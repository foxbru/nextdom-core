SET FOREIGN_KEY_CHECKS=0;
DELETE FROM `user`;
DELETE FROM `eqLogic`;
DELETE FROM `cmd`;
DELETE FROM `object`;
DELETE FROM `dataStore`;
DELETE FROM `note`;
DELETE FROM `plan`;
DELETE FROM `planHeader`;
DELETE FROM `plan3d`;
DELETE FROM `plan3dHeader`;
DELETE FROM `scenario`;
DELETE FROM `scenarioElement`;
DELETE FROM `scenarioSubElement`;
DELETE FROM `scenarioExpression`;
DELETE FROM `cron`;
DELETE FROM `message`;
DELETE FROM `update`;
DELETE FROM `view`;
DELETE FROM `viewData`;
DELETE FROM `viewZone`;
DELETE FROM `widget`;
DELETE FROM `config` WHERE `key` LIKE '%object:summary%';
DELETE FROM `config` WHERE `key` LIKE '%plugin4tests%';
DELETE FROM `config` WHERE `plugin` LIKE '%plugin4tests%';
DELETE FROM `config` WHERE `key` = 'api';
DELETE FROM `config` WHERE `key` = 'nextdom::user-theme';
DELETE FROM `config` WHERE `key` = 'nextdom::user-icon';
DELETE FROM `config` WHERE `key` = 'nextdom::Welcome';
DELETE FROM `config` WHERE `key` = 'object:summary';
DELETE FROM `config` WHERE `key` = 'nextdom::firstUse';
INSERT INTO `config` VALUES ('plugin4tests','active','1'),('plugin4tests','deamonAutoMode','1'),('core','log::level::plugin4tests','{\"100\":\"1\",\"200\":\"0\",\"300\":\"0\",\"400\":\"0\",\"1000\":\"0\",\"default\":\"0\"}');
INSERT INTO `user` VALUES (1,'admin','admin','fea6ef74405b298a3fc654cfac01a3ed2e4cf010f394c0c555df15f14eed4833424545561c68461fc099843b06140ad4ba5c5694e209d30d10a5eb5b034d6a83','{\"localOnly\":\"0\",\"lastConnection\":\"\", \"registerDevice\":{\"20df7457426d7b5052ff8fdfa3b0955164ba5a91e24ad8b69c5ed632410b8b072222032a2ab291e03ed46253dfa4c13cdd15d68339f0c0b52895d0ad743e3be6\":\"1\"}}','VVZtg2HUxbE4XWStXTVWc2ONs0b0fXtt','[]',1);
INSERT INTO `user` VALUES (2,'simple','user','a72ed62e8bc9e7bbf0cbc71312bff824e91411d047bf29fd6abf31c3f4b6e8e3ee2883eec141d0fd9130fe1683f3f8a2c0f3909580c50bcf9016e3cf6249c1b8','{\"localOnly\":\"0\",\"lastConnection\":\"\"}','VVZtg2HUxbE4XWStXTVWc2ONs0b0fXtt','[]',1);
INSERT INTO `object` VALUES (1,'My Room',NULL,1,NULL,'{\"parentNumber\":0,\"tagColor\":\"#FF0000\",\"tagTextColor\":\"#FFFFFF\",\"desktop::summaryTextColor\":\"\",\"mobile::summaryTextColor\":\"\"}','[]','[]');
INSERT INTO `object` VALUES (2,'Second Room',NULL,1,NULL,'{\"parentNumber\":0,\"tagColor\":\"#000000\",\"tagTextColor\":\"#FFFFFF\",\"desktop::summaryTextColor\":\"\",\"mobile::summaryTextColor\":\"\",\"hideOnDashboard\":\"0\",\"summary::global::security\":\"0\",\"summary::global::motion\":\"0\",\"summary::global::door\":\"0\",\"summary::global::windows\":\"0\",\"summary::global::shutter\":\"0\",\"summary::global::light\":\"0\",\"summary::global::outlet\":\"0\",\"summary::global::temperature\":\"0\",\"summary::global::humidity\":\"0\",\"summary::global::luminosity\":\"0\",\"summary::global::power\":\"0\",\"summary::hide::desktop::security\":\"0\",\"summary::hide::desktop::motion\":\"0\",\"summary::hide::desktop::door\":\"0\",\"summary::hide::desktop::windows\":\"0\",\"summary::hide::desktop::shutter\":\"0\",\"summary::hide::desktop::light\":\"0\",\"summary::hide::desktop::outlet\":\"0\",\"summary::hide::desktop::temperature\":\"0\",\"summary::hide::desktop::humidity\":\"0\",\"summary::hide::desktop::luminosity\":\"0\",\"summary::hide::desktop::power\":\"0\",\"summary::hide::mobile::security\":\"0\",\"summary::hide::mobile::motion\":\"0\",\"summary::hide::mobile::door\":\"0\",\"summary::hide::mobile::windows\":\"0\",\"summary::hide::mobile::shutter\":\"0\",\"summary::hide::mobile::light\":\"0\",\"summary::hide::mobile::outlet\":\"0\",\"summary::hide::mobile::temperature\":\"0\",\"summary::hide::mobile::humidity\":\"0\",\"summary::hide::mobile::luminosity\":\"0\",\"summary::hide::mobile::power\":\"0\",\"summary\":{\"security\":[],\"motion\":[],\"door\":[],\"windows\":[],\"shutter\":[],\"light\":[],\"outlet\":[],\"temperature\":[],\"humidity\":[],\"luminosity\":[],\"power\":[]}}','{\"tagColor\":\"#33b8cc\",\"tagTextColor\":\"#ffffff\",\"desktop::summaryTextColor\":\"#ffffff\",\"dashboard::size\":\"\",\"icon\":\"\"}','[]');
INSERT INTO `object` VALUES (3,'Bathroom',2,0,NULL,'{\"parentNumber\":1,\"tagColor\":\"#000000\",\"tagTextColor\":\"#FFFFFF\",\"desktop::summaryTextColor\":\"\",\"mobile::summaryTextColor\":\"\",\"hideOnDashboard\":\"0\",\"summary::global::security\":\"0\",\"summary::global::motion\":\"0\",\"summary::global::door\":\"0\",\"summary::global::windows\":\"0\",\"summary::global::shutter\":\"0\",\"summary::global::light\":\"0\",\"summary::global::outlet\":\"0\",\"summary::global::temperature\":\"0\",\"summary::global::humidity\":\"0\",\"summary::global::luminosity\":\"0\",\"summary::global::power\":\"0\",\"summary::hide::desktop::security\":\"0\",\"summary::hide::desktop::motion\":\"0\",\"summary::hide::desktop::door\":\"0\",\"summary::hide::desktop::windows\":\"0\",\"summary::hide::desktop::shutter\":\"0\",\"summary::hide::desktop::light\":\"0\",\"summary::hide::desktop::outlet\":\"0\",\"summary::hide::desktop::temperature\":\"0\",\"summary::hide::desktop::humidity\":\"0\",\"summary::hide::desktop::luminosity\":\"0\",\"summary::hide::desktop::power\":\"0\",\"summary::hide::mobile::security\":\"0\",\"summary::hide::mobile::motion\":\"0\",\"summary::hide::mobile::door\":\"0\",\"summary::hide::mobile::windows\":\"0\",\"summary::hide::mobile::shutter\":\"0\",\"summary::hide::mobile::light\":\"0\",\"summary::hide::mobile::outlet\":\"0\",\"summary::hide::mobile::temperature\":\"0\",\"summary::hide::mobile::humidity\":\"0\",\"summary::hide::mobile::luminosity\":\"0\",\"summary::hide::mobile::power\":\"0\",\"summary\":{\"security\":[],\"motion\":[],\"door\":[],\"windows\":[],\"shutter\":[],\"light\":[],\"outlet\":[],\"temperature\":[],\"humidity\":[],\"luminosity\":[],\"power\":[]}}','{\"tagColor\":\"#33b8cc\",\"tagTextColor\":\"#ffffff\",\"desktop::summaryTextColor\":\"#ffffff\",\"dashboard::size\":\"\",\"icon\":\"\"}','[]');
INSERT INTO `object` VALUES (4,'Chamber',2,1,NULL,'{\"parentNumber\":1,\"tagColor\":\"#000000\",\"tagTextColor\":\"#FFFFFF\",\"desktop::summaryTextColor\":\"\",\"mobile::summaryTextColor\":\"\",\"hideOnDashboard\":\"0\",\"summary::global::security\":\"0\",\"summary::global::motion\":\"0\",\"summary::global::door\":\"0\",\"summary::global::windows\":\"0\",\"summary::global::shutter\":\"0\",\"summary::global::light\":\"0\",\"summary::global::outlet\":\"0\",\"summary::global::temperature\":\"0\",\"summary::global::humidity\":\"0\",\"summary::global::luminosity\":\"0\",\"summary::global::power\":\"0\",\"summary::hide::desktop::security\":\"0\",\"summary::hide::desktop::motion\":\"0\",\"summary::hide::desktop::door\":\"0\",\"summary::hide::desktop::windows\":\"0\",\"summary::hide::desktop::shutter\":\"0\",\"summary::hide::desktop::light\":\"0\",\"summary::hide::desktop::outlet\":\"0\",\"summary::hide::desktop::temperature\":\"0\",\"summary::hide::desktop::humidity\":\"0\",\"summary::hide::desktop::luminosity\":\"0\",\"summary::hide::desktop::power\":\"0\",\"summary::hide::mobile::security\":\"0\",\"summary::hide::mobile::motion\":\"0\",\"summary::hide::mobile::door\":\"0\",\"summary::hide::mobile::windows\":\"0\",\"summary::hide::mobile::shutter\":\"0\",\"summary::hide::mobile::light\":\"0\",\"summary::hide::mobile::outlet\":\"0\",\"summary::hide::mobile::temperature\":\"0\",\"summary::hide::mobile::humidity\":\"0\",\"summary::hide::mobile::luminosity\":\"0\",\"summary::hide::mobile::power\":\"0\",\"summary\":{\"security\":[],\"motion\":[],\"door\":[],\"windows\":[],\"shutter\":[],\"light\":[],\"outlet\":[],\"temperature\":[],\"humidity\":[],\"luminosity\":[],\"power\":[]}}','{\"tagColor\":\"#33b8cc\",\"tagTextColor\":\"#ffffff\",\"desktop::summaryTextColor\":\"#ffffff\",\"dashboard::size\":\"\",\"icon\":\"\"}','[]');
INSERT INTO `object` VALUES (5,'Special Room',NULL,1,NULL,'{\"parentNumber\":1,\"tagColor\":\"#000000\",\"tagTextColor\":\"#FFFFFF\",\"desktop::summaryTextColor\":\"\",\"mobile::summaryTextColor\":\"\",\"hideOnDashboard\":\"0\",\"summary::global::security\":\"0\",\"summary::global::motion\":\"0\",\"summary::global::door\":\"0\",\"summary::global::windows\":\"0\",\"summary::global::shutter\":\"0\",\"summary::global::light\":\"0\",\"summary::global::outlet\":\"0\",\"summary::global::temperature\":\"0\",\"summary::global::humidity\":\"0\",\"summary::global::luminosity\":\"0\",\"summary::global::power\":\"0\",\"summary::hide::desktop::security\":\"0\",\"summary::hide::desktop::motion\":\"0\",\"summary::hide::desktop::door\":\"0\",\"summary::hide::desktop::windows\":\"0\",\"summary::hide::desktop::shutter\":\"0\",\"summary::hide::desktop::light\":\"0\",\"summary::hide::desktop::outlet\":\"0\",\"summary::hide::desktop::temperature\":\"0\",\"summary::hide::desktop::humidity\":\"0\",\"summary::hide::desktop::luminosity\":\"0\",\"summary::hide::desktop::power\":\"0\",\"summary::hide::mobile::security\":\"0\",\"summary::hide::mobile::motion\":\"0\",\"summary::hide::mobile::door\":\"0\",\"summary::hide::mobile::windows\":\"0\",\"summary::hide::mobile::shutter\":\"0\",\"summary::hide::mobile::light\":\"0\",\"summary::hide::mobile::outlet\":\"0\",\"summary::hide::mobile::temperature\":\"0\",\"summary::hide::mobile::humidity\":\"0\",\"summary::hide::mobile::luminosity\":\"0\",\"summary::hide::mobile::power\":\"0\",\"summary\":{\"security\":[],\"motion\":[],\"door\":[],\"windows\":[],\"shutter\":[],\"light\":[],\"outlet\":[],\"temperature\":[],\"humidity\":[],\"luminosity\":[],\"power\":[]}}','{\"tagColor\":\"#33b8cc\",\"tagTextColor\":\"#ffffff\",\"desktop::summaryTextColor\":\"#ffffff\",\"dashboard::size\":\"\",\"icon\":\"\"}','[]');
INSERT INTO `eqLogic` VALUES (1,'Test eqLogic',NULL,NULL,1,'plugin4tests','{\"createtime\":\"2019-02-10 22:10:30\",\"updatetime\":\"2019-02-01 20:21:16\"}',1,1,NULL,NULL,'{\"heating\":\"0\",\"security\":\"1\",\"energy\":\"0\",\"light\":\"0\",\"automatism\":\"0\",\"multimedia\":\"0\",\"default\":\"0\"}','{\"showObjectNameOnview\":1,\"showObjectNameOndview\":1,\"showObjectNameOnmview\":1,\"height\":\"auto\",\"width\":\"auto\",\"layout::dashboard::table::parameters\":{\"center\":1,\"styletd\":\"padding:3px;\"},\"layout::mobile::table::parameters\":{\"center\":1,\"styletd\":\"padding:3px;\"}}',9999,NULL,NULL);
INSERT INTO `eqLogic` VALUES (2,'Second eqLogic',NULL,NULL,2,'plugin4tests','{\"createtime\":\"2019-03-10 22:10:30\",\"updatetime\":\"2019-03-01 20:21:16\"}',0,0,NULL,NULL,'{\"heating\":\"0\",\"security\":\"0\",\"energy\":\"0\",\"light\":\"1\",\"automatism\":\"0\",\"multimedia\":\"0\",\"default\":\"0\"}','{\"showObjectNameOnview\":1,\"showObjectNameOndview\":1,\"showObjectNameOnmview\":1,\"height\":\"auto\",\"width\":\"auto\",\"layout::dashboard::table::parameters\":{\"center\":1,\"styletd\":\"padding:3px;\"},\"layout::mobile::table::parameters\":{\"center\":1,\"styletd\":\"padding:3px;\"}}',9999,NULL,NULL);
INSERT INTO `eqLogic` VALUES (3,'Third eqLogic',NULL,NULL,1,'plugin4tests','{\"createtime\":\"2019-03-10 22:10:30\",\"updatetime\":\"2019-03-01 20:21:16\"}',0,1,NULL,NULL,'{\"heating\":\"0\",\"security\":\"0\",\"energy\":\"1\",\"light\":\"0\",\"automatism\":\"0\",\"multimedia\":\"1\",\"default\":\"0\"}','{\"showObjectNameOnview\":1,\"showObjectNameOndview\":1,\"showObjectNameOnmview\":1,\"height\":\"auto\",\"width\":\"auto\",\"layout::dashboard::table::parameters\":{\"center\":1,\"styletd\":\"padding:3px;\"},\"layout::mobile::table::parameters\":{\"center\":1,\"styletd\":\"padding:3px;\"}}',9999,NULL,NULL);
INSERT INTO `eqLogic` VALUES (4,'A lamp',NULL,NULL,3,'plugin4tests','{\"createtime\":\"2019-03-10 22:10:30\",\"updatetime\":\"2019-03-01 20:21:16\"}',1,1,NULL,NULL,'','{\"showObjectNameOnview\":1,\"showObjectNameOndview\":1,\"showObjectNameOnmview\":1,\"height\":\"auto\",\"width\":\"auto\",\"layout::dashboard::table::parameters\":{\"center\":1,\"styletd\":\"padding:3px;\"},\"layout::mobile::table::parameters\":{\"center\":1,\"styletd\":\"padding:3px;\"}}',9999,NULL,NULL);
INSERT INTO `eqLogic` VALUES (5,'A special',NULL,NULL,5,'plugin4tests','{\"createtime\":\"2019-03-10 22:10:30\",\"updatetime\":\"2019-03-01 20:21:16\"}',1,1,NULL,NULL,'','{\"showObjectNameOnview\":1,\"showObjectNameOndview\":1,\"showObjectNameOnmview\":1,\"height\":\"auto\",\"width\":\"auto\",\"layout::dashboard::table::parameters\":{\"center\":1,\"styletd\":\"padding:3px;\"},\"layout::mobile::table::parameters\":{\"center\":1,\"styletd\":\"padding:3px;\"}}',9999,NULL,NULL);
INSERT INTO `cmd` VALUES (1,1,'plugin4tests',NULL,NULL,0,'Cmd 1','[]','[]','1','info','binary',NULL,'[]',1,NULL,'[]','[]');
INSERT INTO `cmd` VALUES (2,1,'plugin4tests',NULL,NULL,0,'Cmd 2','[]','[]','0','action','other',NULL,'[]',0,NULL,'[]','[]');
INSERT INTO `cmd` VALUES (3,2,'plugin4tests',NULL,NULL,0,'Cmd 3','[]','[]','0','info','binary',NULL,'[]',1,NULL,'[]','[]');
INSERT INTO `cmd` VALUES (4,4,'plugin4tests',NULL,NULL,0,'Cmd 4','[]','[]','1','info','numeric',NULL,'[]',1,NULL,'[]','[]');
INSERT INTO `cmd` VALUES (5,5,'plugin4tests',NULL,NULL,0,'Cmd 5','[]','{\"dashboard\":\"custom::InfoTest\",\"mobile\":\"custom::InfoTest\"}','0','info','binary',NULL,'[]',1,NULL,'[]','[]');
INSERT INTO `note` VALUES (1,'Note de test','Un peu de contenu');
INSERT INTO `note` VALUES (2,'Une autre note','Peu d\'idée');
INSERT INTO `plan` VALUES (1,1,'eqLogic',4,'[]','[]','{\"z-index\":1000}','[]');
INSERT INTO `planHeader` VALUES (1,'Plan test','[]','{\"desktopSizeX\":500,\"desktopSizeY\":500,\"backgroundTransparent\":1,\"backgroundColor\":\"#ffffff\"}');
INSERT INTO `plan3d` VALUES (1, 'Plan 3d', 1, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `plan3dHeader` VALUES (1,'Test plan 3d','[]');
INSERT INTO `config` VALUES ('core', 'api', 'uMOVMeaRleSDCVp6aZ5aLcOaVeOBeAVv');
INSERT INTO `config` VALUES ('core', 'nextdom::user-theme', 'dark-nextdom');
INSERT INTO `config` VALUES ('core', 'nextdom::user-icon', 'AlphaBlackWhite');
INSERT INTO `config` VALUES ('core', 'nextdom::Welcome', '0');
INSERT INTO `config` VALUES ('core', 'object:summary', '{"security":{"key":"security","name":"Alerte","calcul":"sum","icon":"<i class=\\"icon nextdom-alerte2\\"><\\/i>","unit":"","count":"binary","allowDisplayZero":"0"},"motion":{"key":"motion","name":"Mouvement","calcul":"sum","icon":"<i class=\\"icon nextdom-mouvement\\"><\\/i>","unit":"","count":"binary","allowDisplayZero":"0"},"door":{"key":"door","name":"Porte","calcul":"sum","icon":"<i class=\\"icon nextdom-porte-ouverte\\"><\\/i>","unit":"","count":"binary","allowDisplayZero":"0"},"windows":{"key":"windows","name":"Fenêtre","calcul":"sum","icon":"<i class=\\"icon nextdom-fenetre-ouverte\\"><\\/i>","unit":"","count":"binary","allowDisplayZero":"0"},"shutter":{"key":"shutter","name":"Volet","calcul":"sum","icon":"<i class=\\"icon nextdom-volet-ouvert\\"><\\/i>","unit":"","count":"binary","allowDisplayZero":"0"},"light":{"key":"light","name":"Lumière","calcul":"sum","icon":"<i class=\\"icon nextdom-lumiere-on\\"><\\/i>","unit":"","count":"binary","allowDisplayZero":"0"},"outlet":{"key":"outlet","name":"Prise","calcul":"sum","icon":"<i class=\\"icon nextdom-prise\\"><\\/i>","unit":"","count":"binary","allowDisplayZero":"0"},"temperature":{"key":"temperature","name":"Température","calcul":"avg","icon":"<i class=\\"icon divers-thermometer31\\"><\\/i>","unit":"°C","count":"","allowDisplayZero":"1"},"humidity":{"key":"humidity","name":"Humidité","calcul":"avg","icon":"<i class=\\"fa fa-tint\\"><\\/i>","unit":"%","count":"","allowDisplayZero":"1"},"luminosity":{"key":"luminosity","name":"Luminosité","calcul":"avg","icon":"<i class=\\"icon meteo-soleil\\"><\\/i>","unit":"lx","count":"","allowDisplayZero":"0"},"power":{"key":"power","name":"Puissance","calcul":"sum","icon":"<i class=\\"fa fa-bolt\\"><\\/i>","unit":"W","count":"","allowDisplayZero":"0"}}');
INSERT INTO `config` VALUES ('plugin4tests', 'unused_key', 'sample');
INSERT INTO `config` VALUES ('core', 'nextdom::firstUse', 0);
INSERT INTO `scenario` VALUES (1,'Test scenario','',1,'schedule','* * * * *','[\"1\"]','[]',0,1,NULL,'{\"name\":\"\",\"icon\":\"\"}','','{\"timeDependency\":0,\"has_return\":0,\"logmode\":\"default\",\"timeline::enable\":\"0\",\"allowMultiInstance\":\"0\",\"syncmode\":\"0\"}',99);
INSERT INTO `scenario` VALUES (2,'Empty scenario','Small group',1,'schedule','* * * * *','[]','[]',0,1,NULL,'{\"name\":\"\",\"icon\":\"\"}','','{\"timeDependency\":0,\"has_return\":0,\"logmode\":\"default\",\"timeline::enable\":\"0\",\"allowMultiInstance\":\"0\",\"syncmode\":\"0\"}',99);
INSERT INTO `scenario` VALUES (3,'Scenario with expressions','Scenario for tests',1,'schedule','* * * * *','[\"2\",\"3\"]','[]',0,1,1,'{\"name\":\"\",\"icon\":\"\"}','','{\"timeDependency\":0,\"has_return\":0,\"logmode\":\"default\",\"timeline::enable\":\"0\",\"allowMultiInstance\":\"0\",\"syncmode\":\"0\"}',9999);
INSERT INTO `scenario` VALUES (4,'Disabled scenario','Scenario for tests',0,'schedule','0 0 * * *','[]','[]',0,1,1,'{\"name\":\"\",\"icon\":\"\"}','','{\"timeDependency\":0,\"has_return\":0,\"logmode\":\"default\",\"timeline::enable\":\"0\",\"allowMultiInstance\":\"0\",\"syncmode\":\"0\"}',9999);
INSERT INTO `scenario` VALUES (5,'Trigger scenario','',1,'provoke','[]','[\"5\"]','[\"#1#\"]',0,1,NULL,'{\"name\":\"\",\"icon\":\"\"}','','{\"timeDependency\":0,\"has_return\":0,\"logmode\":\"default\",\"timeline::enable\":\"0\",\"allowMultiInstance\":\"0\",\"syncmode\":\"0\"}',9999);
INSERT INTO `scenarioElement` VALUES (1,0,'action',NULL,'[]',NULL);
INSERT INTO `scenarioElement` VALUES (2,0,'if',NULL,'[]',NULL);
INSERT INTO `scenarioElement` VALUES (3,0,'action',NULL,'[]',NULL);
INSERT INTO `scenarioElement` VALUES (4,0,'action',NULL,'[]',NULL);
INSERT INTO `scenarioElement` VALUES (5,0,'action',NULL,'[]',NULL);
INSERT INTO `scenarioExpression` VALUES (1,0,1,'action',NULL,'log','{\"enable\":\"1\",\"background\":\"0\",\"message\":\"LAUNCHED\"}',NULL);
INSERT INTO `scenarioExpression` VALUES (2,0,2,'condition',NULL,'#3# == 1  ','[]',NULL);
INSERT INTO `scenarioExpression` VALUES (3,0,5,'action',NULL,'log','{\"enable\":\"1\",\"background\":\"0\",\"message\":\"That\'s works\"}',NULL);
INSERT INTO `scenarioExpression` VALUES (4,0,6,'action',NULL,'log','{\"enable\":\"1\",\"background\":\"0\",\"message\":\"Log this message\"}',NULL);
INSERT INTO `scenarioExpression` VALUES (5,0,7,'action',NULL,'log','{\"enable\":\"1\",\"background\":\"0\",\"message\":\"Log this message\"}',NULL);
INSERT INTO `scenarioSubElement` VALUES (1,0,1,'action','action',NULL,'{\"enable\":\"1\"}',NULL);
INSERT INTO `scenarioSubElement` VALUES (2,0,2,'if','condition',NULL,'{\"enable\":\"1\",\"allowRepeatCondition\":\"0\"}',NULL);
INSERT INTO `scenarioSubElement` VALUES (3,1,2,'then','action',NULL,'[]',NULL),(4,2,2,'else','action',NULL,'[]',NULL);
INSERT INTO `scenarioSubElement` VALUES (5,0,3,'action','action',NULL,'{\"enable\":\"1\"}',NULL);
INSERT INTO `scenarioSubElement` VALUES (6,0,4,'action','action',NULL,'{\"enable\":\"1\"}',NULL);
INSERT INTO `scenarioSubElement` VALUES (7,0,5,'action','action',NULL,'{\"enable\":\"1\"}',NULL);
INSERT INTO `cron` VALUES (1,1,'nextdom','cron5','*/5 * * * * *',5,0,1,NULL,0);
INSERT INTO `cron` VALUES (2,1,'nextdom','cron10','*/10 * * * * *',10,0,1,NULL,0);
INSERT INTO `cron` VALUES (3,1,'nextdom','cron','* * * * * *',2,0,1,NULL,0);
INSERT INTO `cron` VALUES (4,0,'nextdom','cronHourly','0 * * * * *',60,0,1,NULL,0);
INSERT INTO `cron` VALUES (5,1,'plugin','cron5','*/5 * * * * *',5,0,1,NULL,0);
INSERT INTO `cron` VALUES (6,1,'plugin','cron10','*/10 * * * * *',10,0,1,NULL,0);
INSERT INTO `cron` VALUES (7,1,'plugin','cron','* * * * * *',2,0,1,NULL,0);
INSERT INTO `cron` VALUES (8,0,'plugin','cronHourly','0 * * * * *',60,0,1,NULL,0);
INSERT INTO `cron` VALUES (9,1,'scenario','control','* * * * * *',30,0,1,NULL,0);
INSERT INTO `cron` VALUES (10,1,'scenario','check','* * * * * *',30,0,1,NULL,0);
INSERT INTO `update` VALUES (1,'core','nextdom','nextdom','','','github','ok','{"doNotUpdate":"1"}');
INSERT INTO `update` VALUES (2,'plugin','plugin4tests','plugin4tests','','','github','update','{"doNotUpdate":"1"}');
INSERT INTO `view` VALUES (1,'Test view','[]',NULL,'[]','[]');
INSERT INTO `viewZone` VALUES (1,1,'widget','My Zone',NULL,'{\"zoneCol\":\"12\"}');
INSERT INTO `viewData` VALUES (1,0,1,'eqLogic',4,'[]');
INSERT INTO `message` VALUES (1,'2019-05-03 22:00:03','newUpdate','update','De nouvelles mises à jour sont disponibles : nextdom,openzwave','');
INSERT INTO `message` VALUES (2,'2019-05-04 00:00:02','scenario::sKEbQHaqQGiOwgvu4sknYQUQqFurIUks','scenario','Une commande du scénario : [Couloir][Couloir][Lumière couloir] est introuvable','');
INSERT INTO `message` VALUES (3,'2019-05-05 22:00:02','plugin4tests::Zx1FKbfyTf3jW6ux8TLpSmQAbJSvCIt1','plugin4tests','Message from a plugin','');
INSERT INTO `dataStore` VALUES (1,'scenario',-1,'numeric_data','42');
INSERT INTO `dataStore` VALUES (2,'scenario',-1,'text_data','H2G2');
INSERT INTO `widget` VALUES (1,'InfoTest','info','binary','tmplicon','{\"icon\":\"<i class=\\\"icon  animal-rabbit  \\\"><\\/i>\"}','{\"#_time_widget_#\":\"0\",\"#_icon_on_#\":\"<i class=\'icon jeedom2-tirelire2 icon_green\'><\\/i>\",\"#_icon_off_#\":\"<i class=\'icon animal-rabbit icon_red\'><\\/i>\"}','[]');
INSERT INTO `widget` VALUES (2,'ActionTest','action','other','tmplicon','{\"icon\":\"\"}','{\"#_time_widget_#\":\"0\",\"#_icon_on_#\":[\"\",\"\"],\"#_icon_off_#\":[\"\",\"\"]}','[]');
SET FOREIGN_KEY_CHECKS=1;
