#!/usr/bin/env sh
FILE="./grammars/perl6fe.cson"
TEMP_FILE="./grammars/perl6fe.cson.new"

perl6 ./dev/q-qq-Q-template.p6
if [ ! -f ZERO.cson ]; then
  exit 1
fi
awk '
    BEGIN       {p=1}
    /^#0START/   {print;system("cat ZERO.cson");p=0}
    /^#0END/     {p=1}
    p' "${FILE}" > "${TEMP_FILE}"
rm ZERO.cson
mv "${TEMP_FILE}" "${FILE}"

awk '
    BEGIN       {p=1}
    /^#1START/   {print;system("cat FIRST.cson");p=0}
    /^#1END/     {p=1}
    p' "${FILE}" > "${TEMP_FILE}"
rm FIRST.cson
mv "${TEMP_FILE}" "${FILE}"

awk '
    BEGIN       {p=1}
    /^#2START/   {print;system("cat SECOND.cson");p=0}
    /^#2END/     {p=1}
    p' "${FILE}" > "${TEMP_FILE}"
rm SECOND.cson
mv "${TEMP_FILE}" "${FILE}"
