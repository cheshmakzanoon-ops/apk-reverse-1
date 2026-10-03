local base = UIBaseContainer
local LWAllianceThumbsUpPopHeadItem = BaseClass("LWAllianceThumbsUpPopHeadItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function LWAllianceThumbsUpPopHeadItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWAllianceThumbsUpPopHeadItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWAllianceThumbsUpPopHeadItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compUIPlayerHead = self.viewSkin:AddComponent(self, UICommonHead, 1)
end

function LWAllianceThumbsUpPopHeadItem:ComponentDestroy()
  self.viewSkin = nil
  self.compUIPlayerHead = nil
end

function LWAllianceThumbsUpPopHeadItem:DataDefine()
end

function LWAllianceThumbsUpPopHeadItem:DataDestroy()
end

function LWAllianceThumbsUpPopHeadItem:OnAddListener()
  base.OnAddListener(self)
end

function LWAllianceThumbsUpPopHeadItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LWAllianceThumbsUpPopHeadItem:ReInit(data)
  if not data then
    return
  end
  self.compUIPlayerHead:ParseHeadInfo(data)
end

return LWAllianceThumbsUpPopHeadItem
