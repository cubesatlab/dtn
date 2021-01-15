--------------------------------------------------------------------------------
-- FILE   : dtn-cfdp-api.ads
-- SUBJECT: Specification of a package that declares the interface to the CFDP module.
-- AUTHOR : (C) Copyright 2021 by Vermont Technical College
--
-- All the subprograms in this package must be task safe. They can be simultaneously called from
-- multiple tasks.
--------------------------------------------------------------------------------
pragma SPARK_Mode(On);

with Message_Manager; use Message_Manager;
with System;

package DTN.CFDP.API is

   -- We have a maximum filename length of 16 characters
   Max_Name_Length : constant := 16;

   -- This implementation uses 16 bit entity IDs.
   type Entity_ID is mod 2**16;

   -- This implementation uses 16 bit transaction IDs.
   type Transaction_ID is mod 2**16;

   type PDU_Category is
     (Metadata_PDU, Filedata_PDU, EOF_PDU, Finished_PDU, Error);

   type Message_Type is
      -- Various request messages sent by the CFDP user to the CFDP entity.
     (Put_Request,
      Cancel_Request,
      Suspend_Request,
      Resume_Request,
      Report_Request,

      -- Various indication messages sent by the CFDP entity to the CFDP user.
      Transaction_Indication_Reply,
      Metadata_Received_Indication_Reply,
      File_Segment_Received_Indication_Reply,
      Suspended_Indication_Reply,
      Resumed_Indication_Reply,
      EOF_Sent_Indication_Reply,
      Transaction_Finished_Indication_Reply,
      Transfer_Consigned_Indication_Reply,
      Report_Indication_Reply,
      Fault_Indication_Reply,
      Abandoned_Indication_Reply,
      EOF_Received_Indication_Reply);


   function Put_Request_Encode
     (Sender_Domain : Domain_ID_Type;
      Sender      : Module_ID_Type;
      Request_ID  : Request_ID_Type;
      Destination : Entity_ID;
      Source_File : String;
      Destination_File : String;
      Priority    : System.Priority := System.Default_Priority) return Message_Record
     with
       Global => null,
       Pre =>
         Source_File'Length > 0 and
         Destination_File'Length > 0 and
         Source_File'Last <= XDR_Size_Type'Last/2 and
         Destination_File'Last <= XDR_Size_Type'Last/2;

   function Transaction_Indication_Reply_Encode
     (Receiver_Domain : Domain_ID_Type;
      Receiver    : Module_ID_Type;
      Request_ID  : Request_ID_Type;
      Transaction : Transaction_ID;
      Priority    : System.Priority := System.Default_Priority) return Message_Record
     with Global => null;


   function Is_Put_Request(Message : Message_Record) return Boolean is
     (Message.Receiver = ID and Message.Message_ID = Message_Type'Pos(Put_Request));

   function Is_Cancel_Request(Message : Message_Record) return Boolean is
     (Message.Receiver = ID and Message.Message_ID = Message_Type'Pos(Cancel_Request));

   function Is_Suspend_Request(Message : Message_Record) return Boolean is
     (Message.Receiver = ID and Message.Message_ID = Message_Type'Pos(Suspend_Request));

   function Is_Resume_Request(Message : Message_Record) return Boolean is
     (Message.Receiver = ID and Message.Message_ID = Message_Type'Pos(Resume_Request));

   function Is_Report_Request(Message : Message_Record) return Boolean is
     (Message.Receiver = ID and Message.Message_ID = Message_Type'Pos(Report_Request));

   function Is_Transaction_Indication_Reply(Message : Message_Record) return Boolean is
     (Message.Sender = ID and Message.Message_ID = Message_Type'Pos(Transaction_Indication_Reply));


   -- TODO: Add the other message parameters.
   procedure Put_Request_Decode
     (Message : in Message_Record;
      Decode_Status : out Message_Status_Type)
     with
       Global => null,
       Pre => Is_Put_Request(Message),
       Depends => (Decode_Status => Message);

end DTN.CFDP.API;
