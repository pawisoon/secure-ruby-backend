# secure-ruby-backend

- Why do I need this? 
A: When I started creating first iOS and Android apps that needed some kind of user registration, I realised there's no ready-to-run script available. Parse was really cool but its terminating really soon. 
Here you have it. Single file, secure and fast scrpt to handle requests from your apps.

- What does it use? 
A:Passwords secured by SHA512 and some salt(just for the flavour :D )

#Ready? Let's go!

- Install all dependencies:

```
sudo apt-get upgrade; sudo apt-get install gem; sudo apt-get install rubygems; sudo gem install ruby-full; sudo gem install rubygems-update;sudo gem install sinatra; sudo gem install base64; sudo gem install json; sudo gem install mysql; sudo gem install digest;sudo gem install securerandom;

```

- Create database.. 

```
mysql -u root -p
```

```
CREATE DATABASE myservice;
```

..and tables: 

```
`CREATE TABLE `users` (
  `uid` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `email` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `encrypted_password` varchar(160) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `salt` varchar(10) COLLATE utf8_unicode_ci NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`uid`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;`

```

- Now run it :) 

```
sudo ruby api.rb -o 0.0.0.0
```
#Test it: 

Register:
```
curl -i -X POST -H 'Content-Type: application/json' -d '{"tag":"register","name":"Tester","email":"test@gmail.com","password":"123"}' http://localhost:4567/mobilelogin
```

Sing in:
```
curl -i -X POST -H 'Content-Type: application/json' -d '{"tag":"login","email":"test@gmail.com","password":"123"}' http://localhost:4567/mobilelogin
```

#TODO:

- Simple project for iOS and Android which will show the basic usage of script. 
- iOS/Android push notifications with Azure Cloud
- ... 
