local base = UIBaseContainer
local BattleSkillList = BaseClass("BattleSkillList", base)
local BattleSkillCell = require("UI.UIActivityCenterTable.Component.ActEpidemic.BattleSkill.Component.BattleSkillCell")
local scrollView_path = "ScrollView"
local content_path = "ScrollView/Viewport/Content"

function BattleSkillList:OnCreate()
  base.OnCreate(self)
  self.cells = {}
  self.scrollView = self:AddComponent(UILoopListView2, scrollView_path)
  self.scrollView:InitListView(0, function(listview, index)
    return self:TryGetScrollItem(listview, index)
  end)
  self.content = self:AddComponent(UIBaseContainer, content_path)
end

function BattleSkillList:OnDestroy()
  self.content:RemoveComponents(BattleSkillCell)
  self.scrollView:ClearAllItems()
  self.content = nil
  self.scrollView = nil
  self.rankCells = {}
  base.OnDestroy(self)
end

function BattleSkillList:UpdateData()
  local bLord = DataCenter.ActEpidemicZoneManager:GetCurRole() == EpidemicZoneRole.Lord
  local types = bLord and {
    EpidemicZoneSkillType.LordActive
  } or {
    EpidemicZoneSkillType.FarmerActive
  }
  local dataList = DataCenter.ActEpidemicZoneManager:GetTemplateSkillIds(types)
  local l = #dataList
  if l == 0 then
    self.scrollView:SetActive(false)
    return
  end
  self.dataList = dataList
  self.scrollView:SetActive(true)
  self.scrollView:SetListItemCount(l, false, false)
  self.scrollView:RefreshAllShownItem()
end

function BattleSkillList:TryGetScrollItem(listview, index)
  local dataList = self.dataList or {}
  if table.IsNullOrEmpty(dataList) then
    return nil
  end
  local len = #dataList
  local idx = index + 1
  if idx < 1 or len < idx then
    return nil
  end
  local csItem = listview:NewListViewItem("BattleSkillCell")
  local item = self.cells[csItem]
  if item == nil then
    local prefabIndex = self.prefabIndex or 0
    local nameStr = "Cell" .. prefabIndex
    self.prefabIndex = prefabIndex + 1
    csItem.gameObject.name = nameStr
    item = self.content:AddComponent(BattleSkillCell, nameStr)
    self.cells[csItem] = item
  end
  if item ~= nil then
    item:UpdateData(dataList[idx], true, idx == len)
  end
  return csItem
end

return BattleSkillList
