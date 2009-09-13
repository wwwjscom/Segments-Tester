#!/usr/bin/perl

#################################################
# Codificado en perl por Alejandro Reyes
# http://blazarsoft.50webs.com/
# en caso de encontrar un error comunicar a alejandroe4@hotmail.com
#################################################
# Creador del algoritmo Gary Mokotoff Copyright © 
#################################################
@newrules = (
["schtsch", "2", "4", "4"],["schtsh", "2", "4", "4"],["schtch", "2", "4", "4"],
["shtch", "2", "4", "4"],["shtsh", "2", "4", "4"],["stsch", "2", "4", "4"],
["ttsch", "4", "4", "4"],["zhdzh", "2", "4", "4"],["shch", "2", "4", "4"],
["scht", "2", "43", "43"],["schd", "2", "43", "43"],["stch", "2", "4", "4"],
["strz", "2", "4", "4"],["strs", "2", "4", "4"],["stsh", "2", "4", "4"],
["szcz", "2", "4", "4"],["szcs", "2", "4", "4"],["ttch", "4", "4", "4"],
["tsch", "4", "4", "4"],["ttsz", "4", "4", "4"],["zdzh", "2", "4", "4"],
["zsch", "4", "4", "4"],["chs", "5", "54", "54"],["csz", "4", "4", "4"],
["czs", "4", "4", "4"],["drz", "4", "4", "4"],["drs", "4", "4", "4"],
["dsh", "4", "4", "4"],["dsz", "4", "4", "4"],["dzh", "4", "4", "4"],
["dzs", "4", "4", "4"],["sch", "4", "4", "4"],["sht", "2", "43", "43"],
["szt", "2", "43", "43"],["shd", "2", "43", "43"],["szd", "2", "43", "43"],
["tch", "4", "4", "4"],["trz", "4", "4", "4"],["trs", "4", "4", "4"],
["tsh", "4", "4", "4"],["tts", "4", "4", "4"],["ttz", "4", "4", "4"],
["tzs", "4", "4", "4"],["tsz", "4", "4", "4"],["zdz", "2", "4", "4"],
["zhd", "2", "43", "43"],["zsh", "4", "4", "4"],["ai", "0", "1", "999"],
["aj", "0", "1", "999"],["ay", "0", "1", "999"],["au", "0", "7", "999"],
["cz", "4", "4", "4"],["cs", "4", "4", "4"],["ds", "4", "4", "4"],
["dz", "4", "4", "4"],["dt", "3", "3", "3"],["ei", "0", "1", "999"],
["ej", "0", "1", "999"],["ey", "0", "1", "999"],["eu", "1", "1", "999"],
["ia", "1", "999", "999"],["ie", "1", "999", "999"],["io", "1", "999", "999"],
["iu", "1", "999", "999"],["ks", "5", "54", "54"],["kh", "5", "5", "5"],
["mn", "66", "66", "66"],["nm", "66", "66", "66"],["oi", "0", "1", "999"],
["oj", "0", "1", "999"],["oy", "0", "1", "999"],["pf", "7", "7", "7"],
["ph", "7", "7", "7"],["sh", "4", "4", "4"],["sc", "2", "4", "4"],
["st", "2", "43", "43"],["sd", "2", "43", "43"],["sz", "4", "4", "4"],
["th", "3", "3", "3"],["ts", "4", "4", "4"],["tc", "4", "4", "4"],
["tz", "4", "4", "4"],["ui", "0", "1", "999"],["uj", "0", "1", "999"],
["uy", "0", "1", "999"],["ue", "0", "1", "999"],["zd", "2", "43", "43"],
["zh", "4", "4", "4"],["zs", "4", "4", "4"],["rz", "4", "4", "4"],
["ch", "5", "5", "5"],["ck", "5", "5", "5"],
#["rs", "4", "4", "4"],
["fb", "7", "7", "7"],
["a", "0", "999", "999"],
["b", "7", "7", "7"],
["d", "3", "3", "3"],
["e", "0", "999", "999"],
["f", "7", "7", "7"],
["g", "5", "5", "5"],
["h", "5", "5", "999"],
["i", "0", "999", "999"],
["k", "5", "5", "5"],
["l", "8", "8", "8"],
["m", "6", "6", "6"],
["n", "6", "6", "6"],
["o", "0", "999", "999"],
["p", "7", "7", "7"],
["q", "5", "5", "5"],
["r", "9", "9", "9"],
["s", "4", "4", "4"],
["t", "3", "3", "3"],
["u", "0", "999", "999"],
["v", "7", "7", "7"],
["w", "7", "7", "7"],
["x", "5", "54", "54"],
["y", "1", "999", "999"],
["z", "4", "4", "4"],
["c", "5", "5", "5"],
["j", "1", "999", "999"]
);

