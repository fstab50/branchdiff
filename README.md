<a name="top"></a>
* * *
# branchdiff
* * *

## About this repository

* Purpose: 		Access advanced git functionality without commands for instant visibility into the status of your working branch
* Version:	     1.1.12
* Repo: 		https://github.com/fstab50/branchdiff


* * *
## Contents

* [**SUMMARY**](#summary)

* [**SUPPORTED LINUX DISTRIBUTIONS**](#supported-linux-distributions)

* [**INSTALLATION**](#installation)
    * [Ubuntu, Linux Mint, Debian-based Distributions](#installation)
    * [Redhat, CentOS, Fedora, Amazon Linux](#redhat-distro-install)

* [**UPGRADING**](#upgrading)

* [**OPTIONS**](#options)

* [**SCREENSHOTS**](#screenshots)
    * [Working Branch Status](#screenshots)
    * [Working Branch Status (Extended)](#screenshots1)
    * [Commit Log History (--commit-log history)](#screenshots2)
    * [Comit Log Detail (--commit-log detail)](#screenshots3)
    * [Code Diff (--code)](#screenshots4)
    * [Code Diff (--code <filename\>)](#screenshots5)

* [**AUTHOR & COPYRIGHT**](#authorcopyright)

* [**LICENSE**](#license)

* [**DISCLAIMER**](#disclaimer)

--

[back to the top](#top)

* * *
## Summary

[branchdiff](https://github.com/fstab50/branchdiff) is a utility for use with git version control.  The program:

* Instantly see differences between current working branch and any other branch
* Access advanced git functionality without any code or typing syntax
* Graphical view of when commits were made to the current branch, by whom
* Graphical merge maps

[![branchdiff default view](./assets/intro_sm.png)](http://images.awspros.world/branchdiff/intro_lg.png)


[back to the top](#top)

* * *
## Supported Linux Distributions

* Ubuntu 18.04, 20.04, 20.10, 22.04
* Linux Mint 18, 19, 20, 21
* Debian variants of Ubuntu / Linux Mint distributions above
* Redhat 7,8+
* CentOS 7, 8+

[back to the top](#top)

* * *
## Installation
* * *

### Ubuntu, Linux Mint, Debian variants

The easiest way to install **branchdiff** is via the Debian-tools repository:

1. Download the public key:

    ```
    $ wget -qO - http://awscloud.center/keys/public.key | sudo apt-key add -
    ```

2. Install the repository:

    ```
    $ sudo echo "deb [arch=amd64] http://deb.awscloud.center <distribution> main" > \
                 /etc/apt/sources.list.d/debian-tools.list
    ```

    **Where:** `<distribution>` is one of the following:

    - `trusty`:  Ubuntu 14.04, Ubuntu 14.04 based Linux distributions
    - `xenial`:  Ubuntu 16.04, 16.04 based Linux distributions
    - `bionic`:  Ubuntu 18.04, 18.04 based Linux distributions ([Linux Mint 19](https://www.linuxmint.com/download.php), etc)
    - `cosmic`:  Ubuntu 18.10, 18.10 based Linux distributions

3. Verify **debian-tools** repository installation

    ```
    $  grep ^ /etc/apt/sources.list /etc/apt/sources.list.d/*
    ```

    [![repository-contents](./assets/repo-install-verify.png)](http://images.awspros.world/branchdiff/repo-install-verify.png)

4. Update and install the package:

    ```
    $ sudo apt update  &&  sudo apt install branchdiff
    ```

5. Verify Installation.  To verify a Debian (.deb) package installation:

    ```
    $ apt show branchdiff
    ```

    ![apt](./assets/apt-show.png)

[back to the top](#top)

* * *
<a name="redhat-distro-install"></a>
### Redhat, CentOS, Fedora, Amazon Linux
The easiest way to install **branchdiff** on redhat-based Linux distributions is via the developer-tools package repository:

1. Download and install the repo definition file

    ```
    $ sudo yum install wget
    ```

    [![rpm-install1](./assets/rpm-install-1.png)](http://images.awspros.world/branchdiff/rpm-install-1.png)

    ```
    $ wget http://awscloud.center/rpm/developer-tools.repo
    ```

    ```
    $ sudo mv developer-tools.repo /etc/yum.repos.d/  &&  sudo chown 0:0 developer-tools.repo
    ```

2. Update local repository cache

    ```
    $ sudo yum update -y
    ```

3. Install **branchdiff** os package

    ```
    $ sudo yum install branchdiff
    ```

    [![rpm-install2](./assets/rpm-install-2.png)](http://images.awspros.world/branchdiff/rpm-install-2.png)


    Answer "y":

    [![rpm-install3](./assets/rpm-install-3.png)](http://images.awspros.world/branchdiff/rpm-install-3.png)


4. Verify Installation

    ```
    $ yum info branchdiff
    ```

    [![rpm-install4](./assets/rpm-install-4.png)](http://images.awspros.world/branchdiff/rpm-install-4.png)

[back to the top](#top)

* * *
## Upgrading
* * *

1. See if an upgrade is available, update your distribution's package repositories:

```
$  sudo apt update
```

2. Issue a list command to see upgrades.  Alternatively, you may issue ```$ sudo apt upgrade``` command.

```
$  apt list branchdiff -a
```

![repo-contents](./assets/repo-contents.png)

3. Upgrade

```
$  sudo apt upgrade
```

[back to the top](#top)

* * *
## Options

To display the help menu:

```bash
    $ branchdiff  --help
```

<p align="center">
  <img src="http://images.awspros.world/branchdiff/help-menu.png" alt="branchdiff help" target="_blank"/>
</p>


[back to the top](#top)

* * *
## Screenshots
* * *
<a name="screenshots0"></a>
#### [Screenshots](#screenshots) / Working Branch Status

[branchdiff](https://github.com/fstab50/branchdiff) provides the status of working branch of the current git repository in which the cursor is located:


```bash
$ cd <git repository root directory>
```

```bash
$ branchdiff
```

<p align="center">
  <img src="http://images.awspros.world/branchdiff/branchdiff1.png" alt="branchdiff1"/>
</p>

[back to the top](#top)

* * *
<a name="screenshots1"></a>
#### [Screenshots](#screenshots) / Extended commit history

```bash
~/xlines$ branchdiff
```

<p align="center">
  <img src="http://images.awspros.world/branchdiff/branchdiff-xlines.png" alt="branchdiff1"/>
</p>


[back to the top](#top)

* * *
<a name="screenshots2"></a>
#### [Screenshots](#screenshots) / Commit Log / history

[branchdiff](https://github.com/fstab50/branchdiff) accurately provides the commit age of the working branch where the cursor is located:

```bash
$ branchdiff --commit-log history
```

<p align="center">
  <img src="http://images.awspros.world/branchdiff/commit-log-history.png" alt="commitlog-history"/>
</p>

[back to the top](#top)


* * *

<a name="screenshots3"></a>
#### [Screenshots](#screenshots) / [Commit Log](screenshots3) / detail

[branchdiff](https://github.com/fstab50/branchdiff) accurately provides the commit age of the working branch where the cursor is located:

Simple repository with minimal branches and merges:

```bash
$ branchdiff --commit-log detail
```

<p align="center">
  <img src="http://images.awspros.world/branchdiff/commit-log-detail.png" alt="commitlog-history"/>
</p>

Git repository with many working branches and complex merge cadence:

```bash
$ branchdiff --commit-log detail
```

<p align="center">
  <img src="http://images.awspros.world/branchdiff/commit-log-detail2.png" alt="commitlog-history"/>
</p>


[back to the top](#top)

* * *
<a name="screenshots4"></a>
#### [Screenshots](#screenshots) / Code Diff

When used without a subcommand, the code option (--code) triggers [branchdiff](https://github.com/fstab50/branchdiff) to show the lines changed in all files updated in the current working branch compared to the master branch.

```bash
$ branchdiff --code
```

<p align="center">
  <img src="http://images.awspros.world/branchdiff/branchdiff-code.png" alt="branchdiff-code"/>
</p>

[back to the top](#top)

* * *
<a name="screenshots5"></a>
#### [Screenshots](#screenshots) / Code Diff \<filename\>

Pressing the tab key twice autocompletes the names of all files that received updates in the current working branch.

```bash
$ branchdiff --code <tab><tab>

Ansible/deploy_configuration.yml                       Code/core/ec2prices.py
attribute_defs.yml                                     Code/core/__init__.py
cloudformation/dynamodb-table.template.yml             Code/core/parameter_processing.py
cloudformation/serverless-monitor.template.yml         Code/core/_version.py
Code/connectors/dynamodb.py                            Code/index.py
Code/connectors/__init__.py                            Jenkinsfile
Code/connectors/table.py                               Makefile
Code/core/dynamodb.py                                  requirements.txt
```

A filename can be selected by typing the first few characters:

```bash
$ branchdiff --code Code/con... <tab><tab>
```

```bash
$ branchdiff --code Code/connectors/table.py
```

<p align="center">
  <img src="http://images.awspros.world/branchdiff/code-filediff.png" alt="branchdiff-code"/>
</p>

[back to the top](#top)

* * *
<a name="authorcopyright"></a>
## Author & Copyright

All works contained herein copyrighted via below author unless work is explicitly noted by an alternate author.

* Copyright Blake Huber, All Rights Reserved.

[back to the top](#top)

* * *

## License

* Software contained in this repository is licensed under the [MIT License](https://opensource.org/licenses/MIT).  A copy of the license agreement is included with this repository [here](./LICENSE).

[back to the top](#top)

* * *

## Disclaimer

The following code is provided in accordance with the strict legal disclaimer below:

*Code is provided "as is". No liability is assumed by either the code's originating author nor this repo's owner for their use at AWS or any other facility. Furthermore, running function code at AWS may incur monetary charges; in some cases, charges may be substantial. Charges are the sole responsibility of the account holder executing code obtained from this library.*

Additional terms may be found in the complete [License Agreement](https://github.com/fstab50/branchdiff/blob/master/LICENSE).

[back to the top](#top)

* * *
