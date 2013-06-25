server:
	npm prune
	npm install
	rm -rf app/tmp
	mkdir app/tmp
	mkdir app/tmp/css
	cp -r app/lib app/tmp/
	foreman start -f Procfile-dev
