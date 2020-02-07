#!/usr/bin/env bash
set -e

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

source ${CURRENT_DIR}/utils.sh

#################################################################################################
########################################### NextDom Steps #######################################
#################################################################################################

step0_prepare_prerequisites() {

  result=true

  # IMPORTANT : keep  ${LOG_DIRECTORY} created first ! the info log is done once it's created
  { ##try
    mkdir -p ${LOG_DIRECTORY}
  } || { ##catch
    echo -e "${RED}${CURRENT_DATE} ERROR : Unable to create ${LOG_DIRECTORY} ${NORMAL}"
    return 0
  }

  addLogStep "Preinst -- Prepare and check prerequisites - 0/7"

  for dir in ${CONFIG_DIRECTORY} ${LIB_DIRECTORY} ${ROOT_DIRECTORY} ${TMP_DIRECTORY}
   do
       createDirectory ${dir}
  done
  addLogInfo "Local needed directories checked"

  if [ "localhost" == "${MYSQL_HOSTNAME}" ] || [ "$(hostname -I)" == "${MYSQL_HOSTNAME}" ]; then
    addLogInfo "Local mysql server detected"
    startService mysql
    addLogInfo "MySQL/MariaDB service started"
    checkMySQLIsRunning
  fi
  { ##try
    unset command_not_found_handle
    php --ini | head -n 1 | sed -E "s/.*Path: (.*)\/cli/\\1/"

    if [ "$?" -eq 127 ]; then
        addLogError "PHP is not installed"
        return 0
    fi
    addLogInfo "PHP detected"
    startService apache2
    addLogInfo "Apache2 service started"
    startService cron
    addLogInfo "Cron service started"
    set command_not_found_handle
  } || {
    addLogError "PHP is not installed"
  }

  if [ "true" == "${result}" ]; then
    addLogSuccess "Prerequisites are checked with success"
  fi
}

step1_generate_nextdom_assets() {

  result=true

  addLogStep "Preinst -- Generate Assets - 1/7"
  # Generate CSS files
    # A faire dans une version developpeur (apres git clone)
    if [ ! -f ${ROOT_DIRECTORY}/vendor ]; then
      { ##try
        cd ${ROOT_DIRECTORY}
        ./scripts/gen_composer_npm.sh
      } || { ##catch
        addLogError "error during composer and npm initialize"
      }
    fi
    { ##try
      cd ${ROOT_DIRECTORY}
      ./scripts/gen_global.sh
    } || { ##catch
      addLogError "error during asset generation"
    }
    addLogInfo "installed nodejs"
    addLogInfo "installed composer manager"
    addLogInfo "installed project dependencies"
    addLogInfo "copied icons, themes and images from assets"
    addLogInfo "generated css files"
    addLogInfo "generated javascript files"
  if [ "true" == "${result}" ]; then
    addLogSuccess "Assets are generated with success"
  fi
}

step2_configure_mysql() {
  # check that mysql is locally installed before any further configuration
  # default value for mysql_host is localhost
  result=true

  addLogStep "Preinst -- Configure MySQL/MariaDB - 2/7"

  if [ "localhost" != "${MYSQL_HOSTNAME}" ] && [ "$(hostname)" != "${MYSQL_HOSTNAME}" ] && [ "$(hostname -I)" != "${MYSQL_HOSTNAME}" ]; then
    addLogInfo "Remote mysql server detected"
    return 0
  fi

  { ##try
    mysqlStatus=$(pgrep mysql | wc -l)
    if [ "${mysqlStatus}" -eq 0 ]; then
      addLogInfo "no mysql service locally"
      return 0
    fi
  } || { ##catch
    addLogError "Error while checking mysql status"
  }

  stopService mysql

  { ##try
    rm -f /var/lib/mysql/ib_logfile*
  } || { ##catch
    addLogError "Error while cleaning mysql data"
  }

  { ##try
    if [ -d /etc/mysql/conf.d ]; then
      cat - >/etc/mysql/conf.d/nextdom_my.cnf <<EOS
[mysqld]
skip-name-resolve
key_buffer_size = 16M
thread_cache_size = 16
tmp_table_size = 48M
max_heap_table_size = 48M
query_cache_type =1
query_cache_size = 32M
query_cache_limit = 2M
query_cache_min_res_unit=3K
innodb_flush_method = O_DIRECT
innodb_flush_log_at_trx_commit = 2
innodb_log_file_size = 32M
EOS
    fi
    addLogInfo "created nextdom mysql configuration: /etc/mysql/conf.d/nextdom_my.cnf"
  } || { ##catch
    addLogError "Error while creating /etc/mysql/conf.d/nextdom_my.cnf"
  }

  startService mysql

  if [ "true" == "${result}" ]; then
    addLogSuccess "MySQL is configured with success"
  fi
}

