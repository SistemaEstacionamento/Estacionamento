{-# LANGUAGE TemplateHaskell, QuasiQuotes #-}
module Import where

import Yesod
 
pRoutes = [parseRoutes|
	/cadastrocliente ClientR POST GET
	/lista ListaR GET
	/cadastroveiculo VeiculoR POST GET
	/cadastrotipoveiculo TipoVeiculoR POST GET
	/listaVeiculo ListaVeiculoR GET
	/cadastrocontrato ContratoR POST
	/cadastrovaga VagaR POST
	/cadastrovagavalor VagaValorR POST
	/cadastroevento EventoR POST
	/cadastroconveniado ConveniadoR POST
	/entrada AvulsoR POST -- pode ser entrada de veiculo também
	/cadastrofuncionario FuncionarioR POST
|]