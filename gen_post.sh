#!/usr/bin/env bash

TITLE=$1
DATE=`date +"%Y-%m-%d"`
DATE_D=`date +"%Y-%m-%d %H:%M:%S"`

META_1="---"
META_2="layout: post"
META_3="title:  \" {{title}} \""
META_4='date: '$DATE_D
META_5='categories: {{category}}'
META_6="---"

touch './_posts/'$DATE'-'$TITLE'.markdown'
echo $META_1 > './_posts/'$DATE'_'$TITLE'.markdown'
echo $META_2 >> './_posts/'$DATE'_'$TITLE'.markdown'
echo $META_3 >> './_posts/'$DATE'_'$TITLE'.markdown'
echo $META_4 >> './_posts/'$DATE'_'$TITLE'.markdown'
echo $META_5 >> './_posts/'$DATE'_'$TITLE'.markdown'
echo $META_6 >> './_posts/'$DATE'_'$TITLE'.markdown'
