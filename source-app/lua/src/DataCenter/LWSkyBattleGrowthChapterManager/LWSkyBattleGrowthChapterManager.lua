local LWSkyBattleGrowthChapterManager = BaseClass("LWSkyBattleGrowthChapterManager", CEventable)
local Localization = CS.GameEntry.Localization

function LWSkyBattleGrowthChapterManager:__init()
  self.currStageId = nil
  self.nextStageId = nil
  self.doneStageIds = {}
  self.chapterCfgs = {}
  self.chapterCfg = nil
  self.chapterReward = {}
  self.lastPlayChapterCfgId = nil
  self.chapterInited = false
  self.userInfoInited = false
  self.battleInfoInited = false
  self.maxStamina = 999
  self.staminaRecoverNum = 1
  self.staminaRecoverTime = 60000
  self.curSlotPower = 0
  self.curTotalPower = 0
  self.curSlotHp = 0
  self.curTotalHp = 0
  self.curSlotAttack = 0
  self.curTotalAttack = 0
  self.curSlotMemberNum = 0
  self.curSlotMemberPropPercent = 0
  self.curTotalMemberPropPercent = 0
  self.curTotalMemberNum = 0
  self.equipGroupToCfgs = {}
  LocalController:instance():visitTable(TableName.LW_SKY_BATTLE_EQUIP, function(id, lineData)
    local equipGroupId = lineData:getIntValue("group")
    if not self.equipGroupToCfgs[equipGroupId] then
      self.equipGroupToCfgs[equipGroupId] = {}
    end
    local groupLevelToCfgs = self.equipGroupToCfgs[equipGroupId]
    groupLevelToCfgs[lineData:getIntValue("level")] = lineData:getIntValue("id")
  end)
  self:RegisterEvent(EventId.SkyBattleWin, self.OnSkyBattleWin)
  self:RegisterEvent(EventId.GF_enter_city, self.OnEnterCity)
end

function LWSkyBattleGrowthChapterManager:__delete()
  self.currStageId = nil
  self.nextStageId = nil
  self.doneStageIds = nil
  self.chapterCfgs = nil
  self.chapterCfg = nil
  self.chapterIdToIndex = nil
  self.chapterRewardAlreadyGet = nil
  self.lastPlayChapterCfgId = nil
  self.autoOpenMapUIWhenBackToCity = nil
  self.chapterInited = false
  self.reward = nil
  self.rewardStageId = nil
  self.stageRewardShow = nil
  self.stageStarConditions = nil
  self.userInfoInited = false
  self.userInfo = nil
  self.battleInfoInited = false
  self.battlePlaneInfo = nil
  self.battleSlotInfo = nil
  self.battleEquipInfo = nil
  self.equipCfgProperties = nil
  self.planeCfgProperties = nil
  self.curSelectedPlaneData = nil
  self.equipGroupToCfgs = nil
  self.topLocationPowerEquip = nil
  self.maxStamina = 999
  self.staminaRecoverNum = 1
  self.staminaRecoverTime = 60000
  self.curSlotPower = 0
  self.curTotalPower = 0
  self.curSlotHp = 0
  self.curTotalHp = 0
  self.curSlotAttack = 0
  self.curTotalAttack = 0
  self.curSlotMemberNum = 0
  self.curSlotMemberPropPercent = 0
  self.curTotalMemberPropPercent = 0
  self.curTotalMemberNum = 0
  self.battleEquipVersion = 1
end

function LWSkyBattleGrowthChapterManager:Startup()
end

local function __FindNextStageId(self, fillDoneStageIds)
  self.nextStageId = nil
  local hitStageId = false
  for _, chapterCfg in ipairs(self.chapterCfgs) do
    if self.nextStageId ~= nil then
      break
    end
    for _, stageId in ipairs(chapterCfg.stageIds) do
      if hitStageId then
        self.nextStageId = stageId
        self.chapterCfg = chapterCfg
        break
      else
        if fillDoneStageIds then
          self.doneStageIds[stageId] = true
        end
        if stageId == self.currStageId then
          self.chapterCfg = chapterCfg
          hitStageId = true
        end
      end
    end
  end
  if not hitStageId and self.nextStageId == nil then
    self.chapterCfg = self.chapterCfgs[1]
    self.nextStageId = self.chapterCfg.stageIds[1]
    if fillDoneStageIds then
      self.doneStageIds = {}
    end
  end
end

function LWSkyBattleGrowthChapterManager:ChapterInited()
  return self.chapterInited
end

function LWSkyBattleGrowthChapterManager:UserInfoInited()
  return self.userInfoInited
end

function LWSkyBattleGrowthChapterManager:BattleInfoInited()
  return self.battleInfoInited
end

