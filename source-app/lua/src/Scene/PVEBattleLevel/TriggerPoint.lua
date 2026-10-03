local Resource = CS.GameEntry.Resource
local TypeOfSpriteRenderer = typeof(CS.UnityEngine.SpriteRenderer)
local Const = require("Scene.PVEBattleLevel.Const")
local Localization = CS.GameEntry.Localization
local TriggerPointCollection = require("Scene.PVEBattleLevel.TriggerPointCollection")
local TriggerPointFactory = require("Scene.PVEBattleLevel.TriggerPointFactory")
local TriggerPointMonster = require("Scene.PVEBattleLevel.TriggerPointMonster")
local TriggerPointBuild = require("Scene.PVEBattleLevel.TriggerPointBuild")
local TriggerPointAttackBox = require("Scene.PVEBattleLevel.TriggerPointAttackBox")
local TriggerPointTurret = require("Scene.PVEBattleLevel.TriggerPointTurret")
local PveTriggerPointBubble = require("Scene.PVEBattleLevel.PveTriggerPointBubble")
local TriggerPointShowModel = require("Scene.PVEBattleLevel.TriggerPointShowModel")
local TriggerPointHireHero = require("Scene.PVEBattleLevel.TriggerPointHireHero")
local TriggerPointMonsterWithHp = require("Scene.PVEBattleLevel.TriggerPointMonsterWithHp")
local TriggerPointBombArea = require("Scene.PVEBattleLevel.TriggerPointBombArea")
local TriggerPointTrapMine = require("Scene.PVEBattleLevel.TriggerPointTrapMine")
local TriggerTeleport = require("Scene.PVEBattleLevel.TriggerPointTeleport")
local ResTypeCount = 5
local UnityTextMeshPro = typeof(CS.TMPro.TextMeshPro)
local tonumber = _ENV.tonumber
local ipairs = _ENV.ipairs
local TypeOfSlider = typeof(CS.UnityEngine.UI.Slider)
local TypeOfText = typeof(CS.NewText)
local Physics = CS.UnityEngine.Physics
local TriggerEnterDistance = 1
local TriggerPoint = BaseClass("TriggerPoint")
local _srcBlend = CS.UnityEngine.Shader.PropertyToID("_SrcBlend")
local _dstBlend = CS.UnityEngine.Shader.PropertyToID("_DstBlend")

function TriggerPoint:__init(battleLevel, mgr, triggerId)
  self.battleLevel = battleLevel
  self.mgr = mgr
  self.triggerId = triggerId
  self.giveRes = {}
  self.position = Vector3.zero
  self.pointId = 0
  self.viewVisible = false
  self:SetTriggerOK(false)
  self.isVisible = nil
  self.monsterLevelVisible = false
  self.collectionPoint = nil
  self.monsterGrid = nil
  self.hitTerrainInfo = CS.System.Array.CreateInstance(typeof(CS.UnityEngine.RaycastHit), 5)
  self.canSubmit = true
  self.triggerEnterDistance = TriggerEnterDistance
  self.oldMaterials = {}
  self.objectRender = {}
  self.isPreOk = false
  self:InitData()
end

function TriggerPoint:__delete()
end

function TriggerPoint:InitData()
  self.config = self:ParseConfig(self:GetTriggerId())
  self.canSubmit = self.config.trigger_type ~= Const.TriggerBubbleType.Bubble
  if self.config.transform ~= nil then
    local t = self.config.transform.t
    self.position = Vector3.New(t.x, t.y, t.z)
  elseif self.config.pos ~= nil then
    self.position = self:GetTerrainPos(SceneUtils.TileToWorld(self.config.pos))
  end
  if self.position ~= nil then
    self.pointId = SceneUtils.WorldToTileIndex(self.position)
  end
  if self.mgr:IsFinishTrigger(self:GetTriggerId()) then
    if self.config.type == Const.TriggerType.Build or self.config.type == Const.TriggerType.ShowModel or self.config.type == Const.TriggerType.CommitAll or self.config.type == Const.TriggerType.CollectRewardMoreThanOneTime or self.config.type == Const.TriggerType.EmptyModel or self.config.type == Const.TriggerType.HealArmy or self.config.type == Const.TriggerType.GainArmy then
      self:SetVisible(true)
    else
      self:SetVisible(false)
    end
  elseif self:IsTypeMonster() then
    self:SetVisible(true)
    self:SetMonsterLevelVisible(false)
  else
    self:SetVisible(false)
  end
  if self:IsTypeBombArea() then
    self.bombArea = TriggerPointBombArea.New(self)
    self.bombArea:Create()
  end
  if self:IsTypeTrapMine() then
    self.trapMine = TriggerPointTrapMine.New(self)
    self.trapMine:Create()
  end
  self:CheckShowFinishTrigger()
  self:SetTimeLineEnd(true)
  self:SetPlayerInteractEnd(true)
end

