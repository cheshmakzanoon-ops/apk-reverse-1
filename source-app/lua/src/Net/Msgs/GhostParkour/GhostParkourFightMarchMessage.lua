local GhostParkourFightMarchMessage = BaseClass("GhostParkourFightMarchMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GhostParkourFightMarchMessage:OnCreate(restart)
  base.OnCreate(self)
  self.sfsObj:PutBool("restart", restart)
end

function GhostParkourFightMarchMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LWGhostParkourDataManager:FightStartCheck(t)
  end
end

return GhostParkourFightMarchMessage
