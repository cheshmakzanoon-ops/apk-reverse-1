local base = UIBaseView
local UIChatReportView = BaseClass("UIChatReportView", base)
local ChatReportItem = require("UI.UIChatReport.Component.UIChatReportItem")
local title_path = "UICommonMidPopUpTitle/titleText"
local closeBtn_path = "UICommonMidPopUpTitle/CloseBtn"
local targetPlayerTxt_path = "ImgBg/nameLayout/txtTargetPlayer"
local playerName_path = "ImgBg/nameLayout/txtTargetPlayer/txtPlayerName"
local reasonTxt_path = "ImgBg/reason"
local input_path = "ImgBg/reasonIpt"
local reasonIptDefault_path = "ImgBg/reasonIpt/viewport/Placeholder"
local cancelBtn_path = "btnLayout/cancelBtn"
local cancelBtnTxt_path = "btnLayout/cancelBtn/cancelBtnTxt"
local confirmBtn_path = "btnLayout/confirmBtn"
local confirmBtnTxt_path = "btnLayout/confirmBtn/confirmBtnTxt"

function UIChatReportView:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
  self:Init()
  EventManager:GetInstance():Broadcast(EventId.ChatSendPhotoSetInputCtlState, false)
end

function UIChatReportView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  EventManager:GetInstance():Broadcast(EventId.ChatSendPhotoSetInputCtlState, true)
  base.OnDestroy(self)
end

function UIChatReportView:ComponentDefine()
  self.titleN = self:AddComponent(UIText, title_path)
  self.titleN:SetLocalText(208251)
  self.closeBtnN = self:AddComponent(UIButton, closeBtn_path)
  self.closeBtnN:SetOnClick(function()
    self:OnClickCloseBtn()
  end)
  self.targetPlayerTxtN = self:AddComponent(UIText, targetPlayerTxt_path)
  self.targetPlayerTxtN:SetText("")
  self.playerNameN = self:AddComponent(UIText, playerName_path)
  self.reasonTxtN = self:AddComponent(UIText, reasonTxt_path)
  self.reasonTxtN:SetLocalText(208253)
  self.contentItem = self.transform:Find("contentItem").gameObject
  self.contentItem:GameObjectCreatePool()
  self.choicesRoot = self:AddComponent(UIBaseContainer, "ImgBg/choices")
  self.contentRoot = self:AddComponent(UIBaseContainer, "ImgBg/contentRoot")
  self.reasonIptN = self:AddComponent(UIInput, input_path)
  self.reasonIptN:SetOnValueChange(function(value)
    self:OnInputValueChange(value)
    self:RefreshReportBtn()
  end)
  self.reasonIptDefaultN = self:AddComponent(UIText, reasonIptDefault_path)
  self.reasonIptDefaultN:SetLocalText(208249)
  self.cancelBtnN = self:AddComponent(UIButton, cancelBtn_path)
  self.btnLayout = self:AddComponent(UIBaseComponent, "btnLayout")
  self.cancelBtnN:SetOnClick(function()
    self:OnClickCancelBtn()
  end)
  self.cancelBtnTxtN = self:AddComponent(UIText, cancelBtnTxt_path)
  self.cancelBtnTxtN:SetLocalText(110106)
  self.confirmBtnN = self:AddComponent(UIButton, confirmBtn_path)
  self.panelBtn = self:AddComponent(UIButton, "UICommonMidPopUpTitle/panel")
  self.bgImg = self:AddComponent(UIImage, "UICommonMidPopUpTitle/Common_bg_orange")
  self.itemRoot = self:AddComponent(UIBaseContainer, "ImgBg")
  self.panelBtn:SetOnClick(function()
    self:OnClickCloseBtn()
  end)
  self.confirmBtnN:SetOnClick(function()
    self:OnClickConfirmBtn()
  end)
  self.inputMask = self:AddComponent(UIImage, "ImgBg/reasonIpt/inputMask")
  self.confirmBtnTxtN = self:AddComponent(UIText, confirmBtnTxt_path)
  self.confirmBtnTxtS = self:AddComponent(UIShadow, confirmBtnTxt_path)
  self.confirmBtnTxtN:SetLocalText(110006)
  self.reasonIptN:SetText("")
  self.inputMask:SetActive(false)
  self.reasonIptN:SetInteractable(true)
