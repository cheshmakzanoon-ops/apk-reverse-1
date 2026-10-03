local GhostReconKickMemberMessage = BaseClass("GhostReconKickMemberMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, uuid, targetUid)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
  self.sfsObj:PutUtfString("targetUid", targetUid)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t ~= nil then
    if t.errorCode == nil then
      DataCenter.ActGhostreconManager:GhostReconKickMemberHandler(t)
    else
      UIUtil.ShowTipsId(t.errorCode)
    end
  end
end

GhostReconKickMemberMessage.OnCreate = OnCreate
GhostReconKickMemberMessage.HandleMessage = HandleMessage
return GhostReconKickMemberMessage
