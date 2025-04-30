/*
 Decription: Keycaps for retrocomputers
 Author: Ismael Salvador
 Date: 05/09/22
 
 Keytop is assumed to the flat
 Rounded surfaces are not nice for FDM 
 Print it updside down without any support. Only RETURN key needs support.
 
 Legs and centering pins are very fragile!!!
 Take extra care when removing it from the printer bed or installing them.
 
 TODOs: Separate files. Integrate hb10x. do it keycap agnostic in order to make it work with keyv2
 
*/

// Fillet function
// https://github.com/clothbot/ClothBotCreations/blob/master/utilities/fillet.scad

module fillet(r=0.5,steps=3,include=true) {
  if(include) for (k=[0:$children-1]) {
	children(k);
  }
  for (i=[0:$children-2] ) {
    for(j=[i+1:$children-1] ) {
	fillet_two(r=r,steps=steps) {
	  children(i);
	  children(j);
	  intersection() {
		children(i);
		children(j);
	  }
	}
    }
  }
}

module fillet_two(r=1.0,steps=3) {
  for(step=[1:steps]) {
	hull() {
	  render() intersection() {
		children(0);
		offset_3d(r=r*step/steps) children(2);
	  }
	  render() intersection() {
		children(1);
		offset_3d(r=r*(steps-step+1)/steps) children(2);
	  }
	}
  }
}

module offset_3d(r=1.0) {
  for(k=[0:$children-1]) minkowski() {
	children(k);
	sphere(r=r,$fn=8);
  }
}



//remove upper outer parts such as pins or legs
module make_key(){
    difference(){
    union(){
        children();    
    }
    //negative of the envelope of a key without anything
    #key_outer_negative() hull() children(0);
    }
    children(0);
}


//gets the negative outer part
module key_outer_negative()
{
    //get the outer negative
    th = 1000; //big enough value to cover all the key

    difference(){
        translate([0,0,(th)/2])
        cube([th, th, th],center=true);
        children(0);
    }
    //get all under 0
    //translate([0,0,-(th)/2])
    //cube([th, th, th],center=true);
}

module key_retainer_6128(deep=7.2)
{
#cube([ 1.1, 8, deep - 2 ]);
	translate([ 0, 0, -3.5 ])
	cube([ 1.1, 8, 3.5 ]);
	translate([ 0, 0, -3.5 - 0.8 ])
	cube([ 1.1, 2.2, 0.8 ]);
	translate([ 0, 0, -3.5 - 0.8 - 1.4 ])
	cube([ 1.1, 5.4, 1.4 ]);
}


