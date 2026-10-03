local base = UIBaseContainer
local UIDurationDropItem = BaseClass("UIDurationDropItem", UIBaseContainer)

function UIDurationDropItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIDurationDropItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIDurationDropItem:ComponentDefine()
  self.desText = self:AddComponent(UITextMeshProUGUIEx, "itemText")
  self.checkBg = self:AddComponent(UIImage, "CheckBg")
  self.lineImg = self:AddComponent(UIImage, "Line")
  self.btn = self:AddComponent(UIButton, "btn")
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
end

function UIDurationDropItem:ComponentDestroy()
  self.desText = nil
  self.checkBg = nil
  self.lineImg = nil
  self.btn = nil
end

function UIDurationDropItem:ReInit(param, index)
  self.param = param
  self.index = index
  self.desText:SetColor(param.generalColor)
  self.desText:SetText(param.text)
end

function UIDurationDropItem:ChangeItem(selectIndex)
  local isSelect = self.index == selectIndex
  local color = isSelect and self.param.selectColor or self.param.generalColor
  self.checkBg:SetActive(isSelect)
  self.desText:SetColor(color)
end

function UIDurationDropItem:DataDefine()
end

function UIDurationDropItem:DataDestroy()
  self.param = nil
  self.index = nil
end

function UIDurationDropItem:OnBtnClick()
  if self.param and self.param.callBack then
    self.param.callBack(self.index)
  end
end

function UIDurationDropItem:OnAddListener()
  base.OnAddListener(self)
end

function UIDurationDropItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIDurationDropItem:OnBtnMaskClick()
end

return UIDurationDropItem
