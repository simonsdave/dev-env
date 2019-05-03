#!/usr/bin/env python
"""See the README.md in the same directory as this script for a
description of why this script exists what this script does.
"""

import logging
import optparse
import os
import re
import tempfile
import time

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

        description = (
            'Replace %RELEASE_VERSION% %RELEASE_DATE% in CHANGELOG.md with '
            'an actual release version and release date.'
        )
        optparse.OptionParser.__init__(
            self,
            'usage: %prog <version> <date> <changelog.md>',
            description=description,
            option_class=CommandLineOption)

        self.version = None
        self.date = None
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
        if 3 != len(cla):
            self.error('version, date & changelog are required')

        self.release_version = cla[0]
        self.release_date = cla[1]
        self.changelog = cla[2]

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

    _logger.info('replacing %%RELEASE_VERSION%% with "%s" in "%s"', clp.release_version, clp.changelog)
    _logger.info('replacing %%RELEASE_DATE%% with "%s" in "%s"', clp.release_date, clp.changelog)

    with open(clp.changelog, 'r') as f:
        lines = f.readlines()
    _logger.info('read %d lines from existing CHANGELOG.md @ "%s"', len(lines), clp.changelog)

    for i in range(0, len(lines)):
        line = lines[i]
        line = line.replace('%RELEASE_VERSION%', clp.release_version)
        line = line.replace('%RELEASE_DATE%', clp.release_date)
        lines[i] = line

    (_, new_changelog) = tempfile.mkstemp()
    _logger.info('creating new CHANGELOG.md @ "%s"', new_changelog)

    with open(new_changelog, 'w') as f:
        for line in lines:
            f.write(line)

    os.rename(new_changelog, clp.changelog)

    _logger.info('updated CHANGELOG.md available @ "%s"', clp.changelog)
