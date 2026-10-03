local MailBattleReportPVPHelper = BaseClass("MailBattleReportPVPHelper")
local MailBattleParseHelper = require("DataCenter.MailData.MailBattleParseHelper")
local BattleHelperEnumtype = require("UI.UILWMail.UILWMailMain.Component.BattleAIHelperComs.BattleHelperEnumtype")
local MailBattleReportHelperUtil = require("DataCenter.MailData.DataExtModule.MailBattleReportHelperUtil")
local ProcessHelper = {}
local ProcessHelperRegisterMap
local DamageType = {Physical = 0, Magic = 1}

function MailBattleReportPVPHelper:__init()
  self.selfHeroLevelBattlePower = 0
  self.selfHeroSkillBattlePower = 0
  self.selfHeroEquipmentBattlePower = 0
  self.selfTechBattlePower = 0
  self.selfSoldierBattlePower = 0
  self.selfTacticalBattlePower = 0
  self.selfHonorWallBattlePower = 0
  self.selfPlayerLevel = 0
  self.selfSoldierMaxLevel = 0
  self.enemyHeroLevelBattlePower = 0
  self.enemyHeroSkillBattlePower = 0
  self.enemyHeroEquipmentBattlePower = 0
  self.enemyTechBattlePower = 0
  self.enemySoldierBattlePower = 0
  self.enemyTacticalBattlePower = 0
  self.enemyHonorWallBattlePower = 0
  self.enemyPlayerLevel = 0
  self.enemySoldierMaxLevel = 0
  self.isSelfAttackCity = 0
  self.isMultiRoundBattle = 0
  self.selfHeroLevelList = {}
  self.selfHeroCampList = {}
  self.selfHeroJobList = {}
  for i = 1, 5 do
    self.selfHeroJobList[i] = 0
  end
  self.enemyHeroLevelList = {}
  self.enemyHeroCampList = {}
  self.selfHeroEquipLevel = 0
  self.enemyHeroEquipLevel = 0
  self.selfUavChipStar = 0
  self.enemyUavChipStar = 0
  self.selfUavChipLevel = 0
  self.enemyUavChipLevel = 0
  self.selfUavEquipLevel = 0
  self.enemyUavEquipLevel = 0
  self.selfUavLevel = 0
  self.enemyUavLevel = 0
  self.enemyStunNum = 0
  self.enemyDpsCrit = 0
  self.enemyDpsType = DamageType.Physical
  self.selfHeroStar = 0
  self.enemyHeroStar = 0
  self.battleTime = 0
  self.isOvertime = false
  self.selfTotalMorale = 0
  self.enemyTotalMorale = 0
  self.selfDominatorTrainInfos = nil
  self.enemyDominatorTrainInfos = nil
  self.selfDominatorMainTrainingGroupId = 0
  self.selfDominatorMainTrainingLevel = 0
  self.enemyDominatorMainTrainingGroupId = 0
  self.enemyDominatorMainTrainingLevel = 0
  self.selfDominator = nil
  self.enemyDominator = nil
  self.selfSkillChips = nil
  self.enemySkillChips = nil
  self.reportResult = nil
  self.initSuccess = false
  self.hasGenerateDetail = false
  self.templateType = 0
end

function MailBattleReportPVPHelper:__delete()
  self.selfHeroLevelBattlePower = nil
  self.selfHeroSkillBattlePower = nil
  self.selfTechBattlePower = nil
  self.selfHeroEquipmentBattlePower = nil
  self.selfSoldierBattlePower = nil
  self.selfTacticalBattlePower = nil
  self.selfHonorWallBattlePower = nil
  self.selfPlayerLevel = nil
  self.selfSoldierMaxLevel = nil
  self.enemyHeroLevelBattlePower = nil
  self.enemyHeroSkillBattlePower = nil
  self.enemyTechBattlePower = nil
  self.enemyHeroEquipmentBattlePower = nil
  self.enemySoldierBattlePower = nil
  self.enemyTacticalBattlePower = nil
  self.enemyHonorWallBattlePower = nil
  self.enemyPlayerLevel = nil
  self.enemySoldierMaxLevel = nil
  self.isSelfAttackCity = nil
  self.isMultiRoundBattle = nil
  self.selfHeroLevelList = nil
  self.selfHeroCampList = nil
  self.selfHeroJobList = nil
  self.enemyHeroLevelList = nil
  self.enemyHeroCampList = nil
  self.selfHeroStar = nil
  self.enemyHeroStar = nil
  self.battleTime = nil
  self.isOvertime = nil
  self.selfTotalMorale = nil
  self.enemyTotalMorale = nil
  self.selfDominatorTrainInfos = nil
  self.enemyDominatorTrainInfos = nil
  self.selfDominatorMainTrainingGroupId = nil
  self.selfDominatorMainTrainingLevel = nil
  self.enemyDominatorMainTrainingGroupId = nil
  self.enemyDominatorMainTrainingLevel = nil
  self.selfDominator = nil
  self.enemyDominator = nil
  self.selfSkillChips = nil
  self.enemySkillChips = nil
  self.reportResult = nil
  self.initSuccess = nil
  self.hasGenerateDetail = nil
  self.templateType = nil
end

