local MeteoriteData = BaseClass("MeteoriteData")

function MeteoriteData:__init()
  self.serverId = 0
  self.cfgId = 0
  self.pointId = 0
  self.time = 0
  self.buildNum = 0
  self.soldierNum = 0
  self.count = 0
  self.personRank = 0
  self.allianceRank = 0
end

function MeteoriteData:__delete()
  self.serverId = 0
  self.cfgId = 0
  self.pointId = 0
  self.time = 0
  self.buildNum = 0
  self.soldierNum = 0
  self.count = 0
  self.personRank = 0
  self.allianceRank = 0
end

function MeteoriteData:ParseData(t)
  if t == nil then
    return
  end
  if t.serverId ~= nil then
    self.serverId = t.serverId
  end
  if t.cfgId ~= nil then
    self.cfgId = t.cfgId
  end
  if t.pointId ~= nil then
    self.pointId = t.pointId
  end
  if t.time ~= nil then
    self.time = t.time
  end
  if t.buildNum ~= nil then
    self.buildNum = t.buildNum
  end
  if t.soldierNum ~= nil then
    self.soldierNum = t.soldierNum
  end
  if t.count ~= nil then
    self.count = t.count
  end
  if t.personRank ~= nil then
    self.personRank = t.personRank
  end
  if t.allianceRank ~= nil then
    self.allianceRank = t.allianceRank
  end
end

return MeteoriteData
