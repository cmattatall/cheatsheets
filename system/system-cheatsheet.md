
## Examples of using update-alternatives

### Create symbolic link called cmake in /usr/bin that points to /usr/local/cmake/cmake-3.16/bin/cmake and is part of the cmake link group
					
```
$ sudo update-alternatives --install          \
	/usr/bin/cmake 	                      \
	cmake                                 \
	/usr/local/cmake/cmake-3.16/bin/cmake \
	316
```

### Create symbolic link with a child alternative that changes when the main alternative does

```
$ sudo update-alternatives                          \
  --install /usr/bin/gcc gcc /usr/local/bin/gcc-7 7 \
  --slave   /usr/bin/g++ g++ /usr/local/bin/g++-7   
```

