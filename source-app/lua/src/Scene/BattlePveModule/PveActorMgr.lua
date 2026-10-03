local Const = require("Scene.BattlePveModule.Const")
local PveActorMgr = BaseClass("PveActorMgr", Singleton)
local MailBattleReport = require("DataCenter.MailData.DataExtModule.MailBattleReport")
local PveReportParseHelper = require("Scene.BattlePveModule.MailDetailParseModule.PveMailDetailReportParseHelper")
local PveModelMgr = require("Scene.BattlePveModule.ModelModule.PveModelMgr")
local PveLineup = require("Scene.BattlePveModule.PveLineup")
local heros = {
  "hero1",
  "hero2",
  "hero3",
  "hero4",
  "hero5"
}
local PveSkillMgr = require("Scene.BattlePveModule.SkillModule.PveSkillMgr")
local Resource = CS.GameEntry.Resource
local EFF_SUMMON_DURATION = 2
local EFF_SUMMON_OFFSET = Vector3.New(0, 3.53, 0)

function PveActorMgr:AddListener(msg_name, callback)
  local function bindFunc(...)
    callback(self, ...)
  end
  
  self.__event_handlers[msg_name] = bindFunc
  EventManager:GetInstance():AddListener(msg_name, bindFunc)
end

function PveActorMgr:RemoveListener(msg_name, callback)
  local bindFunc = self.__event_handlers[msg_name]
  if not bindFunc then
    Logger.LogError(msg_name, " not register")
    return
  end
  self.__event_handlers[msg_name] = nil
  EventManager:GetInstance():RemoveListener(msg_name, bindFunc)
end

function PveActorMgr:GetSpeed()
  return 1.0 / self:GetSpeedOffset()
end

function PveActorMgr:GetSpeedOffset()
  return self.speedOffset
end

function PveActorMgr:SetSpeedOffset(speed)
  Setting:SetPrivateInt(SettingKeys.PVE_SPEED_OFFSET .. LuaEntry.Player.uid, speed)
  self.speedOffset = speed
end

function PveActorMgr:__init()
  self.m_modelMgr = PveModelMgr.New()
  self.m_lineup = PveLineup.New()
  self.__event_handlers = {}
  self.m_skillMgr = PveSkillMgr.New()
  self.m_detailReport = PveReportParseHelper.New()
  self.m_startRoundIdx = 0
  self.m_endRoundIdx = 0
  self.m_skillRoundIdx = 0
  self.m_mailExt = nil
  self.m_curRoundSkill = {}
  self.m_heroes = {}
  self.atkTotalMaxHp = 0
  self.defTotalMaxHp = 0
  self.atkTotalPower = 0
  self.defTotalPower = 0
  self.atkTotalCurPower = 0
  self.defTotalCurPower = 0
  self.totalVirtualArmy = 0
  self.atkHp2PowerRatio = nil
  self.defHp2PowerRatio = nil
  self.tmpAtkPower = {}
  self.stopPlay = false
  self.speedOffset = 0
  self.showSLevelHeroSkill = false
  self.isWaitPlayRound = false
  self.isHeroesBattleInit = false
  self.effReqList = {}
  self.hasResult = false
end

function PveActorMgr:GetCreateModelOK()
  return self.m_modelMgr:GetCreateModelOK()
end

function PveActorMgr:CheckPlayRound()
  if self.isWaitPlayRound == true and self:GetCreateModelOK() then
    self.isWaitPlayRound = false
    self:HeroesBattleInit()
    self:PlayRound()
  end
end

function PveActorMgr:ResetData()
  self.m_startRoundIdx = 0
  self.m_endRoundIdx = 0
  self.m_skillRoundIdx = 0
  self.m_mailExt = nil
  self.m_curRoundSkill = {}
  self.m_heroes = {}
  self.atkTotalMaxHp = 0
  self.defTotalMaxHp = 0
  self.atkTotalPower = 0
  self.defTotalPower = 0
  self.atkTotalCurPower = 0
  self.defTotalCurPower = 0
  self.totalVirtualArmy = 0
  self.atkHp2PowerRatio = nil
  self.defHp2PowerRatio = nil
  self.tmpAtkPower = {}
  self.stopPlay = false
  self.hasResult = false
  self.speedOffset = Setting:GetPrivateInt(SettingKeys.PVE_SPEED_OFFSET .. LuaEntry.Player.uid, 1)
end

function PveActorMgr:ClearMailExt()
  self.m_mailExt = nil
end

function PveActorMgr:ShowUIPVEHeroAppear(heroId, skillId, isOther)
  if self.showSLevelHeroSkill == false then
    self.showSLevelHeroSkill = true
    if isOther == false then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIPVEHeroAppear, heroId, skillId)
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIPVEHeroAppearOther, heroId, skillId)
    end
    return true
  end
  return false
end

function PveActorMgr:ShowSHeroLevelSkill(heroId, skillId, isOther)
  if self.m_lineup ~= nil then
    self.m_lineup:ShowSelfAttackTimeLine(isOther)
  end
end

function PveActorMgr:HideSHeroLevelSkill()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPVEHeroAppear)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPVEHeroAppearOther)
  if self.m_lineup ~= nil then
    self.m_lineup:RemoveTimeLine()
  end
  self.showSLevelHeroSkill = false
end

function PveActorMgr:IsStopPlay()
  return self.stopPlay
end

function PveActorMgr:ForceShowResult()
  self.stopPlay = true
end

function PveActorMgr:GetModelListByCamp(camp)
  return self.m_modelMgr:GetModelListByCamp(camp)
end

function PveActorMgr:SetAllSidePower()
  self.atkHp2PowerRatio = nil
  self.defHp2PowerRatio = nil
  local atkList = self.m_modelMgr:GetModelListByCamp(Const.CampType.Player) or {}
  local defList = self.m_modelMgr:GetModelListByCamp(Const.CampType.Target) or {}
  for _, v in pairs(atkList) do
    self.atkTotalPower = self.atkTotalPower + v:GetHeroPower()
  end
  for _, v in pairs(defList) do
    self.defTotalPower = self.defTotalPower + v:GetHeroPower()
  end
  self.atkTotalPower = Mathf.Floor(self.atkTotalPower)
  self.defTotalPower = Mathf.Floor(self.defTotalPower)
  self.atkTotalCurPower = self.atkTotalPower
  self.defTotalCurPower = self.defTotalPower
end

function PveActorMgr:GetHp2PowerRatio(campType)
  if campType == Const.CampType.Player then
    if self.atkHp2PowerRatio == nil then
      self.atkHp2PowerRatio = self.atkTotalPower / self.atkTotalMaxHp
    end
    return self.atkHp2PowerRatio
  else
    if self.defHp2PowerRatio == nil then
      self.defHp2PowerRatio = self.defTotalPower / self.defTotalMaxHp
    end
    return self.defHp2PowerRatio
  end
end

function PveActorMgr:GetCurScene()
  return CS.SceneManager.World
end

function PveActorMgr:GetBattleResult()
  if self.levelParam ~= nil and self.levelParam.pveEntrance == PveEntrance.BattlePlayBack then
    local result = self.levelParam.battleResult
    if result == true then
      return Const.Result.Win
    else
      return Const.Result.Fail
    end
  end
  if self.m_mailExt == nil then
    return Const.Result.NoWar
  end
  if self.m_mailExt:GetBattleWinInPve() then
    return Const.Result.Win
  else
    return Const.Result.Fail
  end
end

function PveActorMgr:SendBattleCmd()
  local heroes = self:GetHeros()
  if table.count(heroes) == 0 then
    return
  end
  self.m_lineup:HidehHeroSigns()
  local tb = {}
  tb.level = self.m_levelId
  tb.trigger = self.m_triggerId
  tb.heroes = heroes
  tb.armys = self:GetArmys()
  local trigger = DataCenter.BattleLevel:GetTriggerByTriggerId(self.m_triggerId)
  if trigger ~= nil then
    tb.x, tb.y = DataCenter.BattleLevel:GetOnePveDropRewardPosition(trigger:GetPosition())
  end
  SFSNetwork.SendMessage(MsgDefines.GetUserFightPve, tb)
end

function PveActorMgr:SendCaveBattleCmd()
  local heroes = self:GetHeros()
  if table.count(heroes) == 0 then
    return
  end
  self.m_lineup:HidehHeroSigns()
  local mineIndex, formationUuid = DataCenter.MineCaveManager:GetBattleParam()
  local armys = self:GetArmys()
  local powerStr = ""
  local atkList = self.m_modelMgr:GetModelListByCamp(Const.CampType.Player) or {}
  for _, model in pairs(atkList) do
    local _heroId = model:GetHeroId()
    local _power = model:GetHeroPower()
    powerStr = powerStr .. _heroId .. ";" .. _power .. "|"
  end
  SFSNetwork.SendMessage(MsgDefines.BeginPvpCaveFight, mineIndex, formationUuid, heroes, armys, powerStr)
end

function PveActorMgr:SetAdventureArmy()
  local heroes = self:GetHeros()
  if table.count(heroes) == 0 then
    return false
  end
  local army = self:GetArmys()
  DataCenter.AdventureManager:SendSetArmy(heroes, army)
  return true
end

function PveActorMgr:SendArenaSetDefenseArmy()
  local heroes = self:GetHeros()
  if table.count(heroes) == 0 then
    return false
  end
  local atkList = self.m_modelMgr:GetModelListByCamp(Const.CampType.Player) or {}
  local totalPower = 0
  for temp, model in ipairs(atkList) do
    local _power = model:GetHeroPower()
    totalPower = totalPower + _power
  end
  DataCenter.ArenaManager:SendSetDefenseArmy(heroes, totalPower)
  return true
end

