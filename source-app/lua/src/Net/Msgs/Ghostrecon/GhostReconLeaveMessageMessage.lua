local GhostReconLeaveMessageMessage = BaseClass("GhostReconLeaveMessageMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, recordId, msgId, ownerServer)
  base.OnCreate(self)
  self.sfsObj:PutLong("recordUuid", recordId)
  self.sfsObj:PutInt("msgId", msgId)
  self.sfsObj:PutInt("ownerServer", ownerServer)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
end

GhostReconLeaveMessageMessage.OnCreate = OnCreate
GhostReconLeaveMessageMessage.HandleMessage = HandleMessage
return GhostReconLeaveMessageMessage
