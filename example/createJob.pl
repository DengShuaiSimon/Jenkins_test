#!/usr/bin/env perl

use strict;
use warnings;
use Jenkins::API;

use Encode;  
use Encode::CN; 

my $url = shift;
unless ($url)
{
    print "Usage $0 http://jenkins:8080/\n";
    exit 1;
}

my $api = Jenkins::API->new({ base_url => $url });
unless($api->check_jenkins_url)
{
    print "$url does not appear to be a valid jenkins url\n";
    exit 2;
}



##get config.xml template
#my $result = system("curl -X GET http://dengshuai_super:8080\@127.0.0.1:8080/job/JobTest/config.xml >./config.xml");
#print "result: $result\n";


my $file = "./config.xml";
my $config_string="";
my $read_line;
     open (FILE, $file)||die "Can not open $file";
	 while($read_line=<FILE>){
	   #chomp($read_line);
           $config_string = "$config_string$read_line";
	  }
     close(FILE);

	 
##project_config() returns the configuration for the project in xml. To get the template of the config.xml from other project.
my $project_name = "JobTest";
my $config = $api->project_config($project_name);
print "config : $config";


###
my $name = "test7";
#my $job = $api->create_job($name,$config_string);
my $setconfigresult = $api->set_project_config($name,$config_string);











#`curl -X POST http://dengshuai_super:8080@127.0.0.1:8080/createItem?name=test10  -d @config.xml -H Content-Type: text/xml`;

#my $CRUMB=`curl -s 'http://dengshuai_super:8080\@127.0.0.1:8080/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,":",//crumb)'`;
#print "crumb : $CRUMB\n";
#`curl -X POST -H "$CRUMB" "http://dengshuai_super:8080\@127.0.0.1:8080/createItem?name=NewJob"`;
