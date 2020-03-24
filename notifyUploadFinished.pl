#!/usr/bin/perl
use strict;

while(1){
  if(`dropbox status` =~ m/Up to date/i){
    `zenity --info --title='Event' --text='Upload finished' --display=:0.0`;
    exit;
  }
  `sleep 1s`;
}
