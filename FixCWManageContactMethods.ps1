## Specify the location to save the JSON Export, or modify this to use the $OutputFixedRecords variable
## Specify the CSV of the database export that contains all your contacts communication methods.

$ExportJsonPath =  'put a path here'
$ImportCSVPath = 'put a path here'


function Get-ContactMethodType {
    param( $CommunicationTypeRecID)
    switch ($CommunicationTypeRecID) {
        1 { "Email_1"}
        2 { "PhoneDirect" }
        3 { "Fax" }
        4 { "PhoneMobile" }
        5 { "PhonePager" }
        6 { "PhoneHome" }
        7 { "FaxHome" }
        8 { "Email_2" }
        9 { "Email_3" }
        default { $false }
    }
}


$ImportedContactMethodTypesCSV = Import-Csv $ImportCSVPath

$GroupedContacts = $ImportedContactMethodTypesCSV | Group-Object -Property Contact_RecID

$OutputFixedRecords = foreach ($UserEntry in $GroupedContacts) { 
    [pscustomobject]$UserCommDetails = @{Contact_RecID = $UserEntry.name}; 
    foreach ($r in $UserEntry.group) {$UserCommDetails["$(Get-ContactMethodType -CommunicationTypeRecID $r.Communication_Type_RecID)"] = $r.description}
    $UserCommDetails
 }

 $OutputFixedRecords | ConvertTo-Json -Depth 100 -Compress |Out-File -Path $ExportJSONPath
