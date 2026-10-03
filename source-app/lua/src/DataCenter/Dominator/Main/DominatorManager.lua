local DominatorManager = BaseClass("DominatorManager")
local DominatorInfo = require("DataCenter/Dominator/Main/DominatorInfo")
local DominatorGorillaInfo = require("DataCenter/Dominator/Main/DominatorGorillaInfo")
local DominatorCockatriceInfo = require("DataCenter/Dominator/Main/DominatorCockatriceInfo")
local DominatorTrainInfo = require("DataCenter/Dominator/Train/DominatorTrainInfo")
local DominatorUtils = require("DataCenter.Dominator.Main.DominatorUtils")

function DominatorManager:__init()
  self.dominatorInfoDict = {}
  self.dominatorUuidDict = {}
  self.dominatorTrainInfoDict = {}
  self.mainBuildingBubbleRedCountCache = nil
  self.commonRankUpgradeItemId = nil
  self.unlockArchiveIdCache = 0
  self.isShowCityBuildingDominator = true
  self.refreshMainBuildingBubbleCallBack = BindCallback(self, self.TryRefreshMainBuildingBubble)
  EventManager:GetInstance():AddListener(EventId.RefreshItems, self.refreshMainBuildingBubbleCallBack)
end

function DominatorManager:__delete()
  EventManager:GetInstance():RemoveListener(EventId.RefreshItems, self.refreshMainBuildingBubbleCallBack)
  self.refreshMainBuildingBubbleCallBack = nil
  self.mainBuildingBubbleRedCountCache = nil
  self.dominatorInfoDict = nil
  self.dominatorUuidDict = nil
  self.dominatorTrainInfoDict = nil
  self.commonRankUpgradeItemId = nil
  self.unlockArchiveIdCache = nil
  self.isShowCityBuildingDominator = nil
end

function DominatorManager:IsDominatorFunctionOnByDominatorId(dominatorId)
  local isDominatorFuncOn = self:IsDominatorFunctionOn()
  if not isDominatorFuncOn then
    return false
  end
  if dominatorId == DominatorId.Gorilla then
    return true
  elseif dominatorId == DominatorId.Cockatrice then
    local gorilla = self:GetInfoById(DominatorId.Gorilla)
    if gorilla and gorilla:IsUnlocked() then
      local limitData = self:GetDominatorCockatriceFunctionLimitData()
      if limitData then
        local isFuncOn = DominatorUtils.CheckFunctionOnLimitData(limitData)
        return isFuncOn
      end
    end
  end
  return false
end

function DominatorManager:GetDominatorFunctionLimitData()
  local configValue = LuaEntry.DataConfig:TryGetStr("dominator_para", "k5", "")
  if not string.IsNullOrEmpty(configValue) then
    local strSplit = string.split(configValue, ";")
    if #strSplit == 3 then
      return {
        mainLv = tonumber(strSplit[1]) or 0,
        seasonNum = tonumber(strSplit[2]) or 0,
        seasonDay = tonumber(strSplit[3]) or 0
      }
    end
  end
end

function DominatorManager:GetDominatorCockatriceFunctionLimitData()
  local configValue = LuaEntry.DataConfig:TryGetStr("dominator_2_unlock_para", "k1", "")
  if not string.IsNullOrEmpty(configValue) then
    local strSplit = string.split(configValue, ";")
    if #strSplit == 3 then
      return {
        mainLv = tonumber(strSplit[1]) or 0,
        seasonNum = tonumber(strSplit[2]) or 0,
        seasonDay = tonumber(strSplit[3]) or 0
      }
    end
  end
end

function DominatorManager:IsDominatorFunctionOn()
  if LuaEntry.DataConfig:CheckSwitch("dominator_open") then
    local functionLimitData = self:GetDominatorFunctionLimitData()
    if functionLimitData then
      local mainLv = DataCenter.BuildManager.MainLv or 0
      if mainLv >= functionLimitData.mainLv then
        local seasonNum = SeasonUtil.GetSeason()
        if seasonNum > functionLimitData.seasonNum then
          return true
        elseif seasonNum < functionLimitData.seasonNum then
          return false
        end
        return functionLimitData.seasonDay <= SeasonUtil.GetSeasonDayByOpenServerZero()
      end
    end
  end
  return false
end

