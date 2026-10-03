local base = UIBaseContainer
local UILWT11IdleGameBattleMain_BattleContentComponent = BaseClass("UILWT11IdleGameBattleMain_BattleContentComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local Const = require("DataCenter/T11IdleGame/IdleBattle/T11IdleGameIdleBattleConstant")
local T11IdleGameIdleBattleLogic = require("DataCenter/T11IdleGame/IdleBattle/Battle/T11IdleGameIdleBattleLogic")
local UILWT11IdleGameBattleMain_NodeInfoItemComponent = require("UI/T11IdleGame/T11IdleGameBattleMain/Component/UILWT11IdleGameBattleMain_NodeInfoItemComponent")

function UILWT11IdleGameBattleMain_BattleContentComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.bgmSoundId = DataCenter.LWSoundManager:PlaySound(91010, true)
end

function UILWT11IdleGameBattleMain_BattleContentComponent:OnDestroy()
  if self.bgmSoundId then
    DataCenter.LWSoundManager:StopSound(self.bgmSoundId)
    self.bgmSoundId = nil
  end
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWT11IdleGameBattleMain_BattleContentComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.rawImgRT = self.viewSkin:AddComponent(self, UIRawImage, 1)
  self.textBattleSceneTitle01 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textBattleSceneTitle02 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textRewardContentTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.scrollViewRewardContentScrollViewHorizontal = self.viewSkin:AddComponent(self, UIScrollView, 5)
  self.btnRewardContent = self.viewSkin:AddComponent(self, UIButton, 6)
  self.btnRewardContent:SetOnClick(function()
    self:OnBtnRewardContentClick()
  end)
  self.textRewardContentBtn = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.btnEnd = self.viewSkin:AddComponent(self, UIButton, 8)
  self.btnEnd:SetOnClick(function()
    self:OnBtnEndClick()
  end)
  self.textEnd = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.compEffSaoguang = self.viewSkin:AddComponent(self, UIBaseComponent, 10)
  self.textYellowTips = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 11)
  self.textBlueTips = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 12)
  self.compNodeInfoItemContent = self.viewSkin:AddComponent(self, UIBaseContainer, 13)
  self.compPower = self.viewSkin:AddComponent(self, UIBaseComponent, 14)
  self.compSoldier = self.viewSkin:AddComponent(self, UIBaseComponent, 15)
  self.textPowerTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 16)
  self.textPowerSlider = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 17)
  self.textSoldierTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 18)
  self.textSoldierSlider = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 19)
  self.btnBoss = self.viewSkin:AddComponent(self, UIButton, 20)
  self.btnBoss:SetOnClick(function()
    self:OnBtnBossClick()
  end)
  self.textBoss = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 21)
  self.compFlyRewardStart = self.viewSkin:AddComponent(self, UIBaseComponent, 22)
  self.compFlyRewardEnd = self.viewSkin:AddComponent(self, UIBaseComponent, 23)
  self.textRewardContentEmpty = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 24)
  self.compFlyEffectStart = self.viewSkin:AddComponent(self, UIBaseComponent, 25)
  self.btnTask = self.viewSkin:AddComponent(self, UIButton, 26)
  self.btnTask:SetOnClick(function()
    self:OnBtnTaskClick()
  end)
  self.animatorYellowTips = self.viewSkin:AddComponent(self, UIAnimator, 27)
  self.animatorBlueTips = self.viewSkin:AddComponent(self, UIAnimator, 28)
  self.animatorUILWT11IdleGameBattleMainBattleContent = self.viewSkin:AddComponent(self, UIAnimator, 29)
  self.compNodeInfoItem01 = self.viewSkin:AddComponent(self, UILWT11IdleGameBattleMain_NodeInfoItemComponent, 30)
  self.compNodeInfoItem02 = self.viewSkin:AddComponent(self, UILWT11IdleGameBattleMain_NodeInfoItemComponent, 31)
  self.compNodeInfoItem03 = self.viewSkin:AddComponent(self, UILWT11IdleGameBattleMain_NodeInfoItemComponent, 32)
  self.btnRank = self.viewSkin:AddComponent(self, UIButton, 33)
  self.btnRank:SetOnClick(function()
    self:OnBtnRankClick()
  end)
  self.btnRewardPreview = self.viewSkin:AddComponent(self, UIButton, 34)
  self.btnRewardPreview:SetOnClick(function()
    self:OnBtnRewardPreviewClick()
  end)
  self.textBattleLeftTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 35)
  self.compTaskRedPoint = self.viewSkin:AddComponent(self, UIBaseContainer, 36)
  self.compEndRed = self.viewSkin:AddComponent(self, UIBaseComponent, 37)
  self.compBossRed = self.viewSkin:AddComponent(self, UIBaseComponent, 38)
  self.compCenter = self.viewSkin:AddComponent(self, UIBaseComponent, 39)
  self.compBg = self.viewSkin:AddComponent(self, UIBaseComponent, 40)
  self.compLeftTime = self.viewSkin:AddComponent(self, UIBaseComponent, 41)
  self.textLeftTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 42)
  self.btnLeftTimeInfo = self.viewSkin:AddComponent(self, UIButton, 43)
  self.btnLeftTimeInfo:SetOnClick(function()
    self:OnBtnLeftTimeInfoClick()
  end)
  self.btnPowerInfo = self.viewSkin:AddComponent(self, UIButton, 44)
  self.btnPowerInfo:SetOnClick(function()
    self:OnBtnPowerInfoClick()
  end)
  self.nodeInfoItems = {
    self.compNodeInfoItem01,
    self.compNodeInfoItem02,
    self.compNodeInfoItem03
  }
  self.btnRewardContent:SetSafeClickMode(true)
  self.btnEnd:SetSafeClickMode(true)
  self.btnBoss:SetSafeClickMode(true)
  self.textBattleSceneTitle01:SetLocalText("t11_idle_game_desc_2")
  self.textRewardContentTitle:SetLocalText("t11_idle_game_desc_10")
  self.textRewardContentBtn:SetLocalText("t11_idle_game_button_11")
  self.textRewardContentEmpty:SetLocalText("t11_idle_game_desc_60")
  self.textPowerTitle:SetLocalText("t11_idle_game_desc_6")
  self.textSoldierTitle:SetLocalText("t11_idle_game_desc_7")
  self.textEnd:SetLocalText("t11_idle_game_btn_90")
  self.textBoss:SetLocalText("t11_idle_game_button_12")
  self.scrollViewRewardContentScrollViewHorizontal:SetFixedItemSize(90, 90)
  self.scrollViewRewardContentScrollViewHorizontal:SetOnItemMoveIn(function(itemObj, index)
    self:OnRewardItemMoveIn(itemObj, index)
  end)
  self.scrollViewRewardContentScrollViewHorizontal:SetOnItemMoveOut(function(itemObj, index)
    self:OnRewardItemMoveOut(itemObj, index)
  end)
  self:HideAllTips()
  self.btnEnd:SetActive(false)
  self.compEffSaoguang:SetActive(false)
