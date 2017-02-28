#!/usr/bin/env bash
INPUT=people.csv
TEMPLATE=sig.tpl
MYFOLDER="$(dirname $0)"
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
$MYFOLDER/csv.awk -v fs="," -v ofs="/" $MYFOLDER/$INPUT > $MYFOLDER/$INPUT.ssv # we process the CSV, replacing the commas with slashes and removing quotes in fields with a comma.
#dos2unix $MYFOLDER/$INPUT.ssv
FIELDS=$(< people.csv head -1 | awk -f csv.awk -v fs="," -v ofs=" ") # the first line in the CSV is the list of fields. We process it into "space separated" and set $FIELDS to its contents.
#echo "fields are $FIELDS"
rm -fR output 2>/dev/null 1>&2
mkdir output 2>/dev/null 1>&2
while IFS=/ read -r firstname lastname position cellphone officephone #"$FIELDS"
do
	sed \
		-e "s/\${firstname}/$firstname/g" \
		-e "s/\${lastname}/$lastname/g" \
		-e "s/\${position}/$position/g" \
		-e "s/\${cellphone}/$cellphone/g" \
		-e "s/\${officephone}/$officephone/g" \
			template.html \
				> $MYFOLDER/output/${lastname}-${firstname}.html

done < $MYFOLDER/$INPUT.ssv
rm output/lastname-firstname.html $MYFOLDER/$INPUT.ssv
