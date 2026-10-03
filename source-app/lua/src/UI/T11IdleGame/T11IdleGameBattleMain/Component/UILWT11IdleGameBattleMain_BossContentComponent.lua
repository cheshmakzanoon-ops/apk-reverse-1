local base = UIBaseContainer
local UILWT11IdleGameBattleMain_BossContentComponent = BaseClass("UILWT11IdleGameBattleMain_BossContentComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local T11IdleGameBossBattleLogic = require("DataCenter/T11IdleGame/IdleBattle/Boss/T11IdleGameBossBattleLogic")

function UILWT11IdleGameBattleMain_BossContentComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWT11IdleGameBattleMain_BossContentComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWT11IdleGameBattleMain_BossContentComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.rawImgRT = self.viewSkin:AddComponent(self, UIRawImage, 1)
  self.textBattleSceneTitle01 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textBattleSceneTitle02 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.animatorYellowTips = self.viewSkin:AddComponent(self, UIAnimator, 4)
  self.textYellowTips = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.animatorBlueTips = self.viewSkin:AddComponent(self, UIAnimator, 6)
  self.textBlueTips = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.btnEndAuto = self.viewSkin:AddComponent(self, UIButton, 8)
  self.btnEndAuto:SetOnClick(function()
    self:OnBtnEndAutoClick()
  end)
  self.textEndAuto = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.btnStartAuto = self.viewSkin:AddComponent(self, UIButton, 10)
  self.btnStartAuto:SetOnClick(function()
    self:OnBtnStartAutoClick()
  end)
  self.textStartAuto = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 11)
  self.textCurBossCount = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 12)
  self.textTotalBossCount = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 13)
  self.compBossInfo = self.viewSkin:AddComponent(self, UIBaseComponent, 14)
  self.textBossHp = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 15)
  self.textPowerTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 16)
  self.textPowerSlider = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 17)
  self.textSoldierTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 18)
  self.textSoldierSlider = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 19)
  self.textRewardContentTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 20)
  self.scrollViewRewardContentScrollViewHorizontal = self.viewSkin:AddComponent(self, UIScrollView, 21)
  self.textRewardContentEmpty = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 22)
  self.compFlyRewardStart = self.viewSkin:AddComponent(self, UIBaseComponent, 23)
  self.compFlyRewardEnd = self.viewSkin:AddComponent(self, UIBaseComponent, 24)
  self.compEffSaoguang = self.viewSkin:AddComponent(self, UIBaseComponent, 25)
  self.animatorUILWT11IdleGameBattleMainBossContent = self.viewSkin:AddComponent(self, UIAnimator, 26)
  self.btnRank = self.viewSkin:AddComponent(self, UIButton, 27)
  self.btnRank:SetOnClick(function()
    self:OnBtnRankClick()
  end)
  self.btnRewardPreview = self.viewSkin:AddComponent(self, UIButton, 28)
  self.btnRewardPreview:SetOnClick(function()
    self:OnBtnRewardPreviewClick()
  end)
  self.toggleLW = self.viewSkin:AddComponent(self, UIToggle, 29)
  self.textToggle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 30)
  self.btnChallenge = self.viewSkin:AddComponent(self, UIButton, 31)
  self.btnChallenge:SetOnClick(function()
    self:OnBtnChallengeClick()
  end)
  self.textChallenge = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 32)
  self.compCenter = self.viewSkin:AddComponent(self, UIBaseComponent, 33)
  self.compBg = self.viewSkin:AddComponent(self, UIBaseComponent, 34)
  self.btnPowerInfo = self.viewSkin:AddComponent(self, UIButton, 35)
  self.btnPowerInfo:SetOnClick(function()
    self:OnBtnPowerInfoClick()
  end)
  self.btnStartAuto:SetSafeClickMode(true)
  self.btnEndAuto:SetSafeClickMode(true)
  self.btnChallenge:SetSafeClickMode(true)
  self.textBattleSceneTitle01:SetLocalText("t11_idle_game_desc_2")
  self.textRewardContentTitle:SetLocalText("t11_idle_game_desc_82")
  self.textRewardContentEmpty:SetLocalText("t11_idle_game_desc_60")
  self.textEndAuto:SetLocalText("armed_truck_reward_stop_btn")
  self.textStartAuto:SetLocalText("t11_idle_game_desc_68")
  self.textChallenge:SetLocalText("t11_idle_game_desc_68")
  self.textPowerTitle:SetLocalText("t11_idle_game_desc_6")
  self.textSoldierTitle:SetLocalText("t11_idle_game_desc_7")
  self.textToggle:SetLocalText("t11_idle_game_button_19")
  self.toggleLW:SetOnValueChanged(function(tf)
    DataCenter.T11IdleGameManager:SetBossAutoOn(tf)
    self:RefreshBottomBtn()
  end)
  self.animBossCountText = self.textCurBossCount.gameObject.transform:GetComponent(typeof(CS.UnityEngine.Animation))
  self.scrollViewRewardContentScrollViewHorizontal:SetFixedItemSize(90, 90)
  self.scrollViewRewardContentScrollViewHorizontal:SetOnItemMoveIn(function(itemObj, index)
    self:OnRewardItemMoveIn(itemObj, index)
  end)
  self.scrollViewRewardContentScrollViewHorizontal:SetOnItemMoveOut(function(itemObj, index)
    self:OnRewardItemMoveOut(itemObj, index)
  end)
  self:HideAllTips()
  self:HideBossInfo()
