local UIAlR4RecommendNode = BaseClass("UIAlR4RecommendNode", UIAsyncProxy)
local base = UIAsyncProxy
local LuaPath = "UI.LWMainUI.Component.UIMainBottom.UIAlR4RecommendTip"
local PrefabPath = "Assets/Main/Prefabs/UI/Alliance/UILWAlR4Tip.prefab"

function UIAlR4RecommendNode:OnCreate()
  base.OnCreate(self)
end

function UIAlR4RecommendNode:OnDestroy()
  base.OnDestroy(self)
end

function UIAlR4RecommendNode:OnEnable()
  base.OnEnable(self)
  self:OnRefreshShow()
end

function UIAlR4RecommendNode:OnDisable()
  base.OnDisable(self)
end

function UIAlR4RecommendNode:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.Al_R4RecommendTips, self.OnRefreshShow)
end

function UIAlR4RecommendNode:OnRemoveListener()
  self:RemoveUIListener(EventId.Al_R4RecommendTips, self.OnRefreshShow)
  base.OnRemoveListener(self)
end

function UIAlR4RecommendNode:OnRefreshShow()
  local show = DataCenter.AllianceMemberDataManager:GetNeedShowR4Recommend()
  self:TrySetShow(show)
end

function UIAlR4RecommendNode:TrySetShow(bool)
  if not bool then
    self:SetShow(false)
  end
  self.holder:TrySetShow(MainAlBubbleType.R4Recommend, bool)
end

function UIAlR4RecommendNode:SetShow(bool)
  self:SetActiveAsync(bool, LuaPath, PrefabPath)
end

return UIAlR4RecommendNode
