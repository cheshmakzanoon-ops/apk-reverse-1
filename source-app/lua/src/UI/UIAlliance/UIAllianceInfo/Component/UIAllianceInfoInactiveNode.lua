local base = UIBaseContainer
local UIAllianceInfoInactiveNode = BaseClass("UIAllianceInfoInactiveNode", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UIAllianceInfoInactiveNode:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIAllianceInfoInactiveNode:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIAllianceInfoInactiveNode:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgTagBg = self.viewSkin:AddComponent(self, UIImage, 1)
  self.textRedTag = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textYellowTag = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textRedTag:SetLocalText("alliance_member_desc_inactive")
  self.textYellowTag:SetLocalText("alliance_member_name_royalMember")
end

function UIAllianceInfoInactiveNode:ComponentDestroy()
  self.viewSkin = nil
  self.imgTagBg = nil
  self.textRedTag = nil
  self.textYellowTag = nil
end

function UIAllianceInfoInactiveNode:DataDefine()
end

function UIAllianceInfoInactiveNode:DataDestroy()
end

function UIAllianceInfoInactiveNode:OnAddListener()
  base.OnAddListener(self)
end

function UIAllianceInfoInactiveNode:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIAllianceInfoInactiveNode:SetData(inactive)
  if inactive then
    self.textRedTag:SetActive(true)
    self.textYellowTag:SetActive(false)
    self.imgTagBg:LoadSpriteAuto("Assets/Main/Sprites/UI/UILWAlliance/zyf_tongmengguanli_fhycy_di.png")
  else
    self.textRedTag:SetActive(false)
    self.textYellowTag:SetActive(true)
    self.imgTagBg:LoadSpriteAuto("Assets/Main/Sprites/UI/UILWAlliance/zyf_tongmengguanli_rycy_di.png")
  end
end

return UIAllianceInfoInactiveNode
