local ScratchOffGame = BaseClass("ScratchOffGame", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local Setting = CS.GameEntry.Setting
local UIGray = CS.UIGray
local activityTitle_path = "Top/title"
local remainTime_path = "Top/remainTime"
local infoBtn_path = "Top/infoBtn"
local scratchOffRecordBtn_path = "Top/scratchOffRecordBtn"
local scratchOffRecordTxt_path = "Top/scratchOffRecordBtn/scratchOffRecordTxt"
local scratchOffRewardBtn_path = "Top/scratchOffRewardBtn"
local scratchOffRewardTxt_path = "Top/scratchOffRewardBtn/scratchOffRewardTxt"
local scratchOffBuyBtn_path = "Top/scratchOffBuyItemBtn"
local scratchOffBuyTxt_path = "Top/scratchOffBuyItemBtn/scratchOffBuyItemTxt"
local slider_path = "Bottom/RewardBg/SliderProcessBar"
local scoreProcessTxt_path = "Bottom/RewardBg/SliderProcessBar/scoreProcessTxt"
local extraRewardDesTxt_path = "Bottom/RewardBg/SliderProcessBar/extraRewardDesTxt"
local extraRewardIconImg_path = "Bottom/RewardBg/extraRewardBg/extraRewardIconImg"
local extraRewardReceiveBtn_path = "Bottom/RewardBg/ReceiveBtn"
local currentPoolTxt_path = "Top/CumulativeReward/currentPoolTxt"
local currentPoolNumTxt_path = "Top/CumulativeReward/currentPoolNumTxt"
local oneDrawBtn_path = "Bottom/oneDrawBtn"
local oneDrawTxt_path = "Bottom/oneDrawBtn/Root/oneDrawTxt"
local oneDrawNumTxt_path = "Bottom/oneDrawBtn/Root/oneDrawNumTxt"
local oneDrawPropIconImg_path = "Bottom/oneDrawBtn/Root/oneDrawNumTxt/oneDrawPropIcon"
local oneDrawFreeRed_path = "Bottom/oneDrawBtn/Root/Img_FreeRed"
local tenDrawBtn_path = "Bottom/tenDrawBtn"
local tenDrawTxt_path = "Bottom/tenDrawBtn/Root/tenDrawTxt"
local tenDrawNumTxt_path = "Bottom/tenDrawBtn/Root/tenDrawNumTxt"
local tenDrawPropIconImg_path = "Bottom/tenDrawBtn/Root/tenDrawNumTxt/tenDrawPoropIcon"
local tenDrawFree_path = "Bottom/tenDrawBtn/Root/tenDrawFree"
local tenDrawDiscountTxt_path = "Bottom/tenDrawBtn/Root/tenDrawFree/tenDrawDiscountTxt"
local remainNumTxt_path = "Bottom/remainNumTxt"
local skipBtn_path = "Bottom/skipBtn"
local skipTxt_path = "Bottom/skipBtn/skipTxt"
local skipMark_path = "Bottom/skipBtn/skipMark"
local sliderEff_path = "Bottom/RewardBg/SliderProcessBar/FillArea/sliderEff"
local scratchAnim_path = "Bottom/RewardBg/scratchAnim"
local scratchOffImg_path = "Bottom/RewardBg/scratchOffImg"
local icon1_path = "Bottom/RewardBg/icon1"
local icon2_path = "Bottom/RewardBg/icon2"
local icon3_path = "Bottom/RewardBg/icon3"
local commonResItem_path = "Bottom/RewardBg/UICommonResItem"

function ScratchOffGame:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

function ScratchOffGame:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function ScratchOffGame:DataDefine()
  self.skipAnim = false
end

function ScratchOffGame:DataDestroy()
  self.skipAnim = nil
end

function ScratchOffGame:ComponentDefine()
  self.activityTitle = self:AddComponent(UIText, activityTitle_path)
  self.remainTimeTxt = self:AddComponent(UIText, remainTime_path)
  self.infoBtn = self:AddComponent(UIButton, infoBtn_path)
  self.infoBtn:SetOnClick(function()
    self:OnClickInfoBtn()
  end)
  self.scratchOffRecordBtn = self:AddComponent(UIButton, scratchOffRecordBtn_path)
  self.scratchOffRecordBtn:SetOnClick(function()
    self:OnClickScratchOffRecordBtn()
  end)
  self.scratchOffRecordTxt = self:AddComponent(UIText, scratchOffRecordTxt_path)
  self.extraRewardIconImg = self:AddComponent(UICommonResItem, extraRewardIconImg_path)
  self.extraRewardReceiveBtn = self:AddComponent(UIButton, extraRewardReceiveBtn_path)
  self.extraRewardReceiveBtn:SetOnClick(function()
    self:OnReceiveBtnClick()
  end)
  UIGray.SetGray(self.extraRewardReceiveBtn.transform, true, false)
  self.scratchOffRewardBtn = self:AddComponent(UIButton, scratchOffRewardBtn_path)
  self.scratchOffRewardBtn:SetOnClick(function()
    self:OnClickScratchOffRewardDetailBtn()
  end)
  self.scratchOffRewardTxt = self:AddComponent(UIText, scratchOffRewardTxt_path)
  self.scratchOffBuyBtn = self:AddComponent(UIButton, scratchOffBuyBtn_path)
  self.scratchOffBuyBtn:SetOnClick(function()
    self:OnClickScratchOffBuyItemBtn()
  end)
  self.scratchOffBuyTxt = self:AddComponent(UIText, scratchOffBuyTxt_path)
  self.slider = self:AddComponent(UISlider, slider_path)
  self.scoreProcessTxt = self:AddComponent(UIText, scoreProcessTxt_path)
  self.extraRewardDesTxt = self:AddComponent(UIText, extraRewardDesTxt_path)
  self.currentPoolTxt = self:AddComponent(UIText, currentPoolTxt_path)
  self.currentPoolNumTxt = self:AddComponent(UIText, currentPoolNumTxt_path)
  self.oneDrawBtn = self:AddComponent(UIButton, oneDrawBtn_path)
  self.oneDrawBtn:SetOnClick(function()
    self:OnClickDrawBtn(0)
  end)
  UIGray.SetGray(self.oneDrawBtn.transform, false, true)
  self.oneDrawTxt = self:AddComponent(UIText, oneDrawTxt_path)
  self.oneDrawTxt:SetText(Localization:GetString("2000685", "1"))
  self.oneDrawNumTxt = self:AddComponent(UIText, oneDrawNumTxt_path)
  self.oneDrawTxtShadow = self:AddComponent(UIShadow, oneDrawTxt_path)
  self.oneDrawNumTxtShadow = self:AddComponent(UIShadow, oneDrawNumTxt_path)
  self.oneDrawPropIconImg = self:AddComponent(UIImage, oneDrawPropIconImg_path)
  self.oneDrawFreeRed = self:AddComponent(UIBaseContainer, oneDrawFreeRed_path)
  self.tenDrawBtn = self:AddComponent(UIButton, tenDrawBtn_path)
  self.tenDrawBtn:SetOnClick(function()
    self:OnClickDrawBtn(1)
  end)
  UIGray.SetGray(self.tenDrawBtn.transform, false, true)
  self.tenDrawTxt = self:AddComponent(UIText, tenDrawTxt_path)
  self.tenDrawTxt:SetText(Localization:GetString("2000685", "10"))
  self.tenDrawNumTxt = self:AddComponent(UIText, tenDrawNumTxt_path)
  self.tenDrawPropIconImg = self:AddComponent(UIImage, tenDrawPropIconImg_path)
  self.tenDrawFree = self:AddComponent(UIBaseContainer, tenDrawFree_path)
  self.tenDrawDiscountTxt = self:AddComponent(UIText, tenDrawDiscountTxt_path)
  self.remainNumTxt = self:AddComponent(UIText, remainNumTxt_path)
  self.skipBtn = self:AddComponent(UIButton, skipBtn_path)
  self.skipBtn:SetOnClick(function()
    self:OnClickSkipBtn()
  end)
  self.skipTxt = self:AddComponent(UIText, skipTxt_path)
  self.skipTxt:SetLocalText(372228)
  self.skipMark = self:AddComponent(UIBaseContainer, skipMark_path)
  self.sliderEff = self:AddComponent(UIBaseContainer, sliderEff_path)
  self.sliderEff:SetActive(false)
  self.scratchAnim = self:AddComponent(UIAnimator, scratchAnim_path)
  self.scratchAnim:SetActive(false)
  self.scratchOffImg = self:AddComponent(UIBaseContainer, scratchOffImg_path)
  self.icon1 = self:AddComponent(UIImage, icon1_path)
  self.icon2 = self:AddComponent(UIImage, icon2_path)
  self.icon3 = self:AddComponent(UIImage, icon3_path)
  self.commonResItem = self:AddComponent(UICommonResItem, commonResItem_path)
end

function ScratchOffGame:OnReceiveBtnClick()
  if not self.activityId then
    return
  end
  local activityParamInfo = DataCenter.ScratchOffGameManager:GetActivityParamInfo(self.activityId)
  if not activityParamInfo then
    return
  end
  local curScore = tonumber(activityParamInfo.score)
  local maxScore = tonumber(activityParamInfo.extraRewardScore)
  if curScore >= maxScore then
    SFSNetwork.SendMessage(MsgDefines.ScratchScoreReward, self.activityId)
  end
end

function ScratchOffGame:OnEnable()
  base.OnEnable(self)
  self.scratchAnim:SetActive(false)
  self.scratchOffImg:SetActive(true)
  UIGray.SetGray(self.oneDrawBtn.transform, false, true)
  UIGray.SetGray(self.tenDrawBtn.transform, false, true)
end

function ScratchOffGame:ComponentDestroy()
end

function ScratchOffGame:SetData(activityId, id)
  self.activityId = id
  self.actId = activityId
  if not self.activityId then
    return
  end
  self.activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(tostring(self.activityId))
  if not self.activityInfo then
    return
  end
  DataCenter.ActivityListDataManager:SetActivityVisitedEndTime(self.activityId)
  self.endTime = self.activityInfo.endTime
  self:AddCountDownTimer()
  self.skipAnim = Setting:GetBool(SettingKeys.SCRATCH_SKIP_ANIM, false)
  self.skipMark:SetActive(self.skipAnim)
  SFSNetwork.SendMessage(MsgDefines.GetScratchOffGameActivityInfo, self.activityId)
end

function ScratchOffGame:RefreshAll()
  if IsNull(self.gameObject) then
    return
  end
  self.activityTitle:SetLocalText(self.activityInfo.name)
  self.activityTemplate = DataCenter.ScratchOffGameManager:GetActivityTemplate(self.activityId)
  self.activityParamInfo = DataCenter.ScratchOffGameManager:GetActivityParamInfo(self.activityId)
  self.chooseHeroIndex = self.activityParamInfo.chooseIndex
  if self.activityTemplate then
    self.extraRewardIconImg:SetActive(true)
    local itemInfo = {}
    itemInfo.rewardType = RewardType.GOODS
    itemInfo.itemId = self.activityTemplate.extraRewardItemId[self.chooseHeroIndex]
    itemInfo.count = self.activityTemplate.extraRewardItemNum[self.chooseHeroIndex]
    self.extraRewardIconImg:ReInit(itemInfo)
    self.extraRewardIconImg:SetImgQuailtyShow(false)
  else
    self.extraRewardIconImg:SetActive(false)
  end
  local curScore = tonumber(self.activityParamInfo.score)
  local maxScore = tonumber(self.activityParamInfo.extraRewardScore)
  local progress = curScore / maxScore
  if 1 <= progress then
    progress = 1
  end
  self.slider:SetValue(progress)
  local canReceive = curScore >= maxScore
  UIGray.SetGray(self.extraRewardReceiveBtn.transform, not canReceive, canReceive)
  self.scoreProcessTxt:SetText(self.activityParamInfo.score .. "/" .. self.activityParamInfo.extraRewardScore)
  self.currentPoolNumTxt:SetText(string.GetFormattedSeperatorNum(self.activityParamInfo.diamondPool))
  local oneDrawNum = 0
  if 0 < self.activityParamInfo.oneLotteryCount then
    oneDrawNum = self.activityTemplate.oneDrawCostNum
    self.oneDrawBtn:LoadSprite(string.format(LoadPath.LWCommonPath, "cfm_tongyong_anniu_4"))
    self.oneDrawNumTxt:SetText(tostring(oneDrawNum))
    self.oneDrawFreeRed:SetActive(false)
  else
    oneDrawNum = self.activityTemplate.oneDrawFreeCostNum
    self.oneDrawBtn:LoadSprite(string.format(LoadPath.LWCommonPath, "cfm_tongyong_anniu_2"))
    self.oneDrawNumTxt:SetLocalText(130126)
    self.oneDrawFreeRed:SetActive(true)
  end
  self.oneDrawCostNum = tonumber(oneDrawNum)
  if not string.IsNullOrEmpty(self.activityTemplate.costItemIconPath) then
    self.oneDrawPropIconImg:LoadSprite(self.activityTemplate.costItemIconPath)
  end
  local tenDrawNum = 0
  if 0 < self.activityParamInfo.tenLotteryCount then
    tenDrawNum = self.activityTemplate.tenDrawCostNum
    self.tenDrawFree:SetActive(false)
  else
    tenDrawNum = self.activityTemplate.tenDrawFreeCostNum
    self.tenDrawFree:SetActive(false)
  end
  self.tenDrawCostNum = tonumber(tenDrawNum)
  self.tenDrawNumTxt:SetText(tostring(tenDrawNum))
  if not string.IsNullOrEmpty(self.activityTemplate.costItemIconPath) then
    self.tenDrawPropIconImg:LoadSprite(self.activityTemplate.costItemIconPath)
  end
  self.remainNum = self.activityParamInfo:GetRemainLotteryCount()
  self.remainNumTxt:SetText(Localization:GetString("2000707", self.remainNum))
  self:RefreshRes()
end

function ScratchOffGame:RefreshRes()
  self.costItemType = tonumber(self.activityTemplate.costItemType)
  self.costItemId = tonumber(self.activityTemplate.costItemId)
end

function ScratchOffGame:OnClickInfoBtn()
  if self.activityInfo then
    local param = {}
    param.activityRulesStr = Localization:GetString(self.activityInfo.story)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetail, {anim = true}, param)
  end
