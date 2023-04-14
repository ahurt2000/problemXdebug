# Could not connect to host.docker.internal:9003

## The problem: 

With Xdebug on a PHP container that we can't connect to, we see this error:

```
PHP message: Xdebug: [Step Debug] Could not connect to debugging client. Tried: host.docker.internal:9003 (through xdebug.client_host/xdebug.client_port)
```
In all documentation we find that this error is due to a connection problem and that it is usually due to the host or the port. In some cases like this we do not find that it is due to the port.

## Replication

This project simplifies the connection problem from the docker container with Xdebug, to try to fix it. 
.
├── 30-custom.ini
├── docker-compose.yml
├── Dockerfile
└── Readme.md  -> this file

```
#docker -v
Docker version 23.0.3, build 3e7cbfd
#docker compose version
Docker Compose version v2.17.2
```

```
#docker compose build
... 
wait for it to build until FINISHED
```

```
#docker compose up
[+] Running 2/2
 ✔ Network problemxdebug_default       Created                                                                                                                                            0.1s 
 ✔ Container problemxdebug-php-test-1  Created                                                                                                                                            0.1s 
Attaching to problemxdebug-php-test-1
problemxdebug-php-test-1  | [14-Apr-2023 13:14:12] NOTICE: fpm is running, pid 1
problemxdebug-php-test-1  | [14-Apr-2023 13:14:12] NOTICE: ready to handle connections
```
... in another terminal

```
#docker ps
CONTAINER ID   IMAGE                    COMMAND                  CREATED          STATUS          PORTS      NAMES
f41aa385560d   problemxdebug-php-test   "docker-php-entrypoi…"   41 seconds ago   Up 41 seconds   9000/tcp   problemxdebug-php-test-1

```

...

Inside container:  docker exec -it problemxdebug-php-test-1 /bin/bash