step3_prepare_var_www_html() {
  result=true

  addLogStep "Preinst -- Prepare ${APACHE_HTML_DIRECTORY}- 3/7"

  if [ "${ROOT_DIRECTORY}" == "${APACHE_HTML_DIRECTORY}" ]; then
    addLogInfo "No links to build"
    return 0
  fi

  { ##try
    # moving any content of /var/www/html to /var/www/html.XXXXXXXX
    if [ -d "${APACHE_HTML_DIRECTORY}" ]; then
      count="$(find ${APACHE_HTML_DIRECTORY} -mindepth 1 -maxdepth 1 | wc -l)"
      if [ $count -gt 0 ]; then
        tmpd="$(mktemp -d -u ${APACHE_HTML_DIRECTORY}.XXXXXXXX)"
        mv "${APACHE_HTML_DIRECTORY}" "${tmpd}"
        addLogInfo "warning : directory ${APACHE_HTML_DIRECTORY} isn't empty, renamed to ${tmpd}"
      fi
    fi
  } || { ##catch
    addLogError "Error while moving any content of ${APACHE_HTML_DIRECTORY} to ${APACHE_HTML_DIRECTORY}.XXXXXXXX"
  }
  { ##try
    # rename any pre-exiting link
    if [ -L "${APACHE_HTML_DIRECTORY}" ]; then
      dest=$(readlink "${APACHE_HTML_DIRECTORY}")
      if [ "${dest}" == "${ROOT_DIRECTORY}" ]; then
        rm -f "${APACHE_HTML_DIRECTORY}"
      else
        tfile="$(mktemp -u ${APACHE_HTML_DIRECTORY}.XXXXXXXX)"
        cd /var/www/
        mv "${APACHE_HTML_DIRECTORY}" "${tfile}"
        addLogInfo "warning : directory ${APACHE_HTML_DIRECTORY} is a link, renamed it ${tfile}"
      fi
    fi
  } || { ##catch

    addLogError "Error while renaming ${APACHE_HTML_DIRECTORY} to ${APACHE_HTML_DIRECTORY}.XXXXXXXX"
  }
  { ##try
    # strange but why not
    if [ -f "${APACHE_HTML_DIRECTORY}" ]; then
      tfile=$(mktemp -u ${APACHE_HTML_DIRECTORY}.XXXXXXXX)
      mv "${APACHE_HTML_DIRECTORY}" "${tfile}"
      addLogInfo "warning : ${APACHE_HTML_DIRECTORY} is a file, renamed it ${tfile}"
    fi
  } || { ##catch
    addLogError "Error while moving ${APACHE_HTML_DIRECTORY} to ${APACHE_HTML_DIRECTORY}.XXXXXXXX"
  }

  if [ "true" == "${result}" ]; then
    addLogSuccess "${APACHE_HTML_DIRECTORY} is prepared with success"
  fi

}