end

function UILWT11IdleGameBattleMain_BattleContentComponent:ComponentDestroy()
  self:ClearScroll()
  self.nodeInfoItems = nil
  self.viewSkin = nil
  self.rawImgRT = nil
  self.textBattleSceneTitle01 = nil
  self.textBattleSceneTitle02 = nil
  self.textRewardContentTitle = nil
  self.scrollViewRewardContentScrollViewHorizontal = nil
  self.btnRewardContent = nil
  self.textRewardContentBtn = nil
  self.btnEnd = nil
  self.textEnd = nil
  self.compEffSaoguang = nil
  self.textYellowTips = nil
  self.textBlueTips = nil
  self.compNodeInfoItemContent = nil
  self.compPower = nil
  self.compSoldier = nil
  self.textPowerTitle = nil
  self.textPowerSlider = nil
  self.textSoldierTitle = nil
  self.textSoldierSlider = nil
  self.btnBoss = nil
  self.textBoss = nil
  self.compFlyRewardStart = nil
  self.compFlyRewardEnd = nil
  self.textRewardContentEmpty = nil
  self.compFlyEffectStart = nil
  self.btnTask = nil
  self.animatorYellowTips = nil
  self.animatorBlueTips = nil
  self.animatorUILWT11IdleGameBattleMainBattleContent = nil
  self.compNodeInfoItem01 = nil
  self.compNodeInfoItem02 = nil
  self.compNodeInfoItem03 = nil
  self.btnRank = nil
  self.btnRewardPreview = nil
  self.textBattleLeftTime = nil
  self.compTaskRedPoint = nil
  self.compEndRed = nil
  self.compBossRed = nil
  self.compCenter = nil
  self.compBg = nil
  self.compLeftTime = nil
  self.textLeftTime = nil
  self.btnLeftTimeInfo = nil
  self.btnPowerInfo = nil
