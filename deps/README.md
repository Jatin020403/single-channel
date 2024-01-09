# Offline install

1. For Docker Images

- Make tar for each image:

```sh
docker save -o fabric-orderer.tar hyperledger/fabric-orderer:latest
```

- Extract a image from a folder:

```sh
docker load -i fabric-orderer.tar
```

- Or extract all together from a folder:

```sh
for file in *.tar; do
docker load -i $file
done
```

2. For go dependencies,

- place vendor file in the same directory as go.sum. Run without presetup
