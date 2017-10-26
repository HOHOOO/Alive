#!/bin/bash
home_path=$(cd "`dirname $0`"; pwd)
quality_sync_time=`date -d "4 day ago" +"%Y-%m-%d %H:%M:%S"`
score_timestamp=`date -d "now" +%s`

#input para
zscore=$1
yuanchuang_para1=$2
yuanchuang_para2=$3
yuanchuang_para3=$4
yuanchuang_para4=$5
store_decrease=$6
echo $zscore
echo $yuanchuang_para1
echo $yuanchuang_para2
echo $yuanchuang_para3
echo $yuanchuang_para4
echo $store_decrease


hive -e '
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

SELECT "$zscore,$yuanchuang_para1,$yuanchuang_para2,$yuanchuang_para3,$yuanchuang_para4,$store_decrease";
CREATE TABLE recommend.quality_data_source_newton AS SELECT id, ($yuanchuang_para1 *collection_count/max_collection_count)+($yuanchuang_para2 *love_rating_count/max_love_rating_count)+($yuanchuang_para3 *comment_count/max_comment_count)+($yuanchuang_para4 *reward_count/max_reward_count) AS score,0 as last_status, 0 as increase_rate, 0 as order_rank, score_timestamp FROM (SELECT id,collection_count,love_rating_count,comment_count,reward_count,score_timestamp,max(collection_count) over (PARTITION BY score_timestamp ) AS max_collection_count,max(love_rating_count) over (PARTITION BY score_timestamp ) AS max_love_rating_count,max(comment_count) over (PARTITION BY score_timestamp ) AS max_comment_count,max(reward_count) over (PARTITION BY score_timestamp ) AS max_reward_count from  ( SELECT id,collection_count,love_rating_count,comment_count,reward_count,$score_timestamp  as score_timestamp FROM sync_yuanchuang ) t2 ) t3;
s
CREATE TABLE recommend.quality_data_source_wilson AS SELECT id, CASE WHEN phat=-$zscore  THEN 0 WHEN phat<>-$zscore  AND source_from=5 THEN ($store_decrease )*(phat + $zscore /n - $zscore *sqrt((phat * (1- phat) /n)+$zscore /(4*pow(n,2))))/(1+$zscore /n) ELSE (phat + $zscore /n - $zscore *sqrt((phat * (1- phat) /n)+$zscore /(4*pow(n,2))))/(1+$zscore /n)  END as score,0 as last_status, 0 as increase_rate, 0 as order_rank, score_timestamp from ( SELECT id,(worthy+unworthy) as n,CASE WHEN (worthy+unworthy)=0 THEN -1.96 ELSE (worthy/(worthy+unworthy)) END as phat,worthy,unworthy,source_from,$score_timestamp  as score_timestamp FROM sync_youhui ) t ;

CREATE TABLE recommend.quality_data_source AS SELECT a.* from (select * from recommend.quality_data_source_newton union all  select * from recommend.quality_data_source_wilson) a;

INSERT OVERWRITE TABLE recommend.quality_data_score
Select b.*,(score - last_status)/last_status as increase_rate  from (
      select a.*,LEAD(score, 1, 0) over (partition by id order by score_timestamp desc) as last_status ,rank() over (partition by id order by score_timestamp desc) as order_rank
      from (select id, score,score_timestamp from recommend.quality_data_score WHERE order_rank=1
            union all
           select id, score,score_timestamp  from recommend.quality_data_source ) a
) b  where order_rank<2 ;
'