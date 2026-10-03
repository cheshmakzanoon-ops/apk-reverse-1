local rapidjson = require("rapidjson")
local BattleEffectList = require("DataCenter.MailData.BattleReport.BattleEffectData.BattleEffectList")
local MailBattleParseHelper = require("DataCenter.MailData.MailBattleParseHelper")
local AllFightLost = require("DataCenter.MailData.BattleReport.AllFightLost")
local MailBattleReportPVPHelper = require("DataCenter.MailData.DataExtModule.MailBattleReportPVPHelper")
local MailBattleReportPVEHelper = require("DataCenter.MailData.DataExtModule.MailBattleReportPVEHelper")
local Localization = CS.GameEntry.Localization
local MailBattleReport = BaseClass("MailBattleReport")

function MailBattleReport:__init()
  self._fightRoundList = {}
  self.showRoundList = {}
  self._battlePointId = 0
  self._battleServerId = -1
  self._battleBuffList = {}
  self.version = 0
  self.marchTargetType = -1
  self.needExchangeInfo = false
  self.playerOld = {}
  self.player = {}
  self.MailBattleReportPVPHelper = {}
  self.MailBattleReportPVEHelper = {}
  self.reportIntegrity = true
  self.address = ""
  self.level = nil
end

function MailBattleReport:__delete()
  self.playerOld = nil
  self.player = nil
  self.army = nil
  self.round = nil
  self.hero = nil
  self.reward = nil
  self.allianceCityInfo = nil
  self.monsterInvasionInfo = nil
  self.city = nil
  self.army = nil
  self.MailBattleReportPVPHelper = nil
  self.MailBattleReportPVEHelper = nil
  self.address = nil
  self.level = nil
  self.assistanceProtectedCity = nil
end

function MailBattleReport:GetBattleFightPointId()
  return self._battlePointId
end

function MailBattleReport:GetBattleServerId()
  return self._battleServerId
end

function MailBattleReport:GetBattleWorldId()
  return self._battleWorldId
end

function MailBattleReport:GetBattleDownloadAddress()
  return self.address
end

function MailBattleReport:GetIfAddressMode()
  return BattleReportUtil.IsAddressMode(self.address)
end

function MailBattleReport:GetSimpleCombatUnitByUuid()
end

function MailBattleReport:ParseContent(mailContent, mailType)
  if table.IsNullOrEmpty(mailContent) then
    return
  end
  local battleReport = mailContent.battleContent or ""
  local pb_BattleReport = PBController.ParsePb1(battleReport, "protobuf.LwBattleReport") or {}
  self:ParseProto(pb_BattleReport)
  if SeasonUtil.SeasonHasMummyYardBuild() then
    self:CheckSoldierType(pb_BattleReport)
  end
  if mailContent.extra then
    if mailType == MailType.TRUCK_BATTLE_REPORT then
      self.trainData = mailContent.extra
    else
      self.hpData = mailContent.extra
      if mailType == MailType.FIGHT_MONSTER then
        local monsterId = mailContent.extra.monsterChallengeInfo and mailContent.extra.monsterChallengeInfo.monsterConfigId
        if monsterId then
          local line = LocalController:instance():getLine(TableName.Monster, monsterId)
          if line and line.special and tonumber(line.special) == WorldMonsterSpecialType.IndividualChallengeBoss then
            self.level = line.level
          end
        end
      end
    end
  end
end

function MailBattleReport:CheckSoldierType(pb_BattleReport)
  if self.isMuster and self.player then
    local mgr = DataCenter.SoldierDataManager
    for k, player in pairs(self.player) do
      if player and player.armyType == MailTargetType.Player and player.soldierBeforeStart then
        for _, v in pairs(player.soldierBeforeStart) do
          local meta = mgr:GetTemplate(v.soldierId)
          if meta and meta.type == SoldierType.Mummy then
            self.fixedSoldierType = SoldierType.Mummy
            return
          end
        end
      end
    end
  end
  local round = pb_BattleReport.round
  if round then
    local mgr = DataCenter.SoldierDataManager
    for k1, v1 in pairs(round) do
      if v1.battle then
        for k2, v2 in pairs(v1.battle) do
          if v2.player then
            for k3, v3 in pairs(v2.player) do
              if v3.soldierBeforeStart then
                for k4, v4 in pairs(v3.soldierBeforeStart) do
                  local meta = mgr:GetTemplate(v4.soldierId)
                  if meta and meta.type == SoldierType.Mummy then
                    self.fixedSoldierType = SoldierType.Mummy
                    return
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end

function MailBattleReport:ParseContentForSkirmish(mailContent)
  if table.IsNullOrEmpty(mailContent) then
    return
  end
  local battleReport = ""
  if mailContent.contentsArr then
    battleReport = string.join(mailContent.contentsArr)
  elseif mailContent.content then
    battleReport = mailContent.content
  end
  local pb_BattleReport = PBController.ParsePbFromBytes(battleReport, "protobuf.LwBattleReport") or {}
  self:ParseProto(pb_BattleReport)
end

