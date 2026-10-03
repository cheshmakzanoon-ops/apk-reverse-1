local TreasurehuntShowBox = BaseClass("TreasurehuntShowBox", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function TreasurehuntShowBox:OnCreate()
  base.OnCreate(self)
  self._needNum_txt = self:AddComponent(UIText, "Txt_NeedNum")
  self._box_btn = self:AddComponent(UIButton, "")
  self._box_btn:SetOnClick(function()
    self:OnClickReward()
  end)
  self.item = self:AddComponent(UICommonResItem, "UICommonResItem")
  self.frameIcon = self:AddComponent(UIImage, "FrameIcon")
  self.lineIcon = self:AddComponent(UIImage, "LineIcon")
  self.needNumShadow = self:AddComponent(UIShadow, "Txt_NeedNum")
  self.needNumOutline = self:AddComponent(UIOutline, "Txt_NeedNum")
  self.finishContent = self:AddComponent(UIBaseContainer, "finishContent")
  self.effectContent = self:AddComponent(UIBaseContainer, "effectContent")
end

function TreasurehuntShowBox:OnDestroy()
  base.OnDestroy(self)
end

function TreasurehuntShowBox:SetData(itemData, digInfo)
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
  self.effectContent:SetActive(itemData.highlight_reward > 0)
  if curLevel < itemLevel then
    self.frameIcon:SetActive(false)
    self.finishContent:SetActive(false)
  elseif curLevel == itemLevel then
    self.frameIcon:SetActive(true)
    self.finishContent:SetActive(false)
  elseif curLevel > itemLevel then
    self.frameIcon:SetActive(false)
    self.finishContent:SetActive(true)
  end
end

function TreasurehuntShowBox:OnClickReward()
end

return TreasurehuntShowBox
