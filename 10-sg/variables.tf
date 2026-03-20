variable "project_name" {
    default = "expense"
}

variable "environment" {
    default = "dev"
}

variable "common_tags" {
    default = {
        Project = "expense"
        Terraform = "true"
        Environment = "dev"
    }
}

variable "mysql_sg_tags" {
    default = {
        Component = "mysql"
    }
}

variable "bastion_sg_tags" {
    default = {
        Component = "bastion"
    }
}

variable "eks_control_plane_sg_tags" {
    default = {
        Component = "eks-control-plane"
    }
}

variable "node_sg_tags" {
    default = {
        Component = "eks-node"
    }
}

variable "ingress_alb_sg_tags" {
    default = {
        Component = "ingress-alb"
    }
}