end

function ScratchOffGame:OnClickScratchOffRecordBtn()
  UIManager:GetInstance():OpenWindow(UIWindowNames.ScratchOffRecordPage, self.activityId)
end

function ScratchOffGame:OnClickScratchOffRankBtn()
  UIManager:GetInstance():OpenWindow(UIWindowNames.ScratchOffRankPage, self.activityId)
end

function ScratchOffGame:OnClickScratchOffRewardDetailBtn()
  UIManager:GetInstance():OpenWindow(UIWindowNames.ScratchOffRewardDetailPage, self.activityId, 1)
end

function ScratchOffGame:OnClickScratchOffBuyItemBtn()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILuckyRollShop, {anim = true}, self.activityId, self.activityTemplate.exchange, self.activityTemplate.costItemId)
end

function ScratchOffGame:OnClickDrawBtn(drawType)
  if not self.remainNum then
    return
  end
  if drawType == 0 then
    if self.remainNum < 1 then
      UIUtil.ShowTipsId(372304)
      return
    end
  elseif self.remainNum < 10 then
    UIUtil.ShowTipsId(372304)
    return
  end
  if self.costItemType == 1 then
    local tempCount = LuaEntry.Player.gold
    if drawType == 0 and tempCount < self.oneDrawCostNum then
      GoToUtil.GotoPayTips()
      return
    elseif drawType == 1 and tempCount < self.tenDrawCostNum then
      GoToUtil.GotoPayTips()
      return
    end
  elseif self.costItemType == 2 then
    local toggleState = DataCenter.SecondConfirmManager:GetTodayCanShowSecondConfirm(TodayNoSecondConfirmType.BuyScratchTip)
    local haveDiamond = CommonUtil.GetResOrItemCount(ResourceType.Gold)
    local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(self.costItemId)
    local tempCount = DataCenter.ItemData:GetItemCount(self.costItemId)
    if drawType == 0 and tempCount < self.oneDrawCostNum then
      if itemTemplate then
        local itemPrice = itemTemplate.price
        local cost = itemPrice * (self.oneDrawCostNum - tempCount)
        if haveDiamond < cost then
          GoToUtil.GotoPayTips(cost)
          return
        end
      end
      if toggleState == false then
        SFSNetwork.SendMessage(MsgDefines.ScratchDiamondExchangeItem, self.activityTemplate.costItemId, self.oneDrawCostNum - tempCount, toInt(self.activityId), drawType)
      else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UILuckyRollBuy, {anim = true}, self.activityTemplate.costItemId, self.activityTemplate.exchange, self.oneDrawCostNum - tempCount, self.activityId, drawType)
      end
      return
    elseif drawType == 1 and tempCount < self.tenDrawCostNum then
      if itemTemplate then
        local itemPrice = itemTemplate.price
        local cost = itemPrice * (self.tenDrawCostNum - tempCount)
        if haveDiamond < cost then
          GoToUtil.GotoPayTips(cost)
          return
        end
      end
      if toggleState == false then
        SFSNetwork.SendMessage(MsgDefines.ScratchDiamondExchangeItem, self.activityTemplate.costItemId, self.tenDrawCostNum - tempCount, toInt(self.activityId), drawType)
      else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UILuckyRollBuy, {anim = true}, self.activityTemplate.costItemId, self.activityTemplate.exchange, self.tenDrawCostNum - tempCount, self.activityId, drawType)
      end
      return
    end
  end
  SFSNetwork.SendMessage(MsgDefines.GetScratchOffGameLotteryRes, self.activityId, drawType)
