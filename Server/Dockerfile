FROM mcr.microsoft.com/dotnet/framework/aspnet:4.7.2-windowsservercore-ltsc2019

# copy InnovatorSetup.msi
COPY ["Setup/InnovatorSetup.msi", "C:/Setup/"]
COPY ["Setup/init.bat", "C:/Setup/"]

# adding ASP.NET Core 8.0.18 Runtime Hosting Bundle as it is a requirement for the latest Aras version on the website (Aras Release 2025)
ADD "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.18/dotnet-hosting-8.0.18-win.exe" "C:\Setup\dotnet-hosting.exe"

#download SQL server installation files
ADD "https://download.microsoft.com/download/7/c/1/7c14e92e-bdcb-4f89-b7cf-93543e7112d1/SQLServer2019-DEV-x64-ENU.box" "C:\Setup\SQLServer2019-DEV-x64-ENU.box"
ADD "https://download.microsoft.com/download/7/c/1/7c14e92e-bdcb-4f89-b7cf-93543e7112d1/SQLServer2019-DEV-x64-ENU.exe" "C:\Setup\SQLServer2019-DEV-x64-ENU.exe"

# expose port 80 for webserver and 1433 for sql
EXPOSE 1433
EXPOSE 80

# install ASP.NET Core/.NET Core Runtime and Hosting Bundle as it is required for OAuth
RUN C:\Setup\dotnet-hosting.exe /quiet /install /l*v C:\Setup\LogFile.log

# install SQL Server 2019 via command line, set shell to cmd beforehand as somehow otherwise Docker uses Powershell which causes the SQL Server Installation to fail
SHELL ["cmd", "/S /C"]
RUN C:/Setup/SQLServer2019-DEV-x64-ENU.exe /Q /ACTION=INSTALL /FEATURES=SQLENGINE /INSTANCENAME=MSSQLSERVER /SECURITYMODE=SQL /SAPWD="YRQsxj*7i!NQdk" /SQLSVCACCOUNT="NT AUTHORITY\System" /AGTSVCACCOUNT="NT AUTHORITY\System" /SQLSYSADMINACCOUNTS="BUILTIN\Administrators" /IACCEPTSQLSERVERLICENSETERMS=1 /TCPENABLED=1 /UPDATEENABLED=False

# set SQL Server service to automatic
RUN powershell -Command (Set-Service MSSQLSERVER -StartupType Automatic)

# install clean aras
RUN msiexec.exe /i "C:\\Setup\\InnovatorSetup.msi" /qn /norestart /log "C:\\Setup\\InnovatorSetupLog.log" INSTALLDIR="C:\\Innovator" UPGRADEORINSTALL=1 WEBALIAS="Innovator" SMTPSERVER=queue VAULTNAME=InnovatorDb VAULTFOLDER="C:\\Innovator\\Vault" DB_CREATE_NEW_OR_USE_EXISTING=0 IS_SQLSERVER_SERVER="127.0.0.1" IS_SQLSERVER_DATABASE=InnovatorDb IS_SQLSERVER_AUTHENTICATION=1 IS_SQLSERVER_USERNAME=sa IS_SQLSERVER_PASSWORD=YRQsxj*7i!NQdk SQL_SERVER_LOGIN_NAME=innovator SQL_SERVER_LOGIN_PASSWORD=YRQsxj*7i!NQdk SQL_SERVER_LOGIN_REGULAR_NAME=innovator_regular SQL_SERVER_LOGIN_REGULAR_PASSWORD=YRQsxj*7i!NQdk INSTALL_CONVERSION_SERVER=1 CONVERSION_SERVER_NAME="ConversionServer" CONVERSION_SERVER_APP_URL="http://localhost/Innovator/Server/InnovatorServer.aspx" INSTALL_AGENT_SERVICE=1 ARAS_AGENTSERVICE_TO_INNOVATORSERVER_URL="http://localhost/Innovator/Server/InnovatorServer.aspx" INNOVATOR_TO_SERVICE_ADDRESS="http://localhost:8734/ArasInnovatorAgent" AS_FOLDER="ArasInnovatorAgent"

# enable redirect feature as it is required
SHELL ["powershell", "-Command"]
RUN Enable-WindowsOptionalFeature -Online -FeatureName IIS-HttpRedirect

# copy InnovatorServerConfig.xml -> Attention: make sure that you enter a valid license key in the InnovatorServerConfig.xml
# otherwise Aras Innovator will not work
# a license key for your mac address and Aras version can be requested here: https://aras.com/en/support/licensekeyservice/community-edition?version=14.0.0 
COPY ["Setup/InnovatorServerConfig.xml", "C:/Innovator/"]

