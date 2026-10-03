local UIActSlotMachineSelectCardItemRewardPreview = BaseClass("UIActSlotMachineSelectCardItemRewardPreview", UIBaseContainer)
local M = UIActSlotMachineSelectCardItemRewardPreview
local base = UIBaseContainer
local CardQualityType = ActSlotMachineSelectCardQualityType

function M:OnCreate()
  base.OnCreate(self)
  self.rewardData = nil
  self:ComponentDefine()
end

function M:OnDestroy()
  self:ComponentDestroy()
  self.rewardData = nil
  base.OnDestroy(self)
end

function M:OnEnable()
  base.OnEnable(self)
end

function M:OnDisable()
  base.OnDisable(self)
end

function M:ComponentDefine()
  self.item = self:AddComponent(UICommonResItem, "UICommonResItem")
  self.compMulit = self:AddComponent(UIBaseContainer, "mulit")
  self.compEffect = self:AddComponent(UIBaseContainer, "Eff_ui_item_gold_saoguang")
end

function M:ComponentDestroy()
  self.item = nil
  self.compMulit = nil
  self.compEffect = nil
end

function M:SetData(rewardPreviewData)
  self.rewardData = rewardPreviewData
  local rewardData = {
    rewardType = rewardPreviewData.rewardType,
    itemId = rewardPreviewData.itemId,
    count = rewardPreviewData.count
  }
  self.item:ReInit(rewardData)
  self.compMulit:SetActive(self.rewardData.multiple ~= 1)
end

function M:CheckShowOrangeBling(isLastestReward)
  self.compEffect:SetActive(isLastestReward and self.rewardData.qualityType == CardQualityType.OrangeType)
end

return M