function LWSkyBattleGrowthChapterManager:InitChapterData(msg)
  if self.chapterInited then
    return
  end
  if not msg then
    return
  end
  self.chapterInited = true
  self.chapterReward = {}
  if msg.stageId then
    self.currStageId = msg.stageId
  end
  local chapterInfos = msg.chapterInfo
  self.chapterCfgs = {}
  local chapterTbl = LocalController:instance():getTable(TableName.LW_SKY_BATTLE_CHAPTER_UPGRADE)
  for chapterId, _ in pairs(chapterTbl.data) do
    local stageIds = LocalController:instance():getValue(TableName.LW_SKY_BATTLE_CHAPTER_UPGRADE, chapterId, "stages")
    local nodePosArr = {}
    local nodePosStrArr = LocalController:instance():getValue(TableName.LW_SKY_BATTLE_CHAPTER_UPGRADE, chapterId, "nodePos")
    for _, nodePosStr in ipairs(nodePosStrArr) do
      local nodePos = string.split(nodePosStr, ",")
      table.insert(nodePosArr, Vector3(tonumber(nodePos[1]), tonumber(nodePos[2]), 0))
    end
    local nodeTipStyleArr = LocalController:instance():getValue(TableName.LW_SKY_BATTLE_CHAPTER_UPGRADE, chapterId, "nodeTipStyle")
    local sign_up_day = LocalController:instance():getValue(TableName.LW_SKY_BATTLE_CHAPTER_UPGRADE, chapterId, "sign_up_day")
    local main_building_level = LocalController:instance():getValue(TableName.LW_SKY_BATTLE_CHAPTER_UPGRADE, chapterId, "main_building_level")
    local chapterExtraFromMsg
    if chapterInfos then
      for index, chapterInfo in ipairs(chapterInfos) do
        if chapterInfo.chapter == chapterId then
          chapterExtraFromMsg = chapterInfo
          break
        end
      end
    end
    local chapterRewardedIndex = chapterExtraFromMsg and chapterExtraFromMsg.rewardedTarget or nil
    local chapterBox = LocalController:instance():getValue(TableName.LW_SKY_BATTLE_CHAPTER_UPGRADE, chapterId, "chapter_box")
    local chapterBoxDatas = {}
    if not string.IsNullOrEmpty(chapterBox) then
      local chapterBoxStrs = string.split(chapterBox, ";")
      for i, boxStr in ipairs(chapterBoxStrs) do
        local boxDatas = string.split(boxStr, "|")
        if boxDatas and boxDatas[1] and boxDatas[2] then
          local completeNum = tonumber(boxDatas[1])
          local boxReward = tonumber(boxDatas[2])
          local got = chapterRewardedIndex and table.indexof(chapterRewardedIndex, completeNum) and true or false
          local boxData = {
            TargetCompleteNum = completeNum,
            RewardId = boxReward,
            Got = got
          }
          table.insert(chapterBoxDatas, boxData)
        end
      end
    end
    local chapterBgImg = LocalController:instance():getValue(TableName.LW_SKY_BATTLE_CHAPTER, chapterId, "bgImg")
    table.insert(self.chapterCfgs, {
      id = chapterId,
      stageIds = stageIds,
      nodePosArr = nodePosArr,
      nodeTipStyleArr = nodeTipStyleArr,
      sign_up_day = sign_up_day,
      main_building_level = main_building_level,
      boxDatas = {},
      boxDatas = chapterBoxDatas,
      stageExtraInfos = chapterExtraFromMsg and chapterExtraFromMsg.stageInfo or {},
      chapterBgImg = chapterBgImg
    })
  end
  table.sort(self.chapterCfgs, function(a, b)
    return a.id < b.id
  end)
  self.chapterIdToIndex = {}
  for index, chapterCfgData in ipairs(self.chapterCfgs) do
    if chapterCfgData then
      self.chapterIdToIndex[chapterCfgData.id] = index
    end
  end
  if not self.chapterCfg and #self.chapterCfgs > 0 then
    self.chapterCfg = self.chapterCfgs[1]
  end
  __FindNextStageId(self, true)
  EventManager:GetInstance():Broadcast(EventId.SkyBattleChapterMsgInit)
end

function LWSkyBattleGrowthChapterManager:UpdateStageStar(stageStarData)
  if not self.chapterInited then
    return
  end
  if not stageStarData then
    return
  end
  for i, chapterCfg in ipairs(self.chapterCfgs) do
    local alreadyHasStarData = false
    for i, stageExtraInfo in ipairs(chapterCfg.stageExtraInfos) do
      if stageExtraInfo.stageId == stageStarData.id then
        if stageStarData.star > stageExtraInfo.star then
          stageExtraInfo.star = stageStarData.star
        end
        alreadyHasStarData = true
        EventManager:GetInstance():Broadcast(EventId.SkyBattleChapterRefresh, chapterCfg.id)
        break
      end
    end
    if not alreadyHasStarData and table.indexof(chapterCfg.stageIds, stageStarData.id) then
      table.insert(chapterCfg.stageExtraInfos, {
        star = stageStarData.star,
        stageId = stageStarData.id
      })
      EventManager:GetInstance():Broadcast(EventId.SkyBattleChapterRefresh, chapterCfg.id)
    end
  end
end

local planeConfigKey = "plane_stamina_config"

function LWSkyBattleGrowthChapterManager:InitUserInfoData(msg)
  if self.userInfoInited then
    return
  end
  if not msg then
    return
  end
  self.userInfoInited = true
  self.maxStamina = LuaEntry.DataConfig:TryGetNum(planeConfigKey, "k1", 999)
  self.staminaRecoverNum = 1
  self.staminaRecoverTime = LuaEntry.DataConfig:TryGetNum(planeConfigKey, "k2", 300) * 1000
  self.userInfo = {}
  self.userInfo.stamina = msg.stamina or 0
  self.userInfo.lastStaminaTime = msg.lastStaminaTime or 0
  self.userInfo.coin = msg.coin or 0
  self.userInfo.planeId = msg.planeId or 0
  self:RefreshCurPlaneData()
  EventManager:GetInstance():Broadcast(EventId.SkyBattleChapterGrowthUserInfoInit)
end

function LWSkyBattleGrowthChapterManager:RefreshUserInfoData(msg)
  if not self.userInfoInited then
    return
  end
  if not msg then
    return
  end
  self.userInfo.stamina = msg.stamina or 0
  self.userInfo.lastStaminaTime = msg.lastStaminaTime or 0
  self.userInfo.coin = msg.coin or 0
  if msg.planeId ~= self.userInfo.planeId then
    self.userInfo.planeId = msg.planeId or 0
    self:RefreshCurPlaneData()
  end
  EventManager:GetInstance():Broadcast(EventId.SkyBattleChapterGrowthUserInfoRefresh)
end

function LWSkyBattleGrowthChapterManager:InitBattleInfoData(msg)
  if self.battleInfoInited then
    return
  end
  if not msg then
    return
  end
  self.battleInfoInited = true
  self.battlePlaneInfo = {}
  local skyBattlePlaneTbl = LocalController:instance():getTable(TableName.LW_SKY_BATTLE_PLANE)
  for skyBattlePlaneId, _ in pairs(skyBattlePlaneTbl.data) do
    local skyBattlePlaneData = {}
    skyBattlePlaneData.id = skyBattlePlaneId
    skyBattlePlaneData.owned = false
    table.insert(self.battlePlaneInfo, skyBattlePlaneData)
  end
  table.sort(self.battlePlaneInfo, function(a, b)
    return a.id < b.id
  end)
  if msg.planeList then
    for i, planeData in ipairs(msg.planeList) do
      for j, cfgPlaneData in ipairs(self.battlePlaneInfo) do
        if planeData.cfgId == cfgPlaneData.id then
          cfgPlaneData.owned = true
        end
      end
    end
  end
  self.battleEquipInfo = {}
  self.battleEquipVersion = 1
  self.topLocationPowerEquip = {}
  if msg.equipList then
    for i, equipData in ipairs(msg.equipList) do
      self.battleEquipInfo[i] = {}
      self.battleEquipInfo[i].uuid = equipData.uuid
      self.battleEquipInfo[i].ownerId = equipData.ownerId
      self.battleEquipInfo[i].group = equipData.group
      self.battleEquipInfo[i].cfgId = self.equipGroupToCfgs[equipData.group][1]
      self:InitEquipData(self.battleEquipInfo[i])
    end
    self:ResortEquipInfoDatas(self.battleEquipInfo)
    self:RefreshEquipTopPower(self.battleEquipInfo)
  end
  self.battleSlotInfo = {}
  if msg.slotInfo then
    for i, slotInfo in ipairs(msg.slotInfo) do
      local newSlotInfo = {}
      newSlotInfo.slot = slotInfo.slot
      newSlotInfo.uuid = slotInfo.uuid
      newSlotInfo.level = slotInfo.level
      self.battleSlotInfo[slotInfo.slot] = newSlotInfo
    end
    self:RefreshCurSlotData(true)
  end
  EventManager:GetInstance():Broadcast(EventId.SkyBattleChapterGrowthBattleInfoInit)