function MailBattleReport:ParseProto(pb_BattleReport, isSolo)
  self.pb_BattleReport = pb_BattleReport
  self.version = pb_BattleReport.version or 0
  self.myHospitalFull = false
  self.uuid = pb_BattleReport.uuid or 0
  self.battleType = pb_BattleReport.type or MailBattleReportType.City
  self.battleTime = pb_BattleReport.battleTime or 0
  self.player = pb_BattleReport.player
  self.address = pb_BattleReport.address or ""
  if table.count(self.player) == 0 and self.version >= NEED_REQUEST_REPORT_VERSION then
    self.reportIntegrity = false
    return
  else
  end
  self.reportIntegrity = true
  local _battlePointInfo = pb_BattleReport.battlePointInfo
  if _battlePointInfo and _battlePointInfo.pointId then
    self._battlePointId = _battlePointInfo.pointId
    self._battleServerId = _battlePointInfo.battleServerId
    self._battleWorldId = _battlePointInfo.worldId
    self.battlePointOwnerUid = _battlePointInfo.ownerUid
  end
  if MailShowHelper.IsSeasonBattleMail(self.mailType, self.battleType) then
    self.playerOld = self.player
  end
  if self._battlePointId == 0 and self.player and self.player[2] and self.player[2].user then
    self._battlePointId = self.player[2].user.pointId
  end
  self.totalDeath = {
    [1] = 0,
    [2] = 0
  }
  self.hero = {}
  self.weapon = {}
  self.isMuster = pb_BattleReport.isCombineReport == 1
  if self.isMuster then
    if self.player then
      for k, player in pairs(self.player) do
        if player.user and player.user.uid == LuaEntry.Player:GetUid() then
          self.isAttack = k == 1
          self.isDefend = k == 2
          self.myHospitalFull = player.isHospitalFull
        end
      end
    end
    local maxHumanPower = 0
    local maxMonsterPower = 0
    self.army = {}
    if self.battleType == MailBattleReportType.City and self.battlePointOwnerUid then
      self.assistanceProtectedCity = true
    end
    for k, v in pairs(pb_BattleReport.combinePlayer) do
      local player = v.player
      local parseSuccess = MailBattleParseHelper.DecodeLwBattlePlayerStat(player)
      if not parseSuccess then
        self.parseFail = true
        return
      end
      local index = v.index + 1
      if not self.army[index] then
        self.army[index] = {}
      end
      if v.side == 0 then
        self.army[index][1] = player
      else
        self.army[index][2] = player
      end
      if player.armyType == MailTargetType.Player then
        if maxHumanPower < player.soldierCountBeforeStart then
          maxHumanPower = player.soldierCountBeforeStart
        end
      elseif maxMonsterPower < player.soldierCountBeforeStart then
        maxMonsterPower = player.soldierCountBeforeStart
      end
      if player.user and player.user.uid == LuaEntry.Player:GetUid() then
        self.isAttack = v.side == 0
        self.isDefend = v.side == 1
        self.myHospitalFull = player.isHospitalFull
      end
      if self.assistanceProtectedCity and player.user and player.user.uid == self.battlePointOwnerUid then
        self.assistanceProtectedCity = false
      end
    end
    local needSecondCheck = LuaEntry.Player:IsInAlliance() and self:GetMyCamp() == BattleReportCamp.ThirdParty
    for k, v in pairs(pb_BattleReport.combinePlayer) do
      local player = v.player
      if player.armyType == MailTargetType.Player then
        player.maxMaxSoldierPower = maxHumanPower
      else
        player.maxMaxSoldierPower = maxMonsterPower
      end
      if needSecondCheck and player.user and player.user.allianceInfo and player.user.allianceInfo.allianceId == LuaEntry.Player:GetAllianceUid() then
        self.isAttack = v.side == 0
        self.isDefend = v.side == 1
        needSecondCheck = false
      end
    end
    self.round = pb_BattleReport.round
    if self.round then
      for i = 1, #self.round do
        local battle = self.round[i].battle
        if battle then
          for j = 1, #battle do
            local player = battle[j].player
            if player and #player == 2 then
              for k = 1, 2 do
                local slList = player[k].soldierLost
                for l = 1, #slList do
                  self.totalDeath[k] = self.totalDeath[k] + slList[l].dead + slList[l].injured + slList[l].wounded
                end
              end
              local atkMummyBlowUpResult = pb_BattleReport.atkMummyBlowUpResultDetail
              local defMummyBlowUpResult = pb_BattleReport.defMummyBlowUpResultDetail
              if atkMummyBlowUpResult then
                for k, v in ipairs(atkMummyBlowUpResult) do
                  self.totalDeath[2] = self.totalDeath[2] + v.dead
                end
              end
              if defMummyBlowUpResult then
                for k, v in ipairs(defMummyBlowUpResult) do
                  self.totalDeath[1] = self.totalDeath[1] + v.dead
                end
              end
            end
            battle[j].winKillSoldierDetail = pb_BattleReport.winKillSoldierDetail
            battle[j].hospitalFullDeadDetail = pb_BattleReport.hospitalFullDeadDetail
            battle[j].ricochetDetail = pb_BattleReport.ricochetDetail
          end
        end
      end
    end
    self.overTime = PVPBattleOvertimeType.None
  else
    local theBattle = pb_BattleReport
    local needExchangePlayer = true
    self.units = pb_BattleReport.units or {}
    if pb_BattleReport.round and pb_BattleReport.round[1] and pb_BattleReport.round[1].battle and pb_BattleReport.round[1].battle[1] then
      theBattle = pb_BattleReport.round[1].battle[1]
      if needExchangePlayer and theBattle.player then
        local thePlayers = theBattle.player
        if #thePlayers ~= 0 then
          self.player = thePlayers
          self:RefreshAssistanceState(self.player[2])
        end
      end
      if theBattle.units then
        self.units = theBattle.units
      end
    end
    self.atkMummyBlowUpResultDetail = theBattle.atkMummyBlowUpResultDetail
    self.defMummyBlowUpResultDetail = theBattle.defMummyBlowUpResultDetail
    self.overTime = theBattle.overTime or PVPBattleOvertimeType.None
    local parseSuccess = MailBattleParseHelper.DecodeLwBattleHero(self.units)
    if not parseSuccess then
      self.parseFail = true
      return
    end
    parseSuccess = MailBattleParseHelper.DecodeLwBattleWeapon(self.units)
    if not parseSuccess then
      self.parseFail = true
      return
    end
    parseSuccess = MailBattleParseHelper.DecodeLwBattleDominator(self.units)
    if not parseSuccess then
      self.parseFail = true
      return
    end
    for _, v in pairs(self.units) do
      if v.unitType and v.unitType == BattleUnitType.TacticalWeapon then
        self.weapon[v.index] = v
      else
        self.hero[v.index] = v
      end
    end
    if not self.player then
      Logger.LogError("\230\136\152\230\138\165\232\167\163\230\158\144\229\164\177\232\180\165\239\188\154player=nil\239\188\140uid=" .. self.uuid)
      self.parseFail = true
      return
    else
      for k, player in pairs(self.player) do
        if player.user and player.user.uid == LuaEntry.Player:GetUid() then
          self.isAttack = k == 1
          self.isDefend = k == 2
          self.myHospitalFull = player.isHospitalFull
        end
      end
      if self.playerOld and not self.isAttack and not self.isDefend then
        for k, player in pairs(self.playerOld) do
          if player.user and player.user.uid == LuaEntry.Player:GetUid() then
            self.isAttack = k == 1
            self.isDefend = k == 2
            self.myHospitalFull = player.isHospitalFull
          end
        end
      end
    end
    if not self.isAttack and not self.isDefend and pb_BattleReport.combinePlayer then
      for k, v in pairs(pb_BattleReport.combinePlayer) do
        local player = v.player
        if player.user and player.user.uid == LuaEntry.Player:GetUid() then
          self.isAttack = v.side == 0
          self.isDefend = v.side == 1
          self.myHospitalFull = player.isHospitalFull
        end
      end
    end
    local needSecondCheck = LuaEntry.Player:IsInAlliance() and self:GetMyCamp() == BattleReportCamp.ThirdParty
    if needSecondCheck then
      for k, player in pairs(self.player) do
        if player.user and player.user.allianceInfo and player.user.allianceInfo.allianceId == LuaEntry.Player:GetAllianceUid() then
          self.isAttack = k == 1
          self.isDefend = k == 2
          needSecondCheck = false
          break
        end
      end
    end
    if needSecondCheck and pb_BattleReport.combinePlayer then
      for k, v in pairs(pb_BattleReport.combinePlayer) do
        local player = v.player
        if player.user and player.user.allianceInfo and player.user.allianceInfo.allianceId == LuaEntry.Player:GetAllianceUid() then
          self.isAttack = v.side == 0
          self.isDefend = v.side == 1
          needSecondCheck = false
          break
        end
      end
    end
    for j = 1, 2 do
      local onePlayer = self.player[j]
      if onePlayer then
        local slList = onePlayer.soldierLost
        for i = 1, #slList do
          self.totalDeath[j] = self.totalDeath[j] + slList[i].dead + slList[i].injured + slList[i].wounded
        end
      end
    end
    if self.atkMummyBlowUpResultDetail then
      for k, v in ipairs(self.atkMummyBlowUpResultDetail) do
        self.totalDeath[2] = self.totalDeath[2] + v.dead
      end
    end
    if self.defMummyBlowUpResultDetail then
      for k, v in ipairs(self.defMummyBlowUpResultDetail) do
        self.totalDeath[1] = self.totalDeath[1] + v.dead
      end
    end
  end
  local battleResult = pb_BattleReport.fightResult or 1
  self.attackerWin = battleResult == 1
  if self.isAttack then
    self.selfWin = self.attackerWin
  elseif self.isDefend then
    self.selfWin = not self.attackerWin
  end
  for i = 1, 2 do
    local parseSuccess = MailBattleParseHelper.DecodeLwBattlePlayerStat(self.player[i], self.playerOld[i])
    if not parseSuccess then
      self.parseFail = true
      return
    end
  end
  self.allianceCityInfo = pb_BattleReport.allianceCityInfo
  if self.allianceCityInfo then
    self.allianceCityInfo.delta = self.allianceCityInfo.durability - self.allianceCityInfo.durabilityBeforeStart
    self.cityMeta = DataCenter.AllianceCityTemplateManager:GetTemplate(self.allianceCityInfo.cityId)
    if self.cityMeta then
      self.city = {}
      self.city.pic = self.cityMeta:GetIconPath(false)
      self.city.name = Localization:GetString(self.cityMeta.name)
      self.city.level = self.cityMeta.level
    else
      Logger.LogError(string.format("lw_worldcity cant find %s", self.allianceCityInfo.cityId))
      self.parseFail = true
      return
    end
  end
  self.monsterInvasionInfo = pb_BattleReport.monsterInvasionInfo
  local monsterBuffList = pb_BattleReport.monsterBuffList
  self.monsterBuffList = not table.IsNullOrEmpty(monsterBuffList) and monsterBuffList
  if self.allianceCityInfo then
    self.targetType = MailTargetType.AllianceCity
  else
    self.targetType = self.player[2].armyType
  end
  self.reward = pb_BattleReport.reward or {}
  local killSoldier = pb_BattleReport.winKillSoldier or 0
  if 0 < killSoldier then
    local param = {
      sprite = "Assets/Main/Sprites/UI/UILWMail/zyf_zhanbao_kulou.png",
      count = killSoldier,
      tip = Localization:GetString(GameDialogDefine.MAIL_KILL_SOLDIER_TIP)
    }
    if not self.reward.rewardInfo then
      self.reward.rewardInfo = {}
    end
    table.insert(self.reward.rewardInfo, param)
  end
  self.winKillSoldierList = {}
  if pb_BattleReport.winKillSoldierDetail then
    self:ParseSoldierLostInfo(self.winKillSoldierList, pb_BattleReport.winKillSoldierDetail)
  end
  self.hospitalFullSoldierList = {}
  if pb_BattleReport.hospitalFullDeadDetail then
    self:ParseSoldierLostInfo(self.hospitalFullSoldierList, pb_BattleReport.hospitalFullDeadDetail)
  end
  self.ricochetSoldierList = {}
  if pb_BattleReport.ricochetDetail then
    self:ParseSoldierLostInfo(self.ricochetSoldierList, pb_BattleReport.ricochetDetail)
  end
  self.atkMummyBlowUpList = {}
  if self.atkMummyBlowUpResultDetail then
    self:ParseSoldierLostInfo(self.atkMummyBlowUpList, self.atkMummyBlowUpResultDetail)
  end
  self.defMummyBlowUpList = {}
  if self.defMummyBlowUpResultDetail then
    self:ParseSoldierLostInfo(self.defMummyBlowUpList, self.defMummyBlowUpResultDetail)
  end
  self.plunderValue = pb_BattleReport.plunderValue or 0
  self.maxPlunderValue = pb_BattleReport.maxPlunderValue or 0
  self.totalTime = pb_BattleReport.totalTime or 0
  if self.hero then
    local maxDamage, maxInjured, maxEnhance, maxWeaken = 0, 0, 0, 0
    for _, v in pairs(self.hero) do
      if not v.stat then
        Logger.LogError(string.format("\230\136\152\230\138\165v.stat cant find,\230\136\152\230\138\165uuid=%s", self.uuid))
        self.parseFail = true
        return
      end
      if maxDamage < v.stat.damage then
        maxDamage = v.stat.damage
      end
      if maxInjured < v.stat.injured then
        maxInjured = v.stat.injured
      end
      if maxEnhance < v.stat.enhance then
        maxEnhance = v.stat.enhance
      end
      if maxWeaken < v.stat.weaken then
        maxWeaken = v.stat.weaken
      end
    end
    maxDamage = maxDamage < 1 and 1 or maxDamage
    maxInjured = maxInjured < 1 and 1 or maxInjured
    maxEnhance = maxEnhance < 1 and 1 or maxEnhance
    maxWeaken = maxWeaken < 1 and 1 or maxWeaken
    self.maxDamage, self.maxInjured, self.maxEnhance, self.maxWeaken = maxDamage, maxInjured, maxEnhance, maxWeaken
  end
  if self._battlePointId == 0 and self.player[2].user then
    self._battlePointId = self.player[2].user.pointId
  end
  local marchType = 0
  self.marchTargetType = marchType - 1
  if self.isDefend == true and not self.selfWin and self:GetMyCamp() ~= BattleReportCamp.ThirdParty then
    local hasHero = false
    if self.hero then
      for i = PVPBattleSlot.EnemyHero1, PVPBattleSlot.EnemyHero5 do
        if self.hero[i] ~= nil and 0 < self.hero[i].maxSoldierCount then
          hasHero = true
          break
        end
      end
    end
    if not hasHero then
      self.MailBattleReportPVPHelper = {}
      self.MailBattleReportPVEHelper = {}
      return
    end
  end
  if not self.isMuster then
    if self:GetIsPVPBattle() and not self.selfWin and self:IsMyselfInBattle() then
      self.MailBattleReportPVPHelper = MailBattleReportPVPHelper.New()
      self.MailBattleReportPVPHelper:Init(self, self.player, self.hero, self.weapon, isSolo, self)
    elseif self:GetIsPVEBattle() and not self.selfWin and self:IsMyselfInBattle() then
      self.MailBattleReportPVEHelper = MailBattleReportPVEHelper.New()
      self.MailBattleReportPVEHelper:Init(self, self.player, self.hero, self.weapon, isSolo, self)
    end
  end
