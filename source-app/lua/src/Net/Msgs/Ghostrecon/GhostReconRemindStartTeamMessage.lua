local GhostReconRemindStartTeamMessage = BaseClass("GhostReconRemindStartTeamMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, uuid)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t ~= nil then
    if t.errorCode == nil then
      DataCenter.ActGhostreconManager:GhostReconRemindStartTeamHandler(t)
    else
      UIUtil.ShowTipsId(t.errorCode)
    end
  end
end

GhostReconRemindStartTeamMessage.OnCreate = OnCreate
GhostReconRemindStartTeamMessage.HandleMessage = HandleMessage
return GhostReconRemindStartTeamMessage