//main key function
module key(width = 18, height = 18, x_diff = 5.2, y_diff = 4.5, retainer = false, deep = 7.2, enter = 0, row = 0,
           rotate_key = 0, retainer_width = 0, rotate_retainer = 0, middle_pin = false, upper_pin = true,
           enter_pin = false, leg_top_dist = -2, leg_bottom_dist = 2, extra_pin_width = 0, stem = true, keycap=true, y_off=2, 	rounded_corner = 0.5, thickness = 1, upper_bevel_radius = 0, slant=0, base_height=1 )
{

	//y_off = 2; // upper y offset

	// CPC keys have 0 angle but I give you the opportunity to create different styles :)
	h_front = [ deep, deep ];    // front height
	h_back = [ deep, deep - 1 ]; // bottom height
	w_up = width - x_diff;       // upper width

	// compute angle for upper side
    ang = atan2(h_front[row] - h_back[row], w_up) + slant;

	// keycap is the difference of inner and outer shell
	// inner and outher shells are hulls from upper and bottom countours
    if (keycap){
	rotate([ 0, 0, rotate_key ])
	{
		difference()
		{
			// outer
			hull()
			{
				// bottom side
				translate([ 0, 0, 0.5 ])
				minkowski()
				{
					cube([ width - 2 * rounded_corner, height - 2 * rounded_corner, base_height ], center = true);
					cylinder(r = rounded_corner, h = 0.01, $fn = 40);
				}

				// upper side
				translate([ 0, y_off, 
                    min(h_front[row], h_back[row]) + abs(h_front[row] - h_back[row]) / 2  - upper_bevel_radius])
				// echo(ang);
				rotate([ -ang, 0, 0 ])
				minkowski()
				{
					minkowski()
					{
						cube([ width - x_diff - 2 * rounded_corner - 2 * upper_bevel_radius, 
                               height - y_diff - 2 * rounded_corner - 2 * upper_bevel_radius, 
                               0.01 ],
						     center = true);
						cylinder(r = rounded_corner, h = 0.01, $fn = 40);
					}
					sphere(r = upper_bevel_radius, $fn = 40);
				}
			}

			// inner
			hull()
			{

				// bottom
				minkowski()
				{
					cube([ width - 2 * thickness - rounded_corner, height - 2 * thickness - rounded_corner, 0.01 ],
					     center = true);
					cylinder(r = rounded_corner / 2, h = 0.01, $fn = 40);
				}

				// upper
				translate([ 0, y_off, min(h_front[row], h_back[row]) - 1 * thickness ])
                //translate([ 0, 2 * thickness, min(h_front[row], h_back[row]) - 1 * thickness ])
				rotate([ -ang, 0, 0 ])

				minkowski()
				{
					cube(
					    [
						    width - x_diff - 2 * thickness - rounded_corner,
						    height - y_diff - 2 * thickness - rounded_corner, 0.01
					    ],
					    center = true);
					cylinder(r = rounded_corner / 2, h = 0.01, $fn = 40);
				}
			}
		}
	}
    }
    
	// stem
	if (stem)
	{
		tube_height = 6.3; // part under 0, add height for total height
		pin_off = 3.8;
		bevel_height = 0.7;
		difference()
		{
			translate([ 0, 0, -tube_height + bevel_height ])
			union()
			{
				cylinder(d = 6.75, h = deep + tube_height - bevel_height, $fn = 60);
				translate([ 0, 0, -bevel_height ])
				cylinder(d2 = 6.75, d1 = 4.4, h = bevel_height, $fn = 60);
			}
			translate([ 0, 0, -tube_height - 0.01 ])
#cylinder(d = 4.4, h = pin_off + 2, $fn = 60);
		}

		// internal pin inside central tube for spring
		translate([ 0, 0, -tube_height - (-pin_off) ])
		{
			scale([ 1, 2, 1 ]) cylinder(d = 1.1, h = 2, $fn = 10);
		}
	}

	// pin height is around 6
	translate([ 0, 0, -6 ])
	{

		// bottom part
		// circular positioning upper pin
		// translate([-(17.9/2 -2.8),-(17.9/2-2.5+1.5/2)])
		// cylinder(d=1.4, h=8);

		if (enter_pin)
		{
			// circular positioning middle pin
			translate([ -(-height / 2 + 1.5), 0 ])     //-(14.75),0])
			cylinder(d = 1.5, h = 6 + deep, $fn = 60); // 1.4
		}
		if (middle_pin)
		{
			// circular positioning middle pin
			translate([ -width / 2 + 1.5, 0 ])    //-(14.75),0])
			cylinder(d = 1.5, h = 7.5, $fn = 60); // 1.4
			// circular positioning bottom pin
			translate([ -6.4, -17.9 / 2 + 1.5 + 0.1, 0 ])
			cylinder(d = 1.5, h = 7.7, $fn = 60); // 1.4
		}

		if (upper_pin)
		{
			// circular positioning upper pin
			// translate([-6.4,-(-17.9/2+1.5+0.1),0])
			translate([ -(18 / 2 - (1.6 + 1.7 / 2)), (18 / 2 - (4.3 - 1.7 / 2)), 0 ]) /// TODO
			cylinder(d = 1.6, h = 7.7 + 2, $fn = 60);                                 // 1.4
		}

		if (enter_pin)
		{
			if (leg_top_dist)
				translate([ leg_top_dist, width / 2 - 2, 0 ])
			{
				scale([ 1.5, 1, 1 ])
				{
					// cube([2.7,1.2,10],center=true);
					translate([ 0, 0, 0 ])
					{
						rotate([ 0, 0, 45 ])
						cylinder(9, 0.7 + 0.2, 1, $fn = 4);
						// cube([2.7,1.7,1.5],center=true); //peg
						translate([ 0, 0.25, -1 ])
						rotate([ 0, 0, 45 ])
						cylinder(1.5, 0.7, 1.1 + 0.6, $fn = 4); // lower tab. this retains the key
					}
				}
			}
		}

		else
		{
			// legs
			// translate([-(17.9/2 -2.8),17.9/2-2,5]){
			// translate([-6.7,17.9/2-2,5]){ //copy
			if (leg_top_dist)
				translate([ leg_top_dist, 17.9 / 2 - 2, 5 ])
			{
				scale([ 1.5, 1, 1 ])
				{
					// cube([2.7,1.2,10],center=true);
					translate([ 0, 0.25, -5 ])
					{
						rotate([ 0, 0, 45 ])
						cylinder(12, 0.7 + 0.2, 1.2, $fn = 4);
						// cube([2.7,1.7,1.5],center=true); //peg
						translate([ 0, 0.25, -1 ])
						rotate([ 0, 0, 45 ])
						cylinder(1.5, 0.7, 1.1 + 0.6, $fn = 4); // lower tab. this retains the key
					}
				}
			}
		}

		if (enter_pin)
		{
			if (leg_bottom_dist)
				translate([ leg_bottom_dist, -(width / 2 - 2), 0 ])
			{
				scale([ 1.5, 1, 1 ])
				{
					// cube([2.7,1.2,10],center=true);
					translate([ 0, -0, 0 ])
					{
						rotate([ 0, 0, 45 ])
						cylinder(9, 0.7 + 0.2, 1.2, $fn = 4);
						// cube([2.7,1.7,1.5],center=true); //peg
						translate([ 0, -0.25, -1 ])
						rotate([ 0, 0, 45 ])
						cylinder(1.5, 0.7, 1.1 + 0.6, $fn = 4); // lower tab. this retains the key
					}
				}
			}
		}
		else
		{

			// translate([7.5,-(17.9/2-2),5]){ //copy
			if (leg_bottom_dist)
				translate([ leg_bottom_dist, -(17.9 / 2 - 2), 5 ])
			{
				scale([ 1.5, 1, 1 ])
				{
					// cube([2.7,1.2,10],center=true);
					translate([ 0, 0.25, -5 ])
					{ // should be 0.25 like the other?
						rotate([ 0, 0, 45 ])
						cylinder(9, 0.7 + 0.2, 1, $fn = 4);
						// cube([2.7,1.7,1.5],center=true); //peg
						translate([ 0, -0.25, -1 ])
						rotate([ 0, 0, 45 ])
						cylinder(1.5, 0.7, 1.1 + 0.6 + 0.2, $fn = 4); // lower tab. this retains the key
					}
				}
			}
		}
	}
	// longer keys have retainers
	rotate([ 0, 0, rotate_retainer ])
	if (retainer)
	{
		translate([ retainer_width / 2, 2, 0 ])
		rotate([ 0, 0, 180 ])
		key_retainer_6128(deep);
		translate([ -retainer_width / 2, 2, 0 ])
		rotate([ 0, 0, 180 ])
		key_retainer_6128(deep);
	}

    //for the space bar
	if (extra_pin_width)
	{
		translate([ extra_pin_width / 2, -2, 0 ])
		translate([ 0, 3.9 / 2, -(deep + 5.7) / 2 + 5.7 ])
		cube([ 0.8, 3.9, deep + 5.7 ], center = true);
		translate([ -extra_pin_width / 2, -2, 0 ])
		translate([ 0, 3.9 / 2, -(deep + 5.7) / 2 + 5.7 ])
		cube([ 0.8, 3.9, deep + 5.7 ], center = true);
	}
}

