/*
 Decription: Keycaps for 
 Author: Ismael Salvador
 Date: 05/09/22
 
 Keytop is assumed to the flat
 Rounded surfaces are not nice for FDM 
 Print it updside down without any support. Only RETURN key needs support.
 
 Legs and centering pins are very fragile!!!
 Take extra care when removing it from the printer bed or installing them.
 
 TODOs: Separate files. Integrate hb10x. do it keycap agnostic in order to make it work with keyv2
 
*/

use <retro_keys.scad>;

module key_stem_6128(deep=7.2){
	// stem
	
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


module retainer_pair_6128(rotate_retainer=0, retainer_width=0, deep=7.2){
 
        // longer keys have retainers
        rotate([ 0, 0, rotate_retainer ]){
	
		translate([ retainer_width / 2, 2, 0 ])
		rotate([ 0, 0, 180 ])
		key_retainer_6128(deep);
		translate([ -retainer_width / 2, 2, 0 ])
		rotate([ 0, 0, 180 ])
		key_retainer_6128(deep);
        }
	
}

module middle_pin_6128(width=17.9){
            // pin height is around 6
            translate([ 0, 0, -6 ]){
        // circular positioning middle pin
    translate([ -width / 2 + 1.5, 0 ])    //-(14.75),0])
    cylinder(d = 1.5, h = 7.5, $fn = 60); // 1.4
    // circular positioning bottom pin
    translate([ -6.4, -17.9 / 2 + 1.5 + 0.1, 0 ])
    cylinder(d = 1.5, h = 7.7, $fn = 60); // 1.4
            }
}

module enter_pin_6128(height=0, deep=0){	
            // pin height is around 6
            translate([ 0, 0, -6 ])	
			// circular positioning middle pin
			translate([ -(-height / 2 + 1.5), 0 ])     //-(14.75),0])
			cylinder(d = 1.5, h = 6 + deep, $fn = 60); // 1.4
}

module upper_pin_6128(){
                // pin height is around 6
            translate([ 0, 0, -6 ])
// circular positioning upper pin
			translate([ -(18 / 2 - (1.6 + 1.7 / 2)), (18 / 2 - (4.3 - 1.7 / 2)), 0 ]) /// TODO
			cylinder(d = 1.6, h = 7.7 + 2+1, $fn = 60);                                 // 1.4
}

module extra_pin_6128(extra_pin_width=0, deep=0){
    //for space bar
    translate([ extra_pin_width / 2, -2, 0 ])
        translate([ 0, 3.9 / 2, -(deep + 5.7) / 2 + 5.7 ])
		cube([ 0.8, 3.9, deep + 5.7 ], center = true);
		translate([ -extra_pin_width / 2, -2, 0 ])
		translate([ 0, 3.9 / 2, -(deep + 5.7) / 2 + 5.7 ])
		cube([ 0.8, 3.9, deep + 5.7 ], center = true);
}

module leg_6128(enter_pin=false, width=0, leg_top_dist=0, leg_bottom_dist=0){
    translate([ 0, 0, -6 ])
    {
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
			if (leg_top_dist)
				translate([ leg_top_dist, 17.9 / 2 - 2, 5 ])
			{
				scale([ 1.5, 1, 1 ])
				{					
					translate([ 0, 0.25, -5 ])
					{
						rotate([ 0, 0, 45 ])
						cylinder(12, 0.7 + 0.2, 1.2, $fn = 4);						
						translate([ 0, 0.25, -1 ])
						rotate([ 0, 0, 45 ])
						cylinder(1.5, 0.7, 1.1 + 0.6, $fn = 4); // lower tab. this holds the key
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
					translate([ 0, -0, 0 ])
					{
						rotate([ 0, 0, 45 ])
						cylinder(9, 0.7 + 0.2, 1.2, $fn = 4);
						translate([ 0, -0.25, -1 ])
						rotate([ 0, 0, 45 ])
						cylinder(1.5, 0.7, 1.1 + 0.6, $fn = 4); // lower tab. this holds the key
					}
				}
			}
		}
		else
		{
			if (leg_bottom_dist)
				translate([ leg_bottom_dist, -(17.9 / 2 - 2), 5 ])
			{
				scale([ 1.5, 1, 1 ])
				{
					translate([ 0, 0.25, -5 ])
					{
						rotate([ 0, 0, 45 ])
						cylinder(9, 0.7 + 0.2, 1, $fn = 4);					
						translate([ 0, -0.25, -1 ])
						rotate([ 0, 0, 45 ])
						cylinder(1.5, 0.7, 1.1 + 0.6 + 0.2, $fn = 4); // lower tab. this holds the key
					}
				}
			}
		}
	}
}


module key_6128(){
    width=18;
    height=18;
    