end

function LWSkyBattleGrowthChapterManager:InitEquipData(equipData)
  if not equipData then
    return
  end
  equipData.equipLocation = nil
  equipData.quality = nil
  equipData.power = nil
  equipData.level = nil
  equipData.chip = nil
  equipData.properties = nil
  equipData.icon = nil
  equipData.name = nil
  equipData.type = nil
  equipData.skill = nil
  local equipLocation = LocalController:instance():getValue(TableName.LW_SKY_BATTLE_EQUIP, equipData.cfgId, "Location")
  equipData.equipLocation = equipLocation
  local equipColor = LocalController:instance():getValue(TableName.LW_SKY_BATTLE_EQUIP, equipData.cfgId, "color")
  equipData.quality = tonumber(equipColor)
  local equipPower = LocalController:instance():getValue(TableName.LW_SKY_BATTLE_EQUIP, equipData.cfgId, "power")
  equipData.power = equipPower
  local level = LocalController:instance():getValue(TableName.LW_SKY_BATTLE_EQUIP, equipData.cfgId, "level")
  equipData.level = level
  local chip = LocalController:instance():getValue(TableName.LW_SKY_BATTLE_EQUIP, equipData.cfgId, "chip")
  equipData.chip = chip
  local properties = self:GetEquipCfgProperties(equipData.cfgId)
  equipData.properties = properties
  local icon = LocalController:instance():getValue(TableName.LW_SKY_BATTLE_EQUIP, equipData.cfgId, "icon")
  equipData.icon = icon
  local name = LocalController:instance():getValue(TableName.LW_SKY_BATTLE_EQUIP, equipData.cfgId, "name")
  equipData.name = name
  local type = LocalController:instance():getValue(TableName.LW_SKY_BATTLE_EQUIP, equipData.cfgId, "type")
  equipData.type = type
  local skill = LocalController:instance():getValue(TableName.LW_SKY_BATTLE_EQUIP, equipData.cfgId, "skill")
  equipData.skill = skill
end

function LWSkyBattleGrowthChapterManager:GetLocationTopPowerData(location)
  return self.topLocationPowerEquip[location]
end

function LWSkyBattleGrowthChapterManager:RefreshBattlePlaneInfoData(msg)
  if not self.battleInfoInited then
    return
  end
  if not msg or not msg.planeList then
    return
  end
  for i, planeData in ipairs(msg.planeList) do
    for j, cfgPlaneData in ipairs(self.battlePlaneInfo) do
      if planeData.cfgId == cfgPlaneData.id then
        cfgPlaneData.owned = true
      end
    end
  end
  EventManager:GetInstance():Broadcast(EventId.SkyBattleChapterGrowthBattlePlaneInfoRefresh)
end

function LWSkyBattleGrowthChapterManager:RefreshBattleSlotInfoData(msg)
  if not self.battleInfoInited then
    return
  end
  if not msg or not msg.slotInfo then
    return
  end
  for i, slotInfo in ipairs(msg.slotInfo) do
    local battleSlotInfo = self.battleSlotInfo[slotInfo.slot]
    if battleSlotInfo then
      battleSlotInfo.uuid = slotInfo.uuid or 0
      battleSlotInfo.level = slotInfo.level
    else
      local newSlotInfo = {}
      newSlotInfo.slot = slotInfo.slot
      newSlotInfo.uuid = slotInfo.uuid
      newSlotInfo.level = slotInfo.level
      self.battleSlotInfo[newSlotInfo.slot] = newSlotInfo
    end
  end
  self:RefreshCurSlotData(true)
  EventManager:GetInstance():Broadcast(EventId.SkyBattleChapterGrowthBattleSlotInfoRefresh)
end

function LWSkyBattleGrowthChapterManager:SlotUpdate(msg)
  if not self.battleInfoInited then
    return
  end
  if not msg or not msg.slot then
    return
  end
  self.battleSlotInfo[msg.slot].level = msg.level
  local changedSlot = {
    msg.slot
  }
  self:RefreshCurSlotData(false, changedSlot)
  EventManager:GetInstance():Broadcast(EventId.SkyBattleEquipSlotUpgrade, changedSlot)
end

function LWSkyBattleGrowthChapterManager:SlotEquipTakeOff(msg)
  if not self.battleInfoInited then
    return
  end
  if not msg or not msg.slot then
    return
  end
  for i, slotIndex in ipairs(msg.slot) do
    self.battleSlotInfo[slotIndex].uuid = 0
  end
  self:RefreshCurSlotData(false, msg.slot)
  EventManager:GetInstance():Broadcast(EventId.SkyBattleEquipUnInstall, msg.slot)
end

function LWSkyBattleGrowthChapterManager:SlotEquipTakeOn(msg)
  if not self.battleInfoInited then
    return
  end
  if not msg or not msg.slot2Uuid then
    return
  end
  local slots = {}
  for i, slotData in ipairs(msg.slot2Uuid) do
    self.battleSlotInfo[slotData.slot].uuid = slotData.uuid or 0
    table.insert(slots, slotData.slot)
  end
  self:RefreshCurSlotData(false, slots)
  EventManager:GetInstance():Broadcast(EventId.SkyBattleEquipInstall, slots)
end

function LWSkyBattleGrowthChapterManager:EquipRecycled(msg)
  if not self.battleInfoInited then
    return
  end
  if not msg or not msg.ids then
    return
  end
  EventManager:GetInstance():Broadcast(EventId.SkyBattleEquipRecycled, msg.ids)
end

