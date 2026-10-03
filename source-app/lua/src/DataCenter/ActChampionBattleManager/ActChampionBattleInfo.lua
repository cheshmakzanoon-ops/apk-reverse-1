local ActChampionBattleInfo = BaseClass("ActChampionBattleInfo")

local function __init(self)
  self.startTime = 0
  self.endTime = 0
  self.auditionsST = 0
  self.strongestST = 0
  self.nextRoundST = 0
end

local function __delete(self)
end

local function parseServerData(self, message)
  if message == nil then
    return
  end
  if message.phase ~= nil then
    self.phase = message.phase
  end
  if message.startTime ~= nil then
    self.startTime = message.startTime
  end
  if message.endTime ~= nil then
    self.endTime = message.endTime
  end
  if message.auditionsST ~= nil then
    self.auditionsST = message.auditionsST
  end
  if message.strongestST ~= nil then
    self.strongestST = message.strongestST
  end
  if message.hasSingUp ~= nil then
    self.hasSingUp = message.hasSingUp
  end
  self:UpdateFormationInfo(message)
  if message.currNum ~= nil then
    self.currNum = message.currNum
  end
  if message.auditionsData ~= nil then
    self.auditionsData = message.auditionsData
    if self.auditionsData.nextRoundST ~= nil then
      self.nextRoundST = self.auditionsData.nextRoundST
    end
    if self.auditionsData.auditionsState ~= nil then
      self.auditionsState = self.auditionsData.auditionsState
    end
    if self.auditionsData.totalRound ~= nil then
      self.totalRound = self.auditionsData.totalRound
    end
    if self.auditionsData.winRound ~= nil then
      self.winRound = self.auditionsData.winRound
    end
    if self.auditionsData.loseRound ~= nil then
      self.loseRound = self.auditionsData.loseRound
    end
    if self.auditionsData.curRound ~= nil then
      self.curRound = self.auditionsData.curRound
    end
    if self.auditionsData.rewardBoxList ~= nil then
      self.rewardBoxList = self.auditionsData.rewardBoxList
      local tenResult = ""
      for i = 1, #self.rewardBoxList do
        if self.rewardBoxList[i].state ~= nil then
          tenResult = tenResult .. "_" .. self.rewardBoxList[i].state
        end
      end
      Logger.Log("ActChampionBattleInfo:ten result = %s ", tenResult)
    end
    if self.auditionsData.previewMatchObject ~= nil then
      self.previewMatchObject = self.auditionsData.previewMatchObject
    end
    if self.auditionsData.nextRoundST ~= nil then
      self.nextRoundST = self.auditionsData.nextRoundST
    end
  end
  if message.serverId1 then
    self.serverId1 = tostring(message.serverId1)
  end
  if message.serverId2 then
    self.serverId2 = tostring(message.serverId2)
  end
  if message.strongestData ~= nil then
    self.strongestData = message.strongestData
    if self.strongestData.topEightMembers ~= nil and #self.strongestData.topEightMembers > 0 then
      self.topEightMembers = self.strongestData.topEightMembers
      self.leftMembers = {}
      self.rightMembers = {}
      if self.topEightMembers ~= nil then
        for i = 1, #self.topEightMembers do
          local member = self.topEightMembers[i]
          if member ~= nil then
            if i % 2 == 0 then
              table.insert(self.leftMembers, member)
            else
              table.insert(self.rightMembers, member)
            end
          end
        end
      end
      table.sort(self.leftMembers, function(member1, member2)
        return tonumber(member1.score) > tonumber(member2.score)
      end)
      table.sort(self.rightMembers, function(member1, member2)
        return tonumber(member1.score) > tonumber(member2.score)
      end)
    end
    self.strongObsolete = false
    if self.strongestData.topTwoGroup ~= nil and 0 < #self.strongestData.topTwoGroup then
      self.topTwoGroup = self.strongestData.topTwoGroup
      self:CheckIsObsoleteInStrongest(self.topTwoGroup)
    end
    if self.strongestData.topFourGroup ~= nil and 0 < #self.strongestData.topFourGroup then
      self.topFourGroup = self.strongestData.topFourGroup
      self:CheckIsObsoleteInStrongest(self.topFourGroup)
    end
    if self.strongestData.topEightGroup ~= nil and 0 < #self.strongestData.topEightGroup then
      self.topEightGroup = self.strongestData.topEightGroup
      self:CheckIsObsoleteInStrongest(self.topEightGroup)
    end
    if self.strongestData.nextRoundST ~= nil then
      self.strongestNextRoundST = self.strongestData.nextRoundST
    end
    self.strongestType = ChampionBattlePosterType.Strongest_Two
    if self.strongestData.strongestType ~= nil then
      self.strongestType = self.strongestData.strongestType
    end
  end
  self:CheckRedDot()
