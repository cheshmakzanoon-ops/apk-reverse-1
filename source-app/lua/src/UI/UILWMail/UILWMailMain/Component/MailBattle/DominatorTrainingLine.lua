local DominatorTrainingLine = BaseClass("DominatorTrainingLine", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
end

local function OnDestroy(self)
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
  self.name_txt = self:AddComponent(UIText, "groupName_txt")
  self.leftValue_txt = self:AddComponent(UIText, "leftValue_txt")
  self.rightValue_txt = self:AddComponent(UIText, "rightValue_txt")
end

local function ComponentDestroy(self)
  self.name_txt = nil
  self.leftValue_txt = nil
  self.rightValue_txt = nil
end

local function SetData(self, groupId, leftValue, rightValue)
  local groupTemplate = DataCenter.DominatorTemplateManager:GetTrainGroupTemplateById(groupId)
  local name = groupTemplate:GetName()
  self.name_txt:SetText(name)
  if leftValue ~= nil then
    local lvTemplate = DataCenter.DominatorTemplateManager:GetTrainLevelTemplateById(groupId + leftValue)
    self.leftValue_txt:SetText(string.format("Lv.%d", leftValue))
  else
    self.leftValue_txt:SetText("-")
  end
  if rightValue ~= nil then
    local lvTemplate = DataCenter.DominatorTemplateManager:GetTrainLevelTemplateById(groupId + rightValue)
    self.rightValue_txt:SetText(string.format("Lv.%d", rightValue))
  else
    self.rightValue_txt:SetText("-")
  end
end

DominatorTrainingLine.OnCreate = OnCreate
DominatorTrainingLine.OnDestroy = OnDestroy
DominatorTrainingLine.OnEnable = OnEnable
DominatorTrainingLine.OnDisable = OnDisable
DominatorTrainingLine.ComponentDefine = ComponentDefine
DominatorTrainingLine.ComponentDestroy = ComponentDestroy
DominatorTrainingLine.SetData = SetData
return DominatorTrainingLine
