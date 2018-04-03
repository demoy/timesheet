 
A simple time sheet Web Application. Made using Flask (http://flask.pocoo.org/).

Project requirements:

(python tools, these are usually installable via 'pip', the python package manager)

flask
flask_mysqldb
wtforms
python_mysql

(other)

MySQL or MariaDb


Project Shortfalls (by severity):

1. wtforms provides no realtime form editing feedback. Stalling the implementation of dynamic additions of datetime intervals. Work arounds are still being attempted. 

2. stored password are currently unhashed in the database.

3. sql calls are yet to be moved into their own discrete model layer (their are currently intermixed with the controller). once moved optimizations such as caching queries is easier.
