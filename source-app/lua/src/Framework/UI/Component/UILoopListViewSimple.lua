local content_path = "Viewport/Content"
local base = require("Framework.UI.Component.UILoopListView2")
local UILoopListViewSimple = BaseClass("UILoopListViewSimple", base)

function UILoopListViewSimple:OnCreate()
  base.OnCreate(self)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.Items = {}
  self.Scripts = {}
  self.DataList = {}
end

function UILoopListViewSimple:OnDestroy()
  self:Clear()
  self.content = nil
  self.Scripts = {}
  base.OnDestroy(self)
end

function UILoopListViewSimple:Init(...)
  self.Items = {}
  self.Scripts = {
    ...
  }
  self.DataList = {}
  self:InitListView(0, function(listView, index)
    return self:TryGetCell(listView, index)
  end)
  if 0 >= table.count(self.Scripts) then
    Logger.Log("UILoopListViewSimple:Init \230\156\170\228\188\160\229\133\165 Cell \230\168\161\230\157\191\229\175\185\229\186\148\231\154\132\232\132\154\230\156\172")
  end
end

function UILoopListViewSimple:Clear()
  self.Items = {}
  if not table.IsNullOrEmpty(self.Scripts) then
    for _, script in ipairs(self.Scripts) do
      self.content:RemoveComponents(script)
    end
  end
  self:ClearAllItems()
  self.DataList = {}
end

function UILoopListViewSimple:AddData(cellData, prefabIndex)
  assert(table.count(self.Scripts) > 0, "UILoopListViewSimple:AddData \230\156\170\229\136\157\229\167\139\229\140\150, \229\133\136 Init.")
  prefabIndex = Mathf.Clamp(checknumber(prefabIndex), 1, table.count(self.Scripts))
  assert(prefabIndex <= table.count(self.Scripts), "UILoopListViewSimple:AddData prefabIndex \232\182\133\229\135\186\232\140\131\229\155\180, \232\175\183\230\163\128\230\159\165 Init \228\188\160\229\133\165\231\154\132\232\132\154\230\156\172\230\149\176\233\135\143, \228\187\142 1 \229\188\128\229\167\139.")
  self.DataList = self.DataList or {}
  local data = {}
  data.Data = cellData
  data.PrefabIndex = prefabIndex
  table.insert(self.DataList, data)
  return table.count(self.DataList)
end

function UILoopListViewSimple:Show(ToMinPos, toMaxPos)
  local dataCount = table.count(self.DataList)
  if dataCount <= 0 then
    Logger.Log("UILoopListViewSimple:Show \230\149\176\230\141\174\228\184\186\231\169\186, \229\133\136 AddData")
    return
  end
  ToMinPos = ToMinPos or false
  toMaxPos = toMaxPos or false
  self:SetListItemCount(dataCount, ToMinPos, toMaxPos)
  self:RefreshAllShownItem()
end

function UILoopListViewSimple:TryGetCell(listView, index)
  local dataList = self.DataList
  if dataList == nil or #dataList <= 0 then
    return nil
  end
  index = index + 1
  if index < 1 or index > #dataList then
    return nil
  end
  local csItem, script
  local data = dataList[index]
  csItem = listView:NewListViewItemByIndex(data.PrefabIndex - 1)
  script = self.Scripts[data.PrefabIndex]
  if csItem == nil or script == nil then
    return nil
  end
  if self.Items[csItem] == nil then
    local name = UIUtil.GetLoopListItemIndex("Cell_")
    csItem.gameObject.name = name
    self.Items[csItem] = self.content:AddComponent(script, name)
  end
  if self.Items[csItem] ~= nil then
    self.Items[csItem]:ReInit(data.Data)
  end
  return csItem
end

return UILoopListViewSimple
