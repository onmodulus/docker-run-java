FROM onmodulus/image-run-base:0.0.1

ADD . /opt/modulus
ENV PATH=/opt/modulus/bin:$PATH

RUN /opt/modulus/bootstrap.sh

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]
