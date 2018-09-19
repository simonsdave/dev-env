#
# Steps below build the distribution @ dev_env-*.*.*.tar.gz
# (FYI ... use of pandoc is as per https://github.com/pypa/pypi-legacy/issues/148#issuecomment-226939424
# since pypi requires long description in RST but the repo's readme is in
# markdown)
#
#   >git clone https://github.com/simonsdave/dev-env.git
#   >cd dev-env
#   >source cfg4dev
#   >pandoc README.md -o README.rst
#   >python setup.py bdist_wheel sdist --formats=gztar
#
# update pypi with both meta data and source distribution
#
#   >twine upload dist/* -r testpypi
#
# you will be able to find the package at
#
#   https://test.pypi.org/project/dev-env/
#
# use the uploaded package
#
#   >pip install -i https://test.pypi.org/pypi dev-env
#
import re
from setuptools import setup

#
# this approach used below to determine ```version``` was inspired by
# https://github.com/kennethreitz/requests/blob/master/setup.py#L31
#
# why the complexity? wanted a single spot for the version number
#
# the code below assumes the distribution is being built with the
# current directory being the directory in which setup.py is stored
# which should be totally fine 99.9% of the time. not going to add
# the coode complexity to deal with other scenarios
#
reg_ex_pattern = r'__version__\s*=\s*[\'"](?P<version>[^\'"]*)[\'"]'
reg_ex = re.compile(reg_ex_pattern)
version = ''
with open('dev_env/__init__.py', 'r') as fd:
    for line in fd:
        match = reg_ex.match(line)
        if match:
            version = match.group('version')
            break
if not version:
    raise Exception('Can''t locate project''s version number')


def _long_description():
    try:
        with open('README.rst', 'r') as f:
            return f.read()
    except IOError:
        # simple fix for avoid failure on "source cfg4dev"
        return "a long description"


_author = 'Dave Simons'
_author_email = 'simonsdave@gmail.com'


setup(
    name='dev_env',
    packages=[
        'dev_env',
    ],
    scripts=[
        'bin/dev_env_nosetests.py',
        'bin/prep-for-release-python.sh',
        'bin/prep-for-release.sh',
        'bin/run_flake8.sh',
        'bin/run_pip_check.sh',
        'bin/run_shellcheck.sh',
        'bin/run_unit_tests.sh',
    ],
    install_requires=[
        'nose>=1.3.7',
    ],
    include_package_data=True,
    version=version,
    description='Dev Env',
    long_description=_long_description(),
    author=_author,
    author_email=_author_email,
    maintainer=_author,
    maintainer_email=_author_email,
    license='MIT',
    url='https://github.com/simonsdave/dev-env',
    download_url='https://github.com/simonsdave/dev-env/tarball/v%s' % version,
    keywords=[
        'development',
        'tools',
    ],
    # list of valid classifiers @ https://pypi.python.org/pypi?%3Aaction=list_classifiers
    classifiers=[
        'Development Status :: 5 - Production/Stable',
        'Intended Audience :: Developers',
        'Natural Language :: English',
        'License :: OSI Approved :: MIT License',
        'Operating System :: OS Independent',
        'Programming Language :: Python',
        'Programming Language :: Python :: 2.7',
        'Programming Language :: Python :: Implementation :: CPython',
        'Topic :: Software Development :: Libraries :: Python Modules',
    ],
)
