local UIGiftPackContentItem = BaseClass("UIGiftPackContentItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.resItem = self:AddComponent(UICommonResItem, "UICommonResItem")
  self.itemNameText = self:AddComponent(UIText, "ItemNameText")
end

local function ComponentDestroy(self)
  self.resItem = nil
  self.itemNameText = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function SetData(self, itemData)
  if not itemData then
    self:SetActive(false)
    return
  end
  self:SetActive(true)
  self.resItem:ReInit(itemData)
  local itemNameStr = DataCenter.RewardManager:GetNameByType(itemData.rewardType, itemData.itemId)
  local count = itemData.count
  local str = string.format("%s x %s", itemNameStr, count)
  self.itemNameText:SetText(str)
end

UIGiftPackContentItem.OnCreate = OnCreate
UIGiftPackContentItem.OnDestroy = OnDestroy
UIGiftPackContentItem.ComponentDefine = ComponentDefine
UIGiftPackContentItem.ComponentDestroy = ComponentDestroy
UIGiftPackContentItem.DataDefine = DataDefine
UIGiftPackContentItem.DataDestroy = DataDestroy
UIGiftPackContentItem.SetData = SetData
return UIGiftPackContentItem
