local base = UIBaseContainer
local LWUIZombieRushDifficultyItemRender = BaseClass("LWUIZombieRushDifficultyItemRender", base)
local normalLockMark_path = "HorLayout/NormalLockMark"
local normalLevelText_path = "HorLayout/NormalLevelText"
local selectLockMark_path = "HorLayout/SelectLockMark"
local selectLevelText_path = "HorLayout/SelectLevelText"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.normalLockMark = self:AddComponent(UIBaseContainer, normalLockMark_path)
  self.normalLevelText = self:AddComponent(UITextMeshProUGUIEx, normalLevelText_path)
  self.selectLockMark = self:AddComponent(UIBaseContainer, selectLockMark_path)
  self.selectLevelText = self:AddComponent(UITextMeshProUGUIEx, selectLevelText_path)
end

local function ComponentDestroy(self)
  self.normalLockMark = nil
  self.normalLevelText = nil
  self.selectLockMark = nil
  self.selectLevelText = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.UpdateZombieRushSelectDifficulty, self.OnUpdateZombieRushSelectDifficulty)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.UpdateZombieRushSelectDifficulty, self.OnUpdateZombieRushSelectDifficulty)
  base.OnRemoveListener(self)
end

local function OnUpdateZombieRushSelectDifficulty(self, selectTemplateId)
  local isSelect = selectTemplateId == self.template.id
  self:SetSelect(isSelect)
end

local function SetData(self, template, isSelect)
  self.template = template
  self.normalLevelText:SetText("Lv." .. self.template.difficulty)
  self.selectLevelText:SetText("Lv." .. self.template.difficulty)
  self:SetSelect(isSelect)
end

local function SetSelect(self, isSelect)
  local unlock = self.template.id <= DataCenter.LWZombieRushManager.maxDifficultyId
  if isSelect then
    self.selectLevelText:SetActive(true)
    self.selectLockMark:SetActive(not unlock)
    self.normalLevelText:SetActive(false)
    self.normalLockMark:SetActive(false)
  else
    self.selectLevelText:SetActive(false)
    self.selectLockMark:SetActive(false)
    self.normalLevelText:SetActive(true)
    self.normalLockMark:SetActive(not unlock)
  end
end

LWUIZombieRushDifficultyItemRender.OnCreate = OnCreate
LWUIZombieRushDifficultyItemRender.OnDestroy = OnDestroy
LWUIZombieRushDifficultyItemRender.OnEnable = OnEnable
LWUIZombieRushDifficultyItemRender.OnDisable = OnDisable
LWUIZombieRushDifficultyItemRender.ComponentDefine = ComponentDefine
LWUIZombieRushDifficultyItemRender.ComponentDestroy = ComponentDestroy
LWUIZombieRushDifficultyItemRender.DataDefine = DataDefine
LWUIZombieRushDifficultyItemRender.DataDestroy = DataDestroy
LWUIZombieRushDifficultyItemRender.SetData = SetData
LWUIZombieRushDifficultyItemRender.SetSelect = SetSelect
LWUIZombieRushDifficultyItemRender.OnAddListener = OnAddListener
LWUIZombieRushDifficultyItemRender.OnRemoveListener = OnRemoveListener
LWUIZombieRushDifficultyItemRender.OnUpdateZombieRushSelectDifficulty = OnUpdateZombieRushSelectDifficulty
return LWUIZombieRushDifficultyItemRender