function MailBattleReportPVPHelper:Init(battleReport, player, hero, tacticalWeapon, isSolo)
  local battleType = battleReport.battleType
  for k, p in pairs(player) do
    if p.user and p.user.uid == LuaEntry.Player:GetUid() then
      self.isAttack = k == 1
      self.isDefend = k == 2
      self.isSelfAttackCity = self.isAttack and battleType == MailBattleReportType.City and 1 or 0
      self.selfPlayerLevel = p.level
      for k, v in pairs(p.soldierLost) do
        local meta = DataCenter.SoldierDataManager:GetTemplate(v.soldierId)
        self.selfSoldierMaxLevel = math.max(meta.lv, self.selfSoldierMaxLevel)
      end
      if p.progress then
        self.selfTechBattlePower = p.progress.sciencePower or 0
        self.selfHonorWallBattlePower = p.progress.honorPower or 0
        self.selfTacticalBattlePower = p.progress.formationEquipPower or 0
        self.selfSoldierBattlePower = p.soldierPowerBeforeStart or 0
        if p.progress.equipId then
          local equips = p.progress.equipId
          for i = 1, #equips do
            local cfgId = equips[i]
            local equipMeta = DataCenter.CommonEquipTemplateManager:GetTemplate(cfgId)
            if equipMeta then
              self.selfUavEquipLevel = self.selfUavEquipLevel + equipMeta.level
            end
          end
        end
      end
      if p.chipTotalLevel then
        self.selfUavChipLevel = p.chipTotalLevel
      end
    else
      self.enemyPlayerLevel = p.level
      if p.progress then
        self.enemyTechBattlePower = p.progress.sciencePower or 0
        self.enemyHonorWallBattlePower = p.progress.honorPower or 0
        self.enemyTacticalBattlePower = p.progress.formationEquipPower or 0
        self.enemySoldierBattlePower = p.soldierPowerBeforeStart or 0
        if p.progress.equipId then
          local equips = p.progress.equipId
          for i = 1, #equips do
            local cfgId = equips[i]
            local equipMeta = DataCenter.CommonEquipTemplateManager:GetTemplate(cfgId)
            if equipMeta then
              self.enemyUavEquipLevel = self.enemyUavEquipLevel + equipMeta.level
            end
          end
        end
      end
      if p.soldierLost then
        for k, v in pairs(p.soldierLost) do
          local meta = DataCenter.SoldierDataManager:GetTemplate(v.soldierId)
          self.enemySoldierMaxLevel = math.max(meta.lv, self.enemySoldierMaxLevel)
        end
      end
      if p.chipTotalLevel then
        self.enemyUavChipLevel = p.chipTotalLevel
      end
    end
  end
  local mostDamageEnemyHero
  local mostDamage = 0
  for i = 1, ArmyFormationSlot.Hero5 do
    local selfHero, enemyHero
    if self.isAttack then
      selfHero = hero[i]
      enemyHero = hero[i + 5]
    else
      selfHero = hero[i + 5]
      enemyHero = hero[i]
    end
    if selfHero then
      self.selfHeroLevelBattlePower = self.selfHeroLevelBattlePower + (selfHero.effect[HeroEffectDefine.HeroPowerLevel] or 0)
      self.selfHeroSkillBattlePower = self.selfHeroSkillBattlePower + (selfHero.effect[HeroEffectDefine.HeroPowerSkill] or 0)
      self.selfHeroEquipmentBattlePower = self.selfHeroEquipmentBattlePower + (selfHero.effect[HeroEffectDefine.HeroPowerEquip] or 0)
      table.insert(self.selfHeroLevelList, selfHero.heroLevel)
      table.insert(self.selfHeroCampList, selfHero.heroInfo.heroType)
      self.selfHeroJobList[i] = selfHero.heroInfo.heroJob
      self.selfHeroEquipLevel = self.selfHeroEquipLevel + selfHero.weaponLevel
      self.selfHeroStar = self.selfHeroStar + selfHero.heroInfo.rank
    end
    if enemyHero then
      self.enemyHeroLevelBattlePower = self.enemyHeroLevelBattlePower + (enemyHero.effect[HeroEffectDefine.HeroPowerLevel] or 0)
      self.enemyHeroSkillBattlePower = self.enemyHeroSkillBattlePower + (enemyHero.effect[HeroEffectDefine.HeroPowerSkill] or 0)
      self.enemyHeroEquipmentBattlePower = self.enemyHeroEquipmentBattlePower + (enemyHero.effect[HeroEffectDefine.HeroPowerEquip] or 0)
      table.insert(self.enemyHeroLevelList, enemyHero.heroLevel)
      table.insert(self.enemyHeroCampList, enemyHero.heroInfo.heroType)
      self.enemyHeroEquipLevel = self.enemyHeroEquipLevel + enemyHero.weaponLevel
      local stat = enemyHero.stat
      if stat then
        self.enemyStunNum = self.enemyStunNum + (stat.dizzyNum or 0)
        if stat.damage and mostDamage < stat.damage then
          mostDamage = stat.damage
          mostDamageEnemyHero = enemyHero
        end
      end
      self.enemyHeroStar = self.enemyHeroStar + enemyHero.heroInfo.rank
    end
  end
  if mostDamageEnemyHero and mostDamageEnemyHero.stat then
    local enemyStat = mostDamageEnemyHero.stat
    self.enemyDpsCrit = enemyStat.critRate or 0
    if 0 < enemyStat.physicalDamage and enemyStat.magicDamage then
      self.enemyDpsType = enemyStat.physicalDamage > enemyStat.magicDamage and DamageType.Physical or DamageType.Magic
    elseif 0 < enemyStat.physicalDamage then
      self.enemyDpsType = DamageType.Physical
    elseif 0 < enemyStat.magicDamage then
      self.enemyDpsType = DamageType.Magic
    end
  end
  local selfUav, enemyUav
  if tacticalWeapon then
    if self.isAttack then
      selfUav = tacticalWeapon[11]
      enemyUav = tacticalWeapon[12]
    else
      selfUav = tacticalWeapon[12]
      enemyUav = tacticalWeapon[11]
    end
  end
  if selfUav and selfUav.weaponInfo then
    self.selfUavLevel = selfUav.weaponInfo.level
  end
  if enemyUav and enemyUav.weaponInfo then
    self.enemyUavLevel = enemyUav.weaponInfo.level
  end
  if selfUav and selfUav.skillChips then
    for _, chip in pairs(selfUav.skillChips) do
      self.selfUavChipStar = self.selfUavChipStar + chip.star
    end
    self.selfSkillChips = selfUav.skillChips
  end
  if enemyUav and enemyUav.skillChips then
    for _, chip in pairs(enemyUav.skillChips) do
      self.enemyUavChipStar = self.enemyUavChipStar + chip.star
    end
    self.enemySkillChips = enemyUav.skillChips
  end
  local selfProgress = self:GetSelfProgress(battleReport)
  local enemyProgress = self:GetEnemyProgress(battleReport)
  local selfTrainInfo, enemyTrainInfo
  if selfProgress then
    local selfDominatorInfo = selfProgress.dominator
    if selfDominatorInfo then
      selfTrainInfo = selfDominatorInfo.dominatorTrainInfos
    end
  end
  if enemyProgress then
    local enemyDominatorInfo = enemyProgress.dominator
    if enemyDominatorInfo then
      enemyTrainInfo = enemyDominatorInfo.dominatorTrainInfos
    end
  end
  
  local function SetDominatorTrainInfo(trainInfo, isSelf)
    if not table.IsNullOrEmpty(trainInfo) then
      local dominatorTrainInfos = {}
      for _, info in ipairs(trainInfo) do
        local groupId = info.trainId
        local lv = info.level
        local groupTemplate = DataCenter.DominatorTemplateManager:GetTrainGroupTemplateById(groupId)
        if groupTemplate then
          if groupTemplate:IsMainGroup() then
            if isSelf then
              self.selfDominatorMainTrainingGroupId = groupId
              self.selfDominatorMainTrainingLevel = lv
            else
              self.enemyDominatorMainTrainingGroupId = groupId
              self.enemyDominatorMainTrainingLevel = lv
            end
          else
            dominatorTrainInfos[groupId] = lv
          end
        end
      end
      return dominatorTrainInfos
    end
    return nil
  end
  
  self.selfDominatorTrainInfos = SetDominatorTrainInfo(selfTrainInfo, true)
  self.enemyDominatorTrainInfos = SetDominatorTrainInfo(enemyTrainInfo, false)
  local selfDominator, enemyDominator
  if self.isAttack then
    selfDominator = battleReport.hero[PVPBattleSlot.SelfDominator]
    enemyDominator = battleReport.hero[PVPBattleSlot.EnemyDominator]
  else
    selfDominator = battleReport.hero[PVPBattleSlot.EnemyDominator]
    enemyDominator = battleReport.hero[PVPBattleSlot.SelfDominator]
  end
  if selfDominator and selfDominator.heroInfo then
    self.selfDominator = selfDominator.heroInfo
  end
  if enemyDominator and enemyDominator.heroInfo then
    self.enemyDominator = enemyDominator.heroInfo
  end
  self.battleTime = battleReport.battleTime or 0
  local armyList, army1Morale, army2Morale = battleReport:GetArmyMoraleInfo()
  if self.isAttack then
    self.selfTotalMorale = army1Morale
    self.enemyTotalMorale = army2Morale
  else
    self.selfTotalMorale = army2Morale
    self.enemyTotalMorale = army1Morale
  end
  if battleReport.overTime == 2 then
    self.isOvertime = true
  else
    self.isOvertime = false
  end
  self.initSuccess = true
