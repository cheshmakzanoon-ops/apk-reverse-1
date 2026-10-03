local WorldPointDetailData = BaseClass("WorldPointDetailData")
local WorldDesertData = require("DataCenter.DesertData.WorldDesertData")
local AlMineData = require("DataCenter.AllianceMine.AllianceMineData")
local ActGhostreconTaskInfo = require("DataCenter.ActivityListData.ActGhostrecon.ActGhostreconTaskInfo")

local function __init(self)
  self.uid = ""
  self.picVer = 0
  self.pic = ""
  self.name = ""
  self.allianceId = ""
  self.alAbbr = ""
  self.allianceName = ""
  self.power = 0
  self.armyKill = 0
  self.serverId = 0
  self.allianceIcon = ""
  self.allianceRank = 0
  self.vipLevel = 0
  self.pointId = 0
  self.reward = {}
  self.speed = 0
  self.remainRes = 0
  self.initRes = 0
  self.careerType = CareerType.None
  self.careerLv = 0
  self.plunderResRate = 0
  self.attachId = 0
  self.resSpecialType = ResPointType.Normal
  self.expireTime = 0
  self.eventExpireTime = 0
  self.desertInfo = nil
  self.allianceScout = nil
  self.alBuilding = nil
  self.srcServer = 0
  self.maxHp = 0
  self.coverSpeed = 0
  self.taskInfo = nil
  self.isSuperRewardActive = 0
  self.disPlaySkinArr = nil
  self.donateProgress = 0
  self.maxProgress = 0
  self.stage = 0
  self.nextStageTime = 0
  self.transferBeginTime = 0
  self.meteorite = nil
  self.activityId = 0
  self.valentineShow = 0
  self.valentineExp = 0
  self.valentineRank = 0
  self.maxAssistance = 0
  self.uuid = nil
end

local function __delete(self)
  self.uid = nil
  self.picVer = nil
  self.pic = nil
  self.name = nil
  self.allianceId = nil
  self.alAbbr = nil
  self.allianceName = nil
  self.power = nil
  self.armyKill = nil
  self.serverId = nil
  self.allianceIcon = nil
  self.allianceRank = nil
  self.vipLevel = nil
  self.pointId = nil
  self.reward = nil
  self.speed = nil
  self.remainRes = nil
  self.initRes = nil
  self.careerType = nil
  self.careerLv = nil
  self.plunderResRate = nil
  self.attachId = nil
  self.resSpecialType = nil
  self.expireTime = nil
  self.eventExpireTime = nil
  self.desertInfo = nil
  self.allianceScout = nil
  self.alBuilding = nil
  self.srcServer = 0
  self.maxHp = 0
  self.coverSpeed = 0
  self.taskInfo = nil
  self.isSuperRewardActive = nil
  self.disPlaySkinArr = nil
  self.donateProgress = nil
  self.maxProgress = nil
  self.stage = nil
  self.nextStageTime = nil
  self.transferBeginTime = nil
  self.meteorite = nil
  self.activityId = nil
  self.valentineShow = nil
  self.valentineExp = nil
  self.valentineRank = nil
  self.maxAssistance = nil
  self.uuid = nil
end

