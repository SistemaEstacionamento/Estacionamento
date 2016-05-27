{-# LANGUAGE TemplateHaskell, QuasiQuotes #-}
module Import where

import Yesod
 
pRoutes = [parseRoutes|
	/cadastrocliente ClientR POST GET
	/cadastroveiculo VeiculoR POST
	/cadastrotipoveiculo TipoVeiculoR POST
	/cadastrocontrato ContratoR POST
	/cadastrovaga VagaR POST
	/cadastrovagavalor VagaValorR POST
	/cadastroevento EventoR POST
	/cadastroconveniado ConveniadoR POST
	/entrada AvulsoR POST -- pode ser entrada de veiculo também
	/cadastrofuncionario FuncionarioR POST
|]