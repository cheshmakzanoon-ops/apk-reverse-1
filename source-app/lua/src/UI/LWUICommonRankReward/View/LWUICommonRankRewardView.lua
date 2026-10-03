local LWUICommonRankRewardView = BaseClass("LWUICommonRankRewardView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local LWUIWorldBossRewardItem = require("UI.LWUIWorldBossReward.Component.LWUIWorldBossRewardItem")
local panel_path = "Panel"
local text_title_path = "safearea/TopBar/TextTitle"
local btn_close_path = "safearea/BtnClose"
local rank_scroll_view_path = "mainObj/MiddleBg/rankScrollView"

function LWUICommonRankRewardView:OnCreate()
  base.OnCreate(self)
  self.showDataList = self:GetUserData()
  self.panel = self:AddComponent(UIButton, panel_path)
  self.panel:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.text_title = self:AddComponent(UIText, text_title_path)
  self.text_title:SetLocalText(302026)
  self.btn_close = self:AddComponent(UIButton, btn_close_path)
  self.btn_close:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.ScrollView = self:AddComponent(UIScrollView, rank_scroll_view_path)
  self.ScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.ScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
  self:RefreshList()
end

function LWUICommonRankRewardView:OnDestroy()
  self:ClearScroll()
  self.panel = nil
  self.text_title = nil
  self.btn_close = nil
  self.ScrollView = nil
  base.OnDestroy(self)
end

function LWUICommonRankRewardView:ClearScroll()
  self.ScrollView:ClearCells()
  self.ScrollView:RemoveComponents(LWUIWorldBossRewardItem)
end

function LWUICommonRankRewardView:RefreshList()
  self:ClearScroll()
  if #self.showDataList > 0 then
    self.ScrollView:SetTotalCount(#self.showDataList)
    self.ScrollView:RefillCells()
  end
end

function LWUICommonRankRewardView:OnItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.ScrollView:AddComponent(LWUIWorldBossRewardItem, itemObj)
  cellItem:SetData(self.showDataList[index])
end

function LWUICommonRankRewardView:OnItemMoveOut(itemObj, index)
  self.ScrollView:RemoveComponent(itemObj.name, LWUIWorldBossRewardItem)
end

return LWUICommonRankRewardView
