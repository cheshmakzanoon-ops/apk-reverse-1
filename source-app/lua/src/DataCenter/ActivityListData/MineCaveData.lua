local MineCaveData = BaseClass("MineCaveData")

local function __init(self)
  self.fightNum = 0
  self.refreshNum = 0
  self.lastRefreshTime = 0
  self.curScore = 0
  self.minesList = {}
  self.myMinesList = {}
end

local function __delete(self)
  self.fightNum = nil
  self.refreshNum = nil
  self.lastRefreshTime = nil
  self.curScore = nil
  self.minesList = nil
  self.myMinesList = nil
end

local function ParseData(self, message)
  if message == nil then
    return
  end
  if message.mineCaveInfo then
    local mineCaveInfo = message.mineCaveInfo
    if mineCaveInfo.fightNum then
      self.fightNum = mineCaveInfo.fightNum
    end
    if mineCaveInfo.refreshNum then
      self.refreshNum = mineCaveInfo.refreshNum
    end
    if mineCaveInfo.lastRefreshTime then
      self.lastRefreshTime = mineCaveInfo.lastRefreshTime
    end
    if mineCaveInfo.score then
      self.curScore = mineCaveInfo.score
    end
  end
  if message.mineArr then
    self.minesList = {}
    for i, v in ipairs(message.mineArr) do
      local mineInfo = {}
      mineInfo.index = i
      mineInfo.mineId = v.mineId
      if v.occupyInfo then
        mineInfo.ownerUid = v.occupyInfo.ownerUid
        mineInfo.startTime = v.occupyInfo.startTime
        mineInfo.endTime = v.occupyInfo.endTime
        mineInfo.ownerName = v.occupyInfo.userName
        mineInfo.allianceAbbr = v.occupyInfo.allianceAbbr
        mineInfo.allianceId = v.occupyInfo.allianceId
        mineInfo.ownerPic = v.occupyInfo.pic
        mineInfo.ownerPicVer = v.occupyInfo.picVer
        mineInfo.careerType = v.occupyInfo.careerType
        mineInfo.careerLv = v.occupyInfo.careerLv
        mineInfo.monthCardEndTime = v.occupyInfo.monthCardEndTime
        
        function mineInfo:GetHeadBgImg()
          local headBgImg
          local serverTimeS = UITimeManager:GetInstance():GetServerSeconds()
          if self.monthCardEndTime and serverTimeS < self.monthCardEndTime then
            headBgImg = "Common_playerbg_golloes"
          end
          if headBgImg and headBgImg ~= "" then
            return string.format(LoadPath.CommonNewPath, headBgImg)
          end
        end
      end
      table.insert(self.minesList, mineInfo)
    end
  end
  if message.taskArr then
    self.myMinesList = {}
    for i, v in ipairs(message.taskArr) do
      local myMine = {}
      myMine.uuid = v.uuid
      myMine.mineId = v.mineId
      myMine.startTime = v.startTime
      myMine.endTime = v.endTime
      myMine.rewarded = v.state == 2
      myMine.formationUuid = v.formationUuid
      myMine.armyInfo = v.armyInfo
      if not string.IsNullOrEmpty(v.armyInfo) then
        local armyCombatUnit = PBController.ParsePb1(v.armyInfo, "protobuf.ArmyUnitInfo")
        myMine.heros = armyCombatUnit.heroes
        myMine.soldiers = armyCombatUnit.soldiers
      else
        myMine.heros = {}
        myMine.soldiers = {}
      end
      table.insert(self.myMinesList, myMine)
    end
  end
end

local function GetMyMinesList(self)
  local retList = {}
  for i, v in ipairs(self.myMinesList) do
    local formation = DataCenter.ArmyFormationDataManager:GetOneArmyInfoByUuid(v.formationUuid)
    retList[formation.index] = v
  end
  return retList
end

local function GetMyMineInfo(self, uuid)
  for i, v in ipairs(self.myMinesList) do
    if v.uuid == uuid then
      return v
    end
  end
end

local function GetMineInfo(self, index)
  for i, v in ipairs(self.minesList) do
    if v.index == index then
      return v
    end
  end
end

local function ResetMineInfo(self, mineId)
  for i, v in ipairs(self.minesList) do
    if v.mineId == mineId then
      v.ownerUid = nil
      EventManager:GetInstance():Broadcast(EventId.UpdateMineCaveInfo)
      break
    end
  end
end

local function GetBusyFormations(self)
  local retList = {}
  for i, v in ipairs(self.myMinesList) do
    if not string.IsNullOrEmpty(v.formationUuid) then
      table.insert(retList, v.formationUuid)
    end
  end
  return retList
end

MineCaveData.__init = __init
MineCaveData.__delete = __delete
MineCaveData.ParseData = ParseData
MineCaveData.GetMyMineInfo = GetMyMineInfo
MineCaveData.GetMineInfo = GetMineInfo
MineCaveData.ResetMineInfo = ResetMineInfo
MineCaveData.GetBusyFormations = GetBusyFormations
MineCaveData.GetMyMinesList = GetMyMinesList
return MineCaveData
