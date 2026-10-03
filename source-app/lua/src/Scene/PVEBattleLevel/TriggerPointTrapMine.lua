local TriggerPointTrapMine = BaseClass("TriggerPointTrapMine")
local Resource = CS.GameEntry.Resource
local DefaultRadius = 3.5
local AttackTime = 0.5
local AttackAfterTime = 3

function TriggerPointTrapMine:__init(triggerPoint)
  self.triggerPoint = triggerPoint
  self.used = false
  self.warningReq = nil
  self.attackReq = nil
end

function TriggerPointTrapMine:__delete()
  self.triggerPoint = nil
  self.used = nil
  self.warningReq = nil
  self.attackReq = nil
end

function TriggerPointTrapMine:Create()
end

function TriggerPointTrapMine:Destroy()
  if self.warningReq ~= nil then
    self.warningReq:Destroy()
    self.warningReq = nil
  end
  if self.attackReq ~= nil then
    self.attackReq:Destroy()
    self.attackReq = nil
  end
end

function TriggerPointTrapMine:Attack()
  self.used = true
  local worldPos = self.triggerPoint:GetPosition()
  local radius = self.triggerPoint.config.attackRadius
  self:CreateWarning(worldPos, radius)
end

function TriggerPointTrapMine:CreateWarning(worldPos, radius)
  local req = Resource:InstantiateAsync("Assets/Main/Prefabs/PVELevel/BombWarning.prefab")
  req:completed("+", function(_)
    if req.isError then
      return
    end
    local go = req.gameObject
    go.transform.position = worldPos
    go.name = "TrapMineWarning"
    local scale = radius / DefaultRadius
    go.transform.localScale = Vector3.New(scale, scale, scale)
    TimerManager:GetInstance():DelayInvoke(function()
      if self.warningReq ~= nil then
        self:CreateAttack(worldPos, radius)
      end
    end, self.triggerPoint.config.warningTime)
    TimerManager:GetInstance():DelayInvoke(function()
      if self.warningReq ~= nil then
        self.warningReq:Destroy()
        self.warningReq = nil
      end
    end, self.triggerPoint.config.warningTime + AttackTime)
  end)
  self.warningReq = req
end

function TriggerPointTrapMine:CreateAttack(worldPos, radius)
  local req = Resource:InstantiateAsync("Assets/Main/Prefabs/PVELevel/TrapMineAttack.prefab")
  req:completed("+", function(_)
    if req.isError then
      return
    end
    local go = req.gameObject
    go.transform.position = worldPos
    go.name = "TrapMineAttack"
    local scale = radius / DefaultRadius
    go.transform.localScale = Vector3.New(scale, scale, scale)
    TimerManager:GetInstance():DelayInvoke(function()
      if self.attackReq ~= nil then
        self:DoDamage(worldPos, radius)
      end
    end, AttackTime)
    TimerManager:GetInstance():DelayInvoke(function()
      if self.attackReq ~= nil then
        self.attackReq:Destroy()
        self.attackReq = nil
      end
    end, AttackTime + AttackAfterTime)
  end)
  self.attackReq = req
end

function TriggerPointTrapMine:DoDamage(worldPos, radius)
  local player = DataCenter.BattleLevel:GetPlayer()
  if player == nil then
    return
  end
  local dis = Vector3.Distance(player:GetPosition(), worldPos)
  if radius >= dis then
    player:Idle()
    if self.triggerPoint.config.buffId ~= 0 then
      DataCenter.BattleLevel:AddBuffById(self.triggerPoint.config.buffId)
    end
  end
end

return TriggerPointTrapMine
