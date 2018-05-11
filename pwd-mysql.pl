#!/usr/bin/env perl

my %login;
if ($#ARGV == 3) {
	$login{'host'} = $ARGV[0];
	$login{'user'} = $ARGV[1];
	$login{'pass'} = $ARGV[2];
	$login{'port'} = $ARGV[3];
} elsif ($#ARGV == 2) {
	$login{'host'} = $ARGV[0];
	$login{'user'} = $ARGV[1];
	$login{'pass'} = "";
	$login{'port'} = $ARGV[2];
} else {
	print qq{usage:pwd-mysql.pl ip mysql_user [mysql_pass] mysql_port};
	exit;
}




my @dict = ('%null%',
'%user%',
'123',
'123123',
'123456',
'12345678',
'!@#',
'!@#$%^',
'!@#$%^&*',
'111111',
'666666',
'abc',
'test',
'888888',
'%user%00',
'%user%ab',
'%user%12',
'%user%!@#',
'%user%123',
'%user%abc',
'%user%888',
'%user%111',
'%user%1234',
'%user%abcd',
'%user%@',
'%user%!',
'%user%.',
'123321',
'|+_)(',
'Admin123',
'88888888',
'66666666',
'(%user%)',
'^%user%^',
'guest',
'test123',
'master',
'admin',
'root',
'%resu%',
'%tsoh%',
'{%user%}',
'.%user%.',
'11111111',
'000000',
'8888',
'6666',
'123!@#',
'00000000',
'1234567',
'aaaaaa',
'654321',
'999999',
'222222',
'password',
'abcdefg',
'woaini',
'iloveyou',
'exit',
'99999999',
'333333',
'444444',
'555555',
'6543210',
'111222',
'asdfghjkl',
'abc123',
'666888',
'zzzzzz',
'abcd1234',
'Guest123',
'1234',
'12345',
'ab',
'abcd',
'abcde',
'abcdef',
'abcdefgh',
'abcdefghi',
'123qwe',
'qazwsx',
'qweasd',
'asdfjkl;',
'`1234567890-=',
'1234567890-=',
'!@#$%^&*()_+',
'~!@#$%^&*()_+');

my @sdict = (); @mdict = () ;
my $shastyle = 0 , $nullpass = 0 ;

foreach $d (@dict) {
	if ($d =~ /%null%/) { $nullpass = 1; next;}

	my $mb = 0 ;
	my %pass = {} ;

	if ($d =~ /\%user\%/ && $mb == 0) { push @mdict, $d; $mb = 1; }
    if ($d =~ /\%resu\%/ && $mb == 0) { push @mdict, $d; $mb = 1; }

    if ($d =~ /\%host\%/ && $mb == 0) { push @mdict, $d; $mb = 1; }
    if ($d =~ /\%tsoh\%/ && $mb == 0) { push @mdict, $d; $mb = 1; }

    if ($mb ==0) {
    	$pass{'p'} = $d;
    	push @sdict, \%pass;
    }
}


sub sha1style2 {
	my $d = shift @_ ;
	open CHILD , "| sha1sum | awk '{print \$1}' > pwd-mysql-tmp-1";
	print CHILD $d;
	close(CHILD);
	open FH , " pwd-mysql-tmp-1";
	@f = <FH>;
	close(FH);
	chomp @f;
	$unhex = pack("H*",$f[0]);
	open(CHILD, "| sha1sum | awk '{print \$1}' > pwd-mysql-tmp-2");
	print CHILD $unhex;
	close(CHILD);
	open FH , " pwd-mysql-tmp-2";
	@f = <FH>;
	close(FH);
	chomp @f;
	$d = $f[0];
	return "*" . uc($d);
}

sub sha1style3 {
	my @dict = @_;
	my $str = "";
	my @out = ();
	foreach $d (@dict) {
		$str .= "select password(\"$d->{'p'}\");"
	}
	my @sql = `echo -n '$str' | mysql -h$login{'host'} -u"$login{'user'}" --password="$login{'pass'}" --port=$login{'port'} -N`;
	foreach $s (@sql) {
		next if index($s, "*") != 0;
		chomp $s;
		push @out,uc($s);
	}
	return @out;
}

eval {
    require Digest1::SHA;
    $shastyle = 1;
    foreach $d (@sdict) {
    	$d->{'h'} = "*" . uc(Digest::SHA::sha1_hex(pack("H*",Digest::SHA::sha1_hex($d->{'p'}))));
    }
    1;
} or do {
   $sha1sum = `echo -n mysql-pwd | sha1sum | awk '{print \$1}'`;
   chomp $sha1sum;
   if ($sha1sum eq "_b951d6804028551c756b4da6e245075a2ec8b875") {
   		$shastyle = 2;
   		foreach $d (@sdict) {
			$d->{'h'} =  sha1style2(\$d->{'p'});
    	}
    	$del = `rm pwd-mysql-tmp-1 & rm pwd-mysql-tmp-2`;
   } else {
   		$shastyle = 3;
   		my $i = 0 ;
   		foreach $d (sha1style3(@sdict)) {
   			$sdict[$i]->{'h'} = $d;
   			$i++;
   		}
   }
};


foreach $d (@sdict) {
	# print $d->{'p'}. " | " . $d->{'h'} . "\n";
	# $d->{'h'} = 
}



my $host=`hostname -s`;
chomp $host;
my $tsoh=reverse $host;

my $mut=`echo -n "SELECT DISTINCT CONCAT(user,\'@\',host,\';\',password) FROM mysql.user\\G;" | mysql -h$login{'host'} -u"$login{'user'}" --password="$login{'pass'}" --port=$login{'port'} -N`;
chomp $mut;

open FH, '<', \$mut;
while(<FH>)
{
   chomp;
   next if /^\*\*\*/;
   my @f = split /;/;
   my %hash.%pass;

   @hash{'username','password'} = @f;
   @pass{'user','host'} = split /@/,$hash{'username'};
   $pass{'hash'} = $hash{'password'};

   if (($pass{'hash'} eq "") && ($nullpass)) {
      print "$pass{'user'}\@$pass{'host'}\[\](empty password)\n";
      next;
   }

   my $waek = 0;

   foreach $d (@sdict) {
      if ($pass{'hash'} eq $d->{'h'}) {
         print "$pass{'user'}\@$pass{'host'}\[$d->{'p'}\]\n";
         $waek=1;
         last;
      }
   }

   if ($waek) { next; }

   foreach $d (@mdict) {
      my $t = $d;
      my $ans = "";
      my $resu=reverse $pass{'user'};

      $t =~ s/\%user\%/$pass{'user'}/g;
      $t =~ s/\%resu\%/$resu/g;

      $t =~ s/\%host\%/$host/g;
      $t =~ s/\%tsoh\%/$tsoh/g;

      if ($shastyle == 1) {
         eval {
		    require Digest1::SHA;
		    	$ans = "*" . uc(Digest::SHA::sha1_hex(pack("H*",Digest::SHA::sha1_hex($t))));
		}
      } elsif ($shastyle == 2) {
           $ans = sha1style2($t);
      } elsif ($shastyle == 3) {
      	   my %pass = {} ;
      	   $pass{'p'} = $t;
           @a =  sha1style3(\%pass);
           $ans = $a[0];
      } else {
         die "not support crypt type;"
      }

      if ($ans eq $pass{'hash'}) {
      	print "$pass{'user'}\@$pass{'host'}\[$t\]\n";
      }
   }
}

close(FH);