# Now branching cases
@xnewrules = (
["rz", "94", "94", "94"],
["ch", "4", "4", "4"],
["ck", "45", "45", "45"],
#["rs", "94", "94", "94"],
["c", "4", "4", "4"],
["j", "4", "4", "4"]
);

$xnewruleslist = "!rz!ch!ck!c!!j!"; # temporarily remove rs


$firstLetter = 'a'; $lastLetter = 'z'; $vowels = "aeioujy";
$SEPARATOR = " ";	$GROUPSEPARATOR = " ";

# provide alternate entry point so that dm.js and soundex.js can be called the same way
sub getSoundex{
	return soundex($_[0]);
}

sub soundex{
	$MyStr = $_[0];
	# replace certain text in strings with a slash	
	$MyStr =~ s/ v | v\. | vel | aka | f | f. | r | r. | false | recte | on zhe /\//gi;
	
	# append soundex of each individual word
	$result = "";
	@MyStrArray = split(/[\s|,]+/,$MyStr); # use space or comma as token delimiter
	
	for ($i=0; $i<=$#MyStrArray; $i++){ #print $i; print $MyStrArray[$i];
		if ( length($MyStrArray[$i]) > 0) { # ignore null at ends of array (due to leading or trailing space)
			if ($i != 0){
				$result = $result.GROUPSEPARATOR;
			}
			$result = $result.&soundex2($MyStrArray[$i]);			
		}
	}		
	$result = $result;
}