function DominatorManager:InitInfo(message)
  self.dominatorInfoDict = {}
  self.dominatorTrainInfoDict = {}
  if message == nil then
    return
  end
  if message.userDominators then
    for i, v in pairs(message.userDominators) do
      self:UpdateOneInfo(v)
    end
  end
  self:InitTrainInfo()
  if message.dominatorTrains then
    for i, v in pairs(message.dominatorTrains) do
      if v.trainId and v.level then
        self:UpdateTrainInfo(v.trainId, v.level)
      end
    end
  end
end

function DominatorManager:HasAnyInfo()
  if self.dominatorInfoDict then
    for i, v in pairs(self.dominatorInfoDict) do
      return true
    end
  end
  return false
end

function DominatorManager:HasAnyInfoUnlocked()
  if self.dominatorInfoDict then
    for i, v in pairs(self.dominatorInfoDict) do
      if v:IsUnlocked() then
        return true
      end
    end
  end
  return false
end

function DominatorManager:OnPushInfo(message)
  if message and message.userDominators then
    for i, v in pairs(message.userDominators) do
      self:UpdateOneInfo(v)
    end
  end
  self:TryRefreshMainBuildingBubble()
  EventManager:GetInstance():Broadcast(EventId.DominatorOnPushInfo)
end

function DominatorManager:UpdateOneInfo(info, isFromInit)
  if info == nil then
    return
  end
  if info.dominatorId == nil then
    self:PrintRealErrorLog("update info with nil dominatorId")
    return
  end
  if info.uuid == nil then
    self:PrintRealErrorLog("update info with nil uuid")
    return
  end
  if self.dominatorInfoDict[info.uuid] then
    self.dominatorInfoDict[info.uuid]:UpdateInfo(info)
  else
    local addInfo
    if info.dominatorId == DominatorId.Gorilla then
      local dominatorInfo = DominatorGorillaInfo.New()
      dominatorInfo:UpdateInfo(info)
      if dominatorInfo:IsDataValid() then
        addInfo = dominatorInfo
      end
    elseif info.dominatorId == DominatorId.Cockatrice then
      local dominatorInfo = DominatorCockatriceInfo.New()
      dominatorInfo:UpdateInfo(info)
      if dominatorInfo:IsDataValid() then
        addInfo = dominatorInfo
      end
    else
      local dominatorInfo = DominatorInfo.New()
      dominatorInfo:UpdateInfo(info)
      if dominatorInfo:IsDataValid() then
        addInfo = dominatorInfo
      end
    end
    if addInfo then
      self.dominatorUuidDict[info.dominatorId] = info.uuid
      self.dominatorInfoDict[info.uuid] = addInfo
      if not isFromInit then
        local evtData = {
          dominatorId = info.dominatorId
        }
        EventManager:GetInstance():Broadcast(EventId.DominatorReceiveNewOne, evtData)
      end
    end
  end
end

function DominatorManager:GetInfoByUuid(uuid)
  if self.dominatorInfoDict then
    return self.dominatorInfoDict[uuid]
  end
end

function DominatorManager:GetUuidById(id)
  if self.dominatorUuidDict then
    return self.dominatorUuidDict[id]
  end
end

function DominatorManager:GetInfoById(id)
  local uuid = self:GetUuidById(tonumber(id))
  if uuid then
    return self:GetInfoByUuid(uuid)
  end
end

function DominatorManager:GetAllInfo()
  return self.dominatorInfoDict
end

function DominatorManager:GetDefaultShowMainId()
  local tmpList = {}
  if self.dominatorInfoDict then
    for i, v in pairs(self.dominatorInfoDict) do
      if v:IsCanOpenFromMainBuilding() then
        table.insert(tmpList, v)
      end
    end
  end
  table.sort(tmpList, function(a, b)
    local templateA = a:GetMainTemplate()
    local templateB = b:GetMainTemplate()
    if templateA ~= nil and templateB ~= nil then
      return templateA.order < templateB.order
    end
    return false
  end)
  if tmpList[1] ~= nil then
    return tmpList[1].dominatorId
  end
end

function DominatorManager:GetDefaultShowIconPath()
  local path
  local id = DataCenter.DominatorManager:GetDefaultShowMainId()
  local info = DataCenter.DominatorManager:GetInfoById(id)
  if info then
    local rankTemplate = info:GetCurRankTemplate()
    if rankTemplate then
      local rankShowTemplate = rankTemplate:GetRankShowTemplate()
      if rankShowTemplate and not string.IsNullOrEmpty(rankShowTemplate.pic_path) then
        path = rankShowTemplate.pic_path
      end
    end
  end
  return path
