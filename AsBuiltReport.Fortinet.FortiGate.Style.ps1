# Fortinet FortiGate Default Document Style

# Configure document options
DocumentOption -EnableSectionNumbering -PageSize A4 -DefaultFont 'Arial' -MarginLeftAndRight 71 -MarginTopAndBottom 71 -Orientation $Orientation

# Configure Heading and Font Styles
Style -Name 'Title' -Size 24 -Color '000000' -Align Center
Style -Name 'Title 2' -Size 18 -Color 'DA291C' -Align Center
Style -Name 'Title 3' -Size 12 -Color 'DA291C' -Align Left
Style -Name 'Heading 1' -Size 16 -Color 'DA291C'
Style -Name 'Heading 2' -Size 14 -Color 'DA291C'
Style -Name 'Heading 3' -Size 12 -Color 'DA291C'
Style -Name 'Heading 4' -Size 11 -Color 'DA291C'
Style -Name 'NO TOC Heading 4' -Size 11 -Color 'DA291C'
Style -Name 'Heading 5' -Size 10 -Color 'DA291C'
Style -Name 'NO TOC Heading 5' -Size 10 -Color 'DA291C'
Style -Name 'Normal' -Size 10 -Color '565656' -Default
Style -Name 'Caption' -Size 10 -Color '565656' -Italic -Align Center
Style -Name 'Header' -Size 10 -Color '565656' -Align Center
Style -Name 'Footer' -Size 10 -Color '565656' -Align Center
Style -Name 'TOC' -Size 16 -Color 'DA291C'
Style -Name 'TableDefaultHeading' -Size 10 -Color 'FFFFFF' -BackgroundColor 'DA291C'
Style -Name 'TableDefaultRow' -Size 10 -Color '565656'
Style -Name 'Critical' -Size 10 -Color 'FFFFFF' -BackgroundColor 'A12D2D'
Style -Name 'Warning' -Size 10 -Color 'FFFFFF' -BackgroundColor 'FFA52A'
Style -Name 'Info' -Size 10 -BackgroundColor '307FE2'
Style -Name 'OK' -Size 10 -BackgroundColor '48D597'

# Configure Table Styles
$TableDefaultProperties = @{
    Id = 'TableDefault'
    HeaderStyle = 'TableDefaultHeading'
    RowStyle = 'TableDefaultRow'
    BorderColor = 'DA291C'
    Align = 'Left'
    CaptionStyle = 'Caption'
    CaptionLocation = 'Below'
    BorderWidth = 0.25
    PaddingTop = 1
    PaddingBottom = 1.5
    PaddingLeft = 2
    PaddingRight = 2
}

TableStyle @TableDefaultProperties -Default
TableStyle -Id 'Borderless' -HeaderStyle Normal -RowStyle Normal -BorderWidth 0

# Fortinet FortiGate Cover Page Layout
# Header & Footer
if ($ReportConfig.Report.ShowHeaderFooter) {
    Header -Default {
        Paragraph -Style Header "$($ReportConfig.Report.Name) - v$($ReportConfig.Report.Version)"
    }

    Footer -Default {
        Paragraph -Style Footer 'Page <!# PageNumber #!>'
    }
}

# Set position of report titles and information based on page orientation
if (!($ReportConfig.Report.ShowCoverPageImage)) {
    $LineCount = 5
}
if ($Orientation -eq 'Portrait') {
    BlankLine -Count 11
    $LineCount = 32 + $LineCount
} else {
    BlankLine -Count 7
    $LineCount = 15 + $LineCount
}

# Fortinet Logo Image
# FORTINET DO NOT PERMIT THE USE OF THEIR LOGO WITHOUT AUTHORIZATION
<#
if ($ReportConfig.Report.ShowCoverPageImage) {
	# Always check the vendor's branding guidelines to ensure the use of their company logo is allowed.
	# Convert a vendor's logo image to Base64 using https://base64.guru/converter/encode/image/jpg.
	# Specify Base64 code using the `Base64` parameter below. Size image accordingly using the `Percent` parameter. Align image to center.

    Try {
    # Image -Text 'Fortinet Logo' -Align 'Center' -Percent 5 -Base64 ""
    } Catch {
        Write-PScriboMessage -Message ".NET Core is required for cover page image support. Please install .NET Core or disable 'ShowCoverPageImage' in the report JSON configuration file."
    }
}
#>

# Add Report Name
Paragraph -Style Title $ReportConfig.Report.Name

if ($AsBuiltConfig.Company.FullName) {
    # Add Company Name if specified
    BlankLine -Count 2
    Paragraph -Style Title2 $AsBuiltConfig.Company.FullName
    BlankLine -Count $LineCount
} else {
    BlankLine -Count ($LineCount + 1)
}
Table -Name 'Cover Page' -List -Style Borderless -Width 0 -Hashtable ([Ordered] @{
        'Author:' = $AsBuiltConfig.Report.Author
        'Date:' = (Get-Date).ToLongDateString()
        'Version:' = $ReportConfig.Report.Version
    })
PageBreak

if ($ReportConfig.Report.ShowTableOfContents) {
    # Add Table of Contents
    TOC -Name 'Table of Contents'
    PageBreak
}