```
root@f41aa385560d:/var/www/html# cat /etc/hosts
127.0.0.1	localhost
::1	localhost ip6-localhost ip6-loopback
fe00::0	ip6-localnet
ff00::0	ip6-mcastprefix
ff02::1	ip6-allnodes
ff02::2	ip6-allrouters
172.17.0.1	host.docker.internal
192.168.64.2	f41aa385560d
root@f41aa385560d:/var/www/html# telnet host.docker.internal 9003
Trying 172.17.0.1...
telnet: Unable to connect to remote host: Connection refused
root@f41aa385560d:/var/www/html# lsof -i :9003 -sTCP:LISTEN
root@f41aa385560d:/var/www/html# lsof -i  -sTCP:LISTEN
COMMAND PID USER   FD   TYPE   DEVICE SIZE/OFF NODE NAME
php-fpm   1 root    7u  IPv6 11196820      0t0  TCP *:9000 (LISTEN)
root@f41aa385560d:/var/www/html# php -v
PHP 8.1.2 (cli) (built: Jan 26 2022 16:40:42) (NTS)
Copyright (c) The PHP Group
Zend Engine v4.1.2, Copyright (c) Zend Technologies
    with Xdebug v3.1.3, Copyright (c) 2002-2022, by Derick Rethans
root@f41aa385560d:/var/www/html# 
root@f41aa385560d:/var/www/html# lsof
COMMAND PID     USER   FD      TYPE             DEVICE SIZE/OFF     NODE NAME
php-fpm   1     root  cwd       DIR              259,7     4096  3728388 /var/www/html
php-fpm   1     root  rtd       DIR               0,89     4096  2425044 /
php-fpm   1     root  txt       REG               0,89 18903208  1960349 /usr/local/sbin/php-fpm
php-fpm   1     root  mem       REG               0,89    51696  1939680 /lib/x86_64-linux-gnu/libnss_files-2.31.so
php-fpm   1     root  mem       REG               0,89   363208  1959741 /usr/lib/x86_64-linux-gnu/libsodium.so.23.3.0
php-fpm   1     root  mem       REG               0,89   105760  1960293 /usr/local/lib/php/extensions/no-debug-non-zts-20210902/sodium.so
php-fpm   1     root  mem       REG               0,89   365416  1857542 /usr/local/lib/php/extensions/no-debug-non-zts-20210902/xdebug.so
php-fpm   1     root  mem       REG               0,89    27002  1940319 /usr/lib/x86_64-linux-gnu/gconv/gconv-modules.cache
php-fpm   1     root  mem       REG               0,89   346132  1940050 /usr/lib/locale/C.UTF-8/LC_CTYPE
php-fpm   1     root  mem       REG               0,89    43496  1940342 /usr/lib/x86_64-linux-gnu/libffi.so.7.1.0
php-fpm   1     root  mem       REG               0,89    22448  1939666 /lib/x86_64-linux-gnu/libkeyutils.so.1.9
php-fpm   1     root  mem       REG               0,89   149576  1939664 /lib/x86_64-linux-gnu/libgpg-error.so.0.29.0
php-fpm   1     root  mem       REG               0,89    83968  1940386 /usr/lib/x86_64-linux-gnu/libtasn1.so.6.6.0
php-fpm   1     root  mem       REG               0,89  1257280  1940370 /usr/lib/x86_64-linux-gnu/libp11-kit.so.0.3.0
php-fpm   1     root  mem       REG               0,89   137400  1956695 /usr/lib/x86_64-linux-gnu/libbrotlicommon.so.1.0.9
php-fpm   1     root  mem       REG               0,89   113392  1956779 /usr/lib/x86_64-linux-gnu/libsasl2.so.2.0.25
php-fpm   1     root  mem       REG               0,89    56352  1940360 /usr/lib/x86_64-linux-gnu/libkrb5support.so.0.1
php-fpm   1     root  mem       REG               0,89    18344  1939653 /lib/x86_64-linux-gnu/libcom_err.so.2.1
php-fpm   1     root  mem       REG               0,89   187288  1940356 /usr/lib/x86_64-linux-gnu/libk5crypto.so.3.1
php-fpm   1     root  mem       REG               0,89   888448  1940358 /usr/lib/x86_64-linux-gnu/libkrb5.so.3.3
php-fpm   1     root  mem       REG               0,89  1176248  1940344 /usr/lib/x86_64-linux-gnu/libgcrypt.so.20.2.8
php-fpm   1     root  mem       REG               0,89   525152  1940346 /usr/lib/x86_64-linux-gnu/libgmp.so.10.4.1
php-fpm   1     root  mem       REG               0,89   290416  1940366 /usr/lib/x86_64-linux-gnu/libnettle.so.8.4
php-fpm   1     root  mem       REG               0,89   294832  1940352 /usr/lib/x86_64-linux-gnu/libhogweed.so.6.4
php-fpm   1     root  mem       REG               0,89  2086552  1940348 /usr/lib/x86_64-linux-gnu/libgnutls.so.30.29.1
php-fpm   1     root  mem       REG               0,89  1574952  1940392 /usr/lib/x86_64-linux-gnu/libunistring.so.2.1.0
php-fpm   1     root  mem       REG               0,89   100736  1939662 /lib/x86_64-linux-gnu/libgcc_s.so.1
php-fpm   1     root  mem       REG               0,89  1870824  1940382 /usr/lib/x86_64-linux-gnu/libstdc++.so.6.0.28
php-fpm   1     root  mem       REG               0,89 28407344  1959727 /usr/lib/x86_64-linux-gnu/libicudata.so.67.1
php-fpm   1     root  mem       REG               0,89    51384  1956697 /usr/lib/x86_64-linux-gnu/libbrotlidec.so.1.0.9
php-fpm   1     root  mem       REG               0,89    63672  1956737 /usr/lib/x86_64-linux-gnu/liblber-2.4.so.2.11.5
php-fpm   1     root  mem       REG               0,89   339280  1956740 /usr/lib/x86_64-linux-gnu/libldap_r-2.4.so.2.11.5
php-fpm   1     root  mem       REG               0,89   334616  1940350 /usr/lib/x86_64-linux-gnu/libgssapi_krb5.so.2.2
php-fpm   1     root  mem       REG               0,89    75616  1956767 /usr/lib/x86_64-linux-gnu/libpsl.so.5.3.2
php-fpm   1     root  mem       REG               0,89   211272  1956783 /usr/lib/x86_64-linux-gnu/libssh2.so.1.0.1
php-fpm   1     root  mem       REG               0,89   122280  1956777 /usr/lib/x86_64-linux-gnu/librtmp.so.1
php-fpm   1     root  mem       REG               0,89   128944  1940354 /usr/lib/x86_64-linux-gnu/libidn2.so.0.3.7
php-fpm   1     root  mem       REG               0,89   178640  1956756 /usr/lib/x86_64-linux-gnu/libnghttp2.so.14.20.1
php-fpm   1     root  mem       REG               0,89   149520  1939693 /lib/x86_64-linux-gnu/libpthread-2.31.so
php-fpm   1     root  mem       REG               0,89   158400  1939668 /lib/x86_64-linux-gnu/liblzma.so.5.2.5
php-fpm   1     root  mem       REG               0,89  1988784  1959737 /usr/lib/x86_64-linux-gnu/libicuuc.so.67.1
php-fpm   1     root  mem       REG               0,89   187792  1939706 /lib/x86_64-linux-gnu/libtinfo.so.6.2
php-fpm   1     root  mem       REG               0,89  1839792  1939648 /lib/x86_64-linux-gnu/libc-2.31.so
php-fpm   1     root  mem       REG               0,89    34904  1959725 /usr/lib/x86_64-linux-gnu/libargon2.so.1
php-fpm   1     root  mem       REG               0,89   597088  1959739 /usr/lib/x86_64-linux-gnu/libonig.so.5.1.0
php-fpm   1     root  mem       REG               0,89   632328  2082933 /usr/lib/x86_64-linux-gnu/libcurl.so.4.7.0
php-fpm   1     root  mem       REG               0,89   113088  2044052 /lib/x86_64-linux-gnu/libz.so.1.2.11
php-fpm   1     root  mem       REG               0,89  1318776  1959743 /usr/lib/x86_64-linux-gnu/libsqlite3.so.0.8.6
php-fpm   1     root  mem       REG               0,89  3081088  2044043 /usr/lib/x86_64-linux-gnu/libcrypto.so.1.1
php-fpm   1     root  mem       REG               0,89   597792  2044045 /usr/lib/x86_64-linux-gnu/libssl.so.1.1
php-fpm   1     root  mem       REG               0,89  1750104  2083718 /usr/lib/x86_64-linux-gnu/libxml2.so.2.9.10
php-fpm   1     root  mem       REG               0,89    18688  1939656 /lib/x86_64-linux-gnu/libdl-2.31.so
php-fpm   1     root  mem       REG               0,89  1321344  1939669 /lib/x86_64-linux-gnu/libm-2.31.so
php-fpm   1     root  mem       REG               0,89    14720  1939709 /lib/x86_64-linux-gnu/libutil-2.31.so
php-fpm   1     root  mem       REG               0,89   346312  1959716 /lib/x86_64-linux-gnu/libreadline.so.8.1
php-fpm   1     root  mem       REG               0,89    93000  1939695 /lib/x86_64-linux-gnu/libresolv-2.31.so
php-fpm   1     root  DEL       REG                0,1          11196817 /dev/zero
php-fpm   1     root  mem       REG               0,89   177928  1939636 /lib/x86_64-linux-gnu/ld-2.31.so
php-fpm   1     root    0u      CHR                1,3      0t0        6 /dev/null
php-fpm   1     root    1u      CHR                1,3      0t0        6 /dev/null
php-fpm   1     root    2w     FIFO               0,13      0t0 11192100 pipe
php-fpm   1     root    3w     FIFO               0,13      0t0 11192100 pipe
php-fpm   1     root    4w     FIFO               0,13      0t0 11192100 pipe
php-fpm   1     root    5u     unix 0x0000000000000000      0t0 11196818 type=STREAM
php-fpm   1     root    6u     unix 0x0000000000000000      0t0 11196819 type=STREAM
php-fpm   1     root    7u     IPv6           11196820      0t0      TCP *:9000 (LISTEN)
php-fpm   1     root    8u  a_inode               0,14        0    10331 [eventpoll]
php-fpm   1     root    9r     FIFO               0,13      0t0 11196821 pipe
php-fpm   1     root   10r     FIFO               0,13      0t0 11196823 pipe
php-fpm   1     root   11r     FIFO               0,13      0t0 11196822 pipe
php-fpm   1     root   13r     FIFO               0,13      0t0 11196824 pipe
php-fpm   6 www-data  cwd   unknown                                      /proc/6/cwd (readlink: Permission denied)
php-fpm   6 www-data  rtd   unknown                                      /proc/6/root (readlink: Permission denied)
php-fpm   6 www-data  txt   unknown                                      /proc/6/exe (readlink: Permission denied)
php-fpm   6 www-data    0r  unknown                                      /proc/6/fd/0 (readlink: Permission denied)
php-fpm   6 www-data    1r  unknown                                      /proc/6/fd/1 (readlink: Permission denied)
php-fpm   6 www-data    2r  unknown                                      /proc/6/fd/2 (readlink: Permission denied)
php-fpm   6 www-data    4r  unknown                                      /proc/6/fd/4 (readlink: Permission denied)
php-fpm   6 www-data    9r  unknown                                      /proc/6/fd/9 (readlink: Permission denied)
php-fpm   7 www-data  cwd   unknown                                      /proc/7/cwd (readlink: Permission denied)
php-fpm   7 www-data  rtd   unknown                                      /proc/7/root (readlink: Permission denied)
php-fpm   7 www-data  txt   unknown                                      /proc/7/exe (readlink: Permission denied)
php-fpm   7 www-data    0r  unknown                                      /proc/7/fd/0 (readlink: Permission denied)
php-fpm   7 www-data    1r  unknown                                      /proc/7/fd/1 (readlink: Permission denied)
php-fpm   7 www-data    2r  unknown                                      /proc/7/fd/2 (readlink: Permission denied)
php-fpm   7 www-data    4r  unknown                                      /proc/7/fd/4 (readlink: Permission denied)
php-fpm   7 www-data   10r  unknown                                      /proc/7/fd/10 (readlink: Permission denied)
bash      8     root  cwd       DIR              259,7     4096  3728388 /var/www/html
bash      8     root  rtd       DIR               0,89     4096  2425044 /
bash      8     root  txt       REG               0,89  1234376  1788748 /bin/bash
bash      8     root  mem       REG               0,89    51696  1939680 /lib/x86_64-linux-gnu/libnss_files-2.31.so
bash      8     root  mem       REG               0,89  1839792  1939648 /lib/x86_64-linux-gnu/libc-2.31.so
bash      8     root  mem       REG               0,89    18688  1939656 /lib/x86_64-linux-gnu/libdl-2.31.so
bash      8     root  mem       REG               0,89   187792  1939706 /lib/x86_64-linux-gnu/libtinfo.so.6.2
bash      8     root  mem       REG               0,89   177928  1939636 /lib/x86_64-linux-gnu/ld-2.31.so
bash      8     root    0u      CHR              136,0      0t0        3 /dev/pts/0
bash      8     root    1u      CHR              136,0      0t0        3 /dev/pts/0
bash      8     root    2u      CHR              136,0      0t0        3 /dev/pts/0
bash      8     root  255u      CHR              136,0      0t0        3 /dev/pts/0
lsof     19     root  cwd       DIR              259,7     4096  3728388 /var/www/html
lsof     19     root  rtd       DIR               0,89     4096  2425044 /
lsof     19     root  txt       REG               0,89   171488  2078543 /usr/bin/lsof
lsof     19     root  mem       REG               0,89   149520  1939693 /lib/x86_64-linux-gnu/libpthread-2.31.so
lsof     19     root  mem       REG               0,89    18688  1939656 /lib/x86_64-linux-gnu/libdl-2.31.so
lsof     19     root  mem       REG               0,89   617128  1940372 /usr/lib/x86_64-linux-gnu/libpcre2-8.so.0.10.1
lsof     19     root  mem       REG               0,89  1839792  1939648 /lib/x86_64-linux-gnu/libc-2.31.so
lsof     19     root  mem       REG               0,89   166120  1939699 /lib/x86_64-linux-gnu/libselinux.so.1
lsof     19     root  mem       REG               0,89   177928  1939636 /lib/x86_64-linux-gnu/ld-2.31.so
lsof     19     root    0u      CHR              136,0      0t0        3 /dev/pts/0
lsof     19     root    1u      CHR              136,0      0t0        3 /dev/pts/0
lsof     19     root    2u      CHR              136,0      0t0        3 /dev/pts/0
lsof     19     root    3r      DIR               0,93        0        1 /proc
lsof     19     root    4r      DIR               0,93        0 11206580 /proc/19/fd
lsof     19     root    5w     FIFO               0,13      0t0 11206585 pipe
lsof     19     root    6r     FIFO               0,13      0t0 11206586 pipe
lsof     20     root  cwd       DIR              259,7     4096  3728388 /var/www/html
lsof     20     root  rtd       DIR               0,89     4096  2425044 /
lsof     20     root  txt       REG               0,89   171488  2078543 /usr/bin/lsof
lsof     20     root  mem       REG               0,89   149520  1939693 /lib/x86_64-linux-gnu/libpthread-2.31.so
lsof     20     root  mem       REG               0,89    18688  1939656 /lib/x86_64-linux-gnu/libdl-2.31.so
lsof     20     root  mem       REG               0,89   617128  1940372 /usr/lib/x86_64-linux-gnu/libpcre2-8.so.0.10.1
lsof     20     root  mem       REG               0,89  1839792  1939648 /lib/x86_64-linux-gnu/libc-2.31.so
lsof     20     root  mem       REG               0,89   166120  1939699 /lib/x86_64-linux-gnu/libselinux.so.1
lsof     20     root  mem       REG               0,89   177928  1939636 /lib/x86_64-linux-gnu/ld-2.31.so
lsof     20     root    4r     FIFO               0,13      0t0 11206585 pipe
lsof     20     root    7w     FIFO               0,13      0t0 11206586 pipe
root@f41aa385560d:/var/www/html# php -i | grep -i xdebug
/usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
    with Xdebug v3.1.3, Copyright (c) 2002-2022, by Derick Rethans
xdebug
Support Xdebug on Patreon, GitHub, or as a business: https://xdebug.org/support
             Enabled Features (through 'xdebug.mode' setting)             
xdebug.auto_trace => (setting renamed in Xdebug 3) => (setting renamed in Xdebug 3)
xdebug.cli_color => 0 => 0
xdebug.client_discovery_header => no value => no value
xdebug.client_host => host.docker.internal => host.docker.internal
xdebug.client_port => 9003 => 9003
xdebug.cloud_id => no value => no value
xdebug.collect_assignments => Off => Off
xdebug.collect_includes => (setting removed in Xdebug 3) => (setting removed in Xdebug 3)
xdebug.collect_params => (setting removed in Xdebug 3) => (setting removed in Xdebug 3)
xdebug.collect_return => Off => Off
xdebug.collect_vars => (setting removed in Xdebug 3) => (setting removed in Xdebug 3)
xdebug.connect_timeout_ms => 200 => 200
xdebug.coverage_enable => (setting renamed in Xdebug 3) => (setting renamed in Xdebug 3)
xdebug.default_enable => (setting renamed in Xdebug 3) => (setting renamed in Xdebug 3)
xdebug.discover_client_host => On => On
xdebug.dump.COOKIE => no value => no value
xdebug.dump.ENV => no value => no value
xdebug.dump.FILES => no value => no value
xdebug.dump.GET => no value => no value
xdebug.dump.POST => no value => no value
xdebug.dump.REQUEST => no value => no value
xdebug.dump.SERVER => no value => no value
xdebug.dump.SESSION => no value => no value
xdebug.dump_globals => On => On
xdebug.dump_once => On => On
xdebug.dump_undefined => Off => Off
xdebug.file_link_format => no value => no value
xdebug.filename_format => no value => no value
xdebug.force_display_errors => Off => Off
xdebug.force_error_reporting => 0 => 0
xdebug.gc_stats_enable => (setting renamed in Xdebug 3) => (setting renamed in Xdebug 3)
xdebug.gc_stats_output_dir => (setting renamed in Xdebug 3) => (setting renamed in Xdebug 3)
xdebug.gc_stats_output_name => gcstats.%p => gcstats.%p
xdebug.halt_level => 0 => 0
xdebug.idekey => no value => no value
xdebug.log => no value => no value
xdebug.log_level => 7 => 7
xdebug.max_nesting_level => 256 => 256
xdebug.max_stack_frames => -1 => -1
xdebug.mode => debug,develop => debug,develop
xdebug.output_dir => /tmp/xdebug/ => /tmp/xdebug/
xdebug.overload_var_dump => (setting removed in Xdebug 3) => (setting removed in Xdebug 3)
xdebug.profiler_append => Off => Off
xdebug.profiler_enable => (setting renamed in Xdebug 3) => (setting renamed in Xdebug 3)
xdebug.profiler_enable_trigger => (setting renamed in Xdebug 3) => (setting renamed in Xdebug 3)
xdebug.profiler_enable_trigger_value => (setting renamed in Xdebug 3) => (setting renamed in Xdebug 3)
xdebug.profiler_output_dir => (setting renamed in Xdebug 3) => (setting renamed in Xdebug 3)
xdebug.profiler_output_name => cachegrind.out.%p => cachegrind.out.%p
xdebug.remote_autostart => (setting renamed in Xdebug 3) => (setting renamed in Xdebug 3)
xdebug.remote_connect_back => (setting renamed in Xdebug 3) => (setting renamed in Xdebug 3)
xdebug.remote_enable => (setting renamed in Xdebug 3) => (setting renamed in Xdebug 3)
xdebug.remote_host => (setting renamed in Xdebug 3) => (setting renamed in Xdebug 3)
xdebug.remote_log => (setting renamed in Xdebug 3) => (setting renamed in Xdebug 3)
xdebug.remote_log_level => (setting renamed in Xdebug 3) => (setting renamed in Xdebug 3)
xdebug.remote_mode => (setting renamed in Xdebug 3) => (setting renamed in Xdebug 3)
xdebug.remote_port => (setting renamed in Xdebug 3) => (setting renamed in Xdebug 3)
xdebug.remote_timeout => (setting renamed in Xdebug 3) => (setting renamed in Xdebug 3)
xdebug.scream => Off => Off
xdebug.show_error_trace => Off => Off
xdebug.show_exception_trace => Off => Off
xdebug.show_local_vars => Off => Off
xdebug.show_mem_delta => (setting removed in Xdebug 3) => (setting removed in Xdebug 3)
xdebug.start_upon_error => default => default
xdebug.start_with_request => yes => yes
xdebug.trace_enable_trigger => (setting renamed in Xdebug 3) => (setting renamed in Xdebug 3)
xdebug.trace_enable_trigger_value => (setting renamed in Xdebug 3) => (setting renamed in Xdebug 3)
xdebug.trace_format => 0 => 0
xdebug.trace_options => 0 => 0
xdebug.trace_output_dir => (setting renamed in Xdebug 3) => (setting renamed in Xdebug 3)
xdebug.trace_output_name => trace.%c => trace.%c
xdebug.trigger_value => no value => no value
xdebug.use_compression => 1 => 1
xdebug.var_display_max_children => 128 => 128
xdebug.var_display_max_data => 512 => 512
xdebug.var_display_max_depth => 3 => 3
```