end

function MailBattleReport:RefreshAssistanceState(defence)
  self.assistanceProtectedCity = false
  if self.battleType == MailBattleReportType.City and self.battlePointOwnerUid and defence and defence.user and defence.user.uid ~= self.battlePointOwnerUid then
    self.assistanceProtectedCity = true
  end
end

function MailBattleReport:ParseSoldierLostInfo(dataList, list)
  for i = 1, #list do
    dataList[i] = {
      id = list[i].soldierId,
      count = list[i].dead
    }
  end
  table.sort(dataList, function(a, b)
    local aTemplate = DataCenter.SoldierDataManager:GetTemplate(a.id)
    local bTemplate = DataCenter.SoldierDataManager:GetTemplate(b.id)
    if aTemplate and bTemplate and aTemplate.lv ~= bTemplate.lv then
      return aTemplate.lv < bTemplate.lv
    end
    return a.id < b.id
  end)
end

function MailBattleReport:GetBattleWinInPve()
  for _, roundItem in pairs(self._fightRoundList) do
    if roundItem:GetBattleResult() ~= FightResult.SELF_WIN then
      return false
    end
  end
  return true
end

function MailBattleReport:GetMarchTargetType()
  return self.marchTargetType
end

function MailBattleReport:AddInShowList(battleRound, roundIndex)
  local vsList = battleRound:GetVsMap()
  local leaderUuid = battleRound:GetLeaderUuid(true)
  for k, v in pairs(vsList) do
    for a, b in pairs(v) do
      local oneData = {}
      oneData.leftUuid = k
      oneData.rightUuid = a
      oneData.roundIndex = roundIndex
      self.showRoundList[#self.showRoundList + 1] = oneData
    end
  end
  if self.mailType == nil or self.mailType ~= MailType.ELITE_FIGHT_MAIL then
    table.sort(self.showRoundList, function(a, b)
      if a.leftUuid == leaderUuid and b.leftUuid ~= leaderUuid then
        return true
      end
      return false
    end)
  end
end

function MailBattleReport:InsertRound(battleRound)
  local index = #self._fightRoundList + 1
  self._fightRoundList[index] = battleRound
  self:AddInShowList(battleRound, index)
end

function MailBattleReport:GetAllMembers(isMySide)
  local tbl = {}
  for _, v in pairs(self._fightRoundList) do
    local tb = v:GetAllMembers(isMySide)
    for _, v in pairs(tb) do
      tbl[#tbl + 1] = v
    end
  end
  return tbl
end

function MailBattleReport:GetStartRound()
  return self._startRound
end

function MailBattleReport:InitMySideBattleEffect(buffEffect)
  self._battleBuffList = {}
  for _, buffItem in pairs(buffEffect) do
    local uuid = buffItem.memberUuid
    local arrayEffect = buffItem.battleEffectInfos
    local oneData = BattleEffectList.New()
    oneData:InitData(arrayEffect)
    self._battleBuffList[uuid] = oneData
  end
end

function MailBattleReport:InitAllFightLost(allFightLost)
  self.allFightLost = {}
  for k, v in pairs(allFightLost) do
    local oneData = AllFightLost.New()
    oneData:InitData(v)
    if oneData.uuid ~= 0 then
      self.allFightLost[oneData.uuid] = oneData
    end
  end
end

function MailBattleReport:GetResLostListByTargetUuid(targetUuid)
  if self.allFightLost ~= nil and self.allFightLost[targetUuid] ~= nil then
    return self.allFightLost[targetUuid]:GetResLostList()
  end
end

function MailBattleReport:GetResItemLostListByTargetUuid(targetUuid)
  if self.allFightLost ~= nil and self.allFightLost[targetUuid] ~= nil then
    return self.allFightLost[targetUuid]:GetResItemLostArr()
  end
end

function MailBattleReport:GetMySideBattleEffect(marchId)
  if self.mailType ~= nil and self.mailType == MailType.ELITE_FIGHT_MAIL then
    for _, roundItem in pairs(self._fightRoundList) do
      local _battleBuff = roundItem:GetSelfBattleEffectByMarchId(marchId)
      if _battleBuff ~= nil then
        return _battleBuff
      end
    end
  else
    return self._battleBuffList[marchId]
  end
end

function MailBattleReport:GetOtherSideBattleEffect(marchId)
  for _, roundItem in pairs(self._fightRoundList) do
    local _battleBuff = roundItem:GetOtherBattleEffectByMarchId(marchId)
    if _battleBuff ~= nil then
      return _battleBuff
    end
  end
end

function MailBattleReport:GetBuildingName(isMySide)
  for _, roundItem in pairs(self._fightRoundList) do
    local battleType = isMySide and roundItem:GetSelfBattleType() or roundItem:GetTargetBattleType()
    if battleType == BattleType.Building or battleType == BattleType.Road or battleType == BattleType.City then
      return roundItem:GetBuildingName(isMySide)
    end
  end
  for _, roundItem in pairs(self._fightRoundList) do
    local battleType = isMySide and roundItem:GetSelfBattleType() or roundItem:GetTargetBattleType()
    if battleType == BattleType.Turret then
      return roundItem:GetBuildingName(isMySide)
    end
  end
end

function MailBattleReport:GetBuildingName_ForShare(isMySide)
  for _, roundItem in pairs(self._fightRoundList) do
    local battleType = isMySide and roundItem:GetSelfBattleType() or roundItem:GetTargetBattleType()
    if battleType == BattleType.Building or battleType == BattleType.Road or battleType == BattleType.City then
      return roundItem:GetBuildingName_ForShare(isMySide)
    end
  end
  for _, roundItem in pairs(self._fightRoundList) do
    local battleType = isMySide and roundItem:GetSelfBattleType() or roundItem:GetTargetBattleType()
    if battleType == BattleType.Turret then
      return roundItem:GetBuildingName_ForShare(isMySide)
    end
  end
end

function MailBattleReport:GetTargetName()
  local name = "???"
  local target
  if self.isAttack and self.player[2] then
    target = self.player[2]
  elseif self.isDefend and self.player[1] then
    target = self.player[1]
  elseif self.player[2] then
    target = self.player[2]
  end
  if target then
    if MailBattleParseHelper.IsWerewolf(target) then
      name = Localization:GetString(GameDialogDefine.WEREWOLF)
    else
      name = target.name
    end
  end
  if self.level then
    local level = Localization:GetString(GameDialogDefine.LEVEL_NUMBER, self.level)
    name = level .. " " .. name
  end
  return name
end

function MailBattleReport:GetTargetPlayer()
  if self.isAttack and self.player[2] then
    return self.player[2]
  elseif self.isDefend and self.player[1] then
    return self.player[1]
  end
  return self.player[2]
end

function MailBattleReport:GetTargetName_ForShare()
  local playerName, monsterName
  for _, roundItem in pairs(self._fightRoundList) do
    if roundItem:GetTargetBattleType() == BattleType.Monster or roundItem:GetTargetBattleType() == BattleType.Boss or roundItem:GetTargetBattleType() == BattleType.Explore or roundItem:GetTargetBattleType() == BattleType.PVE_MONSTER or roundItem:GetTargetBattleType() == BattleType.ALLIANCE_OCCUPIED_CITY then
      monsterName = roundItem:GetTargetName_ForShare()
      if roundItem:GetTargetBattleType() == BattleType.ALLIANCE_OCCUPIED_CITY and monsterName ~= nil then
        return monsterName
      end
    else
      playerName = roundItem:GetTargetName_ForShare()
      break
    end
  end
  if playerName == nil then
    return monsterName
  else
    return playerName
  end
end

function MailBattleReport:GetTotalItemReward()
  local rewardList = {}
  for _, oneFight in pairs(self._fightRoundList) do
    local rewardItemArr = oneFight:GetRewardItemArr()
    for itemId, itemCnt in pairs(rewardItemArr) do
      rewardList[itemId] = rewardList[itemId] and rewardList[itemId] + itemCnt or itemCnt
    end
  end
  return rewardList
end

function MailBattleReport:GetBattleWin()
  return self.selfWin
end

function MailBattleReport:GetBattleAttack()
  return self.isAttack
end

function MailBattleReport:GetBattleResultStatus()
  if self.selfWin then
    return FightResult.SELF_WIN
  else
    return FightResult.OTHER_WIN
  end
end

function MailBattleReport:IsMyAttackCity()
  return self.isAttack
end

function MailBattleReport:IsExistMonsterBattle()
  for _, roundItem in pairs(self._fightRoundList) do
    local tBattleType = roundItem:GetTargetBattleType()
    if tBattleType == BattleType.Monster or tBattleType == BattleType.Explore then
      return true
    end
  end
  return false
end

function MailBattleReport:IsMyProtectCity()
  return self.isDefend
end

function MailBattleReport:IsAssistanceProtectedCity()
  return self.assistanceProtectedCity
end

function MailBattleReport:GetHeroExpAddInfo()
  local totalRewardExpArr = {}
  for _, roundItem in pairs(self._fightRoundList) do
    local rewardExpArr = roundItem:GetRewardExpArr()
    for _, rewardExp in pairs(rewardExpArr) do
      local heroUuid = rewardExp.heroId
      if totalRewardExpArr[heroUuid] == nil then
        totalRewardExpArr[heroUuid] = DeepCopy(rewardExp)
      else
        totalRewardExpArr[heroUuid].nowExp = rewardExp.nowExp
        totalRewardExpArr[heroUuid].expAdd = rewardExpArr[heroUuid].expAdd + rewardExp.expAdd
      end
    end
  end
  for heroId, rewardExp in pairs(totalRewardExpArr) do
    local oldLevel = self:GetHeroBeforeFightLevel(heroId)
    rewardExp.oldLevel = oldLevel
  end
  return totalRewardExpArr
end

function MailBattleReport:GetHeroBeforeFightLevel(heroId)
  if #self._fightRoundList > 0 then
    local _selfUid = LuaEntry.Player.uid
    local firstHeroList = self._fightRoundList[1]:GetPlayerHeroes(true, _selfUid, true)
    return firstHeroList[heroId] and firstHeroList[heroId].heroLevel or 0
  end
  return 0
end

function MailBattleReport:GetHeroLastFightLevel(heroId)
  if #self._fightRoundList > 0 then
    local _selfUid = LuaEntry.Player.uid
    local firstHeroList = self._fightRoundList[1]:GetPlayerHeroes(true, _selfUid, false)
    return firstHeroList[heroId] and firstHeroList[heroId].heroLevel or 0
  end
  return 0
end

function MailBattleReport:GetTotalRoundCnt()
  return table.count(self.showRoundList)
end

function MailBattleReport:CheckIfNeedExchange()
  return self.needExchangeInfo
end

function MailBattleReport:SortRound()
  if table.count(self.showRoundList) > 1 and (self.mailType == nil or self.mailType ~= MailType.ELITE_FIGHT_MAIL) then
    table.sort(self.showRoundList, function(a, b)
      local leftType = BattleType.None
      local rightType = BattleType.None
      local leftSpecialType = SpecialUnitType.NONE
      local rightSpecialType = SpecialUnitType.NONE
      local leftOneRoundData = self:GetFightReportByRoundIndex(a.roundIndex)
      local rightOneRoundData = self:GetFightReportByRoundIndex(b.roundIndex)
      if leftOneRoundData ~= nil then
        local leftData = leftOneRoundData:GetMemberPlayerInfoByUuid(a.leftUuid, a.rightUuid, true)
        local rightData = leftOneRoundData:GetMemberPlayerInfoByUuid(a.rightUuid, a.leftUuid, false)
        if leftData.battleType == BattleType.Turret or rightData.battleType == BattleType.Turret then
          leftType = BattleType.Turret
        end
        if leftData.specialType == SpecialUnitType.BUILDING_STATION or rightData.specialType == SpecialUnitType.BUILDING_STATION then
          leftSpecialType = SpecialUnitType.BUILDING_STATION
        end
      end
      if rightOneRoundData ~= nil then
        local leftData = rightOneRoundData:GetMemberPlayerInfoByUuid(b.leftUuid, b.rightUuid, true)
        local rightData = rightOneRoundData:GetMemberPlayerInfoByUuid(b.rightUuid, b.leftUuid, false)
        if leftData.battleType == BattleType.Turret or rightData.battleType == BattleType.Turret then
          rightType = BattleType.Turret
        end
        if leftData.specialType == SpecialUnitType.BUILDING_STATION or rightData.specialType == SpecialUnitType.BUILDING_STATION then
          rightSpecialType = SpecialUnitType.BUILDING_STATION
        end
      end
      if leftType ~= rightType and rightType == BattleType.Turret then
        return true
      elseif leftType ~= rightType and leftType == BattleType.Turret then
        return false
      end
      if leftSpecialType ~= rightSpecialType and rightSpecialType == SpecialUnitType.BUILDING_STATION then
        return true
      end
      return false
    end)
  end
end

function MailBattleReport:GetShowRoundListDataByIndex(index)
  if index < 1 or index > table.count(self.showRoundList) then
    return nil
  end
  local tempData = self.showRoundList[index]
  if tempData ~= nil then
    local oneRoundData = self:GetFightReportByRoundIndex(tempData.roundIndex)
    if oneRoundData ~= nil then
      local oneData = {}
      oneData.roundUuid = oneRoundData:GetCurRoundUuid()
      oneData._roundIndex = tempData.roundIndex
      oneData.fightResult = oneRoundData.fightResult
      oneData.leftUuid = tempData.leftUuid
      oneData.rightUuid = tempData.rightUuid
      local leftData = oneRoundData:GetMemberPlayerInfoByUuid(tempData.leftUuid, tempData.rightUuid, true)
      local rightData = oneRoundData:GetMemberPlayerInfoByUuid(tempData.rightUuid, tempData.leftUuid, false)
      oneData.leftData = leftData
      oneData.rightData = rightData
      oneData.leftHurt = 0
      oneData.rightHurt = 0
      if leftData.unitData ~= nil and leftData.afterUnitData ~= nil and leftData.damagePercent ~= nil then
        local leftDead = leftData.unitData:GetAttTotalCnt(eMailSoldierAttr.Dead)
        local leftWounded = leftData.unitData:GetAttTotalCnt(eMailSoldierAttr.Wounded)
        local leftInjured = leftData.unitData:GetAttTotalCnt(eMailSoldierAttr.Injured)
        local leftCure = leftData.unitData:GetAttTotalCnt(eMailSoldierAttr.Cure)
        local leftAfterDead = leftData.afterUnitData:GetAttTotalCnt(eMailSoldierAttr.Dead)
        local leftAfterWounded = leftData.afterUnitData:GetAttTotalCnt(eMailSoldierAttr.Wounded)
        local leftAfterInjured = leftData.afterUnitData:GetAttTotalCnt(eMailSoldierAttr.Injured)
        local leftAfterCure = leftData.afterUnitData:GetAttTotalCnt(eMailSoldierAttr.Cure)
        local leftDeadPercent = leftData.damagePercent.deadPercent
        local leftWoundedPercent = leftData.damagePercent.woundedPercent
        local leftInjuredPercent = leftData.damagePercent.injuredPercent
        oneData.rightHurt = (leftAfterDead - leftDead) * leftDeadPercent + (leftAfterInjured - leftInjured) * leftInjuredPercent + (leftAfterWounded - leftWounded + leftAfterCure - leftCure) * leftWoundedPercent
      end
      if rightData.unitData ~= nil and rightData.afterUnitData ~= nil and rightData.damagePercent ~= nil then
        local rightDead = rightData.unitData:GetAttTotalCnt(eMailSoldierAttr.Dead)
        local rightWounded = rightData.unitData:GetAttTotalCnt(eMailSoldierAttr.Wounded)
        local rightInjured = rightData.unitData:GetAttTotalCnt(eMailSoldierAttr.Injured)
        local rightCure = rightData.unitData:GetAttTotalCnt(eMailSoldierAttr.Cure)
        local rightAfterDead = rightData.afterUnitData:GetAttTotalCnt(eMailSoldierAttr.Dead)
        local rightAfterWounded = rightData.afterUnitData:GetAttTotalCnt(eMailSoldierAttr.Wounded)
        local rightAfterInjured = rightData.afterUnitData:GetAttTotalCnt(eMailSoldierAttr.Injured)
        local rightAfterCure = rightData.afterUnitData:GetAttTotalCnt(eMailSoldierAttr.Cure)
        local rightDeadPercent = rightData.damagePercent.deadPercent
        local rightWoundedPercent = rightData.damagePercent.woundedPercent
        local rightInjuredPercent = rightData.damagePercent.injuredPercent
        oneData.leftHurt = (rightAfterDead - rightDead) * rightDeadPercent + (rightAfterInjured - rightInjured) * rightInjuredPercent + (rightAfterWounded - rightWounded + rightAfterCure - rightCure) * rightWoundedPercent
      end
      return oneData
    end
  end
end

function MailBattleReport:GetFightReportByRoundIndex(index)
  if index < 1 or index > table.count(self._fightRoundList) then
    return nil
  end
  return self._fightRoundList[index]
end

function MailBattleReport:IsOnlyMonsterBattle()
  for _, roundInfo in pairs(self._fightRoundList) do
    local targetBattleType = roundInfo:GetTargetBattleType()
    local selfBattleType = roundInfo:GetSelfBattleType()
    if targetBattleType ~= BattleType.Monster and targetBattleType ~= BattleType.Boss or selfBattleType ~= BattleType.Formation then
      return false
    end
  end
  return true
end

function MailBattleReport:GetCanRePlay()
  local canShow = false
  if table.count(self._fightRoundList) == 1 and self:GetTotalRoundCnt() == 1 then
    local roundInfo = self._fightRoundList[1]
    if roundInfo ~= nil then
      local targetBattleType = roundInfo:GetTargetBattleType()
      local selfBattleType = roundInfo:GetSelfBattleType()
      if (targetBattleType == BattleType.Monster or targetBattleType == BattleType.Formation) and selfBattleType == BattleType.Formation then
        canShow = true
      elseif targetBattleType == BattleType.ELITE_FIGHT_MAIL and targetBattleType == BattleType.ELITE_FIGHT_MAIL then
        canShow = true
      elseif targetBattleType == BattleType.PVE_MARCH or selfBattleType == BattleType.PVE_MARCH then
        canShow = true
      end
    end
  end
  return canShow
end

function MailBattleReport:GetVersion()
  return self.version
end

function MailBattleReport:GetProtoData()
  return self.pb_BattleReport
end

function MailBattleReport:GetEnemyTotalDeath()
  if self.isAttack then
    return self.totalDeath[2]
  elseif self.isDefend then
    return self.totalDeath[1]
  else
    return nil
  end
end

function MailBattleReport:GetMyCamp()
  if self.isAttack then
    return BattleReportCamp.Attacker
  elseif self.isDefend then
    return BattleReportCamp.Defender
  end
  return BattleReportCamp.ThirdParty
end

function MailBattleReport:GetIsPVPBattle()
  return self.battleType == MailBattleReportType.City or self.battleType == MailBattleReportType.THRONE or self.battleType == MailBattleReportType.TRAIN_PVP or self.battleType == MailBattleReportType.TRAIN_PERSON_PVP or self.battleType == MailBattleReportType.CROSS_PVP_BATTLE or self.battleType == MailBattleReportType.CROSS_ALLIANCE_CITY_BATTLE or self.battleType == MailBattleReportType.CROSS_ARENA or self.battleType == MailBattleReportType.THRONE_DEFENSE or self.battleType == MailBattleReportType.CITY_OUTPOST or self.battleType == MailBattleReportType.ROB_STRONGHOLD_BANK
end

function MailBattleReport:GetIsPVEBattle()
  return self.battleType == MailBattleReportType.Jungle or self.battleType == MailBattleReportType.PVE_STAGE or self.battleType == MailBattleReportType.ALLIANCE_BOSS or self.battleType == MailBattleReportType.RUNNING_BOSS_ATTACK_CITY or self.battleType == MailBattleReportType.TRIAL_TOWER or self.battleType == MailBattleReportType.SEASON_DESERT_BATTLE or self.battleType == MailBattleReportType.SEASON_PLAYER_BUILDING_BATTLE or self.battleType == MailBattleReportType.SEASON_AL_BUILDING_BATTLE or self.battleType == MailBattleReportType.ALLIANCE_BUILDING_FURNACE or self.battleType == MailBattleReportType.ALLIANCE_MONSTER_CHALLENGE_KIROV or self.battleType == MailBattleReportType.BLOOD_QUEEN_MONSTER_ATTACK_CITY or self.battleType == MailBattleReportType.ALLIANCE_BOSS_S0
end

function MailBattleReport:GetEffectFromPlayer(playerId)
  local from = PVPBattleSlot.SelfHero1
  local to = PVPBattleSlot.SelfHero5
  if playerId == 2 then
    from = PVPBattleSlot.EnemyHero1
    to = PVPBattleSlot.EnemyHero5
  end
  if self.hero then
    for i = from, to do
      if self.hero[i] then
        return self.hero[i].effect or {}
      end
    end
  end
  return {}
end

function MailBattleReport:GetHelperAdvices(needDetail)
  local hasHelper = not table.IsNullOrEmpty(self.MailBattleReportPVPHelper) or not table.IsNullOrEmpty(self.MailBattleReportPVEHelper)
  if hasHelper then
    local report
    if not table.IsNullOrEmpty(self.MailBattleReportPVPHelper) then
      report = self.MailBattleReportPVPHelper:AnalyseReport(self)
      if needDetail then
        self.MailBattleReportPVPHelper:GenerateDetail(self)
      end
    elseif not table.IsNullOrEmpty(self.MailBattleReportPVEHelper) then
      report = self.MailBattleReportPVEHelper:AnalyseReport(self)
      if needDetail then
        self.MailBattleReportPVEHelper:GenerateDetail(self)
      end
    end
    return report
  end
  return nil
end

function MailBattleReport:IsMyselfInBattle()
  local player1 = self.player[1]
  local player2 = self.player[2]
  local playerUID = LuaEntry.Player:GetUid()
  if player1 and player1.user and player1.user.uid == playerUID and player1.soldierCountBeforeStart and player1.soldierCountBeforeStart > 0 then
    return true
  end
  if player2 and player2.armyType == MailTargetType.SeasonOutpost then
    return true
  end
  if player2 and player2.user and player2.user.uid == playerUID and player2.soldierCountBeforeStart and player2.soldierCountBeforeStart > 0 then
    return true
  end
  return false
end

function MailBattleReport:GetOrCreateSoldierListData(soldierId, soldierEleven, list)
  for _, soldier in ipairs(list) do
    if soldier.soldierId == soldierId then
      if T11Util.IsSuperSoldierById(soldierId) then
        if not soldierEleven then
          Logger.LogError("soldierEleven is nil")
          soldierEleven = {}
          soldierEleven.effects = {
            {
              id = EffectDefine.UNLOCK_T11,
              val = 1
            }
          }
        end
        local type = T11Util.GetSoldierTypeByEffectList(soldierEleven.effects)
        if soldier.soldierElevenType == type then
          return soldier
        end
      else
        return soldier
      end
    end
  end
  local type = soldierEleven and T11Util.GetSoldierTypeByEffectList(soldierEleven.effects) or T11SoldierType.T11NotUnLock
  local level = DataCenter.SoldierDataManager:GetSoldierLevelById(soldierId)
  local soldier = {
    soldierId = soldierId,
    soldierElevenType = type,
    level = level
  }
  table.insert(list, soldier)
  return soldier
end

function MailBattleReport:GetArmyMoraleInfo()
  if self.armyList then
    return self.armyList, self.armyMorales[1] or 0, self.armyMorales[2] or 0, self.soldierTotalCount[1] or 0, self.soldierTotalCount[2] or 0
  end
  local list = {}
  local army1Morale = 0
  local army2Morale = 0
  local soldier1TotalCount = 0
  local soldier2TotalCount = 0
  local moraleEffects = {}
  local effectsStr = LuaEntry.DataConfig:TryGetStr("power_detail_benefit", "k1", "")
  local splitList = string.split(effectsStr, "|")
  for i = 1, #splitList do
    local effectStr = splitList[i]
    local effectId = tonumber(effectStr)
    if effectId then
      moraleEffects[effectId] = true
    end
  end
  local tacticalCardMoraleEffects = {}
  local tacticalCardMoraleEffectsStr = LuaEntry.DataConfig:TryGetStr("power_detail_benefit", "k2", "")
  local splitList = string.split(tacticalCardMoraleEffectsStr, "|")
  for i = 1, #splitList do
    local effectStr = splitList[i]
    local effectId = tonumber(effectStr)
    if effectId then
      tacticalCardMoraleEffects[effectId] = true
    end
  end
  local t11MoraleEffects = {}
  t11MoraleEffects[EffectDefine.LW_Effect_Id_50160] = true
  
  local function GetMoralEffectValue(effectDataDic, effects)
    local effectValue = 0
    if not table.IsNullOrEmpty(effectDataDic) then
      for effectId, _ in pairs(effects) do
        if effectDataDic[effectId] then
          effectValue = checknumber(effectDataDic[effectId]) + effectValue
        end
      end
    end
    return effectValue
  end
  
  local effectData1 = self:GetEffectFromPlayer(1)
  local effectData2 = self:GetEffectFromPlayer(2)
  local moralEffectValue1 = GetMoralEffectValue(effectData1, moraleEffects)
  local moralEffectValue2 = GetMoralEffectValue(effectData2, moraleEffects)
  local cardEffectValue1 = GetMoralEffectValue(effectData1, tacticalCardMoraleEffects)
  local cardEffectValue2 = GetMoralEffectValue(effectData2, tacticalCardMoraleEffects)
  local t11EffectValue1 = GetMoralEffectValue(effectData1, t11MoraleEffects)
  local t11EffectValue2 = GetMoralEffectValue(effectData2, t11MoraleEffects)
  local army1 = self.player[1].soldierBeforeStart or {}
  local army2 = self.player[2].soldierBeforeStart or {}
  local maxLength = math.max(#army1, #army2)
  for i = 1, maxLength do
    for j = 1, 2 do
      local army = j == 1 and army1 or army2
      if army[i] then
        local soldierId = army[i].soldierId
        local soldierEleven = j == 1 and self.player[1].soldierEleven or self.player[2].soldierEleven
        local soldierList = self:GetOrCreateSoldierListData(soldierId, soldierEleven, list)
        local listArmy
        if j == 1 then
          listArmy = soldierList.army1
        else
          listArmy = soldierList.army2
        end
        if not listArmy then
          listArmy = {}
          if j == 1 then
            soldierList.army1 = listArmy
          else
            soldierList.army2 = listArmy
          end
        end
        listArmy.count = army[i].total - army[i].lost
        local t11Morale = j == 1 and t11EffectValue1 or t11EffectValue2
        listArmy.baseMorale = (LocalController:instance():getValue("lw_soldier", soldierId, "level_factor") + t11Morale) * listArmy.count
        listArmy.moraleRatio = j == 1 and moralEffectValue1 or moralEffectValue2
        listArmy.cardMoraleRatio = j == 1 and cardEffectValue1 or cardEffectValue2
        listArmy.morale = listArmy.baseMorale * (1 + listArmy.moraleRatio + listArmy.cardMoraleRatio)
        listArmy.soldierId = soldierId
        listArmy.soldierEleven = soldierEleven
        if j == 1 then
          army1Morale = army1Morale + listArmy.morale
          soldier1TotalCount = soldier1TotalCount + listArmy.count
        else
          army2Morale = army2Morale + listArmy.morale
          soldier2TotalCount = soldier2TotalCount + listArmy.count
        end
      end
    end
  end
  table.sort(list, function(a, b)
    return a.level > b.level
  end)
  self.armyList = list
  self.armyMorales = {army1Morale, army2Morale}
  self.soldierTotalCount = {soldier1TotalCount, soldier2TotalCount}
  return list, army1Morale, army2Morale, soldier1TotalCount, soldier2TotalCount
end

function MailBattleReport:ParseCardMap()
  local leftCardMap = {}
  local rightCardMap = {}
  local player1 = self.player[1]
  local player2 = self.player[2]
  local cards1, cards2
  if player1 and player1.battleCard then
    cards1 = player1.battleCard.cards
  end
  if player2 and player2.battleCard then
    cards2 = player2.battleCard.cards
  end
  for i = 1, #cards1 do
    local card = cards1[i]
    leftCardMap[card.slot] = card
  end
  for i = 1, #cards2 do
    local card = cards2[i]
    rightCardMap[card.slot] = card
  end
  return leftCardMap, rightCardMap
end

function MailBattleReport:IsHasTacticalCard()
  local player1 = self.player[1]
  local player2 = self.player[2]
  local hasCard = false
  local cards1, cards2
  if player1 and player1.battleCard then
    cards1 = player1.battleCard.cards
  end
  if player2 and player2.battleCard then
    cards2 = player2.battleCard.cards
  end
  if cards1 and 0 < #cards1 then
    hasCard = true
  end
  if cards2 and 0 < #cards2 then
    hasCard = true
  end
  return hasCard
end

function MailBattleReport:ParsecCardAttrs(playerId)
  local cardAttrs = {}
  local player = self.player[playerId]
  if not player then
    return cardAttrs
  end
  local cards
  if player.battleCard then
    cards = player.battleCard.cards
  end
  if not cards then
    return cardAttrs
  end
  
  local function AddToAttrMap(effectId, effectValue)
    if not cardAttrs[effectId] then
      cardAttrs[effectId] = effectValue
    else
      cardAttrs[effectId] = cardAttrs[effectId] + effectValue
    end
  end
  
  for i = 1, #cards do
    local card = cards[i]
    local cardId = card.cardId
    local cardLv = card.level
    local cardStar = card.star
    local randomEffects = card.randomEffects
    if randomEffects then
      for j = 1, #randomEffects do
        local effect = randomEffects[j]
        local effectId = effect.id
        local effectValue = effect.val
        AddToAttrMap(effectId, effectValue)
      end
    end
    local attrs = TacticalCardUtil.GetBaseAttrs(cardId, cardLv, cardStar)
    for effectId, effectValue in pairs(attrs) do
      AddToAttrMap(effectId, effectValue)
    end
  end
  return cardAttrs
end

function MailBattleReport:IsHasSoldierEleven()
  local player1 = self.player[1]
  local player2 = self.player[2]
  if not player1 or not player2 then
    return false
  end
  local hasSoldierEleven = false
  local soldierEleven1, soldierEleven2
  if player1.soldierEleven then
    soldierEleven1 = player1.soldierEleven
  end
  if player2.soldierEleven then
    soldierEleven2 = player2.soldierEleven
  end
  local hasSoldierElevenBeforeStart1 = false
  local hasSoldierElevenBeforeStart2 = false
  local soldierElevenBeforeStart1 = player1.soldierBeforeStart
  local soldierElevenBeforeStart2 = player2.soldierBeforeStart
  if soldierElevenBeforeStart1 then
    for _, v in pairs(soldierElevenBeforeStart1) do
      if v and v.soldierId then
        local meta = DataCenter.SoldierDataManager:GetTemplate(v.soldierId)
        if meta then
          if T11Util.IsSuperSoldier(meta.lv, meta.type) then
            hasSoldierElevenBeforeStart1 = true
            break
          elseif T11Util.IsSuperMummySoldier(meta.lv, meta.type) then
            self.fixedSoldierType = SoldierType.Mummy
            hasSoldierElevenBeforeStart1 = true
            break
          end
        end
      end
    end
  end
  if soldierElevenBeforeStart2 then
    for _, v in pairs(soldierElevenBeforeStart2) do
      if v and v.soldierId then
        local meta = DataCenter.SoldierDataManager:GetTemplate(v.soldierId)
        if meta and T11Util.IsSuperSoldier(meta.lv, meta.type) then
          hasSoldierElevenBeforeStart2 = true
          break
        end
      end
    end
  end
  local reachStage1 = soldierEleven1 and soldierEleven1.stage and soldierEleven1.stage > 0
  local reachStage2 = soldierEleven2 and soldierEleven2.stage and soldierEleven2.stage > 0
  local showPlayer1Skill = reachStage1 and hasSoldierElevenBeforeStart1
  local showPlayer2Skill = reachStage2 and hasSoldierElevenBeforeStart2
  hasSoldierEleven = showPlayer1Skill or showPlayer2Skill
  return hasSoldierEleven, showPlayer1Skill, showPlayer2Skill
end

function MailBattleReport:GetMinorInjuryInfo()
  if not self.player[1] or not self.player[2] then
    return {}
  end
  
  local function GetMinorInjuryFromEffects(effects)
    if table.IsNullOrEmpty(effects) then
      return 0
    end
    local value = 0
    for k, v in pairs(effects) do
      if v and v.id == EffectDefine.Minor_Injury_Recovery then
        value = value + v.val
      end
    end
    return value
  end
  
  local t11AttValue = 0
  if self.player[1].soldierEleven then
    local soldierEleven = self.player[1].soldierEleven
    if not table.IsNullOrEmpty(soldierEleven) then
      local soldierEff = soldierEleven.effects
      t11AttValue = t11AttValue + GetMinorInjuryFromEffects(soldierEff)
      local soldierSpecialEff = soldierEleven.specialEffects
      t11AttValue = t11AttValue + GetMinorInjuryFromEffects(soldierSpecialEff)
    end
  end
  local t11DefValue = 0
  if self.player[2].soldierEleven then
    local soldierEleven = self.player[2].soldierEleven
    if not table.IsNullOrEmpty(soldierEleven) then
      local battleCardEff = soldierEleven.effects
      t11DefValue = t11DefValue + GetMinorInjuryFromEffects(battleCardEff)
      local battleCardSkillEffects = soldierEleven.specialEffects
      t11DefValue = t11DefValue + GetMinorInjuryFromEffects(battleCardSkillEffects)
    end
  end
  local result = {}
  result.t11AttValue = t11AttValue
  result.t11DefValue = t11DefValue
  return result
end

return MailBattleReport
