

perl fetch.pl > fetched.json

mkdir -p Cached

#perl parse.pl fetched.json
perl parse.pl 
# - fill ./Cached dir

perl parseLocal.pl

echo '# libreoffice can40.xls'


