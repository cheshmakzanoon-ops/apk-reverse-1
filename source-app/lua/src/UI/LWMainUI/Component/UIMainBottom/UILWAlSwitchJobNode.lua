local UILWAlSwitchJobNode = BaseClass("UILWAlSwitchJobNode", UIAsyncProxy)
local base = UIAsyncProxy
local LuaPath = "UI.LWMainUI.Component.UIMainBottom.UILWAlSwitchJobTip"
local PrefabPath = "Assets/Main/Prefabs/UI/Alliance/Component/UILWAlInviteTip.prefab"

function UILWAlSwitchJobNode:OnCreate()
  base.OnCreate(self)
end

function UILWAlSwitchJobNode:OnDestroy()
  self.hide = nil
  base.OnDestroy(self)
end

function UILWAlSwitchJobNode:OnEnable()
  base.OnEnable(self)
  self:OnRefreshShow()
end

function UILWAlSwitchJobNode:OnDisable()
  base.OnDisable(self)
end

function UILWAlSwitchJobNode:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.AllianceRecommendRefreshJumpNew, self.OnRefreshShow)
  self:AddUIListener(EventId.AllianceBaseDataUpdated, self.OnRefreshShow)
end

function UILWAlSwitchJobNode:OnRemoveListener()
  self:RemoveUIListener(EventId.AllianceRecommendRefreshJumpNew, self.OnRefreshShow)
  self:RemoveUIListener(EventId.AllianceBaseDataUpdated, self.OnRefreshShow)
  base.OnRemoveListener(self)
end

function UILWAlSwitchJobNode:OnHideTip()
  self.hide = true
  self:OnRefreshShow()
end

function UILWAlSwitchJobNode:OnRefreshShow()
  if self.hide == true then
    self:TrySetShow(false)
  else
    local canShowTip = DataCenter.AllianceFeatureManager:GetAlSwitchJobNodeShow()
    self:TrySetShow(canShowTip)
  end
end

function UILWAlSwitchJobNode:TrySetShow(bool)
  if not bool then
    self:SetShow(false)
  end
  self.holder:TrySetShow(MainAlBubbleType.Invite, bool)
end

function UILWAlSwitchJobNode:SetShow(bool)
  self:SetActiveAsync(bool, LuaPath, PrefabPath)
end

return UILWAlSwitchJobNode
