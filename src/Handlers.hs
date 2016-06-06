{-# LANGUAGE OverloadedStrings, QuasiQuotes,
             TemplateHaskell #-}
 
module Handlers where
import Import
import Yesod
import Foundation
import Control.Monad.Logger (runStdoutLoggingT)
import Control.Applicative
import Data.Text
import Yesod.Static

import Database.Persist.Postgresql


mkYesodDispatch "Sitio" pRoutes

--Menu de Navegação 
navMenu = do 
    addStylesheetRemote "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css"
    addScriptRemote "https://ajax.googleapis.com/ajax/libs/jquery/1.12.0/jquery.min.js"
    addScriptRemote "https://cdn.rawgit.com/twbs/bootstrap/v4-dev/dist/js/bootstrap.js"
    
    toWidgetHead [hamlet| 
      <meta charset="utf-8">
      <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
      <meta http-equiv="x-ua-compatible" content="ie=edge">
      <link href=@{StaticR style_css} rel="stylesheet">
    |] >> toWidget [lucius|
        .dropdown-toggle {
  	        margin-top: 20px !important;
  	        color: #ffffff !important;
        }
    |]
    
    [whamlet|
    <nav .navbar .nav-inline>
        <div .col-md-9 .col-lg-9>
            <a href=@{HomeR} title="Voltar á página inicial"><h1>Sistemas BGM | Estacionamento</h1>
        <div .col-md-3 .col-lg-3>
            <ul .nav>
                <li role="presentation" .dropdown>
                    <a .dropdown-toggle data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">MENU
                        <ul .dropdown-menu>
                            <li><a href=@{AvulsoR}>Cadastrar Registro Avulso
                            <li><a href=@{ClientR}>Cadastrar/Alterar Cliente
                            <li><a href=@{ContratoR}>Cadastrar/Alterar Contrato
                            <li><a href=@{ConveniadoR}>Cadastrar/Alterar Convênio
                            <li><a href=@{EventoR}>Cadastrar/Alterar Evento
                            <li><a href=@{VeiculoR}>Cadastrar/Alterar Veículo
                            <li><a href=@{TipoVeiculoR}>Cadastrar/Alterar Tipo de Veículo
                            <li><a href=@{VagaR}>Cadastrar/Alterar Vaga
                            <li><a href=@{VagaValorR}>Cadastrar/Alterar Valor da Vaga
                            <li><a href=@{HistoricoVagaValorR}>Histórico de Valores das Vagas
                             <li><a href=@{FuncionarioR}>Cadastrar/Alterar Funcionário</a>
|]


-- FOOTER
footer = [whamlet|
    <footer>
        <p>Sistemas BGM | Desenvolvido por Bruno Alcamin, Gustavo Ferreira e Melissa Moreira (2016)
    <script src=@{StaticR scripts_js}>    
|] 



-- HOME
getHomeR :: Handler Html
getHomeR = defaultLayout $ do
    setTitle "Sistema Estacionamento | Página Inicial"
    toWidgetHead [hamlet| 
      
      <link href=@{StaticR style_css} rel="stylesheet">
      
   |] >> toWidget [lucius|
       
       h1{ color: #ffffff !important; }
       h2{ color: #337AB7 !important; font-weight: bold; margin-top:5px; }
       h3{ color: #aaaaaa !important; }
       
   |] >> [whamlet|
   
    ^{navMenu}
    <div .jumbotron>
        <div .container>
            <h3>Sistemas BGM
            <h2> Bem-vindo ao Sistema do Estacionamento
            <div .list-group>
                <div .list-group-item href="#" .list-group-item .active>O que deseja fazer?
                <a .list-group-item href=@{AvulsoR}>Cadastrar Registro Avulso
                <a .list-group-item href=@{ClientR}>Cadastrar/Alterar Cliente
                <a .list-group-item href=@{ContratoR}>Cadastrar/Alterar Contrato
                <a .list-group-item href=@{ConveniadoR}>Cadastrar/Alterar Convênio
                <a .list-group-item href=@{EventoR}>Cadastrar/Alterar Evento
                <a .list-group-item href=@{VeiculoR}>Cadastrar/Alterar Veículo
                <a .list-group-item href=@{TipoVeiculoR}>Cadastrar/Alterar Tipo de Veículo
                <a .list-group-item href=@{VagaR}>Cadastrar/Alterar Vaga
                <a .list-group-item href=@{VagaValorR}>Cadastrar/Alterar Valor da Vaga
                <a .list-group-item href=@{HistoricoVagaValorR}>Histórico de Valores das Vagas
                <a .list-group-item href=@{FuncionarioR}>Cadastrar/Alterar Funcionário
                            
    ^{footer}
   |]

--CLIENTE
getClientR :: Handler Html
getClientR = defaultLayout $ do
  setTitle "Sistema Estacionamento | Cadastrar Cliente"
  toWidgetHead [hamlet| 
      <link href=@{StaticR style_css} rel="stylesheet">
   |] >> toWidget [lucius|
       h1{ color: #ffffff !important; } 
   |]
    
  [whamlet|

^{navMenu}

<div .container>
    <div id="formulario" .col-md-12 .col-lg-12>
        <h2>Cadastrar Cliente</h2>
        <br>
        <button id="btn-nv" .btn .btn-primary-outline .col-md-offset-2 .col-lg-offset-2 >Novo</button>
        <button id="btn-alt" .btn .btn-primary-outline>Alterar</button>
        <br><br>
            
        <form .form-horizontal role="form">
        
            <div .form-group>
                <label .control-label .col-md-2 for="flcliente">Tipo: 
                <div .col-md-5>
                    <select .form-control id="flcliente" title="Selecione o tipo de cliente" required ><option value="f"> Fisico </option><option value="j"> Juridico </option></select>
            
            <div .fisico .form-group>
                <label .control-label .col-md-2 for="nome">Nome: 
                <div .col-md-5>
                    <input .form-control type="text" id="nome" required placeholder="Nome do Cliente" title="Digite o nome do cliente">
                        
            <div .fisico .form-group>
                <label .control-label .col-md-2 for="rg">RG: 
                <div .col-md-5>
                    <input id="rg" .form-control type="text" required placeholder="RG do Cliente" title="Digite o RG do cliente">
                        
            <div .fisico .form-group>
                <label .control-label .col-md-2 for="sexo">Sexo: 
                <div .col-md-5>
                        <input id="sexo" .form-control type="text" required placeholder="Sexo do Cliente" title="Digite o sexo do cliente">
                        
            <div .fisico .form-group>
                <label .control-label .col-md-2 for="cpf">CPF: 
                <div .col-md-5>
                    <input id="cpf" .form-control type="text" required placeholder="CPF do Cliente" title="Digite o CPF do cliente">
                
            <div .juridico .form-group>
                <label .control-label .col-md-2 for="cnpj">CNPJ: 
                <div .col-md-5>
                    <input id="cnpj" .form-control type="text" required placeholder="CNPJ do Cliente" title="Digite o CNPJ do cliente">
                        
            <div .juridico .form-group>
                <label .control-label .col-md-2 for="razaosocial">Razão Social: 
                <div .col-md-5>
                    <input id="razaosocial" .form-control type="text" required placeholder="Razão social do Cliente" title="Digite a razão social do cliente">
            
            <div .endereco .form-group>  
                <label .control-label .col-md-2 for="telefone">Telefone:
                <div .col-md-5>
                    <input id="telefone" .form-control type="text" required placeholder="Telefone do Cliente" title="Digite o telefone do cliente">
                        
            <div .endereco .form-group>  
                <label .control-label .col-md-2 for="logradouro">Logradouro:
                <div .col-md-5>
                    <input id="logradouro" .form-control type="text" required placeholder="Logradouro do Cliente" title="Digite o logradouro do cliente">
                        
            <div .endereco .form-group>  
                <label .control-label .col-md-2 for="cidade">Cidade:
                <div .col-md-5>
                    <input id="cidade" .form-control type="text" required placeholder="Cidade do Cliente" title="Digite a cidade do cliente">
                        
            <div .endereco .form-group>  
                <label .control-label .col-md-2 for="estado">Estado:
                <div .col-md-5>
                    <input id="estado" .form-control type="text" required placeholder="Estado do Cliente" title="Digite o estado do cliente">
                        
            <div .endereco .form-group>  
                <label .control-label .col-md-2 for="bairro">Bairro:
                <div .col-md-5>
                    <input id="bairro" .form-control type="text" required placeholder="Bairro do Cliente" title="Digite o bairro do cliente">
                        
            <div .endereco .form-group>  
                <label .control-label .col-md-2 for="cep">CEP:
                <div .col-md-5>
                    <input id="cep" .form-control type="text" required placeholder="CEP do Cliente" title="Digite o CEP do cliente">
            
            <br>
        <div .form-group  .col-md-12 .col-lg-12>    
            <button id="btn-canc" .btn .btn-danger .col-md-offset-2 .col-lg-offset-2 >Cancelar</button>
            <button id="btn-conc" .btn .btn-success>Confirmar</button>
    
    <div .col-md-8 .col-lg-8>
        <h3>Clientes Cadastrados
        <table id="t1" .table .table-hover>
            <thead .thead-inverse>
                <tr>
                    <th>ID
                    <th>Nome
                    <th>Telefone
                    <th>
            <tbody id="tb">

^{footer}

 |] >> toWidget [julius|
  
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
			            itens+="<button class='btn btn-danger' onclick='excluir("+e.data[i].id+")'>Excluir</button>";
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

  |] 


--CONTRATO

getContratoR :: Handler Html
getContratoR = defaultLayout $ do
  setTitle "Sistema Estacionamento | Cadastrar Contrato"
  toWidgetHead [hamlet| 
      <link href=@{StaticR style_css} rel="stylesheet">
   |] >> toWidget [lucius|
       h1{ color: #ffffff !important; } 
   |]
  
  [whamlet|
  
^{navMenu}

<div .container>
    <div id="formulario" .col-md-12 .col-lg-12>
        <h2>Cadastrar Contrato</h2>
        <br>
        <button id="btn-nv" .btn .btn-primary-outline .col-md-offset-2 .col-lg-offset-2 >Novo</button>
        <button id="btn-alt" .btn .btn-primary-outline>Alterar</button>
        <br><br>
            
        <form .form-horizontal role="form">
        
            <div .form-group>
                <label .control-label .col-md-2 for="valor">Valor: 
                <div .col-md-5 .input-group>
                    <span .input-group-addon>R$
                    <input .form-control type="number" id="valor" title="Digite o valor do contrato" required >
        
            <div .form-group>
                <label .control-label .col-md-2 for="inic">Início: 
                <div .col-md-5>
                    <input .form-control type="date" id="inic" title="Selecione a data de início do contrato" required >
                        
            <div .form-group>
                <label .control-label .col-md-2 for="fim">Fim: 
                <div .col-md-5>
                    <input .form-control type="date" id="fim" title="Selecione a data de encerramento do contrato" required >
                        
            <div .form-group>
                <label .control-label .col-md-2 for="qtparcelas">Quantidade de Parcelas: 
                <div .col-md-5>
                    <input .form-control type="number" id="qtparcelas" title="Digite a quantidade de parcelas" required >
                
            <div .form-group>
                <label .control-label .col-md-2 for="qtvagas">Quantidade de Vagas: 
                <div .col-md-5>
                    <input .form-control type="number" id="qtvagas" title="Digite a quantidade de vagas" required >
                        
            <div .form-group>
                <label .control-label .col-md-2 for="clienteid">Cliente: 
                <div .col-md-5>
                    <select .form-control id="clienteid" title="Selecione o cliente" required ></select>
                        
            <br>
        <div .form-group  .col-md-12 .col-lg-12>    
            <button id="btn-canc" .btn .btn-danger .col-md-offset-2 .col-lg-offset-2 >Cancelar</button>
            <button id="btn-conc" .btn .btn-success>Confirmar</button>
    
    <div .col-md-8 .col-lg-8>
        <h3>Contratos Cadastrados
        <table id="t1" .table .table-hover>
            <thead .thead-inverse>
                <tr>
                    <th>ID
                    <th>Valor
                    <th>Início
                    <th>Fim
                    <th>Parcelas
                    <th>Qt.Vagas
                    <th>Cliente
            <tbody id="tb">
            
^{footer}
  
|]  >> toWidget [julius|
     
    	$(listarContrato());
    	$(listarClientes());
		var modeledt = {};
		
		function confirmarContrato(){
			
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
                	
					limpaCamposContrato();	
					listarContrato();
                 },
                 error: function(){
                 	alert("ERRO!");
                 }
            });
        	ajuste();
        	$('tbody tr').css('background-color','#fff');   
		}

		function listarContrato(){
			ajusteContrato();
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
            	      	itens+="<button class='btn btn-danger' onclick='excluirContrato("+e.data[i].id+")'>Excluir</button>";
			            itens+="</td></tr>";
                	}
                	$("#tb").html(itens);
                	selecaoContrato();
			});
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
  toWidgetHead [hamlet| 
      <link href=@{StaticR style_css} rel="stylesheet">
   |] >> toWidget [lucius|
       h1{ color: #ffffff !important; } 
   |]
    
  [whamlet|

^{navMenu}

<div .container>
    <div id="formulario" .col-md-12 .col-lg-12>
        <h2>Cadastrar Convênio</h2>
        <br>
        <button id="btn-nv" .btn .btn-primary-outline .col-md-offset-2 .col-lg-offset-2 >Novo</button>
        <button id="btn-alt" .btn .btn-primary-outline>Alterar</button>
        <br><br>
            
        <form .form-horizontal role="form">
            <div .form-group>
                <label .control-label .col-md-2 for="nome">Nome: 
                <div .col-md-5>
                    <input .form-control type="text" id="nome" required placeholder="Nome do Convênio" title="Digite o nome do convênio">
                        
            <div .form-group>
                <label .control-label .col-md-2 for="desconto">Desconto: 
                <div .col-md-5 .input-group>
                    <input .col-md-3  .col-lg-3 .form-control type="number" id="desconto" required title="Digite o percentual de desconto. Exemplo: 15,50">
                    <span .input-group-addon>%
                        
            <div .form-group>
                <label .control-label .col-md-2 for="eventoid">Evento: 
                <div .col-md-5>
                    <select .form-control id="eventoid" title="Selecione o Evento (opcional)"></select>
                        
                <br>
        <div .form-group  .col-md-12 .col-lg-12>    
            <button id="btn-canc" .btn .btn-danger .col-md-offset-2 .col-lg-offset-2 >Cancelar</button>
            <button id="btn-conc" .btn .btn-success>Confirmar</button>
    
    <div .col-md-8 .col-lg-8>
        <h3>Convênios Cadastrados
        <table id="t1" .table .table-hover>
            <thead .thead-inverse>
                <tr>
                    <th>ID
                    <th>Convênio
                    <th>Desconto
                    <th>Evento
            <tbody id="tb">
^{footer}
  
|] >> toWidget [julius|
     
    	$(listarConveniado());
    	$(listarEventos());
		var modeledt = {};
		
		function confirmarConveniado(){
			
            $.ajax({
                 contentType: "application/json",
                 url: "@{ConveniadoR}",
                 type: "POST",
                 data: JSON.stringify({"nome":$("#nome").val(), 
                                       "percentualDesconto":parseFloat($("#desconto").val()),
                                       "eventoid":$("#eventoid").val() }),
                 success: function(){
                	
					limpaCamposConveniado();	
					listarConveniado();
                 },
                 error: function(){
                 	alert("ERRO!");
                 }
            });
        	ajusteConveniado();
        	$('tbody tr').css('background-color','#fff');   
		}
		
		function listarConveniado(){
			ajusteConveniado();
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
            	      	itens+="<button class='btn btn-danger' onclick='excluirConveniado("+e.data[i].id+")'>Excluir</button>";
			            itens+="</td></tr>";
                	}
                	$("#tb").html(itens);
                	selecaoConveniado();
			});
		}
		
		function listarEventos(){
    		var itens = "";
			$.ajax({
				contentType: "application/json",
                url: "@{ListaEventR} ",
                type: "GET",
    		}).done(function(e){
            		for(var i = 0; i<e.data.length; i++){
                		itens+="<option value="+e.data[i].id+">";
                		itens+=e.data[i].descricao;
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
  toWidgetHead [hamlet| 
      <link href=@{StaticR style_css} rel="stylesheet">
   |] >> toWidget [lucius|
       h1{ color: #ffffff !important; } 
   |]
    
  [whamlet|

^{navMenu}

<div .container>
    <div id="formulario" .col-md-12 .col-lg-12>
        <h2>Cadastrar Evento</h2>
        <br>
        <button id="btn-nv" .btn .btn-primary-outline .col-md-offset-2 .col-lg-offset-2 >Novo</button>
        <button id="btn-alt" .btn .btn-primary-outline>Alterar</button>
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
                <label .control-label .col-md-2 for="contratoid">Contrato:
                <div .col-md-5>
                    <select .form-control id="contratoid" title="Selecione o número do contrato" required ></select>
                        
                <br>
        <div .form-group  .col-md-12 .col-lg-12>    
            <button id="btn-canc" .btn .btn-danger .col-md-offset-2 .col-lg-offset-2 >Cancelar</button>
            <button id="btn-conc" .btn .btn-success>Confirmar</button>
    
    <div .col-md-8 .col-lg-8>
        <h3>Eventos Cadastrados
        <table id="t1" .table .table-hover>
            <thead .thead-inverse>
                <tr>
                    <th>ID
                    <th>Nome
                    <th>Descrição
                    <th>Desconto
                    <th>Contrato
            <tbody id="tb">
^{footer}
  
|] >> toWidget [julius|
     
    	$(listarEvento());
    	$(listarContratos());
		var modeledt = {};
		
		function confirmarEvento(){
			
            $.ajax({
                 contentType: "application/json",
                 url: "@{EventoR}",
                 type: "POST",
                 data: JSON.stringify({"descricao":$("#descricao").val(), 
                                       "percentualDesconto":parseInt($("#desconto").val()),
                                       "contratoid":parseInt($("#contratoid").val()) }),
                 success: function(){
                	
					limpaCamposEvento();	
					listarEvento();
                 },
                 error: function(){
                 	alert("ERRO!");
                 }
            });
        	ajusteEvento();
        	$('tbody tr').css('background-color','#fff');   
		}
		
		function listarEvento(){
			ajusteEvento();
    		var itens = "";
			$.ajax({
				contentType: "application/json",
                url: "@{ListaEventR} ",
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
                		itens+="<span id='contratoid'>"
                		itens+=e.data[i].contratoid;
                		itens+="</span>"
                		itens+="</td><td>";
            	      	itens+="<button class='btn btn-danger' onclick='excluirEvento("+e.data[i].id+")'>Excluir</button>";
			            itens+="</td></tr>";
                	}
                	$("#tb").html(itens);
                	selecaoEvento();
			});
		}
		
		function listarContratos(){
    		var itens = "";
			$.ajax({
				contentType: "application/json",
                url: "@{ListaContratoR}",
                type: "GET",
    		}).done(function(e){
            		for(var i = 0; i<e.data.length; i++){
                		itens+="<option value="+e.data[i].id+">";
                		itens+=e.data[i].id;
                		itens+="</option>";
                	}
                	$("#contratoid").append(itens);
			});
		}
		
|]
  


--AVULSO

getAvulsoR :: Handler Html
getAvulsoR = defaultLayout $ do
  setTitle "Sistema Estacionamento | Cadastrar Registro Avulso"
  toWidgetHead [hamlet| 
      <link href=@{StaticR style_css} rel="stylesheet">
   |] >> toWidget [lucius|
       h1{ color: #ffffff !important; } 
   |]
    
  [whamlet|

^{navMenu}

<div .container>
    <div id="formulario" .col-md-12 .col-lg-12>
        <h2>Cadastrar Registro Avulso</h2>
        <br>
        <button id="btn-nv" .btn .btn-primary-outline .col-md-offset-2 .col-lg-offset-2 >Novo</button>
        <button id="btn-alt" .btn .btn-primary-outline>Alterar</button>
        <br><br>
            
        <form .form-horizontal role="form">

            <div .form-group>
                <label .control-label .col-md-2 for="descricao">Descrição: 
                <div .col-md-5>
                    <input .form-control type="text" id="descricao" required placeholder="Descrição do Evento" title="Digite a descrição do evento">

            <div .form-group>
                <label .control-label .col-md-2 for="placa">Placa: 
                <div .col-md-5>
                    <input .form-control type="text" id="placa" required placeholder="Placa do Veículo" title="Digite a placa do veículo">
                    
            <div .form-group>
                <label .control-label .col-md-2 for="entrada">Entrada: 
                <div .col-md-5>
                    <input .form-control type="datetime-local" id="entrada" required title="Digite o horário de entrada do veículo">
                    
            <div .form-group>
                <label .control-label .col-md-2 for="saida">Saída: 
                <div .col-md-5>
                    <input .form-control type="datetime-local" id="saida" required title="Digite o horário de saída do veículo">
                    
            <div .form-group>
                <label .control-label .col-md-2 for="valor">Valor: 
                <div .col-md-5>
                    <input .form-control type="number" id="valor" required placeholder="Valor do registro" title="Digite o valor do registro">
                        
            <div .form-group>
                <label .control-label .col-md-2 for="vagaid">Vaga: 
                <div .col-md-5>
                    <select .form-control id="vagaid" required title="Selecione a vaga"></select>
            
            <div .form-group>
                <label .control-label .col-md-2 for="convenioid">Convênio: 
                <div .col-md-5>
                    <select .form-control id="convenioid" title="Selecione o convênio, se houver">
            
                <br>
        <div .form-group  .col-md-12 .col-lg-12>    
            <button id="btn-canc" .btn .btn-danger .col-md-offset-2 .col-lg-offset-2 >Cancelar</button>
            <button id="btn-conc" .btn .btn-success>Confirmar</button>
    
    <div .col-md-8 .col-lg-8>
        <h3>Registros Cadastrados
        <table id="t1" .table .table-hover>
            <thead .thead-inverse>
                <tr>
                    <th>ID
                    <th>Placa
                    <th>Entrada
                    <th>Saída
                    <th>Valor
                    <th>Vaga
                    <th>Convênio
            <tbody id="tb">
^{footer}

|] >> toWidget [julius|
     
    	$(listarAvulso());
    	$(listarVagas());
    	$(listarConvenios());
    	$('#btn-conc').attr("onclick","confirmarAvulso()");
    	$('#btn-canc').attr("onclick","limpaCamposAvulso()");
		
		function confirmarAvulso(){
			
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
                	
					limpaCamposAvulso();	
					listarAvulso();
                 },
                 error: function(){
                 	alert("ERRO!");
                 }
            });
		}

		function listarAvulso(){
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
            	      	itens+="<button class='btn btn-danger' onclick='excluirAvulso("+e.data[i].id+")'>Excluir</button>";
			            itens+="</td></tr>";
                	}
                	$("#tb").html(itens);
			});
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

--TIPO DE VEÍCULO
getTipoVeiculoR :: Handler Html
getTipoVeiculoR = defaultLayout $ do
  setTitle "Sistema Estacionamento | Cadastrar Tipo de Veículo"
  toWidgetHead [hamlet| 
      <link href=@{StaticR style_css} rel="stylesheet">
   |] >> toWidget [lucius|
       h1{ color: #ffffff !important; } 
   |]
    
  [whamlet|

^{navMenu}

<div .container>
    <div id="formulario" .col-md-12 .col-lg-12>
        <h2>Cadastrar Tipo de Veículo</h2>
        <br>
        <button id="btn-nv" .btn .btn-primary-outline .col-md-offset-2 .col-lg-offset-2 >Novo</button>
        <button id="btn-alt" .btn .btn-primary-outline>Alterar</button>
        <br><br>
            
        <form .form-horizontal role="form">

            <div .form-group>
                <label .control-label .col-md-2 for="nome">Nome: 
                <div .col-md-5>
                    <input .form-control type="text" id="nome" required placeholder="Digite o nome do veículo" title="Digite o nome do veículo">
                <br>
        <div .form-group  .col-md-12 .col-lg-12>    
            <button id="btn-canc" .btn .btn-danger .col-md-offset-2 .col-lg-offset-2 >Cancelar</button>
            <button id="btn-conc" .btn .btn-success>Confirmar</button>
    
    <div .col-md-8 .col-lg-8>
        <h3>Tipos de Veículos Cadastrados
        <table id="t1" .table .table-hover>
            <thead .thead-inverse>
                <tr>
                    <th>ID
                    <th>Nome
            <tbody id="tb">
^{footer}        

|] >> toWidget [julius|
     
     $(listarTipoVeiculo());
		var modeledt = {};
		
		function confirmarTipoVeiculo(){
            $.ajax({
                 contentType: "application/json",
                 url: "@{TipoVeiculoR}",
                 type: "POST",
                 data: JSON.stringify({"nome":$("#nome").val()}),
                 success: function(){
					limpaCamposTipoVeiculo();	
					listarTipoVeiculo();
                 }
            });
        	ajusteTipoVeiculo();
        	$('tbody tr').css('background-color','#fff');   
		}

		function listarTipoVeiculo(){
			ajusteTipoVeiculo();
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
            	      	itens+="<button class='btn btn-danger' onclick='excluirTipoVeiculo("+e.data[i].id+")'>Excluir</button>";
			            itens+="</td></tr>";
                	}
                	$("#tb").html(itens);
                	selecaoTipoVeiculo();
			});
		}

	|]

