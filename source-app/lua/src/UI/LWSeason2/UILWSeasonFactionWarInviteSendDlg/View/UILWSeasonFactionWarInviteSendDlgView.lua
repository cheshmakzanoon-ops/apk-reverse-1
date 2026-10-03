local UILWSeasonFactionWarInviteSendDlgView = BaseClass("UILWSeasonFactionWarInviteSendDlgView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local panel_path = "panel"
local dialog_title_text_path = "PopUpTitle/Common_img_title/titleText"
local close_btn_path = "PopUpTitle/CloseBtn"
local do_btn_path = "Content/DoBtn"
local tips_msg_path = "Content/TipsMsg"
local user_info_path = "Content/UserInfo"
local ui_player_head_path = "Content/UserInfo/UIPlayerHead"
local user_text_path = "Content/UserInfo/UserText"
local invite_text_path = "Content/UserInfo/InviteText"

function UILWSeasonFactionWarInviteSendDlgView:OnCreate()
  base.OnCreate(self)
  self.data = self:GetUserData()
  self:ComponentDefine()
  self:UpdateData()
end

function UILWSeasonFactionWarInviteSendDlgView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonFactionWarInviteSendDlgView:ComponentDefine()
  self.dialog_title_text = self:AddComponent(UIText, dialog_title_text_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.dialog_title_text:SetLocalText("season_s2_faction_war_44")
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.close_btn1 = self:AddComponent(UIButton, panel_path)
  self.close_btn1:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.send_btn = self:AddComponent(UIButton, do_btn_path)
  self.send_btn:SetOnClick(function()
    self:OnSubmitClick()
  end)
  self.tips_msg = self:AddComponent(UITextMeshProUGUIEx, tips_msg_path)
  self.user_info = self:AddComponent(UIImage, user_info_path)
  self.ui_player_head = self:AddComponent(UICommonHead, ui_player_head_path)
  self.user_text = self:AddComponent(UITextMeshProUGUIEx, user_text_path)
  self.invite_text = self:AddComponent(UITextMeshProUGUIEx, invite_text_path)
end

function UILWSeasonFactionWarInviteSendDlgView:ComponentDestroy()
  self.btn_back = nil
  self.do_btn = nil
  self.tips_msg = nil
  self.user_info = nil
  self.ui_player_head = nil
  self.user_text = nil
  self.invite_text = nil
end

function UILWSeasonFactionWarInviteSendDlgView:UpdateData()
  local full_name = UIUtil.FormatServerAllianceName(self.data.serverId, self.data.abbr, self.data.name)
  self.theContent = self.data.theContent
  if string.IsNullOrEmpty(self.theContent) then
    self.user_info:SetActive(false)
  else
    self.user_info:SetActive(true)
    self.ui_player_head:SetAsMyself()
    self.ui_player_head:SetEnableClickShowInfo(true, true)
    self.user_text:SetText(full_name)
    self.invite_text:SetText(self.theContent)
  end
  self.tips_msg:SetLocalText("season_s2_faction_war_99", full_name)
end

function UILWSeasonFactionWarInviteSendDlgView:OnSubmitClick()
  if DataCenter.AllianceBaseDataManager:IsR4orR5() then
    if self.data then
      SFSNetwork.SendMessage(MsgDefines.SeasonFactionWarInviteSend, self.data.allianceId, self.theContent)
      UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonFactionWarInviteSendDlg)
    end
  else
    UIUtil.ShowTipsId(803040)
  end
end

return UILWSeasonFactionWarInviteSendDlgView
