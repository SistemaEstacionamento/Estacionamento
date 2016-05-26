module Paths_Estacionamento (
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

bindir     = "/home/ubuntu/workspace/Estacionamento/.stack-work/install/x86_64-linux/lts-5.18/7.10.3/bin"
libdir     = "/home/ubuntu/workspace/Estacionamento/.stack-work/install/x86_64-linux/lts-5.18/7.10.3/lib/x86_64-linux-ghc-7.10.3/Estacionamento-0.0.0-4VbT1Fmk5JEJFwuEbPyPVg"
datadir    = "/home/ubuntu/workspace/Estacionamento/.stack-work/install/x86_64-linux/lts-5.18/7.10.3/share/x86_64-linux-ghc-7.10.3/Estacionamento-0.0.0"
libexecdir = "/home/ubuntu/workspace/Estacionamento/.stack-work/install/x86_64-linux/lts-5.18/7.10.3/libexec"
sysconfdir = "/home/ubuntu/workspace/Estacionamento/.stack-work/install/x86_64-linux/lts-5.18/7.10.3/etc"

getBinDir, getLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "Estacionamento_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "Estacionamento_libdir") (\_ -> return libdir)
getDataDir = catchIO (getEnv "Estacionamento_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "Estacionamento_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "Estacionamento_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
