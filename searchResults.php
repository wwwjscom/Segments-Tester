<?
require('sug_func.php');
$et = 3;
$query = $argv[1];
$_GET['query'] = $query;

		/* ET stands for Error Threshold...this is set by the user in the drop-down menu when they enter a query.  
		 * The closer to 0 the ET becomes, the more accurately the user believes they spelled the word.
		 * See the function displaySearcher in functions.php for the numeric values.
		 * A higher ET should return more results, while a lower one should return less.
		 */

		/* Start executing the search assisting methods */
		$list1=method1($_GET['query'],$et);
		$list3=method3($_GET['query'],$et);
		$list4=method4($_GET['query'],$et);
		$list5=method5($_GET['query'],$et);
		$list6=method6($_GET['query'],$et);
		$list7=method7($_GET['query'],$et);
	
		/* Merge all of the returned results into one array */
		$finalArray=array_merge($list1,$list3,$list4,$list5,$list6,$list7);

		$myFile = "/Applications/MAMP/locality/ngrams/votes/our_results.txt";
		$fh = fopen($myFile, 'w') or die("can't open file");

		/* If empty, nothing was found */
		if(sizeof($finalArray)==0)
			$stringData = "0, 0";
		else {
			$origArray=$finalArray;
			$origLen=count($origArray);
			$finalArray=(array_count_values($finalArray));
			arsort($finalArray);//Sort the array
//	reset($finalArray);



			/* Iterate through all of the results */
			while(list($key, $val) = each($finalArray))
			{
				/* Divide how many times the current result was found by the the number of results found.
				 * Then round the value and * it by 100 to make it a percent. */
				$percent= $val/$origLen; 
				$percent=round($percent*100);
				$tmp = findType($key);//Figures out what type (ie. Prov, Dist, etc) the current array value is
				if($tmp == 'p' || $tmp == 'o' || $tmp == 'm' || $tmp == 't' || $tmp == 'h')
				{
					//Makes the output look better
					if($tmp == 'p')
						$type = "Province";
					if($tmp == 'o')
						$type = "District";
					if($tmp == 'm')
						$type = "Municipality";
					if($tmp == 't')
						$type = "Township";
					if($tmp == 'h')
						$type = "Result";
					//If we have a 100% match, then we only found one matching result.
					//If we have a 100% match, then we only found one matching result.
					if($percent==100)
						$stringData = "$val, $key\n";
					//Otherwise display the current result with the percentage that the user meant this word.
					else
						$stringData = "$val, $key\n";
				}	else
				//Does the same as above, except for townships.
					if($percent==100)
						$stringData = "$key is the only close match we found.\n";
					else
						$stringData = "$key is $percent% likely to be your choice.\n";

				fwrite($fh, $stringData);
			}
		}

		fclose($fh);
?>
