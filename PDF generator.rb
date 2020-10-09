require 'gtk3'
require 'prawn'
require "prawn/measurement_extensions"
require 'combine_pdf'

#~ path = 'C:\Program Files (x86)\Foxit Reader\FoxitReader.exe'
path = 'C:\Program Files\Tracker Software\PDF Editor\PDFXEdit.exe'


Gtk.init
windows = Gtk::Window.new("to PDF")
windows.position='center'
windows.signal_connect('destroy'){Gtk.main_quit}
entry = Gtk::Entry.new()
entry.set_text('220001')
text_f1=Pango::FontDescription.new("Normal bold 16")
entry.override_font(text_f1)
entry.max_length=6
entry.width_chars=6
check_p = Gtk::RadioButton.new(:label=>"+")
check_m = Gtk::RadioButton.new(:member=> check_p,:label=>"-")
add=1
check_p.signal_connect("toggled") {
	add=1
}
check_m.signal_connect("toggled") {
	add=-1
}

check = Gtk::CheckButton.new()
  check.set_label "with template"

button = Gtk::Button.new()
button.set_label('to PDF')
button.signal_connect('clicked'){
  number_prev=entry.text.to_i
  number_next=number_prev+1000*add
  entry.set_text(number_next.to_s)
  
     filename=number_prev.to_s+'.pdf'
  Prawn::Document.generate(filename,:page_size => "A4",:margin => 0.mm) do
 
    font_families.update(
  "Times" => {
    :normal      => { :file => 'TIMESBD.TTF', :font => "Times" },
  }
)
font_size 13
font "Times"
	pos_x = 14.mm
	pos_y = 269.mm
	width1 = 113
	heigth1 = 199
	(1..50).each do |k|
	(0..3).each do |j|
	(0..4).each do |i|
	text_n = sprintf "№ %0.6d",number_prev.to_s
	text_box text_n,:at =>[pos_x+i*width1, pos_y-j*heigth1]
	number_prev+=1
	end
	end
	start_new_page unless k==50
	end

  
    
    
    
  end

if check.active? 
template = CombinePDF.load("template.pdf").pages[0]
pdf_t = CombinePDF.load (filename)
pdf_t.pages.each {|page| page << template} 
pdf_t.save "template-"+filename
Process.spawn(path,"template-"+filename)
else
Process.spawn(path,filename)  
end
}

grid = Gtk::Grid.new()
grid.margin = 10
grid.column_spacing=20;
grid.row_spacing=10;
grid.attach(entry,0,0,2,1)
grid.attach(button,2,0,1,1)
grid.attach(check_p,0,1,1,1)
grid.attach(check_m,1,1,1,1)
grid.attach(check,2,1,1,1)

windows.add(grid)
windows.show_all
Gtk.main
