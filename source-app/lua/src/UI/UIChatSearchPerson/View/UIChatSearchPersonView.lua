local UIChatSearchPersonView = BaseClass("UIChatSearchPersonView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIChatSearchPersonCom = require("UI.UIChatSearchPerson.Component.UIChatSearchPersonCom")
local UIChatSearchAddAllianceMember = require("UI.UIChatSearchPerson.Component.UIChatSearchAddAllianceMember")
local _cp_txtTitle = "ImgBg/TxtTitle"
local _cp_btnClose = "ImgBg/CloseBtn"
local _cp_toggle_1 = "ImgBg/Tab/Toggle1"
local _cp_toggle_2 = "ImgBg/Tab/Toggle2"
local _cp_searchObj = "objSearch"
local _cp_alliance = "AllianceMember"
local _cp_warnTips = "warnTips"

function UIChatSearchPersonView:ComponentDefine()
  self._txtTitle = self:AddComponent(UIText, _cp_txtTitle)
  self._btnClose = self:AddComponent(UIButton, _cp_btnClose)
  self._btnClose:SetOnClick(function()
    self.view.ctrl:CloseSelf()
  end)
  self._txtwarnTips = self:AddComponent(UIText, _cp_warnTips)
  self._searchObj = self:AddComponent(UIChatSearchPersonCom, _cp_searchObj)
  self._allianceObj = self:AddComponent(UIChatSearchAddAllianceMember, _cp_alliance)
  self._toggle1 = self:AddComponent(UIToggle, _cp_toggle_1)
  self._toggle1:SetIsOn(false)
  self:ShowAllianceView(false)
  self._toggle1:SetOnValueChanged(BindCallback(self, self.ShowAllianceView))
  self._toggle2 = self:AddComponent(UIToggle, _cp_toggle_2)
  self._toggle2:SetIsOn(true)
  self:ShowSearchView(true)
  self._toggle2:SetOnValueChanged(BindCallback(self, self.ShowSearchView))
end

function UIChatSearchPersonView:ShowAllianceView(isOn)
  self._toggle1.transform:Find("Choose").gameObject:SetActive(isOn)
  self._searchObj:SetActive(not isOn)
  self._txtTitle:SetLocalText(290037)
  if isOn then
    if not ChatInterface.isInAlliance() then
      self._allianceObj:SetActive(false)
      self._txtwarnTips:SetActive(true)
      self._txtwarnTips:SetLocalText(390536)
    else
      self._allianceObj:SetActive(true)
      self._allianceObj:ReInit(true)
      self._txtwarnTips:SetActive(false)
    end
  else
    self._allianceObj:SetActive(false)
  end
end

function UIChatSearchPersonView:ShowSearchView(isOn)
  self._txtwarnTips:SetActive(false)
  self._toggle2.transform:Find("Choose").gameObject:SetActive(isOn)
  self._searchObj:SetActive(isOn)
  self._allianceObj:SetActive(not isOn)
  self._txtTitle:SetLocalText(280173)
  if isOn then
    self._searchObj:ReInit(true)
  end
end

function UIChatSearchPersonView:DataDefine()
  self._isLeft = false
  self._isAnim = false
end

function UIChatSearchPersonView:OnAddListener()
  base.OnAddListener(self)
end

function UIChatSearchPersonView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIChatSearchPersonView:OnCreate()
  base.OnCreate(self)
  self.view.ctrl.chatRoomdId = self:GetUserData()
  self:ComponentDefine()
  self:DataDefine()
end

return UIChatSearchPersonView
