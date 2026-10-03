local UIAlWarBubbleNode = BaseClass("UIAlWarBubbleNode", UIAsyncProxy)
local base = UIAsyncProxy
local LuaPath = "UI.UIAlliance.UIAllianceWarMainTable.Component.UIAlWarBubbleTip"
local PrefabPath = "Assets/Main/Prefabs/UI/Alliance/UIAlWarBubbleTip.prefab"

function UIAlWarBubbleNode:OnCreate()
  base.OnCreate(self)
  self.alliance_btn_fire_eff = self:AddComponent(UIBaseComponent, "AllianceBtnFireEff")
end

function UIAlWarBubbleNode:OnDestroy()
  base.OnDestroy(self)
end

function UIAlWarBubbleNode:OnEnable()
  base.OnEnable(self)
  self:OnRefreshShow()
end

function UIAlWarBubbleNode:OnDisable()
  base.OnDisable(self)
end

function UIAlWarBubbleNode:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.AllianceWarEventRefresh, self.OnRefreshShow)
  self:AddUIListener(EventId.AllianceWarEventReminderChange, self.OnRefreshShow)
end

function UIAlWarBubbleNode:OnRemoveListener()
  self:RemoveUIListener(EventId.AllianceWarEventRefresh, self.OnRefreshShow)
  self:RemoveUIListener(EventId.AllianceWarEventReminderChange, self.OnRefreshShow)
  base.OnRemoveListener(self)
end

function UIAlWarBubbleNode:OnRefreshShow()
  self.alliance_btn_fire_eff:SetActive(DataCenter.AllianceWarEventDataManager:CheckHasReminder())
  self:TrySetShow(DataCenter.AllianceWarEventDataManager:GetBubbleWarEvent() ~= nil)
end

function UIAlWarBubbleNode:TrySetShow(bool)
  if not bool then
    self:SetShow(false)
  end
  self.holder:TrySetShow(MainAlBubbleType.War, bool)
end

function UIAlWarBubbleNode:SetShow(bool)
  self:SetActiveAsync(bool, LuaPath, PrefabPath)
end

return UIAlWarBubbleNode