... 

## docker inspect problemxdebug-php-test-1

```JSON
[
    {
        "Id": "f41aa385560d125c68e66e12e424b93571081d2322c1b0accabecb5ce874448a",
        "Created": "2023-04-14T13:14:12.32745305Z",
        "Path": "docker-php-entrypoint",
        "Args": [
            "php-fpm"
        ],
        "State": {
            "Status": "running",
            "Running": true,
            "Paused": false,
            "Restarting": false,
            "OOMKilled": false,
            "Dead": false,
            "Pid": 24987,
            "ExitCode": 0,
            "Error": "",
            "StartedAt": "2023-04-14T13:14:12.808371713Z",
            "FinishedAt": "0001-01-01T00:00:00Z"
        },
        "Image": "sha256:0a8b8c9fc278f8c6a7f2d19406df84c94cba57504c6b56b6d315192db6b61d7f",
        "ResolvConfPath": "/var/lib/docker/containers/f41aa385560d125c68e66e12e424b93571081d2322c1b0accabecb5ce874448a/resolv.conf",
        "HostnamePath": "/var/lib/docker/containers/f41aa385560d125c68e66e12e424b93571081d2322c1b0accabecb5ce874448a/hostname",
        "HostsPath": "/var/lib/docker/containers/f41aa385560d125c68e66e12e424b93571081d2322c1b0accabecb5ce874448a/hosts",
        "LogPath": "/var/lib/docker/containers/f41aa385560d125c68e66e12e424b93571081d2322c1b0accabecb5ce874448a/f41aa385560d125c68e66e12e424b93571081d2322c1b0accabecb5ce874448a-json.log",
        "Name": "/problemxdebug-php-test-1",
        "RestartCount": 0,
        "Driver": "overlay2",
        "Platform": "linux",
        "MountLabel": "",
        "ProcessLabel": "",
        "AppArmorProfile": "docker-default",
        "ExecIDs": null,
        "HostConfig": {
            "Binds": [
                "project_path_hidden/problemXdebug:/var/www/html:rw",
                "project_path_hidden/problemXdebug/30-custom.ini:/usr/local/etc/php/conf.d/30-custom.ini:rw"
            ],
            "ContainerIDFile": "",
            "LogConfig": {
                "Type": "json-file",
                "Config": {}
            },
            "NetworkMode": "problemxdebug_default",
            "PortBindings": {},
            "RestartPolicy": {
                "Name": "",
                "MaximumRetryCount": 0
            },
            "AutoRemove": false,
            "VolumeDriver": "",
            "VolumesFrom": null,
            "ConsoleSize": [
                0,
                0
            ],
            "CapAdd": null,
            "CapDrop": null,
            "CgroupnsMode": "host",
            "Dns": null,
            "DnsOptions": null,
            "DnsSearch": null,
            "ExtraHosts": [
                "host.docker.internal:host-gateway"
            ],
            "GroupAdd": null,
            "IpcMode": "private",
            "Cgroup": "",
            "Links": null,
            "OomScoreAdj": 0,
            "PidMode": "",
            "Privileged": false,
            "PublishAllPorts": false,
            "ReadonlyRootfs": false,
            "SecurityOpt": null,
            "UTSMode": "",
            "UsernsMode": "",
            "ShmSize": 67108864,
            "Runtime": "runc",
            "Isolation": "",
            "CpuShares": 0,
            "Memory": 0,
            "NanoCpus": 0,
            "CgroupParent": "",
            "BlkioWeight": 0,
            "BlkioWeightDevice": null,
            "BlkioDeviceReadBps": null,
            "BlkioDeviceWriteBps": null,
            "BlkioDeviceReadIOps": null,
            "BlkioDeviceWriteIOps": null,
            "CpuPeriod": 0,
            "CpuQuota": 0,
            "CpuRealtimePeriod": 0,
            "CpuRealtimeRuntime": 0,
            "CpusetCpus": "",
            "CpusetMems": "",
            "Devices": null,
            "DeviceCgroupRules": null,
            "DeviceRequests": null,
            "MemoryReservation": 0,
            "MemorySwap": 0,
            "MemorySwappiness": null,
            "OomKillDisable": false,
            "PidsLimit": null,
            "Ulimits": null,
            "CpuCount": 0,
            "CpuPercent": 0,
            "IOMaximumIOps": 0,
            "IOMaximumBandwidth": 0,
            "MaskedPaths": [
                "/proc/asound",
                "/proc/acpi",
                "/proc/kcore",
                "/proc/keys",
                "/proc/latency_stats",
                "/proc/timer_list",
                "/proc/timer_stats",
                "/proc/sched_debug",
                "/proc/scsi",
                "/sys/firmware"
            ],
            "ReadonlyPaths": [
                "/proc/bus",
                "/proc/fs",
                "/proc/irq",
                "/proc/sys",
                "/proc/sysrq-trigger"
            ]
        },
        "GraphDriver": {
            "Data": {
                "LowerDir": "/var/lib/docker/overlay2/d91b94509239e5fc92214a91187a15c4195ac22833566d0a8d2963a83ab5d64e-init/diff:/var/lib/docker/overlay2/6be7qvo8gat3w2rs9nf0vazvu/diff:/var/lib/docker/overlay2/jl9qttwy3l9znx1u8ibksmh6s/diff:/var/lib/docker/overlay2/txlnnuzb2gh101sp77n5f3c2m/diff:/var/lib/docker/overlay2/pgktgrr3p53surzt6hp82cxvu/diff:/var/lib/docker/overlay2/jp1gjrt378j9sv44pn8mfqzwt/diff:/var/lib/docker/overlay2/fknywerod2ndn2jjsdus6h8k5/diff:/var/lib/docker/overlay2/gib6e22yzxwvcdf2q9hknr1vc/diff:/var/lib/docker/overlay2/40fe8d0c2d9a964a8f3a039df30397b28432a7d5c259dadd04890d3f3531c159/diff:/var/lib/docker/overlay2/77363bf8cab2e760e873c8a7053597a7b78e86482df1dd5234bc4eb910f8c4bf/diff:/var/lib/docker/overlay2/2debfce01431c96269519f57e50e9fa13a1de79eb6d4a93ff259f679323c32d9/diff:/var/lib/docker/overlay2/33b408e20078118175f6e037a6b9a49b99212b3d8a8540c522e9653ec563ac99/diff:/var/lib/docker/overlay2/3ea3d6c952944585dc6353597f2cb275ae002006ca842a4fef5109fcfe5ef54b/diff:/var/lib/docker/overlay2/52bbeb73b48541430cd69c96f06a7af5f6516bde70971d99d4a506e4d452d512/diff:/var/lib/docker/overlay2/1e674b3571bd2a63ee65d52769e2c07e7dcc36dc1f5c7796ce54332b9f332caf/diff:/var/lib/docker/overlay2/6b8ce3e5cb40fa9a467a86952c1f4818191ad3d9be2a5d792f1db711c7c45718/diff:/var/lib/docker/overlay2/6ef348514a24f72756cd7af682843620d7f06687af43c459cbb6ffef0f337d61/diff:/var/lib/docker/overlay2/111fbe0374c48c274b8e86bcf2084dc79cc64ac8ed5cb34d64e6bda5712f5e0e/diff",
                "MergedDir": "/var/lib/docker/overlay2/d91b94509239e5fc92214a91187a15c4195ac22833566d0a8d2963a83ab5d64e/merged",
                "UpperDir": "/var/lib/docker/overlay2/d91b94509239e5fc92214a91187a15c4195ac22833566d0a8d2963a83ab5d64e/diff",
                "WorkDir": "/var/lib/docker/overlay2/d91b94509239e5fc92214a91187a15c4195ac22833566d0a8d2963a83ab5d64e/work"
            },
            "Name": "overlay2"
        },
        "Mounts": [
            {
                "Type": "bind",
                "Source": "project_path_hidden/problemXdebug",
                "Destination": "/var/www/html",
                "Mode": "rw",
                "RW": true,
                "Propagation": "rprivate"
            },
            {
                "Type": "bind",
                "Source": "project_path_hidden/problemXdebug/30-custom.ini",
                "Destination": "/usr/local/etc/php/conf.d/30-custom.ini",
                "Mode": "rw",
                "RW": true,
                "Propagation": "rprivate"
            }
        ],
        "Config": {
            "Hostname": "f41aa385560d",
            "Domainname": "",
            "User": "",
            "AttachStdin": false,
            "AttachStdout": true,
            "AttachStderr": true,
            "ExposedPorts": {
                "9000/tcp": {}
            },
            "Tty": false,
            "OpenStdin": false,
            "StdinOnce": false,
            "Env": [
                "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
                "PHPIZE_DEPS=autoconf \t\tdpkg-dev \t\tfile \t\tg++ \t\tgcc \t\tlibc-dev \t\tmake \t\tpkg-config \t\tre2c",
                "PHP_INI_DIR=/usr/local/etc/php",
                "PHP_CFLAGS=-fstack-protector-strong -fpic -fpie -O2 -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64",
                "PHP_CPPFLAGS=-fstack-protector-strong -fpic -fpie -O2 -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64",
                "PHP_LDFLAGS=-Wl,-O1 -pie",
                "GPG_KEYS=528995BFEDFBA7191D46839EF9BA0ADA31CBD89E 39B641343D8C104B2B146DC3F9C39DC0B9698544 F1F692238FBC1666E5A5CCD4199F9DFEF6FFBAFD",
                "PHP_VERSION=8.1.2",
                "PHP_URL=https://www.php.net/distributions/php-8.1.2.tar.xz",
                "PHP_ASC_URL=https://www.php.net/distributions/php-8.1.2.tar.xz.asc",
                "PHP_SHA256=6b448242fd360c1a9f265b7263abf3da25d28f2b2b0f5465533b69be51a391dd"
            ],
            "Cmd": [
                "php-fpm"
            ],
            "Image": "problemxdebug-php-test",
            "Volumes": null,
            "WorkingDir": "/var/www/html",
            "Entrypoint": [
                "docker-php-entrypoint"
            ],
            "OnBuild": null,
            "Labels": {
                "com.docker.compose.config-hash": "7f8d773d9699bdb47e10a36556c590f8f449abc4d358a995ce8ed924936ecd85",
                "com.docker.compose.container-number": "1",
                "com.docker.compose.depends_on": "",
                "com.docker.compose.image": "sha256:0a8b8c9fc278f8c6a7f2d19406df84c94cba57504c6b56b6d315192db6b61d7f",
                "com.docker.compose.oneoff": "False",
                "com.docker.compose.project": "problemxdebug",
                "com.docker.compose.project.config_files": "project_path_hidden/problemXdebug/docker-compose.yml",
                "com.docker.compose.project.working_dir": "project_path_hidden/problemXdebug",
                "com.docker.compose.service": "php-test",
                "com.docker.compose.version": "2.17.2"
            },
            "StopSignal": "SIGQUIT"
        },
        "NetworkSettings": {
            "Bridge": "",
            "SandboxID": "6a5c2a3a194fd8b52685cb72d4148cc697922de3b6a75f80f99171e0c8e74a48",
            "HairpinMode": false,
            "LinkLocalIPv6Address": "",
            "LinkLocalIPv6PrefixLen": 0,
            "Ports": {
                "9000/tcp": null
            },
            "SandboxKey": "/var/run/docker/netns/6a5c2a3a194f",
            "SecondaryIPAddresses": null,
            "SecondaryIPv6Addresses": null,
            "EndpointID": "",
            "Gateway": "",
            "GlobalIPv6Address": "",
            "GlobalIPv6PrefixLen": 0,
            "IPAddress": "",
            "IPPrefixLen": 0,
            "IPv6Gateway": "",
            "MacAddress": "",
            "Networks": {
                "problemxdebug_default": {
                    "IPAMConfig": null,
                    "Links": null,
                    "Aliases": [
                        "problemxdebug-php-test-1",
                        "php-test",
                        "f41aa385560d"
                    ],
                    "NetworkID": "ca11d6ecef778c35505343e8adcceb1535f44c4efd085c6a18e4a59c120ed56e",
                    "EndpointID": "4ee2a6fc0905c509d08d3e177cae3a6e55fe2947396df6f62ef82cc1dc40a341",
                    "Gateway": "192.168.64.1",
                    "IPAddress": "192.168.64.2",
                    "IPPrefixLen": 20,
                    "IPv6Gateway": "",
                    "GlobalIPv6Address": "",
                    "GlobalIPv6PrefixLen": 0,
                    "MacAddress": "02:42:c0:a8:40:02",
                    "DriverOpts": null
                }
            }
        }
    }
]
```

