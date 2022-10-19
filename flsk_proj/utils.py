from flask_mysqldb import MySQL
from flask import request
import MySQLdb.cursors


def get_table_columns(cursor, table):
    query = "show columns from {}".format(table)
    cursor.execute(query)
    results = cursor.fetchall()
    return [*map(lambda x: x['Field'], results)]


def list_template(tables, cursor):
    results = {}
    for table in tables:
        query = 'SELECT * FROM {}'.format(table)
        cursor.execute(query)
        results[table] = cursor.fetchall()
    return results


def list_template_filtered(table, cursor, filters):
    fields = get_table_columns(cursor, table)
    query = """
        SELECT * FROM {}
        WHERE {}
    """
    where_clauses = []
    for field in fields:
        if 'id' not in field:
            if filters[field]:
                where_clauses.append("{} LIKE '%{}%'".format(field, filters[field]))
    query = query.format(table, ' AND '.join(where_clauses))
    cursor.execute(query)
    return {table: cursor.fetchall()}


def add_record(table, cursor, mysql, field_id):
    fields = get_table_columns(cursor, table)
    non_pk_fields = []
    for field in fields:
        if 'id' not in field:
            non_pk_fields.append(field)
    query_max_id = "SELECT MAX({}) as max_id FROM {}".format(field_id, table)
    cursor.execute(query_max_id)
    max_id = int(cursor.fetchall()[0]['max_id']) + 1
    max_id = ["'{}'".format(max_id)]

    max_id.extend([*map(lambda x: "'{}'".format(request.form[x]), non_pk_fields)])
    insert_query = "INSERT INTO {} VALUES ({})"
    cursor.execute(insert_query.format(table, ",".join(max_id)))
    mysql.connection.commit()


def delete_record(table, cursor, field_id, mysql, tag):
    delete_query = "DELETE FROM {} WHERE {} = '{}'"
    cursor.execute(delete_query.format(table, field_id, request.form[tag]))
    mysql.connection.commit()


def get_client_details(cursor, client_id):

    results_client_details = {}
    bank_account_query = """
        SELECT t2.contbnc_id, IBAN, limita_tranzactionare, in_moneda, sold FROM tblclient
        inner join tbldetine t on tblclient.client_id = t.client_id
        inner join tblcont t2 on t.contbnc_id = t2.contbnc_id
        where t.client_id = '{}';
    """
    credit_card_query = """
        SELECT t3.card_id, IBAN, nr_card, data_expirarii, CVV, tip_card, t3.sold  FROM tblclient
        inner join tbldetine t on tblclient.client_id = t.client_id
        inner join tblcont t2 on t.contbnc_id = t2.contbnc_id
        inner join tblcardcredit t3 on t2.contbnc_id = t3.contbnc_id
        WHERE t.client_id = '{}';
    """
    transactions_query = """
        SELECT nr_card, data_tranzactie, destinatar, suma, plata_la, status_tranzactie FROM tblclient
        inner join tbldetine t on tblclient.client_id = t.client_id
        inner join tblcont t2 on t.contbnc_id = t2.contbnc_id
        inner join tblcardcredit t3 on t2.contbnc_id = t3.contbnc_id
        inner join tbltranzactii t4 on t3.card_id = t4.card_id
        where t.client_id = '{}';
    """

    cursor.execute(bank_account_query.format(client_id))
    results_client_details['bank_account'] = cursor.fetchall()

    cursor.execute(credit_card_query.format(client_id))
    results_client_details['credit_card'] = cursor.fetchall()

    cursor.execute(transactions_query.format(client_id))
    results_client_details['transactions'] = cursor.fetchall()

    return results_client_details
