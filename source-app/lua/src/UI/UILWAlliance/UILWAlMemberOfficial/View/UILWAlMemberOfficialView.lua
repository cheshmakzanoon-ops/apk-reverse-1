local UILWAlMemberOfficialView = BaseClass("UILWAlMemberOfficialView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UILWAlMemberOfficialTopPanel = require("UI.UILWAlliance.UILWAlMemberOfficial.Component.UILWAlMemberOfficialTopPanel")
local UILWAlMemberOfficialEmptyPanel = require("UI.UILWAlliance.UILWAlMemberOfficial.Component.UILWAlMemberOfficialEmptyPanel")
local UILWAlMemberOfficialMemberPanel = require("UI.UILWAlliance.UILWAlMemberOfficial.Component.UILWAlMemberOfficialMemberPanel")

function UILWAlMemberOfficialView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWAlMemberOfficialView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWAlMemberOfficialView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.compTopPanel = self.viewSkin:AddComponent(self, UILWAlMemberOfficialTopPanel, 3)
  self.compEmptyPanel = self.viewSkin:AddComponent(self, UILWAlMemberOfficialEmptyPanel, 4)
  self.compMemberPanel = self.viewSkin:AddComponent(self, UILWAlMemberOfficialMemberPanel, 5)
  self.btnPanel = self.viewSkin:AddComponent(self, UIButton, 6)
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
end

function UILWAlMemberOfficialView:ComponentDestroy()
  self.viewSkin = nil
  self.textTitle = nil
  self.btnClose = nil
  self.compTopPanel = nil
  self.compEmptyPanel = nil
  self.compMemberPanel = nil
  self.btnPanel = nil
end

function UILWAlMemberOfficialView:DataDefine()
  self.type = self:GetUserData()
  self.textTitle:SetLocalText(LWAlMemberOffcialParam[self.type].Text)
  local selectInfo = DataCenter.AllianceMemberDataManager:GetMemberInfoByOfficialPos(self.type)
  self:SetSelectInfo(selectInfo)
end

function UILWAlMemberOfficialView:DataDestroy()
  self.selectInfo = nil
end

function UILWAlMemberOfficialView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.AllianceMember, self.OnAllianceMember)
end

function UILWAlMemberOfficialView:OnRemoveListener()
  self:RemoveUIListener(EventId.AllianceMember, self.OnAllianceMember)
  base.OnRemoveListener(self)
end

function UILWAlMemberOfficialView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function UILWAlMemberOfficialView:OnBtnPanelClick()
  self.ctrl:CloseSelf()
end

function UILWAlMemberOfficialView:SetSelectInfo(playerInfo, noRefreshData)
  if playerInfo then
    if self.selectInfo and self.selectInfo.uid == playerInfo.uid then
      self.selectInfo = nil
    else
      self.selectInfo = DataCenter.AllianceMemberDataManager:GetAllianceMemberByUid(playerInfo.uid)
    end
  else
    self.selectInfo = nil
  end
  self:Refresh(noRefreshData)
end

function UILWAlMemberOfficialView:GetSelectInfo()
  return self.selectInfo
end

function UILWAlMemberOfficialView:Refresh(noRefreshData)
  self.compTopPanel:Refresh()
  local allianceMembers = DataCenter.AllianceMemberDataManager.allianceMembers
  if allianceMembers == nil or DataCenter.AllianceMemberDataManager:GetAllianceMemberCount() <= 1 then
    self.compEmptyPanel:SetActive(true)
    self.compMemberPanel:SetActive(false)
  else
    self.compMemberPanel:SetActive(true)
    self.compMemberPanel:Refresh(noRefreshData)
  end
end

function UILWAlMemberOfficialView:OnAllianceMember()
  if self.selectInfo then
    local data = DataCenter.AllianceMemberDataManager:GetAllianceMemberByUid(self.selectInfo.uid)
    if data then
      self:Refresh()
    else
      self:SetSelectInfo(nil)
    end
  else
    self:SetSelectInfo(nil)
  end
end

return UILWAlMemberOfficialView
