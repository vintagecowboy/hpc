# HPC

## About

This repo contains powershell scripts, which configure MS Windows GCE Virtual
Machines (Google Cloud) as HPC Cluster worker nodes.

## Usage

### Startup Script for Windows GCE VMs

The sysprep-specialize-script.ps1 script should be modified according to the
target domain environment.

Upload the sysprep-specialize-script.ps1 to a Google Cloud Storage (GCS) bucket.

The sysprep-specialize-script.ps1 script can be configured as a specialized
startup script, which runs during sysprep, before boot [on a GCE Virtual Machine][1].
>> A new metadata key should be added to the virtual machine or managed instance
>> group template: sysprep-specialize-script-url.
>> The value should be the URL of the startup script:
>> gs://[bucket]/startup-script.ps1

It's recommended that worker nodes are configured as part of an [autoscaling,
managed instance group][2], using a [custom image][3], produced from a [preconfigured
HPC compute node][4].


### Cloud Pub/Sub HPC Tasks

QueuePubsubMsg.xml executes a GCP powershell cmdlet that publishes a message to
a Cloud Pub/Sub topic ("hpc-topic").

DequeuePubsubMsg.xml executes a GCP powershell cmdlet that subscribes to a
message on a Cloud Pub/Sub topic ("hpc-topic").

[1]: https://cloud.google.com/compute/docs/startupscript
[2]: https://cloud.google.com/compute/docs/instance-groups/creating-groups-of-managed-instances#autoscaling
[3]: https://cloud.google.com/compute/docs/instances/windows/creating-windows-os-image
[4]: https://technet.microsoft.com/en-us/library/ff919496(v=ws.11).aspx