end

function DominatorManager:GetCityBuildingShowIconPath()
  local path
  local id = DataCenter.DominatorManager:GetCityBuildingShowDominatorId()
  local info = DataCenter.DominatorManager:GetInfoById(id)
  if info then
    local rankTemplate = info:GetCurRankTemplate()
    if rankTemplate then
      local rankShowTemplate = rankTemplate:GetRankShowTemplate()
      if rankShowTemplate and not string.IsNullOrEmpty(rankShowTemplate.pic_path) then
        path = rankShowTemplate.pic_path
      end
    end
  end
  return path
end

function DominatorManager:SendSkillUpgradeMessage(uuid, skillSlotIndex)
  SFSNetwork.SendMessage(MsgDefines.DominatorSkillUpgrade, {uuid = uuid, slot = skillSlotIndex})
end

function DominatorManager:OnSkillUpgradeCallback(message)
  if message == nil then
    return
  end
  local updateSkillSlotIndex, preLevel, curLevel
  local preSkillInfoDict = {}
  if message.dominatorId then
    local preInfo = self:GetInfoById(message.dominatorId)
    if preInfo and preInfo.skillList then
      for i, v in pairs(preInfo.skillList) do
        preSkillInfoDict[i] = v.level
      end
    end
  end
  self:UpdateOneInfo(message)
  local curSkillInfoDict = {}
  if message.dominatorId then
    local curInfo = self:GetInfoById(message.dominatorId)
    if curInfo and curInfo.skillList then
      for i, v in pairs(curInfo.skillList) do
        curSkillInfoDict[i] = v.level
      end
    end
  end
  for i, v in pairs(curSkillInfoDict) do
    if preSkillInfoDict[i] and v > preSkillInfoDict[i] then
      updateSkillSlotIndex = i
      preLevel = preSkillInfoDict[i]
      curLevel = v
    end
  end
  local evtData = {
    skillSlotIndex = updateSkillSlotIndex,
    preLevel = preLevel,
    curLevel = curLevel
  }
  EventManager:GetInstance():Broadcast(EventId.DominatorSkillUpgradeSuccess, evtData)
  EventManager:GetInstance():Broadcast(EventId.DominatorMainViewRedPointChanged)
  self:TryRefreshMainBuildingBubble()
end

function DominatorManager:GetCanUpgradeSkillRedCount()
  local res = 0
  if self:IsUpgradeRankAndSkillUnlock() and self.dominatorInfoDict then
    for i, v in pairs(self.dominatorInfoDict) do
      res = res + v:GetCanUpgradeSkillCount()
    end
  end
  return res
end

function DominatorManager:SendCheckEditUserNameMessage(uuid, name)
  SFSNetwork.SendMessage(MsgDefines.DominatorCheckEditName, {uuid = uuid, name = name})
end

function DominatorManager:GetEditUserNameDiamondCostNum()
  return toInt(LuaEntry.DataConfig:TryGetNum("dominator_para", "k2", 0))
end

function DominatorManager:SendEditUserNameMessage(uuid, name)
  SFSNetwork.SendMessage(MsgDefines.DominatorEditName, {uuid = uuid, name = name})
end

function DominatorManager:OnEditUserNameCallback(message)
  if message == nil then
    return
  end
  self:UpdateOneInfo(message.dominator)
  if message.gold ~= nil then
    LuaEntry.Player.gold = message.gold
    EventManager:GetInstance():Broadcast(EventId.UpdateGold)
  end
  EventManager:GetInstance():Broadcast(EventId.DominatorEditUserNameSuccess)
end

function DominatorManager:GetCommonRankUpgradeItemId()
  if self.commonRankUpgradeItemId == nil then
    self.commonRankUpgradeItemId = toInt(LuaEntry.DataConfig:TryGetNum("dominator_para", "k1", 0))
  end
  return self.commonRankUpgradeItemId
end

function DominatorManager:SendRankUpgradeMessage(uuid, useCommonItem)
  SFSNetwork.SendMessage(MsgDefines.DominatorRankUpgrade, {uuid = uuid, useCommonItem = useCommonItem})
