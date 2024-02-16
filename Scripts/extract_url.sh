#!/bin/bash
# Safety.
set -e || exit 1
set -u && set -o pipefail && shopt -s failglob

# Set directory and url file or fail.
dir="${HOME}/Sync/bookmarks" || exit 1
dir="${HOME}/Sync/bookmarks/urls.txt" || exit 1

# More safety.
[[ -d "${dir}" ]] || exit 1
[[ -f "${dir}/urls.txt" ]] || exit 1

# Cd into dir or fail
cd -- "${dir}" || exit 1

# Iterate over each .html file in the directory.
IFS="$(echo -en "\n\b")"
for file in *.html; do
 if [[ -f "${file}" ]]; then
  # Find url in each.
  url="$(head -n 15 -- "${file}" | { grep -oP -- 'url: \K[^\n]+' || test "${?}" = 1; })"
  # Remove trailing whitespace
  url="$(echo -enE "${url}" | sed 's/\s*$//')"
  # Output
  echo -en "${url}\n" >> "${dir}/urls.txt"
 fi
done

# Remove dupes and empty lines
echo -nE "$(sort -u -- "${dir}"/urls.txt)" > urls.txt
echo -nE "$({ grep -v -- '^$' "${dir}"/urls.txt || test "${?}" = 1; })" > urls.txt
exit 0