function LWSkyBattleGrowthChapterManager:RefreshBattleEquipInfoData(msg)
  if not self.battleInfoInited then
    return
  end
  if not msg then
    return
  end
  local changed = false
  if msg.delList then
    for i, delEquipDataUUid in ipairs(msg.delList) do
      local toRemoveIndex = 0
      for j, equipData in ipairs(self.battleEquipInfo) do
        if equipData.uuid == delEquipDataUUid then
          toRemoveIndex = j
          break
        end
      end
      if toRemoveIndex ~= 0 then
        table.remove(self.battleEquipInfo, toRemoveIndex)
        changed = true
      end
    end
  end
  if msg.equipList then
    for i, addEquipData in ipairs(msg.equipList) do
      local addEquipDataUUid = addEquipData.uuid
      local alreadyOwned = false
      for j, equipData in ipairs(self.battleEquipInfo) do
        if equipData.uuid == addEquipDataUUid then
          alreadyOwned = true
          equipData.ownerId = addEquipData.ownerId
          equipData.group = addEquipData.group
          equipData.cfgId = self.equipGroupToCfgs[addEquipData.group][1]
          self:InitEquipData(equipData)
          break
        end
      end
      if not alreadyOwned then
        local cfgId = self.equipGroupToCfgs[addEquipData.group][1]
        local equipData = {
          uuid = addEquipData.uuid,
          ownerId = addEquipData.ownerId,
          cfgId = cfgId,
          group = addEquipData.group
        }
        self:InitEquipData(equipData)
        table.insert(self.battleEquipInfo, equipData)
      end
      changed = true
    end
  end
  if changed then
    self.battleEquipVersion = self.battleEquipVersion + 1
    self:ResortEquipInfoDatas(self.battleEquipInfo)
    self:RefreshEquipTopPower(self.battleEquipInfo)
  end
  EventManager:GetInstance():Broadcast(EventId.SkyBattleChapterGrowthBattleEquipInfoRefresh)
end

function LWSkyBattleGrowthChapterManager:AddRewardsAndRes(rewards)
  if not rewards then
    return
  end
  for i, sReward in ipairs(rewards) do
    if sReward.type == SkyBattleRewardType.Coin and self.userInfoInited then
      self.userInfo.coin = self.userInfo.coin + (sReward.num or 0)
      EventManager:GetInstance():Broadcast(EventId.SkyBattleChapterGrowthUserInfoRefresh)
    end
  end
end

function LWSkyBattleGrowthChapterManager:ResortEquipInfoDatas(equips)
  if not equips then
    return
  end
  table.sort(equips, function(a, b)
    if a.quality ~= b.quality then
      return a.quality > b.quality
    end
    if a.equipLocation ~= b.equipLocation then
      return a.equipLocation < b.equipLocation
    end
  end)
end

function LWSkyBattleGrowthChapterManager:RefreshEquipTopPower(equips)
  if not equips then
    return
  end
  self.topLocationPowerEquip = {}
  for i, equipInfo in ipairs(equips) do
    local equipLocation = equipInfo.equipLocation
    local equipPower = equipInfo.power
    if not equipLocation then
      return
    end
    if not self.topLocationPowerEquip[equipLocation] then
      self.topLocationPowerEquip[equipLocation] = {
        uuid = equipInfo.uuid,
        power = equipPower
      }
    else
      local topPowerEquipData = self.topLocationPowerEquip[equipLocation]
      if equipPower > topPowerEquipData.power then
        topPowerEquipData.power = equipPower
        topPowerEquipData.uuid = equipInfo.uuid
      end
    end
  end
end

function LWSkyBattleGrowthChapterManager:GetEquipInfoDatasByType(location, excludeEquipUuid)
  if not self.battleInfoInited then
    return {}
  end
  local equipInfos = {}
  for i, equipInfo in ipairs(self.battleEquipInfo) do
    if equipInfo.equipLocation == location and (not excludeEquipUuid or not table.indexof(excludeEquipUuid, equipInfo.uuid)) then
      table.insert(equipInfos, equipInfo)
    end
  end
  return equipInfos
end

function LWSkyBattleGrowthChapterManager:OnEnterGame()
end

function LWSkyBattleGrowthChapterManager:EnterChapterStage(chapterId, stageId)
  if not chapterId then
    return
  end
  if not stageId then
    return
  end
  local param = {}
  param.type = PVEType.SkyBattle
  param.levelId = tonumber(stageId)
  param.fromChapter = true
  param.growthMode = true
  DataCenter.LWBattleManager:Enter(param)
  self.autoOpenMapUIWhenBackToCity = true
  self:SetCurPlayChapterId(chapterId)
end

function LWSkyBattleGrowthChapterManager:FindNextChapterStage(stageId)
  if not self.lastPlayChapterCfgId then
    return false
  end
  local lastPlayChapterCfg = self:GetChapterCfgData(self.lastPlayChapterCfgId)
  if not lastPlayChapterCfg then
    return false
  end
  local chapterStageIds = lastPlayChapterCfg.stageIds
  local curStageIndex = table.indexof(chapterStageIds, stageId)
  if not curStageIndex then
    return false
  end
  if curStageIndex >= #chapterStageIds then
    local index = table.indexof(self.chapterCfgs, lastPlayChapterCfg)
    if not index then
      return false
    end
    index = index + 1
    local nextChapterCfg = self.chapterCfgs[index]
    if not nextChapterCfg then
      return false
    end
    return true, nextChapterCfg.id, nextChapterCfg.stageIds[1]
  else
    return true, lastPlayChapterCfg.id, chapterStageIds[curStageIndex + 1]
  end
end

