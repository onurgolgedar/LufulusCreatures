/// @param x
/// @param y
/// @param text
/// @param vCenter*
function draw_text_colortags() {

	var xx, yy, str, st, et, ct, l, h, stl, pc, dx, dy, dp, p, c, ds, i, pure, sth, line_count, center
    
	xx = argument[0]
	yy = argument[1]
	str = argument[2]
	st = "[c="
	et = "]"
	ct = "[/c]"
	pure = ""

	l = string_length(str)
	if (argument_count > 3)
	    center = argument[3]
	else
		center = false

	h = string_height(" ")
	
	stl = string_length(st)
	sth = string_height(st)
	pc = draw_get_color()
	dx = xx
	line_count = string_height(str)/h
	dy = yy-(line_count-1)*h/2*center
	dp = 1

	for (p = 1; p <= l; p += 1) {
	    c = string_char_at(str, p)
	    if (c == chr(10) || p == l || (c == "n" && string_char_at(str, p - 1) == "\\" && !(p > 1 and string_char_at(str, p - 2) == "\\"))) {
	        draw_text(dx, dy, string_copy(str, dp, p - dp + 1))
	        pure += string_copy(str, dp, p - dp + 1)
	        dp = p + 1
	        dx = xx
	        dy += h
	    } else if (c == string_char_at(st, 1) || c == string_char_at(ct, 1)) {
	        if (p + string_length(st) <= l && string_copy(str, p, string_length(st)) == st) {
	            ds = string_copy(str, dp, p - dp)
	            draw_text(dx, dy, ds)
	            pure += ds
	            dx += string_width(ds)
	            i = string_copy(str, p + stl, string_pos(et, string_delete(str, 1, p + stl)))
	            p += string_length(i + et + st) - 1
	            if (i == "") i = pc
	            draw_set_color(real(i))
	            dp = p + 1
	        } else if (p + string_length(st) <= l && string_copy(str, p, string_length(ct)) == ct) {
	            ds  = string_copy(str, dp, p - dp)
	            draw_text(dx, dy, ds)
	            pure += ds
	            draw_set_color(pc)
	            p += string_length(ct) - 1
	            dp = p + 1
	            dx += string_width(ds)
	        }
	    }
	}
	draw_set_color(pc)
    
	return pure


}