step4_configure_apache() {
  # These prerequistes are instaled by nextdom-common or nextdom-minimal package,
  # but this part is for other distribution compatibility
  result=true

  addLogStep "Preinst -- Configure Apache - 4/7"

  if [ ! -d "${APACHE_CONFIG_DIRECTORY}" ]; then
    addLogError "apache is not installed"
  fi

  if [ -d ${LOG_DIRECTORY} ]; then
    createDirectory ${LOG_DIRECTORY}
  fi

  for c_file in nextdom.conf nextdom-ssl.conf nextdom-common; do
    if [ ! -f ${APACHE_CONFIG_DIRECTORY}/${c_file} ]; then
      { ##try
        cp "${ROOT_DIRECTORY}/install/apache/"/${c_file} ${APACHE_CONFIG_DIRECTORY}/${c_file}
        addLogInfo "created file: ${APACHE_CONFIG_DIRECTORY}/${c_file}"
      } || { ##catch
        addLogError "Error while creating file: ${APACHE_CONFIG_DIRECTORY}/${c_file}"
      }
    fi
    if [ ${APACHE_HTML_DIRECTORY} != "/usr/share/nextdom" ]; then
      { ##try
        sed -i "s%/usr/share/nextdom%${APACHE_HTML_DIRECTORY}%g" ${APACHE_CONFIG_DIRECTORY}/${c_file}
        addLogInfo "updated wwwdir in : ${APACHE_CONFIG_DIRECTORY}/${c_file}"
      } || { ##catch
        addLogError "Error while updating wwwdir in : ${APACHE_CONFIG_DIRECTORY}/${c_file}"
      }
    fi
    if [ ${LOG_DIRECTORY} != "/var/log/nextdom" ]; then
      { ##try
        sed -i "s%/var/log/nextdom%${LOG_DIRECTORY}%g" ${APACHE_CONFIG_DIRECTORY}/${c_file}
        addLogInfo "updated logdir in : ${APACHE_CONFIG_DIRECTORY}/${c_file}"
      } || { ##catch
        addLogError "Error while updating logdir in : ${APACHE_CONFIG_DIRECTORY}/${c_file}"
      }
    fi
  done

  { ##try
    # Configure private tmp
    if [ ! -f "${APACHE_SYSTEMD_DIRECTORY}/privatetmp.conf" ]; then
      createDirectory ${APACHE_SYSTEMD_DIRECTORY}
      cp "${ROOT_DIRECTORY}/install/apache/"privatetmp.conf ${APACHE_SYSTEMD_DIRECTORY}/privatetmp.conf
      addLogInfo "created file: ${APACHE_SYSTEMD_DIRECTORY}/privatetmp.conf"
    fi
  } || { ##catch
    addLogError "Error while creating file: ${APACHE_SYSTEMD_DIRECTORY}/privatetmp.conf"
  }

  # Certificat SSL auto signe
  if [ -d ${CONFIG_DIRECTORY} ]; then
    if [ ! -f ${CONFIG_DIRECTORY}/ssl/nextdom.crt ] || [ ! -f ${CONFIG_DIRECTORY}/ssl/nextdom.csr ] || [ ! -f ${CONFIG_DIRECTORY}/ssl/nextdom.key ]; then
      createDirectory ${CONFIG_DIRECTORY}/ssl/
      goToDirectory ${CONFIG_DIRECTORY}/ssl/
      { ##try
        openssl genrsa -out nextdom.key 2048
        openssl req -new -key nextdom.key -out nextdom.csr -subj "/C=FR/ST=Paris/L=Paris/O=Global Security/OU=IT Department/CN=example.com"
        openssl x509 -req -days 3650 -in nextdom.csr -signkey nextdom.key -out nextdom.crt
        addLogInfo "created SSL self-signed certificates in /etc/nextdom/ssl/"
      } || { ##catch
        addLogError "Error while creating SSL self-signed certificates in /etc/nextdom/ssl/"
      }
    fi
  fi

  if [ "true" == "${result}" ]; then
    addLogSuccess "Apache is configured with success"
  fi
}

