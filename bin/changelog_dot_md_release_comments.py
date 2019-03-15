#!/usr/bin/env python
"""Every repo should have a CHANGELOG.md in the root directory.
This file describes, at a high-level, all the changes that have
been made for each release. In the CHANGELOG.md, each release
typically has has a section that looks like:

    ## [0.5.14] - [2019-02-03]

    ### Added

    - added ```current-python-version.sh``` which is used to extract a python project's version number

    ### Changed

    - flake8 3.7.4 -> 3.7.7
    - twine 1.12.1 -> 1.13.0
    - fixed bug in ```run_shellcheck.sh``` where docker containers weren't being removed are they had exited
    - using ```"$(echo "${1:-}" | tr "[:upper:]" "[:lower:]")"``` instead of ```"${1,,}"``` and ```[[:space:]]``` instead of ```\s``` with sed so scripts work on macOS and Ubuntu
    - ```prep-for-release.sh``` now uses ```cut_changelog_dot_md.py``` and ```add_new_changelog_dot_md_release.py``` to improve portability across macOS and Ubuntu as well as simplifying ```prep-for-release.sh```

    ### Removed

    - Nothing

Given a release number, this script extracts the section of CHANGELOG.md
corresponding to version.

Expected innvocation for this script from a bash prompt is something like:

    ~>  changelog_dot_md_release_comments.py '0.5.14' ./CHANGELOG.md

CHANGELOG.md will be updated in place.
"""

import logging
import optparse
import os
import re
import tempfile
import time
import sys

_logger = None


def _check_logging_level(option, opt, value):
    """Type checking function for command line parser's 'logginglevel' type."""
    reg_ex_pattern = "^(DEBUG|INFO|WARNING|ERROR|CRITICAL|FATAL)$"
    reg_ex = re.compile(reg_ex_pattern, re.IGNORECASE)
    if reg_ex.match(value):
        return getattr(logging, value.upper())
    fmt = (
        "option %s: should be one of "
        "DEBUG, INFO, WARNING, ERROR, CRITICAL or FATAL"
    )
    raise optparse.OptionValueError(fmt % opt)


class CommandLineOption(optparse.Option):
    """Adds new option types to the command line parser's base
    option types.
    """
    new_types = (
        'logginglevel',
        'hostcolonport',
    )
    TYPES = optparse.Option.TYPES + new_types
    TYPE_CHECKER = optparse.Option.TYPE_CHECKER.copy()
    TYPE_CHECKER['logginglevel'] = _check_logging_level


class CommandLineParser(optparse.OptionParser):

    def __init__(self):
        optparse.OptionParser.__init__(self)

        description = 'Add a new release template to CHANGELOG.md'
        optparse.OptionParser.__init__(
            self,
            'usage: %prog <version> <changelog.md>',
            description=description,
            option_class=CommandLineOption)

        self.changelog = None

        default = logging.ERROR
        fmt = (
            "logging level [DEBUG,INFO,WARNING,ERROR,CRITICAL,FATAL] - "
            "default = %s"
        )
        help = fmt % logging.getLevelName(default)
        self.add_option(
            "--log",
            action="store",
            dest="logging_level",
            default=default,
            type="logginglevel",
            help=help)

    def parse_args(self, *args, **kwargs):
        (clo, cla) = optparse.OptionParser.parse_args(self, *args, **kwargs)
        if 2 != len(cla):
            self.error('version and changelog is required')

        self.version = cla[0]
        self.changelog = cla[1]

        return (clo, cla)


if __name__ == '__main__':
    #
    # parse the command line ...
    #
    clp = CommandLineParser()
    (clo, cla) = clp.parse_args()

    #
    # configure logging ...
    #
    # remember gmt = utc
    #
    logging.Formatter.converter = time.gmtime
    logging.basicConfig(
        level=clo.logging_level,
        datefmt='%Y-%m-%dT%H:%M:%S',
        format='%(asctime)s.%(msecs)03d+00:00 %(process)d '
        '%(levelname)5s %(module)s:%(lineno)d %(message)s')
    _logger = logging.getLogger(__name__)

    _logger.info('looking for "%s" in "%s"', clp.version, clp.changelog)

    with open(clp.changelog, 'r') as f:
        lines = f.readlines()

    # remove \n from the end of each line
    lines = [line[0:-1] for line in lines]

    _logger.info('read %d lines from existing CHANGELOG.md @ "%s"', len(lines), clp.changelog)

    specific_version_reg_ex_pattern = r'\s*##\s*\[%s\].*$' % clp.version.replace('.', '\.')
    specific_version_reg_ex = re.compile(specific_version_reg_ex_pattern)

    specific_version_found = False

    any_version_reg_ex_pattern = r'\s*##\s*\[\d+\.\d+\.\d+\].*$'
    any_version_reg_ex = re.compile(any_version_reg_ex_pattern)

    release_lines = []

    for line in lines:
        if specific_version_found:
            if any_version_reg_ex.match(line):
                _logger.info('found end of version "%s" in "%s"', clp.version, clp.changelog)
                break
            release_lines.append(line)
            continue

        if specific_version_reg_ex.match(line):
            _logger.info('found start of version "%s" in "%s"', clp.version, clp.changelog)
            specific_version_found = True

    # remove blank lines from top
    while release_lines and not release_lines[0]:
        release_lines = release_lines[1:]

    # remove blank lines from bottom
    while release_lines and not release_lines[-1]:
        release_lines = release_lines[:-1]

    for line in release_lines:
        print line
