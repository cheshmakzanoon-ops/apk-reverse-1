local SetBrightnessLevelMessage = BaseClass("SetBrightnessLevelMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function SetBrightnessLevelMessage:OnCreate(level)
  base.OnCreate(self)
  self.sfsObj:PutInt("level", level)
end

function SetBrightnessLevelMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    local para2 = t.errorPara2
    if para2 == nil then
      UIUtil.ShowTipsId(errCode)
    elseif type(para2) == "table" and 0 < #para2 then
      UIUtil.ShowTips(Localization:GetString(errCode, table.unpack(para2)))
    end
    EventManager:GetInstance():DelayBroadcast(0.1, EventId.BatteryPowerResourceUpdated)
    return
  else
    SFSNetwork.SendMessage(MsgDefines.FetchCityLightStatusInfo)
  end
end

return SetBrightnessLevelMessage
