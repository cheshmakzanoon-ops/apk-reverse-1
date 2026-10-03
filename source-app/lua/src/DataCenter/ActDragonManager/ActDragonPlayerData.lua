local ActDragonPlayerData = BaseClass("ActDragonPlayerData")

local function __init(self)
  self.uid = ""
  self.lv = 0
  self.picVer = 0
  self.pic = ""
  self.name = ""
  self.abbr = ""
  self.power = 0
  self.headSkinId = nil
  self.headSkinET = nil
  self.state = 0
  self.score = 0
  self.apply = 0
  self.armyPower = 0
  self.monthCardEndTime = 0
  self.group = 0
  self.selectBattlePeriodList = {}
  self.commander = false
end

local function __delete(self)
  self.uid = ""
  self.lv = 0
  self.picVer = 0
  self.pic = ""
  self.name = ""
  self.abbr = ""
  self.power = 0
  self.headSkinId = nil
  self.headSkinET = nil
  self.state = 0
  self.apply = 0
  self.armyPower = 0
  self.monthCardEndTime = 0
  self.group = 0
  self.selectBattlePeriodList = nil
  self.commander = false
end

local function ParseData(self, message)
  if message == nil then
    return
  end
  if message.uid ~= nil then
    self.uid = message.uid
  end
  if message.lv ~= nil then
    self.lv = message.lv
  end
  if message.level ~= nil then
    self.lv = message.level
  end
  if message.name ~= nil then
    self.name = message.name
  end
  if message.abbr ~= nil then
    self.abbr = message.abbr
  end
  if message.apply ~= nil then
    self.apply = message.apply
  end
  if message.armyPower ~= nil and message.armyPower ~= 0 then
    self.armyPower = message.armyPower
  end
  if message.monthCardEndTime ~= nil then
    self.monthCardEndTime = message.monthCardEndTime
  end
  if message.picVer ~= nil then
    self.picVer = message.picVer
  end
  if message.pic ~= nil then
    self.pic = message.pic
  end
  if message.power ~= nil then
    self.power = message.power
  end
  if message.headSkinId ~= nil then
    self.headSkinId = message.headSkinId
  end
  if message.headSkinET ~= nil then
    self.headSkinET = message.headSkinET
  end
  if message.state ~= nil then
    self.state = message.state
  end
  if message.score ~= nil then
    self.score = message.score
  end
  if message.group ~= nil then
    self.group = message.group
  end
  if message.chooseTimeList ~= nil then
    self.selectBattlePeriodList = message.chooseTimeList
  end
  if message.commander ~= nil then
    self.commander = message.commander
  end
end

local function GetHeadBgImg(self)
  local headBgImg = DataCenter.DecorationDataManager:GetHeadFrame(self.headSkinId, self.headSkinET)
  return headBgImg
end

local function IsContainerBattleTime(self, battlePeriod)
  local count = table.count(self.selectBattlePeriodList)
  for i = 1, count do
    if self.selectBattlePeriodList[i] == battlePeriod then
      return true
    end
  end
  return false
end

ActDragonPlayerData.__init = __init
ActDragonPlayerData.__delete = __delete
ActDragonPlayerData.ParseData = ParseData
ActDragonPlayerData.GetHeadBgImg = GetHeadBgImg
ActDragonPlayerData.IsContainerBattleTime = IsContainerBattleTime
return ActDragonPlayerData
