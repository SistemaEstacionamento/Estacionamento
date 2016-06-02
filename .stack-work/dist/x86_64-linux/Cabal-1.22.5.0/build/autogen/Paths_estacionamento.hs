module Paths_estacionamento (
    version,
    getBinDir, getLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
catchIO = Exception.catch

version :: Version
version = Version [0,0,0] []
bindir, libdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/home/ubuntu/workspace/estacionamento/.stack-work/install/x86_64-linux/lts-5.18/7.10.3/bin"
libdir     = "/home/ubuntu/workspace/estacionamento/.stack-work/install/x86_64-linux/lts-5.18/7.10.3/lib/x86_64-linux-ghc-7.10.3/estacionamento-0.0.0-3ZBQJH0UNYQCUn9357gnDR"
datadir    = "/home/ubuntu/workspace/estacionamento/.stack-work/install/x86_64-linux/lts-5.18/7.10.3/share/x86_64-linux-ghc-7.10.3/estacionamento-0.0.0"
libexecdir = "/home/ubuntu/workspace/estacionamento/.stack-work/install/x86_64-linux/lts-5.18/7.10.3/libexec"
sysconfdir = "/home/ubuntu/workspace/estacionamento/.stack-work/install/x86_64-linux/lts-5.18/7.10.3/etc"

getBinDir, getLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "estacionamento_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "estacionamento_libdir") (\_ -> return libdir)
getDataDir = catchIO (getEnv "estacionamento_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "estacionamento_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "estacionamento_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