end

local function ProtectCall(fun, ...)
  local ok, ret1, ret2 = xpcall(fun, debug.traceback, ...)
  if not ok then
    Logger.LogError(ret1)
    return ok
  else
    return ok, ret1, ret2
  end
end

function MailBattleReportPVPHelper:PCallFuncHelper(func)
  local success, ret, ret2
  local realFunc = MailBattleReportHelperUtil[func]
  if not realFunc then
    Logger.LogError("MailBattleReportPVPHelper:PCallFuncHelper func not found: " .. func)
    return false
  end
  success, ret, ret2 = ProtectCall(realFunc)
  if success and ret then
    return ret, ret2
  end
end

function MailBattleReportPVPHelper:DoForAllSelfHeroes(mailExtData, func)
  local lowIndex, highIndex = 1, 5
  if self.isAttack == false then
    lowIndex, highIndex = 6, 10
  end
  local heroes = mailExtData.hero
  for i = lowIndex, highIndex do
    local heroInfo = heroes[i]
    if heroInfo then
      func(heroInfo)
    end
  end
end

function MailBattleReportPVPHelper:DoForAllEnemyHeroes(mailExtData, func)
  local lowIndex, highIndex = 6, 10
  if self.isAttack == false then
    lowIndex, highIndex = 1, 5
  end
  local heroes = mailExtData.hero
  for i = lowIndex, highIndex do
    local heroInfo = heroes[i]
    if heroInfo then
      func(heroInfo)
    end
  end
end

function MailBattleReportPVPHelper:GetSelfTacticalWeaponInfo(mailExtData)
  if not mailExtData.weapon then
    return nil
  end
  if self.isAttack then
    return mailExtData.weapon[11]
  else
    return mailExtData.weapon[12]
  end
end

function MailBattleReportPVPHelper:GetSelfProgress(mailExtData)
  if not mailExtData then
    return nil
  end
  if self.isAttack then
    return mailExtData.player[1].progress
  else
    return mailExtData.player[2].progress
  end
end

function MailBattleReportPVPHelper:GetEnemyProgress(mailExtData)
  if not mailExtData then
    return nil
  end
  if self.isAttack then
    return mailExtData.player[2].progress
  else
    return mailExtData.player[1].progress
  end
end

local function ProcessDataNew(self, mailExtData, adviceInfo)
  local id = adviceInfo.id
  local extraInfo = adviceInfo.extraInfo
  local adviceTemplate = DataCenter.BattleReportHelperTemplateManager:GetTemplate(id)
  local mode_type = adviceTemplate.mode_type
  if not BattleHelperEnumtype.Map[mode_type] then
    return
  end
  adviceInfo.displayType = BattleHelperEnumtype.Map[mode_type]
  if extraInfo and extraInfo.selfScore and extraInfo.enemyScore then
    if self.isAttack then
      extraInfo.leftScore = extraInfo.selfScore
      extraInfo.rightScore = extraInfo.enemyScore
    else
      extraInfo.leftScore = extraInfo.enemyScore
      extraInfo.rightScore = extraInfo.selfScore
    end
  end
  if not ProcessHelperRegisterMap then
    ProcessHelperRegisterMap = {}
    for k, v in pairs(ProcessHelper) do
      if BattleHelperEnumtype.Type[k] then
        ProcessHelperRegisterMap[BattleHelperEnumtype.Type[k]] = v
      end
    end
  end
  if ProcessHelperRegisterMap[mode_type] then
    if not extraInfo then
      extraInfo = {}
      adviceInfo.extraInfo = extraInfo
    end
    CommonUtil.ProtectCall(function()
      ProcessHelperRegisterMap[mode_type](self, extraInfo, mailExtData, adviceTemplate)
    end)
  end
end

