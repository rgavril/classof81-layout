#!/bin/bash

version=$1

folder="/tmp/Class of 81"
zipfile="/tmp/classof81-v$version.zip"
tgzfile="/tmp/classof81-v$version.tgz"

echo "Building Release $version ..."

echo "Copying Files ..."
rm -r "$folder"
mkdir -p "$folder"
cp -r ../* "$folder"
echo "$version" > /tmp/version.txt

echo "Cleaning Up ..."
find "$folder" -name '*.git*' -exec rm -Rf {} \;
find "$folder" -name '.DS_Store' -exec rm -Rf {} \; 

rm -rf "$folder/achievements"/*
rm -rf "$folder/config"/*
rm -rf "$folder/helpers"
rm -rf "$folder/images/_pixelmator"
rm -rf "$folder/test.nut"

echo "Creating Zip $zipfile ..."
pushd "$(dirname "$folder")" >/dev/null
rm -rf "$zipfile"
zip -q -r "$zipfile" "$(basename "$folder")"
popd > /dev/null

echo "Creating TGZ $tgzfile ..."
pushd "$(dirname "$folder")" >/dev/null
rm -rf "$tgzfile"
tar zcf "$tgzfile" "$(basename "$folder")"
popd > /dev/null
