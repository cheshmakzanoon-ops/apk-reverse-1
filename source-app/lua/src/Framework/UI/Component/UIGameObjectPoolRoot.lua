local base = UIBaseContainer
local UIGameObjectPoolRoot = BaseClass("UIGameObjectPoolRoot", base)

function UIGameObjectPoolRoot:OnCreate()
  base.OnCreate(self)
  self.Script = nil
  self.DataList = {}
end

function UIGameObjectPoolRoot:OnDestroy()
  self:Clear()
  self.ItemPool = nil
  self.Script = nil
  self.DataList = {}
  base.OnDestroy(self)
end

function UIGameObjectPoolRoot:Init(goTemplate, script)
  assert(goTemplate ~= nil, "UIGameObjectPoolRoot:Init \230\156\170\228\188\160\229\133\165 gameObject \230\168\161\230\157\191")
  self:Clear()
  self.ItemPool = goTemplate
  self.GoName = goTemplate.name
  self.ItemPool:GameObjectCreatePool()
  self.ItemPool:SetActive(false)
  self.Script = script
  if self.Script == nil then
    Logger.Log("UIGameObjectPoolRoot:Init \230\156\170\228\188\160\229\133\165 Cell \230\168\161\230\157\191\229\175\185\229\186\148\231\154\132\232\132\154\230\156\172")
  end
end

function UIGameObjectPoolRoot:Clear()
  if self.Script ~= nil then
    self:RemoveComponents(self.Script)
  end
  if self.ItemPool ~= nil then
    self.ItemPool:GameObjectRecycleAll()
  end
  self.DataList = {}
end

function UIGameObjectPoolRoot:AddData(cellData)
  if self.ItemPool == nil then
    Logger.Log("UIGameObjectPoolRoot:AddData \230\156\170\229\136\157\229\167\139\229\140\150, \229\133\136 Init.")
    return table.count(self.DataList)
  end
  self.DataList = self.DataList or {}
  local data = {}
  data.Data = cellData
  table.insert(self.DataList, data)
  data.Item = self.ItemPool:GameObjectSpawn(self.transform)
  data.Item.name = UIUtil.GetLoopListItemIndex(self.GoName)
  data.Item:SetActive(true)
  if self.Script ~= nil then
    data.Comp = self:AddComponent(self.Script, data.Item.name)
    data.Comp:ReInit(cellData)
  end
  return table.count(self.DataList)
end

function UIGameObjectPoolRoot:Show()
end

return UIGameObjectPoolRoot
