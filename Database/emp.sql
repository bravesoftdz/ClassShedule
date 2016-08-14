CREATE DATABASE 'EMP.FDB' user 'SYSDBA' password 'masterkey' DEFAULT CHARACTER SET WIN1251; 

 -- �������� ������

 -- ���� �������
CREATE TABLE EducActivities
(
	EducID   INTEGER PRIMARY KEY,
	EducName VARCHAR (100) NOT NULL UNIQUE
);

 -- ��������������
CREATE TABLE Administrators
(
	AdminID       INTEGER PRIMARY KEY,
	AdminInitials VARCHAR (100) NOT NULL
);

 -- �������������
CREATE TABLE Teachers
( 
	TeacherID       INTEGER PRIMARY KEY,
	TeacherInitials VARCHAR (100) NOT NULL
);

 -- ������
CREATE TABLE Groups
(
	GroupID     INTEGER PRIMARY KEY,
	GroupNumber VARCHAR (100) NOT NULL UNIQUE,
	GroupName   VARCHAR (100) NOT NULL 
);

 -- ��������
CREATE TABLE Students
(
	StudentID       INTEGER PRIMARY KEY,
	StydentInitials VARCHAR (100) NOT NULL,
	GroupID         INTEGER NOT NULL,
	FOREIGN KEY (GroupID) REFERENCES Groups(GroupID)
);

 -- ��������
CREATE TABLE Items
(
	ItemID   INTEGER PRIMARY KEY,
	ItemName VARCHAR (100) NOT NULL UNIQUE 
);

 -- ���������
CREATE TABLE Audiences
(
	AudienceID     INTEGER PRIMARY KEY,
	AudienceNumber VARCHAR (100) NOT NULL UNIQUE 
);

 -- ��������������/������
CREATE TABLE Administrators_Groups
(
	AdminID INTEGER,
	GroupID INTEGER,
	FOREIGN KEY (AdminID) REFERENCES Administrators(AdminID),
	FOREIGN KEY (GroupID) REFERENCES Groups(GroupID),
	UNIQUE (AdminID, GroupID)
);

 -- �������
CREATE TABLE Pairs
(
	PairID     INTEGER PRIMARY KEY,
	PairBegin  VARCHAR (100) NOT NULL UNIQUE,
	PairEnd    VARCHAR (100) NOT NULL UNIQUE,
	PairNumber INTEGER NOT NULL UNIQUE 
);

 -- ��� ������
CREATE TABLE WeekDays
(
	WeekDayID     INTEGER PRIMARY KEY,
	WeekDayName   VARCHAR (100) NOT NULL UNIQUE, 
	WeekDayNumber INTEGER NOT NULL UNIQUE 
);

 -- ����������
CREATE TABLE Schedules
(
	GroupID    INTEGER NOT NULL,
	WeekDayID  INTEGER NOT NULL,
	PairID     INTEGER NOT NULL,
	ItemID     INTEGER NOT NULL,
	EducID     INTEGER NOT NULL,
	TeacherID  INTEGER NOT NULL,
	AudienceID INTEGER NOT NULL,
	Error_GWP  INTEGER DEFAULT 0 NOT NULL,
	Error_TWP  INTEGER DEFAULT 0 NOT NULL,
	FOREIGN KEY (GroupID)    REFERENCES Groups(GroupID),
	FOREIGN KEY (WeekDayID)  REFERENCES WeekDays(WeekDayID),
	FOREIGN KEY (PairID)     REFERENCES Pairs(PairID),
	FOREIGN KEY (ItemID)     REFERENCES Items(ItemID),
	FOREIGN KEY (EducID)     REFERENCES EducActivities(EducID),
	FOREIGN KEY (TeacherID)  REFERENCES Teachers(TeacherID),
	FOREIGN KEY (AudienceID) REFERENCES Audiences(AudienceID),
	UNIQUE (GroupID, WeekDayID, PairID, ItemID, EducID, TeacherID, AudienceID)
);

 -- �������� ���������, �����������

 -- ���� �������
CREATE GENERATOR G_EducID;
SET GENERATOR G_EducID TO 8;

SET TERM ^ ;
CREATE TRIGGER T_EducID FOR EducActivities
BEFORE INSERT
AS
BEGIN
	IF ((NEW.EducID IS NULL) OR (NEW.EducID = 0))
	THEN NEW.EducID  = GEN_ID(G_EducID, 1);
END^ 
SET TERM ; ^

 -- ��������������
CREATE GENERATOR G_AdminID;
SET GENERATOR G_AdminID TO 12;

