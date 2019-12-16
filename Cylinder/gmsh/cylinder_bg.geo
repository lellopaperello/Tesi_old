// Gmsh project created on Mon Dec  9 10:44:41 2019
SetFactory("OpenCASCADE");
//+
/* Parameters ----------------------------------------------------------------*/
scale = 1;
lc_c = 5e-4*scale;    lc_b = 2*scale;

grade = 1.2;
const = (lc_b - lc_c) * 14.5^(-grade);

/* Geometry ------------------------------------------------------------------*/
Circle(1) = {0, 0, 0, 0.5, 0, 2*Pi};
Circle(2) = {0, 0, 0, 15, 0, 2*Pi};

Curve Loop(1) = {1};
Curve Loop(2) = {2};
Plane Surface(1) = {2, 1};

// Physical Entities ---------------------------------------------------------*/
Physical Surface("Domain") = {1};

Physical Curve("Cylinder") = {1};
Physical Curve("Boundary") = {2};

/* Mesh ----------------------------------------------------------------------*/
Characteristic Length {1} = lc_c;
Characteristic Length {2} = lc_b;

// Background Mesh
// Field 1: Distance from the centre
Point(0) = {0.0, 0.0, 0, lc_c};
Field[1] = Distance;
Field[1].NodesList = {0};

// Field 2: CL defined by a polynomial function of grade "grade"
Field[2] = MathEval;
Field[2].F = Sprintf("%g * (F1 - 0.48)^%g + %g", const, grade, lc_c);

// Field 10: Background field ~ Min of all fields
Field[10] = Min;
Field[10].FieldsList = {2};

Background Field = 2;

// Mesh.CharacteristicLengthExtendFromBoundary = 0;
// Mesh.CharacteristicLengthFromPoints = 0;
// Mesh.CharacteristicLengthFromCurvature = 0;

// Selecting Frontal-Delaunay Algorithm
Mesh.Algorithm = 2;
