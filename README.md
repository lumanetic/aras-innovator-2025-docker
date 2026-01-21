# aras-innovator-2025-docker
Creates an Aras Innovator Community Edition 2025 Docker image ready to use for testing and development purposes.

Before building the image, make sure you add a valid license to be able to use the Aras Innovator installation by following these steps:

<ol>
  <li>Request an Aras Innovator Community Edition 2025 framework license from Aras: https://aras.com/en/support/licensekeyservice/community-edition?version=14.0.0.</li>
  <li>Provide the Docker Container mac_address in the docker-compose.yml so that it matches your Aras license key. The MAC address must be in Docker's assigned range, use range from 02:42:ac:11:00:00 to 02:42:ac:11:ff:ff. Mac Address must match your License Key you specify in the InnovatorServerConfig.xml</li>
  <li>Open the InnovatorServerConfig.xml file in the Server/Setup folder and replace the dummy License tag with your License you received from Aras</li>
</ol>

After that, execute the following command to build and start your Aras Innovator Docker environment:

```
docker-compose up -d
```

The Aras Innovator instance is available under the following link: http://localhost/innovator

You can log in to the Innovator instance using the default users "admin" or "root" with the password "innovator".

>[!WARNING]
>The initial container deployment is NOT configured for persistent storage. To retain configurations and data, use the following guide to set up persistent storage using Docker bind mount.


<ol>
  <li>Add the following lines to docker-compose.yml in the "server:" section. You can use use any host location to bind to, example uses C:\Aras\Volumes.</li>

  ``` 
  Volumes:
    - C:\Aras\Volumes\Innovator:c:\innovator_data_tmp:RW
    - C:\Aras\Volumes\SQL:c:\mssql_data_tmp:RW
  ```

  <li> Run:

  ```
  docker-compose up -d
  ```
  </li>
  <li>From docker desktop, navigate to deployed container and launch Exec</li>
  <li>Run: 

  ```C:\Setup\init.bat```

  This script will copy Aras and SQL data into the mounted volumes.</li>

  <li>Stop and delete the container and revise the docker-compose.yml to point the host mount to the actual Aras and SQL locations. When mounted, container data will be obsecured or written over with the host mount data copied into the volumes during the previous step.</li>

  ``` 
  Volumes:
    - C:\Aras\Volumes\Innovator:c:\Innovator:RW
    - C:\Aras\Volumes\SQL:c:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\:RW
  ```
  
</ol>