SET TERM ^ ;
CREATE TRIGGER T_AdminID FOR Administrators
BEFORE INSERT
AS
BEGIN
	IF ((NEW.AdminID IS NULL) OR (NEW.AdminID = 0))
	THEN NEW.AdminID  = GEN_ID(G_AdminID, 1);
END^ 
SET TERM ; ^

 -- �������������
CREATE GENERATOR G_TeacherID;
SET GENERATOR G_TeacherID TO 11;

SET TERM ^ ;
CREATE TRIGGER T_TeacherID FOR Teachers
BEFORE INSERT
AS
BEGIN
	IF ((NEW.TeacherID IS NULL) OR (NEW.TeacherID = 0))
	THEN NEW.TeacherID  = GEN_ID(G_TeacherID, 1);
END^ 
SET TERM ; ^

 -- ������
CREATE GENERATOR G_GroupID;
SET GENERATOR G_GroupID TO 6;

SET TERM ^ ;
CREATE TRIGGER T_GroupID FOR Groups
BEFORE INSERT
AS
BEGIN
	IF ((NEW.GroupID IS NULL) OR (NEW.GroupID = 0))
	THEN NEW.GroupID  = GEN_ID(G_GroupID, 1);
END^ 
SET TERM ; ^

 -- ��������
CREATE GENERATOR G_StudentID;
SET GENERATOR G_StudentID TO 32;

SET TERM ^ ;
CREATE TRIGGER T_StudentID FOR Students
BEFORE INSERT
AS
BEGIN
	IF ((NEW.StudentID IS NULL) OR (NEW.StudentID = 0))
	THEN NEW.StudentID  = GEN_ID(G_StudentID, 1);
END^ 
SET TERM ; ^

 -- ��������
CREATE GENERATOR G_ItemID;
SET GENERATOR G_ItemID TO 8;

SET TERM ^ ;
CREATE TRIGGER T_ItemID FOR Items
BEFORE INSERT
AS
BEGIN
	IF ((NEW.ItemID IS NULL) OR (NEW.ItemID = 0))
	THEN NEW.ItemID  = GEN_ID(G_ItemID, 1);
END^ 
SET TERM ; ^

 -- ���������
CREATE GENERATOR G_AudienceID;
SET GENERATOR G_AudienceID TO 12;

SET TERM ^ ;
CREATE TRIGGER T_AudienceID FOR Audiences
BEFORE INSERT
AS
BEGIN
	IF ((NEW.AudienceID IS NULL) OR (NEW.AudienceID = 0))
	THEN NEW.AudienceID  = GEN_ID(G_AudienceID, 1);
END^ 
SET TERM ; ^

 -- �������
CREATE GENERATOR G_PairID;
SET GENERATOR G_PairID TO 6;

SET TERM ^ ;
CREATE TRIGGER T_PairID FOR Pairs
BEFORE INSERT
AS
BEGIN
	IF ((NEW.PairID IS NULL) OR (NEW.PairID = 0))
	THEN NEW.PairID  = GEN_ID(G_PairID, 1);
END^ 
SET TERM ; ^

 -- ��� ������
CREATE GENERATOR G_WeekDayID;
SET GENERATOR G_WeekDayID TO 7;

SET TERM ^ ;
CREATE TRIGGER T_WeekDayID FOR WeekDays
BEFORE INSERT
AS
BEGIN
	IF ((NEW.WeekDayID IS NULL) OR (NEW.WeekDayID = 0))
	THEN NEW.WeekDayID  = GEN_ID(G_WeekDayID, 1);
END^ 
SET TERM ; ^

 -- ������������� ������ ������

CREATE GENERATOR G_Error_GWP;
SET GENERATOR G_Error_GWP TO 0;

CREATE GENERATOR G_Error_TWP;
SET GENERATOR G_Error_TWP TO 0;

 -- ��������� ������

 -- ������ �� ����� ���� �� ���������� �������� ������������
