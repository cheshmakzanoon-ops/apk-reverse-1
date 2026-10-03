local base = UIAsyncContainer
local UIActDsbDuelRewardSheetPersonal = BaseClass("UIActDsbDuelRewardSheetPersonal", UIAsyncContainer)
local UIActDsbDuelRewardSheetWinnerItem = require("UI.BFDsbDuel.BFDsbDuelReward.Component.UIActDsbDuelRewardSheetWinnerItem")
local Localization = CS.GameEntry.Localization

function UIActDsbDuelRewardSheetPersonal:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIActDsbDuelRewardSheetPersonal:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIActDsbDuelRewardSheetPersonal:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTips = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 2)
  self.scrollViewRewardRect = self.viewSkin:AddComponent(self, UIScrollView, 3)
  self.textTips:SetLocalText("dsb_duel_interface_1063")
  self.scrollViewRewardRect:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.scrollViewRewardRect:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
end

function UIActDsbDuelRewardSheetPersonal:ComponentDestroy()
  self:ClearScroll()
  self.viewSkin = nil
  self.textTips = nil
  self.compContent = nil
  self.scrollViewRewardRect = nil
end

function UIActDsbDuelRewardSheetPersonal:DataDefine()
end

function UIActDsbDuelRewardSheetPersonal:DataDestroy()
end

function UIActDsbDuelRewardSheetPersonal:OnAddListener()
  base.OnAddListener(self)
end

function UIActDsbDuelRewardSheetPersonal:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIActDsbDuelRewardSheetPersonal:RefreshRewardList()
  self.rankList = self:GetRewardList()
  if #self.rankList > 0 then
    self.scrollViewRewardRect:SetTotalCount(#self.rankList)
    self.scrollViewRewardRect:RefillCells()
  end
end

function UIActDsbDuelRewardSheetPersonal:GetRewardList()
  return table.values(BattlefieldDsbDuelUtils.ActInfo:GetPersonalRewardId()) or {}
end

function UIActDsbDuelRewardSheetPersonal:OnItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scrollViewRewardRect:AddComponent(UIActDsbDuelRewardSheetWinnerItem, itemObj)
  if cellItem ~= nil then
    cellItem:ReInit(index, self.rankList[index])
  end
end

function UIActDsbDuelRewardSheetPersonal:OnItemMoveOut(itemObj, index)
  self.scrollViewRewardRect:RemoveComponent(itemObj.name, UIActDsbDuelRewardSheetWinnerItem)
end

function UIActDsbDuelRewardSheetPersonal:ClearScroll()
  self.scrollViewRewardRect:ClearCells()
  self.scrollViewRewardRect:RemoveComponents(UIActDsbDuelRewardSheetWinnerItem)
end

function UIActDsbDuelRewardSheetPersonal:RefreshSheet()
  self:RefreshRewardList()
end

return UIActDsbDuelRewardSheetPersonal
