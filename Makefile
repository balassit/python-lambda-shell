APP_DIR			    := app
VIRTUALENV		    := python3 -m venv . && source bin/activate
PIP				    := pip3 install
CD				    := cd $(APP_DIR)
PYTHON_VERSION		:= python3.7
STAGING_PATH	    := package
LAMBDAS             := hello_world
.PHONY: all build freeze clean package-all bundle-all zip-all test run-test clean-test

build:
	$(CD) && \
	$(VIRTUALENV) && \
	$(PIP) -r requirements.txt
	
clean:
	$(CD) \
	&& rm -rf bin \
	&& rm -rf include \
	&& rm -rf lib

package-all:
	rm -rf $(STAGING_PATH) && \
	mkdir -p $(STAGING_PATH) && \
	for entry in ${LAMBDAS} ; do \
		mkdir -p $(STAGING_PATH)/$$entry && \
		cp app/$$entry.py $(STAGING_PATH)/$$entry && \
		cp app/__init__.py $(STAGING_PATH)/$$entry && \
		cp -R app/shared $(STAGING_PATH)/$$entry && \
		chmod -R 755 $(STAGING_PATH)/* \
		; \
	done

bundle-all:
	for entry in ${LAMBDAS} ; do \
		$(PIP) --target=package/$$entry/ -r app/requirements.txt \
		; \
	done
	
zip-all:
	for entry in ${LAMBDAS} ; do \
		cd package/$$entry && \
		zip -r9q ../$$entry.zip . && \
		cd ../../ && \
		cp package/*.zip ./infrastructure/lambdas/ \
		; \
	done

all: build package-all bundle-all clean

run-test:
	$(VIRTUALENV) && \
	$(PIP) -r app/requirements.txt && \
	$(PIP) -r tests/unit_tests/requirements.txt && \
	pytest tests/unit_tests && \
	coverage run -m --source=tests/unit_tests/ unittest discover && \
	coverage report

clean-unit-test:
	$(CD) && \
	rm -rf __pycache__ && \
	rm -rf .pytest_cache && \
	rm -rf tests/unit_tests/__pycache__


test: run-test clean-unit-test