SET TERM ^ ;
CREATE TRIGGER T_Schedules_Error_GWP FOR Schedules
AFTER INSERT OR UPDATE OR DELETE
AS
DECLARE ID_NEW INTEGER;
BEGIN
	IF ((
		SELECT COUNT(*)
		FROM SCHEDULES
		WHERE NEW.GROUPID = SCHEDULES.GROUPID
			AND NEW.WEEKDAYID = SCHEDULES.WEEKDAYID
			AND NEW.PAIRID = SCHEDULES.PAIRID
		) = 1)
	THEN 
		UPDATE SCHEDULES
		SET SCHEDULES.ERROR_GWP = 0
		WHERE NEW.GROUPID = SCHEDULES.GROUPID
			AND NEW.WEEKDAYID = SCHEDULES.WEEKDAYID
			AND NEW.PAIRID = SCHEDULES.PAIRID
			AND NEW.ITEMID = SCHEDULES.ITEMID
			AND NEW.EDUCID = SCHEDULES.EDUCID
			AND NEW.TEACHERID = SCHEDULES.TEACHERID
			AND NEW.AUDIENCEID = SCHEDULES.AUDIENCEID
			AND NEW.ERROR_GWP = SCHEDULES.ERROR_GWP
			AND SCHEDULES.ERROR_GWP > 0; 
	
	IF ((
		SELECT COUNT(*)
		FROM SCHEDULES
		WHERE OLD.GROUPID = SCHEDULES.GROUPID
			AND OLD.WEEKDAYID = SCHEDULES.WEEKDAYID
			AND OLD.PAIRID = SCHEDULES.PAIRID
		) = 1)      
	THEN 
		UPDATE SCHEDULES
		SET SCHEDULES.ERROR_GWP = 0                       
		WHERE OLD.GROUPID = SCHEDULES.GROUPID
			AND OLD.WEEKDAYID = SCHEDULES.WEEKDAYID
			AND OLD.PAIRID = SCHEDULES.PAIRID
			AND SCHEDULES.ERROR_GWP > 0; 
	
	ID_NEW = (SELECT SCHEDULES.ERROR_GWP
		FROM SCHEDULES
		WHERE NEW.GROUPID = SCHEDULES.GROUPID
			AND NEW.WEEKDAYID = SCHEDULES.WEEKDAYID
			AND NEW.PAIRID = SCHEDULES.PAIRID
		ORDER BY SCHEDULES.ERROR_GWP DESC
		ROWS 1); 
	
	IF ((
		SELECT COUNT(*)
		FROM SCHEDULES
		WHERE NEW.GROUPID = SCHEDULES.GROUPID
			AND NEW.WEEKDAYID = SCHEDULES.WEEKDAYID
			AND NEW.PAIRID = SCHEDULES.PAIRID
	) > 1)
	THEN  
		IF ((ID_NEW = 0) 
			OR (NEW.ERROR_GWP = OLD.ERROR_GWP) AND (NEW.ERROR_TWP = OLD.ERROR_TWP))   
		THEN 
			ID_NEW = GEN_ID(G_ERROR_GWP, 1); 
			
		UPDATE SCHEDULES 
		SET SCHEDULES.ERROR_GWP = :ID_NEW
		WHERE NEW.GROUPID = SCHEDULES.GROUPID
			AND NEW.WEEKDAYID = SCHEDULES.WEEKDAYID
			AND NEW.PAIRID = SCHEDULES.PAIRID
			AND SCHEDULES.ERROR_GWP <> :ID_NEW;
END^
SET TERM ; ^

 -- ������������� �� ����� ���� �� ���������� �������� ������������
