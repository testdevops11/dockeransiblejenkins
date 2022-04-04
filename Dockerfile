FROM tomcat:8
# Take the war and copy to webapps of tomcat this is new adding for
COPY target/*.war /usr/local/tomcat/webapps/dockeransible.war