step5_configure_mysql_database() {
  # Debian package configuration...
  # nextdom-mysql preconfiguration
  result=true

  addLogStep "Preinst -- Configure MySQL/MariaDB - 5/7"
  if [ "localhost" != "${MYSQL_HOSTNAME}" ] && [ "$(hostname)" != "${MYSQL_HOSTNAME}" ] && [ "$(hostname -I)" != "${MYSQL_HOSTNAME}" ]; then
    addLogInfo "Remote mysql server detected"
    return 0
  fi

  if [ -f ${CONFIG_DIRECTORY}/mysql/secret ]; then
    source ${CONFIG_DIRECTORY}/mysql/secret
  elif [ -z ${MYSQL_NEXTDOM_PASSWD} ] || [ "#MYSQL_NEXTDOM_PASSWD#" == "${MYSQL_NEXTDOM_PASSWD}" ] || [ "" == "${MYSQL_NEXTDOM_PASSWD}" ]; then
    setNextdomPasswordForMySQL
  fi

  #MYSQL_NEXTDOM_PASSWD=${MYSQL_NEXTDOM_PASSWD:-$(cat /dev/urandom | tr -cd 'a-f0-9' | head -c 15)}
  #MYSQL_HOSTNAME=${MYSQL_HOSTNAME:-localhost}
  #MYSQL_PORT=${MYSQL_PORT:-3306}
  #MYSQL_NEXTDOM_DB=${MYSQL_NEXTDOM_DB:-nextdom}
  #MYSQL_NEXTDOM_USER=${MYSQL_NEXTDOM_USER:-nextdom}

  # All parameters
  MYSQL_OPTIONS=""
  if [ -n "${MYSQL_ROOT_PASSWD}" ]; then
    MYSQL_OPTIONS="${MYSQL_OPTIONS} -p${MYSQL_ROOT_PASSWD}"
  fi
  if [ -n "${MYSQL_HOSTNAME}" ]; then
    MYSQL_OPTIONS="${MYSQL_OPTIONS} -h${MYSQL_HOSTNAME}"
  fi
  if [ -n "${MYSQL_PORT}" ]; then
    MYSQL_OPTIONS="${MYSQL_OPTIONS} --port=${MYSQL_PORT}"
  fi

  { ##try
    checkMySQLIsRunning ${MYSQL_OPTIONS}
  } || { ##catch
    addLogError "MySQL/MariaDB is not running"
  }

  if [ "true" == "${result}" ]; then
    addLogSuccess "MySQL/MariaDB is configured with success"
  fi
}

step6_generate_mysql_structure() {
  result=true

  addLogStep "Preinst -- Generate MySQL/MariaDB structure - 6/7"

  CONSTRAINT="%"
  if [ ${MYSQL_HOSTNAME} == "localhost" ]; then
    CONSTRAINT='localhost'
  fi
  { ##try
    QUERY="DROP USER IF EXISTS '${MYSQL_NEXTDOM_USER}'@'${CONSTRAINT}';"
    mysql -uroot -h${MYSQL_HOSTNAME} ${HOSTPASS} -e "${QUERY}"
    addLogInfo "deleted mysql user: ${MYSQL_NEXTDOM_USER}"
  } || { ##catch

    addLogError "Error while deleting user : ${MYSQL_NEXTDOM_USER}"
  }
  { ##try
    QUERY="CREATE USER '${MYSQL_NEXTDOM_USER}'@'${CONSTRAINT}' IDENTIFIED BY '${MYSQL_NEXTDOM_PASSWD}';"
    mysql -uroot -h${MYSQL_HOSTNAME} ${HOSTPASS} -e "${QUERY}"
    addLogInfo "created mysql user: ${MYSQL_NEXTDOM_USER}"
  } || { ##catch
    addLogError "Error while creating user : ${MYSQL_NEXTDOM_USER}"
  }
  { ##try
    QUERY="DROP DATABASE IF EXISTS ${MYSQL_NEXTDOM_DB};"
    mysql -uroot -h${MYSQL_HOSTNAME} ${HOSTPASS} -e "${QUERY}"
    addLogInfo "deleted mysql table: ${MYSQL_NEXTDOM_DB}"
  } || { ##catch
    addLogError "Error while deleting table : ${MYSQL_NEXTDOM_DB}"
  }
  { ##try
    QUERY="CREATE DATABASE ${MYSQL_NEXTDOM_DB};"
    mysql -uroot -h${MYSQL_HOSTNAME} ${HOSTPASS} -e "${QUERY}"
    addLogInfo "created mysql table: ${MYSQL_NEXTDOM_DB}"
  } || { ##catch
    addLogError "Error while creating table : ${MYSQL_NEXTDOM_DB}"
  }
  { ##try
    QUERY="GRANT ALL PRIVILEGES ON ${MYSQL_NEXTDOM_DB}.* TO '${MYSQL_NEXTDOM_USER}'@'${CONSTRAINT}';"
    mysql -uroot -h${MYSQL_HOSTNAME} ${HOSTPASS} -e "${QUERY}"
  } || { ##catch
    addLogError "Error while granting privileges on : ${MYSQL_NEXTDOM_DB}"
  }
  { ##try
    QUERY="FLUSH PRIVILEGES;"
    mysql -uroot -h${MYSQL_HOSTNAME} ${HOSTPASS} -e "${QUERY}"
    addLogInfo "configured table privileges: ${MYSQL_NEXTDOM_DB}"
  } || { ##catch
    addLogError "Error while flushing privileges"
  }

  if [ "true" == "${result}" ]; then
    addLogSuccess "Database structure generated with success"
  fi
}

