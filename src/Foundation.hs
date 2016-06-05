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
Client json
   nome Text
   flcliente Text
   telefone Text
   rg Text
   sexo Text
   cpf Text
   logradouro Text
   cidade Text
   estado Text
   bairro Text
   cep Text
   cnpj Text
   razaosocial Text
   deriving Show

Contrato json
    valor Double
    contratoinc Text sqltype=date
    contratofim Text sqltype=date
    quantidadeparcela Int 
    quantidadevagas Int
    clienteid ClientId
    deriving Show

Parcela json
    dataparcela Text sqltype=date
    valor Double
    valorpago Double
    datapagamento
    clienteid ContratoId
    deriving Show
    
Event json
    descricao Text
    percentualDesconto Double
    contratoid ContratoId
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
    clienteid ClientId
    deriving Show
    
VagaValor json
    valordiurno Double
    valornoturno Double
    funcionarioid FuncionarioId
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
    eventoid EventId Maybe
    deriving Show
    
Avulso json
    placa Text
    entrada Text sqltype = datetime
    saida Text sqltype = datetime
    valor Double
    vagaid VagaId
    conveniadoid ConveniadoId Maybe
    deriving Show
    
Funcionario json
    nome Text
    senha Text
    ativo Text
    deriving Show

HistoricoVagaValor json
    dataalteracao Text sqltype=date
    vldiurnoantigo Double
    vlnoturnoantigo Double
    vldiurnonovo Double
    vlnoturnonovo Double
    vagavalorid VagaValorId
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