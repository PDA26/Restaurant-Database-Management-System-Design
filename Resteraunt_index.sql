SET SERVEROUTPUT ON;
declare
already_exists exception;
pragma exception_init (already_exists ,-955);
begin
execute immediate 'Create unique index menu_idx on Menu(name)';
dbms_output.put_line('Created index menu_idx');

execute immediate 'Create unique index phnum_idx on customer(phoneNum)';
dbms_output.put_line('Created index phnum_idx');

exception
when already_exists then
dbms_output.put_line('Index menu_idx already present');
null;
end;