function PveActorMgr:SendArenaBattle()
  local heroes = self:GetHeros()
  if table.count(heroes) == 0 then
    return false
  end
  local atkList = self.m_modelMgr:GetModelListByCamp(Const.CampType.Player) or {}
  local totalPower = 0
  for temp, model in ipairs(atkList) do
    local _power = model:GetHeroPower()
    totalPower = totalPower + _power
  end
  local enemyInfo = DataCenter.ArenaManager:GetTargetEnemyInfo()
  local type = enemyInfo.type
  local id = 0
  if type == 0 then
    id = enemyInfo.armyId
  else
    id = enemyInfo.uid
  end
  SFSNetwork.SendMessage(MsgDefines.StartArenaBattle, id, type, heroes, totalPower)
end

function PveActorMgr:SendDiffBattle()
  local heroes = self:GetHeros()
  if table.count(heroes) == 0 then
    return
  end
  self.m_lineup:HidehHeroSigns()
  SFSNetwork.SendMessage(MsgDefines.PveDiffFight, self.m_levelId, self.m_triggerId, heroes, self.m_monsterGroupIndex, self.m_monsterId, self:GetArmys())
end

function PveActorMgr:SendLevelLimitBattle()
  local heroes = self:GetHeros()
  if table.count(heroes) == 0 then
    return
  end
  self.m_lineup:HidehHeroSigns()
  local monsterId = PveUtil.GetRecommendLevelLimitMonsterId()
  SFSNetwork.SendMessage(MsgDefines.PveDiffFight, self.m_levelId, self.m_triggerId, heroes, 1, monsterId, self:GetArmys())
end

function PveActorMgr:SetMonsterDiff(monsterGroupIndex, monsterId)
  self.m_monsterGroupIndex = monsterGroupIndex
  self.m_monsterId = monsterId
  self:ClearMailExt()
end

function PveActorMgr:SetCamera()
  local camera = CS.UnityEngine.Camera.main
  local s = camera:GetComponent(typeof(CS.BitBenderGames.MobileTouchCamera))
  self.oldPos = camera.transform.position
  self.oldRot = camera.transform.rotation
  self.oldEnable = s.enabled
  s.enabled = false
  local angle, newY = 40, 16
  local length = newY / math.tan(angle * math.pi / 180)
  local curTarget = CS.SceneManager.World.CurTarget
  camera.transform.position = Vector3.New(self.oldPos.x, newY, curTarget.z - length)
  camera.transform.rotation = Quaternion.Euler(angle, 0, 0)
end

function PveActorMgr:RestoreCamera()
  local camera = CS.UnityEngine.Camera.main
  local s = camera:GetComponent(typeof(CS.BitBenderGames.MobileTouchCamera))
  s.enabled = self.oldEnable
  camera.transform.position = self.oldPos
  camera.transform.rotation = self.oldRot
end

function PveActorMgr:GetCurMonsterId()
  local trigger = DataCenter.BattleLevel:GetTriggerByTriggerId(self.m_triggerId)
  if trigger:IsTypeMonster() then
    local monsterId = GetTableData(TableName.PVETrigger, self.m_triggerId, "UnclockPara")
    return monsterId
  elseif trigger:IsTypeDiffMonster() or trigger:IsTypeDiffMonsterEasy() then
    return self.m_monsterId
  elseif trigger:IsTypeLevelLimitMonster() then
    return PveUtil.GetRecommendLevelLimitMonsterId()
  elseif trigger:IsTypeAdventureSub() then
    local selectInfo = DataCenter.AdventureManager:GetSelectInfo()
    return tonumber(selectInfo.content)
  end
end

function PveActorMgr:GetLeftHeadParam()
  local headParam = {}
  if self.levelParam ~= nil and self.levelParam.pveEntrance == PveEntrance.BattlePlayBack then
    headParam = self.levelParam.leftHeadParam
  else
    headParam.uid = LuaEntry.Player.uid
    headParam.pic = LuaEntry.Player.pic
    headParam.picVer = LuaEntry.Player.picVer
  end
  return headParam
end

function PveActorMgr:GetRightHeadParam()
  local headParam = {}
  if self.levelParam ~= nil and self.levelParam.pveEntrance == PveEntrance.BattlePlayBack then
    headParam = self.levelParam.rightHeadParam
  else
    local entranceType = DataCenter.BattleLevel:GetEntranceType()
    if entranceType == PveEntrance.MineCave then
      local mineIndex, formationUuid, tempID = DataCenter.MineCaveManager:GetBattleParam()
      local caveInfo = DataCenter.MineCaveManager:GetMineInfo(mineIndex)
      if caveInfo ~= nil and caveInfo.ownerUid ~= nil and caveInfo.ownerUid ~= "" then
        headParam.uid = caveInfo.ownerUid
        headParam.pic = caveInfo.ownerPic
        headParam.picVer = caveInfo.ownerPicVer
      else
        headParam.monsterPic = "Assets/Main/Sprites/HeroIconsSmall/UIPVEorder_img_guai.png"
      end
    elseif entranceType == PveEntrance.ArenaBattle then
      local arenaRankInfo = DataCenter.ArenaManager:GetTargetEnemyInfo()
      if arenaRankInfo ~= nil then
        headParam.uid = arenaRankInfo.uid
        headParam.pic = arenaRankInfo.pic
        headParam.picVer = arenaRankInfo.picVer
      end
    else
      headParam.monsterPic = "Assets/Main/Sprites/HeroIconsSmall/UIPVEorder_img_guai.png"
    end
  end
  return headParam
end

function PveActorMgr:GetCurTrigger()
  return DataCenter.BattleLevel:GetTriggerByTriggerId(self.m_triggerId)
end

function PveActorMgr:GetCameraRotation()
  if self.m_mainCamera == nil then
    self.m_mainCamera = CS.UnityEngine.Camera.main
  end
  return self.m_mainCamera.transform.rotation
end

function PveActorMgr:Enter(battleLevel, battleTilePos, levelId, triggerId, rotation, levelParam)
  self.isHeroesBattleInit = false
  self.m_levelId = levelId
  self.m_triggerId = triggerId
  self.m_battleLevel = battleLevel
  self.m_battleTilePos = battleTilePos
  self.levelParam = levelParam
  self.hasResult = false
  self.m_mailExt = nil
  if self.levelParam ~= nil and self.levelParam.pveEntrance == PveEntrance.BattlePlayBack then
    self:SetArmys(self.levelParam.leftSoliderList)
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPVEScene, {
    anim = true,
    UIMainAnim = UIMainAnimType.AllHide,
    hideTop = true
  }, levelId, triggerId, levelParam)
  self.m_lineup:Init(SceneUtils.TileToWorld(battleTilePos), 1, rotation)
  local guideBgmName = DataCenter.GuideManager:GetGuideBgmName()
  if guideBgmName == nil or guideBgmName == "" then
    DataCenter.LWSoundManager:PlayPveSceneBGMusic()
  end
  self:AddListener(EventId.PVE_Lineup_LoadOK, self.OnLineupLoadOK)
end

function PveActorMgr:EnterBarrage(battleLevel, battleTilePos, levelId, levelParam)
  self.isHeroesBattleInit = false
  self.m_levelId = levelId
  self.m_triggerId = 0
  self.m_battleLevel = battleLevel
  self.levelParam = levelParam
  self.hasResult = false
  self.m_mailExt = nil
  if self.levelParam ~= nil and self.levelParam.pveEntrance == PveEntrance.BattlePlayBack then
    self:SetArmys(self.levelParam.leftSoliderList)
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPVEScene, {
    anim = true,
    UIMainAnim = UIMainAnimType.AllHide,
    hideTop = true
  }, levelId, triggerId, levelParam)
  self.m_lineup:Init(SceneUtils.TileToWorld(battleTilePos), 1, 0)
  local guideBgmName = DataCenter.GuideManager:GetGuideBgmName()
  if guideBgmName == nil or guideBgmName == "" then
    DataCenter.LWSoundManager:PlayPveSceneBGMusic()
  end
end

function PveActorMgr:Enter_Test(levelId, triggerId)
  self.m_levelId = levelId
  self.m_triggerId = triggerId
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPVEScene, {
    anim = true,
    UIMainAnim = UIMainAnimType.AllHide,
    hideTop = true
  }, levelId, triggerId)
  local totalW = Screen.width
  local totalH = Screen.height
  local pos = CS.SceneManager.World:ScreenPointToWorld(Vector3.New(totalW / 2, totalH / 2), 0)
  self.m_lineup:Init(pos, 1)
  self:SetCamera()
  self:AddListener(EventId.PVE_Lineup_LoadOK, self.OnLineupLoadOK)
end

function PveActorMgr:ResetBattle()
  self.levelParam = nil
  DataCenter.BattleLevel:CheckPlaySound()
  if self.m_delayAttack ~= nil then
    self.m_delayAttack:Stop()
    self.m_delayAttack = nil
  end
  if self.m_delayAttack1 ~= nil then
    self.m_delayAttack1:Stop()
    self.m_delayAttack1 = nil
  end
  self:HideSHeroLevelSkill()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPveBattleSoldierList)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPVEScene, {
    anim = true,
    UIMainAnim = UIMainAnimType.AllHide
  })
  if self.hasResult then
    DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.PveEndBattle, tostring(self.m_triggerId))
  end
  self.m_lineup:Destroy()
  self.m_modelMgr:Destroy()
  self:RemoveListener(EventId.PVE_Lineup_LoadOK, self.OnLineupLoadOK)
  self:ResetData()
  for _, req in ipairs(self.effReqList) do
    req:Destroy()
  end
  self.effReqList = {}
  BattleReportUtil.Cancel()
end