...

docker network inspect testconection_default 

```JSON
[
    {
        "Name": "problemxdebug_default",
        "Id": "ca11d6ecef778c35505343e8adcceb1535f44c4efd085c6a18e4a59c120ed56e",
        "Created": "2023-04-14T15:14:12.267389649+02:00",
        "Scope": "local",
        "Driver": "bridge",
        "EnableIPv6": false,
        "IPAM": {
            "Driver": "default",
            "Options": null,
            "Config": [
                {
                    "Subnet": "192.168.64.0/20",
                    "Gateway": "192.168.64.1"
                }
            ]
        },
        "Internal": false,
        "Attachable": false,
        "Ingress": false,
        "ConfigFrom": {
            "Network": ""
        },
        "ConfigOnly": false,
        "Containers": {
            "f41aa385560d125c68e66e12e424b93571081d2322c1b0accabecb5ce874448a": {
                "Name": "problemxdebug-php-test-1",
                "EndpointID": "4ee2a6fc0905c509d08d3e177cae3a6e55fe2947396df6f62ef82cc1dc40a341",
                "MacAddress": "02:42:c0:a8:40:02",
                "IPv4Address": "192.168.64.2/20",
                "IPv6Address": ""
            }
        },
        "Options": {},
        "Labels": {
            "com.docker.compose.network": "default",
            "com.docker.compose.project": "problemxdebug",
            "com.docker.compose.version": "2.17.2"
        }
    }
]
```
