
CREATE TABLE tbl_calculate_test(
id bigint(10) UNSIGNED NOT NULL AUTO_INCREMENT comment '计算Id、非空、递增、唯一，可作主键',
amount decimal(18,6) comment '销售金额',
cg_amount decimal(18,6) comment '采购金额',
test_amount decimal(18,6) comment '测试金额',
fl_amount decimal(18,6) comment '辅料金额',
commission decimal(10,6) comment '佣金比',
PRIMARY KEY(id)
) comment='计算测试表';

INSERT INTO tbl_calculate_test
(amount, cg_amount, test_amount, fl_amount, commission)
VALUES(42917.32, 18426.94, 841.74, 1714.31, 0.01);

DROP FUNCTION IF EXISTS `compute_test`;
CREATE FUNCTION `compute_test`(ORDER_DETAIL_ID BIGINT(20)) RETURNS DECIMAL(19,4)
BEGIN
	-- 注释
    DECLARE amount decimal(19,4) default 0.0000;
    DECLARE commission double(11,4) default 0.0000;
   	DECLARE cg_amount decimal(19,4) default 0.0000;
   	DECLARE fl_amount decimal(19,4) default 0.0000;
   	DECLARE cs_amount decimal(19,4) default 0.0000;
   	DECLARE customer_rate decimal(19,4) default 0.0000;
   	DECLARE RESULT_VALUE decimal(19,4) default 0.0000;
   
    SELECT (tct.amount-tct.cg_amount-tct.test_amount-tct.fl_amount - (tct.amount * tct.commission))/tct.amount
   	FROM tbl_calculate_test tct WHERE id=1 INTO RESULT_VALUE;
    RETURN RESULT_VALUE;
END;

select compute_test(111);