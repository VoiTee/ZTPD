--ZAD1
create table DOKUMENTY(
    ID NUMBER(12) PRIMARY KEY,
    DOKUMENT CLOB
)

--ZAD2
declare
tmp CLOB;
begin
    for i in 1..10000
    loop
        tmp:= CONCAT(tmp, 'Oto tekst.');
    end loop;
    insert into dokumenty(id, dokument) values(1, tmp);
end;

--ZAD3
select * from dokumenty;

select upper(dokument) from dokumenty where id = 1;
select length(dokument) from dokumenty where id = 1;

select dbms_lob.getlength(dokument) from dokumenty where id = 1;
select substr(dokument, 5, 1000) from dokumenty where id = 1;
select dbms_lob.substr(dokument, 1000, 5) from dokumenty where id = 1;

--ZAD4
insert into dokumenty(id, dokument) values(2, EMPTY_CLOB());

--ZAD5
insert into dokumenty(id, dokument) values(3, NULL);
commit;

--ZAD6
select * from dokumenty;

select upper(dokument) from dokumenty;
select length(dokument) from dokumenty;

select dbms_lob.getlength(dokument) from dokumenty;
select substr(dokument, 5, 1000) from dokumenty;
select dbms_lob.substr(dokument, 1000, 5) from dokumenty;

--ZAD7
select * from all_directories;

--ZAD8
DECLARE
 lobd clob;
 fils BFILE := BFILENAME('ZSBD_DIR','dokument.txt');
 doffset integer := 1;
 soffset integer := 1;
 langctx integer := 0;
 warn integer := null;
BEGIN
 SELECT dokument INTO lobd FROM dokumenty
 WHERE id=2 FOR UPDATE;
 DBMS_LOB.fileopen(fils, DBMS_LOB.file_readonly);
 DBMS_LOB.LOADCLOBFROMFILE(lobd, fils, DBMS_LOB.LOBMAXSIZE,
 doffset, soffset, 0, langctx, warn);
 DBMS_LOB.FILECLOSE(fils);
 COMMIT;
 DBMS_OUTPUT.PUT_LINE('Status operacji: '||warn);
END;

--ZAD9
update dokumenty
set dokument = TO_CLOB(BFILENAME('ZSBD_DIR','dokument.txt'))
where id = 3;

--ZAD10
select * from dokumenty;

--ZAD11
select length(dokument) from dokumenty;

--ZAD12
drop table dokumenty;

--ZAD13
create procedure CLOB_CENSOR (clob_in in out clob, to_replace in varchar2) as 
    temp integer := 0;
    buffer_temp varchar2(100) := '';
begin
    temp := DBMS_LOB.INSTR(clob_in, to_replace);
    buffer_temp := '';
    for counter in 1..length(to_replace)
    loop
        buffer_temp := buffer_temp || '.'; 
    end loop;
    while temp > 0
    loop
        DBMS_LOB.write(clob_in, temp, length(buffer_temp), buffer_temp);
        temp := DBMS_LOB.INSTR(clob_in, buffer_temp);
    end loop;
end CLOB_CENSOR;

--ZAD14
create table copy_biographies
as select *
from ZSBD_TOOLS.BIOGRAPHIES;

declare
lobd clob;
begin
    select bio into lobd from copy_biographies where id = 1 for update;
    CLOB_CENSOR(lobd, 'Cimrman');
end;

--ZAD15
drop table copy_biographies;