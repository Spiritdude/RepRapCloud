// POV-Ray 3.7 Scene File "povcube0.pov"
// author: Friedrich A. Lohmueller,2005/Aug-2009/Jan-2011
// email: Friedrich.Lohmueller_at_t-online.de
// homepage: http://www.f-lohmueller.de
//
#version 3.6; // 3.7;
global_settings{ assumed_gamma 1.0 }
#default{ finish{ ambient 0.1 diffuse 0.9 }} 

#include "colors.inc"  
#include "textures.inc"
// camera-----------------------------------------------------------
#declare Cam0 =camera {ultra_wide_angle angle 60
                       location  <0.0 , 1.0 ,-3.5>
                       look_at   <0.0 , 1.2 , 0.0>}
#declare Cam1 =camera {ultra_wide_angle angle 250 
                       location  <0.0 , 0.5 ,-2.5>
                       look_at   <0.2 , 1.0 , 0.0>}
camera{Cam0}                                                 //<---1   
// sun -------------------------------------------------------------
light_source{<1500,2000,-2500> color White*0.7}
light_source{<-500, 500,-2500> color Yellow*0.7}
// sky -------------------------------------------------------------
sphere{<0,0,0>,1 hollow 
       texture{pigment{gradient <0,1,0> 
                       color_map{[0    color White]          //<---2
                                 [0.15 color White]
                                 [1.0  color Blue]}}
               finish {ambient 1 diffuse 0} } 
       scale 10000}
// ground-----------------------------------------------------------
plane{ <0,1,0>, 0 
       texture{ pigment { color rgb <0.80,0.55,0.35>}
                normal  { bumps 0.5 scale 0.05  }
                finish  { phong 0.1 } 
              } // end of texture
     } // end of plane
//==================================================================
#declare R = 0.20;   //radius of the tubes                  //<----3
#declare BigCube1 = union{ 
sphere{<-1,-1,-1>,R}  sphere{< 1,-1,-1>,R} 
sphere{<-1,-1, 1>,R}  sphere{< 1,-1, 1>,R}
sphere{<-1, 1,-1>,R}  sphere{< 1, 1,-1>,R}
sphere{<-1, 1, 1>,R}  sphere{< 1, 1, 1>,R}
cylinder {<-1,-1,-1>,< 1,-1,-1>,R}// 4 in x direction
cylinder {<-1,-1, 1>,< 1,-1, 1>,R}
cylinder {<-1, 1,-1>,< 1, 1,-1>,R}
cylinder {<-1, 1, 1>,< 1, 1, 1>,R}
cylinder {<-1,-1,-1>,<-1, 1,-1>,R}// 4 in y direction
cylinder {<-1,-1, 1>,<-1, 1, 1>,R}
cylinder {< 1,-1,-1>,< 1, 1,-1>,R}
cylinder {< 1,-1, 1>,< 1, 1, 1>,R}
cylinder {<-1,-1,-1>,<-1,-1, 1>,R}// 4 in z direction
cylinder {<-1, 1,-1>,<-1, 1, 1>,R}
cylinder {< 1,-1,-1>,< 1,-1, 1>,R}
cylinder {< 1, 1,-1>,< 1, 1, 1>,R}

texture{ pigment{ color rgb<1,0.65,0> }                      //<----4
         finish { phong 1 }
       }  
}//------ end of the cubiform frame definition ----------------------
//
//------------- Zeichnen --------------------------------------------
object{ BigCube1 scale 0.7 
        rotate<0,60,0> translate<0,1.2,0>}
//---------------------------------------------------------- end ----

