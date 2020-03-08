#!/bin/bash
#DO NOT RUN UNLESS REBUILDING TEX FILES FROM SCRATCH, CH34 HAS WEIRD EDGECASES

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

#handles one-time edge cases
cd ../../../tex/chapters/

#allow that one thing to break (line 294 in ch10)
sed -i -e 's/Eventually, she looked away again, seemingly satisfied with Dusty’s words./Eventually, she looked away again, seemingly satisfied with Dusty’s\\linebreak[1] words./' ./ch10.tex
#center (line 418 in ch34)
perl -i -pe 'BEGIN{undef $/;} s/<div style="text-align:center">.*testing}\n}/{\n\\center\n\\textbf{Welcome to Crystal Life Technologies}\n\n\\textbf{Experimental Site Beta:}\n\n\\textbf{Permafrost development and testing}\n\n}/smg' ./ch34.tex
#single line italic and mono (line 709 in ch34)
perl -i -pe 'BEGIN{undef $/;} s/<i style="font-family:IBM Plex Mono">Patient deceased}/\\textit{\\texttt{Patient deceased}}/smg' ./ch34.tex

#deletes junk files
rm ./copyright_page.tex
rm ./cover.tex
rm ./title_page.tex
rm ./toc.tex
echo Removed junk
echo Done