end

function UILWT11IdleGameBattleMain_BossContentComponent:ComponentDestroy()
  self:ClearScroll()
  self.viewSkin = nil
  self.rawImgRT = nil
  self.textBattleSceneTitle01 = nil
  self.textBattleSceneTitle02 = nil
  self.animatorYellowTips = nil
  self.textYellowTips = nil
  self.animatorBlueTips = nil
  self.textBlueTips = nil
  self.btnEndAuto = nil
  self.textEndAuto = nil
  self.btnStartAuto = nil
  self.textStartAuto = nil
  self.textCurBossCount = nil
  self.textTotalBossCount = nil
  self.compBossInfo = nil
  self.textBossHp = nil
  self.textPowerTitle = nil
  self.textPowerSlider = nil
  self.textSoldierTitle = nil
  self.textSoldierSlider = nil
  self.textRewardContentTitle = nil
  self.scrollViewRewardContentScrollViewHorizontal = nil
  self.textRewardContentEmpty = nil
  self.compFlyRewardStart = nil
  self.compFlyRewardEnd = nil
  self.compEffSaoguang = nil
  self.animatorUILWT11IdleGameBattleMainBossContent = nil
  self.btnRank = nil
  self.btnRewardPreview = nil
  self.toggleLW = nil
  self.textToggle = nil
  self.btnChallenge = nil
  self.textChallenge = nil
  self.compCenter = nil
  self.compBg = nil
  self.btnPowerInfo = nil
  self.animBossCountText = nil
end

function UILWT11IdleGameBattleMain_BossContentComponent:DataDefine()
  self.battleLogic = nil
  self.mainData = nil
  self.infoData = nil
  self.rewardsList = nil
  self.rewardAdd = nil
  self.hasInitReward = false
  self.battleLogic = nil
end

function UILWT11IdleGameBattleMain_BossContentComponent:DataDestroy()
  self.mainData = nil
  self.infoData = nil
  self.rewardsList = nil
  self.rewardAdd = nil
  if self.delayHideYellowTipsTimer then
    self.delayHideYellowTipsTimer:Stop()
    self.delayHideYellowTipsTimer = nil
  end
  if self.delayHideBlueTipsTimer then
    self.delayHideBlueTipsTimer:Stop()
    self.delayHideBlueTipsTimer = nil
  end
  self.hasInitReward = nil
  if self.battleLogic then
    self.battleLogic:Destroy()
  end
  self.battleLogic = nil
end

function UILWT11IdleGameBattleMain_BossContentComponent:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.T11IdleGameOnChallengeBossMessage, self.OnChallengeBossMessage)
end

function UILWT11IdleGameBattleMain_BossContentComponent:OnRemoveListener()
  self:RemoveUIListener(EventId.T11IdleGameOnChallengeBossMessage, self.OnChallengeBossMessage)
  base.OnRemoveListener(self)
end

function UILWT11IdleGameBattleMain_BossContentComponent:ReInit()
  self.mainData = DataCenter.T11IdleGameDataManager:GetMainData()
  self.infoData = DataCenter.T11IdleGameDataManager:GetIdleInfoData()
  if self.mainData == nil or self.infoData == nil then
    return
  end
  self:InitBattleLogic()
  self:RefreshBossCount(false)
  self:RefreshBottomBtn()
  self:RefreshInfoContent()
  self:RefreshRewardContent()
  self:RefreshLevelTitle()
  self:RefreshUIPosYByScreenHeight()
  self.animatorUILWT11IdleGameBattleMainBossContent:Play("V_ui_UILWT11IdleGameBattleMain_BossContent_idle")
  self.toggleLW:SetIsOn(DataCenter.T11IdleGameManager:GetBossAutoIsOn())
