local GenSummonTriggerItemTask = BaseClass("GenSummonTriggerItemTask")

function GenSummonTriggerItemTask:__init(mgr, pos, metaId, count, ownerMeta, castType)
  self.mgr = mgr
  self.lastTickTime = 0
  self.genMetaId = metaId
  self.genCount = count
  self.genX = pos.x
  self.genZ = pos.z
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

function GenSummonTriggerItemTask:__delete()
end

function GenSummonTriggerItemTask:Update()
  local now = Time.time
  if now - self.lastTickTime > self.interval then
    self.lastTickTime = now
    self:DoLogic()
  end
end

function GenSummonTriggerItemTask:DoLogic()
  self.genCounter = self.genCounter + 1
  if self.genCounter > self.genCount then
    self.mgr:RemoveTask(self)
    return
  end
  self:Gen()
end

function GenSummonTriggerItemTask:Gen()
  local dir = Vector3.Normalize(Vector3.New(math.random(-10000, 10000), 0, math.random(-10000, 20000)))
  local len = math.random() * 2
  local genPos = Vector3.New(self.genX, 0, self.genZ) + dir * len
  local fakeBuffItemStr = self.genMetaId .. "|" .. "10000"
  local m = self.mgr:CreateTriggerGoods(genPos.x, genPos.z, fakeBuffItemStr)
  if m then
    m:Load()
  end
end

return GenSummonTriggerItemTask
