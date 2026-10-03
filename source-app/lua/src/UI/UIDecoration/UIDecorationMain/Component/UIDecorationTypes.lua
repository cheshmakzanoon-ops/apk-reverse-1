local UIDecorationTypes = BaseClass("UIDecorationTypes", UIBaseContainer)
local base = UIBaseContainer
local UIDecorationTypeCell = require("UI.UIDecoration.UIDecorationMain.Component.UIDecorationTypeCell")
local compBook = {
  {
    path = "",
    name = "scroll",
    type = UIScrollRect
  },
  {
    path = "Viewport/Content",
    name = "content",
    type = UIBaseContainer
  },
  {
    path = "Viewport/Content/template",
    name = "template",
    type = nil,
    active = false
  }
}

function UIDecorationTypes:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIDecorationTypes:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIDecorationTypes:ComponentDefine()
  self:DefineCompsByBook(compBook)
end

function UIDecorationTypes:ComponentDestroy()
  if self.itemComps ~= nil then
    for _, itemComp in pairs(self.itemComps) do
      local itemGO = itemComp.gameObject
      if not IsNull(itemGO) then
        self.content:RemoveComponent(itemGO.name, UIDecorationTypeCell)
        CS.UnityEngine.GameObject.Destroy(itemGO)
      end
    end
  end
  self.itemComps = nil
  self:ClearCompsByBook(compBook)
end

function UIDecorationTypes:SetData(dataList, selectedId)
  if not self.itemComps then
    self.itemComps = {}
    local selectedItem
    for _, data in ipairs(dataList) do
      local itemGO = CS.UnityEngine.GameObject.Instantiate(self.template, self.content.transform)
      itemGO.name = "type" .. data.id
      local itemComp = self.content:AddComponent(UIDecorationTypeCell, itemGO)
      self.itemComps[data.id] = itemComp
      local selected = data.id == selectedId
      itemComp:SetData(data, selected)
      itemComp:SetActive(true)
      if selected then
        selectedItem = itemComp
      end
    end
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.transform)
    if selectedItem then
      self.content:SetAnchoredPositionXY(-selectedItem:GetAnchoredPositionX() + 100, self.content:GetAnchoredPositionY())
    else
      self.content:SetAnchoredPositionXY(0, self.content:GetAnchoredPositionY())
    end
  end
end

function UIDecorationTypes:SetSelected(selectedId)
  if self.itemComps then
    for id, itemComp in pairs(self.itemComps) do
      itemComp:SetSelected(id == selectedId)
    end
  end
end

return UIDecorationTypes
