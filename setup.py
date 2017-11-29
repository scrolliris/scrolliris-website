import os
import sys

from setuptools import setup, find_packages

# pylint: disable=invalid-name
here = os.path.abspath(os.path.dirname(__file__))
with open(os.path.join(here, *('doc', 'DESCRIPTION.rst'))) as f:
    DESCRIPTION = f.read()
with open(os.path.join(here, 'CHANGELOG')) as f:
    CHANGELOG = f.read()

requires = [
    'better_exceptions',
    'bleach',
    'MarkupSafe',
    'Paste',
    'PasteScript',
    'python-dotenv',
    'pyramid',
    'pyramid_assetviews',
    'pyramid_mako',
    'pyramid_secure_response',
]

if sys.version_info[0] < 3:  # python 2.7
    requires.extend([
        'ipaddress',
        'typing',
    ])

development_requires = [
    'colorlog',
    'flake8',
    'flake8-docstrings',
    'pycodestyle',
    'pylint',
    'waitress',
]

testing_requires = [
    'colorlog',
    'pytest',
    'pytest-cov',
    'pytest-mock',
    'WebTest',
]

production_requires = [
    'CherryPy',
]

setup(
    name='thun',
    version='0.1',
    description='Thun; The Honest introdUctioN of scrolliris',
    long_description=DESCRIPTION + '\n\n' + CHANGELOG,
    classifiers=[
        "Programming Language :: Python",
        "Framework :: Pyramid",
        "Topic :: Internet :: WWW/HTTP",
        "Topic :: Internet :: WWW/HTTP :: WSGI :: Application",
    ],
    author='',
    author_email='',
    url='',
    keywords='web wsgi pylons pyramid',
    packages=find_packages(),
    include_package_data=True,
    zip_safe=False,
    extras_require={
        'development': development_requires,
        'testing': testing_requires,
        'production': production_requires,
    },
    install_requires=requires,
    entry_points="""\
    [paste.app_factory]
    main = thun:main
    [console_scripts]
    thun_pserve = thun.scripts.pserve:main
    thun_pstart = thun.scripts.pstart:main
    """,
)
