# Wolfenstein: Enemy Territory Docker Server
Docker Image for a dedicated Wolfenstein: Enemy Territory server with ETTV and ETPro.



## Usage

The fastest way to set this up is to pull the image and start it via `docker run`.

``` bash
docker pull archont94/enemy-territory
```

``` bash
docker run --name et-server -p 27960:27960/udp -p 27960:27960 archont94/enemy-territory:latest
```

In order to edit config files, log inside container with `docker exec -it CONTAINER_ID bash`. After that you can run `nano` editor and modify files.

## Available environment variables

| Variable   | Value    |
| ---------- | -------- |
| PORT       | 27960    |
| MAXPLAYERS | 32       |
| PUNKBUSTER | 1        |

## Custom config files

You can add you own `server.cfg` (or any other file) by linking them as volumes into the image.

``` bash
-v /path/to/your/server.cfg:/et/etpro/server.cfg
```

The complete command looks like this:

``` bash
docker run --name et-server -p 27960:27960/udp -p 27960:27960 -v /path/to/your/server.cfg:/et/etpro/server.cfg archont94/enemy-territory:latest
```

### Example server.cfg

```
//=========================Server Passwords======================//
set g_password "mypassword"             // set to password protect the server 
set sv_privateclients "0"     // if set > 0, then this number of client slots will be reserved for connections 
set sv_privatepassword ""     // that have "password" set to the value of "sv_privatePassword" 
set rconpassword "myrcon"  // remote console access password 
set refereePassword "myreferee"  // referee status password 
set b_shoutcastpassword "myshoutcast" // Shoutcast login

//=============================DL, RATE==========================//
set sv_maxRate "25000"
set sv_dl_maxRate "2048000"
set sv_allowDownload "1"
set sv_wwwDownload "1"
set sv_wwwBaseURL "https://www.gamestv.org/download/repository/et/"
set sv_wwwDlDisconnected "0"
set sv_wwwFallbackURL ""

//=============================MOD, ECT==========================// 
set sv_hostname  "My Server Name"              // name of server here 
set server_motd0 " "              // message in right corner of join screen here 
set server_motd1 " " 
set server_motd2 " "
set server_motd3 " "
set server_motd4 " "
set server_motd5 " "

//==========================MASTER SERVERS==========================//
// The master servers are unset, which means your server will not appear on the list
// This is to avoid DDoS attacks, delete the next 5 lines if you want your server to reappear on the list

set sv_master1 ""
set sv_master2 ""
set sv_master3 ""
set sv_master4 ""
set sv_master5 ""

//=========================STARTUP======================//
map radar
wait 300
config global3
wait 150
config global3

//=========================LOG SETTINGS======================//
set g_log "etserver.log"
set g_logsync 0
set logfile 0

//============================ETTV===========================//
set ettv_sv_maxslaves "2"
set ettv_password "3ttv"
set b_ettv_flags "3"

// Maximum number of clients per IP address
set ip_max_clients 2
```

## Additional maps

In order to install additional maps, you need to put them inside /et/etmain folder.

In order to copy files to docker you can use `docker cp` command:

``` bash
docker cp MAP_DIRECTORY CONTAINER_ID:/et/etmain
```

Be careful to not overwrite other files. Before any changes, you can always use `docker commit` command to create image with your changes, which you can restore easily later.
