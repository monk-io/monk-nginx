Nginx meet Monk
===

This repository contains Monk.io template to deploy Nginx either locally or on cloud of your choice (AWS, GCP, Azure, Digital Ocean).  

This template contains two runnable definitions:
* `nginx/basic` - which is standard nginx configuration that runs on port 80
* `nginx/ssl` - spawns with a certbot as a sidecar container and will automatically generate Letsencrypt certificate.



## Prerequisites
- [Install Monk](https://docs.monk.io/docs/get-monk)
- [Register and Login Monk](https://docs.monk.io/docs/acc-and-auth)
- [Add Cloud Provider](https://docs.monk.io/docs/cloud-provider)
- [Add Instance](https://docs.monk.io/docs/multi-cloud)

### Make sure monkd is running.

``` bash
$ monk status
daemon: ready
auth: logged in
not connected to cluster
```

### Clone Repository

``` bash
$ git clone git@github.com:CuteAnonymousPanda/monk-nginx.git
```

### Load Template

``` bash
$ cd monk-nginx
$ monk load manifest.yaml
```

### Verify if it's loaded correctly

``` bash
$ monk list -l nginx

✔ Got the list
Type      Template     Repository  Version  Tags                            
runnable  nginx/basic  local       -        nginx, webserver, ssl, certbot  
runnable  nginx/ssl    local       -        nginx, webserver, ssl, certbot  
```

## Deploy basic Nginx

### Start runnable

``` bash
$ monk run nginx/basic
? Runnable local/nginx/basic
? Select tag to run [local/nginx/basic] on: aws
✔ Starting the job: local/nginx/basic... DONE
✔ Preparing nodes DONE
✔ Checking/pulling images...
✔ [================================================] 100% nginx:latest set0
✔ Checking/pulling images DONE
✔ Started local/nginx/basic

🔩 templates/local/nginx/basic
 └─🧊 Peer set0
    └─🔩 templates/local/nginx/basic 
       └─📦 28e821a236957d6d861141ea33f435a6-local-nginx-basic-nginx 
          ├─🧩 nginx:latest
          └─🔌 open 54.211.27.40:80 -> 80

💡 You can inspect and manage your above stack with these commands:
        monk logs (-f) local/nginx/basic - Inspect logs
        monk shell     local/nginx/basic - Connect to the container's shell
        monk do        local/nginx/basic/action_name - Run defined action (if exists)
💡 Check monk help for more!
```

### Check if it works

``` bash
$ curl 54.211.27.40:80
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx running on monk!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to nginx running on monk!</h1>
<p>If you see this page, the nginx web server is successfully installed andworking. Further configuration is required.</p>

<p>For online documentation and support please refer to <a href="http://nginx.org/">nginx.org</a><br/> and <a href="http://monk.io/">monk.io</a>.</p>

<p><em>Thank you for using nginx and monk.io.</em></p>
<p style="text-align:center"><img style="transform-origin: top left; transform: scale(2);" src="https://monk.io/_nuxt/img/header_call_logo.472c7d5.svg"></p>
<p style="text-align:center"><img src="https://www.nginx.com/wp-content/uploads/2021/08/NGINX-Part-of-F5-horiz-black-type-1.svg"></p>
</body>
</html>%
```

## Deploy Nginx with certbot and ssl certificates

### Start runnable 

``` bash
$ monk run nginx/ssl
? Select tag to run [local/nginx/ssl] on: aws
✔ Starting the job: local/nginx/ssl... DONE
✔ Preparing nodes DONE
✔ Checking/pulling images...
✔ [================================================] 100% nginx:latest set0
✔ [================================================] 100% certbot/certbot:latest set0
✔ Checking/pulling images DONE
✔ Started local/nginx/ssl

🔩 templates/local/nginx/ssl
 └─🧊 Peer set0
    ├─🔩 templates/local/nginx/ssl 
    │  └─📦 7da29d64a1dabb17c4d2184aa5a0ff61-local-nginx-ssl-nginx 
    │     ├─🧩 nginx:latest                                   
    │     ├─💾 /var/lib/monkd/volumes/certbot/conf -> /etc/letsencrypt
    │     ├─💾 /var/lib/monkd/volumes/certbot/www -> /var/certbot
    │     ├─🔌 open 54.211.27.40:443 -> 443        
    │     └─🔌 open 54.211.27.40:80 -> 80          
    └─🔩 templates/local/nginx/ssl 
       └─📦 40a7805b372e2f60135c2c4bd2ec5b3f-local-nginx-ssl-certbot 
          ├─🧩 certbot/certbot:latest                         
          ├─💾 /var/lib/monkd/volumes/certbot/conf -> /etc/letsencrypt
          └─💾 /var/lib/monkd/volumes/certbot/www -> /var/certbot

💡 You can inspect and manage your above stack with these commands:
        monk logs (-f) local/nginx/ssl - Inspect logs
        monk shell     local/nginx/ssl - Connect to the container's shell
        monk do        local/nginx/ssl/action_name - Run defined action (if exists)
💡 Check monk help for more!
```

### Check the logs

``` bash
$ monk logs 
? Select container: 40a7805b372e2f60135c2c4bd2ec5b3f-local-nginx-ssl-certbot
Tue Aug 30 18:53:41 UTC 2022 Waiting for nginx to start
...
Tue Aug 30 18:53:53 UTC 2022 Waiting for nginx to start
Saving debug log to /var/log/letsencrypt/letsencrypt.log
Plugins selected: Authenticator webroot, Installer None
Account registered.
Requesting a certificate for domain.com
Performing the following challenges:
http-01 challenge for domain.com
Using the webroot path /var/certbot for all unmatched domains.
Waiting for verification...
Cleaning up challenges

Successfully received certificate.
Certificate is saved at: /etc/letsencrypt/live/domain.com/fullchain.pem
Key is saved at:         /etc/letsencrypt/live/domain.com/privkey.pem
This certificate expires on 2022-11-28.
These files will be updated when the certificate renews.
NEXT STEPS:
- The certificate will need to be renewed before it expires. Certbot can automatically renew the certificate in the background, but you may need to take steps to enable that functionality. See https://certbot.org/renewal-setup for instructions.

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
If you like Certbot, please consider supporting our work by:
 * Donating to ISRG / Let's Encrypt:   https://letsencrypt.org/donate
 * Donating to EFF:                    https://eff.org/donate-le
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
```

``` bash
$ monk logs
? Select container: 7da29d64a1dabb17c4d2184aa5a0ff61-local-nginx-ssl-nginx
/docker-entrypoint.sh: /docker-entrypoint.d/ is not empty, will attempt to perform configuration
/docker-entrypoint.sh: Looking for shell scripts in /docker-entrypoint.d/
/docker-entrypoint.sh: Launching /docker-entrypoint.d/10-listen-on-ipv6-by-default.sh
10-listen-on-ipv6-by-default.sh: info: Getting the checksum of /etc/nginx/conf.d/default.conf
10-listen-on-ipv6-by-default.sh: info: Enabled listen on IPv6 in /etc/nginx/conf.d/default.conf
/docker-entrypoint.sh: Launching /docker-entrypoint.d/20-envsubst-on-templates.sh
/docker-entrypoint.sh: Launching /docker-entrypoint.d/30-tune-worker-processes.sh
/docker-entrypoint.sh: Launching /docker-entrypoint.d/99-init-config.sh
Tue Aug 30 18:53:47 UTC 2022 Installing procps
Tue Aug 30 18:53:53 UTC 2022 Using certbot
2022/08/30 18:53:53 [notice] 366#366: using the "epoll" event method
2022/08/30 18:53:53 [notice] 366#366: nginx/1.23.1
Tue Aug 30 18:53:53 UTC 2022 Starting temporary nginx server
...
23.178.112.202 - - [30/Aug/2022:18:53:55 +0000] "GET /.well-known/acme-challenge/zq-hfYxAzeW7g9LGo3uCkbRaqjnDHkMYtVoyaGg24QQ HTTP/1.1" 200 87 "-" "Mozilla/5.0 (compatible; Let's Encrypt validation server; +https://www.letsencrypt.org)" "-"
2022/08/30 18:53:53 [notice] 366#366: start worker process 369
52.14.101.40 - - [30/Aug/2022:18:53:55 +0000] "GET /.well-known/acme-challenge/zq-hfYxAzeW7g9LGo3uCkbRaqjnDHkMYtVoyaGg24QQ HTTP/1.1" 200 87 "-" "Mozilla/5.0 (compatible; Let's Encrypt validation server; +https://www.letsencrypt.org)" "-"
35.158.160.203 - - [30/Aug/2022:18:53:55 +0000] "GET /.well-known/acme-challenge/zq-hfYxAzeW7g9LGo3uCkbRaqjnDHkMYtVoyaGg24QQ HTTP/1.1" 200 87 "-" "Mozilla/5.0 (compatible; Let's Encrypt validation server; +https://www.letsencrypt.org)" "-"
54.245.145.33 - - [30/Aug/2022:18:53:55 +0000] "GET /.well-known/acme-challenge/zq-hfYxAzeW7g9LGo3uCkbRaqjnDHkMYtVoyaGg24QQ HTTP/1.1" 200 87 "-" "Mozilla/5.0 (compatible; Let's Encrypt validation server; +https://www.letsencrypt.org)" "-"
Tue Aug 30 18:53:59 UTC 2022 Detected certificate killing temporary webserver
2022/08/30 18:53:59 [emerg] 378#378: bind() to 0.0.0.0:80 failed (98: Address already in use)
...
Tue Aug 30 18:53:59 UTC 2022 Starting webserver
2022/08/30 18:53:59 [notice] 378#378: nginx/1.23.1
2022/08/30 18:53:59 [notice] 378#378: built by gcc 10.2.1 20210110 (Debian 10.2.1-6) 
2022/08/30 18:53:59 [notice] 378#378: OS: Linux 5.15.0-1004-aws
2022/08/30 18:53:59 [notice] 378#378: getrlimit(RLIMIT_NOFILE): 1048576:1048576
2022/08/30 18:53:59 [notice] 378#378: start worker processes
2022/08/30 18:53:59 [notice] 378#378: start worker process 380
2022/08/30 18:53:59 [notice] 378#378: start worker process 381
54.242.129.61 - - [30/Aug/2022:18:54:05 +0000] "GET /.git/config HTTP/1.1" 404 555 "-" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/97.0.4692.71 Safari/537.36" "-"
2022/08/30 18:54:05 [error] 380#380: *2 open() "/usr/share/nginx/html/.git/config" failed (2: No such file or directory), client: 54.242.129.3
...
```

### Check the connectivity

``` bash
$ curl https://domain.com
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx running on monk!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to nginx running on monk!</h1>
<p>If you see this page, the nginx web server is successfully installed andworking. Further configuration is required.</p>

<p>For online documentation and support please refer to <a href="http://nginx.org/">nginx.org</a><br/> and <a href="http://monk.io/">monk.io</a>.</p>

<p><em>Thank you for using nginx and monk.io.</em></p>
<p style="text-align:center"><img style="transform-origin: top left; transform: scale(2);" src="https://monk.io/_nuxt/img/header_call_logo.472c7d5.svg"></p>
<p style="text-align:center"><img src="https://www.nginx.com/wp-content/uploads/2021/08/NGINX-Part-of-F5-horiz-black-type-1.svg"></p>
</body>
</html>
```
## Variables

The variables are stored in `manifest.yaml` file.  
You can quickly setup by editing the values there.

| Variable       | Description                                                   | Default                               |
|----------------|---------------------------------------------------------------|---------------------------------------|
| email          | Email where the Letsencrypt notifications will be send to     | do-not-reply@domain.com               |
| domain         | Domain that the certificate needs to be requested for         | domain.com                            |
| use-certbot    | Whether we should use a certbot                               | true                                  |
| nginx-hostname | Internal variable to determine dns address of nginx container | <- get-hostname("nginx/ssl", "nginx") |

## Stop, remove and clean up workloads and templates

``` bash
$ monk stop     nginx/basic
$ monk purge    nginx/basic
$ monk purge -x nginx/basic
```

``` bash
$ monk stop     nginx/ssl
$ monk purge    nginx/ssl
$ monk purge -x nginx/ssl
```
