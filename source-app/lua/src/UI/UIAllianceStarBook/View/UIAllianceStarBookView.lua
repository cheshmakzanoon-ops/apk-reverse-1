local UIAllianceStarBookView = BaseClass("UIAllianceStarBookView", UIBaseView)
local UIAllianceStarBookWinnerPanel = require("UI.UIAllianceStarBook.Component.UIAllianceStarBookWinnerPanel")
local UIAllianceStarBookSessionPanel = require("UI.UIAllianceStarBook.Component.UIAllianceStarBookSessionPanel")
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local fade1Time = 0.3
local wait1Time = 0.3
local fade2Time = 0.3

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
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
  self.compWinnerPanel = self:AddComponent(UIAllianceStarBookWinnerPanel, "Bg/WinnerPanel")
  self.imgLine1 = self:AddComponent(UIImage, "Bg/WinnerPanel/Line1")
  self.imgLine2 = self:AddComponent(UIImage, "Bg/WinnerPanel/Line2")
  self.compSessionPanel = self:AddComponent(UIAllianceStarBookSessionPanel, "Bg/SessionPanel")
  self.btnBack = self:AddComponent(UIButton, "Bg/BackBtn")
  self.btnBack:SetOnClick(function()
    self:OnBtnBackClick()
  end)
  self.bg2 = self:AddComponent(UIBaseContainer, "Bg2")
  self.anim = self:AddComponent(UIAnimator, "")
  self.winnerCanvas = self:AddComponent(UICanvasGroup, "Bg/WinnerPanel")
  self.sessionCanvas = self:AddComponent(UICanvasGroup, "Bg/SessionPanel")
  self.winnerCanvas:SetActive(true)
  self.sessionCanvas:SetActive(true)
  self.winnerCanvas:SetAlpha(1)
  self.sessionCanvas:SetAlpha(0)
  self.winnerCanvas:SetBlocksRaycasts(false)
  self.sessionCanvas:SetBlocksRaycasts(false)
  self.flagIcon = self:AddComponent(UIImage, "Bg2/node_information/FlagIcon")
  self.attrName1 = self:AddComponent(UIText, "Bg2/node_information/AttrName1")
  self.attrName2 = self:AddComponent(UIText, "Bg2/node_information/AttrName2")
  local alData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
  if alData then
    self.flagIcon:SetActive(true)
    self.attrName1:SetActive(true)
    self.attrName2:SetActive(true)
    self.flagIcon:LoadSprite(string.format(AL_FLAG_SPRITE_PATH, alData.icon))
    self.attrName1:SetText("[" .. alData.abbr .. "]")
    self.attrName2:SetText(alData.allianceName)
  else
    self.flagIcon:SetActive(false)
    self.attrName1:SetActive(false)
    self.attrName2:SetActive(false)
  end
  if CommonUtil.IsArabicAutoMirrorOpen() then
    self.winnerCanvas:SetAnchoredPositionXY(42, 0)
    self.sessionCanvas:SetAnchoredPositionXY(42, 0)
  end
end

local function ComponentDestroy(self)
  self.textTitle = nil
  self.textTime = nil
  self.compWinnerPanel = nil
  self.imgLine1 = nil
  self.imgLine2 = nil
  self.compSessionPanel = nil
  self.btnBack = nil
  self.winnerCanvas = nil
  self.sessionCanvas = nil
end

local function DataDefine(self)
  self.active = true
  self.showHistoryInfoGetAnim = false
  SFSNetwork.SendMessage(MsgDefines.AllianceStartHistoryPreviewInfo)
  self:ShowEnterAnim()
end

local function DataDestroy(self)
  if self.backTimer then
    self.backTimer:Stop()
    self.backTimer = nil
  end
  if self.enterTimer then
    self.enterTimer:Stop()
    self.enterTimer = nil
  end
  self.active = false
  self.showHistoryInfoGetAnim = false
  self.animTween = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.AllianceStarHistoryPreviewInfoGet, self.OnAllianceStarHistoryPreviewInfoGet)
  self:AddUIListener(EventId.AllianceStarHistoryInfoGet, self.OnAllianceStarHistoryInfoGet)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.AllianceStarHistoryPreviewInfoGet, self.OnAllianceStarHistoryPreviewInfoGet)
  self:RemoveUIListener(EventId.AllianceStarHistoryInfoGet, self.OnAllianceStarHistoryInfoGet)
  base.OnRemoveListener(self)
