local base = UIBaseContainer
local UILWSeasonMilitaryItemCell = BaseClass("UILWSeasonMilitaryItemCell", UIBaseContainer)

function UILWSeasonMilitaryItemCell:ComponentDefine()
  self.p_comp_item = self:AddComponent(UICommonResItem, "p_comp_item")
end

function UILWSeasonMilitaryItemCell:ComponentDestroy()
  self.p_comp_item = nil
end

function UILWSeasonMilitaryItemCell:DataDefine()
end

function UILWSeasonMilitaryItemCell:DataDestroy()
end

function UILWSeasonMilitaryItemCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWSeasonMilitaryItemCell:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonMilitaryItemCell:OnAddListener()
  base.OnAddListener(self)
end

function UILWSeasonMilitaryItemCell:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWSeasonMilitaryItemCell:ReInit(data)
  if self:InitData(data) then
    self:InitUi()
  end
end

function UILWSeasonMilitaryItemCell:InitData(data)
  if data ~= nil then
    self.Data = data
    return true
  end
  return false
end

function UILWSeasonMilitaryItemCell:InitUi()
  local cellData = {}
  cellData.rewardType = self.Data.rewardType
  cellData.itemId = checkstring(self.Data.itemId)
  cellData.count = checknumber(self.Data.count)
  self.p_comp_item:ReInit(cellData)
end

return UILWSeasonMilitaryItemCell
