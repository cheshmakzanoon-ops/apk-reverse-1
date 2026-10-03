local AllianceNoticePopup = BaseClass("AllianceNoticePopup", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local compBook = {
  {
    path = "curtain",
    name = "curtain",
    type = UIButton,
    onClick = function(self)
      self:Close()
    end
  },
  {
    path = "panel/btnClose",
    name = "btnClose",
    type = UIButton,
    onClick = function(self)
      self:Close()
    end
  },
  {
    path = "panel/txtTitle",
    name = "txtTitle",
    type = UIText,
    textKey = 2900001
  },
  {
    path = "panel/btnNormal",
    name = "btnNormal",
    type = UIButton,
    onClick = function(self)
      self:OnClickNormal()
    end
  },
  {
    path = "panel/btnAdvance",
    name = "btnAdvance",
    type = UIButton,
    onClick = function(self)
      self:OnClickAdvance()
    end
  },
  {
    path = "panel/btnNormal/txtBtnNormal",
    name = "txtNormal",
    type = UIText,
    textKey = 2900003
  },
  {
    path = "panel/btnAdvance/layout/txtBtnAdvance",
    name = "txtAdvance",
    type = UIText,
    textKey = 2900004
  },
  {
    path = "panel/btnNormal/disNormal",
    name = "disNormal",
    type = UIGameObjectWrap
  },
  {
    path = "panel/btnAdvance/disAdvance",
    name = "disAdvance",
    type = UIGameObjectWrap
  },
  {
    path = "panel/btnAdvance/layout/layoutCDTime",
    name = "layoutCD",
    type = UIGameObjectWrap
  },
  {
    path = "panel/btnAdvance/layout/layoutCDTime/txtCDTime",
    name = "txtCD",
    type = UIText
  },
  {
    path = "panel/txtFree",
    name = "txtFree",
    type = UIText,
    textKey = 130126
  },
  {
    path = "panel/txtAdvLimit",
    name = "txtAdvLimit",
    type = UIText
  },
  {
    path = "panel/areaContent",
    name = "areaContent",
    type = nil
  },
  {
    path = "panel/areaContent/txtCharNum",
    name = "txtCharNum",
    type = UIText,
    text = "0/200"
  },
  {
    path = "panel/areaContent/InputField",
    name = "inputContent",
    type = UIInput
  },
  {
    path = "panel/areaContent/InputField/Placeholder",
    name = "placeholder",
    type = UIText,
    textKey = 2900002
  },
  {
    path = "panel/areaContent/scrollContent",
    name = "scrollContent",
    type = UIGameObjectWrap
  },
  {
    path = "panel/areaContent/scrollContent/Viewport/Content/txtContent",
    name = "txtContent",
    type = UIText,
    textKey = 2900002
  }
}

function AllianceNoticePopup:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:AddUIListener(EventId.ServerError, self.OnServerError)
  self:AddUIListener(EventId.AllianceNoticeUpdate, self.OnAllianceNoticeUpdate)
  self:AddUIListener(EventId.SCREEN_TOUCH_CLICK_IGNORE_UI, self.OnScreenTouch)
  self.__waiting_for_response = nil
end

function AllianceNoticePopup:OnDestroy()
  self:RemoveUIListener(EventId.ServerError, self.OnServerError)
  self:RemoveUIListener(EventId.AllianceNoticeUpdate, self.OnAllianceNoticeUpdate)
  self:RemoveUIListener(EventId.SCREEN_TOUCH_CLICK_IGNORE_UI, self.OnScreenTouch)
  self:ComponentDestroy()
  base.OnDestroy(self)
  self.__waiting_for_response = nil
end

function AllianceNoticePopup:ComponentDefine()
  self:DefineCompsByBook(compBook)
  self.inputContent:SetOnValueChange(function(text)
    self:OnInputContentChange(text)
  end)
  self.inputContent:SetOnEndEdit(function(text)
    self:SyncContentWithInput(text)
    self.scrollContent:SetActive(true)
    self.inputContent:SetActive(false)
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.txtContent.transform)
  end)
end

function AllianceNoticePopup:ComponentDestroy()
  self:ClearCompsByBook(compBook)
end

