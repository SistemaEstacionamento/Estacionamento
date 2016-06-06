//============================== CLIENTE ==============================

$($(document).ready(function(){
		$(".juridico").hide();
  		$("#btn-nv, btn-alt").click(function(){
  			$("#flcliente").change(function(){
				if($("#flcliente").val()=="f"){
					$(".juridico").hide();
					$(".fisico").show();
				} else {
					$(".fisico").hide();
					$(".juridico").show();
				}
  			});
  		});
  	}));
  		
function confedit(){
    	modeledt.nome = $("#nome").val();
    	modeledt.flcliente = $("#flcliente").val();
    	modeledt.telefone = $("#telefone").val();
    	modeledt.rg = $("#rg").val();
    	modeledt.sexo = $("#sexo").val();
    	modeledt.cpf = $("#cpf").val();
    	modeledt.cnpj = $("#cnpj").val();
    	modeledt.razaosocial = $("#razaosocial").val();
    	modeledt.logradouro = $("#logradouro").val();
    	modeledt.cidade = $("#cidade").val();
    	modeledt.estado = $("#estado").val();
    	modeledt.bairro = $("#bairro").val();
    	modeledt.cep = $("#cep").val();	
       		$.ajax({
           		type: "PUT",
           		dataType: "json",
           		cache: false,
	            contentType:"application/json",    
       		    url: 'https://estacionamento-bruno-alcamin.c9users.io/update/'+modeledt.id,
           		data: JSON.stringify(modeledt),  
       		}).done(function(e){
          			limpaCampos();	
      				$("#tb").html("");
      				listar();
       		});
       		ajusteEdit();
	}
		
	function limpaCampos(){
		$("#nome, #telefone, #rg, #sexo, #cpf, #cnpj, #razaosocial, #logradouro, #cidade, #estado, #bairro, #cep").val("");
		$("#flcliente").val("f");
	}
		
		
	function novo(){
    	$('tbody tr').off("click");
    	limpaCampos();
    	$('#btn-alt, #btn-nv').removeAttr("onclick");
    	$("#nome, #flcliente, #telefone, #rg, #sexo, #cpf, #cnpj, #razaosocial, #logradouro, #cidade, #estado, #bairro, #cep, #tb").removeAttr("disabled","disabled");
    	$('#btn-conc').attr("onclick","confirmar()");
    	$('#btn-canc').attr("onclick","cancelar()");
    	$('#btn-canc, #btn-conc').removeAttr("disabled",'disabled');
    	$('#btn-alt').attr("disabled",'disabled');
    	ajustefisicojuridico();
	}
		
	function ajustefisicojuridico(){
		$("#cnpj, #razaosocial").attr("disabled","disabled");
       	$("#flcliente").click(function(){
       		if($("#flcliente").val()=="f"){
       			$("#cnpj, #razaosocial").attr("disabled","disabled");
       			$("#rg, #sexo, #cpf").removeAttr("disabled","disabled");
       		}else{
          		$("#rg, #sexo, #cpf").attr("disabled","disabled");
       			$("#cnpj, #razaosocial").removeAttr("disabled","disabled");
       		}
      	});
	}

	function cancelar(){
   		selecao();
   		$('tbody tr').css('background-color','#fff');   
   		ajuste();
	}

	function cancelarEdit(){
   		selecao();
   		$("#nome").val($('tr[select="select"]').find('span[id="nm"]').html());
		$("#flcliente").val($('tr[select="select"]').find('span[id="flc"]').html());
		$("#telefone").val($('tr[select="select"]').find('span[id="tl"]').html());
		$("#rg").val($('tr[select="select"]').find('span[id="gr"]').html());
		$("#sexo").val($('tr[select="select"]').find('span[id="sx"]').html());
		$("#cpf").val($('tr[select="select"]').find('span[id="cf"]').html());
		$("#cnpj").val($('tr[select="select"]').find('span[id="cpj"]').html());
		$("#razaosocial").val($('tr[select="select"]').find('span[id="raz"]').html());
		$("#logradouro").val($('tr[select="select"]').find('span[id="log"]').html());
		$("#cidade").val($('tr[select="select"]').find('span[id="cdd"]').html());
		$("#estado").val($('tr[select="select"]').find('span[id="est"]').html());
		$("#bairro").val($('tr[select="select"]').find('span[id="ba"]').html());
		$("#cep").val($('tr[select="select"]').find('span[id="cp"]').html());
   		ajusteEdit();
	}
	
	function alterar(){
   		$('tbody tr').off("click");
   		$('#btn-nv').removeAttr("onclick");
   		$('#btn-nv').attr("disabled",'disabled');
   		$("#nome, #flcliente, #telefone, #rg, #sexo, #cpf, #cnpj, #razaosocial, #logradouro, #cidade, #estado, #bairro, #cep, #tb").removeAttr("disabled","disabled");
   		$('#btn-conc').attr("onclick","confedit()");
   		$('#btn-canc').attr("onclick","cancelarEdit()");
   		$('#btn-conc, #btn-canc').removeAttr("disabled",'disabled');
   		$("#cnpj").attr("disabled","disabled");
   		ajustefisicojuridico();
	}  		

	function excluir(x){
    	if(confirm("Confirma a exclusão do Cliente "+$('button[onclick="excluir('+x+')"').parent().parent().find('span[id="nm"]').html()+"?")){
       		$.ajax({
       			type: 'DELETE',
       			dataType: "json",
       			cache: false,
       			contentType:"application/json",    
       			url: 'https://estacionamento-bruno-alcamin.c9users.io/delete/'+x,
       		});
       		$("#tb").html("");
       		$("#t1 tbody").html("");
       		listar();
   		}
	}

	function selecao(){
   		$('tbody tr').css('cursor','pointer');
       	$('tbody tr').click(function(){
         	$('#btn-alt').removeAttr("disabled",'disabled').attr("onclick","alterar()");
           	ajustefisicojuridico();
           	$('tbody tr').css('background-color','#fff').removeAttr('select','select');
           	$(this).css('background-color','#76affd').attr('select','select');
           	$("#nome").val($(this).find('span[id="nm"]').html());
           	$("#flcliente").val($(this).find('span[id="flc"]').html());
			$("#telefone").val($(this).find('span[id="tl"]').html());
			$("#rg").val($(this).find('span[id="gr"]').html());
			$("#sexo").val($(this).find('span[id="sx"]').html());
			$("#cpf").val($(this).find('span[id="cf"]').html());
			$("#cnpj").val($(this).find('span[id="cpj"]').html());
			$("#razaosocial").val($(this).find('span[id="raz"]').html());
			$("#logradouro").val($(this).find('span[id="log"]').html());
			$("#cidade").val($(this).find('span[id="cdd"]').html());
			$("#estado").val($(this).find('span[id="est"]').html());
			$("#bairro").val($(this).find('span[id="ba"]').html());
			$("#cep").val($(this).find('span[id="cp"]').html());
           	modeledt = {"id":$(this).find('span[id="cd"]').html(),"nome":$(this).find('span[id="nm"]').html(),"flcliente":$(this).find('span[id="flc"]').html(),"telefone":$(this).find('span[id="tl"]').html(),"rg":$(this).find('span[id="gr"]').html(),"sexo":$(this).find('span[id="sx"]').html(),"cpf":$(this).find('span[id="cf"]').html(),"cnpj":$(this).find('span[id="cpj"]').html(),"razaosocial":$(this).find('span[id="raz"]').html(),"logradouro":$(this).find('span[id="log"]').html(),"cidade":$(this).find('span[id="cdd"]').html(),"estado":$(this).find('span[id="est"]').html(),"bairro":$(this).find('span[id="ba"]').html(),"cep":$(this).find('span[id="cp"]').html()};
   		});
	}
		
	function ajuste(){
	    $('tbody tr').on("click");
	    limpaCampos();
	    $('#btn-nv').attr("onclick","novo()");
	    $("#nome, #flcliente, #telefone, #rg, #sexo, #cpf, #cnpj, #razaosocial, #logradouro, #cidade, #estado, #bairro, #cep, #tb").attr("disabled","disabled");
		$('#btn-alt').removeAttr("onclick");
	    $('#btn-alt, #btn-conc, #btn-canc').attr("disabled",'disabled');
	    $('#btn-conc, #btn-canc').removeAttr("onclick");
	    $('input[name="nome"]').css("border-color","#fff");
	}

	function ajusteEdit(){
	    $('tbody tr').on("click");
	    $('#btn-nv').attr("onclick","novo()");
	    $('#btn-nv').removeAttr("disabled",'disabled');
	    $("#nome, #flcliente, #telefone, #rg, #sexo, #cpf, #cnpj, #razaosocial, #logradouro, #cidade, #estado, #bairro, #cep, #tb").attr("disabled","disabled");
		$('#btn-conc, #btn-canc').removeAttr("onclick");
	    $('#btn-conc, #btn-canc').attr("disabled",'disabled');
	    $('input[name="nome"]').css("border-color","#fff");
	}

