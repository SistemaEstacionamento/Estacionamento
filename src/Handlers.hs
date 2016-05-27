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
    <button #btn> OK
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
    Tipo: <select id="flcliente"><option value="f"> Fisico <option value="j"> Juridico
  |] 
  toWidget [julius|
     $(main);
     function main(){
         $("#btn").click(function(){
            $.ajax({
                 contentType: "application/json",
                 url: "@{ClientR}",
                 type: "POST",
                 data: JSON.stringify({"nome":$("#nome").val(),"flcliente":$("#flcliente").val(),"telefone":$("#telefone").val(),"rg":$("#rg").val(),"sexo":$("#sexo").val(),"cpf":$("#cpf").val(),"cnpj":$("#cnpj").val(),"razaosocial":$("#razaosocial").val(),"logradouro":$("#logradouro").val(),"cidade":$("#cidade").val(),"estado":$("#estado").val(),"bairro":$("#bairro").val(),"cep":$("#cep").val()}),
                 success: function(data) {
                     alert(data);
                     $("#usuario").val("");
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
     }
  |]


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