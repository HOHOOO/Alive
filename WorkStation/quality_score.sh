#!/bin/bash
home_path=$(cd "`dirname $0`"; pwd)
quality_sync_time=`date -d "4 day ago" +"%Y-%m-%d %H:%M:%S"`

hdfs dfs -rm -r -f -skipTrash /recommend/dw/sync_yuanchuang/*
hdfs dfs -rm -r -f -skipTrash /recommend/dw/sync_yuanchuang_extend/*
hdfs dfs -rm -r -f -skipTrash /recommend/dw/sync_youhui/*
hdfs dfs -rm -r -f -skipTrash /recommend/dw/sync_youhui_extend/*

sqoop import --connect 'jdbc:mysql://smzdm_recommend_mysql_m01_184/recommendDB?zeroDateTimeBehavior=convertToNull?useUnicode=true&characterEncoding=utf-8&zeroDateTimeBehavior=convertToNull&tinyInt1isBit=false' --username recommendUser --password pVhXTntx9ZG --query "select * from sync_yuanchuang where publishtime > '$quality_sync_time' and \$CONDITIONS " --split-by id -m 4 --fields-terminated-by '\001' --null-string '' --null-non-string '' --hive-drop-import-delims --as-textfile --delete-target-dir --target-dir /recommend/dw/sync_yuanchuang --hive-table recommend.sync_yuanchuang> ./file/log/sync_yuanchuang.log 2>&1
sqoop import --connect 'jdbc:mysql://smzdm_recommend_mysql_m01_184/recommendDB?zeroDateTimeBehavior=convertToNull?useUnicode=true&characterEncoding=utf-8&zeroDateTimeBehavior=convertToNull&tinyInt1isBit=false' --username recommendUser --password pVhXTntx9ZG --query "select * from sync_yuanchuang_extend where last_submit_time > '$quality_sync_time' and \$CONDITIONS " --split-by id -m 4 --fields-terminated-by '\001' --null-string '' --null-non-string '' --hive-drop-import-delims --as-textfile --delete-target-dir --target-dir /recommend/dw/sync_yuanchuang_extend --hive-table recommend.sync_yuanchuang_extend> ./file/log/sync_yuanchuang_extend.log 2>&1

sqoop import --connect 'jdbc:mysql://smzdm_recommend_mysql_m01_184/recommendDB?zeroDateTimeBehavior=convertToNull?useUnicode=true&characterEncoding=utf-8&zeroDateTimeBehavior=convertToNull&tinyInt1isBit=false' --username recommendUser --password pVhXTntx9ZG --query "select * from sync_youhui where pubdate > '$quality_sync_time' and \$CONDITIONS " --split-by id -m 4 --fields-terminated-by '\001' --null-string '' --null-non-string '' --hive-drop-import-delims --as-textfile --delete-target-dir --target-dir /recommend/dw/sync_youhui --hive-table recommend.sync_youhui> ./file/log/sync_youhui.log 2>&1
sqoop import --connect 'jdbc:mysql://smzdm_recommend_mysql_m01_184/recommendDB?zeroDateTimeBehavior=convertToNull?useUnicode=true&characterEncoding=utf-8&zeroDateTimeBehavior=convertToNull&tinyInt1isBit=false' --username recommendUser --password pVhXTntx9ZG --query "select * from sync_youhui_extend where createdate > '$quality_sync_time' and \$CONDITIONS " --split-by id -m 4 --fields-terminated-by '\001' --null-string '' --null-non-string '' --hive-drop-import-delims --as-textfile --delete-target-dir --target-dir /recommend/dw/sync_youhui_extend --hive-table recommend.sync_youhui_extend> ./file/log/sync_youhui_extend.log 2>&1





hive -d zscore='1.96' -d  para1='0.4' -d para2='0.3' -d para3='0.2' -d para4='0.1' -d store='0.8' -d timestamp=`date -d "now" +%s` -e '
use recommend;
CREATE EXTERNAL TABLE IF NOT EXISTS `sync_yuanchuang` (`id` INT,`uid` INT,`anonymous` INT,`type` INT,`title` string,`image` string,`comment_count` INT,`collection_count` INT,`love_rating_count` INT,`brand` string,`link` string,`mall` string,`is_delete` INT,`status` INT,`publishtime` string,`sum_collect_comment` INT,`series_title_temp` string,`title_series_title` string,`article_type` INT,`recommend` INT,`recommend_display_time` string,`export_from` string,`transfer` INT,`reward_count` INT,`hash_value` string,`flagfield` string,`sync_date` string) LOCATION "/recommend/dw/sync_yuanchuang";
CREATE EXTERNAL TABLE IF NOT EXISTS `sync_youhui` (`id` INT,`editor_id` INT,`pubdate` string,`choiceness_date` string,`yh_status` INT,`channel` INT,`comment_count` INT,`collection_count` INT,`praise` INT,`sum_collect_comment` INT,`mall` string,`brand` string,`digital_price` string,`worthy` INT,`unworthy` INT,`is_top` INT,`yh_type` string,`is_essence_for_editor` INT,`article_type` INT,`mobile_exclusive` INT,`clean_link` string,`district` INT,`is_review` INT,`faxian_show` INT,`source_from` INT,`strategy_pub` INT,`uhomedate` string,`update_timestamp` string,`reward_count` INT,`mall_id` string,`brand_id` string,`b2c_id` string,`spu_link` string,`hash_value` string,`flagfield` string,`sync_date` string) LOCATION "/recommend/dw/sync_youhui";
CREATE EXTERNAL TABLE IF NOT EXISTS `sync_youhui_extend` (`id` INT,`createdate` string,`upstring` string,`title_prefix` string,`title` string,`subtitle` string,`phrase_desc` string,`content` string,`focus_pic_url` string,`referrals` string,`direct_link` string,`direct_link_name` string,`direct_link_list` string,`sales_area` INT,`title_mode` INT,`app_push` INT,`last_editor_id` INT,`sync_home_id` string,`source_from_id` string,`source_from_channel` INT,`sina_id` string,`associate_brand` INT,`associate_mall` INT,`is_anonymous` INT,`stock_status` INT,`comment_switch` INT,`push_type` INT,`guonei_id_for_fx` string,`haitao_id_for_fx` string,`sync_home` INT,`sync_home_time` string,`is_home_top` INT,`edit_page_type` INT,`hash_value` string,`flagfield` string,`sync_date` string,`starttime` string,`endtime` string) LOCATION "/recommend/dw/sync_youhui_extend";
CREATE EXTERNAL TABLE IF NOT EXISTS `sync_yuanchuang_extend` (`id` INT,`edit_uid` INT,`updateline` string,`dateline` string,`submit_time` string,`last_submit_time` string,`audit_times` INT,`sina_id` string,`tencent_id` string,`remark` string,`plid` string,`district` INT,`have_read` INT,`add_modify` string,`add_modify_time` string,`seo_title` string,`seo_keywords` string,`seo_description` string,`series_id` INT,`series_order_id` INT,`push_type` INT,`baidu_doc_id` string,`probreport_id` string,`is_write_post_time` string,`set_auto_sync` INT,`is_home_top` INT,`from_vote` string,`comment_switch` INT,`associate_brand` INT,`associate_mall` INT,`hash_value` string,`flagfield` string,`sync_date` string) LOCATION "/recommend/dw/sync_yuanchuang_extend";

set mapred.job.queue.name=q_gmv;
set hive.exec.dynamic.partition=true;
set hive.exec.dynamic.partition.mode=nostrict;
set hive.groupby.skewindata=true;
set hive.exec.parallel=true;
set mapred.reduce.tasks=10;

DROP TABLE recommend.quality_data_source_newton;
DROP TABLE recommend.quality_data_source_wilson;
DROP TABLE recommend.quality_data_source;


CREATE TABLE recommend.quality_data_source_newton AS SELECT id, (${para1} *collection_count/max_collection_count)+(${para2} *love_rating_count/max_love_rating_count)+(${para3} *comment_count/max_comment_count)+(${para4} *reward_count/max_reward_count) AS score,0 as last_status, 0 as increase_rate, 0 as order_rank, score_timestamp FROM (SELECT id,collection_count,love_rating_count,comment_count,reward_count,score_timestamp,max(collection_count) over (PARTITION BY score_timestamp ) AS max_collection_count,max(love_rating_count) over (PARTITION BY score_timestamp ) AS max_love_rating_count,max(comment_count) over (PARTITION BY score_timestamp ) AS max_comment_count,max(reward_count) over (PARTITION BY score_timestamp ) AS max_reward_count from  ( SELECT id,collection_count,love_rating_count,comment_count,reward_count,${timestamp}  as score_timestamp FROM sync_yuanchuang ) t2 ) t3;

CREATE TABLE recommend.quality_data_source_wilson AS SELECT id, CASE WHEN phat=-${zscore}  THEN 0 WHEN phat<>-${zscore}  AND source_from=5 THEN (${store} )*(phat + ${zscore} /n - ${zscore} *sqrt((phat * (1- phat) /n)+${zscore} /(4*pow(n,2))))/(1+${zscore} /n) ELSE (phat + ${zscore} /n - ${zscore} *sqrt((phat * (1- phat) /n)+${zscore} /(4*pow(n,2))))/(1+${zscore} /n)  END as score,0 as last_status, 0 as increase_rate, 0 as order_rank, score_timestamp from ( SELECT id,(worthy+unworthy) as n,CASE WHEN (worthy+unworthy)=0 THEN -1.96 ELSE (worthy/(worthy+unworthy)) END as phat,worthy,unworthy,source_from,${timestamp}  as score_timestamp FROM sync_youhui ) t ;

CREATE TABLE `recommend.quality_data_source`(
  `id` int,
  `score` double,
  `last_status` double,
  `increase_rate` double,
  `order_rank` int,
  `score_timestamp` int,
  `class` int);

INSERT OVERWRITE TABLE  recommend.quality_data_source SELECT a.* from (select * ,1 as class from recommend.quality_data_source_newton union all  select * ,0 as class from recommend.quality_data_source_wilson) a;

INSERT OVERWRITE TABLE recommend.quality_data_score SELECT id,score,last_status,((increase_rate-min_increase_rate)/(max_increase_rate-min_increase_rate+0.00001)) AS increase_rate,order_rank,score_timestamp,class FROM ( SELECT id,score,last_status,increase_rate,max(increase_rate) over (PARTITION BY class) AS max_increase_rate,min(increase_rate) over (PARTITION BY class) AS min_increase_rate,order_rank,score_timestamp,class FROM ( SELECT id,score_alias AS score,last_status,CASE WHEN last_status=0 THEN 0 ELSE ((score_alias-last_status)/last_status+0.00001) END AS increase_rate,order_rank,score_timestamp,class FROM (SELECT id,score AS score_alias,score_timestamp,lead (score,1,0) over (PARTITION BY id ORDER BY score_timestamp DESC) AS last_status,rank () over (PARTITION BY id ORDER BY score_timestamp DESC) AS order_rank,class FROM (SELECT id,score,score_timestamp,class,order_rank FROM recommend.quality_data_score WHERE order_rank=1 UNION ALL SELECT id,score,score_timestamp,class,order_rank FROM recommend.quality_data_source) a ) b) c) t where order_rank=1;
'


mysql -hsmzdm_recommend_mysql_s01_150  -urecommendUser -ppVhXTntx9ZG recommendDB -e "
drop table home_article_quality_score;
create table home_article_quality_score(id int(11) , score double(10,4) , last_status double(10,4),increase_rate double(10,4),order_rank  int(11) ,score_timestamp  int(11) ,class  int(11) );
"
sqoop export --connect jdbc:mysql://smzdm_recommend_mysql_s01_150/recommendDB --username recommendUser --password pVhXTntx9ZG --table home_article_quality_score --fields-terminated-by '\001' --export-dir 'hdfs://hadoopcluster/user/hive/warehouse/recommend.db/quality_data_score'

mysql -hsmzdm_recommend_mysql_s01_150  -urecommendUser -ppVhXTntx9ZG recommendDB -e "update home_article_online a, home_article_quality_score b
set a.hot_score = b.score,
a.hot_increase_rate = b. increase_rate
where a.article_id= b.id
and ((a.channel='yh' and b.class=0)
or (a.channel='yc' and b.class=1));"
