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