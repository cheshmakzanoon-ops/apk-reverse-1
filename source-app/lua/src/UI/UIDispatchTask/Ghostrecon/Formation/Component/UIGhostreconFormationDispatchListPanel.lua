local base = UIBaseContainer
local UIGhostreconFormationDispatchListPanel = BaseClass("UIGhostreconFormationDispatchListPanel", base)
local UIGhostreconFormationDispatchHeroItem = require("UI.UIDispatchTask.Ghostrecon.Formation.Component.UIGhostreconFormationDispatchHeroItem")
local titleText_path = "TitleText"
local heroItem1_path = "Conditions/Bg/DispatchHeroItem1"
local heroItem2_path = "Conditions/Bg/DispatchHeroItem2"
local heroItem3_path = "Conditions/Bg/DispatchHeroItem3"

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
  self.titleText = self:AddComponent(UIText, titleText_path)
  self.heroItem1 = self:AddComponent(UIGhostreconFormationDispatchHeroItem, heroItem1_path)
  self.heroItem2 = self:AddComponent(UIGhostreconFormationDispatchHeroItem, heroItem2_path)
  self.heroItem3 = self:AddComponent(UIGhostreconFormationDispatchHeroItem, heroItem3_path)
  self.titleText:SetLocalText("ghostrecon_028")
end

local function ComponentDestroy(self)
  self.titleText = nil
  self.heroItem1 = nil
  self.heroItem2 = nil
  self.heroItem3 = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function SetAllEmpty(self)
  for i = 1, 3 do
    self["heroItem" .. i]:SetEmpty()
  end
end

local function SetItemEmpty(self, index)
  self["heroItem" .. index]:SetEmpty()
end

local function SetItemData(self, index, heroId, clickFunc)
  self["heroItem" .. index]:SetData(heroId, clickFunc)
end

UIGhostreconFormationDispatchListPanel.OnCreate = OnCreate
UIGhostreconFormationDispatchListPanel.OnDestroy = OnDestroy
UIGhostreconFormationDispatchListPanel.OnEnable = OnEnable
UIGhostreconFormationDispatchListPanel.OnDisable = OnDisable
UIGhostreconFormationDispatchListPanel.ComponentDefine = ComponentDefine
UIGhostreconFormationDispatchListPanel.ComponentDestroy = ComponentDestroy
UIGhostreconFormationDispatchListPanel.DataDefine = DataDefine
UIGhostreconFormationDispatchListPanel.DataDestroy = DataDestroy
UIGhostreconFormationDispatchListPanel.SetAllEmpty = SetAllEmpty
UIGhostreconFormationDispatchListPanel.SetItemEmpty = SetItemEmpty
UIGhostreconFormationDispatchListPanel.SetItemData = SetItemData
return UIGhostreconFormationDispatchListPanel
