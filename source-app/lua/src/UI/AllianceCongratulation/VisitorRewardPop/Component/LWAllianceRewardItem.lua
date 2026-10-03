local base = UIBaseContainer
local LWAllianceRewardItem = BaseClass("LWAllianceRewardItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function LWAllianceRewardItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWAllianceRewardItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWAllianceRewardItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.uICommonResItem = self.viewSkin:AddComponent(self, UICommonResItem, 1)
end

function LWAllianceRewardItem:ComponentDestroy()
  self.viewSkin = nil
  self.uICommonResItem = nil
end

function LWAllianceRewardItem:DataDefine()
end

function LWAllianceRewardItem:DataDestroy()
end

function LWAllianceRewardItem:OnAddListener()
  base.OnAddListener(self)
end

function LWAllianceRewardItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LWAllianceRewardItem:ReInit(data)
  if not data then
    return
  end
  self.uICommonResItem:ReInit(data)
end

return LWAllianceRewardItem
