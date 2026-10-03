local ParkourFightStartCheckMessage = BaseClass("ParkourFightStartCheckMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ParkourFightStartCheckMessage:OnCreate()
  base.OnCreate(self)
end

function ParkourFightStartCheckMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LWSurfingDataManager:FightStartCheck(t)
  end
end

return ParkourFightStartCheckMessage