function MailBattleReportPVPHelper:AnalyseReport(mailExtData)
  if self.reportResult then
    return self.reportResult
  end
  if self.initSuccess then
    self.reportResult = {}
    local allList = {}
    local allTemplates = DataCenter.BattleReportHelperTemplateManager:GetAllTemplate()
    MailBattleReportHelperUtil.SetContext(self, mailExtData)
    if allTemplates then
      for k, v in pairs(allTemplates) do
        if v.type == self.templateType and not string.IsNullOrEmpty(v.score_func) then
          local score, extraInfo = self:PCallFuncHelper(v.score_func)
          if score and 0 < score then
            local oneData = {
              id = v.id,
              score = score,
              extraInfo = extraInfo,
              cate = v.cate,
              template = v
            }
            allList[#allList + 1] = oneData
          end
        end
      end
      table.sort(allList, function(a, b)
        return a.score > b.score
      end)
      if not table.IsNullOrEmpty(allList) then
        local subCateLimitStr = LuaEntry.DataConfig:TryGetStr("report_helper_config", "k1", "")
        local subCateLimits = {}
        if subCateLimitStr then
          local subCateMaxList = string.split(subCateLimitStr, ";")
          for id, max in pairs(subCateMaxList) do
            subCateLimits[tonumber(id)] = tonumber(max)
          end
        end
        local totalLimit = LuaEntry.DataConfig:TryGetNum("report_helper_config", "k2", 1)
        local ret = {}
        local curCount = {}
        for i = 1, #allList do
          local oneData = allList[i]
          local cate = oneData.cate
          if cate and 0 < cate then
            if not curCount[cate] then
              curCount[cate] = 0
            end
            if curCount[cate] < subCateLimits[cate] then
              curCount[cate] = curCount[cate] + 1
              ret[#ret + 1] = oneData
            end
          end
          if totalLimit <= #ret then
            break
          end
        end
        table.sort(ret, function(a, b)
          if a.cate == b.cate then
            if a.score == b.score then
              return a.id < b.id
            else
              return a.score > b.score
            end
          else
            return a.cate < b.cate
          end
        end)
        self.reportResult = ret
      end
    end
    MailBattleReportHelperUtil.ClearContext()
  end
  return self.reportResult or {}
end

function MailBattleReportPVPHelper:GenerateDetail(mailExtData)
  if self.hasGenerateDetail and self.hasGenerateDetail == true then
    return
  end
  if self.reportResult then
    for i = 1, #self.reportResult do
      ProcessDataNew(self, mailExtData, self.reportResult[i])
    end
  end
  self.hasGenerateDetail = true
end

function ProcessHelper.PlayerBaseLevel(reportHelper, adviceExtraInfo, mailExtData, adviceTemplate)
  local buildingLevel = reportHelper.selfPlayerLevel
  local buildingTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(BuildingTypes.FUN_BUILD_MAIN, buildingLevel)
  if buildingTemplate then
    adviceExtraInfo.displayData = {}
    adviceExtraInfo.displayData[1] = {
      type = BattleHelperEnumtype.InfoItemType.CommonResItem,
      info = {
        rewardType = RewardType.GOODS,
        iconName = buildingTemplate:GetBuildIconOutCity(),
        itemColor = ItemColor.ORANGE,
        enableClick = false
      }
    }
  end
  
  function adviceExtraInfo.jumpFunc()
    GoToUtil.GotoCityByBuildId(BuildingTypes.FUN_BUILD_MAIN, WorldTileBtnType.City_Upgrade)
  end
end

function ProcessHelper.HeroLevel(reportHelper, adviceExtraInfo, mailExtData, adviceTemplate)
  local lowestLevelHero
  reportHelper:DoForAllSelfHeroes(mailExtData, function(heroInfo)
    local heroLevel = heroInfo.heroLevel
    if not lowestLevelHero or heroLevel < lowestLevelHero.heroLevel then
      lowestLevelHero = heroInfo
    end
  end)
  if lowestLevelHero then
    adviceExtraInfo.displayData = {}
    adviceExtraInfo.displayData[1] = {
      type = BattleHelperEnumtype.InfoItemType.UIHeroCellSmallConfig,
      info = {
        lowestLevelHero.heroId,
        nil,
        lowestLevelHero.heroLevel,
        lowestLevelHero.rankLv,
        lowestLevelHero.weaponLevel,
        lowestLevelHero.awakenLv,
        lowestLevelHero.heroSkinId
      }
    }
    local hasHero = DataCenter.HeroDataManager:GetHeroByHeroId(lowestLevelHero.heroId) ~= nil
    if hasHero then
      function adviceExtraInfo.jumpFunc()
        local hasHero = DataCenter.HeroDataManager:GetHeroByHeroId(lowestLevelHero.heroId) ~= nil
        
        if hasHero then
          GoToUtil.GoHeroDetails(lowestLevelHero.heroId, HeroDetailGuideArrowType.Upgrade)
        end
      end
    end
  end
end

function ProcessHelper.HeroRank(reportHelper, adviceExtraInfo, mailExtData, adviceTemplate)
  local lowestRankHero
  reportHelper:DoForAllSelfHeroes(mailExtData, function(heroInfo)
    local heroRank = heroInfo.rankLv
    if not lowestRankHero or heroRank < lowestRankHero.rankLv then
      lowestRankHero = heroInfo
    end
  end)
  if lowestRankHero then
    adviceExtraInfo.displayData = {}
    adviceExtraInfo.displayData[1] = {
      type = BattleHelperEnumtype.InfoItemType.UIHeroCellSmallConfig,
      info = {
        lowestRankHero.heroId,
        nil,
        lowestRankHero.heroLevel,
        lowestRankHero.rankLv,
        lowestRankHero.weaponLevel,
        lowestRankHero.awakenLv,
        lowestRankHero.heroSkinId
      }
    }
    local hasHero = DataCenter.HeroDataManager:GetHeroByHeroId(lowestRankHero.heroId) ~= nil
    if hasHero then
      function adviceExtraInfo.jumpFunc()
        local hasHero = DataCenter.HeroDataManager:GetHeroByHeroId(lowestRankHero.heroId) ~= nil
        
        if hasHero then
          GoToUtil.GoHeroDetails(lowestRankHero.heroId, HeroDetailGuideArrowType.Rank)
        end
      end
    end
  end
end

function ProcessHelper.HeroSkill(reportHelper, adviceExtraInfo, mailExtData, adviceTemplate)
  local lowestLevelSkill, lowestLevelSkillHeroId
  reportHelper:DoForAllSelfHeroes(mailExtData, function(heroInfo)
    local skills = heroInfo.heroInfo.skillList
    for _, skill in pairs(skills) do
      if not skill:IsReachGroupMaxLevel() then
        local canShow = skill:GetSlotIndex() <= 3
        if not canShow then
          return
        end
        if not lowestLevelSkill or skill:GetLevel() < lowestLevelSkill.level then
          lowestLevelSkill = skill
          lowestLevelSkillHeroId = heroInfo.heroId
        end
      end
    end
  end)
  if lowestLevelSkill then
    adviceExtraInfo.displayData = {}
    adviceExtraInfo.displayData[1] = {
      type = BattleHelperEnumtype.InfoItemType.HeroSkillItemConfig,
      info = {
        lowestLevelSkill:GetId(),
        lowestLevelSkill:GetLevel(),
        lowestLevelSkill:GetAddMaxLevel(),
        {showStar = false}
      }
    }
    local hasHero = DataCenter.HeroDataManager:GetHeroByHeroId(lowestLevelSkillHeroId) ~= nil
    if hasHero then
      function adviceExtraInfo.jumpFunc()
        local hasHero = DataCenter.HeroDataManager:GetHeroByHeroId(lowestLevelSkillHeroId) ~= nil
        
        if hasHero then
          GoToUtil.GoHeroDetails(lowestLevelSkillHeroId, HeroDetailGuideArrowType.Skill)
        end
      end
    end
  end
end

function ProcessHelper.HeroEquip(reportHelper, adviceExtraInfo, mailExtData, adviceTemplate)
  local lowestEquip, lowestEquipPower, lowestEquipHeroId
  local templateEquipInfo = EquipInfo.New()
  reportHelper:DoForAllSelfHeroes(mailExtData, function(heroInfo)
    local equips = heroInfo.equipInfos
    for _, equip in pairs(equips) do
      templateEquipInfo:CreateFromTemplate(equip.equipId, equip.equipLv, equip.promote)
      if not lowestEquip then
        lowestEquip = equip
        lowestEquipPower = templateEquipInfo.power
        lowestEquipHeroId = heroInfo.heroId
      elseif not templateEquipInfo:IsMaxLevel() or not templateEquipInfo:IsMaxPromoteLevel() then
        local power = templateEquipInfo.power
        if not lowestEquip or power < lowestEquipPower then
          lowestEquip = equip
          lowestEquipPower = power
          lowestEquipHeroId = heroInfo.heroId
        end
      end
    end
  end)
  if lowestEquip then
    adviceExtraInfo.displayData = {}
    adviceExtraInfo.displayData[1] = {
      type = BattleHelperEnumtype.InfoItemType.BaseUIEquipItemConfig,
      info = {
        lowestEquip.equipId,
        nil,
        false,
        true,
        lowestEquip.equipLv,
        lowestEquip.promote
      }
    }
    if not templateEquipInfo:IsMaxLevel() or not templateEquipInfo:IsMaxPromoteLevel() then
      local hasHero = DataCenter.HeroDataManager:GetHeroByHeroId(lowestEquipHeroId) ~= nil
      if hasHero then
        function adviceExtraInfo.jumpFunc()
          local hasHero = DataCenter.HeroDataManager:GetHeroByHeroId(lowestEquipHeroId) ~= nil
          
          if hasHero then
            GoToUtil.GoHeroDetails(lowestEquipHeroId, HeroDetailGuideArrowType.Equip)
          end
        end
      end
    end
  end
end

function ProcessHelper.SoldierLevel(reportHelper, adviceExtraInfo, mailExtData, adviceTemplate)
  adviceExtraInfo.displayData = {}
  local soldierId = DataCenter.SoldierDataManager:GetSoldierIdByLevel(reportHelper.selfSoldierMaxLevel)
  adviceExtraInfo.displayData[1] = {
    type = BattleHelperEnumtype.InfoItemType.CommonResItem,
    info = {
      rewardType = RewardType.RESOURCE_ITEM,
      itemId = soldierId,
      enableClick = false
    }
  }
  
  function adviceExtraInfo.jumpFunc()
    local buildingList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.LW_BUILD_MILITARY_CAMP)
    if not table.IsNullOrEmpty(buildingList) then
      local maxLevel = 0
      local maxLevelBuilding
      for _, building in pairs(buildingList) do
        if maxLevel < building.level then
          maxLevel = building.level
          maxLevelBuilding = building
        end
      end
      if maxLevelBuilding then
        GoToUtil.GotoCityByBuildUuid(maxLevelBuilding.uuid, WorldTileBtnType.Train_Soldier)
      end
    end
  end
  
  if adviceExtraInfo.displayData[1] then
    local iconPath = DataCenter.RewardManager:GetPicByType(tonumber(adviceExtraInfo.displayData[1].info.rewardType), tonumber(adviceExtraInfo.displayData[1].info.itemId))
    if string.IsNullOrEmpty(iconPath) then
      Logger.LogError("SoldierLevel iconPath is nil, mail uuid:" .. mailExtData.uuid)
    end
  end
end

function ProcessHelper.HeroHonor(reportHelper, adviceExtraInfo, mailExtData, adviceTemplate)
  local mostPowerHonorFaction
  local facitonCount = {}
  reportHelper:DoForAllSelfHeroes(mailExtData, function(heroInfo)
    local faction = heroInfo.heroInfo.heroType
    if not facitonCount[faction] then
      facitonCount[faction] = 1
    else
      facitonCount[faction] = facitonCount[faction] + 1
    end
    if not mostPowerHonorFaction then
      mostPowerHonorFaction = faction
    end
  end)
  for k, v in pairs(facitonCount) do
    if v > facitonCount[mostPowerHonorFaction] then
      mostPowerHonorFaction = k
    end
  end
  adviceExtraInfo.displayData = {}
  local iconPath = ""
  local buildingTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(HeroTypeBuilding[mostPowerHonorFaction])
  if buildingTemplate then
    iconPath = buildingTemplate:GetBuildIconOutCity()
  end
  adviceExtraInfo.displayData[1] = {
    type = BattleHelperEnumtype.InfoItemType.CommonResItem,
    info = {
      rewardType = RewardType.GOODS,
      iconName = iconPath,
      itemColor = ItemColor.ORANGE,
      enableClick = false
    }
  }
  
  function adviceExtraInfo.jumpFunc()
    GoToUtil.GotoHeroHonorWall(mostPowerHonorFaction)
  end
end

function ProcessHelper.TacticalWeaponLevel(reportHelper, adviceExtraInfo, mailExtData, adviceTemplate)
  local selfWeaponInfo = reportHelper:GetSelfTacticalWeaponInfo(mailExtData)
  adviceExtraInfo.displayData = {}
  adviceExtraInfo.displayData[1] = {
    type = BattleHelperEnumtype.InfoItemType.TacticalWeaponItemConfig,
    info = {
      selfWeaponInfo.heroId,
      selfWeaponInfo.heroLevel
    }
  }
  local weaponInfo = DataCenter.TacticalWeaponManager:GetFirstWeaponInfo()
  if weaponInfo ~= nil then
    function adviceExtraInfo.jumpFunc()
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWTacticalWeapon, {
        anim = true,
        
        UIMainAnim = UIMainAnimType.AllHide
      }, TacticalWeaponPageType.Basic)
    end
  end
