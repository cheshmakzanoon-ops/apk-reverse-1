local UIAllianceStarOrderTimeItemComponent = BaseClass("UIAllianceStarOrderTimeItemComponent", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.normalLevelText = self:AddComponent(UITextMeshProUGUIEx, "NormalLevelText")
  self.selectLevelText = self:AddComponent(UITextMeshProUGUIEx, "SelectLevelText")
end

local function ComponentDestroy(self)
  self.normalLevelText = nil
  self.selectLevelText = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.UpdateZombieRushSelectPopDate, self.OnUpdateZombieRushSelectDate)
  self:AddUIListener(EventId.UpdateZombieRushSelectPopDifficulty, self.OnUpdateZombieRushSelectDifficulty)
  self:AddUIListener(EventId.UpdateZombieRushSelectPopHour, self.OnUpdateZombieRushSelectHour)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.UpdateZombieRushSelectPopDifficulty, self.OnUpdateZombieRushSelectDifficulty)
  self:RemoveUIListener(EventId.UpdateZombieRushSelectPopDate, self.OnUpdateZombieRushSelectDate)
  self:RemoveUIListener(EventId.UpdateZombieRushSelectPopHour, self.OnUpdateZombieRushSelectHour)
  base.OnRemoveListener(self)
end

local function OnUpdateZombieRushSelectDifficulty(self, selectTemplateId)
  if self.template then
    local isSelect = selectTemplateId == self.template.id
    self:SetDiffSelect(isSelect)
  end
end

local function OnUpdateZombieRushSelectDate(self, selectDate)
  if self.date then
    local isSelect = selectDate.day == self.date.day
    self:SetDiffSelect(isSelect)
  end
end

local function OnUpdateZombieRushSelectHour(self, selectHour)
  if self.hour then
    local isSelect = selectHour == self.hour
    self:SetDiffSelect(isSelect)
  end
end

local function SetDiffData(self, template, isSelect)
  self.template = template
  self.normalLevelText:SetText("Lv." .. self.template.difficulty)
  self.selectLevelText:SetText("Lv." .. self.template.difficulty)
  self:SetDiffSelect(isSelect)
end

local function SetDateData(self, date, isSelect)
  self.date = date
  local showTimeStr = string.format("%d/%d/%02d", self.date.year, self.date.month, self.date.day)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local curDate = UITimeManager:GetInstance():TimeStampToServerDate(curTime)
  if curDate.day == self.date.day then
    self.normalLevelText:SetLocalText("zombierush_plan_today", showTimeStr)
    self.selectLevelText:SetLocalText("zombierush_plan_today", showTimeStr)
  else
    self.normalLevelText:SetText(showTimeStr)
    self.selectLevelText:SetText(showTimeStr)
  end
  self:SetDiffSelect(isSelect)
end

local function SetHourData(self, hour, isSelect)
  self.hour = hour
  self.normalLevelText:SetText(self.hour .. ":00")
  self.selectLevelText:SetText(self.hour .. ":00")
  self:SetDiffSelect(isSelect)
end

local function SetDiffSelect(self, isSelect)
  if isSelect then
    self.selectLevelText:SetActive(true)
    self.normalLevelText:SetActive(false)
  else
    self.selectLevelText:SetActive(false)
    self.normalLevelText:SetActive(true)
  end
end

UIAllianceStarOrderTimeItemComponent.OnCreate = OnCreate
UIAllianceStarOrderTimeItemComponent.OnDestroy = OnDestroy
UIAllianceStarOrderTimeItemComponent.OnEnable = OnEnable
UIAllianceStarOrderTimeItemComponent.OnDisable = OnDisable
UIAllianceStarOrderTimeItemComponent.ComponentDefine = ComponentDefine
UIAllianceStarOrderTimeItemComponent.ComponentDestroy = ComponentDestroy
UIAllianceStarOrderTimeItemComponent.DataDefine = DataDefine
UIAllianceStarOrderTimeItemComponent.DataDestroy = DataDestroy
UIAllianceStarOrderTimeItemComponent.OnAddListener = OnAddListener
UIAllianceStarOrderTimeItemComponent.OnRemoveListener = OnRemoveListener
UIAllianceStarOrderTimeItemComponent.OnUpdateZombieRushSelectDifficulty = OnUpdateZombieRushSelectDifficulty
UIAllianceStarOrderTimeItemComponent.SetDiffData = SetDiffData
UIAllianceStarOrderTimeItemComponent.SetDiffSelect = SetDiffSelect
UIAllianceStarOrderTimeItemComponent.OnUpdateZombieRushSelectDate = OnUpdateZombieRushSelectDate
UIAllianceStarOrderTimeItemComponent.SetDateData = SetDateData
UIAllianceStarOrderTimeItemComponent.SetHourData = SetHourData
UIAllianceStarOrderTimeItemComponent.OnUpdateZombieRushSelectHour = OnUpdateZombieRushSelectHour
return UIAllianceStarOrderTimeItemComponent