function TriggerPoint:ParseConfig(triggerId)
  local config = {}
  config.triggerId = triggerId
  local row = LocalController:instance():getLine(TableName.PVETrigger, triggerId)
  if row == nil then
    Logger.LogError("trigger not exist: " .. triggerId)
    return config
  end
  local str = row:getValue("Pos")
  if str ~= nil and str ~= "" then
    local ss = string.split_ff_array(str, ",")
    if #ss == 2 then
      config.pos = Vector2.New(ss[1], ss[2])
    end
  end
  local unlockType = toInt(row:getValue("UnclockType"))
  local unlockPara = {}
  local unlockPara2 = {}
  local unlockPara3 = {}
  local unlockPara4 = {}
  local unlockPara5 = {}
  str = row:getValue("UnclockPara")
  if str ~= nil and str ~= "" then
    local ss = string.split_ss_array(str, "|")
    for _, v in ipairs(ss) do
      unlockPara[#unlockPara + 1] = v
    end
  end
  str = row:getValue("UnclockPara2")
  if str ~= nil and str ~= "" then
    local ss = string.split_ss_array(str, "|")
    for _, v in ipairs(ss) do
      unlockPara2[#unlockPara2 + 1] = v
    end
  end
  str = row:getValue("UnclockPara3")
  if str ~= nil and str ~= "" then
    local ss = string.split_ss_array(str, "|")
    for _, v in ipairs(ss) do
      unlockPara3[#unlockPara3 + 1] = v
    end
  end
  str = row:getValue("UnclockPara4")
  if str ~= nil and str ~= "" then
    local ss = string.split_ss_array(str, "|")
    for _, v in ipairs(ss) do
      unlockPara4[#unlockPara4 + 1] = v
    end
  end
  str = row:getValue("UnclockPara5")
  if str ~= nil and str ~= "" then
    local ss = string.split_ss_array(str, "|")
    for _, v in ipairs(ss) do
      unlockPara5[#unlockPara5 + 1] = v
    end
  end
  config.type = unlockType
  config.needRes = {}
  config.collectRes = {}
  config.needCostRes = {}
  config.needCostResItem = {}
  config.selectBuff = {}
  config.monsterGroupList = {}
  config.needBubbleSubmit = {}
  local transform = row:getValue("Transform")
  if not string.IsNullOrEmpty(transform) then
    local transArr = string.split_ss_array(transform, ";")
    if 4 <= #transArr then
      local t = string.split_ff_array(transArr[1], ",")
      local r = string.split_ff_array(transArr[2], ",")
      local s = string.split_ff_array(transArr[3], ",")
      local prefab = transArr[4]
      config.transform = {
        t = {
          x = t[1],
          y = t[2],
          z = t[3]
        },
        r = {
          x = r[1],
          y = r[2],
          z = r[3]
        },
        s = {
          x = s[1],
          y = s[2],
          z = s[3]
        },
        prefab = prefab
      }
    end
  end
  if unlockType == Const.TriggerType.CommitRes then
    for i, t in ipairs(unlockPara) do
      t = tonumber(t)
      config.needRes[t] = tonumber(unlockPara2[i]) or 1
    end
    config.type = Const.TriggerType.CommitRes
  elseif unlockType == Const.TriggerType.CommitResource then
    for i, t in ipairs(unlockPara) do
      t = tonumber(t)
      config.needRes[t] = tonumber(unlockPara2[i]) or 1
    end
    config.type = Const.TriggerType.CommitResource
  elseif unlockType == Const.TriggerType.CommitResourceItem then
    for k, v in ipairs(unlockPara) do
      config.needRes[tonumber(v)] = tonumber(unlockPara2[k]) or 1
    end
    config.type = Const.TriggerType.CommitResourceItem
    for k, v in ipairs(unlockPara) do
      local param = {}
      param.needType = TriggerNeedType.ResourceItem
      param.needId = tonumber(v)
      param.needCount = tonumber(unlockPara2[k]) or 1
      table.insert(config.needBubbleSubmit, param)
    end
  elseif unlockType == Const.TriggerType.CommitResourceItem then
    for k, v in ipairs(unlockPara) do
      local param = {}
      param.needType = TriggerNeedType.ResourceItem
      param.needId = tonumber(v)
      param.needCount = tonumber(unlockPara2[k]) or 1
      table.insert(config.needBubbleSubmit, param)
    end
    config.type = Const.TriggerType.CommitResourceItem
    if unlockPara3 ~= nil and table.count(unlockPara3) > 0 then
      config.gotoTriggerIds = unlockPara3
    end
    config.canBuy = unlockPara4 or {}
    if unlockPara5 ~= nil and table.count(unlockPara5) > 0 then
      config.triggerIcon = unlockPara5[1]
    end
  elseif unlockType == Const.TriggerType.CommitGoods then
    for k, v in ipairs(unlockPara) do
      local param = {}
      param.needType = TriggerNeedType.Goods
      param.needId = tonumber(v)
      param.needCount = tonumber(unlockPara2[k]) or 1
      table.insert(config.needBubbleSubmit, param)
    end
    config.type = Const.TriggerType.CommitGoods
    if unlockPara3 ~= nil and table.count(unlockPara3) > 0 then
      config.gotoTriggerIds = unlockPara3
    end
    config.canBuy = unlockPara4 or {}
    if unlockPara5 ~= nil and table.count(unlockPara5) > 0 then
      config.triggerIcon = unlockPara5[1]
    end
  elseif unlockType == Const.TriggerType.Monster then
    config.monsterId = tonumber(unlockPara[1]) or nil
    config.specialFlag = tonumber(unlockPara2[1]) or 0
  elseif unlockType == Const.TriggerType.RewardBox then
    config.rewardId = tonumber(unlockPara[1]) or nil
  elseif unlockType == Const.TriggerType.CollectRes then
    config.collectRes[Const.CommitType.HeroExp] = tonumber(unlockPara[1]) or 0
    config.maxBlood = tonumber(unlockPara2[1]) or 6
    config.resType = Const.CityCutResType.HeroExp
  elseif unlockType == Const.TriggerType.Flag then
    config.type = Const.TriggerType.CommitRes
    config.needRes[Const.CommitType.Flag] = 1
  elseif unlockType == Const.TriggerType.Person then
    config.type = Const.TriggerType.CommitRes
    config.needRes[Const.CommitType.Person] = 1
  elseif unlockType == Const.TriggerType.Player then
    config.playerName = unlockPara[1] or Const.DefinePlayerName
    config.dialogId = tonumber(unlockPara2[1]) or tonumber(GameDialogDefine.HELP_PEOPLE_BUBBLE_TIP)
  elseif unlockType == Const.TriggerType.Build then
    local list = string.split_ss_array(unlockPara[1], ";")
    local count = table.count(list)
    if 0 < count then
      config.buildName = list[1]
    end
    if 1 < count then
      config.animName = list[2]
    end
    local para2Count = table.count(unlockPara2)
    if 0 < para2Count then
      config.buffTriggerList = {}
      local buffList = string.split_ss_array(unlockPara2[1], ";")
      for k, v in ipairs(buffList) do
        local one = string.split_ii_array(v, ",")
        table.insert(config.buffTriggerList, one)
      end
    end
    if 1 < para2Count then
      config.triggerDirection = tonumber(unlockPara2[2])
    end
  elseif unlockType == Const.TriggerType.Buff then
    for i, s in ipairs(unlockPara) do
      local need = string.split_ii_array(s, ";")
      if #need == 2 then
        local param = {}
        param.resType = Const.ResourceTypeToResType[need[1]]
        param.count = need[2]
        table.insert(config.needCostRes, param)
      end
    end
    for i, s in ipairs(unlockPara3) do
      local need = string.split_ii_array(s, ";")
      if #need == 2 then
        local param = {}
        param.resType = Const.UnlockToResType[need[1]]
        param.count = need[2]
        table.insert(config.needCostRes, param)
      end
    end
    for i, s in ipairs(unlockPara4) do
      local need = string.split_ii_array(s, ";")
      if #need == 2 then
        local param = {}
        param.resItemId = tonumber(need[1])
        param.count = tonumber(need[2])
        table.insert(config.needCostResItem, param)
      end
    end
    config.buffId = tonumber(unlockPara2[1])
  elseif unlockType == Const.TriggerType.BuyResItem or unlockType == Const.TriggerType.BuyWaitResItem then
    for i, s in ipairs(unlockPara) do
      local need = string.split_ii_array(s, ";")
      if #need == 2 then
        local param = {}
        param.resType = Const.ResourceTypeToResType[need[1]]
        param.count = need[2]
        table.insert(config.needCostRes, param)
      end
    end
    for i, s in ipairs(unlockPara3) do
      local need = string.split_ii_array(s, ";")
      if #need == 2 then
        local param = {}
        param.resType = Const.UnlockToResType[need[1]]
        param.count = need[2]
        table.insert(config.needCostRes, param)
      end
    end
    local list = string.split_ii_array(unlockPara2[1], ";")
    if #list == 2 then
      config.buyResItem = list[1]
      config.buyResItemNum = list[2]
    end
  elseif unlockType == Const.TriggerType.Area then
    config.areaRadius = tonumber(unlockPara[1]) or 1
  elseif unlockType == Const.TriggerType.Npc then
    local list = string.split_ss_array(unlockPara[1], ";")
    local count = table.count(list)
    if 0 < count then
      config.npcName = list[1]
    end
    if 1 < count then
      config.aniName = list[2]
    end
    if 2 < count then
      config.dialogId = tonumber(list[3])
    end
    config.posArr = {}
    local list2 = string.split_ss_array(unlockPara2[1], ";")
    count = table.count(list2)
    if 0 < count then
      local need = string.split_ii_array(list2[1], ",")
      if 1 < table.count(need) then
        local vec = {}
        vec.x = need[1]
        vec.y = need[2]
        table.insert(config.posArr, vec)
      end
    end
    if 1 < count then
      config.angle = tonumber(list2[2])
    else
      config.angle = 0
    end
  elseif unlockType == Const.TriggerType.Timeline then
    config.timelinePath = unlockPara[1]
    config.timelineLen = unlockPara2[1] or 5
  elseif unlockType == Const.TriggerType.SelectBuff then
    if unlockPara[1] ~= nil then
      local list = string.split_ss_array(unlockPara[1], ";")
      for k, v in ipairs(list) do
        local spl = string.split_ii_array(v, ",")
        table.insert(config.selectBuff, spl)
      end
    end
  elseif unlockType == Const.TriggerType.AdvancedBuild then
    config.stateNeedRes = {}
    config.buildName = table.remove(unlockPara2, 1)
    for i, n in ipairs(unlockPara2) do
      local stateNeed = config.stateNeedRes[i] or {}
      for _, m in ipairs(unlockPara) do
        stateNeed[tonumber(m)] = tonumber(n)
      end
      config.stateNeedRes[i] = stateNeed
    end
  elseif unlockType == Const.TriggerType.BuyWaitMoveMan then
    for i, s in ipairs(unlockPara) do
      local need = string.split_ii_array(s, ";")
      if #need == 2 then
        local param = {}
        param.resType = Const.ResourceTypeToResType[need[1]]
        param.count = need[2]
        table.insert(config.needCostRes, param)
      end
    end
    for i, s in ipairs(unlockPara3) do
      local need = string.split_ii_array(s, ";")
      if #need == 2 then
        local param = {}
        param.resType = Const.UnlockToResType[need[1]]
        param.count = need[2]
        table.insert(config.needCostRes, param)
      end
    end
    config.buyMoveManNum = tonumber(unlockPara2[1])
  elseif unlockType == Const.TriggerType.DiffMonster then
    config.monsterId = LINEUP_DEFAULT_MONSTER
    local basicExp = 0
    for i, p in ipairs(unlockPara) do
      local spl = string.split_ss_array(p, ";")
      if #spl == 1 then
        local info = {}
        info.exp = tonumber(spl[1])
        local effectValue = LuaEntry.Effect:GetGameEffect(EffectDefine.GLOBAL_HERO_EXP_EXTRA_PERCENT)
        info.exp = Mathf.Round(info.exp * (1 + effectValue / 100))
        if i == 1 then
          basicExp = info.exp
        end
        info.basicExp = basicExp
        info.monsterIdList = {}
        table.insert(config.monsterGroupList, info)
      elseif #spl == 2 then
        local info = {}
        info.id = tonumber(spl[1])
        info.exp = tonumber(spl[2])
        local effectValue = LuaEntry.Effect:GetGameEffect(EffectDefine.GLOBAL_HERO_EXP_EXTRA_PERCENT)
        info.exp = Mathf.Round(info.exp * (1 + effectValue / 100))
        if i == 1 then
          basicExp = info.exp
        end
        info.basicExp = basicExp
        local monsterIdStr = LocalController:instance():getStrValue("aps_pve_monster_group", info.id, "monsterIds")
        local strs = string.split_ss_array(monsterIdStr, ",")
        info.monsterIdList = {}
        for _, s in ipairs(strs) do
          table.insert(info.monsterIdList, tonumber(s))
        end
        table.insert(config.monsterGroupList, info)
      end
    end
  elseif unlockType == Const.TriggerType.BuffBox then
    for _, p in ipairs(unlockPara) do
      table.insert(config.selectBuff, tonumber(p))
    end
  elseif unlockType == Const.TriggerType.LevelLimitMonster then
    config.exp = tonumber(unlockPara[1]) or 0
  elseif unlockType == Const.TriggerType.AdventureSub then
    config.monsterId = ADVENTURE_DEFAULT_MONSTER
    config.caseList = {}
    for _, str in ipairs(unlockPara) do
      local spls = string.split_ss_array(str, ";")
      if #spls == 2 then
        local info = {}
        info.mainLv = tonumber(spls[1])
        info.caseId = tonumber(spls[2])
        table.insert(config.caseList, info)
      end
    end
  elseif unlockType == Const.TriggerType.Turret then
    config.attack = tonumber(unlockPara[1])
    config.maxBlood = tonumber(unlockPara[2])
    config.gunCount = tonumber(unlockPara[3])
    config.attackRadius = tonumber(unlockPara[4])
  elseif unlockType == Const.TriggerType.FollowPlayer then
    config.attack = tonumber(unlockPara[1])
    config.maxBlood = tonumber(unlockPara[2])
    config.attackRadius = tonumber(unlockPara[3])
  elseif unlockType == Const.TriggerType.DiffMonsterEasy then
    config.monsterId = LINEUP_DEFAULT_MONSTER
    config.exp = tonumber(unlockPara[1]) or 0
    local effectValue = LuaEntry.Effect:GetGameEffect(EffectDefine.GLOBAL_HERO_EXP_EXTRA_PERCENT)
    config.exp = Mathf.Round(config.exp * (1 + effectValue / 100))
  elseif unlockType == Const.TriggerType.BuyAttack then
    if unlockPara2[1] ~= nil then
      config.selectBuff = string.split_ii_array(unlockPara2[1], ";")
    end
  elseif unlockType == Const.TriggerType.AttackBox then
    config.rewardId = tonumber(unlockPara[1]) or nil
    config.blood = tonumber(unlockPara2[1]) or 5
    config.resType = Const.CityCutResType.AttackBox
  elseif unlockType == Const.TriggerType.BanHero then
    config.banHeroIds = {}
    for _, v in ipairs(unlockPara) do
      table.insert(config.banHeroIds, tonumber(v))
    end
  elseif unlockType == Const.TriggerType.CollectRewardMoreThanOneTime then
    config.collectTimeGap = toInt(unlockPara[1])
    config.collectTotalTime = toInt(unlockPara[2] or -1)
    config.speedUpCostType = tonumber(unlockPara2[1] or Const.TriggerClearCDType.TriggerClearCDType_Null)
    config.speedUpCostValue = tonumber(unlockPara2[2] or 0)
    config.bubbleIcon = unlockPara3[1] or ""
  elseif unlockType == Const.TriggerType.ShowModel then
    config.bubbleIcon = unlockPara[1] or ""
    config.bubbleItemIcon = unlockPara2[1] or ""
  elseif unlockType == Const.TriggerType.PVEFactory then
    config.maxBuildingLv = toInt(unlockPara[1])
    config.buildingUpgradeConditions = {}
    for i, s in ipairs(unlockPara2) do
      local tmpVec = string.split(s, ",")
      local conditions = {}
      table.walk(tmpVec, function(_, needStr)
        local need = string.split_ii_array(needStr, ";")
        if #need == 3 then
          local param = {}
          param.type = need[1]
          param.id = need[2]
          param.num = need[3]
          table.insert(conditions, param)
        end
      end)
      table.insert(config.buildingUpgradeConditions, conditions)
    end
    config.productFormula = {}
    for i, s in ipairs(unlockPara3) do
      local levelFormula = string.split_ii_array(s, ";")
      table.insert(config.productFormula, levelFormula)
    end
    config.productQueueNum = {}
    table.walk(unlockPara4, function(_, v)
      table.insert(config.productQueueNum, toInt(v))
    end)
  elseif unlockType == Const.TriggerType.CommitAll then
    for k, v in ipairs(unlockPara) do
      local param = {}
      param.needType = tonumber(v)
      table.insert(config.needBubbleSubmit, param)
    end
    for k, v in ipairs(unlockPara2) do
      if config.needBubbleSubmit[k] ~= nil then
        local spl = string.split_ii_array(v, ";")
        if 1 < #spl then
          config.needBubbleSubmit[k].needId = spl[1]
          config.needBubbleSubmit[k].needCount = spl[2] or 1
        end
      end
    end
    config.type = Const.TriggerType.CommitAll
    if unlockPara3 ~= nil and 0 < table.count(unlockPara3) then
      config.gotoTriggerIds = unlockPara3
    end
    config.canBuy = unlockPara4 or {}
    if unlockPara5 ~= nil and 0 < table.count(unlockPara5) then
      config.triggerIcon = unlockPara5[1]
    end
  elseif unlockType == Const.TriggerType.GainBuff then
    config.battleBuffId = unlockPara3[1]
  elseif unlockType == Const.TriggerType.HealArmy then
    config.healType = tonumber(unlockPara[1])
    config.healVal = tonumber(unlockPara2[1])
  elseif unlockType == Const.TriggerType.GainArmy then
    for k, v in ipairs(unlockPara) do
      local param = {}
      param.needType = tonumber(v)
      table.insert(config.needBubbleSubmit, param)
    end
    for k, v in ipairs(unlockPara2) do
      if config.needBubbleSubmit[k] ~= nil then
        local spl = string.split_ii_array(v, ";")
        if 1 < #spl then
          config.needBubbleSubmit[k].needId = spl[1]
          config.needBubbleSubmit[k].needCount = spl[2] or 1
        end
      end
    end
    local para3 = string.split(unlockPara3[1], ";")
    if #para3 == 2 then
      config.armsId = tonumber(para3[1])
      config.count = tonumber(para3[2])
    end
  elseif unlockType == Const.TriggerType.HireHero then
    for k, v in ipairs(unlockPara) do
      local param = {}
      param.needType = tonumber(v)
      table.insert(config.needBubbleSubmit, param)
    end
    for k, v in ipairs(unlockPara2) do
      if config.needBubbleSubmit[k] ~= nil then
        local spl = string.split_ii_array(v, ";")
        if 1 < #spl then
          config.needBubbleSubmit[k].needId = spl[1]
          config.needBubbleSubmit[k].needCount = spl[2] or 1
        end
      end
    end
    config.battleBuffId = tonumber(unlockPara3[1])
    config.heroData = HeroUtils.GetHireHeroDataByBattleBuff(config.battleBuffId)
  elseif unlockType == Const.TriggerType.CommitLvPoint then
    config.needLvPoint = tonumber(unlockPara[1]) or 0
  elseif unlockType == Const.TriggerType.MonsterWithHp then
    config.monsterId = tonumber(unlockPara[1]) or 0
    local spls = string.split(unlockPara2[1] or "", ";")
    if #spls == 3 then
      config.monsterName = tonumber(spls[1])
      config.monsterLevel = tonumber(spls[2])
      config.monsterRarity = tonumber(spls[3])
    end
  elseif unlockType == Const.TriggerType.BombArea then
    config.attackCount = tonumber(unlockPara[1]) or 0
    config.attackCd = tonumber(unlockPara[2]) or 0
    config.warningTime = tonumber(unlockPara[3]) or 0
    str = tostring(unlockPara[4]) or ""
    local spls = string.split(str, ";")
    if #spls == 2 then
      config.radiusMin = tonumber(spls[1])
      config.radiusMax = tonumber(spls[2])
    end
    config.enterRadius = config.transform.s.x / 2
    config.buffId = tonumber(unlockPara2[1]) or 0
    config.endTriggerId = tonumber(unlockPara3[1]) or 0
  elseif unlockType == Const.TriggerType.TrapMine then
    config.warningTime = tonumber(unlockPara[1]) or 0
    config.enterRadius = tonumber(unlockPara[2]) or 0
    config.attackRadius = tonumber(unlockPara[3]) or 0
    config.buffId = tonumber(unlockPara2[1]) or 0
  elseif unlockType == Const.TriggerType.Teleport then
  elseif unlockType == Const.TriggerType.GotoOtherPve then
    config.gotoLevelId = tonumber(unlockPara[1])
    config.pveEntrance = tonumber(unlockPara2[1])
  elseif unlockType == Const.TriggerType.Portal then
    config.targetPos = {x = 0, y = 0}
    str = tostring(unlockPara[1]) or ""
    local spls = string.split(str, ",")
    if #spls == 2 then
      config.targetPos.x = tonumber(spls[1])
      config.targetPos.y = tonumber(spls[2])
    end
    config.targetRot = tonumber(unlockPara2[1]) or 0
    config.endTriggerId = tonumber(unlockPara3[1]) or 0
  end
  str = row:getValue("ShowPos")
  if str ~= nil then
    local ss = string.split_ff_array(str, ",")
    if #ss == 2 then
      config.showPos = Vector2.New(ss[1], ss[2])
    end
  end
  config.preTriggers = nil
  str = row:getValue("ConditionID")
  if str ~= nil then
    config.preTriggers = string.split_ii_array(str, ";")
  end
  config.guideId = row:getValue("Noviceboot")
  local specialTag = row:getValue("SpecialTag")
  config.specialTag = specialTag == nil and Const.SpecialTag.No or tonumber(specialTag)
  local rotation = row:getValue("JsRotation")
  config.rotation = tonumber(rotation)
  local sideQuest = tonumber(row:getValue("SideQuest")) or 0
  config.sideQuest = sideQuest
  local expReward = tonumber(row:getValue("exp_reward")) or 0
  config.expReward = expReward
  local energy_cost = row:getValue("energy_cost")
  if energy_cost == nil or energy_cost == "" then
    config.energy_cost = 0
  else
    config.energy_cost = tonumber(energy_cost)
  end
  local trigger_type = row:getValue("trigger_type")
  if trigger_type == nil or trigger_type == "" then
    config.trigger_type = Const.TriggerBubbleType.Direct
  else
    config.trigger_type = tonumber(trigger_type)
  end
  config.model_name = row:getValue("ModelName")
  config.name = row:getValue("name") or ""
  config.description = row:getValue("description") or ""
  local animation = row:getValue("Animation")
  if animation ~= nil and animation ~= "" then
    local spl = string.split_ss_array(animation, ";")
    if spl[1] ~= nil then
      config.animation = spl[1]
    end
    if spl[2] ~= nil then
      config.animationTime = tonumber(spl[2])
    end
  end
  local BubbleDisplay = row:getValue("BubbleDisplay")
  config.bubbleDisplayRange = 2
  config.bubbleShowRange = 2
  if BubbleDisplay ~= nil and BubbleDisplay ~= "" then
    local spl = string.split_ii_array(BubbleDisplay, ";")
    if spl[1] ~= nil then
      config.bubbleDisplayRange = spl[1]
    end
    if spl[2] ~= nil then
      config.bubbleShowRange = spl[2]
    end
  else
  end
  local Timeline = row:getValue("Timeline")
  if Timeline ~= nil and Timeline ~= "" then
    config.timeline = {}
    local spl = string.split_ss_array(Timeline, "|")
    for k, v in ipairs(spl) do
      local timelineParam = {}
      local spl2 = string.split_ss_array(v, ";")
      if spl2[1] ~= nil then
        timelineParam.path = spl2[1]
      end
      if spl2[2] ~= nil then
        timelineParam.startPlayTime = tonumber(spl2[2]) / 1000
      end
      if spl2[3] ~= nil then
        timelineParam.endPlayTime = timelineParam.startPlayTime + tonumber(spl2[3]) / 1000
      end
      table.insert(config.timeline, timelineParam)
    end
  end
  local Order = row:getValue("Order")
  if Order == nil or Order == "" then
    config.order = 0
  else
    config.order = tonumber(Order)
  end
  config.FollowNpc = row:getValue("FollowNpc")
  config.effectArea = {}
  str = row:getValue("EffectArea") or ""
  for _, s in ipairs(string.split(str, ";")) do
    local spls = string.split(s, ",")
    if #spls == 2 then
      local p = {}
      p.x = tonumber(spls[1])
      p.y = tonumber(spls[2])
      table.insert(config.effectArea, p)
    end
  end
  config.ForceFinish = nil
  str = row:getValue("ForceFinish")
  if str ~= nil then
    config.ForceFinish = string.split_ii_array(str, ";")
  end
  return config
end

function TriggerPoint:NeedOpenTriggerItemBuyPanel()
  if self.config == nil then
    return false
  end
  return self.config.type == Const.TriggerType.CommitResourceItem or self.config.type == Const.TriggerType.CommitGoods or self.config.type == Const.TriggerType.CommitAll or self.config.type == Const.TriggerType.GainArmy or self.config.type == Const.TriggerType.HireHero
end

function TriggerPoint:GetAllNeedRes()
  return self.config.needRes
end

function TriggerPoint:GetAllNeedResItems()
  return self.config.needResItem
end

function TriggerPoint:GetCurrentStateNeedRes()
  return self.config.stateNeedRes[self.advancedBuild:GetCurrState()]
end

function TriggerPoint:GetCurrentBuildState()
  return self.advancedBuild:GetCurrState()
end

function TriggerPoint:GetBuildStateCount()
  return self.advancedBuild:GetStateCount()
end

function TriggerPoint:IsCurrentStateFull()
  local list = self:GetCurrentStateNeedRes()
  if list == nil then
    return true
  end
  local _, total = next(list)
  local give = 0
  for t, _ in pairs(list) do
    give = give + self:GetGiveRes(t)
  end
  return total <= give
end

function TriggerPoint:ChangeBuildState(newState)
  self.advancedBuild:ChangeState(newState)
end

function TriggerPoint:GetGiveRes(t)
  return self.giveRes[t] or 0
end

function TriggerPoint:GiveRes(t, n)
  local num = self.giveRes[t] or 0
  num = num + n
  self.giveRes[t] = num
end

function TriggerPoint:GetCurLvPoint()
  return self.lvPoint or 0
end

function TriggerPoint:SetCurLvPoint(t)
  self.lvPoint = t
end

function TriggerPoint:GetShowPos()
  return self.config.showPos or self.config.pos
end

function TriggerPoint:GetTilePos()
  local pos = self:GetPosition()
  if pos ~= nil then
    return SceneUtils.WorldToTile(pos)
  end
end

function TriggerPoint:GetTag()
  return 0
end

function TriggerPoint:GetTagPara()
  return ""
end

function TriggerPoint:GetObjId()
  return self.triggerId
end

function TriggerPoint:GetCollectExpCount()
  return self.config.collectRes and self.config.collectRes[Const.CommitType.HeroExp] or 0
end

function TriggerPoint:GetMaxBlood()
  return self.config.maxBlood
end

function TriggerPoint:IsFull()
  local list = {}
  if self:IsTypeCommitRes() or self:IsTypeTurret() or self:IsTypeCommitResource() or self:IsTypeCommitResourceItem() then
    list = self.config.needRes
  elseif self:IsTypeCommitLvPoint() then
    return self:GetCurLvPoint() >= self.config.needLvPoint
  end
  for t, need in pairs(list) do
    local give = self:GetGiveRes(t)
    if 0 < need - give then
      return false
    end
  end
  return true
end

function TriggerPoint:GetTriggerId()
  return self.triggerId
end

function TriggerPoint:GetTriggerType()
  return self.config.type
end

function TriggerPoint:HasType(type)
  if self.config.needRes ~= nil then
    for t, need in pairs(self.config.needRes) do
      local resType = Const.UnlockToResType[t]
      if resType == type then
        return true
      end
    end
  end
  return false
end

function TriggerPoint:IsTypeCommitRes()
  return self.config.type == Const.TriggerType.CommitRes
end

function TriggerPoint:IsTypeCommitResource()
  return self.config.type == Const.TriggerType.CommitResource
end

function TriggerPoint:IsTypeCommitResourceItem()
  return self.config.type == Const.TriggerType.CommitResourceItem
end

function TriggerPoint:IsTypeBuyResItem()
  return self.config.type == Const.TriggerType.BuyResItem
end

function TriggerPoint:IsTypeBuyWaitResItem()
  return self.config.type == Const.TriggerType.BuyWaitResItem
end

function TriggerPoint:IsTypeMonster()
  return self.config.type == Const.TriggerType.Monster
end

function TriggerPoint:IsTypeRewardBox()
  return self.config.type == Const.TriggerType.RewardBox
end

function TriggerPoint:IsTypeRewardBoxUI()
  return self.config.type == Const.TriggerType.RewardBoxUI
end

function TriggerPoint:IsTypeAttackBox()
  return self.config.type == Const.TriggerType.AttackBox
end

function TriggerPoint:IsTypeCollectRes()
  return self.config.type == Const.TriggerType.CollectRes
end

function TriggerPoint:IsTypePlayer()
  return self.config.type == Const.TriggerType.Player
end

function TriggerPoint:IsTypeFollowPlayer()
  return self.config.type == Const.TriggerType.FollowPlayer
end

function TriggerPoint:IsTypeArea()
  return self.config.type == Const.TriggerType.Area
end

function TriggerPoint:IsBuff()
  return self.config.type == Const.TriggerType.Buff
end

function TriggerPoint:IsNpc()
  return self.config.type == Const.TriggerType.Npc
end

function TriggerPoint:IsTypeTimeline()
  return self.config.type == Const.TriggerType.Timeline
end

function TriggerPoint:IsTypeAdvancedBuild()
  return self.config.type == Const.TriggerType.AdvancedBuild
end

function TriggerPoint:IsTypeBuyWaitMoveMan()
  return self.config.type == Const.TriggerType.BuyWaitMoveMan
end

function TriggerPoint:IsTypeDiffMonster()
  return self.config.type == Const.TriggerType.DiffMonster
end

function TriggerPoint:IsTypeDiffMonsterEasy()
  return self.config.type == Const.TriggerType.DiffMonsterEasy
end

function TriggerPoint:IsTypeBuffBox()
  return self.config.type == Const.TriggerType.BuffBox
end

function TriggerPoint:IsTypeLevelLimitMonster()
  return self.config.type == Const.TriggerType.LevelLimitMonster
end

function TriggerPoint:IsTypeAdventureSub()
  return self.config.type == Const.TriggerType.AdventureSub
end

function TriggerPoint:IsTypeTurret()
  return self.config.type == Const.TriggerType.Turret
end

function TriggerPoint:IsTypeBanHero()
  return self.config.type == Const.TriggerType.BanHero
end

function TriggerPoint:IsTypeBubbleSubmit()
  return self.config.type == Const.TriggerType.CommitGoods or self.config.type == Const.TriggerType.ShowModel or self.config.type == Const.TriggerType.CollectRewardMoreThanOneTime or self.config.type == Const.TriggerType.CommitAll or self.config.type == Const.TriggerType.GainBuff or self.config.type == Const.TriggerType.HealArmy or self.config.type == Const.TriggerType.GainArmy or self.config.type == Const.TriggerType.HireHero
end

function TriggerPoint:IsTypeShowModel()
  return self.config.type == Const.TriggerType.ShowModel
end

function TriggerPoint:IsTypeEmptyModel()
  return self.config.type == Const.TriggerType.EmptyModel
end

function TriggerPoint:IsTypeCommitLvPoint()
  return self.config.type == Const.TriggerType.CommitLvPoint
end

function TriggerPoint:IsTypeBombArea()
  return self.config.type == Const.TriggerType.BombArea
end

function TriggerPoint:IsTypeTrapMine()
  return self.config.type == Const.TriggerType.TrapMine
end

function TriggerPoint:IsTypeTeleport()
  return self.config.type == Const.TriggerType.Teleport
end

function TriggerPoint:IsTypeGainBuff()
  return self.config.type == Const.TriggerType.GainBuff
end

function TriggerPoint:IsTypeHealArmy()
  return self.config.type == Const.TriggerType.HealArmy
end

function TriggerPoint:IsTypeGainArmy()
  return self.config.type == Const.TriggerType.GainArmy
end

function TriggerPoint:IsTypeHireHero()
  return self.config.type == Const.TriggerType.HireHero
end

function TriggerPoint:IsTypeGotoOtherPve()
  return self.config.type == Const.TriggerType.GotoOtherPve
end

function TriggerPoint:IsTypePortal()
  return self.config.type == Const.TriggerType.Portal
end

function TriggerPoint:GetMonsterId()
  if self.config.type == Const.TriggerType.LevelLimitMonster then
    return PveUtil.GetRecommendLevelLimitMonsterId() or 0
  else
    return self.config.monsterId
  end
end

function TriggerPoint:GetMonsterSpecialType()
  if self.config.type == Const.TriggerType.Monster then
    return self.config.specialFlag
  else
    return 0
  end
end

function TriggerPoint:GetRotation()
  if self.config.rotation then
    return self.config.rotation
  elseif self.config.transform then
    return self.config.transform.r.y
  else
    return 0
  end
end

function TriggerPoint:IsSideQuest()
  return self.config.sideQuest == Const.SideQuestType.Side
end

function TriggerPoint:IsMainQuest()
  return self.config.sideQuest == Const.SideQuestType.Main
end

function TriggerPoint:GetExpReward()
  local effectValue = LuaEntry.Effect:GetGameEffect(EffectDefine.GLOBAL_HERO_EXP_EXTRA_PERCENT)
  local exp = Mathf.Round((self.config.expReward or 0) * (1 + effectValue / 100))
  return exp
end

function TriggerPoint:SetTransformByConfig(transform, offset)
  offset = offset or Vector3.zero
  if self.config.transform then
    local t = self.config.transform.t
    local r = self.config.transform.r
    local s = self.config.transform.s
    transform.position = Vector3.New(t.x, t.y, t.z) + offset
    transform.localRotation = Quaternion.Euler(r.x, r.y, r.z)
    transform.localScale = Vector3.New(s.x, s.y, s.z)
  else
    local p = self:GetPosition()
    transform.position = Vector3.New(p.x, p.y, p.z) + offset
    transform.localRotation = Quaternion.identity
    transform.localScale = Vector3.one
  end
end

function TriggerPoint:GetPosition()
  return self.position
end

function TriggerPoint:GetTerrainPos(pos)
  local maxY = pos.y
  local origin = Vector3.New(pos.x, pos.y + 1000, pos.z)
  local hitCount = Physics.RaycastNonAlloc(origin, Vector3.down, self.hitTerrainInfo, 10000, LayerMask.GetMask("Terrain"))
  if 0 < hitCount then
    for i = 0, hitCount - 1 do
      if maxY < self.hitTerrainInfo[i].point.y then
        maxY = self.hitTerrainInfo[i].point.y
      end
    end
  end
  return Vector3.New(pos.x, maxY, pos.z)
end

function TriggerPoint:CreateObject()
  if self.isVisible and self.viewVisible then
    self:CheckLoadFollowNpc()
    self:CheckLoadBubble()
    self.isPreOk = self:IsPreTriggerOK()
    if self.inst == nil then
      local isInitFinish = self.battleLevel:IsFinishTrigger(self:GetTriggerId())
      local triggerType = self.config.type
      local prefabPath
      if triggerType == Const.TriggerType.Monster then
        prefabPath = "Assets/Main/Prefabs/PVELevel/TriggerMonster.prefab"
      elseif triggerType == Const.TriggerType.RewardBox or triggerType == Const.TriggerType.RewardBoxUI then
        prefabPath = "Assets/Main/Prefabs/PVELevel/RewardBox.prefab"
      elseif triggerType == Const.TriggerType.CommitRes then
        prefabPath = "Assets/Main/Prefabs/PVELevel/TriggerGrid.prefab"
      elseif triggerType == Const.TriggerType.CommitResource then
        prefabPath = "Assets/Main/Prefabs/PVELevel/TriggerGrid.prefab"
      elseif triggerType == Const.TriggerType.CommitResourceItem then
        prefabPath = "Assets/Main/Prefabs/PVELevel/TriggerGrid.prefab"
      elseif triggerType == Const.TriggerType.CommitResourceItem or triggerType == Const.TriggerType.CommitGoods or triggerType == Const.TriggerType.CommitAll then
      elseif triggerType == Const.TriggerType.CollectRes then
        local transCfg = self.config.transform
        if transCfg then
          prefabPath = transCfg.prefab
        else
          prefabPath = "Assets/Main/Prefabs/PVELevel/TriggerHeroExp.prefab"
        end
      elseif triggerType == Const.TriggerType.Player then
        if self.isPreOk then
          self.battleLevel:AddOnePlayer(self.config.playerName, 0, self:GetPosition(), true, true)
        end
        prefabPath = "Assets/Main/Prefabs/PVELevel/OnePlayer.prefab"
      elseif triggerType == Const.TriggerType.FollowPlayer then
        prefabPath = "Assets/Main/Prefabs/PVELevel/OnePlayer.prefab"
      elseif triggerType == Const.TriggerType.Build then
        if self.isPreOk then
          local rot = Vector3.New(0, self:GetRotation(), 0)
          self.battleLevel:AddOneBuild(self:GetPosition(), self.config.buildName, self.config.animName, self.config.buffTriggerList, self.config.triggerDirection, self.config.triggerId, rot)
        end
      elseif triggerType == Const.TriggerType.Buff then
      elseif triggerType == Const.TriggerType.Area then
        prefabPath = "Assets/Main/Prefabs/PVELevel/TriggerArea.prefab"
      elseif triggerType == Const.TriggerType.Npc then
        if self.isPreOk then
          local param = {}
          param.modelName = self.config.npcName
          param.dialogId = self.config.dialogId
          param.posArr = self.config.posArr
          param.animName = self.config.aniName
          param.angle = self.config.angle
          self.battleLevel:AddOneNpc(param)
        end
      elseif triggerType == Const.TriggerType.Timeline then
        prefabPath = "Assets/Main/Prefabs/PVELevel/TriggerTimeline.prefab"
      elseif triggerType == Const.TriggerType.AdvancedBuild then
        prefabPath = "Assets/Main/Prefabs/PVELevel/TriggerBuild.prefab"
      elseif triggerType == Const.TriggerType.DiffMonster then
        prefabPath = "Assets/Main/Prefabs/PVELevel/TriggerMonsterSpecial.prefab"
      elseif triggerType == Const.TriggerType.DiffMonsterEasy then
        prefabPath = "Assets/Main/Prefabs/PVELevel/TriggerMonsterSpecial.prefab"
      elseif triggerType == Const.TriggerType.BuffBox then
        prefabPath = "Assets/Main/Prefabs/PVELevel/RewardBox.prefab"
      elseif triggerType == Const.TriggerType.LevelLimitMonster then
        prefabPath = "Assets/Main/Prefabs/PVELevel/TriggerMonster.prefab"
      elseif triggerType == Const.TriggerType.AdventureSub then
        if self.battleLevel:IsLastTrigger(self.config.triggerId) then
          prefabPath = "Assets/Main/Prefabs/PVELevel/TriggerMonsterSandworm.prefab"
        else
          prefabPath = "Assets/Main/Prefabs/PVELevel/TriggerMonster.prefab"
        end
      elseif triggerType == Const.TriggerType.BuyAttack then
      elseif triggerType == Const.TriggerType.AttackBox then
        prefabPath = "Assets/Main/Prefabs/PVELevel/TriggerAttackBox.prefab"
      elseif triggerType == Const.TriggerType.Turret then
        prefabPath = "Assets/Main/Prefabs/PVELevel/TriggerTurret.prefab"
      elseif triggerType == Const.TriggerType.CommitLvPoint then
        prefabPath = "Assets/Main/Prefabs/PVELevel/TriggerGrid.prefab"
      elseif triggerType == Const.TriggerType.MonsterWithHp then
        prefabPath = "Assets/Main/Prefabs/PVELevel/TriggerMonsterWithHp.prefab"
      elseif triggerType == Const.TriggerType.BombArea then
        prefabPath = "Assets/Main/Prefabs/PVELevel/TriggerArea.prefab"
      elseif triggerType == Const.TriggerType.TrapMine then
        prefabPath = "Assets/Main/Prefabs/PVELevel/TriggerArea.prefab"
      elseif triggerType == Const.TriggerType.Teleport then
        prefabPath = "Assets/Main/Prefabs/PVELevel/TriggerTeleport.prefab"
      elseif triggerType == Const.TriggerType.GotoOtherPve then
        prefabPath = "Assets/Main/Prefabs/PVELevel/TriggerWhiteBlock.prefab"
      elseif triggerType == Const.TriggerType.Portal then
        prefabPath = "Assets/Main/Prefabs/PVELevel/TriggerPortal.prefab"
      elseif triggerType == Const.TriggerType.HireHero then
        prefabPath = "Assets/Main/Prefabs/PVELevel/TriggerHireHero.prefab"
      end
      if self.config.model_name ~= nil and self.config.model_name ~= "" then
        prefabPath = string.format(LoadPath.PVELevel, self.config.model_name)
      end
      if string.IsNullOrEmpty(prefabPath) then
        return
      end
      self.inst = Resource:InstantiateAsync(prefabPath)
      self.inst:completed("+", function(req)
        if req.gameObject ~= nil then
          self.gameObject = req.gameObject
          self.gameObject.name = "Trigger_" .. self:GetTriggerId()
          local transform = req.gameObject.transform
          local state0 = transform:Find("state0")
          self.isPreOk = self:IsPreTriggerOK()
          if self.isPreOk or state0 ~= nil then
            if self.config.type == Const.TriggerType.Monster then
              self:SetTransformByConfig(transform, Vector3.New(0, 0.1, 0))
              if self.config.rotation then
                transform.localRotation = Quaternion.Euler(0, self.config.rotation, 0)
              end
              self.monsterGrid = transform:Find("O_env_place").gameObject
              self.monsterGrid:SetActive(self.monsterLevelVisible)
              self.monster = TriggerPointMonster.New()
              self.monster:Create(transform:Find("pve_js").gameObject, self:GetMonsterId(), self:GetRotation())
              self.monster:SetVisible(self.isVisible)
              self.monster:SetLevelVisible(self.monsterLevelVisible)
            elseif self.config.type == Const.TriggerType.RewardBox or self.config.type == Const.TriggerType.RewardBoxUI then
              self:SetTransformByConfig(transform)
              if self.isVisible then
                DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_pve_box_appear, false)
              end
              self.appearAnim = transform:Find("Model/VFX_baoxiang_scene/V_baoxiang_scene_show_timeline"):GetComponent(typeof(CS.UnityEngine.Playables.PlayableDirector))
              self.rewardBoxOpen = transform:Find("Model/VFX_baoxiang_scene/V_baoxiang_scene_open_timeline"):GetComponent(typeof(CS.UnityEngine.Playables.PlayableDirector))
              if self.isVisible then
                self:PlayAppearAnim()
              end
            elseif self.config.type == Const.TriggerType.CommitRes then
              self:SetTransformByConfig(transform, Vector3.New(0, 0.1, 0))
              self.textObj = transform:Find("TriggerText").gameObject
              self.textObj:SetActive(true)
              local showPos = self:GetShowPos()
              if showPos then
                local p = SceneUtils.TileToWorld(showPos)
                p = self:GetTerrainPos(p)
                self.textObj.transform:Set_position(p.x, p.y, p.z)
              end
              local faceCameraNode = self.textObj.transform:Find("face_camera")
              faceCameraNode.localScale = Vector3.one
              self.numItem = {}
              for i = 1, ResTypeCount do
                local lineNode = self.textObj.transform:Find("face_camera/Line" .. i)
                self.numItem[#self.numItem + 1] = {
                  node = lineNode.gameObject,
                  numText = lineNode:GetComponentInChildren(UnityTextMeshPro, true),
                  iconSpr = lineNode:GetComponentInChildren(TypeOfSpriteRenderer, true)
                }
              end
              self:RefreshText()
              local gridTrans = transform:Find("O_env_place")
              gridTrans.gameObject:SetActive(true)
              self.triggerAni = gridTrans:GetComponentInChildren(typeof(CS.SimpleAnimation))
              self:PlayScaleDown()
            elseif self.config.type == Const.TriggerType.CommitResource then
              self:SetTransformByConfig(transform, Vector3.New(0, 0.1, 0))
              local TriggerText = transform:Find("TriggerText")
              if TriggerText ~= nil then
                self.textObj = TriggerText.gameObject
                self.textObj:SetActive(true)
                local showPos = self:GetShowPos()
                if showPos then
                  local p = SceneUtils.TileToWorld(showPos)
                  p = self:GetTerrainPos(p)
                  self.textObj.transform:Set_position(p.x, p.y, p.z)
                end
                local faceCameraNode = self.textObj.transform:Find("face_camera")
                faceCameraNode.localScale = Vector3.one
                self.numItem = {}
                for i = 1, ResTypeCount do
                  local lineNode = self.textObj.transform:Find("face_camera/Line" .. i)
                  self.numItem[#self.numItem + 1] = {
                    node = lineNode.gameObject,
                    numText = lineNode:GetComponentInChildren(UnityTextMeshPro, true),
                    iconSpr = lineNode:GetComponentInChildren(TypeOfSpriteRenderer, true)
                  }
                end
                self:RefreshText()
              end
              local gridTrans = transform:Find("O_env_place")
              if gridTrans ~= nil then
                gridTrans.gameObject:SetActive(true)
                self.triggerAni = gridTrans:GetComponentInChildren(typeof(CS.SimpleAnimation))
                self:PlayScaleDown()
              end
            elseif self.config.type == Const.TriggerType.CommitResourceItem then
              self:SetTransformByConfig(transform, Vector3.New(0, 0.1, 0))
              local TriggerText = transform:Find("TriggerText")
              if TriggerText ~= nil then
                self.textObj = TriggerText.gameObject
                self.textObj:SetActive(true)
                local showPos = self:GetShowPos()
                if showPos then
                  local p = SceneUtils.TileToWorld(showPos)
                  p = self:GetTerrainPos(p)
                  self.textObj.transform:Set_position(p.x, p.y, p.z)
                end
                local faceCameraNode = self.textObj.transform:Find("face_camera")
                faceCameraNode.localScale = Vector3.one
                self.numItem = {}
                for i = 1, ResTypeCount do
                  local lineNode = self.textObj.transform:Find("face_camera/Line" .. i)
                  self.numItem[#self.numItem + 1] = {
                    node = lineNode.gameObject,
                    numText = lineNode:GetComponentInChildren(UnityTextMeshPro, true),
                    iconSpr = lineNode:GetComponentInChildren(TypeOfSpriteRenderer, true)
                  }
                end
                self:RefreshText()
              end
              local gridTrans = transform:Find("O_env_place")
              if gridTrans ~= nil then
                gridTrans.gameObject:SetActive(true)
                self.triggerAni = gridTrans:GetComponentInChildren(typeof(CS.SimpleAnimation))
                self:PlayScaleDown()
              end
            elseif self.config.type == Const.TriggerType.CommitResourceItem or self.config.type == Const.TriggerType.CommitGoods then
              self:SetTransformByConfig(transform, Vector3.New(0, 0.1, 0))
              local gridTrans = transform:Find("O_env_place")
              if gridTrans ~= nil then
                gridTrans.gameObject:SetActive(true)
                self.triggerAni = gridTrans:GetComponentInChildren(typeof(CS.SimpleAnimation))
                self:PlayScaleDown()
              end
            elseif self.config.type == Const.TriggerType.CollectRes then
              local origPos
              local transCfg = self.config.transform
              if transCfg then
                transform:Set_position(transCfg.t.x, transCfg.t.y, transCfg.t.z)
                transform.localRotation = Quaternion.Euler(transCfg.r.x, transCfg.r.y, transCfg.r.z)
                transform.localScale = Vector3.New(transCfg.s.x, transCfg.s.y, transCfg.s.z)
                origPos = SceneUtils.TileToWorld(SceneUtils.WorldToTile(transCfg.t))
              else
                origPos = self:GetPosition()
                transform:Set_position(origPos.x, origPos.y, origPos.z)
                transform.localRotation = Quaternion.identity
                local scale = 1
                local triggerSize = self.battleLevel:GetTriggerExpSize()
                if triggerSize then
                  scale = triggerSize.min + (triggerSize.max - triggerSize.min) * math.random()
                end
                transform.localScale = Vector3.New(scale, scale, scale)
              end
              self.collectionPoint = TriggerPointCollection.New(self, origPos)
              self.collectionPoint:BindGameObject(self.gameObject)
            elseif self.config.type == Const.TriggerType.Player then
              self:SetTransformByConfig(transform)
            elseif self.config.type == Const.TriggerType.FollowPlayer then
              self:SetTransformByConfig(transform)
            elseif self.config.type == Const.TriggerType.Area then
              self:SetTransformByConfig(transform)
              self.triggerEnterDistance = self.config.areaRadius
            elseif self.config.type == Const.TriggerType.Timeline then
              self:SetTransformByConfig(transform)
              self.timelineInst = Resource:InstantiateAsync("Assets/Main/Prefabs/PVELevel/" .. self.config.timelinePath .. ".prefab")
              self.timelineInst:completed("+", function()
                local p = self:GetPosition()
                local timelineTrans = self.timelineInst.gameObject.transform
                timelineTrans:Set_position(p.x, p.y, p.z)
                timelineTrans.localRotation = Quaternion.identity
                local timeline = self.timelineInst.gameObject:GetComponentInChildren(typeof(CS.UnityEngine.Playables.PlayableDirector))
                if timeline then
                  timeline.time = 0
                  timeline:Stop()
                end
              end)
            elseif self.config.type == Const.TriggerType.AdvancedBuild then
              self:SetTransformByConfig(transform)
              self.advancedBuild = TriggerPointBuild.New(self)
              self.advancedBuild:Create(self.config.buildName, function()
                self:RefreshText()
              end)
              self.textObj = transform:Find("TriggerText").gameObject
              self.textObj:SetActive(true)
              self.slider = {
                progress = transform:Find("TriggerText/Canvas/SliderGo/Slider"):GetComponent(TypeOfSlider),
                label = transform:Find("TriggerText/Canvas/SliderGo/SliderText"):GetComponent(TypeOfText)
              }
              self:RefreshText()
            elseif self.config.type == Const.TriggerType.DiffMonster then
              self:SetTransformByConfig(transform)
              self.monsterGrid = transform:Find("O_env_place").gameObject
              self.monsterGrid:SetActive(true)
              self.monster = TriggerPointMonster.New()
              self.monster:Create(transform:Find("pve_js").gameObject, self:GetMonsterId(), self:GetRotation())
              self.monster:HideHeroLevel()
              self.monster:SetVisible(self.isVisible)
            elseif self.config.type == Const.TriggerType.BuffBox then
              self:SetTransformByConfig(transform)
              if self.isVisible then
                DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_pve_box_appear, false)
              end
            elseif self.config.type == Const.TriggerType.LevelLimitMonster then
              self:SetTransformByConfig(transform)
              self.monsterGrid = transform:Find("O_env_place").gameObject
              self.monsterGrid:SetActive(true)
              self.monster = TriggerPointMonster.New()
              self.monster:Create(transform:Find("pve_js").gameObject, self:GetMonsterId(), self:GetRotation())
              self.monster:HideHeroLevel()
              self.monster:SetVisible(self.isVisible)
            elseif self.config.type == Const.TriggerType.AdventureSub then
              self:SetTransformByConfig(transform)
              self.monsterGrid = transform:Find("O_env_place").gameObject
              self.monsterGrid:SetActive(true)
              if self.battleLevel:IsLastTrigger(self.config.triggerId) then
                self.sandwormGo = transform:Find("Sandworm").gameObject
                self.sandwormGo:SetActive(true)
              else
                self.monster = TriggerPointMonster.New()
                self.monster:Create(transform:Find("pve_js").gameObject, self:GetMonsterId(), self:GetRotation())
                self.monster:HideHeroLevel()
                self.monster:SetVisible(self.isVisible)
                if DataCenter.AdventureManager:CanTriggerShowArrow(self:GetTriggerId()) then
                  local tf = self.monsterGrid.transform:Find("WorldYellowArrow")
                  if tf == nil then
                    local r = Resource:InstantiateAsync("Assets/Main/Prefabs/Guide/WorldYellowArrow.prefab")
                    r:completed("+", function()
                      if r.isError then
                        return
                      end
                      local go = r.gameObject
                      tf = go.transform
                      go:SetActive(true)
                      go.name = "WorldYellowArrow"
                      tf:SetParent(self.monsterGrid.transform)
                      tf:Set_localScale(0.5, 0.5, 0.5)
                      tf:Set_localPosition(0, 1, 0)
                    end)
                  else
                    tf.gameObject:SetActive(true)
                  end
                else
                  local tf = self.monsterGrid.transform:Find("WorldYellowArrow")
                  if tf ~= nil then
                    tf.gameObject:SetActive(false)
                  end
                end
              end
            elseif self.config.type == Const.TriggerType.DiffMonsterEasy then
              self:SetTransformByConfig(transform)
              self.monsterGrid = transform:Find("O_env_place").gameObject
              self.monsterGrid:SetActive(true)
              self.monster = TriggerPointMonster.New()
              self.monster:Create(transform:Find("pve_js").gameObject, self:GetMonsterId(), self:GetRotation())
              self.monster:HideHeroLevel()
              self.monster:SetVisible(self.isVisible)
            elseif self.config.type == Const.TriggerType.AttackBox then
              self.collectionPoint = TriggerPointAttackBox.New()
              self.collectionPoint:OnCreate(self.inst)
              local param = {}
              param.pos = self:GetPosition()
              param.objId = self.triggerId
              param.resType = Const.CityCutResType.AttackBox
              param.blood = self.config.blood
              param.isInitFinish = isInitFinish
              self.collectionPoint:ReInit(param)
              self:SetTransformByConfig(self.collectionPoint.transform)
            elseif self.config.type == Const.TriggerType.Turret then
              self:SetTransformByConfig(transform)
              self.turret = TriggerPointTurret.New()
              self.turret:Create(self, self.gameObject, self.config.attack, self.config.maxBlood, self.config.attackRadius)
            elseif self.config.type == Const.TriggerType.CollectRewardMoreThanOneTime then
              self:SetTransformByConfig(transform, Vector3.New(0, 0.1, 0))
              self.collectRewardStateCanGet = transform:Find("state1").gameObject
              self.collectRewardStateWait = transform:Find("state2").gameObject
              self:RefreshRewardState()
            elseif self.config.type == Const.TriggerType.PVEFactory then
              self:SetTransformByConfig(transform, Vector3.New(0, 0.1, 0))
              self.freeEffect = TriggerPointFactory.New()
              self.freeEffect:Create(self, self.gameObject)
            elseif self.config.type == Const.TriggerType.MonsterWithHp then
              self:SetTransformByConfig(transform, Vector3.New(0, 0.1, 0))
              if self.config.rotation then
                transform.localRotation = Quaternion.Euler(0, self.config.rotation, 0)
              end
              self.monsterGrid = transform:Find("O_env_place").gameObject
              self.monsterGrid:SetActive(true)
              self.monsterHp = TriggerPointMonsterWithHp.New()
              self.monsterHp:Create(self.gameObject, transform:Find("pve_js").gameObject, self)
              local data = DataCenter.BattleLevel:GetMonsterDataByTriggerId(self.triggerId)
              if data ~= nil then
                self:RefreshMonsterHp(data.health, data.initHealth)
              else
                self:RefreshMonsterHp(100, 100)
              end
            elseif self.config.type == Const.TriggerType.ShowModel then
              self.showModel = TriggerPointShowModel.New()
              self.showModel:OnCreate(self.inst)
              local param = {}
              param.pos = self:GetPosition()
              param.triggerData = self
              param.isInitFinish = isInitFinish
              param.isPreOk = self.isPreOk
              self.showModel:ReInit(param)
              if self.showModel ~= nil then
                self:SetTransformByConfig(self.showModel.transform)
              end
            elseif self.config.type == Const.TriggerType.CommitLvPoint then
              self:SetTransformByConfig(transform, Vector3.New(0, 0.1, 0))
              self.textObj = transform:Find("TriggerText").gameObject
              self.textObj:SetActive(true)
              local showPos = self:GetShowPos()
              if showPos then
                local p = SceneUtils.TileToWorld(showPos)
                p = self:GetTerrainPos(p)
                self.textObj.transform:Set_position(p.x, p.y, p.z)
              end
              local faceCameraNode = self.textObj.transform:Find("face_camera")
              faceCameraNode.localScale = Vector3.one
              self.numItem = {}
              for i = 1, ResTypeCount do
                local lineNode = self.textObj.transform:Find("face_camera/Line" .. i)
                self.numItem[#self.numItem + 1] = {
                  node = lineNode.gameObject,
                  numText = lineNode:GetComponentInChildren(UnityTextMeshPro, true),
                  iconSpr = lineNode:GetComponentInChildren(TypeOfSpriteRenderer, true)
                }
              end
              self:RefreshText()
              local gridTrans = transform:Find("O_env_place")
              gridTrans.gameObject:SetActive(true)
              self.triggerAni = gridTrans:GetComponentInChildren(typeof(CS.SimpleAnimation))
              self:PlayScaleDown()
            elseif self.config.type == Const.TriggerType.BombArea then
              self:SetTransformByConfig(transform)
            elseif self.config.type == Const.TriggerType.TrapMine then
              self:SetTransformByConfig(transform)
            elseif self.config.type == Const.TriggerType.CommitAll then
              local gridTrans = transform:Find("O_env_place")
              if gridTrans ~= nil then
                gridTrans.gameObject:SetActive(true)
                self.triggerAni = gridTrans:GetComponentInChildren(typeof(CS.SimpleAnimation))
                self:PlayScaleDown()
              end
              self.showModel = TriggerPointShowModel.New()
              self.showModel:OnCreate(self.inst)
              local param = {}
              param.pos = self:GetPosition()
              param.triggerData = self
              param.isInitFinish = isInitFinish
              param.isPreOk = self.isPreOk
              self.showModel:ReInit(param)
              if self.showModel ~= nil then
                self:SetTransformByConfig(self.showModel.transform)
              end
            elseif self.config.type == Const.TriggerType.GainBuff then
              self:SetTransformByConfig(transform)
            elseif self.config.type == Const.TriggerType.HealArmy then
              self:SetTransformByConfig(transform)
            elseif self.config.type == Const.TriggerType.GainArmy then
              self:SetTransformByConfig(transform)
            elseif self.config.type == Const.TriggerType.HireHero then
              self:SetTransformByConfig(transform)
              self.hireHero = TriggerPointHireHero.New(self)
              self.hireHero:Create(transform)
            elseif self.config.type == Const.TriggerType.EmptyModel then
              self.showModel = TriggerPointShowModel.New()
              self.showModel:OnCreate(self.inst)
              local param = {}
              param.pos = self:GetPosition()
              param.triggerData = self
              param.isInitFinish = isInitFinish
              param.isPreOk = self.isPreOk
              self.showModel:ReInit(param)
              if self.showModel ~= nil then
                self:SetTransformByConfig(self.showModel.transform)
              end
            elseif self.config.type == Const.TriggerType.Teleport then
              self:SetTransformByConfig(transform)
              self.teleport = TriggerTeleport.New(self.inst)
              self.teleport:Create()
            elseif self.config.type == Const.TriggerType.GotoOtherPve then
              self:SetTransformByConfig(transform)
              local gridTrans = transform:Find("O_env_place")
              if gridTrans ~= nil then
                gridTrans.gameObject:SetActive(true)
                self.triggerAni = gridTrans:GetComponentInChildren(typeof(CS.SimpleAnimation))
                self:PlayScaleDown()
              end
            elseif self.config.type == Const.TriggerType.Portal then
              self:SetTransformByConfig(transform)
            end
            if self.gameObject ~= nil then
              self:AddTimelineComponent()
              self.gameObject:SetActive(self.isVisible)
            end
          else
            self:DestroyObject()
          end
        end
      end)
    elseif self.showModel ~= nil then
      self.showModel:SwitchNextState()
    end
  end
end

function TriggerPoint:DestroyObject()
  if self.inst ~= nil then
    self.inst:Destroy()
    self.inst = nil
  end
end

function TriggerPoint:GetTypePosition(type)
  local i = self:GetTypeIndex(type)
  if i and self.numItem[i] ~= nil then
    local item = self.numItem[i]
    if item.iconSpr then
      return Vector3.New(item.iconSpr.gameObject.transform:Get_position())
    end
  end
  return Vector3.New(self.textObj.transform:Get_position())
end

function TriggerPoint:PlayScaleUp()
  if self.triggerAni and not self.triggerAni:IsPlaying("xiaoshi") then
    self.triggerAni:Play("fangda")
  end
end

function TriggerPoint:PlayScaleDown()
  if self.triggerAni and not self.triggerAni:IsPlaying("xiaoshi") then
    self.triggerAni:Play("suoxiao")
  end
end

function TriggerPoint:PlayTextHideAni()
  if self.textObj == nil then
    return
  end
  local faceCameraNode = self.textObj.transform:Find("face_camera")
  if faceCameraNode ~= nil then
    DOTween.Kill(faceCameraNode.transform)
    faceCameraNode.transform:DOScale(Vector3.zero, 0.5):OnComplete(function()
      self.textObj:SetActive(false)
    end):SetEase(CS.DG.Tweening.Ease.InCubic)
  else
    self.textObj:SetActive(false)
  end
end

function TriggerPoint:PlayRewardBoxOpen(onComplete)
  if self.rewardBoxOpen then
    self.rewardBoxOpen.time = 0
    self.rewardBoxOpen:Play()
    self.rewardBoxOpenTimer = TimerManager:GetInstance():DelayInvoke(function()
      self.rewardBoxOpenTimer = nil
      if onComplete then
        onComplete()
      end
    end, 1)
  end
end

function TriggerPoint:PlayAppearAnim()
  if self.appearAnim then
    self.appearAnim.time = 0
    self.appearAnim:Play()
    if self.config.type == Const.TriggerType.RewardBox or self.config.type == Const.TriggerType.BuffBox or self.config.type == Const.TriggerType.AttackBox then
      DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_pve_box_appear, false)
    end
  end
end

function TriggerPoint:GetVisible()
  return self.isVisible
end

function TriggerPoint:SetVisible(visible)
  if self.isVisible ~= visible then
    self.isVisible = visible
    self:CheckCreateDoTrigger()
    if self.viewVisible then
      self:CheckCreateObj(visible)
    end
  end
end

function TriggerPoint:CheckCreateDoTrigger()
  if self.isVisible and not self.config.isCreateOne and self:IsPreTriggerOK() then
    self.config.isCreateOne = true
    if self.config.type == Const.TriggerType.Build or self.config.type == Const.TriggerType.FollowPlayer or self.config.type == Const.TriggerType.Npc or self.config.type == Const.TriggerType.SelectBuff or self.config.type == Const.TriggerType.AutoFinish then
      self.battleLevel:DoTrigger(self)
    end
  end
end

function TriggerPoint:CheckCreateObj(visible)
  self:SetBubbleVisible(visible)
  if visible then
    self:CreateObject()
  else
    self:HideHighlightItem()
    self:DestroyBubble()
    self:DestroyObject()
    self:DestroyLoadObject()
  end
end

function TriggerPoint:SetMonsterLevelVisible(visible)
  self.monsterLevelVisible = visible
  if self.monster then
    if self.config.type == Const.TriggerType.AdventureSub then
      self.monster:SetVisible(visible)
    else
      self.monster:SetLevelVisible(visible)
    end
  end
  if self.monsterGrid then
    self.monsterGrid:SetActive(visible)
  end
  if self.sandwormGo then
    self.sandwormGo:SetActive(visible)
  end
end

function TriggerPoint:SetTriggerOK(ok)
  self.isTriggerOK = ok
  if ok then
    self.battleLevel:UnlockAreaFog(self:GetTriggerId())
  else
    self.battleLevel:SetLockAreaFog(self:GetTriggerId())
  end
end

function TriggerPoint:IsTriggerOK()
  return self.isTriggerOK
end

function TriggerPoint:GetFirstPreTriggerId()
  if self.config.preTriggers and #self.config.preTriggers > 0 then
    return self.config.preTriggers[1]
  end
end

function TriggerPoint:IsPreTriggerOK()
  if self.config.preTriggers then
    for _, t in ipairs(self.config.preTriggers) do
      if t <= 0 then
        return false
      end
      local trigger = self.battleLevel:GetTriggerByTriggerId(t)
      if trigger and not trigger:IsTriggerOK() then
        return false
      end
    end
  end
  return true
end

function TriggerPoint:DoWhenTriggerRewardBack()
  if self.triggerBubble ~= nil then
    self.triggerBubble:DoTouchBubbleClick()
  end
end

function TriggerPoint:OnPreTriggerOK()
  if self.isPreOk ~= true then
    self.isPreOk = true
    if self.battleLevel:CanShowTrigger(self.triggerId) then
      self:CheckCreateDoTrigger()
      self:CheckCreateObj(true)
      self:PlayAppearAnim()
      if self:IsTypeMonster() then
        self:SetMonsterLevelVisible(true)
      elseif self:IsTypeTurret() then
        self.turret:OnPreTriggerOK()
      end
    end
  end
end

function TriggerPoint:TriggerOK()
  self:HideBubble()
  TimerManager:GetInstance():DelayInvoke(function()
    self:DestroyBubble()
  end, 0.5)
  self.isTriggerOK = true
  if self:IsTypeCommitRes() then
    self:PlayTextHideAni()
    if self.triggerAni then
      self.triggerAni:Play("xiaoshi")
    end
    self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
      self.delayTimer = nil
      self:SetVisible(false)
    end, 1)
  elseif self:IsTypeCommitResource() then
    self:PlayTextHideAni()
    if self.triggerAni then
      self.triggerAni:Play("xiaoshi")
    end
    self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
      self.delayTimer = nil
      self:SetVisible(false)
    end, 1)
    for k, v in pairs(self.giveRes) do
      self.battleLevel:ChangeSubmitResource(k, -v)
    end
  elseif self:IsTypeCommitResourceItem() then
    self:PlayTextHideAni()
    if self.triggerAni then
      self.triggerAni:Play("xiaoshi")
    end
    self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
      self.delayTimer = nil
      self:SetVisible(false)
    end, 1)
    for k, v in pairs(self.giveRes) do
      self.battleLevel:ChangeSubmitResourceItem(k, -v)
    end
  elseif self.config.type == Const.TriggerType.RewardBoxUI then
    local battleLevel = self.battleLevel
    local player = battleLevel:GetPlayer()
    player:PauseCameraFollow()
  elseif self.config.type == Const.TriggerType.RewardBox then
    self:SetVisible(false)
  elseif self.config.type == Const.TriggerType.AttackBox then
    local time = self.collectionPoint:GetOpenAnimTime()
    if time ~= nil and 0 < time then
      self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
        self.delayTimer = nil
        self:SetVisible(false)
      end, 1)
    else
      self:SetVisible(false)
    end
  elseif self.config.type == Const.TriggerType.Monster then
    self:SetVisible(false)
  elseif self.config.type == Const.TriggerType.Player then
    self:SetVisible(false)
    self.battleLevel:ChangeSubPlayerToFollow(self.config.playerName, self:GetPosition())
  elseif self.config.type == Const.TriggerType.FollowPlayer then
    self:SetVisible(false)
    if self.followPlayerObjId then
      local followPlayer = self.battleLevel:GetObj(self.followPlayerObjId)
      if followPlayer then
        followPlayer:BeRescued()
      end
    end
  elseif self.config.type == Const.TriggerType.Build then
    local rot = Vector3.New(0, self:GetRotation(), 0)
    self.battleLevel:AddOneBuild(self:GetPosition(), self.config.buildName, self.config.animName, self.config.buffTriggerList, self.config.triggerDirection, self.config.triggerId, rot)
  elseif self.config.type == Const.TriggerType.Buff then
    self:SetVisible(false)
    self.battleLevel:AddBuffById(self.config.buffId)
  elseif self.config.type == Const.TriggerType.Area then
    self:SetVisible(false)
  elseif self.config.type == Const.TriggerType.Npc then
    self:SetVisible(false)
    local param = {}
    param.modelName = self.config.npcName
    param.dialogId = self.config.dialogId
    param.posArr = self.config.posArr
    param.animName = self.config.aniName
    param.angle = self.config.angle
    self.battleLevel:AddOneNpc(param)
  elseif self.config.type == Const.TriggerType.Timeline then
    local timeline = self.timelineInst.gameObject:GetComponentInChildren(typeof(CS.UnityEngine.Playables.PlayableDirector))
    timeline.time = 0
    timeline:Play()
    self.battleLevel:GetPlayer():PauseCameraFollow()
    self.battleLevel:AutoLookat(self:GetPosition(), Const.LevelCameraHeight, 2)
    self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
      self.delayTimer = nil
      timeline:Stop()
      self:SetVisible(false)
      self.battleLevel:GetPlayer():ResumeCameraFollow()
      self.timelineInst:Destroy()
      self.timelineInst = nil
    end, self.config.timelineLen)
  elseif self.config.type == Const.TriggerType.SelectBuff then
    self:SetVisible(false)
    if self.config.selectBuff ~= nil then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIPVESelectBuff, {anim = true}, self.config.selectBuff)
    end
  elseif self.config.type == Const.TriggerType.AdvancedBuild then
    self:PlayTextHideAni()
    if self.triggerAni then
      self.triggerAni:Play("xiaoshi")
    end
  elseif self.config.type == Const.TriggerType.AutoFinish then
    self:SetVisible(false)
  elseif self.config.type == Const.TriggerType.DiffMonster then
    self:SetVisible(false)
  elseif self.config.type == Const.TriggerType.BuffBox then
    self:SetVisible(false)
    if self.config.selectBuff ~= nil then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIPVESelectBattleBuff, {anim = true}, self.config.selectBuff, self.config.triggerId)
    end
  elseif self.config.type == Const.TriggerType.LevelLimitMonster then
    self:SetVisible(false)
  elseif self.config.type == Const.TriggerType.AdventureSub then
    self:SetVisible(false)
  elseif self.config.type == Const.TriggerType.DiffMonsterEasy then
    self:SetVisible(false)
  elseif self.config.type == Const.TriggerType.Turret then
  elseif self.config.type == Const.TriggerType.BanHero then
    for _, heroId in ipairs(self.config.banHeroIds) do
      self.battleLevel.heroMgr:BanHero(heroId)
    end
  elseif self:IsTypeShowModel() then
    if self.showModel == nil then
      self:SetVisible(false)
    else
      self.showModel:SwitchNextState()
    end
  elseif self:IsTypeEmptyModel() then
    if self.showModel == nil then
      self:SetVisible(false)
    else
      self.showModel:SwitchNextState()
    end
  elseif self.config.type == Const.TriggerType.CommitAll then
    if self:CanDoTrigger() then
      if self.showModel == nil then
        self:SetVisible(false)
      else
        self.showModel:SwitchNextState()
      end
    end
  elseif self.config.type == Const.TriggerType.GainBuff then
    self.battleLevel:DoTriggerAnimation(self, 1)
    if self:CanDoTrigger() then
      if self.showModel == nil then
        self:SetVisible(false)
      else
        self.showModel:SwitchNextState()
      end
    end
    if self.config.battleBuffId ~= nil then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIPVEGainBuff, self.config.battleBuffId)
      SFSNetwork.SendMessage(MsgDefines.ChoosePveBuff, DataCenter.BattleLevel.levelId, self.config.triggerId, 1)
    end
  elseif self.config.type == Const.TriggerType.HealArmy then
  elseif self.config.type == Const.TriggerType.GainArmy then
  elseif self.config.type == Const.TriggerType.HireHero then
    self.hireHero:Destroy()
    self:SetVisible(false)
  elseif self:IsTypeBubbleSubmit() then
    self:SetVisible(false)
  elseif self:ISCollectRewardMoreThanOneTime() then
    self.collectRewardStateWait.gameObject:SetActive(true)
    self.collectRewardStateCanGet.gameObject:SetActive(false)
  elseif self:IsTypeCommitLvPoint() then
    self:PlayTextHideAni()
    if self.triggerAni then
      self.triggerAni:Play("xiaoshi")
    end
    self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
      self.delayTimer = nil
      self:SetVisible(false)
    end, 1)
  elseif self.config.type == Const.TriggerType.BombArea then
    self.bombArea:Destroy()
    self:SetVisible(false)
  elseif self.config.type == Const.TriggerType.TrapMine then
    self.trapMine:Destroy()
    self:SetVisible(false)
  elseif self.config.type == Const.TriggerType.Teleport then
    self:SetVisible(false)
  elseif self.config.type == Const.TriggerType.Portal then
    self:SetVisible(false)
  end
  self:CheckLoadFollowNpc()
  if self.config.ForceFinish ~= nil then
    for k, v in ipairs(self.config.ForceFinish) do
      self.battleLevel:DoTrigger(self.battleLevel:GetTriggerByTriggerId(v), true)
    end
  end
  if self.config.guideId ~= nil and self.config.guideId ~= "" then
    self.battleLevel:DoTriggerGuide(tonumber(self.config.guideId))
  end