end

function ProcessHelper.TacticalWeaponEquipLevel(reportHelper, adviceExtraInfo, mailExtData, adviceTemplate)
  local selfProgress = reportHelper:GetSelfProgress(mailExtData)
  local lowestEquipId, lowestEquipLevel
  for _, v in pairs(selfProgress.equipId) do
    local equipTemplate = DataCenter.CommonEquipTemplateManager:GetTemplate(v)
    if equipTemplate and (not lowestEquipLevel or lowestEquipLevel > equipTemplate.level) then
      lowestEquipLevel = equipTemplate.level
      lowestEquipId = v
    end
  end
  if lowestEquipId then
    adviceExtraInfo.displayData = {}
    local equipData = CommonEquipInfo.New()
    equipData:UpdateInfo({cfgId = lowestEquipId})
    adviceExtraInfo.displayData[1] = {
      type = BattleHelperEnumtype.InfoItemType.UILWSquadEquipItemConfig,
      info = equipData
    }
    local weaponInfo = DataCenter.TacticalWeaponManager:GetFirstWeaponInfo()
    if weaponInfo ~= nil then
      function adviceExtraInfo.jumpFunc()
        UIManager:GetInstance():OpenWindow(UIWindowNames.UILWTacticalWeapon, {
          anim = true,
          
          UIMainAnim = UIMainAnimType.AllHide
        }, TacticalWeaponPageType.Equip)
      end
    end
  end
end

function ProcessHelper.SkillChipLevel(reportHelper, adviceExtraInfo, mailExtData, adviceTemplate)
  local selfWeapon = reportHelper:GetSelfTacticalWeaponInfo(mailExtData)
  local lowestChipInfo
  for _, v in pairs(selfWeapon.skillChips) do
    if not lowestChipInfo or v:GetLevel() < lowestChipInfo:GetLevel() then
      lowestChipInfo = v
    end
  end
  if lowestChipInfo then
    adviceExtraInfo.displayData = {}
    adviceExtraInfo.displayData[1] = {
      type = BattleHelperEnumtype.InfoItemType.TWSkillChipItemConfig,
      info = {
        lowestChipInfo.id,
        lowestChipInfo:GetLevel(),
        lowestChipInfo.star
      }
    }
    
    function adviceExtraInfo.jumpFunc()
      GoToUtil.GotoTWSkillChipView()
    end
  end
end