end

function ScratchOffGame:OnClickSkipBtn()
  self.skipAnim = not self.skipAnim
  self.skipMark:SetActive(self.skipAnim)
  Setting:SetBool(SettingKeys.SCRATCH_SKIP_ANIM, self.skipAnim)
end

function ScratchOffGame:AddCountDownTimer()
  function self.CountDownTimerAction()
    self:RefreshRemainTime()
  end
  
  if self.countDownTimer == nil then
    self.countDownTimer = TimerManager:GetInstance():GetTimer(1, self.CountDownTimerAction, self, false, false, false)
  end
  self.countDownTimer:Start()
  self:RefreshRemainTime()
end

function ScratchOffGame:RefreshRemainTime()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local remainTime = self.endTime - curTime
  if 0 <= remainTime then
    self.remainTimeTxt:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
  else
    self.remainTimeTxt:SetText("")
  end
end

function ScratchOffGame:DelCountDownTimer()
  self.CountDownTimerAction = nil
  if self.countDownTimer ~= nil then
    self.countDownTimer:Stop()
    self.countDownTimer = nil
  end
end

function ScratchOffGame:ShowLotteryReward()
  if self.activityId then
    UIManager:GetInstance():OpenWindow(UIWindowNames.ScratchOffGameGetRewardPage, self.activityId)
  end
  if self.oneDrawBtn and not IsNull(self.oneDrawBtn.transform) then
    UIGray.SetGray(self.oneDrawBtn.transform, false, true)
  end
  if self.tenDrawBtn and not IsNull(self.tenDrawBtn.transform) then
    UIGray.SetGray(self.tenDrawBtn.transform, false, true)
  end
