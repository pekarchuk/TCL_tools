proc prepare_text {filename} {
	set file [open $filename r]
	set input [string tolower [read $file]]
	set input [regsub -all {[^а-я]} $input ""]
	return $input	
}

 proc range {from to {step 1}} {
     set res $from
     while {$step>0 ? $to>$from : $to<$from} {lappend res [incr from $step]}
     return $res
  }

proc encode {PT key} {
	set result {}
	set PTLength [string length $PT]
	foreach i [range 0 [expr $PTLength - 1]] chr [split $PT ""] {
		if {![string compare $chr ""]} {continue}
		scan $chr %c temp
		set sym_i [expr $temp - 1072]
		set key_i [expr $i % [string length $key]]
		set res_i [expr ($sym_i + $key_i) % $PTLength]
		lappend result [format %c [expr $res_i + 1072]]
	}
	return [join $result ""]
}

proc decode {CT key} {
	set result {}
	set CTLength [string length $CT]
	foreach i [range 0 [expr $CTLength - 1]] chr [split $CT ""] {
		if {![string compare $chr ""]} {continue}
		scan $chr %c temp
		set sym_i [expr $temp - 1072]
		set key_i [expr $i % [string length $key]]
		set res_i [expr ($sym_i - $key_i) % $CTLength]
		lappend result [format %c [expr $res_i + 1072]]
	}
	return [join $result ""]
}

proc main {} {
	set CT [encode [prepare_text "test.txt"] экомаятникфуко]
	set PT [decode $CT экомаятникфуко]
	puts $PT
}


main