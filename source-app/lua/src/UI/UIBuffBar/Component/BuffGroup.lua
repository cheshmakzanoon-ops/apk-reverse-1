local BuffGroup = BaseClass("BuffGroup", UIBaseContainer)
local base = UIBaseContainer
local BuffBar = require("UI.UIBuffBar.Component.BuffBar")

function BuffGroup:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function BuffGroup:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function BuffGroup:ComponentDefine()
  self.buffBars = {}
  self.buffBarTemplate = self.transform:Find("BuffBar").gameObject
  self.buffBarTemplate:GameObjectCreatePool()
  self.buffBarTemplate:SetActive(false)
  self.count = 0
end

function BuffGroup:ComponentDestroy()
  self:RemoveComponents(BuffGroup)
  self.buffBarTemplate.gameObject:GameObjectRecycleAll()
  self.buffBars = nil
end

function BuffGroup:OnAddListener()
  base.OnAddListener(self)
end

function BuffGroup:OnRemoveListener()
  base.OnRemoveListener(self)
end

function BuffGroup:SetData(buff)
  local modelPos = buff.unit:GetPosition()
  self.transform.position = CS.CSUtils.WorldPositionToUISpacePosition(modelPos)
  self:AddBuffBar(buff)
end

function BuffGroup:AddBuffBar(buff)
  local item = self.buffBarTemplate:GameObjectSpawn(self.transform)
  self.count = self.count + 1
  item.name = "buffBar" .. self.count
  local obj = self:AddComponent(BuffBar, item.name)
  obj:SetData(buff)
  self.buffBars[buff] = obj
end

function BuffGroup:RemoveBuffBar(buff)
  if self.buffBars[buff] then
    local go = self.buffBars[buff].gameObject
    self.buffBars[buff]:OnDestroy()
    go:GameObjectRecycle()
    self.buffBars[buff] = nil
  end
end

function BuffGroup:OnUpdateSec()
  for _, v in pairs(self.buffBars) do
    v:OnUpdateSec()
  end
end

return BuffGroup
