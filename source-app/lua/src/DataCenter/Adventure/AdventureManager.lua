local AdventureManager = BaseClass("AdventureManager")
local Localization = CS.GameEntry.Localization
local PveLevelConst = require("Scene.PVEBattleLevel.Const")
local BattlePveConst = require("Scene.BattlePveModule.Const")
local BattleWinDelay = 1

local function __init(self)
  self.apsRandom = ApsRandom.New()
  self.actData = nil
  self.advInfo = {
    nowLevel = 0,
    maxLevel = 0,
    resetTime = 0,
    startTime = 0,
    armyUnit = nil,
    buffList = {},
    raidReward = {},
    justNowLevel = 0
  }
  self.selectInfo = {
    triggerId = 0,
    type = AdventureType.Default,
    subType = AdventureType.Default,
    content = ""
  }
  self.boxBuffList = {}
  self.rewardCache = {}
  self.flyRewardList = {}
  self.totalRewardList = {}
  self.soliderChangeCache = 0
  self.hasRaidResult = false
  self.finalLevel = 0
  self.canShowSubWindow = true
  self.canFlyReward = false
  self.autoRaid = false
  LocalController:instance():visitTable(TableName.BattleBuff, function(id, line)
    if tonumber(line:getValue("group")) == BattleBuffGroup.Adventure and tonumber(line:getValue("not_choose")) == 0 then
      table.insert(self.boxBuffList, tonumber(id))
    end
  end)
  LocalController:instance():visitTable(TableName.AdventureEntrance, function(id, _)
    self.finalLevel = math.max(self.finalLevel, id)
  end)
end

local function __delete(self)
  self.apsRandom = nil
  self.actData = nil
  self.advInfo = nil
  self.selectInfo = nil
  self.boxBuffList = nil
  self.rewardCache = nil
  self.flyRewardList = nil
  self.totalRewardList = nil
  self.soliderChangeCache = nil
  self.hasRaidResult = nil
  self.canShowSubWindow = nil
  self.canFlyReward = nil
  self.autoRaid = nil
end

local function SetActivityData(self, actData)
  self.actData = actData
end

local function SetSelectInfo(self, selectInfo)
  self.selectInfo = selectInfo
end

local function GetSelectInfo(self)
  return self.selectInfo
end

local function GetBuffList(self)
  return self.advInfo.buffList
end

