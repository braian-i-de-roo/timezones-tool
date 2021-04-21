# Package

version       = "1.0.0"
author        = "braian-pc"
description   = "A small nim script to display time in different timezones in a terminal"
license       = "MIT"
srcDir        = "src"
bin           = @["timezonesTool"]



# Dependencies

requires "nim >= 1.2.6", "timezones >= 0.5.4 & < 0.6.0"
