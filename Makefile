# an old-fashioned makefile...
# theoretically anything I want to do with the site
# can be done via targets in here

serve:
	hugo server --watch

upload: generate
	lftp -e 'mirror -x .git -x Makefile -X *~ --verbose=3 -c -R public www.veganmilitia.org/web/content/b2' ftp.veganmilitia.org

generate:
	hugo
