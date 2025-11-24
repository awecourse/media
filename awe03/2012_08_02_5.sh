#!/bin/bash
# Prepare video footage for deposit on https://av.tib.eu/
# - setting framerate and video encoding (H264)
# - cutting videos to same absolute starting time and duration
# - disengagement of tether from mast head is used for synchronization
# - original resolution of GoPro video: 1280x960 (960p) 4:3  SXGA- https://en.wikipedia.org/wiki/Graphics_display_resolution#SXGAminus
#

LICENSE='This work is licensed to the public under the CC-Attribution - 4.0 International (CC BY 4.0) license http://creativecommons.org/licenses/by/4.0/'
LICENSEURL='http://creativecommons.org/licenses/by/4.0/'
AUTHOR='Roland Schmehl'
ATTRIBUTIONNAME='Delft University of Technology'
ATTRIBUTIONURL='http://www.tudelft.nl'

setmetadata () {
  exiftool -tagsFromFile $1  \
  -VideoFrameRate=25 \
  -CreateDate="${DATE}" \
  -ModifyDate="${DATE}" \
  -QuickTime:TrackCreateDate="${DATE}" \
  -QuickTime:TrackModifyDate="${DATE}" \
  -QuickTime:MediaCreateDate="${DATE}" \
  -QuickTime:MediaModifyDate="${DATE}" \
  -Author="${AUTHOR}" \
  -XMP-dc:Rights="${LICENSE}" \
  -xmp:usageterms="${LICENSE}" \
  -XMP-cc:license="${LICENSEURL}" \
  -XMP-cc:AttributionName="${ATTRIBUTIONNAME}" \
  -XMP-cc:AttributionURL="${ATTRIBUTIONURL}" \
  -overwrite_original $2
}

# Pillarboxing the original GoPro video, wich is in 1280x960 format, to 1280x720 format
DATE='2012:08:02 19:26:29.50'
SDIR=/run/media/rschmehl/SD-Card/testing/2012-08-02/video
FILE='2012_08_02_5-GoPro_Ground.mp4'
echo $SDIR
#ffmpeg -i $SDIR/Start2.MP4 -c:v libx264 -vf "scale=iw*sar:ih,setsar=1,pad=ih*16/9:ih:(ow-iw)/2:0,fps=fps=25" -s 1280x720 -crf 25 -strict -2 -ss 00:07:21.884  -t 30 $FILE
#setmetadata "$SDIR/Start2.MP4" "$FILE"

# Setting two synchronized GoPro videos side by side, letterboxing the merged video and scaling it down to 1280x720 format
FILE='2012_08_02_5.mp4'
ffmpeg -ss 00:07:21.884  -t 30 -i $SDIR/Start2.MP4 -ss 00:05:53.763 -t 30 -i $SDIR/GOPR0291.MP4 -c:v libx264 -filter_complex "scale=iw*sar:ih,setsar=1[a]; scale=iw*sar:ih,setsar=1[b]; [a][b]hstack,pad=2560:1440:-1:-1,fps=fps=25" -s 1280x720 -crf 25 -strict -2 $FILE
setmetadata "$SDIR/Start2.MP4" "$FILE"


# Pillarboxing, in color, the original square formatted simulation video, removing also a 9px black bar at the bottom.
SDIR=/home/rschmehl/awecourse-material/video
FILE='4-point_kite_8ms.mp4'
#echo $SDIR
#ffmpeg -i $SDIR/4-point_kite_8ms.mp4 -c:v libx264 -vf "crop=iw:ih-9:0:0,scale=iw*sar:ih,setsar=1,pad=ih*16/9:ih:(ow-iw)/2:0:color=0xb2cbfe,fps=fps=25" -s 1280x720 -strict -2 $FILE

ffmpeg -i ./Twingtec-Pilot-System-Demonstrates-Automated-Electricity-Production-90.mp4 -c:v libx264  -s 1280x720 -strict -2 -crf 25 twingtec.mp4 
