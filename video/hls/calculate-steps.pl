#!/usr/bin/perl
use strict;
use POSIX;
my $sourceResolution = $ARGV[0];
my $sourceBitrate    = $ARGV[1];
my $minSteps	     = 3;
my $bitRateShift     = 512;
my $audioRate	     = $ARGV[2];
my $outScript	     = $ARGV[3];

my $bandSteps = floor($sourceBitrate / $bitRateShift);
print "Bandwitdh Possible Steps: $bandSteps \n";


my $startBitRate = $sourceBitrate;
my $stepRate	 = 0;
my %variants;
while( $startBitRate > 0){
	if ($startBitRate >= $bitRateShift){
		$variants{$stepRate}{'bitrate'} = $startBitRate;
		$stepRate++;
		print "Stepd: $startBitRate" , "\n";
	}
	$startBitRate = $startBitRate - $bitRateShift;
}

print "Found $stepRate steps. Calculating variants resolutions..[$outScript]" , "\n";

my $heigh = $sourceResolution;
my $hStep = floor($heigh/$stepRate);
$stepRate     = 0;
while( $heigh > 0){
	if ($heigh > 130){
		if ($heigh % 2 == 1){
			$heigh++;
		}
		$variants{$stepRate}{'heigh'} = $heigh;		
		$stepRate++;
		print $heigh , "\n";
	}
	$heigh = $heigh - $hStep;
}

my $audioStep = floor($audioRate/$bandSteps);
$stepRate     = 0;
while ($audioRate > 0){
	if ($audioRate >16){
		$variants{$stepRate}{'audio'} = $audioRate;
		$stepRate++;
	}
	$audioRate = $audioRate - $audioStep;
}
if ($stepRate <4){
	open(SCRIPT,'>>',$outScript);
	while (my ($key,$value) = each(%variants)){
		my $rate = $variants{$key}->{'bitrate'};
		my $vh   = $variants{$key}->{'heigh'};
		my $hr	 = $variants{$key}->{'audio'};
		if(!$hr){
			$hr = 96;
		}
		print " R: $vh => $rate  \n";

		my $cmd = '	-filter:v scale='.$vh.':-2 \
			  -bufsize '.$rate.'k   \
			  -b:v '.$rate.'k -r $FRAME_RATE \
			  -c:v libx264 -x264opts "keyint=$GOP_INTERVAL:min-keyint=$GOP_INTERVAL:pic-struct:no-scenecut" -movflags fragkeyframe  \
			  -vprofile ${PROFILE} -level ${LEVEL}  -preset $H264_PRESET \
			  -g ${FRAME_RATE} -keyint_min $GOP_INTERVAL\
			  -maxrate '.$rate.'k \
			  -c:a aac \
			  -b:a '.$hr.'k -ac 2 \
			  -hls_time $HLS_TIME -hls_list_size 0 \
			  -start_number 0 \
			  ${DIR}/out/${PREFIX}_'.$rate.'k.m3u8 \
			  ';
		print $cmd;
		print SCRIPT $cmd;	
	}
	close(SCRIPT)
}else{
	open(SCRIPT,'>>',$outScript);
		my $key	 = $stepRate -1;
                my $rate = $variants{$key}->{'bitrate'};
                my $vh   = $variants{$key}->{'heigh'};
                my $hr   = $variants{$key}->{'audio'};
                if(!$hr){
                        $hr = 96;
                }
                print " R: $vh => $rate  \n";

                my $cmd = '     -filter:v scale='.$vh.':-2 \
                          -bufsize '.$rate.'k   \
                          -b:v '.$rate.'k -r $FRAME_RATE \
                          -c:v libx264 -x264opts "keyint=$GOP_INTERVAL:min-keyint=$GOP_INTERVAL:pic-struct:no-scenecut" -movflags fragkeyframe  \
                          -vprofile ${PROFILE} -level ${LEVEL}  -preset $H264_PRESET \
                          -g ${FRAME_RATE} -keyint_min $GOP_INTERVAL\
                          -maxrate '.$rate.'k \
                          -c:a aac \
                          -b:a '.$hr.'k -ac 2 \
                          -hls_time $HLS_TIME -hls_list_size 0 \
                          -start_number 0 \
                          ${DIR}/out/${PREFIX}_'.$rate.'k.m3u8 \
                          ';
                print $cmd;
                print SCRIPT $cmd;

		
                $key  = 0;
                $rate = $variants{$key}->{'bitrate'};
                $vh   = $variants{$key}->{'heigh'};
                $hr   = $variants{$key}->{'audio'};
                if(!$hr){
                        $hr = 96;
                }
                print " R: $vh => $rate  \n";

                $cmd = '     -filter:v scale='.$vh.':-2 \
                          -bufsize '.$rate.'k   \
                          -b:v '.$rate.'k -r $FRAME_RATE \
                          -c:v libx264 -x264opts "keyint=$GOP_INTERVAL:min-keyint=$GOP_INTERVAL:pic-struct:no-scenecut" -movflags fragkeyframe  \
                          -vprofile ${PROFILE} -level ${LEVEL}  -preset $H264_PRESET \
                          -g ${FRAME_RATE} -keyint_min $GOP_INTERVAL\
                          -maxrate '.$rate.'k \
                          -c:a aac \
                          -b:a '.$hr.'k -ac 2 \
                          -hls_time $HLS_TIME -hls_list_size 0 \
                          -start_number 0 \
                          ${DIR}/out/${PREFIX}_'.$rate.'k.m3u8 \
                          ';
                print $cmd;
                print SCRIPT $cmd;

                $key  = floor($stepRate/2);;
                $rate = $variants{$key}->{'bitrate'};
                $vh   = $variants{$key}->{'heigh'};
                $hr   = $variants{$key}->{'audio'};
                if(!$hr){
                        $hr = 96;
                }
                print " R: $vh => $rate  \n";

                $cmd = '     -filter:v scale='.$vh.':-2 \
                          -bufsize '.$rate.'k   \
                          -b:v '.$rate.'k -r $FRAME_RATE \
                          -c:v libx264 -x264opts "keyint=$GOP_INTERVAL:min-keyint=$GOP_INTERVAL:pic-struct:no-scenecut" -movflags fragkeyframe  \
                          -vprofile ${PROFILE} -level ${LEVEL}  -preset $H264_PRESET \
                          -g ${FRAME_RATE} -keyint_min $GOP_INTERVAL\
                          -maxrate '.$rate.'k \
                          -c:a aac \
                          -b:a '.$hr.'k -ac 2 \
                          -hls_time $HLS_TIME -hls_list_size 0 \
                          -start_number 0 \
                          ${DIR}/out/${PREFIX}_'.$rate.'k.m3u8 \
                          ';
                print $cmd;
                print SCRIPT $cmd;

	
	close(SCRIPT);

}
