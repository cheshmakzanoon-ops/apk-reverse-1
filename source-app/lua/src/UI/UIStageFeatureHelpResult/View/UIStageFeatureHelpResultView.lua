local UIStageFeatureHelpResultView = BaseClass("UIStageFeatureHelpResultView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray

function UIStageFeatureHelpResultView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RequestPanelInfo()
  self:InitView()
  self:Update1000MS()
end

function UIStageFeatureHelpResultView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIStageFeatureHelpResultView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.btnAccept = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnAccept:SetOnClick(function()
    self:OnBtnAcceptClick()
  end)
  self.textName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.btnGift = self.viewSkin:AddComponent(self, UIButton, 6)
  self.btnGift:SetOnClick(function()
    self:OnBtnGiftClick()
  end)
  self.btnLike = self.viewSkin:AddComponent(self, UIButton, 7)
  self.btnLike:SetOnClick(function()
    self:OnBtnLikeClick()
  end)
  self.textTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.btnTip = self.viewSkin:AddComponent(self, UIButton, 9)
  self.btnTip:SetOnClick(function()
    self:OnBtnTipClick()
  end)
  self.textBtn = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
  self.head = self:AddComponent(UICommonHead, "bg/Head")
  self.head:SetEnableClickShowInfo(true, true)
end

function UIStageFeatureHelpResultView:ComponentDestroy()
  self.viewSkin = nil
  self.btnClose = nil
  self.btnAccept = nil
  self.textName = nil
  self.textDesc = nil
  self.textTitle = nil
  self.btnGift = nil
  self.btnLike = nil
  self.textTime = nil
  self.btnTip = nil
  self.textBtn = nil
end

function UIStageFeatureHelpResultView:DataDefine()
  self.param = self:GetUserData()
  self.hasThumb = false
  self.isExpired = false
  self.isAccepted = false
end

function UIStageFeatureHelpResultView:DataDestroy()
  self.param = nil
end

function UIStageFeatureHelpResultView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.PlaneFeatureGetResultThumbsInfo, self.OnGetLikeInfo)
  self:AddUIListener(EventId.PlaneFeatureThumbsSuccess, self.OnThumbsSuccess)
  self:AddUIListener(EventId.PlaneFeatureGetShareStateSuccess, self.OnGetShareStateSuccess)
end

function UIStageFeatureHelpResultView:OnRemoveListener()
  self:RemoveUIListener(EventId.PlaneFeatureGetResultThumbsInfo, self.OnGetLikeInfo)
  self:RemoveUIListener(EventId.PlaneFeatureThumbsSuccess, self.OnThumbsSuccess)
  self:RemoveUIListener(EventId.PlaneFeatureGetShareStateSuccess, self.OnGetShareStateSuccess)
  base.OnRemoveListener(self)
end

function UIStageFeatureHelpResultView:Update1000MS()
  if not (self.param and self.param.endTime) or self.isExpired or self.isAccepted then
    return
  end
  local endTime = self.param.endTime
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local remainTime = endTime - curTime
  if 0 < remainTime then
    self.textTime:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
  else
    self.isExpired = true
    self.textTime:SetLocalText("390843")
  end
end

function UIStageFeatureHelpResultView:OnBtnLikeClick()
  if self.hasThumb then
    UIUtil.ShowTipsId("activity_sports_uitips_017")
    return
  end
  local uuid = self.param.uuid
  DataCenter.LWStageFeatureChapterManager:StageFeatureResultThumbsUp(uuid)
end

function UIStageFeatureHelpResultView:OnBtnAcceptClick()
  if self.isExpired then
    UIUtil.ShowTipsId("390843")
    return
  end
  local uuid = self.param.uuid
  local stageId = self.param.stageId
  self.ctrl:CloseSelf()
  DataCenter.LWStageFeatureChapterManager:AcceptHelpResult(uuid, stageId)
end

function UIStageFeatureHelpResultView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function UIStageFeatureHelpResultView:InitView()
  local senderInfo = self.param.senderInfo
  self.head:SetHeadAndFrame(senderInfo.uid, senderInfo.headPic, senderInfo.headPicVer, false, senderInfo.headSkinId, senderInfo.headSkinET)
  local name = ""
  local abbr = ""
  if self.param.fromList then
    name = senderInfo.name
    abbr = senderInfo.abbr
  else
    name = senderInfo.userName
    abbr = senderInfo.allianceSimpleName
  end
  name = UIUtil.FormatAllianceAndName(abbr, name, senderInfo.uid)
  self.textName:SetText(name)
  local stageName = DataCenter.LWStageFeatureChapterManager:GetStageFeatureName(self.param.stageId)
  local soliderCount = self.param.soldierNum or 0
  self.textDesc:SetLocalText("frontline_help_report_02", stageName, soliderCount)
end

function UIStageFeatureHelpResultView:OnBtnGiftClick()
  local senderInfo = self.param.senderInfo
  DataCenter.GiftSystemManager:OpenOperationView({
    windowType = GiftSystemConst.WindowType.Send,
    targetUid = senderInfo.uid,
    targetServerId = senderInfo.serverId,
    fromType = GiftSystemConst.fromType.StageFeatureShare
  })
end

function UIStageFeatureHelpResultView:RequestPanelInfo()
  if not self.param or not self.param.uuid then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.PlaneFeatureResultThumbsInfo, self.param.uuid)
  SFSNetwork.SendMessage(MsgDefines.PlaneFeatureGetState, self.param.uuid)
end

function UIStageFeatureHelpResultView:OnGetLikeInfo(data)
  if not data then
    return
  end
  local curUuid = tonumber(self.param.uuid)
  if data.uuid ~= curUuid then
    return
  end
  self.hasThumb = data.hasThumb
  self.btnLike:SetActive(not self.hasThumb)
end

function UIStageFeatureHelpResultView:OnThumbsSuccess(uuid)
  local curUuid = tonumber(self.param.uuid)
  if uuid ~= curUuid then
    return
  end
  self.hasThumb = true
  self.btnLike:SetActive(false)
end

function UIStageFeatureHelpResultView:OnBtnTipClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWHowToPlay, {anim = true}, {
    howToPlayList = {100040}
  })
end

function UIStageFeatureHelpResultView:OnGetShareStateSuccess(data)
  if not data then
    return
  end
  local curUuid = tonumber(self.param.uuid)
  if data.uuid ~= curUuid then
    return
  end
  local state = data.state
  self.isAccepted = state == StageFeatureHelpInfoState.AcceptResult
  if self.isAccepted then
    self.textTime:SetText("")
    self.textBtn:SetLocalText("frontline_help_message_16")
    UIGray.SetGray(self.btnAccept.transform, true, false)
  else
    self.textBtn:SetLocalText("frontline_help_report_03")
    UIGray.SetGray(self.btnAccept.transform, false, true)
  end
end

return UIStageFeatureHelpResultView
