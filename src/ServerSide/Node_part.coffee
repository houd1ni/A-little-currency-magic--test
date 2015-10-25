#a bit of dependences

global.http = require 'http'
global.expressJS = require 'express'
compress = require 'compression'
App = expressJS()
App.use compress()
global.Server = http.Server App
global.io = require('socket.io') Server
global.msql = require 'mysql'



App.use '/currency/lib/', expressJS.static 'D:\\web\\node\\Currency\\public\\'
global.https = require 'https'
Currency = require './modules/Currency.coffee'
Currency = new Currency

App.get startsfrom('/currency'), (request, response, next) ->
	if request.hostname != 'akiliev.ml' then next()
	get_query = Query.get_parse request.url
	if get_query.data.todo?
		todo = get_query.data.todo
		response.writeHead 200, 'Content-Type': 'application/json; charset=utf-8'
		try
			if todo=='subscribe_value'
				Currency.prepare_notifications get_query.data, (result)=>
					response.write JSON.stringify result
					response.end()
			else if todo=='update_currency'
				Currency.get_last_shot().then (data)=>
					response.write JSON.stringify data
					response.end()
			else response.end()
		catch err
			logg err
			logg 'Notifications trouble.'
			response.write '{success:false}'
			response.end()
	else
		response.writeHead 200,
			'Content-Type': 'text/html; charset=utf-8',
			'Last-Modified': (new Date()),
			'Connection': 'Keep-Alive',
			'Cache-Control':'max-age=15'
		fs.readFile 'D:\\web\\node\\Currency\\public\\index.html', (d)->
			response.write d
			response.end()