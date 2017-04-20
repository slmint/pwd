#!/usr/bin/env perl

my @dict = ('!@#',
'!@#$%^',
'!@#$%^&*',
'!@#$%^&*()_+',
'%resu%',
'%tsoh%',
'%user%',
'%user%!',
'%user%!@#',
'%user%.',
'%user%00',
'%user%111',
'%user%12',
'%user%123',
'%user%1234',
'%user%888',
'%user%@',
'%user%ab',
'%user%abc',
'%user%abcd',
'(%user%)',
'.%user%.',
'000000',
'00000000',
'111111',
'11111111',
'111222',
'123',
'123!@#',
'123123',
'123321',
'1234',
'12345',
'123456',
'1234567',
'12345678',
'123456789',
'1234567890-=',
'123qwe',
'222222',
'333333',
'444444',
'555555',
'654321',
'6543210',
'6666',
'666666',
'66666666',
'666888',
'816357',
'8888',
'888888',
'88888888',
'999999',
'99999999',
'Admin123',
'Guest123',
'^%user%^',
'`1234567890-=',
'aaaaaa',
'ab',
'abc',
'abc123',
'abcd',
'abcd1234',
'abcde',
'abcdef',
'abcdefg',
'abcdefgh',
'abcdefghi',
'admin',
'asdfghjkl',
'asdfjkl;',
'exit',
'guest',
'iloveyou',
'master',
'password',
'qazwsx',
'qq123456',
'qweasd',
'root',
'taobao',
'test',
'test123',
'wang1234',
'woaini',
'xiaoming',
'zzzzzz',
'{%user%}',
'|+_)(',
'~!@#$%^&*()_+');

my $host=`hostname -s`;
chomp $host;
my $tosh=reverse $host;

open(PASSWD, '</etc/shadow') or print ("can't open /etc/shadow");
while (<PASSWD>) {
    chomp;
    next if /^\s*#/; # ignore comments
    my @f = split /:/;
    my %hash,%pass;
    @hash{'username','password'} = @f;

    next if $hash{'password'} =~ /[!!|*]/;

    @pass{'user','const','salt','hash'} = split /\$/,$hash{'password'};
    $pass{'user'} = $hash{'username'};

    foreach $d (@dict) {
        my $t = $d;
        my $resu=reverse $pass{'user'};

        $t =~ s/\%user\%/$pass{'user'}/g;
        $t =~ s/\%resu\%/$resu/g;

        $t =~ s/\%host\%/$host/g;
        $t =~ s/\%tsoh\%/$tsoh/g;

        if (crypt($d,"\$$pass{'const'}\$$pass{'salt'}\$") eq $hash{'password'}) {
            print "$pass{'user'}\[$d\]\n";
            last;
        }
    }
}
close(PASSWD);


