# an old-fashioned makefile...
# theoretically anything I want to do with the site
# can be done via targets in here

serve:
	hugo server --watch
servedraft:
	hugo server --watch --buildDrafts=true --buildFuture=true

upload: generate
	lftp -e 'mirror -n -x \.git -x Makefile -X *~ --verbose=3 -c -R public www.veganmilitia.org/web/content/b2' ftp.veganmilitia.org

generate:
	hugo

theme:
	git clone https://github.com/yoshiharuyamashita/blackburn.git

# notes:
#  new post:  hugo new post/foo.md
