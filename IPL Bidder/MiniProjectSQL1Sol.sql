use ipl;
select * from ipl_bidder_details;
select * from ipl_bidder_points;
select * from ipl_bidding_details;
select * from ipl_match;
select * from ipl_match_schedule;
select * from ipl_player;
select * from ipl_stadium;
select * from ipl_team;
select * from ipl_team_players;
select * from ipl_team_standings;
select * from ipl_tournament;
select * from ipl_user;
show tables;


###############################################################################################

-- Q1 1.	Show the percentage of wins of each bidder in the order of highest to lowest percentage.
 
select bd.bidder_id `Bidder ID`,bd.bidder_name `Bidder Name`,round((count(bid.bid_status)/bp.no_of_bids)*100,2) `Win%`
from ipl_bidding_details bid join ipl_bidder_details bd on bid.bidder_id = bd.bidder_id 
join ipl_bidder_points bp on bd.bidder_id = bp.bidder_id
where bid.bid_status = 'won' group by bd.bidder_id order by bd.bidder_id;

-- Q2	Display the number of matches conducted at each stadium with stadium name, city from the database.

select s.stadium_id `Stadium Id`, s.stadium_name `Stadium name`,s.city,count(s.stadium_id) `No. of Matches Conducted`
from ipl_stadium s join ipl_match_schedule ms on s.stadium_id = ms.stadium_id
group by s.stadium_id order by s.stadium_id;

######################################################################################

-- Q3	In a given stadium, what is the percentage of wins by a team which has won the toss?

select s.stadium_id `Stadium Id`,s.stadium_name `Stadium Name`, (count(m.match_id)),
m.toss_winner,m.match_winner,
case
when toss_winner = match_winner then count(toss_winner)/count(s.stadium_id) * 100
end `%win`
from ipl_match m join ipl_match_schedule ms on ms.match_id = m.match_id
join ipl_stadium s on s.stadium_id = ms.stadium_id
group by s.stadium_id order by s.stadium_id;

select s.stadium_id `Stadium Id`,s.stadium_name `Stadium Name`,
case
when toss_winner = match_winner then count(match_winner)
end win, 
toss_winner,match_winner
from ipl_match m join ipl_match_schedule ms on ms.match_id = m.match_id
join ipl_stadium s on s.stadium_id = ms.stadium_id;

######################################################################################################
-- Q4	Show the total bids along with bid team and team name.

select bid_team `Bid Team`,team_name `Team Name`,count(bid_team) `Total Bid`
from ipl_bidding_details bd join ipl_team t on bd.bid_Team = t.team_id group by bid_team order by bid_team;

#############################################################################################################
-- Q5  Show the team id who won the match as per the win details.

select match_id `Match Id`, 
case 
when match_winner = 1 then team_id1
else team_id2
end `Winner Team Id`,
win_details `Win Details` 
from ipl_match;

##############################################################################################
-- Q6  Display total matches played, total matches won and total matches lost by team along with its team name.

select t.team_id `Team ID`,team_name `Team Name`,  sum(matches_played) `Total Matches Played`,Sum(matches_won) `Total Matches Won`,
sum(matches_lost) `Total Matches Lost`
from ipl_team_standings ts join ipl_team t on ts.team_id = t.team_id group by t.team_id order by tournmt_id; 

###############################################################################################
-- Q7	Display the bowlers for Mumbai Indians team.

select tp.player_id `Player ID`, player_name `Player Name`
from ipl_team_players tp join ipl_player p on tp.player_id = p.player_id
where tp.player_role ='bowler' and tp.remarks like '%MI%' order by tp.player_id;

###############################################################################################3
-- Q8 How many all-rounders are there in each team, Display the teams with more than 4 all-rounder in descending order.

select tp.team_id `Team ID`, team_name `Team Name`,count(team_name) `No. of All Rounder`
from ipl_team_players tp join ipl_team t on tp.team_id = t.team_id
where tp.player_role ='All-rounder' group by tp.team_id Having count(team_name) >4 order by count(team_name) desc;