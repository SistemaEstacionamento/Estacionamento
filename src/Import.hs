{-# LANGUAGE TemplateHaskell, QuasiQuotes #-}
module Import where

import Yesod  
 
pRoutes = [parseRoutes|
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
	/cadastrocontrato ContratoR POST
	/cadastrovaga VagaR POST GET
	/alteravaga/#VagaId UpdateVagaR PUT
	/deletevaga/#VagaId DeleteVagaR DELETE
	/listavaga ListaVagaR GET
	/cadastrovagavalor VagaValorR POST GET
	/alteravagavalor/#VagaValorId UpdateVagaValorR PUT
	/listavagavalor ListaVagaValorR GET
	/cadastroevento EventoR POST
	/cadastroconveniado ConveniadoR POST
	/entrada AvulsoR POST -- pode ser entrada de veiculo também
	/cadastrofuncionario FuncionarioR POST GET
	/alterafuncionario/#FuncionarioId UpdateFuncionarioR PUT
	/listafuncionario ListaFuncionarioR GET
|]