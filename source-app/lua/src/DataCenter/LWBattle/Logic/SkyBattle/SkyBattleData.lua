local SkyBattleData = BaseClass("SkyBattleData")
local ConstLW = require("Scene.LWBattle.Const")

local function __init(self, id)
  self.hasError = false
  self:InitData(id)
end

local function __delete(self)
end

local function Contains(self, x, z)
  for _, v in pairs(self.bossRect) do
    if x > v.xMin and x < v.xMax and z > v.zMin and z < v.zMax then
      return true
    end
  end
  return false
end

local function InitData(self, stageMetaId)
  self.metaId = stageMetaId
  self.finalId, self.appearanceMap = LuaEntry.Player:GetGrayTestParkourStage(stageMetaId)
  local line = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage_SkyBattle), self.finalId)
  if not line then
    self.hasError = true
    return
  end
  self.meta = line
  self.meta.id = stageMetaId
  local initPos = string.split(line:getValue("birth_point") or "", "|")
  self.initPosX = tonumber(initPos[1])
  self.initPosY = tonumber(initPos[2])
  self.endLine = line:getValue("boss_line")
  local boss_area_str = line:getValue("boss_area")
  boss_area_str = string.split(boss_area_str, ";")
  self.bossRect = {}
  for _, v in pairs(boss_area_str) do
    local rect = {}
    local boss_area_param = string.split(v, "|")
    rect.xMin = BARRAGE_SCENE_CENTER - tonumber(boss_area_param[2]) * 0.5
    rect.xMax = BARRAGE_SCENE_CENTER + tonumber(boss_area_param[2]) * 0.5
    rect.zMin = tonumber(boss_area_param[1])
    rect.zMax = tonumber(boss_area_param[1]) + tonumber(boss_area_param[3])
    table.insert(self.bossRect, rect)
  end
  self.moveSpeedX = line:getValue("speed_x")
  self.moveSpeedZ = line:getValue("speed_z")
  self.moveDeltaMulti = 1
  self.sceneSpeedZ = line:getValue("speed_scene") or self.moveSpeedZ
  self.sceneCfgArr = {}
  local sceneIdArray = string.split(line:getValue("scene") or "", ",")
  local offset = 0
  if sceneIdArray and 0 < #sceneIdArray then
    local sceneMeta = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.LW_Scene), sceneIdArray[1])
    offset = -1 * sceneMeta.scene_size
  end
  for _, sceneId in ipairs(sceneIdArray) do
    local sceneMeta = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.LW_Scene), sceneId)
    local sceneCfg = {}
    sceneCfg.meta = sceneMeta
    sceneCfg.offset = offset
    sceneCfg.isDeco = false
    sceneCfg.hasAnim = sceneMeta.animation == "1"
    table.insert(self.sceneCfgArr, sceneCfg)
    offset = offset + sceneMeta.scene_size
  end
  self.sceneEffectCfgArr = {}
  local sceneEffectArray = line:getValue("scene_effect") or {}
  local sceneEffectOffset = 0
  for _, sceneEffectId in ipairs(sceneEffectArray) do
    local sceneEffectMeta = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.LW_Scene_Effect), sceneEffectId)
    local sceneEffectCfg = {}
    sceneEffectCfg.meta = sceneEffectMeta
    sceneEffectCfg.offset = sceneEffectOffset
    table.insert(self.sceneEffectCfgArr, sceneEffectCfg)
    sceneEffectOffset = sceneEffectOffset + sceneEffectMeta.scene_size
  end
  self.winCondition = self:GetWinConditionByCfg(self.meta.win_condition)
  local bossControlValue = line:getValue("boss_control")
  self.teamBossControlState = ConstLW.ParkourTeamBossControlState.AllDirection
  if bossControlValue == 2 then
    self.teamBossControlState = ConstLW.ParkourTeamBossControlState.Horizontal
  elseif bossControlValue == 1 then
    self.teamBossControlState = ConstLW.ParkourTeamBossControlState.Stay
  end
  self.showStatistic = line:getValue("end_type") == "1"
  self.battleType = line:getValue("type")
  self.title = line:getValue("title")
  self.target = line:getValue("target")
  self.hideTitle = line:getValue("if_title") == "1"
  local special_pos = line:getValue("special_pos")
  if not string.IsNullOrEmpty(special_pos) then
    local specialPosArray = string.split(special_pos, "|")
    self.specialPos = {}
    for i = 1, #specialPosArray do
      table.insert(self.specialPos, tonumber(specialPosArray[i]))
    end
  end
  local circle_pos = line:getValue("circle_pos")
  if not string.IsNullOrEmpty(circle_pos) then
    local circlePosArray = string.split(circle_pos, ";")
    self.circlePos = {}
    for i = 1, #circlePosArray do
      local str = circlePosArray[i]
      if not string.IsNullOrEmpty(str) then
        local array = string.split(str, "|")
        if #array == 2 then
          local radius = tonumber(array[1]) or 0
          local count = tonumber(array[2]) or 0
          if 0 < count then
            table.insert(self.circlePos, {radius = radius, count = count})
          end
        end
      end
    end
  end
  local special_circle_pos = line:getValue("special_circle_pos")
  if not string.IsNullOrEmpty(special_circle_pos) then
    local specialCirclePosArray = string.split(special_circle_pos, ";")
    self.specialCirclePos = {}
    for i = 1, #specialCirclePosArray do
      local str = specialCirclePosArray[i]
      if not string.IsNullOrEmpty(str) then
        local array = string.split(str, "|")
        if #array == 2 then
          local x = tonumber(array[1]) or 0
          local y = tonumber(array[2]) or 0
          if i <= 5 or 0 < y then
            table.insert(self.specialCirclePos, {x = x, y = y})
          end
        end
      end
    end
  end
  self.showEnergy = line:getValue("energy_show") == "1"
  self.cameraParams = line:getValue("camera_params")
  self.isBlock = line:getValue("is_block") == "1"
  local hideDamage = tonumber(line:getValue("is_hide_damage")) or 0
  self.hideDamage = hideDamage == 1
  self.expect_num = tonumber(line:getValue("expect_num")) or 1
  self.sceneExt = line:getValue("sceneExt")
  local cameraMoveRange = line:getValue("camera_move_range")
  if not string.IsNullOrEmpty(cameraMoveRange) then
    local cmoveRangeStrs = string.split(cameraMoveRange, "|")
    self.cameraLeftBoderX = cmoveRangeStrs[1] and tonumber(cmoveRangeStrs[1])
    self.cameraRightBoderX = cmoveRangeStrs[2] and tonumber(cmoveRangeStrs[2])
  end
  local monsterAttackRange = line:getValue("monster_attack_range")
  if not string.IsNullOrEmpty(monsterAttackRange) then
    self.monsterAttackRange = tonumber(monsterAttackRange) or 0
    self.monsterAttackRangeSquare = self.monsterAttackRange ^ 2
  end
  local soilderMoveRange = line:getValue("soldier_move_range")
  if not string.IsNullOrEmpty(soilderMoveRange) then
    local smoveRangeStrs = string.split(soilderMoveRange, "|")
    self.soliderLeftBoderDeltaX = smoveRangeStrs[1] and tonumber(smoveRangeStrs[1])
    self.soliderRightBoderDeltaX = smoveRangeStrs[2] and tonumber(smoveRangeStrs[2])
  end
  local soilderRushValue = line:getValue("soldier_rush_value")
  if not string.IsNullOrEmpty(soilderRushValue) then
    self.soliderRushValue = tonumber(soilderRushValue)
  end
  local videoRaiseUpFailTimes = line:getValue("failure_times")
  if not string.IsNullOrEmpty(videoRaiseUpFailTimes) then
    self.videoRaiseUpFailTimes = tonumber(videoRaiseUpFailTimes)
  end
  local youtubeLinkURL = line:getValue("youtube_link")
  if not string.IsNullOrEmpty(youtubeLinkURL) then
    self.youtubeLinkURL = youtubeLinkURL
  end
  local suggest_herolv = tonumber(line:getValue("suggest_herolv")) or 0
  self.suggest_herolv = suggest_herolv
  local special_level = tonumber(line:getValue("special_level")) or 0
  self.specialLevel = special_level == 1
  self.failSkipNum = tonumber(line:getValue("fail_skip_num")) or 0
  self.preloadType = tonumber(line:getValue("preload_type")) or 3
  self.preloadAsset = tonumber(line:getValue("preload_id")) or 0
  self.bonusType = nil
  self.bonusWinConditions = nil
  self.bonusExtendData = nil
  local bonus_level = line:getValue("bonus_level")
  if not string.IsNullOrEmpty(bonus_level) then
    local split1 = string.split(bonus_level, ":")
    self.bonusType = tonumber(split1[1])
    self.bonusWinConditions = {}
    for i, v in ipairs(string.split(split1[2], ";")) do
      local winCondition = self:GetWinConditionByCfg(v)
      self.bonusWinConditions[winCondition.winType] = winCondition
    end
    if self.bonusType == ConstLW.ParkourBattleBonusType.ProgressMonster then
      self.bonusExtendData = {}
      local split2 = string.split(split1[3], ";")
      for i, v in ipairs(split2) do
        local data = {}
        local split3 = string.split(v, "|")
        data.progressNum = tonumber(split3[1])
        data.rewardId = tonumber(split3[2])
        table.insert(self.bonusExtendData, data)
      end
    elseif self.bonusType == ConstLW.ParkourBattleBonusType.GoldMonster then
      self.bonusExtendData = {}
      self.bonusExtendData.goldMaxNum = tonumber(line:getValue("coin_limit"))
    elseif self.bonusType == ConstLW.ParkourBattleBonusType.Dash then
      self.bonusExtendData = {}
      self.bonusExtendData.rushStartZ = tonumber(split1[3])
      self.bonusExtendData.stopFireZ = tonumber(split1[4])
      self.bonusExtendData.rushStopZ = tonumber(split1[5])
      self.bonusExtendData.tapTime = tonumber(split1[6])
      local split2 = string.split(split1[7], "|")
      self.bonusExtendData.tapEnergy = tonumber(split2[1])
      self.bonusExtendData.totalEnergy = tonumber(split2[2])
      local split3 = string.split(split1[8], "|")
      self.bonusExtendData.heroToEnemy = tonumber(split3[1])
      self.bonusExtendData.soliderToEnemy = tonumber(split3[2])
      local split4 = string.split(split1[9], "|")
      self.bonusExtendData.rewardData = {}
      for _, v in ipairs(split4) do
        local rewardSp = string.split(v, ";")
        table.insert(self.bonusExtendData.rewardData, {
          tonumber(rewardSp[1]) or 0,
          tonumber(rewardSp[2]) or 1
        })
      end
    end
  end
  self.stageRewardList = nil
  local stage_reward = line:getValue("stage_reward")
  if not string.IsNullOrEmpty(stage_reward) then
    self.stageRewardList = {}
    for i, v in ipairs(string.split(stage_reward, "|")) do
      table.insert(self.stageRewardList, tonumber(v))
    end
  end
  local formationSpecialType = line:getValue("formation_special_type")
  if not string.IsNullOrEmpty(formationSpecialType) then
    self.formationSpecialType = tonumber(formationSpecialType)
  else
    self.formationSpecialType = nil
  end
  self.default_hero_add = tonumber(line:getValue("default_hero_add")) or 0
  local collect_type = line:getValue("collect_type")
  if not string.IsNullOrEmpty(collect_type) then
    local split = string.split(collect_type, "|")
    self.collectType = tonumber(split[1])
    self.collectRewardNum = tonumber(split[2])
  end
  local num_range = line:getValue("num_range")
  if not string.IsNullOrEmpty(num_range) then
    local split = string.split(num_range, "|")
    self.collectMinNum = tonumber(split[1])
    self.collectMaxNum = tonumber(split[2])
  end
  self.useViewBossHpBar = (tonumber(line:getValue("boss_HPbar")) or 0) == 1
  self.bossCameraZoom = tonumber(line:getValue("boss_camera_zoom")) or 30
  self.parkourDoorHeroId = tonumber(line:getValue("parkour_door_hero_id"))
