from flask import Flask, render_template, redirect, url_for, request
from flask_mysqldb import MySQL
from utils import *
import MySQLdb.cursors

app = Flask(__name__, static_folder='assets')
app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_DB'] = 'tranzactiidb'
mysql = MySQL(app)
filters = {}
all_client_details = {}
client_id = ''


@app.route('/')
@app.route('/home')
def home():
    return render_template('home.html')


@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'GET':
        return render_template('login.html')
    elif request.method == 'POST':
        return redirect(url_for('home_admin'))


@app.route('/home_admin', methods=['GET'])
def home_admin():
    if request.method == 'GET':
        return render_template('home_admin.html')


@app.route('/clients', methods=['GET', 'POST'])
def clients():
    global filters
    global client_id
    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    client_fields = get_table_columns(cursor, 'tblClient')
    if request.method == 'GET':
        if all([*map(lambda x: not x[1], filters.items())]):
            select_results = list_template(['tblClient'], cursor)
        else:
            select_results = list_template_filtered('tblClient', cursor, filters)
        filters = {}
        return render_template('clients.html', client_fields=client_fields, select_results=select_results)
    elif request.method == 'POST':
        if request.form.get('add_client_button'):
            return redirect(url_for('add_client'))
        elif request.form.get('delete'):
            delete_record('tblClient', cursor, 'client_id', mysql, 'delete')
            return redirect(url_for('clients'))
        elif request.form.get('to_client'):
            client_id = request.form['to_client']
            return redirect(url_for('client_details'))
        elif request.form.get('update_client'):
            client_id = request.form['update_client']
            return redirect(url_for('update_client'))
        elif request.form.get('search_button'):
            for field in client_fields:
                if 'id' not in field:
                    filters[field] = request.form[field]
            return redirect(url_for('clients'))


@app.route('/add_client', methods=['GET', 'POST'])
def add_client():
    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    if request.method == 'GET':
        return render_template('add_client.html')
    elif request.method == 'POST':
        add_record('tblClient', cursor, mysql, 'client_id')
        return redirect(url_for('clients'))


@app.route('/client_details', methods=['GET', 'POST'])
def client_details():
    global all_client_details
    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    if request.method == 'GET':
        all_client_details = get_client_details(cursor, client_id)
        return render_template('client_details.html', all_client_details=all_client_details)
    if request.method == 'POST':
        if request.form.get('add_bank_account_button'):
            return redirect(url_for('add_bank_account'))
        if request.form.get('add_credit_card_button'):
            return redirect(url_for('add_credit_card'))
        if request.form.get('delete_account'):
            delete_record('tblDetine', cursor, 'contbnc_id', mysql, 'delete_account')
            delete_record('tblCardCredit', cursor, 'contbnc_id', mysql, 'delete_account')
            delete_record('tblCont', cursor, 'contbnc_id', mysql, 'delete_account')
            return redirect(url_for('client_details'))
        if request.form.get('delete_card'):
            delete_record('tblCardCredit', cursor, 'card_id', mysql, 'delete_card')
            return redirect(url_for('client_details'))


@app.route('/update_client', methods=['GET', 'POST'])
def update_client():
    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    global client_id
    if request.method == 'GET':
        query = "SELECT * FROM {} where client_id = '{}'".format('tblClient', client_id)
        cursor.execute(query)
        client = cursor.fetchone()
        return render_template('update_client.html', client=client)
    elif request.method == 'POST':

        query = "SELECT * FROM {} where client_id = '{}'".format('tblClient', client_id)
        cursor.execute(query)
        client = cursor.fetchone()

        col_condition = []
        update_query = """
            UPDATE {} SET {} WHERE client_id = {}
        """
        for key, _ in client.items():
            if key != 'client_id':
                col_condition.append("{} = '{}'".format(key, request.form.get(key)))
        set_stmt = ', '.join(col_condition)
        cursor.execute(update_query.format('tblClient', set_stmt, client_id))
        mysql.connection.commit()
        return redirect(url_for('clients'))


@app.route('/add_bank_account', methods=['GET', 'POST'])
def add_bank_account():
    global client_id
    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    if request.method == 'GET':
        return render_template('add_bank_account.html')
    elif request.method == 'POST':
        add_record('tblCont', cursor, mysql, 'contbnc_id')
        query_max_id = "SELECT MAX({}) as max_id FROM {}".format('contbnc_id', 'tblCont')
        cursor.execute(query_max_id)
        max_id = int(cursor.fetchall()[0]['max_id'])
        query_link = """
            INSERT INTO tblDetine VALUES('{}', '{}')
        """
        cursor.execute(query_link.format(client_id, max_id))
        mysql.connection.commit()
        return redirect(url_for('client_details'))


@app.route('/add_credit_card', methods=['GET', 'POST'])
def add_credit_card():
    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    if request.method == 'GET':
        accounts = {}
        credit_card_query = """
                SELECT IBAN FROM tblclient
                inner join tbldetine t on tblclient.client_id = t.client_id
                inner join tblcont t2 on t.contbnc_id = t2.contbnc_id
                WHERE t.client_id = '{}';
            """
        cursor.execute(credit_card_query.format(client_id))
        accounts['ibans'] = cursor.fetchall()
        return render_template('add_credit_card.html', accounts=accounts)
    if request.method == 'POST':
        iban = request.form.get('IBAN')
        get_cntbnc_query = "SELECT contbnc_id FROM tblCont WHERE IBAN = '{}'".format(iban)
        cursor.execute(get_cntbnc_query)
        contbnc_id = cursor.fetchone()['contbnc_id']

        query_max_id = "SELECT MAX({}) as max_id FROM {}".format('card_id', 'tblCardCredit')
        cursor.execute(query_max_id)
        max_id = int(cursor.fetchone()['max_id']) + 1
        nr_card = request.form.get('nr_card')
        cvv = request.form.get('CVV')
        tip_card = request.form.get('tip_card')
        sold = request.form.get('sold')

        insert_query = """
            INSERT INTO {} 
            VALUES('{}', '{}', DATE_ADD(SYSDATE(), INTERVAL 4 YEAR), '{}', '{}', '{}', '{}') 
        """.format('tblCardCredit', max_id, nr_card, cvv, tip_card, contbnc_id, sold)

        cursor.execute(insert_query)
        mysql.connection.commit()
        return redirect(url_for('client_details'))


if __name__ == '__main__':
    app.run()