end

function DominatorManager:OnRankUpgradeCallback(message)
  if message == nil then
    return
  end
  local preRankLevel = self:GetRankLevelById(message.dominatorId)
  local preRankTemplate = self:GetRankTemplateById(message.dominatorId)
  self:UpdateOneInfo(message)
  local curRankLevel = self:GetRankLevelById(message.dominatorId)
  local curRankTemplate = self:GetRankTemplateById(message.dominatorId)
  local evtData = {
    dominatorId = message.dominatorId,
    uuid = message.uuid,
    preRankLevel = preRankLevel,
    curRankLevel = curRankLevel
  }
  EventManager:GetInstance():Broadcast(EventId.DominatorRankUpgradeSuccess, evtData)
  EventManager:GetInstance():Broadcast(EventId.DominatorMainViewRedPointChanged)
  self:TryRefreshMainBuildingBubble()
  if preRankTemplate and curRankTemplate and preRankTemplate.star_judge ~= curRankTemplate.star_judge then
    EventManager:GetInstance():Broadcast(EventId.DominatorAppearanceUpdate)
    local preRankShowTemplate = preRankTemplate:GetRankShowTemplate()
    local curRankShowTemplate = curRankTemplate:GetRankShowTemplate()
    if curRankShowTemplate and not string.IsNullOrEmpty(curRankShowTemplate.timeline_path) then
      local param = {preRankShowTemplate = preRankShowTemplate, curRankShowTemplate = curRankShowTemplate}
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWDominatorUpgradeBigRank, {anim = false}, param)
    end
  end
end

function DominatorManager:GetRankTemplateById(mainId)
  local info = self:GetInfoById(mainId)
  if info then
    return info:GetCurRankTemplate()
  end
  return 0
end

function DominatorManager:GetRankLevelById(mainId)
  local info = self:GetInfoById(mainId)
  if info then
    return info:GetCurRankLv()
  end
  return 0
end

function DominatorManager:GetCanUpgradeRankRedCount()
  local res = 0
  if self:IsUpgradeRankAndSkillUnlock() and self.dominatorInfoDict then
    for i, v in pairs(self.dominatorInfoDict) do
      if v:IsCanUpgradeRank() then
        res = res + 1
      end
    end
  end
  return res
end

function DominatorManager:GetGorillaTreatmentRedCount()
  local res = 0
  local info = self:GetInfoById(DominatorId.Gorilla)
  if info and info:IsInTreatment() then
    local costInfo = info:GetTreatmentCostInfo()
    if costInfo then
      for i, v in pairs(costInfo) do
        local userCount = DataCenter.ItemData:GetItemCount(v.itemId)
        if 1 <= userCount then
          res = res + 1
        end
      end
    end
  end
  return res
end

function DominatorManager:SendGorillaTreatmentMessage(uuid, itemId)
  SFSNetwork.SendMessage(MsgDefines.DominatorGorillaTreatment, {uuid = uuid, itemId = itemId})
end

function DominatorManager:OnGorillaTreatmentCallback(message)
  if message == nil then
    return
  end
  DataCenter.RewardManager:AddRewardsAndRes(message)
  local preState = 0
  local curState = 0
  local info = self:GetInfoById(DominatorId.Gorilla)
  if info then
    preState = info:GetCurTreatmentStage()
  end
  self:UpdateOneInfo(message.dominator)
  info = self:GetInfoById(DominatorId.Gorilla)
  if info then
    curState = info:GetCurTreatmentStage()
  end
  EventManager:GetInstance():Broadcast(EventId.DominatorGorillaTreatmentSuccess, {preState = preState, curState = curState})
  self:TryRefreshMainBuildingBubble()
  if info and info:IsFinishTreatment() then
    EventManager:GetInstance():Broadcast(EventId.DominatorAppearanceUpdate)
  end
end

function DominatorManager:OpenGorillaTreatmentWindow()
  if not self:IsDominatorFunctionOn() then
    return
  end
  local dominatorInfo = self:GetInfoById(DominatorId.Gorilla)
  if dominatorInfo and dominatorInfo.IsInTreatment and dominatorInfo:IsInTreatment() then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWDominatorGorillaTreatment, {anim = true})
  end
end

