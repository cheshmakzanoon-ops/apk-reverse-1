local UIStageFeatureRewardTipItem = BaseClass("UIStageFeatureRewardTipItem", UIBaseContainer)
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

local function SetData(self, itemData, showCount, rewardMultiVal)
  if not itemData then
    self:SetActive(false)
    return
  end
  self:SetActive(true)
  local rewardData = self.resItem:ParseInfo(itemData)
  local itemNameStr = DataCenter.RewardManager:GetNameByType(rewardData.rewardType, rewardData.itemId)
  local count = toInt(rewardData.count)
  if rewardData.rewardType == RewardType.RESOURCE then
    count = 1
  end
  count = count * (rewardMultiVal or 1)
  self.itemNameText:SetText(itemNameStr)
  if showCount then
    self.ItemValueText:SetText(count)
  else
    self.ItemValueText:SetText(nil)
  end
end

UIStageFeatureRewardTipItem.OnCreate = OnCreate
UIStageFeatureRewardTipItem.OnDestroy = OnDestroy
UIStageFeatureRewardTipItem.ComponentDefine = ComponentDefine
UIStageFeatureRewardTipItem.ComponentDestroy = ComponentDestroy
UIStageFeatureRewardTipItem.SetData = SetData
return UIStageFeatureRewardTipItem