end

function UIChatReportView:ComponentDestroy()
  self:ClearAllItem()
  self.contentItem = nil
  self.titleN = nil
  self.closeBtnN = nil
  self.targetPlayerTxtN = nil
  self.playerNameN = nil
  self.choiceItemsTb = nil
  self.reasonIptN = nil
  self.reasonIptDefaultN = nil
  self.cancelBtnN = nil
  self.cancelBtnTxtN = nil
  self.confirmBtnN = nil
  self.confirmBtnTxtN = nil
  self.confirmBtnTxtS = nil
end

function UIChatReportView:DataDefine()
  self.chatData = nil
  self.roomData = nil
  self.curReportItem = nil
  self.contentCellList = {}
  self.choicesCellList = {}
  self.reTypeDic = {}
end

function UIChatReportView:DataDestroy()
  self.chatData = nil
  self.roomData = nil
  self.curReportItem = nil
  self.contentCellList = nil
  self.choicesCellList = nil
  self.reTypeDic = nil
end

function UIChatReportView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.GetNewUserInfoSucc, self.OnGetNewUserInfoSucc)
end

function UIChatReportView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.GetNewUserInfoSucc, self.OnGetNewUserInfoSucc)
end

function UIChatReportView:OnGetNewUserInfoSucc(uid)
  if uid == self.data.uid then
    local info = DataCenter.PlayerInfoDataManager:GetPlayerDataByUid(self.data.uid)
    if info then
      self.data.name = info.name
    end
    self:RefreshAll()
  end
end

function UIChatReportView:Init()
  self.data = self:GetUserData()
  if self.data and self.data.chatData and (self.data.chatData.post == PostType.FriendsCirleBodyHasIcon or self.data.chatData.post == PostType.FriendsCirleBody) then
    self.data.type = ReportType.FriendCircle
  end
  if self.data.type == ReportType.chat or self.data.type == ReportType.player or self.data.type == ReportType.chatPhoto or self.data.type == ReportType.FriendCircle or self.data.type == ReportType.FriendCircleMoment or self.data.type == ReportType.ActEasterEggOwner or self.data.type == ReportType.voiceRoom then
    self.chatData = self.data.chatData
  elseif self.data.type == ReportType.SeasonAlliancePhotoMessage then
  elseif self.data.type == ReportType.GroupChat then
    self.roomData = self.data.roomData
  end
  self:RefreshAll()
end

function UIChatReportView:RefreshAll()
  self.reportContentList = self.ctrl.GetReportContentCof(self.data)
  self.reportReasonList = self.ctrl.GetReportReasonCof()
  local name = ""
  if self.data.type == ReportType.GroupChat then
    name = self.ctrl.GetGroupChatName(self.data, self.roomData)
  else
    name = self.ctrl.GetPlayerName(self.data, self.chatData)
  end
  self.playerNameN:SetText(name)
  self:ClearAllItem()
  self:InitReportContentView()
  self:InitReason()
  self:RefreshReportBtn()
  self:UpdateViewLatyout()
end

function UIChatReportView:UpdateViewLatyout()
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.itemRoot.transform)
  local size = self.itemRoot:GetSizeDelta()
  local rootPosY = self.itemRoot:GetAnchoredPositionY()
  local posY = rootPosY - size.y - 5
  local bgImgSizeY = size.y + self.btnLayout:GetSizeDelta().y + 170
  if self.btnLayout then
    self.btnLayout:SetAnchoredPositionXY(self.btnLayout:GetAnchoredPositionX(), posY)
  end
  self.bgImg:SetSizeDeltaXY(self.bgImg:GetSizeDelta().x, bgImgSizeY)
