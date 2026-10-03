local UILWAlGiftTipNode = BaseClass("UILWAlGiftTipNode", UIAsyncProxy)
local base = UIAsyncProxy
local LuaPath = "UI.UILWAlliance.UILWAlHelp.Component.UILWAlGiftTip"
local PrefabPath = "Assets/Main/Prefabs/UI/Alliance/UILWAlGiftTip.prefab"

function UILWAlGiftTipNode:OnCreate()
  base.OnCreate(self)
end

function UILWAlGiftTipNode:OnDestroy()
  base.OnDestroy(self)
end

function UILWAlGiftTipNode:OnEnable()
  base.OnEnable(self)
end

function UILWAlGiftTipNode:OnDisable()
  base.OnDisable(self)
end

function UILWAlGiftTipNode:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.UpdateAllianceGiftNum, self.OnRefreshShow)
end

function UILWAlGiftTipNode:OnRemoveListener()
  self:RemoveUIListener(EventId.UpdateAllianceGiftNum, self.OnRefreshShow)
  base.OnRemoveListener(self)
end

function UILWAlGiftTipNode:OnRefreshShow()
  if not DataCenter.BuildManager:IsExistBuildByTypeLv(BuildingTypes.LW_BUILD_ALLIANCE_CENTER, 1) then
    self:TrySetShow(false)
    return
  end
  local count = DataCenter.AllianceGiftDataManager:GetGiftNum()
  local show
  if DataCenter.BuildManager.MainLv <= 10 then
    show = 50 <= count
  else
    show = 100 <= count
  end
  self:TrySetShow(show)
end

function UILWAlGiftTipNode:TrySetShow(bool)
  if not bool then
    self:SetShow(false)
  end
  self.holder:TrySetShow(MainAlBubbleType.Gift, bool)
end

function UILWAlGiftTipNode:SetShow(bool)
  self:SetActiveAsync(bool, LuaPath, PrefabPath)
end

return UILWAlGiftTipNode
