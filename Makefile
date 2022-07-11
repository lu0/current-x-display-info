init:
	rm -rf venv_dev
	python3 -m pip install virtualenv
	virtualenv venv_dev && \
	. venv_dev/bin/activate && \
	pip3 install --upgrade pip && \
	pip3 install -r requirements-dev.txt && \
	pre-commit install

clean:
	rm -rf build dist
	rm -rf xdisplayinfo.egg-info .egg
	rm -rf venv_test
	virtualenv venv_test
	. venv_test/bin/activate

# Naive test
test: clean
	pip3 install .
	xdisplayinfo --all

build: clean
	python3 -m build
	pip3 install dist/*.tar.gz
	xdisplayinfo --all

prepublish: build
	twine upload -r testpypi dist/*
	make clean && . venv_test/bin/activate
	pip install -i https://test.pypi.org/simple/ --no-deps xdisplayinfo
	xdisplayinfo --all

publish:
	twine upload dist/*
