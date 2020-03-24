#!/usr/bin/perl

use strict;

my @site=`lynx -dump -nolist https://docs.jboss.org/wildfly/plugins/maven/`;
@site = grep(/DIR/, @site);
print scalar(@site);