    key(width = width, height=height, upper_pin = false);
    
    //middle_pin
   upper_pin_6128();

}

// key wrappers based on generic key function

module key_tab_6128_old()
{
	key(width = 27, upper_pin = false, middle_pin = true, leg_top_dist = -(27 / 2 - (8.3 - 2.9 / 2)),
	    leg_bottom_dist = (27 / 2 - (7.7 - 2.9 / 2)));
}

module key_tab_6128()
{	
    width=27;
    height=18;    
    leg_top_dist = -(27 / 2 - (8.3 - 2.9 / 2));
    leg_bottom_dist = (27 / 2 - (7.7 - 2.9 / 2));
    
	key(width = width, middle_pin = false, upper_pin = false, retainer = 0, 
	    leg_top_dist = 0, leg_bottom_dist = 0);
    
    //stem
    key_stem_6128();
    
    //middle pin    
    middle_pin_6128(width=width);
    
    leg_6128(enter_pin=false, width=width, leg_top_dist=leg_top_dist, leg_bottom_dist=leg_bottom_dist);
}

/*
module key_copy_6128_old()
{
	key(width = 32.2, middle_pin = true, leg_top_dist = -6.7, leg_bottom_dist = 7.5, upper_pin = false);
}*/

module key_copy_6128()
{
    width=32.2;
    height=18;    
    leg_top_dist = -6.7;
    leg_bottom_dist = 7.5;
    
	key(width = width, middle_pin = false, upper_pin = false, retainer = 0, 
	    leg_top_dist = 0, leg_bottom_dist = 0);
    
    //stem
    key_stem_6128();
    
    //middle pin    
    middle_pin_6128(width=width);
    
    leg_6128(enter_pin=false, width=width, leg_top_dist=leg_top_dist, leg_bottom_dist=leg_bottom_dist);
}


/*
module key_ctrl_6128_old()
{
	key(width = 41.9, middle_pin = true, upper_pin = false, retainer = 1, retainer_width = 23.9,
	    leg_top_dist = -(41.9 / 2 - (7.4 - 2.9 / 2)), leg_bottom_dist = (41.9 / 2 - (15.4 - 2.9 / 2)));
}
*/
module key_ctrl_6128()
{
    width=41.9;
    height=18;
    retainer_width = 23.9;
    leg_top_dist = -(41.9 / 2 - (7.4 - 2.9 / 2));
    leg_bottom_dist = (41.9 / 2 - (15.4 - 2.9 / 2));
    
	key(width = width, middle_pin = false, upper_pin = false, retainer = 0, 
	    leg_top_dist = 0, leg_bottom_dist = 0);
    
    //retainer
    retainer_pair_6128(rotate_retainer=0, retainer_width=retainer_width);
    
    //stem
    key_stem_6128();
    
    //middle pin    
    middle_pin_6128(width=width);
    
    leg_6128(enter_pin=false, width=width, leg_top_dist=leg_top_dist, leg_bottom_dist=leg_bottom_dist);
}

module key_intro_6128()
{
    width=56.2;
    height=18;
    leg_bottom_dist = (56.2 / 2 - (10.7 - 2.9 / 2));
    leg_top_dist = -(56.2 / 2 - (2.2 + 2.9 / 2));
    retainer_width = 43.7 - 1.1;
    
	key(width = width, upper_pin = false, middle_pin = true, leg_top_dist = -(56.2 / 2 - (2.2 + 2.9 / 2)),
	    leg_bottom_dist = 0, retainer = false, retainer_width = 0);
    
    //stem
    key_stem_6128();
    
    //retainer
    retainer_pair_6128(rotate_retainer=0, retainer_width=retainer_width);
    
    leg_6128(enter_pin=false, width=width, leg_top_dist=leg_top_dist, leg_bottom_dist=leg_bottom_dist);
}

/*
module key_intro_6128_old()
{
	key(width = 56.2, upper_pin = false, middle_pin = true, leg_top_dist = -(56.2 / 2 - (2.2 + 2.9 / 2)),
	    leg_bottom_dist = (56.2 / 2 - (10.7 - 2.9 / 2)), retainer = true, retainer_width = 43.7 - 1.1);
}
*/

module key_return_6128_old()
{
	// RETURN key
	// a dirty hack with 2 keys :)

