local base = UIBaseView
local UIChatReportSpecificTypeView = BaseClass("UIChatReportSpecificTypeView", base)
local ChatReportItem = require("UI.UIChatReport.Component.UIChatReportItem")
local title_path = "UICommonMidPopUpTitle/titleText"
local closeBtn_path = "UICommonMidPopUpTitle/CloseBtn"
local targetPlayerTxt_path = "ImgBg/txtTargetPlayer"
local playerName_path = "ImgBg/txtTargetPlayer/txtPlayerName"
local reasonTxt_path = "ImgBg/reason"
local input_path = "ImgBg/reasonIpt"
local reasonIptDefault_path = "ImgBg/reasonIpt/Placeholder"
local cancelBtn_path = "ImgBg/cancelBtn"
local cancelBtnTxt_path = "ImgBg/cancelBtn/cancelBtnTxt"
local confirmBtn_path = "ImgBg/confirmBtn"
local confirmBtnTxt_path = "ImgBg/confirmBtn/confirmBtnTxt"

function UIChatReportSpecificTypeView:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
  self:Init()
end

function UIChatReportSpecificTypeView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIChatReportSpecificTypeView:ComponentDefine()
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
  self.reasonIptN = self:AddComponent(UIInput, input_path)
  self.reasonIptN:SetOnEndEdit(function(value)
    self:RefreshReportBtn()
  end)
  self.reasonIptN:SetText("")
  self.reasonIptDefaultN = self:AddComponent(UIText, reasonIptDefault_path)
  self.reasonIptDefaultN:SetLocalText(208249)
  self.cancelBtnN = self:AddComponent(UIButton, cancelBtn_path)
  self.cancelBtnN:SetOnClick(function()
    self:OnClickCancelBtn()
  end)
  self.cancelBtnTxtN = self:AddComponent(UIText, cancelBtnTxt_path)
  self.cancelBtnTxtN:SetLocalText(110106)
  self.confirmBtnN = self:AddComponent(UIButton, confirmBtn_path)
  self.panelBtn = self:AddComponent(UIButton, "UICommonMidPopUpTitle/panel")
  self.panelBtn:SetOnClick(function()
    self:OnClickCloseBtn()
  end)
  self.confirmBtnN:SetOnClick(function()
    self:OnClickConfirmBtn()
  end)
  self.confirmBtnTxtN = self:AddComponent(UIText, confirmBtnTxt_path)
  self.confirmBtnTxtS = self:AddComponent(UIShadow, confirmBtnTxt_path)
  self.confirmBtnTxtN:SetLocalText(110006)
end

function UIChatReportSpecificTypeView:ComponentDestroy()
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

function UIChatReportSpecificTypeView:DataDefine()
  self.contentCellList = {}
  self.choicesCellList = {}
  self.reTypeDic = {}
end

function UIChatReportSpecificTypeView:DataDestroy()
  self.contentCellList = nil
  self.choicesCellList = nil
  self.reTypeDic = nil
end

function UIChatReportSpecificTypeView:Init()
  self.data = self:GetUserData()
  self:RefreshAll()
end

function UIChatReportSpecificTypeView:RefreshAll()
  self.reportReasonList = self.ctrl.GetReportReasonCof()
  self.playerNameN:SetText(self.ctrl.GetPlayerName(self.data))
  self:ClearAllItem()
  self:InitReason()
  self:RefreshReportBtn()
end

function UIChatReportSpecificTypeView:ClearAllItem()
  self.choicesRoot:RemoveComponents(ChatReportItem)
  self.contentItem.gameObject:GameObjectRecycleAll()
end

function UIChatReportSpecificTypeView:InitReason()
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

function UIChatReportSpecificTypeView:RefreshReportBtn()
  if table.count(self.reTypeDic) == 0 then
    CS.UIGray.SetGray(self.confirmBtnN.transform, true, false)
    self.confirmBtnTxtS:SetAllColor(YellowBtnShadowGrayColor)
    return
  end
  local isOther
  for typeCof, v in pairs(self.reTypeDic) do
    if typeCof == ChatReportType.Other then
      isOther = true
      break
    end
  end
  if isOther then
    local extra = self.reasonIptN:GetText()
    if string.IsNullOrEmpty(extra) or string.IsNullOrEmpty(string.trim(extra)) then
      CS.UIGray.SetGray(self.confirmBtnN.transform, true, false)
      self.confirmBtnTxtS:SetAllColor(YellowBtnShadowGrayColor)
      return
    end
  end
  CS.UIGray.SetGray(self.confirmBtnN.transform, false, true)
  self.confirmBtnTxtS:SetAllColor(YellowBtnShadowLightColor)
end

function UIChatReportSpecificTypeView:OnSelectOne(reportItem)
  if reportItem.selectType == SelectType.Multiple then
    self.reTypeDic[reportItem.reportConf.ReportType] = reportItem.isOn or nil
  end
  self:RefreshReportBtn()
end

function UIChatReportSpecificTypeView:OnClickCloseBtn()
  self.ctrl:CloseSelf()
end

function UIChatReportSpecificTypeView:OnClickConfirmBtn()
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
  if self.data.type == ReportType.SeasonAlliancePhoto then
    local extraInfo = self.data.allianceId .. ";" .. self.data.season .. ";" .. self.data.version .. ";" .. self.data.picUrl
    SFSNetwork.SendMessage(MsgDefines.AllianceReport, self.data.allianceId, ReportType.SeasonAlliancePhoto, self.reTypeDic, "", extraNote, extraInfo)
  elseif self.data.type == ReportType.SeasonAlliancePhotoMessage then
    local key = "SeasonPhotoMessageOperation" .. self.data.uid
    local cache = DataCenter.ActivityListDataManager:GetExtraData(key, {})
    local extra = {
      allianceId = self.data.allianceId,
      season = self.data.season,
      uid = self.data.uid
    }
    ChatManager2:GetInstance():ReqReportChat(self.data.uid, self.data.msg, ReportType.SeasonAlliancePhotoMessage, self.reTypeDic, extra, nil, nil)
    table.insert(cache, self.data.msg or "")
    DataCenter.ActivityListDataManager:UpdateExtraData(key, cache)
  end
  UIUtil.ShowTipsId(280063)
  self.ctrl:CloseSelf()
end

function UIChatReportSpecificTypeView:OnClickCancelBtn()
  self.ctrl:CloseSelf()
end

return UIChatReportSpecificTypeView