function DominatorManager:InitTrainInfo()
  self.dominatorTrainInfoDict = {}
  local normalTrainGroupTemplates = DataCenter.DominatorTemplateManager:GetAllNormalTrainGroupTemplates()
  for i, v in pairs(normalTrainGroupTemplates) do
    self:UpdateTrainInfo(v.id, 0)
  end
  local mainTrainGroupTemplate = DataCenter.DominatorTemplateManager:GetMainTrainGroupTemplate()
  if mainTrainGroupTemplate then
    self:UpdateTrainInfo(mainTrainGroupTemplate.id, 0)
  end
end

function DominatorManager:GetTrainLevelByGroupId(groupId)
  local info = self:GetTrainInfoByGroupId(groupId)
  if info then
    return info:GetCurLevel()
  end
  return 0
end

function DominatorManager:GetTrainInfoByGroupId(groupId)
  groupId = tonumber(groupId) or 0
  if self.dominatorTrainInfoDict then
    for i, v in pairs(self.dominatorTrainInfoDict) do
      if v:GetGroupId() == groupId then
        return v
      end
    end
  end
end

function DominatorManager:GetTrainByGroupId(groupId)
  local info = self:GetTrainInfoByGroupId(groupId)
  if info then
    return info:GetCurLevel()
  end
  return 0
end

function DominatorManager:UpdateTrainInfo(groupId, level)
  local info = self:GetTrainInfoByGroupId(groupId)
  if info then
    info:UpdateInfo(groupId, level)
  else
    info = DominatorTrainInfo.New()
    info:UpdateInfo(groupId, level)
    self.dominatorTrainInfoDict[groupId] = info
  end
end

function DominatorManager:SendTrainUpgradeMessage(groupId)
  SFSNetwork.SendMessage(MsgDefines.DominatorTrainUpgrade, {trainId = groupId})
end

function DominatorManager:OnTrainUpgradeMessageCallback(message)
  if message and message.trainId and message.level then
    local preTrainLevel = self:GetTrainLevelByGroupId(message.trainId)
    self:UpdateTrainInfo(message.trainId, message.level)
    local curTrainLevel = self:GetTrainLevelByGroupId(message.trainId)
    local evtData = {
      groupId = message.trainId,
      preTrainLevel = preTrainLevel,
      curTrainLevel = curTrainLevel
    }
    EventManager:GetInstance():Broadcast(EventId.DominatorTrainUpgradeSuccess, evtData)
    EventManager:GetInstance():Broadcast(EventId.DominatorMainViewRedPointChanged)
    self:TryRefreshMainBuildingBubble()
  end
end

function DominatorManager:GetCanUpgradeTrainGroupRedCount()
  local res = 0
  if self:HasAnyInfoUnlocked() and self.dominatorTrainInfoDict then
    for i, v in pairs(self.dominatorTrainInfoDict) do
      if v:IsCanUpgrade() then
        res = res + 1
      end
    end
  end
  return res
end

function DominatorManager:GetUpgradeRankAndSkillUnlockTrainId()
  return toInt(LuaEntry.DataConfig:TryGetNum("dominator_para", "k11", 0))
end

function DominatorManager:IsUpgradeRankAndSkillUnlock()
  local unlockTrainId = self:GetUpgradeRankAndSkillUnlockTrainId()
  if 0 < unlockTrainId then
    local levelTemplate = DataCenter.DominatorTemplateManager:GetTrainLevelTemplateById(unlockTrainId)
    if levelTemplate then
      local groupTemplate = levelTemplate:GetGroupTemplate()
      if groupTemplate then
        local curLevel = self:GetTrainLevelByGroupId(groupTemplate.id)
        return curLevel >= levelTemplate.level_order
      end
    end
  end
  return false
end

function DominatorManager:GetMainTrainGroupInfo()
  local mainTrainGroupTemplate = DataCenter.DominatorTemplateManager:GetMainTrainGroupTemplate()
  if mainTrainGroupTemplate then
    return self:GetTrainInfoByGroupId(mainTrainGroupTemplate.id)
  end
end

function DominatorManager:SendChangeCityBuildingShowMessage(dominatorId)
  SFSNetwork.SendMessage(MsgDefines.DominatorStatueChange, {dominatorId = dominatorId})
end

function DominatorManager:IsShowCityBuildingDominator()
  return self.isShowCityBuildingDominator == true
end

