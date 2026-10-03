local ActLotteryDraw100ResultView = BaseClass("ActLotteryDraw100ResultView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local other_title_text_path = "Root/Panel/CongrationArea/OtherTitleBg/OtherTitleText"
local top_area_text_path = "Root/Panel/CongrationArea/topAreaText"
local repeat_hero_tip_text_path = "Root/Panel/repeatHeroTipText"
local UITopItem = require("UI.UIHero2.UIHeroRecruit.Component.UITopItem")
local CardContent = require("UI.UIActLottery.ActLotteryDraw100Result.Component.ActLotteryDraw100ResultContent")
local ItemContent = require("UI.UIActLottery.ActLotteryDraw100Result.Component.ActLotteryDraw100ResultItemContent")
local node_bottom_path = "Root/NodeBottom"
local content_path = "Root/Panel/Scroll View/Viewport/Content"
local hero_area_content_path = "Root/Panel/Scroll View/Viewport/Content/RewardAreaContent"
local item_area_content_path = "Root/Panel/Scroll View/Viewport/Content/ItemAreaContent"
local panel_path = "Root/Panel"
local scroll_view_path = "Root/Panel/Scroll View"
local viewport_path = "Root/Panel/Scroll View/Viewport"
local recruit100_show_ani_path = "Recruit100ShowAni"
local bgs_path = "Bgs"
local root_path = "Root"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  local message = self:GetUserData()
  self:RefreshMessageData(message)
  self:OnOpen()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.btnClose = self:AddComponent(UIButton, "Root/closeBtn")
  self.btnClose:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.topBar = self:AddComponent(UIBaseContainer, "Root/TopBar")
  self.bottomArea = self:AddComponent(UIBaseContainer, node_bottom_path)
  self.textTitle = self:AddComponent(UIText, "Root/TopBar/TextTitle")
  self.textTitle:SetLocalText(110021)
  self.itemBar1 = self:AddComponent(UITopItem, "Root/TopBar/TopBarList/ItemBar1")
  self.itemBar2 = self:AddComponent(UITopItem, "Root/TopBar/TopBarList/ItemBar2")
  self.itemBarList = {
    self.itemBar1,
    self.itemBar2
  }
  self.TextBtn2 = self:AddComponent(UIText, "Root/NodeBottom/BtnRecruit/TextBtn2")
  self.imgCost = self:AddComponent(UIImage, "Root/NodeBottom/BtnRecruit/ImgCost")
  self.textCost = self:AddComponent(UIText, "Root/NodeBottom/BtnRecruit/ImgCost/TextCost")
  self.scrollContent = self:AddComponent(UIBaseContainer, content_path)
  self.heroRowContent = self:AddComponent(CardContent, hero_area_content_path)
  self.itemContent = self:AddComponent(ItemContent, item_area_content_path)
  self.btnRecruit = self:AddComponent(UIButton, "Root/NodeBottom/BtnRecruit")
  self.btnRecruit:SetOnClick(BindCallback(self, self.OnBtnRecruitClick))
  self.cardRoot = self:AddComponent(UIBaseContainer, panel_path)
  self.scrollView = self:AddComponent(UIScrollRect, scroll_view_path)
  self.congrationTitleText = self:AddComponent(UIText, other_title_text_path)
  self.congrationTitleText:SetLocalText(128027)
  self.recruitGetTipText = self:AddComponent(UIText, top_area_text_path)
  self.recruitGetTipText:SetLocalText("thxgiv_thxgiv_Lottery_Open100des")
  self.repeatHeroTipText = self:AddComponent(UIText, repeat_hero_tip_text_path)
  self.scrollViewMask = self.transform:Find(viewport_path):GetComponent(typeof(CS.UnityEngine.UI.Mask))
  self.scrollViewImg = self.transform:Find(viewport_path):GetComponent(typeof(CS.UnityEngine.UI.Image))
  self.bgObj = self:AddComponent(UIBaseContainer, bgs_path)
  self.rootObj = self:AddComponent(UIBaseContainer, root_path)
end

local function ComponentDestroy(self)
  self.btnClose = nil
  self.topBar = nil
  self.bottomArea = nil
  self.textTitle = nil
  self.itemBar1 = nil
  self.itemBar2 = nil
  self.itemBarList = nil
  self.scrollContent = nil
  self.heroRowContent = nil
  self.itemContent = nil
  self.btnRecruit = nil
  self.TextBtn2 = nil
  self.imgCost = nil
  self.textCost = nil
  self.contentLayout = nil
  self.scrollView = nil
  self.congrationTitleText = nil
  self.recruitGetTipText = nil
  self.repeatHeroTipText = nil
  self.scrollViewMask = nil
  self.scrollViewImg = nil
  self.bgObj = nil
  self.rootObj = nil
end

local function DataDefine(self)
  self.lotteryData = nil
  self.lotteryHeroData = nil
  self.displayResultTimer = nil
  self.closeEnterAniTimer = nil
  self.flipTimer = nil
  self.scrollMoveTween = nil
  self.screenYCenter = CS.UnityEngine.Screen.height / 2
  self.curScrollMoveTarget = Vector2(0, 0)
  self.scrollContentHeight = 0
  self.scrollViewHeight = 0
  self.canDrawClickTime = 0
end

local function DataDestroy(self)
  self:StopAllTimer()
  self:StopTween()
  self.lotteryData = nil
  self.lotteryHeroData = nil
  self.displayResultTimer = nil
  self.closeEnterAniTimer = nil
  self.flipTimer = nil
  self.scrollMoveTween = nil
  self.curScrollMoveTarget = nil
  self.scrollContentHeight = nil
  self.scrollViewHeight = nil
  self.canDrawClickTime = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshItems, self.OnRefreshItems)
  self:AddUIListener(EventId.ActLotteryDrawResultMsg, self.OnHandleRecruitResponse)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.RefreshItems, self.OnRefreshItems)
  self:RemoveUIListener(EventId.ActLotteryDrawResultMsg, self.OnHandleRecruitResponse)
