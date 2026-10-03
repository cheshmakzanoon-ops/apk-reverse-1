local UICD_FormationLvGroup = BaseClass("UICD_FormationLvGroup", UIAsyncContainer)
local base = UIAsyncContainer
local UICD_FormationLvItem = require("UI.UIChampionDuel.FormationTips.Component.UICD_FormationLvItem")
local text_title_path = "Title/LvText"
local mid_path = "Mid"
local text_tip_path = "Mid/LvTipText"
local scroll_view_path = "LvScroll"

function UICD_FormationLvGroup:OnCreate()
  base.OnCreate(self)
  self.text_title = self:AddComponent(UIText, text_title_path)
  self.text_title:SetLocalText("champion_duel_tips1176")
  self.mid = self:AddComponent(UIBaseComponent, mid_path)
  self.text_tip = self:AddComponent(UIText, text_tip_path)
  self.text_tip:SetLocalText("champion_duel_tips1177")
  self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
  self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnCellMoveIn(itemObj, index)
  end)
  self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnCellMoveOut(itemObj, index)
  end)
end

function UICD_FormationLvGroup:OnDestroy()
  self.notBeastUuids = nil
  self.scroll_view:ClearCells()
  self.scroll_view:RemoveComponents(UICD_FormationLvItem)
  self.scroll_view = nil
  self.mid = nil
  self.text_tip = nil
  self.text_title = nil
  base.OnDestroy(self)
end

function UICD_FormationLvGroup:SetData(notBeastUuids)
  self.notBeastUuids = notBeastUuids
  self:RefreshView()
end

function UICD_FormationLvGroup:UpdateData()
  if table.IsNullOrEmpty(self.notBeastUuids) then
    return
  end
  self.scroll_view:SetTotalCount(#self.notBeastUuids)
  self.scroll_view:RefillCells()
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.mid.rectTransform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.rectTransform)
end

function UICD_FormationLvGroup:OnCellMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scroll_view:AddComponent(UICD_FormationLvItem, itemObj)
  cellItem:ReInit(self.notBeastUuids[index])
end

function UICD_FormationLvGroup:OnCellMoveOut(itemObj, index)
  self.scroll_view:RemoveComponent(itemObj.name, UICD_FormationLvItem)
end

return UICD_FormationLvGroup
