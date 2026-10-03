local UIStageFeatureHelpInviteView = BaseClass("UIStageFeatureHelpInviteView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function UIStageFeatureHelpInviteView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitView()
  self:Update1000MS()
end

function UIStageFeatureHelpInviteView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIStageFeatureHelpInviteView:ComponentDefine()
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
  self.textTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.head = self:AddComponent(UICommonHead, "bg/Head")
  self.head:SetEnableClickShowInfo(true, true)
end

function UIStageFeatureHelpInviteView:ComponentDestroy()
  self.viewSkin = nil
  self.btnClose = nil
  self.btnAccept = nil
  self.textName = nil
  self.textDesc = nil
  self.textTitle = nil
  self.textTime = nil
end

function UIStageFeatureHelpInviteView:DataDefine()
  self.isExpired = false
  self.param = self:GetUserData()
end

function UIStageFeatureHelpInviteView:DataDestroy()
end

function UIStageFeatureHelpInviteView:OnAddListener()
  base.OnAddListener(self)
end

function UIStageFeatureHelpInviteView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIStageFeatureHelpInviteView:Update1000MS()
  if not (self.param and self.param.endTime) or self.isExpired then
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

function UIStageFeatureHelpInviteView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function UIStageFeatureHelpInviteView:OnBtnAcceptClick()
  local endTime = self.param.endTime
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if endTime <= curTime then
    UIUtil.ShowTipsId(390843)
    return
  end
  local uuid = self.param.uuid
  local stageId = self.param.stageId
  if self.param.fromAlliance then
    local targetUid = self.param.senderInfo.uid
    DataCenter.LWStageFeatureChapterManager:AcceptHelpInviteAlliance(uuid, stageId, targetUid)
  else
    DataCenter.LWStageFeatureChapterManager:AcceptHelpInvite(uuid, stageId)
  end
  self.ctrl:CloseSelf()
end

function UIStageFeatureHelpInviteView:InitView()
  if not self.param or not self.param.senderInfo then
    Logger.LogError("UIStageFeatureHelpInviteView InitView param is nil")
    return
  end
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
  self.textDesc:SetLocalText("frontline_help_invite_02", stageName)
end

return UIStageFeatureHelpInviteView
