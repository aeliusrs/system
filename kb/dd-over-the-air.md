

# ON RECEIVING MACHINES

on each machines run:
```bash
nc -l 8888 | dd of=/path/to/disk
```


# ON TRANSMITING MACHINES

on the source machine:
```bash

# for 1
dd if=/path/to/iso | nc <ip-node> <port>

# for 3
dd if=/path/to/iso | tee >(nc <ip-node1> <port>) >(nc <ip-node2> <port>) | nc <ip-node3> <port>
```

from compress image:
```bash
cat img.xz | xz -d | tee >(nc <ip-node1> <port>) >(nc <ip-node2> <port>) | nc <ip-node3> <port>
```

