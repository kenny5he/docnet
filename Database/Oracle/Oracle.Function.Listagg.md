1. 组拼接
```sql
select
    listagg(mci.industry_en_name,'/') within group(order by level desc) industry_en_name
from mdm.mdm_cdh_industry_info_t mci where mci.public_flag = 'Y' and mci.status = 'Active'
start with mci.industry_id = 'IND200000994' connect by mci.industry_id = PRIOR mci.parent_id
group by connect_by_root(mci.industry_en_name)
```