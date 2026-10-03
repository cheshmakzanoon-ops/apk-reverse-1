local SetLighthouseBrightnessAutoDowngradeMessage = BaseClass("SetLighthouseBrightnessAutoDowngradeMessage", SFSBaseMessage)
local base = SFSBaseMessage

function SetLighthouseBrightnessAutoDowngradeMessage:OnCreate(autoDownGrade)
  base.OnCreate(self)
  self.sfsObj:PutInt("autoDownGrade", autoDownGrade)
end

function SetLighthouseBrightnessAutoDowngradeMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  local lightHouseStatus = DataCenter.SeasonPowerWorkerManager.lightHouseStatus
  if lightHouseStatus then
    lightHouseStatus.autoDownGrade = toInt(t.autoDownGrade)
  end
  UIUtil.ShowTipsId(120094)
end

return SetLighthouseBrightnessAutoDowngradeMessage
