local base = UIBaseContainer
local GoldTreeRuleCardItem = BaseClass("GoldTreeRuleCardItem", base)
local name_path = "name"
local icon_path = "icon"

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
  self.name = self:AddComponent(UIText, name_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.bg = self:AddComponent(UIImage, "")
end

local function ComponentDestroy(self)
  self.name = nil
  self.icon = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function GoldTreeRuleCardItem:ReInit(cardConfig, index, max)
  if not cardConfig then
    return
  end
  self.name:SetLocalText(cardConfig.name)
  self.icon:LoadSprite(cardConfig.icon)
  self.icon:SetNativeSize()
  local bgPath = "GoldTree/zxl_s4_qiuqian_d2"
  if index == 1 then
    bgPath = "GoldTree/zxl_s4_qiuqian_d1"
  elseif max <= index then
    bgPath = "GoldTree/zxl_s4_qiuqian_d3"
  end
  self.bg:LoadSprite(string.format(LoadPath.UISeason4Path, bgPath))
  self.bg:SetNativeSize()
end

GoldTreeRuleCardItem.OnCreate = OnCreate
GoldTreeRuleCardItem.OnDestroy = OnDestroy
GoldTreeRuleCardItem.OnEnable = OnEnable
GoldTreeRuleCardItem.OnDisable = OnDisable
GoldTreeRuleCardItem.ComponentDefine = ComponentDefine
GoldTreeRuleCardItem.ComponentDestroy = ComponentDestroy
GoldTreeRuleCardItem.DataDefine = DataDefine
GoldTreeRuleCardItem.DataDestroy = DataDestroy
return GoldTreeRuleCardItem
