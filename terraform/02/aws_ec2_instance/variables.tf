/**** **** **** **** **** **** **** **** **** **** **** ****
Prefix is here to emulate a required naming convention.
**** **** **** **** **** **** **** **** **** **** **** ****/

variable "prefix" {}

variable "instance_names" {}

/**** **** **** **** **** **** **** **** **** **** **** ****
Defaulting to US-EAST-2
**** **** **** **** **** **** **** **** **** **** **** ****/

variable "region" {}

/**** **** **** **** **** **** **** **** **** **** **** ****
Default tags used to determine the identity and meta-data 
for the deployment. 
**** **** **** **** **** **** **** **** **** **** **** ****/

variable "tags" {}

variable "key_name" {}

variable "vpc_security_group_id" {}
