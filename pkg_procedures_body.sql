Create or Replace Package Body pkg_procedures IS
-----------------------------------------------------------Procedure customer_signUp---------------------------------------------------------------
procedure customer_signUp(
    c_fName customer.firstname%type, 
    c_lName customer.lastname%type, 
    c_phoneNum customer.phonenum%type, 
    c_address customer.address%type, 
    c_zipcode customer.zipcode%type)
is
    phone_excep exception;
    input_excep exception;
    PRAGMA EXCEPTION_INIT(phone_excep,-00001);
    PRAGMA EXCEPTION_INIT(input_excep,-01722);
begin
    if REGEXP_LIKE(c_fName, '^[[:digit:]]+$') then
        raise input_excep;
    end if;
    if REGEXP_LIKE(c_lName, '^[[:digit:]]+$') then
        raise input_excep;
    end if;
  insert into customer(id, firstname, lastname, phonenum, address, zipcode)
  values (customer_id_seq.nextval, c_fName, c_lName, c_phoneNum, c_address, c_zipcode);
  commit;
exception
  when phone_excep then dbms_output.put_line('phone num already exsits');
  when input_excep then dbms_output.put_line('wrong type of input');
end customer_signUp;

----------------------------------------------------------PROCEDURE customer_update--------------------------------------------------------------
PROCEDURE customer_update (   
    c_id customer.id%type,
    c_fName customer.firstname%type, 
    c_lName customer.lastname%type, 
    c_phoneNum customer.phonenum%type, 
    c_address customer.address%type, 
    c_zipcode customer.zipcode%type)  
IS  
    phone_excep exception;
    input_excep exception;
    type_excep exception;
    PRAGMA EXCEPTION_INIT(phone_excep,-00001);
    PRAGMA EXCEPTION_INIT(input_excep,-01722);
    PRAGMA EXCEPTION_INIT(phone_excep,-06502);
BEGIN 
    if REGEXP_LIKE(c_fName, '^[[:digit:]]+$') then
        raise input_excep;
    end if;
    if REGEXP_LIKE(c_lName, '^[[:digit:]]+$') then
        raise input_excep;
    end if;
    UPDATE CUSTOMER 
    SET firstname = c_fname,
        lastname = c_lname,
        phonenum = c_phonenum,
        address = c_address,
        zipcode = c_zipcode
    WHERE id = c_id;
    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('wrong customer id');
    END IF;
    COMMIT; 
exception
  when phone_excep then dbms_output.put_line('overlap of phone num');
  when input_excep then dbms_output.put_line('wrong type of input');
  when type_excep then dbms_output.put_line('wrong type of input');
END customer_update;

--------------------------------------------------------------PROCEDURE deliveryOrder_setup--------------------------------------------------------
PROCEDURE deliveryOrder_setup(  
    c_id customer.id%type,
    do_zipcode deliveryorder.zipcode%type,
    do_deliverid deliveryorder.deliverid%type,
    do_datetime deliveryorder.datetime%type,
    do_address deliveryorder.address%type,
    do_phonenum deliveryorder.phonenumber%type)  
IS 
    --phone_excep exception;
    input_excep exception;
    --PRAGMA EXCEPTION_INIT(phone_excep,-00001);
    PRAGMA EXCEPTION_INIT(input_excep,-01722);
    v_tmp number := -1;
BEGIN
    begin
    select id into v_tmp from customer where id = c_id;
    exception
        when no_data_found then 
        dbms_output.put_line('wrong input of customer id');
        return;
    end;
    insert into deliveryorder(id, customerid, zipcode, deliverid, datetime, address, phonenumber, orderstatus, deliverystatus)
    values(deliveryorder_id_seq.nextval, c_id, do_zipcode, do_deliverid, do_datetime, do_address, do_phonenum, 'preparing', 'accepted');
    COMMIT;  
exception 
    when no_data_found then DBMS_OUTPUT.PUT_LINE('invalid in input');
    --when phone_excep then dbms_output.put_line('overlap of phone num');
    when input_excep then dbms_output.put_line('wrong type of input');
END deliveryOrder_setup;

----------------------------------------------------------------PROCEDURE dineInOrder_setup--------------------------------------------------------
PROCEDURE dineInOrder_setup(  
    t_id diningtable.id%type,
    c_id customer.id%type,
    do_datetime dineinorder.datetime%type)  
