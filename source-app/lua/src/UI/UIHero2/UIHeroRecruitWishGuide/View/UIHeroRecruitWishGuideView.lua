local UIHeroRecruitWishGuideView = BaseClass("UIHeroRecruitWishGuideView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local MyModf = math.modf
local MyFloor = math.floor
local MyStrFormat = string.format
local MyDate = os.date

function UIHeroRecruitWishGuideView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:OnOpen()
end

function UIHeroRecruitWishGuideView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIHeroRecruitWishGuideView:ComponentDefine()
  self.anim = self:AddComponent(UIAnimator, "")
  self.btnPanel = self:AddComponent(UIButton, "Panel")
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.textTitle = self:AddComponent(UIText, "MainContent/TitleText")
  self.textTitle:SetText(Localization:GetString("herorecruit_preview_title3"))
  self.btnClose = self:AddComponent(UIButton, "MainContent/CloseBtn")
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.compUICommonResItem = self:AddComponent(UICommonResItem, "MainContent/UICommonResItem")
  self.compUICommonResItem.gameObject:GameObjectCreatePool()
  self.compUICommonResItem:SetActive(false)
  self.textNewWish = self:AddComponent(UIText, "MainContent/ScrollView/Viewport/Content/NewWishText")
  self.compContent = self:AddComponent(UIBaseContainer, "MainContent/ScrollView/Viewport/Content")
  self.imgNewWishIcon = self:AddComponent(UIImage, "MainContent/ScrollView/Viewport/Content/NewWishIcon")
  self.textDesText1 = self:AddComponent(UIText, "MainContent/ScrollView/Viewport/Content/DesText1")
  self.imgDesImage1 = self:AddComponent(UIImage, "MainContent/ScrollView/Viewport/Content/DesImageRoot/DesImage1")
  self.imgDesImage2 = self:AddComponent(UIImage, "MainContent/ScrollView/Viewport/Content/DesImageRoot/DesImage2")
  self.textDesText2 = self:AddComponent(UIText, "MainContent/ScrollView/Viewport/Content/DesText2")
  self.textOption = self:AddComponent(UIText, "MainContent/ScrollView/Viewport/Content/OptionText")
  self.textOption:SetLocalText("wish_preview_text4")
  self.compOptionContent = self:AddComponent(UIBaseContainer, "MainContent/ScrollView/Viewport/Content/OptionContent")
  self.btnRewardContent = self:AddComponent(UIButton, "MainContent/RewardContent")
  self.btnRewardContent:SetOnClick(function()
    self:OnBtnRewardContentClick()
  end)
  self.textReward = self:AddComponent(UIText, "MainContent/RewardContent/RewardText")
  self.imgReward = self:AddComponent(UIImage, "MainContent/RewardContent/RewardIcon")
  self.animReward = self:AddComponent(UIAnimator, "MainContent/RewardContent/RewardIcon")
  self.compRedReward = self:AddComponent(UIBaseContainer, "MainContent/RewardContent/RedReward")
  self.textDay = self:AddComponent(UIText, "TimeGroup/DiDay/DayText")
  self.textHour = self:AddComponent(UIText, "TimeGroup/DiHour/HourText")
  self.textMin = self:AddComponent(UIText, "TimeGroup/DiMin/MinText")
  self.textSec = self:AddComponent(UIText, "TimeGroup/DiSec/SecText")
  self.compTime = self:AddComponent(UIBaseContainer, "TimeGroup")
end

function UIHeroRecruitWishGuideView:ComponentDestroy()
  self:ClearItems()
  self.anim = nil
  self.btnPanel = nil
  self.textTitle = nil
  self.btnClose = nil
  self.compUICommonResItem = nil
  self.textNewWish = nil
  self.compContent = nil
  self.imgNewWishIcon = nil
  self.textDesText1 = nil
  self.imgDesImage1 = nil
  self.imgDesImage2 = nil
  self.textDesText2 = nil
  self.textOption = nil
  self.compOptionContent = nil
  self.btnRewardContent = nil
  self.textReward = nil
  self.compRedReward = nil
  self.textDay = nil
  self.textHour = nil
  self.textMin = nil
  self.textSec = nil
  self.imgReward = nil
  self.compTime = nil
  self.animReward = nil
end

function UIHeroRecruitWishGuideView:DataDefine()
  self.isClosing = false
end

function UIHeroRecruitWishGuideView:DataDestroy()
  if self.closeTimer ~= nil then
    self.closeTimer:Stop()
    self.closeTimer = nil
  end
end

function UIHeroRecruitWishGuideView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.HeroLotteryClaimWishGuideSuccess, self.OnClaimReward)
end

function UIHeroRecruitWishGuideView:OnRemoveListener()
  self:RemoveUIListener(EventId.HeroLotteryClaimWishGuideSuccess, self.OnClaimReward)
  base.OnRemoveListener(self)
end