//============================== CONTRATO ==============================

		function confeditContrato(){
    		modeledt.valor = parseFloat($("#valor").val());
    		modeledt.contratoinc = $("#inic").val();
    		modeledt.contratofim = $("#fim").val(); //.toUTCString()
    		modeledt.quantidadeparcela = parseInt($("#qtparcelas").val());
    		modeledt.quantidadevagas = parseInt($("#qtvagas").val());
    		modeledt.clienteid = parseInt($("#clienteid").val());
        		$.ajax({
            		type: "PUT",
            		dataType: "json",
            		cache: false,
		            contentType:"application/json",    
        		    url: 'https://estacionamento-bruno-alcamin.c9users.io/contratoupdate/'+modeledt.id,
            		data: JSON.stringify(modeledt),  
        		}).done(function(e){
           			limpaCamposContrato();	
       				$("#tb").html("");
       				listarContrato();
        		});
        		ajusteEditContrato();
		}
		
		function limpaCamposContrato(){
			$('input, select').val("");
		}
		
		
		function novoContrato(){
    		$('tbody tr').off("click");
    		limpaCamposContrato();
    		$('#btn-alt, #btn-nv').removeAttr("onclick");
    		$("input, select").removeAttr("disabled","disabled");
    		$('#btn-conc').attr("onclick","confirmarContrato()");
    		$('#btn-canc').attr("onclick","cancelarContrato()");
    		$('#btn-canc, #btn-conc').removeAttr("disabled",'disabled');
    		$('#btn-alt').attr("disabled",'disabled');
		}
		

		function cancelarContrato(){
    		selecaoContrato();
    		$('tbody tr').css('background-color','#fff');   
    		ajusteContrato();
		}

		function cancelarEditContrato(){
    		selecaoContrato();
    		$("input, select").val("").attr("disabled", 'disabled');
    		ajusteEditContrato();
		}
	
		function alterarContrato(){
    		$('tbody tr').off("click");
    		$('#btn-nv').removeAttr("onclick");
    		$('#btn-nv').attr("disabled",'disabled');
    		$("input, select").removeAttr("disabled",'disabled');
    		$('#btn-conc').attr("onclick","confeditContrato()");
    		$('#btn-canc').attr("onclick","cancelarEditContrato()");
    		$('#btn-conc, #btn-canc').removeAttr("disabled",'disabled');
		}

		function excluirContrato(x){
     		if(confirm("Confirma a exclusão do contrato "+$('button[onclick="excluirContrato('+x+')"').parent().parent().find('span[id="codigo"]').html()+"?")){
        		$.ajax({
        			type: 'DELETE',
        			dataType: "json",
        			cache: false,
        			contentType:"application/json",    
        			url: 'https://estacionamento-bruno-alcamin.c9users.io/contratodelete/'+x,
        		});
        		$("#tb, #t1 tbody").html("");
        		listarContrato();
    		}
		}

		function selecaoContrato(){
    		$('tbody tr').css('cursor','pointer');
        	$('tbody tr').click(function(){
            	$('#btn-alt').removeAttr("disabled",'disabled');
            	$('#btn-alt').attr("onclick","alterarContrato()");
            	$('tbody tr').css('background-color','#fff');
            	$('tbody tr').removeAttr('select','select');
            	$(this).css('background-color','#76affd');
            	$(this).attr('select','select');
            	
            	$("#valor").val($(this).find('span[id="valor"]').html());
            	$("#inic").val($(this).find('span[id="inic"]').html());
            	$("#fim").val($(this).find('span[id="fim"]').html());
            	$("#qtparcelas").val($(this).find('span[id="qtparcelas"]').html());
            	$("#qtvagas").val($(this).find('span[id="qtvagas"]').html());
            	$("#clienteid").val($(this).find('span[id="clienteid"]').html());
            	
            	modeledt = {"id":$(this).find('span[id="codigo"]').html(),"valor":$(this).find('span[id="valor"]').html(),
            		        "contratoinc":$(this).find('span[id="inic"]').html() ,"contratofim":$(this).find('span[id="fim"]').html(),
            		        "quantidadeparcela":$(this).find('span[id="qtparcelas"]').html() , "quantidadevagas":$(this).find('span[id="qtvagas"]').html(),
            		        "clienteid":$(this).find('span[id="clienteid"]').html() };
    		});
		}
		
		function ajusteContrato(){
		    $('tbody tr').on("click");
		    limpaCamposContrato();
		    $('#btn-nv').attr("onclick","novoContrato()");
		    $('input, select').attr("disabled",'disabled');
		    $('#btn-alt, #btn-conc, #btn-canc').removeAttr("onclick");
		    $('#btn-alt, #btn-conc, #btn-canc').attr("disabled",'disabled');
		}

		function ajusteEditContrato(){
		    $('tbody tr').on("click");
		    $('#btn-nv').attr("onclick","novoContrato()");
		    $('#btn-nv').removeAttr("disabled",'disabled');
		    $('input, select').attr("disabled",'disabled');
		    $('#btn-conc, #btn-canc').removeAttr("onclick");
		    $('#btn-conc, #btn-canc').attr("disabled",'disabled');
		}