IS  
    v_tmp number := -1;
    v_status varchar2(50);
BEGIN
    begin
    select status into v_status from diningtable where id = t_id;
    if lower(v_status) = 'occupied' then
        dbms_output.put_line('this table is in use');
        return;
    end if;
    exception
        when no_data_found then 
        dbms_output.put_line('wrong input of table id');
        return;
    end;
    begin
    select id into v_tmp from customer where id = c_id;
    exception
        when no_data_found then 
        dbms_output.put_line('wrong input of customer id');
        return;
    end;
    insert into dineinorder(id, tableid, customerid, status, datetime)
    values(dineinorder_id_seq.nextval, t_id, c_id, 'accepted', do_datetime);
    COMMIT;  
exception 
    when no_data_found then DBMS_OUTPUT.PUT_LINE('invalid in input');
END dineInOrder_setup;

---------------------------------------------------------------PROCEDURE member_signup--------------------------------------------------------------
PROCEDURE member_signup (   
    c_id customer.id%type,
    m_discount member.discount%type, 
    m_flavor member.flavor%type, 
    m_birthday member.birthday%type, 
    m_balance member.balance%type, 
    m_expirydatetime member.expirydate%type)  
IS  
    --phone_excep exception;
    input_excep exception;
    --PRAGMA EXCEPTION_INIT(phone_excep,-00001);
    PRAGMA EXCEPTION_INIT(input_excep,-01722);
    v_tmp number := -1;
BEGIN
    begin
    select id into v_tmp from customer where id = c_id;
    exception
        when no_data_found then 
        dbms_output.put_line('wrong input of customer id');
        return;
    end;
    select memberid into v_tmp from customer where id = c_id;
    if v_tmp != -1
    then dbms_output.put_line('this customer is already a memeber!');
    end if;
    insert into member
    values (member_id_seq.nextval, m_discount, m_flavor, m_birthday, m_balance, m_expirydatetime, 'active');
    update customer
    set memberid = member_id_seq.currval
    where id = c_id;
    COMMIT;  
exception
  --when phone_excep then dbms_output.put_line('overlap of phone num');
  when input_excep then dbms_output.put_line('wrong type of input');
END member_signup;

----------------------------------------------------------------PROCEDURE member_updateByMemberId---------------------------------------------------

PROCEDURE member_updateByMemberId(   
    m_id member.id%type,
    m_discount member.discount%type,
    m_flavor member.flavor%type, 
    m_birthday member.birthday%type, 
    m_balance member.balance%type, 
    m_expirydatetime member.expirydate%type)  
IS  
    --type_excep exception;
    input_excep exception;
    --PRAGMA EXCEPTION_INIT(type_excep,-06550);
    PRAGMA EXCEPTION_INIT(input_excep,-01722);
    v_tmp member.id%type := -1;
BEGIN
    select id into v_tmp from member where id = m_id;
    update member
    set
        discount = m_discount,
        flavor = m_flavor,
        birthday = m_birthday,
        balance = m_balance,
        expirydate = m_expirydatetime
    where id = m_id;
    COMMIT;  
exception 
    when no_data_found then DBMS_OUTPUT.PUT_LINE('wrong input of member id');
    when input_excep then dbms_output.put_line('wrong type of input');
    when others then
         dbms_output.put_line('you provided invalid number');
		 
END member_updateByMemberId;

--------------------------------------------------------------------PROCEDURE ORDER_FOOD---------------------------------------------------------

PROCEDURE ORDER_FOOD(  
    order_type varchar2,
    order_id foodlist.dineinorderid%type,
    item_id foodlist.dishid%type,
    item_quant foodlist.quantity%type)  
IS  
BEGIN
    if lower(order_type) = 'dinein' then
    insert into foodlist(dineinorderid, dishid, quantity)
    values(order_id, item_id, item_quant);
    COMMIT;
    elsif lower(order_type) = 'delivery' then 
    insert into foodlist(deliveryorderid, dishid, quantity)
    values(order_id, item_id, item_quant);
    COMMIT;
    else DBMS_OUTPUT.PUT_LINE('invalid input of order type');
    end if;
exception when no_data_found then DBMS_OUTPUT.PUT_LINE('invalid in input');
END ORDER_FOOD;

----------------------------------------------------------------PROCEDURE PAYMENT_SETUP-----------------------------------------------------------

