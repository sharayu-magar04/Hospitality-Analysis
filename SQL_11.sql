select * from dim_date;
alter table dim_date change `week no` `week_no` text;
alter table dim_date change `mmm yy` `mmm_yy` text;
select * from dim_hotels;
select * from dim_rooms;
select * from fact_aggregated_bookings;
select * from fact_bookings;

select concat(ceil(sum(revenue_realized)/1000000),"M") as Total_Revenue from fact_bookings;

select concat(ceil(count(booking_id)/1000),"K") as Total_Booking from fact_bookings;

select concat(ceil(sum(capacity)/1000),"K") as Total_Capacity from fact_aggregated_bookings;

select concat(Format((sum(successful_bookings)/sum(capacity))*100,2),"%") as Occupancy from fact_aggregated_bookings;

select Format(sum(ratings_given)/(select count(*) from fact_bookings where ratings_given<>''),2) as Average_Rating
from fact_bookings;

select day_type,concat(round(sum(revenue_realized)/1000000),"M") as Day_type_Revenue,
concat(round(count(booking_id)/1000),"K") as Day_type_Booking
from fact_bookings F join dim_date D 
on date_format(F.booking_date,'%d-%b-%y')=D.date
group by day_type;

select week_no,concat(round(sum(revenue_realized)/1000000),"M") as Day_type_Revenue,
concat(round(count(booking_id)/1000,1),"K") as Day_type_Booking
from fact_bookings F join dim_date D 
on date_format(F.booking_date,'%d-%b-%y')=D.date
group by week_no;

select date_format(booking_date,"%M") as Month_name,
concat(round(sum(revenue_realized)/1000000),"M") as Monthly_Revenue,
concat(round(count(booking_id)/1000),"K") as Monthly_Booking
from fact_bookings group by date_format(booking_date,"%M");

select booking_status, Concat(Round(count(*)/1000),'K') as Status_Count,
concat(Round(count(*)/(select count(booking_status) from fact_bookings)*100,2),'%') as Statur_Rate
from fact_bookings group by booking_status;

select city,
concat(Round(sum(case when property_name='Atliq Bay' then F.revenue_realized else 0 end)/1000000),'M') Atliq_Bay,
concat(Round(sum(case when property_name='Atliq Blu' then F.revenue_realized else 0 end)/1000000),'M') Atliq_Blu,
concat(Round(sum(case when property_name='Atliq City' then F.revenue_realized else 0 end)/1000000),'M') Atliq_City,
concat(Round(sum(case when property_name='Atliq Exotica' then F.revenue_realized else 0 end)/1000000),'M') Atliq_Exotica,
concat(Round(sum(case when property_name='Atliq Grands' then F.revenue_realized else 0 end)/1000000),'M') Atliq_Grands,
concat(Round(sum(case when property_name='Atliq Palace' then F.revenue_realized else 0 end)/1000000),'M') Atliq_Palace,
concat(Round(sum(case when property_name='Atliq Seasons' then F.revenue_realized else 0 end)/1000000),'M') Atliq_Seasons
from fact_bookings F join dim_hotels H
on F.property_id=H.property_id
group by city order by city;

select room_class,
concat(Round(sum(case when property_name='Atliq Bay' then F.revenue_realized else 0 end)/1000000),'M') Atliq_Bay,
concat(Round(sum(case when property_name='Atliq Blu' then F.revenue_realized else 0 end)/1000000),'M') Atliq_Blu,
concat(Round(sum(case when property_name='Atliq City' then F.revenue_realized else 0 end)/1000000),'M') Atliq_City,
concat(Round(sum(case when property_name='Atliq Exotica' then F.revenue_realized else 0 end)/1000000),'M') Atliq_Exotica,
concat(Round(sum(case when property_name='Atliq Grands' then F.revenue_realized else 0 end)/1000000),'M') Atliq_Grands,
concat(Round(sum(case when property_name='Atliq Palace' then F.revenue_realized else 0 end)/1000000),'M') Atliq_Palace,
concat(Round(sum(case when property_name='Atliq Seasons' then F.revenue_realized else 0 end)/1000000),'M') Atliq_Seasons
from fact_bookings F join dim_hotels H
on F.property_id=H.property_id
join dim_rooms R on F.room_category=R.room_id
group by room_class order by room_class;