step7_configure_php() {
  result=true

  addLogStep "Preinst -- Configure PHP - 7/7"

  { ##try
    PHP_DIRECTORY=$(php --ini | head -n 1 | sed -E "s/.*Path: (.*)\/cli/\\1/")
  } || { ##catch
    addLogError "PHP is not installed"
  }

  { ##try
    removeDirectoryOrFile ${ROOT_DIRECTORY}/assets/config/default.config.ini
  } || { ##catch
    addLogError "Error while removing default.config.ini file"
  }
  { ##try
    removeDirectoryOrFile ${PHP_DIRECTORY}/apache2/conf.d/10-opcache.ini
  } || { ##catch
    addLogError "Error while removing 10-opcache.ini file"
  }

  if [ "true" == "${PRODUCTION}" ]; then
    addLogInfo "production mode"
    { ##try
      cp -f ${ROOT_DIRECTORY}/assets/config/dist/default.config.ini.dist ${ROOT_DIRECTORY}/assets/config/default.config.ini
    } || { ##catch
      addLogError "Error while copying default.config.ini file"
    }
    addLogInfo "enable PHP opcache"
    { ##try
      cp -f ${ROOT_DIRECTORY}/assets/config/dist/opcache.ini.dist ${PHP_DIRECTORY}/apache2/conf.d/10-opcache.ini
    } || { ##catch
      addLogError "Error while copying 10-opcache.ini file"
    }
  else
    addLogInfo "development mode"
    { ##try
      cp -f ${ROOT_DIRECTORY}/assets/config/dist/default.config.ini.dev ${ROOT_DIRECTORY}/assets/config/default.config.ini
    } || { ##catch
      addLogError "Error while copying default.config.ini file"
    }
    addLogInfo "disable PHP opcache"
    { ##try
      cp -f ${ROOT_DIRECTORY}/assets/config/dist/opcache.ini.dev ${PHP_DIRECTORY}/apache2/conf.d/10-opcache.ini
    } || { ##catch
      addLogError "Error while copying 10-opcache.ini file"
    }
  fi
  addLogInfo "restart Apache"
  { ##try
    restartService apache2
  } || { ##catch
    addLogError "Error while restarting apache2"
  }

  if [ "true" == "${result}" ]; then
    addLogSuccess "PHP is configured with success"
  fi
}

#################################################################################################
############################################# Installation ######################################
#################################################################################################

preinstall_nextdom() {

  if [ $(id -u) != 0 ]; then
    addLogError "Les droits de super-utilisateur (root) sont requis pour installer NextDom\
        Veuillez lancer sudo $0 ou connectez-vous en tant que root, puis relancez $0"
    exit 1
  fi

  step0_prepare_prerequisites

  addLogScript "============ Starting preinst.sh ============"

  step1_generate_nextdom_assets
  step2_configure_mysql
  step3_prepare_var_www_html
  step4_configure_apache
  step5_configure_mysql_database
  step6_generate_mysql_structure
  step7_configure_php

  addLogScript "============ Preinst.sh is executed ... ============"

}

preinstall_nextdom

exit 0