function PveActorMgr:Leave()
  self.levelParam = nil
  DataCenter.BattleLevel:CheckPlaySound()
  if self.m_delayAttack ~= nil then
    self.m_delayAttack:Stop()
    self.m_delayAttack = nil
  end
  if self.m_delayAttack1 ~= nil then
    self.m_delayAttack1:Stop()
    self.m_delayAttack1 = nil
  end
  self:HideSHeroLevelSkill()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPveBattleSoldierList)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPVEScene, {
    anim = true,
    UIMainAnim = UIMainAnimType.AllHide
  })
  if self.hasResult then
    DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.PveEndBattle, tostring(self.m_triggerId))
  end
  self.m_lineup:Destroy()
  self.m_modelMgr:Destroy()
  self:RemoveListener(EventId.PVE_Lineup_LoadOK, self.OnLineupLoadOK)
  self.m_battleLevel:LeaveBattle(self.m_triggerId, self:GetBattleResult())
  self:ResetData()
  for _, req in ipairs(self.effReqList) do
    req:Destroy()
  end
  self.effReqList = {}
  BattleReportUtil.Cancel()
end

function PveActorMgr:OnLineupLoadOK()
  if self.levelParam ~= nil and self.levelParam.pveEntrance == PveEntrance.BattlePlayBack then
    self:LodPlackBackTarget()
    self:LodPlackBackSelf()
    TimerManager:GetInstance():DelayInvoke(function()
      PveActorMgr:GetInstance():SendBattlePlayBackCmd()
    end, 1.5)
  else
    self:LoadTarget()
    self:RefreshEnemySigns()
    DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.PveEnterBattle, tostring(self.m_triggerId))
  end
end

function PveActorMgr:IsLineupLoadOK()
  return self.m_lineup:IsLoadOK()
end

function PveActorMgr:SendBattlePlayBackCmd()
end

function PveActorMgr:GetIsInPlayBackPveState()
  if self.levelParam ~= nil and self.levelParam.pveEntrance == PveEntrance.BattlePlayBack then
    return true
  end
  return false
end