//============================== CONVENIADOS ==============================

		function confeditConveniado(){
    		modeledt.nome = $("#nome").val();
    		modeledt.percentualDesconto = parseFloat($("#desconto").val());
    		modeledt.eventoid = parseInt($("#eventoid").val());
        		$.ajax({
            		type: "PUT",
            		dataType: "json",
            		cache: false,
		            contentType:"application/json",    
        		    url: 'https://estacionamento-bruno-alcamin.c9users.io/alterarconveniado/'+modeledt.id,
            		data: JSON.stringify(modeledt),  
        		}).done(function(e){
           			limpaCamposConveniado();	
       				$("#tb").html("");
       				listarConveniado();
        		});
        		ajusteEditConveniado();
		}
		
		function limpaCamposConveniado(){
			$('input, select').val("");
		}
		
		
		function novoConveniado(){
    		$('tbody tr').off("click");
    		limpaCamposConveniado();
    		$('#btn-alt, #btn-nv').removeAttr("onclick");
    		$("input, select").removeAttr("disabled","disabled");
    		$('#btn-conc').attr("onclick","confirmarConveniado()");
    		$('#btn-canc').attr("onclick","cancelarConveniado()");
    		$('#btn-canc, #btn-conc').removeAttr("disabled",'disabled');
    		$('#btn-alt').attr("disabled",'disabled');
		}
		

		function cancelarConveniado(){
    		selecaoConveniado();
    		$('tbody tr').css('background-color','#fff');   
    		ajusteConveniado();
		}

		function cancelarEditConveniado(){
    		selecaoConveniado();
    		$("input, select").val("").attr("disabled", 'disabled');
    		ajusteEditConveniado();
		}
	
		function alterarConveniado(){
    		$('tbody tr').off("click");
    		$('#btn-nv').removeAttr("onclick");
    		$('#btn-nv').attr("disabled",'disabled');
    		$("input, select").removeAttr("disabled",'disabled');
    		$('#btn-conc').attr("onclick","confeditConveniado()");
    		$('#btn-canc').attr("onclick","cancelarEditConveniado()");
    		$('#btn-conc, #btn-canc').removeAttr("disabled",'disabled');
		}

		function excluirConveniado(x){
     		if(confirm("Confirma a exclusão do convênio "+$('button[onclick="excluirConveniado('+x+')"').parent().parent().find('span[id="nome"]').html()+"?")){
        		$.ajax({
        			type: 'DELETE',
        			dataType: "json",
        			cache: false,
        			contentType:"application/json",    
        			url: 'https://estacionamento-bruno-alcamin.c9users.io/deleteconveniado/'+x,
        		});
        		$("#tb, #t1 tbody").html("");
        		listarConveniado();
    		}
		}

		function selecaoConveniado(){
    		$('tbody tr').css('cursor','pointer');
        	$('tbody tr').click(function(){
            	$('#btn-alt').removeAttr("disabled",'disabled');
            	$('#btn-alt').attr("onclick","alterarConveniado()");
            	$('tbody tr').css('background-color','#fff');
            	$('tbody tr').removeAttr('select','select');
            	$(this).css('background-color','#76affd');
            	$(this).attr('select','select');
            	
            	$("#nome").val($(this).find('span[id="nome"]').html());
            	$("#desconto").val($(this).find('span[id="desconto"]').html());
            	$("#eventoid").val($(this).find('span[id="eventoid"]').html());
            	
            	modeledt = {"id":$(this).find('span[id="codigo"]').html(),"nome":$(this).find('span[id="nome"]').html(),
            		        "percentualDesconto":$(this).find('span[id="desconto"]').html() ,"eventoid":$(this).find('span[id="eventoid"]').html() };
    		});
		}
		
		function ajusteConveniado(){
		    $('tbody tr').on("click");
		    limpaCamposConveniado();
		    $('#btn-nv').attr("onclick","novoConveniado()");
		    $('input, select').attr("disabled",'disabled');
		    $('#btn-alt, #btn-conc, #btn-canc').removeAttr("onclick");
		    $('#btn-alt, #btn-conc, #btn-canc').attr("disabled",'disabled');
		}

		function ajusteEditConveniado(){
		    $('tbody tr').on("click");
		    $('#btn-nv').attr("onclick","novoConveniado()");
		    $('#btn-nv').removeAttr("disabled",'disabled');
		    $('input, select').attr("disabled",'disabled');
		    $('#btn-conc, #btn-canc').removeAttr("onclick");
		    $('#btn-conc, #btn-canc').attr("disabled",'disabled');
		}

