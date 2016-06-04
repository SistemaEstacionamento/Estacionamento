{-# LANGUAGE OverloadedStrings, QuasiQuotes,
             TemplateHaskell #-}
 
module Handlers where
import Import
import Yesod
import Foundation
import Control.Monad.Logger (runStdoutLoggingT)
import Control.Applicative
import Data.Text

import Database.Persist.Postgresql


mkYesodDispatch "Sitio" pRoutes

getClientR :: Handler Html
getClientR = defaultLayout $ do
  setTitle "Sistema Estacionamento | Cadastrar Cliente"
  addScriptRemote "https://ajax.googleapis.com/ajax/libs/jquery/1.12.0/jquery.min.js"
  addStylesheetRemote "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css"
  [whamlet|
<h1>Cadastrar Cliente
<div .container>  
    <div id="formulario" .col-md-12 .col-lg-12>
        
        <button id="btn-nv" .btn .btn-default >Novo</button>
        <button id="btn-alt" .btn .btn-default>Alterar</button>
        <br><br>
            
        <form .form-horizontal>
            <div .control-group>
                <label .control-label for="flcliente">Tipo: 
                    <div .controls>
                        <select id="flcliente"><option value="f"> Fisico </option><option value="j"> Juridico </option></select>
            
            <div .fisico .control-group>
                <label .control-label for="nome">Nome: 
                    <div .controls>
                        <input type="text" id="nome">
                        
            <div .fisico .control-group>
                <label .control-label for="rg">RG: 
                    <div .controls>
                        <input type="text" id="rg">
                        
            <div .fisico .control-group>
                <label .control-label for="sexo">Sexo: 
                    <div .controls>
                        <input type="text" id="sexo">
                        
            <div .fisico .control-group>
                <label .control-label for="cpf">CPF: 
                    <div .controls>
                        <input type="text" id="cpf">
                
            <div .juridico .control-group>
                <label .control-label for="cnpj">CNPJ: 
                    <div .controls>
                        <input type="text" id="cnpj">
                        
            <div .juridico .control-group>
                <label .control-label for="razaosocial">Razão Social: 
                    <div .controls>
                        <input type="text" id="razaosocial">
            
            <div .endereco .control-group>    
                <label .control-label for="telefone">Telefone:
                    <div .controls>
                        <input type="text" id="telefone">
                        
            <div .endereco .control-group>    
                <label .control-label for="logradouro">Logradouro:
                    <div .controls>
                        <input type="text" id="logradouro">
                        
            <div .endereco .control-group>    
                <label .control-label for="cidade">Cidade:
                    <div .controls>
                        <input type="text" id="cidade">
                        
            <div .endereco .control-group>    
                <label .control-label for="estado">Estado:
                    <div .controls>
                        <input type="text" id="estado">
                        
            <div .endereco .control-group>    
                <label .control-label for="bairro">Bairro:
                    <div .controls>
                        <input type="text" id="bairro">
                        
            <div .endereco .control-group>    
                <label .control-label for="cep">CEP:
                    <div .controls>
                        <input type="text" id="cep" .form-control>
            
            <br>
        <div .form-group  .col-md-12 .col-lg-12>    
            <button id="btn-canc" .btn .btn-danger>Cancelar</button>
            <button id="btn-conc" .btn .btn-success>Confirmar</button>

    <div id="tabela" .col-md-12 .col-lg-12>
        <table id="t1">
            <thead>
                <tr>
                    <th>ID
                    <th>Nome
                    <th>Telefone
            <tbody id="tb">
  |] 
  toWidget [julius|
  
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
  
  		$(listar());
		var modeledt = {};
		function confirmar(){
            $.ajax({
                 contentType: "application/json",
                 url: "@{ClientR}",
                 type: "POST",
                 data: JSON.stringify({"nome":$("#nome").val(),"flcliente":$("#flcliente").val(),"telefone":$("#telefone").val(),"rg":$("#rg").val(),"sexo":$("#sexo").val(),"cpf":$("#cpf").val(),"cnpj":$("#cnpj").val(),"razaosocial":$("#razaosocial").val(),"logradouro":$("#logradouro").val(),"cidade":$("#cidade").val(),"estado":$("#estado").val(),"bairro":$("#bairro").val(),"cep":$("#cep").val()}),
                 success: function(){
					$("#nome, #telefone, #rg, #sexo, #cpf, #cnpj, #razaosocial, #logradouro, #cidade, #estado, #bairro, #cep").val("");
					$("#flcliente").val("f");
       				$("#tb").html("");
       				listar();
                 }
            });
        	ajuste();
        	$('tbody tr').css('background-color','#fff');   
		}

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

		function listar(){
    		ajuste();
    		var itens = "";
   			$.ajax({
				contentType: "application/json",
                url: "@{ListaR}",
                type: "GET",
    		}).done(function(e){
            		for(var i = 0; i<e.data.length; i++){
                		itens+="<tr><td>";
                		itens+="<span id='cd'>"
                		itens+=e.data[i].id;
                		itens+="</span>"
                		itens+="</td><td class='nomeprod'>";
            	    	itens+="<span id='nm'>"
                		itens+=e.data[i].nome;
                		itens+="</span>"
            	    	itens+="</td><td>";
        	        	itens+="<span id='tl'>"
                		itens+=e.data[i].telefone;
    	            	itens+="</span>"
	                	itens+="</td><td>";
			            itens+="<button onclick='excluir("+e.data[i].id+")'>Excluir</button>";
			            itens+="</td>";
			            itens+="<td style='position: absolute; top: 22%; left: 80000000%'>";
			            itens+="<span id='ba' style='text-indent:-1000000px'>"
			            itens+=e.data[i].bairro;
			            itens+="</span>"
			            itens+="<span id='cp' style='text-indent:-1000000px'>"
			            itens+=e.data[i].cep;
			            itens+="</span>"
			            itens+="<span id='cdd' style='text-indent:-1000000px'>"
			            itens+=e.data[i].cidade;
			            itens+="</span>"
			            itens+="<span id='cpj' style='text-indent:-1000000px'>"
			            itens+=e.data[i].cnpj;
			            itens+="</span>"
			            itens+="<span id='cf' style='text-indent:-1000000px'>"
			            itens+=e.data[i].cpf;
			            itens+="</span>"
			            itens+="<span id='est' style='text-indent:-1000000px'>"
			            itens+=e.data[i].estado;
			            itens+="</span>"
			            itens+="<span id='flc' style='text-indent:-1000000px'>"
			            itens+=e.data[i].flcliente;
			            itens+="</span>"
			            itens+="<span id='log' style='text-indent:-1000000px'>"
			            itens+=e.data[i].logradouro;
			            itens+="</span>"
			            itens+="<span id='raz' style='text-indent:-1000000px'>"
			            itens+=e.data[i].razaosocial;
			            itens+="</span>"
			            itens+="<span id='gr' style='text-indent:-1000000px'>"
			            itens+=e.data[i].rg;
			            itens+="</span>"
			            itens+="<span id='sx' style='text-indent:-1000000px'>"
			            itens+=e.data[i].sexo;
			            itens+="</span>"
			            itens+="</td>";
			            itens+="</tr>";
                	}
                	$("#tb").html(itens);
				    $("#t1 tbody").html(itens);
				    selecao();
    		});
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
  |] >> toWidget [lucius|
  	h1{
  		margin-left: 5%;
  		font-weight: bold;
  	}
  	
  	.container,
  	#formulario, 
  	#tabela {
  		margin: 2% auto;
  		padding: 1% 1% 1% 1%;
  	}
  	
  	#formulario {
  		padding: 2% 2% 2% 2%;
  		--background-color: #ddd;
  	}
  |]


--CONTRATO

getContratoR :: Handler Html
getContratoR = defaultLayout $ do
  setTitle "Sistema Estacionamento | Cadastrar Contrato"
  addScriptRemote "https://ajax.googleapis.com/ajax/libs/jquery/1.12.0/jquery.min.js"
  addStylesheetRemote "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css"
  [whamlet|
<h1>Cadastrar Contrato
<div .container>  
    <div id="formulario" .col-md-12 .col-lg-12>
        
        <button id="btn-nv" .btn .btn-default >Novo</button>
        <button id="btn-alt" .btn .btn-default>Alterar</button>
        <br><br>
        
        <form .form-horizontal role="form">
        
            <div .form-group>
                <label .control-label .col-md-2 for="valor">Valor: 
                <div .col-md-5 .input-group>
                    <span .input-group-addon>R$
                    <input .form-control type="number" id="valor">
                        
            <div .form-group>
                <label .control-label .col-md-2 for="inic">Início: 
                <div .col-md-5>
                    <input .form-control type="date" id="inic">
                        
            <div .form-group>
                <label .control-label .col-md-2 for="fim">Fim: 
                <div .col-md-5>
                    <input .form-control type="date" id="fim">
                        
            <div .form-group>
                <label .control-label .col-md-2 for="qtparcelas">Quantidade de Parcelas: 
                <div .col-md-5>
                    <input .form-control type="number" id="qtparcelas">
                
            <div .form-group>
                <label .control-label .col-md-2 for="qtvagas">Quantidade de Vagas: 
                <div .col-md-5>
                    <input .form-control type="number" id="qtvagas">
                        
            <div .form-group>
                <label .control-label .col-md-2 for="clienteid">Cliente: 
                <div .col-md-5>
                    <select .form-control id="clienteid"></select>
                        
            <br>
        <div .form-group  .col-md-12 .col-lg-12>    
            <button id="btn-canc" .btn .btn-danger>Cancelar</button>
            <button id="btn-conc" .btn .btn-success>Confirmar</button>

    <div id="tabela" .col-md-12 .col-lg-12>
        <table id="t1" .text-center>
            <thead>
                <tr>
                    <th>ID
                    <th>Valor
                    <th>Início
                    <th>Fim
                    <th>Parcelas
                    <th>Qt.Vagas
                    <th>Cliente
            <tbody id="tb">
  
|] >> toWidget [lucius|
  	h1{
  		margin-left: 5%;
  		font-weight: bold;
  	}
  	
  	.container,
  	#formulario, 
  	#tabela {
  		margin: 2% auto;
  		padding: 1% 1% 1% 1%;
  	}
  	
  	#formulario {
  		padding: 2% 2% 2% 2%;
  	}
  	
