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



###get config.xml template
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

	 
###project_config() returns the configuration for the project in xml. To get the template of the config.xml from other project.
#my $project_name = "JobTest";
#my $config = $api->project_config($project_name);
#print "config : $config\n";


###
my $job_name = "test7";
#my $job = $api->create_job($name,$config_string);
my $setconfigresult = $api->set_project_config($job_name,$config_string);


###Trigger a build
my $success = $api->trigger_build($job_name);
    unless($success)
    {
        if($api->response_code == 403)
        {
            print "Auth failure\n";
        }
        else
        {
            print $api->response_content;
        }
    }

my $jobs = $api->current_status({ extra_params => { tree => 'jobs[name,color]' } });
my @job_list = @{$jobs->{jobs}};
#@job_list = sort { $a->{name} cmp $b->{name} } @job_list;
for my $job (@job_list)
{
    # status isn't really this simple, but unstable doesn't
    # map very to the todos in perl, so I'm not interested
    # in it personally.
	if($job->{name} eq $job_name){
    my $status = $job->{color} eq 'blue' ? 'OK' : 'Fail';
    print "$job->{name} - $status\n";
	}#if
}





#`curl -X POST http://dengshuai_super:8080@127.0.0.1:8080/createItem?name=test10  -d @config.xml -H Content-Type: text/xml`;

#my $CRUMB=`curl -s 'http://dengshuai_super:8080\@127.0.0.1:8080/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,":",//crumb)'`;
#print "crumb : $CRUMB\n";
#`curl -X POST -H "$CRUMB" "http://dengshuai_super:8080\@127.0.0.1:8080/createItem?name=NewJob"`;
