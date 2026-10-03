local UIGhostParkourRankPageRewardPopView = BaseClass("UIGhostParkourRankPageRewardPopView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local RewardItem = require("UI.UIGhostParkour.Outside.RankInfoRewardPop.Component.UIGhostParkourRankPageRewardItem")

function UIGhostParkourRankPageRewardPopView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshList()
end

function UIGhostParkourRankPageRewardPopView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIGhostParkourRankPageRewardPopView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnPanel = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.textDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.scrollView = self.viewSkin:AddComponent(self, UIScrollView, 5)
  self.scrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.scrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
end

function UIGhostParkourRankPageRewardPopView:ComponentDestroy()
  self.viewSkin = nil
  self.btnPanel = nil
  self.textTitle = nil
  self.btnClose = nil
  self.textDesc = nil
  self.scrollView = nil
end

function UIGhostParkourRankPageRewardPopView:DataDefine()
end

function UIGhostParkourRankPageRewardPopView:DataDestroy()
end

function UIGhostParkourRankPageRewardPopView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.GhostParkourRankInfoRefresh, self.RefreshList)
end

function UIGhostParkourRankPageRewardPopView:OnRemoveListener()
  self:RemoveUIListener(EventId.GhostParkourRankInfoRefresh, self.RefreshList)
  base.OnRemoveListener(self)
end

function UIGhostParkourRankPageRewardPopView:OnBtnPanelClick()
  self.ctrl:CloseSelf()
end

function UIGhostParkourRankPageRewardPopView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function UIGhostParkourRankPageRewardPopView:ClearScroll()
  self.scrollView:ClearCells()
  self.scrollView:RemoveComponents(RewardItem)
  self.showDatalist = {}
end

function UIGhostParkourRankPageRewardPopView:RefreshList()
  self:ClearScroll()
  self.showDatalist = DataCenter.LWGhostParkourDataManager:GetGhostParkourTierConfigInfo()
  if #self.showDatalist > 0 then
    self.scrollView:SetTotalCount(#self.showDatalist)
    self.scrollView:RefillCells()
  end
end

function UIGhostParkourRankPageRewardPopView:OnItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scrollView:AddComponent(RewardItem, itemObj)
  cellItem:SetData(self.showDatalist[index])
end

function UIGhostParkourRankPageRewardPopView:OnItemMoveOut(itemObj, index)
  self.scrollView:RemoveComponent(itemObj.name, RewardItem)
end

return UIGhostParkourRankPageRewardPopView
