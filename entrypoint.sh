#!/bin/bash

MaxServerPlayers="${MaxServerPlayers:-6}"
Port="${Port:-7777}"
QueryPort="${QueryPort:-27015}"
ServerPassword="${ServerPassword:-password}"
SteamServerName="${SteamServerName:-HappyCupServer}"
WorldSaveName="${WorldSaveName:-Cascade}"
AdditionalArgs="${AdditionalArgs:-}"
AutoUpdate="${AutoUpdate:-true}"

AbioticDir="/app/AbioticFactor"

SaveDir="$AbioticDir/Saved"
echo "Checking for save directory at $SaveDir"
if [ ! -e "$SaveDir" ]; then
    echo "Save directory not found, creating one"
    mkdir -p "$AbioticDir" || {
        echo "Failed to create server directory"
        exit 1
    }
    ln -s /data "$SaveDir" || {
        echo "Failed to create save directory"
        exit 1
    }
    echo "Save directory created"
else
    echo "Save directory already exists"
fi

app_update() {
    /usr/games/steamcmd \
        +@sSteamCmdForcePlatformType windows \
        +force_install_dir /app \
        +login anonymous \
        +app_update 2857200 validate \
        +quit
}

ServerExecutable="$AbioticDir/Binaries/Win64/AbioticFactorServer-Win64-Shipping.exe"
echo "Checking for server executable at $ServerExecutable"
if [ ! -f "$ServerExecutable" ]; then
    echo "Server executable not found, downloading"
    app_update
    echo "Server download complete"
elif [[ $AutoUpdate == "true" ]]; then
    echo "Checking for server updates"
    app_update
    echo "Server update complete"
fi

/usr/lib/wine/wine64 "$ServerExecutable" \
    -useperfthreads \
    -NoAsyncLoadingThread \
    -MaxServerPlayers="$MaxServerPlayers" \
    -PORT="$Port" \
    -QueryPort="$QueryPort" \
    -ServerPassword="$ServerPassword" \
    -SteamServerName="$SteamServerName" \
    -WorldSaveName="$WorldSaveName" \
    -tcp \
    $AdditionalArgs
