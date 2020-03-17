////////////////
//SSH Key 
////////////////

data "ibm_is_ssh_key" "sshkey1" {
  name = "${var.ssh_key_name}"
}


////////////////
//Create VPC
///////////////

resource "ibm_is_vpc" "vpc1" {
  name = "${var.vpc_name}"
  address_prefix_management = "manual"
}

/*
resource "ibm_is_security_group" "fip_public_facing_sg_web_admin" {
    name = "fip_public_facing_sg_web_admin"
    vpc = "${ibm_is_vpc.vpc1.id}"
}

resource "ibm_is_security_group_rule" "fip_public_facing_sg_tcp22" {
    group = "${ibm_is_security_group.fip_public_facing_sg_web_admin}"
    direction = "inbound"
    remote = "0.0.0.0/0"
    tcp = {
      port_min = "22"
      port_max = "22"
    }


resource "ibm_is_security_group_rule" "fip_public_facing_sg_tcp80" {
    group = "${ibm_is_security_group.fip_public_facing_sg_web_admin}"
    direction = "inbound"
    remote = "0.0.0.0/0"
    tcp = {
      port_min = "80"
      port_max = "80"
    }



resource "ibm_is_security_group" "private_facing_sg_db_admin" {
    name = "private_facing_sg_db_admin"
    vpc = "${ibm_is_vpc.vpc1.id}"
}

*/


/////////////////////
//   ZONE 1 AKA LEFT
/////////////////////


resource "ibm_is_vpc_address_prefix" "vpc-ap1" {
  name = "vpc-ap1"
  zone = "${var.zone1}"
  vpc  = "${ibm_is_vpc.vpc1.id}"
  cidr = "${var.zone1_cidr}"
}

resource "ibm_is_subnet" "subnet1" {
  name            = "subnet1"
  vpc             = "${ibm_is_vpc.vpc1.id}"
  zone            = "${var.zone1}"
  ipv4_cidr_block = "${var.zone1_cidr}"
  depends_on      = ["ibm_is_vpc_address_prefix.vpc-ap1"]
}

resource "ibm_is_instance" "web-instancez01" {
  count   = "${var.web_server_count}"
  name    = "webz01-${count.index+1}"
  image   = "${var.image}"
  profile = "${var.profile}"

  primary_network_interface = {
    subnet = "${ibm_is_subnet.subnet1.id}"
  }
  vpc  = "${ibm_is_vpc.vpc1.id}"
  zone = "${var.zone1}"
  keys = ["${data.ibm_is_ssh_key.sshkey1.id}"]
  network_interfaces.security_groups = "fip_public_facing_sg_web_admin"
  //user_data = "${data.template_cloudinit_config.cloud-init-apptier.rendered}"
}

resource "ibm_is_instance" "db-instancez01" {
  count   = "${var.db_server_count}"
  name    = "dbz01-${count.index+1}"
  image   = "${var.image}"
  profile = "${var.profile}"

  primary_network_interface = {
    subnet = "${ibm_is_subnet.subnet1.id}"
  }
  vpc  = "${ibm_is_vpc.vpc1.id}"
  zone = "${var.zone1}"
  keys = ["${data.ibm_is_ssh_key.sshkey1.id}"]
  //user_data = "${data.template_cloudinit_config.cloud-init-apptier.rendered}"
}


resource "ibm_is_floating_ip" "floatingip1" {
  count   = "${var.web_server_count}"
  name = "fip1"
  target = "${ibm_is_instance.webz01-${count.index+1}.primary_network_interface.0.id}"
}



/*
/////////////////
//ZONE 2 AKA RIGHT
//////////////////

resource "ibm_is_vpc_address_prefix" "vpc-ap2" {
  name = "vpc-ap2"
  zone = "${var.zone2}"
  vpc  = "${ibm_is_vpc.vpc1.id}"
  cidr = "${var.zone2_cidr}"
}



resource "ibm_is_subnet" "subnet2" {
  name            = "subnet2"
  vpc             = "${ibm_is_vpc.vpc1.id}"
  zone            = "${var.zone2}"
  ipv4_cidr_block = "${var.zone2_cidr}"
  depends_on      = ["ibm_is_vpc_address_prefix.vpc-ap2"]
}


resource "ibm_is_instance" "instancez02" {
  count   = "${var.web_server_count}"
  name    = "webz02-${count.index+1}"
  image   = "${var.image}"
  profile = "${var.profile}"

  primary_network_interface = {
    subnet = "${ibm_is_subnet.subnet2.id}"
  }
  vpc  = "${ibm_is_vpc.vpc1.id}"
  zone = "${var.zone2}"
  keys = ["${data.ibm_is_ssh_key.sshkey1.id}"]
  //user_data = "${data.template_cloudinit_config.cloud-init-apptier.rendered}"
}


resource "ibm_is_instance" "db-instancez02" {
  count   = "${var.db_server_count}"
  name    = "dbz02-${count.index+1}"
  image   = "${var.image}"
  profile = "${var.profile}"

  primary_network_interface = {
    subnet = "${ibm_is_subnet.subnet2.id}"
  }
  vpc  = "${ibm_is_vpc.vpc1.id}"
  zone = "${var.zone2}"
  keys = ["${data.ibm_is_ssh_key.sshkey1.id}"]
  //user_data = "${data.template_cloudinit_config.cloud-init-apptier.rendered}"
} 
*/