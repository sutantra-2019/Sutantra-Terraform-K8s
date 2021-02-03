# PACT K8s Cluster

Architecture:

![Alt text](Images/Kubernetes.jpeg?raw=true "Architecture")

Following is the Steps to create the AWS Kubernetes Cluster and ALB Ingress Controller to route
the traffic from Route 53 To The Application Load Balancer and to the Kubernetes Containers.

Step - 1: Terraform Initiation / Plan / Apply Commands to create the AWS EKS Cluster.

      * terraform plan -var aws_k8s_cluster="PACT-Dev" -var ami_release_version="1.18.9-20201211" -var aws_k8s-version="1.18" -var ec2_ssh_key="achaudhari-pact-ec2-key" -var aws-node-instance-type="t2.2xlarge" -var desired-capacity="1" -var max-size="5" -var min-size="1" -var aws_vpc_id="vpc-08ff0ba905abb5b4a"

      * terraform apply -var aws_k8s_cluster="PACT-Dev" -var ami_release_version="1.18.9-20201211" -var aws_k8s-version="1.18" -var ec2_ssh_key="achaudhari-pact-ec2-key" -var aws-node-instance-type="t2.2xlarge" -var desired-capacity="1" -var max-size="5" -var min-size="1" -var aws_vpc_id="vpc-08ff0ba905abb5b4a"

      * terraform destroy -var aws_k8s_cluster="PACT-Dev" -var ami_release_version="1.18.9-20201211" -var aws_k8s-version="1.18" -var ec2_ssh_key="achaudhari-pact-ec2-key" -var aws-node-instance-type="t2.2xlarge" -var desired-capacity="1" -var max-size="5" -var min-size="1" -var aws_vpc_id="vpc-08ff0ba905abb5b4a"

Step - 2: From the Helm Folder run the following sequentially,

      * Create Helm Chart from "ALB-Controller-ServiceAccount"

      * Create Helm Chart from "ALB-Controller-CertManager"

      * Create Helm Chart from "ALB-Controller"

      * Create Helm Chart from "ALB-Controler-ServiceAcc-Refresh"

      * Create Helm Chart from "ALB-Ingress-Object" (This should run only after application deployment and change of port number etc. in the values.yaml file)

Step - 3: Enable the container and cluster logging using Fluent Bit.

      * Create the namespace "amazon-cloudwatch".

      * Create config map with cluster information.

            ClusterName=cluster-name
            RegionName=cluster-region
            FluentBitHttpPort='2020'
            FluentBitReadFromHead='Off'
            [[ ${FluentBitReadFromHead} = 'On' ]] && FluentBitReadFromTail='Off'|| FluentBitReadFromTail='On'
            [[ -z ${FluentBitHttpPort} ]] && FluentBitHttpServer='Off' || FluentBitHttpServer='On'
            kubectl create configmap fluent-bit-cluster-info \
            --from-literal=cluster.name=${ClusterName} \
            --from-literal=http.server=${FluentBitHttpServer} \
            --from-literal=http.port=${FluentBitHttpPort} \
            --from-literal=read.head=${FluentBitReadFromHead} \
            --from-literal=read.tail=${FluentBitReadFromTail} \
            --from-literal=logs.region=${RegionName} -n amazon-cloudwatch

        * Download and Deploy the Fluent Bit Daemon set using kubectl command.

            kubectl apply -f https://raw.githubusercontent.com/aws-samples/amazon-cloudwatch-container-insights/latest/k8s-deployment-manifest-templates/deployment-mode/daemonset/container-insights-monitoring/fluent-bit/fluent-bit.yaml

        * Validate the Fluent Bit daemonset deployment.

            kubectl get pods -n amazon-cloudwatch