SET TERM ^ ;
CREATE TRIGGER T_Schedules_Error_TWP FOR Schedules
AFTER INSERT OR UPDATE OR DELETE
AS
DECLARE ID_NEW INTEGER;
BEGIN
	IF ((
		SELECT COUNT(*)
		FROM SCHEDULES
		WHERE NEW.TEACHERID = SCHEDULES.TEACHERID
			AND NEW.WEEKDAYID = SCHEDULES.WEEKDAYID
			AND NEW.PAIRID = SCHEDULES.PAIRID
		) = 1)
	THEN 
		UPDATE SCHEDULES
		SET SCHEDULES.ERROR_TWP = 0
		WHERE NEW.GROUPID = SCHEDULES.GROUPID
			AND NEW.WEEKDAYID = SCHEDULES.WEEKDAYID
			AND NEW.PAIRID = SCHEDULES.PAIRID
			AND NEW.ITEMID = SCHEDULES.ITEMID
			AND NEW.EDUCID = SCHEDULES.EDUCID
			AND NEW.TEACHERID = SCHEDULES.TEACHERID
			AND NEW.AUDIENCEID = SCHEDULES.AUDIENCEID
			AND NEW.ERROR_TWP = SCHEDULES.ERROR_TWP
			AND SCHEDULES.ERROR_TWP > 0; 

	IF ((
		SELECT COUNT(*)
		FROM SCHEDULES
		WHERE OLD.TEACHERID = SCHEDULES.TEACHERID
			AND OLD.WEEKDAYID = SCHEDULES.WEEKDAYID
			AND OLD.PAIRID = SCHEDULES.PAIRID
		) = 1)      
	THEN 
		UPDATE SCHEDULES
		SET SCHEDULES.ERROR_TWP = 0                       
		WHERE OLD.TEACHERID = SCHEDULES.TEACHERID
			AND OLD.WEEKDAYID = SCHEDULES.WEEKDAYID
			AND OLD.PAIRID = SCHEDULES.PAIRID
			AND SCHEDULES.ERROR_TWP > 0; 

	ID_NEW = (SELECT SCHEDULES.ERROR_TWP
		FROM SCHEDULES
		WHERE NEW.TEACHERID = SCHEDULES.TEACHERID  
			AND NEW.WEEKDAYID = SCHEDULES.WEEKDAYID
			AND NEW.PAIRID = SCHEDULES.PAIRID
		ORDER BY SCHEDULES.ERROR_TWP DESC
		ROWS 1); 

	IF ((
		SELECT COUNT(*)
		FROM SCHEDULES
		WHERE NEW.TEACHERID = SCHEDULES.TEACHERID
			AND NEW.WEEKDAYID = SCHEDULES.WEEKDAYID
			AND NEW.PAIRID = SCHEDULES.PAIRID
		) > 1)
	THEN  
		IF ((ID_NEW = 0) 
			OR (NEW.ERROR_TWP = OLD.ERROR_TWP) AND (NEW.ERROR_GWP = OLD.ERROR_GWP))   
		THEN 
			ID_NEW = GEN_ID(G_ERROR_TWP, 1); 

		UPDATE SCHEDULES 
		SET SCHEDULES.ERROR_TWP = :ID_NEW
		WHERE NEW.TEACHERID = SCHEDULES.TEACHERID
			AND NEW.WEEKDAYID = SCHEDULES.WEEKDAYID
			AND NEW.PAIRID = SCHEDULES.PAIRID
			AND SCHEDULES.ERROR_TWP <> :ID_NEW;             
END^
SET TERM ; ^

 -- �������������� �������(�������������)

CREATE VIEW GroupCount (GROUPNUMBER, GROUPNAME, COUNTSTD, COUNTADM, COUNTPAIR)
AS 
SELECT GROUPS.GROUPNUMBER AS "GROUPNUMBER",
	GROUPS.GROUPNAME AS "GROUPNAME",
	COUNT(*) AS "COUNTSTD",

	(
		SELECT COUNT(*) AS "COUNTADM"
		FROM ADMINISTRATORS_GROUPS
		WHERE ADMINISTRATORS_GROUPS.GROUPID = GROUPS.GROUPID
		GROUP BY ADMINISTRATORS_GROUPS.GROUPID
	),

	(
		SELECT COUNT(*) AS "COUNTPAIR"
		FROM SCHEDULES 
		WHERE SCHEDULES.GROUPID = GROUPS.GROUPID
		GROUP BY SCHEDULES.GROUPID
	)

FROM GROUPS INNER JOIN STUDENTS ON GROUPS.GROUPID = STUDENTS.GROUPID
GROUP BY GROUPS.GROUPID, GROUPS.GROUPNUMBER, GROUPS.GROUPNAME;

CREATE VIEW TeacherCount (TEACHERINITIALS, COUNTPAIR)
AS
SELECT TEACHERS.TEACHERINITIALS AS "TEACHERINITIALS", 
COUNT(*) AS "COUNTPAIR"

FROM TEACHERS INNER JOIN SCHEDULES ON TEACHERS.TEACHERID = SCHEDULES.TEACHERID
GROUP BY TEACHERS.TEACHERID, TEACHERS.TEACHERINITIALS;

 -- ���������� ������� ����������

INSERT INTO EducActivities VALUES (1, '������');
INSERT INTO EducActivities VALUES (2, '��������');
INSERT INTO EducActivities VALUES (3, '������������');
INSERT INTO EducActivities VALUES (4, '������������');
INSERT INTO EducActivities VALUES (5, '�������');
INSERT INTO EducActivities VALUES (6, '�����������');
INSERT INTO EducActivities VALUES (7, '���������');
INSERT INTO EducActivities VALUES (8, '����');

