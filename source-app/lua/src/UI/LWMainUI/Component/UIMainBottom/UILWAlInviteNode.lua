local UILWAlInviteNode = BaseClass("UILWAlInviteNode", UIAsyncProxy)
local base = UIAsyncProxy
local LuaPath = "UI.LWMainUI.Component.UIMainBottom.UILWAlInviteTip"
local PrefabPath = "Assets/Main/Prefabs/UI/Alliance/Component/UILWAlInviteTip.prefab"

function UILWAlInviteNode:OnCreate()
  base.OnCreate(self)
end

function UILWAlInviteNode:OnDestroy()
  self.hide = nil
  base.OnDestroy(self)
end

function UILWAlInviteNode:OnEnable()
  base.OnEnable(self)
  self:OnRefreshShow()
end

function UILWAlInviteNode:OnDisable()
  base.OnDisable(self)
end

function UILWAlInviteNode:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnGetNewAllianceAutoInvite, self.OnRefreshShow)
end

function UILWAlInviteNode:OnRemoveListener()
  self:RemoveUIListener(EventId.OnGetNewAllianceAutoInvite, self.OnRefreshShow)
  base.OnRemoveListener(self)
end

function UILWAlInviteNode:OnHideTip()
  self.hide = true
  self:OnRefreshShow()
end

function UILWAlInviteNode:OnRefreshShow()
  if self.hide == true then
    self:TrySetShow(false)
  else
    local canShowTip = DataCenter.AllianceAutoInviteManager:CheckIfNeedAutoInviteChatRoom()
    self:TrySetShow(canShowTip)
  end
end

function UILWAlInviteNode:TrySetShow(bool)
  if not bool then
    self:SetShow(false)
  end
  self.holder:TrySetShow(MainAlBubbleType.Invite, bool)
end

function UILWAlInviteNode:SetShow(bool)
  self:SetActiveAsync(bool, LuaPath, PrefabPath)
end

return UILWAlInviteNode
