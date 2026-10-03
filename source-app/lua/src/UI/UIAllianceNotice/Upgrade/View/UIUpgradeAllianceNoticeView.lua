local base = UIBaseView
local UIUpgradeAllianceNoticeView = BaseClass("UIUpgradeAllianceNoticeView", base)
local Localization = CS.GameEntry.Localization
local compBook = {
  {
    path = "curtain",
    name = "curtain",
    type = UIButton,
    onClick = function(self)
      self.ctrl:CloseSelf()
    end
  },
  {
    path = "panel/btnClose",
    name = "btnClose",
    type = UIButton,
    onClick = function(self)
      self.ctrl:CloseSelf()
    end
  },
  {
    path = "panel/txtTitle",
    name = "txtTitle",
    type = UIText,
    textKey = 100378
  },
  {
    path = "panel/txtDesc",
    name = "txtDesc",
    type = UIText,
    textKey = 2900006
  },
  {
    path = "panel/btnCancel",
    name = "btnCancel",
    type = UIButton,
    onClick = function(self)
      self.ctrl:CloseSelf()
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
    path = "panel/btnCancel/txtBtnCancel",
    name = "txtCancel",
    type = UIText,
    textKey = 110106
  },
  {
    path = "panel/btnAdvance/layout/txtBtnAdvance",
    name = "txtAdvance",
    type = UIText,
    textKey = 110006
  },
  {
    path = "panel/btnAdvance/disAdvance",
    name = "disAdvance",
    type = nil
  },
  {
    path = "panel/btnAdvance/layout/layoutCDTime",
    name = "layoutCD",
    type = nil
  },
  {
    path = "panel/btnAdvance/layout/layoutCDTime/txtCDTime",
    name = "txtCD",
    type = UIText
  },
  {
    path = "panel/txtAdvLimit",
    name = "txtAdvLimit",
    type = UIText
  }
}

function UIUpgradeAllianceNoticeView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:AddUIListener(EventId.ServerError, self.OnServerError)
  self:AddUIListener(EventId.AllianceNoticeUpdate, self.OnAllianceNoticeUpdate)
  self.__waiting_for_response = nil
  self.changeAlNoticeData = self:GetUserData()
  self:Show()
end

function UIUpgradeAllianceNoticeView:OnDestroy()
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
  self:RemoveUIListener(EventId.ServerError, self.OnServerError)
  self:RemoveUIListener(EventId.AllianceNoticeUpdate, self.OnAllianceNoticeUpdate)
  self:ComponentDestroy()
  base.OnDestroy(self)
  self.__waiting_for_response = nil
end

function UIUpgradeAllianceNoticeView:ComponentDefine()
  self:DefineCompsByBook(compBook)
end

function UIUpgradeAllianceNoticeView:ComponentDestroy()
  self:ClearCompsByBook(compBook)
end

function UIUpgradeAllianceNoticeView:RefreshTimer()
  local noticeData = DataCenter.AllianceNoticeManager.noticeData
  local serverTime = UITimeManager:GetInstance():GetServerTime()
  local targetTime = noticeData.lastAdvNoticeTime + 3600000
  local remainTime = targetTime - serverTime
  if remainTime <= 0 then
    self.txtCD:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(0))
    self:UpdateBtnsState()
    if self.timer then
      self.timer:Stop()
      self.timer = nil
    end
  else
    self.txtCD:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
  end
end

function UIUpgradeAllianceNoticeView:UpdateBtnsState(first)
  local noticeData = DataCenter.AllianceNoticeManager.noticeData
  local serverTime = UITimeManager:GetInstance():GetServerTime()
  local targetTime = noticeData.lastAdvNoticeTime + 3600000
  local cdOK = serverTime >= targetTime
  local timesOK = noticeData.restTimes > 0
  self.btnAdvance:SetInteractable(timesOK and cdOK)
  self.disAdvance:SetActive(not timesOK or not cdOK)
  self.txtAdvLimit:SetText(Localization:GetString(2000344, noticeData.restTimes))
  self.layoutCD:SetActive(not cdOK and timesOK)
  if not cdOK and first and not self.timer then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.RefreshTimer, self, false, false, false)
    self.timer:Start()
  end
end

function UIUpgradeAllianceNoticeView:Show()
  self:UpdateBtnsState(true)
  self:RefreshTimer()
  self:SetActive(true)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.txtCD.transform)
end

function UIUpgradeAllianceNoticeView:OnClickAdvance()
  if self.__waiting_for_response then
    return
  end
  local param = self:GetMsgParam()
  if not param then
    return
  end
  self.__waiting_for_response = true
  SFSNetwork.SendMessage(MsgDefines.AllianceChangeNotice, param)
end

function UIUpgradeAllianceNoticeView:GetMsgParam()
  local data, dataType, param
  if self.changeAlNoticeData ~= nil then
    data = self.changeAlNoticeData.data
    dataType = self.changeAlNoticeData.dataType
  else
    data = DataCenter.AllianceNoticeManager:GetTotalFristNotice()
    dataType = AlNoticeInputDataType.AllianceNoticeData
  end
  if data then
    if dataType == AlNoticeInputDataType.AllianceNoticeData then
      local noticeData = data
      local picVerIn, picSenderUidIn, smallHeightIn, smallWidthIn, bigHeightIn, bigWidthIn = noticeData:GetNoticePicData()
      param = {
        notice = noticeData.content,
        isAdv = 1,
        uid = noticeData.uid,
        isR4R5 = noticeData:GetIsR4R5() and 1 or 0,
        smallHeight = smallHeightIn,
        smallWidth = smallWidthIn,
        bigHeight = bigHeightIn,
        bigWidth = bigWidthIn,
        noticePicVer = picVerIn,
        picSenderUid = picSenderUidIn,
        extraJson = noticeData.extraJson,
        picJson = noticeData.picJson
      }
    elseif dataType == AlNoticeInputDataType.MsgParamTbl then
      local noticeData = data
      param = {
        notice = noticeData.notice,
        isAdv = 1,
        uid = noticeData.uid,
        publisherUid = noticeData.publisherUid,
        edited = noticeData.edited,
        isR4R5 = noticeData.isR4R5,
        extraJson = noticeData.extraJson,
        picJson = noticeData.picJson
      }
    end
  end
  return param
end

function UIUpgradeAllianceNoticeView:OnAllianceNoticeUpdate()
  self.__waiting_for_response = nil
  self.ctrl:CloseSelf()
end

function UIUpgradeAllianceNoticeView:OnServerError(msgName)
  if msgName == MsgDefines.AllianceChangeNotice then
    self.__waiting_for_response = nil
  end
end

return UIUpgradeAllianceNoticeView
