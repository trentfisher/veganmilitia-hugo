# an old-fashioned makefile...
# theoretically anything I want to do with the site
# can be done via targets in here

HUGO_DL=https://github.com/gohugoio/hugo/releases/download/v0.31.1/hugo_0.31.1_Linux-64bit.tar.gz
$(notdir $(HUGO_DL)):
	wget $(HUGO_DL)
hugo: $(notdir $(HUGO_DL))
	tar xvzf hugo_0.31.1_Linux-64bit.tar.gz hugo
	chmod a+x hugo

serve:
	./hugo server --watch
servedraft:
	./hugo server --watch --buildDrafts=true --buildFuture=true

upload: generate
	lftp -e 'mirror -n -x \.git -x Makefile -X *~ --verbose=3 -c -R public www.veganmilitia.org/web/content/b2' ftp.veganmilitia.org

generate:
	./hugo

theme:
	git clone https://github.com/yoshiharuyamashita/blackburn.git
	git clone https://github.com/spf13/hyde.git
	git clone https://github.com/ribice/kiss.git
# notes:
#  new post:  hugo new post/foo.md
