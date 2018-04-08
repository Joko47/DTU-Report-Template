# DTU Report Template
My report template for use at DTU
by Jakob Løfgren

Latex template for writing reports at DTU

Comes with multiple frontpages dependent on the number of people working on the project.

Explanation for the different documents can be seen here:
# FrontSetup.tex 
contains the data for the frontpages, no editing inside the Forsider folder should be neccessary.
  - Student name
  - Student number
  - Course name
  - Course number
  - Project name
  - Groupnumber
The wanted frontpage type (FrontSingle, FrontThree or FrontFour) should be inputtet in main.tex
 
# PageSetup.tex
contains the basic setup, as well as package loading and definition of new commands.

# Main.tex
is where you build the document, avoid big sections here, for ease of debugging.
Fancy headers and footers are also configured at the top here.

# Inspiration.tex
contains inspiration as to how one can insert pictures, tables use equations and more.

# mcode.sty
is for inputting matlab code
