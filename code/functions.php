<?
/*
 * Used on the main page to update the static header.
 */
function currSelection()
{
	//if((!isset($_GET['p_drop']) && sizeof($_SESSION)==1) || $_GET['p_drop']=="NoNotMe")
	if(!isset($_GET['p_drop']) && !isset($_SESSION['p_drop']) || $_GET['p_drop']=="NoNotMe")
		echo "Province";
	else if(isset($_GET['p_drop']) || $_GET['o_drop']=="NoNotMe")
	//if(isset($_SESSION['p_drop']))
		echo "District";
	else if(isset($_GET['o_drop']) || $_GET['m_drop']=="NoNotMe")
	//else if(isset($_SESSION['o_drop']))
		echo "Municipality";
	else if(isset($_GET['m_drop']) || $_GET['t_drop']=="NoNotMe")
	//else if(isset($_SESSION['m_drop']))
		echo "Township";
	else
		echo "Province";
}

function openConn() {

	$SERVER_NAME = $_SERVER['SERVER_NAME'];

	switch ($SERVER_NAME) {

		case 'locality':
		default:
			$user = "root";
			$pass = "root";
			$db = "locality";
			break;
		case 'ir.iit.edu':
			$user = "ushmm";
			$pass = "ushmm";
			$db = "ushmm";
			break;
	}

	mysql_connect(localhost,$user,$pass);
	@mysql_select_db($db) or die("Database Error");
}


function autoResults($key,$val)
{
//	echo "$key:$val";
		switch($key)
		{
			case 'p_drop':
				$query="SELECT o FROM locality WHERE p = '$val'";
			break;
			
			case 'o_drop':
				$p=$_SESSION['p_drop'];
				$query="SELECT m FROM locality WHERE p = '$p' AND o = '$val'";
			break;

			case 'm_drop':
				$p = $_SESSION['p_drop'];
				$o = $_SESSION['o_drop'];
				$query="SELECT t FROM locality WHERE p = '$p' AND o = '$o' AND m = '$val'";
			break;
		}

		if(isset($query))
		{
//			echo "Running query";
			openConn();
			$query_result=mysql_query($query);
			$query_num=mysql_num_rows($query_result);
			mysql_close();
//			echo "<br>Num: $query_num";

			for($i=0;$i<$query_num;$i++)
			{
				//DEBUG
				//if(mysql_result($query_result,$i)!="X")
				if(mysql_result($query_result,$i)!=null)
					return false;
			}
			return true;

//				if(mysql_result($query_result,0)=="X")
//				{
//					return true;
//				}
//			}
		}
}


/*
 * $cat: The field to select from
 * $prev_cat: Used when we need to use the WHERE statement
 * $term: The row selected by the user
 * $selectID: Boolean; if true it changes the select statement below -- Selects the ID instead of the row data
*/
function display($cat, $prev_cat, $term, $selectID) {
	openConn();

	if($term!=null)//Term is only set when we need use a WHERE...term is the what was selected prev 
		switch($prev_cat)
		{
			case 'p':
				$query="SELECT o FROM locality WHERE p = '$term' ORDER BY $cat";
			break;
			
			case 'o':
				$p=$_SESSION['p_drop'];
				$query="SELECT m FROM locality WHERE p = '$p' AND o = '$term' ORDER BY $cat";
			break;

			case 'm':
				$p = $_SESSION['p_drop'];
				$o = $_SESSION['o_drop'];
				$query="SELECT t FROM locality WHERE p = '$p' AND o = '$o' AND m = '$term' ORDER BY $cat";
			break;
		}
	else
		$query="SELECT $cat FROM locality ORDER BY $cat";

	$query_result=mysql_query($query);
	$query_num=mysql_num_rows($query_result);
	mysql_close();

	$chosenList = array();//NOT NEEDED?

	echo "<SELECT NAME='".$cat."_drop'>";
	echo "<OPTION VALUE='NoNotMe'>";
//	array_push($chosenList,"\"<SELECT NAME='\".$cat."_drop'>\";");
//	echo "<OPTION VALUE='NoNotMe'>";
	$next=null;//Setting next to null as to display first row found
	if($selectID=="no")//If selecting the row info, not the id
	{
		for($i=0;$i<$query_num;$i++)
		{
			$dis = mysql_result($query_result,$i,$cat);

//		if($dis == "X")
//				$dis = "No Jewish Census Information";

			if(!in_array($dis,$chosenList) && $dis !=  "")
			{
				array_push($chosenList,$dis);
				echo "<OPTION VALUE='$dis'>$dis";//Didplay given entry
			}

			if($i+1<$query_num)//If not at the end of the rows, select the next to prevent duplicated
				$next = mysql_result($query_result,$i+1,$cat);
		}	
	}

	echo"</SELECT>";
	//DEBUG
	//if(sizeof($chosenList)==1 && $chosenList[0]=="X")
	if(sizeof($chosenList)==1 && $chosenList[0]==null)
	{
		echo "<br>Forward<br>";
	}
}


/* Simple footer echo */
function footer() 
{
	echo <<<END
	<div class="footer">
	Developed by Jason Soo and Jordan Wilberding under the direction of Drs. Gideon Frieder and Ophir Frieder. <br>
	Courtesy of the IIT IR Laboratory. E-Mail problems to <a class="footer" href="mailto:ushmm@ir.iit.edu">ushmm@ir.iit.edu</a>
	</div>
END;
}

