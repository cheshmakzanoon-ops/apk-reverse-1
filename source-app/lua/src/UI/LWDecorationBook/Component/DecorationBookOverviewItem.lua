local DecorationBookOverviewItem = BaseClass("DecorationBookOverviewItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local DecorationBookOverviewSubItem = require("UI.LWDecorationBook.Component.DecorationBookOverviewSubItem")
local TypeToKey = {
  [1] = "building_center_desc4",
  [2] = "building_center_desc5",
  [3] = "building_center_desc6",
  [4] = "building_center_desc7"
}

function DecorationBookOverviewItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function DecorationBookOverviewItem:OnDestroy()
  self:SetAllCellDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function DecorationBookOverviewItem:ComponentDefine()
  self.titleText = self:AddComponent(UIText, "Title/TitleText")
  self.itemContent = self:AddComponent(UIBaseContainer, "ItemContent")
end

function DecorationBookOverviewItem:ComponentDestroy()
  self.titleText = nil
  self.itemContent = nil
end

function DecorationBookOverviewItem:DataDefine()
end

function DecorationBookOverviewItem:DataDestroy()
end

function DecorationBookOverviewItem:Refresh(data)
  self.data = data
  self.type = data.type
  self.titleText:SetLocalText(TypeToKey[self.type])
  local effectMap = DeepCopy(data.effectMap)
  self.effectList = {}
  for k, v in pairs(effectMap) do
    table.insert(self.effectList, {effectId = k, value = v})
  end
  table.sort(self.effectList, function(a, b)
    local effectTemplate1 = DataCenter.EffectNumberTemplateManager:GetTemplate(a.effectId)
    local effectTemplate2 = DataCenter.EffectNumberTemplateManager:GetTemplate(b.effectId)
    return effectTemplate1.display_order_gallery < effectTemplate2.display_order_gallery
  end)
  self:SetAllCellDestroy()
  for k, v in ipairs(self.effectList) do
    self.model[k] = self:GameObjectInstantiateAsync(UIAssets.UIDecorationBookSubItem, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go.gameObject:SetActive(true)
      go.transform:SetParent(self.itemContent.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      local nameStr = tostring(k)
      go.name = nameStr
      local cell = self.itemContent:AddComponent(DecorationBookOverviewSubItem, nameStr)
      cell:Refresh(v.effectId, v.value, k)
    end)
  end
end

function DecorationBookOverviewItem:SetAllCellDestroy()
  self.itemContent:RemoveComponents(DecorationBookOverviewSubItem)
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.model = {}
end

return DecorationBookOverviewItem
