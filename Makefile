# an old-fashioned makefile...
# theoretically anything I want to do with the site
# can be done via targets in here

HUGOVER=0.112.3
ifeq ($(shell uname -p),i686)
HUGO_DL=https://github.com/gohugoio/hugo/releases/download/v$(HUGOVER)/hugo_$(HUGOVER)_Linux-32bit.tar.gz
else
HUGO_DL=https://github.com/gohugoio/hugo/releases/download/v$(HUGOVER)/hugo_$(HUGOVER)_Linux-64bit.tar.gz
endif

$(notdir $(HUGO_DL)):
	wget $(HUGO_DL)
hugo: $(notdir $(HUGO_DL))
	tar xvzf $< hugo
	chmod a+x hugo
	./hugo version

serve:
	./hugo server --watch
servedraft:
	./hugo server --watch --buildDrafts=true --buildFuture=true
servefuture:
	./hugo server --watch --buildFuture=true

upload: generate
	lftp -e 'mirror -R -n -x \.git -x Makefile -X *~ --verbose=3 public www.veganmilitia.org/web/content/b2' ftp.veganmilitia.org

generate: themes/hugo-xmin
	./hugo

themes/hugo-xmin:
	git clone https://github.com/trentfisher/hugo-xmin.git themes/hugo-xmin

#	git clone https://github.com/yoshiharuyamashita/blackburn.git
#	git clone https://github.com/spf13/hyde.git
#	git clone https://github.com/ribice/kiss.git

# notes:
#  new post:  hugo new post/foo.md
