local p_text_log_value_path = "p_text_log_value"
local base = UIBaseContainer
local SeasonAllianceWarTimeSetLogComp = BaseClass("SeasonAllianceWarTimeSetLogComp", UIBaseContainer)

function SeasonAllianceWarTimeSetLogComp:ComponentDefine()
  self.p_text_log_value = self:AddComponent(UITextMeshProUGUIEx, p_text_log_value_path)
end

function SeasonAllianceWarTimeSetLogComp:ComponentDestroy()
  self.p_text_log_value = nil
end

function SeasonAllianceWarTimeSetLogComp:DataDefine()
end

function SeasonAllianceWarTimeSetLogComp:DataDestroy()
end

function SeasonAllianceWarTimeSetLogComp:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function SeasonAllianceWarTimeSetLogComp:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SeasonAllianceWarTimeSetLogComp:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonAllianceWarTimeSwitchServerLocal, self.OnSwitchServerLocal)
end

function SeasonAllianceWarTimeSetLogComp:OnRemoveListener()
  self:RemoveUIListener(EventId.SeasonAllianceWarTimeSwitchServerLocal, self.OnSwitchServerLocal)
  base.OnRemoveListener(self)
end

function SeasonAllianceWarTimeSetLogComp:ReInit(data)
  if self:InitData(data) then
    self:InitUi()
  end
end

function SeasonAllianceWarTimeSetLogComp:InitData(data)
  if data ~= nil then
    self.Data = data
    self.TimeConfig = DataCenter.UILWSeasonAllianceWarTimeManager:GetWarTimeConfigData(self.Data.Log.wartimeindex)
    return self.TimeConfig ~= nil
  end
  return false
end

function SeasonAllianceWarTimeSetLogComp:InitUi()
  self:UpdateLogStr(self.Data.IsLocalTime)
end

function SeasonAllianceWarTimeSetLogComp:UpdateLogStr(isLocalTime)
  local setTime = ""
  local logStr = ""
  if isLocalTime then
    setTime = UITimeManager:GetInstance():TimeStampToTimeForLocal(self.Data.Log.t)
    logStr = CS.GameEntry.Localization:GetString("s5_alliance_battle_time_ui28", self.Data.Log.name, self.TimeConfig:GetLocalTimeRangeStr())
  else
    setTime = UITimeManager:GetInstance():TimeStampToTimeForServer(self.Data.Log.t)
    logStr = CS.GameEntry.Localization:GetString("s5_alliance_battle_time_ui28", self.Data.Log.name, self.TimeConfig:GetServerTimeRangeStr())
  end
  self.p_text_log_value:SetTextFormat("[%s] %s", setTime, logStr)
end

function SeasonAllianceWarTimeSetLogComp:OnSwitchServerLocal(evtData)
  self:UpdateLogStr(evtData)
end

return SeasonAllianceWarTimeSetLogComp
