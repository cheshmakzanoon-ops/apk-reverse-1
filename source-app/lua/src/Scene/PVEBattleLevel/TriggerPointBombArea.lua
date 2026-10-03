local TriggerPointBombArea = BaseClass("TriggerPointBombArea")
local Resource = CS.GameEntry.Resource
local DefaultRadius = 3.5
local AttackTime = 0.5
local AttackAfterTime = 3

function TriggerPointBombArea:__init(triggerPoint)
  self.triggerPoint = triggerPoint
  self.started = false
  self.enabled = false
  self.warningIndex = 1
  self.attackIndex = 1
  self.attackCd = 0
  self.warningReqs = {}
  self.attackReqs = {}
end

function TriggerPointBombArea:__delete()
  self.triggerPoint = nil
  self.started = nil
  self.enabled = nil
  self.warningIndex = nil
  self.attackIndex = nil
  self.attackCd = nil
  self.warningReqs = nil
  self.attackReqs = nil
end

function TriggerPointBombArea:Create()
end

function TriggerPointBombArea:Destroy()
  self.enabled = false
  for _, req in pairs(self.warningReqs) do
    req:Destroy()
  end
  self.warningReqs = {}
  for _, req in pairs(self.attackReqs) do
    req:Destroy()
  end
  self.attackReqs = {}
end

function TriggerPointBombArea:PlayerInDistance()
  if not self.started then
    self.started = true
    self.enabled = true
  end
end

function TriggerPointBombArea:OnUpdate(deltaTime)
  if not self.enabled then
    return
  end
  if self.attackCd > 0 then
    self.attackCd = self.attackCd - deltaTime
    return
  end
  self.attackCd = self.triggerPoint.config.attackCd
  if table.count(self.warningReqs) > self.triggerPoint.config.attackCount then
    return
  end
  self:AttackInArea()
end

function TriggerPointBombArea:AttackInArea()
  if #self.triggerPoint.config.effectArea == 0 then
    return
  end
  local tilePos = table.randomArrayValue(self.triggerPoint.config.effectArea)
  local worldPos = SceneUtils.TileToWorld(tilePos)
  local radius = math.random() * (self.triggerPoint.config.radiusMax - self.triggerPoint.config.radiusMin) + self.triggerPoint.config.radiusMin
  self:CreateWarning(worldPos, radius)
end

function TriggerPointBombArea:CreateWarning(worldPos, radius)
  local index = self.warningIndex
  local req = Resource:InstantiateAsync("Assets/Main/Prefabs/PVELevel/BombWarning.prefab")
  req:completed("+", function(_)
    if req.isError then
      return
    end
    local go = req.gameObject
    go.transform.position = worldPos
    go.name = tostring(index)
    local scale = radius / DefaultRadius
    go.transform.localScale = Vector3.New(scale, scale, scale)
    TimerManager:GetInstance():DelayInvoke(function()
      if self.warningReqs[index] ~= nil then
        self:CreateAttack(worldPos, radius)
      end
    end, self.triggerPoint.config.warningTime)
    TimerManager:GetInstance():DelayInvoke(function()
      if self.warningReqs[index] ~= nil then
        self.warningReqs[index]:Destroy()
        self.warningReqs[index] = nil
      end
    end, self.triggerPoint.config.warningTime + AttackTime)
  end)
  self.warningReqs[index] = req
  self.warningIndex = self.warningIndex + 1
end

function TriggerPointBombArea:CreateAttack(worldPos, radius)
  local index = self.attackIndex
  local req = Resource:InstantiateAsync("Assets/Main/Prefabs/PVELevel/BombAttack.prefab")
  req:completed("+", function(_)
    if req.isError then
      return
    end
    local go = req.gameObject
    go.transform.position = worldPos
    go.name = tostring(index)
    local scale = radius / DefaultRadius
    go.transform.localScale = Vector3.New(scale, scale, scale)
    TimerManager:GetInstance():DelayInvoke(function()
      if self.attackReqs[index] ~= nil then
        self:DoDamage(worldPos, radius)
      end
    end, AttackTime)
    TimerManager:GetInstance():DelayInvoke(function()
      if self.attackReqs[index] ~= nil then
        self.attackReqs[index]:Destroy()
        self.attackReqs[index] = nil
      end
    end, AttackTime + AttackAfterTime)
  end)
  self.attackReqs[index] = req
  self.attackIndex = self.attackIndex + 1
end

function TriggerPointBombArea:DoDamage(worldPos, radius)
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

return TriggerPointBombArea
