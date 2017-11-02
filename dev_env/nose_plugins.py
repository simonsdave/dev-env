"""To understand how this plug-in works take a look at the
inline documenation for dev_env_nosetests.py

References used to create this plug-in:

-- http://nose.readthedocs.org/en/latest/plugins/writing.html
-- http://nose.readthedocs.org/en/latest/plugins/capture.html
-- http://nose.readthedocs.org/en/latest/plugins/failuredetail.html
"""

from nose.plugins import Plugin
from nose.util import safe_str
from nose.util import ln


class FileCapture(Plugin):
    name = 'file-capture'
    _filenames_to_description = {}

    @classmethod
    def watch(cls, filename, description):
        cls._filenames_to_description[filename] = description

    def options(self, parser, env):
        pass

    def configure(self, options, conf):
        self.conf = conf
        self.enabled = True

    def beforeTest(self, test):
        type(self)._filenames_to_description = {}

    def formatError(self, test, err):
        ec, ev, tb = err
        return (ec, self.addCaptureToErr(ev), tb)

    def formatFailure(self, test, err):
        return self.formatError(test, err)

    def addCaptureToErr(self, ev):
        lines = []
        for (filename, description) in self._filenames_to_description.iteritems():
            lines.append(ln('>> begin ''{0}'' <<'.format(description)))
            with open(filename, 'r') as fp:
                lines += [safe_str(fp.read())]
            lines.append(ln('>> end ''{0}'' <<'.format(description)))
        lines.append(safe_str(ev))
        return '\n'.join(lines)