function PveActorMgr:LodPlackBackTarget()
  if self.levelParam ~= nil then
    if self.levelParam.rightMonsterId == 0 then
      local enemyHero = self.levelParam.rightHero
      local qualities = {}
      local tempAtkPower = {}
      for i, heroData in pairs(enemyHero) do
        local power = heroData.power or 0
        local heroId = heroData.heroId
        local heroLv = heroData.heroLv
        local heroQuality = heroData.heroQuality
        tempAtkPower[heroId] = power
        local rarity = GetTableData(HeroUtils.GetHeroXmlName(), tonumber(heroId), "rarity")
        qualities[i] = rarity
        self.m_modelMgr:CreateModel(Const.CampType.Target, i, tonumber(heroId), tonumber(power), heroLv, heroQuality, rarity)
        local effPos = self:GetStandPosByIndex(Const.CampType.Target, i) + EFF_SUMMON_OFFSET
        self:CreateEffectObj(UIAssets.PveHeroSummon, effPos, EFF_SUMMON_DURATION)
      end
      local atkList = self.m_modelMgr:GetModelListByCamp(Const.CampType.Target) or {}
      local totalHeroPower = 0
      for _, v in pairs(tempAtkPower) do
        totalHeroPower = totalHeroPower + v
      end
      local realTotalPower = self:GetEmBattleTotalPowerAndHp(false)
      local atkCnt = table.count(tempAtkPower)
      local tmpIndex = 1
      local realHeroPowerList = {}
      local temPower = 0
      for heroId, power in pairs(tempAtkPower) do
        if tmpIndex == atkCnt then
          realHeroPowerList[heroId] = realTotalPower - temPower
        else
          local realPower = Mathf.Floor(power / totalHeroPower * realTotalPower)
          realHeroPowerList[heroId] = realPower
          temPower = temPower + realPower
        end
        tmpIndex = tmpIndex + 1
      end
      for _, model in pairs(atkList) do
        local _heroId = model:GetHeroId()
        local _power = realHeroPowerList[tostring(_heroId)] or 0
        model:SetHeroPower(_power)
      end
      self.m_lineup:RefreshEnemySigns(qualities)
    else
      local monsterId = self.levelParam.rightMonsterId
      local armyId = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.Monster), monsterId, "army")
      armyId = armyId[1] or 0
      local enemyHeros = {}
      local qualities = {}
      for k, v in ipairs(heros) do
        local heroInfo = GetTableData(TableName.Army, armyId, v)
        if not string.IsNullOrEmpty(heroInfo) then
          local t = string.split(heroInfo, ";")
          if table.count(t) >= 3 then
            local oneData = {}
            oneData.heroId = tonumber(t[1])
            oneData.heroLv = tonumber(t[2])
            oneData.heroQuality = tonumber(t[3])
            enemyHeros[#enemyHeros + 1] = oneData
          end
        end
      end
      local pve_power = GetTableData(TableName.Army, armyId, "pve_power")
      local tab_pve_power = string.split(pve_power, "|")
      for i, heroData in pairs(enemyHeros) do
        local power = tab_pve_power[i] or 0
        if power == "" then
          power = 0
        end
        local heroId = heroData.heroId
        local heroLv = heroData.heroLv
        local heroQuality = heroData.heroQuality
        local rarity = GetTableData(HeroUtils.GetHeroXmlName(), tonumber(heroId), "rarity")
        qualities[i] = rarity
        self.m_modelMgr:CreateModel(Const.CampType.Target, i, tonumber(heroId), tonumber(power), heroLv, heroQuality, rarity)
        local effPos = self:GetStandPosByIndex(Const.CampType.Target, i) + EFF_SUMMON_OFFSET
        self:CreateEffectObj(UIAssets.PveHeroSummon, effPos, EFF_SUMMON_DURATION)
      end
      self.m_lineup:RefreshEnemySigns(qualities)
    end
  end
end

function PveActorMgr:LodPlackBackSelf()
  if self.levelParam ~= nil then
    local hero = self.levelParam.leftHero
    local tempAtkPower = {}
    for i, heroData in pairs(hero) do
      local power = heroData.power or 0
      local heroId = heroData.heroId
      local heroLv = heroData.heroLv
      local heroQuality = heroData.heroQuality
      tempAtkPower[heroId] = power
      local rarity = GetTableData(HeroUtils.GetHeroXmlName(), tonumber(heroId), "rarity")
      self.m_modelMgr:CreateModel(Const.CampType.Player, i, tonumber(heroId), tonumber(power), heroLv, heroQuality, rarity)
      local effPos = self:GetStandPosByIndex(Const.CampType.Player, i) + EFF_SUMMON_OFFSET
      self:CreateEffectObj(UIAssets.PveHeroSummon, effPos, EFF_SUMMON_DURATION)
      self.m_lineup:SetHeroSignIcon(i, rarity)
    end
    local atkList = self.m_modelMgr:GetModelListByCamp(Const.CampType.Player) or {}
    local totalHeroPower = 0
    for _, v in pairs(tempAtkPower) do
      totalHeroPower = totalHeroPower + v
    end
    local realTotalPower = self:GetEmBattleTotalPowerAndHp(true)
    local atkCnt = table.count(tempAtkPower)
    local tmpIndex = 1
    local realHeroPowerList = {}
    local temPower = 0
    for heroId, power in pairs(tempAtkPower) do
      if tmpIndex == atkCnt then
        realHeroPowerList[heroId] = realTotalPower - temPower
      else
        local realPower = Mathf.Floor(power / totalHeroPower * realTotalPower)
        realHeroPowerList[heroId] = realPower
        temPower = temPower + realPower
      end
      tmpIndex = tmpIndex + 1
    end
    for _, model in pairs(atkList) do
      local _heroId = model:GetHeroId()
      local _power = realHeroPowerList[tostring(_heroId)] or 0
      model:SetHeroPower(_power)
    end
  end
end

function PveActorMgr:LoadTarget()
  local model = self:GetEnemyHeros()
  local armyId = 0
  local entranceType = DataCenter.BattleLevel:GetEntranceType()
  if entranceType == PveEntrance.MineCave then
    local mineIndex, formationUuid, tempID = DataCenter.MineCaveManager:GetBattleParam()
    armyId = tempID
  else
    armyId = self:GetArmyId()
  end
  local tab_pve_power = {}
  if entranceType == PveEntrance.ArenaBattle then
    tab_pve_power = self:GetArenaDefenseHeroPower()
  else
    local pve_power = GetTableData(TableName.Army, armyId, "pve_power")
    tab_pve_power = string.split(pve_power, "|")
  end
  for i, heroData in pairs(model) do
    local power = tab_pve_power[i] or 0
    local heroId = heroData.heroId
    local heroLv = heroData.heroLv
    local heroQuality = heroData.heroQuality
    local rarity = GetTableData(HeroUtils.GetHeroXmlName(), tonumber(heroId), "rarity")
    self.m_modelMgr:CreateModel(Const.CampType.Target, i, tonumber(heroId), tonumber(power), heroLv, heroQuality, rarity)
    local effPos = self:GetStandPosByIndex(Const.CampType.Target, i) + EFF_SUMMON_OFFSET
    self:CreateEffectObj(UIAssets.PveHeroSummon, effPos, EFF_SUMMON_DURATION)
  end
  local entranceType = DataCenter.BattleLevel:GetEntranceType()
  if entranceType == PveEntrance.MineCave then
    local isTargetPlayer = DataCenter.MineCaveManager:CheckIfEnemyIsPlayer()
    if isTargetPlayer then
      self:ResetTargetHeroPower()
    end
  end
end

function PveActorMgr:GetArenaDefenseHeroPower()
  local arenaRankInfo = DataCenter.ArenaManager:GetTargetEnemyInfo()
  local powerTb = {}
  if arenaRankInfo.type == 0 then
    local armyId = LuaEntry.DataConfig:TryGetStr("arena", "k12")
    local strPower = GetTableData(TableName.Army, armyId, "pve_power")
    local arrPower = string.split(strPower, "|")
    for i, v in ipairs(arrPower) do
      if not string.IsNullOrEmpty(v) then
        table.insert(powerTb, tonumber(v))
      end
    end
  else
    local virtualPowerTb = {}
    local virtualPower = 0
    local heroes = arenaRankInfo.army.heroes
    local totalPower = arenaRankInfo.power
    for i, heroData in ipairs(heroes) do
      local curPower = 0
      local k1 = LuaEntry.DataConfig:TryGetNum("power_setting", "k1")
      local beyondTimes = HeroUtils.GetBeyondTimesByLevel(heroData.heroLevel)
      local curAtk, curDef = HeroUtils.GetHeroAttr(heroData.heroId, heroData.heroQuality, heroData.heroLevel, beyondTimes, 1)
      curPower = Mathf.Round((curAtk + curDef) * k1)
      virtualPower = virtualPower + curPower
      table.insert(virtualPowerTb, curPower)
    end
    for i, v in ipairs(virtualPowerTb) do
      local tempHp = math.modf(v / virtualPower * totalPower)
      table.insert(powerTb, tempHp)
    end
  end
  return powerTb
end

function PveActorMgr:ResetTargetHeroPower()
  local heroPowerDic = DataCenter.MineCaveManager:GetEnemyPlayerPower()
  local atkList = self.m_modelMgr:GetModelListByCamp(Const.CampType.Target) or {}
  for _, model in pairs(atkList) do
    local _heroId = model:GetHeroId()
    local _power = heroPowerDic[tostring(_heroId)] or 99
    model:SetHeroPower(_power)
  end
end

function PveActorMgr:RemoveModelObj(modelType, index, heroId)
  self.tmpAtkPower[tostring(heroId)] = nil
  self.m_modelMgr:RemoveModelObj(modelType, index)
  self:ResetHeroPower()
end

function PveActorMgr:GetModelMgr()
  return self.m_modelMgr
end

function PveActorMgr:GetHealth(mailExt, roundIdx)
  local roundFight = mailExt:GetFightReportByRoundIndex(roundIdx)
  if roundFight == nil then
    return
  end
  local selfHealth = roundFight:GetTroopHealth(true)
  local otherHealth = roundFight:GetTroopHealth(false)
  return selfHealth, otherHealth
end

function PveActorMgr:ParseMailData(battleContent)
  local mailInfo = {}
  mailInfo.battleContent = battleContent
  local ext = MailBattleReport.New()
  ext:ParseContent(mailInfo)
  self.m_mailExt = ext
end

local ReportParseHelper = require("DataCenter.MailData.MailDetailModule.MailDetailReportParseHelper")
local util = require("Common.Tools.cjson.util")
local rapidjson = require("rapidjson")

function PveActorMgr:ParseMailDetail(detailContent)
  local selfHealth, otherHealth = self:GetHealth(self.m_mailExt, 1)
  local tableData1 = PBController.ParsePb1(detailContent, ".protobuf.BattleDetailInfo")
  self.m_detailReport:ParseData(tableData1, selfHealth, otherHealth)
  self.m_startRoundIdx = self.m_detailReport:GetMinIndex()
  self.m_endRoundIdx = self.m_detailReport:GetMaxIndex()
  self:SetAtkTotalMaxHp(selfHealth)
  self:SetDefTotalMaxHp(otherHealth)
end

function PveActorMgr:ParseExpInfo(expContent)
  self.expInfoDict = {}
  if expContent ~= nil then
    local reportReward = PBController.ParsePb1(expContent, "protobuf.ReportReward")
    local exps = reportReward.rewardHeroExps or {}
    for _, expInfo in pairs(exps) do
      self.expInfoDict[expInfo.heroUuid] = expInfo
    end
  end
end

function PveActorMgr:ParseData(battleContent, detailContent, expContent)
  self:ResetData()
  self.m_detailReport:ClearData()
  self:ParseMailData(battleContent)
  self:ParseMailDetail(detailContent)
  self:ParseExpInfo(expContent)
  EventManager:GetInstance():Broadcast(EventId.PveMineCaveInfoUpdate)
  local entranceType = DataCenter.BattleLevel:GetEntranceType()
  if entranceType == PveEntrance.MineCave and not DataCenter.MineCaveManager:CheckIfNeedPreloadEnemy() then
    EventManager:GetInstance():Broadcast(EventId.PVE_Lineup_LoadOK)
    TimerManager:GetInstance():DelayInvoke(function()
      if self:IsLineupLoadOK() and self:GetCreateModelOK() then
        self:HeroesBattleInit()
        self:PlayRound()
      else
        self.isWaitPlayRound = true
      end
    end, 1.5)
  elseif self:IsLineupLoadOK() and self:GetCreateModelOK() then
    self:HeroesBattleInit()
    self:PlayRound()
  else
    self.isWaitPlayRound = true
  end
end

function PveActorMgr:ParsePlayBackData(detailContent)
  self:ResetData()
  local selfHealth = 0
  local otherHealth = 0
  if self.levelParam ~= nil and self.levelParam.pveEntrance == PveEntrance.BattlePlayBack then
    selfHealth = self.levelParam.selfHealth
    otherHealth = self.levelParam.otherHealth
  end
  self.m_detailReport:ClearData()
  local tableData1 = PBController.ParsePb1(detailContent, ".protobuf.BattleDetailInfo")
  self.m_detailReport:ParseData(tableData1, selfHealth, otherHealth)
  self.m_startRoundIdx = self.m_detailReport:GetMinIndex()
  self.m_endRoundIdx = self.m_detailReport:GetMaxIndex()
  self:SetAtkTotalMaxHp(selfHealth)
  self:SetDefTotalMaxHp(otherHealth)
  self:ParseExpInfo()
  EventManager:GetInstance():Broadcast(EventId.PveMineCaveInfoUpdate)
  if self:IsLineupLoadOK() and self:GetCreateModelOK() then
    self:HeroesBattleInit()
    self:PlayRound()
  else
    self.isWaitPlayRound = true
  end
end

function PveActorMgr:SetModelArmyCombatUnit()
  local s_memlist = self.m_mailExt:GetAllMembers(true)
  local t_memlist = self.m_mailExt:GetAllMembers(false)
  self.m_modelMgr:SetModelArmyCombatUnit(s_memlist, t_memlist)
end

function PveActorMgr:SetModelDetailReportPlayerInfo()
  local allMembers = self.m_detailReport:GetPlayerInfo()
  local s_list = {}
  local t_list = {}
  for _, v in pairs(allMembers) do
    if v.isSelf == true then
      s_list[#s_list + 1] = v
    else
      t_list[#t_list + 1] = v
    end
  end
  self.m_modelMgr:SetModelDetailReportPlayerInfo(s_list, t_list)
end

function PveActorMgr:HeroesBattleInit()
  self:SetAllSidePower()
  self:SetHeroHp()
  self.isHeroesBattleInit = true
  self.m_modelMgr:HeroesBattleInit()
end

function PveActorMgr:SetHeroHp()
  self.m_modelMgr:SetHeroHp(self.atkTotalPower, self.defTotalPower)
  local monsterData = DataCenter.BattleLevel:GetMonsterDataByTriggerId(self.m_triggerId)
  if monsterData ~= nil then
    local hpFactor = monsterData.health / monsterData.initHealth
    self.m_modelMgr:SetHeroHpFactor(Const.CampType.Target, hpFactor)
  end
end

function PveActorMgr:GetStandPosByIndex(campType, index)
  if campType == Const.CampType.Player then
    return self.m_lineup:GetMyPosPosition(index)
  else
    return self.m_lineup:GetEnemyPosPosition(index)
  end
end

function PveActorMgr:GetInitPowerByHeroUuid(uuid)
  local curPower = 0
  local heroData = DataCenter.BattleLevel:GetPveHeroData(uuid)
  if heroData ~= nil then
    local k1 = LuaEntry.DataConfig:TryGetNum("power_setting", "k1")
    local beyondTimes = HeroUtils.GetBeyondTimesByLevel(heroData.level)
    local curAtk, curDef = HeroUtils.GetHeroAttr(heroData.heroId, heroData.quality, heroData.level, beyondTimes, heroData.curMilitaryRankId)
    curPower = Mathf.Round((curAtk + curDef) * k1)
    if heroData.skillDict ~= nil then
      for k, v in pairs(heroData.skillDict) do
        if 0 < v.level and heroData:IsSkillUnlock(k) then
          local powerStr = GetTableData(TableName.SkillTab, k, "power")
          local strArr = string.split(powerStr, "|")
          if #strArr >= v.level then
            curPower = curPower + tonumber(strArr[v.level])
          end
        end
      end
    end
  end
  return curPower
end

function PveActorMgr:LoadPlayer(index, heroId, power, heroLv, quality, rarity)
  self.tmpAtkPower[tostring(heroId)] = power
  local enemy = self:GetEnemyHeros()
  local targetLv = 0
  if index <= #enemy then
    local emy = enemy[index]
    if emy ~= nil then
      targetLv = emy.heroLv
    end
  end
  self.m_modelMgr:CreateModel(Const.CampType.Player, index, heroId, power, heroLv, quality, rarity, targetLv)
  local effPos = self:GetStandPosByIndex(Const.CampType.Player, index) + EFF_SUMMON_OFFSET
  self:CreateEffectObj(UIAssets.PveHeroSummon, effPos, EFF_SUMMON_DURATION)
  self:ResetHeroPower()
end

function PveActorMgr:ResetHeroPower()
  local atkList = self.m_modelMgr:GetModelListByCamp(Const.CampType.Player) or {}
  local totalHeroPower = 0
  for _, v in pairs(self.tmpAtkPower) do
    totalHeroPower = totalHeroPower + v
  end
  local realTotalPower = self:GetEmBattleTotalPowerAndHp(true)
  local atkCnt = table.count(self.tmpAtkPower)
  local tmpIndex = 1
  local realHeroPowerList = {}
  local tmpAtkPower = 0
  for heroId, power in pairs(self.tmpAtkPower) do
    if tmpIndex == atkCnt then
      realHeroPowerList[heroId] = realTotalPower - tmpAtkPower
    else
      local power = Mathf.Floor(power / totalHeroPower * realTotalPower)
      realHeroPowerList[heroId] = power
      tmpAtkPower = tmpAtkPower + power
    end
    tmpIndex = tmpIndex + 1
  end
  for _, model in pairs(atkList) do
    local _heroId = model:GetHeroId()
    local _power = realHeroPowerList[tostring(_heroId)] or 0
    model:SetHeroPower(_power)
  end
end

function PveActorMgr:IsFinalRound()
  if self.m_startRoundIdx == 0 then
    return false
  end
  return self.m_startRoundIdx == self.m_endRoundIdx
end

function PveActorMgr:GetHeroesGotExpInBattle()
  if self.m_mailExt == nil then
    return {}
  end
  return self.m_mailExt:GetHeroExpAddInfo()
end

function PveActorMgr:ShowResult()
  self.hasResult = true
  self:HideSHeroLevelSkill()
  EventManager:GetInstance():Broadcast(EventId.PVEBattleSetLeftBuffData)
  EventManager:GetInstance():Broadcast(EventId.PVEBattleSetRightBuffData)
  local battleResult = self:GetBattleResult()
  local _modelMgr = PveActorMgr:GetInstance():GetModelMgr()
  local _targetModelList = battleResult == Const.Result.Win and _modelMgr:GetModelListByCamp(Const.CampType.Target) or _modelMgr:GetModelListByCamp(Const.CampType.Player)
  if _targetModelList ~= nil then
    for _, modelObj in pairs(_targetModelList) do
      modelObj:ShowMuBei()
    end
  end
  local showBtn = false
  local trigger = DataCenter.BattleLevel:GetTriggerByTriggerId(self.m_triggerId)
  if battleResult == Const.Result.Win then
    if trigger:IsTypeDiffMonster() then
      local info = trigger.config.monsterGroupList[self.m_monsterGroupIndex]
      DataCenter.BattleLevel:AddFrontReward(RewardType.HERO_EXP, nil, info.exp)
    elseif trigger:IsTypeDiffMonsterEasy() then
      DataCenter.BattleLevel:AddFrontReward(RewardType.HERO_EXP, nil, trigger.config.exp)
    elseif trigger:IsTypeAdventureSub() then
      DataCenter.AdventureManager:OnBattleWin()
      return
    end
  elseif trigger:IsTypeAdventureSub() then
    showBtn = true
  end
  local exp = self:GetHeroesGotExpInBattle()
  if battleResult == Const.Result.Win and table.count(exp) > 0 then
    TimerManager:GetInstance():DelayInvoke(function()
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIPVEResult, battleResult, {showBtn = showBtn})
    end, 1.5)
    return
  end
  TimerManager:GetInstance():DelayInvoke(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIPVEResult, battleResult, {showBtn = showBtn})
  end, 1)
end

function PveActorMgr:PlayRound()
  if self.m_startRoundIdx > self.m_endRoundIdx then
    self:ShowResult()
    return
  end
  self.m_skillRoundIdx = 1
  self.m_curRoundSkill = {}
  local atkInfo = self.m_detailReport:GetAtkInfoByIndex(self.m_startRoundIdx)
  if atkInfo ~= nil then
    self.m_curRoundSkill = atkInfo[Const.Define.SKILL]
  end
  self:SetBuffStateForUI()
  self:DoAllNormalAttack(function()
    self:PlaySkill()
  end)
end

function PveActorMgr:SetBuffStateForUI()
  local bufflist = self.m_detailReport:GetBuffListByRoundIndex(self.m_startRoundIdx)
  local leftBuff = {}
  local rightBuff = {}
  for _, v in pairs(bufflist) do
    local t_index = v:GetTargetTriggerIndex()
    local modelObj = self.m_modelMgr:GetModelObjByTriggerIndex(t_index)
    if modelObj ~= nil then
      local actionItem = v:GetActionItem()
      if actionItem ~= nil and actionItem._actionData ~= nil then
        local status = actionItem._actionData.value or 0
        if status ~= nil and status ~= 0 then
          if modelObj:IsPlayer() == true then
            leftBuff[status] = 1
          else
            rightBuff[status] = 1
          end
        end
      end
    end
  end
  EventManager:GetInstance():Broadcast(EventId.PVEBattleSetLeftBuffData, leftBuff)
  EventManager:GetInstance():Broadcast(EventId.PVEBattleSetRightBuffData, rightBuff)
end

function PveActorMgr:AddBuffToHeroes()
  local bufflist = self.m_detailReport:GetBuffListByRoundIndex(self.m_startRoundIdx)
  for _, v in pairs(bufflist) do
    local t_index = v:GetTargetTriggerIndex()
    local modelObj = self.m_modelMgr:GetModelObjByTriggerIndex(t_index)
    modelObj:AddBuff(v)
  end
end

function PveActorMgr:DoAllBuff(callback)
  if callback ~= nil then
    callback()
  end
end

function PveActorMgr:GetCampTypeByTriggerIndex(value)
  if self.m_detailReport == nil then
    return Const.CampType.Target
  end
  local needExchange = self.levelParam and self.levelParam.needExchange or false
  return self.m_detailReport:GetCampTypeByTriggerIndex(value, needExchange)
end

local tabRank = {-1, 1}

function PveActorMgr:_CalculateTargetHit(defSide, damage)
  damage = Mathf.Abs(damage)
  local _tabHit = {}
  local _totalPower = 0
  local _aliveCnt = 0
  local _totalDamage = 0
  local _atkHit = {}
  local _attackModelList = defSide == Const.CampType.Player and self.m_modelMgr:GetModelListByCamp(Const.CampType.Target) or self.m_modelMgr:GetModelListByCamp(Const.CampType.Player)
  local _targetModelList = defSide == Const.CampType.Player and self.m_modelMgr:GetModelListByCamp(Const.CampType.Player) or self.m_modelMgr:GetModelListByCamp(Const.CampType.Target)
  if _attackModelList ~= nil then
    for _, modelObj in pairs(_attackModelList) do
      if not modelObj:IsDead() then
        _totalPower = _totalPower + modelObj:GetHeroPower()
        _aliveCnt = _aliveCnt + 1
      end
    end
    local _index_tmp1 = 1
    for index, modelObj in pairs(_attackModelList) do
      if not modelObj:IsDead() then
        if _index_tmp1 == _aliveCnt then
          _atkHit[tostring(index)] = damage - _totalDamage
        else
          local ratio = modelObj:GetHeroPower() / _totalPower
          ratio = Mathf.DecimalFormat(ratio)
          local _damage = Mathf.Floor(damage * ratio)
          _atkHit[tostring(index)] = _damage
          _totalDamage = _totalDamage + _damage
          _index_tmp1 = _index_tmp1 + 1
        end
      end
    end
  end
  if _targetModelList ~= nil then
    local _targetHp = {}
    for index, model in pairs(_targetModelList) do
      if not model:IsDead() then
        _targetHp[tostring(index)] = model:GetCurHp()
      end
    end
    local _targetHp_clone = DeepCopy(_targetHp)
    for index, value in pairs(_atkHit) do
      local leftvalue = value
      for i = 0, 4 do
        if i == 0 then
          local modelHp = _targetHp_clone[index]
          if modelHp ~= nil and 0 < modelHp then
            if leftvalue <= modelHp then
              _targetHp_clone[index] = _targetHp_clone[index] - leftvalue
              leftvalue = 0
              break
            else
              leftvalue = leftvalue - _targetHp_clone[index]
              _targetHp_clone[index] = 0
            end
          end
        else
          local tabRankCnt = table.count(tabRank)
          for j = 1, tabRankCnt do
            local newIndex = tostring(tonumber(index) + tabRank[j] * i)
            local modelHp = _targetHp_clone[newIndex]
            if modelHp ~= nil and 0 < modelHp then
              if leftvalue <= modelHp then
                _targetHp_clone[newIndex] = _targetHp_clone[newIndex] - leftvalue
                leftvalue = 0
                goto lbl_180
              else
                leftvalue = leftvalue - _targetHp_clone[newIndex]
                _targetHp_clone[newIndex] = 0
              end
            end
          end
        end
      end
      ::lbl_180::
    end
    for k, v in pairs(_targetHp) do
      _tabHit[k] = _targetHp_clone[k] - v
    end
  end
  return _tabHit
end

function PveActorMgr:DoAllNormalAttack(callback)
  if self:IsStopPlay() ~= true then
    self:PlayAllHeroesFireEffect()
  end
  local atkInfo = self.m_detailReport:GetAtkInfoByIndex(self.m_startRoundIdx)
  if atkInfo ~= nil then
    local normalAtk = atkInfo[Const.Define.NORMAL_ATK] or {}
    for triggerIdx, damage in pairs(normalAtk) do
      local needExchange = self.levelParam and self.levelParam.needExchange or false
      local _targetCampType = self:GetCampTypeByTriggerIndex(tonumber(triggerIdx), needExchange)
      damage = damage * self:GetHp2PowerRatio(_targetCampType)
      damage = Mathf.Floor(damage)
      local _targetModelList = _targetCampType == Const.CampType.Player and self.m_modelMgr:GetModelListByCamp(Const.CampType.Player) or self.m_modelMgr:GetModelListByCamp(Const.CampType.Target)
      local _hitInfo = self:_CalculateTargetHit(_targetCampType, damage)
      for index, value in pairs(_hitInfo) do
        local modelObj = _targetModelList[tonumber(index)]
        if modelObj ~= nil then
          modelObj:RecvHit(value, false)
          if not self:IsStopPlay() then
            modelObj:ShowHitEffect()
          end
        end
      end
    end
  end
  if self:IsStopPlay() then
    self:StopAllHeroesFireEffect()
    callback()
  else
    local delay = 1.0 * self:GetSpeed()
    self.m_delayAttack1 = TimerManager:GetInstance():DelayInvoke(function()
      self:StopAllHeroesFireEffect()
    end, delay * 0.7)
    self.m_delayAttack = TimerManager:GetInstance():DelayInvoke(function()
      callback()
    end, delay)
  end
end

function PveActorMgr:PlayAllHeroesFireEffect()
  self.m_modelMgr:PlayAllHeroesFireEffect()
end

function PveActorMgr:StopAllHeroesFireEffect()
  self.m_modelMgr:StopAllHeroesFireEffect()
end

function PveActorMgr:PlaySkill()
  local actionItem = self.m_curRoundSkill[self.m_skillRoundIdx]
  if actionItem == nil then
    self:DoAllBuff(function()
      self.m_startRoundIdx = self.m_startRoundIdx + 1
      self:PlayRound()
    end)
    return
  end
  self.m_skillRoundIdx = self.m_skillRoundIdx + 1
  self.m_skillMgr:DoAttack(actionItem, function()
    self:PlaySkill()
  end)
end

function PveActorMgr:PlaySkillWithActionItem(actionItem, maxTime)
  if self.m_skillMgr ~= nil then
    self.m_skillMgr:DoAttack(actionItem, nil, maxTime)
  end
end

function PveActorMgr:Destroy()
  if self.m_delayAttack ~= nil then
    self.m_delayAttack:Stop()
    self.m_delayAttack = nil
  end
  if self.m_delayAttack1 ~= nil then
    self.m_delayAttack1:Stop()
    self.m_delayAttack1 = nil
  end
  self.levelParam = nil
  self:HideSHeroLevelSkill()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPveBattleSoldierList)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPVEScene)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPVEResult)
  self.m_lineup:Destroy()
  self.m_modelMgr:Destroy()
  if self.__event_handlers[EventId.PVE_Lineup_LoadOK] then
    self:RemoveListener(EventId.PVE_Lineup_LoadOK, self.OnLineupLoadOK)
  end
  self.m_detailReport:ClearData()
  self.m_mailExt = nil
  self.hasResult = false
  BattleReportUtil.Cancel()
