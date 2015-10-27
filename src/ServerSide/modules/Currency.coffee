class Currency
	# TODO: convenient add for any currency.
	constructor: ->

		# Params
		source = 'https://www.tinkoff.ru/api/v1/currency_rates'
		currencyList = ['EUR','USD', 'RUB']
		server_poll_period = 30 #min
		@precision = 3

		tiktak = (period, todo)-> #period in seconds
			todo()
			setInterval todo, period*1000*60

		loadFromServer = ->
			new Promise (fulfill, reject)->
				HTTPS_LIB.get source, (res)-> #{host:source[0], path:source[1]}
					str = ''
					res.on 'data', (chunk)->
						str += chunk;
					res.on 'end', ->
						try
							str = JSON.parse str
							fulfill str
						catch e
							reject err

		parseUploaded = (data)->
			new Promise (fulfill, reject)->
				if typeof data != 'object'
					reject 'wrong data to parseUploaded: not a hash'
				if data.resultCode != 'OK'
					reject 'resultCode isn\'t OK. Is it down?..'
				try
					data = data.payload.rates.filter (cur)->
						cur.category=='DepositPayments' &&
						currencyList.indexOf(cur.fromCurrency.name)>=0 &&
						currencyList.indexOf(cur.toCurrency.name)>=0
					prepared_data = {}
					for cur in data
						from_to = cur.fromCurrency.name+'_'+cur.toCurrency.name
						prepared_data[from_to] = [cur.sell, cur.buy, ((+cur.sell - cur.buy).toFixed 9)]
					
					# { USD_RUB:[buy, sell], EUR_RUB:--||--, --||-- for spreads... }
					fulfill prepared_data
				catch e
					reject e

		insertInDb = (data)-> # ... after adaptiong for db arch
			new Promise (fulfill, reject)->
				parsed_insert = [
					data['USD_RUB'][0], data['EUR_RUB'][0], data['USD_EUR'][0], data['EUR_USD'][0],
					data['USD_RUB'][1], data['EUR_RUB'][1], data['USD_EUR'][1], data['EUR_USD'][1]
				]
				# SIGNATURE: REQUEST, RAW STATEMENTS, DBNAME(OPTIONAL), CALLBACK: (ROWS, ERROR) (in the case of error, rows === false)
				System.sql.q 'select new_shot(<v0>, <v1>, <v2>, <v3>, <v4>, <v5>, <v6>, <v7>) as result', parsed_insert, 'currency', (rows) =>
					if rows then fulfill rows[0].result

		checkinsertion = (out)-> # just a tail.
			if out != 'ok' then logg 'Error with new_shot(): SQL'
		
		tiktak server_poll_period, -> # Trigger
			loadFromServer().then(parseUploaded, logg).then(insertInDb, logg).then(checkinsertion, logg)

		@notifications_check_input = (data)->
			data? &&
			data.email?.length>1 &&
			data.currency_sign? &&
			data.inequality_sign? &&
			data.value>0


	# For realtime updates (by interval on Client-side). WITHOUT ANY DOS PROTECTION HERE!
	# TODO: caching with (last record from master table) comparison
	get_last_shot: ->
		new Promise (fulfill, reject)->
			System.sql.q 'select * from show_actual_shot', [], 'currency', (actual_shot) =>
				if actual_shot
					System.sql.q 'select forecast_avg_tomorrow() as forecast', [], 'currency', (forecast_rows) =>
						if forecast_rows
							forecast = forecast_rows[0].forecast.split('_')
							forecast.shift()
							
							###
								now:
									Buy: dollar:[], euro:[]
									Sell: --||--
								forecast:
									Buy:  --||--
									Sell: --||--
									Spread usd->eur :Number
									Spread eur->usd :Number
							###

							fulfill
								now:
									buy:            actual_shot[0]
									sell:           actual_shot[1]
								forecast:
									buy:
										avg_usd:      forecast[0]
										avg_eur:      forecast[1]
									sell:
										avg_usd:      forecast[2]
										avg_eur:      forecast[3]
									usd_eur_spread: forecast[4]
									eur_usd_spread: forecast[5]

						else reject false;
				else reject false;


	prepare_notifications: (user_get_data, cb)->
		result = {}
		if @notifications_check_input user_get_data

			# HERE WILL BE REALISATION

			result = success:true, data: 'yaaay!'
		else result = success:false, data: 'bad_input_data'
		cb result


module.exports = Currency