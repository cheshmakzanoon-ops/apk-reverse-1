local UIDesertBattleIntroductionGroup = BaseClass("UIDesertBattleIntroductionGroup", UIBaseContainer)
local base = UIBaseContainer
local UIDesertBattleIntroductionItem = require("UI.UIActivityCenterTable.Component.DesertBattle.BattleCommander.Component.UIDesertBattleIntroductionItem")

function UIDesertBattleIntroductionGroup:OnCreate()
  base.OnCreate(self)
  self.scroll_view = self:AddComponent(UIScrollView, "ScrollView")
  self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreateItem(itemObj, index)
  end)
  self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeleteItem(itemObj, index)
  end)
  local list = {}
  list[1] = {
    title = "Desert_strom_commander_1030",
    desc = "Desert_strom_commander_1031"
  }
  list[2] = {
    title = "Desert_strom_commander_1032",
    desc = "Desert_strom_commander_1033"
  }
  self.dataList = list
end

function UIDesertBattleIntroductionGroup:OnDestroy()
  self.scroll_view:ClearCells()
  self.scroll_view:RemoveComponents(UIDesertBattleIntroductionItem)
  base.OnDestroy(self)
end

function UIDesertBattleIntroductionGroup:OnCreateItem(itemObj, idx)
  local data = self.dataList[idx]
  itemObj.name = tostring(idx)
  local item = self.scroll_view:AddComponent(UIDesertBattleIntroductionItem, itemObj)
  item:SetData(data)
end

function UIDesertBattleIntroductionGroup:OnDeleteItem(itemObj, idx)
  self.scroll_view:RemoveComponent(itemObj.name, UIDesertBattleIntroductionItem)
end

function UIDesertBattleIntroductionGroup:UpdateData()
  local cnt = #self.dataList
  self.scroll_view:SetTotalCount(cnt)
  if 0 < cnt then
    self.scroll_view:RefillCells()
    self.scroll_view:ScrollToCell(1, 1000)
  end
end

return UIDesertBattleIntroductionGroup
