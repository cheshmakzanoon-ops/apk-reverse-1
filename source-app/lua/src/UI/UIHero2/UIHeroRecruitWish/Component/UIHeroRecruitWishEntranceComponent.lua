local base = UIBaseContainer
local UIHeroRecruitWishEntranceComponent = BaseClass("UIHeroRecruitWishEntranceComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UIHeroRecruitWishEntranceComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIHeroRecruitWishEntranceComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIHeroRecruitWishEntranceComponent:ComponentDefine()
  self.btnWishClaim = self:AddComponent(UIButton, "WishBtn/NotEmpty/WishClaimBtn")
  self.btnWishClaim:SetOnClick(function()
    self:OnBtnWishClaimClick()
  end)
  self.btnWishClaim:SetSafeClickMode(true)
  self.textWIshCurProgress = self:AddComponent(UIText, "WishProgressLayout/WIshCurProgressText")
  self.textWIshTotalProgress = self:AddComponent(UIText, "WishProgressLayout/WIshTotalProgressText")
  self.sliderWish = self:AddComponent(UISlider, "WishSlider")
  self.compEmpty = self:AddComponent(UIBaseContainer, "WishBtn/Empty")
  self.btnEmpty = self:AddComponent(UIButton, "WishBtn/Empty")
  self.btnEmpty:SetOnClick(function()
    self:OnBtnNotEmptyClick()
  end)
  self.compNotEmpty = self:AddComponent(UIBaseContainer, "WishBtn/NotEmpty")
  self.compUICommonResItem = self:AddComponent(UICommonResItem, "WishBtn/NotEmpty/UICommonResItem")
  self.btnNotEmpty = self:AddComponent(UIButton, "WishBtn/NotEmpty/NotEmptyBtn")
  self.btnNotEmpty:SetOnClick(function()
    self:OnBtnNotEmptyClick()
  end)
  self.compWishRed = self:AddComponent(UIBaseContainer, "WishBtn/WishRed")
  self.textWishText = self:AddComponent(UIText, "WishTipsText")
end

function UIHeroRecruitWishEntranceComponent:ComponentDestroy()
  self.textWIshCurProgress = nil
  self.textWIshTotalProgress = nil
  self.sliderWish = nil
  self.btnWishClaim = nil
  self.compEmpty = nil
  self.compNotEmpty = nil
  self.btnNotEmpty = nil
  self.compWishRed = nil
  self.compUICommonResItem = nil
  self.textWishText = nil
  self.btnEmpty = nil
end

function UIHeroRecruitWishEntranceComponent:DataDefine()
end

function UIHeroRecruitWishEntranceComponent:DataDestroy()
end

function UIHeroRecruitWishEntranceComponent:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.HeroLotterySwitchWishSuccess, self.OnSwitchWish)
  self:AddUIListener(EventId.HeroLotteryClaimWishSuccess, self.OnClaimWish)
end

function UIHeroRecruitWishEntranceComponent:OnRemoveListener()
  self:RemoveUIListener(EventId.HeroLotterySwitchWishSuccess, self.OnSwitchWish)
  self:RemoveUIListener(EventId.HeroLotteryClaimWishSuccess, self.OnClaimWish)
  base.OnRemoveListener(self)
end

function UIHeroRecruitWishEntranceComponent:ReInit(lotteryId)
  self.lotteryId = lotteryId
  if self.lotteryId == nil then
    return
  end
  self.lotteryData = DataCenter.LotteryDataManager:GetLotteryDataById(self.lotteryId)
  if self.lotteryData == nil then
    return
  end
  self.textWIshCurProgress:SetText(tostring(self.lotteryData.wishPityCurNum))
  self.textWIshTotalProgress:SetText("/" .. tostring(self.lotteryData.wishPityReceiveNum))
  local percent = self.lotteryData.wishPityCurNum / self.lotteryData.wishPityReceiveNum
  percent = math.max(0, math.min(percent, 1))
  self.sliderWish:SetValue(percent)
  self.textWishText:SetLocalText("herorecruit_desc1", tostring(self.lotteryData.wishPityReceiveNum))
  local curSelectHeroId = self.lotteryData:GetCurSelectWishHeroId()
  self.compEmpty:SetActive(curSelectHeroId == nil)
  self.compNotEmpty:SetActive(curSelectHeroId ~= nil)
  if curSelectHeroId ~= nil then
    local heroTemplate = DataCenter.HeroTemplateManager:GetTemplate(curSelectHeroId)
    if heroTemplate then
      local iconPath = HeroUtils.GetHeroIconPath(heroTemplate.appearance, HeroIconType.small_icon)
      if not string.IsNullOrEmpty(iconPath) then
        self.compUICommonResItem:ReInit({
          rewardType = RewardType.HERO,
          itemId = curSelectHeroId,
          count = 1
        })
      end
    end
  end
  self.compWishRed:SetActive(self.lotteryData:IsCanClaimWish())
  self.btnWishClaim:SetActive(self.lotteryData:IsCanClaimWish())
  DataCenter.LotteryDataManager:SetHasShownWish()
  EventManager:GetInstance():Broadcast(EventId.HeroLotteryBubbleUpdate)
end

function UIHeroRecruitWishEntranceComponent:OnSwitchWish()
  self:ReInit(self.lotteryId)
end

function UIHeroRecruitWishEntranceComponent:OnClaimWish()
  self:ReInit(self.lotteryId)
end

function UIHeroRecruitWishEntranceComponent:OnBtnWishClaimClick()
  if not self.lotteryData or not self.lotteryId then
    return
  end
  local curSelectHeroId = self.lotteryData:GetCurSelectWishHeroId()
  if curSelectHeroId ~= nil and self.lotteryData:IsCanClaimWish() then
    DataCenter.LotteryDataManager:SendClaimWishHeroMessage(self.lotteryId)
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroRecruitWish, {anim = false}, self.lotteryId)
end

function UIHeroRecruitWishEntranceComponent:OnBtnNotEmptyClick()
  if self.lotteryId then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroRecruitWish, {anim = false}, self.lotteryId)
  end
end

return UIHeroRecruitWishEntranceComponent
