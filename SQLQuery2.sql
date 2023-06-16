select * from project.dbo.data2;
select * from project.dbo.data1;

-- dataset for Jharkhand and Bihar

select * from project..data1 where state in ('Jharkhand','Bihar')

-- population of India

select sum(population) Population from project..data2 

-- Average Growth % per state

select state,avg(growth)*100 as Avg_Growth from project..data1 group by state;

-- Average Sex Ratio 

select state, round(avg(sex_ratio),0) avg_ratio from project..data1
group by state
order by avg_ratio desc;

-- Average Literacy Ratio of states more than 90

select state, round(avg(literacy),0) avg_literacy_ratio from project..data1
group by state
having round(avg(literacy),0) > 90
order by avg_literacy_ratio desc;

--Top 3 states showing highest growth ratio

select top 3 state,avg(growth)*100 as Avg_Growth from project..data1 
group by state
order by Avg_Growth desc;

--Bottom 3 states showing lowest sex ratio

select top 3 state, round(avg(sex_ratio),0) avg_ratio from project..data1
group by state
order by avg_ratio asc; 

-- States starting with letter "A" or ending with letter "D"

select distinct state from project..Data1
where state like 'a%' or state like '%d';

--Joining both tables

select a.district,a.state,a.sex_ratio,b.population from project..Data1 a inner join project..Data2 b on a.district = b.district

--Total number of males and females per state

select d.state,sum(d.males) total_males,sum(d.females) total_females from
(select c.district,c.state,round(c.population/(c.sex_ratio+1),0) males, round((c.population*sex_ratio)/(c.sex_ratio+1),0) females from
(select a.district,a.state,a.sex_ratio/1000 sex_ratio,b.population from project..Data1 a inner join project..Data2 b on a.district = b.district) c) d
group by state
-- (equations for males and females in terms of population and sex_ratio, substituted from, females/males = sex_ratio and females + males = population)

--Total literate and illiterate population rate per state

select d.state, sum(d.literate_people) total_literate_population,sum(d.illiterate_people) total_illiterate_population from
(select c.district, c.state, round(c.literacy_ratio*c.population,0) literate_people,round((1-c.literacy_ratio)*c.population,0) illiterate_people from
(select a.district,a.state,a.literacy/100 literacy_ratio,b.population from project..Data1 a inner join project..Data2 b on a.district = b.district) c)d
group by state
--(literate people = literacy_ratio*population & illiterate people = (1-literacy_ratio)*population)



--Population in previous census

select sum(e.previous_census_population) total_previous_census_population, sum(e.current_census_population) total_current_census_population from
(select d.state,sum(d.previous_census_population) previous_census_population,sum(d.current_census_population) current_census_population from
(select c.district,c.state, round(c.population/(1+c.growth),0) previous_census_population,population current_census_population from
(select a.district,a.state,a.growth,b.population from project..Data1 a inner join project..Data2 b on a.district = b.district)c)d
group by state)e
--( formula for previous census population derived from previous_census + growth*previous_census = population)