|] >> toWidget [julius|
     
    	$(listar());
    	$(listarClientes());
		var modeledt = {};
		
		function confirmar(){
			
            $.ajax({
                 contentType: "application/json",
                 url: "@{ContratoR}",
                 type: "POST",
                 data: JSON.stringify({"valor":parseFloat($("#valor").val()), 
                                       "contratoinc":$("#inic").val(),
                                       "contratofim":$("#fim").val(),
                                       "quantidadeparcela":parseInt($("#qtparcelas").val()),
                                       "quantidadevagas":parseInt($("#qtvagas").val()),
                                       "clienteid":parseInt($("#clienteid").val())}),
                 success: function(){
                	
					limpaCampos();	
					listar();
                 },
                 error: function(){
                 	alert("ERRO!");
                 }
            });
        	ajuste();
        	$('tbody tr').css('background-color','#fff');   
		}

		function confedit(){
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
           			limpaCampos();	
       				$("#tb").html("");
       				listar();
        		});
        		ajusteEdit();
		}
		
		function limpaCampos(){
			$('input, select').val("");
		}
		
		
		function novo(){
    		$('tbody tr').off("click");
    		limpaCampos();
    		$('#btn-alt, #btn-nv').removeAttr("onclick");
    		$("input, select").removeAttr("disabled","disabled");
    		$('#btn-conc').attr("onclick","confirmar()");
    		$('#btn-canc').attr("onclick","cancelar()");
    		$('#btn-canc, #btn-conc').removeAttr("disabled",'disabled');
    		$('#btn-alt').attr("disabled",'disabled');
		}
		

		function cancelar(){
    		selecao();
    		$('tbody tr').css('background-color','#fff');   
    		ajuste();
		}

		function cancelarEdit(){
    		selecao();
    		$("input, select").val("").attr("disabled", 'disabled');
    		ajusteEdit();
		}
	
		function alterar(){
    		$('tbody tr').off("click");
    		$('#btn-nv').removeAttr("onclick");
    		$('#btn-nv').attr("disabled",'disabled');
    		$("input, select").removeAttr("disabled",'disabled');
    		$('#btn-conc').attr("onclick","confedit()");
    		$('#btn-canc').attr("onclick","cancelarEdit()");
    		$('#btn-conc, #btn-canc').removeAttr("disabled",'disabled');
		}

		function listar(){
			ajuste();
    		var itens = "";
			$.ajax({
				contentType: "application/json",
                url: "@{ListaContratoR}",
                type: "GET",
    		}).done(function(e){
            		for(var i = 0; i<e.data.length; i++){
                		itens+="<tr><td>";
                		itens+="<span id='codigo'>"
                		itens+=e.data[i].id;
                		itens+="</span>"
                		itens+="</td><td>";
            	    	itens+="<span id='valor'>"
                		itens+=e.data[i].valor;
                		itens+="</span>"
                		itens+="</td><td>";
                		itens+="<span id='inic'>"
                		itens+=e.data[i].contratoinc;
                		itens+="</span>"
                		itens+="</td><td>";
                		itens+="<span id='fim'>"
                		itens+=e.data[i].contratofim;
                		itens+="</span>"
                		itens+="</td><td>";
                		itens+="<span id='qtparcelas'>"
                		itens+=e.data[i].quantidadeparcela;
                		itens+="</span>"
                		itens+="</td><td>";
                		itens+="<span id='qtvagas'>"
                		itens+=e.data[i].quantidadevagas;
                		itens+="</span>"
                		itens+="</td><td>";
                		itens+="<span id='clienteid'>"
                		itens+=e.data[i].clienteid;
                		itens+="</span>"
                		itens+="</td><td>";
            	      	itens+="<button onclick='excluir("+e.data[i].id+")'>Excluir</button>";
			            itens+="</td></tr>";
                	}
                	$("#tb").html(itens);
                	selecao();
			});
		}

		function excluir(x){
     		if(confirm("Confirma a exclusão do contrato "+$('button[onclick="excluir('+x+')"').parent().parent().find('span[id="codigo"]').html()+"?")){
        		$.ajax({
        			type: 'DELETE',
        			dataType: "json",
        			cache: false,
        			contentType:"application/json",    
        			url: 'https://estacionamento-bruno-alcamin.c9users.io/contratodelete/'+x,
        		});
        		$("#tb, #t1 tbody").html("");
        		listar();
    		}
		}

		function selecao(){
    		$('tbody tr').css('cursor','pointer');
        	$('tbody tr').click(function(){
            	$('#btn-alt').removeAttr("disabled",'disabled');
            	$('#btn-alt').attr("onclick","alterar()");
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
		
		function ajuste(){
		    $('tbody tr').on("click");
		    limpaCampos();
		    $('#btn-nv').attr("onclick","novo()");
		    $('input, select').attr("disabled",'disabled');
		    $('#btn-alt, #btn-conc, #btn-canc').removeAttr("onclick");
		    $('#btn-alt, #btn-conc, #btn-canc').attr("disabled",'disabled');
		}

		function ajusteEdit(){
		    $('tbody tr').on("click");
		    $('#btn-nv').attr("onclick","novo()");
		    $('#btn-nv').removeAttr("disabled",'disabled');
		    $('input, select').attr("disabled",'disabled');
		    $('#btn-conc, #btn-canc').removeAttr("onclick");
		    $('#btn-conc, #btn-canc').attr("disabled",'disabled');
		}
		
		function listarClientes(){
    		var itens = "";
			$.ajax({
				contentType: "application/json",
                url: "@{ListaR}",
                type: "GET",
    		}).done(function(e){
            		for(var i = 0; i<e.data.length; i++){
                		itens+="<option value="+e.data[i].id+">";
                		itens+=e.data[i].nome;
                		itens+="</option>";
                	}
                	$("#clienteid").append(itens);
			});
		}
		
|]



--CONVENIADO

getConveniadoR :: Handler Html
getConveniadoR = defaultLayout $ do
  setTitle "Sistema Estacionamento | Cadastrar Convênio"
  addScriptRemote "https://ajax.googleapis.com/ajax/libs/jquery/1.12.0/jquery.min.js"
  addStylesheetRemote "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css"
  [whamlet|
<h1>Cadastrar Convênio
<div .container>  
    <div id="formulario" .col-md-12 .col-lg-12>
        
        <button id="btn-nv" .btn .btn-default >Novo</button>
        <button id="btn-alt" .btn .btn-default>Alterar</button>
        <br><br>
        
        <form .form-horizontal role="form">
        
            <div .form-group>
                <label .control-label .col-md-2 for="nome">Nome: 
                <div .col-md-5>
                    <input .form-control type="text" id="nome" required placeholder="Nome do Convênio" title="Digite o nome do convênio">
                        
            <div .form-group>
                <label .control-label .col-md-2 for="desconto">Desconto: 
                <div .col-md-5 .input-group>
                    <input .form-control type="number" id="desconto" required title="Digite o percentual de desconto. Exemplo: 15,50">
                    <span .input-group-addon>%
                        
            <div .form-group>
                <label .control-label .col-md-2 for="eventoid">Evento: 
                <div .col-md-5>
                    <select .form-control id="eventoid" title="Selecione o Evento (opcional)"></select>
                        
            <br>
        <div .form-group  .col-md-12 .col-lg-12>    
            <button id="btn-canc" .btn .btn-danger>Cancelar</button>
            <button id="btn-conc" .btn .btn-success>Confirmar</button>

    <div id="tabela" .col-md-12 .col-lg-12>
        <table id="t1" .text-center>
            <thead>
                <tr>
                    <th>ID
                    <th>Convênio
                    <th>Desconto
                    <th>Evento
            <tbody id="tb">
  
|] >> toWidget [lucius|
  	h1{
  		margin-left: 5%;
  		font-weight: bold;
  	}
  	
  	.container,
  	#formulario, 
  	#tabela {
  		margin: 2% auto;
  		padding: 1% 1% 1% 1%;
  	}
  	
  	#formulario {
  		padding: 2% 2% 2% 2%;
  	}
  	
|] >> toWidget [julius|
     
    	$(listar());
    	$(listarEventos());
		var modeledt = {};
		
		function confirmar(){
			
            $.ajax({
                 contentType: "application/json",
                 url: "@{ConveniadoR}",
                 type: "POST",
                 data: JSON.stringify({"nome":$("#nome").val(), 
                                       "percentualDesconto":parseFloat($("#desconto").val()),
                                       "eventoid":$("#eventoid").val() }),
                 success: function(){
                	
					limpaCampos();	
					listar();
                 },
                 error: function(){
                 	alert("ERRO!");
                 }
            });
        	ajuste();
        	$('tbody tr').css('background-color','#fff');   
		}

		function confedit(){
    		modeledt.nome = $("#nome").val();
    		modeledt.percentualDesconto = parseFloat($("#desconto").val());
    		modeledt.eventoid = $("#eventoid").val();
        		$.ajax({
            		type: "PUT",
            		dataType: "json",
            		cache: false,
		            contentType:"application/json",    
        		    url: 'https://estacionamento-bruno-alcamin.c9users.io/alterarconveniado/'+modeledt.id,
            		data: JSON.stringify(modeledt),  
        		}).done(function(e){
           			limpaCampos();	
       				$("#tb").html("");
       				listar();
        		});
        		ajusteEdit();
		}
		
		function limpaCampos(){
			$('input, select').val("");
		}
		
		
		function novo(){
    		$('tbody tr').off("click");
    		limpaCampos();
    		$('#btn-alt, #btn-nv').removeAttr("onclick");
    		$("input, select").removeAttr("disabled","disabled");
    		$('#btn-conc').attr("onclick","confirmar()");
    		$('#btn-canc').attr("onclick","cancelar()");
    		$('#btn-canc, #btn-conc').removeAttr("disabled",'disabled');
    		$('#btn-alt').attr("disabled",'disabled');
		}
		

		function cancelar(){
    		selecao();
    		$('tbody tr').css('background-color','#fff');   
    		ajuste();
		}

		function cancelarEdit(){
    		selecao();
    		$("input, select").val("").attr("disabled", 'disabled');
    		ajusteEdit();
		}
	
		function alterar(){
    		$('tbody tr').off("click");
    		$('#btn-nv').removeAttr("onclick");
    		$('#btn-nv').attr("disabled",'disabled');
    		$("input, select").removeAttr("disabled",'disabled');
    		$('#btn-conc').attr("onclick","confedit()");
    		$('#btn-canc').attr("onclick","cancelarEdit()");
    		$('#btn-conc, #btn-canc').removeAttr("disabled",'disabled');
		}

		function listar(){
			ajuste();
    		var itens = "";
			$.ajax({
				contentType: "application/json",
                url: "@{ListaConveniadoR}",
                type: "GET",
    		}).done(function(e){
            		for(var i = 0; i<e.data.length; i++){
                		itens+="<tr><td>";
                		itens+="<span id='codigo'>"
                		itens+=e.data[i].id;
                		itens+="</span>"
                		itens+="</td><td>";
            	    	itens+="<span id='nome'>"
                		itens+=e.data[i].nome;
                		itens+="</span>"
                		itens+="</td><td>";
                		itens+="<span id='desconto'>"
                		itens+=e.data[i].percentualDesconto;
                		itens+="</span>"
                		itens+="</td><td>";
                		itens+="<span id='evento'>"
                		if (e.data[i].eventoid == null){
                			itens+= "Nenhum";
                		} else {
                			itens+=e.data[i].eventoid;
                		}
                		itens+="</span>"
                		itens+="</td><td>";
            	      	itens+="<button onclick='excluir("+e.data[i].id+")'>Excluir</button>";
			            itens+="</td></tr>";
                	}
                	$("#tb").html(itens);
                	selecao();
			});
		}

		function excluir(x){
     		if(confirm("Confirma a exclusão do convênio "+$('button[onclick="excluir('+x+')"').parent().parent().find('span[id="nome"]').html()+"?")){
        		$.ajax({
        			type: 'DELETE',
        			dataType: "json",
        			cache: false,
        			contentType:"application/json",    
        			url: 'https://estacionamento-bruno-alcamin.c9users.io/deleteconveniado/'+x,
        		});
        		$("#tb, #t1 tbody").html("");
        		listar();
    		}
		}

		function selecao(){
    		$('tbody tr').css('cursor','pointer');
        	$('tbody tr').click(function(){
            	$('#btn-alt').removeAttr("disabled",'disabled');
            	$('#btn-alt').attr("onclick","alterar()");
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
		
		function ajuste(){
		    $('tbody tr').on("click");
		    limpaCampos();
		    $('#btn-nv').attr("onclick","novo()");
		    $('input, select').attr("disabled",'disabled');
		    $('#btn-alt, #btn-conc, #btn-canc').removeAttr("onclick");
		    $('#btn-alt, #btn-conc, #btn-canc').attr("disabled",'disabled');
		}

		function ajusteEdit(){
		    $('tbody tr').on("click");
		    $('#btn-nv').attr("onclick","novo()");
		    $('#btn-nv').removeAttr("disabled",'disabled');
		    $('input, select').attr("disabled",'disabled');
		    $('#btn-conc, #btn-canc').removeAttr("onclick");
		    $('#btn-conc, #btn-canc').attr("disabled",'disabled');
		}
		
		function listarEventos(){
    		var itens = "";
			$.ajax({
				contentType: "application/json",
                url: "@{ListaEventoR}",
                type: "GET",
    		}).done(function(e){
            		for(var i = 0; i<e.data.length; i++){
                		itens+="<option value="+e.data[i].id+">";
                		itens+=e.data[i].nome;
                		itens+="</option>";
                	}
                	$("#eventoid").append(itens);
			});
		}
		
|]



--EVENTO

getEventoR :: Handler Html
getEventoR = defaultLayout $ do
  setTitle "Sistema Estacionamento | Cadastrar Evento"
  addScriptRemote "https://ajax.googleapis.com/ajax/libs/jquery/1.12.0/jquery.min.js"
  addStylesheetRemote "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css"
  [whamlet|
<h1>Cadastrar Evento
<div .container>  
    <div id="formulario" .col-md-12 .col-lg-12>
        
        <button id="btn-nv" .btn .btn-default >Novo</button>
        <button id="btn-alt" .btn .btn-default>Alterar</button>
        <br><br>
        
        <form .form-horizontal role="form">
        
            <div .form-group>
                <label .control-label .col-md-2 for="descricao">Descrição: 
                <div .col-md-5>
                    <input .form-control type="text" id="descricao" required placeholder="Descrição do Evento" title="Digite a descrição do evento">
                        
            <div .form-group>
                <label .control-label .col-md-2 for="desconto">Desconto: 
                <div .col-md-5 .input-group>
                    <input .form-control type="number" id="desconto" required title="Digite o percentual de desconto. Exemplo: 15,50">
                    <span .input-group-addon>%
                        
            <div .form-group>
                <label .control-label .col-md-2 for="clienteid">Cliente: 
                <div .col-md-5>
                    <select .form-control id="clienteid" title="Selecione o Cliente" required ></select>
                        
            <br>
        <div .form-group  .col-md-12 .col-lg-12>    
            <button id="btn-canc" .btn .btn-danger>Cancelar</button>
            <button id="btn-conc" .btn .btn-success>Confirmar</button>

    <div id="tabela" .col-md-12 .col-lg-12>
        <table id="t1" .text-center>
            <thead>
                <tr>
                    <th>ID
                    <th>Nome
                    <th>Descrição
                    <th>Desconto
                    <th>Cliente
            <tbody id="tb">
  
|] >> toWidget [lucius|
  	h1{
  		margin-left: 5%;
  		font-weight: bold;
  	}
  	
  	.container,
  	#formulario, 
  	#tabela {
  		margin: 2% auto;
  		padding: 1% 1% 1% 1%;
  	}
  	
  	#formulario {
  		padding: 2% 2% 2% 2%;
  	}
  	
|] >> toWidget [julius|
     
    	$(listar());
    	$(listarContratos());
		var modeledt = {};
		
		function confirmar(){
			
            $.ajax({
                 contentType: "application/json",
                 url: "@{EventoR}",
                 type: "POST",
                 data: JSON.stringify({"descricao":$("#descricao").val(), 
                                       "percentualDesconto":parseInt($("#desconto").val()),
                                       "clienteid":parseInt($("#clienteid").val()) }),
                 success: function(){
                	
					limpaCampos();	
					listar();
                 },
                 error: function(){
                 	alert("ERRO!");
                 }
            });
        	ajuste();
        	$('tbody tr').css('background-color','#fff');   
		}

		function confedit(){
    		modeledt.descricao = $("#descricao").val();
    		modeledt.percentualDesconto = parseInt($("#desconto").val());
    		modeledt.clienteid = parseInt($("#clienteid").val());
        		$.ajax({
            		type: "PUT",
            		dataType: "json",
            		cache: false,
		            contentType:"application/json",    
        		    url: 'https://estacionamento-bruno-alcamin.c9users.io/alteraevento/'+modeledt.id,
            		data: JSON.stringify(modeledt),  
        		}).done(function(e){
           			limpaCampos();	
       				$("#tb").html("");
       				listar();
        		});
        		ajusteEdit();
		}
		
		function limpaCampos(){
			$('input, select').val("");
		}
		
		
		function novo(){
    		$('tbody tr').off("click");
    		limpaCampos();
    		$('#btn-alt, #btn-nv').removeAttr("onclick");
    		$("input, select").removeAttr("disabled","disabled");
    		$('#btn-conc').attr("onclick","confirmar()");
    		$('#btn-canc').attr("onclick","cancelar()");
    		$('#btn-canc, #btn-conc').removeAttr("disabled",'disabled');
    		$('#btn-alt').attr("disabled",'disabled');
		}
		

		function cancelar(){
    		selecao();
    		$('tbody tr').css('background-color','#fff');   
    		ajuste();
		}

		function cancelarEdit(){
    		selecao();
    		$("input, select").val("").attr("disabled", 'disabled');
    		ajusteEdit();
		}
	
		function alterar(){
    		$('tbody tr').off("click");
    		$('#btn-nv').removeAttr("onclick");
    		$('#btn-nv').attr("disabled",'disabled');
    		$("input, select").removeAttr("disabled",'disabled');
    		$('#btn-conc').attr("onclick","confedit()");
    		$('#btn-canc').attr("onclick","cancelarEdit()");
    		$('#btn-conc, #btn-canc').removeAttr("disabled",'disabled');
		}

		function listar(){
			ajuste();
    		var itens = "";
			$.ajax({
				contentType: "application/json",
                url: "@{ListaEventoR}",
                type: "GET",
    		}).done(function(e){
            		for(var i = 0; i<e.data.length; i++){
                		itens+="<tr><td>";
                		itens+="<span id='codigo'>"
                		itens+=e.data[i].id;
                		itens+="</span>"
                		itens+="</td><td>";
            	    	itens+="<span id='descricao'>"
                		itens+=e.data[i].descricao;
                		itens+="</span>"
                		itens+="</td><td>";
                		itens+="<span id='desconto'>"
                		itens+=e.data[i].percentualDesconto;
                		itens+="</span>"
                		itens+="</td><td>";
                		itens+="<span id='clienteid'>"
                		itens+=e.data[i].clienteid;
                		itens+="</span>"
                		itens+="</td><td>";
            	      	itens+="<button onclick='excluir("+e.data[i].id+")'>Excluir</button>";
			            itens+="</td></tr>";
                	}
                	$("#tb").html(itens);
                	selecao();
			});
		}

		function excluir(x){
     		if(confirm("Confirma a exclusão do evento "+$('button[onclick="excluir('+x+')"').parent().parent().find('span[id="nome"]').html()+"?")){
        		$.ajax({
        			type: 'DELETE',
        			dataType: "json",
        			cache: false,
        			contentType:"application/json",    
        			url: 'https://estacionamento-bruno-alcamin.c9users.io/deletaevento/'+x,
        		});
        		$("#tb, #t1 tbody").html("");
        		listar();
    		}
		}

		function selecao(){
    		$('tbody tr').css('cursor','pointer');
        	$('tbody tr').click(function(){
            	$('#btn-alt').removeAttr("disabled",'disabled');
            	$('#btn-alt').attr("onclick","alterar()");
            	$('tbody tr').css('background-color','#fff');
            	$('tbody tr').removeAttr('select','select');
            	$(this).css('background-color','#76affd');
            	$(this).attr('select','select');
            	
            	$("#descricao").val($(this).find('span[id="descricao"]').html());
            	$("#desconto").val($(this).find('span[id="desconto"]').html());
            	$("#clienteid").val($(this).find('span[id="clienteid"]').html());
            	
            	modeledt = {"id":$(this).find('span[id="codigo"]').html(), "descricao":$(this).find('span[id="descricao"]').html(),
            		        "percentualDesconto":parseInt($(this).find('span[id="desconto"]').html()) ,"clienteid":parseInt($(this).find('span[id="clienteid"]').html()) };
    		});
		}
		
		function ajuste(){
		    $('tbody tr').on("click");
		    limpaCampos();
		    $('#btn-nv').attr("onclick","novo()");
		    $('input, select').attr("disabled",'disabled');
		    $('#btn-alt, #btn-conc, #btn-canc').removeAttr("onclick");
		    $('#btn-alt, #btn-conc, #btn-canc').attr("disabled",'disabled');
		}

		function ajusteEdit(){
		    $('tbody tr').on("click");
		    $('#btn-nv').attr("onclick","novo()");
		    $('#btn-nv').removeAttr("disabled",'disabled');
		    $('input, select').attr("disabled",'disabled');
		    $('#btn-conc, #btn-canc').removeAttr("onclick");
		    $('#btn-conc, #btn-canc').attr("disabled",'disabled');
		}
		
		function listarContratos(){
    		var itens = "";
			$.ajax({
				contentType: "application/json",
                url: "@{ListaContratoR}",
                type: "GET",
    		}).done(function(e){
            		for(var i = 0; i<e.data.length; i++){
                		itens+="<option value="+e.data[i].clienteid+">";
                		itens+=e.data[i].clienteid;
                		itens+="</option>";
                	}
                	$("#clienteid").append(itens);
			});
		}
		
|]
  


--AVULSO

getAvulsoR :: Handler Html
getAvulsoR = defaultLayout $ do
  setTitle "Sistema Estacionamento | Cadastrar Registro Avulso"
  addScriptRemote "https://ajax.googleapis.com/ajax/libs/jquery/1.12.0/jquery.min.js"
  addStylesheetRemote "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css"
  [whamlet|

<h1>Cadastrar Registro Avulso
<div .container>  
    <div id="formulario" .col-md-12 .col-lg-12>
        <form .form-horizontal role="form">
            <div .form-group>
                <label .control-label .col-md-2 for="placa">Placa: 
                <div .col-md-5>
                    <input .form-control type="text" id="placa">
                    
            <div .form-group>
                <label .control-label .col-md-2 for="entrada">Entrada: 
                <div .col-md-5>
                    <input .form-control type="datetime-local" id="entrada">
                    
            <div .form-group>
                <label .control-label .col-md-2 for="saida">Saída: 
                <div .col-md-5>
                    <input .form-control type="datetime-local" id="saida">
                    
            <div .form-group>
                <label .control-label .col-md-2 for="valor">Valor: 
                <div .col-md-5>
                    <input .form-control type="number" id="valor">
                        
            <div .form-group>
                <label .control-label .col-md-2 for="vagaid">Vaga: 
                <div .col-md-5>
                    <select .form-control id="vagaid"></select>
            
            <div .form-group>
                <label .control-label .col-md-2 for="convenioid">Convênio: 
                <div .col-md-5>
                    <select .form-control id="convenioid">
            
            <br>
        <div .form-group  .col-md-12 .col-lg-12>    
            <button id="btn-canc" .btn .btn-danger>Cancelar</button>
            <button id="btn-conc" .btn .btn-success>Confirmar</button>

    <div id="tabela" .col-md-12 .col-lg-12>
        <h3>Registros Cadastrados
        <table id="t1" .text-center>
            <thead>
                <tr>
                    <th>ID
                    <th>Placa
                    <th>Entrada
                    <th>Saída
                    <th>Valor
                    <th>Vaga
                    <th>Convênio
            <tbody id="tb">
  
|] >> toWidget [lucius|
  	h1{
  		margin-left: 5%;
  		font-weight: bold;
  	}
  	
  	.container,
  	#formulario, 
  	#tabela {
  		margin: 2% auto;
  		padding: 1% 1% 1% 1%;
  	}
  	
  	#formulario {
  		padding: 2% 2% 2% 2%;
  	}
  	
