# Open files for reading/writing line by line
$reader = New-Object System.IO.StreamReader("C:\devlab\graphipedia\Neo4j\export.csv")
$writer = New-Object System.IO.StreamWriter("C:\devlab\graphipedia\Neo4j\output.csv")

# Copy first line over, with an extra ",DATE"
$writer.WriteLine("Title|PageID|Source")

# Process lines until in.csv ends
while (($line = $reader.ReadLine()) -ne $null) {
    # Get index of last occurrence of ""title"": "
    $index_title = $line.LastIndexOf("title")
	If ($index_title -gt 0) {
		$title = $line.Substring($index_title + 10)
		$index_title = $title.IndexOf("`"`"")
		$title = $title.Substring(0, $index_title)			
	} Else {
		$title = ""
	}
	
    $index_title = $line.LastIndexOf("pageid")
	If ($index_title -gt 0) {
		$pageid = $line.Substring($index_title + 9)
		$index_title = $pageid.IndexOf("`"`"")
		$pageid = $pageid.Substring(0, $index_title - 1)		
	} Else {
		$pageid = 0
	}
	
    $index_title = $line.LastIndexOf("source")
	If ($index_title -gt 0) {
		$source = $line.Substring($index_title + 11)
		$index_title = $source.IndexOf("`"`"")
		$source = $source.Substring(0, $index_title)		
	} Else {
		$source = ""
	}	
	
	echo $title
	echo $pageid
	echo $source

    # Replace last occurrence of "DATE: " with a comma
    $lineNew = $title + "|" + $pageid + "|" + $source
	$lineNew2 = $lineNew | Out-String
	
    # Write the modified line to the new file
    $writer.WriteLine($lineNew)
}

# Close the file handles
$reader.Close()
$writer.Close()