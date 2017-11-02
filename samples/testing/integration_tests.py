"""Some examples of how to use the ```FileCapture``` plug-in."""

import os
import subprocess
import tempfile
import unittest

from nose.plugins.attrib import attr
from dev_env.nose_plugins import FileCapture


@attr('integration')
class SomeTestCase(unittest.TestCase):

    def test_happy_path(self):
        stdout_file = tempfile.mktemp()
        FileCapture.watch(stdout_file, 'stdout')

        cmd = [
            'echo',
            '"dave was here"',
        ]
        process = subprocess.Popen(
            cmd,
            stdout=open(stdout_file, 'w+'),
            stderr=subprocess.STDOUT,
            preexec_fn=os.setsid,
        )
        process.wait()

        # This assertion is expected to fail since
        # process.returncode will be 0.
        self.assertEqual(process.returncode, 1)
