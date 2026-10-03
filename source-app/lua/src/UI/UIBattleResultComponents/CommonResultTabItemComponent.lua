local base = UIBaseContainer
local CommonResultTabItemComponent = BaseClass("CommonResultTabItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function CommonResultTabItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function CommonResultTabItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function CommonResultTabItemComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgNodeActive = self.viewSkin:AddComponent(self, UIImage, 1)
  self.textTxtActive = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.imgNodeInactive = self.viewSkin:AddComponent(self, UIImage, 3)
  self.textTxtInactive = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.btnCommonResultTabItem = self.viewSkin:AddComponent(self, UIButton, 5)
  self.btnCommonResultTabItem:SetOnClick(function()
    self:OnBtnCommonResultTabItemClick()
  end)
end

function CommonResultTabItemComponent:ComponentDestroy()
  self.viewSkin = nil
  self.imgNodeActive = nil
  self.textTxtActive = nil
  self.imgNodeInactive = nil
  self.textTxtInactive = nil
  self.btnCommonResultTabItem = nil
end

function CommonResultTabItemComponent:DataDefine()
  self.isOn = false
end

function CommonResultTabItemComponent:DataDestroy()
  self.isOn = false
  self.onTabClick = nil
  self.index = nil
  self.data = nil
end

function CommonResultTabItemComponent:OnBtnCommonResultTabItemClick()
  self:SetIsOn(true)
end

function CommonResultTabItemComponent:ReInit(index, data, onTabClick)
  self.index = index
  self.data = data
  self.onTabClick = onTabClick
  self.textTxtInactive:SetText(data.inActiveTxt or "")
  self.textTxtActive:SetText(data.activeTxt or "")
  self:SetIsOn(false)
end

function CommonResultTabItemComponent:SetIsOn(isOn)
  self.imgNodeActive:SetActive(isOn)
  self.imgNodeInactive:SetActive(not isOn)
  if not self.isOn and isOn and self.onTabClick then
    self.onTabClick(self.index, self.data)
  end
  self.isOn = isOn
end

return CommonResultTabItemComponent
