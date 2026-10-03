local SelectTimeItem = BaseClass("SelectTimeItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local data_text_path = "DataText"
local time_text_path = "TimeText"
local checkbox_path = "Checkbox"

function SelectTimeItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function SelectTimeItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SelectTimeItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.BattleFieldChangeShowLocalTime, self.OnChangeShowLocalTime)
end

function SelectTimeItem:OnRemoveListener()
  self:RemoveUIListener(EventId.BattleFieldChangeShowLocalTime, self.OnChangeShowLocalTime)
  base.OnRemoveListener(self)
end

function SelectTimeItem:OnChangeShowLocalTime()
  local isShowLocalTime = BattleFieldUtil.GetShowLocalTime()
  if isShowLocalTime then
    self:ShowLocalTime()
  else
    self:ShowUTCTime()
  end
end

function SelectTimeItem:ComponentDefine()
  self.data_text = self:AddComponent(UIText, data_text_path)
  self.time_text = self:AddComponent(UIText, time_text_path)
  self.checkbox = self:AddComponent(UIToggle, checkbox_path)
  self.checkbox:SetOnValueChanged(function(tf)
    if self.data then
      self.view:OnSetSelectState(tf, self.data.battlePeriod)
    end
  end)
end

function SelectTimeItem:ComponentDestroy()
  self.data_text = nil
  self.time_text = nil
  self.checkbox = nil
end

function SelectTimeItem:ReInit(data)
  self.data = data
  self.checkbox:SetIsOn(false)
  self:OnChangeShowLocalTime()
end

function SelectTimeItem:ShowUTCTime()
  local dataStr = UITimeManager:GetInstance():GetTimeToMD(math.modf(self.data.startTime / 1000))
  self.data_text:SetText(Localization:GetString("Desert_strom_tips1017") .. ": " .. dataStr)
  local startTimeStr = UITimeManager:GetInstance():TimeStampToTimeForServerSimple(self.data.startTime, true)
  local endTimeStr = UITimeManager:GetInstance():TimeStampToTimeForServerSimple(self.data.endTime, true)
  self.time_text:SetText(startTimeStr .. " ~ " .. endTimeStr)
end

function SelectTimeItem:ShowLocalTime()
  local dataStr = UITimeManager:GetInstance():GetTimeToLocalYMD(math.modf(self.data.startTime))
  self.data_text:SetText(Localization:GetString("Desert_strom_tips1017") .. ": " .. dataStr)
  local startTimeLocalStr = UITimeManager:GetInstance():ConvertServerTimeToLocalTime(self.data.startTime, true, true)
  local endTimeLocalStr = UITimeManager:GetInstance():ConvertServerTimeToLocalTime(self.data.endTime, true, true)
  self.time_text:SetText(startTimeLocalStr .. " ~ " .. endTimeLocalStr)
end

return SelectTimeItem
