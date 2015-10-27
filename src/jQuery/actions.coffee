###
	TODO: further decomposing of `open()` and refactor to make it more reusable.
###

UI =
	ModalWindow:
	
		stored_pops: {}
		default_props:
			selector: '#ModalWindow'
			width:    400
			height:   265
			title:    'Notifications center'

			ok_action: ->

				here = $(@)
				if Helpers.check_mail here.find('#email').val()

					data =
						currency_sign:   here.find('currency_sign').eq(0).text()
						inequality_sign: here.find('#inequality_sign').val()
						value:           here.find('#value').val()
						email:           here.find('#email').val()
						todo:            'subscribe_value'
						
					#send a confirmation
					UI.ModalWindow.send 'currency_notifications', data, (success)->
						if success
							alert 'Success! Check your email!'
							here.dialog 'close'
						else
							alert 'Input or sever error. Check input fields of try again later. Thank you.'
				else
					here.find('#error').text 'Wrong email.'

			cancel_action: ->
				$(@).dialog 'close'


		# Sends a form inside theModalWindow to a server
		send: (todo, data, cb)->
			switch todo
				when 'currency_notifications'
					$.ajax
						url: 'http://akiliev.ml/currency'
						method: 'GET'
						dataType: 'json'
						data: data
						success: (recieved_data)->
							cb recieved_data.success
				else
					console.log 'Don\'t know this sendModal todo O.o'

		prepare: (props)->

			if typeof props == 'object'
				for name, prop of UI.ModalWindow.default_props
					props[name] = props[name] || prop
			else props = UI.ModalWindow.default_props

			$(props.selector).dialog
					autoOpen:  false,
					resizable: false,
					height:    props.height,
					width:     props.width,
					modal:     true,
					title:     props.title,
					show:
						effect: 'fade'
						duration: 360
					hide:
						effect: 'fade'
						duration: 240

					open: ->
						ReactDOM.render(
							<ModalWindow key={1}/>,
							document.querySelector props.selector
						)
						$(@).find('#error').text ''

					buttons:
						'Ok!': ->    props.ok_action.apply(@)
						'Cancel': -> props.cancel_action.apply(@)

			UI.ModalWindow.stored_pops = props

		open: ->
			$(UI.ModalWindow.stored_pops.selector).dialog 'open'