sub soundex2{	$MyStr = $_[0];
	$MyStr = lc($MyStr);
	$MyStr3 = $MyStr;
	#print $MyStr; 																									#ok osama
	$dm3 = "";
	while (length($MyStr3) > 0){
		$MyStr2 = "";	$LenMyStr3 = length($MyStr3);
		#print "\n+MyStr2:".$MyStr2." MyStr3:".$LenMyStr3." ";				#ok ( ,5)
		for ($i=0; $i < length($MyStr3); $i++) {
			$a = substr($MyStr,$i,1); $b = substr($MyStr3,$i,1); 
			if (($a ge $firstLetter && $b le $lastLetter) || $b eq '/'){ #print "\n".$a."-".$b;
				if ($b eq '/'){
					$MyStr3 = substr($MyStr3,$i + 1); # MyStr3 = MyStr3.slice(i + 1);
					last;
				}else{
					$MyStr2 = $MyStr2.$b;
				}
			} else {
				if ($MyStr[$i] eq "(" || $MyStr[$i] eq $SEPARATOR){
					last;
				}
			} #print "\n-MyStr2:".$MyStr2." MyStr3:".$MyStr3." ";
		} #print "\n-MyStr2:".$MyStr2." MyStr3:".$MyStr3." ";
		if ($i == $LenMyStr3){
			$MyStr3 = ""; # finished
		}
		#print $i."-".$LenMyStr3."  MyStr3: $MyStr3\n";							#ok
		$MyStr = $MyStr2;
		$dm = "";
		$allblank = 1;	# true
		for ($k=0; $k<length($MyStr); $k++){
			$c = substr($MyStr,$k,1);
			if ($c ne " "){
				$allblank = 0; last;
			} #print $k;
		} #print "166 $MyStr";																			#ok
		if (!$allblank) {
			
			$dim_dm2 = 1;
			@dm2 = (); #$dm2 = new Array(16);
			$dm2[0] = "";
			
			$first = 1;
			@lastdm = (); #lastdm = new Array(16);
			$lastdm[0] = "";
			
			while (length($MyStr) > 0){
				#print length($MyStr)." ";														#longitud $#newrules 118
				for ($i=0; $i<$#newrules; $i++){	# loop through the rules					
					if (substr($MyStr,0,length($newrules[$i][0])) eq $newrules[$i][0]){ # match found
						# check for xnewrules branch
						$xr = "!".$newrules[$i][0]."!"; #index(CADENA,SUBCADENA,POSICIÓN);
						if (index($xnewruleslist,$xr) != -1){
							$xr = index($xnewruleslist,$xr) / 3;
							for ($dmm = $dim_dm2; $dmm < 2*$dim_dm2; $dmm++){
								$dm2[$dmm] = $dm2[$dmm - $dim_dm2];
								$lastdm[$dmm] = $lastdm[$dmm - $dim_dm2];
							}
							$dim_dm2 = 2*$dim_dm2;						#print "\nxnewrules";
						}else{
							$xr = -1;
						}
						#############################ELIMINA UNA a UNA
						$dm = $dm."_".$newrules[$i][0];	#print "dm: $dm ";		#ok (imprime la palabra con _ intermedios
						if (length($MyStr) > length($newrules[$i][0])){
							$MyStr = substr($MyStr,length($newrules[$i][0])); 	#print "196 $MyStr\n";	#ok elimina la regla actual y acorta la cadena
						}else{
							$MyStr = ""; #print "198 $MyStr";										#ok termina de recorrer
						}
						
						if ($first == 1) {#print "\nInicio:$MyStr";						#ok, aqui ya se elimino la primera parte "letra"
							$dm2[0] = $newrules[$i][1];
							$first = 0;
							$lastdm[0] = $newrules[$i][1];
							#print "\nInicial: $dm2[0]  ";												#ok
							if ($xr  >= 0){
								$dm2[1] = $xnewrules[$xr][1];
								$lastdm[1] = $xnewrules[$xr][1];
								
							} #print "-dm2 $dm2[0] $dm2[1]-";										#ok En caso q halla mas de dos formas de mapeo
						}else{
							$dmnumber = 1;
							if ($dim_dm2 > 1){
								$dmnumber = $dim_dm2 / 2;
							} 			#print "MyStr:$MyStr ";											#ok va imprimiendo lo que queda d la pabra
							if (length($MyStr) > 0 && index($vowels,substr($MyStr,0,1)) != -1) { # followe by a vowel
								for ($ii=0; $ii<$dmnumber; $ii++) { 					
									if ($newrules[$i][2] ne "999" && $newrules[$i][2] ne $lastdm[$ii]) {
										# vowel following, non-branching case, not a vowel and different code from previous one
										$lastdm[$ii] = $newrules[$i][2];
										$dm2[$ii] = $dm2[$ii].$newrules[$i][2];							#print "dm2: $dm2[$ii] "; #ok +=
									}else {if ($newrules[$i][3] == 999){ # should this be newrules[i][2] ?
                    # vowel following, non-branching case, is a vowel, so reset previous one to blank
                    $lastdm[$ii] = "";
									} }
									# else non-branching case, not a vowel and same code from previous one -- do nothing
								}
								#entra en caso de haber varias opciones para la palabra
								if ($dim_dm2 > 1){
									for ($ii=$dmnumber; $ii<$dim_dm2; $ii++){
										if ($xr >= 0 && $xnewrules[$xr][2] ne "999" && $xnewrules[$xr][2] ne $lastdm[$ii]){
											# vowel following, branching case, not a vowel and different code from prevous case
                      $lastdm[$ii] = $xnewrules[$xr][2];
                      $dm2[$ii] = $dm2[$ii].$xnewrules[$xr][2]; 		#dm2[ii] += xnewrules[xr][2];
                      
                      # not in original code -- added for dm hebrew, never encountered used in dm latin
                      # occurs only when a vowel is in the branching case (e.g., the VAV in hebrew)
										} else { if ($xr >= 0 && $xnewrules[$xr][2] eq "999") {
											# vowel following, branching case, is a vowel, so reset previous one to blank
                      $lastdm[$ii] = "";
                      
                    } else {
                    	if ($xr < 0 && $newrules[$i][2] ne "999" && $newrules[$i][2] ne $lastdm[$ii]) {
                    		# vowel following, non-branching case, not a vowel and different code from prevous case
                    		$lastdm[$ii] = $newrules[$i][2] ;
                    		$dm2[$ii] = $dm2[$ii].$newrules[$i][2];				#+=
                    	}else { if ($newrules[$i][3] == 999) { # should this be newrules[i][2] ?
                    		# vowel following, non-branching case, is a vowel, so reset previous one to blank
                    		$lastdm[$ii] = "";
                    	}}
                  }}
                  } #fin for
									} # fin if
									
								}else{ 							#print "NoVoc:".substr($MyStr,0,1)." "; #if 216
									for ($ii=0; $ii<$dmnumber; $ii++) { 	#print "$ii "; #ok, casi siempre es 0
										if ($newrules[$i][3] ne "999" && $newrules[$i][3] ne $lastdm[$ii]){
											# non-branching case, not a vowel and different code from prevous case
											$lastdm[$ii] = $newrules[$i][3];
                    	$dm2[$ii] = $dm2[$ii].$newrules[$i][3];				#+=
										} else { if ($newrules[$i][3] == 999) {
											# non-branching case, is a vowel, so reset previous one to blank
                    	$lastdm[$ii] = "";
										}}
										# else non-branching case, not a vowel and same code from previous one -- do nothing
									} #fin for dmnumber
									if ($dim_dm2 > 1){
										for ($ii=dmnumber; $ii<$dim_dm2; $ii++){
											if ($xr >= 0 && $xnewrules[$xr][3] ne "999" && $xnewrules[$xr][3] ne $lastdm[$ii]){
												# branching case, not a vowel and different code from prevous case
                      	$lastdm[$ii] = $xnewrules[$xr][3];
                      	$dm2[$ii] = $dm2[$ii].$xnewrules[$xr][3];				#+=
                      	
                      	# not in original code -- added for dm hebrew, never encountered used in dm latin
                    		# occurs only when a vowel is in the branching case (e.g., the VAV in hebrew)
											} else { if ($xr >= 0 && $xnewrules[$xr][3] eq "999") {
												# branching case, is a vowel, so reset previous one to blank
                      	$lastdm[$ii] = "";
                      	
                      } else {
                      	if ($xr < 0 && $newrules[$i][3] ne "999" && $newrules[$i][3] ne $lastdm[$ii]){
                      		# non-branching case, not a vowel and different code from prevous case
                      		$lastdm[$ii] = $newrules[$i][3];
                      		$dm2[$ii] = $dm2[$ii].$newrules[$i][3];						#+=
                      	} else { if ($newrules[$i][3] == 999) {
                      		# non-branching case, is a vowel, so reset previous one to blank
                      		$lastdm[$ii] = "";
                      		} }
                      	} }
										}
									}
								} #print "nr:$newrules[$i][1] ";    #255
							}  #211
							
							last; # stop looping through rules
						} # end of match found
						
					} # end of looping through the rules 179
				} # end of while (MyStr.length) > 0)   177
				$dm = ""; 								#print "\n <dm2:".$dm2[0]."-".$dim_dm2.">";		#
				for ($ii=0; $ii<$dim_dm2; $ii++) {
					$aux1 = $dm2[$ii]."000000"; $dm2[$ii] = substr($aux1,0,6); # = (dm2[ii] + "000000").substr(0, 6);
					if ($ii == 0 && index($dm,$dm2[$ii]) == -1 && index($dm3,$dm2[$ii]) == -1) {
						$dm = $dm2[$ii];
					} else {
						if ( index($dm,$dm2[$ii]) == -1 && index($dm3,$dm2[$ii]) == -1) {
							if (length($dm) > 0){
								$dm = $dm.$SEPARATOR.$dm2[$ii];
							} else {
								$dm = $dm2[$ii];
							}
						}
					}
				} #fin for 301
	
				if (length($dm3) > 0 && index($dm3,$dm) == -1) {
					$dm3 = $dm3.$SEPARATOR.$dm;
				} else {
					if (length($dm) > 0){
						$dm3 = $dm;
					}
				}

			} #fin if(!allBlank) 67

		} # end of while
	
	$dm = $dm3;
}

print &soundex($ARGV[0])."\n";
