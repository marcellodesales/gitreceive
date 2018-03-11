# Docker - Gitreceive

Gitreceive https://github.com/progrium/gitreceive

# Build the image and run it as follows

```
docker build -t gitreceive .
docker run --name gitreceive -d -p 22:22 gitreceive
```

* The container will expose port 22 (default ssh port) and have a docker volume mounted at /home/git.
* Make sure the receiver is correct

```
docker exec -ti gitreceiver cat /home/git/receiver
```

# Add Users

To allow someone push to gitreceive, you need to add their public key.

`cat ~/.ssh/id_rsa.pub | ssh -i sshkey root@localhost "gitreceive upload-key mdesales"`

* The ssh keys are provided for convenience. You must create your own in any serious use.*

# Add Repo

Simply add a git repo and push

```
$ git remote add paas git@localhost:myapp

$ git remote show paas
* remote paas
  Fetch URL: git@localhost:myapp
  Push  URL: git@localhost:myapp
  HEAD branch: master
  Remote branch:
    master tracked
  Local ref configured for 'git push':
    master pushes to master (up to date)
```

You can now push to the receiver... It will execute the receive script...

```
$ git push paas master
Counting objects: 12, done.
Delta compression using up to 8 threads.
Compressing objects: 100% (12/12), done.
Writing objects: 100% (12/12), 6.56 KiB | 6.56 MiB/s, done.
Total 12 (delta 2), reused 4 (delta 0)
----> Posting to http://requestb.in/rlh4znrl ...
Receiving a push..
==> repository: myapp
==> revision: d1e5127f2a1822bfc2b6d93739634f64351c3be2
==> username: mdesales
==> fingerprint: 7d:5f:8a:b0:f8:43:9f:a1:b3:91:7f:48:62:27:17:ec

To localhost:myapp
 * [new branch]      master -> master
```

* I have patched this to allow any branches to be pushed...

```$ git push paas develop
Total 0 (delta 0), reused 0 (delta 0)
Receiving a push..
==> repository: myapp
==> revision: 9906a93e67f29316727e071f3b9b602c014ef2fc
==> username: mdesales
==> fingerprint: 7d:5f:8a:b0:f8:43:9f:a1:b3:91:7f:48:62:27:17:ec

----> Unpacking repo...
To localhost:myapp
 * [new branch]      develop -> develop
```

You can see the receiver executing the following:

```
$ docker exec -ti gitreceiver cat /home/git/receiver
#!/bin/bash
echo ""
echo "######## Git Receiver - by marcello.desales@gmail.com ##########"
echo ""
echo "==> repository: $1"
echo "==> revision: $2"
echo "==> username: $3"
echo "==> fingerprint: $4"
echo ""
echo "==> Unpacking repo..."
mkdir -p /tmp/build/$1 && cat | tar -x -C /tmp/build/$1
echo ""
for i in $(ls -R /tmp/build/$1/); do echo "-> $i"; done
echo ""
echo "Receiving done..."
echo ""
```
