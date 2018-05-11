#!/usr/bin/env python

import os
import sys
from hashlib import sha1

if len(sys.argv) == 5 :
	login = {'host':sys.argv[1] , 'user':sys.argv[2], 'pass':sys.argv[3],'port':sys.argv[4]}
elif len(sys.argv) == 4 :
	login = {'host':sys.argv[1] , 'user':sys.argv[2], 'pass':'','port':sys.argv[3]}
else :
	print "usage: pwd-mysql.py ip mysql_user [mysql_pass] mysql_port"
	sys.exit(1);


passwordDict = [r'%null%',
r'%user%',
r'123',
r'123123',
r'123456',
r'12345678',
r'!@#',
r'!@#$%^',
r'!@#$%^&*',
r'111111',
r'666666',
r'abc',
r'test',
r'888888',
r'%user%00',
r'%user%ab',
r'%user%12',
r'%user%!@#',
r'%user%123',
r'%user%abc',
r'%user%888',
r'%user%111',
r'%user%1234',
r'%user%abcd',
r'%user%@',
r'%user%!',
r'%user%.',
r'123321',
r'|+_)(',
r'Admin123',
r'88888888',
r'66666666',
r'(%user%)',
r'^%user%^',
r'guest',
r'test123',
r'master',
r'admin',
r'root',
r'%resu%',
r'%tsoh%',
r'{%user%}',
r'.%user%.',
r'11111111',
r'000000',
r'8888',
r'6666',
r'123!@#',
r'00000000',
r'1234567',
r'aaaaaa',
r'654321',
r'999999',
r'222222',
r'password',
r'abcdefg',
r'woaini',
r'iloveyou',
r'exit',
r'99999999',
r'333333',
r'444444',
r'555555',
r'6543210',
r'111222',
r'asdfghjkl',
r'abc123',
r'666888',
r'zzzzzz',
r'abcd1234',
r'Guest123',
r'1234',
r'12345',
r'ab',
r'abcd',
r'abcde',
r'abcdef',
r'abcdefgh',
r'abcdefghi',
r'123qwe',
r'qazwsx',
r'qweasd',
r'asdfjkl;',
r'`1234567890-=',
r'1234567890-=',
r'!@#$%^&*()_+',
r'~!@#$%^&*()_+']

host = os.popen('hostname -s').read().strip()
tsoh = host[::-1]

mDict = []
sDict = []

for d in passwordDict:
	if d == "%null%":
		nullpass = 1
		continue

	if ("%user%" in d) or ("%resu%" in d) or ("%host%" in d) or ("%tsoh" in d):
		mDict.append(d)
		continue

	sDict.append({'p':d,'h': "*" + sha1(sha1(d).digest()).hexdigest().upper()})


for MYSQL in os.popen("echo -n \"SELECT DISTINCT CONCAT(user,\'@\',host,\';\',password) FROM mysql.user\\G;\" | mysql -h"+ login['host'] +" -u\"" +login['user'] +"\" --password=\"" +login['pass']+ "\" --port=" +login['port']+ " -N").readlines():
	if MYSQL.startswith('***'):
		continue

	h=MYSQL.strip().split(';')
	uh = h[0].split('@')

	weak = 0

	p = {'user':uh[0],'host':uh[1],'hash':h[1]}

	if nullpass and p['hash'] == "":
		print "%s@%s[](empty password)" % (p['user'],p['host'])

	for d in sDict:
		if d['h'] == p['hash'] :
			print "user: "+ p['user'] +" waek password:" + d['h']
			weak = 1
			break

	if weak:
		continue

	for d in mDict:
		t = d
		resu = p['user'][::-1]

		t = t.replace(r'%user%',p['user'])
		t = t.replace(r'%resu%',resu)

		t = t.replace(r'%host%',host)
		t = t.replace(r'%tsoh%',tsoh)

		if p['hash'] == "*" + sha1(sha1(t).digest()).hexdigest().upper():
			print "%s@%s[%s]" % (p['user'],p['host'],t)
			break