end

function UILWT11IdleGameBattleMain_BattleContentComponent:DataDefine()
  self.param = nil
  self.battleLogic = nil
  self.infoData = nil
  self.rewardsList = nil
  if self.delayHideYellowTipsTimer then
    self.delayHideYellowTipsTimer:Stop()
    self.delayHideYellowTipsTimer = nil
  end
  if self.delayHideBlueTipsTimer then
    self.delayHideBlueTipsTimer:Stop()
    self.delayHideBlueTipsTimer = nil
  end
  self.hasInitReward = false
  self.hasSendEndMsg = false
  self.hasClickEnterBoss = false
  self.battleLogic = nil
  self.enterTime = 0
  self.stayTipsSeconds = 0
  self.hasShownStayTips = false
  self.leftTimeTextStr = nil
end

function UILWT11IdleGameBattleMain_BattleContentComponent:DataDestroy()
  self.param = nil
  self.infoData = nil
  self.rewardsList = nil
  if self.delayHideYellowTipsTimer then
    self.delayHideYellowTipsTimer:Stop()
    self.delayHideYellowTipsTimer = nil
  end
  if self.delayHideBlueTipsTimer then
    self.delayHideBlueTipsTimer:Stop()
    self.delayHideBlueTipsTimer = nil
  end
  self.hasInitReward = nil
  self.hasSendEndMsg = nil
  self.hasClickEnterBoss = nil
  if self.battleLogic then
    self.battleLogic:Destroy()
  end
  self.battleLogic = nil
  self.enterTime = nil
  self.stayTipsSeconds = nil
  self.hasShownStayTips = nil
  self.leftTimeTextStr = nil
end

function UILWT11IdleGameBattleMain_BattleContentComponent:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.T11IdleGameOnRewardReceiveMessage, self.OnRewardReceiveMessage)
  self:AddUIListener(EventId.T11IdleGameOnGetIdleGameMainMessage, self.OnGetMainMessage)
  self:AddUIListener(EventId.T11IdleGamePlayFlyRewardNew, self.OnFlyNewReward)
  self:AddUIListener(EventId.T11IdleGameTaskEventListRefresh, self.OnRefreshEventRedPointByEventList)
  self:AddUIListener(EventId.T11IdleGameTaskEventRedPointRefreshByUpdateMsg, self.OnRefreshEventRedPointByUpdateMsg)
  self:AddUIListener(EventId.T11IdleGameOnStartGameLeftTimeChangeMessage, self.OnStartGameLeftTimeChange)
end

function UILWT11IdleGameBattleMain_BattleContentComponent:OnRemoveListener()
  self:RemoveUIListener(EventId.T11IdleGameOnRewardReceiveMessage, self.OnRewardReceiveMessage)
  self:RemoveUIListener(EventId.T11IdleGameOnGetIdleGameMainMessage, self.OnGetMainMessage)
  self:RemoveUIListener(EventId.T11IdleGamePlayFlyRewardNew, self.OnFlyNewReward)
  self:RemoveUIListener(EventId.T11IdleGameTaskEventListRefresh, self.OnRefreshEventRedPointByEventList)
  self:RemoveUIListener(EventId.T11IdleGameTaskEventRedPointRefreshByUpdateMsg, self.OnRefreshEventRedPointByUpdateMsg)
  self:RemoveUIListener(EventId.T11IdleGameOnStartGameLeftTimeChangeMessage, self.OnStartGameLeftTimeChange)
  base.OnRemoveListener(self)
end

