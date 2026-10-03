local WeaponCostGroup = BaseClass("WeaponCostGroup", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local Resource = CS.GameEntry.Resource
local UIGray = CS.UIGray

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self.active = true
end

local function OnDisable(self)
  base.OnDisable(self)
  self.active = false
end

local function ComponentDefine(self)
  self.icon = self:AddComponent(UIImage, "icon")
  self.costText = self:AddComponent(UIText, "costText")
end

local function ComponentDestroy(self)
  self.icon = nil
  self.costText = nil
end

local function RefreshCost(self)
  if not self.itemId or not self.cost then
    self.costText:SetText("")
    return
  end
  local have = DataCenter.ItemData:GetItemCount(self.itemId)
  local colorStr = ""
  if self.whiteColor then
    colorStr = "<color=#FFFFFF>"
  elseif have < self.cost then
    colorStr = "<color=#F97077>"
  else
    colorStr = "<color=#5FEF87>"
  end
  self.costText:SetText(string.format("%s%d</color>/%d", colorStr, have, self.cost))
end

local function SetData(self, itemId, cost, whiteColor)
  self.itemId = itemId
  self.cost = cost
  self.icon:LoadSprite(DataCenter.RewardManager:GetPicByType(RewardType.GOODS, self.itemId))
  self.whiteColor = whiteColor
  RefreshCost(self)
end

WeaponCostGroup.OnCreate = OnCreate
WeaponCostGroup.OnDestroy = OnDestroy
WeaponCostGroup.OnEnable = OnEnable
WeaponCostGroup.OnDisable = OnDisable
WeaponCostGroup.DataDefine = DataDefine
WeaponCostGroup.DataDestroy = DataDestroy
WeaponCostGroup.ComponentDefine = ComponentDefine
WeaponCostGroup.ComponentDestroy = ComponentDestroy
WeaponCostGroup.SetData = SetData
return WeaponCostGroup
