local Resource = CS.GameEntry.Resource
local BarrageTriggerItem = BaseClass("BarrageTriggerItem")

function BarrageTriggerItem:__init(battleManager, triggerMetaId, pos)
  self.triggerMetaId = triggerMetaId
  self.meta = DataCenter.LWTriggerItemTemplateManager:GetTemplate(triggerMetaId)
  self.battleManager = battleManager
  self.pos = pos
end

function BarrageTriggerItem:Load()
  local req = Resource:InstantiateAsync(self.meta.effect)
  req:completed("+", function()
    local trans = req.gameObject.transform
    trans:Set_position(self.pos.x, self.pos.y, self.pos.z)
  end)
  self.loadReq = req
end

function BarrageTriggerItem:Trigger()
  local heros = self.battleManager.squad.members
  for _, hero in pairs(heros) do
    hero:AddBuff(self.meta.para)
  end
  self.battleManager:ShowEffectObj(self.meta.dead_effect, self.pos, nil, 1, nil)
  self:Destroy()
end

function BarrageTriggerItem:Destroy()
  if self.loadReq then
    self.loadReq:Destroy()
    self.loadReq = nil
  end
end

return BarrageTriggerItem
