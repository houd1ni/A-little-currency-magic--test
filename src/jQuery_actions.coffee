###
	TODO: Split `open()` and refactor to make it reusable
###

UI =
	ModalWindow:
		send: (todo, data, cb)->
			switch todo
				when 'currency_notifications'
					# console.log data
					$.ajax
						url: 'http://akiliev.ml/currency'
						method: 'GET'
						dataType: 'json'
						data: data
						success: (recieved_data)->
							# console.log recieved_data
							cb recieved_data.success
				else
					console.log 'Don\'t know this sendModal todo O.o'

		open: ->
			$('#ModalWindow').dialog
					autoOpen: false,
					resizable: false,
					height:265,
					width:400,
					modal: true,
					title: 'Notifications center'
					buttons:

						'Ok!': ->
							here = $(@)
							if Helpers.check_mail here.find('#email').val()
								#send a confirmation
								data =
									currency_sign:   here.find('currency_sign').eq(0).text()
									inequality_sign: here.find('#inequality_sign').val()
									value:           here.find('#value').val()
									email:           here.find('#email').val()
									todo:            'subscribe_value'
								UI.ModalWindow.send 'currency_notifications', data, (success)->
									if success
										alert 'Success! Check your email!'
										here.dialog 'close'
									else
										alert 'Input or sever error. Check input fields of try again later. Thank you.'
							else
								here.find('#error').text 'Wrong email.'

						'Cancel': ->
							$(@).dialog 'close'

					show:
						effect: 'fade'
						duration: 360
					hide:
						effect: 'fade'
						duration: 240
					open: ->
						ReactDOM.render(
							<ModalWindow key={1}/>,
							document.querySelector '#ModalWindow'
						)
						$(@).find('#error').text ''