//============================== EVENTO ==============================


		function confeditEvento(){
    		modeledt.descricao = $("#descricao").val();
    		modeledt.percentualDesconto = parseInt($("#desconto").val());
    		modeledt.contratoid = parseInt($("#contratoid").val());
        		$.ajax({
            		type: "PUT",
            		dataType: "json",
            		cache: false,
		            contentType:"application/json",    
        		    url: 'https://estacionamento-bruno-alcamin.c9users.io/alteraevento/'+modeledt.id,
            		data: JSON.stringify(modeledt),  
        		}).done(function(e){
           			limpaCamposEvento();	
       				$("#tb").html("");
       				listarEvento();
        		});
        		ajusteEditEvento();
		}
		
		function limpaCamposEvento(){
			$('input, select').val("");
		}
		
		
		function novoEvento(){
    		$('tbody tr').off("click");
    		limpaCamposEvento();
    		$('#btn-alt, #btn-nv').removeAttr("onclick");
    		$("input, select").removeAttr("disabled","disabled");
    		$('#btn-conc').attr("onclick","confirmarEvento()");
    		$('#btn-canc').attr("onclick","cancelarEvento()");
    		$('#btn-canc, #btn-conc').removeAttr("disabled",'disabled');
    		$('#btn-alt').attr("disabled",'disabled');
		}
		

		function cancelarEvento(){
    		selecaoEvento();
    		$('tbody tr').css('background-color','#fff');   
    		ajusteEvento();
		}

		function cancelarEditEvento(){
    		selecaoEvento();
    		$("input, select").val("").attr("disabled", 'disabled');
    		ajusteEditEvento();
		}
	
		function alterarEvento(){
    		$('tbody tr').off("click");
    		$('#btn-nv').removeAttr("onclick");
    		$('#btn-nv').attr("disabled",'disabled');
    		$("input, select").removeAttr("disabled",'disabled');
    		$('#btn-conc').attr("onclick","confeditEvento()");
    		$('#btn-canc').attr("onclick","cancelarEditEvento()");
    		$('#btn-conc, #btn-canc').removeAttr("disabled",'disabled');
		}


		function excluirEvento(x){
     		if(confirm("Confirma a exclusão do evento "+$('button[onclick="excluirEvento('+x+')"').parent().parent().find('span[id="nome"]').html()+"?")){
        		$.ajax({
        			type: 'DELETE',
        			dataType: "json",
        			cache: false,
        			contentType:"application/json",    
        			url: 'https://estacionamento-bruno-alcamin.c9users.io/deletaevento/'+x,
        		});
        		$("#tb, #t1 tbody").html("");
        		listarEvento();
    		}
		}

		function selecaoEvento(){
    		$('tbody tr').css('cursor','pointer');
        	$('tbody tr').click(function(){
            	$('#btn-alt').removeAttr("disabled",'disabled');
            	$('#btn-alt').attr("onclick","alterarEvento()");
            	$('tbody tr').css('background-color','#fff');
            	$('tbody tr').removeAttr('select','select');
            	$(this).css('background-color','#76affd');
            	$(this).attr('select','select');
            	
            	$("#descricao").val($(this).find('span[id="descricao"]').html());
            	$("#desconto").val($(this).find('span[id="desconto"]').html());
            	$("#contratoid").val($(this).find('span[id="contratoid"]').html());
            	
            	modeledt = {"id":$(this).find('span[id="codigo"]').html(), "descricao":$(this).find('span[id="descricao"]').html(),
            		        "percentualDesconto":parseInt($(this).find('span[id="desconto"]').html()) ,"contratoid":parseInt($(this).find('span[id="contratoid"]').html()) };
    		});
		}
		
		function ajusteEvento(){
		    $('tbody tr').on("click");
		    limpaCamposEvento();
		    $('#btn-nv').attr("onclick","novoEvento()");
		    $('input, select').attr("disabled",'disabled');
		    $('#btn-alt, #btn-conc, #btn-canc').removeAttr("onclick");
		    $('#btn-alt, #btn-conc, #btn-canc').attr("disabled",'disabled');
		}

		function ajusteEditEvento(){
		    $('tbody tr').on("click");
		    $('#btn-nv').attr("onclick","novoEvento()");
		    $('#btn-nv').removeAttr("disabled",'disabled');
		    $('input, select').attr("disabled",'disabled');
		    $('#btn-conc, #btn-canc').removeAttr("onclick");
		    $('#btn-conc, #btn-canc').attr("disabled",'disabled');
		}

//============================== AVULSO ==============================


		function excluirAvulso(x){
     		if(confirm("Confirma a exclusão do registro "+$('button[onclick="excluirAvulso('+x+')"').parent().parent().find('span[id="codigo"]').html()+"?")){
        		$.ajax({
        			type: 'DELETE',
        			dataType: "json",
        			cache: false,
        			contentType:"application/json",    
        			url: 'https://estacionamento-bruno-alcamin.c9users.io/deleteavulso/'+x,
        		});
        		$("#tb, #t1 tbody").html("");
        		listarAvulso();
    		}
		}

		function limpaCamposAvulso(){
			$('input, select').val("");
		}
		
