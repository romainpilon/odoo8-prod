# Odoo8-prod

Environnement Odoo 8 à base de [Centos 7](https://hub.docker.com/r/tahitiwebdesign/centos7-without-systemd).
Les variables d'environnement suivantes sont nécessaires pour lancer correctement un container:

* `DB_ADDR` pour l'adresse vers la BDD
* `DB_PORT` pour le port vers la BDD
* `DB_USER` pour le nom d'utilisateur pour accéder à la BDD
* `DB_PASSWORD` pour le mot de passe de l'utilisateur pour accéder à la BDD

Cette image s'attend à trouver le fichier suivant:

```
/etc/odoo/openerp-server.conf
```

Par défaut, l'image va tenter de se connecter à la BDD suivante:

```
adresse: db
nom d'utilisateur: odoo
mot de passe utilisateur: odoo
```

Il est possible de monter les volumes suivants:

* `/etc/odoo` pour le fichier de config openerp-server.conf
* `/var/lib/odoo` pour le filestore Odoo
* `/var/log/odoo` pour le fichier de log odoo-server.log 
* `/mnt/extra-addons` pour les modules métier et leurs dépendances

Exemple d'utilisation:

```
docker run -d -p 80:8069 -p 8072:8072 -v /odoo/config:/etc/odoo \
           -v /odoo/log:/var/log/odoo -v /odoo/addons:/mnt/extra-addons \
		   -e DB_ADDR=localhost -e DB_PORT=5432 -e DB_USER=odoo \
		   -e DB_PASSWORD=odoo tahitiwebdesign/odoo8-prod
```