end

function UILWT11IdleGameBattleMain_BossContentComponent:InitBattleLogic()
  if self.battleLogic then
    return
  end
  local param = {}
  param.renderTexture = self.rawImgRT
  param.rtWidth = math.floor(self.rawImgRT.rectTransform.rect.width)
  param.rtHeight = math.floor(self.rawImgRT.rectTransform.rect.height)
  param.mainData = self.mainData
  param.infoData = self.infoData
  self.battleLogic = T11IdleGameBossBattleLogic.New()
  self.battleLogic:Enter(param)
end

function UILWT11IdleGameBattleMain_BossContentComponent:RefreshLevelTitle()
  if self.infoData == nil then
    return
  end
  local curLevel = self.infoData:GetLevelTemplate()
  if curLevel then
    self.textBattleSceneTitle02:SetText(curLevel:GetName())
  end
end

function UILWT11IdleGameBattleMain_BossContentComponent:RefreshBossCount(playAnim)
  if self.mainData == nil then
    return
  end
  local levelTemplate = self.mainData:GetCurLevelTemplate()
  if not levelTemplate then
    return
  end
  local firstBoss = levelTemplate:GetFirstBossTemplate()
  if not firstBoss then
    return
  end
  local totalCount = firstBoss:GetMaxBossCount()
  local curCount = 0
  local lastBoss = self.mainData:GetLastWinedBossTemplate()
  if lastBoss then
    curCount = lastBoss.boss_order
  end
  self.textCurBossCount:SetText(curCount)
  self.textTotalBossCount:SetText("/" .. totalCount)
  if playAnim == true and IsNotNull(self.animBossCountText) then
    self.animBossCountText:Play()
  end
end

function UILWT11IdleGameBattleMain_BossContentComponent:ShowBossInfo(boss)
  if boss == nil then
    return
  end
  self.compBossInfo:SetActive(true)
  self.textBossHp:SetText(string.GetFormattedSeparatorNum(boss.boss_power))
end

function UILWT11IdleGameBattleMain_BossContentComponent:HideBossInfo()
  self.compBossInfo:SetActive(false)
end

function UILWT11IdleGameBattleMain_BossContentComponent:RefreshBossCountAfterFlyEffect()
  local path = "Assets/_Art_LastWar/Effect/Prefab/UI/Yingxiongxiangqing/Eff_ui_hero_xiangqing_shengji_jingyan.prefab"
  local parent = UIManager:GetInstance():GetLayer(UILayer.TopMost.Name).transform
  DataCenter.FlyController.DoFlyWithBezierFunc(path, self.compFlyRewardStart.transform.position, self.textCurBossCount.transform.position, 1, parent, function()
    self:RefreshBossCount(true)
  end)
end

function UILWT11IdleGameBattleMain_BossContentComponent:RefreshBottomBtn()
  if self.battleLogic == nil or self.mainData == nil then
    return
  end
  local isFinishedAllBoss = self.mainData:IsFinishedAllBoss()
  local isInAutoMode = self.battleLogic:IsAutoModeOn()
  if isInAutoMode then
    self.btnChallenge:SetActive(false)
    self.btnStartAuto:SetActive(false)
    self.btnEndAuto:SetActive(true)
  else
    local isAutoToggleOn = self.toggleLW:GetIsOn()
    self.btnEndAuto:SetActive(false)
    self.btnStartAuto:SetActive(isAutoToggleOn)
    CS.UIGray.SetGray(self.btnStartAuto.transform, isFinishedAllBoss, not isFinishedAllBoss)
    self.btnChallenge:SetActive(not isAutoToggleOn)
    if not isAutoToggleOn then
      local isCanChallengeNow = self.battleLogic:IsCanChallengeNow()
      local isShowGray = not isCanChallengeNow or isFinishedAllBoss
      CS.UIGray.SetGray(self.btnChallenge.transform, isShowGray, not isShowGray)
    end
  end
end

function UILWT11IdleGameBattleMain_BossContentComponent:RefreshInfoContent()
  if self.infoData == nil then
    return
  end
  self.textPowerSlider:SetText(self.infoData:GetPowerStr())
  self.textSoldierSlider:SetText(self.infoData.soldierNum)