local function IsSameDay(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local sameDay = UITimeManager:GetInstance():IsSameDayForServer(curTime // 1000, self.advInfo.startTime // 1000)
  return sameDay
end

local function GetFirstPveLevel(self)
  return tonumber(GetTableData(TableName.AdventureEntrance, 1, "pveLevel"))
end

local function GetCurrentPveLevel(self)
  local level = math.min(self.advInfo.nowLevel, self.finalLevel)
  return tonumber(GetTableData(TableName.AdventureEntrance, level, "pveLevel"))
end

local function GetTotalResetTime(self)
  return tonumber(LuaEntry.DataConfig:TryGetStr("explorer_pve", "k1")) or 0
end

local function GetTodayRestResetTime(self)
  local totalResetTime = self:GetTotalResetTime()
  if self:IsSameDay() then
    return totalResetTime - self.advInfo.resetTime
  else
    return totalResetTime
  end
end

local function GetAdventureInfo(self)
  return self.advInfo
end

local function GetHeroCount(self)
  if self.advInfo.armyUnit ~= nil and self.advInfo.armyUnit.heroes ~= nil then
    return table.count(self.advInfo.armyUnit.heroes)
  else
    return 0
  end
end

local function GetAdventureState(self)
  if not self:IsSameDay() then
    return AdventureState.Ready
  end
  if self.advInfo.nowLevel == 0 then
    return AdventureState.Ready
  end
  local pve = tonumber(GetTableData(TableName.AdventureEntrance, self.advInfo.nowLevel, "pveLevel"))
  local pveTemplate = DataCenter.PveLevelTemplateManager:GetTemplate(pve)
  if pveTemplate == nil then
    return AdventureState.Won
  end
  if not self:IsArmyAlive() then
    return AdventureState.Lost
  end
  return AdventureState.Playing
end

local function GetHeroUuidList(self)
  local list = {}
  if self.advInfo.armyUnit ~= nil and self.advInfo.armyUnit.heroes ~= nil then
    for _, v in ipairs(self.advInfo.armyUnit.heroes) do
      table.insert(list, v.heroUuid)
    end
  end
  return list
end

local function GetAliveArmy(self)
  local armyDict = {}
  if self.advInfo.armyUnit ~= nil and self.advInfo.armyUnit.soldiers ~= nil then
    for _, v in ipairs(self.advInfo.armyUnit.soldiers) do
      local count = v.total - (v.wounded + v.injured + v.dead)
      if 0 < count then
        armyDict[tonumber(v.armsId)] = count
      end
    end
  end
  return armyDict
end

local function GetArmyCount(self)
  local aliveCount = 0
  local totalCount = 0
  if self.advInfo.armyUnit ~= nil and self.advInfo.armyUnit.soldiers ~= nil then
    for _, v in ipairs(self.advInfo.armyUnit.soldiers) do
      local alive = v.total - (v.wounded + v.injured + v.dead)
      totalCount = totalCount + v.total
      aliveCount = aliveCount + alive
    end
  end
  return aliveCount, totalCount
end

local function IsArmyAlive(self)
  local armyDict = self:GetAliveArmy()
  return table.count(armyDict) > 0
end

local function GetSubContent(self, param)
  local result = {}
  local subType = AdventureType.Default
  local content = ""
  local rewardList = {}
  local desc = ""
  local icon = ""
  local seed = self.advInfo.startTime * 61 + self.advInfo.resetTime * 83 + param.triggerId * 113
  self.apsRandom:SetSeed(seed)
  if param.type == AdventureType.Monster then
    local str = tostring(param.line:getValue("monster")) or ""
    local spls = string.split(str, "|")
    local index = param.indexCache[AdventureType.Monster] or 1
    param.indexCache[AdventureType.Monster] = index % #spls + 1
    content = tostring(spls[index])
    local rewardTotalStr = tostring(param.line:getValue("monster_showreward")) or ""
    local rewardStrs = string.split(rewardTotalStr, "|")
    local rewardStr = rewardStrs[index]
    local rewardSpls = string.split(rewardStr, ";")
    for _, spl in ipairs(rewardSpls) do
      local s = string.split(spl, ",")
      if #s == 3 then
        local reward = {}
        reward.rewardType = tonumber(s[1])
        reward.itemId = tonumber(s[2])
        reward.count = tonumber(s[3])
        table.insert(rewardList, reward)
      end
    end
    icon = "Assets/Main/Sprites/Guide/UIPVE_adventure_sub_monster"
  elseif param.type == AdventureType.Reward then
    local str = tostring(param.line:getValue("reward")) or ""
    local spls = string.split(str, "|")
    local index = param.indexCache[AdventureType.Reward] or 1
    param.indexCache[AdventureType.Reward] = index % #spls + 1
    content = tostring(spls[index])
    local rewardTotalStr = tostring(param.line:getValue("reward_show")) or ""
    local rewardStrs = string.split(rewardTotalStr, "|")
    local rewardStr = rewardStrs[index]
    local rewardSpls = string.split(rewardStr, ";")
    for _, spl in ipairs(rewardSpls) do
      local s = string.split(spl, ",")
      if #s == 3 then
        local reward = {}
        reward.rewardType = tonumber(s[1])
        reward.itemId = tonumber(s[2])
        reward.count = tonumber(s[3])
        table.insert(rewardList, reward)
      end
    end
    icon = "Assets/Main/Sprites/Guide/UIPVE_adventure_sub_reward"
  elseif param.type == AdventureType.Buff then
    local str = tostring(param.line:getValue("buff")) or ""
    local spls = string.split(str, "|")
    local index = param.indexCache[AdventureType.Buff] or 1
    param.indexCache[AdventureType.Buff] = index % #spls + 1
    local spl = spls[index]
    if spl == "all" then
      local rand = self.apsRandom:NextInt(#self.boxBuffList) + 1
      content = tostring(self.boxBuffList[rand])
    else
      content = tostring(spl)
    end
    local iconName = GetTableData(TableName.BattleBuff, tonumber(content), "icon") or ""
    icon = string.format(LoadPath.UIPveBattleBuff, iconName)
  elseif param.type == AdventureType.Box then
    local randomStr = tostring(param.line:getValue("random")) or ""
    local strs = string.split(randomStr, "|")
    local index = param.indexCache[AdventureType.Box] or 1
    param.indexCache[AdventureType.Box] = index % #strs + 1
    local str = strs[index]
    local spls = string.split(str, ";")
    local infoList = {}
    local totalRate = 0
    for _, spl in ipairs(spls) do
      local s = string.split(spl, ",")
      if #s == 3 then
        local info = {}
        info.subType = tonumber(s[1])
        info.content = tostring(s[2])
        info.rate = tonumber(s[3])
        totalRate = totalRate + info.rate
        table.insert(infoList, info)
      end
    end
    local rand = self.apsRandom:NextInt(totalRate)
    for _, info in ipairs(infoList) do
      rand = rand - info.rate
      if rand < 0 then
        subType = info.subType
        content = info.content
        break
      end
    end
    local descStr = tostring(param.line:getValue("randomdes")) or ""
    local descStrs = string.split(descStr, "|")
    desc = Localization:GetString(descStrs[index])
    icon = "Assets/Main/Sprites/Guide/UIPVE_adventure_sub_box"
  end
  result.subType = subType
  result.content = content
  result.rewardList = rewardList
  result.desc = desc
  result.icon = icon
  return result
end

local function GetBuffContentStrList(self, buffContent)
  local battleBuffId = tonumber(buffContent)
  local line = LocalController:instance():getLine(TableName.BattleBuff, battleBuffId)
  local descStrList = {}
  local recoverVal = 0
  if line ~= nil then
    local strs = string.split(line:getValue("buffId"), "|")
    local localType = tonumber(line:getValue("LocalType")) or 0
    for _, str in ipairs(strs) do
      local spls = string.split(str, ";")
      if #spls == 1 then
        recoverVal = tonumber(spls[1])
      elseif #spls == 2 then
        local buff = tonumber(spls[1])
        local val = tonumber(spls[2])
        local descStr = Localization:GetString(GetTableData(TableName.EffectNumDesc, buff, "des"))
        local valStr = CommonUtil.GetValueWithLocalType(val, localType)
        table.insert(descStrList, descStr .. " " .. valStr)
      end
    end
  end
  return descStrList, recoverVal
end

local function ParseAdventureInfo(self, message)
  self.advInfo.nowLevel = message.nowLevel or 0
  self.advInfo.maxLevel = message.maxLevel or 0
  self.advInfo.resetTime = message.resetTime or 0
  self.advInfo.startTime = message.startTime or 0
  self.advInfo.buffList = {}
  local buffStr = message.buffList or ""
  for _, str in ipairs(string.split(buffStr, ";")) do
    local buffId = tonumber(str)
    table.insert(self.advInfo.buffList, buffId)
  end
  if message.reward then
    DataCenter.RewardManager:AddRewardsAndRes(message)
    self.advInfo.raidReward = message.reward
    self:AddTotalReward(message.reward)
  end
  if message.armyUnit then
    self.advInfo.armyUnit = PBController.ParsePb1(message.armyUnit, "protobuf.ArmyUnitInfo")
  end
  EventManager:GetInstance():Broadcast(EventId.AdventureInfoUpdate)
end

local function CheckShowReward(self)
  if self.rewardCache then
    DataCenter.RewardManager:ShowGiftReward({
      reward = self.rewardCache
    }, Localization:GetString("128027"), function()
      self:UpdatePlayerHpBar()
      EventManager:GetInstance():Broadcast(EventId.AdventureInfoUpdate)
    end)
    self.rewardCache = {}
  end
end

local function GetRaidState(self)
  local needMaxLevel = tonumber(LuaEntry.DataConfig:TryGetStr("explorer_pve", "k2")) or 0
  if needMaxLevel > self.advInfo.maxLevel then
    return AdventureRaidState.NeedLevel
  elseif self.advInfo.nowLevel >= self.advInfo.maxLevel then
    return AdventureRaidState.LevelMaxed
  else
    return AdventureRaidState.Ready
  end
end

local function GetSubTip(self)
  if self.selectInfo.type == AdventureType.Monster then
    return Localization:GetString("302257", self.advInfo.justNowLevel, math.abs(self.soliderChangeCache))
  elseif self.selectInfo.type == AdventureType.Buff or self.selectInfo.subType == AdventureType.Buff then
    local descStrList, recoverVal = self:GetBuffContentStrList(self.selectInfo.content)
    if 0 < #descStrList then
      return Localization:GetString("302258", string.join(descStrList, ", "))
    elseif 0 < recoverVal then
      return Localization:GetString("302279", recoverVal)
    elseif recoverVal < 0 then
      return Localization:GetString("302260", -recoverVal)
    else
      return ""
    end
  elseif self.selectInfo.type == AdventureType.Reward or self.selectInfo.subType == AdventureType.Reward then
    local names = DataCenter.RewardManager:GetRewardNames(self.rewardCache)
    return Localization:GetString("302263", string.join(names, ", "))
  end
  return ""
end

local function Start(self)
  local state = self:GetAdventureState()
  if state == AdventureState.Playing then
    local param = {}
    param.pveEntrance = PveEntrance.Adventure
    param.levelId = self:GetCurrentPveLevel()
    param.abandon = true
    DataCenter.BattleLevel:Enter(param)
  elseif state == AdventureState.Ready then
    local param = {}
    param.pveEntrance = PveEntrance.AdventureSetting
    param.levelId = AdventureSettingLevelId
    param.abandon = true
    DataCenter.BattleLevel:Enter(param)
  elseif state == AdventureState.Won or state == AdventureState.Lost then
    local resetTime = self:GetTodayRestResetTime()
    if 0 < resetTime then
      self:SendReset()
    else
      UIUtil.ShowTipsId(302285)
    end
  end
end

local function StartPveLevel(self)
  local state = self:GetAdventureState()
  if self.hasRaidResult then
    if state == AdventureState.Won then
      local pve = self:GetCurrentPveLevel()
      local pveTemplate = DataCenter.PveLevelTemplateManager:GetTemplate(pve)
      local locMsg = {
        finishTime = 0,
        finishTrigger = string.join(pveTemplate.triggerList, ";"),
        status = 1,
        levelId = pve
      }
      DataCenter.BattleLevel:OnStartLevelMessage(locMsg)
    else
      self:SendContinue()
    end
  elseif state == AdventureState.Playing then
    self:SendContinue()
  else
    self:SendStart()
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPVEAdventure)
end

local function GetRaidPreviewRewardList(self, level)
  local list = {}
  for entranceId = 1, level do
    local pve = tonumber(GetTableData(TableName.AdventureEntrance, entranceId, "pveLevel"))
    local pveTemplate = DataCenter.PveLevelTemplateManager:GetTemplate(pve)
    for _, triggerId in ipairs(pveTemplate.triggerList) do
      local triggerType = tonumber(GetTableData(TableName.PVETrigger, tonumber(triggerId), "UnclockType"))
      if triggerType == PveLevelConst.TriggerType.AdventureSub then
        local unlockParaStr = GetTableData(TableName.PVETrigger, tonumber(triggerId), "UnclockPara")
        local unlockPara = string.split(unlockParaStr, "|")
        local caseId = -1
        for _, str in ipairs(unlockPara) do
          local spls = string.split(str, ";")
          if #spls == 2 then
            local mainLv = tonumber(spls[1])
            caseId = tonumber(spls[2])
            if mainLv >= DataCenter.BuildManager.MainLv then
              break
            end
          end
        end
        local line = LocalController:instance():getLine(TableName.AdventureCase, caseId)
        if line ~= nil then
          local contentSpls = string.split(line:getValue("content") or "", ";")
          for _, spl in ipairs(contentSpls) do
            local type = tonumber(spl)
            local param = {}
            param.triggerId = triggerId
            param.caseId = caseId
            param.type = type
            param.line = line
            param.indexCache = {}
            local result = self:GetSubContent(param)
            for _, reward in ipairs(result.rewardList) do
              local insert = true
              for _, v in ipairs(list) do
                if v.rewardType == reward.rewardType and v.itemId == reward.itemId then
                  insert = false
                  break
                end
              end
              if insert then
                local o = {}
                o.rewardType = reward.rewardType
                o.itemId = reward.itemId
                o.count = ""
                table.insert(list, o)
              end
            end
          end
        end
      end
    end
  end
  return list
end

local function CanTriggerShowArrow(self, checkTriggerId)
  local raidState = self:GetRaidState()
  if raidState ~= AdventureRaidState.Ready then
    return false
  end
  local triggerIdList = DataCenter.BattleLevel:GetConfigTriggers()
  for _, triggerId in ipairs(triggerIdList) do
    local trigger = DataCenter.BattleLevel:GetTriggerByTriggerId(triggerId)
    if trigger:IsTypeAdventureSub() then
      return trigger:GetTriggerId() == checkTriggerId
    end
  end
  return false
end

local function IsFinalLevel(self)
  return self.advInfo.nowLevel == self.finalLevel
end

local function UpdatePlayerHpBar(self)
  local aliveCount, totalCount = self:GetArmyCount()
  DataCenter.BattleLevel:SetPlayerHpBar(aliveCount, totalCount)
end

local function CanShowSubWindow(self)
  return self.canShowSubWindow
end

local function AddTotalReward(self, rawRewards)
  local rewards = DataCenter.RewardManager:ReturnRewardParamForMessage(rawRewards)
  for _, v1 in ipairs(rewards) do
    local insert = true
    for _, v2 in ipairs(self.totalRewardList) do
      if v1.rewardType == v2.rewardType and v1.itemId == v2.itemId then
        v2.count = v1.count + v2.count
        insert = false
        break
      end
    end
    if insert then
      local v = DeepCopy(v1)
      table.insert(self.totalRewardList, v)
    end
  end
  self.flyRewardList = rewards
end

local function OnLevelExit(self)
  local state = self:GetAdventureState()
  if state == AdventureState.Playing then
    local param = {}
    param.pveEntrance = PveEntrance.Adventure
    param.levelId = self:GetCurrentPveLevel()
    param.abandon = true
    DataCenter.BattleLevel:Enter(param)
  end
end

local function OnLevelFinish(self)
  self.advInfo.justNowLevel = self.advInfo.nowLevel
end

local function OnBattleWin(self)
  local tip = self:GetSubTip()
  if tip ~= "" then
    UIUtil.ShowTips(tip)
  end
  TimerManager:GetInstance():DelayInvoke(function()
    self.canFlyReward = true
    self:UpdatePlayerHpBar()
    PveActorMgr:GetInstance():Leave()
  end, BattleWinDelay)
end

local function SendGetInfo(self)
end

local function SendSetArmy(self, heroes, army)
  SFSNetwork.SendMessage(MsgDefines.AdventureSetArmy, heroes, army)
end

local function SendStart(self)
  SFSNetwork.SendMessage(MsgDefines.AdventureStart)
end

local function SendContinue(self)
  SFSNetwork.SendMessage(MsgDefines.AdventureGetLevel)
end

local function SendSelect(self)
  self.canShowSubWindow = false
  SFSNetwork.SendMessage(MsgDefines.AdventureSelect, self.selectInfo.triggerId, self.selectInfo.type, self.selectInfo.subType, self.selectInfo.content)
end

local function SendReset(self)
  SFSNetwork.SendMessage(MsgDefines.AdventureReset)
end

local function SendRaid(self)
  self.advInfo.raidReward = {}
  SFSNetwork.SendMessage(MsgDefines.AdventureRaid)
  local param = {}
  param.animType = PveLoadingAnimType.Circle
  param.circleText = Localization:GetString("302280") .. "\n" .. Localization:GetString("302281")
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPVELoading, {
    anim = true,
    UIMainAnim = UIMainAnimType.LeftRightBottomHide,
    playEffect = 10004
  }, param)
end

local function SendGetRecord(self)
  SFSNetwork.SendMessage(MsgDefines.AdventureGetRecord)
end

local function SendGetRecordDetail(self)
  SFSNetwork.SendMessage(MsgDefines.AdventureGetRecordDetail)
end

local function HandleGetInfo(self, message)
  self:ParseAdventureInfo(message)
end

local function HandleSetArmy(self, message)
  self:ParseAdventureInfo(message)
  if self.autoRaid then
    self:SendStart()
  else
    local param = {}
    param.pveEntrance = PveEntrance.Adventure
    param.levelId = self:GetFirstPveLevel()
    param.abandon = true
    DataCenter.BattleLevel:Enter(param)
  end
end

local function HandleStart(self, message)
  self.canShowSubWindow = true
  self.totalRewardList = {}
  self:ParseAdventureInfo(message)
  if self.autoRaid then
    self:SendRaid()
  else
    if message.pveInfo then
      DataCenter.BattleLevel:OnStartLevelMessage(message.pveInfo)
    end
    UIUtil.ShowTips(Localization:GetString("302283", self.advInfo.nowLevel))
  end
end

local function HandleContinue(self, message)
  self.canShowSubWindow = true
  self:ParseAdventureInfo(message)
  if message.pveInfo then
    DataCenter.BattleLevel:OnStartLevelMessage(message.pveInfo)
  end
  UIUtil.ShowTips(Localization:GetString("302283", self.advInfo.nowLevel))
end

local function HandleSelect(self, message)
  local hasBattle = false
  self.advInfo.justNowLevel = self.advInfo.nowLevel
  self.canShowSubWindow = true
  if message.pveInfo then
    DataCenter.BattleLevel:OnFinishTriggerMessage(message.pveInfo)
  end
  if message.explorerInfo then
    self:ParseAdventureInfo(message.explorerInfo)
  end
  if message.battle then
    local battleContent = message.battle.battleContent or ""
    local detailContent = message.battle.detailContent or ""
    PveActorMgr:GetInstance():ParseData(battleContent, detailContent)
    hasBattle = true
  end
  if message.record then
    if self.selectInfo.type == message.record.type and self.selectInfo.subType == message.record.subType then
      local trigger = DataCenter.BattleLevel:GetTriggerByTriggerId(self.selectInfo.triggerId)
      DataCenter.BattleLevel:DoTrigger(trigger)
    else
      Logger.LogError("AdventureManager, HandleSelect: record check failed.")
      return
    end
    if message.record.paramObj then
      local paramObj = message.record.paramObj
      self.soliderChangeCache = paramObj.soldierChange or 0
      if paramObj.reward then
        DataCenter.RewardManager:AddRewardsAndRes(paramObj)
        self.rewardCache = paramObj.reward
        self:AddTotalReward(paramObj.reward)
      end
    end
  end
  if not hasBattle then
    local tip = self:GetSubTip()
    if tip ~= "" then
      UIUtil.ShowTips(tip)
    end
    self:UpdatePlayerHpBar()
  end
  if self.selectInfo.type == AdventureType.Reward or self.selectInfo.subType == AdventureType.Reward then
    self:UpdatePlayerHpBar()
    self.canFlyReward = true
    EventManager:GetInstance():Broadcast(EventId.AdventureInfoUpdate)
  end
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPVESelectAdventureSub)
end

