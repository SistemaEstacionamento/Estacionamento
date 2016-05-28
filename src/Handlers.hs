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
  addScriptRemote "https://ajax.googleapis.com/ajax/libs/jquery/1.12.0/jquery.min.js"
  [whamlet|
<button id="btn-nv">Novo</button>
<button id="btn-alt">Alterar</button>
    <form>
    Tipo: <select id="flcliente"><option value="f"> Fisico </option><option value="j"> Juridico </option></select>
    Nome: <input type="text" id="nome">
    Telefone: <input type="text" id="telefone">
    RG: <input type="text" id="rg">
    Sexo: <input type="text" id="sexo">
    CPF: <input type="text" id="cpf">
    CNPJ: <input type="text" id="cnpj">
    Razão Social: <input type="text" id="razaosocial">
    Logradouro: <input type="text" id="logradouro">
    Cidade: <input type="text" id="cidade">
    Estado: <input type="text" id="estado">
    Bairro: <input type="text" id="bairro">
    CEP: <input type="text" id="cep">
    <button id="btn-canc">cancelar</button>
    <button id="btn-conc">confirmar</button>
    <table id="t1">
        <thead>
            <tr>
            <th>ID
            <th>Nome
            <th>Telefone
        <tbody id="tb">
  |] 
  toWidget [julius|
  		$(listar());
		var modeledt = {};
		function confirmar(){
            $.ajax({
                 contentType: "application/json",
                 url: "@{ClientR}",
                 type: "POST",
                 data: JSON.stringify({"nome":$("#nome").val(),"flcliente":$("#flcliente").val(),"telefone":$("#telefone").val(),"rg":$("#rg").val(),"sexo":$("#sexo").val(),"cpf":$("#cpf").val(),"cnpj":$("#cnpj").val(),"razaosocial":$("#razaosocial").val(),"logradouro":$("#logradouro").val(),"cidade":$("#cidade").val(),"estado":$("#estado").val(),"bairro":$("#bairro").val(),"cep":$("#cep").val()}),
                 success: function(){
					$("#nome").val("");
					$("#flcliente").val("f");
					$("#telefone").val("");
					$("#rg").val("");
					$("#sexo").val("");
					$("#cpf").val("");
					$("#cnpj").val("")
					$("#razaosocial").val("");
					$("#logradouro").val("");
					$("#cidade").val("");
					$("#estado").val("");
					$("#bairro").val("");
					$("#cep").val("");	
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
           			$("#nome").val("");
					$("#flcliente").val("f");
					$("#telefone").val("");
					$("#rg").val("");
					$("#sexo").val("");
					$("#cpf").val("");
					$("#cnpj").val("")
					$("#razaosocial").val("");
					$("#logradouro").val("");
					$("#cidade").val("");
					$("#estado").val("");
					$("#bairro").val("");
					$("#cep").val("");	
       				$("#tb").html("");
       				listar();
        		});
        		ajusteEdit();
		}

		function novo(){
    		$('tbody tr').off("click")
    		$('input[name="nome"]').val("");
    		$('#btn-alt').removeAttr("onclick");
    		$('#btn-nv').removeAttr("onclick");
    		$("#nome").removeAttr("disabled","disabled");
			$("#flcliente").removeAttr("disabled","disabled");
			$("#telefone").removeAttr("disabled","disabled");
			$("#rg").removeAttr("disabled","disabled");
			$("#sexo").removeAttr("disabled","disabled");
			$("#cpf").removeAttr("disabled","disabled");
			$("#cnpj").removeAttr("disabled","disabled");
			$("#razaosocial").removeAttr("disabled","disabled");
			$("#logradouro").removeAttr("disabled","disabled");
			$("#cidade").removeAttr("disabled","disabled");
			$("#estado").removeAttr("disabled","disabled");
			$("#bairro").removeAttr("disabled","disabled");
			$("#cep").removeAttr("disabled","disabled");
			$("#tb").removeAttr("disabled","disabled");
    		$('#btn-conc').attr("onclick","confirmar()");
    		$('#btn-canc').attr("onclick","cancelar()");
    		$('#btn-canc').removeAttr("disabled",'disabled');
    		$('#btn-conc').removeAttr("disabled",'disabled');
    		$('#btn-alt').attr("disabled",'disabled');
    		ajustefisicojuridico();
		}
		
		function ajustefisicojuridico(){
			$("#cnpj").attr("disabled","disabled");
        	$("#razaosocial").attr("disabled","disabled");
        	$("#flcliente").click(function(){
        		if($("#flcliente").val()=="f"){
         			$("#cnpj").attr("disabled","disabled");
         			$("#razaosocial").attr("disabled","disabled");
         			$("#rg").removeAttr("disabled","disabled");
         			$("#sexo").removeAttr("disabled","disabled");
         			$("#cpf").removeAttr("disabled","disabled");
         		}else{
	          		$("#rg").attr("disabled","disabled");
         			$("#sexo").attr("disabled","disabled");
         			$("#cpf").attr("disabled","disabled");
         			$("#cnpj").removeAttr("disabled","disabled");
         			$("#razaosocial").removeAttr("disabled","disabled");
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
    		$('input[name="nome"]').val($('tr[select="select"]').find('span[id="nm"]').html());
    		
    		ajusteEdit();
		}
	
		function alterar(){
    		$('tbody tr').off("click");
    		$('#btn-nv').removeAttr("onclick");
    		$('#btn-nv').attr("disabled",'disabled');
    		$("#nome").removeAttr("disabled","disabled");
			$("#flcliente").removeAttr("disabled","disabled");
			$("#telefone").removeAttr("disabled","disabled");
			$("#rg").removeAttr("disabled","disabled");
			$("#sexo").removeAttr("disabled","disabled");
			$("#cpf").removeAttr("disabled","disabled");
			$("#cnpj").removeAttr("disabled","disabled");
			$("#razaosocial").removeAttr("disabled","disabled");
			$("#logradouro").removeAttr("disabled","disabled");
			$("#cidade").removeAttr("disabled","disabled");
			$("#estado").removeAttr("disabled","disabled");
			$("#bairro").removeAttr("disabled","disabled");
			$("#cep").removeAttr("disabled","disabled");
			$("#tb").removeAttr("disabled","disabled");
    		$('#btn-conc').attr("onclick","confedit()");
    		$('#btn-canc').attr("onclick","cancelarEdit()");
    		$('#btn-conc').removeAttr("disabled",'disabled');
    		$('#btn-canc').removeAttr("disabled",'disabled');
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
     		if(confirm("Confirma a exclusão do usuário "+$('button[onclick="excluir('+x+')"').parent().parent().find('span[id="nm"]').html()+"?")){
        		$.ajax({
        			type: 'DELETE',
        			dataType: "json",
        			cache: false,
        			contentType:"application/json",    
        			url: 'https://estacionamento-bruno-alcamin.c9users.io/delete/'+x,
        		});
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
		    $("#nome").val("");
			$("#flcliente").val("f");
			$("#telefone").val("");
			$("#rg").val("");
			$("#sexo").val("");
			$("#cpf").val("");
			$("#cnpj").val("")
			$("#razaosocial").val("");
			$("#logradouro").val("");
			$("#cidade").val("");
			$("#estado").val("");
			$("#bairro").val("");
			$("#cep").val("");	
		    $('#btn-nv').attr("onclick","novo()");
		    $("#nome").attr("disabled","disabled");
			$("#flcliente").attr("disabled","disabled");
			$("#telefone").attr("disabled","disabled");
			$("#rg").attr("disabled","disabled");
			$("#sexo").attr("disabled","disabled");
			$("#cpf").attr("disabled","disabled");
			$("#cnpj").attr("disabled","disabled");
			$("#razaosocial").attr("disabled","disabled");
			$("#logradouro").attr("disabled","disabled");
			$("#cidade").attr("disabled","disabled");
			$("#estado").attr("disabled","disabled");
			$("#bairro").attr("disabled","disabled");
			$("#cep").attr("disabled","disabled");
			$("#tb").attr("disabled","disabled");
		    $('#btn-alt').removeAttr("onclick");
		    $('#btn-alt').attr("disabled",'disabled');
		    $('#btn-conc').attr("disabled",'disabled');
		    $('#btn-canc').attr("disabled",'disabled');
		    $('#btn-conc').removeAttr("onclick");
		    $('#btn-canc').removeAttr("onclick");
		    $('input[name="nome"]').css("border-color","#fff");
		}

		function ajusteEdit(){
		    $('tbody tr').on("click");
		    $('#btn-nv').attr("onclick","novo()");
		    $('#btn-nv').removeAttr("disabled",'disabled');
		    $("#nome").attr("disabled","disabled");
			$("#flcliente").attr("disabled","disabled");
			$("#telefone").attr("disabled","disabled");
			$("#rg").attr("disabled","disabled");
			$("#sexo").attr("disabled","disabled");
			$("#cpf").attr("disabled","disabled");
			$("#cnpj").attr("disabled","disabled");
			$("#razaosocial").attr("disabled","disabled");
			$("#logradouro").attr("disabled","disabled");
			$("#cidade").attr("disabled","disabled");
			$("#estado").attr("disabled","disabled");
			$("#bairro").attr("disabled","disabled");
			$("#cep").attr("disabled","disabled");
			$("#tb").attr("disabled","disabled");
		    $('#btn-conc').removeAttr("onclick");
		    $('#btn-canc').removeAttr("onclick");
		    $('#btn-conc').attr("disabled",'disabled');
		    $('#btn-canc').attr("disabled",'disabled');
		    $('input[name="nome"]').css("border-color","#fff");
		}
  |]
  
getTipoVeiculoR :: Handler Html
getTipoVeiculoR = defaultLayout $ do
  addScriptRemote "https://ajax.googleapis.com/ajax/libs/jquery/1.12.0/jquery.min.js"
  [whamlet|
    <form>
    Nome: <input type="text" id="nome">
    <button #btn> OK
    <table id="t1">
        <thead>
            <tr>
            <th>ID
            <th>Nome
        <tbody id="tb">
  |] 
  toWidget [julius|
     $(main);
     function main(){
     	$(listar());
        $("#btn").click(function(){
            $.ajax({
                 contentType: "application/json",
                 url: "@{TipoVeiculoR}",
                 type: "POST",
                 data: JSON.stringify({"nome":$("#nome").val()}),
                 success: function(){
					$("#nome").val("");
					listar();
                 }
            })
        });
        
       function listar(){
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
                		itens+="</td><td class='nomeprod'>";
            	    	itens+="<span id='nm'>"
                		itens+=e.data[i].nome;
                		itens+="</span>"
            	      	itens+="</td></tr>";
                	}
                	$("#tb").html(itens);
			});
		}
        }
	|]

getVeiculoR :: Handler Html
getVeiculoR = defaultLayout $ do
  addScriptRemote "https://ajax.googleapis.com/ajax/libs/jquery/1.12.0/jquery.min.js"
  [whamlet|
    <form>
    Clientes: <select id="clienteid"></select>
    Placa: <input type="text" id="placa">
    Descricao: <input type="text" id="descricao">
    Marca: <input type="text" id="marca">
    Ano: <input type="text" id="ano">
    Cor: <input type="text" id="cor">
    Tipos de Veiculo: <select id="tipoveiculoid"></select>
    <button #btn> OK
  |]     
  toWidget [julius|
     $(main);
     function main(){
     	$(listarClientes());
     	$(listarTiposveiculos());
        $("#btn").click(function(){
            $.ajax({
                 contentType: "application/json",
                 url: "@{VeiculoR}",
                 type: "POST",
                 data: JSON.stringify({"clienteid":parseInt($("#clienteid").val()),"placa":$("#placa").val(),"descricao":$("#descricao").val(),"marca":$("#marca").val(),"ano":$("#ano").val(),"cor":$("#cor").val(),"tipoveiculoid":parseInt($("#tipoveiculoid").val())}),
                 success: function(){
					$("#placa").val("");
					$("#clienteid").val("1");
					$("#descricao").val("");
					$("#marca").val("");
					$("#ano").val("");
					$("#cor").val("");
					$("#tipoveiculoid").val("1");
                 }
            })
        });
        
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
                url: "@{ListaVeiculoR}",
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
     }
  |]	
	


getListaR :: Handler ()
getListaR = do
    allClientes <- runDB $ selectList [] [Asc ClientNome]
    sendResponse (object [pack "data" .= fmap toJSON allClientes])

getListaVeiculoR :: Handler ()
getListaVeiculoR = do
    allVec <- runDB $ selectList [] [Asc TipoVeiculoNome]
    sendResponse (object [pack "data" .= fmap toJSON allVec])
        
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
    
    
-----------------------------------------------------------
--                  METHODS PUT
-----------------------------------------------------------
putUpdateR :: ClientId -> Handler ()
putUpdateR pid = do
    cli <- requireJsonBody :: Handler Client 
    runDB $ update pid [ClientNome =. clientNome cli ] 
    runDB $ update pid [ClientFlcliente =. clientFlcliente cli ]
    runDB $ update pid [ClientTelefone =. clientTelefone cli ]
    runDB $ update pid [ClientRg =. clientRg cli ]
    runDB $ update pid [ClientSexo =. clientSexo cli ]
    runDB $ update pid [ClientCpf =. clientCpf cli ]
    runDB $ update pid [ClientLogradouro =. clientLogradouro cli ]
    runDB $ update pid [ClientCidade =. clientCidade cli ]
    runDB $ update pid [ClientEstado =. clientEstado cli ]
    runDB $ update pid [ClientBairro =. clientBairro cli ]
    runDB $ update pid [ClientCep =. clientCep cli ]
    runDB $ update pid [ClientCnpj =. clientCnpj cli ]
    runDB $ update pid [ClientRazaosocial =. clientRazaosocial cli ]
    sendResponse (object [pack "resp" .= pack "UPDATED"])

-----------------------------------------------------------
--                  METHODS DELETE
-----------------------------------------------------------   

deleteDeleteR :: ClientId -> Handler ()
deleteDeleteR pid = do
    runDB $ delete pid
    sendResponse (object [pack "resp" .= pack "DELETED"])