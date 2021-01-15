--------------------------------------------------------------------------------
-- FILE   : dtn-cfdp-api.adb
-- SUBJECT: Body of a package that declares the interface to the CFDP module.
-- AUTHOR : (C) Copyright 2021 by Vermont Technical College
--
--------------------------------------------------------------------------------
pragma SPARK_Mode(On);

with CubedOS.Lib.XDR;
use  CubedOS.Lib;

package body DTN.CFDP.API is

   function Put_Request_Encode
     (Sender_Domain : Domain_ID_Type;
      Sender      : Module_ID_Type;
      Request_ID  : Request_ID_Type;
      Destination : Entity_ID;
      Source_File : String;
      Destination_File : String;
      Priority    : System.Priority := System.Default_Priority) return Message_Record
   is
      Message : Message_Record := Make_Empty_Message
        (Sender_Domain   => Sender_Domain,
         Receiver_Domain => Domain_ID,
         Sender     => Sender,
         Receiver   => ID,
         Request_ID => Request_ID,
         Message_ID => Message_Type'Pos(Put_Request),
         Priority   => Priority);

      Position : XDR_Index_Type;
      Last : XDR_Index_Type;
   begin
      Position := 0;
      XDR.Encode(XDR.XDR_Unsigned(Destination), Message.Payload, Position, Last);
      Position := Last + 1;
      XDR.Encode(XDR.XDR_Unsigned(Source_File'Length), Message.Payload, Position, Last);
      Position := Last + 1;
      XDR.Encode(Source_File, Message.Payload, Position, Last);
      Position := Last + 1;
      XDR.Encode(XDR.XDR_Unsigned(Destination_File'Length), Message.Payload, Position, Last);
      Position := Last + 1;
      XDR.Encode(Destination_File, Message.Payload, Position, Last);
      Message.Size := Last + 1;
      return Message;
   end Put_Request_Encode;


   function Transaction_Indication_Reply_Encode
     (Receiver_Domain : Domain_ID_Type;
      Receiver    : Module_ID_Type;
      Request_ID  : Request_ID_Type;
      Transaction : Transaction_ID;
      Priority    : System.Priority := System.Default_Priority) return Message_Record
   is
      Message  : Message_Record := Make_Empty_Message
        (Sender_Domain   => Domain_ID,
         Receiver_Domain => Receiver_Domain,
         Sender     => ID,
         Receiver   => Receiver,
         Request_ID => Request_ID,
         Message_ID => Message_Type'Pos(Transaction_Indication_Reply),
         Priority   => Priority);
      Position : XDR_Index_Type;
      Last     : XDR_Index_Type;
   begin
      Position := 0;
      XDR.Encode(XDR.XDR_Unsigned(Transaction), Message.Payload, Position, Last);
      Message.Size := Last + 1;
      return Message;
   end Transaction_Indication_Reply_Encode;


   procedure Put_Request_Decode
     (Message : in Message_Record;
      Decode_Status : out Message_Status_Type) is
   begin
      -- TODO: Finish me!
      Decode_Status := Malformed;
   end Put_Request_Decode;

end DTN.CFDP.API;
