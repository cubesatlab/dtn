---------------------------------------------------------------------------
-- FILE   : dtn_check.adb
-- SUBJECT: The main entry point for the DTN unit test program.
-- AUTHOR : (C) Copyright 2021 by Vermont Technical College
--
-- Please send comments or bug reports to
--
--      CubeSat Laboratory
--      c/o Dr. Carl Brandon
--      Vermont Technical College
--      Randolph Center, VT 05061 USA
--      CBrandon@vtc.vsc.edu
---------------------------------------------------------------------------
with DTN.CFDP.Internals.Check;

procedure DTN_Check is
begin
   DTN.CFDP.Internals.Check.Run_Tests;
end DTN_Check;
