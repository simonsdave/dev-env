import unittest

from .. import __version__


class SomethingTestCase(unittest.TestCase):

    def test_version(self):
        self.assertIsNotNone(__version__)
        self.assertTrue(0 < len(__version__))
