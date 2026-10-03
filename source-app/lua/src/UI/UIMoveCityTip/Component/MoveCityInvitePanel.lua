local MoveCityInvitePanel = BaseClass("MoveCityInvitePanel", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local AllianceFlagItem = require("UI.UIAlliance.UIAllianceFlag.Component.AllianceFlagItem")
local inviteDesc_path = "inviteDesc"
local inviteBtn_path = "inviteBtn"
local inviteBtnTxt_path = "inviteBtn/inviteBtnTxt"

local function OnCreate(self)
  base.OnCreate(self)
  self.inviteDescN = self:AddComponent(UIText, inviteDesc_path)
  self.inviteDescN:SetLocalText(391078)
  self.inviteBtnN = self:AddComponent(UIButton, inviteBtn_path)
  self.inviteBtnN:SetOnClick(function()
    self:OnClickConfirmBtn()
  end)
  self.inviteBtnTxtN = self:AddComponent(UIText, inviteBtnTxt_path)
  self.inviteBtnTxtN:SetLocalText(390198)
end

local function OnDestroy(self)
  self.inviteDescN = nil
  self.inviteBtnN = nil
  self.inviteBtnTxtN = nil
  base.OnDestroy(self)
end

local function ShowPanel(self, isShow, param)
  if not isShow then
    self:SetActive(false)
    return
  end
  self:SetActive(true)
end

local function OnClickConfirmBtn(self)
  SFSNetwork.SendMessage(MsgDefines.InviteMoveCity)
  UIUtil.ShowTipsId(390196)
  self.view.ctrl:CloseSelf()
end

MoveCityInvitePanel.OnCreate = OnCreate
MoveCityInvitePanel.OnDestroy = OnDestroy
MoveCityInvitePanel.ShowPanel = ShowPanel
MoveCityInvitePanel.OnClickConfirmBtn = OnClickConfirmBtn
return MoveCityInvitePanel