//main key function
module key_old(width = 18, height = 18, x_diff = 5.2, y_diff = 4.5, retainer = false, deep = 7.2, enter = 0, row = 0,
           rotate_key = 0, retainer_width = 0, rotate_retainer = 0, middle_pin = false, upper_pin = true,
           enter_pin = false, leg_top_dist = -2, leg_bottom_dist = 2, extra_pin_width = 0, stem = true, keycap=true, y_off=2, 	rounded_corner = 0.5, thickness = 1, upper_bevel_radius = 0 )
{

	//y_off = 2; // upper y offset

	// CPC keys have 0 angle but I give you the opportunity to create different styles :)
	h_front = [ deep, deep ];    // front height
	h_back = [ deep, deep - 1 ]; // bottom height
	w_up = width - x_diff;       // upper width

	// compute angle for upper side
	ang = atan2(h_front[row] - h_back[row], w_up);

	// keycap is the difference of inner and outer shell
	// inner and outher shells are hulls from upper and bottom countours
    if (keycap){
	rotate([ 0, 0, rotate_key ])
	{
		difference()
		{
			// outer
			hull()
			{
				// bottom side
				translate([ 0, 0, 0.5 ])
				minkowski()
				{
					cube([ width - 2 * rounded_corner, height - 2 * rounded_corner, 1 ], center = true);
					cylinder(r = rounded_corner, h = 0.01, $fn = 40);
				}

				// upper side
				translate([ 0, y_off, min(h_front[row], h_back[row]) + abs(h_front[row] - h_back[row]) / 2 ])
				// echo(ang);
				rotate([ -ang, 0, 0 ])
				minkowski()
				{
					minkowski()
					{
						cube([ width - x_diff - 2 * rounded_corner, height - y_diff - 2 * rounded_corner, 0.01 ],
						     center = true);
						cylinder(r = rounded_corner, h = 0.01, $fn = 40);
					}
					sphere(r = upper_bevel_radius, $fn = 40);
				}
			}

			// inner
			hull()
			{

				// bottom
				minkowski()
				{
					cube([ width - 2 * thickness - rounded_corner, height - 2 * thickness - rounded_corner, 0.01 ],
					     center = true);
					cylinder(r = rounded_corner / 2, h = 0.01, $fn = 40);
				}

				// upper
				translate([ 0, y_off, min(h_front[row], h_back[row]) - 1 * thickness ])
                //translate([ 0, 2 * thickness, min(h_front[row], h_back[row]) - 1 * thickness ])
				rotate([ -ang, 0, 0 ])

				minkowski()
				{
					cube(
					    [
						    width - x_diff - 2 * thickness - rounded_corner,
						    height - y_diff - 2 * thickness - rounded_corner, 0.01
					    ],
					    center = true);
					cylinder(r = rounded_corner / 2, h = 0.01, $fn = 40);
				}
			}
		}
	}
    }
    
	// stem
	if (stem)
	{
		tube_height = 6.3; // part under 0, add height for total height
		pin_off = 3.8;
		bevel_height = 0.7;
		difference()
		{
			translate([ 0, 0, -tube_height + bevel_height ])
			union()
			{
				cylinder(d = 6.75, h = deep + tube_height - bevel_height, $fn = 60);
				translate([ 0, 0, -bevel_height ])
				cylinder(d2 = 6.75, d1 = 4.4, h = bevel_height, $fn = 60);
			}
			translate([ 0, 0, -tube_height - 0.01 ])
#cylinder(d = 4.4, h = pin_off + 2, $fn = 60);
		}

		// internal pin inside central tube for spring
		translate([ 0, 0, -tube_height - (-pin_off) ])
		{
			scale([ 1, 2, 1 ]) cylinder(d = 1.1, h = 2, $fn = 10);
		}
	}

	// pin height is around 6
	translate([ 0, 0, -6 ])
	{

		// bottom part
		// circular positioning upper pin
		// translate([-(17.9/2 -2.8),-(17.9/2-2.5+1.5/2)])
		// cylinder(d=1.4, h=8);

		if (enter_pin)
		{
			// circular positioning middle pin
			translate([ -(-height / 2 + 1.5), 0 ])     //-(14.75),0])
			cylinder(d = 1.5, h = 6 + deep, $fn = 60); // 1.4
		}
		if (middle_pin)
		{
			// circular positioning middle pin
			translate([ -width / 2 + 1.5, 0 ])    //-(14.75),0])
			cylinder(d = 1.5, h = 7.5, $fn = 60); // 1.4
			// circular positioning bottom pin
			translate([ -6.4, -17.9 / 2 + 1.5 + 0.1, 0 ])
			cylinder(d = 1.5, h = 7.7, $fn = 60); // 1.4
		}

		if (upper_pin)
		{
			// circular positioning upper pin
			// translate([-6.4,-(-17.9/2+1.5+0.1),0])
			translate([ -(18 / 2 - (1.6 + 1.7 / 2)), (18 / 2 - (4.3 - 1.7 / 2)), 0 ]) /// TODO
			cylinder(d = 1.6, h = 7.7 + 2, $fn = 60);                                 // 1.4
		}

		if (enter_pin)
		{
			if (leg_top_dist)
				translate([ leg_top_dist, width / 2 - 2, 0 ])
			{
				scale([ 1.5, 1, 1 ])
				{
					// cube([2.7,1.2,10],center=true);
					translate([ 0, 0, 0 ])
					{
						rotate([ 0, 0, 45 ])
						cylinder(9, 0.7 + 0.2, 1, $fn = 4);
						// cube([2.7,1.7,1.5],center=true); //peg
						translate([ 0, 0.25, -1 ])
						rotate([ 0, 0, 45 ])
						cylinder(1.5, 0.7, 1.1 + 0.6, $fn = 4); // lower tab. this retains the key
					}
				}
			}
		}

		else
		{
			// legs
			// translate([-(17.9/2 -2.8),17.9/2-2,5]){
			// translate([-6.7,17.9/2-2,5]){ //copy
			if (leg_top_dist)
				translate([ leg_top_dist, 17.9 / 2 - 2, 5 ])
			{
				scale([ 1.5, 1, 1 ])
				{
					// cube([2.7,1.2,10],center=true);
					translate([ 0, 0.25, -5 ])
					{
						rotate([ 0, 0, 45 ])
						cylinder(12, 0.7 + 0.2, 1.2, $fn = 4);
						// cube([2.7,1.7,1.5],center=true); //peg
						translate([ 0, 0.25, -1 ])
						rotate([ 0, 0, 45 ])
						cylinder(1.5, 0.7, 1.1 + 0.6, $fn = 4); // lower tab. this retains the key
					}
				}
			}
		}

		if (enter_pin)
		{
			if (leg_bottom_dist)
				translate([ leg_bottom_dist, -(width / 2 - 2), 0 ])
			{
				scale([ 1.5, 1, 1 ])
				{
					// cube([2.7,1.2,10],center=true);
					translate([ 0, -0, 0 ])
					{
						rotate([ 0, 0, 45 ])
						cylinder(9, 0.7 + 0.2, 1.2, $fn = 4);
						// cube([2.7,1.7,1.5],center=true); //peg
						translate([ 0, -0.25, -1 ])
						rotate([ 0, 0, 45 ])
						cylinder(1.5, 0.7, 1.1 + 0.6, $fn = 4); // lower tab. this retains the key
					}
				}
			}
		}
		else
		{

			// translate([7.5,-(17.9/2-2),5]){ //copy
			if (leg_bottom_dist)
				translate([ leg_bottom_dist, -(17.9 / 2 - 2), 5 ])
			{
				scale([ 1.5, 1, 1 ])
				{
					// cube([2.7,1.2,10],center=true);
					translate([ 0, 0.25, -5 ])
					{ // should be 0.25 like the other?
						rotate([ 0, 0, 45 ])
						cylinder(9, 0.7 + 0.2, 1, $fn = 4);
						// cube([2.7,1.7,1.5],center=true); //peg
						translate([ 0, -0.25, -1 ])
						rotate([ 0, 0, 45 ])
						cylinder(1.5, 0.7, 1.1 + 0.6 + 0.2, $fn = 4); // lower tab. this retains the key
					}
				}
			}
		}
	}
	// longer keys have retainers
	rotate([ 0, 0, rotate_retainer ])
	if (retainer)
	{
		translate([ retainer_width / 2, 2, 0 ])
		rotate([ 0, 0, 180 ])
		key_retainer(deep);
		translate([ -retainer_width / 2, 2, 0 ])
		rotate([ 0, 0, 180 ])
		key_retainer(deep);
	}

    //for the space bar
	if (extra_pin_width)
	{
		translate([ extra_pin_width / 2, -2, 0 ])
		translate([ 0, 3.9 / 2, -(deep + 5.7) / 2 + 5.7 ])
		cube([ 0.8, 3.9, deep + 5.7 ], center = true);
		translate([ -extra_pin_width / 2, -2, 0 ])
		translate([ 0, 3.9 / 2, -(deep + 5.7) / 2 + 5.7 ])
		cube([ 0.8, 3.9, deep + 5.7 ], center = true);
	}
}