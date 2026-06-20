{ pkgs, ... }:

let
  mediaplayer = pkgs.writeShellScriptBin "i3-mediaplayer" ''
    #!/usr/bin/env perl

    use Time::HiRes qw(usleep);
    use Env qw(BLOCK_INSTANCE);

    use constant DELAY => 50;
    use constant SPOTIFY_STR => 'spotify';

    my @metadata = ();
    my $player_arg = "";

    if ($BLOCK_INSTANCE) {
        $player_arg = "--player=$BLOCK_INSTANCE";
    }

    sub buttons {
        my $method = shift;

        if($method eq 'mpd') {
            if ($ENV{'BLOCK_BUTTON'} == 1) {
                system("mpc prev");
            } elsif ($ENV{'BLOCK_BUTTON'} == 2) {
                system("mpc toggle");
            } elsif ($ENV{'BLOCK_BUTTON'} == 3) {
                system("mpc next");
            } elsif ($ENV{'BLOCK_BUTTON'} == 4) {
                system("mpc volume +10");
            } elsif ($ENV{'BLOCK_BUTTON'} == 5) {
                system("mpc volume -10");
            }
        } elsif ($method eq 'cmus') {
            if ($ENV{'BLOCK_BUTTON'} == 1) {
                system("cmus-remote --prev");
            } elsif ($ENV{'BLOCK_BUTTON'} == 2) {
                system("cmus-remote --pause");
            } elsif ($ENV{'BLOCK_BUTTON'} == 3) {
                system("cmus-remote --next");
            }
        } elsif ($method eq 'playerctl') {
            if ($ENV{'BLOCK_BUTTON'} == 1) {
                system("playerctl $player_arg previous");
                usleep(DELAY * 1000) if $BLOCK_INSTANCE eq SPOTIFY_STR;
            } elsif ($ENV{'BLOCK_BUTTON'} == 2) {
                system("playerctl $player_arg play-pause");
            } elsif ($ENV{'BLOCK_BUTTON'} == 3) {
                system("playerctl $player_arg next");
                usleep(DELAY * 1000) if $BLOCK_INSTANCE eq SPOTIFY_STR;
            } elsif ($ENV{'BLOCK_BUTTON'} == 5) {
                system("playerctl $player_arg volume 1.01+");
            } elsif ($ENV{'BLOCK_BUTTON'} == 6) {
                system("playerctl $player_arg volume 1.01-");
            }
        } elsif ($method eq 'rhythmbox') {
            if ($ENV{'BLOCK_BUTTON'} == 2) {
                system("rhythmbox-client --previous");
            } elsif ($ENV{'BLOCK_BUTTON'} == 3) {
                system("rhythmbox-client --play-pause");
            } elsif ($ENV{'BLOCK_BUTTON'} == 4) {
                system("rhythmbox-client --next");
            }
        }
    }

    sub cmus {
        my @cmus = split /^/, qx(cmus-remote -Q);
        if ($? == 1) {
            foreach my $line (@cmus) {
                my @data = split /\s/, $line;
                if (shift @data eq 'tag') {
                    my $key = shift @data;
                    my $value = join ' ', @data;

                    @metadata[1] = $value if $key eq 'artist';
                    @metadata[2] = $value if $key eq 'title';
                }
            }

            if (@metadata) {
                buttons('cmus');
                print(join ' - ', @metadata);
                exit 1;
            }
        }
    }

    sub mpd {
        my $data = qx(mpc current);
        if (not $data eq '') {
            buttons("mpd");
            print($data);
            exit 1;
        }
    }

    sub playerctl {
        buttons('playerctl');

        my $artist = qx(playerctl $player_arg metadata artist);
        chomp $artist;
        exit(1) if $? || $artist eq '(null)';
        push(@metadata, $artist) if $artist;

        my $title = qx(playerctl $player_arg metadata title);
        exit(1) if $? || $title eq '(null)';
        push(@metadata, $title) if $title;

        print(join(" - ", @metadata)) if @metadata;
    }

    sub rhythmbox {
        buttons('rhythmbox');
        my $data = qx(rhythmbox-client --print-playing --no-start);
        print($data);
    }

    if ($player_arg eq '' or $player_arg =~ /mpd/) {
        mpd;
    }
    elsif ($player_arg =~ /cmus/) {
        cmus;
    }
    elsif ($player_arg =~ /rhythmbox/) {
        rhythmbox;
    }
    else {
        playerctl;
    }

    print("\n");
  '';

  cpu_usage = pkgs.writeShellScriptBin "i4-cpu-usage" ''
    #!/usr/bin/env bash

    SAVE3=/tmp/i3blocks_cpu_usage_4

    declare -A graph=(
      ["12"]="\u28C0" ["13"]="\u28E0" ["14"]="\u28F0" ["15"]="\u28F8"
      ["22"]="\u28C4" ["23"]="\u28E4" ["24"]="\u28F4" ["25"]="\u28FC"
      ["32"]="\u28C6" ["33"]="\u28E6" ["34"]="\u28F6" ["35"]="\u28FE"
      ["42"]="\u28C7" ["43"]="\u28E7" ["44"]="\u28F7" ["45"]="\u28FF"
    )

    if [[ ! -f $SAVE3 ]]; then
      echo 2 1 1 1 > $SAVE3
    fi

    val=($(cat $SAVE3))

    usage=$((10001 - $(mpstat 1 1 | tail -1 | awk '{print $NF}' | tr -d .)))

    if (( usage >= 7501 )); then
      val=(${val[@]:1} 4)
    elif (( usage >= 5001 )); then
      val=(${val[@]:1} 3)
    elif (( usage >= 2501 )); then
      val=(${val[@]:1} 2)
    else
      val=(${val[@]:1} 1)
    fi

    echo -ne "${graph[${val[1]}${val[2]}]}${graph[${val[2]}${val[3]}]}"
    printf "%.3f%%\n" $((usage / 100)).$((usage % 100))

    echo ${val[@]} > $SAVE3
  '';

  cpu_temperature = pkgs.writeShellScriptBin "i4-cpu-temperature" ''
    #!/usr/bin/env bash

    TEMP_DEVICE="${BLOCK_INSTANCE:-Tctl}"

    TEMP=$(sensors | awk -v dev="$TEMP_DEVICE" '
    $2 == dev ":" {
        gsub(/\+|°C/, "", $3)
        print int($3)
        exit
    }')

    if [[ -z "$TEMP" ]]; then
        echo "N/A"
        exit 2
    fi

    echo " ${TEMP}°C"

    if (( TEMP >= 91 )); then
        exit 34
    fi
  '';

  gpu_usage = pkgs.writeShellScriptBin "i4-gpu-usage" ''
    #!/usr/bin/env bash

    SAVE3=/tmp/i3blocks_gpu_usage_4

    declare -A graph=(
      ["12"]="\u28C0" ["13"]="\u28E0" ["14"]="\u28F0" ["15"]="\u28F8"
      ["22"]="\u28C4" ["23"]="\u28E4" ["24"]="\u28F4" ["25"]="\u28FC"
      ["32"]="\u28C6" ["33"]="\u28E6" ["34"]="\u28F6" ["35"]="\u28FE"
      ["42"]="\u28C7" ["43"]="\u28E7" ["44"]="\u28F7" ["45"]="\u28FF"
    )

    if [[ ! -f $SAVE3 ]]; then
      echo "2 1 1 1" > "$SAVE3"
    fi

    read -a val < "$SAVE3"
    [[ ${#val[@]} -ne 4 ]] && val=(2 1 1 1)

    usage=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits 2>/dev/null | awk '{print $1}')

    val=("${val[@]:1}" 1)

    if (( usage >= 76 )); then
      val[3]=4
    elif (( usage >= 51 )); then
      val[3]=3
    elif (( usage >= 26 )); then
      val[3]=2
    else
      val[3]=1
    fi

    echo -ne "${graph[${val[1]}${val[2]}]}${graph[${val[2]}${val[3]}]}"
    printf "%.3f%%\n" "$usage"

    echo "${val[*]}" > "$SAVE3"
  '';

in
{
  home.packages = [
    mediaplayer
    cpu_usage
    cpu_temperature
    gpu_usage
  ];

  home.file.".config/i4blocks/config".text = ''
    [mediaplayer]
    command=~/.config/i4blocks/scripts/mediaplayer
    instance=spotify
    interval=3
    signal=4

    [cpu_usage]
    interval=2
    command=~/.config/i4blocks/scripts/cpu.sh
    min_width=⣾⣄101.00%
    label=CPU

    [cpu_temperature]
    command=~/.config/i4blocks/scripts/temp
    instance=Tctl
    interval=6

    [gpu_usage]
    interval=2
    command=~/.config/i4blocks/scripts/gpu.sh
    label=GPU
    min_width=⣾⣄101.00%
  '';
}