end

function UILWT11IdleGameBattleMain_BossContentComponent:OnBtnEndAutoClick()
  if self.battleLogic == nil then
    return
  end
  if not self.battleLogic:IsAutoModeOn() then
    return
  end
  self.battleLogic:SetAutoMode(false)
  self:RefreshBottomBtn()
end

function UILWT11IdleGameBattleMain_BossContentComponent:OnBtnStartAutoClick()
  if self.battleLogic == nil or self.mainData == nil then
    return
  end
  if self.battleLogic:IsAutoModeOn() then
    return
  end
  local isFinishedAllBoss = self.mainData:IsFinishedAllBoss()
  if isFinishedAllBoss then
    return
  end
  local isInCd = false
  if self.mainData.lastChallengeTime and self.mainData.lastChallengeTime > 0 then
    local curBoss = self.mainData:GetCurBossTemplate()
    if curBoss then
      local canStartTime = self.mainData.lastChallengeTime + curBoss.boss_cd * 1000
      local timeNow = UITimeManager:GetInstance():GetServerTime()
      if canStartTime > timeNow then
        isInCd = true
      end
    end
  end
  if isInCd then
    UIUtil.ShowTipsId("t11_idle_game_button_73")
    return
  end
  self.battleLogic:SetAutoMode(true)
  self:RefreshBottomBtn()
end

function UILWT11IdleGameBattleMain_BossContentComponent:OnBtnChallengeClick()
  if self.battleLogic == nil or self.mainData == nil then
    return
  end
  if self.toggleLW:GetIsOn() then
    return
  end
  if self.battleLogic:IsAutoModeOn() then
    return
  end
  if not self.battleLogic:IsCanChallengeNow() then
    return
  end
  local isFinishedAllBoss = self.mainData:IsFinishedAllBoss()
  if isFinishedAllBoss then
    return
  end
  local isInCd = false
  if self.mainData.lastChallengeTime and self.mainData.lastChallengeTime > 0 then
    local curBoss = self.mainData:GetCurBossTemplate()
    if curBoss then
      local canStartTime = self.mainData.lastChallengeTime + curBoss.boss_cd * 1000
      local timeNow = UITimeManager:GetInstance():GetServerTime()
      if canStartTime > timeNow then
        isInCd = true
      end
    end
  end
  if isInCd then
    UIUtil.ShowTipsId("t11_idle_game_button_73")
    return
  end
  self.battleLogic:OnClickChallengeBtn()
end

function UILWT11IdleGameBattleMain_BossContentComponent:TryFlyAddReward()
  if not self.rewardAdd then
    return
  end
  for _, v in ipairs(self.rewardAdd) do
    local rewardType = v.rewardType
    local itemId = v.itemId
    local pic = DataCenter.RewardManager:GetPicByType(rewardType, itemId)
    if not string.IsNullOrEmpty(pic) then
      UIUtil.DoFly(tonumber(rewardType), 1, pic, self.compFlyRewardStart.transform.position, self.compFlyRewardEnd.transform.position, nil, nil, nil, nil, nil, nil, self.transform)
    end
  end
end

function UILWT11IdleGameBattleMain_BossContentComponent:OnChallengeBossMessage(evtData)
  if self.rewardsList == nil then
    self.rewardsList = {}
  end
  if evtData and evtData.reward then
    local rewardDataShow = DataCenter.RewardManager:ReturnRewardParamForView(evtData.reward)
    for i, v in ipairs(rewardDataShow) do
      table.insert(self.rewardsList, v)
    end
    self.rewardsList = DataCenter.RewardManager:CombineRewardList(self.rewardsList)
    self.rewardAdd = rewardDataShow
  end
end

