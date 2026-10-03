local UIAlStarBubbleNode = BaseClass("UIAlStarBubbleNode", UIAsyncProxy)
local base = UIAsyncProxy
local LuaPath = "UI.LWMainUI.Component.UIMainBottom.UIAlStarBubbleTip"
local PrefabPath = "Assets/Main/Prefabs/UI/Alliance/UiLWAlBubbleTip.prefab"

function UIAlStarBubbleNode:OnCreate()
  base.OnCreate(self)
end

function UIAlStarBubbleNode:OnDestroy()
  base.OnDestroy(self)
end

function UIAlStarBubbleNode:OnEnable()
  base.OnEnable(self)
  self:OnRefreshShow()
end

function UIAlStarBubbleNode:OnDisable()
  base.OnDisable(self)
end

function UIAlStarBubbleNode:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.AllianceStarRefreshMainBubbleTip, self.OnRefreshShow)
end

function UIAlStarBubbleNode:OnRemoveListener()
  self:RemoveUIListener(EventId.AllianceStarRefreshMainBubbleTip, self.OnRefreshShow)
  base.OnRemoveListener(self)
end

function UIAlStarBubbleNode:OnRefreshShow()
  local show = DataCenter.AllianceStarManager:IsShowMainBubbleTip()
  self:TrySetShow(show)
end

function UIAlStarBubbleNode:TrySetShow(bool)
  if not bool then
    self:SetShow(false)
  end
  self.holder:TrySetShow(MainAlBubbleType.Star, bool)
end

function UIAlStarBubbleNode:SetShow(bool)
  self:SetActiveAsync(bool, LuaPath, PrefabPath)
end

return UIAlStarBubbleNode
