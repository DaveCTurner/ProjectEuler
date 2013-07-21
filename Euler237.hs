
import Test.HUnit
import Test.QuickCheck
import Text.Printf
import Data.List
import Data.Maybe
import Data.Array
import Data.STRef
import Data.Array.ST
import Data.Ratio
import Control.Arrow
import Control.Monad
import Control.Applicative
import Control.Monad.ST
import Control.DeepSeq
import qualified Data.Map as M

{- T(10) is 2329. What is T(10^12) modulo 10^8? -}

{- first 10 values of T are: [1,1,4,8,23,55,144,360,921,2329] -}

main :: IO ()
main = do
  forM_ [1..10] $ \n -> print (naiveT n)

naiveT :: Int -> Integer
naiveT n = runST $ do
  countRef <- newSTRef 0
  visitedArray <- newArray arrayBounds False
  countPaths countRef visitedArray
  readSTRef countRef

  where
    arrayBounds = ((1,1), (4,n))
    cellCount = 4 * n
    finishCell = (4,1)

    countPaths :: STRef s Integer -> STArray s (Int, Int) Bool -> ST s ()
    countPaths countRef visitedArray = go 1 (1,1)

      where
        go visitedCount currentCell = do
          isLegal <- if inRange arrayBounds currentCell
                      then not <$> readArray visitedArray currentCell
                      else return False
          when isLegal $ do
            when (visitedCount == cellCount && currentCell == finishCell) $ do
              modifySTRef countRef (+1)
            writeArray visitedArray currentCell True
            sequence_
              [ go (visitedCount + 1) $ component (modifier 1) currentCell
              | component <- [first, second]
              , modifier <- [subtract, (+)]
              ]
            writeArray visitedArray currentCell False

data RecState = RecState
  { _type1Count :: Integer
  , _type3Count :: Integer
  , _type4Count :: Integer
  , _type6Count :: Integer
  , _type7CanCloseCount :: Integer
  , _type7CannotCloseCount :: Integer
  }

instance Show RecState where
  show (RecState a b c d e f) = printf "%5d %5d %5d %5d %5d %5d" a b c d e f
  
zeroState :: RecState
zeroState = RecState 0 0 0 0 0 0



recT :: [RecState]
recT = go $ zeroState { _type3Count = 1, _type7CannotCloseCount = 1 }
  where
    go currentState = (:) currentState $ go $ RecState
      { _type1Count = fromCurrentState [ _type3Count, _type7CanCloseCount ]
      , _type3Count = fromCurrentState [ _type1Count, _type4Count, _type6Count, _type7CanCloseCount, _type7CannotCloseCount ]
      , _type4Count = fromCurrentState [ _type3Count ]
      , _type6Count = fromCurrentState [ _type3Count, _type7CanCloseCount ]
      , _type7CanCloseCount = fromCurrentState
        [ _type7CanCloseCount, _type3Count ]
      , _type7CannotCloseCount = fromCurrentState
        [ _type6Count, _type1Count, _type7CannotCloseCount, _type3Count ]
      }
    
      where
        fromCurrentState fs = sum $ map (\f -> f currentState) fs