|] >> toWidget [julius|
     
    	$(listar());
    	$(listarVagas());
    	$(listarConvenios());
    	$('#btn-conc').attr("onclick","confirmar()");
    	$('#btn-canc').attr("onclick","limpaCampos()");
		
		function confirmar(){
			
            $.ajax({
                 contentType: "application/json",
                 url: "@{AvulsoR}",
                 type: "POST",
                 data: JSON.stringify({"placa":$("#placa").val(), 
                                       "entrada":$("#entrada").val(),
                                       "saida":$("#saida").val(),
                                       "valor":parseFloat($("#valor").val()),
                                       "vagaid":parseInt($("#vagaid").val()),
                                       "convenioid":parseInt($("#convenioid").val())}),
                 success: function(){
                	
					limpaCampos();	
					listar();
                 },
                 error: function(){
                 	alert("ERRO!");
                 }
            });
		}
		
		function limpaCampos(){
			$('input, select').val("");
		}

		function listar(){
    		var itens = "";
			$.ajax({
				contentType: "application/json",
                url: "@{ListaAvulsoR}",
                type: "GET",
    		}).done(function(e){
            		for(var i = 0; i<e.data.length; i++){
                		itens+="<tr><td>";
                		itens+="<span id='codigo'>"
                		itens+=e.data[i].id;
                		itens+="</span>"
                		itens+="</td><td>";
            	    	itens+="<span id='placa'>"
                		itens+=e.data[i].placa;
                		itens+="</span>"
                		itens+="</td><td>";
                		itens+="<span id='entrada'>"
                		itens+=e.data[i].entrada;
                		itens+="</span>"
                		itens+="</td><td>";
                		itens+="<span id='saida'>"
                		itens+=e.data[i].saida;
                		itens+="</span>"
                		itens+="</td><td>";
                		itens+="<span id='valor'>"
                		itens+=e.data[i].valor;
                		itens+="</span>"
                		itens+="</td><td>";
                		itens+="<span id='vagaid'>"
                		itens+=e.data[i].vagaid;
                		itens+="</span>"
                		itens+="</td><td>";
                		itens+="<span id='convenioid'>"
                		if (e.data[i].convenioid == null){
                			itens+= "Nenhum";
                		} else {
                			itens+=e.data[i].convenioid;
                		}
                		itens+="</span>"
                		itens+="</td><td>";
            	      	itens+="<button onclick='excluir("+e.data[i].id+")'>Excluir</button>";
			            itens+="</td></tr>";
                	}
                	$("#tb").html(itens);
			});
		}

		function excluir(x){
     		if(confirm("Confirma a exclusão do registro "+$('button[onclick="excluir('+x+')"').parent().parent().find('span[id="codigo"]').html()+"?")){
        		$.ajax({
        			type: 'DELETE',
        			dataType: "json",
        			cache: false,
        			contentType:"application/json",    
        			url: 'https://estacionamento-bruno-alcamin.c9users.io/deleteavulso/'+x,
        		});
        		$("#tb, #t1 tbody").html("");
        		listar();
    		}
		}
		
		function listarVagas(){
    		var itens = "";
			$.ajax({
				contentType: "application/json",
                url: "@{ListaVagaR}",
                type: "GET",
    		}).done(function(e){
            		for(var i = 0; i<e.data.length; i++){
                		itens+="<option value="+e.data[i].id+"> VAGA ID #";
                		itens+=e.data[i].id;
                		itens+="</option>";
                	}
                	$("#vagaid").append(itens);
			});
		}
		
		function listarConvenios(){
    		var itens = "";
			$.ajax({
				contentType: "application/json",
                url: "@{ListaConveniadoR}",
                type: "GET",
    		}).done(function(e){
            		for(var i = 0; i<e.data.length; i++){
                		itens+="<option value="+e.data[i].id+">";
                		itens+=e.data[i].nome;
                		itens+="</option>";
                	}
                	$("#convenioid").append(itens);
			});
		}
		
|]



  
  