end

function PveActorMgr:GetEnemyHeros()
  local entranceType = DataCenter.BattleLevel:GetEntranceType()
  local isTargetPlayer = DataCenter.MineCaveManager:CheckIfEnemyIsPlayer()
  if entranceType == PveEntrance.MineCave and isTargetPlayer then
    local tempHeroes = {}
    if self.m_mailExt._fightRoundList and #self.m_mailExt._fightRoundList > 0 then
      local heroInfoDic = self.m_mailExt._fightRoundList[1]._otherArmyResult._armyObj._tHeroes
      for i, v in pairs(heroInfoDic) do
        local oneData = {}
        oneData.heroId = tonumber(v.heroId)
        oneData.heroLv = tonumber(v.heroLevel)
        oneData.heroQuality = tonumber(v.heroQuality)
        tempHeroes[#tempHeroes + 1] = oneData
      end
    end
    return tempHeroes
  end
  if entranceType == PveEntrance.ArenaBattle then
    local arenaRankInfo = DataCenter.ArenaManager:GetTargetEnemyInfo()
    if arenaRankInfo and arenaRankInfo.type == 1 then
      local heroes = {}
      local tempHeroes = arenaRankInfo.army.heroes
      for i, v in ipairs(tempHeroes) do
        local oneData = {}
        oneData.heroId = tonumber(v.heroId)
        oneData.heroLv = tonumber(v.heroLevel)
        oneData.heroQuality = tonumber(v.heroQuality)
        heroes[#heroes + 1] = oneData
      end
      return heroes
    end
  end
  local armyId = 0
  local entranceType = DataCenter.BattleLevel:GetEntranceType()
  if entranceType == PveEntrance.MineCave then
    local mineIndex, formationUuid, tempID = DataCenter.MineCaveManager:GetBattleParam()
    armyId = tempID
  elseif entranceType == PveEntrance.ArenaBattle then
    armyId = LuaEntry.DataConfig:TryGetStr("arena", "k12")
  else
    armyId = self:GetArmyId()
  end
  local enemyHeros = {}
  for k, v in ipairs(heros) do
    local heroInfo = GetTableData(TableName.Army, armyId, v)
    if not string.IsNullOrEmpty(heroInfo) then
      local t = string.split(heroInfo, ";")
      if table.count(t) >= 3 then
        local oneData = {}
        oneData.heroId = tonumber(t[1])
        oneData.heroLv = tonumber(t[2])
        oneData.heroQuality = tonumber(t[3])
        enemyHeros[#enemyHeros + 1] = oneData
      end
    end
  end
  return enemyHeros
end

function PveActorMgr:GetArmyId()
  local entranceType = DataCenter.BattleLevel:GetEntranceType()
  if entranceType == PveEntrance.MineCave then
    local mineIndex, formationUuid, tempArmyId = DataCenter.MineCaveManager:GetBattleParam()
    return tempArmyId
  end
  local trigger = DataCenter.BattleLevel:GetTriggerByTriggerId(self.m_triggerId)
  if trigger == nil then
    return -1
  end
  local armyId = ""
  if trigger:IsMonsterWithHp() then
    armyId = GetTableData(TableName.PVETrigger, self.m_triggerId, "UnclockPara")
  else
    armyId = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.Monster), self:GetCurMonsterId(), "army")
    armyId = armyId[1] or ""
  end
  return armyId
end

function PveActorMgr:RefreshEnemySigns()
  local qualities = {}
  local entranceType = DataCenter.BattleLevel:GetEntranceType()
  if entranceType == PveEntrance.MineCave then
    local model = self:GetEnemyHeros()
    for i, v in ipairs(model) do
      qualities[i] = GetTableData(HeroUtils.GetHeroXmlName(), v.heroId, "rarity")
    end
  elseif entranceType == PveEntrance.ArenaBattle then
    local arenaRankInfo = DataCenter.ArenaManager:GetTargetEnemyInfo()
    for i, v in ipairs(arenaRankInfo.army.heroes) do
      qualities[i] = GetTableData(HeroUtils.GetHeroXmlName(), v.heroId, "rarity")
    end
  else
    local armyId = self:GetArmyId()
    for k, fieldName in ipairs(heros) do
      local heroInfo = GetTableData(TableName.Army, armyId, fieldName)
      if not string.IsNullOrEmpty(heroInfo) then
        local t = string.split(heroInfo, ";")
        if table.count(t) >= 1 then
          qualities[k] = GetTableData(HeroUtils.GetHeroXmlName(), t[1], "rarity")
        end
      end
    end
  end
  self.m_lineup:RefreshEnemySigns(qualities)
end

function PveActorMgr:SetAtkTotalMaxHp(maxHp)
  self.atkTotalMaxHp = maxHp
  EventManager:GetInstance():Broadcast(EventId.PVE_TotalHp_Changed, true)
end

function PveActorMgr:SetDefTotalMaxHp(maxHp)
  self.defTotalMaxHp = maxHp
  EventManager:GetInstance():Broadcast(EventId.PVE_TotalHp_Changed, false)
end

function PveActorMgr:AddAtkTotalHp(hp)
  self.atkTotalCurPower = Mathf.Clamp(self.atkTotalCurPower + hp, 0, self.atkTotalPower)
  EventManager:GetInstance():Broadcast(EventId.PVE_TotalHp_Changed, true)
end

function PveActorMgr:AddDefTotalHp(hp)
  self.defTotalCurPower = Mathf.Clamp(self.defTotalCurPower + hp, 0, self.defTotalPower)
  EventManager:GetInstance():Broadcast(EventId.PVE_TotalHp_Changed, false)
end

function PveActorMgr:GetAtkTotalMaxHp()
  return self.atkTotalPower
end

function PveActorMgr:GetAtkTotalCurHp()
  return math.ceil(self.atkTotalCurPower)
end

function PveActorMgr:GetDefTotalMaxHp()
  return self.defTotalPower
end

function PveActorMgr:GetDefTotalCurHp()
  return self.defTotalCurPower
end

function PveActorMgr:GetTotalVirtualArmy()
  if self.totalVirtualArmy == 0 then
    local entranceType = DataCenter.BattleLevel:GetEntranceType()
    if entranceType == PveEntrance.MineCave and self.m_mailExt and self.m_mailExt._fightRoundList and 0 < #self.m_mailExt._fightRoundList then
      local soldierDic = self.m_mailExt._fightRoundList[1]._otherArmyResult._armyObj._tSoldiers
      for i, v in pairs(soldierDic) do
        self.totalVirtualArmy = self.totalVirtualArmy + v.total
      end
    end
  end
  return self.totalVirtualArmy
end

function PveActorMgr:SetHeros(heroes)
  self.m_heroes = {}
  for i = 1, #heroes do
    self.m_heroes[i] = {
      index = i,
      uuid = heroes[i]
    }
  end
  self:SetHeroDataBackup()
  EventManager:GetInstance():Broadcast(EventId.OnEmBattleHeroChanged)
end

function PveActorMgr:GetHeros()
  if self.m_heroes == nil then
    self.m_heroes = {}
  end
  return self.m_heroes
end

function PveActorMgr:SetArmys(armys)
  self.m_armys = armys
end

function PveActorMgr:GetArmys()
  if DataCenter.BattleLevel:GetLevelType() == PveLevelType.HeroExpLevel or DataCenter.BattleLevel:GetLevelType() == PveLevelType.BattleExpLevel or DataCenter.BattleLevel:GetLevelType() == PveLevelType.RadarExpLevel then
    local heroes = {}
    for _, v in pairs(self.m_heroes) do
      heroes[v.uuid] = DataCenter.BattleLevel:GetPveHeroData(v.uuid)
    end
    return self:GetArmyDataForHeroExpBattleLevel(heroes)
  elseif DataCenter.BattleLevel:GetLevelType() == PveLevelType.AdventureLevel then
    return DataCenter.AdventureManager:GetAliveArmy()
  else
    if self.m_armys == nil then
      self.m_armys = {}
    end
    return self.m_armys
  end
end

function PveActorMgr:GetEmBattleTotalPowerAndHp(isSelf)
  if self.levelParam ~= nil and self.levelParam.pveEntrance == PveEntrance.BattlePlayBack then
    if isSelf then
      return self.levelParam.leftPower
    elseif self.levelParam.rightMonsterId == 0 then
      return self.levelParam.rightPower
    else
      local totalPower = 0
      local monsterId = self.levelParam.rightMonsterId
      local armyId = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.Monster), monsterId, "army")
      armyId = armyId[1] or 0
      local pve_power_str = GetTableData(TableName.Army, armyId, "pve_power") or ""
      local powerTable = string.split(pve_power_str, "|")
      for _, v in pairs(powerTable) do
        totalPower = totalPower + (tonumber(v) or 0)
      end
      return totalPower
    end
  else
    local defSoldierId = LuaEntry.DataConfig:TryGetNum("aps_pve_config", "k1")
    local defSoldierNum = LuaEntry.DataConfig:TryGetNum("aps_pve_config", "k2")
    if isSelf then
      local heroes = {}
      for _, v in pairs(self.m_heroes) do
        if v ~= nil and v.uuid ~= nil then
          heroes[v.uuid] = DataCenter.BattleLevel:GetPveHeroData(v.uuid)
        end
      end
      local soldiers = {}
      table.walk(self:GetArmys(), function(k, v)
        soldiers[tonumber(k)] = v
      end)
      local buffEffectDict = DataCenter.BattleLevel:GetBuffEffectDict()
      local totalPower, totalHp = MarchUtil.GetFormationPower(heroes, soldiers, 1, MarchUtil.GetCampAddParam(heroes), buffEffectDict)
      return math.ceil(totalPower), math.ceil(totalHp)
    else
      local armyId = 0
      local entranceType = DataCenter.BattleLevel:GetEntranceType()
      if entranceType == PveEntrance.MineCave then
        local isTargetPlayer = DataCenter.MineCaveManager:CheckIfEnemyIsPlayer()
        if isTargetPlayer then
          local heroPowerDic = DataCenter.MineCaveManager:GetEnemyPlayerPower()
          local totalP = 0
          for _, tempHp in pairs(heroPowerDic) do
            totalP = totalP + tempHp
          end
          return totalP, totalP
        else
          local mineIndex, formationUuid, tempID = DataCenter.MineCaveManager:GetBattleParam()
          armyId = tempID
        end
      elseif entranceType == PveEntrance.ArenaBattle then
        local hpTb = self:GetArenaDefenseHeroPower()
        local totalHp = 0
        for i, v in ipairs(hpTb) do
          totalHp = totalHp + v
        end
        return totalHp, totalHp
      else
        armyId = self:GetArmyId()
      end
      if armyId < 0 then
        return 0, 0
      end
      local pve_power_str = GetTableData(TableName.Army, armyId, "pve_power") or ""
      local powerTable = string.split(pve_power_str, "|")
      local totalPower, totalHp = 0, 0
      for _, v in pairs(powerTable) do
        totalPower = totalPower + (tonumber(v) or 0)
      end
      local monsterData = DataCenter.BattleLevel:GetMonsterDataByTriggerId(self.m_triggerId)
      if monsterData ~= nil then
        local hpFactor = monsterData.health / monsterData.initHealth
        totalPower = totalPower * hpFactor
      end
      local arm_str = GetTableData(TableName.Army, armyId, "arm")
      if string.IsNullOrEmpty(arm_str) then
        Logger.LogError("Error army id: " .. armyId)
        return totalPower, totalHp
      end
      local armTable = string.split(arm_str, "|")
      for _, str in pairs(armTable) do
        local soliderKV = string.split(str, ";")
        local soldierId = tonumber(soliderKV[1])
        local soldierNum = tonumber(soliderKV[2])
        local hp = GetTableData(TableName.ArmsTab, soldierId, "health")
        totalHp = totalHp + hp * soldierNum
      end
      return totalPower, totalHp
    end
  end
