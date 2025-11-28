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

DATE='2008:05:05 15:07:23+02:00'
FILE='2008_05_05_kiteplane_Boenwindkanal.mp4'

# Create the video segments
$FFMPEG -i $SDIR/00396.mts -c copy -ss 00:00:02 -to 00:00:06 -an -y segment_01.mts
$FFMPEG -i $SDIR/00373.mts -c copy -ss 00:00:03 -to 00:00:08 -an -y segment_02.mts
$FFMPEG -i $SDIR/00387.mts -c copy -ss 00:00:08 -to 00:00:14 -an -y segment_03.mts
$FFMPEG -i $SDIR/00386.mts -c copy -ss 00:00:03 -to 00:00:07 -an -y segment_04.mts
$FFMPEG -i $SDIR/00388.mts -c copy -ss 00:01:09 -to 00:00:14 -an -y segment_05.mts
$FFMPEG -i $SDIR/00385.mts -c copy -ss 00:00:06 -to 00:00:15 -an -y segment_06.mts
$FFMPEG -i $SDIR/00392.mts -c copy -ss 00:00:17 -to 00:00:23 -an -y segment_07.mts
$FFMPEG -i $SDIR/00393.mts -c copy -ss 00:00:56 -to 00:01:00 -an -y segment_08.mts
$FFMPEG -i $SDIR/00394.mts -c copy -ss 00:00:20 -to 00:00:25 -an -y segment_09.mts

# Concatenate the segments with xfade transition
#./xfadeffmpeg.py segment_*.mts -e fade -d 1 -o $FILE
$( ./xfadeffmpeg.py segment_*.mts -e fade -d 1 -o $FILE )

# At very end
setmetadata "$SDIR/00374.mts" "$FILE"
rm -fr segment_*.mts
