local PushRefreshTimeMessage = BaseClass("PushRefreshTimeMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    if t.temperature_help then
      DataCenter.TemperatureManager:SetSendCoalTimes(t.temperature_help)
    end
    if t.whistle_reward then
      DataCenter.MonsterManager:HandleWhistleBoxReward(t)
    end
  end
end

PushRefreshTimeMessage.HandleMessage = HandleMessage
return PushRefreshTimeMessage
