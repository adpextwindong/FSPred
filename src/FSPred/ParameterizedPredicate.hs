module FSPred.Predicate where

import System.FilePath()
import Data.Semigroup()
import Control.Applicative

--Damn this new FSPattern a shit is ugly.
--Lets read this paper and think about it
--https://www.microsoft.com/en-us/research/uploads/prod/2016/11/trees-that-grow.pdf
data FSPattern a =
    DirectoryExists FilePath [FSPattern a] a
  -- | FilePath :/ ([FSPattern a] a)
  | WildCard (FSPattern a) a
  | FileSetExists [FilePath] a
  | FileExists FilePath a
  deriving Show

--TODO Consider an instance for Alternative kind of like optparse-applicative
--Maybe an applicative instance too

--Flattens potential nested WildCard terms
flatten :: (Monoid a) => FSPattern a -> FSPattern a
flatten (WildCard (WildCard inner x) y) = (WildCard (flatten inner) (x<>y))
flatten (DirectoryExists f xs y) = DirectoryExists f (fmap flatten xs) y
--flatten (f :/ xs) = f :/ fmap flatten xs
--TODO tests for this
flatten x = x

--root :: [FSPattern a] -> FilePath -> FSPattern a
--root xs f = DirectoryExists f xs

genSuffixFSet :: [FilePath] -> FilePath -> FSPattern ()
genSuffixFSet xs s = FileSetExists (liftA2 (++) [s] xs) ()

genPreffixFSet :: [FilePath] -> FilePath -> FSPattern ()
genPreffixFSet xs s = FileSetExists (liftA2 (++) xs [s]) ()

--Test fixtures
genTs :: String -> FilePath -> FSPattern ()
genTs s root =   DirectoryExists root [
                    DirectoryExists ("qc"<>s) [
                           genSuffixFSet [".fbd",".stl",".fit.stl"] s,
                           FileExists ("qc_"<>s<>".3dm") (),
                           FileExists "qc_report.txt" (),
                           FileExists "Alignment.ginspect" ()
                       ] (),
                    FileExists "Calib.ini" (),
                    FileExists "Foot.ini"  (),
                    FileExists "Layer.cld" (),
                    FileExists "Model.ini" (),
                    FileExists "table.ctd" ()
                  ] ()

dirInfTest :: FSPattern ()
dirInfTest = DirectoryExists "foo" [ FileExists "baz.txt" ()] ()

--What about parsing something like this
{-
 - foo/
 -      baz.txt
 - bar/
 -      quux.txt
 -}
--Into a pattern