INSERT INTO Administrators VALUES (1,  '������� ������� ����������');
INSERT INTO Administrators VALUES (2,  '��������� ������� �������������');
INSERT INTO Administrators VALUES (3,  '�������� ������� ����������');
INSERT INTO Administrators VALUES (4,  '�������� ������� ������������');
INSERT INTO Administrators VALUES (5,  '��������� ������� ������������');
INSERT INTO Administrators VALUES (6,  '������ ����� �����������');
INSERT INTO Administrators VALUES (7,  '������ ������ ��������');
INSERT INTO Administrators VALUES (8,  '������� ������� ����������');
INSERT INTO Administrators VALUES (9,  '������� ������ ���������');
INSERT INTO Administrators VALUES (10, '������� ��������� ����������');
INSERT INTO Administrators VALUES (11, '�������� ����� ��������');
INSERT INTO Administrators VALUES (12, '��������  ��������� ����������');

INSERT INTO Teachers VALUES (1,  '������ ��������� ���������');
INSERT INTO Teachers VALUES (2,  '������� ����� ����������');
INSERT INTO Teachers VALUES (3,  '��������� ���� �������������');
INSERT INTO Teachers VALUES (4,  '���������� �������� ����������');
INSERT INTO Teachers VALUES (5,  '������ ����� ���������');
INSERT INTO Teachers VALUES (6,  '��� �������� ��������������');
INSERT INTO Teachers VALUES (7,  '��� ��������� ������������');
INSERT INTO Teachers VALUES (8,  '������ ���� ���������');
INSERT INTO Teachers VALUES (9,  '������� ����� ����������');
INSERT INTO Teachers VALUES (10, '���������� ������� ��������');
INSERT INTO Teachers VALUES (11, '���� �������� �������');

INSERT INTO Groups VALUES (1, '�8103a', '���������� ���������� � �����������');
INSERT INTO Groups VALUES (2, '�8103�', '���������� ���������� � �����������');
INSERT INTO Groups VALUES (3, '�8102',  '���������� � ������������ �����');
INSERT INTO Groups VALUES (4, '�8104',  '���.����������� � ����������������� �������������� ������');
INSERT INTO Groups VALUES (5, '�8119�', '���������� �����������');
INSERT INTO Groups VALUES (6, '�8142',  '���������, ������� "���.���.� ���������"');

INSERT INTO Students VALUES (1,  '�������� ������ ���������', 1);
INSERT INTO Students VALUES (2,  '������ ��������� �����������', 1);
INSERT INTO Students VALUES (3,  '��������� ��������� ������������', 1);
INSERT INTO Students VALUES (4,  '�������� ������� �����������', 1);
INSERT INTO Students VALUES (5,  '������� ������ �����������', 1);
INSERT INTO Students VALUES (6,  '������ ��� �����������', 1);
INSERT INTO Students VALUES (7,  '������� ����� �����������', 1);
INSERT INTO Students VALUES (8,  '������� ������� ���������', 1);
INSERT INTO Students VALUES (9,  '������ ������� ���������', 1);
INSERT INTO Students VALUES (10, '�������� ���� ����������', 1);
INSERT INTO Students VALUES (11, '������ ���� ����������', 1);
INSERT INTO Students VALUES (12, '�������� �������� ����������', 1);
INSERT INTO Students VALUES (13, '������ ���� ��������', 1);
INSERT INTO Students VALUES (14, '������������ ����� ������������', 1);
INSERT INTO Students VALUES (15, '������ ������� �������������', 1);
INSERT INTO Students VALUES (16, '��������� ������ ��������', 1);
INSERT INTO Students VALUES (17, '������� ��������� ������������', 1);
INSERT INTO Students VALUES (18, '�������� ���� ��������', 1);
INSERT INTO Students VALUES (19, '�������� ������� ����������', 1);
INSERT INTO Students VALUES (20, '������ ������ ��������', 1);
INSERT INTO Students VALUES (21, '��������� ������� ���������', 1);
INSERT INTO Students VALUES (22, '������� ��������� ���������', 1);
INSERT INTO Students VALUES (23, '��������� ��������� ����������', 1);
INSERT INTO Students VALUES (24, '�������� ����� ����������', 1);
INSERT INTO Students VALUES (25, '������� �������� ���������', 1);
INSERT INTO Students VALUES (26, '������� ������ �����������', 1);
INSERT INTO Students VALUES (27, '�������� ������� ����������', 1);
INSERT INTO Students VALUES (28, '�������� ����� ������������', 1);
INSERT INTO Students VALUES (29, '������ ������ ��������', 1);
INSERT INTO Students VALUES (30, '����� ���� �������������', 1);
INSERT INTO Students VALUES (31, '������ ����� ����������', 1);
INSERT INTO Students VALUES (32, '����� ����� ����������', 1);