function UILWT11IdleGameBattleMain_BattleContentComponent:ReInit(param)
  self.param = param or {}
  self.enterTime = UITimeManager:GetInstance():GetServerSeconds()
  self.stayTipsSeconds = DataCenter.T11IdleGameTemplateManager:GetBattleContentStayTipsSeconds()
  self.infoData = DataCenter.T11IdleGameDataManager:GetIdleInfoData()
  if self.infoData == nil or not self.infoData:IsHasStarted() then
    return
  end
  local needSendGetMainMsg = false
  if not self.infoData:IsCanEnd() and self.infoData:IsFutureNodeDataExpired() then
    needSendGetMainMsg = true
    DataCenter.T11IdleGameDataManager:SendGetIdleGameMainMessage()
  end
  self:InitBattleLogic(needSendGetMainMsg)
  self:RefreshBottomBtn()
  self:RefreshRewardContent()
  self:CreateNodeInfoItems()
  self:RefreshInfoContent()
  self:RefreshLevelTitle()
  self:Update1000MS()
  self:RefreshBossBtnRed()
  self:RefreshEndBtnRed()
  self:RefreshUIPosYByScreenHeight()
  if self.param.isFromStart == true then
    self:ShowYellowTips(Localization:GetString("t11_idle_game_desc_66"), 4)
  end
  if self.param.isFromOpen == true then
    DataCenter.T11IdleGameDataManager:CheckOpenTaskEventNewTipsView()
    self.animatorUILWT11IdleGameBattleMainBattleContent:Play("V_ui_UILWT11IdleGameBattleMain_BattleContent_in")
  else
    self.animatorUILWT11IdleGameBattleMainBattleContent:Play("V_ui_UILWT11IdleGameBattleMain_BattleContent_idle")
  end
  self.hasSendEndMsg = false
  self.hasClickEnterBoss = false
  local isShowRedPoint = DataCenter.T11IdleGameDataManager:IsShowEventRedPointByMainMsg()
  self.compTaskRedPoint:SetActive(isShowRedPoint)
end

function UILWT11IdleGameBattleMain_BattleContentComponent:TryShowRewardNew(battleRewardViewCloseCallback)
  local rewards = self.infoData:GetRewardNewForShow()
  if not table.IsNullOrEmpty(rewards) then
    local param = {}
    param.rewards = rewards
    param.tips = Localization:GetString("t11_idle_game_desc_22")
    param.title = Localization:GetString("t11_idle_game_title_21")
    
    function param.closeCallback()
      self:ShowRewardRefreshEffect()
      if battleRewardViewCloseCallback then
        battleRewardViewCloseCallback()
      end
    end
    
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWT11IdleGameBattleReward, {anim = true}, param)
  elseif battleRewardViewCloseCallback then
    battleRewardViewCloseCallback()
  end
end

function UILWT11IdleGameBattleMain_BattleContentComponent:InitBattleLogic(needWaitForGetMainData)
  if self.battleLogic ~= nil then
    return
  end
  local param = {}
  param.renderTexture = self.rawImgRT
  param.rtWidth = self.rawImgRT.rectTransform.rect.width
  param.rtHeight = self.rawImgRT.rectTransform.rect.height
  param.infoData = self.infoData
  param.isFromStart = self.param.isFromStart
  param.needWaitForGetMainData = needWaitForGetMainData
  self.battleLogic = T11IdleGameIdleBattleLogic.New()
  self.battleLogic:Enter(param)
end

function UILWT11IdleGameBattleMain_BattleContentComponent:RefreshLevelTitle()
  if self.infoData == nil then
    return
  end
  local curLevel = self.infoData:GetLevelTemplate()
  if curLevel then
    self.textBattleSceneTitle02:SetText(curLevel:GetName())
  end
end

function UILWT11IdleGameBattleMain_BattleContentComponent:OnGameEnd()
  self:RefreshBottomBtn()
  self:RefreshEndBtnRed()
end

function UILWT11IdleGameBattleMain_BattleContentComponent:RefreshBottomBtn()
  if self.infoData == nil then
    return
  end
  local mainData = DataCenter.T11IdleGameDataManager:GetMainData()
  if mainData == nil then
    return
  end
  local leftTime = mainData:GetStartGameLeftTime()
  local isCanEnd = self.infoData:IsCanEnd()
  local isShowEnd = isCanEnd and 0 < leftTime
  self.btnEnd:SetActive(isShowEnd)
  if isCanEnd then
    self:ShowYellowTips(Localization:GetString("t11_idle_game_desc_67"))
  end
  local isShowBossBtn = not isShowEnd and self.infoData:IsHasStarted()
  self.btnBoss:SetActive(isShowBossBtn)
end

function UILWT11IdleGameBattleMain_BattleContentComponent:OnBtnEndClick()
  if not self.hasSendEndMsg then
    DataCenter.T11IdleGameDataManager:SendIdleGameEndMessage()
    self.hasSendEndMsg = true
    DataCenter.LWSoundManager:PlaySound(90118, false)
  end
