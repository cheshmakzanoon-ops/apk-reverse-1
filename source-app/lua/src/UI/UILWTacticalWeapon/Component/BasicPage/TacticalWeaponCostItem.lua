local TacticalWeaponCostItem = BaseClass("TacticalWeaponCostItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local ResourceManager = CS.GameEntry.Resource

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
  self.itemIcon = self:AddComponent(UIImage, "ItemIcon")
  self.countText = self:AddComponent(UIText, "ItemCountText")
end

local function DataDefine(self)
end

local function ComponentDestroy(self)
  self.itemIcon = nil
  self.countText = nil
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

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function SetValue(self, itemId, need)
  if not itemId then
    self:SetActive(false)
    return
  end
  self:SetActive(true)
  local iconPath = DataCenter.RewardManager:GetPicByType(RewardType.RESOURCE_ITEM, itemId)
  self.itemIcon:LoadSprite(iconPath)
  local count = DataCenter.ResourceItemDataManager:GetCountByItemId(itemId)
  if need <= count then
    self.countText:SetText("<color=#5FEF87>" .. string.GetFormattedStr2(count) .. "</color>/" .. string.GetFormattedStr2(need))
  else
    self.countText:SetText("<color=#F97077>" .. string.GetFormattedStr2(count) .. "</color>/" .. string.GetFormattedStr2(need))
  end
end

TacticalWeaponCostItem.OnCreate = OnCreate
TacticalWeaponCostItem.OnDestroy = OnDestroy
TacticalWeaponCostItem.OnEnable = OnEnable
TacticalWeaponCostItem.OnDisable = OnDisable
TacticalWeaponCostItem.OnAddListener = OnAddListener
TacticalWeaponCostItem.OnRemoveListener = OnRemoveListener
TacticalWeaponCostItem.ComponentDefine = ComponentDefine
TacticalWeaponCostItem.DataDefine = DataDefine
TacticalWeaponCostItem.ComponentDestroy = ComponentDestroy
TacticalWeaponCostItem.DataDestroy = DataDestroy
TacticalWeaponCostItem.SetValue = SetValue
return TacticalWeaponCostItem