function UIHeroRecruitWishGuideView:OnOpen()
  self:UpdateReward()
  local textList = self.ctrl:GetViewTextConfig()
  self.textNewWish:SetLocalText(textList[1] or "")
  self.textDesText2:SetLocalText(textList[3] or "")
  local imgList = self.ctrl:GetViewImgConfig()
  self.imgNewWishIcon:LoadSpriteAuto(imgList[1] or "")
  self.imgDesImage1:LoadSpriteAuto(imgList[2] or "")
  self.imgDesImage2:LoadSpriteAuto(imgList[3] or "")
  self.startTime = nil
  self:ClearItems()
  local lotteryId = self.ctrl:GetShowLotteryId()
  self.itemList = {}
  if lotteryId ~= nil then
    local info = DataCenter.LotteryDataManager:GetLotteryDataById(lotteryId)
    if info and not table.IsNullOrEmpty(info.wishList) then
      for i, v in pairs(info.wishList) do
        local item = self.compUICommonResItem.gameObject:GameObjectSpawn(self.compOptionContent.transform)
        item.name = tostring(i)
        local obj = self.compOptionContent:AddComponent(UICommonResItem, item.name)
        obj:SetActive(true)
        obj:ReInit({
          rewardType = RewardType.HERO,
          itemId = v,
          count = 1
        })
        self.itemList[i] = obj
      end
    end
    if info then
      self.startTime = info:GetWishStartTimeForNewTag()
      self.textDesText1:SetLocalText(textList[2] or "", tostring(info.wishPity or 0))
    end
    PostEventLog.Track(PostEventLog.Defines.HeroRecruitWishGuideOpen, {lotteryId = lotteryId})
  end
  self:UpdateTimeShow()
  self.anim:Play("Eff_UIHeroRecruitWishGuide_In")
end

function UIHeroRecruitWishGuideView:UpdateReward()
  local isCanClaim = DataCenter.LotteryDataManager:IsCanClaimHeroWishGuideReward()
  self.btnRewardContent:SetActive(isCanClaim)
  self.animReward:Enable(isCanClaim)
  if isCanClaim then
    local itemId, count = DataCenter.LotteryDataManager:GetHeroWishGuideRewardInfo()
    if itemId and count then
      local icon = DataCenter.ItemTemplateManager:GetIconPath(itemId)
      if not string.IsNullOrEmpty(icon) then
        self.imgReward:LoadSprite(icon)
      end
      self.textReward:SetText("\195\151" .. tostring(count))
    end
    self.animReward:Play("Eff_UIHeroRecruitWishGuide_RewardIconloop")
  end
end

function UIHeroRecruitWishGuideView:ClearItems()
  self.compOptionContent:RemoveComponents(UICommonResItem)
  self.compUICommonResItem.gameObject:GameObjectRecycleAll()
  self.itemList = nil
end

function UIHeroRecruitWishGuideView:UpdateTimeShow()
  if self.startTime == nil then
    self.compTime:SetActive(false)
    return
  end
  local curSec = UITimeManager:GetInstance():GetServerSeconds()
  local remainTime = self.startTime / 1000 - curSec
  if remainTime <= 0 then
    self.compTime:SetActive(false)
    return
  end
  self.compTime:SetActive(true)
  local day = MyModf(remainTime / OneDayTime)
  self.textDay:SetText(MyStrFormat("%dd", day))
  local hour = MyModf(remainTime / 3600) % 24
  self.textHour:SetText(MyStrFormat("%02d", hour))
  local minute = MyModf(remainTime / 60) % 60
  self.textMin:SetText(MyStrFormat("%02d", minute))
  local second = MyFloor(remainTime % 60)
  self.textSec:SetText(MyStrFormat("%02d", second))
end

function UIHeroRecruitWishGuideView:Update1000MS()
  self:UpdateTimeShow()
end

function UIHeroRecruitWishGuideView:OnBtnPanelClick()
  self:Close()
end

function UIHeroRecruitWishGuideView:OnBtnCloseClick()
  self:Close()
end

function UIHeroRecruitWishGuideView:OnClaimReward()
  self:UpdateReward()
end

function UIHeroRecruitWishGuideView:OnBtnRewardContentClick()
  local isCanClaim = DataCenter.LotteryDataManager:IsCanClaimHeroWishGuideReward()
  if isCanClaim then
    DataCenter.LotteryDataManager:SendClaimWishGuideRewardMessage()
  end
end

function UIHeroRecruitWishGuideView:Close()
  if self.isClosing then
    return
  end
  self.isClosing = true
  local ret, time = self.anim:PlayAnimationReturnTime("Eff_UIHeroRecruitWishGuide_Out")
  if ret then
    self.closeTimer = TimerManager:GetInstance():GetTimer(time, function()
      if self.closeTimer ~= nil then
        self.closeTimer:Stop()
        self.closeTimer = nil
      end
      if self.ctrl then
        self.ctrl:CloseSelf()
      end
    end, self, true, false, false)
    self.closeTimer:Start()
  elseif self.ctrl then
    self.ctrl:CloseSelf()
  end
end

return UIHeroRecruitWishGuideView
