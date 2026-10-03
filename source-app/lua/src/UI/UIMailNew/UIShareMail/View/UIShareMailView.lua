local Localization = CS.GameEntry.Localization
local UIShareMailView = BaseClass("UIShareMailView", UIBaseView)
local base = UIBaseView
local MailContentContainer = require("UI.UIMailNew.UIMailMainPanel.Component.MailContentContainer")
local _cp_btnClose = "UICommonPopUpTitle/CloseBtn"
local _cp_txtTitle = "UICommonPopUpTitle/Common_img_title/titleText"
local _cp_content = "RightScrollView/Viewport/Content"
local _cp_btnShare = "UICommonPopUpTitle/shareBtn"

function UIShareMailView:OnCreate()
  base.OnCreate(self)
  self._btnClose = self:AddComponent(UIButton, _cp_btnClose)
  self._btnClose:SetOnClick(BindCallback(self, self.OnClickBtnClose))
  self._txtTitle = self:AddComponent(UIText, _cp_txtTitle)
  self._content = self:AddComponent(MailContentContainer, _cp_content)
  self._btnShare = self:AddComponent(UIButton, _cp_btnShare)
  self._btnShare:SetOnClick(function()
    self:OnClickShareBtn()
  end)
end

function UIShareMailView:OnClickBtnClose()
  self.ctrl:CloseSelf()
end

function UIShareMailView:OnEnable()
  base.OnEnable(self)
  local mailInfo, shareParam, playbackJumpType = self:GetUserData()
  self.mailInfo = mailInfo
  self.shareParam = shareParam
  self.playbackJumpType = playbackJumpType
  if self.mailInfo.type == MailType.NEW_FIGHT then
    self._txtTitle:SetLocalText(311132)
  elseif self.mailInfo.type == MailType.MAIL_SCOUT_RESULT or self.mailInfo.type == MailType.LW_SEASON_SCOUT_MAIL then
    self._txtTitle:SetLocalText(300617)
  elseif self.mailInfo.type == MailType.ELITE_FIGHT_MAIL then
    self._txtTitle:SetLocalText(302022)
  end
  self:CheckShowShareBtn()
  local showReplay = false
  if self.mailInfo.type == MailType.NEW_FIGHT then
    showReplay = self.mailInfo:GetMailExt():GetCanRePlay()
  end
  self._content:ShowData(self.mailInfo, showReplay, self.playbackJumpType)
end

function UIShareMailView:OnClickShareBtn()
  if self.mailInfo.type == MailType.ELITE_FIGHT_MAIL then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIPositionShare, {anim = true}, self.shareParam)
  else
    MailShowHelper.TryShareMail(self.mailInfo)
  end
end

function UIShareMailView:CheckShowShareBtn()
  self._btnShare:SetActive(self.mailInfo.type == MailType.ELITE_FIGHT_MAIL and self.shareParam ~= nil)
end

return UIShareMailView
