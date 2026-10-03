local LWUIDesertBattleSoldierInfoContainer = BaseClass("LWUIDesertBattleSoldierInfoContainer", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local LWUIDesertBattleSoldierTreatmentInfoItem = require("UI.UIActivityCenterTable.Component.DesertBattle.UILWTreatmentSoldier.Component.LWUIDesertBattleSoldierTreatmentInfoItem")
local close_soldier_info_tips_btn_path = "CloseSoldierInfoTipsBtn"
local soldier_treatment_info_scroll_view_path = "ArrowBg/SoldierTreatmentInfoScrollView"

function LWUIDesertBattleSoldierInfoContainer:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function LWUIDesertBattleSoldierInfoContainer:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIDesertBattleSoldierInfoContainer:ComponentDefine()
  self.close_soldier_info_tips_btn = self:AddComponent(UIButton, close_soldier_info_tips_btn_path)
  self.close_soldier_info_tips_btn:SetOnClick(function()
    self:SetActive(false)
  end)
  self.soldier_treatment_info_scroll_view = self:AddComponent(UIScrollView, soldier_treatment_info_scroll_view_path)
  self.soldier_treatment_info_scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.soldier_treatment_info_scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
end

function LWUIDesertBattleSoldierInfoContainer:ComponentDestroy()
  self.close_soldier_info_tips_btn = nil
  self.soldier_treatment_info_scroll_view:ClearCells()
  self.soldier_treatment_info_scroll_view:RemoveComponents(LWUIDesertBattleSoldierTreatmentInfoItem)
  self.soldier_treatment_info_scroll_view = nil
end

function LWUIDesertBattleSoldierInfoContainer:ReInit()
  self.dataList = BattleFieldUtil.GetMgrActive():GetTreatmentSoldierDataList()
  local dataCount = table.count(self.dataList)
  if 0 < dataCount then
    self.soldier_treatment_info_scroll_view:SetTotalCount(dataCount)
    self.soldier_treatment_info_scroll_view:RefillCells()
  end
end

function LWUIDesertBattleSoldierInfoContainer:OnItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local itemRender = self.soldier_treatment_info_scroll_view:AddComponent(LWUIDesertBattleSoldierTreatmentInfoItem, itemObj)
  if itemRender ~= nil then
    itemRender:ReInit(self.dataList[index])
  end
end

function LWUIDesertBattleSoldierInfoContainer:OnItemMoveOut(itemObj, index)
  self.soldier_treatment_info_scroll_view:RemoveComponent(itemObj.name, LWUIDesertBattleSoldierTreatmentInfoItem)
end

return LWUIDesertBattleSoldierInfoContainer
