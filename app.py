from flask import Flask, render_template, flash, redirect, url_for, session, logging, request
from flask_mysqldb import MySQL
from wtforms import Form, StringField, SelectField, validators
from passlib.hash import sha256_crypt
from functools import wraps
import os
import json

app = Flask(__name__)

# Config MySQL
app.config['MYSQL_HOST'] = 'localhost';
app.config['MYSQL_USER'] = 'basic';
app.config['MYSQL_PASSWORD'] = '9ik0ol';
app.config['MYSQL_DB'] = 'timesheet';
app.config['MYSQL_CURSORCLASS'] = 'DictCursor';
# init MYSQL
mysql = MySQL(app)

def is_logged_in(f):
    @wraps(f)
    def wrap(*args, **kwargs):
        if 'logged_in' in session:
            return f(*args, **kwargs)
        else:
            flash('Unauthorized, Please login', 'danger')
            return redirect(url_for('login'))
    return wrap


@app.route('/')
def index():
    return redirect(url_for('login'))


@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        eid = request.form["eid"]
        candidate = request.form["password"]
    
        cur = mysql.connection.cursor()
        result = cur.execute("SELECT * FROM passw WHERE eid=%s",[eid])
        
        if result > 0:
            data = cur.fetchone()
            password = data['pass_hash']
            
            if password == candidate:
                session['logged_in'] = True
                session['eid'] = eid
                flash('You are now logged in', 'success')
                
                return redirect(url_for('sheet'))
            else:
                error = 'Invalid login'
                return render_template('login.html', error=error)
            cur.close()
        else:
                error = 'Username not found'
                return render_template('login.html', error=error)
        
    return render_template('login.html')

      

@app.route('/sheet', methods=['GET', 'POST'])
#@is_logged_in
def sheet():
    cur = mysql.connection.cursor()
    cur.execute("SELECT client_id, client_nam, client.eid, fam_nam, pers_nam, title FROM employee INNER JOIN (client, pos) ON (client.eid = employee.eid AND pos.pos_id = employee.pos_id);")
    cache=cur.fetchall()
    cur.close()

    class sheet_form(Form):
        work_title = StringField('Work Title', [validators.Length(min=1, max=50), validators.DataRequired()])
        app.logger.info([(c['client_id'], c['client_nam']) for c in cache])
        client = SelectField('Client', choices=[(c['client_id'], c['client_nam']) for c in cache])

    form = sheet_form(request.form)
    if request.method == 'POST' and form.validate():
        return
    return render_template('sheet.html', form=form, cache=json.dumps(cache))


if __name__ == '__main__':
    app.secret_key=os.urandom(24)
    app.run(debug=True)
