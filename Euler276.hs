
import Test.HUnit
import Test.QuickCheck
import Text.Printf
import Data.List
import Data.Maybe
import Data.Array
import Data.Ratio
import Control.Arrow
import Control.Monad
import Control.DeepSeq
import qualified Data.Map as M

{- Consider the triangles with integer sides a, b and c with a <= b <= c.
An integer sided triangle (a,b,c) is called primitive if gcd(a,b,c)=1.
How many primitive integer sided triangles exist with a perimeter not exceeding 10 000 000? 
-}

showTable :: Int -> Int -> (Int -> Int -> Bool) -> IO ()
showTable maxCol maxRow cellContents = do
  mapM_ (putStrLn . ("        " ++) . intersperse ' ') $ transpose headers  
  mapM_ showRow [0..maxRow]
  
  where
    values = [0..maxCol]
    valueStrings = map show values
    maxLength = length $ show maxCol
    headers = map (padTo maxLength) valueStrings
    
    showRow c = do
      putStr $ printf "%6d  " c
      forM_ [0..maxCol] showCell
      putStrLn ""
      
      where
        showCell b = putStr $ if cellContents b c then "X " else ". "

padTo maxLength s = replicate (maxLength - length s) ' ' ++ s

maxPerimeter = 100

isPrimitiveTriangle a b c = and
  [ a <= b
  , b <= c
  , c < a + b
  , gcd a (gcd b c) == 1
  , a + b + c <= maxPerimeter
  ]

{- a < b <==> 0 < b - a
 - b < c <==> 0 < c - b
 - c < a + b <==> c - b < a
 - gcd a (gcd b c) == gcd a (gcd (b-a) (c-b))
 - a + b + c == (c-b) + (b-a) + a + (b-a) + a + a
 -
 - Therefore the problem can be transformed into one
 - involving a, b', c' where b' == b-a and c' == c-b such that
 - 0 < b'
 - 0 < c' < a
 - gcd a (gcd b' c') == 1
 - c' + 2b' <= maxPerimeter - 3a
 -} 

isPrimitiveTriangle' :: Int -> Int -> Int -> Bool
isPrimitiveTriangle' a b c = and
  [ c < a
  , gcd (gcd a b) c == 1
  , c + 2*b + 3*a <= maxPerimeter
  ]
  
propGcd :: Integer -> Integer -> Integer -> Bool
propGcd a b c = let
  [a', b', c'] = sort $ zipWith (+) [1..] $ (map abs) [a, b, c]
  in gcd a' (gcd b' c') == gcd a' (gcd (b'-a') (c'-b'))

main = do
  runTestTT tests
  quickCheck propGcd
  forM_ [1..10] $ \v -> showTable (4*v) (4*v) (isPrimitiveTriangle v)
  forM_ [1..10] $ \v -> do
    putStrLn $ printf "a = %d" v
    showTable (4*v) (v-1) (isPrimitiveTriangle' v)

tests = TestList
  [ 
  ]
