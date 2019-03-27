#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""Integration tests often run database installer(s),
start up service(s) and then direct various requests at the
service(s). When the tests fail it's very useful to output the
logs associated with these installers and services.

The nose plug-in dev_env.nose_plugins.FileCapture is used
in integration tests to identify the files that should be
displayed on test failure. In order for dev_env.nose_plugins.FileCapture
to work as desired it must be registered prior to running tests.
This script is responsible for registering dev_env.nose_plugins.FileCapture
the plug-in. This script is used as a replacement for ```nosetests```.
"""

import nose

from dev_env import nose_plugins

if __name__ == '__main__':
    nose.main(addplugins=[nose_plugins.FileCapture()])
