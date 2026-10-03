local WorldMarchData = BaseClass("WorldMarchData")
local ArmyInfo = require("DataCenter.WorldMarchDataManager.ArmyInfo")

local function __init(self)
  self.uuid = 0
  self.ownerUid = ""
  self.ownerName = ""
  self.teamUuid = 0
  self.allianceUid = ""
  self.ownerFormationUuid = ""
  self.path = ""
  self.targetPos = 0
  self.startPos = 0
  self.startTime = 0
  self.endTime = 0
  self.blackStartTime = 0
  self.blackEndTime = 0
  self.target = MarchTargetType.STATE
  self.status = MarchStatus.DEFAULT
  self.type = NewMarchType.DEFAULT
  self.targetUuid = 0
  self.speed = 0
  self.oriSpeed = 0
  self.plunderRes = ""
  self.worldId = 0
  self.worldType = 0
  self.collectSpd = 0
  self.armyWeight = 0
  self.inBattle = false
  self.armyInfos = {}
  self.monsterId = 0
  self.refreshTime = 0
  self.actStartTime = 0
  self.actEndTime = 0
  self.isBroken = false
  self.allianceAbbr = ""
  self.allianceName = ""
  self.allianceIcon = ""
  self.eventId = ""
  self.belongUid = ""
  self.pic = ""
  self.picVer = 0
  self.serverId = 0
  self.targetServer = 0
  self.srcServer = 0
  self.realTargetPos = 0
  self.isSelect = false
  self.isCameraFollow = false
  self.bossOwnerUid = ""
  self.callHelp = 0
  self.fightMonster = false
  self.secretKey = 0
  self.monsterRallyNum = 0
  self.allianceBuildingCfgId = 0
  self.zombieRushRound = 0
  self.zombieRushState = 0
  self.zombieRushId = 0
  self.isAnonymity = false
end

local function __delete(self)
end

