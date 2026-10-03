local UILWAl1stJoinNode = BaseClass("UILWAl1stJoinNode", UIAsyncProxy)
local base = UIAsyncProxy
local LuaPath = "UI.LWMainUI.Component.UIMainBottom.UILWAl1stJoinTip"
local PrefabPath = "Assets/Main/Prefabs/UI/Alliance/Component/UILWAl1stJoinTip.prefab"

function UILWAl1stJoinNode:OnCreate()
  base.OnCreate(self)
end

function UILWAl1stJoinNode:OnDestroy()
  base.OnDestroy(self)
end

function UILWAl1stJoinNode:OnEnable()
  base.OnEnable(self)
  self:OnRefreshShow()
end

function UILWAl1stJoinNode:OnDisable()
  base.OnDisable(self)
end

function UILWAl1stJoinNode:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.AllianceApplySuccess, self.OnRefreshShow)
  self:AddUIListener(EventId.UILWAllianceFirstJoinOpen, self.OnHideTip)
end

function UILWAl1stJoinNode:OnRemoveListener()
  self:RemoveUIListener(EventId.AllianceApplySuccess, self.OnRefreshShow)
  self:RemoveUIListener(EventId.UILWAllianceFirstJoinOpen, self.OnHideTip)
  base.OnRemoveListener(self)
end

function UILWAl1stJoinNode:OnHideTip()
  self.hide = true
  self:OnRefreshShow()
end

function UILWAl1stJoinNode:OnRefreshShow()
  if self.hide == true then
    self:TrySetShow(false)
  else
    if not LuaEntry.Player.AllianceFirstShowTips then
      self:TrySetShow(false)
      return
    end
    self:TrySetShow(LuaEntry.Player:IsFirstJoinAlliance())
  end
end

function UILWAl1stJoinNode:TrySetShow(bool)
  if not bool then
    self:SetShow(false)
  end
  self.holder:TrySetShow(MainAlBubbleType.Join, bool)
end

function UILWAl1stJoinNode:SetShow(bool)
  self:SetActiveAsync(bool, LuaPath, PrefabPath)
end

return UILWAl1stJoinNode
