local base = UIBaseContainer
local LWUIQuestionnaireItemRender = BaseClass("LWUIQuestionnaireItemRender", base)
local UIPersonalArmsRewardTipView = require("UI.UIActivityPersonalArms.UIPersonalArmsRewardTip.View.UIPersonalArmsRewardTipView")
local rewardBtn_path = "RewardBtn"
local openRewardState_path = "OpenRewardState"
local nameText_path = "VerticalLayout/NameText"
local timeContent_path = "VerticalLayout/TimeContent"
local timeText_path = "VerticalLayout/TimeContent/TimeText"
local gotoBtn_path = "GotoBtn"
local gotoBtnText_path = "GotoBtn/tongyong_cfm_anniu_5/GoToBtnText"
local gotoRedDot_path = "GotoBtn/tongyong_cfm_anniu_5/GoToRedDot"
local receiveRewardAni_path = "RewardBtn/NoOpenRewardState"
local receiveRewardEffect_path = "RewardBtn/NoOpenRewardState/Eff_ui_wenjuanbaoxiang1"
local rewardRedDot_path = "RewardBtn/NoOpenRewardState/RewardRedDot"
local NoRewardImage_path = "NoRewardIcon"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.rewardBtn = self:AddComponent(UIButton, rewardBtn_path)
  self.openRewardState = self:AddComponent(UIBaseContainer, openRewardState_path)
  self.nameText = self:AddComponent(UIText, nameText_path)
  self.timeContent = self:AddComponent(UIBaseContainer, timeContent_path)
  self.timeText = self:AddComponent(UIText, timeText_path)
  self.gotoBtn = self:AddComponent(UIButton, gotoBtn_path)
  self.gotoBtnText = self:AddComponent(UIText, gotoBtnText_path)
  self.gotoRedDot = self:AddComponent(UIBaseContainer, gotoRedDot_path)
  self.receiveRewardAni = self:AddComponent(UIAnimator, receiveRewardAni_path)
  self.receiveRewardEffect = self:AddComponent(UIBaseContainer, receiveRewardEffect_path)
  self.rewardRedDot = self:AddComponent(UIBaseContainer, rewardRedDot_path)
  self.NoRewardImage = self:AddComponent(UIImage, NoRewardImage_path)
  self.gotoBtn:SetOnClick(function()
    self:GoToBtnClick()
  end)
  self.rewardBtn:SetOnClick(function()
    self:RewardBtnClick()
  end)
end

local function ComponentDestroy(self)
  self.rewardBtn = nil
  self.openRewardState = nil
  self.nameText = nil
  self.timeContent = nil
  self.timeText = nil
  self.gotoBtn = nil
  self.gotoBtnText = nil
  self.gotoRedDot = nil
  self.receiveRewardAni = nil
  self.receiveRewardEffect = nil
  self.rewardRedDot = nil
  self.NoRewardImage = nil
end

local function DataDefine(self)
  self.stayTime = LuaEntry.DataConfig:TryGetNum("wenjuan_stage_change", "k1") * 1000
  self.startDelay = false
  self.refreshOne = false
  self.refreshTwo = false
  self.refreshThree = false
end

local function DataDestroy(self)
  self.stayTime = 0
  self.startDelay = false
  self.refreshOne = nil
  self.refreshTwo = nil
  self.refreshThree = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.GoToQuestionnaireSuccess, self.OnGoToQuestionnaireSuccess)
  self:AddUIListener(EventId.ReceiveQuestionnaireRewardSuccess, self.OnReceiveQuestionnaireRewardSuccess)
  self:AddUIListener(EventId.RefreshActivityRedDot, self.OnRefreshActivityRedDot)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.GoToQuestionnaireSuccess, self.OnGoToQuestionnaireSuccess)
  self:RemoveUIListener(EventId.ReceiveQuestionnaireRewardSuccess, self.OnReceiveQuestionnaireRewardSuccess)
  self:RemoveUIListener(EventId.RefreshActivityRedDot, self.OnRefreshActivityRedDot)
  base.OnRemoveListener(self)