function ProcessHelper.SkillChipStar(reportHelper, adviceExtraInfo, mailExtData, adviceTemplate)
  local selfWeapon = reportHelper:GetSelfTacticalWeaponInfo(mailExtData)
  local lowestChipInfo
  for _, v in pairs(selfWeapon.skillChips) do
    if not lowestChipInfo or v.star < lowestChipInfo.star then
      lowestChipInfo = v
    end
  end
  if lowestChipInfo then
    adviceExtraInfo.displayData = {}
    adviceExtraInfo.displayData[1] = {
      type = BattleHelperEnumtype.InfoItemType.TWSkillChipItemConfig,
      info = {
        lowestChipInfo.id,
        lowestChipInfo:GetLevel(),
        lowestChipInfo.star
      }
    }
    
    function adviceExtraInfo.jumpFunc()
      GoToUtil.GotoTWSkillChipView()
    end
  end
end

function ProcessHelper.SciencePower(reportHelper, adviceExtraInfo, mailExtData, adviceTemplate)
  adviceExtraInfo.displayData = {}
  adviceExtraInfo.displayData[1] = {
    type = BattleHelperEnumtype.InfoItemType.CommonResItem,
    info = {
      rewardType = RewardType.GOODS,
      iconName = "Assets/Main/Sprites/UI/LWCommon/Sprite/lyp_zhujiemian_qipao_kejishu.png",
      itemColor = ItemColor.ORANGE,
      enableClick = false
    }
  }
  
  function adviceExtraInfo.jumpFunc()
    GoToUtil.GotoScience(nil, nil, nil, true)
  end
end

function ProcessHelper.HeroUniqueWeapon(reportHelper, adviceExtraInfo, mailExtData, adviceTemplate)
  local lowestUniqueWeaponHero, lowestUniqueWeaponLevel
  reportHelper:DoForAllSelfHeroes(mailExtData, function(heroInfo)
    local weaponLevel = heroInfo.heroInfo.uniqueWeaponLv
    local canShow = 0 < weaponLevel
    canShow = canShow or heroInfo.heroInfo:IsUniqueWeaponShow()
    if not canShow then
      return
    end
    if not lowestUniqueWeaponLevel or weaponLevel < lowestUniqueWeaponLevel then
      lowestUniqueWeaponLevel = weaponLevel
      lowestUniqueWeaponHero = heroInfo
    end
  end)
  if lowestUniqueWeaponHero then
    adviceExtraInfo.displayData = {}
    adviceExtraInfo.displayData[1] = {
      type = BattleHelperEnumtype.InfoItemType.UIHeroCellSmallConfig,
      info = {
        lowestUniqueWeaponHero.heroId,
        nil,
        lowestUniqueWeaponHero.heroLevel,
        lowestUniqueWeaponHero.rankLv,
        lowestUniqueWeaponHero.weaponLevel,
        lowestUniqueWeaponHero.awakenLv,
        lowestUniqueWeaponHero.heroSkinId
      }
    }
    local hasHero = DataCenter.HeroDataManager:GetHeroByHeroId(lowestUniqueWeaponHero.heroId) ~= nil
    local maxLv = lowestUniqueWeaponHero.heroInfo:IsUniqueWeaponMaxLevel()
    if hasHero and not maxLv then
      function adviceExtraInfo.jumpFunc()
        local hasHero = DataCenter.HeroDataManager:GetHeroByHeroId(lowestUniqueWeaponHero.heroId) ~= nil
        
        if hasHero then
          GoToUtil.GoHeroDetails(lowestUniqueWeaponHero.heroId, HeroDetailGuideArrowType.UniqueWeapon)
        end
      end
    end
  end
end

function ProcessHelper.PVEHeroLevel(reportHelper, adviceExtraInfo, mailExtData, adviceTemplate)
  local lowestLevelHero
  reportHelper:DoForAllSelfHeroes(mailExtData, function(heroInfo)
    local heroLevel = heroInfo.heroLevel
    if not lowestLevelHero or heroLevel < lowestLevelHero.heroLevel then
      lowestLevelHero = heroInfo
    end
  end)
  if lowestLevelHero then
    adviceExtraInfo.displayData = {}
    adviceExtraInfo.displayData[1] = {
      type = BattleHelperEnumtype.InfoItemType.UIHeroCellSmallConfig,
      info = {
        lowestLevelHero.heroId,
        nil,
        lowestLevelHero.heroLevel,
        lowestLevelHero.rankLv,
        lowestLevelHero.weaponLevel,
        lowestLevelHero.awakenLv,
        lowestLevelHero.heroSkinId
      }
    }
    adviceExtraInfo.displayData[2] = {
      type = BattleHelperEnumtype.InfoItemType.CommonResItem,
      info = {
        rewardType = RewardType.GOODS,
        itemId = adviceTemplate.typePara[2] or 1001,
        enableClick = false
      }
    }
    adviceExtraInfo.displayData[3] = {
      type = BattleHelperEnumtype.InfoItemType.UIHeroCellSmallConfig,
      info = {
        lowestLevelHero.heroId,
        nil,
        lowestLevelHero.heroLevel + 1,
        lowestLevelHero.rankLv,
        lowestLevelHero.weaponLevel,
        lowestLevelHero.awakenLv,
        lowestLevelHero.heroSkinId
      }
    }
    local hasHero = DataCenter.HeroDataManager:GetHeroByHeroId(lowestLevelHero.heroId) ~= nil
    if hasHero then
      function adviceExtraInfo.jumpFunc()
        local hasHero = DataCenter.HeroDataManager:GetHeroByHeroId(lowestLevelHero.heroId) ~= nil
        
        if hasHero then
          GoToUtil.GoHeroDetails(lowestLevelHero.heroId, HeroDetailGuideArrowType.Upgrade)
        end
      end
    end
  end
end

function ProcessHelper.PVEHeroSkill(reportHelper, adviceExtraInfo, mailExtData, adviceTemplate)
  local lowestLevelSkill, lowestLevelSkillHeroId
  reportHelper:DoForAllSelfHeroes(mailExtData, function(heroInfo)
    local skills = heroInfo.heroInfo.skillList
    for _, skill in pairs(skills) do
      local canShow = skill:GetSlotIndex() <= 3
      if not canShow then
        return
      end
      if not skill:IsReachGroupMaxLevel() and (not lowestLevelSkill or skill:GetLevel() < lowestLevelSkill.level) then
        lowestLevelSkill = skill
        lowestLevelSkillHeroId = heroInfo.heroId
      end
    end
  end)
  if lowestLevelSkill then
    adviceExtraInfo.displayData = {}
    adviceExtraInfo.displayData[1] = {
      type = BattleHelperEnumtype.InfoItemType.HeroSkillItemConfig,
      info = {
        lowestLevelSkill:GetId(),
        lowestLevelSkill:GetLevel(),
        lowestLevelSkill:GetAddMaxLevel(),
        {showStar = false}
      }
    }
    adviceExtraInfo.displayData[2] = {
      type = BattleHelperEnumtype.InfoItemType.CommonResItem,
      info = {
        rewardType = RewardType.GOODS,
        itemId = adviceTemplate.typePara[2] or 1001,
        enableClick = false
      }
    }
    adviceExtraInfo.displayData[3] = {
      type = BattleHelperEnumtype.InfoItemType.HeroSkillItemConfig,
      info = {
        lowestLevelSkill:GetId(),
        lowestLevelSkill:GetLevel() + 1,
        lowestLevelSkill:GetAddMaxLevel(),
        {showStar = false}
      }
    }
    local hasHero = DataCenter.HeroDataManager:GetHeroByHeroId(lowestLevelSkillHeroId) ~= nil
    if hasHero then
      function adviceExtraInfo.jumpFunc()
        local hasHero = DataCenter.HeroDataManager:GetHeroByHeroId(lowestLevelSkillHeroId) ~= nil
        
        if hasHero then
          GoToUtil.GoHeroDetails(lowestLevelSkillHeroId, HeroDetailGuideArrowType.Skill)
        end
      end
    end
  end