function DominatorManager:SetIsShowCityBuildingDominator(value)
  self.isShowCityBuildingDominator = value
  EventManager:GetInstance():Broadcast(EventId.DominatorAppearanceUpdate)
end

function DominatorManager:GetCityBuildingShowDominatorId()
  local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_BUILD_DOMINATOR_MAIN)
  if buildData and buildData.dominatorId ~= nil and buildData.dominatorId > 0 then
    return buildData.dominatorId
  end
  return self:GetDefaultShowMainId()
end

function DominatorManager:GetCityBuildingShowAppearanceId()
  local gorillaInfo = self:GetInfoById(DominatorId.Gorilla)
  if gorillaInfo and gorillaInfo:IsFinishTreatment() then
    local showDominatorId = self:GetCityBuildingShowDominatorId()
    if showDominatorId then
      local info = self:GetInfoById(showDominatorId)
      if info then
        return info:GetAppearanceId()
      else
        self:PrintRealErrorLog("no dominatorInfo, id:" .. tostring(showDominatorId))
      end
    end
  end
end

function DominatorManager:OnMainBuildingEntranceClick()
  if not self:IsDominatorFunctionOn() or not self:HasAnyInfo() then
    return
  end
  local defaultMainId = self:GetDefaultShowMainId()
  if defaultMainId then
    local info = self:GetInfoById(defaultMainId)
    if info and defaultMainId == DominatorId.Gorilla and info:IsInTreatment() then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWDominatorGorillaTreatment, {anim = true})
      return
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWDominatorMain, {anim = true})
  end
end

function DominatorManager:OnTrainBuildingEntranceClick()
  if not self:IsDominatorFunctionOn() or not self:HasAnyInfo() then
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWDominatorMain, {anim = true}, {
    DefaultPageTag = UILWDominatorMainPageTag.Train
  })
end

function DominatorManager:GetMainBuildingBubbleRedCount()
  local res = 0
  if 0 < self:GetCanUpgradeRankRedCount() then
    res = res + 1
  end
  if 0 < self:GetCanUpgradeSkillRedCount() then
    res = res + 1
  end
  if 0 < self:GetCanUpgradeTrainGroupRedCount() then
    res = res + 1
  end
  if 0 < self:GetGorillaTreatmentRedCount() then
    res = res + 1
  end
  if 0 < self:GetArchiveRedCount() then
    res = res + 1
  end
  return res
end

function DominatorManager:GetMainBuildingBubbleIconPath()
  if self:IsUpgradeRankAndSkillUnlock() then
    local showInfo
    if self.dominatorInfoDict then
      for i, v in pairs(self.dominatorInfoDict) do
        if v:IsCanUpgradeRank() and v:IsUnlocked() then
          if showInfo ~= nil then
            showInfo = nil
            break
          else
            showInfo = v
          end
        end
      end
    end
    if showInfo ~= nil then
      return showInfo:GetCityMainBuildingBubbleIconPath()
    end
    local cityShowMainId = self:GetCityBuildingShowDominatorId()
    local info = self:GetInfoById(cityShowMainId)
    if info then
      return info:GetCityMainBuildingBubbleIconPath()
    end
  end
  if self:GetCanUpgradeTrainGroupRedCount() > 0 then
    local cityShowMainId = self:GetCityBuildingShowDominatorId()
    local info = self:GetInfoById(cityShowMainId)
    if info then
      return info:GetCityMainBuildingBubbleIconPath()
    end
  end
  return string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.DominatorMainBuildingBubbleIconGorilla)
end

function DominatorManager:IsCanOpenMainUI()
  if self:IsDominatorFunctionOn() then
    return self:HasAnyInfo()
  end
  return false
end

function DominatorManager:TryRefreshMainBuildingBubble()
  local redCount = self:GetMainBuildingBubbleRedCount()
  if redCount ~= self.mainBuildingBubbleRedCountCache then
    self.mainBuildingBubbleRedCountCache = redCount
    EventManager:GetInstance():Broadcast(EventId.DominatorMainBuildingRedPointChanged)
  end
end

function DominatorManager:PrintRealErrorLog(msg)
  Logger.LogError("Dominator Error, Detail: " .. msg or "")
end

function DominatorManager:PrintEditorErrorLog(msg)
  if not CS.SDKManager.IS_UNITY_EDITOR() then
    return
  end
  Logger.LogError("Dominator \230\151\165\229\191\151, " .. msg or "")
