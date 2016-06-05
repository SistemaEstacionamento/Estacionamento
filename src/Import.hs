{-# LANGUAGE TemplateHaskell, QuasiQuotes #-}
module Import where

import Yesod  
 
pRoutes = [parseRoutes|
    /home HomeR GET
	/cadastrocliente ClientR POST GET
	/update/#ClientId UpdateR PUT
	/delete/#ClientId DeleteR DELETE
	/lista ListaR GET
	/cadastroveiculo VeiculoR POST GET
	/veiculoupdate/#VeiculoId VeiUpdateR PUT
	/veiculodelete/#VeiculoId VeiDeleteR DELETE
	/listaVeiculo ListaVeiculoR GET
	/cadastrotipoveiculo TipoVeiculoR POST GET
	/tipoveiculoupdate/#TipoVeiculoId TipoVeiUpdateR PUT
	/tipoveiculodelete/#TipoVeiculoId TipoVeiDeleteR DELETE
	/listaTpVeiculo ListaTpVeiculoR GET
	/cadastrocontrato ContratoR POST GET
	/contratoupdate/#ContratoId ContratoUpdateR PUT
	/contratodelete/#ContratoId ContratoDeleteR DELETE
	/listacontrato ListaContratoR GET
	/cadastrovaga VagaR POST GET
	/alteravaga/#VagaId UpdateVagaR PUT
	/deletevaga/#VagaId DeleteVagaR DELETE
	/listavaga ListaVagaR GET
	/cadastrovagavalor VagaValorR POST GET
	/alteravagavalor/#VagaValorId UpdateVagaValorR PUT
	/deletevagavalor/#VagaValorId DeleteVagaValorR DELETE
	/listavagavalor ListaVagaValorR GET
	/cadastroevento EventoR POST GET
	/alteraevento/#EventId UpdateEventoR PUT
	/deletaevento/#EventId DeleteEventoR DELETE
	/listaevento ListaEventoR GET
	/cadastroconveniado ConveniadoR POST GET
	/alterarconveniado/#ConveniadoId UpdateConveniadoR PUT
	/deleteconveniado/#ConveniadoId DeleteConveniadoR DELETE
	/listaconveniado ListaConveniadoR GET
	/entrada AvulsoR POST GET
	/listaavulsos ListaAvulsoR GET
	/deleteavulso/#AvulsoId DeleteAvulsoR DELETE
	/cadastrofuncionario FuncionarioR POST GET
	/alterafuncionario/#FuncionarioId UpdateFuncionarioR PUT
	/deletefuncionario/#FuncionarioId DeleteFuncionarioR DELETE
	/listafuncionario ListaFuncionarioR GET
	/historicovagavalor HistoricoVagaValorR POST GET
	/deletehistoricovagavalor/#HistoricoVagaValorId DeleteHistoricoVagaValorR DELETE	
|]