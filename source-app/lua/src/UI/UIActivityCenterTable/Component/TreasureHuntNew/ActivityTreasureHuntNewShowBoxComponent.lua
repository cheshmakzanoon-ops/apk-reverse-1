local ActivityTreasureHuntNewShowBoxComponent = BaseClass("ActivityTreasureHuntNewShowBoxComponent", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function ActivityTreasureHuntNewShowBoxComponent:OnCreate()
  base.OnCreate(self)
  self._needNum_txt = self:AddComponent(UIText, "Txt_NeedNum")
  self._box_claim_btn = self:AddComponent(UIButton, "ClaimBtn")
  self._box_claim_btn:SetOnClick(function()
    self:OnClickClaim()
  end)
  self.item = self:AddComponent(UICommonResItem, "UICommonResItem")
  self.frameIcon = self:AddComponent(UIImage, "FrameIcon")
  self.lineIcon = self:AddComponent(UIImage, "LineIcon")
  self.needNumShadow = self:AddComponent(UIShadow, "Txt_NeedNum")
  self.needNumOutline = self:AddComponent(UIOutline, "Txt_NeedNum")
  self.finishContent = self:AddComponent(UIBaseContainer, "finishContent")
  self.effectContent = self:AddComponent(UIBaseContainer, "effectContent")
  self.effectContentCanClaim = self:AddComponent(UIBaseContainer, "effectContentCanClaim")
end

function ActivityTreasureHuntNewShowBoxComponent:OnDestroy()
  base.OnDestroy(self)
end

function ActivityTreasureHuntNewShowBoxComponent:SetData(itemData, digInfo)
  self.itemData = itemData
  self.digInfo = digInfo
  local rewardType = RewardType.GOODS
  local itemId = itemData.big_reward_Preview
  local itemNum = itemData.count
  local rewardData = {
    rewardType = rewardType,
    itemId = itemId,
    count = itemNum
  }
  self.item:ReInit(rewardData)
  local curLevel = self.digInfo.finishedLv + 1
  local itemLevel = itemData.level
  self._needNum_txt:SetText(itemLevel)
  self.effectContent:SetActive(itemData.highlight_reward)
  local state = DataCenter.ActivityTreasureHuntNewManager:GetBigRewardClaimStateByLevel(self.digInfo.activityId, itemLevel)
  self.effectContentCanClaim:SetActive(state == 1)
  self.finishContent:SetActive(state == 2)
  self._box_claim_btn:SetActive(state == 1)
end

function ActivityTreasureHuntNewShowBoxComponent:OnClickClaim()
  if self.digInfo ~= nil and self.itemData ~= nil then
    local state = DataCenter.ActivityTreasureHuntNewManager:GetBigRewardClaimStateByLevel(self.digInfo.activityId, self.itemData.level)
    if state == 1 then
      DataCenter.ActivityTreasureHuntNewManager:RequestClaimBigReward(self.digInfo.activityId)
    end
  end
end

return ActivityTreasureHuntNewShowBoxComponent
