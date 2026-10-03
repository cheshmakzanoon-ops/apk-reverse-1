local base = UIBaseView
local UIAllyDrillRewardView = BaseClass("UIAllyDrillRewardView", base)
local AllyDrillRewardPage = require("UI.UIAllyDrill.UIAllyDrillReward.Component.AllyDrillRewardPage")

function UIAllyDrillRewardView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:Refresh()
end

function UIAllyDrillRewardView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIAllyDrillRewardView:ComponentDefine()
  self.returnBtn = self:AddComponent(UIButton, "UICommonPopUpTitle/panel")
  self.closeBtn = self:AddComponent(UIButton, "Root/CloseBtn")
  self.returnBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.rewardPage = self:AddComponent(AllyDrillRewardPage, "Root/RewardPage")
end

function UIAllyDrillRewardView:ComponentDestroy()
end

function UIAllyDrillRewardView:DataDefine()
end

function UIAllyDrillRewardView:DataDestroy()
end

function UIAllyDrillRewardView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnAllyDrillRankRefresh, self.Refresh)
end

function UIAllyDrillRewardView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.OnAllyDrillRankRefresh, self.Refresh)
end

function UIAllyDrillRewardView:Refresh()
  self.rewardPage:Refresh(false)
end

return UIAllyDrillRewardView
