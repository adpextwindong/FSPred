module FSPred.Predicate where

import System.FilePath()
import Data.Semigroup()
import Control.Applicative

type Serial = String

data FSPattern =
    DirectoryExists FilePath [FSPattern]
  | FilePath :/ [FSPattern]
  | WildCard FSPattern
  | FileSetExists [FilePath]
  | FileExists FilePath
  deriving Show

--Test fixtures
root :: [FSPattern] -> FilePath -> FSPattern
root = flip DirectoryExists

genSuffixFSet :: [FilePath] -> FilePath -> FSPattern
genSuffixFSet xs s = FileSetExists $ liftA2 (++) [s] xs

genPreffixFSet :: [FilePath] -> FilePath -> FSPattern
genPreffixFSet xs s = FileSetExists $ liftA2 (++) xs [s]

genTs :: Serial -> FilePath -> FSPattern
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
--How do we support annotations for file validation/verification?
--What if we used an infix '/' operator for the directory type constructor???


--What about parsing something like this
{-
 - foo/
 -      baz.txt
 - bar/
 -      quux.txt
 -}
--Into a pattern
