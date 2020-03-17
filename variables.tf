////////////////
//Define Zones
////////////////


variable "ibmcloud_region" {
  description = "Preferred IBM Cloud region to use for your infrastructure"
  default = "us-south"
}

variable "zone1" {
  default = "us-south-1"
  description = "Define the 1st zone of the region"
}

variable "zone2" {
  default = "us-south-2"
  description = "Define the 2nd zone of the region"
}


////////////////
//Define VPC
////////////////

variable "vpc_name" {
  default = "vpc-demo003"
  description = "Name of your VPC"
}


variable "cis_resource_group" {
  default = "default"
}


////////////////
// Define CIDR
////////////////


variable "zone1_cidr" {
  default = "172.33.1.0/21"
  description = "CIDR block to be used for zone 1"
}

variable "zone2_cidr" {
  default = "172.33.8.0/21"
  description = "CIDR block to be used for zone 2"
}


////////////////////////////////
// Define Subnets for zones
////////////////////////////////

variable "web_subnet_zone1" {
  default = "172.33.0.0/24"
}

variable "db_subnet_zone_1" {
  default = "172.33.1.0/24"
}



variable "web_subnet_zone_2" {
  default = "172.33.8.0/24"
}

variable "db_subnet_zone_2" {
  default = "172.33.1.9/24"
}



////////////////////////////////




variable "ssh_key_name" {
  default = "default"
  description = "Name of existing VPC SSH Key"
}

variable "web_server_count" {
  default = 2
}

variable "db_server_count" {
  default = 1
}

variable "image" {
  default = "r006-14140f94-fcc4-11e9-96e7-a72723715315"
  description = "OS Image ID to be used for virtual instances"
}

variable "profile" {
  default = "cx2-2x4"
  description = "Instance profile to be used for virtual instances"
}