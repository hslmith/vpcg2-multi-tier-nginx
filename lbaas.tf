/////////////////////////////////////////
// Create WebAppTier Load Balancer in zone 1 & Zone 2 of VPC
/////////////////////////////////////////


resource "ibm_is_lb" "webtier-lb" {
  name = "${var.vpc-name}-webtier01-lb"
  subnets = ["${ibm_is_subnet.websubnet1.id}"]
}

resource "ibm_is_lb_listener" "webapptier-lb-listener" {
  lb           = "${ibm_is_lb.webapptier-lb.id}"
  default_pool = "${element(split("/", ibm_is_lb_pool.webapptier-lb-pool.id),1)}"
  port         = "80"
  protocol     = "http"
}


resource "ibm_is_lb_pool" "webapptier-lb-pool" {
  lb                 = "${ibm_is_lb.webapptier-lb.id}"
  name               = "${var.vpc-name}-webapptier-lb-pool1"
  protocol           = "http"
  algorithm          = "${var.webapptier-lb-algorithm}"
  health_delay       = "5"
  health_retries     = "2"
  health_timeout     = "2"
  health_type        = "http"
  health_monitor_url = "/"
}





/////////////////////////////////////////
// Add web from zone 1 and zone 2 to pool
/////////////////////////////////////////


resource "ibm_is_lb_pool_member" "webapptier-lb-pool-member-zone1" {
  count          = "${ibm_is_instance.web-instancez01.count}"
  lb             = "${ibm_is_lb.webapptier-lb.id}"
  pool           = "${element(split("/", ibm_is_lb_pool.webapptier-lb-pool.id),1)}"
  port           = "80"
  target_address = "${element(ibm_is_instance.web-instancez01.*.primary_network_interface.0.primary_ipv4_address,count.index)}"
}