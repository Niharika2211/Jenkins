module "jenkins" { 
    source = "terraform-aws-modules/ec2-instance/aws"

    name = "mini-jenkins"

    instance_type = "t3.small"
    vpc_security_group_ids = ["sg-078f41000246b5e6b"]
    subnet_id = "subnet-02f09a7a45feb12bf"
    ami = data.ami.info_ami.id
    user_data = file("jenkins.sh")

    tags = {
        Name = mini-jenkins
        Terraform = true
    }

    # Define the root volume size and type

    root_block_device = [
        {
            volume_size = 50            # Size of the root volume in GB
            volume_type = "gp3"        # General Purpose SSD (you can change it if needed)
            delete_on_termination = true
        }
    ]
}


module "agent_jenkins" {
    source = "terraform-aws-modules/ec2-instance/aws"

    name = "agent-mini"

    instance_type = "t3.small"
    vpc_security_group_ids = ["sg-078f41000246b5e6b"]
    subnet_id = ["subnet-02f09a7a45feb12bf"]
    ami = data.aws_ami.info-ami.id
    user_data = file(jenkins-agent.sh)
    

    tags = {
        name = agent-mini
        Terraform = true
    }
  

    
    root_block_device = [

    {

       volume_size = 50
       volume_type = "gp3"
       delete_on_termination = true
    }
    ]
}



module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 2.0"

  zone_name = var.zone_name

  records = [
    {
      name    = "jenkins"
      type    = "A"
      ttl     = 1
      records = [
        module.jenkins.public_ip
      ]
      allow_overwrite = true
    },
    {
      name    = "jenkins-agent"
      type    = "A"
      ttl     = 1
      records = [
        module.jenkins_agent.private_ip
      ]
      allow_overwrite = true
    }
  ]

}