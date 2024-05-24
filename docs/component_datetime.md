[⬅ Promptfessional](../README.md#documentation)

# Component: `datetime`

Displays the current date and time.

## Behavior

- Displays the date and time of when the prompt is printed.
- Default prompt uses a format that displays `Tue Jan 01 15:22:35`.

## Options

|Option|Default|Description|
|:--|:--|:--|
|`--pattern`|`{color}{extra_color}{wday} {date_color}{mnth_name} {day} {time_color}{24hour}:{minute}:{second}`|The pattern to use.|

## Colors

|Name|Description|
|:--|:--|
|component.datetime|The color of the component.|
|component.datetime.date|The color for the date.|
|component.datetime.extra|The color for extra information such as the weekday.|
|component.datetime.time|The color for the time.|

## Variables

When specifying a pattern string, you can provide the following template variables:

|Variable|Description|
|:--|:--|
|`{year}`|The full year (e.g. 2024).|
|`{yr}`|The shortened year (e.g. 24).|
|`{month_name}`|The full month name (e.g. `January`).|
|`{mnth_name}`|The shortened month name (e.g. `Jan`).|
|`{month}`|The zero-padded month number.|
|`{mnth}`|The space-padded month number.|
|`{mnth_name}`|The shortened month name (e.g. `Jan`).|
|`{day}`|The zero-padded day of the month.|
|`{day_nopad}`|The day of the month.|
|`{12hr}`|The space-padded hour in 12-hour format.|
|`{12hour}`|The zero-padded hour in 12-hour format.|
|`{24hr}`|The space-padded hour in 24-hour format.|
|`{24hour}`|The zero-padded hour in 24-hour format.|
|`{minute}`|The zero-padded minute of the hour.|
|`{min}`|The space-padded minute of the hour.|
|`{second}`|The zero-padded second of the minute.|
|`{sec}`|The space-padded second of the minute.|
|`{AM}` or `{PM}`|AM/PM in upper case.|
|`{am}` or `{pm}`|AM/PM in lower case.|
|`{wday}`|The shortened weekday name (e.g. `Mon`).|
|`{weekday}`|The full weekday name (e.g. `Monday`).|
|`{tz_name}`|The timezone name.|
|`{tz_offset}`|The timezone offset.|
|`{color}`|The component color.|
|`{date_color}`|The color for the date part of the component.|
|`{extra_color}`|The color for the weekday part of the component.|
|`{time_color}`|The color for the time part of the component.|