local function HandleReset(self, message)
  self:ParseAdventureInfo(message)
  self.advInfo.raidReward = {}
  local param = {}
  param.pveEntrance = PveEntrance.AdventureSetting
  param.levelId = AdventureSettingLevelId
  param.abandon = true
  DataCenter.BattleLevel:Enter(param)
end

local function HandleRaid(self, message)
  self.autoRaid = false
  self.canShowSubWindow = true
  self.hasRaidResult = true
  self:ParseAdventureInfo(message)
  local param = {}
  param.pveEntrance = PveEntrance.Adventure
  param.levelId = self:GetCurrentPveLevel()
  param.abandon = true
  DataCenter.BattleLevel:Enter(param)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPVEAdventure)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPVEAdventureRaid)
  
  local function ShowRaidResult()
    local state = self:GetAdventureState()
    if state == AdventureState.Won then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIPVEResult, BattlePveConst.Result.Win, {showBtn = true})
    elseif state == AdventureState.Lost then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIPVEResult, BattlePveConst.Result.Fail, {showBtn = true})
    end
    self.canFlyReward = true
    EventManager:GetInstance():Broadcast(EventId.AdventureInfoUpdate)
  end
  
  if not table.IsNullOrEmpty(message.reward) then
    local title = Localization:GetString("302287", math.min(self.advInfo.nowLevel, self.finalLevel))
    DataCenter.RewardManager:ShowGiftReward(message, title, ShowRaidResult)
  else
    ShowRaidResult()
  end
  self.hasRaidResult = false
  local loadingWindow = UIManager:GetInstance():GetWindow(UIWindowNames.UIPVELoading)
  if loadingWindow then
    loadingWindow.View:Quit()
  end
  EventManager:GetInstance():Broadcast(EventId.AdventureRaid)