end

function TriggerPoint:RefreshText(aniIndex)
  if self.config.type == Const.TriggerType.CommitRes then
    if self.textObj ~= nil then
      local i = 1
      local list = {}
      for i = 1, ResTypeCount do
        if self.numItem[i] then
          self.numItem[i].node:SetActive(false)
        end
      end
      list = self:GetAllNeedRes()
      for t, n in pairs(list) do
        if self.numItem[i] ~= nil then
          local item = self.numItem[i]
          item.node:SetActive(true)
          local curNum = self:GetGiveRes(t)
          local text = string.format("%d<size=50%%>/%d", curNum, n)
          item.numText:SetText(text)
          local imagePic = Const.ResTypeIconPath[Const.UnlockToResType[t]] or Const.ResTypeIconPath[Const.CityCutResType.Stone]
          item.iconSpr:LoadSprite(imagePic)
        end
        i = i + 1
      end
    end
  elseif self.config.type == Const.TriggerType.AdvancedBuild then
    if self.textObj ~= nil then
      local list = self.config.stateNeedRes[self.advancedBuild:GetStateCount() - 1]
      if list then
        local giveNum = 0
        for t, _ in pairs(list) do
          giveNum = giveNum + self:GetGiveRes(t)
        end
        local _, totalNum = next(list, nil)
        local percent = math.floor(math.min(giveNum / totalNum, 1) * 100)
        self.slider.label.text = string.format("%d%%", percent)
        self.slider.progress.value = math.min(giveNum / totalNum, 1)
      end
    end
  elseif self.config.type == Const.TriggerType.CommitResource then
    if self.textObj ~= nil then
      local i = 1
      local list = {}
      for i = 1, ResTypeCount do
        if self.numItem[i] then
          self.numItem[i].node:SetActive(false)
        end
      end
      list = self:GetAllNeedRes()
      for t, n in pairs(list) do
        if self.numItem[i] ~= nil then
          local item = self.numItem[i]
          item.node:SetActive(true)
          local curNum = self:GetGiveRes(t)
          local text = string.format("%d<size=50%%>/%d", curNum, n)
          item.numText:SetText(text)
          local imagePic = Const.ResTypeIconPath[Const.ResourceTypeToResType[t]]
          item.iconSpr:LoadSprite(imagePic)
        end
        i = i + 1
      end
    end
  elseif self.config.type == Const.TriggerType.CommitResourceItem then
    if self.textObj ~= nil then
      local i = 1
      local list = {}
      for i = 1, ResTypeCount do
        if self.numItem[i] then
          self.numItem[i].node:SetActive(false)
        end
      end
      list = self:GetAllNeedRes()
      for t, n in pairs(list) do
        if self.numItem[i] ~= nil then
          local item = self.numItem[i]
          item.node:SetActive(true)
          local curNum = self:GetGiveRes(t)
          local text = string.format("%d<size=50%%>/%d", curNum, n)
          item.numText:SetText(text)
          local imagePic = DataCenter.ResourceItemDataManager:GetIconPath(t)
          item.iconSpr:LoadSprite(imagePic)
        end
        i = i + 1
      end
    end
  elseif self.config.type == Const.TriggerType.CommitLvPoint and self.textObj ~= nil then
    local cur = self:GetCurLvPoint()
    local max = self.config.needLvPoint
    for i = 1, ResTypeCount do
      local item = self.numItem[i]
      if item then
        if i == 1 then
          item.node:SetActive(true)
          item.numText:SetText(string.format("%d<size=50%%>/%d", cur, max))
          item.iconSpr:LoadSprite(Const.LvPointIconPath)
        else
          item.node:SetActive(false)
        end
      end
    end
  end