PROCEDURE PAYMENT_SETUP(  
    o_type varchar2,
    o_id foodlist.dineinorderid%type,
    tips_val payment.tipsvalue%type)  
IS
    main_val payment.mainvalue%type := 0;
    v_dinein_att_id diningtable.attendantid%type := -1;
    v_delivery_att_id diningtable.attendantid%type := -1;
    v_tmp dineinorder.paymentid%type := -1;
    cursor c_dinein is (
        select a.quantity as quant, b.price as price
        from (
            select dishid, quantity
            from foodlist
            where dineinorderid = o_id) a
        left join menu b
        on a.dishid = b.id
    );
    cursor c_delivery is (
        select a.quantity as quant, b.price as price
        from (
            select dishid, quantity
            from foodlist
            where deliveryorderid = o_id) a
        left join menu b
        on a.dishid = b.id
    );
BEGIN
    if lower(o_type) = 'dinein' then
    for i in c_dinein loop
        main_val := main_val + i.quant * i.price;
    end loop;
    insert into payment
    values(payment_id_seq.nextval, sysdate, main_val, tips_val);
    update dineinorder
    set
        paymentid = payment_id_seq.currval
    where id = o_id;
    v_tmp := payment_id_seq.currval;
    select c.attendantid
       into v_dinein_att_id
           from(
             select b.attendantid attendantid, a.paymentid
             from dineinorder a
             join 
             diningtable b
             on a.tableid = b.id
             where a.paymentid = v_tmp
           ) c;
    update attendant
         set
            tipscount = tipscount + tips_val
         where id = v_dinein_att_id;
    COMMIT;
    elsif lower(o_type) = 'delivery' then 
    for i in c_delivery loop
        main_val := main_val + i.quant * i.price;
    end loop;
    insert into payment
    values(payment_id_seq.nextval, sysdate, main_val, tips_val);
    update deliveryorder
    set
        paymentid = payment_id_seq.currval
    where id = o_id;
    v_tmp := payment_id_seq.currval;
    select deliverid
    into v_delivery_att_id
    from deliveryorder
    where paymentid = v_tmp;
    update deliveryattendant
         set
            tipscount = tipscount + tips_val
         where id = v_delivery_att_id;
    COMMIT;
    else DBMS_OUTPUT.PUT_LINE('invalid input of order type');
    end if;
END PAYMENT_SETUP;

-----------------------------------------------------------------PROCEDURE reservation_setup--------------------------------------------------------
PROCEDURE reservation_setup(  
    c_id customer.id%type,
    t_id diningtable.id%type,
    in_datetime reservation.datetimeIn%type,
    out_datetime reservation.datetimeOut%type
    )  
IS  
    v_tmp number := -1;
    v_status char(255);
BEGIN
    -- t_id
    begin
    select status into v_status from diningtable where id = t_id;
    if lower(v_status) = 'occupied' then
        dbms_output.put_line('this table is in use');
        return;
    end if;
    exception
        when no_data_found then 
        dbms_output.put_line('wrong input of table id');
        return;
    end;
    -- c_id
    begin
    select id into v_tmp from customer where id = c_id;
    exception
        when no_data_found then 
        dbms_output.put_line('wrong input of customer id');
        return;
    end;
    insert into reservation
    values (reservation_id_seq.nextval, c_id, in_datetime, out_datetime, t_id, 'accepted');
    commit;
exception 
    when no_data_found then DBMS_OUTPUT.PUT_LINE('invalid in input');
END reservation_setup;

-----------------------------------------------------------------PROCEDURE customized_menu_setup-----------------------------------------------------

PROCEDURE customized_menu_setup(  
        m_id member.id%type
    )  
IS 
    v_flavor member.flavor%type;
BEGIN
     select flavor into v_flavor from member where id = m_id;
     for i in (select m.name, m.price, m.flavor from menu m where lower(flavor) = rtrim(lower(v_flavor))) loop
        dbms_output.put_line(i.name || ':' || i.price || '(' || i.flavor || ')');
     end loop;
     for i in (select m.name, m.price, m.flavor from menu m where lower(flavor) != rtrim(lower(v_flavor)) order by m.name) loop
        dbms_output.put_line(i.name || ':' || i.price || '(' || i.flavor || ')');
     end loop;
exception 
    when no_data_found then DBMS_OUTPUT.PUT_LINE('invalid in input');
END customized_menu_setup;



END pkg_procedures;