end

function ScratchOffGame:OpenGetRewardPage()
  self.scratchOffImg:SetActive(false)
  local firstScratchOffResInfo = DataCenter.ScratchOffGameManager:GetFirstScratchOffResInfo(self.activityId)
  if not firstScratchOffResInfo then
    return
  end
  if self.commonResItem then
    self.commonResItem:ReInit(firstScratchOffResInfo.commonResItemInfo)
    if self.commonResItem.num_text and self.commonResItem.itemCountActive then
      local text = string.format("X%d", self.commonResItem.itemCount)
      self.commonResItem.num_text:SetText(text)
    end
  end
  self.icon1:LoadSprite(firstScratchOffResInfo.icon1)
  self.icon2:LoadSprite(firstScratchOffResInfo.icon2)
  self.icon3:LoadSprite(firstScratchOffResInfo.icon3)
  if self.skipAnim then
    self.scratchAnim:SetActive(false)
    self:ShowLotteryReward()
  else
    self.scratchAnim:SetActive(true)
    UIGray.SetGray(self.oneDrawBtn.transform, true, false)
    UIGray.SetGray(self.tenDrawBtn.transform, true, false)
    self.scratchAnim:SampleAnimationAtTime("Eff_ui_guaguale_huichen", 0)
    local ret1, time1 = self.scratchAnim:PlayAnimationReturnTime("Eff_ui_guaguale_huichen")
    self.delayShowReward = TimerManager:GetInstance():DelayInvoke(function()
      self:ShowLotteryReward()
    end, time1)
  end
