local GhostReconHandleSendChatMessage = BaseClass("GhostReconHandleSendChatMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, uuid, type, targetUid)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
  self.sfsObj:PutInt("type", type)
  self.sfsObj:PutUtfString("targetUid", targetUid)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t ~= nil then
    if t.errorCode == nil then
      DataCenter.ActGhostreconManager:GhostReconHandleSendChatHandler(t)
    else
      UIUtil.ShowTipsId(t.errorCode)
    end
  end
end

GhostReconHandleSendChatMessage.OnCreate = OnCreate
GhostReconHandleSendChatMessage.HandleMessage = HandleMessage
return GhostReconHandleSendChatMessage