end

local function OnGoToQuestionnaireSuccess(self, targetUuid)
  if self.uuid == targetUuid then
    self.startDelay = true
  end
end

local function OnReceiveQuestionnaireRewardSuccess(self, targetUuid)
  if self.uuid == targetUuid then
    self:RefreshRewardStatus()
  end
end

local function OnRefreshActivityRedDot(self)
  self:RefreshGoToRedDotStatus()
end

local function Update1000MS(self)
  if self.questionnaireInfo == nil then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.questionnaireInfo.type == QuestionnaireType.LimitedTime then
    local surplusTime = self.questionnaireInfo.endTime - curTime
    self.timeText:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(surplusTime))
    if surplusTime <= 0 and self.refreshOne == false then
      DataCenter.LWQuestionnaireManager:SetOneQuestionnaireRedDotMark(self.uuid)
      self.startDelay = false
      self.refreshOne = true
      EventManager:GetInstance():Broadcast(EventId.RefreshCanShowQuestionnaireList)
    end
  elseif self.questionnaireInfo.type == QuestionnaireType.Permanent then
    if self.questionnaireInfo:IsInvalid() and self.refreshTwo == false then
      DataCenter.LWQuestionnaireManager:SetOneQuestionnaireRedDotMark(self.uuid)
      self.startDelay = false
      self.refreshTwo = true
      EventManager:GetInstance():Broadcast(EventId.RefreshCanShowQuestionnaireList)
    end
  elseif self.questionnaireInfo.type == QuestionnaireType.Return and self.questionnaireInfo:IsInvalid() and self.refreshThree == false then
    DataCenter.LWQuestionnaireManager:SetOneQuestionnaireRedDotMark(self.uuid)
    self.startDelay = false
    self.refreshThree = true
    EventManager:GetInstance():Broadcast(EventId.RefreshCanShowQuestionnaireList)
    EventManager:GetInstance():Broadcast(EventId.QuestionnaireDataMainUIRefresh)
  end
  if self.startDelay then
    local surplusTime = curTime - self.questionnaireInfo.firstEnterQuestionnaireTime
    if surplusTime >= self.stayTime then
      self.startDelay = false
      self:RefreshRewardStatus()
      self:RefreshGoToBtnStatus()
    end
  end
end

local function SetData(self, targetUuid)
  self.uuid = targetUuid
  self.questionnaireInfo = DataCenter.LWQuestionnaireManager:GetQuestionnaireInfoByUuid(self.uuid)
  if self.questionnaireInfo == nil then
    Logger.LogError("\230\178\161\230\156\137\230\139\191\229\136\176uuid\228\184\186: " .. tostring(self.uuid) .. " \231\154\132\233\151\174\229\141\183\232\175\166\231\187\134\228\191\161\230\129\175\230\149\176\230\141\174")
  end
  self.nameText:SetText(self.questionnaireInfo.title)
  self.timeContent:SetActive(self.questionnaireInfo.type == QuestionnaireType.LimitedTime)
  self:Update1000MS()
  self:RefreshRewardStatus()
  self:RefreshGoToBtnStatus()
  self:RefreshGoToRedDotStatus()
end

local function RefreshGoToBtnStatus(self)
  if self.questionnaireInfo ~= nil then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if curTime >= self.questionnaireInfo.firstEnterQuestionnaireTime and self.questionnaireInfo.firstEnterQuestionnaireTime ~= 0 then
      self.gotoBtnText:SetLocalText("wenjuan_04")
    else
      self.gotoBtnText:SetLocalText("wenjuan_03")
    end
  end
end

local function RefreshRewardStatus(self)
  if self.questionnaireInfo.reward and #self.questionnaireInfo.reward > 0 then
    self.NoRewardImage:SetActive(false)
    self.openRewardState:SetActive(self.questionnaireInfo.status == QuestionnaireRewardStatus.AlreadyReceive)
    self.rewardBtn:SetActive(self.questionnaireInfo.status ~= QuestionnaireRewardStatus.AlreadyReceive)
    self:RefreshRewardRedDotStatus()
  else
    self.openRewardState:SetActive(false)
    self.rewardBtn:SetActive(false)
    self.NoRewardImage:SetActive(true)
  end