/*
 * This is used when the user uses the search function.
 * It figures out what the user selected (ie. Prov or Dist, etc)
 * And then presets all fields before that to "Preset by Sercher"
 */
function checkSet()
{
	if($_GET['o_drop']!="" && !isset($_SESSION['p_drop']))
	{
		$loc = find_parents($_GET['o_drop'],'o');
		//$_SESSION['p_drop']="Preset by Searcher";
		$_SESSION['p_drop']="$loc[0]";
	}
	if($_GET['m_drop']!="" && !isset($_SESSION['o_drop']))
	{
		$loc = find_parents($_GET['m_drop'],'m');
		$_SESSION['p_drop']="$loc[0]";
		$_SESSION['o_drop']="$loc[1]";
		$_SESSION['m_drop']=$_GET['m_drop'];
	}
	if($_GET['t_drop']!="" && !isset($_SESSION['m_drop']))
	{
		$loc = find_parents($_GET['t_drop'],'t');
		$_SESSION['p_drop']="$loc[0]";
		$_SESSION['o_drop']="$loc[1]";
		$_SESSION['m_drop']="$loc[2]";
		$_SESSION['t_drop']="$loc[3]";
		/*
		foreach($loc as $val)
			echo $val;
		foreach($_SESSION as $val)
			echo $val;
			*/
		$_GET['t_drop']="$loc[3]";
	}

}


function find_parents($term,$type)
{
//	echo "<br>Find Parents:<br>Term: $term<br><br>Type: $type<br><br>";
	openConn();

	switch($type)
	{
		case 'o':
			$query="SELECT p from locality WHERE o = '$term'";
			$query_result=mysql_query($query);
			$num=mysql_num_rows($query_result);
			$loc[0] = mysql_result($query_result,0);
		break;

		case 'm':
			$query="SELECT * from locality WHERE m = '$term'";
			$query_result=mysql_query($query);
			$num=mysql_num_rows($query_result);
			$loc[0] = mysql_result($query_result,0,p);
			$loc[1] = mysql_result($query_result,0,o);
		break;

		case 't':
			$query="SELECT * from locality WHERE t = '$term'";
//			$query="SELECT * from locality WHERE id = '$term'";
			$query_result=mysql_query($query);
			$num=mysql_num_rows($query_result);
			$loc[0] = mysql_result($query_result,0,p);
			$loc[1] = mysql_result($query_result,0,o);
			$loc[2] = mysql_result($query_result,0,m);
			$loc[3] = mysql_result($query_result,0,t);
		break;
	}
			

	mysql_close();
	return $loc;
}

/*
 * Displays a functional serch box for the user to use.
 * Also inclused the selection box asking how accurate they spelled the word.
 */
function displaySearcher()
{
	$q = $_GET['query'];
	echo <<<END
	<div class="searcher">
	<form action="searchResults.php" method="get">
	<!-- <font face="Verdana" size="2">Searcher:</font> -->
	Searcher:
	<br>
	<input style="width: 185px" type="text" id="query" value="$q" name="query" autocomplete="off">
	<!--
	<br>
	Spelling Accuracy:
	<br>
	<SELECT name="et">
	<OPTION value="1">Very Close
	<OPTION value="2">Close
	<OPTION value="3" SELECTED>Somewhat
	<OPTION value="4">Off
	<OPTION value="5">Way Off
	<OPTION value="6">Nowhere Near Correct
	</SELECT> -->
	<input type="hidden" name="et" id="et" value="3" />
	<br><br>
	<input type="submit" value="Search">
	</form>
	</div>
END;
}

/*
 * Checks a search query entered by the user...
 * If it doesn't include any of the following 
 * The queyr is ok, and returns 1...
 * Otherwise the query is invalid and returns -1
 */
function checkQueryIsOK($query)
{
//	echo strpos($query,'%');
	if(strpos($query,'%')!==false)
		return -1;
	if(strpos($query,'_')!==false)
		return -1;
	if(strpos($query,'<')!==false)
		return -1;
	if(strpos($query,'>')!==false)
		return -1;
	if(strpos($query,'*')!==false)
		return -1;
	if(strpos($query,'(')!==false)
		return -1;
	if(strpos($query,')')!==false)
		return -1;
	if(strpos($query,'$')!==false)
		return -1;
	if(strpos($query,'!')!==false)
		return -1;
	if(strpos($query,'@')!==false)
		return -1;
	if(strpos($query,'#')!==false)
		return -1;
	if(strpos($query,'^')!==false)
		return -1;
	if(strpos($query,'=')!==false)
		return -1;
	if(strpos($query,'+')!==false)
		return -1;
	if(strpos($query,'"')!==false)
		return -1;
	if(strpos($query,'`')!==false)
		return -1;
	if(strpos($query,'{')!==false)
		return -1;
	if(strpos($query,'}')!==false)
		return -1;
	if(strpos($query,'[')!==false)
		return -1;
	if(strpos($query,']')!==false)
		return -1;
	if(strpos($query,'/')!==false)
		return -1;
	if(strpos($query,'\\')!==false)
		return -1;
	if(strpos($query,'?')!==false)
		return -1;
	if(strpos($query,';')!==false)
		return -1;
	if(strpos($query,':')!==false)
		return -1;
	else
		return 1;
}
?>
