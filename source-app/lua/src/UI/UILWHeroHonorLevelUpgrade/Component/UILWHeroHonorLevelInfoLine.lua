local UILWHeroHonorLevelEffectLine = BaseClass("UILWHeroHonorLevelEffectLine", UIBaseContainer)
local base = UIBaseContainer

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

local function ComponentDefine(self)
  self.nameText = self:AddComponent(UIText, "NameText")
  self.valueText = self:AddComponent(UIText, "ValueText")
  self.upgradeImage = self:AddComponent(UIImage, "HpUpgradeIcon")
end

local function ComponentDestroy(self)
  self.nameText = nil
  self.valueText = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ReInit(self, data)
  if data then
    self.nameText:SetText(data.title or "")
    self.valueText:SetText(data.value or "")
    self.upgradeImage:SetActive(data.showUpgradeIcon or false)
  end
end

local function SetUpgradeIconActive(isActive)
  self.upgradeImage:SetActive(isActive)
end

UILWHeroHonorLevelEffectLine.OnCreate = OnCreate
UILWHeroHonorLevelEffectLine.OnDestroy = OnDestroy
UILWHeroHonorLevelEffectLine.OnEnable = OnEnable
UILWHeroHonorLevelEffectLine.OnDisable = OnDisable
UILWHeroHonorLevelEffectLine.ComponentDefine = ComponentDefine
UILWHeroHonorLevelEffectLine.ComponentDestroy = ComponentDestroy
UILWHeroHonorLevelEffectLine.DataDefine = DataDefine
UILWHeroHonorLevelEffectLine.DataDestroy = DataDestroy
UILWHeroHonorLevelEffectLine.ReInit = ReInit
UILWHeroHonorLevelEffectLine.SetUpgradeIconActive = SetUpgradeIconActive
return UILWHeroHonorLevelEffectLine
