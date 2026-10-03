local UIBuffBarView = BaseClass("UIBuffBarView", UIBaseView)
local base = UIBaseView
local BuffGroup = require("UI.UIBuffBar.Component.BuffGroup")

function UIBuffBarView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIBuffBarView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIBuffBarView:ComponentDefine()
  self.buffGroups = {}
  self.buffGroupTemplate = self.transform:Find("BuffGroup").gameObject
  self.buffGroupTemplate:GameObjectCreatePool()
  self.buffGroupTemplate:SetActive(false)
  if self.updateSecTimer == nil then
    self.updateSecTimer = TimerManager:GetInstance():GetTimer(1, self.OnUpdateSec, self, false, false, false)
    self.updateSecTimer:Start()
  end
end

function UIBuffBarView:ComponentDestroy()
  self:RemoveComponents(BuffGroup)
  self.buffGroupTemplate.gameObject:GameObjectRecycleAll()
  if self.updateSecTimer then
    self.updateSecTimer:Stop()
    self.updateSecTimer = nil
  end
end

function UIBuffBarView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.PVEBuffAdded, self.OnAddBuffBar)
  self:AddUIListener(EventId.PVEBuffRemoved, self.OnRemoveBuffBar)
end

function UIBuffBarView:OnRemoveListener()
  self:RemoveUIListener(EventId.PVEBuffAdded, self.OnAddBuffBar)
  self:RemoveUIListener(EventId.PVEBuffRemoved, self.OnRemoveBuffBar)
  base.OnRemoveListener(self)
end

function UIBuffBarView:OnAddBuffBar(buff)
  local unit = buff.unit
  if self.buffGroups[unit:GetGuid()] then
    self.buffGroups[unit:GetGuid()]:AddBuffBar(buff)
  else
    local item = self.buffGroupTemplate:GameObjectSpawn(self.transform)
    item.name = "buffGroup" .. table.count(self.buffGroups) + 1
    local obj = self:AddComponent(BuffGroup, item.name)
    obj:SetData(buff)
    self.buffGroups[unit:GetGuid()] = obj
  end
end

function UIBuffBarView:OnRemoveBuffBar(buff)
  local unit = buff.unit
  if self.buffGroups[unit:GetGuid()] then
    self.buffGroups[unit:GetGuid()]:RemoveBuffBar(buff)
  end
end

function UIBuffBarView:OnUpdateSec()
  for _, v in pairs(self.buffGroups) do
    v:OnUpdateSec()
  end
end

return UIBuffBarView
