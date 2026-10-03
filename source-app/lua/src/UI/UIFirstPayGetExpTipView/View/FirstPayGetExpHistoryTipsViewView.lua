local base = require("UI.UILWHero.UIHeroSimpleTip.View.UIArrowTipBase")
local FirstPayGetExpHistoryTipsViewView = BaseClass("FirstPayGetExpHistoryTipsViewView", base)
local Localization = CS.GameEntry.Localization
local FirstPayGetExpHistoryInfoCptComponent = require("UI.UIFirstPay.Component.FirstPayGetExpHistoryInfoCptComponent")

function FirstPayGetExpHistoryTipsViewView:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:RefreshView()
end

function FirstPayGetExpHistoryTipsViewView:OnDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function FirstPayGetExpHistoryTipsViewView:ComponentDefine()
  base.ComponentDefine(self)
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compRoot = self.viewSkin:AddComponent(self, UIBaseComponent, 1)
  self.compFirstPayGetExpHistoryInfoCpt = self.viewSkin:AddComponent(self, FirstPayGetExpHistoryInfoCptComponent, 2)
end

function FirstPayGetExpHistoryTipsViewView:ComponentDestroy()
  base.ComponentDestroy(self)
  self.viewSkin = nil
  self.compRoot = nil
  self.compFirstPayGetExpHistoryInfoCpt = nil
end

function FirstPayGetExpHistoryTipsViewView:DataDefine()
end

function FirstPayGetExpHistoryTipsViewView:DataDestroy()
end

function FirstPayGetExpHistoryTipsViewView:OnAddListener()
  base.OnAddListener(self)
end

function FirstPayGetExpHistoryTipsViewView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function FirstPayGetExpHistoryTipsViewView:RefreshView()
  self.compFirstPayGetExpHistoryInfoCpt:RefreshView()
end

return FirstPayGetExpHistoryTipsViewView
