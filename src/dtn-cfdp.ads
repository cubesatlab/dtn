--------------------------------------------------------------------------------
-- FILE   : dtn-cfdp.ads
-- SUBJECT: Top level package of a CFDP implementation.
-- AUTHOR : (C) Copyright 2021 by Vermont Technical College
--
-- This module implements the CCSDS File Delivery Protocol (CFDP).
--------------------------------------------------------------------------------
pragma SPARK_Mode(On);

with Message_Manager;

package DTN.CFDP is

   ID : constant Message_Manager.Module_ID_Type := 4;

end DTN.CFDP;
