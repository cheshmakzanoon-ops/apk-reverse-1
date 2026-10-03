local CityBattleS1RestGainActivityInfoMessage = BaseClass("CityBattleS1RestGainActivityInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function CityBattleS1RestGainActivityInfoMessage:OnCreate(param)
  base.OnCreate(self)
  if param then
    self.sfsObj:PutInt("updateType", param.updateType)
    self.sfsObj:PutUtfString("extendInfo", param.extendInfo)
  end
end

function CityBattleS1RestGainActivityInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.OffSeason1RecaptureManager:OnCityBattleS1RestGainActivityInfoMessage(t)
  end
end

return CityBattleS1RestGainActivityInfoMessage