getTipoVeiculoR :: Handler Html
getTipoVeiculoR = defaultLayout $ do
  addScriptRemote "https://ajax.googleapis.com/ajax/libs/jquery/1.12.0/jquery.min.js"
  [whamlet|
    <form>
<button id="btn-nv">Novo</button>
<button id="btn-alt">Alterar</button>
    Nome: <input type="text" id="nome">
    <button id="btn-canc">cancelar</button>
    <button id="btn-conc">confirmar</button>
    <table id="t1">
        <thead>
            <tr>
            <th>ID
            <th>Nome
        <tbody id="tb">
  |] 
  toWidget [julius|
     
     $(listar());
		var modeledt = {};
		function confirmar(){
            $.ajax({
                 contentType: "application/json",
                 url: "@{TipoVeiculoR}",
                 type: "POST",
                 data: JSON.stringify({"nome":$("#nome").val()}),
                 success: function(){
					limpaCampos();	
					listar();
                 }
            });
        	ajuste();
        	$('tbody tr').css('background-color','#fff');   
		}

		function confedit(){
    		modeledt.nome = $("#nome").val();
        		$.ajax({
            		type: "PUT",
            		dataType: "json",
            		cache: false,
		            contentType:"application/json",    
        		    url: 'https://estacionamento-bruno-alcamin.c9users.io/tipoveiculoupdate/'+modeledt.id,
            		data: JSON.stringify(modeledt),  
        		}).done(function(e){
           			limpaCampos();	
       				$("#tb").html("");
       				listar();
        		});
        		ajusteEdit();
		}
		
		function limpaCampos(){
			$("#nome").val("");
		}
		
		
		function novo(){
    		$('tbody tr').off("click");
    		limpaCampos();
    		$('#btn-alt').removeAttr("onclick");
    		$('#btn-nv').removeAttr("onclick");
    		$("#nome").removeAttr("disabled","disabled");
    		$('#btn-conc').attr("onclick","confirmar()");
    		$('#btn-canc').attr("onclick","cancelar()");
    		$('#btn-canc').removeAttr("disabled",'disabled');
    		$('#btn-conc').removeAttr("disabled",'disabled');
    		$('#btn-alt').attr("disabled",'disabled');
		}
		

		function cancelar(){
    		selecao();
    		$('tbody tr').css('background-color','#fff');   
    		ajuste();
		}

		function cancelarEdit(){
    		selecao();
    		$("#nome").val($('tr[select="select"]').find('span[id="nm"]').html());
    		ajusteEdit();
		}
	
		function alterar(){
    		$('tbody tr').off("click");
    		$('#btn-nv').removeAttr("onclick");
    		$('#btn-nv').attr("disabled",'disabled');
    		$("#nome").removeAttr("disabled","disabled");
    		$('#btn-conc').attr("onclick","confedit()");
    		$('#btn-canc').attr("onclick","cancelarEdit()");
    		$('#btn-conc').removeAttr("disabled",'disabled');
    		$('#btn-canc').removeAttr("disabled",'disabled');
		}

		function listar(){
			ajuste();
    		var itens = "";
			$.ajax({
				contentType: "application/json",
                url: "@{ListaTpVeiculoR}",
                type: "GET",
    		}).done(function(e){
            		for(var i = 0; i<e.data.length; i++){
                		itens+="<tr><td>";
                		itens+="<span id='cd'>"
                		itens+=e.data[i].id;
                		itens+="</span>"
                		itens+="</td><td>";
            	    	itens+="<span id='nm'>"
                		itens+=e.data[i].nome;
                		itens+="</span>"
            	      	itens+="</td><td>";
            	      	itens+="<button onclick='excluir("+e.data[i].id+")'>Excluir</button>";
			            itens+="</td></tr>";
                	}
                	$("#tb").html(itens);
                	selecao();
			});
		}

		function excluir(x){
     		if(confirm("Confirma a exclusão do Tipo de veiculo "+$('button[onclick="excluir('+x+')"').parent().parent().find('span[id="nm"]').html()+"?")){
        		$.ajax({
        			type: 'DELETE',
        			dataType: "json",
        			cache: false,
        			contentType:"application/json",    
        			url: 'https://estacionamento-bruno-alcamin.c9users.io/tipoveiculodelete/'+x,
        		});
        		$("#tb").html("");
        		$("#t1 tbody").html("");
        		listar();
    		}
		}

		function selecao(){
    		$('tbody tr').css('cursor','pointer');
        	$('tbody tr').click(function(){
            	$('#btn-alt').removeAttr("disabled",'disabled');
            	$('#btn-alt').attr("onclick","alterar()");
            	$('tbody tr').css('background-color','#fff');
            	$('tbody tr').removeAttr('select','select');
            	$(this).css('background-color','#76affd');
            	$(this).attr('select','select');
            	$("#nome").val($(this).find('span[id="nm"]').html());
            	modeledt = {"id":$(this).find('span[id="cd"]').html(),"nome":$(this).find('span[id="nm"]').html()};
    		});
		}
		
		function ajuste(){
		    $('tbody tr').on("click");
		    limpaCampos();
		    $('#btn-nv').attr("onclick","novo()");
		    $("#nome").attr("disabled","disabled");
		    $('#btn-alt').removeAttr("onclick");
		    $('#btn-alt').attr("disabled",'disabled');
		    $('#btn-conc').attr("disabled",'disabled');
		    $('#btn-canc').attr("disabled",'disabled');
		    $('#btn-conc').removeAttr("onclick");
		    $('#btn-canc').removeAttr("onclick");
		}

		function ajusteEdit(){
		    $('tbody tr').on("click");
		    $('#btn-nv').attr("onclick","novo()");
		    $('#btn-nv').removeAttr("disabled",'disabled');
		    $("#nome").attr("disabled","disabled");
		    $('#btn-conc').removeAttr("onclick");
		    $('#btn-canc').removeAttr("onclick");
		    $('#btn-conc').attr("disabled",'disabled');
		    $('#btn-canc').attr("disabled",'disabled');
		}
	|]