end

local function UpdateFormationInfo(self, message)
  if message.formationArray ~= nil then
    self.formationArray = {}
    table.walk(message.formationArray, function(_, v)
      self:ParseFormationInfo(v)
    end)
    table.sort(self.formationArray, function(k, v)
      return k ~= nil and v ~= nil and k.formationId > v.formationId
    end)
  end
end

local function ParseFormationInfo(self, data)
  if data ~= nil then
    local tmp = {}
    tmp.formationId = data.formationId
    tmp.power = data.power
    if data.armyInfo ~= nil then
      local armyUnit = PBController.ParsePb1(data.armyInfo, "protobuf.ArmyUnitInfo")
      tmp.heroes = {}
      local hasDeleteHero = false
      table.walk(armyUnit.heroes, function(k, v)
        local heroData = DataCenter.HeroDataManager:GetHeroByUuid(v.heroUuid)
        if heroData ~= nil then
          table.insert(tmp.heroes, v)
        else
          hasDeleteHero = true
        end
      end)
      if hasDeleteHero == true then
        local heroes = {}
        table.walk(tmp.heroes, function(k, v)
          heroes[v.heroUuid] = v.index
        end)
        local asPlayerMaxSoldiers = toInt(MarchUtil.GetMaxCanAddSoldierNum(heroes, data.formationId))
        tmp.soldiers = {}
        local count = 0
        table.walk(armyUnit.soldiers, function(k, v)
          local currentNum = v.total
          if count + currentNum >= asPlayerMaxSoldiers then
            currentNum = asPlayerMaxSoldiers - count
          end
          currentNum = math.max(currentNum, 0)
          v.total = currentNum
          table.insert(tmp.soldiers, v)
          count = count + currentNum
        end)
      else
        tmp.soldiers = armyUnit.soldiers
      end
    end
    table.insert(self.formationArray, tmp)
  end
end

local function GetFormationData(self, index)
  if self.formationArray == nil then
    return nil
  end
  for _, v in ipairs(self.formationArray) do
    if v ~= nil and v.formationId == index then
      return v
    end
  end
  return nil
end

local function GetFormationHeroPic(self, index)
  if self.formationArray == nil then
    return nil
  end
  for _, v in ipairs(self.formationArray) do
    if v ~= nil and v.formationId == index and v.heroes ~= nil and table.count(v.heroes) > 0 then
      return HeroUtils.GetHeroIconPath(v.heroes[1].heroId)
    end
  end
  return nil
end

local function GetHeroIndexInFormation(self, heroUUid)
  if self.formationArray == nil then
    return 0
  end
  for _, k in ipairs(self.formationArray) do
    for _, v in ipairs(k.heroes) do
      if v.heroUuid == heroUUid then
        return k.formationId
      end
    end
  end
  return 0
end

local function CheckIsObsoleteInStrongest(self, dataList)
  if self.strongObsolete ~= true and dataList ~= nil then
    for i = 1, #dataList do
      local member = dataList[i]
      if member ~= nil and member.loseUid == LuaEntry.Player.uid then
        self.strongObsolete = true
      end
    end
  end
