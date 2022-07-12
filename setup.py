#!/usr/bin/env python3

import os
from setuptools import setup

install_requires = []

package_info = dict()
current_dir = os.path.abspath(os.path.dirname(__file__))
with open(os.path.join(current_dir, "src", "__version__.py")) as f:
    exec(f.read(), package_info)

readme = ""
with open("README.md") as f:
    readme = f.read()

setup(
    name="xdisplayinfo",
    version=package_info["__version__"],
    description=package_info["__description__"],
    long_description=readme,
    author=package_info["__author__"],
    author_email=package_info["__author_email__"],
    url=package_info["__source_url__"],
    long_description_content_type="text/markdown",
    packages=["xdisplayinfo"],
    package_dir={"xdisplayinfo": "src"},
    license_files = ("LICENSE",),
    include_package_data=True,
    python_requires=">=3.7, <4",
    install_requires=install_requires,
    scripts=["src/scripts/xdisplayinfo"],
    project_urls={
        "Source": package_info["__source_url__"],
        "Documentation": package_info["__docs_url__"],
        "Tracker": package_info["__issues_url__"],
    },
    classifiers=[
        "Development Status :: 3 - Alpha",
        "Environment :: Console",
        "Environment :: X11 Applications",
        "Intended Audience :: Developers",
        "License :: OSI Approved :: GNU General Public License v3 (GPLv3)",
        "Natural Language :: English",
        "Operating System :: Unix",
        "Operating System :: POSIX :: Linux",
        "Programming Language :: Unix Shell",
        "Programming Language :: Python :: 3",
        "Programming Language :: Python :: Implementation :: CPython",
        "Topic :: Multimedia :: Video :: Display",
        "Topic :: Desktop Environment :: Window Managers",
        "Topic :: System :: Hardware",
        "Topic :: System :: Shells",
        "Topic :: Terminals",
        "Topic :: Utilities",
    ],
)
