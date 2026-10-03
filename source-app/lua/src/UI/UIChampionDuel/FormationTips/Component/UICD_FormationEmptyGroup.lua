local UICD_FormationEmptyGroup = BaseClass("UICD_FormationEmptyGroup", UIAsyncContainer)
local base = UIAsyncContainer
local UICD_FormationEmptyItem = require("UI.UIChampionDuel.FormationTips.Component.UICD_FormationEmptyItem")
local text_title_path = "Title/EmptyText"
local scroll_view_path = "EmptyScroll"

function UICD_FormationEmptyGroup:OnCreate()
  base.OnCreate(self)
  self.teams = {}
  self.text_title = self:AddComponent(UIText, text_title_path)
  self.text_title:SetLocalText("champion_duel_tips1178")
  self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
  self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnCellMoveIn(itemObj, index)
  end)
  self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnCellMoveOut(itemObj, index)
  end)
end

function UICD_FormationEmptyGroup:OnDestroy()
  self.scroll_view:ClearCells()
  self.scroll_view:RemoveComponents(UICD_FormationEmptyItem)
  self.scroll_view = nil
  self.text_title = nil
  self.teams = {}
  base.OnDestroy(self)
end

function UICD_FormationEmptyGroup:UpdateData()
  self.teams = {}
  for i = 1, 3 do
    local team = DataCenter.ChampionDuelManager:GetSelfTeamByOrder(i)
    if team ~= nil then
      table.insert(self.teams, team)
    end
  end
  self.scroll_view:SetTotalCount(#self.teams)
  self.scroll_view:RefillCells()
end

function UICD_FormationEmptyGroup:OnCellMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scroll_view:AddComponent(UICD_FormationEmptyItem, itemObj)
  cellItem:ReInit(index, self.teams[index])
end

function UICD_FormationEmptyGroup:OnCellMoveOut(itemObj, index)
  self.scroll_view:RemoveComponent(itemObj.name, UICD_FormationEmptyItem)
end

return UICD_FormationEmptyGroup
