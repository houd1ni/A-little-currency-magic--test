CurrencyCard = React.createClass
		
	paramClicked: (param_name, currency_sign, e)->
		State.ModalWindow =
			chosen_param: param_name
			chosen_currency_sign: currency_sign
		$('#ModalWindow').dialog 'open'

	render: ->
		<div className='CurrencyCard'>
			<h1 className='currency_symbol'>{@props.sign}</h1>
			
			<table>
				<tbody>
					<tr>
						<th>Now</th>
						<th>Forecast for tomorrow</th>
					</tr>
					{
						for param_name, param_value of @props.now
							<tr onClick={@paramClicked.bind(@, param_name, @props.sign)} title='You can subscribe on changes!' key={param_name}>
								<td>{param_name}: {param_value}</td>
								{if @props.forecast[param_name]? then <td>{param_name}: {@props.forecast[param_name]}</td> else <td></td>}
							</tr>
					}
				</tbody>
			</table>

		</div>