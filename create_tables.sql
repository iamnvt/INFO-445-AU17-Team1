/*
Team 1: Parker, Jake, and Brendan
INFO 445 AU17

description: This script will create BookPromotions and its tables.
*/

/******************create database************************/
use master
if exists (select name from sysdatabases where name='g1_BookPromotionsDB')
	drop database g1_BookPromotionsDB
go
create database g1_BookPromotionsDB
go

USE g1_BookPromotionsDB
GO

/******************Editions table**********************/
create table Editions (
	EditionID int
		primary key
		identity(1,1)
		not null,
	EditionName nvarchar(100)
		not null,
	EditionDescription nvarchar(500)
)
/******************Formats table***********************/
create table Formats (
	FormatID int
		primary key
		identity(1,1)
		not null,
	FormatName nvarchar(100)
		not null,
	FormatDescription nvarchar(500)
)
/******************Books table*************************/
create table Books (
	BookID int
		primary key
		identity(1,1)
		not null,
	BookTitle nvarchar(100)
		not null,
	BookDescription nvarchar(500)
)
/******************ReleaseDays table*******************/
create table ReleaseDays (
	ReleaseDayID int
		primary key
		identity(1,1)
		not null,
	ReleaseDayDate date
		not null,
	ReleaseDayBookID int
		not null
		foreign key
			references Books(BookID),
	ReleaseDayEditionID int
		not null
		foreign key
			references Editions(EditionID),
	ReleaseDayFormatID int
		not null
		foreign key
			references  Formats(FormatID)
)
/******************Series table************************/
create table Series (
	SeriesID int
		primary key
		identity(1,1)
		not null,
	SeriesName nvarchar(100)
		not null,
	SeriesDescription nvarchar(500)
)
/******************BooksSeries table******************/
create table BooksSeries (
	BooksSeriesID int
		primary key
		identity(1,1)
		not null,
	BookID int
		foreign key
			references Books(Bookid)
		not null,
	SeriesID int
		foreign key
			references Series(SeriesID)
		not null
)
/******************Authors table***********************/
create table Authors (
	AuthorID int
		primary key
		identity(1,1)
		not null,
	AuthorFirstName nvarchar(100)
		not null,
	AuthorLastName nvarchar(100)
		not null,
	AuthorDOB date
)
/******************BooksAuthors table******************/
create table BooksAuthors (
	BooksAuthorID int
		primary key
		identity(1,1)
		not null,
	BookID int
		foreign key
			references Books(BookID)
		not null,
	AuthorID int
		foreign key
			references Authors(AuthorID)
		not null
)
/******************Genres table************************/
create table Genres (
	GenreID int
		primary key
		identity(1,1)
		not null,
	GenreName nvarchar(100)
		not null,
	GenreDescription nvarchar(500)
)
/******************GenresBooks table*******************/
create table GenresBooks (
	GenreBookID int
		primary key
		identity(1,1)
		not null,
	GenreID int
		foreign key
			references Genres(GenreID)
		not null,
	BookID int
		foreign key
			references Books(BookID)
		not null
)

CREATE TABLE States (
	StateID int IDENTITY(1,1) NOT NULL,
	StateAbbreviation varchar(5) NOT NULL,
	StateName varchar(100) NOT NULL

	CONSTRAINT pk_States PRIMARY KEY (StateID)
	);

CREATE TABLE Cities (
	CityID int IDENTITY(1,1) NOT NULL,
	CityName varchar(100) NOT NULL,
	StateID int NOT NULL

	CONSTRAINT pk_Cities PRIMARY KEY (CityID),
	CONSTRAINT fk_Cities_States FOREIGN KEY (StateID) REFERENCES States (StateID)
	);

CREATE TABLE Retailers (
	RetailerID int IDENTITY(1,1) NOT NULL,
	RetailerName varchar(100) NOT NULL,
	RetailerDesc varchar(250) NOT NULL

	CONSTRAINT pk_Retailers PRIMARY KEY (RetailerID)
	);