end

function UILWT11IdleGameBattleMain_BattleContentComponent:OnBtnBossClick()
  if not self.hasClickEnterBoss then
    self.hasClickEnterBoss = true
    EventManager:GetInstance():Broadcast(EventId.T11IdleGameOnClickEnterBossBattle)
    DataCenter.LWSoundManager:PlaySound(91011, false)
  end
end

function UILWT11IdleGameBattleMain_BattleContentComponent:OnBtnTaskClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIIdleGameTaskEventList)
  DataCenter.T11IdleGameDataManager:CheckOpenTaskEventNewTipsView()
  DataCenter.T11IdleGameDataManager:ClearNewEventTipsData()
end

function UILWT11IdleGameBattleMain_BattleContentComponent:PlayFlyEffectToTaskBtn()
  local path = "Assets/_Art_LastWar/Effect/Prefab/UI/Yingxiongxiangqing/Eff_ui_hero_xiangqing_shengji_jingyan.prefab"
  local parent = self.transform
  DataCenter.FlyController.DoFlyWithBezierFunc(path, self.compFlyEffectStart.transform.position, self.btnTask.transform.position, 1, parent)
end

function UILWT11IdleGameBattleMain_BattleContentComponent:RefreshRewardContent()
  if self.infoData == nil then
    return
  end
  self.rewardsList = self.infoData:GetRewardPoolForShow()
  local showClaim = not table.IsNullOrEmpty(self.rewardsList)
  self.scrollViewRewardContentScrollViewHorizontal:SetActive(showClaim)
  self.btnRewardContent:SetActive(showClaim)
  self.textRewardContentEmpty:SetActive(not showClaim)
  if showClaim then
    self.scrollViewRewardContentScrollViewHorizontal:SetTotalCount(#self.rewardsList)
    self.scrollViewRewardContentScrollViewHorizontal:RefillCells()
    if self.hasInitReward then
      self:ShowRewardRefreshEffect()
    end
  end
  self.hasInitReward = true
end

function UILWT11IdleGameBattleMain_BattleContentComponent:ShowRewardRefreshEffect()
  if self.compEffSaoguang then
    self.compEffSaoguang:SetActive(false)
    self.compEffSaoguang:SetActive(true)
    DataCenter.LWSoundManager:PlaySound(91017, false)
  end
end

function UILWT11IdleGameBattleMain_BattleContentComponent:OnBtnRewardContentClick()
  if self.infoData and not self.infoData:IsRewardPoolEmpty() then
    if self.battleLogic == nil then
      return
    end
    if self.battleLogic:IsPlayingNode() then
      UIUtil.ShowTipsId("t11_idle_game_desc_79")
      return
    end
    DataCenter.T11IdleGameDataManager:SendRewardReceiveMessage()
  end
end

function UILWT11IdleGameBattleMain_BattleContentComponent:OnRewardItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scrollViewRewardContentScrollViewHorizontal:AddComponent(UICommonResItem, itemObj)
  if cellItem ~= nil and self.rewardsList and self.rewardsList[index] then
    cellItem.rectTransform:Set_localScale(0.8, 0.8, 0.8)
    cellItem.rectTransform:Set_sizeDelta(150, 150)
    cellItem.rectTransform:Set_pivot(0, 1)
    cellItem:ReInit(self.rewardsList[index])
  end
end

function UILWT11IdleGameBattleMain_BattleContentComponent:OnRewardItemMoveOut(itemObj, index)
  self.scrollViewRewardContentScrollViewHorizontal:RemoveComponent(itemObj.name, UICommonResItem)
end

function UILWT11IdleGameBattleMain_BattleContentComponent:ClearScroll()
  self.scrollViewRewardContentScrollViewHorizontal:ClearCells()
  self.scrollViewRewardContentScrollViewHorizontal:RemoveComponents(UICommonResItem)
end

function UILWT11IdleGameBattleMain_BattleContentComponent:OnRewardReceiveMessage()
  if not self.infoData then
    return
  end
  self:RefreshRewardContent()
end

function UILWT11IdleGameBattleMain_BattleContentComponent:OnFlyNewReward()
  if not self.infoData then
    return
  end
  local rewards = self.infoData:GetRewardNewForShow()
  if table.IsNullOrEmpty(rewards) then
    return
  end
  for _, v in ipairs(rewards) do
    local rewardType = v.rewardType
    local itemId = v.itemId
    local pic = DataCenter.RewardManager:GetPicByType(rewardType, itemId)
    if not string.IsNullOrEmpty(pic) then
      UIUtil.DoFly(tonumber(rewardType), 1, pic, self.compFlyRewardStart.transform.position, self.compFlyRewardEnd.transform.position, nil, nil, nil, nil, nil, nil, self.transform)
    end
  end
end

function UILWT11IdleGameBattleMain_BattleContentComponent:HideAllTips()
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

function UILWT11IdleGameBattleMain_BattleContentComponent:ShowYellowTips(text, showTime)
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

function UILWT11IdleGameBattleMain_BattleContentComponent:ShowBlueTips(text, showTime)
  self:HideAllTips()
  self.animatorBlueTips:SetActive(true)
  self.textBlueTips:SetText(text)
  DataCenter.LWSoundManager:PlaySound(91008, false)
  if showTime ~= nil then
  end
end

function UILWT11IdleGameBattleMain_BattleContentComponent:CreateNodeInfoItems()
  for i, nodeType in pairs(Const.NodeType) do
    if self.nodeInfoItems and self.nodeInfoItems[nodeType] then
      self.nodeInfoItems[nodeType]:SetData(nodeType, self.infoData)
    end
  end
end

function UILWT11IdleGameBattleMain_BattleContentComponent:RefreshNodeInfoItems()
  if self.nodeInfoItems then
    for k, v in pairs(self.nodeInfoItems) do
      v:Refresh()
    end
  end
end

function UILWT11IdleGameBattleMain_BattleContentComponent:RefreshPassedNodeInfoContent(nodeData)
  if self.infoData == nil then
    return
  end
  local flyNodeType
  if nodeData then
    flyNodeType = nodeData:GetType()
  end
  if flyNodeType and self.nodeInfoItems and self.nodeInfoItems[flyNodeType] then
    self.nodeInfoItems[flyNodeType]:RefreshAfterShowFlyEffect(self.compFlyEffectStart.transform.position)
  end
end

function UILWT11IdleGameBattleMain_BattleContentComponent:RefreshInfoContent()
  if self.infoData == nil then
    return
  end
  self.textPowerSlider:SetText(self.infoData:GetPowerStr())
  self.textSoldierSlider:SetText(self.infoData.soldierNum)
end

function UILWT11IdleGameBattleMain_BattleContentComponent:PlayChangeAnim()
  return self.animatorUILWT11IdleGameBattleMainBattleContent:PlayAnimationReturnTime("V_ui_UILWT11IdleGameBattleMain_BattleContent_show")
end

function UILWT11IdleGameBattleMain_BattleContentComponent:PlayChangeBackAnim()
  return self.animatorUILWT11IdleGameBattleMainBattleContent:PlayAnimationReturnTime("V_ui_UILWT11IdleGameBattleMain_BattleContent_hide")
end

function UILWT11IdleGameBattleMain_BattleContentComponent:OnGetMainMessage()
  if self.infoData == nil then
    return
  end
  self:RefreshBottomBtn()
  self:RefreshRewardContent()
  self:RefreshNodeInfoItems()
end

function UILWT11IdleGameBattleMain_BattleContentComponent:OnBtnRankClick()
  DataCenter.T11IdleGameManager:OpenRankView()
end

function UILWT11IdleGameBattleMain_BattleContentComponent:OnBtnRewardPreviewClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWT11IdleGameBattleRewardPreview, {anim = true})
end