end

local function OnOpen(self)
  self:StopAllTimer()
  self:ParseData()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  self.canDrawClickTime = curTime + 2000
  self.heroRowContent:SetData(self.allHeroDataList)
  self.itemContent:SetData(self.allItemDataList)
  self.itemId = self.activityTemp.ticket
  local costNum = DataCenter.ActLotteryDataManager:GetDrawNumByType(self.drawType)
  self.recruitCost = costNum
  self.itemHave = CommonUtil.GetResOrItemCount(tonumber(self.itemId))
  self.openCardDict = {}
  self.openCardCount = 0
  self.scrollContent.transform.anchoredPosition = Vector3(0, 0, 0)
  self:UpdateTopItemBar()
  self:RefreshNodeBottom()
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.scrollContent.transform)
  self.scrollViewHeight = self.scrollView.transform.rect.height
  self:ShowEnterAni()
end

local function OnHandleRecruitResponse(self, message)
  self:RefreshMessageData(message)
  self:OnOpen()
end

function ActLotteryDraw100ResultView:ParseData()
  local allHeroDataList = self.message.recordArr
  local allItemDataList = DataCenter.RewardManager:ReturnRewardParamForView(self.message.totalReward)
  self.allHeroDataList = allHeroDataList
  self.allItemDataList = allItemDataList
end

function ActLotteryDraw100ResultView:UpdateTopItemBar()
  local goldIndex = 2
  local itemIndex = 1
  self.itemBarList[goldIndex]:SetActive(true)
  self.itemBarList[goldIndex]:SetData(nil, ResourceType.Gold)
  self.itemBarList[itemIndex]:SetActive(true)
  self.itemBarList[itemIndex]:SetData(self.itemId)
end

function ActLotteryDraw100ResultView:RefreshNodeBottom()
  local item = DataCenter.ItemData:GetItemByItemId(tonumber(self.itemId))
  local itemCount = item and item.count or 0
  self.btnRecruit:SetActive(itemCount >= self.recruitCost)
  if itemCount < self.recruitCost then
    return
  end
  self.imgCost:LoadSprite(string.format(LoadPath.ItemPath, DataCenter.ItemTemplateManager:GetItemTemplate(self.itemId).icon))
  self.textCost:SetText(self.recruitCost)
  self.TextBtn2:SetLocalText("hero_recruit_100_tips4")
end

function ActLotteryDraw100ResultView:OnBtnRecruitClick()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime < self.canDrawClickTime then
    return
  end
  self.canDrawClickTime = curTime + 5000
  SFSNetwork.SendMessage(MsgDefines.LottoDraw, self.activityId, self.drawType)
end

local function OnRefreshItems(self)
  self.itemId = self.activityTemp.ticket
  local costNum = DataCenter.ActLotteryDataManager:GetDrawNumByType(self.drawType)
  self.recruitCost = costNum
  self.itemHave = CommonUtil.GetResOrItemCount(tonumber(self.itemId))
  self:UpdateTopItemBar()
  self:RefreshNodeBottom()
end

function ActLotteryDraw100ResultView:ExecuteNextAniStep()
  if not self.heroRowContent:IsAniAllFinish() then
    return self.heroRowContent:ExecuteOneAniStep()
  end
  if not self.itemContent:IsAniAllFinish() then
    return self.itemContent:ExecuteOneAniStep()
  end
  self:OnAllAniFinish()
end

function ActLotteryDraw100ResultView:OnAllAniFinish()
  self:StopTween()
  self.scrollMoveTween = self.scrollContent.transform:DOLocalMoveY(0, 0.5):SetDelay(0.5)
  
  function self.scrollMoveTween.onComplete()
    self.scrollView:SetEnable(true)
    self.scrollMoveTween = nil
  end
  
  self.scrollViewMask.enabled = true
  self.scrollViewImg.enabled = true
  self.bottomArea.gameObject:SetActive(true)
  self.topBar.gameObject:SetActive(true)
end

function ActLotteryDraw100ResultView:IsAniAllFinish()
  return self.heroRowContent:IsAniAllFinish() and self.itemContent:IsAniAllFinish()
end