end

function UIChatReportView:ClearAllItem()
  self.contentRoot:RemoveComponents(ChatReportItem)
  self.choicesRoot:RemoveComponents(ChatReportItem)
  self.contentItem.gameObject:GameObjectRecycleAll()
end

function UIChatReportView:InitReportContentView()
  for i = 1, #self.reportContentList do
    local item = self.contentItem:GameObjectSpawn(self.contentRoot.transform)
    item.name = "reportContentItem" .. i
    local obj = self.contentRoot:AddComponent(ChatReportItem, item.name)
    obj:SetActive(true)
    obj:SetItem(self.reportContentList[i])
    obj:SetType(SelectType.Radio)
    table.insert(self.contentCellList, obj)
  end
end

function UIChatReportView:InitReason()
  for i = 1, #self.reportReasonList do
    local item = self.contentItem:GameObjectSpawn(self.choicesRoot.transform)
    item.name = "reasonItem" .. i
    local obj = self.choicesRoot:AddComponent(ChatReportItem, item.name)
    obj:SetActive(true)
    obj:SetItem(self.reportReasonList[i])
    obj:SetType(SelectType.Multiple)
    table.insert(self.choicesCellList, obj)
  end
end

function UIChatReportView:UpdateAllGray()
  for i = 1, #self.choicesCellList do
    self.choicesCellList[i]:SetCanCilck(not self.allGray)
  end
end

function UIChatReportView:OnInputValueChange(value)
  self.reasonIptDefaultN:SetActive(value == "")
end

function UIChatReportView:RefreshReportBtn(value)
  if not self.curReportItem or table.count(self.reTypeDic) == 0 and not self.allGray then
    CS.UIGray.SetGray(self.confirmBtnN.transform, true, false)
    self.confirmBtnTxtS:SetAllColor(YellowBtnShadowGrayColor)
    self:UpdateAllGray()
    return
  end
  local isOther
  for typeCof, v in pairs(self.reTypeDic) do
    if typeCof == ChatReportType.Other then
      isOther = true
      break
    end
  end
  if isOther and not self.allGray then
    local extra = self.reasonIptN:GetText()
    if string.IsNullOrEmpty(extra) or string.IsNullOrEmpty(string.trim(extra)) then
      CS.UIGray.SetGray(self.confirmBtnN.transform, true, false)
      self.confirmBtnTxtS:SetAllColor(YellowBtnShadowGrayColor)
      self:UpdateAllGray()
      return
    end
  end
  CS.UIGray.SetGray(self.confirmBtnN.transform, false, true)
  self.confirmBtnTxtS:SetAllColor(YellowBtnShadowLightColor)
  self:UpdateAllGray()
end

function UIChatReportView:OnSelectOne(reportItem)
  if reportItem.selectType == SelectType.Radio then
    if self.curReportItem then
      self.curReportItem:SetSelected(false)
    end
    self.curReportItem = reportItem
    self.allGray = reportItem.reportConf.ReportType == ChatReportContent.chatTranslate
  else
    self.reTypeDic[reportItem.reportConf.ReportType] = reportItem.isOn or nil
  end
  self:RefreshReportBtn()
end

function UIChatReportView:OnClickCloseBtn()
  self.ctrl:CloseSelf()
end