end

function TriggerPoint:GetTypeIndex(type)
  local i = 1
  local list = {}
  if self:IsTypeCommitRes() or self:IsTypeCommitResource() or self:IsTypeCommitResourceItem() then
    list = self:GetAllNeedRes()
  elseif self:IsTypeCommitLvPoint() then
    return 1
  end
  for t, need in pairs(list) do
    local resType = Const.UnlockToResType[t]
    if resType == type then
      return i
    end
    i = i + 1
  end
  return nil
end

function TriggerPoint:AniItem(type)
  local aniIndex = self:GetTypeIndex(type)
  if aniIndex == nil then
    return
  end
  local aniTf = self.numItem[aniIndex].node.transform
  DOTween.Kill(aniTf)
  aniTf:Set_localScale(1, 1, 1)
  aniTf:DOScale(Vector3.New(1.15, 1.15, 1), 0.15):OnComplete(function()
    aniTf:DOScale(Vector3.one, 0.15)
  end):SetEase(CS.DG.Tweening.Ease.InOutCubic)
end

function TriggerPoint:OnUpdate(deltaTime)
  if self.textObj ~= nil then
    self.textObj.transform.rotation = self.battleLevel:GetCameraRotation()
  end
  if self.collectionPoint ~= nil and self.collectionPoint.OnUpdate ~= nil then
    self.collectionPoint:OnUpdate()
  end
  if self.monster then
    self.monster:OnUpdate()
  end
  if self.turret then
    self.turret:OnUpdate()
  end
  if self.bombArea then
    self.bombArea:OnUpdate(deltaTime)
  end
  if self.timelineEnd == false then
    for k, v in pairs(self.config.timeline) do
      if v.start == true then
        v.curTime = v.curTime + deltaTime
        if v.curTime >= v.endPlayTime then
          v.start = false
          v.IsPlaying = false
          self:SetTimeLineEnd(true)
          self:CheckDoTrigger()
        elseif v.curTime >= v.startPlayTime and not v.IsPlaying and v.director ~= nil then
          v.IsPlaying = true
          v.director.time = 0
          v.director:Play()
        end
      end
    end
  end
