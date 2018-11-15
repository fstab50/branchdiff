<a name="top"></a>
* * *
# branchdiff
* * *

## About this repository

* Purpose: 		Instantly know status of the current git working branch
* Version:	     1.0.16
* Repo: 		https://github.com/fstab50/branchdiff


* * *
## Contents

* [**SUMMARY**](#summary)
* [**SUPPORTED LINUX DISTRIBUTIONS**](#supported-linux-distributions)
* [**INSTALLATION**](#installation)
* [**USAGE**](#usage)
* [**SCREENSHOTS**](#screenshots)
    * [Working Branch Status](#screenshots)
    * [Working Branch Status (Extended)](#screenshots1)
    * [Commit Log History](#screenshots2)
    * [Line-by-Line Code Diff](#screenshots3)
* [Author & Copyright](#author---copyright)
* [License](#license)
* [Disclaimer](#disclaimer)

[back to the top](#top)

* * *
## Summary

[branchdiff](https://github.com/fstab50/branchdiff) is a utility for use with git version control.  The program:

* Illustrates differences between current working branch and master branch

* Details when commits were made to the current branch, by whom

* Provides summary statistics

[back to the top](#top)

* * *
## Supported Linux Distributions

* Ubuntu,  Debian variants
* Linux Mint 17, 18, 19
* Redhat 7, CentOS 7
* Fedora 28+

[back to the top](#top)

* * *
## Installation

* TBD

[back to the top](#top)

* * *
## Usage

To display the help menu:

```bash
    $ branchdiff  --help
```

<p align="center">
  <img src="https://raw.githubusercontent.com/fstab50/branchdiff/master/assets/help-menu.png" alt="branchdiff help"/>
</p>


[back to the top](#top)

* * *
## Screenshots
* * *
<a name="screenshots0"></a>
#### [Screenshots](#screenshots) / Working Branch Status

[branchdiff](https://github.com/fstab50/branchdiff) provides the status of working branch of the git project in which the cursor is located when the user invokes the program:


```bash
$ branchdiff
```

<p align="center">
  <img src="https://raw.githubusercontent.com/fstab50/branchdiff/master/assets/branchdiff1.png" alt="branchdiff1"/>
</p>

* * *
<a name="screenshots1"></a>
#### [Screenshots](#screenshots) / Extended commit history

```bash
$ branchdiff
```
<p align="center">
  <img src="https://raw.githubusercontent.com/fstab50/branchdiff/master/assets/branchdiff2.png" alt="branchdiff1"/>
</p>

[back to the top](#top)

* * *
<a name="screenshots2"></a>
#### [Screenshots](#screenshots) / Commit Log / History

[branchdiff](https://github.com/fstab50/branchdiff) accurately provides the commit age of the working branch where the cursor is located when user invokes the program:

```bash
$ branchdiff --commit-log history
```

<p align="center">
  <img src="https://raw.githubusercontent.com/fstab50/branchdiff/master/assets/commitlog-history.png" alt="commitlog-history"/>
</p>

[back to the top](#top)

* * *
<a name="screenshots3"></a>
#### [Screenshots](#screenshots) / Code Diff

[branchdiff](https://github.com/fstab50/branchdiff) shows the actual lines updated in the current working branch compared to the master branch.

```bash
$ branchdiff --code
```

<p align="center">
  <img src="https://raw.githubusercontent.com/fstab50/branchdiff/master/assets/branchdiff-code.png" alt="branchdiff-code"/>
</p>

[back to the top](#top)

* * *
## Author & Copyright

All works contained herein copyrighted via below author unless work is explicitly noted by an alternate author.

* Copyright Blake Huber, All Rights Reserved.

[back to the top](#top)

* * *

## License

* Software contained in this repository is licensed under the [MIT License](https://opensource.org/licenses/MIT).

[back to the top](#top)

* * *

## Disclaimer

The following code is provided in accordance with the strict legal disclaimer below:

*Code is provided "as is". No liability is assumed by either the code's originating author nor this repo's owner for their use at AWS or any other facility. Furthermore, running function code at AWS may incur monetary charges; in some cases, charges may be substantial. Charges are the sole responsibility of the account holder executing code obtained from this library.*

Additional terms may be found in the complete [License Agreement](https://github.com/fstab50/branchdiff/blob/master/LICENSE).

[back to the top](#top)

* * *