end

function ScratchOffGame:OnClickAddResBtn()
end

function ScratchOffGame:RefreshRank()
end

function ScratchOffGame:ShowExtraReward()
  self.sliderEff:SetActive(false)
  self.sliderEff:SetActive(true)
  local num = self.activityTemplate.extraRewardItemNum[self.chooseHeroIndex]
  local iconPath = self.activityTemplate.extraRewardIconPath[self.chooseHeroIndex]
  UIUtil.DoFly(RewardType.GOODS, num, iconPath, self.extraRewardIconImg.transform.position, Vector3.New(0, 0, 0))
end

function ScratchOffGame:OnDisable()
  base.OnDisable(self)
  self:DelCountDownTimer()
  self.sliderEff:SetActive(false)
end

function ScratchOffGame:OnBackToScratchOff()
  self.scratchAnim:SetActive(false)
  self.scratchOffImg:SetActive(true)
  UIGray.SetGray(self.oneDrawBtn.transform, false, true)
  UIGray.SetGray(self.tenDrawBtn.transform, false, true)
end

function ScratchOffGame:SwitchHero()
  self.chooseHeroIndex = self.activityParamInfo.chooseIndex
  local bgIcon = self.activityTemplate.heroPicList[self.chooseHeroIndex]
  local path = string.format("Assets/Main/TextureEx/UIScratchOff/%s", bgIcon)
