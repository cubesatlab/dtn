--------------------------------------------------------------------------------
-- FILE   : dtn-cfdp-messages.adb
-- SUBJECT: A package containing the CFDP message loop.
-- AUTHOR : (C) Copyright 2021 by Vermont Technical College
--
--------------------------------------------------------------------------------
pragma SPARK_Mode(On);

with System;

package DTN.CFDP.Messages is

   task Message_Loop is
      pragma Storage_Size(4 * 1024);
      pragma Priority(System.Default_Priority);
   end Message_Loop;

   pragma Annotate
     (GNATprove,
      Intentional,
      "multiple tasks might queue on protected entry",
      "Every module has a unique ID");

end DTN.CFDP.Messages;
