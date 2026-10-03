local UIS0AllianceBossNode = BaseClass("UIS0AllianceBossNode", UIAsyncProxy)
local base = UIAsyncProxy
local LuaPath = "UI.LWMainUI.Component.UIMainBottom.UIBubbleTipS0AllianceBossItem"
local PrefabPath = "Assets/Main/Prefabs/UI/LWMainUI/UIBubbleTipS0AllianceBoss.prefab"

function UIS0AllianceBossNode:OnCreate()
  base.OnCreate(self)
end

function UIS0AllianceBossNode:OnDestroy()
  self.hide = nil
  base.OnDestroy(self)
end

function UIS0AllianceBossNode:OnEnable()
  base.OnEnable(self)
  self:OnRefreshShow()
end

function UIS0AllianceBossNode:OnDisable()
  base.OnDisable(self)
end

function UIS0AllianceBossNode:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnS0AllianceBossBattleBubbleRefresh, self.OnRefreshShow)
  self:AddUIListener(EventId.OnS0AllianceBossOnActInfoGot, self.OnRefreshShow)
end

function UIS0AllianceBossNode:OnRemoveListener()
  self:RemoveUIListener(EventId.OnS0AllianceBossBattleBubbleRefresh, self.OnRefreshShow)
  self:RemoveUIListener(EventId.OnS0AllianceBossOnActInfoGot, self.OnRefreshShow)
  base.OnRemoveListener(self)
end

function UIS0AllianceBossNode:OnHideTip()
  self.hide = true
  self:OnRefreshShow()
end

function UIS0AllianceBossNode:OnRefreshShow()
  if self.hide == true then
    self:TrySetShow(false)
  else
    local show = DataCenter.S0AllianceBossDataManager:CheckBattleBubbleShow()
    self:TrySetShow(show)
  end
end

function UIS0AllianceBossNode:TrySetShow(bool)
  if not bool then
    self:SetShow(false)
  end
  self.holder:TrySetShow(MainAlBubbleType.S0AllianceBoss, bool)
end

function UIS0AllianceBossNode:SetShow(bool)
  self:SetActiveAsync(bool, LuaPath, PrefabPath)
end

return UIS0AllianceBossNode
