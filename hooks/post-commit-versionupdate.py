#!/usr/bin/env python3
"""

   - Summary:   Post commit hook, updates version throughout project
   - Location:  .git/hooks
   - Filename:  commit-msg

"""
import os
import sys
import inspect
import fileinput
from pyaws.utils import stdout_message

version_module = 'version.py'


def packagename(filename):
    """Retrieve name of build package stored locally."""
    if os.path.exists(filename):
        with open(filename) as p1:
            for line in p1.readlines():
                if 'PACKAGE' in line:
                    return line.split(':')[1].strip()
                    break
                else:
                    return None
    return None


PACKAGE = packagename('DESCRIPTION.rst')

if PACKAGE is None:
    stdout_message(
            message='Problem executing post-commit-hook (%s). Exit' % __file__,
            prefix='WARN'
        )
    sys.exit(1)
else:
    sys.path.insert(0, os.path.abspath(PACKAGE))
    from version_module import __version__
    sys.path.pop(0)


try:

    if os.path.exists('README.md'):
        # update specfile - major version
        for line in fileinput.input(['README.md'], inplace=True):
            print(line.replace('MAJOR_VERSION', major), end='')
        stdout_message(f'Updated {specfile} with MAJOR_VERSION', prefix='OK')

except OSError as e:
    stdout_message(
            message='%s: Error while reading or writing post-commit-hook' % inspect.stack()[0][3],
            prefix='WARN'
        )
sys.exit(0)
