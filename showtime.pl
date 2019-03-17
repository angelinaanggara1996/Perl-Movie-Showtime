use LWP::Simple;
use strict;
use utf8;

binmode(STDOUT, ':encoding(big5)'); #read chinese characters

#websites
my @url=("http://www.atmovies.com.tw/showtime/theater_t06608_a06.html",	 	#guobing
	"http://www.atmovies.com.tw/showtime/theater_t06607_a06.html",		#xinguang
	"http://www.atmovies.com.tw/showtime/theater_t06609_a06.html");		#viewshow


my $sq; # for list
my $type;	#movie version
my $i;		#recursion use

#3 websites              
for($i=0; $i<3; $i++)
{
	my $title; #movie name
	my $page = get $url[$i]; #get the website
	
	my $pgbegin='<div style="margin-bottom:0px;border:0px solid #ccc;">'; #search the beginning of the page to start for
	my $pgclear='<BR clear="both">'; #the end of page that we gonna use
	#my $limit='</div><!--showtime_block end-->'; 	#limit for the time recursive

	my $up='<li class="filmTitle">';	#search film title
        my $end='<li class="theaterElse">';      #search the end of that film         

	#take the middle of the page beginning and the end
        if($page =~ /$pgbegin(.*?)$pgclear/s)
        {
    	   	$page =~ /<h2>(.*?)<(\/)h2>/; #search theater name
		print "\n-------------".$1."-------------\n"; 	#get theater name and print out

       	        while($page =~ /$up(.*?)$end/gs)		#take the lists from film title to the end of that movie
		{
                	my @list=($page =~ /$up(.*?)$end/s); 	#assign to list array
                        foreach $sq(@list)			#let sq become the part of each list
			{
				my $temp; 
                       		($title, $temp)= ($page=~ /<a href="\/movie\/\S+\/">(.*?)<\/a>(.*)/s); #get title and temp
                       		($type)=($sq=~ /<li class="filmVersion">(.*?)<\/li>/); #get movie version
			
				print "\n$title\n$type\n";	#print out title and the version of the movie
                        
				$page= $temp;	#assign the next list of the movie to page
   			
				my $vie; #for viewshow 
                        	my $tget;	#time get!
				#if the time is between <li> and </li> from the up til the end
                      		if($sq =~ /<li>((\S*(\s*\<\/li\>\S*\s+)*)+)<\/li\>/) #get all the time
				{
                        		($tget)=($sq =~ /<li>((\S*(\s*\<\/li\>\S*\s+)*)+)<\/li\>/); #assign to tget
                        		$tget=~ s/[ \r\n\t]//g; #line breaks
					$tget =~ s/<\/li><li>/\n/g;  #replace </li><li> to a new line
					print "$tget\n"; #print out the time
				}                     
				if($sq=~/<li><a href="\/showtime\/ticket\/\S+\/" class="openbox">(.*?)<.*?/)
                      		{
					#for viewshow only
                       			#($vie)=($sq=~/<li><a href="\/showtime\/ticket\/\S+\/" class="openbox">(.*?)<(.*?)<\/li\>/);
                       			print"$1\n";
				}
                       	}			  
		} 
	}
}