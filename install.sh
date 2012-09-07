#!/usr/bin/awk -f 

BEGIN {ARGV[1] = "config.list"; ARGC = 2}

NF==0 { getline }

# print line comments
/^\#/{
	if(first++) print "\n" $0
	else print $0
 }

# remove (in)line comments
/\#/{
	for( i=1 ; i <= NF ; i++ )
		if( index( $i, "#" ) == 1 ) NF = i -1;
	if( NF == 0 ) getline
 }

{
	command=sprintf("ln -snf %s/%s %s", ENVIRON["PWD"],$1, $2) ;
	printf("Installing %10s as %-20s (%s)\n", $1, $2, command) ;
	system(command) ;
}
