local UIDecorationTypeCell = BaseClass("UIDecorationTypeCell", UIBaseContainer)
local base = UIBaseContainer
local compBook = {
  {
    path = "",
    name = "btn",
    type = UIButton,
    onClick = function(self)
      self:ClickBtn()
    end
  },
  {
    path = "Selected",
    name = "select",
    type = UIBaseContainer
  },
  {
    path = "Selected/SelectedTextTab",
    name = "select_name",
    type = UIText
  },
  {
    path = "Normal",
    name = "normal",
    type = UIBaseContainer
  },
  {
    path = "Normal/NormalTextTab",
    name = "normal_name",
    type = UIText
  },
  {
    path = "RedPoint",
    name = "redPoint",
    type = UIImage
  }
}

function UIDecorationTypeCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIDecorationTypeCell:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIDecorationTypeCell:ComponentDefine()
  self:DefineCompsByBook(compBook)
end

function UIDecorationTypeCell:ComponentDestroy()
  self:ClearCompsByBook(compBook)
end

function UIDecorationTypeCell:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.UserSkinUpdate, self.RefreshRedPoint)
  self:AddUIListener(EventId.RefreshItems, self.RefreshRedPoint)
end

function UIDecorationTypeCell:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.UserSkinUpdate, self.RefreshRedPoint)
  self:RemoveUIListener(EventId.RefreshItems, self.RefreshRedPoint)
end

function UIDecorationTypeCell:SetData(data, selected)
  self.data = data
  self.select_name:SetLocalText(self.data.name)
  self.normal_name:SetLocalText(self.data.name)
  if self.view.ctrl then
    self.redPoint:SetActive(self.view.ctrl:IsTypeShowRedPoint(self.data.id))
  end
  self:SetSelected(selected)
end

function UIDecorationTypeCell:SetSelected(selected)
  self.normal:SetActive(not selected)
  self.select:SetActive(selected)
end

function UIDecorationTypeCell:ClickBtn()
  self.view:SetCurrentType(self.data.id)
end

function UIDecorationTypeCell:RefreshRedPoint()
  if self.view.ctrl and self.redPoint and self.data then
    self.redPoint:SetActive(self.view.ctrl:IsTypeShowRedPoint(self.data.id))
  end
end

return UIDecorationTypeCell