//============================== TIPO DE VEÍCULO ==============================


		function excluirTipoVeiculo(x){
     		if(confirm("Confirma a exclusão do Tipo de veiculo "+$('button[onclick="excluirTipoVeiculo('+x+')"').parent().parent().find('span[id="nm"]').html()+"?")){
        		$.ajax({
        			type: 'DELETE',
        			dataType: "json",
        			cache: false,
        			contentType:"application/json",    
        			url: 'https://estacionamento-bruno-alcamin.c9users.io/tipoveiculodelete/'+x,
        		});
        		$("#tb").html("");
        		$("#t1 tbody").html("");
        		listarTipoVeiculo();
    		}
		}

		function selecaoTipoVeiculo(){
    		$('tbody tr').css('cursor','pointer');
        	$('tbody tr').click(function(){
            	$('#btn-alt').removeAttr("disabled",'disabled');
            	$('#btn-alt').attr("onclick","alterarTipoVeiculo()");
            	$('tbody tr').css('background-color','#fff');
            	$('tbody tr').removeAttr('select','select');
            	$(this).css('background-color','#76affd');
            	$(this).attr('select','select');
            	$("#nome").val($(this).find('span[id="nm"]').html());
            	modeledt = {"id":$(this).find('span[id="cd"]').html(),"nome":$(this).find('span[id="nm"]').html()};
    		});
		}
		
		function ajusteTipoVeiculo(){
		    $('tbody tr').on("click");
		    limpaCamposTipoVeiculo();
		    $('#btn-nv').attr("onclick","novoTipoVeiculo()");
		    $("#nome").attr("disabled","disabled");
		    $('#btn-alt').removeAttr("onclick");
		    $('#btn-alt').attr("disabled",'disabled');
		    $('#btn-conc').attr("disabled",'disabled');
		    $('#btn-canc').attr("disabled",'disabled');
		    $('#btn-conc').removeAttr("onclick");
		    $('#btn-canc').removeAttr("onclick");
		}

		function ajusteEditTipoVeiculo(){
		    $('tbody tr').on("click");
		    $('#btn-nv').attr("onclick","novoTipoVeiculo()");
		    $('#btn-nv').removeAttr("disabled",'disabled');
		    $("#nome").attr("disabled","disabled");
		    $('#btn-conc').removeAttr("onclick");
		    $('#btn-canc').removeAttr("onclick");
		    $('#btn-conc').attr("disabled",'disabled');
		    $('#btn-canc').attr("disabled",'disabled');
		}


		function confeditTipoVeiculo(){
    		modeledt.nome = $("#nome").val();
        		$.ajax({
            		type: "PUT",
            		dataType: "json",
            		cache: false,
		            contentType:"application/json",    
        		    url: 'https://estacionamento-bruno-alcamin.c9users.io/tipoveiculoupdate/'+modeledt.id,
            		data: JSON.stringify(modeledt),  
        		}).done(function(e){
           			limpaCamposTipoVeiculo();	
       				$("#tb").html("");
       				listarTipoVeiculo();
        		});
        		ajusteEditTipoVeiculo();
		}
		
		function limpaCamposTipoVeiculo(){
			$("#nome").val("");
		}
		
		
		function novoTipoVeiculo(){
    		$('tbody tr').off("click");
    		limpaCamposTipoVeiculo();
    		$('#btn-alt').removeAttr("onclick");
    		$('#btn-nv').removeAttr("onclick");
    		$("#nome").removeAttr("disabled","disabled");
    		$('#btn-conc').attr("onclick","confirmarTipoVeiculo()");
    		$('#btn-canc').attr("onclick","cancelarTipoVeiculo()");
    		$('#btn-canc').removeAttr("disabled",'disabled');
    		$('#btn-conc').removeAttr("disabled",'disabled');
    		$('#btn-alt').attr("disabled",'disabled');
		}
		

		function cancelarTipoVeiculo(){
    		selecaoTipoVeiculo();
    		$('tbody tr').css('background-color','#fff');   
    		ajusteTipoVeiculo();
		}

		function cancelarEditTipoVeiculo(){
    		selecaoTipoVeiculo();
    		$("#nome").val($('tr[select="select"]').find('span[id="nm"]').html());
    		ajusteEditTipoVeiculo();
		}
	
		function alterarTipoVeiculo(){
    		$('tbody tr').off("click");
    		$('#btn-nv').removeAttr("onclick");
    		$('#btn-nv').attr("disabled",'disabled');
    		$("#nome").removeAttr("disabled","disabled");
    		$('#btn-conc').attr("onclick","confeditTipoVeiculo()");
    		$('#btn-canc').attr("onclick","cancelarEditTipoVeiculo()");
    		$('#btn-conc').removeAttr("disabled",'disabled');
    		$('#btn-canc').removeAttr("disabled",'disabled');
		}