local function UpdateWorldMarch(self, message)
  if message == nil then
    return
  end
  if message.uuid ~= nil then
    self.uuid = message.uuid
  end
  if message.worldId ~= nil then
    self.worldId = message.worldId
  end
  if message.worldType ~= nil then
    self.worldType = message.worldType
  end
  if message.teamUuid ~= nil then
    self.teamUuid = message.teamUuid
  end
  if message.ownerUid ~= nil then
    self.ownerUid = message.ownerUid
  end
  if message.teamUuid ~= nil then
    self.teamUuid = message.teamUuid
  end
  if message.ownerName ~= nil then
    self.ownerName = message.ownerName
  end
  if message.ownerFormationUuid ~= nil then
    self.ownerFormationUuid = message.ownerFormationUuid
  end
  if message.mainPointId ~= nil then
    self.homePos = message.mainPointId
  end
  if message.path ~= nil then
    self.path = message.path
  end
  if message.targetPos ~= nil then
    self.targetPos = message.targetPos
  end
  if message.startPos ~= nil then
    self.startPos = message.startPos
  end
  if message.target ~= nil then
    self.target = message.target
  end
  if message.status ~= nil then
    self.status = message.status
  end
  if message.targetUuid ~= nil then
    self.targetUuid = message.targetUuid
  end
  if message.startTime ~= nil then
    self.startTime = message.startTime
  end
  if message.targetUuid ~= nil then
    self.targetUuid = message.targetUuid
  end
  if message.startTime ~= nil then
    self.startTime = message.startTime
  end
  if message.endTime ~= nil then
    self.endTime = message.endTime
  end
  if message.secretKey ~= nil then
    self.secretKey = message.secretKey
  else
    self.secretKey = 0
  end
  if self.worldId ~= nil and self.worldId > 0 then
    self.blackStartTime = 0
    self.blackEndTime = 0
  end
  if message.blackStartTime ~= nil then
    self.blackStartTime = message.blackStartTime
  end
  if message.blackEndTime ~= nil then
    self.blackEndTime = message.blackEndTime
  end
  if message.allianceUid ~= nil then
    self.allianceUid = message.allianceUid
  end
  if message.type ~= nil then
    self.type = message.type
  end
  if message.speed ~= nil then
    self.speed = message.speed
  end
  if message.oriSpeed ~= nil then
    self.oriSpeed = message.oriSpeed
  end
  if message.plunderRes ~= nil then
    self.plunderRes = message.plunderRes
  end
  if message.collectSpd ~= nil then
    self.collectSpd = message.collectSpd
  end
  if message.armyWeight ~= nil then
    self.armyWeight = message.armyWeight
  end
  if message.inBattle ~= nil then
    self.inBattle = message.inBattle
  end
  if message.eventId ~= nil then
    self.eventId = message.eventId
  end
  if message.belongUid ~= nil then
    self.belongUid = message.belongUid
  end
  if message.actEndTime ~= nil then
    self.actEndTime = message.actEndTime
  end
  if message.actStartTime ~= nil then
    self.actStartTime = message.actStartTime
  end
  if message.bossOwnerUid ~= nil then
    self.bossOwnerUid = message.bossOwnerUid
  end
  if message.server ~= nil then
    self.serverId = message.server
  end
  if message.targetServer ~= nil then
    self.targetServer = message.targetServer
  end
  if message.srcServer ~= nil then
    self.srcServer = message.srcServer
  end
  if message.fightMonster ~= nil then
    self.fightMonster = message.fightMonster
  end
  if self.type == NewMarchType.MONSTER or self.type == NewMarchType.BOSS or self.type == NewMarchType.DARKNESS_MONSTER or self.type == NewMarchType.ACT_BOSS or self.type == NewMarchType.PUZZLE_BOSS or self.type == NewMarchType.CHALLENGE_BOSS or self.type == NewMarchType.RUNNING_MUMMY or self.type == NewMarchType.SANDFISH or self.type == NewMarchType.CROCODILE or self.type == NewMarchType.RUNNING_BOSS then
    if message.monsterId ~= nil then
      self.monsterId = message.monsterId
    end
    if message.refreshTime ~= nil then
      self.refreshTime = message.refreshTime
    end
  end
  if self.type == NewMarchType.CHALLENGE_BOSS and message.callHelp ~= nil then
    self.callHelp = message.callHelp
  end
  if message.isBroken ~= nil then
    self.isBroken = message.isBroken
  end
  if message.allianceAbbr ~= nil then
    self.allianceAbbr = message.allianceAbbr
  end
  if message.allianceName ~= nil then
    self.allianceName = message.allianceName
  end
  if message.allianceIcon ~= nil then
    self.allianceIcon = message.allianceIcon
  end
  if message.pic ~= nil then
    self.pic = message.pic
  end
  if message.picVer ~= nil then
    self.picVer = message.picVer
  end
  if message.combatInfos ~= nil then
    self:UpdateArmy(message.combatInfos)
  end
  if message.train ~= nil then
    self.train = message.train
  end
  if message.allianceBossInfo ~= nil then
    self.allianceBossInfo = message.allianceBossInfo
  end
  if message.rally_num ~= nil then
    self.monsterRallyNum = message.rally_num
  end
  self.power = message.power or 0
  if message.allianceBuildingCfgId ~= nil then
    self.allianceBuildingCfgId = message.allianceBuildingCfgId
  end
  if message.zombieRushRound ~= nil then
    self.zombieRushRound = message.zombieRushRound
  end
  if message.zombieRushState ~= nil then
    self.zombieRushState = message.zombieRushState
  end
  if message.zombieRushId ~= nil then
    self.zombieRushId = message.zombieRushId
  end
  if message.isAnonymity ~= nil then
    self.isAnonymity = message.isAnonymity
  else
    self.isAnonymity = false
  end
  if message.invasionBossInfo ~= nil then
    self.invasionBossInfo = message.invasionBossInfo
  end
  if message.pvpNum ~= nil then
    self.pvpNum = message.pvpNum
  end
  if message.pveNum ~= nil then
    self.pveNum = message.pveNum
  end
end

local function UpdateArmy(self, arr)
  if arr == nil or table.count(arr) <= 0 then
    return
  end
  self.armyInfos = {}
  for k, v in pairs(arr) do
    local armyInfo = ArmyInfo.New()
    local armyUnit = PBController.ParsePb1(v, "protobuf.ArmyCombatUnit")
    if armyUnit then
      armyInfo.health = armyUnit.simpleCombatUnit.health
      armyInfo.initHealth = armyUnit.simpleCombatUnit.initHealth
      armyInfo.uid = armyUnit.simpleCombatUnit.uid
      armyInfo:UpdateArmyList(armyUnit.armyInfo)
      table.insert(self.armyInfos, armyInfo)
    end
  end
end

local function GetIsBroken(self)
  return self.isBroken
end

local function GetArmyInfo(self, uid)
  local armyData
  for k, v in pairs(self.armyInfos) do
    if v.uuid == uid then
      armyData = v
    end
  end
  return armyData
end

local function GetFirstArmyInfo(self)
  local armyData
  for k, v in pairs(self.armyInfos) do
    if v.uuid == self.uuid then
      armyData = v
    end
  end
  return armyData