function ActLotteryDraw100ResultView:StartPlayFlipCardAni()
  local aniTime, screenPos, isRepeatHeroChip = self:ExecuteNextAniStep()
  if screenPos then
    self:ContentYMoveCheck(screenPos)
  end
  if not aniTime or not screenPos then
    return
  end
  if self.flipTimer then
    self.flipTimer:Stop()
  end
  self.flipTimer = TimerManager:GetInstance():DelayInvoke(function()
    self:StartPlayFlipCardAni()
  end, aniTime)
  if isRepeatHeroChip then
    self.repeatHeroTipText.gameObject:SetActive(true)
  end
end

function ActLotteryDraw100ResultView:PauseFlipCardAni()
  if self.flipTimer then
    self.flipTimer:Stop()
  end
end

function ActLotteryDraw100ResultView:StopAllTimer()
  if self.displayResultTimer then
    self.displayResultTimer:Stop()
    self.displayResultTimer = nil
  end
  if self.closeEnterAniTimer then
    self.closeEnterAniTimer:Stop()
    self.closeEnterAniTimer = nil
  end
  if self.flipTimer then
    self.flipTimer:Stop()
    self.flipTimer = nil
  end
end

function ActLotteryDraw100ResultView:ShowEnterAni()
  self:ShowRecruitRewardResult()
end

function ActLotteryDraw100ResultView:ShowRecruitRewardResult()
  self.bgObj:SetActive(true)
  self.rootObj:SetActive(true)
  self.topBar.gameObject:SetActive(false)
  self.bottomArea.gameObject:SetActive(false)
  self.btnClose.gameObject:SetActive(false)
  self.cardRoot:SetActive(false)
  self.cardRoot:SetActive(true)
  self.btnClose.gameObject:SetActive(true)
  self.displayResultTimer = TimerManager:GetInstance():DelayInvoke(function()
    self:StartPlayFlipCardAni()
  end, 0.3)
end

function ActLotteryDraw100ResultView:ContentYMoveCheck(curCardScreenPos)
  if not (self.scrollContent and self.screenYCenter) or not curCardScreenPos then
    return
  end
  if curCardScreenPos.y > self.screenYCenter then
    return
  end
  self.scrollViewMask.enabled = true
  self.scrollViewImg.enabled = true
  self.scrollContentHeight = self.scrollContent.transform.rect.height
  if self.scrollContentHeight <= self.scrollViewHeight then
    return
  end
  local moveDistance = self.screenYCenter - curCardScreenPos.y
  local targetPos = self.scrollContent.transform.anchoredPosition + Vector2(0, moveDistance)
  local maxPosY = self.scrollContentHeight - self.scrollViewHeight
  if maxPosY < targetPos.y then
    targetPos = Vector2(targetPos.x, maxPosY)
  end
  if math.abs(targetPos.y - self.curScrollMoveTarget.y) < 0.1 then
    return
  end
  self:StopTween()
  self.curScrollMoveTarget = targetPos
  self.scrollMoveTween = self.scrollContent.transform:DOLocalMoveY(self.curScrollMoveTarget.y, 0.5)
end

function ActLotteryDraw100ResultView:StopTween()
  if not self.scrollMoveTween then
    return
  end
  self.scrollMoveTween:Kill()
  self.scrollMoveTween = nil
end

function ActLotteryDraw100ResultView:GetAllHeroCardScreenPos()
  if not self.heroRowContent then
    return {}
  end
  return self.heroRowContent:GetAllHeroCardScreenPos()
end

local function RefreshMessageData(self, message)
  self.message = message
  self.activityId = self.message.activityId
  self.drawType = self.message.type
  self.lotteryData = self.message.recordArr
  self.activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if self.activityInfo == nil then
    return
  end
  self.activityDetailData = DataCenter.ActLotteryDataManager:GetActData(self.activityId)
  if self.activityDetailData == nil then
    return
  end
  self.activityTemp = DataCenter.ActLotteryDataManager:GetTempByActInfo(self.activityInfo)
  self.isSkip = DataCenter.ActLotteryDataManager:GetIsSkip()
end

ActLotteryDraw100ResultView.OnCreate = OnCreate
ActLotteryDraw100ResultView.OnDestroy = OnDestroy
ActLotteryDraw100ResultView.OnEnable = OnEnable
ActLotteryDraw100ResultView.OnDisable = OnDisable
ActLotteryDraw100ResultView.ComponentDefine = ComponentDefine
ActLotteryDraw100ResultView.ComponentDestroy = ComponentDestroy
ActLotteryDraw100ResultView.DataDefine = DataDefine
ActLotteryDraw100ResultView.DataDestroy = DataDestroy
ActLotteryDraw100ResultView.OnAddListener = OnAddListener
ActLotteryDraw100ResultView.OnRemoveListener = OnRemoveListener
ActLotteryDraw100ResultView.OnOpen = OnOpen
ActLotteryDraw100ResultView.OnHandleRecruitResponse = OnHandleRecruitResponse
ActLotteryDraw100ResultView.OnRefreshItems = OnRefreshItems
ActLotteryDraw100ResultView.RefreshMessageData = RefreshMessageData
return ActLotteryDraw100ResultView
