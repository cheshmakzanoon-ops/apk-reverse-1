local UIRewardTipItem = BaseClass("UIRewardTipItem", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization

function UIRewardTipItem:OnCreate()
  base.OnCreate(self)
  self.resItem = self:AddComponent(UICommonResItem, "UICommonResItem")
  self.itemNameText = self:AddComponent(UIText, "ItemNameText")
  self.ItemValueText = self:AddComponent(UIText, "ItemValueText")
end

function UIRewardTipItem:OnDestroy()
  self.resItem = nil
  self.itemNameText = nil
  self.ItemValueText = nil
  base.OnDestroy(self)
end

function UIRewardTipItem:ReInit(itemData)
  if not itemData then
    self:SetActive(false)
    return
  end
  self:SetActive(true)
  local rewardData = self.resItem:ParseInfo(itemData)
  local itemNameStr = DataCenter.RewardManager:GetNameByType(rewardData.rewardType, rewardData.itemId)
  local count = rewardData.count
  self.itemNameText:SetText(itemNameStr)
  if type(count) == "number" then
    self.ItemValueText:SetText(string.GetFormattedSeparatorNum(count))
  else
    self.ItemValueText:SetText(count)
  end
end

return UIRewardTipItem
