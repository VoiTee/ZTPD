-- ZAD1
create table MOVIES(
    ID NUMBER(12) PRIMARY KEY,
    TITLE VARCHAR2(400) NOT NULL,
    CATEGORY VARCHAR2(50),
    YEAR CHAR(4),
    CAST VARCHAR2(4000),
    DIRECTOR VARCHAR2(4000),
    STORY VARCHAR2(4000),
    PRICE NUMBER(5,2),
    COVER BLOB,
    MIME_TYPE VARCHAR2(50)
)


-- ZAD2
insert into MOVIES (id, title, category, year, cast, director,
    story, price, cover, mime_type)
    select d.id, d.title, d.category, trim(to_char(d.year, '9999')), d.cast, d.director, d.story,
    d.price, c.image, c.mime_type
    from descriptions d full outer join covers c on d.id = c.movie_id;

-- ZAD3
select id, title from MOVIES
where cover is null;

-- ZAD4
select id, title, DBMS_LOB.GETLENGTH(cover) as filesize from MOVIES
where cover is not null;

-- ZAD5
select id, title, DBMS_LOB.GETLENGTH(cover) as filesize from MOVIES
where cover is null;

-- ZAD6
select directory_name, directory_path from all_directories;

-- ZAD7
update MOVIES
set cover = EMPTY_BLOB(), mime_type = 'image/jpeg'
where id = 66;
commit;

-- ZAD8
select id, title, DBMS_LOB.GETLENGTH(cover) as filesize from MOVIES
where id in (65, 66);

-- ZAD9
DECLARE
 lobd blob;
 fils BFILE := BFILENAME('ZSBD_DIR','escape.jpg');
BEGIN
 SELECT cover INTO lobd
 FROM MOVIES
 where id=66
 FOR UPDATE;
 DBMS_LOB.fileopen(fils, DBMS_LOB.file_readonly);
 DBMS_LOB.LOADFROMFILE(lobd,fils,DBMS_LOB.GETLENGTH(fils));
 DBMS_LOB.FILECLOSE(fils);
 COMMIT;
END;

-- ZAD10
create table temp_covers(
    movie_id NUMBER(12),
    image BFILE,
    mime_type VARCHAR2(50)
);

-- ZAD11
insert into temp_covers values(65, BFILENAME('ZSBD_DIR','eagles.jpg'), 'imapge/jpeg') ;
commit;

-- ZAD12
select movie_id, DBMS_LOB.GETLENGTH(image) as filesize from temp_covers;

-- ZAD13
DECLARE
 lobd blob;
 fils BFILE;
 mimetype VARCHAR2(50);
BEGIN

 SELECT image, mime_type INTO fils, mimetype
 FROM temp_covers
 where movie_id=65;
 https://epoczta.put.poznan.pl/?do=Main
 DBMS_LOB.fileopen(fils, DBMS_LOB.file_readonly);
 dbms_lob.createtemporary(lobd, TRUE);
 DBMS_LOB.LOADFROMFILE(lobd,fils,DBMS_LOB.GETLENGTH(fils));
 
 update MOVIES set cover = lobd, mime_type = mimetype
 where id = 65;
 
 dbms_lob.freetemporary(lobd);
 DBMS_LOB.FILECLOSE(fils);
 COMMIT;
END;

-- ZAD14
select id, DBMS_LOB.GETLENGTH(cover) as filesize from MOVIES
where id in (65, 66);

-- ZAD15
drop table MOVIES;
drop table temp_covers;