end

local function RefreshRewardRedDotStatus(self)
  local hasRedDot = self.questionnaireInfo:HasRewardRedDot()
  self.receiveRewardEffect:SetActive(hasRedDot)
  self.rewardRedDot:SetActive(hasRedDot)
  if hasRedDot then
    self.receiveRewardAni:Play("Eff_ui_wenjuanbaoxiang01", 0, 0)
  else
    self.receiveRewardAni:Play("New State")
  end
end

local function RefreshGoToRedDotStatus(self)
  local hasRedDot = self.questionnaireInfo:HasGoToRedDot()
  self.gotoRedDot:SetActive(hasRedDot)
end

local function GoToBtnClick(self)
  if self.questionnaireInfo.firstEnterQuestionnaireTime == 0 then
    DataCenter.LWQuestionnaireManager:SendMsgInquiryGoTo(self.uuid)
  end
  local url = CommonUtil.ParseQuestionnaireURL(self.questionnaireInfo.jumpURL)
  CS.SDKManager.OpenURL(url)
end

local function RewardBtnClick(self)
  if self.questionnaireInfo.status == QuestionnaireRewardStatus.NotAvailable then
    local showRewardList = self.questionnaireInfo:GetShowRewardList()
    if showRewardList ~= nil then
      local tipParam = UIPersonalArmsRewardTipView.ParamDataClass.New()
      tipParam.position = self.rewardBtn.transform.position
      tipParam.dir = UIPersonalArmsRewardTipView.Direction.LEFT
      tipParam.deltaX = 56
      tipParam.rewardList = showRewardList
      tipParam.closePassClick = true
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIPersonalArmsRewardTip, {anim = false}, tipParam)
    end
  elseif self.questionnaireInfo.status == QuestionnaireRewardStatus.CanReceive then
    DataCenter.LWQuestionnaireManager:SendMsgInquiryReward(self.uuid)
  end
end

LWUIQuestionnaireItemRender.OnCreate = OnCreate
LWUIQuestionnaireItemRender.OnDestroy = OnDestroy
LWUIQuestionnaireItemRender.OnEnable = OnEnable
LWUIQuestionnaireItemRender.OnDisable = OnDisable
LWUIQuestionnaireItemRender.ComponentDefine = ComponentDefine
LWUIQuestionnaireItemRender.ComponentDestroy = ComponentDestroy
LWUIQuestionnaireItemRender.DataDefine = DataDefine
LWUIQuestionnaireItemRender.DataDestroy = DataDestroy
LWUIQuestionnaireItemRender.SetData = SetData
LWUIQuestionnaireItemRender.Update1000MS = Update1000MS
LWUIQuestionnaireItemRender.RefreshGoToBtnStatus = RefreshGoToBtnStatus
LWUIQuestionnaireItemRender.RefreshRewardStatus = RefreshRewardStatus
LWUIQuestionnaireItemRender.OnGoToQuestionnaireSuccess = OnGoToQuestionnaireSuccess
LWUIQuestionnaireItemRender.OnReceiveQuestionnaireRewardSuccess = OnReceiveQuestionnaireRewardSuccess
LWUIQuestionnaireItemRender.OnRefreshActivityRedDot = OnRefreshActivityRedDot
LWUIQuestionnaireItemRender.RefreshGoToRedDotStatus = RefreshGoToRedDotStatus
LWUIQuestionnaireItemRender.RefreshRewardRedDotStatus = RefreshRewardRedDotStatus
LWUIQuestionnaireItemRender.GoToBtnClick = GoToBtnClick
LWUIQuestionnaireItemRender.RewardBtnClick = RewardBtnClick
LWUIQuestionnaireItemRender.OnAddListener = OnAddListener
LWUIQuestionnaireItemRender.OnRemoveListener = OnRemoveListener
return LWUIQuestionnaireItemRender