function UILWT11IdleGameBattleMain_BossContentComponent:RefreshRewardContent()
  local isShow = not table.IsNullOrEmpty(self.rewardsList)
  self.scrollViewRewardContentScrollViewHorizontal:SetActive(isShow)
  self.textRewardContentEmpty:SetActive(not isShow)
  if isShow then
    self.scrollViewRewardContentScrollViewHorizontal:SetTotalCount(#self.rewardsList)
    self.scrollViewRewardContentScrollViewHorizontal:RefillCells()
    if self.hasInitReward then
      self:ShowRewardRefreshEffect()
    end
  end
  self.hasInitReward = true
end

function UILWT11IdleGameBattleMain_BossContentComponent:OnRewardItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scrollViewRewardContentScrollViewHorizontal:AddComponent(UICommonResItem, itemObj)
  if cellItem ~= nil and self.rewardsList and self.rewardsList[index] then
    cellItem.rectTransform:Set_localScale(0.8, 0.8, 0.8)
    cellItem.rectTransform:Set_sizeDelta(150, 150)
    cellItem.rectTransform:Set_pivot(0, 1)
    cellItem:ReInit(self.rewardsList[index])
  end
end

function UILWT11IdleGameBattleMain_BossContentComponent:OnRewardItemMoveOut(itemObj, index)
  self.scrollViewRewardContentScrollViewHorizontal:RemoveComponent(itemObj.name, UICommonResItem)
end

function UILWT11IdleGameBattleMain_BossContentComponent:ClearScroll()
  self.scrollViewRewardContentScrollViewHorizontal:ClearCells()
  self.scrollViewRewardContentScrollViewHorizontal:RemoveComponents(UICommonResItem)
end

function UILWT11IdleGameBattleMain_BossContentComponent:ShowRewardRefreshEffect()
  if self.compEffSaoguang then
    self.compEffSaoguang:SetActive(false)
    self.compEffSaoguang:SetActive(true)
    DataCenter.LWSoundManager:PlaySound(91017, false)
  end
end

function UILWT11IdleGameBattleMain_BossContentComponent:HideAllTips()
  self.animatorYellowTips:SetActive(false)
  self.animatorBlueTips:SetActive(false)
  if self.delayHideYellowTipsTimer then
    self.delayHideYellowTipsTimer:Stop()
    self.delayHideYellowTipsTimer = nil
  end
  if self.delayHideBlueTipsTimer then
    self.delayHideBlueTipsTimer:Stop()
    self.delayHideBlueTipsTimer = nil
  end
end

function UILWT11IdleGameBattleMain_BossContentComponent:ShowYellowTips(text, showTime)
  self:HideAllTips()
  self.animatorYellowTips:SetActive(true)
  self.textYellowTips:SetText(text)
  DataCenter.LWSoundManager:PlaySound(91008, false)
  if showTime ~= nil then
    self.delayHideYellowTipsTimer = TimerManager:GetInstance():DelayInvoke(function()
      if self.animatorYellowTips then
        self.animatorYellowTips:SetActive(false)
      end
    end, showTime)
  end
end

function UILWT11IdleGameBattleMain_BossContentComponent:ShowBlueTips(text, showTime)
  self:HideAllTips()
  self.animatorBlueTips:SetActive(true)
  self.textBlueTips:SetText(text)
  if showTime ~= nil then
  end
end

function UILWT11IdleGameBattleMain_BossContentComponent:PlayChangeAnim()
  return self.animatorUILWT11IdleGameBattleMainBossContent:PlayAnimationReturnTime("V_ui_UILWT11IdleGameBattleMain_BossContent_show")
end

function UILWT11IdleGameBattleMain_BossContentComponent:PlayChangeBackAnim()
  return self.animatorUILWT11IdleGameBattleMainBossContent:PlayAnimationReturnTime("V_ui_UILWT11IdleGameBattleMain_BossContent_hide")
end

function UILWT11IdleGameBattleMain_BossContentComponent:OnBtnRankClick()
  DataCenter.T11IdleGameManager:OpenRankView()
end

function UILWT11IdleGameBattleMain_BossContentComponent:OnBtnRewardPreviewClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWT11IdleGameBattleRewardPreview, {anim = true})
end

function UILWT11IdleGameBattleMain_BossContentComponent:RefreshUIPosYByScreenHeight()
  local uiContainerRect = UIManager:GetInstance():GetUIContainerRect()
  local parentHeight = uiContainerRect.sizeDelta.y
  if Config.IsPC() then
    parentHeight = DefaultScreenHeight
  end
  local curOffsetMin = self.compBg:GetOffsetMin()
  self.compBg:SetOffsetMinXY(curOffsetMin.x, -0.3888888888888889 * (parentHeight - DefaultScreenHeight))
end

function UILWT11IdleGameBattleMain_BossContentComponent:OnBtnPowerInfoClick()
  local param = {}
  param.activityRulesStr = Localization:GetString("t11_idle_game_desc_92")
  param.title = "t11_idle_game_title_91"
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
end

return UILWT11IdleGameBattleMain_BossContentComponent
