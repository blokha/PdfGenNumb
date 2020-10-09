require 'combine_pdf'

company_logo = CombinePDF.load("template.pdf").pages[0]
pdf = CombinePDF.load "220001.pdf"
pdf.pages.each {|page| page << company_logo} # notice the << operator is on a page and not a PDF object.
pdf.save "content_with_logo.pdf"
