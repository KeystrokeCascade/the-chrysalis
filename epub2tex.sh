#!/bin/bash
cd ./epub/OEBPS/Text/
for filename in ./*.xhtml; do
	[ -e "$filename" ] || continue
	cp $filename ../../../tex/chapters/${filename/xhtml/tex}
	cd ../../../tex/chapters/
	#<p>
	sed -i -e 's/<p>//' ./${filename/xhtml/tex}
	sed -i -e 's/<p class="noindent">//' ./${filename/xhtml/tex}
	sed -i -e 's/<\/p>/\n/' ./${filename/xhtml/tex}
	#<i>
	perl -i -pe 'BEGIN{undef $/;} s/<i>/\\textit{/smg' ./${filename/xhtml/tex}
	perl -i -pe 'BEGIN{undef $/;} s/<\/i>/}/smg' ./${filename/xhtml/tex}
	#<b>
	perl -i -pe 'BEGIN{undef $/;} s/<b>/\\textbf{/smg' ./${filename/xhtml/tex}
	perl -i -pe 'BEGIN{undef $/;} s/<\/b>/}/smg' ./${filename/xhtml/tex}
	#<div>
	sed -i -e 's/<div class="break">☢<\/div>/{\\br}/' ./${filename/xhtml/tex}
	#<br/>
	perl -i -pe 'BEGIN{undef $/;} s/<br\/>\n//smg' ./${filename/xhtml/tex}
	sed -i -e 's/<br\/>/\n/' ./${filename/xhtml/tex}
	#terminal
	sed -i -e 's/<div class="terminal.*">/\\terminal{/' ./${filename/xhtml/tex}
	perl -i -pe 'BEGIN{undef $/;} s/\n<\/div>/}\n/smg' ./${filename/xhtml/tex}
	#header and footer
	perl -i -pe 'BEGIN{undef $/;} s/<\?xml.*<\/h3>\n\n//smg' ./${filename/xhtml/tex}
	perl -i -pe 'BEGIN{undef $/;} s/<\/h3>\n/}/smg' ./${filename/xhtml/tex}
	perl -i -pe 'BEGIN{undef $/;} s/\n\n\n<script.*<\/html>//smg' ./${filename/xhtml/tex}
	#symbols
	perl -i -pe 'BEGIN{undef $/;} s/#/\\#/smg' ./${filename/xhtml/tex}
	perl -i -pe 'BEGIN{undef $/;} s/%/\\%/smg' ./${filename/xhtml/tex}
	perl -i -pe 'BEGIN{undef $/;} s/_/\\_/smg' ./${filename/xhtml/tex}
	perl -i -pe 'BEGIN{undef $/;} s/\\\\$/\\\$/smg' ./${filename/xhtml/tex}
	perl -i -pe 'BEGIN{undef $/;} s/&amp;/\\&/smg' ./${filename/xhtml/tex}
	perl -i -pe 'BEGIN{undef $/;} s/\n“/\n\\leavevmode\\llap\{“\}/smg' ./${filename/xhtml/tex}
	perl -i -pe 'BEGIN{undef $/;} s/{\\br}\n\\leavevmode\\llap{“}/{\\br}\n“/smg' ./${filename/xhtml/tex}
	#break again
	sed -i -e 's/{\\br}/{\\br}%/' ./${filename/xhtml/tex}
	#confirmation
	echo Converted $filename
	cd ../../epub/OEBPS/Text/
done