CREATE TABLE Locations (
	LocationID int IDENTITY(1,1) NOT NULL,
	LocationName varchar(100) NOT NULL,
	StreetAddress varchar(100) NOT NULL,
	CityID int NOT NULL,
	ZipCode varchar(10) NOT NULL,
	RetailerID int NOT NULL

	CONSTRAINT pk_Locations PRIMARY KEY (LocationID),
	CONSTRAINT fk_Locations_Cities FOREIGN KEY (CityID) REFERENCES Cities (CityID),
	CONSTRAINT fk_Locations_Retailers FOREIGN KEY (RetailerID) REFERENCES Retailers (RetailerID)
	);

CREATE TABLE BookLocation (
	BookLocationID int IDENTITY(1,1) NOT NULL,
	BookID int NOT NULL,
	LocationID int NOT NULL

	CONSTRAINT pk_BookLocation PRIMARY KEY (BookLocationID),
	CONSTRAINT fk_BookLocation_Books FOREIGN KEY (BookID) REFERENCES Books (BookID),
	CONSTRAINT fk_BookLocation_Location FOREIGN KEY (LocationID) REFERENCES Locations (LocationID)
	);

CREATE TABLE DailySalesData (
	DailySalesID int IDENTITY(1,1) NOT NULL,
	BookLocationID int NOT NULL,
	UnitsSold int NOT NULL,
	DollarsSold money NOT NULL,
	UtcDate date NOT NULL

	CONSTRAINT pk_DailySalesData PRIMARY KEY (DailySalesID),
	CONSTRAINT fk_DailySalesData_BookLocation FOREIGN KEY (BookLocationID) REFERENCES BookLocation (BookLocationID)
	);

CREATE TABLE Promos (
	PromoID int IDENTITY(1,1) NOT NULL,
	PromoName varchar(150) NOT NULL,
	PromoBudget money NOT NULL,
	PromoDesc varchar(250) NOT NULL,
	PromoStartDate date NOT NULL,
	PromoEndDate date NOT NULL

	CONSTRAINT pk_Promos PRIMARY KEY (PromoID)
	);

CREATE TABLE BookPromos (
	BookPromoID int IDENTITY(1,1) NOT NULL,
	BookID int NOT NULL,
	PromoID int NOT NULL

	CONSTRAINT pk_BookPromos PRIMARY KEY (BookPromoID),
	CONSTRAINT fk_BookPromos_Books FOREIGN KEY (BookID) REFERENCES Books (BookID),
	CONSTRAINT fk_BookPromos_Promos FOREIGN KEY (PromoID) REFERENCES Promos (PromoID)
	);

CREATE TABLE Expense (
	ExpenseID int IDENTITY(1,1) NOT NULL,
	ExpenseName varchar(100) NOT NULL,
	ExpenseDesc varchar(250) NOT NULL,
	BookPromoID int  NOT NULL

	CONSTRAINT pk_Expense PRIMARY KEY (ExpenseID),
	CONSTRAINT fk_Expense_BookPromo FOREIGN KEY (BookPromoID) REFERENCES BookPromos (BookPromoID)
	);

CREATE TABLE Categories (
	CategoryID int IDENTITY(1,1) NOT NULL,
	CategoryName varchar(100) NOT NULL,
	CategoryDesc varchar(250) NOT NULL

	CONSTRAINT pk_CategoryID PRIMARY KEY (CategoryID)
	);

CREATE TABLE PromoCategories (
	PromoCategoryID int IDENTITY(1,1) NOT NULL,
	PromoID int NOT NULL,
	CategoryID int NOT NULL

	CONSTRAINT pk_PromoCategories PRIMARY KEY (PromoCategoryID),
	CONSTRAINT fk_PromoCategories_Promo FOREIGN KEY (PromoID) REFERENCES Promos (PromoID),
	CONSTRAINT fk_PromoCategories_Categories FOREIGN KEY (CategoryID) REFERENCES Categories (CategoryID)
	);

