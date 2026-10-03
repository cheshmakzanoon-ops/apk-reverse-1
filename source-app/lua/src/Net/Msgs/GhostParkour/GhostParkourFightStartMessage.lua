local GhostParkourFightStartMessage = BaseClass("GhostParkourFightStartMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GhostParkourFightStartMessage:OnCreate(fightType, restart)
  base.OnCreate(self)
  restart = restart or false
  self.sfsObj:PutInt("fightType", fightType)
  self.sfsObj:PutBool("restart", restart)
end

function GhostParkourFightStartMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LWGhostParkourDataManager:OnStartGame(t)
  end
end

return GhostParkourFightStartMessage
