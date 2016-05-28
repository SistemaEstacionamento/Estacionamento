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
    <button #btn> OK
    <table id="t1">
        <thead>
            <tr>
            <th>ID
            <th>Nome
            <th>Telefone
        <tbody id="tb">
  |] 
  toWidget [julius|
     $(main);
     function main(){
     	$(listar());
        $("#btn").click(function(){
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
            })
        });
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
        
    	function listar(){
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
	                	itens+="</td></tr>";
                	}
                	$("#tb").html(itens);
			});
		}
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