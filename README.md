# secure-ruby-backend
Readme

1. Install all dependences: 

sudo apt-get upgrade; sudo apt-get install gem; sudo apt-get install rubygems; sudo gem install ruby-full; sudo gem install rubygems-update;sudo gem install sinatra; sudo gem install base64; sudo gem install json; sudo gem install mysql; sudo gem install digest;sudo gem install securerandom;


2. Create database and tables: 

mysql -u root -p

CREATE DATABASE myservice;


CREATE TABLE `users` (
  `uid` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `email` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `encrypted_password` varchar(160) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `salt` varchar(10) COLLATE utf8_unicode_ci NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`uid`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



3. Edit script with new creditentials and 
