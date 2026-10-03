local UIPersonalArmsRewardTipItem = BaseClass("UIPersonalArmsRewardTipItem", UIBaseContainer)
local base = UIBaseContainer

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.resItem = self:AddComponent(UICommonResItem, "UICommonResItem")
  self.itemNameText = self:AddComponent(UIText, "ItemNameText")
  self.ItemValueText = self:AddComponent(UIText, "ItemValueText")
end

local function ComponentDestroy(self)
  self.resItem = nil
  self.itemNameText = nil
  self.ItemValueText = nil
end

local function SetData(self, itemData, showCount, rewardMultiVal, hideResIconCount)
  if not itemData then
    self:SetActive(false)
    return
  end
  self:SetActive(true)
  local rewardData = self.resItem:ParseInfo(itemData)
  local itemNameStr = DataCenter.RewardManager:GetNameByType(rewardData.rewardType, rewardData.itemId)
  local count = toInt(rewardData.count)
  if rewardData.rewardType == RewardType.RESOURCE and not hideResIconCount then
    count = 1
  end
  count = count * (rewardMultiVal or 1)
  self.itemNameText:SetText(itemNameStr)
  if showCount then
    self.ItemValueText:SetText(count)
  else
    self.ItemValueText:SetText(nil)
  end
  if hideResIconCount then
    self.resItem:SetItemCountActive(false)
  else
    self.resItem:SetItemCountActive(true)
  end
  local curMultiRewardVal = rewardMultiVal or 1
  self.resItem:ShowMultiMark(curMultiRewardVal)
end

UIPersonalArmsRewardTipItem.OnCreate = OnCreate
UIPersonalArmsRewardTipItem.OnDestroy = OnDestroy
UIPersonalArmsRewardTipItem.ComponentDefine = ComponentDefine
UIPersonalArmsRewardTipItem.ComponentDestroy = ComponentDestroy
UIPersonalArmsRewardTipItem.DataDefine = DataDefine
UIPersonalArmsRewardTipItem.DataDestroy = DataDestroy
UIPersonalArmsRewardTipItem.SetData = SetData
return UIPersonalArmsRewardTipItem
