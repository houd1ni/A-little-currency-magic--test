(function(){var e,t,r,n,a,i;r={check_mail:function(e){return/^[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$/.test(e)}},i={ModalWindow:{send:function(e,t,r){switch(e){case"currency_notifications":return $.ajax({url:"http://akiliev.ml/currency",method:"GET",dataType:"json",data:t,success:function(e){return r(e.success)}});default:return console.log("Don't know this sendModal todo O.o")}},open:function(){return $("#ModalWindow").dialog({autoOpen:!1,resizable:!1,height:265,width:400,modal:!0,title:"Notifications center",buttons:{"Ok!":function(){var e,t;return t=$(this),r.check_mail(t.find("#email").val())?(e={currency_sign:t.find("currency_sign").eq(0).text(),inequality_sign:t.find("#inequality_sign").val(),value:t.find("#value").val(),email:t.find("#email").val(),todo:"subscribe_value"},i.ModalWindow.send("currency_notifications",e,function(e){return e?(alert("Success! Check your email!"),t.dialog("close")):alert("Input or sever error. Check input fields of try again later. Thank you.")})):t.find("#error").text("Wrong email.")},Cancel:function(){return $(this).dialog("close")}},show:{effect:"fade",duration:360},hide:{effect:"fade",duration:240},open:function(){return ReactDOM.render(React.createElement(n,{key:1}),document.querySelector("#ModalWindow")),$(this).find("#error").text("")}})}}},n=React.createClass({render:function(){return React.createElement("div",null,a.ModalWindow.chosen_param,"			  ",React.createElement("select",{id:"inequality_sign"},React.createElement("option",{value:">"},">"),React.createElement("option",{value:"<"},"<")),"			  ",React.createElement("input",{type:"text",size:5,id:"value"}),React.createElement("currency_sign",null,a.ModalWindow.chosen_currency_sign),React.createElement("br",null),React.createElement("br",null),"			your mail:  ",React.createElement("input",{type:"text",id:"email"}),React.createElement("br",null),React.createElement("br",null),React.createElement("div",{id:"error",style:{color:"red",position:"relative","float":"right"}}))}}),e=React.createClass({paramClicked:function(e,t,r){return a.ModalWindow={chosen_param:e,chosen_currency_sign:t},$("#ModalWindow").dialog("open")},render:function(){var e,t;return React.createElement("div",{className:"CurrencyCard"},React.createElement("h1",{className:"currency_symbol"},this.props.sign),React.createElement("table",null,React.createElement("tbody",null,React.createElement("tr",null,React.createElement("th",null,"Now"),React.createElement("th",null,"Forecast for tomorrow")),function(){var r,n;r=this.props.now,n=[];for(e in r)t=r[e],n.push(React.createElement("tr",{onClick:this.paramClicked.bind(this,e,this.props.sign),title:"You can subscribe on changes!",key:e},React.createElement("td",null,e,": ",t),null!=this.props.forecast[e]?React.createElement("td",null,e,": ",this.props.forecast[e]):React.createElement("td",null)));return n}.call(this))))}}),t=React.createClass({precision:function(e){return+(+e).toFixed(3)},new_state:function(e){var t,r;return r=e.now,t=e.forecast,{dollar:{sign:"$",now:{buy:this.precision(r.buy.usd_rub),sell:this.precision(r.sell.usd_rub),"avg.buy":this.precision(r.buy.avg_usd),"avg.sell":this.precision(r.sell.avg_usd),"spread abs":this.precision(r.sell.usd_rub-r.buy.usd_rub),"spread rel":this.precision(r.sell.usd_eur-r.buy.usd_eur)},forecast:{buy:"-",sell:"-","avg.buy":this.precision(t.buy.avg_usd),"avg.sell":this.precision(t.buy.avg_usd),"spread abs":this.precision(t.sell.avg_usd-t.buy.avg_usd),"spread rel":this.precision(t.usd_eur_spread)}},euro:{sign:"€",now:{buy:this.precision(r.buy.eur_rub),sell:this.precision(r.sell.eur_rub),"avg.buy":this.precision(r.buy.avg_eur),"avg.sell":this.precision(r.sell.avg_eur),"spread abs":this.precision(r.sell.eur_rub-r.buy.eur_rub),"spread rel":this.precision(r.sell.eur_usd-r.buy.eur_usd)},forecast:{buy:"-",sell:"-","avg.buy":this.precision(t.buy.avg_eur),"avg.sell":this.precision(t.sell.avg_eur),"spread abs":this.precision(t.sell.avg_eur-t.buy.avg_eur),"spread rel":this.precision(t.eur_usd_spread)}}}},updateNet:function(){return $.ajax({url:"http://akiliev.ml/currency",method:"GET",dataType:"json",data:{todo:"update_currency"},success:function(e){return function(t){return console.log(t),e.setState(e.new_state(t))}}(this)})},componentDidMount:function(){return i.ModalWindow.open(),this.updateNet(),setInterval(this.updateNet,1e3*this.props.updateInterval*60)},render:function(){var t,r,n;return r=0,React.createElement("div",{key:r},React.createElement("ul",{key:++r},function(){var a,i;a=this.state,i=[];for(t in a)n=a[t],i.push(React.createElement("li",{key:++r}," ",React.createElement(e,React.__spread({},n,{key:++r}))," "));return i}.call(this)))}}),a={ModalWindow:{}},ReactDOM.render(React.createElement(t,{key:0,updateInterval:100/60}),document.querySelector("#content"))}).call(this);