function LWSkyBattleGrowthChapterManager:CheckChapterStageMatchEnterCondition(chapterId, stageId, battleWin)
  if not self:IsOpen() then
    UIUtil.ShowTipsId(Localization:GetString("undo_system_toast_failed_desc003"))
    return false
  end
  local chapterCfgData = self:GetChapterCfgData(chapterId)
  if not chapterCfgData then
    return false
  end
  local sign_up_day = chapterCfgData.sign_up_day
  local main_building_level = chapterCfgData.main_building_level
  local regTime = LuaEntry.Player.openServerTime
  local regZero = regTime - (regTime + UITimeManager:GetInstance().changeDeltaTime) % 86400000
  local now = UITimeManager:GetInstance():GetServerTime()
  local regDiff = now - regZero
  local regDay = regDiff / 86400000 + 1
  if sign_up_day > regDay then
    local remain = Mathf.Floor(sign_up_day - regDay)
    local diff = 86400000 - (now + UITimeManager:GetInstance().changeDeltaTime) % 86400000 + remain * 86400000
    local time = UITimeManager:GetInstance():MilliSecondToFmtStringSpecial(diff)
    local tipMsg = Localization:GetString("plane_chapter_unlock_desc_01", time)
    UIUtil.ShowMessage(tipMsg, 1, nil, 801037)
    return false
  end
  local curLevel = DataCenter.BuildManager.MainLv
  if main_building_level > curLevel then
    local buildingNameKey = LocalController:instance():getValue(LuaEntry.Player:GetABTestTableName(TableName.Building), BuildingTypes.FUN_BUILD_MAIN, "name")
    local tipMsg = Localization:GetString(800371, Localization:GetString(buildingNameKey), tostring(main_building_level))
    UIUtil.ShowMessage(tipMsg, 2, 801037, 393010, function()
      GoToUtil.CloseAllWindows()
      if battleWin then
        DataCenter.LWBattleManager:Exit(nil, "win")
      end
      GoToUtil.GotoCityByBuildId(BuildingTypes.FUN_BUILD_MAIN, WorldTileBtnType.City_Upgrade)
    end)
    return false
  end
  if not self:UserInfoInited() then
    return false
  end
  local staminaToChallenge = LocalController:instance():getValue(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage_SkyBattle), stageId, "stamina")
  local staminaToChallengeNum = tonumber(staminaToChallenge)
  local timeToWait = self:CalTimeToMatchStamina(staminaToChallengeNum)
  if 0 < timeToWait then
    local formatTimeToWait = UITimeManager:GetInstance():SecondToFmtStringWithoutDay(math.ceil(timeToWait / 1000))
    UIUtil.ShowTipsId(string.format("NoKey-No Enough Stamina,wait time %s", formatTimeToWait))
    return false
  end
  return true
end

function LWSkyBattleGrowthChapterManager:CacheReward(stageId, reward)
  self.reward = reward
  self.rewardStageId = stageId
end

function LWSkyBattleGrowthChapterManager:SetCurPlayChapterId(chapterId)
  self.lastPlayChapterCfgId = chapterId
end

function LWSkyBattleGrowthChapterManager:GetCurPlayChapterId()
  return self.lastPlayChapterCfgId
end

function LWSkyBattleGrowthChapterManager:IsAllDone()
  return self.nextStageId == nil
end

function LWSkyBattleGrowthChapterManager:IsOpen()
  local actData = DataCenter.ActivityListDataManager:GetOneOpenActivityByType(EnumActivity.ActSkyBattleGrowth.Type)
  if actData then
    return DataCenter.ActivityListDataManager:CheckIsSend(actData)
  else
    return false
  end
end

function LWSkyBattleGrowthChapterManager:GetEndTime()
  if not self:IsOpen() then
    return -1
  end
  local actData = DataCenter.ActivityListDataManager:GetOneOpenActivityByType(EnumActivity.ActSkyBattleGrowth.Type)
  if actData then
    return actData.endTime
  end
  return -1
end

function LWSkyBattleGrowthChapterManager:UpdateBoxRewardData(newRewardGetMsg)
  if newRewardGetMsg.chapter and newRewardGetMsg.rewardedTarget then
    local chapterIndex = self.chapterIdToIndex[newRewardGetMsg.chapter]
    local chapter = self.chapterCfgs[chapterIndex]
    if chapter then
      local boxDatas = chapter.boxDatas
      for i, boxData in ipairs(boxDatas) do
        local got = table.indexof(newRewardGetMsg.rewardedTarget, boxData.TargetCompleteNum) and true or false
        if not boxData.Got and got then
          boxData.Got = got
        end
      end
    end
    EventManager:GetInstance():Broadcast(EventId.SkyBattleChapterRewardBoxUpdate, newRewardGetMsg.chapter)
  end
end

function LWSkyBattleGrowthChapterManager:OnSkyBattleWin(stageId)
  local isNextStageId = self.nextStageId and self.nextStageId == stageId
  if not isNextStageId then
    return
  end
  self.doneStageIds[stageId] = true
  if isNextStageId then
    self.currStageId = stageId
    __FindNextStageId(self, false)
  end
end

function LWSkyBattleGrowthChapterManager:GetStageBelongsChapterCfgData(targetStageId)
  for _, chapterCfg in ipairs(self.chapterCfgs) do
    for _, stageId in ipairs(chapterCfg.stageIds) do
      if stageId == targetStageId then
        return chapterCfg
      end
    end
  end
  return nil
end

function LWSkyBattleGrowthChapterManager:GetChapterCfgData(chapterId)
  local chapterCfgIndex = self.chapterIdToIndex[chapterId]
  if not chapterCfgIndex then
    return nil
  end
  return self.chapterCfgs[chapterCfgIndex]
end

function LWSkyBattleGrowthChapterManager:OnEnterCity()
  if self.autoOpenMapUIWhenBackToCity then
    self.autoOpenMapUIWhenBackToCity = nil
    local skyBattleIsOpen = self:IsOpen()
    if skyBattleIsOpen then
      DataCenter.LWBattleManager:SetBattleExitStartTime(BattleExitTimeLogType.SkyBattle)
      local ultraHigh
      if DataCenter.LWBattleManager:IsOpenReturnOpt() then
        ultraHigh = true
      end
      UIManager:GetInstance():OpenWindow(UIWindowNames.LWStageSkyBattleChapter, {anim = true, ultraHigh = ultraHigh}, {growMode = true})
    end
  end
end

function LWSkyBattleGrowthChapterManager:IsChapterFinsh(chapterCfg)
  local stageIds = chapterCfg.stageIds
  for i, stageId in ipairs(stageIds) do
    if not self.doneStageIds[stageId] then
      return false
    end
  end
  return true
end

function LWSkyBattleGrowthChapterManager:GetStageStarCondition(stageId)
  if not self.stageStarConditions then
    self.stageStarConditions = {}
  end
  if not self.stageStarConditions[stageId] then
    self.stageStarConditions[stageId] = {}
    local stageStarConditionStr = LocalController:instance():getValue(TableName.LW_Stage_SkyBattle, stageId, "star_condition")
    if not string.IsNullOrEmpty(stageStarConditionStr) then
      local conditionStrs = string.split(stageStarConditionStr, "|")
      if conditionStrs then
        for i, conditionStr in ipairs(conditionStrs) do
          local conditionParams = string.split(conditionStr, ",")
          table.insert(self.stageStarConditions[stageId], {
            type = not string.IsNullOrEmpty(conditionParams[1]) and tonumber(conditionParams[1]) or 0,
            value = not string.IsNullOrEmpty(conditionParams[2]) and tonumber(conditionParams[2]) or 0
          })
        end
      end
    end
  end
  return self.stageStarConditions[stageId]
