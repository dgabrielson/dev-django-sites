#!/usr/bin/env bash
set -e

for year in 2018 2017 2016 2015 2014 2013 2012 2011 2010 2009 2008 2007; do 
	for term in fall summer winter; do 
		echo $year $term
		time manage.py aurora load_classes --year $year --term $term
	done 
done
echo "2006 fall"
time manage.py aurora load_classes --year 2006 --term fall
