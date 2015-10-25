CurrencyNet = React.createClass

	precision: (x)-> +((+x).toFixed 3)

	new_state: (data)->
		now = data.now
		forecast = data.forecast
		# console.log +forecast.buy.avg_usd
		dollar:
			sign: '$'
			now:
				'buy':        @precision( now.buy.usd_rub )
				'sell':       @precision( now.sell.usd_rub )
				'avg.buy':    @precision( now.buy.avg_usd )
				'avg.sell':   @precision( now.sell.avg_usd )
				'spread abs': @precision( now.sell.usd_rub - now.buy.usd_rub )
				'spread rel': @precision( now.sell.usd_eur - now.buy.usd_eur )
			forecast:
				'buy':        '-'
				'sell':       '-'
				'avg.buy':    @precision( forecast.buy.avg_usd )
				'avg.sell':   @precision( forecast.buy.avg_usd )
				'spread abs': @precision( forecast.sell.avg_usd - forecast.buy.avg_usd )
				'spread rel': @precision( forecast.usd_eur_spread )
		euro:
			sign: '€'
			now:
				'buy':        @precision( now.buy.eur_rub )
				'sell':       @precision( now.sell.eur_rub )
				'avg.buy':    @precision( now.buy.avg_eur )
				'avg.sell':   @precision( now.sell.avg_eur )
				'spread abs': @precision( now.sell.eur_rub - now.buy.eur_rub )
				'spread rel': @precision( now.sell.eur_usd - now.buy.eur_usd )
			forecast:
				'buy':        '-'
				'sell':       '-'
				'avg.buy':    @precision( forecast.buy.avg_eur )
				'avg.sell':   @precision( forecast.sell.avg_eur )
				'spread abs': @precision( forecast.sell.avg_eur - forecast.buy.avg_eur )
				'spread rel': @precision( forecast.eur_usd_spread )

	updateNet: ->
		$.ajax
			url: 'http://akiliev.ml/currency'
			method: 'GET'
			dataType: 'json'
			data: todo: 'update_currency'
			success: (data)=>
				console.log data
				@setState @new_state data
				

	componentDidMount: ->
		UI.ModalWindow.open()
		@updateNet()
		setInterval @updateNet, @props.updateInterval*1000*60
		
	render: ->
		i = 0
		<div key={i}>
			<ul key={++i}>
				{
					for currency_name, info of @state
						<li key={++i}> <CurrencyCard {...info} key={++i}/> </li>
				}
			</ul>
		</div>