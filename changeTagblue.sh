#!/bin/bash
sed "s/tagVersion/$1/g" kubernates_blue.yml > blue.yml