end

function LWSkyBattleGrowthChapterManager:GetConditionLocalKey(conditionType, conditionValue)
  if conditionType == BattleStarCondition.Success then
    return Localization:GetString("plane_chapter_detail_05")
  elseif conditionType == BattleStarCondition.HPPercent then
    return Localization:GetString("plane_chapter_detail_07", math.ceil(conditionValue * 0.01))
  elseif conditionType == BattleStarCondition.StageSuccessTime then
    return Localization:GetString("plane_chapter_detail_06", conditionValue)
  elseif conditionType == BattleStarCondition.MemberNum then
    return Localization:GetString("plane_chapter_detail_12", conditionValue)
  else
    return ""
  end
end

function LWSkyBattleGrowthChapterManager:GetStageRewardShow(stageId)
  if not self.stageRewardShow then
    self.stageRewardShow = {}
  end
  if not self.stageRewardShow[stageId] then
    local rewardDatas = {}
    local rewardArrayStr = LocalController:instance():getValue(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage_SkyBattle), stageId, "plane_upgrade_reward")
    if not string.IsNullOrEmpty(rewardArrayStr) then
      local rewardStrArray = string.split(rewardArrayStr, "|")
      if rewardStrArray then
        for _, rewardStr in ipairs(rewardStrArray) do
          local rewardData = self:ParseOneRewardStr(rewardStr)
          if rewardData then
            table.insert(rewardDatas, rewardData)
          end
        end
      end
    end
    self.stageRewardShow[stageId] = rewardDatas
  end
  return self.stageRewardShow[stageId]
end

function LWSkyBattleGrowthChapterManager:ParseOneRewardStr(str)
  if str == nil or str == "" then
    return nil
  end
  local _rewardType, id, _num = string.match(str, "(%d+)[,](%d+)[,](%d+)")
  if id == nil then
    return nil
  end
  id = tonumber(id)
  return self:ParseOneData(id, tonumber(_rewardType), _num)
end

function LWSkyBattleGrowthChapterManager:ParseOneData(id, rewardType, count)
  local item
  if rewardType == SkyBattleRewardType.Coin then
    item = {}
    item.iconName = "Assets/Main/Sprites/UI/LWUIStageSkyBattleChapter/FX_feiji_ranliao_icon.png"
    item.itemColor = self:GetQualityIcon(3)
    item.itemName = Localization:GetString("Coin")
    item.itemDesc = Localization:GetString("more more good,day day up")
  elseif rewardType == SkyBattleRewardType.Plane then
    local planeCfgData = LocalController:instance():tryGetLine(TableName.LW_SKY_BATTLE_PLANE, id)
    if planeCfgData then
      item = {}
      item.iconName = planeCfgData:getValue("icon")
      item.itemColor = self:GetQualityIcon(planeCfgData:getValue("color"))
      item.itemName = Localization:GetString(planeCfgData:getValue("name"))
      item.itemDesc = Localization:GetString("play play play")
    end
  elseif rewardType == SkyBattleRewardType.Equip then
    local equipCfgId = self.equipGroupToCfgs[id][1]
    local equip = LocalController:instance():tryGetLine(TableName.LW_SKY_BATTLE_EQUIP, equipCfgId)
    if equip ~= nil then
      item = {}
      item.iconName = equip:getValue("icon")
      item.itemColor = self:GetQualityIcon(equip:getValue("color"))
      item.itemName = Localization:GetString(equip:getValue("name"))
      item.itemDesc = Localization:GetString(equip:getValue("desc"))
    end
  end
  if item ~= nil then
    item.itemId = tonumber(id)
    item.count = count
    item.rewardType = rewardType
  end
  return item
end

function LWSkyBattleGrowthChapterManager:ReturnRewardParamForMessage(rewards)
  if not rewards then
    return {}
  end
  local showedReward = {}
  for i, sReward in ipairs(rewards) do
    local rewardType = SkyBattleRewardType.Coin
    local rewardId = sReward.itemId
    local count = sReward.num
    if sReward.type ~= 1 then
      rewardType = sReward.type
    end
    local item = self:ParseOneData(rewardId, rewardType, count)
    if item then
      table.insert(showedReward, item)
    end
  end
  return showedReward
end

function LWSkyBattleGrowthChapterManager:CalStaminaToShow()
  if not self.userInfoInited then
    return 0
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local timeDeltaSinceLastChange = Mathf.Max(0, curTime - self.userInfo.lastStaminaTime)
  local targetStaminaShow = self.userInfo.stamina + timeDeltaSinceLastChange // self.staminaRecoverTime * self.staminaRecoverNum
  targetStaminaShow = Mathf.Min(self.maxStamina, targetStaminaShow)
  return targetStaminaShow
end

function LWSkyBattleGrowthChapterManager:CalTimeToMatchStamina(targetStamina)
  if not self.userInfoInited then
    return 0
  end
  if not targetStamina then
    return 0
  end
  if targetStamina <= self.userInfo.stamina then
    return 0
  end
  local deltaStamina = targetStamina - self.userInfo.stamina
  local deltaTimeToMatch = math.ceil(deltaStamina / self.staminaRecoverNum) * self.staminaRecoverTime
  local targetTimeToMatch = self.userInfo.lastStaminaTime + deltaTimeToMatch
  local curTime = UITimeManager:GetInstance():GetServerTime()
  return Mathf.Max(0, targetTimeToMatch - curTime)
end

function LWSkyBattleGrowthChapterManager:GetEquipCfgProperties(cfgId)
  if not self.equipCfgProperties then
    self.equipCfgProperties = {}
  end
  if not self.equipCfgProperties[cfgId] then
    local propertiesData = {}
    local equipPropertyStr = LocalController:instance():getValue(TableName.LW_SKY_BATTLE_EQUIP, cfgId, "property")
    if not string.IsNullOrEmpty(equipPropertyStr) then
      local propertyItemsStr = string.split(equipPropertyStr, ";")
      if propertyItemsStr then
        for i, propertyItemStr in ipairs(propertyItemsStr) do
          if not string.IsNullOrEmpty(propertyItemStr) then
            local propertyData = {}
            local propertyStrPairs = string.split(propertyItemStr, "|")
            propertyData.type = not string.IsNullOrEmpty(propertyStrPairs[1]) and tonumber(propertyStrPairs[1]) or 0
            propertyData.value = not string.IsNullOrEmpty(propertyStrPairs[2]) and tonumber(propertyStrPairs[2]) or 0
            propertiesData[propertyData.type] = propertyData
          end
        end
      end
    end
    self.equipCfgProperties[cfgId] = propertiesData
  end
  return self.equipCfgProperties[cfgId]