end

local function OnBtnBackClick(self)
  if self.animTween then
    self.animTween:Kill()
    self.animTween = nil
  end
  self.winnerCanvas:SetBlocksRaycasts(false)
  self.sessionCanvas:SetBlocksRaycasts(false)
  local _, duration = self.anim:PlayAnimationReturnTime("V_ui_UIAllianceStarBook_out")
  self.backTimer = TimerManager:GetInstance():DelayInvoke(function()
    if self.active then
      self.ctrl:CloseSelf()
    end
  end, duration)
end

local function ShowEnterAnim(self)
  local _, duration = self.anim:PlayAnimationReturnTime("V_ui_UIAllianceStarBook_in")
  self.enterTimer = TimerManager:GetInstance():DelayInvoke(function()
    if self.active then
      self.winnerCanvas:SetAlpha(1)
      self.sessionCanvas:SetAlpha(0)
      self.winnerCanvas:SetBlocksRaycasts(true)
      self.sessionCanvas:SetBlocksRaycasts(false)
    end
  end, duration)
end

local function OnAllianceStarHistoryPreviewInfoGet(self)
  self.historyInfoList = DataCenter.AllianceStarManager.historyInfoList
  if self.historyInfoList and #self.historyInfoList > 0 then
    SFSNetwork.SendMessage(MsgDefines.AllianceStarHistoryInfo, self.historyInfoList[#self.historyInfoList].ceremonyEdition)
  end
end

local function OnAllianceStarHistoryInfoGet(self, ceremonyEdition)
  if self.showHistoryInfoGetAnim then
    self:ShowSessionToWinnerAnim(ceremonyEdition)
  else
    self.winnerCanvas:SetAlpha(1)
    self.sessionCanvas:SetAlpha(0)
    self.compWinnerPanel:Refresh(ceremonyEdition)
  end
end

local function ShowWinnerPanelChangeAnim(self, ceremonyEdition, pageNum, isLeft)
  if isLeft then
    self.anim:PlayAnimationReturnTime("V_ui_UIAllianceStarBook_flip_right")
  else
    self.anim:PlayAnimationReturnTime("V_ui_UIAllianceStarBook_flip_left")
  end
  self.winnerCanvas:SetAlpha(1)
  self.sessionCanvas:SetAlpha(0)
  self.winnerCanvas:SetBlocksRaycasts(false)
  self.sessionCanvas:SetBlocksRaycasts(false)
  if self.animTween then
    self.animTween:Kill()
  end
  local sequence = DOTween.Sequence()
  sequence:Append(self.winnerCanvas.unity_canvas_group:DOFade(0, fade1Time))
  sequence:AppendInterval(wait1Time)
  sequence:AppendCallback(function()
    self.compWinnerPanel:Refresh(ceremonyEdition, pageNum)
  end)
  sequence:Append(self.winnerCanvas.unity_canvas_group:DOFade(1, fade2Time))
  sequence:AppendCallback(function()
    self.winnerCanvas:SetBlocksRaycasts(true)
  end)
  self.animTween = sequence
end

local function ShowSessionPanelChangeAnim(self, pageNum, isLeft)
  if isLeft then
    self.anim:PlayAnimationReturnTime("V_ui_UIAllianceStarBook_flip_right")
  else
    self.anim:PlayAnimationReturnTime("V_ui_UIAllianceStarBook_flip_left")
  end
  self.winnerCanvas:SetAlpha(0)
  self.sessionCanvas:SetAlpha(1)
  self.winnerCanvas:SetBlocksRaycasts(false)
  self.sessionCanvas:SetBlocksRaycasts(false)
  if self.animTween then
    self.animTween:Kill()
  end
  local sequence = DOTween.Sequence()
  sequence:Append(self.sessionCanvas.unity_canvas_group:DOFade(0, fade1Time))
  sequence:AppendInterval(wait1Time)
  sequence:AppendCallback(function()
    self.compSessionPanel:Refresh(pageNum)
  end)
  sequence:Append(self.sessionCanvas.unity_canvas_group:DOFade(1, fade2Time))
  sequence:AppendCallback(function()
    self.sessionCanvas:SetBlocksRaycasts(true)
  end)
  self.animTween = sequence
end

local function ShowWinnerToSessionAnim(self)
  if CommonUtil.IsArabicAutoMirrorOpen() then
    self.anim:PlayAnimationReturnTime("V_ui_UIAllianceStarBook_flip_left")
  else
    self.anim:PlayAnimationReturnTime("V_ui_UIAllianceStarBook_flip_right")
  end
  self.winnerCanvas:SetAlpha(1)
  self.sessionCanvas:SetAlpha(0)
  self.winnerCanvas:SetBlocksRaycasts(false)
  self.sessionCanvas:SetBlocksRaycasts(false)
  if self.animTween then
    self.animTween:Kill()
  end
  local sequence = DOTween.Sequence()
  sequence:Append(self.winnerCanvas.unity_canvas_group:DOFade(0, fade1Time))
  sequence:AppendInterval(wait1Time)
  sequence:AppendCallback(function()
    self.compSessionPanel:Refresh()
  end)
  sequence:Append(self.sessionCanvas.unity_canvas_group:DOFade(1, fade2Time))
  sequence:AppendCallback(function()
    self.sessionCanvas:SetBlocksRaycasts(true)
  end)
  self.animTween = sequence
end

local function TryShowSessionToWinnerAnim(self, ceremonyEdition)
  if self.historyInfoList and self.historyInfoList[ceremonyEdition] and self.historyInfoList[ceremonyEdition].detailData then
    self:ShowSessionToWinnerAnim(ceremonyEdition)
  else
    self.showHistoryInfoGetAnim = true
    SFSNetwork.SendMessage(MsgDefines.AllianceStarHistoryInfo, ceremonyEdition)
  end
end

local function ShowSessionToWinnerAnim(self, ceremonyEdition)
  if CommonUtil.IsArabicAutoMirrorOpen() then
    self.anim:PlayAnimationReturnTime("V_ui_UIAllianceStarBook_flip_right")
  else
    self.anim:PlayAnimationReturnTime("V_ui_UIAllianceStarBook_flip_left")
  end
  self.winnerCanvas:SetAlpha(0)
  self.sessionCanvas:SetAlpha(1)
  self.winnerCanvas:SetBlocksRaycasts(false)
  self.sessionCanvas:SetBlocksRaycasts(false)
  if self.animTween then
    self.animTween:Kill()
  end
  local sequence = DOTween.Sequence()
  sequence:Append(self.sessionCanvas.unity_canvas_group:DOFade(0, fade1Time))
  sequence:AppendInterval(wait1Time)
  sequence:AppendCallback(function()
    self.compWinnerPanel:Refresh(ceremonyEdition)
  end)
  sequence:Append(self.winnerCanvas.unity_canvas_group:DOFade(1, fade2Time))
  sequence:AppendCallback(function()
    self.winnerCanvas:SetBlocksRaycasts(true)
  end)
  self.animTween = sequence
end

UIAllianceStarBookView.OnCreate = OnCreate
UIAllianceStarBookView.OnDestroy = OnDestroy
UIAllianceStarBookView.OnEnable = OnEnable
UIAllianceStarBookView.OnDisable = OnDisable
UIAllianceStarBookView.ComponentDefine = ComponentDefine
UIAllianceStarBookView.ComponentDestroy = ComponentDestroy
UIAllianceStarBookView.DataDefine = DataDefine
UIAllianceStarBookView.DataDestroy = DataDestroy
UIAllianceStarBookView.OnAddListener = OnAddListener
UIAllianceStarBookView.OnRemoveListener = OnRemoveListener
UIAllianceStarBookView.OnBtnBackClick = OnBtnBackClick
UIAllianceStarBookView.ShowEnterAnim = ShowEnterAnim
UIAllianceStarBookView.OnAllianceStarHistoryPreviewInfoGet = OnAllianceStarHistoryPreviewInfoGet
UIAllianceStarBookView.OnAllianceStarHistoryInfoGet = OnAllianceStarHistoryInfoGet
UIAllianceStarBookView.ShowWinnerPanelChangeAnim = ShowWinnerPanelChangeAnim
UIAllianceStarBookView.ShowSessionPanelChangeAnim = ShowSessionPanelChangeAnim
UIAllianceStarBookView.ShowWinnerToSessionAnim = ShowWinnerToSessionAnim
UIAllianceStarBookView.TryShowSessionToWinnerAnim = TryShowSessionToWinnerAnim
UIAllianceStarBookView.ShowSessionToWinnerAnim = ShowSessionToWinnerAnim
return UIAllianceStarBookView