function UIChatReportView:OnClickConfirmBtn()
  if not self.curReportItem then
    return
  end
  local extraNote = ""
  local isOther
  for typeCof, v in pairs(self.reTypeDic) do
    if typeCof == ChatReportType.Other then
      isOther = true
      break
    end
  end
  extraNote = self.reasonIptN:GetText()
  if isOther and string.IsNullOrEmpty(extraNote) then
    return
  end
  local cofType = self.curReportItem:GetReportConf().ReportType
  if cofType == ChatReportContent.chatTranslate then
    PostEventLog.Track(PostEventLog.Defines.TransLateContentError, {
      err_msg = tostring(self.chatData.msg),
      announce = tostring(self.chatData.translateMsg),
      battle_uuid = extraNote
    })
    UIUtil.ShowTipsId(280063)
    self.ctrl:CloseSelf()
    return
  end
  if self.data.type == ReportType.alliance then
    SFSNetwork.SendMessage(MsgDefines.AllianceReport, self.data.allianceId, cofType, self.reTypeDic, extraNote)
  elseif self.data.type == ReportType.championDuel then
    ChatManager2:GetInstance():ReqReportChat(self.data.uid, self.data.msg, cofType, self.reTypeDic, {
      extraType = ReportExtraType.championDuel
    }, nil, extraNote)
  elseif self.data.type == ReportType.chatPhoto then
    ChatManager2:GetInstance():ReportChat(self.chatData, ReportType.chatPhoto, self.reTypeDic, extraNote)
  elseif self.data.type == ReportType.actMigrate then
    ChatManager2:GetInstance():ReqReportChat(self.data.uid, self.data.msg, cofType, self.reTypeDic, {
      extraType = ReportExtraType.actMigrate
    }, nil, extraNote)
  elseif self.data.type == ReportType.actMigrateAlly then
    ChatManager2:GetInstance():ReqReportChat(self.data.uid, self.data.msg, cofType, self.reTypeDic, {
      extraType = ReportExtraType.actMigrateAlly
    }, nil, extraNote)
  elseif self.data.type == ReportType.actMigrateSNotice then
    ChatManager2:GetInstance():ReqReportChat(self.data.uid, self.data.msg, cofType, self.reTypeDic, {
      extraType = ReportExtraType.actMigrateSNotice
    }, nil, extraNote)
  elseif self.data.type == ReportType.mailR4 then
    ChatManager2:GetInstance():ReqReportChat(self.data.uid, "", cofType, self.reTypeDic, {
      groupMailId = self.data.groupMailId
    }, SafeLocalOsTime(), extraNote)
  elseif self.data.type == ReportType.mailPresident then
    ChatManager2:GetInstance():ReqReportChat(self.data.uid, "", cofType, self.reTypeDic, {
      groupMailId = self.data.groupMailId
    }, SafeLocalOsTime(), extraNote)
  elseif self.data.type == ReportType.allianceNotice then
    ChatManager2:GetInstance():ReqReportChat(self.data.uid, "", cofType, self.reTypeDic, {
      allianceId = self.data.allianceId,
      noticeId = self.data.noticeId
    }, SafeLocalOsTime(), extraNote)
  elseif self.data.type == ReportType.FriendCircle or self.data.type == ReportType.FriendCircleMoment then
    ChatManager2:GetInstance():ReportChat(self.chatData, self.data.type, self.reTypeDic, extraNote)
  elseif self.data.type == ReportType.ActEasterEggOwner then
    DataCenter.ActEasterEggManager:ReportEgg(self.data.createTime, self.data.uid, self.reTypeDic, self.data.msg, extraNote, self.data.eggUuid)
  elseif self.data.type == ReportType.GroupChat then
    ChatInterface.getGroupChatMgr():ReportName(self.data.roomData, extraNote, self.reTypeDic)
  elseif self.data.type == ReportType.gift then
    local param = {
      playerUid = self.data.playerUid,
      msg = self.data.msg,
      type = cofType,
      reportTypeList = self.reTypeDic,
      extraNote = extraNote,
      extraData = {
        uid = self.data.dataUuid
      }
    }
    ChatManager2:GetInstance():ReportData(param)
  else
    ChatManager2:GetInstance():ReportChat(self.chatData, cofType, self.reTypeDic, extraNote)
  end
  UIUtil.ShowTipsId(280063)
  self.ctrl:CloseSelf()
end

function UIChatReportView:OnClickCancelBtn()
  self.ctrl:CloseSelf()
end

return UIChatReportView
