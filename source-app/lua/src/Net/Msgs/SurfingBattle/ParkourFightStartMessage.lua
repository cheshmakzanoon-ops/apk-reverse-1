local ParkourFightStartMessage = BaseClass("ParkourFightStartMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ParkourFightStartMessage:OnCreate(restart)
  base.OnCreate(self)
  restart = restart or false
  self.sfsObj:PutBool("restart", restart)
end

function ParkourFightStartMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LWSurfingDataManager:OnStartGame(t)
  end
end

return ParkourFightStartMessage