end

function PveActorMgr:RefreshHeroSigns()
  self.m_lineup:RefreshHeroSigns()
end

function PveActorMgr:SetHeroSignIcon(index, quality)
  self.m_lineup:SetHeroSignIcon(index, quality)
end

function PveActorMgr:GetStandObj(campType, index)
  return self.m_lineup:GetStandObj(campType, index)
end

function PveActorMgr:GetEmArmyList()
  local armyList = {}
  if self.levelParam ~= nil and self.levelParam.pveEntrance == PveEntrance.BattlePlayBack then
    if self.levelParam.rightMonsterId == 0 then
      local list = self.levelParam.rightSoliderList
      if list ~= nil then
        for k, v in pairs(list) do
          local army = {}
          army.soldierId = k
          army.soldierNum = v
          table.insert(armyList, army)
        end
      end
    else
      local monsterId = self.levelParam.rightMonsterId
      local armyId = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.Monster), monsterId, "army")
      armyId = armyId[1] or 0
      local arm_str = GetTableData(TableName.Army, armyId, "arm")
      local armTable = string.split(arm_str, "|")
      for _, str in pairs(armTable) do
        local army = {}
        local soliderKV = string.split(str, ";")
        local soldierId = tonumber(soliderKV[1])
        local soldierNum = tonumber(soliderKV[2])
        army.soldierId = soldierId
        army.soldierNum = soldierNum
        table.insert(armyList, army)
      end
    end
    return armyList
  end
  local entranceType = DataCenter.BattleLevel:GetEntranceType()
  if entranceType == PveEntrance.MineCave then
    if self.m_mailExt and self.m_mailExt._fightRoundList and 0 < #self.m_mailExt._fightRoundList then
      local soldierDic = self.m_mailExt._fightRoundList[1]._otherArmyResult._armyObj._tSoldiers
      for i, v in pairs(soldierDic) do
        local army = {}
        army.soldierId = v.armsId
        army.soldierNum = v.total
        table.insert(armyList, army)
      end
    else
      local armyId = self:GetArmyId()
      local arm_str = GetTableData(TableName.Army, armyId, "arm")
      local armTable = string.split(arm_str, "|")
      for _, str in pairs(armTable) do
        local army = {}
        local soliderKV = string.split(str, ";")
        local soldierId = tonumber(soliderKV[1])
        local soldierNum = tonumber(soliderKV[2])
        army.soldierId = soldierId
        army.soldierNum = soldierNum
        table.insert(armyList, army)
      end
    end
  elseif entranceType == PveEntrance.ArenaBattle then
    local arenaRankInfo = DataCenter.ArenaManager:GetTargetEnemyInfo()
    local tempSoldieres = arenaRankInfo.army.soldiers
    for i, v in ipairs(tempSoldieres) do
      local soldier = {}
      soldier.soldierId = v.armsId
      soldier.soldierNum = v.total
      table.insert(armyList, soldier)
    end
  else
    local armyId = self:GetArmyId()
    local arm_str = GetTableData(TableName.Army, armyId, "arm")
    local armTable = string.split(arm_str, "|")
    for _, str in pairs(armTable) do
      local army = {}
      local soliderKV = string.split(str, ";")
      local soldierId = tonumber(soliderKV[1])
      local soldierNum = tonumber(soliderKV[2])
      army.soldierId = soldierId
      army.soldierNum = soldierNum
      table.insert(armyList, army)
    end
  end
  return armyList
