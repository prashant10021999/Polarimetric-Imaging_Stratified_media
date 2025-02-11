# Polarimetric-Imaging

### Calculating and Plotting Mueller Matrices of Stratified Media

### Introduction

This repository contains MATLAB code for calculating and plotting Mueller matrices of stratified media. The code supplements the PhD thesis "Coherence in Polarimetry" by Shane Nichols and includes models, plotting tools, and measurement classes. It supports the computation of Mueller matrices using the Berreman and Partial Wave methods and provides tools for k-space mapping and visualization.

Features

Mueller Matrix Calculation: Implements the Berreman and Partial Wave methods.

K-Space Mapping: Generates conoscopic and polar maps.

Plotting Tools: Provides MPlot and MPlot3D classes for visualizing spectral and spatial Mueller matrix data.

Measurement Processing: Includes classes to handle experimental data from a custom-built polarimeter.

Installation

Ensure you have MATLAB installed. Clone this repository and add the necessary files to your MATLAB path.

Usage

### 1. Calculating Mueller Matrices

Building a Model

Define the layers in a stratified medium using:

layer = {material, thickness, euler_angles, thick_layer_flag, isotropic_flag};
layerArray = {layer1, layer2, ..., layerN};

material: Name from materialLib.m or materialLibIso.m.

thickness: Layer thickness in nm.

euler_angles: ZXZ Euler rotation angles in degrees.

thick_layer_flag: Boolean for thick layers.

isotropic_flag: Boolean for isotropic materials.

Running Calculations

Berreman Method:

1.1 M = mmBerreman(layerArray, wavelengths, aoi, bReflect, bNormalize);

Partial Wave Method:

1.2 M = mmPartialWave(layerArray, wavelengths, aoi, bReflect, bNormalize);

### 2. K-Space Mapping

Generate conoscopic or polar maps using:

2.1 M = mmBerremanMap(layerArray, wavelengths, Npts, maxAOI, bReflect, bNorm, bConoscopic);

### 3. Plotting Mueller Matrices

3.1 Using MPlot

pObj = MPlot(wavelengths, mmData, mmError, lineSpec, 'title', 'Sample Plot');

3.2 Using MPlot3D

pObj3D = MPlot3D(mmData, 'palette', 'HotCold Bright');



Dependencies

MATLAB (with required toolboxes)

materialLib.m and materialLibIso.m for material properties

Multiprod Toolbox for optimized matrix operations

References

For theoretical background and implementation details, refer to:

Nichols, S. "Coherence in Polarimetry," PhD Thesis, NYU, 2018.

Nichols et al., "Measurement of transmission and reflection...," J. Opt. Soc. Am. A, 2015.
