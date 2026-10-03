local base = UIAsyncContainer
local UIGMPanelPageVerticalDynamicButton = BaseClass("UIGMPanelPageVerticalDynamicButton", base)
local Localization = CS.GameEntry.Localization

function UIGMPanelPageVerticalDynamicButton:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIGMPanelPageVerticalDynamicButton:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIGMPanelPageVerticalDynamicButton:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btn = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.textTmpBtnName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.imgBtn = self.viewSkin:AddComponent(self, UIImage, 3)
end

function UIGMPanelPageVerticalDynamicButton:ComponentDestroy()
  self.viewSkin = nil
  self.btn = nil
  self.textTmpBtnName = nil
  self.imgBtn = nil
end

function UIGMPanelPageVerticalDynamicButton:DataDefine()
end

function UIGMPanelPageVerticalDynamicButton:DataDestroy()
end

function UIGMPanelPageVerticalDynamicButton:OnAddListener()
  base.OnAddListener(self)
end

function UIGMPanelPageVerticalDynamicButton:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIGMPanelPageVerticalDynamicButton:ReInit(data, parentItem)
  self.data = data
  self.parentItem = parentItem
  self.onClicked = self.data.onClicked
  if self.viewSkin then
    if type(self.data.btnName) == "function" then
      self.textTmpBtnName:SetText(self.data.btnName())
    else
      self.textTmpBtnName:SetText(self.data.btnName)
    end
    self:RefreshSkin()
  end
end

function UIGMPanelPageVerticalDynamicButton:OnBtnClick()
  if self.onClicked then
    self.onClicked()
    self:ReInit(self.data, self.parentItem)
  end
end

function UIGMPanelPageVerticalDynamicButton:RefreshSkin(skin)
  skin = skin or GMUtils.GetSkinPath()
  self.imgBtn:LoadSpriteAuto(skin.btnBg)
end

return UIGMPanelPageVerticalDynamicButton