end

function PveActorMgr:GetMaxHeroNum()
  local levelType = DataCenter.BattleLevel:GetLevelType()
  if levelType == PveLevelType.BattleExpLevel or levelType == PveLevelType.RadarExpLevel then
    return DataCenter.BattleLevel:GetMaxHeroCount()
  else
    local maxHeroNum = 0
    local k5 = LuaEntry.DataConfig:TryGetStr("aps_pve_config", "k5")
    local arr = string.split(k5, ";")
    local needLv = 100
    if 0 < #arr then
      for i = 1, #arr do
        local id = tonumber(arr[i])
        local level = DataCenter.BuildManager.MainLv
        if id ~= nil and level ~= nil and id <= level then
          maxHeroNum = maxHeroNum + 1
        end
      end
      if maxHeroNum < 5 and maxHeroNum + 1 <= #arr then
        needLv = tonumber(arr[maxHeroNum + 1])
      end
    end
    return math.min(maxHeroNum, 5), needLv
  end
end

function PveActorMgr:GetCurrentHeroDataList(camp)
  local allHeroes = DataCenter.HeroDataManager:GetAllHeroBySort()
  local heroes = table.values(allHeroes)
  table.sort(heroes, function(heroA, heroB)
    if heroA.rarity ~= heroB.rarity then
      return heroA.rarity < heroB.rarity
    end
    if heroA.level ~= heroB.level then
      return heroA.level > heroB.level
    end
    if heroA.quality ~= heroB.quality then
      return heroA.quality > heroB.quality
    end
    if heroA.camp ~= heroB.camp then
      return heroA.camp < heroB.camp
    end
    return heroA.heroId < heroB.heroId
  end)
  local result = {}
  for _, heroData in pairs(heroes) do
    if camp ~= nil and -1 < camp then
      local targetCamp = GetTableData(HeroUtils.GetHeroXmlName(), heroData.heroId, "camp")
      if targetCamp == camp then
        table.insert(result, heroData.uuid)
      end
    else
      table.insert(result, heroData.uuid)
    end
  end
  return result
end

