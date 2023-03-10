#!/bin/bash
sed "s/tagVersion/$1/g" kubernates_green.yml > green_kubernates.yml
