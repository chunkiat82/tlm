--Script for Added Countries--
export count=0;
for i in `cat country.txt`; 
do 
let "count+=1";
j=$(echo $i | sed 's/\_/ /g' | sed 's/.png//g'); 
k=$(echo $i | sed 's/\_//g' | sed 's/.png//g');
l=$(echo $k | tr '[:lower:]' '[:upper:]');
m=$(echo ${l:0:4});
echo 'new Country(code:"'$m'",title:"'$j'",image:"'$i'").save()'
done 

insert into country (id, version, title, code)
select id,"0",title, code FROM portal.country

insert into supplier (id, version, fax,  website,country_id,address,email,description,company,telephone,mobile)
select id,"0",fax,website,178,address,email,description,company,tel,"" FROM portal.supplier

insert into publication_suppliers (supplier_id,publication_id)
select id, 1 from supplier

insert into event (id, version, start_date,location, event_link,event_name,end_date,org_name,org_link)
select id, "0",CONCAT(year,"-",month,"-",day),location, event_hyperlink,event, CONCAT(eyear,"-",emonth,"-",eday),org,org_hyperlink  from portal.event

delete from publication where id>100