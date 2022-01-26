module FSPred.Predicate where

import System.FilePath()
import Data.Semigroup()
import Control.Applicative

--TODO brainstorm validation ideas
data FValidation a = FValidation (a -> Bool)

data FSPattern
  = DirectoryExists FilePath [FSPattern]
  | FilePath :/ [FSPattern]
  | WildCard FSPattern
  | FileSetExists [FilePath]
  | FileExists FilePath
  deriving Show

--TODO Consider an instance for Alternative kind of like optparse-applicative
--Maybe an applicative instance too

--Flattens potential nested WildCard terms
--TODO tests for this
flatten :: FSPattern -> FSPattern
flatten (WildCard (WildCard x)) = flatten x
flatten (DirectoryExists f xs) = DirectoryExists f (fmap flatten xs)
flatten (f :/ xs) = f :/ fmap flatten xs
flatten x = x

root :: [FSPattern] -> FilePath -> FSPattern
root = flip DirectoryExists

genSuffixFSet :: [FilePath] -> FilePath -> FSPattern
genSuffixFSet xs s = FileSetExists $ liftA2 (++) [s] xs

genPreffixFSet :: [FilePath] -> FilePath -> FSPattern
genPreffixFSet xs s = FileSetExists $ liftA2 (++) xs [s]

--Test fixtures
genTs :: String -> FilePath -> FSPattern
genTs s = root [
            DirectoryExists ("qc"<>s) [
                   genSuffixFSet [".fbd",".stl",".fit.stl"] s,
                   FileExists ("qc_"<>s<>".3dm"),
                   FileExists "qc_report.txt",
                   FileExists "Alignment.ginspect"
               ],
            FileExists "Calib.ini",
            FileExists "Foot.ini",
            FileExists "Layer.cld",
            FileExists "Model.ini",
            FileExists "table.ctd"
          ]

dirInfTest :: FSPattern
dirInfTest = "foo" :/ [ FileExists "baz.txt"]
{-
genTs :: FilePath -> FSPattern
genTs s = DirectoryExists s [pattern]
    where pattern =
            DirectoryExists "qc"<>s (genSerialSet s : [
                   FileExists "qc_report.txt",
                   FileExists "Alignment.ginspect"
               ]
            )

-}

--What about parsing something like this
{-
 - foo/
 -      baz.txt
 - bar/
 -      quux.txt
 -}
--Into a pattern