--VEÍCULO
getVeiculoR :: Handler Html
getVeiculoR = defaultLayout $ do
  setTitle "Sistema Estacionamento | Cadastrar Veículo"
  toWidgetHead [hamlet| 
      <link href=@{StaticR style_css} rel="stylesheet">
   |] >> toWidget [lucius|
       h1{ color: #ffffff !important; } 
   |]
    
  [whamlet|

^{navMenu}

<div .container>
    <div id="formulario" .col-md-12 .col-lg-12>
        <h2>Cadastrar Veículo</h2>
        <br>
        <button id="btn-nv" .btn .btn-primary-outline .col-md-offset-2 .col-lg-offset-2 >Novo</button>
        <button id="btn-alt" .btn .btn-primary-outline>Alterar</button>
        <br><br>
            
        <form .form-horizontal role="form">
        
            <div .form-group>
                <label .control-label .col-md-2 for="clienteid">Cliente: 
                <div .col-md-5>
                    <select .form-control id="clienteid" title="Selecione o cliente">

            <div .form-group>
                <label .control-label .col-md-2 for="placa">Placa: 
                <div .col-md-5>
                    <input .form-control type="text" id="placa" required placeholder="Digite a placa do veículo" title="Digite a placa do veículo">

            <div .form-group>
                <label .control-label .col-md-2 for="descricao">Descrição: 
                <div .col-md-5>
                    <input .form-control type="text" id="descricao" required placeholder="Digite a descrição do veículo" title="Digite a descrição do veículo">

            <div .form-group>
                <label .control-label .col-md-2 for="marca">Marca: 
                <div .col-md-5>
                    <input .form-control type="text" id="marca" required placeholder="Digite a marca do veículo" title="Digite a marca do veículo">

            <div .form-group>
                <label .control-label .col-md-2 for="ano">Ano: 
                <div .col-md-5>
                    <input .form-control type="text" id="ano" required placeholder="Digite o ano do veículo" title="Digite o ano do veículo">

            <div .form-group>
                <label .control-label .col-md-2 for="cor">Cor: 
                <div .col-md-5>
                    <input .form-control type="text" id="cor" required placeholder="Digite a cor do veículo" title="Digite a cor do veículo">

            <div .form-group>
                <label .control-label .col-md-2 for="tipoveiculoid">Tipo de veículo: 
                <div .col-md-5>
                    <select .form-control id="tipoveiculoid" title="Selecione o tipo de veículo">

                <br>
        <div .form-group  .col-md-12 .col-lg-12>    
            <button id="btn-canc" .btn .btn-danger .col-md-offset-2 .col-lg-offset-2 >Cancelar</button>
            <button id="btn-conc" .btn .btn-success>Confirmar</button>
    
    <div .col-md-8 .col-lg-8>
        <h3>Veículos Cadastrados
        <table id="t1" .table .table-hover>
            <thead .thead-inverse>
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
^{footer}            

|] >> toWidget [julius|

  		$(listarClientes());
     	$(listarTiposveiculos());
  		$(listarVeiculo());
		var modeledt = {};
		
		function confirmarVeiculo(){
            $.ajax({
                 contentType: "application/json",
                 url: "@{VeiculoR}",
                 type: "POST",
                 data: JSON.stringify({"clienteid":parseInt($("#clienteid").val()),"placa":$("#placa").val(),"descricao":$("#descricao").val(),"marca":$("#marca").val(),"ano":$("#ano").val(),"cor":$("#cor").val(),"tipoveiculoid":parseInt($("#tipoveiculoid").val())}),
                 success: function(){
					limpaCamposVeiculo();
					listarVeiculo();
                 }
            })
        	ajusteVeiculo();
        	$('tbody tr').css('background-color','#fff');   
		}

		function listarVeiculo(){
    		ajusteVeiculo();
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
			            itens+="<button class='btn btn-danger' onclick='excluirVeiculo("+e.data[i].id+")'>Excluir</button>";
			            itens+="</td></tr>";
                	}
                	$("#tb").html(itens);
				    selecaoVeiculo();
    		});
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

