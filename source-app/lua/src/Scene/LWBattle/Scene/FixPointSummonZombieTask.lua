local Time = _ENV.Time
local FixPointSummonZombieTask = BaseClass("FixPointSummonZombieTask")

function FixPointSummonZombieTask:__init(battleMgr, interval, pos, metaId, count, master)
  self.battleMgr = battleMgr
  self.interval = interval / 1000
  self.lastTickTime = 0
  self.genNum = 0
  self.limit = count
  self.metaId = metaId
  self.pos = pos
  self.master = master
end

function FixPointSummonZombieTask:Update()
  local now = Time.time
  if now - self.lastTickTime > self.interval then
    self.lastTickTime = now
    self:DoLogic()
  end
end

function FixPointSummonZombieTask:DoLogic()
  if self.genNum > self.limit then
    self.battleMgr:RemoveGenZombieTask(self)
    return
  end
  if self.battleMgr.squad == nil then
    return
  end
  self.battleMgr:CreateMonster(self.metaId, self.pos, self.master)
  self.genNum = self.genNum + 1
end

return FixPointSummonZombieTask