end

local function GetPlayerMsgByUid(self, uid)
  local onePlayerMsg
  if uid == nil or uid == "" then
    Logger.Log("ActChampionBattleInfo:GetPlayerMsgByUid \230\159\165\230\137\190\231\154\132uid = nil")
    return onePlayerMsg
  end
  if self.topEightMembers ~= nil then
    for i = 1, #self.topEightMembers do
      local onePlayerData = self.topEightMembers[i]
      if onePlayerData ~= nil and tostring(uid) == tostring(onePlayerData.uid) then
        onePlayerMsg = onePlayerData
        return onePlayerMsg
      end
    end
  end
  return onePlayerMsg
end

local function GetChampionKingData(self)
  local king
  if self.topTwoGroup ~= nil then
    for i = 1, #self.topTwoGroup do
      local member = self.topTwoGroup[i]
      if member ~= nil and member.winUid ~= nil then
        king = self:GetPlayerMsgByUid(member.winUid)
        return king
      end
    end
  end
  return king
end

local function GetStrongestPosterDataByType(self, type)
  local list
  if type == ChampionBattlePosterType.Strongest_Eight then
    list = self.topEightGroup
  elseif type == ChampionBattlePosterType.Strongest_Four then
    list = self.topFourGroup
  elseif type == ChampionBattlePosterType.Strongest_Two then
    list = self.topTwoGroup
  elseif type == ChampionBattlePosterType.Strongest_King then
    local king = self:GetChampionKingData()
    if king ~= nil then
      list = {}
      table.insert(list, king)
    end
  end
  if list ~= nil and 0 < #list then
    return list
  end
  return nil
end

local function GetCurState(self)
  local state = Activity_ChampionBattle_Stage_State.None
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.startTime - curTime > 0 then
    Logger.Log("ActChampionBattleInfo\239\188\154\230\180\187\229\138\168\229\176\154\230\156\170\229\188\128\229\144\175")
  elseif 0 > self.endTime - curTime then
    Logger.Log("ActChampionBattleInfo\239\188\154\230\180\187\229\138\168\229\183\178\231\187\143\231\187\147\230\157\159")
  else
    state = self.phase
  end
  return state
end

local function GetPlayerRankByUid(self, uid)
  local rank = 0
  table_walk(self.leftMembers, function(k, v)
    if v ~= nil and uid == v.uid then
      rank = k
      return
    end
  end)
  if rank == 0 then
    table_walk(self.rightMembers, function(k, v)
      if v ~= nil and uid == v.uid then
        rank = k
        return
      end
    end)
  end
  return rank
end

local function CheckRedDot(self)
  return false
end

ActChampionBattleInfo.__init = __init
ActChampionBattleInfo.__delete = __delete
ActChampionBattleInfo.parseServerData = parseServerData
ActChampionBattleInfo.CheckIsObsoleteInStrongest = CheckIsObsoleteInStrongest
ActChampionBattleInfo.GetPlayerMsgByUid = GetPlayerMsgByUid
ActChampionBattleInfo.GetChampionKingData = GetChampionKingData
ActChampionBattleInfo.GetStrongestPosterDataByType = GetStrongestPosterDataByType
ActChampionBattleInfo.GetCurState = GetCurState
ActChampionBattleInfo.GetPlayerRankByUid = GetPlayerRankByUid
ActChampionBattleInfo.CheckRedDot = CheckRedDot
ActChampionBattleInfo.UpdateFormationInfo = UpdateFormationInfo
ActChampionBattleInfo.ParseFormationInfo = ParseFormationInfo
ActChampionBattleInfo.GetFormationData = GetFormationData
ActChampionBattleInfo.GetFormationHeroPic = GetFormationHeroPic
ActChampionBattleInfo.GetHeroIndexInFormation = GetHeroIndexInFormation
return ActChampionBattleInfo
