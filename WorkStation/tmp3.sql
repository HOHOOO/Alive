CREATE TABLE `sync_yuanchuang` (
  `id` int(10) unsigned NOT NULL DEFAULT '0',
  `uid` int(10) DEFAULT NULL,
  `anonymous` int(1) DEFAULT '0',
  `type` int(1) DEFAULT '0' COMMENT '0:??,1:?????,3:??,4:???,5:????? 6.???,8.????????9.????10.???????13.?????14.?????16.?????????17??????',
  `title` string(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `image` string(255) DEFAULT '' COMMENT '??',
  `comment_count` int(9) DEFAULT '0' COMMENT '???',
  `collection_count` int(9) DEFAULT '0' COMMENT '???',
  `love_rating_count` int(11) DEFAULT '0' COMMENT '???',
  `brand` string(255) DEFAULT '',
  `link` string,
  `mall` string(255) DEFAULT '',
  `is_delete` int(1) DEFAULT '0',
  `status` int(2) unsigned DEFAULT '0' COMMENT '0??,1?????,2?????,3?????,4??????5.????????6.????????',
  `publishtime` string DEFAULT '0001-01-01 00:00:00' COMMENT '????',
  `sum_collect_comment` int(11) DEFAULT '0' COMMENT '?????????????    ?? 3_2324323',
  `series_title_temp` string(255) DEFAULT '' COMMENT '?????????????',
  `title_series_title` string(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `article_type` int(4) DEFAULT '0' COMMENT '?????1?????2????,3?????4?????5?????6????',
  `recommend` int(4) DEFAULT '0' COMMENT '????????0?????1???',
  `recommend_display_time` string DEFAULT '0001-01-01 00:00:00' COMMENT '?????????????????????????',
  `export_from` string(50) DEFAULT '' COMMENT '?????????????????????',
  `transfer` int(1) DEFAULT '0' COMMENT '?????????0????1????',
  `reward_count` int(11) DEFAULT NULL,
  `hash_value` string(50) DEFAULT NULL COMMENT '????????MD5?',
  `flagfield` string(10) DEFAULT NULL COMMENT '????',
  `sync_date` string DEFAULT '0001-01-01 00:00:00' COMMENT '??????',
  PRIMARY KEY (`id`),
  KEY `uid` (`uid`),
  KEY `publishtime` (`publishtime`),
  KEY `arttype_t_pt_index` (`article_type`,`type`,`publishtime`) USING BTREE,
  KEY `t_re_pt_index` (`type`,`recommend_display_time`,`publishtime`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 |


 CREATE TABLE `sync_youhui` (
  `id` string(20) unsigned NOT NULL DEFAULT '0' COMMENT '??id',
  `editor_id` mediumint(11) DEFAULT '0' COMMENT '??id???????',
  `pubdate` string DEFAULT '0001-01-01 00:00:00' COMMENT '????',
  `choiceness_date` string DEFAULT '0001-01-01 00:00:00' COMMENT '????',
  `yh_status` int(4) DEFAULT '3' COMMENT '????? 1????2???? 3:??,??',
  `channel` int(1) DEFAULT NULL COMMENT '??',
  `comment_count` int(11) DEFAULT '0' COMMENT '???',
  `collection_count` int(11) DEFAULT '0' COMMENT '???',
  `praise` int(10) DEFAULT '0' COMMENT '?',
  `sum_collect_comment` int(11) DEFAULT '0' COMMENT '??>=???+???+??',
  `mall` string(200) DEFAULT '' COMMENT '??',
  `brand` string(200) DEFAULT '' COMMENT '??',
  `digital_price` string(50) DEFAULT '' COMMENT '????',
  `worthy` int(10) unsigned DEFAULT '0' COMMENT '????',
  `unworthy` int(10) unsigned DEFAULT '0' COMMENT '?????',
  `is_top` int(4) DEFAULT '0' COMMENT '?????????0????1??',
  `yh_type` string(50) DEFAULT '' COMMENT '????',
  `is_essence_for_editor` int(4) DEFAULT '0' COMMENT '????????????????????0????1??',
  `article_type` int(4) DEFAULT '0' COMMENT '0??? 1?? 2?? 3???? 4????',
  `mobile_exclusive` int(4) DEFAULT '0' COMMENT '????????0????1??????2????',
  `clean_link` string(600) DEFAULT '' COMMENT '????',
  `district` int(1) DEFAULT '1' COMMENT '1???    2??? 3??',
  `is_review` int(1) DEFAULT '0' COMMENT '0?????? ??? ??????? 1?????????? 2??????????',
  `faxian_show` int(1) DEFAULT '1' COMMENT '??????0??? 1??',
  `source_from` int(4) DEFAULT '1' COMMENT '???? 1????2????3?????4??5????6????7????8??C?',
  `strategy_pub` int(4) DEFAULT '0' COMMENT '0 ????? 1???? 2???????? 3??? 4????',
  `uhomedate` string DEFAULT '0001-01-01 00:00:00' COMMENT '????????',
  `update_timestamp` string DEFAULT '0001-01-01 00:00:00',
  `reward_count` int(11) DEFAULT '0' COMMENT '????',
  `mall_id` string(20) DEFAULT '0' COMMENT '??id',
  `brand_id` string(20) DEFAULT '0' COMMENT '??id',
  `b2c_id` string(20) DEFAULT NULL COMMENT 'b2c ???id',
  `spu_link` string(600) DEFAULT '' COMMENT '??????',
  `hash_value` string(50) DEFAULT NULL COMMENT '????????MD5?',
  `flagfield` string(10) DEFAULT NULL COMMENT '????',
  `sync_date` string DEFAULT '0001-01-01 00:00:00' COMMENT '??????',
  PRIMARY KEY (`id`),
  KEY `index_clean_link` (`clean_link`(255)) USING BTREE,
  KEY `pubdate` (`pubdate`),
  KEY `idx_choiceness_date` (`choiceness_date`),
  KEY `idx_mall_date` (`mall`,`pubdate`),
  KEY `idx_type` (`yh_type`,`choiceness_date`),
  KEY `idx_status_choiceness` (`channel`,`yh_status`,`choiceness_date`),
  KEY `idx_mall_choiceness_date` (`mall`,`choiceness_date`),
  KEY `idx_status_pubdate` (`yh_status`,`channel`,`is_top`,`faxian_show`,`pubdate`),
  KEY `idx_brand_choiceness_date` (`brand`,`choiceness_date`),
  KEY `ind_update_timestamp` (`update_timestamp`),
  KEY `uhomedate` (`uhomedate`),
  KEY `idx_status_choiceness_date` (`yh_status`,`channel`,`mall`,`choiceness_date`),
  KEY `spu_link` (`spu_link`(255))
) ENGINE=InnoDB DEFAULT CHARSET=utf8

CREATE TABLE `sync_youhui_extend` (
  `id` string(20) unsigned NOT NULL COMMENT '??id',
  `createdate` string DEFAULT '0001-01-01 00:00:00' COMMENT '????',
  `upstring` string DEFAULT '0001-01-01 00:00:00' COMMENT '????',
  `title_prefix` string(50) DEFAULT '' COMMENT '????',
  `title` string(1000) DEFAULT '' COMMENT '????',
  `subtitle` string(200) DEFAULT '' COMMENT '?????????',
  `phrase_desc` string(1000) DEFAULT '' COMMENT '??????????',
  `content` mediumstring CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `focus_pic_url` string COMMENT '??????????? ???????',
  `referrals` string(200) DEFAULT '' COMMENT '???',
  `direct_link` string COMMENT '????',
  `direct_link_name` string(1000) DEFAULT NULL COMMENT '????title',
  `direct_link_list` string COMMENT '??????',
  `sales_area` mediumint(9) DEFAULT '0' COMMENT '?????? smzdm_buy_domain??ID',
  `title_mode` int(4) DEFAULT '0' COMMENT '???????,0???1?????',
  `app_push` int(4) DEFAULT '0' COMMENT '?????????0????1???',
  `last_editor_id` mediumint(8) unsigned DEFAULT '0' COMMENT '???????id',
  `sync_home_id` string(20) unsigned DEFAULT '0' COMMENT '????????id',
  `source_from_id` string(20) DEFAULT '0' COMMENT '???????id???????????????id',
  `source_from_channel` int(4) DEFAULT '0' COMMENT '???????id?1???2???5?? 30 ?? ?1,2,5???????',
  `sina_id` string(30) DEFAULT '0' COMMENT '????id',
  `associate_brand` int(4) DEFAULT '0' COMMENT '????????0????1???',
  `associate_mall` int(4) DEFAULT '0' COMMENT '????????0????1???',
  `is_anonymous` int(4) DEFAULT '0' COMMENT '?????0????1??',
  `stock_status` int(4) DEFAULT '0' COMMENT '??????0???1????2???',
  `comment_switch` int(4) DEFAULT '1' COMMENT '?????1?? 0??',
  `push_type` int(4) DEFAULT '1' COMMENT '?????0????1?????2???????3????',
  `guonei_id_for_fx` string(20) DEFAULT '0' COMMENT '??????????????id??????',
  `haitao_id_for_fx` string(20) DEFAULT '0' COMMENT '??????????????id??????',
  `sync_home` int(4) DEFAULT '0' COMMENT '??????????0????1?????2???? ',
  `sync_home_time` string DEFAULT '0001-01-01 00:00:00' COMMENT '?????????',
  `is_home_top` int(4) DEFAULT '0' COMMENT '?????????0????1??',
  `edit_page_type` int(4) DEFAULT '1' COMMENT '??????1????2???',
  `hash_value` string(50) DEFAULT NULL COMMENT '????????MD5?',
  `flagfield` string(10) DEFAULT NULL COMMENT '????',
  `sync_date` string DEFAULT '0001-01-01 00:00:00' COMMENT '??????',
  `starttime` string DEFAULT '0001-01-01 00:00:00' COMMENT '??????',
  `endtime` string DEFAULT '0001-01-01 00:00:00' COMMENT '??????',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 |

CREATE TABLE `sync_yuanchuang_extend` (
  `id` int(10) unsigned NOT NULL DEFAULT '0',
  `edit_uid` int(9) DEFAULT '0' COMMENT '????UID',
  `updateline` string DEFAULT '0001-01-01 00:00:00' COMMENT '??????',
  `dateline` string DEFAULT '0001-01-01 00:00:00' COMMENT '????',
  `submit_time` string DEFAULT '0001-01-01 00:00:00' COMMENT '??????',
  `last_submit_time` string DEFAULT '0001-01-01 00:00:00' COMMENT '????????',
  `audit_times` int(4) DEFAULT '0' COMMENT '????',
  `sina_id` string(20) DEFAULT '0',
  `tencent_id` string(20) DEFAULT '0',
  `remark` string COMMENT '??????',
  `plid` string(20) DEFAULT '0' COMMENT '??ucenter????id',
  `district` int(1) DEFAULT '0' COMMENT '?? 0 ?? 1????????',
  `have_read` int(1) DEFAULT '0' COMMENT '???? 0?? 1??',
  `add_modify` string COMMENT '??????',
  `add_modify_time` string DEFAULT '0001-01-01 00:00:00' COMMENT '??????',
  `seo_title` string(255) DEFAULT '' COMMENT 'seo??',
  `seo_keywords` string(255) DEFAULT '' COMMENT 'seo???',
  `seo_description` string(500) DEFAULT '' COMMENT 'seo????',
  `series_id` int(10) DEFAULT '0' COMMENT '????ID',
  `series_order_id` int(5) DEFAULT '0' COMMENT '????ID',
  `push_type` int(1) DEFAULT '1' COMMENT '0????1?????2???????3????',
  `baidu_doc_id` string(100) DEFAULT '0' COMMENT '????id',
  `probreport_id` string(20) unsigned DEFAULT '0' COMMENT '????id',
  `is_write_post_time` string DEFAULT '0001-01-01 00:00:00' COMMENT '?????????set_auto_sync????????????????????',
  `set_auto_sync` int(1) DEFAULT '0' COMMENT '????????????1????????2???????',
  `is_home_top` int(1) DEFAULT '0' COMMENT '?????????',
  `from_vote` string(20) unsigned DEFAULT '0' COMMENT '????vote_id????0',
  `comment_switch` int(4) DEFAULT '1' COMMENT '?????1?? 0??',
  `associate_brand` int(3) unsigned DEFAULT '0' COMMENT '????????0????1???',
  `associate_mall` int(3) unsigned DEFAULT '0' COMMENT '????????0????1???',
  `hash_value` string(50) DEFAULT NULL COMMENT '????????MD5?',
  `flagfield` string(10) DEFAULT NULL COMMENT '????',
  `sync_date` string DEFAULT '0001-01-01 00:00:00' COMMENT '??????',
  PRIMARY KEY (`id`),
  KEY `probreport_id` (`probreport_id`) USING BTREE,
  KEY `series_id` (`series_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 |