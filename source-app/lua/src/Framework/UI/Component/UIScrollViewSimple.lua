local base = UIScrollView
local UIScrollViewSimple = BaseClass("UIScrollViewSimple", base)

function UIScrollViewSimple:OnCreate()
  base.OnCreate(self)
  self.Script = nil
  self.DataList = {}
end

function UIScrollViewSimple:OnDestroy()
  self:Clear()
  self.Script = nil
  base.OnDestroy(self)
end

function UIScrollViewSimple:Init(script)
  self.Script = script
  self.DataList = {}
  self:SetOnItemMoveIn(function(itemObj, index)
    self:OnCellMoveIn(itemObj, index)
  end)
  self:SetOnItemMoveOut(function(itemObj, index)
    self:OnCellMoveOut(itemObj, index)
  end)
  if self.Script == nil then
    Logger.Log("UIScrollViewSimple:Init \230\156\170\228\188\160\229\133\165 Cell \230\168\161\230\157\191\229\175\185\229\186\148\231\154\132\232\132\154\230\156\172")
  end
end

function UIScrollViewSimple:Clear()
  if self.Script ~= nil then
    self:RemoveComponents(self.Script)
  end
  self:ClearCells()
  self.DataList = {}
end

function UIScrollViewSimple:AddData(cellData)
  assert(self.Script ~= nil, "UIScrollViewSimple:Show \230\156\170\229\136\157\229\167\139\229\140\150, \229\133\136 Init.")
  self.DataList = self.DataList or {}
  table.insert(self.DataList, cellData)
  return table.count(self.DataList)
end

function UIScrollViewSimple:Show()
  local dataCount = table.count(self.DataList)
  if dataCount <= 0 then
    Logger.Log("UIScrollViewSimple:Show \230\149\176\230\141\174\228\184\186\231\169\186, \229\133\136 AddData")
    return
  end
  self:SetTotalCount(dataCount)
  self:RefillCells()
end

function UIScrollViewSimple:OnCellMoveIn(itemObj, index)
  if IsNotNull(itemObj) then
    itemObj.name = UIUtil.GetLoopListItemIndex("Cell_")
    local cellItem = self:AddComponent(self.Script, itemObj)
    if cellItem ~= nil then
      cellItem:ReInit(self.DataList[index])
    end
  end
end

function UIScrollViewSimple:OnCellMoveOut(itemObj, index)
  if self.Script ~= nil and IsNotNull(itemObj) then
    self:RemoveComponent(itemObj.name, self.Script)
  end
end

return UIScrollViewSimple
