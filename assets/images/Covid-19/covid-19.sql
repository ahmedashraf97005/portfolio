-- get list of all continents and countries  
SELECT distinct[Entity]
  FROM [Covid-19].[dbo].['covid-19-cases$']
  order by [Entity]


-- Merge tables and get comparison between ( cases & vaccine & icu & deaths ) and convert null : 0
select c.[Entity] , c.[Day] , c.[cases per million people] , COALESCE(v.[vaccine per million people], 0) as [vaccine per million people],
		COALESCE(i.[ICU occupancy per million people], 0) as [ICU occupancy per million people] ,
		COALESCE(d.[deaths per million people], 0) as [deaths per million people]

from [Covid-19].[dbo].['covid-19-cases$'] c
left join [Covid-19].[dbo].['covid-19-vaccine$'] v on c.Day = v.Day and c.Entity = v.Entity
left join [Covid-19].[dbo].['covid-19-icu$'] i on c.Day = i.Day and c.Entity = i.Entity
left join [Covid-19].[dbo].['covid-19-deaths$'] d on c.Day = d.Day and c.Entity = d.Entity


-- Remove continents and make them countries only and clean up duplicates
where c.Entity not in ('Africa' , 'Asia' , 'Europe' , 'European Union (27)' , 'North America' , 'South America',
						'World' , 'World excl. China' , 'World excl. China and South Korea' ,
						'World excl. China, South Korea, Japan and Singapore')


-- sortting
order by c.Day , c.Entity