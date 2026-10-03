local TacticalPropertyGroupPanel = BaseClass("TacticalPropertyGroupPanel", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UICommonPropertyCanFoldItem = require("UI.UICommonPropertyCanFold.Component.UICommonPropertyCanFoldItem")

function TacticalPropertyGroupPanel:OnCreate()
  base.OnCreate(self)
  self.propertyGroupContent = self:AddComponent(UIBaseContainer, "PropertyGroupScrollView/Viewport/Content")
  self.cellReqs = {}
  self.cells = {}
end

function TacticalPropertyGroupPanel:OnDestroy()
  self:ClearList()
  self.propertyGroupContent = nil
  base.OnDestroy(self)
end

function TacticalPropertyGroupPanel:OnEnable()
  base.OnEnable(self)
end

function TacticalPropertyGroupPanel:OnDisable()
  base.OnDisable(self)
end

function TacticalPropertyGroupPanel:ReInit(param)
end

function TacticalPropertyGroupPanel:SetData(groupData)
  if groupData == nil then
    return
  end
  for i, v in ipairs(groupData.itemList) do
    self.cellReqs[i] = self:CreateItem(i, v)
  end
end

function TacticalPropertyGroupPanel:CreateItem(index, data)
  return self:GameObjectInstantiateAsync(UIAssets.UICommonPropertyCanFoldItem, function(request)
    if request.isError then
      return
    end
    local go = request.gameObject
    go:SetActive(true)
    go.transform:SetParent(self.propertyGroupContent.transform)
    go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    local nameStr = "propertyGroup_" .. index
    go.name = nameStr
    self.cells[index] = self.propertyGroupContent:AddComponent(UICommonPropertyCanFoldItem, nameStr)
    self.cells[index]:Refresh(data)
  end)
end

function TacticalPropertyGroupPanel:ClearList()
  if self.cellReqs then
    self.propertyGroupContent:RemoveComponents(UICommonPropertyCanFoldItem)
    for k, v in pairs(self.cellReqs) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.cellReqs = nil
  self.cells = nil
end

return TacticalPropertyGroupPanel
