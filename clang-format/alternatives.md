
# Notes on how to install alternatives for clang-format

examples given for versions 10.1 and 6.0

```
sudo update-alternatives                                                                                                           \
    --install /usr/bin/clang-format                      clang-format           /usr/bin/clang-format-6.0                      60  \
    --slave   /usr/bin/clang-format-diff                 clang-format-diff      /usr/bin/clang-format-diff-6.0                     \
    --slave   /usr/share/man/man1/clang-format.1.gz      clang-format.1.gz      /usr/share/man/man1/clang-format-6.0.1.gz          \
    --slave   /usr/share/man/man1/clang-format-diff.1.gz clang-format-diff.1.gz /usr/share/man/man1/clang-format-diff-6.0.1.gz


sudo update-alternatives                                                                                                           \
    --install /usr/bin/clang-format                      clang-format           /usr/bin/clang-format-10                       100 \
    --slave   /usr/bin/clang-format-diff                 clang-format-diff      /usr/bin/clang-format-diff-10                      \
    --slave   /usr/share/man/man1/clang-format.1.gz      clang-format.1.gz      /usr/share/man/man1/clang-format-10.1.gz           \
    --slave   /usr/share/man/man1/clang-format-diff.1.gz clang-format-diff.1.gz /usr/share/man/man1/clang-format-diff-10.1.gz    
```    

