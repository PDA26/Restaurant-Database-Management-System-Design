Create or Replace Package pkg_procedures IS

PROCEDURE customer_signUp( c_fName customer.firstname%type, c_lName customer.lastname%type, c_phoneNum customer.phonenum%type, c_address customer.address%type, c_zipcode customer.zipcode%type);
PROCEDURE customer_update ( c_id customer.id%type,c_fName customer.firstname%type, c_lName customer.lastname%type, c_phoneNum customer.phonenum%type, c_address customer.address%type, c_zipcode customer.zipcode%type); 
PROCEDURE deliveryOrder_setup(c_id customer.id%type,do_zipcode deliveryorder.zipcode%type,do_deliverid deliveryorder.deliverid%type,do_datetime deliveryorder.datetime%type,do_address deliveryorder.address%type,do_phonenum deliveryorder.phonenumber%type);
PROCEDURE dineInOrder_setup(t_id diningtable.id%type,c_id customer.id%type,do_datetime dineinorder.datetime%type); 
PROCEDURE member_signup (c_id customer.id%type,m_discount member.discount%type, m_flavor member.flavor%type, m_birthday member.birthday%type, m_balance member.balance%type, m_expirydatetime member.expirydate%type);
PROCEDURE member_updateByMemberId(   m_id member.id%type,m_discount member.discount%type,m_flavor member.flavor%type, m_birthday member.birthday%type, m_balance member.balance%type, m_expirydatetime member.expirydate%type); 
PROCEDURE ORDER_FOOD(order_type varchar2,order_id foodlist.dineinorderid%type,item_id foodlist.dishid%type,item_quant foodlist.quantity%type);
PROCEDURE PAYMENT_SETUP(o_type varchar2,o_id foodlist.dineinorderid%type,tips_val payment.tipsvalue%type);
PROCEDURE reservation_setup(  c_id customer.id%type,t_id diningtable.id%type,in_datetime reservation.datetimeIn%type,out_datetime reservation.datetimeOut%type);
PROCEDURE customized_menu_setup(m_id member.id%type);    

END pkg_procedures;