--FUNCIONÁRIO
getFuncionarioR :: Handler Html
getFuncionarioR = defaultLayout $ do
  setTitle "Sistema Estacionamento | Cadastrar Funcionário"
  toWidgetHead [hamlet| 
      <link href=@{StaticR style_css} rel="stylesheet">
   |] >> toWidget [lucius|
       h1{ color: #ffffff !important; } 
   |]
    
  [whamlet|

^{navMenu}

<div .container>
    <div id="formulario" .col-md-12 .col-lg-12>
        <h2>Cadastrar Funcionário</h2>
        <br>
        <button id="btn-nv" .btn .btn-primary-outline .col-md-offset-2 .col-lg-offset-2 >Novo</button>
        <button id="btn-alt" .btn .btn-primary-outline>Alterar</button>
        <br><br>
            
        <form .form-horizontal role="form">

            <div .form-group>
                <label .control-label .col-md-2 for="nome">Nome: 
                <div .col-md-5>
                    <input .form-control type="text" id="nome" required placeholder="Digite o nome do funcionário" title="Digite o nome do funcionário">

            <div .form-group>
                <label .control-label .col-md-2 for="password">Senha: 
                <div .col-md-5>
                    <input .form-control type="password" id="senha" required placeholder="Digite a senha" title="Digite a senha">

        
            <div .form-group>
                <label .control-label .col-md-2 for="FuncionarioAtivo">Ativo: 
                <div .col-md-5>
                    <select .form-control id="FuncionarioAtivo" title="Selecione o cliente">
                        <option value="true">Sim
                        <option value="false">Não

                <br>
        <div .form-group  .col-md-12 .col-lg-12>    
            <button id="btn-canc" .btn .btn-danger .col-md-offset-2 .col-lg-offset-2 >Cancelar</button>
            <button id="btn-conc" .btn .btn-success>Confirmar</button>
    
    <div .col-md-8 .col-lg-8>
        <h3>Funcionários Cadastrados
        <table id="t1" .table .table-hover>
            <thead .thead-inverse>
                <tr>
                    <th>ID
                    <th>Nome
                    <th>Senha
                    <th>Ativo
            <tbody id="tbody1">
^{footer}

|] >> toWidget [julius|

    $(listarFuncionario());
    var modeledt = {};
    
    function confirmarFuncionario(){
        $.ajax({
            contentType: "application/json",
            url: "@{FuncionarioR}",
            type: "POST",
            data: JSON.stringify({"nome":$("#nome").val(),"senha":$("#senha").val(),"ativo":$("#FuncionarioAtivo").val()}),
            success: function(){
				$("input").val("");
				$("#FuncionarioAtivo").val("true");
       			listarFuncionario();
            }
        });
    	$("tbody tr").css("background-color","#fff");   
	}
	
    function listarFuncionario(){
    	ajusteFuncionario();
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
		    selecaoFuncionario();
        });
    }