end

function ProcessHelper.PVEHeroEquip(reportHelper, adviceExtraInfo, mailExtData, adviceTemplate)
  local lowestEquip, lowestEquipPower, lowestEquipHeroId
  local templateEquipInfo = EquipInfo.New()
  reportHelper:DoForAllSelfHeroes(mailExtData, function(heroInfo)
    local equips = heroInfo.equipInfos
    for _, equip in pairs(equips) do
      templateEquipInfo:CreateFromTemplate(equip.equipId, equip.equipLv, equip.promote)
      if not lowestEquip then
        lowestEquip = equip
        lowestEquipPower = templateEquipInfo.power
        lowestEquipHeroId = heroInfo.heroId
      elseif not templateEquipInfo:IsMaxLevel() or not templateEquipInfo:IsMaxPromoteLevel() then
        local power = templateEquipInfo.power
        if not lowestEquip or power < lowestEquipPower then
          lowestEquip = equip
          lowestEquipPower = power
          lowestEquipHeroId = heroInfo.heroId
        end
      end
    end
  end)
  if lowestEquip then
    adviceExtraInfo.displayData = {}
    templateEquipInfo:CreateFromTemplate(lowestEquip.equipId, lowestEquip.equipLv, lowestEquip.promote)
    adviceExtraInfo.displayData[1] = {
      type = BattleHelperEnumtype.InfoItemType.BaseUIEquipItemConfig,
      info = {
        lowestEquip.equipId,
        nil,
        false,
        true,
        lowestEquip.equipLv,
        lowestEquip.promote
      }
    }
    adviceExtraInfo.displayData[2] = {
      type = BattleHelperEnumtype.InfoItemType.CommonResItem,
      info = {
        rewardType = RewardType.GOODS,
        itemId = adviceTemplate.typePara[2] or 1001,
        enableClick = false
      }
    }
    local equipLv = lowestEquip.equipLv
    local promote = lowestEquip.promote
    if templateEquipInfo:IsMaxLevel() then
      promote = promote + 1
    else
      equipLv = equipLv + 1
    end
    adviceExtraInfo.displayData[3] = {
      type = BattleHelperEnumtype.InfoItemType.BaseUIEquipItemConfig,
      info = {
        lowestEquip.equipId,
        nil,
        false,
        true,
        equipLv,
        promote
      }
    }
    local hasHero = DataCenter.HeroDataManager:GetHeroByHeroId(lowestEquipHeroId) ~= nil
    if hasHero then
      function adviceExtraInfo.jumpFunc()
        local hasHero = DataCenter.HeroDataManager:GetHeroByHeroId(lowestEquipHeroId) ~= nil
        
        if hasHero then
          GoToUtil.GoHeroDetails(lowestEquipHeroId, HeroDetailGuideArrowType.Equip)
        end
      end
    end
  end
end

function ProcessHelper.PVETacticalWeaponLevel(reportHelper, adviceExtraInfo, mailExtData, adviceTemplate)
  local selfWeaponInfo = reportHelper:GetSelfTacticalWeaponInfo(mailExtData)
  if not selfWeaponInfo then
    return
  end
  adviceExtraInfo.displayData = {}
  adviceExtraInfo.displayData[1] = {
    type = BattleHelperEnumtype.InfoItemType.TacticalWeaponItemConfig,
    info = {
      selfWeaponInfo.heroId,
      selfWeaponInfo.heroLevel
    }
  }
  adviceExtraInfo.displayData[2] = {
    type = BattleHelperEnumtype.InfoItemType.CommonResItem,
    info = {
      rewardType = RewardType.GOODS,
      itemId = adviceTemplate.typePara[2] or 1001,
      enableClick = false
    }
  }
  adviceExtraInfo.displayData[3] = {
    type = BattleHelperEnumtype.InfoItemType.TacticalWeaponItemConfig,
    info = {
      selfWeaponInfo.heroId,
      selfWeaponInfo.heroLevel + 1
    }
  }
  local previewWeaponInfo = DataCenter.TacticalWeaponManager:GetFirstWeaponInfo()
  if previewWeaponInfo then
    function adviceExtraInfo.jumpFunc()
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWTacticalWeapon, {
        anim = true,
        
        UIMainAnim = UIMainAnimType.AllHide
      }, TacticalWeaponPageType.Basic)
    end
  end
end

function ProcessHelper.Morale(reportHelper, adviceExtraInfo, mailExtData, adviceTemplate)
  adviceExtraInfo.displayData = {}
  adviceExtraInfo.displayData[1] = {
    type = BattleHelperEnumtype.InfoItemType.CommonResItem,
    info = {
      rewardType = RewardType.GOODS,
      iconName = "Assets/Main/Sprites/UI/UILWScience/zyf_kejitubiao_20.png",
      itemColor = ItemColor.ORANGE,
      enableClick = false
    }
  }
  
  function adviceExtraInfo.jumpFunc()
    GoToUtil.GotoScience(nil, nil, nil, true)
  end
end

function ProcessHelper.DPSHeorRank(reportHelper, adviceExtraInfo, mailExtData, adviceTemplate)
  local highestDPSHero
  local highestDPS = 0
  reportHelper:DoForAllSelfHeroes(mailExtData, function(heroInfo)
    local heroStat = heroInfo.stat
    local damage = heroStat.damage
    if not highestDPSHero or damage > highestDPS then
      highestDPSHero = heroInfo
      highestDPS = damage
    end
  end)
  if highestDPSHero then
    adviceExtraInfo.displayData = {}
    adviceExtraInfo.displayData[1] = {
      type = BattleHelperEnumtype.InfoItemType.UIHeroCellSmallConfig,
      info = {
        highestDPSHero.heroId,
        nil,
        highestDPSHero.heroLevel,
        highestDPSHero.rankLv,
        highestDPSHero.weaponLevel
      }
    }
    local hasHero = DataCenter.HeroDataManager:GetHeroByHeroId(highestDPSHero.heroId) ~= nil
    if hasHero then
      function adviceExtraInfo.jumpFunc()
        local hasHero = DataCenter.HeroDataManager:GetHeroByHeroId(highestDPSHero.heroId) ~= nil
        
        if hasHero then
          GoToUtil.GoHeroDetails(highestDPSHero.heroId, HeroDetailGuideArrowType.Rank)
        end
      end
    end
  end
