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
        'bin/add-new-changelog-dot-md-release.py',
        'bin/changelog-dot-md-release-comments.py',
        'bin/cut-changelog-dot-md.py',
        'bin/python-version.sh',
        'bin/python-increment-version.sh',
        'bin/cut-release.sh',
        'bin/create-github-release.sh',
        'bin/run-flake8.sh',
        'bin/run-pip-check.sh',
        'bin/run-shellcheck.sh',
        'bin/run-unit-tests.sh',
        'bin/run-repo-security-scanner.sh',
        'bin/kill-and-rm-all-docker-containers.sh',
        'bin/build-python-package.sh',
        'bin/build-readme-dot-rst.sh',
        'bin/repo.sh',
        'bin/repo-root-dir.sh',
        'bin/run-snyk.sh',
        'bin/rm-dangling-docker-images.sh',
        'bin/run-markdownlint.sh',
        'bin/upload-dist-to-pypi.sh',
        'bin/create-dummy-docker-container.sh',
        'bin/check-consistent-dev-env-version.sh',
        'bin/run-yamllint.sh',
        'bin/run-circleci.sh',
        'bin/run-bandit.sh',
    ],
    install_requires=[
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