|]

--VAGA VALOR
getVagaValorR :: Handler Html
getVagaValorR = defaultLayout $ do
  setTitle "Sistema Estacionamento | Cadastrar Valor de Vaga"
  toWidgetHead [hamlet| 
      <link href=@{StaticR style_css} rel="stylesheet">
   |] >> toWidget [lucius|
       h1{ color: #ffffff !important; } 
   |]
    
  [whamlet|

^{navMenu}

<div .container>
    <div id="formulario" .col-md-12 .col-lg-12>
        <h2>Cadastrar Valor de Vaga</h2>
        <br>
        <div id="alteracao" .col-md-offset-2 .col-lg-offset-2 >
        <button id="btn-nv" .btn .btn-primary-outline .col-md-offset-2 .col-lg-offset-2 >Novo
        <button id="btn-alt" .btn .btn-primary-outline>Alterar
        <a href=@{HistoricoVagaValorR} id="listaHistorico" .btn .btn-default>Histórico de valor das vagas
        <br><br>
            
        <form .form-horizontal role="form">

            <div .form-group>
                <label .control-label .col-md-2 for="nome">Nome: 
                <div .col-md-5>
                    <input .form-control type="text" id="nome" required placeholder="Digite o nome do funcionário" title="Digite o nome do funcionário">

            <div .form-group>
                <label .control-label .col-md-2 for="senha">Senha: 
                <div .col-md-5>
                    <input .form-control type="password" id="senha" required placeholder="Digite a senha" title="Digite a senha">

            <div .form-group>
                <label .control-label .col-md-2 for="vlDia">Valor diurno: 
                <div .col-md-5>
                    <input .form-control type="number" id="vlDia" name="diurno" step="0.01" required>
            
            <div .form-group>
                <label .control-label .col-md-2 for="vlNoite">Valor noturno: 
                <div .col-md-5>
                    <input .form-control type="number" id="vlNoite" name="noturno" step="0.01" required>
            
            <div .form-group>
                <label .control-label .col-md-2 for="funcionario">Funcionário: 
                <div .col-md-5>
                    <select .form-control id="funcionario" required>

                <br>
        <div .form-group  .col-md-12 .col-lg-12>    
            <button id="btn-canc" .btn .btn-danger .col-md-offset-2 .col-lg-offset-2 >Cancelar</button>
            <button id="btn-conc" .btn .btn-success>Confirmar</button>
    
    <div .col-md-8 .col-lg-8>
        <h3>Valores de Vagas Cadastrados
        <table id="t1" .table .table-hover>
            <thead .thead-inverse>
                <tr>
                    <th>ID
                    <th>Valor diurno
                    <th>Valor noturno
                    <th>Alterado por
                    <th>Id Funcionario
            <tbody id="tbody1">
^{footer}

|] >> toWidget [julius|

    $(listarVagaValor());
    $(optFuncionario());
    
    var modeledt = {};
    
    function optFuncionario(){
        var opt = "<option value=''>Selecione um funcionário";
   		$.ajax({
			contentType: "application/json",
            url: "@{ListaFuncionarioR}",
            type: "GET",
    	}).done(function(e){
       		for(var i = 0; i<e.data.length; i++){
           		opt+="<option value='"+e.data[i].id+"'>"+e.data[i].nome;
           	}
           	$("#funcionario").html(opt);
        });
    }
    
    function getFuncionario(id,j){
        var opt = "";
   		$.ajax({
			contentType: "application/json",
            url: "@{ListaFuncionarioR}",
            type: "GET",
    	}).done(function(e){
       		for(var i = 0; i<e.data.length; i++){
       		    if(id == e.data[i].id){
       		    	opt=e.data[i].nome;
       		    	$("#nmFuncionario"+j).html(opt);
       		    }
           	}
        });
    }
    
    function confirmarVagaValor(){
        $.ajax({
            contentType: "application/json",
            url: "@{VagaValorR}",
            type: "POST",
            data: JSON.stringify({"valordiurno":parseFloat($("input[name='diurno']").val()),"valornoturno":parseFloat($("input[name='noturno']").val()),"funcionarioid":parseInt($("#funcionario").val())}),
            success: function(){
				$("input[name='diurno'],input[name='noturno']").val("");
				$("#funcionario").val("1");
       			listarVagaValor();
            }
        });
    	$("tbody tr").css("background-color","#fff");   
	}
	
    function listarVagaValor(){
    	ajusteVagaValor();
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
            	itens+="<td><span id='nmFuncionario"+i+"'>"
           		itens+=getFuncionario(e.data[i].funcionarioid,i);
             	itens+="</span></td>"
             	itens+="<td><span id='idFuncionario'>"
           		itens+=e.data[i].funcionarioid;
             	itens+="</span></td>"
	           	itens+="</tr>";
           	}
		    $("#tbody1").html(itens);
		    selecaoVagaValor();
        });
    }
	
	function confeditVagaValor(){
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
    		listarVagaValor();
       	});
        $.ajax({
            contentType: "application/json",
            url: "@{HistoricoVagaValorR}",
            type: "POST",
            data: JSON.stringify(modeledt),
            success: function(){
				$("#alteracao").html("Histórico de alteração atualizado com sucesso!");
				$("#alteracao").css("font-size","1em");
            }
        });
       	ajusteEditVagaValor();
	}