end

function ProcessHelper.EnemyDPS(reportHelper, adviceExtraInfo, mailExtData, adviceTemplate)
  local highestDPSHero
  local highestDPS = 0
  reportHelper:DoForAllEnemyHeroes(mailExtData, function(heroInfo)
    local heroStat = heroInfo.stat
    local damage = heroStat.damage
    if not highestDPSHero or damage > highestDPS then
      highestDPSHero = heroInfo
      highestDPS = damage
    end
  end)
  if highestDPSHero then
    adviceExtraInfo.displayData = {}
    adviceExtraInfo.displayData[1] = {
      type = BattleHelperEnumtype.InfoItemType.UIHeroCellSmallConfig,
      info = {
        highestDPSHero.heroId,
        nil,
        highestDPSHero.heroLevel,
        highestDPSHero.rankLv,
        highestDPSHero.weaponLevel,
        highestDPSHero.awakenLv,
        highestDPSHero.heroSkinId
      }
    }
  end
end

function ProcessHelper.EnemyStun(reportHelper, adviceExtraInfo, mailExtData, adviceTemplate)
  local highestStunHero
  local highestStunCount = 0
  reportHelper:DoForAllEnemyHeroes(mailExtData, function(heroInfo)
    local heroStat = heroInfo.stat
    local stunCount = heroStat.dizzyNum
    if not highestStunHero or stunCount > highestStunCount then
      highestStunHero = heroInfo
      highestStunCount = stunCount
    end
  end)
  if highestStunHero then
    adviceExtraInfo.displayData = {}
    adviceExtraInfo.displayData[1] = {
      type = BattleHelperEnumtype.InfoItemType.UIHeroCellSmallConfig,
      info = {
        highestStunHero.heroId,
        nil,
        highestStunHero.heroLevel,
        highestStunHero.rankLv,
        highestStunHero.weaponLevel,
        highestStunHero.awakenLv,
        highestStunHero.heroSkinId
      }
    }
  end
end

function ProcessHelper.DominatorTrainLv(reportHelper, adviceExtraInfo, mailExtData, adviceTemplate)
  adviceExtraInfo.displayData = {}
  local selfDominator = reportHelper.selfDominator
  local gotoDominatorId
  if not selfDominator then
    local allDominators = DataCenter.DominatorManager:GetAllInfo()
    if not selfDominator then
      for _, v in pairs(allDominators) do
        selfDominator = v:GetHeroInfo()
        break
      end
    end
  end
  if selfDominator then
    adviceExtraInfo.displayData[1] = {
      type = BattleHelperEnumtype.InfoItemType.UIHeroCellSmallConfig,
      info = {
        selfDominator.heroId,
        nil,
        1,
        selfDominator.rank,
        0
      }
    }
    gotoDominatorId = selfDominator.heroId
  end
  if DataCenter.DominatorManager:IsDominatorFunctionOn() then
    function adviceExtraInfo.jumpFunc()
      DataCenter.DominatorManager:OpenDominatorMain(gotoDominatorId, UILWDominatorMainPageTag.Train)
    end
  end
end

function ProcessHelper.DominatorRank(reportHelper, adviceExtraInfo, mailExtData, adviceTemplate)
  adviceExtraInfo.displayData = {}
  local selfDominator = reportHelper.selfDominator
  if not selfDominator then
    return
  end
  if selfDominator then
    adviceExtraInfo.displayData[1] = {
      type = BattleHelperEnumtype.InfoItemType.UIHeroCellSmallConfig,
      info = {
        selfDominator.heroId,
        nil,
        1,
        selfDominator.rank,
        0
      }
    }
  end
  if DataCenter.DominatorManager:IsDominatorFunctionOn() then
    function adviceExtraInfo.jumpFunc()
      DataCenter.DominatorManager:OpenDominatorMain(toInt(selfDominator.heroId), UILWDominatorMainPageTag.Rank)
    end
  end
end

function ProcessHelper.DominatorMainTrain(reportHelper, adviceExtraInfo, mailExtData, adviceTemplate)
  adviceExtraInfo.displayData = {}
  local selfDominator = reportHelper.selfDominator
  local gotoDominatorId
  if not selfDominator then
    local allDominators = DataCenter.DominatorManager:GetAllInfo()
    if not selfDominator then
      for _, v in pairs(allDominators) do
        selfDominator = v:GetHeroInfo()
        break
      end
    end
  end
  if selfDominator then
    adviceExtraInfo.displayData[1] = {
      type = BattleHelperEnumtype.InfoItemType.DominatorTrainingGrade,
      info = {
        reportHelper.selfDominatorMainTrainingGroupId,
        reportHelper.selfDominatorMainTrainingLevel
      }
    }
    gotoDominatorId = selfDominator.heroId
  end
  if DataCenter.DominatorManager:IsDominatorFunctionOn() then
    function adviceExtraInfo.jumpFunc()
      DataCenter.DominatorManager:OpenDominatorMain(gotoDominatorId, UILWDominatorMainPageTag.Train)
    end
  end
end

function ProcessHelper.SoldierMorale(reportHelper, adviceExtraInfo, mailExtData, adviceTemplate)
  adviceExtraInfo.displayData = {}
  if reportHelper.selfSoldierMaxLevel and reportHelper.selfSoldierMaxLevel > 0 then
    adviceExtraInfo.displayData[1] = {
      type = BattleHelperEnumtype.InfoItemType.CommonResItem,
      info = {
        rewardType = RewardType.RESOURCE_ITEM,
        itemId = DataCenter.SoldierDataManager:GetSoldierIdByLevel(reportHelper.selfSoldierMaxLevel),
        enableClick = false
      }
    }
  end
  local isMasteryOpen = DataCenter.MasteryManager:Enabled()
  local career = DataCenter.MasteryManager:GetCurPlanIndex()
  if isMasteryOpen and career ~= MasteryHome.Battle then
    local masteryData = DataCenter.MasteryManager:GetData()
    if masteryData.home_id ~= MasteryHome.Battle then
      function adviceExtraInfo.jumpFunc()
        UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIMastery, {
          anim = true,
          
          UIMainAnim = UIMainAnimType.AllHide
        })
      end
    end
  end
  if adviceExtraInfo.jumpFunc == nil then
    function adviceExtraInfo.jumpFunc()
      GoToUtil.GotoScience(nil, nil, nil, true)
    end
  end
  if adviceExtraInfo.displayData[1] then
    local iconPath = DataCenter.RewardManager:GetPicByType(tonumber(adviceExtraInfo.displayData[1].info.rewardType), tonumber(adviceExtraInfo.displayData[1].info.itemId))
    if string.IsNullOrEmpty(iconPath) then
      Logger.LogError("SoldierMorale iconPath is nil, mail uuid:" .. mailExtData.uuid)
    end
  end
end

return MailBattleReportPVPHelper
