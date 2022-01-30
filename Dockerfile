FROM tomcat:8
# Take the war and copy to webapps of tomcat and this is new one sections for
COPY target/*.war /usr/local/tomcat/webapps/dockeransible.war