function UILWT11IdleGameBattleMain_BattleContentComponent:Update1000MS()
  if self.infoData == nil then
    return
  end
  local showCountdown = self.infoData:IsHasStarted()
  self.textBattleLeftTime:SetActive(showCountdown)
  if showCountdown then
    local endTime = self.infoData:GetEndTime()
    local severTimeNow = UITimeManager:GetInstance():GetServerTime()
    local leftTime = math.max(0, endTime - severTimeNow)
    local countDownTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
    self.textBattleLeftTime:SetLocalText("t11_idle_game_desc_4", countDownTimeStr)
  end
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  local passedTime = curTime - self.enterTime
  if 0 < self.stayTipsSeconds and passedTime > self.stayTipsSeconds and not self.hasShownStayTips then
    self.hasShownStayTips = true
    UIUtil.ShowSecondMessage(Localization:GetString("activity_concert_15"), Localization:GetString("t11_idle_game_desc_86", self.stayTipsSeconds // 60), 1, "alliance_announcement_4", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, false)
  end
  self:RefreshLeftTime()
end

function UILWT11IdleGameBattleMain_BattleContentComponent:OnRefreshEventRedPointByEventList()
  local isShowRedPoint = DataCenter.T11IdleGameDataManager:IsShowEventRedPointByTaskList()
  self.compTaskRedPoint:SetActive(isShowRedPoint)
end

function UILWT11IdleGameBattleMain_BattleContentComponent:OnRefreshEventRedPointByUpdateMsg()
  local isShowRedPoint = DataCenter.T11IdleGameDataManager:IsShowEventRedPointByUpdateMsg()
  self.compTaskRedPoint:SetActive(isShowRedPoint)
end

function UILWT11IdleGameBattleMain_BattleContentComponent:RefreshBossBtnRed()
  local isShow = false
  if self.param and self.param.isFromStart then
    isShow = true
  end
  if not isShow then
    local mainData = DataCenter.T11IdleGameDataManager:GetMainData()
    if mainData and self.infoData then
      local myPower = self.infoData.challengePower
      local boss = mainData:GetCurBossTemplate()
      if boss and myPower and myPower >= boss.boss_power then
        isShow = true
      end
    end
  end
  self.compBossRed:SetActive(isShow)
end

function UILWT11IdleGameBattleMain_BattleContentComponent:RefreshEndBtnRed()
  local isShow = self.infoData and self.infoData:IsCanEnd()
  self.compEndRed:SetActive(isShow)
end

function UILWT11IdleGameBattleMain_BattleContentComponent:RefreshUIPosYByScreenHeight()
  local uiContainerRect = UIManager:GetInstance():GetUIContainerRect()
  local parentHeight = uiContainerRect.sizeDelta.y
  if Config.IsPC() then
    parentHeight = DefaultScreenHeight
  end
  local curOffsetMin = self.compBg:GetOffsetMin()
  self.compBg:SetOffsetMinXY(curOffsetMin.x, -0.3888888888888889 * (parentHeight - DefaultScreenHeight))
end

function UILWT11IdleGameBattleMain_BattleContentComponent:RefreshLeftTime()
  local mainData = DataCenter.T11IdleGameDataManager:GetMainData()
  if mainData == nil or self.infoData == nil then
    return
  end
  local isCanEnd = self.infoData:IsCanEnd()
  self.compLeftTime:SetActive(isCanEnd)
  if not isCanEnd then
    return
  end
  local leftTime = mainData:GetStartGameLeftTime()
  if 0 < leftTime then
    local showStr = Localization:GetString("t11_idle_game_desc_87", leftTime)
    if self.leftTimeTextStr ~= showStr then
      self.leftTimeTextStr = showStr
      self.textLeftTime:SetText(showStr)
    end
  else
    local remainTimeS = UITimeManager:GetInstance():GetResSecondsTo24()
    local leftTimeStr = UITimeManager:GetInstance():SecondToFmtStringWithoutDay(remainTimeS)
    local showStr = Localization:GetString("t11_idle_game_desc_89", leftTimeStr)
    self.leftTimeTextStr = showStr
    self.textLeftTime:SetText(showStr)
  end
end

function UILWT11IdleGameBattleMain_BattleContentComponent:OnStartGameLeftTimeChange()
  self:RefreshBottomBtn()
  self:RefreshLeftTime()
end

function UILWT11IdleGameBattleMain_BattleContentComponent:OnBtnPowerInfoClick()
  local param = {}
  param.activityRulesStr = Localization:GetString("t11_idle_game_desc_92")
  param.title = "t11_idle_game_title_91"
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
end

function UILWT11IdleGameBattleMain_BattleContentComponent:OnBtnLeftTimeInfoClick()
  local param = {}
  param.alignObject = self.btnLeftTimeInfo.transform
  param.yPosFix = 70
  param.xPosFix = -10
  param.showArrow = false
  param.target = self.btnLeftTimeInfo
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWT11IdleGameBattleLeftTimeTips, {anim = true}, param)
end

return UILWT11IdleGameBattleMain_BattleContentComponent