function PveActorMgr:GetCanAddHero()
  local heroList = self:GetCurrentHeroDataList()
  local maxHeroNum = self:GetMaxHeroNum()
  local curHeroes = PveActorMgr:GetInstance():GetHeros()
  local len = table.count(curHeroes)
  local heroes = {}
  if 0 < len then
    table.walk(curHeroes, function(k, v)
      if v ~= nil then
        heroes[v.uuid] = v.index
      end
    end)
  else
    local heroArr = DataCenter.BattleLevel:GetHeroSelectHistory()
    if not table.IsNullOrEmpty(heroArr) then
      for _, v in ipairs(heroArr) do
        local uuid = tonumber(v)
        heroes[uuid] = _
      end
    end
  end
  local curHeroNum = table.count(heroes)
  if curHeroNum < 5 and maxHeroNum > curHeroNum and curHeroNum < #heroList then
    return true
  end
  return false
end

function PveActorMgr:GetCanAddHeroByHeroId(heroId)
  local canAdd = false
  local has = self:GetCanAddHero()
  if has == true then
    local heroUuid = DataCenter.HeroDataManager:GetHeroUuidByHeroId(heroId)
    if heroUuid ~= nil and heroUuid ~= "" then
      canAdd = true
      local curHeroes = PveActorMgr:GetInstance():GetHeros()
      local len = table.count(curHeroes)
      local heroes = {}
      if 0 < len then
        table.walk(curHeroes, function(k, v)
          if v ~= nil then
            heroes[v.uuid] = v.index
          end
        end)
      else
        local heroArr = DataCenter.BattleLevel:GetHeroSelectHistory()
        if not table.IsNullOrEmpty(heroArr) ~= "" then
          for _, v in ipairs(heroArr) do
            local uuid = tonumber(v)
            heroes[uuid] = _
          end
        end
      end
      if heroes[heroUuid] ~= nil then
        canAdd = false
      end
    end
  end
  return canAdd
end

function PveActorMgr:IsHeroExistByHeroId(heroId)
  local heroUuid = DataCenter.HeroDataManager:GetHeroUuidByHeroId(heroId)
  if heroUuid ~= nil and heroUuid ~= "" then
    local curHeroes = PveActorMgr:GetInstance():GetHeros()
    local len = table.count(curHeroes)
    local heroes = {}
    if 0 < len then
      table.walk(curHeroes, function(k, v)
        if v ~= nil then
          heroes[v.uuid] = v.index
        end
      end)
    else
      local heroArr = DataCenter.BattleLevel:GetHeroSelectHistory()
      if not table.IsNullOrEmpty(heroArr) ~= "" then
        for _, v in ipairs(heroArr) do
          local uuid = tonumber(v)
          heroes[uuid] = _
        end
      end
    end
    if heroes[heroUuid] == nil then
      return true
    end
  end
  return false
end

function PveActorMgr:GetCanAddHeroByHeroRarity(rarity)
  local has = self:GetCanAddHero()
  local list = self:GetCurrentHeroDataList()
  if has then
    local heroes = {}
    local curHeroes = PveActorMgr:GetInstance():GetHeros()
    local len = table.count(curHeroes)
    if 0 < len then
      table.walk(curHeroes, function(k, v)
        if v ~= nil then
          heroes[v.uuid] = v.index
        end
      end)
    else
      local heroArr = DataCenter.BattleLevel:GetHeroSelectHistory()
      if not table.IsNullOrEmpty(heroArr) ~= "" then
        for _, v in ipairs(heroArr) do
          local uuid = tonumber(v)
          heroes[uuid] = _
        end
      end
    end
    for i = 1, #list do
      local uuid = list[i]
      if heroes[uuid] == nil then
        local tempHeroData = DataCenter.BattleLevel:GetPveHeroData(uuid)
        if tempHeroData.rarity == rarity then
          return tempHeroData
        end
      end
    end
  end
end

function PveActorMgr:IsHeroExistByHeroRarity(rarity)
  local list = self:GetCurrentHeroDataList()
  local heroes = {}
  local curHeroes = PveActorMgr:GetInstance():GetHeros()
  local len = table.count(curHeroes)
  if 0 < len then
    table.walk(curHeroes, function(k, v)
      if v ~= nil then
        heroes[v.uuid] = v.index
      end
    end)
  else
    local heroArr = DataCenter.BattleLevel:GetHeroSelectHistory()
    if not table.IsNullOrEmpty(heroArr) ~= "" then
      for _, v in ipairs(heroArr) do
        local uuid = tonumber(v)
        heroes[uuid] = _
      end
    end
  end
  for i = 1, #list do
    local uuid = list[i]
    if heroes[uuid] == nil then
      local tempHeroData = DataCenter.BattleLevel:GetPveHeroData(uuid)
      if tempHeroData.rarity == rarity then
        return tempHeroData
      end
    end
  end
end

function PveActorMgr:GetRarityMinHero()
  local heroData
  local rarity = 999
  local level = 0
  local heroes = {}
  local curHeroes = PveActorMgr:GetInstance():GetHeros()
  local len = table.count(curHeroes)
  if 0 < len then
    table.walk(curHeroes, function(k, v)
      if v ~= nil then
        heroes[v.uuid] = v.index
      end
    end)
  else
    local heroArr = DataCenter.BattleLevel:GetHeroSelectHistory()
    if not table.IsNullOrEmpty(heroArr) ~= "" then
      for _, v in ipairs(heroArr) do
        local uuid = tonumber(v)
        heroes[uuid] = _
      end
    end
  end
  for k, v in pairs(heroes) do
    local uuid = k
    local tempHeroData = DataCenter.BattleLevel:GetPveHeroData(uuid)
    if rarity == 999 or rarity < tempHeroData.rarity then
      heroData = tempHeroData
      rarity = tempHeroData.rarity
      level = tempHeroData.level
    elseif rarity == tempHeroData.rarity and level > tempHeroData.level then
      heroData = tempHeroData
      rarity = tempHeroData.rarity
      level = tempHeroData.level
    end
  end
  if heroData ~= nil then
    return heroData
  end
end

function PveActorMgr:GetArmyDataForHeroExpBattleLevel(heroList)
  local soldierId = LuaEntry.DataConfig:TryGetNum("aps_pve_config", "k1")
  local asPlayerMaxSoldiers = LuaEntry.DataConfig:TryGetNum("building_base", "k5")
  local baseSize = LuaEntry.Effect:GetGameEffect(EffectDefine.APS_FORMATION_SIZE)
  local sizeEnhance = LuaEntry.Effect:GetGameEffect(EffectDefine.APS_FORMATION_SIZE_ENHANCE)
  asPlayerMaxSoldiers = asPlayerMaxSoldiers + math.floor(baseSize + 0.5)
  local campAdd = 0
  if heroList ~= nil then
    table.walk(heroList, function(k, v)
      local heroData = DataCenter.BattleLevel:GetPveHeroData(k)
      if heroData ~= nil then
        local config = heroData:GetConfig()
        local rankId = heroData:GetRank()
        local armyAdd = HeroUtils.GetArmyLimit(heroData.level, rankId, config.rarity, heroData.heroId, heroData.quality)
        asPlayerMaxSoldiers = asPlayerMaxSoldiers + armyAdd
        local heroBaseSize = heroData:GetEffectNum(EffectDefine.APS_FORMATION_SIZE)
        local heroSizeEnhance = heroData:GetEffectNum(EffectDefine.APS_FORMATION_SIZE_ENHANCE)
        local campAddEffect = LuaEntry.Effect:GetGameEffect(HeroUtils.GetExtraTroopByCamp(heroData.camp))
        campAdd = campAddEffect + campAdd
        asPlayerMaxSoldiers = asPlayerMaxSoldiers + heroBaseSize
        sizeEnhance = sizeEnhance + heroSizeEnhance
      end
    end)
  end
  local formationIndex = 1
  local finalAddNumByIndex = MarchUtil.GetFormationMaxNumByFormationIndex(formationIndex)
  asPlayerMaxSoldiers = asPlayerMaxSoldiers + finalAddNumByIndex + campAdd
  asPlayerMaxSoldiers = asPlayerMaxSoldiers * (1 + sizeEnhance / 100)
  local armyData = {}
  armyData[tonumber(soldierId)] = math.floor(asPlayerMaxSoldiers)
  return armyData
end

function PveActorMgr:GetLevelParam()
  return self.levelParam
end

function PveActorMgr:SetHeroDataBackup()
  self.heroDataBackup = {}
  for _, v in ipairs(self.m_heroes) do
    local heroUuid = v.uuid
    local heroData = DataCenter.BattleLevel:GetPveHeroData(heroUuid)
    local info = {}
    info.oldLevel = heroData.level
    info.oldExp = heroData.exp
    self.heroDataBackup[heroUuid] = info
  end
end

function PveActorMgr:GetHeroDataBackup()
  return self.heroDataBackup
end

function PveActorMgr:SetDiffMonsterEasy(trigger)
  local diff = 1
  local monsterId = PveUtil.GetRecommendMonsterId(diff)
  if monsterId == nil then
    Logger.LogError("PveActorMgr, SetDiffMonsterEasy, Cannot get recommend monster id, triggerId: " .. trigger:GetTriggerId())
    return
  end
  self:SetMonsterDiff(diff, monsterId)
  DataCenter.BattleLevel:DoTrigger(trigger)
end

function PveActorMgr:CreateEffectObj(path, pos, duration, showDelay)
  local req = Resource:InstantiateAsync(path)
  req:completed("+", function()
    if req.isError or req.gameObject == nil then
      req:Destroy()
      table.removebyvalue(self.effReqList, req)
      return
    end
    local go = req.gameObject
    go:SetActive(true)
    local tf = go.transform
    tf.position = pos
    TimerManager:GetInstance():DelayInvoke(function()
      if req ~= nil then
        req:Destroy()
        table.removebyvalue(self.effReqList, req)
      end
    end, duration)
  end)
  table.insert(self.effReqList, req)
end

function PveActorMgr:SetModelHeroLv(heroId, heroLv)
  self.m_modelMgr:SetHeroLv(heroId, heroLv)
end

return PveActorMgr
