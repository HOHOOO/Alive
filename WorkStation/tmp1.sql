drop table recommend.tag_relation_user_preference_long_term;
drop table recommend.tag_relation_user_preference_level_3;
drop table recommend.tag_relation_user_preference_level_3_simple;
drop table recommend.tag_relation_count_left;
drop table recommend.tag_relation_count_right;







select "关联三级标签";
create table recommend.tag_relation_user_preference_long_term as select user_proxy_key, split(tag_id,"_")[0] as channel, split(tag_id,"_")[1] as tag_id , user_tag_weight FROM recommend.dw_cp_user_preference_long_term where ds>'2017-09-23';


select "若不做限制，三级品类105569616，用户数320w";
select "限制时间后，71235142/2458673";
create table recommend.tag_relation_user_preference_level_3 as select user_proxy_key,tag_id,user_tag_weight from recommend.tag_relation_user_preference_long_term  a left join default.level_3_1 b on a.tag_id=b.level_3_id and a.channel='cate' where b.level_3_id is not null;
select "限制用户最大浏览20 和最小数值0.005 后，12447811/2451193（少的用户是因为权重都小于0.005？）";
CREATE TABLE recommend.tag_relation_user_preference_level_3_simple AS select tag_id,user_proxy_key from (SELECT tag_id,user_proxy_key,user_tag_weight,count() over (partition by user_proxy_key) tag_sum, row_number () over (partition by user_proxy_key ORDER BY user_tag_weight DESC) rank FROM recommend.tag_relation_user_preference_level_3) t where tag_sum>5 and rank<20 and user_tag_weight>0.005;

select "计算标签出现次数";
CREATE TABLE recommend.tag_relation_count_left AS SELECT tag_id,count(DISTINCT user_proxy_key) user_num,row_number () over (ORDER BY count(DISTINCT user_proxy_key) DESC) rank FROM recommend.tag_relation_user_preference_level_3_simple GROUP BY tag_id;
create table recommend.tag_relation_count_right as select * from recommend.tag_relation_count_left;

select "计算共现矩阵";
CREATE TABLE recommend.tag_relation_user_preference_level_3_simple_mirror as select tag_id,user_proxy_key from recommend.tag_relation_user_preference_level_3_simple;
CREATE TABLE recommend.tag_relation_count_cross AS SELECT t.tag_id_1,t.tag_id_2,t.num FROM (SELECT t1.tag_id AS tag_id_1,t2.tag_id AS tag_id_2,count(DISTINCT t2.user_proxy_key) AS num FROM recommend.tag_relation_user_preference_level_3_simple t1 CROSS JOIN recommend.tag_relation_user_preference_level_3_simple_mirror t2 ON t1.user_proxy_key=t2.user_proxy_key WHERE t1.tag_id<> t2.tag_id GROUP BY t1.tag_id,t2.tag_id) t;

select "标签之间相似度";
CREATE TABLE recommend.tag_relation_collaborative AS SELECT t1.tag_id_1 AS tag_id_1,t2.user_num_1 AS user_num_1,t1.tag_id_2 AS tag_id_2,t3.user_num_2 AS user_num_2,t1.num AS num,(t1.num/sqrt(t2.user_num_1*t3.user_num_2)) AS power,row_number () over (ORDER BY (t1.num/sqrt(t2.user_num_1*t3.user_num_2)) DESC) rank FROM recommend.tag_relation_count_cross t1 LEFT JOIN (SELECT tag_id,user_num AS user_num_1 FROM recommend.tag_relation_count_left) t2 ON t1.tag_id_1=t2.tag_id LEFT JOIN (SELECT tag_id,user_num AS user_num_2 FROM recommend.tag_relation_count_right) t3 ON t1.tag_id_2=t3.tag_id GROUP BY t1.tag_id_1,t2.user_num_1,t1.tag_id_2,t3.user_num_2,t1.num,(t1.num/sqrt(t2.user_num_1*t3.user_num_2));

CREATE TABLE recommend.tag_relation_collaborative_top10 AS SELECT tag_id_1,tag_id_2,power FROM (SELECT tag_id_1,tag_id_2,power,row_number () over (PARTITION BY tag_id_1 ORDER BY power DESC) row_id FROM recommend.tag_relation_collaborative) t1 WHERE t1.row_id<10;







create table recommend.tag_relation_collaborative
    as
    select t1.tag_id_1 as ta_id_1,
       t2.user_num_1 as user_num_1,
       t1.tag_id_2 as tag_id_2,
       t3.user_num_2 as user_num_2,
       t1.num as num,
       (t1.num/sqrt(t2.user_num_1 * t3.user_num_2)) as power,
       row_number() over(order by (t1.num/sqrt(t2.user_num_1 * t3.user_num_2)) desc) rank
      from recommend.tag_relation_count_cross t1
   left join (select tag_id,
              user_num as user_num_1
         from recommend.tag_relation_count_left
         ) t2
      on t1.tag_id_1 = t2.tag_id
   left join (select tag_id,
              user_num as user_num_2
         from recommend.tag_relation_count_right
         ) t3
      on t1.tag_id_2 = t3.tag_id
    group by t1.ta_id_1,
        t2.user_num_1,
        t1.tag_id_2,
        t3.user_num_2,
        t1.num,
            (t1.num/sqrt(t2.user_num_1 * t3.user_num_2))



            create table recommend.tag_relation_collaborative_top10
              as
              select tag_id_1,
            		 tag_id_2,
            		 power
            	from (select tag_id_1,
            				 tag_id_2,
            				 power,
            				 row_number() over(partition by tag_id_1 order by power desc) row_id
            			from recommend.tag_relation_collaborative
            			) t1
            			where t1.row_id=1