getVeiculoR :: Handler Html
getVeiculoR = defaultLayout $ do
  addScriptRemote "https://ajax.googleapis.com/ajax/libs/jquery/1.12.0/jquery.min.js"
  [whamlet|
<button id="btn-nv">Novo</button>
<button id="btn-alt">Alterar</button>
    <form>
    Clientes: <select id="clienteid"></select>
    Placa: <input type="text" id="placa">
    Descricao: <input type="text" id="descricao">
    Marca: <input type="text" id="marca">
    Ano: <input type="text" id="ano">
    Cor: <input type="text" id="cor">
    Tipos de Veiculo: <select id="tipoveiculoid"></select>
    <button id="btn-canc">cancelar</button>
    <button id="btn-conc">confirmar</button>
    <table id="t1">
        <thead>
            <tr>
            <th>ID
            <th>Placa
            <th>Cliente
            <th>Marca
            <th>Ano
            <th>Cor
            <th>Descricao
            <th>Tipo de Veiculo
        <tbody id="tb">
  |]     
  toWidget [julius|
  		$(listarClientes());
     	$(listarTiposveiculos());
  		$(listar());
		var modeledt = {};
		function confirmar(){
            $.ajax({
                 contentType: "application/json",
                 url: "@{VeiculoR}",
                 type: "POST",
                 data: JSON.stringify({"clienteid":parseInt($("#clienteid").val()),"placa":$("#placa").val(),"descricao":$("#descricao").val(),"marca":$("#marca").val(),"ano":$("#ano").val(),"cor":$("#cor").val(),"tipoveiculoid":parseInt($("#tipoveiculoid").val())}),
                 success: function(){
					limpaCampos();
					listar();
                 }
            })
        	ajuste();
        	$('tbody tr').css('background-color','#fff');   
		}

		function confedit(){
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
           			limpaCampos();	
       				$("#tb").html("");
       				listar();
        		});
        		ajusteEdit();
		}
		
		function limpaCampos(){
			$("#placa").val("");
			$("#clienteid").val("1");
			$("#descricao").val("");
			$("#marca").val("");
			$("#ano").val("");
			$("#cor").val("");
			$("#tipoveiculoid").val("1");
		}
		
		
		function novo(){
    		$('tbody tr').off("click");
    		limpaCampos();
    		$('#btn-alt').removeAttr("onclick");
    		$('#btn-nv').removeAttr("onclick");
    		$("#placa").removeAttr("disabled","disabled");
			$("#clienteid").removeAttr("disabled","disabled");
			$("#descricao").removeAttr("disabled","disabled");
			$("#marca").removeAttr("disabled","disabled");
			$("#ano").removeAttr("disabled","disabled");
			$("#cor").removeAttr("disabled","disabled");
			$("#tipoveiculoid").removeAttr("disabled","disabled");
    		$('#btn-conc').attr("onclick","confirmar()");
    		$('#btn-canc').attr("onclick","cancelar()");
    		$('#btn-canc').removeAttr("disabled",'disabled');
    		$('#btn-conc').removeAttr("disabled",'disabled');
    		$('#btn-alt').attr("disabled",'disabled');
		}
		
		function cancelar(){
    		selecao();
    		$('tbody tr').css('background-color','#fff');   
    		ajuste();
		}

		function cancelarEdit(){
    		selecao();
    		$("#placa").val($('tr[select="select"]').find('span[id="pl"]').html());
			$("#clienteid").val($('tr[select="select"]').find('span[id="cdcli"]').html());
			$("#descricao").val($('tr[select="select"]').find('span[id="dsc"]').html());
			$("#marca").val($('tr[select="select"]').find('span[id="mc"]').html());
			$("#ano").val($('tr[select="select"]').find('span[id="aa"]').html());
			$("#cor").val($('tr[select="select"]').find('span[id="cr"]').html());
			$("#tipoveiculoid").val($('tr[select="select"]').find('span[id="cdtv"]').html());
    		ajusteEdit();
		}
	
		function alterar(){
    		$('tbody tr').off("click");
    		$('#btn-nv').removeAttr("onclick");
    		$('#btn-nv').attr("disabled",'disabled');
    		$("#placa").removeAttr("disabled","disabled");
			$("#clienteid").removeAttr("disabled","disabled");
			$("#descricao").removeAttr("disabled","disabled");
			$("#marca").removeAttr("disabled","disabled");
			$("#ano").removeAttr("disabled","disabled");
			$("#cor").removeAttr("disabled","disabled");
			$("#tipoveiculoid").removeAttr("disabled","disabled");
    		$('#btn-conc').attr("onclick","confedit()");
    		$('#btn-canc').attr("onclick","cancelarEdit()");
    		$('#btn-conc').removeAttr("disabled",'disabled');
    		$('#btn-canc').removeAttr("disabled",'disabled');
    		$("#cnpj").attr("disabled","disabled");
		}

		function listar(){
    		ajuste();
    		var itens = "";
   			$.ajax({
				contentType: "application/json",
                url: "@{ListaVeiculoR}",
                type: "GET",
    		}).done(function(e){
            		for(var i = 0; i<e.data.length; i++){
                		itens+="<tr><td>";
                		itens+="<span id='cd'>"
                		itens+=e.data[i].id;
                		itens+="</span>"
                		itens+="</td><td>";
            	    	itens+="<span id='pl'>"
                		itens+=e.data[i].placa;
                		itens+="</span>"
            	    	itens+="</td><td>";
        	        	itens+="<span id='cdcli'>"
                		itens+=e.data[i].clienteid;
    	            	itens+="</span>"
	                	itens+="</td><td>";
	                	itens+="<span id='dsc'>"
                		itens+=e.data[i].descricao;
    	            	itens+="</span>"
	                	itens+="</td><td>";
	                	itens+="<span id='mc'>"
                		itens+=e.data[i].marca;
    	            	itens+="</span>"
	                	itens+="</td><td>";
	                	itens+="<span id='aa'>"
                		itens+=e.data[i].ano;
    	            	itens+="</span>"
	                	itens+="</td><td>";
	                	itens+="<span id='cr'>"
                		itens+=e.data[i].cor;
    	            	itens+="</span>"
	                	itens+="</td><td>";
	                	itens+="<span id='cdtv'>"
                		itens+=e.data[i].tipoveiculoid;
    	            	itens+="</span>"
	                	itens+="</td><td>";
			            itens+="<button onclick='excluir("+e.data[i].id+")'>Excluir</button>";
			            itens+="</td></tr>";
                	}
                	$("#tb").html(itens);
				    selecao();
    		});
		}

		function excluir(x){
     		if(confirm("Confirma a exclusão do Veiculo com a placa "+$('button[onclick="excluir('+x+')"').parent().parent().find('span[id="pl"]').html()+"?")){
        		$.ajax({
        			type: 'DELETE',
        			dataType: "json",
        			cache: false,
        			contentType:"application/json",    
        			url: 'https://estacionamento-bruno-alcamin.c9users.io/veiculodelete/'+x,
        		});
        		$("#tb").html("");
        		$("#t1 tbody").html("");
        		listar();
    		}
		}

		function selecao(){
    		$('tbody tr').css('cursor','pointer');
        	$('tbody tr').click(function(){
            	$('#btn-alt').removeAttr("disabled",'disabled');
            	$('#btn-alt').attr("onclick","alterar()");
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
		
		function ajuste(){
		    $('tbody tr').on("click");
		    limpaCampos();
		    $('#btn-nv').attr("onclick","novo()");
		    $("#placa").attr("disabled","disabled");
			$("#clienteid").attr("disabled","disabled");
			$("#descricao").attr("disabled","disabled");
			$("#marca").attr("disabled","disabled");
			$("#ano").attr("disabled","disabled");
			$("#cor").attr("disabled","disabled");
			$("#tipoveiculoid").attr("disabled","disabled");
		    $('#btn-alt').removeAttr("onclick");
		    $('#btn-alt').attr("disabled",'disabled');
		    $('#btn-conc').attr("disabled",'disabled');
		    $('#btn-canc').attr("disabled",'disabled');
		    $('#btn-conc').removeAttr("onclick");
		    $('#btn-canc').removeAttr("onclick");
		}

		function ajusteEdit(){
		    $('tbody tr').on("click");
		    $('#btn-nv').attr("onclick","novo()");
		    $('#btn-nv').removeAttr("disabled",'disabled');
			$("#placa").attr("disabled","disabled");
			$("#clienteid").attr("disabled","disabled");
			$("#descricao").attr("disabled","disabled");
			$("#marca").attr("disabled","disabled");
			$("#ano").attr("disabled","disabled");
			$("#cor").attr("disabled","disabled");
			$("#tipoveiculoid").attr("disabled","disabled");
		    $('#btn-conc').removeAttr("onclick");
		    $('#btn-canc').removeAttr("onclick");
		    $('#btn-conc').attr("disabled",'disabled');
		    $('#btn-canc').attr("disabled",'disabled');
		}
        
    	function listarClientes(){
    		var itens = "";
			$.ajax({
				contentType: "application/json",
                url: "@{ListaR}",
                type: "GET",
    		}).done(function(e){
            		for(var i = 0; i<e.data.length; i++){
                		itens+="<option value="+e.data[i].id+">";
                		itens+=e.data[i].nome;
                		itens+="</option>";
                	}
                	$("#clienteid").append(itens);
			});
		}
		
		function listarTiposveiculos(){
    		var itens = "";
			$.ajax({
				contentType: "application/json",
                url: "@{ListaTpVeiculoR}",
                type: "GET",
    		}).done(function(e){
            		for(var i = 0; i<e.data.length; i++){
                		itens+="<option value="+e.data[i].id+">";
                		itens+=e.data[i].nome;
                		itens+="</option>";
                	}
                	$("#tipoveiculoid").append(itens);
			});
		}
     
  |]

getFuncionarioR :: Handler Html
getFuncionarioR = defaultLayout $ do
  addScriptRemote "https://ajax.googleapis.com/ajax/libs/jquery/1.12.0/jquery.min.js"
  [whamlet|
    <button id="btnNovo">Novo
    <button id="btnAlterar">Alterar
    <form>
    Nome: <input type="text" name="nome">
    Senha: <input type="password" name="senha">
    Ativo: <select id="FuncionarioAtivo"><option value="true">Sim</option> <option value="false">Não</option></select>
    <button id="btnCancelar">cancelar
    <button id="btnConfirmar">confirmar
    <table id="table1">
        <thead>
            <tr>
                <th>ID
                <th>Nome
                <th>Senha
                <th>Ativo
        <tbody id="tbody1">
  |]
  toWidget [julius|
    $(listar());
    var modeledt = {};
    function confirmar(){
        $.ajax({
            contentType: "application/json",
            url: "@{FuncionarioR}",
            type: "POST",
            data: JSON.stringify({"nome":$("input[name='nome']").val(),"senha":$("input[name='senha']").val(),"ativo":$("#FuncionarioAtivo").val()}),
            success: function(){
				$("input[name='nome'], input[name='senha']").val("");
				$("#FuncionarioAtivo").val("true");
       			listar();
            }
        });
    	$("tbody tr").css("background-color","#fff");   
	}
    function listar(){
    	ajuste();
    	var itens = "";
   		$.ajax({
			contentType: "application/json",
            url: "@{ListaFuncionarioR}",
            type: "GET",
    	}).done(function(e){
       		for(var i = 0; i<e.data.length; i++){
           		itens+="<tr>";
           		itens+="<td><span id='idFuncionario'>"
           		itens+=e.data[i].id;
           		itens+="</span></td>"
       	    	itens+="<td><span id='nomeFuncionario'>"
           		itens+=e.data[i].nome;
           		itens+="</span></td>"
       	    	itens+="<td><span id='senhaFuncionario'>"
           		itens+=e.data[i].senha;
           		itens+="</span></td>"
            	itens+="<td><span id='atFuncionario'>"
           		itens+=e.data[i].ativo;
             	itens+="</span></td>"
	           	itens+="</tr>";
           	}
		    $("#tbody1").html(itens);
		    selecao();
        });
    }
    function novo(){
    	$("tbody tr").off("click");
    	limpaCampos();
    	$("#btnAlterar, #btnNovo").removeAttr("onclick");
    	$("input[name='nome'], input[name='senha'], #FuncionarioAtivo, #tbody1, #btnCancelar, #btnConfirmar").removeAttr("disabled","disabled");
    	$("#btnConfirmar").attr("onclick","confirmar()");
    	$("#btnCancelar").attr("onclick","cancelar()");
    	$("#btnAlterar").attr("disabled","disabled");
	}
	function alterar(){
    		$("tbody tr").off("click");
    		$("#btnNovo").removeAttr("onclick").attr("disabled","disabled");
			$("input[name='senha'], #FuncionarioAtivo, #tbody1, #btnConfirmar, #btnCancelar").removeAttr("disabled","disabled");
    		$("#btnConfirmar").attr("onclick","confedit()");
    		$("#btnCancelar").attr("onclick","cancelarEdit()");
	}
	function confedit(){
    	modeledt.senha = $("input[name='senha']").val();
    	modeledt.ativo = $("#FuncionarioAtivo").val();
    	$.ajax({
       		type: "PUT",
       		dataType: "json",
       		cache: false,
	        contentType:"application/json",    
    	    url: 'https://estacionamento-bruno-alcamin.c9users.io/alterafuncionario/'+modeledt.id,
      		data: JSON.stringify(modeledt),  
    	}).done(function(e){
    		limpaCampos();
    		$("#tbody1").html("");
    		listar();
       	});
       	ajusteEdit();
	}
	function cancelarEdit(){
    	selecao();
    	$("input[name='nome']").val($('tr[select="select"]').find('span[id="nomeFuncionario"]').html());
		$("input[name='senha']").val($('tr[select="select"]').find('span[id="senhaFuncionario"]').html());
		$("#FuncionarioAtivo").val($('tr[select="select"]').find('span[id="atFuncionario"]').html());
    	ajusteEdit();
	}
	function cancelar(){
    	selecao();
    	$("tbody tr").css("background-color","#fff");   
    	ajuste();
	}
	function selecao(){
    	$("tbody tr").css("cursor","pointer");
       	$("tbody tr").click(function(){
         	$("#btnAlterar").removeAttr("disabled","disabled").attr("onclick","alterar()");
           	$("tbody tr").css("background-color","#fff").removeAttr("select","select");
           	$(this).css("background-color","#76affd");
           	$(this).attr("select","select");
           	$("input[name='nome']").val($(this).find('span[id="nomeFuncionario"]').html());
           	$("input[name='senha']").val($(this).find('span[id="senhaFuncionario"]').html());
			$("#FuncionarioAtivo").val($(this).find('span[id="atFuncionario"]').html());
           	modeledt = {"id":$(this).find('span[id="idFuncionario"]').html(),"nome":$(this).find('span[id="nomeFuncionario"]').html(),"senha":$(this).find('span[id="senhaFuncionario"]').html(),"ativo":$(this).find('span[id="atFuncionario"]').html()};
    	});
	}
    function ajuste(){
	    $("tbody tr").on("click");
	    limpaCampos();
	    $("#btnNovo").attr("onclick","novo()");
	    $("input[name='nome'], input[name='senha'], #FuncionarioAtivo, #tbody1").attr("disabled","disabled");
	    $("#btnAlterar, #btnConfirmar, #btnCancelar").removeAttr("onclick");
	    $("#btnAlterar, #btnConfirmar, #btnCancelar").attr("disabled","disabled");
	    $("input[name='nome']").css("border-color","#fff");
    }
    function ajusteEdit(){
	    $("tbody tr").on("click");
	    $("#btnNovo").attr("onclick","novo()");
	    $("#btnNovo").removeAttr("disabled","disabled");
	    $("input[name='nome'], input[name='senha'], #FuncionarioAtivo, #tbody1, #btnConfirmar, #btnCancelar").attr("disabled","disabled");
	    $("#btnConfirmar, #btnCancelar").removeAttr("onclick");
	    $("input[name='nome']").css("border-color","#fff");
	}
    function limpaCampos(){
		$("input[name='nome'], input[name='senha']").val("");
		$("#FuncionarioAtivo").val("true");
	}
  |]

getVagaValorR :: Handler Html
getVagaValorR = defaultLayout $ do
  addScriptRemote "https://ajax.googleapis.com/ajax/libs/jquery/1.12.0/jquery.min.js"
  [whamlet|
    <h1>Alterar valor vaga diurno e noturno
    <p id="alteracao">
    <button id="btnNovo">Novo
    <button id="btnAlterar">Alterar
    <form>
    Valor diurno: <input type="number" name="diurno" step="0.01">
    Valor noturno: <input type="number" name="noturno" step="0.01">
    Funcionario: <select id="funcionario"></select>
    <button id="btnCancelar">cancelar
    <button id="btnConfirmar">confirmar
    <table id="table1">
        <caption>Valor atual</caption>
            <thead>
                <tr>
                    <th>ID
                    <th>Valor diurno
                    <th>Valor noturno
                    <th>Alterado por
                    <th>Id Funcionario
            <tbody id="tbody1">
  |]
  toWidget [julius|
    $(listar());
    $(optFuncionario());
    var modeledt = {};
    function optFuncionario(){
        var opt = "";
   		$.ajax({
			contentType: "application/json",
            url: "@{ListaFuncionarioR}",
            type: "GET",
    	}).done(function(e){
       		for(var i = 0; i<e.data.length; i++){
           		opt+="<option value='"+e.data[i].id+"'>"+e.data[i].nome+"</option>";
           	}
           	$("#funcionario").html(opt);
        });
    }
    function getFuncionario(id){
        var opt = "";
   		$.ajax({
			contentType: "application/json",
            url: "@{ListaFuncionarioR}",
            type: "GET",
    	}).done(function(e){
       		for(var i = 0; i<e.data.length; i++){
       		    if(id == e.data[i].id){
       		    	opt=e.data[i].nome;
       		    	$("#nmFuncionario"+id).html(opt);
       		    }
           	}
        });
    }
    function confirmar(){
        $.ajax({
            contentType: "application/json",
            url: "@{VagaValorR}",
            type: "POST",
            data: JSON.stringify({"valordiurno":parseFloat($("input[name='diurno']").val()),"valornoturno":parseFloat($("input[name='noturno']").val()),"funcionarioid":parseInt($("#funcionario").val())}),
            success: function(){
				$("input[name='diurno'],input[name='noturno']").val("");
				$("#funcionario").val("1");
       			listar();
            }
        });
    	$("tbody tr").css("background-color","#fff");   
	}
    function listar(){
    	ajuste();
    	var itens = "";
   		$.ajax({
			contentType: "application/json",
            url: "@{ListaVagaValorR}",
            type: "GET",
    	}).done(function(e){
       		for(var i = 0; i<e.data.length; i++){
           		itens+="<tr>";
           		itens+="<td><span id='idVagaValor'>"
           		itens+=e.data[i].id;
           		itens+="</span></td>"
       	    	itens+="<td><span id='valordiurno'>"
           		itens+=e.data[i].valordiurno.toFixed(2);
           		itens+="</span></td>"
       	    	itens+="<td><span id='valornoturno'>"
           		itens+=e.data[i].valornoturno.toFixed(2);
           		itens+="</span></td>"
            	itens+="<td><span id='nmFuncionario"+e.data[i].funcionarioid+"'>"
           		itens+=getFuncionario(e.data[i].funcionarioid);
             	itens+="</span></td>"
             	itens+="<td><span id='idFuncionario'>"
           		itens+=e.data[i].funcionarioid;
             	itens+="</span></td>"
	           	itens+="</tr>";
           	}
		    $("#tbody1").html(itens);
		    selecao();
        });
    }
    function novo(){
    	$("tbody tr").off("click");
    	limpaCampos();
    	$("#btnAlterar, #btnNovo").removeAttr("onclick");
    	$("input[name='diurno'], input[name='noturno'], #funcionario, #tbody1, #btnCancelar, #btnConfirmar").removeAttr("disabled","disabled");
    	$("#btnConfirmar").attr("onclick","confirmar()");
    	$("#btnCancelar").attr("onclick","cancelar()");
    	$("#btnAlterar").attr("disabled","disabled");
	}
	function alterar(){
    	$("tbody tr").off("click");
    	$("#btnNovo").removeAttr("onclick").attr("disabled","disabled");
		$("input[name='diurno'], input[name='noturno'], #funcionario, #tbody1, #btnConfirmar, #btnCancelar").removeAttr("disabled","disabled");
    	$("#btnConfirmar").attr("onclick","confedit()");
    	$("#btnCancelar").attr("onclick","cancelarEdit()");
	}
	function confedit(){
	    modeledt.valordiurno = parseFloat($("input[name='diurno']").val());
    	modeledt.valornoturno = parseFloat($("input[name='noturno']").val());
    	modeledt.funcionarioid = parseInt($("#funcionario").val());
    	modeledt.vldiurnonovo = parseFloat($("input[name='diurno']").val());
    	modeledt.vlnoturnonovo = parseFloat($("input[name='noturno']").val());
    	date = new Date;
    	modeledt.dataalteracao = date.toUTCString();
    	$.ajax({
       		type: "PUT",
       		dataType: "json",
       		cache: false,
	        contentType:"application/json",    
    	    url: "https://estacionamento-bruno-alcamin.c9users.io/alteravagavalor/"+modeledt.vagavalorid,
      		data: JSON.stringify(modeledt),  
    	}).done(function(e){
    		limpaCampos();
    		$("#tbody1").html("");
    		listar();
       	});
        $.ajax({
            contentType: "application/json",
            url: "@{HistoricoVagaValorR}",
            type: "POST",
            data: JSON.stringify(modeledt),
            success: function(){
				$("#alteracao").html("Histórico de alteração de valor atualizado com sucesso!");
            }
        });
       	ajusteEdit();
	}
	function cancelarEdit(){
    	selecao();
    	$("input[name='diurno']").val($('tr[select="select"]').find('span[id="valordiurno"]').html());
		$("input[name='noturno']").val($('tr[select="select"]').find('span[id="valornoturno"]').html());
		$("#funcionario").val($('tr[select="select"]').find('span[id="nmFuncionario"]').html());
    	ajusteEdit();
	}
	function cancelar(){
    	selecao();
    	$("tbody tr").css("background-color","#fff");   
    	ajuste();
	}
	function selecao(){
    	$("tbody tr").css("cursor","pointer");
       	$("tbody tr").click(function(){
         	$("#btnAlterar").removeAttr("disabled","disabled").attr("onclick","alterar()");
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
    function ajuste(){
	    $("tbody tr").on("click");
	    limpaCampos();
	    $("#btnNovo").attr("onclick","novo()");
	    $("input[name='diurno'], input[name='noturno'], #funcionario, #tbody1").attr("disabled","disabled");
	    $("#btnAlterar, #btnConfirmar, #btnCancelar").removeAttr("onclick");
	    $("#btnAlterar, #btnConfirmar, #btnCancelar").attr("disabled","disabled");
	    $("input[name='diurno']").css("border-color","#fff");
    }
    function ajusteEdit(){
	    $("tbody tr").on("click");
	    $("#btnNovo").attr("onclick","novo()");
	    $("#btnNovo").removeAttr("disabled","disabled");
	    $("input[name='diurno'], input[name='noturno'], #funcionario, #tbody1, #btnConfirmar, #btnCancelar").attr("disabled","disabled");
	    $("#btnConfirmar, #btnCancelar").removeAttr("onclick");
	    $("input[name='diurno']").css("border-color","#fff");
	}
    function limpaCampos(){
		$("input[name='diurno'], input[name='noturno']").val("");
		$("#funcionario").val("1");
	}
  |]

getVagaR :: Handler Html
getVagaR = defaultLayout $ do
  addScriptRemote "https://ajax.googleapis.com/ajax/libs/jquery/1.12.0/jquery.min.js"
  [whamlet|
    <h1>Cadastro de vagas
    <button id="btnNovo">Novo
    <button id="btnAlterar">Alterar
    <form>
    Vaga: <select id="vaga"></select>
    Diurno: <select id="optDiurno"><option value="livre">LIVRE</option><option value="ocupadoMensal">OCUPADO MENSAL</option><option value="ocupadoAvulso">OCUPADO AVULSO</option></select>
    Noturno: <select id="optNoturno"><option value="livre">LIVRE</option><option value="ocupadoMensal">OCUPADO MENSAL</option><option value="ocupadoAvulso">OCUPADO AVULSO</option></select>
    Id vaga valor: <select id="vagaValor"></select>
    <button id="btnCancelar">cancelar
    <button id="btnConfirmar">confirmar
    <table id="table1">
        <caption>Vagas disponíveis</caption>
            <thead>
                <tr>
                    <th>Id/Vaga
                    <th>Diurno
                    <th>Noturno
                    <th>Id vaga valor
            <tbody id="tbody1">
  |]
  toWidget [julius|
    $(listar());
    $(optVagaValor());
    $(optVaga());
    var modeledt = {};
    function optVagaValor(){
        var opt = "<option value='0'></option>";
   		$.ajax({
			contentType: "application/json",
            url: "@{ListaVagaValorR}",
            type: "GET",
    	}).done(function(e){
       		for(var i = 0; i<e.data.length; i++){
           		opt+="<option value='"+e.data[i].id+"'>"+e.data[i].id+"</option>";
           	}
           	$("#vagaValor").html(opt);
        });
    }
    function optVaga(){
        var opt = "<option value='0'></option>";
   		$.ajax({
			contentType: "application/json",
            url: "@{ListaVagaR}",
            type: "GET",
    	}).done(function(e){
       		for(var i = 0; i<e.data.length; i++){
       		    opt+="<option value='"+e.data[i].id+"'>"+e.data[i].id+"</option>";
           	}
           	$("#vaga").html(opt);
        });
    }
    function confirmar(){
        $.ajax({
            contentType: "application/json",
            url: "@{VagaR}",
            type: "POST",
            data: JSON.stringify({"diurno":$("#optDiurno").val(),"noturno":$("#optNoturno").val(),"vagavalorid":parseInt($("#vagaValor").val())}),
            success: function(){
				$("#vaga, #optDiurno, #optNoturno, #vagaValor").val("");
       			listar();
            }
        });
    	$("tbody tr").css("background-color","#fff");   
	}
    function listar(){
    	ajuste();
    	var itens = "";
   		$.ajax({
			contentType: "application/json",
            url: "@{ListaVagaR}",
            type: "GET",
    	}).done(function(e){
       		for(var i = 0; i<e.data.length; i++){
           		itens+="<tr>";
           		itens+="<td><span id='idVaga'>"
           		itens+=e.data[i].id;
           		itens+="</span></td>"
       	    	itens+="<td><span id='diurno'>"
           		itens+=e.data[i].diurno;
           		itens+="</span></td>"
       	    	itens+="<td><span id='noturno'>"
           		itens+=e.data[i].noturno;
           		itens+="</span></td>"
             	itens+="<td><span id='idVagaValor'>"
           		itens+=e.data[i].vagavalorid;
             	itens+="</span></td>"
	           	itens+="</tr>";
           	}
		    $("#tbody1").html(itens);
		    selecao();
        });
    }
    function novo(){
    	$("tbody tr").off("click");
    	limpaCampos();
    	$("#btnAlterar, #btnNovo").removeAttr("onclick");
    	$("#optDiurno, #optNoturno, #vagaValor, #tbody1, #btnCancelar, #btnConfirmar").removeAttr("disabled","disabled");
    	$("#btnConfirmar").attr("onclick","confirmar()");
    	$("#btnCancelar").attr("onclick","cancelar()");
    	$("#btnAlterar").attr("disabled","disabled");
	}
	function alterar(){
    	$("tbody tr").off("click");
    	$("#btnNovo").removeAttr("onclick").attr("disabled","disabled");
		$("#optDiurno, #optNoturno, #vagaValor, #tbody1, #btnConfirmar, #btnCancelar").removeAttr("disabled","disabled");
    	$("#btnConfirmar").attr("onclick","confedit()");
    	$("#btnCancelar").attr("onclick","cancelarEdit()");
	}
	function confedit(){
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
    		limpaCampos();
    		$("#tbody1").html("");
    		listar();
       	});
       	ajusteEdit();
	}
	function cancelarEdit(){
    	selecao();
    	$("#optDiurno").val($('tr[select="select"]').find('span[id="diurno"]').html());
		$("#optNoturno").val($('tr[select="select"]').find('span[id="noturno"]').html());
		$("#vagaValor").val($('tr[select="select"]').find('span[id="idVagaValor"]').html());
    	ajusteEdit();
	}
	function cancelar(){
    	selecao();
    	$("tbody tr").css("background-color","#fff");   
    	ajuste();
	}
	function selecao(){
    	$("tbody tr").css("cursor","pointer");
       	$("tbody tr").click(function(){
         	$("#btnAlterar").removeAttr("disabled","disabled").attr("onclick","alterar()");
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
    function ajuste(){
	    $("tbody tr").on("click");
	    limpaCampos();
	    $("#btnNovo").attr("onclick","novo()");
	    $("#vaga, #optDiurno, #optNoturno, #vagaValor, #tbody1").attr("disabled","disabled");
	    $("#btnAlterar, #btnConfirmar, #btnCancelar").removeAttr("onclick");
	    $("#btnAlterar, #btnConfirmar, #btnCancelar").attr("disabled","disabled");
    }
    function ajusteEdit(){
	    $("tbody tr").on("click");
	    $("#btnNovo").attr("onclick","novo()");
	    $("#btnNovo").removeAttr("disabled","disabled");
	    $("#vaga, #optDiurno, #optNoturno, #vagaValor, #tbody1, #btnConfirmar, #btnCancelar").attr("disabled","disabled");
	    $("#btnConfirmar, #btnCancelar").removeAttr("onclick");
	}
    function limpaCampos(){
		$("#vaga, #optDiurno, #optNoturno, #vagaValor").val("");
	}
  |]

getListaR :: Handler ()
getListaR = do
    allClientes <- runDB $ selectList [] [Asc ClientNome]
    sendResponse (object [pack "data" .= fmap toJSON allClientes])

getListaContratoR :: Handler ()
getListaContratoR = do
    allContratos <- runDB $ selectList [] [Asc ContratoId]
    sendResponse (object [pack "data" .= fmap toJSON allContratos])

getListaAvulsoR :: Handler ()
getListaAvulsoR = do
    allAvulsos <- runDB $ selectList [] [Asc AvulsoId]
    sendResponse (object [pack "data" .= fmap toJSON allAvulsos])

getListaConveniadoR :: Handler ()
getListaConveniadoR = do
    allconvs <- runDB $ selectList [] [Asc ConveniadoId]
    sendResponse (object [pack "data" .= fmap toJSON allconvs])

getListaEventoR :: Handler ()
getListaEventoR = do
    alleventos <- runDB $ selectList [] [Asc EventoId]
    sendResponse (object [pack "data" .= fmap toJSON alleventos])

getListaTpVeiculoR :: Handler ()
getListaTpVeiculoR = do
    allVec <- runDB $ selectList [] [Asc TipoVeiculoNome]
    sendResponse (object [pack "data" .= fmap toJSON allVec])
    
getListaVeiculoR :: Handler ()
getListaVeiculoR = do
    allVe <- runDB $ selectList [] [Asc VeiculoId]
    sendResponse (object [pack "data" .= fmap toJSON allVe])

getListaFuncionarioR :: Handler ()
getListaFuncionarioR = do
    allFuncionarios <- runDB $ selectList [] [Asc FuncionarioId]
    sendResponse (object [pack "data" .= fmap toJSON allFuncionarios])

getListaVagaValorR :: Handler ()
getListaVagaValorR = do
    allVagaValor <- runDB $ selectList [] [Asc VagaValorId]
    sendResponse (object [pack "data" .= fmap toJSON allVagaValor])

getListaVagaR :: Handler ()
getListaVagaR = do
    allVaga <- runDB $ selectList [] [Asc VagaId]
    sendResponse (object [pack "data" .= fmap toJSON allVaga])

getHistoricoVagaValorR :: Handler ()
getHistoricoVagaValorR = do
    allHistoricoVagaValor <- runDB $ selectList [] [Asc HistoricoVagaValorId]
    sendResponse (object [pack "data" .= fmap toJSON allHistoricoVagaValor])

--------------------------------------------------------
--              METHODS POST
--------------------------------------------------------
postClientR :: Handler ()
postClientR = do
    clientes <- requireJsonBody :: Handler Client
    runDB $ insert clientes
    sendResponse (object [pack "data" .= pack "CREATED"])

postVeiculoR :: Handler ()
postVeiculoR = do
    veiculo <- requireJsonBody :: Handler Veiculo
    runDB $ insert veiculo
    sendResponse (object [pack "resp" .= pack "CREATED"])
    
postTipoVeiculoR :: Handler ()
postTipoVeiculoR = do
    tipoveiculo <- requireJsonBody :: Handler TipoVeiculo
    runDB $ insert tipoveiculo
    sendResponse (object [pack "resp" .= pack "CREATED"])
    
postContratoR :: Handler ()
postContratoR = do
    contrato <- requireJsonBody :: Handler Contrato
    runDB $ insert contrato
    sendResponse (object [pack "resp" .= pack "CREATED"])
    
postVagaR :: Handler ()
postVagaR = do
    vaga <- requireJsonBody :: Handler Vaga
    runDB $ insert vaga
    sendResponse (object [pack "resp" .= pack "CREATED"])

postVagaValorR :: Handler ()
postVagaValorR = do
    vagavalor <- requireJsonBody :: Handler VagaValor
    runDB $ insert vagavalor
    sendResponse (object [pack "resp" .= pack "CREATED"])
    
postEventoR :: Handler ()
postEventoR = do
    evento <- requireJsonBody :: Handler Evento
    runDB $ insert evento
    sendResponse (object [pack "resp" .= pack "CREATED"])
    
postConveniadoR :: Handler ()
postConveniadoR = do
    conveniado <- requireJsonBody :: Handler Conveniado
    runDB $ insert conveniado
    sendResponse (object [pack "resp" .= pack "CREATED"])
    
postAvulsoR :: Handler ()
postAvulsoR = do
    avulso <- requireJsonBody :: Handler Avulso
    runDB $ insert avulso
    sendResponse (object [pack "resp" .= pack "CREATED"])
    
postFuncionarioR :: Handler ()
postFuncionarioR = do
    funcionario <- requireJsonBody :: Handler Funcionario
    runDB $ insert funcionario
    sendResponse (object [pack "resp" .= pack "CREATED"])

postHistoricoVagaValorR :: Handler ()
postHistoricoVagaValorR = do
    historicovagavalor <- requireJsonBody :: Handler HistoricoVagaValor
    runDB $ insert historicovagavalor
    sendResponse (object [pack "resp" .= pack "CREATED"])

-----------------------------------------------------------
--                  METHODS PUT
-----------------------------------------------------------
putUpdateR :: ClientId -> Handler ()
putUpdateR pid = do
    cli <- requireJsonBody :: Handler Client 
    runDB $ update pid [ClientNome =. clientNome cli, ClientFlcliente =. clientFlcliente cli,ClientTelefone =. clientTelefone cli,ClientRg =. clientRg cli,ClientSexo =. clientSexo cli, ClientCpf =. clientCpf cli, ClientLogradouro =. clientLogradouro cli, ClientCidade =. clientCidade cli, ClientEstado =. clientEstado cli, ClientBairro =. clientBairro cli, ClientCep =. clientCep cli, ClientCnpj =. clientCnpj cli, ClientRazaosocial =. clientRazaosocial cli ] 
    sendResponse (object [pack "resp" .= pack "UPDATED"])
    
putContratoUpdateR :: ContratoId -> Handler ()
putContratoUpdateR cid = do
    ct <- requireJsonBody :: Handler Contrato
    runDB $ update cid [ContratoValor =. contratoValor ct, ContratoContratoinc =. contratoContratoinc ct, ContratoContratofim =. contratoContratofim ct, ContratoQuantidadeparcela =. contratoQuantidadeparcela ct, ContratoQuantidadevagas =. contratoQuantidadevagas ct, ContratoClienteid =. contratoClienteid ct]
    sendResponse (object [pack "resp" .= pack "UPDATED"])
    
putUpdateConveniadoR :: ConveniadoId -> Handler ()
putUpdateConveniadoR convid = do
    convs <- requireJsonBody :: Handler Conveniado
    runDB $ update convid [ConveniadoNome =. conveniadoNome convs, ConveniadoPercentualDesconto =. conveniadoPercentualDesconto convs, ConveniadoEventoid =. conveniadoEventoid convs]
    sendResponse (object [pack "resp" .= pack "UPDATED"])    
    
putUpdateEventoR :: EventoId -> Handler ()
putUpdateEventoR evid = do
    evs <- requireJsonBody :: Handler Evento
    runDB $ update evid [EventoDescricao =. eventoDescricao evs, EventoPercentualDesconto =. eventoPercentualDesconto evs, EventoClienteid =. eventoClienteid evs]
    sendResponse (object [pack "resp" .= pack "UPDATED"])        
    
putTipoVeiUpdateR :: TipoVeiculoId -> Handler ()
putTipoVeiUpdateR  tvid = do
    tpv <- requireJsonBody :: Handler TipoVeiculo 
    runDB $ update tvid [TipoVeiculoNome =. tipoVeiculoNome tpv ]
    sendResponse (object [pack "resp" .= pack "UPDATED"])
    
putVeiUpdateR :: VeiculoId -> Handler ()
putVeiUpdateR vid = do
    pv <- requireJsonBody :: Handler Veiculo 
    runDB $ update vid [VeiculoPlaca =. veiculoPlaca pv, VeiculoDescricao =. veiculoDescricao pv, VeiculoMarca =. veiculoMarca pv, VeiculoAno =. veiculoAno pv, VeiculoCor =. veiculoCor pv, VeiculoTipoveiculoid =. veiculoTipoveiculoid pv, VeiculoClienteid =. veiculoClienteid pv ]
    sendResponse (object [pack "resp" .= pack "UPDATED"])

putUpdateFuncionarioR :: FuncionarioId -> Handler ()
putUpdateFuncionarioR pid = do
    fun <- requireJsonBody :: Handler Funcionario
    runDB $ update pid [FuncionarioSenha =. funcionarioSenha fun ,FuncionarioAtivo =. funcionarioAtivo fun]
    sendResponse (object [pack "resp" .= pack "UPDATED"])

putUpdateVagaValorR :: VagaValorId -> Handler ()
putUpdateVagaValorR pid = do
    vava <- requireJsonBody :: Handler VagaValor
    runDB $ update pid [VagaValorValordiurno =. vagaValorValordiurno vava, VagaValorValornoturno =. vagaValorValornoturno vava, VagaValorFuncionarioid =. vagaValorFuncionarioid vava]
    sendResponse (object [pack "resp" .= pack "UPDATED"])

putUpdateVagaR :: VagaId -> Handler ()
putUpdateVagaR pid = do
    va <- requireJsonBody :: Handler Vaga
    runDB $ update pid [VagaDiurno =. vagaDiurno va,VagaNoturno =. vagaNoturno va,VagaVagavalorid =. vagaVagavalorid va]
    sendResponse (object [pack "resp" .= pack "UPDATED"])
-----------------------------------------------------------
--                  METHODS DELETE
-----------------------------------------------------------   

deleteDeleteR :: ClientId -> Handler ()
deleteDeleteR pid = do
    runDB $ delete pid
    sendResponse (object [pack "resp" .= pack "DELETED"])

deleteContratoDeleteR :: ContratoId -> Handler ()
deleteContratoDeleteR cid = do
    runDB $ delete cid
    sendResponse (object [pack "resp" .= pack "DELETED"])

deleteDeleteAvulsoR :: AvulsoId -> Handler ()
deleteDeleteAvulsoR aid = do
    runDB $ delete aid
    sendResponse (object [pack "resp" .= pack "DELETED"])  
    
deleteDeleteConveniadoR :: ConveniadoId -> Handler ()
deleteDeleteConveniadoR convid = do
    runDB $ delete convid
    sendResponse (object [pack "resp" .= pack "DELETED"])
    
deleteDeleteEventoR :: EventoId -> Handler ()
deleteDeleteEventoR evid = do
    runDB $ delete evid
    sendResponse (object [pack "resp" .= pack "DELETED"])      
    
deleteTipoVeiDeleteR :: TipoVeiculoId -> Handler ()
deleteTipoVeiDeleteR tvid = do
    runDB $ delete tvid
    sendResponse (object [pack "resp" .= pack "DELETED"])
    
deleteVeiDeleteR :: VeiculoId -> Handler ()
deleteVeiDeleteR vid = do
    runDB $ delete vid
    sendResponse (object [pack "resp" .= pack "DELETED"])

deleteDeleteFuncionarioR :: FuncionarioId -> Handler ()
deleteDeleteFuncionarioR fid = do
    runDB $ delete fid
    sendResponse (object [pack "resp" .= pack "DELETED"])

deleteDeleteVagaR :: VagaId -> Handler ()
deleteDeleteVagaR vaid = do
    runDB $ delete vaid
    sendResponse (object [pack "resp" .= pack "DELETED"])

deleteDeleteVagaValorR :: VagaValorId -> Handler ()
deleteDeleteVagaValorR vavaid = do
    runDB $ delete vavaid
    sendResponse (object [pack "resp" .= pack "DELETED"])

deleteDeleteHistoricoVagaValorR :: HistoricoVagaValorId -> Handler ()
deleteDeleteHistoricoVagaValorR hvvid = do
    runDB $ delete hvvid
    sendResponse (object [pack "resp" .= pack "DELETED"])