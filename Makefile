docs-html:
	rst2html.py README.rst > doc/_build/README.html
	rst2html.py doc/troubleshooting.rst > doc/_build/troubleshooting.html

publish-docs: docs-html
	scp doc/_build/*.html www-data@www.tunfish.org:/srv/www/organizations/backdoor-collective/www.tunfish.org/htdocs/doc/
