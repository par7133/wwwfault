#!/usr/local/bin/wish

#package require -exact Tk $tcl_version
package require Tk 8.4

puts ""
puts ""
puts "---------------------------------------"
puts "Released under GPLv3.0"
puts "Copyrights © 2022-2026 Daniele Bonini"
puts "This software is supplied AS-IS, without WARRENTY."
puts "Welcome in WWWFAULT!!"
puts "---------------------------------------"
puts ""
puts ""


cd ~/util/bin

# Variable and Proc declarations

variable urlfile
array set cmdslbl {}
array set cmds {}

proc scanUrls {} {

    global filename
    global cmdslbl
    global cmds

    # Resetting arrays and listbox
    if {[array size cmdslbl] > 0} {
      array set cmdslbl {}
    }
    if {[array size cmds] > 0} {
      array set cmds {}
    } 
    if {[.fr.lb size] > 0} {
      .fr.lb delete 0 [ .fr.lb size ]
    }
    
    if {$filename == ""} {
      return
    } 

    if { [file exists $filename] == 0 } {

      .fr.lb insert end "No url to scan."
      tk_messageBox -message "No url to scan."
      return
    }

		# Reading url list
		set fh [open $filename "r"]

		set intli 0
		set li 0
		while {[gets $fh str] >= 0} {

			if {"[string range $str 0 0]" == "\#"} {
			  continue
			}
			
                        set str [string trim $str]

			set cmdpath [pwd]/urlchecker.sh
                        set newurl $str

			set cmds($intli) $cmdpath
                        
                        set cmdres [exec $cmds($intli) $newurl]
			                            
                        if {[string range $cmdres 0 1] == "0"} {
                          set cmdslbl($intli) "$newurl failed"
                        } else {
                          set cmdslbl($intli) "$newurl valid"
			}
                        .fr.lb insert 0 $cmdslbl($intli)

			incr intli
                        update			
		}
		close $fh

}

proc shutdown {} {
    # perform necessary housework for ensuring that application files
    # are in proper state, lock files are removed, etc.
    
    puts stdout "Good Bye, from WWWFAULT.."
    
    exit
}

# Main Frame
frame .fr
pack .fr -fill both -expand 1

set today [clock seconds]
set filename "~/urls/urls.txt"
entry .fr.txt -width 65 -textvariable filename
button .fr.bscan -height 1 -text "Scan Urls" -command { scanUrls }

listbox .fr.lb -yscrollcommand { .fr.sb set }
place .fr.lb -height 120
scrollbar .fr.sb -command {.fr.lb yview} -orient vertical

#ListBox
bind .fr.lb <<ListboxSelect>>

# Close Button
button .fr.bclose -text "Exit" -command { shutdown }
grid .fr.bclose -sticky sw -ipadx 20 -padx 0 -pady 40 

# Set frame and controls position
grid configure .fr -row 0 -rowspan 6 -column 0 -columnspan 4
grid configure .fr.txt -column 1 -columnspan 2 -row 0 -rowspan 1
grid configure .fr.bscan -column 2 -columnspan 1 -row 0 -rowspan 1
grid configure .fr.lb -column 1 -columnspan 2 -row 1 -rowspan 1
grid configure .fr.sb -column 2 -columnspan 1 -row 1 -rowspan 1
grid configure .fr.bclose -column 1 -columnspan 2 -row 5 -rowspan 1
grid .fr.txt -sticky w
grid .fr.txt -ipadx 20 -pady 10 -ipady 5
grid .fr.bscan -sticky e
grid .fr.lb -sticky nsew
place .fr.sb -width 5
grid .fr.sb -sticky nes
grid .fr.lb -ipadx 20 -pady 20 -columnspan 2
grid .fr.sb -ipadx 5 -padx 1 -pady 20 
grid .fr.bclose -sticky sw -ipadx 20 -padx 0 -pady 40
grid .fr -sticky w -padx 20

# Window
wm title . "wwwfault: your url validator"
image create photo imgobj -file wwwfault.png
wm iconphoto . imgobj
wm resizable . 0 0
wm attributes . -fullscreen 0
wm geometry . 600x380
wm protocol . WM_DELETE_WINDOW { shutdown }

