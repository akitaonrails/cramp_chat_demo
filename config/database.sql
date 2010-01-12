create database cramp_chat_development 
  default character set utf8 
  default collate utf8_general_ci;

use cramp_chat_development;

create table chat ( 
  id int not null auto_increment, 
  name varchar(100) not null, 
  message text, 
  sent_at datetime, 
  primary key(id) 
);