//============================== VEÍCULO ==============================


		function excluirVeiculo(x){
     		if(confirm("Confirma a exclusão do Veiculo com a placa "+$('button[onclick="excluirVeiculo('+x+')"').parent().parent().find('span[id="pl"]').html()+"?")){
        		$.ajax({
        			type: 'DELETE',
        			dataType: "json",
        			cache: false,
        			contentType:"application/json",    
        			url: 'https://estacionamento-bruno-alcamin.c9users.io/veiculodelete/'+x,
        		});
        		$("#tb").html("");
        		$("#t1 tbody").html("");
        		listarVeiculo();
    		}
		}

		function selecaoVeiculo(){
    		$('tbody tr').css('cursor','pointer');
        	$('tbody tr').click(function(){
            	$('#btn-alt').removeAttr("disabled",'disabled');
            	$('#btn-alt').attr("onclick","alterarVeiculo()");
            	$('tbody tr').css('background-color','#fff');
            	$('tbody tr').removeAttr('select','select');
            	$(this).css('background-color','#76affd');
            	$(this).attr('select','select');
            	$("#placa").val($(this).find('span[id="pl"]').html());
            	$("#clienteid").val($(this).find('span[id="cdcli"]').html());
				$("#descricao").val($(this).find('span[id="dsc"]').html());
				$("#marca").val($(this).find('span[id="mc"]').html());
				$("#ano").val($(this).find('span[id="aa"]').html());
				$("#cor").val($(this).find('span[id="cr"]').html());
				$("#tipoveiculoid").val($(this).find('span[id="cdtv"]').html());
            	modeledt = {"id":$(this).find('span[id="cd"]').html(),"placa":$(this).find('span[id="pl"]').html(),"clienteid":$(this).find('span[id="cdcli"]').html(),"descricao":$(this).find('span[id="dsc"]').html(),"marca":$(this).find('span[id="mc"]').html(),"ano":$(this).find('span[id="aa"]').html(),"cor":$(this).find('span[id="cr"]').html(),"tipoveiculoid":$(this).find('span[id="cdtv"]').html()};
    		});
		}
		
		function ajusteVeiculo(){
		    $('tbody tr').on("click");
		    limpaCamposVeiculo();
		    $('#btn-nv').attr("onclick","novoVeiculo()");
		    $("input, select").attr("disabled","disabled");
		    $('#btn-alt').removeAttr("onclick");
		    $('#btn-alt, #btn-conc, #btn-canc').attr("disabled",'disabled');
		    $('#btn-conc, #btn-canc').removeAttr("onclick");
		}

		function ajusteEditVeiculo(){
		    $('tbody tr').on("click");
		    $('#btn-nv').attr("onclick","novoVeiculo()");
		    $('#btn-nv').removeAttr("disabled",'disabled');
			$("input, select").attr("disabled","disabled");
		    $('#btn-canc, #btn-conc').removeAttr("onclick");
		    $('#btn-canc, #btn-conc').attr("disabled",'disabled');
		}

		function confeditVeiculo(){
    		modeledt.placa = $("#placa").val();
    		modeledt.clienteid = parseInt($("#clienteid").val());
    		modeledt.descricao = $("#descricao").val();
    		modeledt.marca = $("#marca").val();
    		modeledt.ano = $("#ano").val();
    		modeledt.cor = $("#cor").val();	
    		modeledt.tipoveiculoid = parseInt($("#tipoveiculoid").val());	
        		$.ajax({
            		type: "PUT",
            		dataType: "json",
            		cache: false,
		            contentType:"application/json",    
        		    url: 'https://estacionamento-bruno-alcamin.c9users.io/veiculoupdate/'+modeledt.id,
            		data: JSON.stringify(modeledt),  
        		}).done(function(e){
           			limpaCamposVeiculo();	
       				$("#tb").html("");
       				listarVeiculo();
        		});
        		ajusteEditVeiculo();
		}
		
		function limpaCamposVeiculo(){
			$("input").val("");
			$("select").val("1");
		}
		
		function novoVeiculo(){
    		$('tbody tr').off("click");
    		limpaCamposVeiculo();
    		$('#btn-alt, #btn-nv').removeAttr("onclick");
    		$("input, select").removeAttr("disabled","disabled");
    		$('#btn-conc').attr("onclick","confirmarVeiculo()");
    		$('#btn-canc').attr("onclick","cancelarVeiculo()");
    		$('#btn-canc, #btn-conc').removeAttr("disabled",'disabled');
    		$('#btn-alt').attr("disabled",'disabled');
		}
		
		function cancelarVeiculo(){
    		selecaoVeiculo();
    		$('tbody tr').css('background-color','#fff');   
    		ajusteVeiculo();
		}

		function cancelarEditVeiculo(){
    		selecaoVeiculo();
    		$("#placa").val($('tr[select="select"]').find('span[id="pl"]').html());
			$("#clienteid").val($('tr[select="select"]').find('span[id="cdcli"]').html());
			$("#descricao").val($('tr[select="select"]').find('span[id="dsc"]').html());
			$("#marca").val($('tr[select="select"]').find('span[id="mc"]').html());
			$("#ano").val($('tr[select="select"]').find('span[id="aa"]').html());
			$("#cor").val($('tr[select="select"]').find('span[id="cr"]').html());
			$("#tipoveiculoid").val($('tr[select="select"]').find('span[id="cdtv"]').html());
    		ajusteEditVeiculo();
		}
	
		function alterarVeiculo(){
    		$('tbody tr').off("click");
    		$('#btn-nv').removeAttr("onclick");
    		$('#btn-nv').attr("disabled",'disabled');
    		$("input, select").removeAttr("disabled","disabled");
    		$('#btn-conc').attr("onclick","confeditVeiculo()");
    		$('#btn-canc').attr("onclick","cancelarEditVeiculo()");
    		$('#btn-conc, #btn-canc').removeAttr("disabled",'disabled');
    		$("#cnpj").attr("disabled","disabled");
		}

