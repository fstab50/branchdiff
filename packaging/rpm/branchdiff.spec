#
#   RPM spec: branchdiff, 2018 dec
#
%define name        branchdiff
%define version     MAJOR_VERSION
%define release     MINOR_VERSION
%define _bindir     usr/local/bin
%define _libdir     usr/local/lib/branchdiff
%define _compdir    etc/bash_completion.d
%define _topdir     /home/DOCKERUSER/rpmbuild
%define buildroot   %{_topdir}/%{name}-%{version}

BuildRoot:      %{buildroot}
Name:           %{name}
Version:        %{version}
Release:        %{release}
Summary:        A Utility for visualizing the status of the current git working branch

Group:          Development/Tools
BuildArch:      noarch
License:        GPL
URL:
Source:         %{name}-%{version}.%{release}.tar.gz
Prefix:         /usr
Requires:      DEPLIST

%if 0%{?rhel}%{?amzn2}
Requires: bash-completion
%endif

%if 0%{?amzn1}
Requires: epel-release
%endif


%description
branchdiff is a utility for use with git version control. branchdiff
provides user access to advanced  git features without requiring any
knowledge of advanced git syntax.
.
branch diff features:
  * Illustration of differences between current working branch and master branch
  * Details when commits were made to the current branch, by whom
  * Summary statistics for all commits
  * Advanced file difference illustration between branches

%prep

%setup -q

%build


%install
install -m 0755 -d $RPM_BUILD_ROOT/%{_bindir}
install -m 0755 -d $RPM_BUILD_ROOT/%{_libdir}
install -m 0755 -d $RPM_BUILD_ROOT/%{_compdir}
install -m 0755 branchdiff $RPM_BUILD_ROOT/%{_bindir}/branchdiff
install -m 0644 std_functions.sh $RPM_BUILD_ROOT/%{_libdir}/std_functions.sh
install -m 0644 os_distro.sh $RPM_BUILD_ROOT/%{_libdir}/os_distro.sh
install -m 0644 colors.sh $RPM_BUILD_ROOT/%{_libdir}/colors.sh
install -m 0644 exitcodes.sh $RPM_BUILD_ROOT/%{_libdir}/exitcodes.sh
install -m 0644 version.py $RPM_BUILD_ROOT/%{_libdir}/version.py
install -m 0644 branchdiff-completion.bash $RPM_BUILD_ROOT/%{_compdir}/branchdiff-completion.bash


%files
 %defattr(-,root,root)
/%{_libdir}
/%{_bindir}
/%{_compdir}
#/%{_bindir}/branchdiff


%post
#!/usr/bin/env bash

BIN_PATH=/usr/local/bin

# path updates - root user
if [ -f "$HOME/.bashrc" ]; then
    printf -- '%s\n\n' 'PATH=$PATH:/usr/local/bin' >> "$HOME/.bashrc"
    printf -- '%s\n' 'export PATH' >> "$HOME/.bashrc"

elif [ -f "$HOME/.bash_profile" ]; then
    printf -- '%s\n\n' 'PATH=$PATH:/usr/local/bin' >> "$HOME/.bash_profile"
    printf -- '%s\n' 'export PATH' >> "$HOME/.bash_profile"

elif [ -f "$HOME/.profile" ]; then
    printf -- '%s\n\n' 'PATH=$PATH:/usr/local/bin' >> "$HOME/.profile"
    printf -- '%s\n' 'export PATH' >> "$HOME/.profile"

fi


# path updates - sudo user
if [ $SUDO_USER ]; then

    if [ -f "/home/$SUDO_USER/.bashrc" ]; then
        printf -- '%s\n\n' 'PATH=$PATH:/usr/local/bin' >> "/home/$SUDO_USER/.bashrc"
        printf -- '%s\n' 'export PATH' >> "/home/$SUDO_USER/.bashrc"

    elif [ -f "/home/$SUDO_USER/.bash_profile" ]; then
        printf -- '%s\n\n' 'PATH=$PATH:/usr/local/bin' >> "/home/$SUDO_USER/.bash_profile"
        printf -- '%s\n' 'export PATH' >> "/home/$SUDO_USER/.bash_profile"

    elif [ -f "/home/$SUDO_USER/.profile" ]; then
        printf -- '%s\n\n' 'PATH=$PATH:/usr/local/bin' >> "/home/$SUDO_USER/.profile"
        printf -- '%s\n' 'export PATH' >> "/home/$SUDO_USER/.profile"

    fi

fi


##   install bash_completion, amazonlinux 1   ##

if [ -f '/usr/local/lib/buildpy/os_distro.sh' ]; then
    if [ "$(sh /usr/local/lib/buildpy/os_distro.sh | awk '{print $2}')" -eq "1" ]; then
        yum -y install bash-completion --enablerepo=epel
    fi
fi


##   end post install   ##
exit 0
