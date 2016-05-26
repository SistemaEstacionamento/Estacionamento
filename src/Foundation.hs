{-# LANGUAGE OverloadedStrings, TypeFamilies, QuasiQuotes,
             TemplateHaskell, GADTs, FlexibleContexts,
             MultiParamTypeClasses, DeriveDataTypeable,
             GeneralizedNewtypeDeriving, ViewPatterns #-}
module Foundation where
import Import
import Yesod
import Data.Text
import Database.Persist.Postgresql
    ( ConnectionPool, SqlBackend, runSqlPool, runMigration )

data Sitio = Sitio { connPool :: ConnectionPool }

share [mkPersist sqlSettings, mkMigrate "migrateAll"] [persistLowerCase|
Cliente json
   nome Text
   flcliente Text
   deriving Show

Telefone json
   ordem Text
   clienteid ClienteId
   deriving Show
   
ClienteFisico json
   rg Text
   sexo Text
   cpf Text
   clientefisicoid ClienteId
   deriving Show
   
Endereco json
    logradouro Text
    cidade Text
    estado Text
    bairro Text
    cep Text
    clienteid ClienteId
    deriving Show

Contrato json
    valor Double
    contratoinc Text sqltype=date
    contratofim Text sqltype=date
    quantidadeparcela Int 
    quantidadevagas Int
    clienteid ClienteId
    deriving Show

Parcela json
    dataparcela Text sqltype=date
    valor Double
    valorpago Double
    datapagamento
    clienteid ContratoId
    deriving Show
    
Evento json
    descricao Text
    percentualDesconto Int
    clienteid ContratoId
    deriving Show
    
ClienteJuridico json
    cnpj Text
    razaosocial Text
    clientejuridicoid ClienteId
    deriving Show

TipoVeiculo json
    nome Text
    deriving Show

Veiculo json
    placa Text
    descricao Text
    marca Text
    ano Text
    cor Text
    tipoveiculoid TipoVeiculoId
    clienteid ClienteId
    deriving Show
    
VagaValor json
    valordiurno Double
    valornoturno Double
    deriving Show
    
Vaga json
    diurno Text
    noturno Text
    vagavalorid VagaValorId
    deriving Show
    
ContratoVaga json
    periodo Text
    contratoid ContratoId
    vagaid VagaId
    deriving Show
    
Conveniado json
    nome Text
    percentualDesconto Double
    eventoid EventoId
    deriving Show
    
Avulso json
    placa Text
    entrada Text sqltype=date
    saida Text sqltype=date
    valor Double
    vagaid VagaId
    conveniadoid ConveniadoId
    deriving Show
    
Funcionario json
    nome Text
    senha Text 
    deriving Show

HistoricoPreco json
    dataalteracao Text sqltype=date
    vldiurnoantigo Double
    vlnoturnoantigo Double
    vldiurnonovo Double
    vlnoturnonovo Double
    vagaid VagaId
    funcionarioid FuncionarioId
    deriving Show

|]

mkYesodData "Sitio" pRoutes

instance YesodPersist Sitio where
   type YesodPersistBackend Sitio = SqlBackend
   runDB f = do
       master <- getYesod
       let pool = connPool master
       runSqlPool f pool

instance Yesod Sitio where

type Form a = Html -> MForm Handler (FormResult a, Widget)

instance RenderMessage Sitio FormMessage where
    renderMessage _ _ = defaultFormMessage