// Gmsh project created on Mon Dec 16 19:44:59 2019
SetFactory("OpenCASCADE");
//+
/* Parameters ----------------------------------------------------------------*/
scale = 1;
lc_s = 1e-2*scale;    lc_1 = 10*lc_s;    lc_2 = 10*lc_s;   lc_b = 10;

/* Geometry ------------------------------------------------------------------*/
// Spherocylinder - wall
Cylinder(1) = {-5, 0, 0, 10, 0, 0, 1, 2*Pi};
Sphere(2) = {-5, 0, 0, 1, -Pi/2, Pi/2, 2*Pi};
Sphere(3) = {5, 0, 0, 1, -Pi/2, Pi/2, 2*Pi};

BooleanUnion{ Volume{1}; Delete; }{ Volume{3}; Volume{2}; Delete; }

// Outer Boundary
Sphere(2) = {0, 0, 0, 90, -Pi/2, Pi/2, 2*Pi};

// Volumes definition
BooleanDifference{ Volume{2}; Delete; }{ Volume{1}; Delete; }

/* Physical Entities ---------------------------------------------------------*/
Physical Surface("spherocylinder") = {1, 2, 3, 4};
Physical Surface("boundary") = {5};
Physical Volume("domain") = {2};

/* Mesh ----------------------------------------------------------------------*/
// Background Mesh

// Field 1: Distance from the spherocylinder
Field[1] = Distance;
Field[1].NNodesByEdge = 1000;
//Field[1].EdgesList = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12};
Field[1].FacesList = {1, 2, 3, 4};

// Field 2: Threshold field, which uses the return value of the Distance
// Field[1] in order to define a simple change in element size depending on the
// computed distances (like a boundary layer but non-structured)
Field[2] = Threshold;
Field[2].IField = 1;
Field[2].LcMin = lc_s;
Field[2].LcMax = lc_1;
Field[2].DistMin = 0.1;
Field[2].DistMax = 1;
Field[2].StopAtDistMax = 1;

// Field 3: Characteristic length of VIn inside a spherical ball, VOut outside.
// If Thickness is > 0, the mesh size is interpolated between VIn and VOut in
// a layer around the ball of the prescribed thickness.
Field[3] = Ball;
Field[3].Radius = 8;
Field[3].Thickness = 30;
Field[3].VIn = lc_1;
Field[3].VOut = lc_b;

// Field 4: Same of Field [3]
//Field[4] = Ball;
//Field[4].Radius = 10;
//Field[4].Thickness = 30;
//Field[4].VIn = lc_2;
//Field[4].VOut = lc_b;

// Finally, let's use the minimum of all the fields as the background mesh field
Field[5] = Min;
Field[5].FieldsList = {2, 3};
Background Field = 5;

// The element size is fully specified by a background mesh, so:
Mesh.CharacteristicLengthExtendFromBoundary = 0;
Mesh.CharacteristicLengthFromPoints = 0;
Mesh.CharacteristicLengthFromCurvature = 0;
