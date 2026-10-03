local SetAutoCloseLighthouseWhenBloodNightMessage = BaseClass("SetAutoCloseLighthouseWhenBloodNightMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function SetAutoCloseLighthouseWhenBloodNightMessage:OnCreate(autoClose)
  base.OnCreate(self)
  if autoClose then
    self.sfsObj:PutInt("autoSwitch", 1)
  else
    self.sfsObj:PutInt("autoSwitch", 0)
  end
end

function SetAutoCloseLighthouseWhenBloodNightMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    local para2 = t.errorPara2
    if para2 == nil then
      UIUtil.ShowTipsId(errCode)
    elseif type(para2) == "table" and 1 < #para2 then
      UIUtil.ShowTips(Localization:GetString(t.errorCode, table.unpack(para2)))
    else
      UIUtil.ShowTipsId(errCode)
    end
  elseif t.autoSwitch ~= nil then
    local lightHouseStatus = DataCenter.SeasonPowerWorkerManager.lightHouseStatus
    if lightHouseStatus ~= nil then
      lightHouseStatus.autoCloseOnBloodNight = t.autoSwitch
    end
  end
end

return SetAutoCloseLighthouseWhenBloodNightMessage
