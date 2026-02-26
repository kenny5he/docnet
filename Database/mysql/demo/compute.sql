/*二目运算*/
DROP FUNCTION IF EXISTS compute;
CREATE FUNCTION compute(v1 DECIMAL(19,4), o CHAR(2), v2 DECIMAL(19,4)) RETURNS DECIMAL(19,4)
BEGIN
    IF(o = '+')
    THEN
        RETURN v1 + v2;
    ELSEIF(o = '-')
    THEN
        RETURN v1 - v2;
    ELSEIF(o = '*')
    THEN
        RETURN v1 * v2;
    ELSEIF(o = '/')
    THEN
        RETURN v1 / v2;
    ELSEIF(o = '=')
    THEN
        RETURN v1 = v2;
    ELSEIF(o = '!=')
    THEN
        RETURN v1 != v2;
    ELSEIF(o = '&&')
    THEN
        RETURN v1 AND v2;
    ELSEIF(o = '||')
    THEN
        RETURN v1 OR v2;
    ELSEIF(o = '>')
    THEN
        RETURN v1 > v2;
    ELSEIF(o = '>=')
    THEN
        RETURN v1 >= v2;
    ELSEIF(o = '<')
    THEN
        RETURN v1 < v2;
    ELSEIF(o = '<=')
    THEN
        RETURN v1 <= v2;
    ELSE
        RETURN 0;
    END IF;
END;



