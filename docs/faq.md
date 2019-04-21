# FAQ

* *macOS keeps asking my ssh passphrase since I updated to Sierra*
* see [this](https://superuser.com/questions/1127067/macos-keeps-asking-my-ssh-passphrase-since-i-updated-to-sierra)
which essentially says create the file ```~/.ssh/config``` with the following
content and after entering the passphrase once you won't be asked again
```
Host *
    UseKeychain yes
```