end

function LWSkyBattleGrowthChapterManager:GetPlaneCfgProperties(cfgId)
  if not self.planeCfgProperties then
    self.planeCfgProperties = {}
  end
  if not self.planeCfgProperties[cfgId] then
    local propertiesData = {}
    local planePropertyStr = LocalController:instance():getValue(TableName.LW_SKY_BATTLE_PLANE, cfgId, "property")
    if not string.IsNullOrEmpty(planePropertyStr) then
      local propertyItemsStr = string.split(planePropertyStr, ";")
      if propertyItemsStr then
        for i, propertyItemStr in ipairs(propertyItemsStr) do
          if not string.IsNullOrEmpty(propertyItemStr) then
            local propertyData = {}
            local propertyStrPairs = string.split(propertyItemStr, "|")
            propertyData.type = not string.IsNullOrEmpty(propertyStrPairs[1]) and tonumber(propertyStrPairs[1]) or 0
            propertyData.value = not string.IsNullOrEmpty(propertyStrPairs[2]) and tonumber(propertyStrPairs[2]) or 0
            propertiesData[propertyData.type] = propertyData
          end
        end
      end
    end
    self.planeCfgProperties[cfgId] = propertiesData
  end
  return self.planeCfgProperties[cfgId]
end

function LWSkyBattleGrowthChapterManager:RefreshCurPlaneData()
  if not self.curSelectedPlaneData then
    self.curSelectedPlaneData = {}
  end
  self.curSelectedPlaneData.planeId = self.userInfo.planeId
  if self.userInfo.planeId and self.userInfo.planeId ~= 0 then
    self.curSelectedPlaneData.planeId = self.userInfo.planeId
    self.curSelectedPlaneData.planePower = LocalController:instance():getValue(TableName.LW_SKY_BATTLE_PLANE, self.userInfo.planeId, "power") or 0
    local properties = self:GetPlaneCfgProperties(self.userInfo.planeId)
    self.curSelectedPlaneData.planeProperties = properties
    self.curSelectedPlaneData.planeHp = properties[SkyBattlePlanePropertiesType.HPNum] and properties[SkyBattlePlanePropertiesType.HPNum].value or 0
    self.curSelectedPlaneData.planeAttack = properties[SkyBattlePlanePropertiesType.Attack] and properties[SkyBattlePlanePropertiesType.Attack].value or 0
    self.curSelectedPlaneData.planeMember = properties[SkyBattlePlanePropertiesType.MemberNum] and properties[SkyBattlePlanePropertiesType.MemberNum].value or 0
    self.curSelectedPlaneData.planeMemberPropPercent = properties[SkyBattlePlanePropertiesType.MemberPropPercent] and properties[SkyBattlePlanePropertiesType.MemberPropPercent].value or 0
    self.curSelectedPlaneData.heroId = LocalController:instance():getValue(TableName.LW_SKY_BATTLE_PLANE, self.userInfo.planeId, "hero_id") or 0
    self.curSelectedPlaneData.planePrefabPath = LocalController:instance():getValue(TableName.LW_SKY_BATTLE_PLANE, self.userInfo.planeId, "prefab")
  else
    self.curSelectedPlaneData.planeId = 0
    self.curSelectedPlaneData.planePower = 0
    self.curSelectedPlaneData.planeProperties = nil
    self.curSelectedPlaneData.planeHp = 0
    self.curSelectedPlaneData.planeAttack = 0
    self.curSelectedPlaneData.heroId = 0
    self.curSelectedPlaneData.planeMemberPropPercent = 0
    self.curSelectedPlaneData.planeMember = 0
    self.curSelectedPlaneData.planePrefabPath = nil
  end
  self.curTotalPower = self.curSelectedPlaneData.planePower + self.curSlotPower
  self.curTotalHp = self.curSelectedPlaneData.planeHp + self.curSlotHp
  self.curTotalAttack = self.curSelectedPlaneData.planeAttack + self.curSlotAttack
  self.curTotalMemberPropPercent = self.curSelectedPlaneData.planeMemberPropPercent + self.curSlotMemberPropPercent
  self.curTotalMemberNum = self.curSelectedPlaneData.planeMember + self.curSlotMemberNum
end

function LWSkyBattleGrowthChapterManager:GetCurSelectedPlaneData()
  return self.curSelectedPlaneData
end

function LWSkyBattleGrowthChapterManager:GetEquipGroupMaxLevel(group)
  local groupCfgs = self.equipGroupToCfgs[group]
  if not groupCfgs then
    return 1
  end
  return #groupCfgs
end

