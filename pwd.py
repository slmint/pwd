#!/usr/bin/env python

import os
import crypt

passwordDict = [r'!@#',
r'!@#$%^',
r'!@#$%^&*',
r'!@#$%^&*()_+',
r'%resu%',
r'%tsoh%',
r'%user%',
r'%user%!',
r'%user%!@#',
r'%user%.',
r'%user%00',
r'%user%111',
r'%user%12',
r'%user%123',
r'%user%1234',
r'%user%888',
r'%user%@',
r'%user%ab',
r'%user%abc',
r'%user%abcd',
r'(%user%)',
r'.%user%.',
r'000000',
r'00000000',
r'111111',
r'11111111',
r'111222',
r'123',
r'123!@#',
r'123123',
r'123321',
r'1234',
r'12345',
r'123456',
r'1234567',
r'12345678',
r'123456789',
r'1234567890-=',
r'123qwe',
r'222222',
r'333333',
r'444444',
r'555555',
r'654321',
r'6543210',
r'6666',
r'666666',
r'66666666',
r'666888',
r'816357',
r'8888',
r'888888',
r'88888888',
r'999999',
r'99999999',
r'Admin123',
r'Guest123',
r'^%user%^',
r'`1234567890-=',
r'aaaaaa',
r'ab',
r'abc',
r'abc123',
r'abcd',
r'abcd1234',
r'abcde',
r'abcdef',
r'abcdefg',
r'abcdefgh',
r'abcdefghi',
r'admin',
r'asdfghjkl',
r'asdfjkl;',
r'exit',
r'guest',
r'iloveyou',
r'master',
r'password',
r'qazwsx',
r'qq123456',
r'qweasd',
r'root',
r'taobao',
r'test',
r'test123',
r'wang1234',
r'woaini',
r'xiaoming',
r'zzzzzz',
r'{%user%}',
r'|+_)(',
r'~!@#$%^&*()_+']

host = os.popen('hostname -s').read().strip()
tosh = host[::-1]

try:
	f = open('/etc/shadow','r')
except:
	print "can't open /etc/shadow"

for PASSWD in f.readlines():  
		if PASSWD.startswith('#'):
			continue
		h=PASSWD.split(':');
		if "!!" in h[1] or "*" in h[1]:
			continue

		pwd=h[1].split('$');

		p={'user':h[0],'const':pwd[1],'salt':pwd[2],'hash':pwd[3]}

		print "user %s const %s salt %s hash %s" % (p['user'],p['const'],p['salt'],p['hash'])

		for d in passwordDict:
			t = d
			resu = p['user'][::-1]

			t = t.replace(r'%user%',p['user'])
			t = t.replace(r'%resu%',resu)

			t = t.replace(r'%host%',host)
			t = t.replace(r'%tosh%',tosh)

			s = "$" + p['const'] + "$" + p['salt'] + "$"

			if crypt.crypt(d, s) == h[1]:
				print "%s[%s]" % (p['user'],d)
				break
if f:
	f.close()