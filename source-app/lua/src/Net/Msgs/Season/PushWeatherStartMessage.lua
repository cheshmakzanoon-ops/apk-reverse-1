local PushWeatherStartMessage = BaseClass("PushWeatherStartMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushWeatherStartMessage:OnCreate()
  base.OnCreate(self)
end

function PushWeatherStartMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.SeasonWeatherManager:InitData(t, true)
end

return PushWeatherStartMessage