end

function TriggerPoint:Destroy()
  self:DestroyBubble()
  if self.delayTimer ~= nil then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
  if not IsNull(self.gameObject) then
    if self:IsNeedPlaceSubmit() then
      local joint1 = self.gameObject.transform:Find("O_env_place/A_place@O_env_skin/To_unity/Root/joint1")
      if joint1 ~= nil then
        joint1:Set_localScale(1, 1, 1)
      end
    end
    self.gameObject = nil
  end
  if self.bombArea then
    self.bombArea:Destroy()
    self.bombArea = nil
  end
  if self.trapMine then
    self.trapMine:Destroy()
    self.trapMine = nil
  end
  self:DestroyObject()
  self:DestroyLoadObject()
end

function TriggerPoint:GetTurretAttackRadius()
  return self.config.attackRadius
end

function TriggerPoint:OnCutOnce(attack)
  if self.collectionPoint then
    self.collectionPoint:OnCutOnce(attack)
  end
end

function TriggerPoint:GetBloodLeftCnt()
  if self.collectionPoint then
    return self.collectionPoint:GetBloodLeftCnt()
  end
  return 0
end

function TriggerPoint:IsNeedResType(resType)
  if self.isVisible and self:IsTypeAdvancedBuild() then
    local list = self:GetCurrentStateNeedRes()
    if list ~= nil and list[resType] ~= nil then
      local give = self:GetGiveRes(resType)
      if give < list[resType] then
        return true
      end
    end
  end
  return false
