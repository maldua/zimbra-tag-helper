#!/usr/bin/perl

use strict;
use warnings;

use Config;
use Cwd;
use Data::Dumper;
use File::Basename;
use File::Copy;
use Getopt::Long;
use IPC::Cmd qw/run/;
use Net::Domain;
use Term::ANSIColor;

my $GLOBAL_PATH_TO_SCRIPT_FILE;
my $GLOBAL_PATH_TO_SCRIPT_DIR;
my $GLOBAL_PATH_TO_TOP;
my $CWD;

my %CFG = ();

BEGIN
{
   $ENV{ANSI_COLORS_DISABLED} = 1 if ( !-t STDOUT );
   $GLOBAL_PATH_TO_SCRIPT_FILE = Cwd::abs_path(__FILE__);
   $GLOBAL_PATH_TO_SCRIPT_DIR  = dirname($GLOBAL_PATH_TO_SCRIPT_FILE);
   $GLOBAL_PATH_TO_TOP         = dirname($GLOBAL_PATH_TO_SCRIPT_DIR);
   $CWD                        = getcwd();
}

chdir($GLOBAL_PATH_TO_TOP);

sub EvalFile($;$)
{
   my $fname = shift;

   my $file = "$GLOBAL_PATH_TO_SCRIPT_DIR/$fname";

   Die( "Error in '$file'", "$@" )
     if ( !-f $file );

   my @ENTRIES;

   eval `cat '$file'`;
   Die( "Error in '$file'", "$@" )
     if ($@);

   return \@ENTRIES;
}

##############################################################################################

sub PrintReposLoadRemotes()
{
   my %details = @{ EvalFile("zm-build/instructions/FOSS_remote_list.pl") };

   return \%details;
}

sub PrintReposLoadRepos()
{
   my @agg_repos = ();

   push( @agg_repos, @{ EvalFile("zm-build/instructions/FOSS_repo_list.pl") } );

   return \@agg_repos;
}

sub PrintReposClone($$)
{
   my $repo_details        = shift;
   my $repo_remote_details = shift;

   my $repo_name       = $repo_details->{name};
   my $repo_remote     = $repo_details->{remote} || "gh-zm";
   my $repo_url_prefix = $repo_remote_details->{$repo_remote}->{'url-prefix'} || Die( "unresolved url-prefix for remote='$repo_remote'", "" );

   $repo_url_prefix =~ s,/*$,,;

   my $repo_details_remote = "";
   $repo_details_remote = $repo_details->{remote} if (defined "$repo_details->{remote}");

   if ( $repo_details_remote eq "" ) {
      print("$repo_url_prefix/$repo_name.git\n");
   }

}

sub PrintReposCheckout($)
{
   my $repo_list = shift;

   my $repo_remote_details = PrintReposLoadRemotes();

   for my $repo_details (@$repo_list)
   {
      PrintReposClone( $repo_details, $repo_remote_details );
   }
}

sub printReposMain()
{
   my $all_repos = PrintReposLoadRepos();
   PrintReposCheckout($all_repos);
}

printReposMain();

##############################################################################################