//============================== FUNCIONÁRIO ==============================

    function novoFuncionario(){
    	$("tbody tr").off("click");
    	$("#btn-nv").removeAttr("onclick").attr("disabled","disabled");
    	limpaCamposFuncionario();
    	$("#btn-alt, #btn-nv").removeAttr("onclick");
    	$("input, select, #btn-canc, #btn-conc").removeAttr("disabled","disabled");
    	$("#btn-conc").attr("onclick","confirmarFuncionario()");
    	$("#btn-canc").attr("onclick","cancelarFuncionario()");
    	$("#btn-alt").attr("disabled","disabled");
	}
	
	function alterarFuncionario(){
    		$("tbody tr").off("click");
    		$("#btn-nv").removeAttr("onclick").attr("disabled","disabled");
			$("#senha, #FuncionarioAtivo, #tbody1, #btn-conc, #btn-canc").removeAttr("disabled","disabled");
    		$("#btn-conc").attr("onclick","confeditFuncionario()");
    		$("#btn-canc").attr("onclick","cancelarEditFuncionario()");
	}
	
	function confeditFuncionario(){
    	modeledt.senha = $("#senha").val();
    	modeledt.ativo = $("#FuncionarioAtivo").val();
    	$.ajax({
       		type: "PUT",
       		dataType: "json",
       		cache: false,
	        contentType:"application/json",    
    	    url: 'https://estacionamento-bruno-alcamin.c9users.io/alterafuncionario/'+modeledt.id,
      		data: JSON.stringify(modeledt),  
    	}).done(function(e){
    		limpaCamposFuncionario();
    		$("#tbody1").html("");
    		listarFuncionario();
       	});
       	ajusteEditFuncionario();
	}
	
	function cancelarEditFuncionario(){
    	selecaoFuncionario();
    	$("#nome").val($('tr[select="select"]').find('span[id="nomeFuncionario"]').html());
		$("#senha").val($('tr[select="select"]').find('span[id="senhaFuncionario"]').html());
		$("#FuncionarioAtivo").val($('tr[select="select"]').find('span[id="atFuncionario"]').html());
    	ajusteEditFuncionario();
	}
	
	function cancelarFuncionario(){
    	selecaoFuncionario();
    	$("tbody tr").css("background-color","#fff");   
    	ajusteFuncionario();
	}
	
	function selecaoFuncionario(){
    	$("tbody tr").css("cursor","pointer");
       	$("tbody tr").click(function(){
         	$("#btn-alt").removeAttr("disabled","disabled").attr("onclick","alterarFuncionario()");
           	$("tbody tr").css("background-color","#fff").removeAttr("select","select");
           	$(this).css("background-color","#76affd");
           	$(this).attr("select","select");
           	$("#nome").val($(this).find('span[id="nomeFuncionario"]').html());
           	$("#senha").val($(this).find('span[id="senhaFuncionario"]').html());
			$("#FuncionarioAtivo").val($(this).find('span[id="atFuncionario"]').html());
           	modeledt = {"id":$(this).find('span[id="idFuncionario"]').html(),"nome":$(this).find('span[id="nomeFuncionario"]').html(),"senha":$(this).find('span[id="senhaFuncionario"]').html(),"ativo":$(this).find('span[id="atFuncionario"]').html()};
    	});
	}
	
    function ajusteFuncionario(){
	    $("tbody tr").on("click");
	    limpaCamposFuncionario();
	    $("#btn-nv").attr("onclick","novoFuncionario()").removeAttr("disabled","disabled");
	    $("#nome, #senha, #FuncionarioAtivo, #tbody1").attr("disabled","disabled");
	    $("#btn-alt, #btn-conc, #btn-canc").removeAttr("onclick");
	    $("#btn-alt, #btn-conc, #btn-canc").attr("disabled","disabled");
    }
    
    function ajusteEditFuncionario(){
	    $("tbody tr").on("click");
	    $("#btn-nv").attr("onclick","novoFuncionario()");
	    $("#btn-nv").removeAttr("disabled","disabled");
	    $("#nome, #senha, #FuncionarioAtivo, #tbody1, #btn-conc, #btn-canc").attr("disabled","disabled");
	    $("#btn-conc, #btn-canc").removeAttr("onclick");
	}
	
    function limpaCamposFuncionario(){
		$("#nome, #senha").val("");
		$("#FuncionarioAtivo").val("true");
	}

//============================== VAGA VALOR ==============================

	
	function cancelarEditVagaValor(){
    	selecaoVagaValor();
    	$("input[name='diurno']").val($('tr[select="select"]').find('span[id="valordiurno"]').html());
		$("input[name='noturno']").val($('tr[select="select"]').find('span[id="valornoturno"]').html());
		$("#funcionario").val($('tr[select="select"]').find('span[id="idFuncionario"]').html());
    	ajusteEditVagaValor();
	}
	
	function cancelarVagaValor(){
    	selecaoVagaValor();
    	$("tbody tr").css("background-color","#fff");
    	$("#funcionario").val("0");
    	ajusteVagaValor();
	}
	
	function selecaoVagaValor(){
    	$("tbody tr").css("cursor","pointer");
       	$("tbody tr").click(function(){
         	$("#btn-alt").removeAttr("disabled","disabled").attr("onclick","alterarVagaValor()");
           	$("tbody tr").css("background-color","#fff").removeAttr("select","select");
           	$(this).css("background-color","#76affd");
           	$(this).attr("select","select");
           	$("input[name='diurno']").val($(this).find('span[id="valordiurno"]').html());
           	$("input[name='noturno']").val($(this).find('span[id="valornoturno"]').html());
			$("#funcionario").val($(this).find('span[id="idFuncionario"]').html());
           	modeledt = {"vagavalorid":parseInt($(this).find('span[id="idVagaValor"]').html()),
           				"vldiurnoantigo":parseFloat($(this).find('span[id="valordiurno"]').html()),
           				"vlnoturnoantigo":parseFloat($(this).find('span[id="valornoturno"]').html()),
           				"vldiurnonovo":$(this).find('span[id="valordiurno"]').html(),
           				"vlnoturnonovo":$(this).find('span[id="valornoturno"]').html(),
           				"dataalteracao":null,
           				"funcionarioid":parseInt($(this).find('span[id="idFuncionario"]').html())};
    	});
	}
	
    function ajusteVagaValor(){
	    $("tbody tr").on("click");
	    limpaCampos();
	    $("#btn-nv").attr("onclick","novoVagaValor()").removeAttr("disabled","disabled");
	    $("input[name='diurno'], input[name='noturno'], #funcionario, #tbody1").attr("disabled","disabled");
	    $("#btn-alt, #btn-conc, #btn-canc").removeAttr("onclick");
	    $("#btn-alt, #btn-conc, #btn-canc").attr("disabled","disabled");
    }
    
    function ajusteEditVagaValor(){
	    $("tbody tr").on("click");
	    $("#btn-nv").attr("onclick","novoVagaValor()");
	    $("#btn-nv").removeAttr("disabled","disabled");
	    $("input[name='diurno'], input[name='noturno'], #funcionario, #tbody1, #btn-conc, #btn-canc").attr("disabled","disabled");
	    $("#btn-conc, #btn-canc").removeAttr("onclick");
	}
	
    function limpaCamposVagaValor(){
		$("#senha, input[name='diurno'], input[name='noturno'], #funcionario").val("");
	}
	
    
    function novoVagaValor(){
    	$("tbody tr").off("click");
    	$("#btn-nv").removeAttr("onclick").attr("disabled","disabled");
    	limpaCamposVagaValor();
    	$("#btn-alt, #btn-nv").removeAttr("onclick");
    	$("input[name='diurno'], input[name='noturno'], #funcionario, #tbody1, #btn-canc, #btn-conc").removeAttr("disabled","disabled");
    	$("#btn-conc").attr("onclick","confirmarVagaValor()");
    	$("#btn-canc").attr("onclick","cancelarVagaValor()");
    	$("#btn-alt").attr("disabled","disabled");
	}
	
	function alterarVagaValor(){
    	$("tbody tr").off("click");
    	$("#btn-nv").removeAttr("onclick").attr("disabled","disabled");
		$("input[name='diurno'], input[name='noturno'], #funcionario, #tbody1, #btn-conc, #btn-canc").removeAttr("disabled","disabled");
    	$("#btn-conc").attr("onclick","confeditVagaValor()");
    	$("#btn-canc").attr("onclick","cancelarEditVagaValor()");
	}