|]

-- VAGA
getVagaR :: Handler Html
getVagaR = defaultLayout $ do
  setTitle "Sistema Estacionamento | Cadastrar Vaga"
  toWidgetHead [hamlet| 
      <link href=@{StaticR style_css} rel="stylesheet">
   |] >> toWidget [lucius|
       h1{ color: #ffffff !important; } 
   |]
    
  [whamlet|

^{navMenu}

<div .container>
    <div id="formulario" .col-md-12 .col-lg-12>
        <h2>Cadastrar Vaga</h2>
        <br>
        <button id="btn-nv" .btn .btn-primary-outline .col-md-offset-2 .col-lg-offset-2 >Novo
        <button id="btn-alt" .btn .btn-primary-outline>Alterar
        <a href=@{HistoricoVagaValorR} id="listaHistorico" .btn .btn-default>Histórico de valor das vagas
        <br><br>
            
        <form .form-horizontal role="form">

            <div .form-group>
                <label .control-label .col-md-2 for="nome">Nome: 
                <div .col-md-5>
                    <input .form-control type="text" id="nome" required placeholder="Digite o nome do funcionário" title="Digite o nome do funcionário">

            <div .form-group>
                <label .control-label for="vaga">Vaga: 
                <div .col-md-5>
                    <select .form-control id="vaga" required>
                
            <div .form-group>
                <label .control-label for="optDiurno">Diurno: 
                <div .col-md-5>
                    <select .form-control id="optDiurno">
                        <option value="">Selecione
                        <option value="livre">Livre
                        <option value="ocupadoMensal">Ocupado Mensal
                        <option value="ocupadoAvulso">Ocupado Avulso
            
            <div .form-group>
                <label .control-label for="optNoturno">Noturno: 
                <div .col-md-5>
                    <select .form-control id="optNoturno">
                        <option value="">Selecione
                        <option value="livre">Livre
                        <option value="ocupadoMensal">Ocupado Mensal
                        <option value="ocupadoAvulso">Ocupado Avulso
            
            <div .form-group>
                <label .control-label for="vagaValor">Id vaga valor: 
                <div .col-md-5>
                    <select .form-control id="vagaValor">

                <br>
        <div .form-group  .col-md-12 .col-lg-12>    
            <button id="btn-canc" .btn .btn-danger .col-md-offset-2 .col-lg-offset-2 >Cancelar</button>
            <button id="btn-conc" .btn .btn-success>Confirmar</button>
    
    <div .col-md-8 .col-lg-8>
        <h3>Vagas Cadastradas
        <table id="t1" .table .table-hover>
            <thead .thead-inverse>
                <tr>
                    <th>Id/Vaga
                    <th>Diurno
                    <th>Noturno
                    <th>Id vaga valor
            <tbody id="tbody1">
^{footer}

|] >> toWidget [julius|

    $(listarVaga());
    $(optVagaValor());
    $(optVaga());
    var modeledt = {};
    
    function optVagaValor(){
        var opt = "<option value=''>Selecione";
   		$.ajax({
			contentType: "application/json",
            url: "@{ListaVagaValorR}",
            type: "GET",
    	}).done(function(e){
       		for(var i = 0; i<e.data.length; i++){
           		opt+="<option value='"+e.data[i].id+"'>"+e.data[i].id;
           	}
           	$("#vagaValor").html(opt);
        });
    }
    
    function optVaga(){
        var opt = "<option value=''>Código para novas vagas gerado automaticamente";
   		$.ajax({
			contentType: "application/json",
            url: "@{ListaVagaR}",
            type: "GET",
    	}).done(function(e){
       		for(var i = 0; i<e.data.length; i++){
       		    opt+="<option value='"+e.data[i].id+"'>"+e.data[i].id;
           	}
           	$("#vaga").html(opt);
        });
    }
    
    function confirmarVaga(){
        $.ajax({
            contentType: "application/json",
            url: "@{VagaR}",
            type: "POST",
            data: JSON.stringify({"diurno":$("#optDiurno").val(),"noturno":$("#optNoturno").val(),"vagavalorid":parseInt($("#vagaValor").val())}),
            success: function(){
				$("#vaga, #optDiurno, #optNoturno, #vagaValor").val("");
       			listarVaga();
            }
        });
    	$("tbody tr").css("background-color","#fff");   
	}
	
    function listarVaga(){
    	ajusteVaga();
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
		    selecaoVaga();
        });
    }

