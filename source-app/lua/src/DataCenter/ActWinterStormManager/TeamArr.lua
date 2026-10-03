local TeamArr = BaseClass("TeamArr")

function TeamArr:__init()
  self.head = ""
  self.frame = ""
  self.lv = 0
  self.allianceName = 0
  self.name = 0
  self.server = 0
  self.side = 0
  self.title = ""
  self.uid = 0
  self.b_ready = false
  self.killScore = 0
  self.occupyScore = 0
  self.winPointScore = 0
  self.mvpId = 0
  self.score = 0
  self.achievement = {}
end

function TeamArr:__delete()
  self.head = ""
  self.frame = ""
  self.lv = 0
  self.allianceName = 0
  self.name = 0
  self.server = 0
  self.side = 0
  self.title = ""
  self.uid = 0
  self.b_ready = false
  self.killScore = 0
  self.occupyScore = 0
  self.winPointScore = 0
  self.mvpId = 0
  self.score = 0
  self.achievement = {}
end

function TeamArr:ParseData(message)
  if message == nil then
    return
  end
  if message.frame ~= nil then
    self.frame = message.frame
  end
  if message.lv ~= nil then
    self.lv = message.lv
  end
  if message.level ~= nil then
    self.lv = message.level
  end
  if message.server ~= nil then
    self.server = message.server
  end
  if message.side ~= nil then
    self.side = message.side
  end
  if message.uid ~= nil then
    self.uid = message.uid
  end
  if message.head ~= nil then
    self.head = message.head
  end
  if message.allianceName ~= nil then
    self.allianceName = message.allianceName
  end
  if message.name ~= nil then
    self.name = message.name
  end
  if message.ready ~= nil then
    self.ready = message.ready
  end
  if message.title ~= nil then
    self.title = message.title
  end
  if message.killScore ~= nil then
    self.killScore = message.killScore
  end
  if message.occupyScore ~= nil then
    self.occupyScore = message.occupyScore
  end
  if message.winPointScore ~= nil then
    self.winPointScore = message.winPointScore
  end
  if message.mvpId ~= nil then
    self.mvpId = message.mvpId
  end
  if message.score ~= nil then
    self.score = message.score
  end
  local ac = message.achievement
  if ac ~= nil and type(ac) == "table" then
    self.achievement = ac
    DataCenter.ActWinterStormManager:SortAchievement(self.achievement)
  end
end

function TeamArr:GetTotalScore()
  return self.killScore + self.occupyScore + self.winPointScore
end

return TeamArr
