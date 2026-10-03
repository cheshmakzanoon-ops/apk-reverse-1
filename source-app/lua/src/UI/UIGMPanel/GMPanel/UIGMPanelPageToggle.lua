local base = UIBaseContainer
local UIGMPanelPageToggle = BaseClass("UIGMPanelPageToggle", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UIGMPanelPageToggle:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIGMPanelPageToggle:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIGMPanelPageToggle:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compUnselected = self.viewSkin:AddComponent(self, UIBaseComponent, 1)
  self.compSelected = self.viewSkin:AddComponent(self, UIBaseComponent, 2)
  self.textTmpUnselected = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textTmpSelected = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.imgUnselectedIcon = self.viewSkin:AddComponent(self, UIImage, 5)
  self.btnUIGMPanelPageToggle = self.viewSkin:AddComponent(self, UIButton, 6)
  self.btnUIGMPanelPageToggle:SetOnClick(function()
    self:OnBtnUIGMPanelPageToggleClick()
  end)
  self.imgSelectedIcon = self.viewSkin:AddComponent(self, UIImage, 7)
  self.imgUnselected = self.viewSkin:AddComponent(self, UIImage, 8)
  self.imgSelected = self.viewSkin:AddComponent(self, UIImage, 9)
  self:UpdateSelected(false)
  self:RefreshSkin()
end

function UIGMPanelPageToggle:ComponentDestroy()
  self.viewSkin = nil
  self.compUnselected = nil
  self.compSelected = nil
  self.textTmpUnselected = nil
  self.textTmpSelected = nil
  self.imgUnselectedIcon = nil
  self.btnUIGMPanelPageToggle = nil
  self.imgSelectedIcon = nil
  self.imgUnselected = nil
  self.imgSelected = nil
end

function UIGMPanelPageToggle:DataDefine()
end

function UIGMPanelPageToggle:DataDestroy()
  self.data = nil
end

function UIGMPanelPageToggle:OnAddListener()
  base.OnAddListener(self)
end

function UIGMPanelPageToggle:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIGMPanelPageToggle:ReInit(index, data)
  if not data then
    return
  end
  self.data = data
  self.index = index
  self.textTmpSelected:SetText(data.label or "???")
  self.textTmpUnselected:SetText(data.label or "???")
  self:SetIcon()
end

function UIGMPanelPageToggle:Setup(host)
  self.host = host
end

function UIGMPanelPageToggle:OnBtnUIGMPanelPageToggleClick()
  if self.host then
    self.host:ClickedToggle(self.index, self)
  end
end

function UIGMPanelPageToggle:UpdateSelected(selected)
  self.compUnselected:SetActive(not selected)
  self.compSelected:SetActive(selected)
end

function UIGMPanelPageToggle:RefreshSkin(skin)
  skin = skin or GMUtils.GetSkinPath()
  self.imgSelected:LoadSpriteAuto(skin.panelBtnBg)
  self:SetIcon()
end

function UIGMPanelPageToggle:SetIcon()
  if not self.data then
    return
  end
  local icon = self.data.iconGet and self.data.iconGet() or self.data.icon
  self.imgSelectedIcon:LoadSpriteAuto(icon)
  self.imgUnselectedIcon:LoadSpriteAuto(icon)
end

return UIGMPanelPageToggle
