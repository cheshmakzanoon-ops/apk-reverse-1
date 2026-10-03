local base = UIBaseContainer
local UICommonToggleListItemComponent = BaseClass("UICommonToggleListItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UICommonToggleListItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UICommonToggleListItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UICommonToggleListItemComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compUnselect = self.viewSkin:AddComponent(self, UIBaseComponent, 1)
  self.btnUICommonToggleItem = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnUICommonToggleItem:SetOnClick(function()
    self:OnBtnUICommonToggleItemClick()
  end)
  self.textUnSelect = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.compSelect = self.viewSkin:AddComponent(self, UIBaseComponent, 4)
  self.textSelect = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.compRedDot = self.viewSkin:AddComponent(self, UIBaseComponent, 6)
  self.imageSelectBg = self.viewSkin:AddComponent(self, UIImage, 7)
  self.imageUnselectBg = self.viewSkin:AddComponent(self, UIImage, 8)
end

function UICommonToggleListItemComponent:ComponentDestroy()
  self.viewSkin = nil
  self.compUnselect = nil
  self.btnUICommonToggleItem = nil
  self.textUnSelect = nil
  self.compSelect = nil
  self.textSelect = nil
  self.compRedDot = nil
  self.imageSelectBg = nil
  self.imageUnselectBg = nil
end

function UICommonToggleListItemComponent:DataDefine()
  self.param = nil
end

function UICommonToggleListItemComponent:DataDestroy()
  self.param = nil
end

function UICommonToggleListItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function UICommonToggleListItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UICommonToggleListItemComponent:ReInit(param)
  if param == nil then
    return
  end
  self.param = param
  self.textSelect:SetText(self.param.data.name)
  self.textUnSelect:SetText(self.param.data.name)
  self:SetToggleBg()
end

function UICommonToggleListItemComponent:UpdateSelect(value)
  self.compSelect:SetActive(value)
  self.compUnselect:SetActive(not value)
end

function UICommonToggleListItemComponent:UpdateRed()
  local isShow = false
  if self.param then
    isShow = self.param.isShowRed(self.param)
  end
  self.compRedDot:SetActive(isShow)
end

function UICommonToggleListItemComponent:GetIndex()
  if self.param then
    return self.param.index
  end
  return 0
end

function UICommonToggleListItemComponent:OnBtnUICommonToggleItemClick()
  if self.param and self.param.onItemSelect then
    self.param.onItemSelect(self.param)
  end
end

function UICommonToggleListItemComponent:SetToggleBg()
  if self.param then
    local unselectBg = self.param.data.unselectBgPath
    local selectBg = self.param.data.selectBgPath
    if not string.IsNullOrEmpty(unselectBg) then
      self.imageUnselectBg:LoadSprite(unselectBg)
    end
    if not string.IsNullOrEmpty(selectBg) then
      self.imageSelectBg:LoadSprite(selectBg)
    end
    if self.param.data.selectTextColor then
      self.textSelect:SetColor(self.param.data.selectTextColor)
    end
    if self.param.data.unselectTextColor then
      self.textUnSelect:SetColor(self.param.data.unselectTextColor)
    end
  end
end

return UICommonToggleListItemComponent
