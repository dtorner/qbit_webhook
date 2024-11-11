# Webhook triggered qbit_manage 

Based off official [qbit_manage](https://github.com/StuffAnThings/qbit_manage) docker images but wrapped in a webhook to trigger it. So you can call it via the start hook in qbittorrent if they're running in different containers.

Based on the webhook pattern from [TheCatLady](https://github.com/TheCatLady/docker-webhook)

An example `/config/hook.json` file to would be 
```
[
  {
    "id": "qbitmanage",
    "execute-command": "/app/qbit_manage.py",
    "command-working-directory": "/app"
  }
]
```

This can be used the same way the qbit_manage image is loaded in a compose. Just swap out the image and add a port section. You will want the commands setup for a "run" `QBT_RUN=true` and not schedule.
```
version: "3.7"
services:
  qbitmanage:
    container_name: qbitmanage
    image: ghcr.io/davidgibbons/qbit_webhook
    ports:
      - 9000:9000
    volumes:
      - /mnt/user/appdata/qbit_manage/:/config:rw
      - /mnt/user/data/torrents/:/data/torrents:rw
      - /mnt/user/appdata/qbittorrent/:/qbittorrent/:ro
    environment:
      - QBT_RUN=true
      - QBT_CONFIG=config.yml
      - QBT_LOGFILE=activity.log
      - QBT_CROSS_SEED=false
      - QBT_RECHECK=false
      - QBT_CAT_UPDATE=false
      - QBT_TAG_UPDATE=false
      - QBT_REM_UNREGISTERED=false
      - QBT_REM_ORPHANED=false
      - QBT_TAG_TRACKER_ERROR=false
      - QBT_TAG_NOHARDLINKS=false
      - QBT_SHARE_LIMITS=false
      - QBT_SKIP_CLEANUP=false
      - QBT_DRY_RUN=false
      - QBT_LOG_LEVEL=INFO
      - QBT_DIVIDER==
      - QBT_WIDTH=100
    restart: on-failure:2

Then make a small wrapper script for qbittorrent to run on start:
```
#!/bin/sh
URL="http://qbitmanage/hooks/qbitmanage"
curl --connect-timeout 5 -X PUT "${URL}" -d '{}'
```
