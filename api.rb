#!/usr/bin/env ruby
require 'rubygems'
require 'base64'
require 'sinatra'
require 'json'
require 'mysql'
require 'digest'
require 'securerandom'
require 'socket'
require 'uri'

locale = 'localhost'
user = 'root'
passwd = '*********'
db = 'myservice'

get '/' do
	"Nothing to see here. Move along."
end

def check_registered_user_email(email)
	begin
		con = Mysql.new(locale,user,passwd,db) 
		con.autocommit false

		pst = con.prepare "SELECT * FROM users WHERE email = ?"

		pst.execute "#{email}"
			
		n_rows = pst.num_rows

		con.commit
		return n_rows
	rescue Mysql::Error => e
		puts e
		con.rollback
	
	ensure
		pst.close if pst
		con.close if con
	end
end

def hashSSHA(password)
	salt = Digest::SHA512.hexdigest SecureRandom.hex
	salt = salt[0,10]
	a = password+salt
	en = Digest::SHA512.hexdigest a
	b = en+salt
	hash = [salt,b]
	puts b
	return hash
end

def checkhashSSHA(salt, password)
	a = password+salt
	en = Digest::SHA512.hexdigest a
	b = en+salt
	return b
end

def register_new_user(name,email,password)
	begin
		con = Mysql.new(locale,user,passwd,db) 
		pst = con.prepare "INSERT INTO users(name, email, encrypted_password, salt, created_at) VALUES(?,?,?,?,?)"
		hash = hashSSHA(password)
		encrypted_password = hash.at(1)
		salt = hash.at(0)
		time = Time.new
		pst.execute name, email, encrypted_password, salt, time.strftime("%Y-%m-%d %H:%M:%S")
		"{\"success\":1,\"error\":\"User registered\"}"
	rescue Mysql::Error => e
		puts e
		con.rollback
	ensure
		con.close if con
		pst.close if pst
	end
end

post '/mobilelogin' do
	values = JSON.parse(request.env["rack.input"].read)
	if values["tag"]=="login"
		begin
			con = Mysql.new(locale,user,passwd,db) 
			con.autocommit false
			rs = con.query "SELECT * FROM users WHERE email = '"+values["email"]+"'"
			if rs.num_rows == 1
				rs.each_hash do |row|
				salt = row['salt']
				encrypted_password = row['encrypted_password']
				password = values["password"]
				hash = checkhashSSHA(salt, password)
				puts encrypted_password, "\n"+hash, "\n"+salt
				if encrypted_password == hash
					message = "Welcome "+row['name']
					return "{\"success\":1,\"message\":\"#{message}\"}"
				else
					return"{\"success\":0,\"message\":\"Wrong password\"}"
				end
			end
			con.commit
			else
				return"{\"success\":0,\"message\":\"User doesn't exist.\"}"
			end
		rescue Mysql::Error => e
			puts e
			con.rollback
		ensure
			con.close if con
		end
	elsif values["tag"]=="register"
		if check_registered_user_email(values["email"]) > 0
			"{\"success\":0,\"message\":\"User already exists\"}"
		else
			if values["name"]!="" && values["email"]!="" && values["password"]!=""
				register_new_user(values["name"],values["email"],values["password"])
				return "{\"success\":1,\"message\":\"User registered.\"}"
			else
				return "{\"success\":0,\"message\":\"Please provide all your details.\"}"
			end
		end
	else
		"{\"success\":0,\"message\":\"acces denied\"}"
	end
end

