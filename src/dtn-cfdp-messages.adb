--------------------------------------------------------------------------------
-- FILE   : dtn-cfdp-messages.adb
-- SUBJECT: Package containing the CFDP message loop
-- AUTHOR : (C) Copyright 2021 by Vermont Technical College
--
-- This is in it's own child package so that it can be left out of the test program. The message
-- loop doesn't terminate and we want the test program to terminate!
--------------------------------------------------------------------------------
pragma SPARK_Mode(On);

with DTN.CFDP.API;
with DTN.CFDP.Internals;

package body DTN.CFDP.Messages is
   use Message_Manager;
   use DTN.CFDP.Internals;

   -- This is horribly memory inefficient (because Transaction_ID is a 16 bit type).
   Transactions : array(DTN.CFDP.API.Transaction_ID) of Transaction_Record;

   
   procedure Get_Free_Transaction(Transaction : out DTN.CFDP.API.Transaction_ID; Found : out Boolean)
     with
       Global => (In_Out => Transactions),
       Depends => ((Transactions, Transaction, Found) => Transactions)
   is
   begin
      -- Initialize out parameters to the "not found" case.
      Transaction := DTN.CFDP.API.Transaction_ID'First;
      Found := False;

      -- Look for the first available transaction record.
      for I in DTN.CFDP.API.Transaction_ID loop
         if not Transactions(I).Is_Used then
            Transactions(I).Is_Used := True;
            Transaction := I;
            Found := True;
            exit;
         end if;
      end loop;
   end Get_Free_Transaction;

   -----------------------------------
   -- Message Decoding and Dispatching
   -----------------------------------

   -- Here is where decoding procedures should be placed for splitting messages into well
   -- typed values according to the message API.

   -- TODO. This should be part of the XDR2OS3 generated API package!


   -------------------
   -- Message Handling
   -------------------
   
   procedure Handle_Put_Request(Message : in Message_Record)   
     with Pre => DTN.CFDP.API.Is_Put_Request(Message)
   is
      Transaction       : DTN.CFDP.API.Transaction_ID;
      Transaction_Found : Boolean;
      Status            : Message_Status_Type;
   begin
      -- TODO: Must decode all the message parameters!
      DTN.CFDP.API.Put_Request_Decode(Message, Status);
      Get_Free_Transaction(Transaction, Transaction_Found);
      if not Transaction_Found then
         -- TODO: What should happen if we can't honor the put request?
         null;
      else
         -- Send the user a Transaction.indication.
         -- TODO: Generalize this code so that arbitrary domains can be used.
         Message_Manager.Route_Message
           (DTN.CFDP.API.Transaction_Indication_Reply_Encode
              (Message.Sender_Domain, Message.Sender, Message.Request_ID, Transaction));

         -- TODO Create and send a metadata PDU.
      end if;
   end Handle_Put_Request;
   
   
   procedure Handle_Cancel_Request(Message : in Message_Record)
     with Pre => DTN.CFDP.API.Is_Cancel_Request(Message)
   is
   begin
      -- TODO: Not implemented.
      null;
   end Handle_Cancel_Request;
   
   
   procedure Handle_Suspend_Request(Message : in Message_Record)
     with Pre => DTN.CFDP.API.Is_Suspend_Request(Message)
   is
   begin
      -- TODO: Not implemented.
      null;
   end Handle_Suspend_Request;
   
   
   procedure Handle_Resume_Request(Message : in Message_Record)
     with Pre => DTN.CFDP.API.Is_Resume_Request(Message)
   is
   begin
      -- TODO: Not implemented.
      null;
   end Handle_Resume_Request;
   
   
   procedure Handle_Report_Request(Message : in Message_Record)
     with Pre => DTN.CFDP.API.Is_Report_Request(Message)
   is
   begin
      -- TODO: Not implemented.
      null;
   end Handle_Report_Request;
   
   
   -----------------------------------
   -- Message Decoding and Dispatching
   -----------------------------------
   
   procedure Process(Message : in Message_Record)
     with Global => (In_Out => (Transactions, Mailboxes))
   is
   begin
      if DTN.CFDP.API.Is_Put_Request(Message) then
         Handle_Put_Request(Message);
      elsif DTN.CFDP.API.Is_Cancel_Request(Message) then    
         Handle_Cancel_Request(Message);       
      elsif DTN.CFDP.API.Is_Suspend_Request(Message) then       
         Handle_Suspend_Request(Message);   
      elsif DTN.CFDP.API.Is_Resume_Request(Message) then        
         Handle_Resume_Request(Message);            
      elsif DTN.CFDP.API.Is_Report_Request(Message) then        
         Handle_Report_Request(Message);            
      else
         -- TODO: Deal with unknown or malformed messages in a useful way.
         null;
      end if;
   end Process;

   ---------------
   -- Message Loop
   ---------------

   task body Message_Loop is
      Incoming_Message : Message_Manager.Message_Record;
   begin
      loop
         Message_Manager.Fetch_Message(ID, Incoming_Message);
         Process(Incoming_Message);
      end loop;
   end Message_Loop;

end DTN.CFDP.Messages;
