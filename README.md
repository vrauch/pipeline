# pipeline
1.	Install server (for example apache2, nginx, other)
2.	Ruby (version 2.3.0)
3.	install node js
4.	DataBase - mysql  Ver 14.14 Distrib 5.5.49, for debian-linux-gnu (x86_64)
5.	Sphinx 2.0.4-id64-release (r3135) – for search
6.	install php5-memcache, memcached
7.	Install imagemagic
8.	Redis server v=2.8.4 (for sidekiq)
9.	Install bundler
10.	Add config/secrets.yml
11.	Add config/database.yml (view config/database_example.yml)
12.	Add config/thinking_sphinx.yml (view config/thinking_sphinx_example.yml)
13.	$ bundle install
14.	$ rake db:create
15.	load database from dump → $ mysql -u username -p evol8tion < dump_name.sql
16.	$ rake assets:precompile RAILS_ENV=production
17.	reboot your server
18.	for search (see all tasks $ rake -T) $ rake ts:index
19.	starts sphinx $ rake ts:start 
