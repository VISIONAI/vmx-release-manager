#!/bin/sh
sed 's/_/#/g' | sort -V | sed -e 's/#/_/g'