INSERT INTO Items VALUES (1, '�������������� ������');
INSERT INTO Items VALUES (2, '������� � ���������');
INSERT INTO Items VALUES (3, '��������� �� ���');
INSERT INTO Items VALUES (4, '���������� ��������');
INSERT INTO Items VALUES (5, '����������� ����');
INSERT INTO Items VALUES (6, '���� ������');
INSERT INTO Items VALUES (7, '���������� ����������');
INSERT INTO Items VALUES (8, '����� � ������ ����������������');

INSERT INTO Audiences VALUES (1,  '327');
INSERT INTO Audiences VALUES (2,  '233');
INSERT INTO Audiences VALUES (3,  '209�');
INSERT INTO Audiences VALUES (4,  '218�');
INSERT INTO Audiences VALUES (5,  '356');
INSERT INTO Audiences VALUES (6,  '329');
INSERT INTO Audiences VALUES (7,  '332');
INSERT INTO Audiences VALUES (8,  '319');
INSERT INTO Audiences VALUES (9,  '216�');
INSERT INTO Audiences VALUES (10, '435');
INSERT INTO Audiences VALUES (11, '208');
INSERT INTO Audiences VALUES (12, '������������� ���');

INSERT INTO Administrators_Groups VALUES (1, 1);
INSERT INTO Administrators_Groups VALUES (1, 2);
INSERT INTO Administrators_Groups VALUES (1, 3);
INSERT INTO Administrators_Groups VALUES (2, 4);
INSERT INTO Administrators_Groups VALUES (2, 5);
INSERT INTO Administrators_Groups VALUES (2, 6);

INSERT INTO Pairs VALUES (1, '8.30',  '10.10', 1);
INSERT INTO Pairs VALUES (2, '10.10', '11.40', 2);
INSERT INTO Pairs VALUES (3, '11.50', '13.20', 3);
INSERT INTO Pairs VALUES (4, '13.30', '15.00', 4);
INSERT INTO Pairs VALUES (5, '15.10', '16.40', 5);
INSERT INTO Pairs VALUES (6, '16.50', '18.20', 6);

INSERT INTO WeekDays VALUES (1, '�����������', 1);
INSERT INTO WeekDays VALUES (2, '�������', 2);
INSERT INTO WeekDays VALUES (3, '�����', 3);
INSERT INTO WeekDays VALUES (4, '�������', 4);
INSERT INTO WeekDays VALUES (5, '�������', 5);
INSERT INTO WeekDays VALUES (6, '�������', 6);
INSERT INTO WeekDays VALUES (7, '�����������', 7);

INSERT INTO Schedules VALUES (1, 1, 1, 1, 1, 3, 1, 0, 0);
INSERT INTO Schedules VALUES (1, 1, 2, 2, 1, 6, 2, 0, 0);
INSERT INTO Schedules VALUES (1, 1, 3, 8, 2, 2, 3, 0, 0);
INSERT INTO Schedules VALUES (1, 1, 4, 8, 2, 2, 3, 0, 0);

INSERT INTO Schedules VALUES (1, 2, 2, 2, 2, 6, 6, 0, 0);
INSERT INTO Schedules VALUES (1, 2, 4, 4, 8, 7, 12, 0, 0);

INSERT INTO Schedules VALUES (1, 3, 1, 1, 1, 3, 1, 0, 0);
INSERT INTO Schedules VALUES (1, 3, 3, 5, 2, 4, 2, 0, 0);
INSERT INTO Schedules VALUES (1, 3, 4, 1, 2, 8, 1, 0, 0);

INSERT INTO Schedules VALUES (1, 4, 3, 7, 2, 6, 8, 0, 0);
INSERT INTO Schedules VALUES (1, 4, 4, 7, 1, 6, 1, 0, 0);

INSERT INTO Schedules VALUES (1, 5, 1, 8, 2, 2, 7, 0, 0);
INSERT INTO Schedules VALUES (1, 5, 2, 8, 1, 2, 10, 0, 0);
INSERT INTO Schedules VALUES (1, 5, 4, 4, 8, 7, 12, 0, 0);

INSERT INTO Schedules VALUES (1, 6, 1, 6, 1, 1, 10, 0, 0);
INSERT INTO Schedules VALUES (1, 6, 2, 1, 2, 8, 6, 0, 0);
INSERT INTO Schedules VALUES (1, 6, 3, 6, 2, 1, 7, 0, 0);