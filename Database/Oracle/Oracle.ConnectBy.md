### Oracle 层级查询
#### 语法

{ CONNECT BY [ NOCYCLE ] condition [AND condition]... [ START WITH condition ]
| START WITH condition CONNECT BY [ NOCYCLE ] condition [AND condition]...}

1. 释义:
    - start with: 指定起始节点的条件
    - connect by: 指定父子行的条件关系
    - prior: 查询父行的限定符，格式: prior column1 = column2 or column1 = prior column2 and ... ，
    - nocycle: 若数据表中存在循环行，那么不添加此关键字会报错，添加关键字后，便不会报错，但循环的两行只会显示其中的第一条循环行: 该行只有一个子行，而且子行又是该行的祖先行
    - connect_by_iscycle: 前置条件:在使用了nocycle之后才能使用此关键字，用于表示是否是循环行，0表示否，1 表示是
    - connect_by_isleaf: 是否是叶子节点，0表示否，1 表示是
    - level: level伪列,表示层级，值越小层级越高，level=1为层级最高节点
2. 使用案例
```sql
select 
    hp_cont.party_name partyName,
    hp_cont.party_id subjectId,
    hp_cust.party_name companyName,
    hp_cust.party_id partyId,
    (
        select listagg(hcp.phone_number,'/') within group(order by 1)
        from apps.hz_contact_points hcp
        where hcp.owner_table_id = hr.party_id
        and hcp.contact_point_type = 'PHONE'
        and hcp.status = 'A'
    ) as phoneNumber,
    from 
        apps.hz_parties hp_cont,
        apps.hz_relationships hr
        apps.hz_cust_accounts hca
    where 1 = 1
    and hr.subject_id = hp_cont.part_id
    and hr.object_id = hp_cust.party_id
    and hr.subject_type = 'PHONE'
    and hr.object_type = 'ORGANIZATION'
    
```