end

local function HandleGetRecord(self, message)
  local recordList = message.records or {}
  EventManager:GetInstance():Broadcast(EventId.AdventureGetRecord, recordList)
end

local function HandleGetRecordDetail(self, message)
end

AdventureManager.__init = __init
AdventureManager.__delete = __delete
AdventureManager.SetActivityData = SetActivityData
AdventureManager.SetSelectInfo = SetSelectInfo
AdventureManager.GetSelectInfo = GetSelectInfo
AdventureManager.GetBuffList = GetBuffList
AdventureManager.IsSameDay = IsSameDay
AdventureManager.GetFirstPveLevel = GetFirstPveLevel
AdventureManager.GetCurrentPveLevel = GetCurrentPveLevel
AdventureManager.GetTotalResetTime = GetTotalResetTime
AdventureManager.GetTodayRestResetTime = GetTodayRestResetTime
AdventureManager.GetAdventureInfo = GetAdventureInfo
AdventureManager.GetHeroCount = GetHeroCount
AdventureManager.GetAdventureState = GetAdventureState
AdventureManager.GetHeroUuidList = GetHeroUuidList
AdventureManager.GetAliveArmy = GetAliveArmy
AdventureManager.GetArmyCount = GetArmyCount
AdventureManager.IsArmyAlive = IsArmyAlive
AdventureManager.GetSubContent = GetSubContent
AdventureManager.GetBuffContentStrList = GetBuffContentStrList
AdventureManager.ParseAdventureInfo = ParseAdventureInfo
AdventureManager.CheckShowReward = CheckShowReward
AdventureManager.GetRaidState = GetRaidState
AdventureManager.GetSubTip = GetSubTip
AdventureManager.Start = Start
AdventureManager.StartPveLevel = StartPveLevel
AdventureManager.GetRaidPreviewRewardList = GetRaidPreviewRewardList
AdventureManager.CanTriggerShowArrow = CanTriggerShowArrow
AdventureManager.IsFinalLevel = IsFinalLevel
AdventureManager.UpdatePlayerHpBar = UpdatePlayerHpBar
AdventureManager.CanShowSubWindow = CanShowSubWindow
AdventureManager.AddTotalReward = AddTotalReward
AdventureManager.OnLevelExit = OnLevelExit
AdventureManager.OnLevelFinish = OnLevelFinish
AdventureManager.OnBattleWin = OnBattleWin
AdventureManager.SendGetInfo = SendGetInfo
AdventureManager.SendSetArmy = SendSetArmy
AdventureManager.SendStart = SendStart
AdventureManager.SendContinue = SendContinue
AdventureManager.SendSelect = SendSelect
AdventureManager.SendReset = SendReset
AdventureManager.SendRaid = SendRaid
AdventureManager.SendGetRecord = SendGetRecord
AdventureManager.SendGetRecordDetail = SendGetRecordDetail
AdventureManager.HandleGetInfo = HandleGetInfo
AdventureManager.HandleSetArmy = HandleSetArmy
AdventureManager.HandleStart = HandleStart
AdventureManager.HandleContinue = HandleContinue
AdventureManager.HandleSelect = HandleSelect
AdventureManager.HandleReset = HandleReset
AdventureManager.HandleRaid = HandleRaid
AdventureManager.HandleGetRecord = HandleGetRecord
AdventureManager.HandleGetRecordDetail = HandleGetRecordDetail
return AdventureManager