/*执行表达式*/
CREATE FUNCTION eval(express VARCHAR(2000)) RETURNS DOUBLE
BEGIN
    DECLARE hasValue TINYINT;
    DECLARE r DOUBLE;/*结果*/
    DECLARE l INT;
    DECLARE i INT;
    DECLARE lt INT;/*临时*/
    DECLARE it INT;/*临时*/
    DECLARE c CHAR;/*当前字符*/
    DECLARE t CHAR;/*双字操作符前一个字符*/
    DECLARE tt VARCHAR(200); /*临时*/
    DECLARE o VARCHAR(20); /*操作符*/
    DECLARE v VARCHAR(20); /*值*/
    DECLARE v1 DOUBLE;/*结果*/
    DECLARE v2 DOUBLE;/*结果*/

    DECLARE stack VARCHAR(4000); /*堆栈*/
    
    DECLARE fc INT;/*搜索括号计数*/
    DECLARE fi INT;/*搜索括号指针*/
    SET r = 0;
    SET hasValue = 0;

    SET l = LENGTH(express);
    SET i = 1;
    SET t = '';
    SET v = '';
    SET o = '';
    set stack = '';

    _loop : LOOP
        IF(i > l)
        THEN
            SET c = '';
        ELSE
            SET tt = SUBSTRING(express, i, 1);
            SET c = if(tt = ' ', 'S', tt);
        END IF;
        IF(c = '')
        THEN /*表达式结束*/
            IF(v != '')
            THEN
                SET v2 = v;
                set v = '';
                IF (o != '')
                THEN
                    IF (hasValue = 0)
                    THEN
                        IF (o = '-')
                        THEN
                            SET r = -v2;
                        ELSE
                            /*无前操作数*/
                            /*set _log = concat(_log, ',no v1');*/
                            set r = NULL;
                            set i = l + 1;
                        END IF;
                        SET hasValue = 1;
                    ELSE
                        SET r = compute(r, o, v2);
                    END IF;
                ELSEIF (hasValue = 0)
                THEN
                    SET r = v2;
                    SET hasValue = 1;
                ELSE
                    /*无操作符*/
                    set r = NULL;
                    set i = l + 1;
                END IF;
            ELSEIF (o != '' OR t = '!' OR t = '<' OR t = '〉' OR t = '&' OR t = '|')
            THEN
                /*无后操作数或操作符不全*/
                set r = NULL;
                set i = l + 1;
            END IF;
        ELSEIF (c = ')')
        THEN
            /*未匹配的右括号*/
            set r = NULL;
            set i = l + 1;
        ELSE        
            IF (v != '' AND LOCATE(c,'0123456789.') = 0)
            THEN
                /*数字结束*/
                SET v2 = v;
                set v = '';
                IF (o != '')
                THEN
                    IF (hasValue = 0)
                    THEN
                        IF (o = '-')
                        THEN
                            SET r = -v2;
                        ELSE
                            /*无前操作数*/
                            set r = NULL;
                            set i = l + 1;
                        END IF;
                        SET hasValue = 1;
                    ELSE
                        SET r = compute(r, o, v2);
                    END IF;
                    SET o = '';
                ELSEIF (hasValue = 0)
                THEN
                    SET r = v2;
                    SET hasValue = 1;
                ELSE
                    /*无操作符*/
                    set r = NULL;
                    set i = l + 1;
                END IF;
            END IF;

            if(i <= l)
            then                
                IF (t = '!' AND c != '=' OR t = '<' AND c != '>' AND c != '=' OR t = '>' AND c != '=') /*非、大于、小于*/
                THEN
                    if(o != '' and t != '!')
                    then
                        /*多余的操作数*/
                        set r = NULL;
                        set i = l + 1;
                    else
                        /*搜索下一个表达式或者值*/
                        SET fc = 0;
                        SET fi = i;
                        SET tt = '';
                        SET v = '';
                        WHILE (fi <= l AND (tt = '' OR fc > 0))
                        DO
                            SET c = SUBSTRING(express,fi, 1);
                            IF (c = '(')
                            THEN
                                SET tt = '(';
                                SET fc = fc + 1;
                            ELSEIF (c = ')')
                            THEN
                                SET fc = fc - 1;
                            ELSEIF (tt = '' AND LOCATE(c, '0123456789.'))
                            THEN
                                SET tt = '0';
                                SET fc = 1;
                            ELSEIF (tt = '0' AND LOCATE(c, '0123456789.') = 0)
                            THEN
                                SET fc = 0;
                                SET fi = fi - 1;
                            END IF;
                            SET fi = fi + 1;
                        END WHILE;

                        IF (fc = 0 OR tt = '0')
                        THEN
                            /*当前状态入栈，并初始化变量*/
                            set stack = concat(stack ,'$',hasValue,',',ifnull(r, ''),',',o,',',t,',',l,',',fi);
                            /*set _log = concat(_log, ',not:',substring(express, i, fi - i), ',push:[',hasValue,',',ifnull(r, ''),',',o,',',t,',',l,',',fi,']');*/
                            set i = i;
                            set l = fi - 1;
                            set hasValue = 0;
                            set r = 0;
                            set t = '';
                            SET o = '';
                            set v = '';

                            /*开始新的循环*/
                            ITERATE _loop;
                        ELSE
                            /*没有找到操作数*/
                            set r = NULL;
                            set i = l + 1;
                        END IF;
                    END if;
                ELSEIF (c = '(')
                THEN
                    /*寻找匹配的)*/
                    SET fc = 1;
                    SET i = i + 1;
                    SET fi = i;
                    WHILE (fi <= l AND fc > 0)
                    DO
                        SET c = SUBSTRING(express,fi, 1);
                        IF (c = '(')
                        THEN
                            SET fc = fc + 1;
                        ELSEIF (c = ')')
                        THEN
                            SET fc = fc - 1;
                        END IF;
                        SET fi = fi + 1;
                    END WHILE;

                    IF (fc = 0)
                    THEN
                        
                        /*当前状态入栈，并初始化变量*/
                        set stack = concat(stack ,'$',hasValue,',',ifnull(r, ''),',',o,',','',',',l,',',fi);
                        /*set _log = concat(_log, ',sub:',substring(express, i, fi - 1 - i), ',push:[',hasValue,',',ifnull(r, ''),',',o,',',t,',',l,',',fi,']');*/
                        set i = i;
                        set l = fi - 2;
                        set hasValue = 0;
                        set r = 0;
                        set t = '';
                        SET o = '';
                        set v = '';

                        /*开始新的循环*/
                        ITERATE _loop;
                    ELSE /*没有找到匹配的右括号*/                        
                        /*set _log = concat(_log, ',no )');*/
                        set r = NULL;/*无操作符*/
                        set i = l + 1;
                    END IF;
                ELSEIF (LOCATE(c, '0123456789.') > 0)
                THEN
                    /*找到数字*/
                    IF (v = '')
                    THEN
                        SET v = c;
                    ELSE
                        SET v = CONCAT(v, c);
                    END IF;
                ELSEIF(LOCATE(c,'!<>|&=+-*/'))
                THEN
                    SET tt = '';
                    IF (t = '!' AND c = '=')
                    THEN
                        SET tt = '!=';
                    ELSEIF (t = '<' AND c = '>')
                    THEN
                        SET tt = '!=';
                    ELSEIF (t = '|' AND c = '|')
                    THEN
                        SET tt = '||';
                    ELSEIF (t = '&' AND c = '&')
                    THEN
                        SET tt = '&&';
                    ELSEIF (t = '' AND c = '=')
                    THEN
                        SET tt = '=';
                    ELSEIF (t = '>' AND c = '=')
                    THEN
                        SET tt = '>=';
                    ELSEIF (t = '<' AND c = '=')
                    THEN
                        SET tt = '<=';
                    ELSEIF (t = '' AND c = '+')
                    THEN
                        SET tt = '+';
                    ELSEIF (t = '' AND c = '-')
                    THEN
                        SET tt = '-';
                    ELSEIF (t = '' AND c = '*')
                    THEN
                        SET tt = '*';
                    ELSEIF (t = '' AND c = '/')
                    THEN
                        SET tt = '/';
                    END IF;

                    IF (o != '' AND tt != '')
                    THEN
                        set r = NULL; /*多个操作符*/
                        set i = l + 1;
                    ELSEIF (tt != '')
                    THEN
                        SET o = tt;
                        SET t = '';
                    ELSEIF (c = '!' OR c = '<' OR c = '>' OR c = '&' OR c = '|')
                    THEN
                        IF(t = '')
                        THEN
                            SET t = c;
                        ELSE
                            set r = NULL; /*错误的操作符*/
                            set i = l + 1;
                        END IF;
                    END IF;
                ELSEIF(LOCATE(c, ' S\r\n\t') = 0)
                THEN
                    set r = NULL; /*无效字符*/
                    set i = l + 1;
                END IF;
            END IF;
        END IF;

        SET i = i + 1;
        if(i > l + 1)
        then
            if (stack != '') /*堆栈未空，返回上一层*/
            then
                set l = 0;
                repeat
                    set l = locate('$',stack, l + 1);
                    if(l != 0)
                    then
                        set i = l;
                    end if;
                until l = 0 end repeat;

                set tt = substring(stack, i + 1);
                set stack = substring(stack, 1, i - 1);
                /*恢复上一层环境，并计算 concat('$',hasValue,',',v1,',',o,',',t,',',l,',',fi - 1);*/
                set i = 1;
                set it = 1;
                set lt = 0;
                repeat
                    set lt = locate(',',tt, lt + 1);
                    if(i = 1)
                    then
                        set hasValue = substring(tt, it, lt - it);
                    elseif(i = 2)
                    then
                        set v1 = substring(tt, it, lt - it);
                    elseif(i = 3)
                    then
                        set o = substring(tt, it, lt - it);
                    elseif(i = 4)
                    then
                        set t = substring(tt, it, lt - it);
                    elseif(i = 5)
                    then
                        set l = substring(tt, it, lt - it);
                    elseif(i = 6)
                    then
                        set i = substring(tt, it);
                    end if;

                    if(lt != 0)
                    then
                        set it = lt + 1;
                        set i = i + 1;
                    end if;
                until lt = 0 end repeat;

                if(t = '!')
                then
                    set r = not r;
                elseif(t != '')
                then
                    set o = t;
                end if;
                set t = '';

                IF (o != '')
                THEN
                    IF (hasValue = 0)
                    THEN
                        IF (o = '-')
                        THEN
                            SET r = -r;
                        ELSE
                            SET r = NULL;
                        END IF;
                        SET hasValue = 1;
                    ELSE
                        SET r = compute(v1, o, r);
                    END IF;
                    SET o = '';
                ELSEIF (hasValue = 0)
                THEN
                    SET hasValue = 1;
                ELSE
                    /*无操作符*/
                    set r = NULL;
                    set i = l + 1;
                END IF;
            else
                LEAVE _loop;
            end if;
        end if;
    END LOOP;
        RETURN r;
END;