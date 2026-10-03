local Localization = CS.GameEntry.Localization
local BattlefieldManagerBase = BaseClass("BattlefieldManagerBase")

function BattlefieldManagerBase:__init()
  self:OnInit()
  self.baseConfig = BattleFieldUtil.GetBaseConfig(self.bfType)
  self.actType = self.baseConfig.ActType
end

function BattlefieldManagerBase:__delete()
  self:OnDelete()
  self.baseConfig = nil
  self.actType = 0
  self.bfType = nil
end

function BattlefieldManagerBase:OnEnterGame()
  local activityData = DataCenter.ActivityListDataManager:GetOneOpenActivityByType(self.actType)
  if activityData ~= nil then
    self:ReqActInfo()
  else
    self:ResetData()
  end
  BattleFieldUtil.OnReconnect(self.bfType)
end

function BattlefieldManagerBase:ReqActInfo(bRandomDelay)
  local msgId = self.baseConfig ~= nil and self.baseConfig.ActMsgIdGetter() or nil
  if msgId == nil then
    BattleFieldUtil.Log("Battlefield mgr bfType=%s actType=%s ReqActInfo msgId is nil.", self.bfType)
    return
  end
  if bRandomDelay then
    TimerManager:GetInstance():DelayInvoke(function()
      SFSNetwork.SendMessage(msgId)
    end, math.random(1, 10))
  else
    SFSNetwork.SendMessage(msgId)
  end
end

function BattlefieldManagerBase:GetCfgValue(key, season)
  return BattleFieldUtil.GetBattleFieldCfgValue(self.bfType, key, season)
end

function BattlefieldManagerBase:IsEASeason()
  local season = self:GetActSeason()
  return season == BattleFieldUtil.SP_SEASON
end

function BattlefieldManagerBase:GetActSeason()
  local actInfo = self:GetActInfo()
  return actInfo ~= nil and actInfo.season or 0
end

function BattlefieldManagerBase:GetActSCfgId()
  local actInfo = self:GetActInfo()
  return actInfo ~= nil and actInfo.sCfgId or 0
end

function BattlefieldManagerBase:UpdateMapBR()
  local baseObj = BattleFieldUtil.GetMapObj(self.bfType)
  if IsNull(baseObj) then
    return
  end
  local mapHandle = baseObj:GetComponent(typeof(CS.BattlefieldHandle))
  if mapHandle == nil then
    return
  end
  if self.UpdateAreaMaterial then
    self:UpdateAreaMaterial(mapHandle)
  end
end

function BattlefieldManagerBase:PrepareBGM(bNow, bUp)
  local soundCheckTime = -1
  
  local function func()
    local soundId
    if self.GetBGM then
      soundId, soundCheckTime = self:GetBGM(bUp)
    end
    if soundId then
      DataCenter.LWSoundManager:PlaySound(soundId, true, true)
    end
  end
  
  if bNow then
    func()
  else
    TimerManager:GetInstance():DelayInvoke(func, 0.5)
  end
  return soundCheckTime
end

function BattlefieldManagerBase:CheckCanEnterBattlefield(checkType)
  if checkType == BattlefieldEnterCheckType.AllianceIsValid then
    local canEnter = true
    if self.CheckAllianceIsValid then
      canEnter = self:CheckAllianceIsValid()
    end
    return true, canEnter, {"458135", ""}
  elseif checkType == BattlefieldEnterCheckType.YouAreLowBeMember then
    local canEnter = true
    if self.CheckSelfAssigned then
      canEnter = self:CheckSelfAssigned()
    end
    return true, canEnter, {"458137"}
  elseif checkType == BattlefieldEnterCheckType.InBlackRect then
    return true, not LuaEntry.Player:IsInBlackRange(true) and not LuaEntry.Player:IsInCityField(true), {"458138"}
  end
end

function BattlefieldManagerBase:BaseCheckActivityOpen(actType)
  local actData = DataCenter.ActivityListDataManager:GetOneOpenActivityByType(actType)
  if actData == nil then
    return 458822
  end
  if RaceEntranceUtil.IsNeedShowLoadingByType(actType, false, true) then
    return "battlefield_entrance_tips1121"
  end
end

function BattlefieldManagerBase:BaseCheckAlliance()
  if LuaEntry.Player:IsInAlliance() == false then
    return 390856
  end
end

