# Timezones-tool

A small nim script to display time in different timezones in a terminal

## Running
Just running `timezonesTool` without any parameters will only display local time, but you can provide different parameters when running the tool:

### Timezones
You can specify the timezones to display with `-t` or `--timezones`. A timezone consist of:
* The display name can have any format and it's only used to clearly differentiate each timezone in the terminal,
* A semicolon (`:`),
* And a timezone in either [tz format](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones) like `America/Argentina/Buenos_Aires`, or just with the time offset like `+05:30`.

For example `Rome:Europe/Rome` or `"New Delhi:+05:30"`
For multiple timezones, you can use a space as a separator and put the entire list in double quotes.

### Time format
You can specify the format in which the time is displayed with `-f` or `--format`, for example `--format HH:mm:ss`. The list of valid formats is at the [official nim documentation](https://nim-lang.org/docs/times.html#parsing-and-formatting-dates)

### Configuration path
You can specify the path to the configuration file with `-c` or `--config`, for example `--config ./config.json`.
An example configuration can be:
```json
{
    "timezones": [
        {
	    "display": "Dublin",
	    "timezone": "Europe/Dublin"
	},
	{
	    "display": "Rome",
	    "timezone": "Europe/Rome"
	}
    ],
    "format": "HH:mm"
}
```