local function ParseData(self, message)
  if message == nil then
    return
  end
  if message.resourceId ~= nil then
    self.resourceId = message.resourceId
  end
  if message.pointId ~= nil then
    self.pointId = message.pointId
  elseif message.point ~= nil then
    self.pointId = message.point
  end
  if message.uid ~= nil then
    self.uid = message.uid
  end
  if message.name ~= nil then
    self.name = message.name
  end
  if message.picVer ~= nil then
    self.picVer = message.picVer
  end
  if message.pic ~= nil then
    self.pic = message.pic
  end
  if message.allianceId ~= nil then
    self.allianceId = message.allianceId
  end
  if message.afn ~= nil then
    self.alAbbr = message.afn
  end
  if message.alName ~= nil then
    self.allianceName = message.alName
  end
  if message.power ~= nil then
    self.power = message.power
  end
  if message.killArmy ~= nil then
    self.armyKill = message.killArmy
  end
  if message.alIcon ~= nil then
    self.allianceIcon = message.alIcon
  end
  if message.rank ~= nil then
    self.allianceRank = message.rank
  end
  if message.vl ~= nil then
    self.vipLevel = message.vl
  end
  if message.scrServer ~= nil then
    self.serverId = message.scrServer
  end
  if message.speed ~= nil then
    self.speed = message.speed
  end
  if message.remainRes ~= nil then
    self.remainRes = message.remainRes
  elseif message.reserve ~= nil then
    self.remainRes = message.reserve
  end
  if message.initRes ~= nil then
    self.initRes = message.initRes
  elseif message.initReserve ~= nil then
    self.initRes = message.initReserve
  end
  if message.reward then
    self.reward = DataCenter.RewardManager:ReturnRewardParamForView(message.reward)
  end
  if message.careerType then
    self.careerType = message.careerType
  end
  if message.careerLv then
    self.careerLv = message.careerLv
  end
  if message.plunderResRate then
    self.plunderResRate = message.plunderResRate
  end
  if message.attachId then
    self.attachId = message.attachId
  end
  if message.plunderResRate then
    self.resSpecialType = message.type
  end
  if message.expireTime then
    self.expireTime = message.expireTime
  end
  if message.eventExpireTime then
    self.eventExpireTime = message.eventExpireTime
  end
  if message.desert ~= nil then
    self.desertInfo = WorldDesertData.New()
    self.desertInfo:ParseData(message.desert)
    if string.IsNullOrEmpty(self.allianceId) then
      self.allianceId = self.desertInfo.allianceId
    end
  end
  if message.allianceScout then
    self.allianceScout = message.allianceScout
  end
  if message.maxHp then
    self.maxHp = tonumber(message.maxHp)
  end
  if message.srcServer then
    self.srcServer = message.srcServer
  end
  if message.alBuilding then
    self.alBuilding = AlMineData.New()
    self.alBuilding:ParseData(message.alBuilding)
    if self.alBuilding.allianceId ~= nil and self.alBuilding.allianceId ~= "" and self.alBuilding.allianceId == LuaEntry.Player.allianceId then
      DataCenter.AllianceMineManager:UpdateMinInfo(self.alBuilding)
    end
  end
  if message.taskInfo then
    self.taskInfo = ActGhostreconTaskInfo.New()
    self.taskInfo:ParseData(message.taskInfo)
  end
  if message.isSuperRewardActive then
    self.isSuperRewardActive = message.isSuperRewardActive
  end
  if message.allianceBuildInfo then
    self.allianceBuildInfo = message.allianceBuildInfo
  end
  if message.furnace then
    self.furnace = message.furnace
  end
  if message.scoreList then
    self.scoreList = message.scoreList
  end
  if not string.IsNullOrEmpty(self.allianceId) and string.IsNullOrEmpty(self.alAbbr) then
    local data = DataCenter.AllianceTempListManager:GetSearchAllianceDataByUid(self.allianceId)
    if data ~= nil then
      self.alAbbr = data.abbr
      self.allianceName = data.allianceName
    elseif self.allianceId == LuaEntry.Player:GetAllianceUid() then
      data = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
      if data ~= nil and data.abbr ~= nil and data.abbr ~= "" then
        self.alAbbr = data.abbr
        self.allianceName = data.allianceName
      end
    else
      SFSNetwork.SendMessage(MsgDefines.GetAllianceInfo, self.allianceId)
    end
  end
  if message.disPlaySkinArr then
    self.disPlaySkinArr = message.disPlaySkinArr
  end
  if message.donateProgress then
    self.donateProgress = message.donateProgress
  end
  if message.maxProgress then
    self.maxProgress = message.maxProgress
  end
  if message.stage then
    self.stage = message.stage
  end
  if message.nextStageTime then
    self.nextStageTime = message.nextStageTime
  end
  if message.transferBeginTime then
    self.transferBeginTime = message.transferBeginTime
  end
  if message.meteorite then
    self.meteorite = message.meteorite
  end
  if message.activityId then
    self.activityId = message.activityId
  end
  if message.valentineShow then
    self.valentineShow = message.valentineShow
  end
  if message.valentineExp then
    self.valentineExp = message.valentineExp
  end
  if message.valentineRank then
    self.valentineRank = message.valentineRank
  end
  if message.lightHouse then
    self.otherPowerWorkerNum = toInt(message.lightHouse.otherPowerWorkerNum)
    self.otherPowerWorkerMaxNum = toInt(message.lightHouse.otherPowerWorkerMaxNum)
    if self.otherPowerWorkerMaxNum == 0 then
      self.otherPowerWorkerNum = nil
      self.otherPowerWorkerMaxNum = nil
    end
  else
    self.otherPowerWorkerNum = nil
    self.otherPowerWorkerMaxNum = nil
  end
  if WorldBattleUtil.EnableShowWorldAssistanceInfo() then
    self.maxAssistance = message.maxAssistance or 0
    self.currAssistance = message.currAssistance or 0
    self.assistanceTotalPower = message.assistanceTotalPower or 0
    self.assistanceList = nil
    if message.assistanceList then
      self.assistanceList = {}
      for k, v in ipairs(message.assistanceList) do
        local _p = AssistancePlayerInfo.New()
        _p:Parse(v)
        table.insert(self.assistanceList, _p)
      end
    end
  else
    self.assistanceList = nil
  end
  if message.wolfEndTime and UITimeManager:GetInstance():GetServerTime() < message.wolfEndTime then
    self.wolfEndTime = message.wolfEndTime
  end
  if message.uuid then
    self.uuid = message.uuid
  end
end

WorldPointDetailData.__init = __init
WorldPointDetailData.__delete = __delete
WorldPointDetailData.ParseData = ParseData
return WorldPointDetailData
