local UILWAllianceFirstJoinView = BaseClass("UILWAllianceFirstJoinView", UIBaseView)
local base = UIBaseView
local list_btn_path = "Root/Content/ContentJoinHolder/BottomBtns/ListBtn"
local create_btn_path = "Root/Content/ContentJoinHolder/BottomBtns/CreateBtn"
local join_btn_path = "Root/Content/ContentJoinHolder/BottomBtns/JoinBtn"
local panel_path = "Panel"
local AlPostEventLog = require("DataCenter.AllianceData.AlliancePostEventLog")
local Localization = CS.GameEntry.Localization
local UIAllianceInfoPanel = require("UI.UIAlliance.UIAllianceInfo.Component.UIAllianceInfoPanel")

function UILWAllianceFirstJoinView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  EventManager:GetInstance():Broadcast(EventId.UILWAllianceFirstJoinOpen)
  SFSNetwork.SendMessage(MsgDefines.AllianceRecommendGetRecommendAllianceInfo)
  self:InitPanelInAnim()
  AlPostEventLog.PostEventLog_FirstJoin_Action(AlPostEventLog.FirstJoinAction.Open)
end

function UILWAllianceFirstJoinView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWAllianceFirstJoinView:ComponentDefine()
  self.list_btn = self:AddComponent(UIButton, list_btn_path)
  self.list_btn:SetOnClick(function()
    local params = self.param
    params.showJoin = true
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlCreateJoin, {anim = true}, params)
    self.ctrl:CloseSelf()
    AlPostEventLog.PostEventLog_FirstJoin_Action(AlPostEventLog.FirstJoinAction.List)
  end)
  self.create_btn = self:AddComponent(UIButton, create_btn_path)
  self.create_btn:SetOnClick(function()
    self:OnCreateClick()
    AlPostEventLog.PostEventLog_FirstJoin_Action(AlPostEventLog.FirstJoinAction.Creat)
  end)
  self.join_btn = self:AddComponent(UIButton, join_btn_path)
  self.join_btn:SetOnClick(function()
    self:OnFastJoinClick()
    AlPostEventLog.PostEventLog_FirstJoin_Action(AlPostEventLog.FirstJoinAction.Join)
  end)
  self.panel = self:AddComponent(UIButton, panel_path)
  self.panel:SetOnClick(BindCallback(self, self.OnCloseClick))
  self.anim = self:AddComponent(UIAnimator, "")
  self.canvasGroup = self.transform.gameObject:GetComponent(typeof(CS.UnityEngine.CanvasGroup))
  DataCenter.LWSoundManager:PlaySound(80009, false)
  self.textTitle = self:AddComponent(UIText, "Root/Content/TitleTxt")
  self.rewardBubbleBtn = self:AddComponent(UIButton, "Root/Content/ContentJoinHolder/RewardBubble")
  self.giftBubbleBtn = self:AddComponent(UIButton, "Root/Content/ContentJoinHolder/GiftBubble")
  self.helpBubbleBtn = self:AddComponent(UIButton, "Root/Content/ContentJoinHolder/HelpBubble")
  self.textCreateTip = self:AddComponent(UIText, "Root/Content/ContentJoinHolder/InfoBg/InnerBg/CreateTipText")
  self.compAllianceItem = self:AddComponent(UIAllianceInfoPanel, "Root/Content/ContentJoinHolder/InfoBg/InnerBg/AllianceItem")
  self.btnRefresh = self:AddComponent(UIButton, "Root/Content/ContentJoinHolder/InfoBg/InnerBg/AllianceItem/RefreshBtn")
  self.btnRefresh:SetOnClick(function()
    self:OnRefreshBtnClick()
  end)
  self.textCreateTip:SetLocalText("alliance_firstJoin_desc2")
  self.rewardBubbleBtn:SetOnClick(function()
    self:OnClickRewardBubbleBtn()
  end)
  self.giftBubbleBtn:SetOnClick(function()
    UIUtil.ShowBubbleTips(Localization:GetString("alliance_firstJoin_gift"), self.giftBubbleBtn.transform.position, 0, -50, 0)
  end)
  self.helpBubbleBtn:SetOnClick(function()
    UIUtil.ShowBubbleTips(Localization:GetString("alliance_firstJoin_help"), self.helpBubbleBtn.transform.position, 0, -50, 0)
  end)
  self.infoBgCanvasGroup = self:AddComponent(UICanvasGroup, "Root/Content/ContentJoinHolder/InfoBg/InnerBg")
  self.infoBgCanvasGroup:SetAlpha(1)
