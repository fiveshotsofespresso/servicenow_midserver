
# servicenow_midserver

#### Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with servicenow_midserver](#setup)
    * [What servicenow_midserver affects](#what-servicenow_midserver-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with servicenow_midserver](#beginning-with-servicenow_midserver)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)

## Description

This Puppet module configures and installs a ServiceNow MID Server on Windows 2012 R2 and Windows 2016 servers

## Setup

### Setup Requirements

The servicenow_midserver module requires the [ianoberst-xml_fragment module](https://forge.puppet.com/ianoberst/xml_fragment) (version 1.0.2)

### Beginning with servicenow_midserver

```puppet
class { 'servicenow_midserver':
  midserver_source        => 'https://install.service-now.com/glide/distribution/builds/package/mid/2018/03/19/mid.istanbul-09-23-2016__patch11a-03-13-2018_03-19-2018_0958.windows.x86-64.zip',
  midserver_name          => 'Discovery_MID1',
  midserver_install_dir   => 'D:/ServiceNow/',
  servicenow_username     => 'foo',
  servicenow_password     => 'bar',
  servicenow_url          => 'https://myinstance.service-now.com/',
}
```

## Usage

### Specify java heap max or max threads

```puppet
class { 'servicenow_midserver':
  midserver_source        => 'https://install.service-now.com/glide/distribution/builds/package/mid/2018/03/19/mid.istanbul-09-23-2016__patch11a-03-13-2018_03-19-2018_0958.windows.x86-64.zip',
  midserver_name          => 'Discovery_MID1',
  midserver_install_dir   => 'D:/ServiceNow/',
  servicenow_username     => 'foo',
  servicenow_password     => 'bar',
  servicenow_url          => 'https://myinstance.service-now.com/',
  midserver_java_heap_max => 4096,
  midserver_max_threads   => 200,
}
```

## Reference

### Classes

#### Public classes

* servicenow_midserver: Main class, includes all other classes.

#### Private classes

* servicenow_midserver::install: Handles downloading the MID Server ZIP and extracting it to the right location.
* servicenow_midserver::config: Handles the MID Server configuration file.
* servicenow_midserver::service: Handles the MID Server service.

### Parameters

The following parameters are available in the `servicenow_midserver` class:

#### `midserver_source`

Required.

Data type: String.

Specifies a URL that a MID Server ZIP file can be downloaded from

#### `midserver_name`

Required.

Data type: String

Specifies the desired MID Server name

#### `midserver_install_dir`

Required.

Data type: String

Specifies the folder to install the MID Server in. ServiceNow reccomends a folder called 'ServiceNow' in the root of a drive (D:/ServiceNow/)

#### `servicenow_url`

Required.

Data type: String

Specifies the URL of your ServiceNow instance

#### `servicenow_username`

Required.

Data type: String.

Specifies a username (assigned the mid_server role in ServiceNow) 

#### `servicenow_username`

Required.

Data type: String.

Specifies the password associated with the user defined in servicenow_username

#### `midserver_java_heap_max`

Optional.

Data type: Integer.

Specifies the maximum size the heap of the JVM process running your MID Server can grow to (in MB)

Default: 1024

#### `midserver_max_threads`

Optional.

Data type: Integer

Specifies a maximum number of threads your MID Server can handle at once

Default: 25

## Limitations

Compatible with Windows Server 2012 R2 and Windows Server 2016.

Only handles one MID Server per node.

Password must be left unencrypted on the MID Server itself, or it will constantly be trying to overwrite the encrypted value. Password may, of course, still be encrypted through EYAML and unencrypted through a Hiera lookup in your manifest.

The lifecycle of a ServiceNow MID Server is largely handled by ServiceNow once initially installed. Upgrades are orchestrated by ServiceNow and changes to the configuration file (like changing the maximum number of threads will stay in place).

## Future

* Add parameters and configuration for when MID Server sits behind proxy
* Create defined type rather than a class so that multiple MID Servers can exist on one node
* Figure out a way to allow encryption of the password on the MID Server itself