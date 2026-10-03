local GhostReconQuitTeamMessage = BaseClass("GhostReconQuitTeamMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, uuid)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t == nil or t.errorCode == nil then
  else
    UIUtil.ShowTipsId(t.errorCode)
  end
end

GhostReconQuitTeamMessage.OnCreate = OnCreate
GhostReconQuitTeamMessage.HandleMessage = HandleMessage
return GhostReconQuitTeamMessage
