local WorldAllianceResourceData = BaseClass("WorldAllianceResourceData")

local function __init(self)
  self.uuid = 0
  self.remainValue = 0
  self.expireTime = 0
  self.playerInfoLiset = {}
  self.totalSpeed = 0
  self.isSelfCollect = false
  self.selfEndTime = nil
  self.totalCount = 0
  self.creatorInfo = ""
  self.allianceAbbr = ""
end

local function __delete(self)
  self.uuid = nil
  self.remainValue = nil
  self.expireTime = nil
  self.playerInfoLiset = nil
  self.totalSpeed = nil
  self.isSelfCollect = nil
  self.selfEndTime = nil
  self.totalCount = 0
  self.creatorInfo = nil
  self.allianceAbbr = nil
end

local function ParseData(self, message)
  if message.uuid then
    self.uuid = message.uuid
  end
  if message.res_num then
    self.remainValue = message.res_num
  end
  if message.expire_time then
    self.expireTime = message.expire_time
  end
  if message.creator_info then
    self.creatorInfo = message.creator_info
  end
  if message.alliance_info then
    self.allianceAbbr = message.alliance_info
  end
  self.totalSpeed = 0
  self.totalCount = 0
  self.playerInfoLiset = {}
  self.isSelfCollect = false
  self.selfEndTime = nil
  if message.collect_infos then
    for key, value in pairs(message.collect_infos) do
      local oneData = {}
      oneData.name = value.name
      oneData.uid = value.uid
      oneData.pic = value.pic
      oneData.picVer = value.picver
      oneData.headSkinId = value.headSkinId
      oneData.headSkinET = value.headSkinET
      oneData.speed = value.speed
      self.totalSpeed = self.totalSpeed + oneData.speed
      oneData.endTime = value.endTime
      oneData.startTime = value.startTime
      self.totalCount = self.totalCount + 1
      if not self.isSelfCollect and LuaEntry.Player.uid == value.uid then
        self.isSelfCollect = true
        self.selfEndTime = value.endTime
      end
      table.insert(self.playerInfoLiset, oneData)
    end
  end
end

local function GetCurResourceValue(self)
  local collectTotal = 0
  if 0 < #self.playerInfoLiset then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    for index, value in ipairs(self.playerInfoLiset) do
      if curTime > value.startTime then
        local time = (curTime - value.startTime) / 1000
        collectTotal = collectTotal + time * value.speed
      end
    end
  end
  return self.remainValue - toInt(collectTotal)
end

local function GetSelfEndTime(self)
  return self.selfEndTime
end

WorldAllianceResourceData.__init = __init
WorldAllianceResourceData.__delete = __delete
WorldAllianceResourceData.ParseData = ParseData
WorldAllianceResourceData.GetCurResourceValue = GetCurResourceValue
WorldAllianceResourceData.GetSelfEndTime = GetSelfEndTime
return WorldAllianceResourceData