function LWSkyBattleGrowthChapterManager:RefreshCurSlotData(allSlot, changedSlots)
  self.curSlotPower = 0
  self.curSlotHp = 0
  self.curSlotAttack = 0
  self.curSlotMemberNum = 0
  self.curSlotMemberPropPercent = 0
  for i = 1, 4 do
    local slotInfo = self.battleSlotInfo[i]
    if slotInfo then
      if slotInfo.uuid and slotInfo.uuid ~= 0 then
        if slotInfo.equipInfo and slotInfo.equipInfo.uuid ~= slotInfo.uuid then
          slotInfo.equipInfo.wearing = nil
        end
        local equipInfo = self:GetEquip(slotInfo.uuid)
        local equipCfgPower = slotInfo.power
        local slotProperties = slotInfo.properties
        local slotChanged = changedSlots ~= nil and table.indexof(changedSlots, i) or true
        slotInfo.equipInfo = equipInfo
        if equipInfo and (allSlot or slotChanged) then
          local equipCfgId = self.equipGroupToCfgs[equipInfo.group] and self.equipGroupToCfgs[equipInfo.group][slotInfo.level] or 0
          equipCfgPower = LocalController:instance():getValue(TableName.LW_SKY_BATTLE_EQUIP, equipCfgId, "power", 0)
          slotProperties = self:GetEquipCfgProperties(equipCfgId)
          slotInfo.properties = slotProperties
          slotInfo.power = equipCfgPower
          slotInfo.cfgId = equipCfgId
          local equipCfgQuality = LocalController:instance():getValue(TableName.LW_SKY_BATTLE_EQUIP, equipCfgId, "color", 3)
          slotInfo.quality = equipCfgQuality
          local equipCfgDesc = LocalController:instance():getValue(TableName.LW_SKY_BATTLE_EQUIP, equipCfgId, "desc", "")
          slotInfo.desc = equipCfgDesc
          local equipCfgIcon = LocalController:instance():getValue(TableName.LW_SKY_BATTLE_EQUIP, equipCfgId, "icon", "")
          slotInfo.icon = equipCfgIcon
          local equipCfgName = LocalController:instance():getValue(TableName.LW_SKY_BATTLE_EQUIP, equipCfgId, "name", "")
          slotInfo.name = equipCfgName
          local equipCfgUpgradeChip = LocalController:instance():getValue(TableName.LW_SKY_BATTLE_EQUIP, equipCfgId, "upgrade_chip", 0)
          slotInfo.upgradeChip = equipCfgUpgradeChip
          local equipSkill = LocalController:instance():getValue(TableName.LW_SKY_BATTLE_EQUIP, equipCfgId, "skill", 0)
          slotInfo.skill = tonumber(equipSkill)
          slotInfo.equipInfo.wearing = true
        end
        if slotProperties then
          self.curSlotPower = self.curSlotPower + equipCfgPower
          self.curSlotHp = self.curSlotHp + (slotProperties[SkyBattleEquipType.HP] and slotProperties[SkyBattleEquipType.HP].value or 0)
          self.curSlotAttack = self.curSlotAttack + (slotProperties[SkyBattleEquipType.Attack] and slotProperties[SkyBattleEquipType.Attack].value or 0)
          self.curSlotMemberPropPercent = self.curSlotMemberPropPercent + (slotProperties[SkyBattleEquipType.MemberPropPercent] and slotProperties[SkyBattleEquipType.MemberPropPercent].value or 0)
          self.curSlotMemberNum = self.curSlotMemberNum + (slotProperties[SkyBattleEquipType.MemberNum] and slotProperties[SkyBattleEquipType.MemberNum].value or 0)
        end
      else
        if slotInfo.equipInfo then
          slotInfo.equipInfo.wearing = nil
        end
        slotInfo.equipInfo = nil
        slotInfo.properties = nil
        slotInfo.power = nil
        slotInfo.cfgId = nil
        slotInfo.quality = nil
        slotInfo.desc = nil
        slotInfo.icon = nil
        slotInfo.name = nil
        slotInfo.upgradeChip = nil
        slotInfo.skill = nil
      end
    end
  end
  local planePower = self.curSelectedPlaneData and self.curSelectedPlaneData.planePower or 0
  self.curTotalPower = planePower + self.curSlotPower
  local planeHp = self.curSelectedPlaneData and self.curSelectedPlaneData.planeHp or 0
  self.curTotalHp = planeHp + self.curSlotHp
  local planeAttack = self.curSelectedPlaneData and self.curSelectedPlaneData.planeAttack or 0
  self.curTotalAttack = planeAttack + self.curSlotAttack
  local planeMemberNum = self.curSelectedPlaneData and self.curSelectedPlaneData.planeMember or 0
  self.curTotalMemberNum = planeMemberNum + self.curSlotMemberNum
  local planeMemberPropPercent = self.curSelectedPlaneData and self.curSelectedPlaneData.planeMemberPropPercent or 0
  self.curTotalMemberPropPercent = planeMemberPropPercent + self.curSlotMemberPropPercent
end

function LWSkyBattleGrowthChapterManager:GetCurTotalPower()
  return self.curTotalPower or 0
end

function LWSkyBattleGrowthChapterManager:GetPropertyValue(propertyType)
  if propertyType == SkyBattleEquipType.HP then
    return self.curTotalHp
  elseif propertyType == SkyBattleEquipType.Attack then
    return self.curTotalAttack
  elseif propertyType == SkyBattleEquipType.MemberPropPercent then
    return self.curTotalMemberPropPercent
  elseif propertyType == SkyBattleEquipType.MemberNum then
    return self.curTotalMemberNum
  end
end

function LWSkyBattleGrowthChapterManager:GetPlanePropertyNameKey(propertyType)
  if propertyType == SkyBattlePlanePropertiesType.HPNum then
    return "NoKey-HP"
  elseif propertyType == SkyBattlePlanePropertiesType.Attack then
    return "NoKey-Attack"
  elseif propertyType == SkyBattlePlanePropertiesType.MemberNum then
    return "NoKey-MemNum"
  elseif propertyType == SkyBattlePlanePropertiesType.MemberPropPercent then
    return "NoKey-MemberPropPec"
  end
end

function LWSkyBattleGrowthChapterManager:GetEquipPropertyNameKey(propertyType)
  if propertyType == SkyBattleEquipType.HP then
    return "NoKey-HP"
  elseif propertyType == SkyBattleEquipType.Attack then
    return "NoKey-Attack"
  elseif propertyType == SkyBattleEquipType.MemberPropPercent then
    return "NoKey-MemProperty"
  elseif propertyType == SkyBattleEquipType.MemberNum then
    return "NoKey-MemCount"
  end
end

function LWSkyBattleGrowthChapterManager:GetEquip(equipUUid)
  if not self.battleInfoInited then
    return nil
  end
  for i, equipData in ipairs(self.battleEquipInfo) do
    if equipData.uuid == equipUUid then
      return equipData
    end
  end
end

function LWSkyBattleGrowthChapterManager:GetQualityIcon(quality)
  if quality == nil then
    quality = 3
  end
  quality = tonumber(quality)
  quality = math.max(3, math.min(quality, 6))
  if quality == 3 then
    return "Assets/Main/Sprites/UI/LWUIStageSkyBattleChapter/FX_feiji_daojukuang_lan.png"
  elseif quality == 4 then
    return "Assets/Main/Sprites/UI/LWUIStageSkyBattleChapter/FX_feiji_daojukuang_zi.png"
  elseif quality == 5 then
    return "Assets/Main/Sprites/UI/LWUIStageSkyBattleChapter/FX_feiji_daojukuang_cheng.png"
  elseif quality == 6 then
    return "Assets/Main/Sprites/UI/LWUIStageSkyBattleChapter/FX_feiji_daojukuang_hong.png"
  end
end

function LWSkyBattleGrowthChapterManager:GetResourceIconByType(resType)
  if resType == ResourceType.SkyBattleGold then
    return "Assets/Main/Sprites/UI/LWUIStageSkyBattleChapter/FX_feiji_ranliao_icon.png"
  end
end

function LWSkyBattleGrowthChapterManager:GetResourceNameByType(resType)
  if resType == ResourceType.SkyBattleGold then
    return "No-Key-Chip"
  end
end

return LWSkyBattleGrowthChapterManager
