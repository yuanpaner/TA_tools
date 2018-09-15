----------------------------------------------------------------------------------------
-- Script Name:		JJTools8_BipedSelectionTools.mcr
-- Compatible:		Max 4, 5, 6, 7 and 8
-- Version:			v1.6
-- Started:      	18 May 2004
-- Last Modified: 	10 November 2005
-- Code by:			Jim Jagger jimjagger@hotmail.com
-- 					www.JimJagger.com
-- Based on an idea by Saku Partamies
----------------------------------------------------------------------------------------
-- Requires: JJTools8_JimFunctions.ms
--			 BipSelTools_head1.bmp
--			 BipSelTools_spine1.bmp
--			 BipSelTools_pelvis1.bmp
--			 BipSelTools_left1.bmp
--			 BipSelTools_right1.bmp
--			 BipSelTools_HoriVert.bmp
--			 BipSelTools_Hori.bmp
--			 BipSelTools_Vert.bmp
--			 BipSelTools_Syn.bmp
--			 BipSelTools_All.bmp
--			 BipSelTools_lfingers1.bmp
--			 BipSelTools_rfingers1.bmp
--			 BipSelTools_lthumbs1.bmp
--			 BipSelTools_rthumbs1.bmp
----------------------------------------------------------------------------------------
-- v1.0  -- 2004.05.18 -- First release
-- v1.1  -- 2004.05.19 -- Included support for fingers
-- v1.11 -- 2004.05.20 -- Included support for multiple finger selections and fixed a 
--						  bug relating to the root bone on multiple bipeds.  Also added 
--						  a select entire biped button and supported fileIn() for the
--						  select symmetry feature
-- v1.12 -- 2004.05.21 -- Added option to hide/unhide all bipeds
-- v1.13 -- 2004.05.25 -- Added support for horizontal, vertical and rotational selections
-- v1.14 -- 2004.05.27 -- Changed the buttons to images with rollovers and added support
--						  for multiple selections through the use of the shift key.  Also
--						  added the option to select the entire biped while switching to
--						  the hierarchy panel.  This allows the horizontal, vertical
--						  and rotational selections of the root to be active at the same
--						  time.
-- v1.15 -- 2004.05.28 -- Added the option to shift click objects to add multiple bones.
--						  Also added pivot selections for the feet objects, based on a
--						  script by Carl Boulay
-- v1.16 -- 2004.06.04 -- Added support for shift clicking root node
-- v1.17 -- 2004.06.08 -- Added an extended 'about' box to help people who use this script
--						  remotely ie Shanghai
-- v1.18 -- 2004.06.10 -- Added callbacks so that the file automatically updates whenever
--						  the user opens a file
-- v1.19 -- 2004.06.18 -- Switched the selection panel to Motion on selection of feet
--						  Also fixed the missing selection of a finger on multiple selects
-- v1.20 -- 2004.06.23 -- Added support for snapshotting hands
-- v1.21 -- 2004.06.25 -- Added support for snapshotting anything
-- v1.22 -- 2004.06.30 -- Added fig mode and box dispaly toggles
-- v1.23 -- 2004.06.30 -- Added toggle for mesh visability
-- v1.24 -- 2004.07.05 -- Restrutcutred the code to use functions instead of repetitive
--						  lines.  It may be a little slower now but it is far more robust
-- v1.25 -- 2004.07.06 -- Created new icons for advanced features
-- v1.26 -- 2004.07.08 -- Added support for loading and saving poses as well as bip files
-- v1.27 -- 2004.07.12 -- Added support for toggling the visability of dummy roots
-- v1.5b -- 2005.02.25 -- Modified the script for general release
-- v1.6  -- 2005.11.10 -- Added support for Max 8
-- v1.61 -- 2005.11.10 -- Improved spine selection thanks to Dani Rosen
----------------------------------------------------------------------------------------
-- To Add
-- Add support for Pony Tails and Tail.
-- Chop version down into a more generic structure
----------------------------------------------------------------------------------------

macroscript JJTools8_BipedSelectionTools_POP
category:"JJTools 8"
tooltip:"Biped Selection Tools"
buttontext:"Biped Selection Tools"
icon:#("JJTools", 14)

(	
	filein (getdir #maxroot+"scripts\\JJTools8\\JJTools8_BipedSelectionTools.ms")
)