end

function UILWAllianceFirstJoinView:ComponentDestroy()
  self.list_btn = nil
  self.join_btn = nil
  self.create_btn = nil
  self.panel = nil
  self.anim = nil
  self.canvasGroup = nil
  if self.inTimer then
    self.inTimer:Stop()
    self.inTimer = nil
  end
  if self.delayBg1Timer then
    self.delayBg1Timer:Stop()
    self.delayBg1Timer = nil
  end
  if self.delayBg2Timer then
    self.delayBg2Timer:Stop()
    self.delayBg2Timer = nil
  end
  self.textTitle = nil
  self.rewardBubbleBtn = nil
  self.giftBubbleBtn = nil
  self.helpBubbleBtn = nil
  self.textCreateTip = nil
  self.compAllianceItem = nil
  self.btnRefresh = nil
end

function UILWAllianceFirstJoinView:DataDefine()
  self.model = {}
  self.param = self:GetUserData() or {}
  self.dataList = {}
  self.selectParam = nil
  self.selectIndex = 1
  self.rewardBubbleData = nil
  self.inFade = false
  self:ReInit()
end

function UILWAllianceFirstJoinView:DataDestroy()
  self.param = nil
  self.dataList = nil
  self.selectParam = nil
  self.selectIndex = nil
  self.rewardBubbleData = nil
  self:ClearTween()
end

function UILWAllianceFirstJoinView:OnEnable()
  base.OnEnable(self)
end

function UILWAllianceFirstJoinView:OnDisable()
  base.OnDisable(self)
end

function UILWAllianceFirstJoinView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.AllianceApplySuccess, self.OnJoinAlSuccessBack)
  self:AddUIListener(EventId.AllianceRecommendGetRecommendAllianceInfo, self.OnAllianceRecommendGetRecommendAllianceInfo)
end

function UILWAllianceFirstJoinView:OnRemoveListener()
  self:RemoveUIListener(EventId.AllianceApplySuccess, self.OnJoinAlSuccessBack)
  self:RemoveUIListener(EventId.AllianceRecommendGetRecommendAllianceInfo, self.OnAllianceRecommendGetRecommendAllianceInfo)
  base.OnRemoveListener(self)
end

function UILWAllianceFirstJoinView:OnJoinAlSuccessBack()
  if self.param.al_success_callback then
    self.param.al_success_callback()
  else
    self.ctrl:CloseSelf()
  end
end

function UILWAllianceFirstJoinView:ReInit()
  self.selectParam = self.dataList and self.dataList[self.selectIndex]
  if self.selectParam then
    self.textCreateTip:SetActive(false)
    self.compAllianceItem:SetActive(true)
    self.create_btn:SetActive(false)
    self.join_btn:SetActive(true)
    self.textTitle:SetLocalText("alliance_firstJoin_title")
    self.compAllianceItem:Refresh(self.selectParam)
  else
    self.textCreateTip:SetActive(true)
    self.compAllianceItem:SetActive(false)
    self.create_btn:SetActive(true)
    self.join_btn:SetActive(false)
    self.textTitle:SetLocalText("alliance_firstJoin_title2")
  end
end

function UILWAllianceFirstJoinView:OnFastJoinClick()
  if self.selectParam == nil then
    UIUtil.ShowTipsId(455100)
  else
    SFSNetwork.SendMessage(MsgDefines.AlApply, self.selectParam.allianceId, 0, self.selectParam.language)
  end
end

function UILWAllianceFirstJoinView:OnCreateClick()
  local isFreeCreate = UIUtil.IsFreeCreateAllianceInOpenServerTime()
  if isFreeCreate then
    local param = {}
    param.chooseLeader = 1
    param.status = 2
    param.isRecommendNew = true
    SFSNetwork.SendMessage(MsgDefines.FirstJoinAlliance, param)
  else
    local params = self.param
    params.showJoin = false
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlCreateJoin, {anim = true}, params)
    self.ctrl:CloseSelf()
  end