|]

--HISTÓRICO VAGA VALOR
getHistoricoVagaValorR :: Handler Html
getHistoricoVagaValorR = defaultLayout $ do
  setTitle "Sistema Estacionamento | Histórico de valores das vagas"
  toWidgetHead [hamlet| 
      <link href=@{StaticR style_css} rel="stylesheet">
   |] >> toWidget [lucius|
       h1{ color: #ffffff !important; } 
   |]
    
  [whamlet|

^{navMenu}

<div .container>
    <div id="formulario" .col-md-12 .col-lg-12>
        
        <h2>Histórico de valores das vagas</h2>
        <a href=@{VagaValorR} id="voltar" .btn .btn-default >Voltar para Cadastro e Alteração de valor de vaga
        <br>

        <div id="tabela" .col-md-12 .col-lg-12>
            <table id="t1" .table .table-hover>
                <thead .thead-inverse>
                    <tr>
                        <th>ID
                        <th>Data alteração
                        <th>Valor diurno antigo
                        <th>Valor diurno novo
                        <th>Valor noturno antigo
                        <th>Valor noturno novo
                        <th>funcionario id
                <tbody id="tbody1">
^{footer}                

|] >> toWidget [julius|

    $(listarHistorico());
    
    function listarHistorico(){
    	var itens = "";
   		$.ajax({
			contentType: "application/json",
            url: "@{ListaHistoricoVagaValorR}",
            type: "GET",
    	}).done(function(e){
       		for(var i = 0; i<e.data.length; i++){
           		itens+="<tr>";
           		itens+="<td><span>"
           		itens+=e.data[i].id;
           		itens+="</span></td>"
       	    	itens+="<td><span>"
           		itens+=e.data[i].dataalteracao;
           		itens+="</span></td>"
       	    	itens+="<td><span>"
           		itens+=e.data[i].vldiurnoantigo;
           		itens+="</span></td>"
            	itens+="<td><span>"
           		itens+=e.data[i].vldiurnonovo;
             	itens+="</span></td>"
             	itens+="</span></td>"
       	    	itens+="<td><span>"
           		itens+=e.data[i].vlnoturnoantigo;
           		itens+="</span></td>"
       	    	itens+="<td><span>"
           		itens+=e.data[i].vlnoturnonovo;
           		itens+="</span></td>"
            	itens+="<td><span>"
           		itens+=e.data[i].funcionarioid;
             	itens+="</span></td>"
	           	itens+="</tr>";
           	}
		    $("#tbody1").html(itens);
        });
    }
|]


--------------------------------------------------------
--              METHODS GET LISTAR
--------------------------------------------------------

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

getListaEventR :: Handler ()
getListaEventR = do
    alleventos <- runDB $ selectList [] [Asc EventId]
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

getListaHistoricoVagaValorR :: Handler ()
getListaHistoricoVagaValorR = do
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
    evento <- requireJsonBody :: Handler Event
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
    
putUpdateEventoR :: EventId -> Handler ()
putUpdateEventoR evid = do
    evs <- requireJsonBody :: Handler Event
    runDB $ update evid [EventDescricao =. eventDescricao evs, EventPercentualDesconto =. eventPercentualDesconto evs, EventContratoid =. eventContratoid evs]
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
    
deleteDeleteEventoR :: EventId -> Handler ()
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