end

function ScratchOffGame:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ScratchOffGameActivityParamUpdate, self.RefreshAll)
  self:AddUIListener(EventId.ScratchOffGameRewardLotteryInfoUpdate, self.OpenGetRewardPage)
  self:AddUIListener(EventId.ScratchOffGameRankInfoUpdate, self.RefreshRank)
  self:AddUIListener(EventId.ScratchOffGameGetExtraReward, self.ShowExtraReward)
  self:AddUIListener(EventId.BackToScratchOff, self.OnBackToScratchOff)
  self:AddUIListener(EventId.UpdateGold, self.RefreshRes)
  self:AddUIListener(EventId.ScratchOffGameSelectedHeroUpdate, self.SwitchHero)
end

function ScratchOffGame:OnRemoveListener()
  self:RemoveUIListener(EventId.ScratchOffGameActivityParamUpdate, self.RefreshAll)
  self:RemoveUIListener(EventId.ScratchOffGameRewardLotteryInfoUpdate, self.OpenGetRewardPage)
  self:RemoveUIListener(EventId.ScratchOffGameRankInfoUpdate, self.RefreshRank)
  self:RemoveUIListener(EventId.ScratchOffGameGetExtraReward, self.ShowExtraReward)
  self:RemoveUIListener(EventId.BackToScratchOff, self.OnBackToScratchOff)
  self:RemoveUIListener(EventId.UpdateGold, self.RefreshRes)
  self:RemoveUIListener(EventId.ScratchOffGameSelectedHeroUpdate, self.SwitchHero)
  base.OnRemoveListener(self)
end

return ScratchOffGame
