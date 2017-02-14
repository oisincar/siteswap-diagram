import Data.List
import Data.Char
import Data.Maybe
import System.Environment

main = do
  args <- getArgs
  let b = read (args !! 0)
      h = read (args !! 1)
  -- let b = 5
  --     h = 9

  let allN = getAllNodes b h
      revGr = revGraph $ graph b allN
      borderLine = '|' : (replicate (2 * length allN -1) '-') ++ "|"

  putStrLn $ ' ' : (show b) ++ " balls up to throw height " ++ (show h)
  putStrLn borderLine

  putStrLn $ intercalate "\n" $ showStates h allN
  putStrLn $ '|' : (concat $ replicate (length allN) "-|")

  -- special case for base throw
  putStrLn $ "|^" ++ (concat $ replicate (length allN) "| ")
  putStrLn $ intercalate "\n" $
    [showLine (revGr !! x) x (length revGr) | x <- [0..(length revGr) -1]]
  putStrLn borderLine

getAllNodes b h = reverse $ sort $ nub $ permutations ((replicate b '1') ++ (replicate (h-b) '0'))

findNodes :: Int -> String -> [(Int, String)]
findNodes b (x:xs)
 | x == '0' = [(0, xs ++ "0")]
 | otherwise = filter isValid $ map (\i -> (i+1, replace (xs ++ "0") i)) [0..length xs]
 where isValid (_,st) = (b == length (filter (=='1') st))
       replace str x = (take x str) ++ "1" ++ (drop (x+1) str)

--     num balls -> all states -> [start state,  [(throwheight, end state)]]
graph :: Int -> [String] -> [(String, [(Int, String)])]
graph b allNodes = map (\x -> (x, findNodes b x)) allNodes

--          graph               ->         index, throwHeight
revGraph :: [(String, [(Int, String)])] ->  [[(Int, Int)]]
revGraph gr = map f gr
  where --f :: (String, [(Int, String)]) -> [(Int, Int)]
        f node = g gr (fst node) 0
        -- g :: [(String, [(Int, String)])] -> String -> Int -> [(Int, Int)]
        g [] _ _ = []
        g (x:xs) s ix
          | isJust matchState = (ix, (fst $ fromJust matchState)) : g xs s (ix+1)
          | otherwise = g xs s (ix+1)
          where matchState = find (\y -> snd y == s) (snd x)

showStates h st = (map showLine (reverse [0..h-1]))
  where showLine y = '|' : concatMap (\s -> (s !! y) : "|") st

-- [(ix, throwHeight)], end ix, width
showLine :: [(Int, Int)] -> Int -> Int -> String
showLine arr ix width = '|' : (replicate (stIx*2) ' ')
                         ++ (drop 1 $ g arr stIx)
                         ++ (concat $ replicate (width - endIx) "| ")
  where stIx  = min ix $ fst (head arr)
        endIx = max ix $ fst (last arr)
        g lst i
          | i > endIx = ""
          | lst /= [] && fst (head lst) == i =
            arrowS : (showThrow $ snd (head lst)) ++ g (tail lst) (i+1)
          | i == ix   = arrowS : "." ++ rec
          | otherwise = arrowS : "-" ++ rec
          where rec = g lst (i+1)
                arrowS | i > ix = '<' | otherwise = '>'
                showThrow x | x < 10 = (show x)
                            | otherwise = chr (x + 87) : ""
