local base = UIBaseContainer
local UILWAlMemberOfficialEmptyPanel = BaseClass("UILWAlMemberOfficialEmptyPanel", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UILWAlMemberOfficialEmptyPanel:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWAlMemberOfficialEmptyPanel:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWAlMemberOfficialEmptyPanel:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textEmpty = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.btnEmpty = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnEmpty:SetOnClick(function()
    self:OnBtnEmptyClick()
  end)
  self.textEmptyBtn = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textEmpty:SetLocalText("alliance_officer_noMember")
  self.textEmptyBtn:SetLocalText("393085")
end

function UILWAlMemberOfficialEmptyPanel:ComponentDestroy()
  self.viewSkin = nil
  self.textEmpty = nil
  self.btnEmpty = nil
  self.textEmptyBtn = nil
end

function UILWAlMemberOfficialEmptyPanel:DataDefine()
end

function UILWAlMemberOfficialEmptyPanel:DataDestroy()
end

function UILWAlMemberOfficialEmptyPanel:OnAddListener()
  base.OnAddListener(self)
end

function UILWAlMemberOfficialEmptyPanel:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWAlMemberOfficialEmptyPanel:OnBtnEmptyClick()
  if LuaEntry.DataConfig:CheckSwitch("alliance_inviteLinkNew_switch") then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAllianceInviteShareNew, {anim = true})
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAllianceInviteShare, {anim = true})
  end
end

return UILWAlMemberOfficialEmptyPanel
