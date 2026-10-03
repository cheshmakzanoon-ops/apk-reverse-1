local AllianceHelpInfo = BaseClass("AllianceHelpInfo")

local function __init(self)
  self.helpId = ""
  self.senderId = ""
  self.name = ""
  self.allianceId = ""
  self.content = 0
  self.helpType = AllianceHelpType.None
  self.itemId = ""
  self.updateTime = 0
  self.maxCount = 0
  self.nowCount = 0
  self.queueType = NewQueueType.Default
  self.stats = 0
  self.pic = ""
  self.picVer = 0
  self.level = 0
  self.headSkinId = nil
  self.headSkinET = nil
  self.startTime = 0
end

local function __delete(self)
  self.helpId = nil
  self.senderId = nil
  self.name = nil
  self.allianceId = nil
  self.content = nil
  self.helpType = nil
  self.itemId = nil
  self.updateTime = nil
  self.maxCount = nil
  self.nowCount = nil
  self.queueType = nil
  self.stats = nil
  self.pic = nil
  self.picVer = nil
  self.level = nil
  self.headSkinId = nil
  self.headSkinET = nil
  self.startTime = nil
end

local function ParseData(self, message)
  if message == nil then
    return
  end
  if message.helpId ~= nil then
    self.helpId = message.helpId
  end
  if message.level ~= nil then
    self.level = message.level
  end
  if message.senderId ~= nil then
    self.senderId = message.senderId
  end
  if message.name ~= nil then
    self.name = message.name
  end
  if message.allianceId ~= nil then
    self.allianceId = message.allianceId
  end
  if message.content ~= nil then
    self.content = message.content
  end
  if message.helpType ~= nil then
    self.helpType = message.helpType
  end
  if message.itemId ~= nil then
    self.itemId = message.itemId
  end
  if message.updateTime ~= nil then
    self.updateTime = message.updateTime
  end
  if message.startTime ~= nil then
    self.startTime = message.startTime
  end
  if message.maxcount ~= nil then
    self.maxCount = message.maxcount
  end
  if message.nowcount ~= nil then
    self:SetNowCount(message.nowcount)
  end
  if message.queueType ~= nil then
    self.queueType = message.queueType
  end
  if message.stats ~= nil then
    self.stats = message.stats
  end
  if message.pic ~= nil then
    self.pic = message.pic
  end
  if message.picVer ~= nil then
    self.picVer = message.picVer
  end
  if message.monthCardEndTime ~= nil then
    self.monthCardEndTime = message.monthCardEndTime
  end
  if message.reduceSec then
    self.reduceSec = message.reduceSec
  end
  if message.headSkinId then
    self.headSkinId = message.headSkinId
  end
  if message.headSkinET then
    self.headSkinET = message.headSkinET
  end
  self:CheckStats()
end

local function CheckStats(self)
  if self.senderId == LuaEntry.Player.uid then
    self.stats = 0
  else
    self.stats = 1
  end
end

local function SetNowCount(self, count)
  if count <= self.maxCount then
    self.nowCount = count
  else
    self.nowCount = self.maxCount
  end
end

local function CheckIsFinish(self)
  return self.nowCount >= self.maxCount
end

local function GetHeadBgImg(self)
  local headBgImg = DataCenter.DecorationDataManager:GetHeadFrame(self.headSkinId, self.headSkinET, false)
  return headBgImg
end

function AllianceHelpInfo:GetTotalTime()
  if self.helpType == AllianceHelpType.Building then
    local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(self.content)
    return buildData.updateTime - buildData.startTime
  elseif self.helpType == AllianceHelpType.Queue and (self.queueType == NewQueueType.Science or self.queueType == NewQueueType.Hospital) then
    local queue = DataCenter.QueueDataManager:GetQueueByUuid(self.content)
    return queue.endTime - queue.startTime
  end
end

AllianceHelpInfo.__init = __init
AllianceHelpInfo.__delete = __delete
AllianceHelpInfo.ParseData = ParseData
AllianceHelpInfo.CheckStats = CheckStats
AllianceHelpInfo.CheckIsFinish = CheckIsFinish
AllianceHelpInfo.SetNowCount = SetNowCount
AllianceHelpInfo.GetHeadBgImg = GetHeadBgImg
return AllianceHelpInfo
