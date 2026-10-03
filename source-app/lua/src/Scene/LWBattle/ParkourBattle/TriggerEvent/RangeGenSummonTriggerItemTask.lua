local RangeGenSummonTriggerItemTask = BaseClass("RangeGenSummonTriggerItemTask")

function RangeGenSummonTriggerItemTask:__init(mgr, pos, r1, r2, metaId, count, ownerMeta, castType)
  self.mgr = mgr
  self.lastTickTime = 0
  self.genMetaId = metaId
  self.genCount = count
  self.genX = pos.x
  self.genZ = pos.z
  self.r1 = r1
  self.r2 = r2
  self.interval = 0.1
  self.genCounter = 0
  self.ownerMeta = ownerMeta
  if not string.IsNullOrEmpty(castType) then
    local type = tonumber(castType)
    if type == 1 then
      for i = 1, self.genCount do
        self:DoLogic()
      end
    end
  end
end

function RangeGenSummonTriggerItemTask:__delete()
end

function RangeGenSummonTriggerItemTask:Update()
  local now = Time.time
  if now - self.lastTickTime > self.interval then
    self.lastTickTime = now
    self:DoLogic()
  end
end

function RangeGenSummonTriggerItemTask:DoLogic()
  self.genCounter = self.genCounter + 1
  if self.genCounter > self.genCount then
    self.mgr:RemoveTask(self)
    return
  end
  self:RangeGen()
end

function RangeGenSummonTriggerItemTask:RangeGen()
  local dir = Vector3.Normalize(Vector3.New(math.random(-10000, 10000), 0, math.random(-10000, 20000)))
  local len = math.random(self.r1, self.r2)
  local genPos = Vector3.New(self.genX, 0, self.genZ) + dir * len
  local fakeBuffItemStr = self.genMetaId .. "|" .. "10000"
  local m = self.mgr:CreateTriggerGoods(genPos.x, genPos.z, fakeBuffItemStr)
  if m then
    m:Load()
  end
end

return RangeGenSummonTriggerItemTask
