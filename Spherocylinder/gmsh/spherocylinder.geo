// Gmsh project created on Mon Dec 16 19:44:59 2019
SetFactory("OpenCASCADE");
//+
/* Parameters ----------------------------------------------------------------*/

/* Geometry ------------------------------------------------------------------*/
Cylinder(1) = {-5, 0, 0, 10, 0, 0, 1, 2*Pi};
Sphere(2) = {-5, 0, 0, 1, -Pi/2, Pi/2, 2*Pi};
Sphere(3) = {5, 0, 0, 1, -Pi/2, Pi/2, 2*Pi};

BooleanUnion{ Volume{1}; Delete; }{ Volume{3}; Volume{2}; Delete; }

/* Physical Entities ---------------------------------------------------------*/
Physical Surface("spherocylinder") = {2, 1, 3, 4};