end

function TriggerPoint:GetCurBlood()
  if self.collectionPoint then
    return self.collectionPoint:GetBloodLeftCnt()
  end
  return 0
end

function TriggerPoint:RefreshCameraRotation(rotation)
  if self.collectionPoint ~= nil and self.collectionPoint.RefreshCameraRotation ~= nil then
    self.collectionPoint:RefreshCameraRotation(rotation)
  end
  if self.triggerBubble ~= nil then
    self.triggerBubble:RefreshCameraRotation(rotation)
  end
end

function TriggerPoint:GetNeedPveStamina()
  if self:IsMonsterWithHp() then
    return 0
  end
  return self.config.energy_cost
end

function TriggerPoint:SetCanSubmit(value)
  self.canSubmit = value
end

function TriggerPoint:CanSubmit()
  return self.canSubmit
end

function TriggerPoint:IsBubbleSubmit()
  return self.config.trigger_type == Const.TriggerBubbleType.Bubble or self.config.trigger_type == Const.TriggerBubbleType.Bubble_Open_Panel
end

function TriggerPoint:CheckLoadBubble()
  local isInitFinish = self.battleLevel:IsFinishTrigger(self:GetTriggerId())
  if not isInitFinish and self:IsPreTriggerOK() then
    local needStaminaCount = self:GetNeedPveStamina()
    if (0 < needStaminaCount or self:IsTypeBubbleSubmit()) and self.triggerBubble == nil then
      local param = {}
      param.triggerData = self
      param.rotation = self.battleLevel:GetCameraRotation()
      param.visible = not isInitFinish
      param.bubbleDisplayRange = self.config.bubbleDisplayRange
      param.bubbleShowRange = self.config.bubbleShowRange
      param.pos = self:GetPosition()
      param.isBubbleSubmit = self:IsBubbleSubmit()
      param.needStaminaCount = needStaminaCount
      param.need = self.config.needBubbleSubmit
      self.triggerBubble = PveTriggerPointBubble.New(param)
    end
  end