function AllianceNoticePopup:RefreshTimer()
  local noticeData = DataCenter.AllianceNoticeManager.noticeData
  local serverTime = UITimeManager:GetInstance():GetServerTime()
  local targetTime = noticeData.lastAdvNoticeTime + 3600000
  local remainTime = targetTime - serverTime
  if remainTime <= 0 then
    self.txtCD:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(0))
    self:UpdateBtnsState(self.inputContent:GetText())
    if self.timer then
      self.timer:Stop()
      self.timer = nil
    end
  else
    self.txtCD:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
  end
end

function AllianceNoticePopup:UpdateBtnsState(notice, first)
  local empty = string.IsNullOrEmpty(string.trim(notice))
  self.btnNormal:SetInteractable(not empty)
  self.disNormal:SetActive(empty)
  local noticeData = DataCenter.AllianceNoticeManager.noticeData
  local serverTime = UITimeManager:GetInstance():GetServerTime()
  local targetTime = noticeData.lastAdvNoticeTime + 3600000
  local cdOK = serverTime >= targetTime
  local timesOK = noticeData.restTimes > 0
  self.btnAdvance:SetInteractable(not empty and timesOK and cdOK)
  self.disAdvance:SetActive(empty or not timesOK or not cdOK)
  self.txtAdvLimit:SetText(Localization:GetString(2000344, noticeData.restTimes))
  self.layoutCD:SetActive(not cdOK and timesOK)
  if not cdOK and first and not self.timer then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.RefreshTimer, self, false, false, false)
    self.timer:Start()
  end
end

function AllianceNoticePopup:SyncContentWithInput(inputText)
  if 0 < #inputText then
    self.txtContent:SetText(inputText)
    self.txtContent:SetColorRGBA(0.1647059, 0.1568628, 0.1882353, 1)
  else
    self.txtContent:SetText(Localization:GetString(2900002))
    self.txtContent:SetColorRGBA(0.1960784, 0.1960784, 0.1960784, 0.5019608)
  end
end

function AllianceNoticePopup:Show()
  self.inputContent:SetText("")
  self:UpdateBtnsState("", true)
  self:SyncContentWithInput("")
  self:RefreshTimer()
  self:SetActive(true)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.txtCD.transform)
  self.inputContent:SetActive(false)
  EventManager:GetInstance():Broadcast(EventId.GF_window_opened, "AllianceNoticePopup")
end

function AllianceNoticePopup:Close()
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
  self:SetActive(false)
  EventManager:GetInstance():Broadcast(EventId.GF_window_closed, "AllianceNoticePopup")
end

function AllianceNoticePopup:OnClickNormal()
  if self.__waiting_for_response then
    return
  end
  local notice = self.inputContent:GetText()
  if string.IsNullOrEmpty(string.trim(notice)) then
    return
  end
  local param = {notice = notice, isAdv = 0}
  SFSNetwork.SendMessage(MsgDefines.AllianceChangeNotice, param)
  self.__waiting_for_response = true
end

function AllianceNoticePopup:OnClickAdvance()
  if self.__waiting_for_response then
    return
  end
  local notice = self.inputContent:GetText()
  if string.IsNullOrEmpty(string.trim(notice)) then
    return
  end
  UIUtil.ShowMessage(Localization:GetString("2900006"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
    local param = {notice = notice, isAdv = 1}
    SFSNetwork.SendMessage(MsgDefines.AllianceChangeNotice, param)
    self.__waiting_for_response = true
  end)
end

function AllianceNoticePopup:OnInputContentChange(text)
  self.txtCharNum:SetText(string.format("%d/%d", string.word_count(text), 200))
  self:UpdateBtnsState(text)
  self:SyncContentWithInput(text)
end

function AllianceNoticePopup:OnAllianceNoticeUpdate()
  self.__waiting_for_response = nil
  self:Close()
end

function AllianceNoticePopup:OnServerError(msgName)
  printError("BINGO:" .. msgName .. " vs " .. MsgDefines.AllianceChangeNotice)
  if msgName == MsgDefines.AllianceChangeNotice then
    self.__waiting_for_response = nil
  end
end

function AllianceNoticePopup:OnScreenTouch(touchInfo)
  if not self:GetActive() or self.inputContent:GetActive() then
    return
  end
  local touchPos = touchInfo.pointerPos
  local result = CS.UnityEngine.RectTransformUtility.RectangleContainsScreenPoint(self.areaContent.transform, touchPos, CS.GameEntry.UICamera)
  if result then
    self.scrollContent:SetActive(false)
    self.inputContent:SetActive(true)
    self.inputContent:Select()
  end
end

return AllianceNoticePopup