end

local function InitPanelInAnim(self)
  if self.anim then
    if self.canvasGroup then
      self.canvasGroup.interactable = false
    end
    self.inTimer = TimerManager:GetInstance():DelayInvoke(function()
      if self.inTimer then
        self.inTimer:Stop()
        self.inTimer = nil
      end
      self.canvasGroup.interactable = true
    end, 1.35)
  end
end

local function PlayPanelAnim(self, animName, duration, loop, callback)
  if self.anim then
    self.anim.enabled = true
    self.anim.speed = 1
    self.anim:Play(animName, 0, 0)
    self.anim.speed = 0
    if loop then
      return
    end
    TimerManager:GetInstance():DelayInvoke(function()
      if self.anim then
        self.anim.enabled = false
      end
      if callback then
        callback()
      end
    end, duration or 0)
  end
end

local function OnCloseClick(self)
  if self.canvasGroup then
    self.canvasGroup.interactable = false
  end
  self:PlayPanelAnim("UILWAllianceFirstJoinOut", 0.33, false, function()
    if self.param and self.param.al_lose_callback then
      self.param.al_lose_callback()
    end
    if self.ctrl then
      self.ctrl:CloseSelf()
    end
  end)
  AlPostEventLog.PostEventLog_FirstJoin_Action(AlPostEventLog.FirstJoinAction.Close)
end

function UILWAllianceFirstJoinView:OnRefreshBtnClick()
  if self.dataList and #self.dataList > 0 then
    if self.inFade then
      return
    end
    self:ClearTween()
    self.inFade = true
    self.tweenSequence = CS.DG.Tweening.DOTween.Sequence()
    self.tweenSequence:Append(self.infoBgCanvasGroup:FadeOut(0.3))
    self.tweenSequence:AppendCallback(function()
      self.selectIndex = self.selectIndex + 1
      if self.selectIndex > #self.dataList then
        self.selectIndex = 1
      end
      self:ReInit()
    end)
    self.tweenSequence:Append(self.infoBgCanvasGroup:FadeIn(0.3))
    self.tweenSequence:AppendCallback(function()
      self.inFade = false
    end)
  end
end

function UILWAllianceFirstJoinView:ClearTween()
  if self.tweenSequence then
    self.tweenSequence:Kill()
    self.tweenSequence = nil
  end
  self.inFade = false
  if self.infoBgCanvasGroup then
    self.infoBgCanvasGroup:SetAlpha(1)
  end
end

function UILWAllianceFirstJoinView:OnAllianceRecommendGetRecommendAllianceInfo(msg)
  self.dataList = self.ctrl:ParseMsg(msg)
  self.selectIndex = 1
  self:ReInit()
end

function UILWAllianceFirstJoinView:OnClickRewardBubbleBtn()
  if self.rewardBubbleData == nil then
    local rewardStr = LuaEntry.DataConfig:TryGetStr("first_join_alliance_reward", "k1")
    local rewardStrVec = string.split_ss_array(rewardStr, "|")
    self.rewardBubbleData = {}
    table.walk(rewardStrVec, function(k, v)
      local str = v
      local item = DataCenter.RewardManager:ParseOneRewardStr(str)
      if item then
        table.insert(self.rewardBubbleData, item)
      end
    end)
  end
  local param = {}
  param.width = 445
  param.alignObject = self.rewardBubbleBtn.transform
  param.yPosFix = -50
  param.xPadding = 50
  param.showArrow = true
  param.showRewardList = self.rewardBubbleData
  param.tipsText = Localization:GetString("alliance_firstJoin_reward")
  param.scrollHeight = 400
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIRewardPreviewTip, {anim = true}, param)
end

UILWAllianceFirstJoinView.InitPanelInAnim = InitPanelInAnim
UILWAllianceFirstJoinView.PlayPanelAnim = PlayPanelAnim
UILWAllianceFirstJoinView.OnCloseClick = OnCloseClick
return UILWAllianceFirstJoinView