    difference(){
	
	rotate([ 0, 0, 90 ])
	union()
	{
//fillet(r=1,steps=10) 
        {        
		key(width = 22.7, height = 37.1, retainer = 1, retainer_width = 25 - 1.1,
		    leg_bottom_dist = (37.1 / 2 - (1.8 + 2.9 / 2)), leg_top_dist = -(37.1 / 2 - (9.7 + 2.9 / 2)),
		    rotate_key = -90, rotate_retainer = 180, middle_pin = false, upper_pin = false, enter_pin = true);

		translate([ 37.1 / 2 - 18 / 2, 22.7 / 2 + 4.7 / 2 - 2, 0 ])
		rotate([ 0, 0, -90 ])
		key(width = 4.7 + 4, x_diff = 2.6, y_diff = 4.5 - 0.25, height = 18, upper_pin = false, middle_pin = false,
		    leg_top_dist = 0, leg_bottom_dist = 0, stem = false, deep = 4);
}
	}

	//translate([ -(37.1 / 2 - 18 / 2), 22.7 / 2 + 4.7 / 2 - 4.2, 0 ])
    //#cube([ 4.7, 18-2, 3 ], center = true);
    }
}

//TODO check this!!!!!!
module key_return_6128()
{
    width=22.7;
    height=37.1;
    leg_bottom_dist = (height / 2 - (1.8 + 2.9 / 2));
    leg_top_dist =  -(height / 2 - (9.7 + 2.9 / 2));
    retainer_width = 25 - 1.1;
    rotate_retainer = 180;
    width2 = 4.7+4;
    height2 = 18;
    
	// RETURN key
	// a dirty hack with 2 keys :)

    difference(){
	
	rotate([ 0, 0, 90 ])
	union()
	{
//fillet(r=1,steps=10) 
        {        
		key(width = width, height = height, retainer = 0, retainer_width = 25 - 1.1,
		    leg_bottom_dist = 0, leg_top_dist = 0,
		    rotate_key = -90, middle_pin = false, upper_pin = false, enter_pin = false, stem=false);
    //stem
    key_stem_6128();
    
        //retainer
        retainer_pair_6128(rotate_retainer=rotate_retainer, retainer_width=retainer_width);
        //enter pin
        leg_6128(enter_pin=true, width=width, leg_top_dist=leg_top_dist, leg_bottom_dist=leg_bottom_dist);
    
        enter_pin_6128(height=height, deep=7.2);
    
        //low part is modelled as a small low key
		translate([ 37.1 / 2 - 18 / 2, 22.7 / 2 + 4.7 / 2 - 2, 0 ])
		rotate([ 0, 0, -90 ])
		key(width = width2, x_diff = 2.6, y_diff = 4.5 - 0.25, height = height2, upper_pin = false, middle_pin = false,
		    leg_top_dist = 0, leg_bottom_dist = 0, stem = false, deep = 4);
}
	}

	//translate([ -(37.1 / 2 - 18 / 2), 22.7 / 2 + 4.7 / 2 - 4.2, 0 ])
    //#cube([ 4.7, 18-2, 3 ], center = true);
    }
}


module key_space_6128_old()
{
	key(width = 151, middle_pin = false, upper_pin = false, leg_top_dist = -44, leg_bottom_dist = 65.3, retainer = true,
	    retainer_width = 107.3, extra_pin_width = 131.2);
}

module key_space_6128()
{
    width=151;
    height=18;
    leg_bottom_dist = 65.3;
    leg_top_dist =  -44;
    retainer_width = 107.3;
    rotate_retainer = 0;
    extra_pin_width = 131.2;
    
	key(width = 151, middle_pin = false, upper_pin = false, leg_top_dist = -44, leg_bottom_dist = 65.3, retainer = false);
    
    //stem
    key_stem_6128();
    
    //retainer
        retainer_pair_6128(rotate_retainer=rotate_retainer, retainer_width=retainer_width);
    //enter pin
    leg_6128(enter_pin=false, width=width, leg_top_dist=leg_top_dist, leg_bottom_dist=leg_bottom_dist);
    
    extra_pin_6128(extra_pin_width=extra_pin_width, deep=7.2);
    
}

module show_examples_6128()
{
	// key_pin();
	key_y = 25;

	// just a normal key
	key_6128();

	// TAB key
	translate([ 0, -key_y, 0 ])
	key_tab_6128();

	// COPY/RIGHT SHIFT key
	translate([ 0, -key_y * 2, 0 ])
	key_copy_6128();

	// CTRL/LEFT SHIFT key
	translate([ 0, -key_y * 3, 0 ])
	key_ctrl_6128();

	// INTRO key
	translate([ 0, -key_y * 4, 0 ])
	key_intro_6128();

	// SPACE key
	translate([ 151 / 2 + 20, -key_y, 0 ])
	key_space_6128();

    translate([ 0, -key_y * 6, 0 ])
	key_return_6128();
}

show_examples_6128();

/*
{
key();
translate([0,20,0])
make_key() key_6128();
}*/