end

function DominatorManager:HasDominatorUnlockBattle()
  if not self:IsDominatorFunctionOn() then
    return false
  end
  if self.dominatorInfoDict then
    for i, v in pairs(self.dominatorInfoDict) do
      if v:IsUnlockedBattle() then
        return true
      end
    end
  end
  return false
end

function DominatorManager:HasDominatorUnlockBattleForTrial()
  if not self:IsDominatorFunctionOn() then
    return false
  end
  if self.dominatorInfoDict then
    for i, v in pairs(self.dominatorInfoDict) do
      if v:IsUnlockedBattleForTrial() then
        return true
      end
    end
  end
  return false
end

function DominatorManager:GetUnlockBattleDominators()
  local res = {}
  if not self:IsDominatorFunctionOn() then
    return res
  end
  if self.dominatorInfoDict then
    for i, v in pairs(self.dominatorInfoDict) do
      if v:IsUnlockedBattle() then
        table.insert(res, v)
      end
    end
  end
  return res
end

function DominatorManager:GetUnlockBattleDominatorsForTrial()
  local res = {}
  if not self:IsDominatorFunctionOn() then
    return res
  end
  if self.dominatorInfoDict then
    for i, v in pairs(self.dominatorInfoDict) do
      if v:IsUnlockedBattleForTrial() then
        table.insert(res, v)
      end
    end
  end
  return res
end

function DominatorManager:GetTrainIdsForRadarBattleTrial()
  local configValue = LuaEntry.DataConfig:TryGetStr("dominator_para", "k14", "")
  if not string.IsNullOrEmpty(configValue) then
    local dominatorTemporaryUse = {}
    local split = string.split(configValue, ";")
    for i, v in ipairs(split) do
      table.insert(dominatorTemporaryUse, tonumber(v))
    end
    return dominatorTemporaryUse
  end
end

function DominatorManager:OpenDominatorMain(defaultDominatorId, defaultPageTag)
  if not self:IsDominatorFunctionOn() then
    return
  end
  local dominatorInfo = self:GetInfoById(defaultDominatorId)
  if dominatorInfo == nil or not dominatorInfo:IsUnlocked() then
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWDominatorMain, {anim = true}, {DefaultDominatorId = defaultDominatorId, DefaultPageTag = defaultPageTag})
end

function DominatorManager:OpenArchive(info)
  if not info then
    return
  end
  if info.dominatorId == DominatorId.Cockatrice then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWDominatorArchiveCockatrice, {anim = true}, info.uuid)
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWDominatorArchive, {anim = true}, info.uuid)
  end
end

function DominatorManager:GetArchiveState(uuid, id)
  local info = self:GetInfoByUuid(uuid)
  if info then
    return info:GetArchiveStateById(id)
  end
  return DominatorArchiveState.Locked
end

function DominatorManager:SendUnlockArchiveMessage(uuid, id)
  SFSNetwork.SendMessage(MsgDefines.DominatorClickHandbook, {uuid = uuid, id = id})
end

function DominatorManager:OnUnlockArchiveMessageCallback(message)
  if not message or not message.uuid then
    return
  end
  self:UpdateOneInfo(message)
  EventManager:GetInstance():Broadcast(EventId.DominatorArchiveUnlockSuccess)
  self:TryRefreshMainBuildingBubble()
  local id = self:GetUnlockArchiveIdCache()
  if id and 0 < id then
    local info = self:GetInfoByUuid(message.uuid)
    if info then
      if info.dominatorId == DominatorId.Gorilla then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UILWDominatorArchiveDetail, {anim = true}, id)
      elseif info.dominatorId == DominatorId.Cockatrice then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UILWDominatorArchiveDetailCockatrice, {anim = true}, id)
      end
    end
  end
end

function DominatorManager:GetArchiveRedCount()
  local res = 0
  if self.dominatorInfoDict then
    for i, v in pairs(self.dominatorInfoDict) do
      if v:HasAnyArchiveCanUnlock() then
        res = res + 1
      end
    end
  end
  return res
end

function DominatorManager:SetUnlockArchiveIdCache(id)
  self.unlockArchiveIdCache = id
end

function DominatorManager:GetUnlockArchiveIdCache()
  return self.unlockArchiveIdCache
end

return DominatorManager
