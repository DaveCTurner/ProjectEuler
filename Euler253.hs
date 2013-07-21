
import Test.HUnit
import Test.QuickCheck
import Text.Printf
import Data.List
import Data.Maybe
import Data.Array
import Data.Ratio
import Control.Arrow
import Control.DeepSeq
import qualified Data.Map as M

data CaterpillarState = CaterpillarState
  { _lowGap :: Int
  , _highGap :: Int
  , _otherGaps :: [Int]
  } deriving (Eq, Ord)

flagsFromState :: CaterpillarState -> [Bool]
flagsFromState (CaterpillarState l h gs) = tail $ concatMap flags $ l : gs ++ [h]
  where
    flags g = True : replicate g False

instance Show CaterpillarState where
  show = map (\b -> if b then '#' else '.') . flagsFromState

showStateTests = TestLabel "showStateTests" $ TestList
  [ show (CaterpillarState 0 0 []) ~?= "#"
  , show (CaterpillarState 1 0 []) ~?= ".#"
  , show (CaterpillarState 0 1 []) ~?= "#."
  , show (CaterpillarState 1 1 []) ~?= ".#."
  , show (CaterpillarState 0 0 [1]) ~?= "#.#"
  , show (CaterpillarState 0 0 [2]) ~?= "#..#"
  , show (CaterpillarState 0 0 [1,2]) ~?= "#.#..#"
  , show (CaterpillarState 1 2 [1,2]) ~?= ".#.#..#.."
  ]

stateFromFlags :: [Bool] -> CaterpillarState
stateFromFlags flags = CaterpillarState l h gs
  where
    l = head gaps - 1
    h = last gaps - 1
    gs = init $ tail gaps

    gaps = filter (/= 0) $ go (False : flags ++ [False]) 0
    go [] n = [n]
    go (False:xs) n = go xs (n+1)
    go (True:xs) n = n : go xs 0

stateFromFlagsTests = TestLabel "stateFromFlagsTests" $ TestList
  [ runTest 0 0 [] "#"
  , runTest 0 0 [] "##"
  , runTest 1 0 [] ".#"
  , runTest 0 1 [] "#."
  , runTest 1 1 [] ".#."
  , runTest 1 1 [] ".#."
  , runTest 1 1 [1] ".#.#."
  , runTest 1 1 [1,2] ".#.#..#."
  , runTest 1 2 [1,2] ".#.#..#.."
  ] where
    runTest h l gs fs = stateFromString fs ~?= CaterpillarState h l gs

nextStatesNaive :: CaterpillarState -> [CaterpillarState]
nextStatesNaive s = map stateFromFlags nextFlagStates
  where
    currentFlagState = flagsFromState s
    nextFlagStates = go currentFlagState []
    go [] _ = []
    go (False:xs) ys = (ys ++ [True] ++ xs) : go xs (ys ++ [False])
    go (True:xs) ys  =                        go xs (ys ++ [True])

stateFromString = stateFromFlags . map (== '#')

nextStatesNaiveTests = TestLabel "nextStatesNaiveTests" $ TestList
  [ runTest "..#.#...#..#."
          [ "#.#.#...#..#."
          , ".##.#...#..#."
          , "..###...#..#."
          , "..#.##..#..#."
          , "..#.#.#.#..#."
          , "..#.#..##..#."
          , "..#.#...##.#."
          , "..#.#...#.##."
          , "..#.#...#..##"
          ]
  ]
    where
      runTest s nss = sort (nextStatesNaive $ stateFromString s) ~?= sort (map stateFromString nss)

normaliseState :: CaterpillarState -> CaterpillarState
normaliseState (CaterpillarState l h gs) = CaterpillarState (min l h) (max l h) (sort gs)

normaliseStateTests = TestLabel "normaliseStateTests" $ TestList
  [ runTest "..#.#...#..#." ".#.#..#...#.."
  ]
    where
      runTest s s' = normaliseState (stateFromString s) ~?= stateFromString s'

instance Arbitrary CaterpillarState where
  arbitrary = sized $ \size -> do
    flags <- vector $ min size 40
    return $ normaliseState $ stateFromFlags $ if or flags then flags else True : flags

  shrink s = map (normaliseState . stateFromFlags) (filter or $ shrink $ flagsFromState s)

nextStates :: CaterpillarState -> [CaterpillarState]
nextStates (CaterpillarState l h gs)
    =  [ CaterpillarState (l-1) h gs | 0 < l ]
    ++ [ CaterpillarState (l-1) h gs | 0 < l, l == h ]
    ++ [ CaterpillarState l (h-1) gs | l < h ]
    ++ map splitLow [0..l-2] ++ map splitHigh [0..h-2]
    ++ map (CaterpillarState l h) (splitGaps gs)
  where
    splitLow  k = CaterpillarState k h $ insertGap gs (l-k-1)
    splitHigh k = CaterpillarState (min l k) (max l k) $ insertGap gs (h-k-1)

propNextStates :: CaterpillarState -> Bool
propNextStates s = sort (nextStates s) == sort (map normaliseState $ nextStatesNaive s)

bits :: Int -> Int -> [Bool]
bits 0 _ = []
bits nBits n = (r /= 0) : (bits (nBits - 1) q)
  where (q, r) = divMod n 2