end

local function GetSoliderNum(self)
  local num = 0
  for k, v in pairs(self.armyInfos) do
    for a, b in pairs(v.Soldiers) do
      num = num + (b.total - b.lost)
    end
  end
  return num
end

local function GetMarchTargetType(self)
  return self.target
end

local function GetHP(self)
  local ret = 1
  if not table.IsNullOrEmpty(self.armyInfos) then
    table.walk(self.armyInfos, function(k, v)
      if v.uid == LuaEntry.Player.uid then
        ret = v.health
      end
    end)
  end
  return ret
end

local function GetMaxHP(self)
  local ret = 1
  if not table.IsNullOrEmpty(self.armyInfos) then
    table.walk(self.armyInfos, function(k, v)
      if v.uid == LuaEntry.Player.uid then
        ret = v.initHealth
      end
    end)
  end
  return ret
end

local function GetMarchStatus(self)
  return self.status
end

local function GetMarchCurPos(self)
  return SceneUtils.GetMarchCurPos(self)
end

local function GetCurArmyWeight(self)
  local plunderRe = 0
  if self.plunderRes ~= nil then
    local num = 0
    local stringNum = string.split(self.plunderRes, ";")
    if 0 < #stringNum then
      for i = 1, #stringNum do
        local item = stringNum[i]
        local arr = string.split(item, ",")
        if 0 < #arr then
          local addNum = tonumber(arr[#arr])
          if addNum ~= nil then
            num = num + addNum
          end
        end
      end
    end
    plunderRe = num
  end
  return plunderRe
end

local function GetResourcePercent(self)
  local percent = 0
  local hasTimer = UITimeManager:GetInstance():GetServerTime() - self.startTime
  local curNum = hasTimer * 0.001 * self.collectSpd
  local curWeight = self:GetCurArmyWeight()
  if 0 < curWeight then
    percent = (curNum + curWeight) / math.max(self.armyWeight, 1)
  else
  end
end

local function IsMine(self)
  if self.ownerUid == LuaEntry.Player.uid then
    return true
  else
    return false
  end
end

local function HasFightMonster(self)
  return self.fightMonster
end

local function GetMarchType(self)
  return self.type
end

local function IsScoutMarch(self)
  return self.type == NewMarchType.SCOUT or self.type == NewMarchType.TREAT_VIRUS or self.type == NewMarchType.LOTTO_RECEIVE or self.type == NewMarchType.ZONE_MOBILIZATION_DONATE or self.type == NewMarchType.MONSTER_CHALLENGE_DONATE
end

local function GetArmyInfoIndexOne(self)
  return self.armyInfos[1]
end

local function GetWorldType(self)
  if self.worldId ~= nil and self.worldId > 0 then
    if self.worldType ~= nil and 0 < self.worldType then
      return self.worldType
    end
    if self.target == MarchTargetType.ATTACK_WINTER_ENTITY or self.target == MarchTargetType.ASSISTANCE_WINTER_ENTITY or self.target == MarchTargetType.SCOUT_WINTER_ENTITY then
      return BattleFieldType.WinterStorm
    else
      return BattleFieldType.Desert
    end
  end
  return 0
end

WorldMarchData.__init = __init
WorldMarchData.__delete = __delete
WorldMarchData.UpdateWorldMarch = UpdateWorldMarch
WorldMarchData.UpdateArmy = UpdateArmy
WorldMarchData.GetIsBroken = GetIsBroken
WorldMarchData.GetArmyInfo = GetArmyInfo
WorldMarchData.GetFirstArmyInfo = GetFirstArmyInfo
WorldMarchData.GetSoliderNum = GetSoliderNum
WorldMarchData.GetMarchTargetType = GetMarchTargetType
WorldMarchData.GetHP = GetHP
WorldMarchData.GetMaxHP = GetMaxHP
WorldMarchData.GetMarchStatus = GetMarchStatus
WorldMarchData.GetMarchCurPos = GetMarchCurPos
WorldMarchData.GetCurArmyWeight = GetCurArmyWeight
WorldMarchData.GetResourcePercent = GetResourcePercent
WorldMarchData.IsMine = IsMine
WorldMarchData.HasFightMonster = HasFightMonster
WorldMarchData.GetMarchType = GetMarchType
WorldMarchData.GetArmyInfoIndexOne = GetArmyInfoIndexOne
WorldMarchData.GetWorldType = GetWorldType
WorldMarchData.IsScoutMarch = IsScoutMarch
return WorldMarchData