end

function TriggerPoint:DestroyBubble()
  if self.triggerBubble ~= nil then
    self.triggerBubble:Destroy()
    self.triggerBubble = nil
  end
end

function TriggerPoint:RefreshStamina()
  if self.triggerBubble ~= nil then
    self.triggerBubble:RefreshStamina()
  end
end

function TriggerPoint:RefreshResourceItem()
  if self.triggerBubble ~= nil then
    self.triggerBubble:RefreshResourceItem()
  end
end

function TriggerPoint:RefreshGoods()
  if self.triggerBubble ~= nil then
    self.triggerBubble:RefreshGoods()
  end
end

function TriggerPoint:RefreshResource()
  if self.triggerBubble ~= nil then
    self.triggerBubble:RefreshResource()
  end
end

function TriggerPoint:RefreshComplete()
  if self.triggerBubble ~= nil then
    self.triggerBubble:RefreshComplete()
  end
end

function TriggerPoint:IsBubbleNeedFull()
  for k, v in ipairs(self.config.needBubbleSubmit) do
    if v.needType == TriggerNeedType.ResourceItem then
      local resData = DataCenter.ResourceItemDataManager:GetItemDataByItemId(v.needId)
      local haveCount = resData ~= nil and resData.number or 0
      if haveCount < v.needCount then
        return false
      end
    elseif v.needType == TriggerNeedType.Goods then
      local haveCount = DataCenter.ItemData:GetItemCount(v.needId)
      if haveCount < v.needCount then
        return false
      end
    elseif v.needType == TriggerNeedType.Resource then
      local haveCount = self.battleLevel:GetResourceCount(v.needId)
      if haveCount < v.needCount then
        return false
      end
    end
  end
  return true
end

function TriggerPoint:SetBubbleVisible(visible)
  if self.triggerBubble ~= nil then
    self.triggerBubble:SetVisible(visible)
  end
end

function TriggerPoint:HideBubble()
  if self.triggerBubble ~= nil then
    self.triggerBubble:DoHideAnim()
  end
end

function TriggerPoint:IsTypeCanAttack()
  return self:IsTypeCollectRes() or self.config.type == Const.TriggerType.AttackBox
end

function TriggerPoint:IsTypeCanCheckCollect()
  return self:IsTypeMonster() or self:IsTypeRewardBox() or self:IsTypeRewardBoxUI() or self:IsTypeBuffBox() or self:IsTypePlayer() or self:IsTypeArea() or self:IsTypeFollowPlayer()
end

function TriggerPoint:OnPlayerMoveSignal(pos)
  if self:IsTypeCanCheckCollect() then
    local distance = Vector3.Distance(pos, self:GetPosition())
    if distance <= self.triggerEnterDistance then
      self.battleLevel:DoTrigger(self)
    end
  end
  if self:IsTypePortal() then
    local distance = Vector3.Distance(pos, self:GetPosition())
    if distance <= self.triggerEnterDistance then
      self:UsePortal()
    end
  end
  if self:IsTypeBombArea() and self:IsPreTriggerOK() and self.bombArea ~= nil and not self.bombArea.started then
    local distance = Vector3.Distance(pos, self.config.transform.t)
    if distance <= self.config.enterRadius then
      self.bombArea:PlayerInDistance()
    end
  end
  if self:IsTypeTrapMine() and self:IsPreTriggerOK() and self.trapMine ~= nil and not self.trapMine.used then
    local distance = Vector3.Distance(pos, self.config.transform.t)
    if distance <= self.config.enterRadius then
      self.trapMine:Attack()
    end
  end
  if self.triggerBubble ~= nil then
    self.triggerBubble:OnPlayerMoveSignal(pos)
  end
end

function TriggerPoint:ISCollectRewardMoreThanOneTime()
  return self.config.type == Const.TriggerType.CollectRewardMoreThanOneTime
end

function TriggerPoint:ISSpecialEnd()
  return self.config.type == Const.TriggerType.SpecialEnd
end

function TriggerPoint:ISCollectRewardMoreThanOneTimeAllComplete()
  if self:ISCollectRewardMoreThanOneTime() then
    local lastCollectTime, collectTimes = DataCenter.BattleLevel:GetMoreThanOneRewardInfo(self.triggerId)
    if self.config.collectTotalTime < 0 then
      return false
    end
    if collectTimes >= self.config.collectTotalTime then
      return true
    end
  end
  return false
end

function TriggerPoint:Is2000TypeCanSpeedUp()
  if self:ISCollectRewardMoreThanOneTime() then
    return self.config.speedUpCostType == Const.TriggerClearCDType.TriggerClearCDType_Diamond or self.config.speedUpCostType == Const.TriggerClearCDType.TriggerClearCDType_Energy
  end
  return false
end

function TriggerPoint:NeedShowCollectRewardMoreThanOneTimeBubble()
  if self:ISCollectRewardMoreThanOneTime() then
    local lastCollectTime, collectTimes = DataCenter.BattleLevel:GetMoreThanOneRewardInfo(self.triggerId)
    local now = UITimeManager:GetInstance():GetServerTime()
    local time = self:GetCollectRewardMoreThanOneTimeCollCollectTime()
    if now < time and not self:Is2000TypeCanSpeedUp() then
      return false
    end
    if self.config.collectTotalTime < 0 then
      return true
    end
    if collectTimes < self.config.collectTotalTime then
      return true
    end
  end
  return false
end

function TriggerPoint:GetCollectRewardMoreThanOneTimeCollCollectTime()
  local lastCollectTime, collectTimes = DataCenter.BattleLevel:GetMoreThanOneRewardInfo(self.triggerId)
  lastCollectTime = lastCollectTime or 0
  return lastCollectTime + self.config.collectTimeGap * 1000
end

