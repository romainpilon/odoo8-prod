FROM tahitiwebdesign/centos7-without-systemd
LABEL maintainer="dev@tahitiwebdesign.com"

ENV ODOO_RPM_URL https://nightly.odoo.com/8.0/nightly/rpm/odoo_8.0.20171001.noarch.rpm
ENV ODOO_CFG /etc/odoo/openerp-server.conf
ENV WKHTMLTOX_URL https://github.com/wkhtmltopdf/packaging/releases/download/0.12.1.4-2/wkhtmltox-0.12.1.4-2.centos7.x86_64.rpm

# Installation de la locale FR
RUN localedef -i fr_FR -f UTF-8 fr_FR.UTF-8;

# Installation des dependances centos et odoo
RUN yum -y swap -- remove fakesystemd -- install systemd systemd-libs && \
	yum clean all && yum -y update && yum -y install epel-release && \
	yum -y update && yum -y install python-gevent tree less vim \
	python-pip python-devel git libjpeg-devel libtiff-devel gcc \
	libxslt-devel libxml2-devel graphviz openldap-devel postgresql;

COPY ./entrypoint.sh /

# Installation de xlwt pour python et les rapport excel
RUN pip install xlwt

# Installation de odoo
# et creation du repertoire des addons metier
RUN curl -o odoo.rpm $ODOO_RPM_URL && yum -y install odoo.rpm && \
	mkdir -p /mnt/extra-addons && chown -R odoo:odoo /mnt/extra-addons && \
        mkdir -p /var/log/odoo && chown -R odoo:odoo /var/log/odoo;

# Installation de wkhtmltox 0.12.1
RUN curl -Lo wkhtmltox.rpm $WKHTMLTOX_URL && \
	yum -y localinstall wkhtmltox.rpm && \
	ln -s /usr/local/bin/wkhtmltopdf /usr/bin/wkhtmltopdf;

EXPOSE 8069 8071

VOLUME ["/etc/odoo", "/var/lib/odoo", "/var/log/odoo/", "/mnt/extra-addons"]

HEALTHCHECK --interval=1m --timeout=30s \
CMD curl -f http://localhost:8069 || exit 1

USER odoo

ENTRYPOINT ["/entrypoint.sh"]

CMD ["openerp-server", "-c", "/etc/odoo/openerp-server.conf"]
