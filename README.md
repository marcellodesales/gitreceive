# Docker - Gitreceive

Gitreceive https://github.com/progrium/gitreceive

# Running

```
docker run --name gitreceive -d -p 22:22 marcellodesales/gitreceive
```

* The container will expose port 22 (default ssh port) and have a docker volume mounted at /home/git.

> Making port binding to other ports makes it harder to connect to the container.

* Make sure the receiver is correctly setup in your host.

```
docker exec -ti gitreceiver cat /home/git/receiver
```

# Add Keys

To allow someone push to gitreceive, you need to add their public key.

> Make sure to review details at https://github.com/progrium/gitreceive

```
cat ~/.ssh/id_rsa.pub | ssh -i sshkey root@localhost "gitreceive upload-key mdesales"
```

* The ssh keys are provided for convenience. You must create your own in any serious use.*

# Receiving Git changes

* Simply add the server as an origin of a directory with a github repo.

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

* You can now push to the receiver... It will execute the receive script...

```
$ git push paas master
Counting objects: 5, done.
Delta compression using up to 8 threads.
Compressing objects: 100% (5/5), done.
Writing objects: 100% (5/5), 1.21 KiB | 1.21 MiB/s, done.
Total 5 (delta 2), reused 0 (delta 0)


######## Git Receiver - by marcello.desales@gmail.com ##########

==> repository: myapp
==> label: branch 'master'
==> revision: b61ad7b28d0beeee43297278acbede4f01745987
==> username: mdesales
==> fingerprint: 7d:5f:8a:b0:f8:43:9f:a1:b3:91:7f:48:62:27:17:ec

==> Unpacking repo...
-> sshkey
-> gitreceive
-> receiver
-> Dockerfile
-> sshkey.pub
-> README.md

Receiving done...

To localhost:myapp
 * [new branch]      master -> master
```

* I have patched this to allow any branches to be pushed...

```
$ git push paas develop
Counting objects: 20, done.
Delta compression using up to 8 threads.
Compressing objects: 100% (20/20), done.
Writing objects: 100% (20/20), 7.81 KiB | 7.81 MiB/s, done.
Total 20 (delta 7), reused 4 (delta 0)


######## Git Receiver - by marcello.desales@gmail.com ##########

==> repository: myapp
==> label: branch 'develop'
==> revision: 9906a93e67f29316727e071f3b9b602c014ef2fc
==> username: mdesales
==> fingerprint: 7d:5f:8a:b0:f8:43:9f:a1:b3:91:7f:48:62:27:17:ec

==> Unpacking repo...
-> sshkey
-> gitreceive
-> receiver
-> Dockerfile
-> sshkey.pub
-> README.md

Receiving done...

To localhost:myapp
 * [new branch]      develop -> develop
```

* You can see the receiver executing the following:

```
$ docker exec -ti gitreceiver cat /home/git/receiver
```
