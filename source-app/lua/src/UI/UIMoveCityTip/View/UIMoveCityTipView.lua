local base = UIBaseView
local UIMoveCityTipView = BaseClass("UIMoveCityTipView", base)
local Localization = CS.GameEntry.Localization
local MoveCityConfirmPanel = require("UI.UIMoveCityTip.Component.MoveCityConfirmPanel")
local MoveCityInvitePanel = require("UI.UIMoveCityTip.Component.MoveCityInvitePanel")
local title_path = "UICommonMiniPopUpTitle/titleText"
local closeBtn_path = "UICommonMiniPopUpTitle/CloseBtn"
local movePanel_path = "movePanel"
local invitePanel_path = "invitePanel"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshAll()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.titleN = self:AddComponent(UIText, title_path)
  self.closeBtnN = self:AddComponent(UIButton, closeBtn_path)
  self.closeBtnN:SetOnClick(function()
    self:OnClickCloseBtn()
  end)
  self.movePanelN = self:AddComponent(MoveCityConfirmPanel, movePanel_path)
  self.invitePanelN = self:AddComponent(MoveCityInvitePanel, invitePanel_path)
end

local function ComponentDestroy(self)
  self.titleN = nil
  self.closeBtnN = nil
  self.movePanelN = nil
  self.invitePanelN = nil
end

local function DataDefine(self)
  self.paramTb = {}
end

local function DataDestroy(self)
  self.paramTb = nil
end

local function RefreshAll(self)
  self.paramTb = self:GetUserData()
  if self.paramTb.openType == 1 then
    self.titleN:SetLocalText(390854)
  elseif self.paramTb.openType == 2 then
    self.titleN:SetLocalText(391077)
  end
  self.movePanelN:ShowPanel(self.paramTb.openType == 1, self.paramTb)
  self.invitePanelN:ShowPanel(self.paramTb.openType == 2, self.paramTb)
end

local function OnClickCloseBtn(self)
  if self.paramTb.openType == 1 then
    if self.paramTb.isInviteMove then
      SFSNetwork.SendMessage(MsgDefines.RefuseAllianceMoveInvite)
    end
  elseif self.paramTb.openType == 2 then
  end
  self.ctrl:CloseSelf()
end

UIMoveCityTipView.OnCreate = OnCreate
UIMoveCityTipView.OnDestroy = OnDestroy
UIMoveCityTipView.ComponentDefine = ComponentDefine
UIMoveCityTipView.ComponentDestroy = ComponentDestroy
UIMoveCityTipView.DataDefine = DataDefine
UIMoveCityTipView.DataDestroy = DataDestroy
UIMoveCityTipView.RefreshAll = RefreshAll
UIMoveCityTipView.OnClickCloseBtn = OnClickCloseBtn
return UIMoveCityTipView
