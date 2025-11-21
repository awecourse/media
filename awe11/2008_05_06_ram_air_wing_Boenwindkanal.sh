#! /bin/bash
#
# Prepare video footage for deposit on https://av.tib.eu/
# 1. Cut video segments from original footage
# 2. Concatenate segments using xfade filter
#
LICENSE='This work is licensed to the public under the CC-Attribution - 4.0 International (CC BY 4.0) license http://creativecommons.org/licenses/by/4.0/'
LICENSEURL='http://creativecommons.org/licenses/by/4.0/'
AUTHOR='Roland Schmehl'
ATTRIBUTIONNAME='Delft University of Technology'
ATTRIBUTIONURL='http://www.tudelft.nl'
SDIR=/run/media/rschmehl/SD-Card/testing/2008-05-stuttgart/movies
FFMPEG=/opt/ffmpeg-4.4-i686-static/ffmpeg

setmetadata () {
  exiftool -tagsFromFile $1  \
  -VideoFrameRate=25 \
  -CreateDate="${DATE}" \
  -ModifyDate="${DATE}" \
  -Author="${AUTHOR}" \
  -XMP-dc:Rights="${LICENSE}" \
  -xmp:usageterms="${LICENSE}" \
  -XMP-cc:license="${LICENSEURL}" \
  -XMP-cc:AttributionName="${ATTRIBUTIONNAME}" \
  -XMP-cc:AttributionURL="${ATTRIBUTIONURL}" \
  -overwrite_original $2
}

DATE='2008:05:06 09:42:20+02:00'
FILE='2008_05_06_ram_air_wing_Boenwindkanal.mp4'

# Create the video segments
$FFMPEG -i $SDIR/00322.mts -c copy -ss 00:00:06 -to 00:00:10 -an -y segment_01.mts
$FFMPEG -i $SDIR/00322.mts -c copy -ss 00:00:45 -to 00:00:49 -an -y segment_02.mts
$FFMPEG -i $SDIR/00350.mts -c copy -ss 00:00:31 -to 00:00:35 -an -y segment_03.mts
$FFMPEG -i $SDIR/00350.mts -c copy -ss 00:00:15 -to 00:00:18 -an -y segment_04.mts
$FFMPEG -i $SDIR/00350.mts -c copy -ss 00:00:52 -to 00:00:55 -an -y segment_05.mts
$FFMPEG -i $SDIR/00351.mts -c copy -ss 00:00:01 -to 00:00:04 -an -y segment_06.mts
$FFMPEG -i $SDIR/00329.mts -c copy -ss 00:00:03 -to 00:00:06 -an -y segment_07.mts
$FFMPEG -i $SDIR/00341.mts -c copy -ss 00:00:03 -to 00:00:06 -an -y segment_08.mts
$FFMPEG -i $SDIR/00331.mts -c copy -ss 00:00:03 -to 00:00:06 -an -y segment_09.mts
$FFMPEG -i $SDIR/00353.mts -c copy -ss 00:00:04 -to 00:00:07 -an -y segment_10.mts
$FFMPEG -i $SDIR/00354.mts -c copy -ss 00:00:10 -to 00:00:15 -an -y segment_11.mts
$FFMPEG -i $SDIR/pointcloud.ts -c:v libx264 -vf "scale=1440x1080,setsar=4/3" -ss 00:00:01 -to 00:00:06 -an -y segment_12.mts
$FFMPEG -i $SDIR/00398.mts -c copy -ss 00:00:17 -to 00:00:22 -an -y segment_13.mts
$FFMPEG -i $SDIR/00402.mts -c copy -ss 00:02:19 -to 00:02:24 -an -y segment_14.mts
$FFMPEG -i $SDIR/00402.mts -c copy -ss 00:00:40 -to 00:00:44 -an -y segment_15.mts
$FFMPEG -i $SDIR/00401.mts -c copy -ss 00:00:09 -to 00:00:13 -an -y segment_16.mts
$FFMPEG -i $SDIR/00401.mts -c copy -ss 00:01:21 -to 00:01:25 -an -y segment_17.mts
$FFMPEG -i $SDIR/00403.mts -c copy -ss 00:00:16 -to 00:00:20 -an -y segment_18.mts
$FFMPEG -i $SDIR/00403.mts -c copy -ss 00:00:30 -to 00:00:34 -an -y segment_19.mts

# Concatenate the segments with xfade transition
#./xfadeffmpeg.py segment_*.mts -e fade -d 1 -o $FILE
$( ./xfadeffmpeg.py segment_*.mts -e fade -d 1 -o $FILE )

# At very end
setmetadata "$SDIR/00322.mts" "$FILE"
rm -fr segment_*.mts
