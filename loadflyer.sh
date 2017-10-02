ey ssh ./dumpflyer.sh
ey scp HOST:~/reflyer.dump.sql reflyer.dump.sql
reflyer<reflyer.dump.sql
mysql -ureflyer -preflyer -D reflyer -e "insert into flyers (id,title) values (100000,'bumper')"