function TriggerPoint:ShowHighlightItem()
  if self.config ~= nil and self.config.timeline ~= nil then
    return
  end
  if self.objectRender == nil then
    return
  end
  if self.gameObject ~= nil then
    local renders = self.gameObject:GetComponentsInChildren(typeof(CS.UnityEngine.Renderer))
    if renders ~= nil and renders.Length > 0 then
      for i = 0, renders.Length - 1 do
        local render = renders[i]
        local material = render.material
        if material.shader.name ~= "Custom2019/BuildingShadow" and material ~= nil and material.renderQueue < 3001 then
          local newMat = CS.UnityEngine.Material(material)
          self.objectRender[i + 1] = render
          self.oldMaterials[i + 1] = material
          render.material = newMat
          newMat:EnableKeyword("HIGHLIGHT_ON")
          newMat:SetFloat(_srcBlend, 5)
          newMat:SetFloat(_dstBlend, 10)
          newMat.renderQueue = 3000
        end
      end
    end
  end
end

function TriggerPoint:HideHighlightItem()
  if self.config ~= nil and self.config.timeline ~= nil then
    return
  end
  if string.IsNullOrEmpty(self.config.animation) then
    return
  end
  if self.objectRender == nil then
    return
  end
  for i, v in pairs(self.objectRender) do
    local newMat = v.material
    v.material = self.oldMaterials[i]
    CS.UnityEngine.GameObject.Destroy(newMat)
  end
end

function TriggerPoint:AddTimelineComponent()
  self:SetTimeLineEnd(true)
  if self.gameObject ~= nil and self.config.timeline ~= nil then
    for k, v in ipairs(self.config.timeline) do
      local path = self.gameObject.transform:Find(v.path)
      if path ~= nil then
        v.director = path:GetComponent(typeof(CS.UnityEngine.Playables.PlayableDirector))
        if v.director ~= nil then
          v.director.time = 0
          v.director:Stop()
        end
      end
    end
  end
end

function TriggerPoint:CanDoTrigger()
  return self.timelineEnd and self.playerInteractEnd
end

function TriggerPoint:SetTimeLineEnd(isEnd)
  self.timelineEnd = isEnd
end

function TriggerPoint:SetPlayerInteractEnd(isEnd)
  self.playerInteractEnd = isEnd
end

function TriggerPoint:PlayInterActAnim(index)
  if self.config.timeline ~= nil and self.config.timeline[index] ~= nil and self.config.timeline[index].director ~= nil then
    self:SetTimeLineEnd(false)
    self.config.timeline[index].curTime = 0
    self.config.timeline[index].start = true
    self.config.timeline[index].IsPlaying = false
  end
end

function TriggerPoint:GetTriggerBubble()
  if self.triggerBubble ~= nil then
    return self.triggerBubble
  end
end

function TriggerPoint:ISPVEFactory()
  return self.config.type == Const.TriggerType.PVEFactory
end

function TriggerPoint:GetPVEFactoryMaxLevel()
  return self.config.maxBuildingLv
end

function TriggerPoint:GetPVEFactoryMaxQueueNum()
  local data = DataCenter.BattleLevel:GetPveTriggerBuildingInfo(self.triggerId)
  if data ~= nil then
    return self:GetPVEFactoryMaxQueueNumByLv(data.level)
  end
  return 0
end

function TriggerPoint:GetPVEFactoryMaxQueueNumByLv(lv)
  if self.config.productQueueNum == nil then
    return 0
  end
  local count = table.count(self.config.productQueueNum)
  if count == 0 then
    return 0
  end
  local index = math.min(lv, count)
  return self.config.productQueueNum[index]
end

function TriggerPoint:GetPVEFactoryFormula()
  local data = DataCenter.BattleLevel:GetPveTriggerBuildingInfo(self.triggerId)
  if data ~= nil then
    return self:GetPVEFactoryFormulaByLv(data.level)
  end
  return 0
end

function TriggerPoint:GetPVEFactoryFormulaByLv(lv)
  if self.config.productFormula == nil then
    return {}
  end
  local count = table.count(self.config.productFormula)
  if count == 0 then
    return {}
  end
  local index = math.min(lv, count)
  return self.config.productFormula[index]
end

function TriggerPoint:GetPVEFactoryUpgradeCondition()
  local data = DataCenter.BattleLevel:GetPveTriggerBuildingInfo(self.triggerId)
  if data ~= nil then
    return self:GetPVEFactoryUpgradeConditionByLv(data.level)
  end
  return nil
end

function TriggerPoint:GetPVEFactoryUpgradeConditionByLv(lv)
  if self.config.buildingUpgradeConditions == nil then
    return nil
  end
  local count = table.count(self.config.buildingUpgradeConditions)
  if lv > count then
    return nil
  end
  local index = math.min(lv, count)
  return self.config.buildingUpgradeConditions[index]
end

function TriggerPoint:RefreshFactory()
  if self:ISPVEFactory() and self.freeEffect ~= nil then
    self.freeEffect:RefreshFactoryState()
  end
end

function TriggerPoint:DoWhenClickOnTrigger()
  if self:ISCollectRewardMoreThanOneTime() then
    local bubble = self:GetTriggerBubble()
    if bubble ~= nil then
      bubble:Click2000Trigger()
    end
  elseif self:ISPVEFactory() then
    local battleLevel = DataCenter.BattleLevel
    battleLevel:DisableJoystick()
    battleLevel:EnableJoystick()
    local data = battleLevel:GetPveTriggerBuildingInfo(self.triggerId)
    if data == nil then
      local param = {}
      param.trigger = self.triggerId
      param.level = battleLevel.levelId
      SFSNetwork.SendMessage(MsgDefines.UpgradeTriggerBuilding, param)
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIFactory, data.uuid)
    end
  elseif self:IsTypeGotoOtherPve() then
    local pveTemplate = DataCenter.PveLevelTemplateManager:GetTemplate(self.config.gotoLevelId)
    if pveTemplate ~= nil then
      UIUtil.ShowMessage(Localization:GetString(GameDialogDefine.GOTO_OTHER_PVE_TIP, Localization:GetString(tostring(pveTemplate.name))), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
        local pveEntrance = self.config.pveEntrance
        local levelId = self.config.gotoLevelId
        local abandon = true
        if pveEntrance == PveEntrance.Test then
          local param = {}
          param.pveEntrance = pveEntrance
          param.levelId = levelId
          param.abandon = abandon
          param.isStart = false
          DataCenter.BattleLevel:Enter(param)
        elseif pveEntrance == PveEntrance.LandLock then
          DataCenter.LandLockManager:EnterPve(levelId, abandon)
        elseif pveEntrance == PveEntrance.PveAct then
          DataCenter.PveActManager:EnterPve(levelId, abandon)
        end
      end, function()
        local playerPos = DataCenter.BattleLevel:GetPlayerLeavePos(self)
        DataCenter.BattleLevel:SetPosition(playerPos)
      end, function()
        local playerPos = DataCenter.BattleLevel:GetPlayerLeavePos(self)
        DataCenter.BattleLevel:SetPosition(playerPos)
      end)
    end
  end
end

function TriggerPoint:CheckLoadFollowNpc()
  local npcName = self.config.FollowNpc
  if npcName ~= nil and npcName ~= "" then
    local isOk = self.battleLevel:IsFinishTrigger(self:GetTriggerId())
    if (isOk or self.isVisible) and (self.position.x ~= 0 or self.position.z ~= 0) then
      local tile = SceneUtils.WorldToTile(self.position)
      local param = {}
      param.modelName = npcName
      param.posArr = {tile}
      param.isFollow = isOk
      self.battleLevel:AddOneNpc(param)
    end
  end
end

function TriggerPoint:CheckShowFinishTrigger()
  if self.config.type == Const.TriggerType.BuyAttack then
    self.battleLevel:ShowBuyAttackShop(self.config.selectBuff)
  end
  local isOk = self.battleLevel:IsFinishTrigger(self:GetTriggerId())
  if isOk then
    if self.config.type == Const.TriggerType.Player then
      self.battleLevel:AddOnePlayer(self.config.playerName, 0, nil, false, true)
    elseif self.config.type == Const.TriggerType.FollowPlayer then
      self.followPlayerObjId = self.battleLevel:AddOneFollowPlayer(self:GetPosition(), self.config.attack, self.config.maxBlood, self.config.attackRadius)
    elseif self.config.type == Const.TriggerType.Buff then
      self.battleLevel:AddBuffById(self.config.buffId)
    elseif self.config.type == Const.TriggerType.Npc then
      local param = {}
      param.modelName = self.config.npcName
      param.dialogId = self.config.dialogId
      param.posArr = self.config.posArr
      param.animName = self.config.aniName
      param.angle = self.config.angle
      self.battleLevel:AddOneNpc(param)
    end
    self:CheckLoadFollowNpc()
  end
end

function TriggerPoint:SetViewVisible(visible)
  if self.viewVisible ~= visible then
    self.viewVisible = visible
    self:CheckCreateObj(visible)
  end
end

function TriggerPoint:DestroyLoadObject()
  if self.config.type == Const.TriggerType.Build then
    self.battleLevel:RemoveOneBuild(self:GetPosition())
  end
  local isOk = self.battleLevel:IsFinishTrigger(self:GetTriggerId())
  if self.config.type == Const.TriggerType.Player and not isOk then
    self.battleLevel:RemoveOneTriggerPlayerByPrefabNameAndPos(self.config.playerName, self:GetPosition())
  end
  self.gameObject = nil
  self.textObj = nil
  self.monsterGrid = nil
  self.appearAnim = nil
  self.rewardBoxOpen = nil
  self.numItem = nil
  self.triggerAni = nil
  self.slider = nil
  self.sandwormGo = nil
  if self.showModel then
    self.showModel:Destroy()
    self.showModel = nil
  end
  if self.hireHero then
    self.hireHero:Destroy()
    self.hireHero = nil
  end
  if self.collectionPoint then
    self.collectionPoint:Destroy()
    self.collectionPoint = nil
  end
  if self.monster then
    self.monster:Destroy()
    self.monster = nil
  end
  if self.freeEffect then
    self.freeEffect:Destroy()
    self.freeEffect = nil
  end
  if self.monsterHp then
    self.monsterHp:Destroy()
    self.monsterHp = nil
  end
  if self.timelineInst then
    self.timelineInst:Destroy()
    self.timelineInst = nil
  end
  if self.advancedBuild then
    self.advancedBuild:Destroy()
    self.advancedBuild = nil
  end
  if self.rewardBoxOpenTimer then
    self.rewardBoxOpenTimer:Stop()
    self.rewardBoxOpenTimer = nil
  end
  if self.turret then
    self.turret:Destroy()
    self.turret = nil
  end
  if self.teleport then
    self.teleport:Destroy()
    self.teleport = nil
  end
  self.oldMaterials = nil
  self.objectRender = nil
end

function TriggerPoint:IsMonsterWithHp()
  return self.config.type == Const.TriggerType.MonsterWithHp
end

function TriggerPoint:RefreshMonsterHp(cur, max)
  if self:IsMonsterWithHp() and self.monsterHp then
    self.monsterHp:SetVal(cur, max)
  end
end

function TriggerPoint:RefreshRewardState()
  if self:ISCollectRewardMoreThanOneTime() then
    local now = UITimeManager:GetInstance():GetServerTime()
    local time = self:GetCollectRewardMoreThanOneTimeCollCollectTime()
    local waitFlag = now < time or self:ISCollectRewardMoreThanOneTimeAllComplete()
    self.collectRewardStateWait.gameObject:SetActive(waitFlag)
    self.collectRewardStateCanGet.gameObject:SetActive(not waitFlag)
    local bubble = self:GetTriggerBubble()
    if bubble ~= nil then
      bubble:SetVisible(true)
    end
  end
end

function TriggerPoint:OnSetHighView(isHighView)
  if self:IsTypeTeleport() and self.teleport ~= nil then
    self.teleport:OnSetHighView(isHighView)
  end
end

function TriggerPoint:CheckDoTrigger()
  if self:CanDoTrigger() then
    DataCenter.BattleLevel:DoTrigger(self)
  end
end

function TriggerPoint:IsNeedPlaceSubmit()
  return self:IsTypeCommitRes() or self:IsTypeTurret() or self:IsTypeCommitResource() or self:IsTypeCommitLvPoint() or self:IsTypeCommitResourceItem()
end

function TriggerPoint:SubmitAllIndexFinish()
  if self.config.needBubbleSubmit ~= nil then
    for k, v in ipairs(self.config.needBubbleSubmit) do
      if not self.battleLevel:IsItemSubmit(self:GetTriggerId(), k) then
        local param = {}
        param.index = k
        param.trigger = self:GetTriggerId()
        param.level = self.battleLevel.levelId
        param.useGold = 0
        SFSNetwork.SendMessage(MsgDefines.PayTriggerResItem, param)
      end
    end
  end
end

function TriggerPoint:DoSelectBubble()
  if self.triggerBubble ~= nil and not self.triggerBubble.isOnInteract then
    self.triggerBubble:OnTouchBubbleClick()
  end
end

function TriggerPoint:ShowBubble(show)
  if self.triggerBubble ~= nil then
    self.triggerBubble:Show(show)
  end
end

function TriggerPoint:UsePortal()
  local playerPos = DataCenter.BattleLevel:GetPosition()
  local targetPos = SceneUtils.TileToWorld(self.config.targetPos)
  DataCenter.BattleLevel:SetPosition(targetPos, true)
  DataCenter.BattleLevel:SetRotation(self.config.targetRot)
  DataCenter.BattleLevel:CreateTeleportEffect(playerPos)
  DataCenter.BattleLevel:CreateTeleportEffect(targetPos)
end

return TriggerPoint
