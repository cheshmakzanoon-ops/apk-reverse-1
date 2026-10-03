local UIRewardContentItem = BaseClass("UIRewardContentItem", UIBaseContainer)
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
  self.itemCountText = self:AddComponent(UIText, "ItemCountText")
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
  self.resItem:SetItemCountActive(false)
  local itemNameStr = DataCenter.RewardManager:GetNameByType(itemData.rewardType, itemData.itemId)
  local count = itemData.count
  self.itemNameText:SetText(itemNameStr)
  if count then
    self.itemCountText:SetText(string.GetFormattedStr(count))
  else
    self.itemCountText:SetText("")
  end
end

UIRewardContentItem.OnCreate = OnCreate
UIRewardContentItem.OnDestroy = OnDestroy
UIRewardContentItem.ComponentDefine = ComponentDefine
UIRewardContentItem.ComponentDestroy = ComponentDestroy
UIRewardContentItem.DataDefine = DataDefine
UIRewardContentItem.DataDestroy = DataDestroy
UIRewardContentItem.SetData = SetData
return UIRewardContentItem
