#!/bin/sh

num1=1
count1=0
count2=0

name1=`df |grep /tmp/usbmount|head -n "$num1"|tail -n 1|tr -s " "|cut -d " " -f 1`
tmp1=`df |grep /tmp/usbmount|head -n "$num1"|tail -n 1|tr -s " "|cut -d " " -f 2`
tmp2=`df |grep /tmp/usbmount|head -n "$num1"|tail -n 1|tr -s " "|cut -d " " -f 4`


while [ -n "$tmp1" ] && [ "$name1" != "$name2" ]
do
	count1=`expr "$count1" + "$tmp1"`
	count2=`expr "$count2" + "$tmp2"`
	name1=`df |grep /tmp/usbmount|head -n "$num1"|tail -n 1|tr -s " "|cut -d " " -f 1`
	num1=`expr "$num1" + 1`
	name2=`df |grep /tmp/usbmount|head -n "$num1"|tail -n 1|tr -s " "|cut -d " " -f 1`
	tmp1=`df |grep /tmp/usbmount|head -n "$num1"|tail -n 1|tr -s " "|cut -d " " -f 2`
	tmp2=`df |grep /tmp/usbmount|head -n "$num1"|tail -n 1|tr -s " "|cut -d " " -f 4`

done

echo $count1 $count2

