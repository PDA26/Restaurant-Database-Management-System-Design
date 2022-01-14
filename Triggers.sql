create or replace trigger delivery_cake_trigger
after insert
on deliveryorder for each row 
declare
    cursor member_cursor is (
        select c.id id
        from member m
        join customer c
        on m.id = c.memberid and to_char(m.birthday, 'MM-DD') = to_char(sysdate, 'MM-DD')
    );

    error_exp exception;
    PRAGMA EXCEPTION_INIT(error_exp, -2291);

begin
    for i in member_cursor loop
        if(i.id = :new.customerid) then
        dbms_output.put_line('Happy Birthday!');
        end if;
    end loop;

    exception
    when error_exp then dbms_output.put_line('No!');

end;
/

create or replace trigger dinein_cake_trigger
after insert
on dineInOrder for each row 
declare
    cursor member_cursor is (
        select c.id id
        from member m
        join customer c
        on m.id = c.memberid and to_char(m.birthday, 'MM-DD') = to_char(sysdate, 'MM-DD')
    );
begin
    for i in member_cursor loop
        if(i.id = :new.customerid) then
        dbms_output.put_line('Happy birthday');
        end if;
    end loop;
end;
/


create or replace trigger dinein_order_trigger
    after insert
    on dineinorder
    for each row 
declare
    --v_tmp number := -1;
begin
    update diningtable
    set status = 'occupied'
    where id = :new.tableid;
end;
/


create or replace trigger inventory_status_trigger
       before update
       on inventory
       for each row
declare 
    pragma autonomous_transaction;
begin
    if :new.quant = 0 and :old.status = 'In Stock' then
        :new.status := 'Out of Stock';
    elsif :new.quant != 0 and :old.status = 'Out of Stock' then
        :new.status := 'In Stock';
    else
        null;
    end if;
    commit;
end;
/


create or replace trigger orderfood_inventory_trigger
       before insert or update
       on foodlist
       for each row
declare 
    out_of_stock exception;
    cursor recipe_cursor is (
        select d.quantity recipe_quant, i.quant inventory_quant, i.id inventory_id
        from (
            select *
            from dishrecipe
            where dishid = :new.dishid
        ) d
        join inventory i
        on d.inventoryid = i.id  
    );
begin
    --we care about 'dishid' and 'quantity' in FOODLIST
    for i in recipe_cursor loop
        if i.recipe_quant * :new.quantity > i.inventory_quant then
            raise out_of_stock;
        end if;
    end loop;
    for i in recipe_cursor loop
        if i.recipe_quant * :new.quantity <= i.inventory_quant then
            update inventory
            set quant = quant - i.recipe_quant * :new.quantity
            where id = i.inventory_id; 
        end if;
    end loop;
exception
  when out_of_stock then
     dbms_output.put_line('due to out of stock, we can fulfill this food');
end;
/


create or replace trigger reservation_trigger
    before insert or update
    on reservation
    for each row 
declare
    pragma autonomous_transaction; 
    cursor reservation_cursor is (
        select customerid c_id, datetimein time_in, datetimeout time_out, tableid t_id, status r_status
        from reservation
    );
    cursor table_cursor is (
        select id
        from diningtable
        where lower(status) = 'occupied'
    );
    error_exp exception;
    PRAGMA EXCEPTION_INIT(error_exp, -2291);

begin
    -- :new.datetimein, :new.datetimeout, :new.tableid
    for i in table_cursor loop
        if i.id = :new.tableid then
        dbms_output.put_line('table is on use');
        rollback;
        end if;
    end loop;
    for j in reservation_cursor loop
        if ((j.time_out > :new.datetimein and j.time_out < :new.datetimeout) or (j.time_in > :new.datetimein and j.time_in < :new.datetimeout)) and j.t_id = :new.tableid then
        dbms_output.put_line('schedule overlap in the timespan of the table');
        rollback;
        end if;
    end loop;
end;
/