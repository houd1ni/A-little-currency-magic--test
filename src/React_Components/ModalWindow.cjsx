ModalWindow = React.createClass

	render: ->
		<div>
			{State.ModalWindow.chosen_param}
			&nbsp;&nbsp;
			<select id='inequality_sign'>
				<option value='>'>></option>
				<option value='<'><</option>
			</select>
			&nbsp;&nbsp;
			<input type="text" size=5 id='value' /><currency_sign>{State.ModalWindow.chosen_currency_sign}</currency_sign>
			<br /><br />
			your mail:  <input type="text" id='email' />
			<br /><br />
			<div id='error' style={{color:'red', position:'relative', float:'right'}}/>
		</div>