# Modulus Java Docker Run Image
The Modulus images are a set of Docker images designed to run arbitrary applications with a standardized external interface. The Modulus image convention enforces a high degree of security and control required by PaaS environments and might not be suitable for small, more focused, deployments.

Refer to the [base run image](https://github.com/onmodulus/docker-run-base) for details on how all Modulus Run Images work.

## Image Details
The Modulus Java image supports OpenJDK 7 and 8 and Tomcat 7 and 8 and handles initializing the correct version as part of its start process. The Java and Tomcat versions can be defined in the app bundle's [app.json](http://help.modulus.io/customer/portal/articles/1967537-app-json-specification) file. If no version is specified OpenJDK and Tomcat version 7 are used.

## How to use this image
All Modulus images enforce a strict data convention for security and ease of orchestration. Application source should be mounted in externally and assumptions are made based on these directories.

``` text
/host-folder/
  |- app/
  |- home/
  |- log/
  |- tmp/
  |- supervisor.conf
```

The only requirement for a basic running container is to put the Java war file in the app folder. Then mount this directory to /mnt inside the container.

``` text
$ docker pull onmodulus/run-java
$ docker run -v /host-folder:/mnt -p 80:8080 onmodulus/run-java start
```

All Modulus run images have a binary available in the PATH named "start" that is a script designed to run the inner application. The start script is the most important part of each image type and is what's responsible for properly running the underlying application.

The start script in the Java run image handles initializing the proper version of Java and Tomcat.

Even though you can run the start script directly, Modulus has adopted supervisord as the underlying process monitor for all application types. The supervisor daemon is preconfigured in all run images to load /mnt/supervisor.conf. The high-level Modulus tools generate this configuration file to support passing environment variables into the application and redirect all log output to /mnt/log/app.log. The supervisor daemon is already baked into the underlying run image init process, so you can run the image directly once a supervisor.conf file is provided.

```text
[program:app]
command=start
environment=
  PORT=8080,
  NODE_ENV=production
stdout_logfile=/mnt/log/app.log
```

Save this to /host-folder/supervisor.conf and run the container.

``` text
$ docker run -v /host-folder:/mnt -p 80:8080 onmodulus/run-java
```

# License
Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