//============================== VAGA ==============================

    
    function novoVaga(){
    	$("tbody tr").off("click");
    	$("#btn-nv").removeAttr("onclick").attr("disabled","disabled");
    	limpaCamposVaga();
    	$("#btn-alt, #btn-nv").removeAttr("onclick");
    	$("input, select, #tbody1, #btn-canc, #btn-conc").removeAttr("disabled","disabled");
    	$("#btn-conc").attr("onclick","confirmarVaga()");
    	$("#btn-canc").attr("onclick","cancelarVaga()");
    	$("#btn-alt").attr("disabled","disabled");
	}
	
	function alterarVaga(){
    	$("tbody tr").off("click");
    	$("#btn-nv, #btn-alt").removeAttr("onclick").attr("disabled","disabled");
		$("input, select, #tbody1, #btn-conc, #btn-canc").removeAttr("disabled","disabled");
    	$("#btn-conc").attr("onclick","confeditVaga()");
    	$("#btn-canc").attr("onclick","cancelarEditVaga()");
	}
	
	function confeditVaga(){
	    modeledt.diurno = $("#optDiurno").val();
    	modeledt.noturno = $("#optNoturno").val();
    	modeledt.vagavalorid = parseInt($("#vagaValor").val());
    	$.ajax({
       		type: "PUT",
       		dataType: "json",
       		cache: false,
	        contentType:"application/json",    
    	    url: "https://estacionamento-bruno-alcamin.c9users.io/alteravaga/"+modeledt.id,
      		data: JSON.stringify(modeledt),  
    	}).done(function(e){
    		limpaCamposVaga();
    		$("#tbody1").html("");
    		listarVaga();
       	});
       	ajusteEditVaga();
	}
	
	function cancelarEditVaga(){
    	selecaoVaga();
    	$("#vaga").val($('tr[select="select"]').find('span[id="idVaga"]').html());
    	$("#optDiurno").val($('tr[select="select"]').find('span[id="diurno"]').html());
		$("#optNoturno").val($('tr[select="select"]').find('span[id="noturno"]').html());
		$("#vagaValor").val($('tr[select="select"]').find('span[id="idVagaValor"]').html());
    	ajusteEditVaga();
	}
	
	function cancelarVaga(){
    	selecaoVaga();
    	$("tbody tr").css("background-color","#fff");   
    	ajusteVaga();
	}
	
	function selecaoVaga(){
    	$("tbody tr").css("cursor","pointer");
       	$("tbody tr").click(function(){
         	$("#btn-alt").removeAttr("disabled","disabled").attr("onclick","alterarVaga()");
           	$("tbody tr").css("background-color","#fff").removeAttr("select","select");
           	$(this).css("background-color","#76affd");
           	$(this).attr("select","select");
           	$("#vaga").val($(this).find('span[id="idVaga"]').html());
           	$("#optDiurno").val($(this).find('span[id="diurno"]').html());
           	$("#optNoturno").val($(this).find('span[id="noturno"]').html());
			$("#vagaValor").val($(this).find('span[id="idVagaValor"]').html());
           	modeledt = {"id":$(this).find('span[id="idVaga"]').html(),"diurno":$(this).find('span[id="diurno"]').html(),"noturno":$(this).find('span[id="noturno"]').html(),"idVagaValor":$(this).find('span[id="idVagaValor"]').html()};
    	});
	}
	
    function ajusteVaga(){
	    $("tbody tr").on("click");
	    limpaCamposVaga();
	    $("#btn-nv").attr("onclick","novoVaga()").removeAttr("disabled","disabled");
	    $("input, select, #tbody1").attr("disabled","disabled");
	    $("#btn-alt, #btn-conc, #btn-canc").removeAttr("onclick");
	    $("#btn-alt, #btn-conc, #btn-canc").attr("disabled","disabled");
    }
    
    function ajusteEditVaga(){
	    $("tbody tr").on("click");
	    $("#btn-nv").attr("onclick","novoVaga()").removeAttr("disabled","disabled");
	    $("input, select, #tbody1, #btn-conc, #btn-canc").attr("disabled","disabled");
	    $("#btn-conc, #btn-canc").removeAttr("onclick");
	}
	
    function limpaCamposVaga(){
		$("input, select").val("");
	}


//==============================================================