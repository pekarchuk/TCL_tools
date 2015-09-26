proc prepare_t {filename space} {
	set file [open $filename r]
	set input [string tolower [read $file]]
	if {$space} {
		set input [join [regsub -all {[^а-я ]} $input ""] " "]
	} else {
		set input [regsub -all {[^а-я]} $input ""]
	}
	return $input	
}

proc char_bigr_freq {text} {
    set last -
    foreach char [split $text ""] {
    	if {[catch {incr counter_c($char)}]} { set counter_c($char) 1 }
    	if {[catch {incr counter_b($last$char)}]} { set counter_b($last$char) 1 }
            set last $char
    }
    return [list [array get counter_c] [array get counter_b]]
}

proc bigr_freq_uncr {text} {
	set new [split $text ""]
	for {set i 0} {$i <= [expr [llength $new] - 1]} {incr i 2} {
		set first [lindex $new $i]
		set second [lindex $new [expr $i + 1]]
		if {[catch {incr counter($first$second)}]} {
			set counter($first$second) 1
		}
	}
	return [array get counter]
}

proc entropy {freq text_l} {
 	set summ 0
 	foreach {key value} $freq {
 		set summ [expr $summ + abs([expr double($value) / $text_l * (log(double($value) / $text_l) / log(2))])]
 	}
 	return $summ

}

proc redundancy {entropy} {
 	return [expr 1 - $entropy / 5]
}

proc main {} {
	set clear_text [prepare_t book2.txt true]
	set ch_br [char_bigr_freq $clear_text]
	set char_fr [lindex $ch_br 0]
	set bigrams [lindex $ch_br 1]
	# set bigrams_uncrossed [bigr_freq_uncr $clear_text]
	
	puts "For Letters:"
	set entropy1 [entropy $char_fr [string length $clear_text]]
	puts [format "Entropy: %.4f" $entropy1]
	puts [format "Redundancy: %.4f" [redundancy $entropy1]]

	puts "For Bigrams:"
	set entropy1 [expr [entropy $bigrams [string length $clear_text]] / 2]
	puts [format "Entrpy: %.4f" $entropy1]
	puts [format "Redundancy: %.4f" [redundancy $entropy1]]
}

main