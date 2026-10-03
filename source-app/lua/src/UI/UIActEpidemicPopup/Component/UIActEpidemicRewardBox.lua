local UIActEpidemicRewardBox = BaseClass("UIActEpidemicRewardBox", UIBaseContainer)
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
  self.compBoxClose = self:AddComponent(UIBaseContainer, "BoxClose")
  self.compBoxOpen = self:AddComponent(UIBaseContainer, "BoxOpen")
  self.textTmpVal = self:AddComponent(UITextMeshProUGUIEx, "PointBg/tmpVal")
end

local function ComponentDestroy(self)
  self.compBoxClose = nil
  self.compBoxOpen = nil
  self.textTmpVal = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

UIActEpidemicRewardBox.OnCreate = OnCreate
UIActEpidemicRewardBox.OnDestroy = OnDestroy
UIActEpidemicRewardBox.OnEnable = OnEnable
UIActEpidemicRewardBox.OnDisable = OnDisable
UIActEpidemicRewardBox.ComponentDefine = ComponentDefine
UIActEpidemicRewardBox.ComponentDestroy = ComponentDestroy
UIActEpidemicRewardBox.DataDefine = DataDefine
UIActEpidemicRewardBox.DataDestroy = DataDestroy
UIActEpidemicRewardBox.OnAddListener = OnAddListener
UIActEpidemicRewardBox.OnRemoveListener = OnRemoveListener
return UIActEpidemicRewardBox
