from flask import Flask
from flask import render_template, request
from bq import *
import requests as req
#from flask_flatpages import FlatPages
#from flask_frozen import Freezer

app = Flask(__name__)


#app.config.from_pyfile('settings.py')
#pages = FlatPages(app)
#freezer = Freezer(app)



@app.route('/bq_test.html', methods=['GET','POST'])
def home():
    transactions= []
    y = 'just checking cache'

    if request.method == 'GET':
        x = ''
        return render_template('base.html', x=x, y=y)


    else:
        account = request.form['account']
        q = 'select Date, Amount_Spent from min_mass.samp where Account = '
        # 40000430 40001405 40000500
        x = bq_query(service, q + account + ';', 
            'premium-weft-555', http)
        print x, account
        return render_template('base.html', x=x, y=y)

if __name__ == '__main__':
    app.debug=True
    app.run(threaded=True)