nextStatesTests = TestLabel "nextStatesTests" $ TestList $ map makeTestCase [1..127]
  where
    makeTestCase n = TestCase $ assertBool (show n) $ propNextStates $ normaliseState $ stateFromFlags $ bits 7 n

insertGap :: [Int] -> Int -> [Int]
insertGap [] g = [g]
insertGap ggs@(g0:gs) g
  | g <= g0 = g : ggs
  | otherwise = g0 : insertGap gs g

splitGaps :: [Int] -> [[Int]]
splitGaps allGaps = go1 0 [] allGaps
  where
    go1 nOnes doneGaps (1:pendingGaps) = go1 (nOnes + 1) (doneGaps ++ [1]) pendingGaps
    go1 nOnes doneGaps pendingGaps = replicate nOnes (tail allGaps) ++ go2 doneGaps pendingGaps
    
    go2 doneGaps [] = []
    go2 doneGaps (g:gs)
      = splitAtEnd : splitAtEnd : splitsInMiddle ++ go2 (doneGaps ++ [g]) gs
      
      where
        otherGaps = doneGaps ++ gs
        splitAtEnd = insertGap otherGaps (g-1)
        splitsInMiddle = map splitInMiddle [1..g-2]
        splitInMiddle k = insertGap (insertGap otherGaps k) (g-k-1)


splitGapsTests = TestLabel "splitGapsTests" $ TestList
  [ runTest [] []
  , runTest [1] [[]]
  , runTest [1,1] [[1], [1]]
  , runTest [2] [[1], [1]]
  , runTest [1,2] [[2], [1,1], [1,1]]
  , runTest [1,1,2] [[1,2], [1,2], [1,1,1], [1,1,1]]
  , runTest [3] [[1,1], [2], [2]]
  ]
    where
      runTest gs expected = sort (splitGaps gs) ~?= sort expected

allStates n = do
  l <- [0 .. div n 2]
  h <- [l .. n - l - 1]
  gs <- gapsToAtMost 1 (n - l - h - 2)
  return $ CaterpillarState l h gs
  
    where
      gapsToAtMost minGap k = [] : do
        g <- [minGap..k]
        gs <- gapsToAtMost g (k-g-1)
        return $ g:gs

allStatesTests = TestLabel "allStatesTests" $ TestList
  [ sort (allStates 4) ~?= map stateFromString
    [ "####", "#.##", "#..#" , "###." , "#.#." , "##.." , "#..." , ".##." , ".#.." ]
  , sort (allStates 7) ~?= nub (sort $ map (normaliseState . stateFromFlags . bits 7) [1..127])
  ]

pieceCount :: Int
pieceCount = 40

maxParts :: Int
maxParts = div (pieceCount + 1) 2

newtype FrequencyTable = FrequencyTable { _unFrequencyTable :: Array Int Integer } deriving (Eq)

instance Show FrequencyTable where show = show . elems . _unFrequencyTable

initialFrequencyTable = FrequencyTable $ listArray (1, maxParts) $ 1 : repeat 0

forceTable :: FrequencyTable -> FrequencyTable
forceTable ft@(FrequencyTable ary) = deepseq ary ft

raiseMinTo :: Int -> FrequencyTable -> FrequencyTable
raiseMinTo 1 ft = ft
raiseMinTo minValue (FrequencyTable ary) = forceTable $ FrequencyTable $ ary // [(minValue - 1, 0), (minValue, ary ! minValue + ary ! (minValue - 1))]

combineTables :: [FrequencyTable] -> FrequencyTable
combineTables fts = forceTable $ FrequencyTable $ listArray (1, maxParts) $ map (\k -> sum $ map ((! k) . _unFrequencyTable) fts) [1 .. maxParts]

finalCaterpillarState = CaterpillarState 0 0 []

frequencyTablesMap :: M.Map CaterpillarState FrequencyTable
frequencyTablesMap = M.fromList $ (finalCaterpillarState, initialFrequencyTable)
  : map (id &&& calculateFrequencyTable) (filter (/= finalCaterpillarState) $ allStates pieceCount)
  
calculateFrequencyTable :: CaterpillarState -> FrequencyTable
calculateFrequencyTable s@(CaterpillarState _ _ gs) = raiseMinTo (length gs + 1) $ combineTables $ map (fromJust . flip M.lookup frequencyTablesMap) $ nextStates s

finalFrequencyTable = combineTables $ do
  firstPiece <- [1..pieceCount]
  return $ fromJust $ flip M.lookup frequencyTablesMap $ normaliseState $ CaterpillarState (firstPiece - 1) (pieceCount - firstPiece) []

meanMaxLength = sum (zipWith (*) [1..] frequencies) % sum frequencies
  where
    frequencies = elems $ _unFrequencyTable finalFrequencyTable
  
main = do
  runTestTT tests
  quickCheck propNextStates
  print finalFrequencyTable
  print meanMaxLength
  putStrLn $ printf "%0.6f" (fromRational meanMaxLength :: Double)

tests = TestList
  [ showStateTests
  , stateFromFlagsTests
  , nextStatesNaiveTests
  , normaliseStateTests
  , splitGapsTests
  , nextStatesTests
  , allStatesTests
  ]
