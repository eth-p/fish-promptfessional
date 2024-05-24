# Prompt Component: Datetime
# Displays the current date and time.
#
# Options:
#   --pattern   :: The pattern to use.      (default: "{color}{extra_color}{wday} {date_color}{mnth_name} {day} {time_color}{24hour}:{minute}:{second}")
#
# Colors:
#   component.datetime       :: The color of the component.
#   component.datetime.extra :: The color for extra information such as the weekday.
#   component.datetime.date  :: The color for the date.
#   component.datetime.time  :: The color for the time.
function promptfessional_component_datetime
	argparse 'pattern=' -- $argv
	[ -n "$_flag_pattern" ]   || set _flag_pattern '{color}{extra_color}{wday} {date_color}{mnth_name} {day} {time_color}{24hour}:{minute}:{second}'

	# Get the date and time.
	date +"%A:%a:%B:%b:%d:%e:%G:%g:%H:%I:%k:%l:%m:%M:%S:%Z:%z:%p" | \
		read --function --delimiter=':' \
		weekday_name_full weekday_name_short \
		month_name_full month_name_short \
		day_of_month_padded day_of_month \
		year_long year_short \
		hour_24_padded hour_12_padded \
		hour_24 hour_12 \
		month_padded \
		minute_padded second_padded \
		timezone_name timezone_offset \
		ampm

	set ampm_lower (string lower -- "$ampm")
	set ampm_upper (string upper -- "$ampm")

	# Render the date and time.
	set -l color (promptfessional color "component.datetime")
	set -l color_date (promptfessional color "component.datetime.date")
	set -l color_time (promptfessional color "component.datetime.time")
	set -l color_extra (promptfessional color "component.datetime.extra")
	promptfessional util template "$_flag_pattern" -- \
		"color" "$color" \
		"date_color" "$color_date" \
		"time_color" "$color_time" \
		"extra_color" "$color_extra" \
		"weekday" "$weekday_name_full" \
		"wday" "$weekday_name_short" \
		"month_name" "$month_name_full" \
		"mnth_name" "$month_name_short" \
		"day" "$day_of_month_padded" \
		"day_nopad" "$day_of_month" \
		"year" "$year_long" \
		"yr" "$year_short" \
		"24hour" "$hour_24_padded" \
		"12hour" "$hour_12_padded" \
		"24hr" "$hour_24" \
		"12hr" "$hour_12" \
		"month" "$month_padded" \
		"mnth" "$month_padded" \
		"minute" "$minute_padded" \
		"min" "$minute_padded" \
		"second" "$second_padded" \
		"sec" "$second_padded" \
		"tz_name" "$timezone_name" \
		"tz_offset" "$timezone_offset" \
		"AM" "$ampm_upper" \
		"am" "$ampm_lower" \
		"PM" "$ampm_upper" \
		"pm" "$ampm_lower"
end

