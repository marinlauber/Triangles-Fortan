# Triangles-Fortan
Various subroutines to deal with triangles

## Write vtu data for Paraview

Build
```bash
gfortran write_vtu.f90 -o write_vtu
```
run
```bash
./write_vtu
```

![triangles](triangle.png)

## Distance to triangle

Algorithm to find the closest distance to a triangle.

Build
```bash
gfortran tri_distance.f90 -o distance
```
Run
```bash
./distance
```
