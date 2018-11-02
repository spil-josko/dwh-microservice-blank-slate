#!/bin/bash
export PYTHONPATH=$PYTHONPATH:/opt/:/opt/container/
rm -Rf .htmlcov
SETTINGS_PATH=/opt/container/config/importer.conf coverage run -m py.test unittest/tests/
SUCCESS=$?
echo ""
coverage report -m
coverage html -d .htmlcov
echo ""
exit $SUCCESS
