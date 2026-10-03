local Time = _ENV.Time
local SummonPetTask = BaseClass("SummonPetTask")

function SummonPetTask:__init(battleMgr, interval, metaId, count, master)
  self.battleMgr = battleMgr
  self.interval = interval / 1000
  self.lastTickTime = 0
  self.genNum = 0
  self.limit = count
  self.metaId = metaId
  self.master = master
end

function SummonPetTask:Update()
  local now = Time.time
  if now - self.lastTickTime > self.interval then
    self.lastTickTime = now
    self:DoLogic()
  end
end

function SummonPetTask:DoLogic()
  if self.genNum >= self.limit then
    self.battleMgr:RemoveGenZombieTask(self)
    return
  end
  if self.battleMgr.squad == nil then
    return
  end
  self.battleMgr:CreatePet(self.metaId, self.master)
  self.genNum = self.genNum + 1
end

return SummonPetTask
