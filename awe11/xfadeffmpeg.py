#!/usr/bin/python3
# Use ffmpeg xfade filter to concatenate video segments
#
# source: https://gist.github.com/ckhung/6e9c6bf47a1f977f2f16da4707664361
# reference: https://stackoverflow.com/a/66546687
#
# Note: for some reason, some of the clipped mts-files, when clipped from t=0, do not render well after concatenation.

import argparse, subprocess, re

def gen_filter(segments, effect='fade', duration=1):
    video_fades = ''
    audio_fades = ''
    settb = ''
    last_fade_output = '0:v'
    last_audio_output = '0:a'

    video_length = 0
    file_lengths = [0]*len(segments)

    input_files = ''
    for i in range(len(segments)):
        settb += '[{:d}]settb=AVTB[{:d}:v];'.format(i,i)
        input_files += ' -i ' + segments[i]

    for i in range(len(segments)-1):
        file_lengths[i] = float(
            subprocess.check_output(
                re.split('\s+', 'ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1') + [segments[i]]
            )
        )
        video_length += file_lengths[i]
        next_fade_output = 'v{:d}{:d}'.format(i, i+1)
        video_fades += '[{}][{:d}:v]xfade=transition={}:duration={:0.2f}:offset={:0.2f}'.format(
            last_fade_output, i+1, effect, duration, video_length - duration*(i+1)
        )
        video_fades += '[{}];'.format(next_fade_output) \
            if i < len(segments)-2 \
            else ''
        last_fade_output = next_fade_output

        next_audio_output = 'a{:d}{:d}'.format(i, i+1)
        audio_fades += '[{}][{:d}:a]acrossfade=d={:0.2f}'.format(
            last_audio_output, i+1, duration
        )
        if (i) < len(segments)-2:
            audio_fades += '[{}];'.format(next_audio_output)
        last_audio_output = next_audio_output

#    video_fades += '[video];'
    video_fades += '[video]'  # Audio removed
    audio_fades += '[audio]'

#    return '/opt/ffmpeg-4.4-i686-static/ffmpeg {} -c:v libx264 -s 1280x960 -acodec libmp3lame -b:a 192k -filter_complex {} -map [video] -map [audio] -movflags +faststart'.format(
#        input_files, settb + video_fades + audio_fades
#    )
    return '/opt/ffmpeg-4.4-i686-static/ffmpeg {} -c:v libx264 -s 1280x960 -filter_complex {} -map [video] -movflags +faststart'.format(
        input_files, settb + video_fades
    ) # Audio removed

parser = argparse.ArgumentParser(
    description='generate parameters for xfade of ffmpeg',
    formatter_class=argparse.ArgumentDefaultsHelpFormatter)
parser.add_argument('-o', '--outfile', type=str, default='out.mp4',
    help='output file name')
parser.add_argument('-e', '--effect', type=str, default='fade',
    help='transition effect')
parser.add_argument('-d', '--duration', type=float, default=1,
    help='transition duration')
parser.add_argument('videofiles', nargs='*', help=u'v1.mp4 v2.mp4 ...')
args = parser.parse_args()

print(gen_filter(args.videofiles, effect=args.effect, duration=args.duration) + ' -y ' + args.outfile)
