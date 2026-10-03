local GhostReconDisbandTeamMessage = BaseClass("GhostReconDisbandTeamMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, uuid)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t ~= nil then
    if t.errorCode == nil then
      DataCenter.ActGhostreconManager:GhostReconDisbandTeamHandler(t)
    else
      UIUtil.ShowTipsId(t.errorCode)
    end
  end
end

GhostReconDisbandTeamMessage.OnCreate = OnCreate
GhostReconDisbandTeamMessage.HandleMessage = HandleMessage
return GhostReconDisbandTeamMessage
