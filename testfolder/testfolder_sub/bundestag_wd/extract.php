<?php
ini_set('memory_limit', '2048M');
include_once("simple_html_dom.php");
$db;
set_time_limit(0);
$breakDoubleLimit = 60;
$doubles = 0;
$maxoffset = 8800;

$KILL= time() . "000";
$OFFSET = 0;

CrawlData();

function CrawlData(){
    global $OFFSET, $KILL, $doubles , $breakDoubleLimit;
    while($OFFSET < $KILL){
        echo "<h2>Crawl with offset $OFFSET </h2>";
        $inp = "https://www.bundestag.de/ajax/filterlist/de/dokumente/analysen/442054-442054/h_3509d35ded1665a05475c26e7d489192?enddate=$KILL&endfield=date&limit=20&noFilterSet=false&offset=$OFFSET&startdate=1213740000000&startfield=date";
        $OFFSET += 20;
        GetExtract($inp);
        if($doubles > $breakDoubleLimit){
            return false;
        }
    }



}


//$inp = "all/OUTPUT_0.html";









function OpenDB(){
    global $db;
    $db = new SQLite3("WD_DATA");
    $db-> exec("CREATE TABLE IF NOT EXISTS WDDokumente (
        	docuid INTEGER PRIMARY KEY,
            doctimestamp INTEGER NOT NULL,
            docthema TEXT NOT NULL,
            doctyp TEXT NOT NULL,
        	doclabel TEXT NOT NULL,
	        doclink TEXT NOT NULL,
	        checksum TEXT NOT NULL UNIQUE
    )"

    );
}
///////////////
function CloseDB(){
    global $db;
    $db->close();
}



function GetExtract($inp){
    OpenDB();
    $i=0;
    $html = file_get_html($inp);
    foreach($html->find('tr') as $element){
        if($i > 0){
       // echo $element->innertext .  "<br />";
        
            foreach( $element->find('td[data-th=Veröffentlichung]') as $dat){
                $datum =  trim($dat->plaintext) ;
                $datum = SaniDate($datum);
                $timestamp = strtotime($datum);
            }

            foreach( $element->find('td[data-th=Dokumenttyp]') as $dt){
                $doctyp =  trim($dt->plaintext) ;
            }

            foreach( $element->find('td[data-th=Thema]') as $th){
                $thema =  trim($th->plaintext) ;
            }

            foreach( $element->find('td[data-th=Dokument]') as $docdata){
                $dn = $docdata->find("strong",0);
                $docname = trim($dn->plaintext);
                $dl =$docdata->find("a",0);
                $doclink =  "https://www.bundestag.de" . trim($dl->href) ;
            }

            echo "<hr>$timestamp -  $doctyp - $datum - $thema<br> $docname <br> $doclink  ";
            $checksum=md5($doclink);
            if(!IsIn($checksum)){
                AddData($doctyp,$thema,"$datum - $docname",$doclink,$checksum,$timestamp);
            }else{

            }

        }
        $i++;

    }


    CloseDB();
}

function IsIn($checksum){
    global $db,$doubles;
    $results = $db->query("SELECT checksum FROM WDDokumente WHERE checksum = '$checksum'");
    //echo "<h2>" . strlen(print_r($results->fetchArray(),true)) . "</h2>";
    if(strlen(print_r($results->fetchArray(),true)) > 100){
        $doubles++;
        return true;
    }
        return false;
}

function AddData($doctyp,$docthema,$label,$link,$checksum,$timestamp){
    global $db;
    $db->exec("INSERT INTO WDDokumente (
        docthema,
        doctimestamp, 
        doctyp, 
        doclabel,
        doclink,
        checksum
        ) VALUES (
            '$docthema',
            $timestamp,
            '$doctyp',
            '$label',
            '$link',
            '$checksum'
        )");
}

function SaniDate($datumGet){
    $repl = array(
        ' Januar ' => "01.",
        ' Februar ' => "02.",
        ' März ' => "03.",
        ' April ' => "04.",
        ' Mai ' => "05.",
        ' Juni ' => "06.",
        ' Juli ' => "07.",
        ' August ' => "08.",
        ' September ' => "09.",
        ' Oktober ' => "10.",
        ' November ' => "11.",
        ' Dezember ' => "12."     
    );
    return strtr($datumGet,$repl);

}