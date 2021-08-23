####
# This Dockerfile is used in order to build a container that runs the Quarkus application in JVM mode
#
# Before building the container image run:
#
# ./mvnw package
#
# Then, build the image with:
#
# docker build -f src/main/docker/Dockerfile.jvm -t gkovan/ztsc-quarkus-hello-service-jvm .
#
# Then run the container using:
#
# docker run -i --rm -p 8080:8080 gkovan/ztsc-quarkus-hello-service-jvm
#
# If you want to include the debug port into your docker image
# you will have to expose the debug port (default 5005) like this :  EXPOSE 8080 5005
#
# Then run the container using :
#
# docker run -i --rm -p 8080:8080 -p 5005:5005 -e JAVA_ENABLE_DEBUG="true" gkovan/ztsc-quarkus-hello-service-jvm
#
###
#FROM registry.access.redhat.com/ubi8/ubi-minimal:8.3 
FROM docker.io/gkovan/ztsc-base-quarkus-image:368c513 
LABEL base.image="docker.io/gkovan/ztsc-base-quarkus-image:368c513"
# Configure the JAVA_OPTIONS, you can add -XshowSettings:vm to also display the heap size.
ENV JAVA_OPTIONS="-Dquarkus.http.host=0.0.0.0 -Djava.util.logging.manager=org.jboss.logmanager.LogManager"
# We make four distinct layers so if there are application changes the library layers can be re-used
COPY --chown=1001 target/quarkus-app/lib/ /deployments/lib/
COPY --chown=1001 target/quarkus-app/*.jar /deployments/
COPY --chown=1001 target/quarkus-app/app/ /deployments/app/
COPY --chown=1001 target/quarkus-app/quarkus/ /deployments/quarkus/

EXPOSE 8080
USER 1001

ENTRYPOINT [ "/deployments/run-java.sh" ]