end

function SkyBattleData:GetWinConditionByCfg(cfg)
  local winCondition = {}
  local winParam = string.split(cfg, "|")
  local winType = tonumber(winParam[1])
  winCondition.winType = winType
  if winType == ConstLW.ParkourWinType.KillTargetMonster then
    winCondition.needKillTarget = {}
    local targetIds = string.split(winParam[2], ",")
    local targetNums = string.split(winParam[3] or "1", ",")
    local needValue = 0
    for i = 1, #targetIds do
      local target = {}
      target.id = tonumber(targetIds[i])
      local need = tonumber(targetNums[i])
      target.need = need
      target.finish = 0
      needValue = needValue + need
      winCondition.needKillTarget[target.id] = target
    end
    winCondition.needKillTargetNum = needValue
  elseif winType == ConstLW.ParkourWinType.SaveWorker then
    winCondition.needSaveNum = tonumber(winParam[2])
  elseif winType == ConstLW.ParkourWinType.KillMonster then
    winCondition.needKillNum = tonumber(winParam[2])
  elseif winType == ConstLW.ParkourWinType.KillBoss then
    winCondition.needKillNum = tonumber(winParam[2])
  elseif winType == ConstLW.ParkourWinType.Time then
    winCondition.needTime = tonumber(winParam[2])
  end
  return winCondition
end

function SkyBattleData:GetFormationSaveType()
  if self.formationSpecialType then
    if self.formationSpecialType == ArmyFormationPositionType.OneHero then
      return FormationSaveType.ParkourOneHero
    elseif self.formationSpecialType == ArmyFormationPositionType.TwoHero then
      return FormationSaveType.ParkourTwoHero
    elseif self.formationSpecialType == ArmyFormationPositionType.ThreeHero then
      return FormationSaveType.ParkourThreeHero
    elseif self.formationSpecialType == ArmyFormationPositionType.FourHero then
      return FormationSaveType.ParkourFourHero
    end
  end
  return FormationSaveType.PVESquad
end

function SkyBattleData:GetAppearanceMap()
  return self.appearanceMap
end

SkyBattleData.__init = __init
SkyBattleData.__delete = __delete
SkyBattleData.InitData = InitData
SkyBattleData.Contains = Contains
return SkyBattleData