function BattlefieldManagerBase:BaseGetAttackInfo(pointId, param)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local allMarches = DataCenter.WorldMarchDataManager:GetAllMarches()
  local attackCountRed = 0
  local attackCountBlue = 0
  local defenceCountRed = 0
  local defenceCountBlue = 0
  local allianceAbbr = "?"
  local baseData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
  if baseData ~= nil and baseData.abbr ~= nil and baseData.abbr ~= "" then
    allianceAbbr = baseData.abbr
  end
  if allMarches then
    local alUIDs
    if type(param) == "table" then
      alUIDs = param
    else
      alUIDs = {param}
    end
    for _, marchData in pairs(allMarches) do
      if 0 < marchData.worldId and marchData.targetPos == pointId then
        local status = marchData:GetMarchStatus()
        local marchType = marchData:GetMarchType()
        if marchType ~= NewMarchType.SCOUT then
          if status == MarchStatus.ASSISTANCE or status == MarchStatus.STATION then
            if table.hasvalue(alUIDs, marchData.allianceUid) then
              if marchData.allianceAbbr == allianceAbbr then
                defenceCountBlue = defenceCountBlue + 1
              else
                defenceCountRed = defenceCountRed + 1
              end
            end
          elseif status == MarchStatus.MOVING or status == MarchStatus.ATTACKING or status == MarchStatus.IN_TEAM then
            if marchData.allianceAbbr == allianceAbbr then
              attackCountBlue = attackCountBlue + 1
            else
              attackCountRed = attackCountRed + 1
            end
          end
        end
      end
    end
  end
  local warIdList = DataCenter.AllianceWarDataManager:GetAllianceWarIdList()
  for _, warId in ipairs(warIdList) do
    local data = DataCenter.AllianceWarDataManager:GetAllianceWarDataByUuid(warId)
    local skipIt = false
    if data.leaderMarch and data.leaderMarch.endTime and curTime >= data.leaderMarch.endTime then
      skipIt = true
    end
    if data.leaderMarch and (data.leaderMarch.status == 1 or data.leaderMarch.status == 4) then
      skipIt = true
    end
    if not skipIt and pointId == data.targetPointId and not data:AlreadyGo() then
      if CommonUtil.IsDebug() and data.leaderMarch then
        print("GetAttackInfo.leaderMarch.status = " .. data.leaderMarch.status)
      end
      if data.attackAllianceAbbr == allianceAbbr then
        attackCountBlue = attackCountBlue + 1
      else
        attackCountRed = attackCountRed + 1
      end
    end
  end
  return attackCountRed, attackCountBlue, defenceCountRed, defenceCountBlue
end

function BattlefieldManagerBase:Description()
  local sb = StringBuilder.New()
  sb:AppendLineFormat("--\230\136\152\229\156\186\228\191\161\230\129\175--")
  sb:AppendLineFormat("\230\136\152\229\156\186\231\177\187\229\158\139:%s", self.bfType)
  sb:AppendLineFormat("\230\180\187\229\138\168\231\177\187\229\158\139:%s", self.actType)
  return sb:ToString()
end

function BattlefieldManagerBase:TryEnterBattlefield(group, pointId)
  if RaceEntranceUtil.IsNeedShowLoadingByType(self.actType, true, true) then
    return false
  end
  local canEnterBattlefield, params = self:LocalCheckCanEnterBattlefield(group, pointId)
  if not canEnterBattlefield then
    if params then
    end
    return false
  end
  if (group or 0) ~= 0 or self:CanShowEnter() then
    self:SendEnterBattleMessage(group, pointId)
    return true
  end
  local wfs = DataCenter.StatusManager:WarFeverStatu()
  if wfs == nil then
    self:SendEnterBattleMessage(group, pointId)
    return true
  end
  UIUtil.ShowSecondMessageByParam({
    tipText = Localization:GetString("winter_battlefield_tips1060"),
    btnNum = 2,
    showToggle = false,
    sureAction = function()
      self:SendEnterBattleMessage(group, pointId)
    end
  })
  return true
end

function BattlefieldManagerBase:OnHandleEnterBattleMessage(serverMsg, bWatch)
  if not BattleFieldUtil.BTestJump() then
    local canEnterBattlefield, params = self:ServerCheckCanEnterBattlefield(serverMsg)
    if not canEnterBattlefield then
      if params then
      end
      return
    end
  end
  BattleFieldUtil.SetObserve(bWatch)
  if bWatch then
    if BattleFieldUtil.preWatchIdx then
      BattleFieldUtil.watchIdx = BattleFieldUtil.preWatchIdx
      BattleFieldUtil.preWatchIdx = nil
    end
  else
    BattleFieldUtil.preWatchIdx = nil
  end
  self:BeforeEnterBattlefield(serverMsg, bWatch)
  BattleFieldUtil.HandleEnterWorld(self.bfType, serverMsg, function()
    self:AfterEnterBattlefield(bWatch)
  end)
end

BattleFieldUtil.MergeFunctions(BattlefieldManagerBase, "Scene.Battlefield.Base.Module.BuildInfo")
BattleFieldUtil.MergeFunctions(BattlefieldManagerBase, "Scene.Battlefield.Base.Module.EnterBattle")
return BattlefieldManagerBase
