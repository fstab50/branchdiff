#!/usr/bin/env python3
"""

   - Summary:   Post commit hook, updates version throughout project
   - Location:  .git/hooks
   - Filename:  commit-msg

"""
import os
import sys
import re
import inspect
import fileinput
from pyaws.utils import stdout_message

# globals
module = os.path.basename(__file__)
lib_relpath = 'core'                # path relative to git project root
version_module = 'version'
targets = ['README.md']


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


def deprecated_version(filename, expression):
    """
    Summary.

        Extract program version N-1.

    Args:
        :filename (str): Name of file contents searched for N-1 version num.
        :expression (str): Regex or string which matches deprecated version

    Returns:
        exact match, TYPE: str or None

    """
    pattern = re.compile(expression)

    try:
        with open(filename) as d1:
            parsed = set(d1.read().split())
            for item in parsed:
                if pattern.match(item):
                    return item
    except OSError:
        stdout_message(
                message=f'File {filename} not found', prefix='DBUG'
            )
    except Exception as e:
        stdout_message(
                message=f'Unknown error ({e})', prefix='DBUG'
            )
    return None


PACKAGE = packagename('DESCRIPTION.rst')
CURRENT = deprecated_version('README.md', '[0-9]\.[0-9]\.[0-9]')

if PACKAGE is None:

    try:

        pwd = os.getcwd()
        os.chdir(lib_relpath)
        from . import version
        __version__ = version.__version__
        os.chdir(pwd)

    except ImportError as e:
        stdout_message(
            message='Problem executing commit-hook (%s). Error: %s' %
            (__file__, str(e)),
            prefix='WARN'
            )
else:
    sys.path.insert(0, os.path.abspath(PACKAGE))
    from version_module import __version__
    sys.path.pop(0)


try:
    for target in targets:
        if os.path.exists(target):
            # update specfile - major version
            for line in fileinput.input([target], inplace=True):
                print(line.replace(CURRENT, __version__), end='')
            stdout_message(f'Updated {target} version {CURRENT} with {__version__}', prefix='OK')
except OSError as e:
    stdout_message(
            message='%s: Error while reading or writing post-commit-hook' % inspect.stack()[0][3],
            prefix='WARN'
        )
sys.exit(0)
