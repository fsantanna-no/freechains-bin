- Install additional packages:

```
$ sudo apt install ssmtp
```

- Execute on startup:

```
$ ./start-sync-XX.sh &      # manually
$ crontab -e                # automatically
@reboot /XXX/freechains/bin/start-sync-XX.sh
```

- Execute once:

```
$ ./setup-post.sh
```
