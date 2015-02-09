{- |
Module      :  $Header$
License     :  FreeBSD

Maintainer  :  penzin.dev@gmail.com
Stability   :  experimental
Portability :  non-portable (FreeBSD specific)

Module to interact with purely package tools. In relation to ports this means
checking versions of installed ports.

-}
module Config.FreeBSD.Package(
        -- * Functions
        -- ** Get a list of packages to update from pkgNG
        getOutdatedPackagesNG,
        -- ** Get a list of packages to update from pkg
        getOutdatedPackagesPkg,
        -- ** Get a list of packages to update smartly, depending on what package system is used
        getOutdatedPackagesSmart
    ) where

import System.Process
import Config.FreeBSD.PortTools

{-|Strip package names from pkg(ng) output -}
pkgToNames :: String -> [String]
pkgToNames = scrape . lines

{-|Scrape pkg metadata to get package names -}
scrape :: [String] -> [String]
scrape [] = []
scrape (x:xs) = (scrapeOne x):(scrape xs)
    where scrapeOne = reverse . tail . dropWhile ((/=) '-') . reverse

{-| Call pkg_version (pkg) and produce a list of packages from it -}
getOutdatedPackagesPkg :: IO ([String])
getOutdatedPackagesPkg = readProcess "pkg_version" ["-l", "<"] ""
                     >>= return . pkgToNames

{-| Call pkg (pkgNG) and produce a list of packages from it -}
getOutdatedPackagesNG :: IO ([String])
getOutdatedPackagesNG = readProcess "pkg" ["version", "-l", "<"] ""
                    >>= return . pkgToNames

{-| Check what package system is in use and then use it to produce a list of packages to update -}
getOutdatedPackagesSmart :: IO ([String])
getOutdatedPackagesSmart = isPkgNgPresent
                       >>= \a -> if a then getOutdatedPackagesNG else getOutdatedPackagesPkg
