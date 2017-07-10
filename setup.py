""" Setup Script.
"""
import os

from setuptools import setup, find_packages

# pylint: disable=invalid-name
try:
    from babel.messages import frontend as babel
    babel_cmdclass = {
        'extract_messages': babel.extract_messages,
    }
except ImportError:
    babel_cmdclass = {}

here = os.path.abspath(os.path.dirname(__file__))
with open(os.path.join(here, *('doc', 'DESCRIPTION.rst'))) as f:
    DESCRIPTION = f.read()
with open(os.path.join(here, 'CHANGELOG')) as f:
    CHANGELOG = f.read()

requires = [
    'colorlog',
    'Paste',
    'PasteScript',
    'python-dotenv',
    'pyramid',
    'pyramid_assetviews',
    'pyramid_mako',
]

development_requires = [
    'Babel',
    'flake8',
    'pylint',
    'waitress',
]

testing_requires = [
    'pytest',
    'pytest-cov',
    'WebTest',
]

production_requires = [
    'CherryPy',
    'raven',
]

cmdclass = {}
cmdclass = cmdclass.copy()
cmdclass.update(babel_cmdclass)

setup(
    name='tirol',
    version='0.1',
    description='The IntROduction website for ScroLliris.',
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
    message_extractors={'tirol': [
        ('**.py', 'python', None),
        ('templates/**.mako', 'mako', {'input_encoding': 'utf-8'}),
        ('static/**', 'ignore', None),
    ]},
    cmdclass=cmdclass,
    entry_points="""\
    [paste.app_factory]
    main = tirol:main
    [console_scripts]
    tirol_pserve = tirol.scripts.pserve:main
    tirol_pstart = tirol.scripts.pstart:main
    """,
)
