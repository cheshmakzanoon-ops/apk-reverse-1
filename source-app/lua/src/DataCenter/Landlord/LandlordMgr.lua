local LandlordMgr = BaseClass("LandlordMgr", CEventable)

function LandlordMgr:__init()
  self.serverGroupCheckDirty = true
  self._isInMyServerGroup = true
  self.TimeCtrlParamData = {config = nil, isFly = false}
  self:InitAct()
  self:InitBattle()
  self:InitConfig()
end

function LandlordMgr:__delete()
  self.serverGroupCheckDirty = true
  self._isInMyServerGroup = true
  self.TimeCtrlParamData = nil
  self:RemoveListeners()
  self:ClearStageTimer()
  self:DeleteAct()
  self:DeleteBattle()
  self:DeleteConfig()
end

function LandlordMgr:Startup()
  self:AddListeners()
end

function LandlordMgr:AddListeners()
  self:RegisterEvent(EventId.HeroEventClaimBoxReward, self.HandleGetNineBox)
  self:RegisterEvent(EventId.HeroEventCfgInfoUpdate, self.HandleNineBoxUpdate)
  self:RegisterEvent(EventId.HeroEventDataUpdate, self.HandleNineBoxUpdate)
  self:RegisterEvent(EventId.OnFinishHandleInitMsg, self.OnFinishHandleInitMsg)
  self:RegisterEvent(EventId.LandlordActStageChange, self.RefreshServerChange)
  self:RegisterEvent(EventId.OnEnterWorld, self.OnEnterWorld)
  self:RegisterEvent(EventId.OnSetCrossID, self.OnCrossServer)
  self:RegisterEvent(EventId.OnEnterWorld, self.OnEnterWorld)
  self:RegisterEvent(EventId.LandlordTargetServerActInfoUpdate, self.OnTargetServerActInfoUpdate)
end

function LandlordMgr:RemoveListeners()
  self:UnregisterEvent(EventId.HeroEventClaimBoxReward)
  self:UnregisterEvent(EventId.HeroEventCfgInfoUpdate)
  self:UnregisterEvent(EventId.HeroEventDataUpdate)
  self:UnregisterEvent(EventId.OnFinishHandleInitMsg)
  self:UnregisterEvent(EventId.LandlordActStageChange)
  self:UnregisterEvent(EventId.OnSetCrossID)
  self:UnregisterEvent(EventId.OnEnterWorld)
  self:UnregisterEvent(EventId.LandlordTargetServerActInfoUpdate)
end

function LandlordMgr:SetCurCenterServerId(curCenterServerId)
  self.curCenterServerId = curCenterServerId
end

function LandlordMgr:OnCrossServer()
  self.serverGroupCheckDirty = true
  local curCenterServerId = DataCenter.SeasonDataManager:GetNinePalacesServer(5, ServerEnum.View)
  local isCrossBigModeMap = curCenterServerId ~= self.curCenterServerId
  self:SetCurCenterServerId(curCenterServerId)
  if isCrossBigModeMap then
    if not self:IsInMyServerGroup() then
      local centerServerId = self:GetCenterServerId()
      if 0 < centerServerId then
        self:ReqTargetServerActInfo(centerServerId)
      end
    else
      self:ClearTargetActInfoCache()
      local actData = self:GetActData()
      if actData ~= nil and 0 < actData.configId then
        self:RefreshBaseConfigById(actData.configId)
      end
      self:RefreshCenterMapRandomFxSystem()
    end
  end
  self:RefreshServerChange()
  EventManager:GetInstance():Broadcast(EventId.LandlordActInfoRefresh)
end

function LandlordMgr:IsInMyServerGroup()
  if self.serverGroupCheckDirty then
    self._isInMyServerGroup = SeasonUtil.IsInSameMap(LuaEntry.Player:GetCurServerId(), ServerEnum.Source)
    self.serverGroupCheckDirty = false
  end
  return self._isInMyServerGroup
end

function LandlordMgr:IsInSourceCenterGroup()
  if self:IsInMyServerGroup() then
    local centerId = DataCenter.SeasonDataManager:GetNinePalacesServer(5, ServerEnum.View)
    return LuaEntry.Player:GetCurServerId() == centerId
  end
  return false
end

function LandlordMgr:CanShowWarZoneMark()
  local curStage = self:GetActCurStage()
  if curStage > LLConst.LandlordStage.GROUP then
    return DataCenter.LandlordMgr:IsInSourceCenterGroup()
  end
  return false
end

function LandlordMgr:OnTargetServerActInfoUpdate(msg)
  local centerServerId = self:GetCenterServerId()
  if 0 < centerServerId then
    self:HandleTargetActInfo(msg, centerServerId)
  end
end

function LandlordMgr:ClearStageTimer()
  if self.stageTimer ~= nil then
    self.stageTimer:Stop()
    self.stageTimer = nil
  end
  self.nextReqTime = nil
  self.forcePartHandledIdx = 0
  self.forcePartLastCheckSec = nil
  self:ClearPreviewBoomCheck()
  self:RemoveBattleCountDownTimer()
end

function LandlordMgr:StartStageTimer()
  self:PreviewBoomCheck()
  self:BattleCountDownCheck()
  if self.stageTimer ~= nil then
    return
  end
  local actData = self:GetActData()
  if actData ~= nil then
    self.nextReqTime = actData.nextStageTime
    local curStage = actData:GetCurStageInfo()
    if curStage then
      self.nextReqTime = curStage.eTime or self.nextReqTime
    end
    self.stageTimer = TimerManager:GetInstance():GetTimer(1, self.StageTimerAction, self, false, false, false)
    self.stageTimer:Start()
  end
end

function LandlordMgr:StageTimerAction()
  local actData = self:GetActData()
  if actData == nil then
    self:ClearStageTimer()
    return
  end
  local curSec = UITimeManager:GetInstance():GetServerSeconds()
  if curSec >= actData.endTime then
    self:ClearStageTimer()
    return
  end
  self:PreviewBoomTimerAction()
  self:BattleCountDownTimerAction()
  self:CheckForcePartTime(curSec)
  self:CheckBattleTimeCtrl(curSec)
  self:CheckPlayerTypeClearCacheTime(curSec)
  if self.nextReqTime then
    local remain = self.nextReqTime - curSec
    if remain <= 0 then
      self:ClearStageTimer()
      self:ReqActInfo()
    end
  end
end

function LandlordMgr:CheckForcePartTime(curSec)
  if self.GetActCurStage == nil then
    return
  end
  if self:GetActCurStage() ~= LLConst.LandlordStage.GROUP then
    return
  end
  local actData = self:GetActData()
  local list = actData ~= nil and actData.forcePartTime or nil
  if list == nil then
    return
  end
  if self.forcePartLastCheckSec == nil then
    self.forcePartLastCheckSec = curSec
    return
  end
  local lastSec = self.forcePartLastCheckSec
  if curSec <= lastSec then
    return
  end
  self.forcePartLastCheckSec = curSec
  self.forcePartHandledIdx = self.forcePartHandledIdx or 0
  local maxIdx = #list
  for i = self.forcePartHandledIdx + 1, maxIdx do
    local t = list[i] or 0
    if 0 < t and lastSec < t and curSec >= t then
      self.forcePartHandledIdx = i
      EventManager:GetInstance():Broadcast(EventId.LandlordActInfoRefresh)
      self:ReqActInfo()
      break
    end
  end
end

function LandlordMgr:JumpToCity(cityId)
  local template = cityId ~= nil and self:GetCityTemplate(cityId) or nil
  local pId = template ~= nil and template:GetPointId() or 500500
  local sId = self:GetCenterServerId()
  GoToUtil.CloseAllWindows()
  local time = LuaEntry.Player:GetCurServerId() == sId and LookAtFocusTime or 0
  GoToUtil.GotoWorldPos(SceneUtils.TileIndexToWorld(pId, ForceChangeScene.World, sId), CS.SceneManager.World.InitZoom, time, nil, sId)
end

function LandlordMgr:SignGroupChanged()
  if self:GetActCurStage() ~= LLConst.LandlordStage.GROUP then
    return
  end
  local lList = self:GetServersByGroup(LLConst.LandLordGroup.LORD)
  local rList = self:GetServersByGroup(LLConst.LandLordGroup.FARMER)
  local cnt = #lList + #rList
  local sign = CommonUtil.PlayerPrefsGetLong(LLConst.SIGN_GROUP_CHANGE, 0)
  if sign ~= 0 then
    local time = math.modf(sign / 10)
    local signCnt = sign % 10
    local sTime = self:GetActStartTime()
    if signCnt == cnt and time >= sTime then
      return
    end
  end
  local now = UITimeManager:GetInstance():GetServerSeconds()
  sign = now * 10 + cnt
  CommonUtil.PlayerPrefsSetLong(LLConst.SIGN_GROUP_CHANGE, sign)
  EventManager:GetInstance():Broadcast(EventId.LandlordRedRefresh)
end

function LandlordMgr:CheckGroupChanged()
  if self:GetActCurStage() ~= LLConst.LandlordStage.GROUP then
    return false
  end
  local lList = self:GetServersByGroup(LLConst.LandLordGroup.LORD)
  local rList = self:GetServersByGroup(LLConst.LandLordGroup.FARMER)
  local cnt = #lList + #rList
  local def = LLConst.INIT_BIG_LORD_COUNT + LLConst.INIT_BIG_FARMER_COUNT
  if cnt <= def then
    return false
  end
  local sign = CommonUtil.PlayerPrefsGetLong(LLConst.SIGN_GROUP_CHANGE, 0)
  if sign == 0 then
    return true
  else
    local time = math.modf(sign / 10)
    local signCnt = sign % 10
    local sTime = self:GetActStartTime()
    if time < sTime or signCnt ~= cnt then
      return true
    end
  end
  return false
end

function LandlordMgr:CheckRed(tab)
  local check = toInt(tab)
  local flag = false
  local stage = self:GetActCurStage()
  if stage == LLConst.LandlordStage.GROUP then
    if check == 0 or check == 1 then
      local partInfo = self:GetCurGroupPartInfo()
      local partIdx = partInfo ~= nil and partInfo.partIdx or 0
      if 0 < partIdx then
        local camp = partInfo.camp
        local isOperator = false
        local defNum = 1
        if camp == LLConst.LandLordGroup.LORD then
          isOperator = self:IsBigKing()
          defNum = LLConst.INIT_BIG_LORD_COUNT
        elseif camp == LLConst.LandLordGroup.FARMER then
          isOperator = self:IsBigFarmerKing()
          defNum = LLConst.INIT_BIG_FARMER_COUNT
        end
        if isOperator then
          local limitNum = partInfo.totalLimit
          local lList = self:GetServersByGroup(camp)
          local cntTeamMate = #lList - defNum
          if limitNum > cntTeamMate then
            flag = true
          end
        end
      end
      if not flag then
        flag = self:CheckGroupChanged()
      end
    end
  elseif stage >= LLConst.LandlordStage.PREPARE and (check == 0 or check == 3) then
    flag = self:CheckHaveBoxCanGet()
    self.haveBoxCanGet = flag
  end
  return flag
end

function LandlordMgr:SetDetailCityShow(data, imgBg, imgBgA, imgBgB, textOccupy, textPos)
  local ownerCampId = data.ownerCampId
  local state = data.state
  local myGroup = self:GetMyGroup()
  if imgBg ~= nil then
    local bg, bgA, bgB = self:GetDetailCityBg(state, ownerCampId, myGroup)
    imgBg:LoadSpriteAsync(bg)
    if imgBgA ~= nil then
      imgBgA:LoadSpriteAsync(bgA)
    end
    if imgBgB ~= nil then
      imgBgB:LoadSpriteAsync(bgB)
    end
  end
  if textOccupy ~= nil then
    local occupyKey = self:GetDetailOccupyKey(state, ownerCampId, myGroup)
    textOccupy:SetLocalText(occupyKey)
  end
  if textPos ~= nil then
    local color = self:GetDetailPosColor(state, ownerCampId, myGroup)
    textPos:SetColorHex(color)
  end
end

function LandlordMgr:SetDetailSubCityShow(data, imgBg, textPos)
  local ownerCampId = data.ownerCampId
  local state = data.state
  local myGroup = self:GetMyGroup()
  if imgBg ~= nil then
    local color = self:GetDetailSubCityColor(state, ownerCampId, myGroup)
    imgBg:SetColorHex(color)
  end
  if textPos ~= nil then
    local color = self:GetDetailPosColor(state, ownerCampId, myGroup)
    textPos:SetColorHex(color)
  end
end

function LandlordMgr:GetDetailCityBg(state, ownerCampId, myGroup)
  local bg = "lrb_jinmai_hong.png"
  local bgA = "lrb_jinmai_hongA.png"
  local bgB = "lrb_jinmai_hongb.png"
  if state == LLConst.ZWLBuildingState.OVER then
    bg = "lrb_jinmai_hui.png"
    bgA = "lrb_jinmai_huiA.png"
    bgB = "lrb_jinmai_huiB.png"
  elseif ownerCampId == LLConst.LandLordGroup.NONE then
    bg = "lrb_jinmai_huang.png"
    bgA = "lrb_jinmai_huangA.png"
    bgB = "lrb_jinmai_huangB.png"
  elseif ownerCampId == myGroup then
    bg = "lrb_jinmai_lan.png"
    bgA = "lrb_jinmai_lanA.png"
    bgB = "lrb_jinmai_lanB.png"
  end
  local bgPath = string.format(LoadPath.LandlordPath, bg)
  local bgAPath = string.format(LoadPath.LandlordPath, bgA)
  local bgBPath = string.format(LoadPath.LandlordPath, bgB)
  return bgPath, bgAPath, bgBPath
end

function LandlordMgr:GetDetailOccupyKey(state, ownerCampId, myGroup)
  local occupyKey = "zonewar_landlord_limit_1021"
  if state == LLConst.ZWLBuildingState.OVER then
    occupyKey = "zonewar_landlord_limit_1017"
  elseif ownerCampId == LLConst.LandLordGroup.NONE then
    occupyKey = "zonewar_landlord_limit_1023"
  elseif ownerCampId == myGroup then
    occupyKey = "zonewar_landlord_limit_1022"
  end
  return occupyKey
end

function LandlordMgr:GetDetailSubCityColor(state, ownerCampId, myGroup)
  local color = "#fec5c4"
  if state == LLConst.ZWLBuildingState.OVER then
    color = "#dbd6d3"
  elseif ownerCampId == LLConst.LandLordGroup.NONE then
    color = "#ffd37d"
  elseif ownerCampId == myGroup then
    color = "#c9e0ee"
  end
  return color
end

function LandlordMgr:GetDetailPosColor(state, ownerCampId, myGroup)
  local color = "#f97077"
  if state == LLConst.ZWLBuildingState.OVER then
    color = "#FFFFFF"
  elseif ownerCampId == LLConst.LandLordGroup.NONE then
    color = "#FFFFFF"
  elseif ownerCampId == myGroup then
    color = "#70E6F1"
  end
  return color
end

function LandlordMgr:GetRankTypeKey(idx)
  local key = "zonewar_landlord_score_type_name_1004"
  if 2 <= idx and idx <= 4 then
    key = "zonewar_landlord_score_type_name_100" .. idx - 1
  end
  return key
end

function LandlordMgr:CheckLLResourceByServerId(serverId)
  if CS.UnityEngine.Application.isEditor or serverId == LuaEntry.Player:GetSelfServerId() then
    return true
  end
  local config = DataCenter.SeasonTemplateManager:GetConfigDataByServerId(serverId)
  if config == nil then
    return true
  end
  local seasonId = toInt(config.server_index)
  local curSeconds = UITimeManager:GetInstance():GetServerSeconds()
  local realOpenSec, realCloseSec = self:GetCurTemplateServerGroupOpenTime(seasonId, serverId)
  if curSeconds >= realOpenSec and curSeconds <= realCloseSec then
    local flag = RaceEntranceUtil.IsNeedShowLoading(EnumActivity.ActLandlord.ActId, true, true)
    return not flag
  end
  return true
end

function LandlordMgr:Description()
  local sb = StringBuilder.New()
  self:DescriptionAct(sb)
  self:DescriptionBattle(sb)
  return sb:ToString()
end

function LandlordMgr:TestFunc()
  local list = self:GetBattleTimeCtrlDic()
  local tipTemplate = list[1]
  for i = 1, 8 do
    local isFly = i == 1
    if i ~= 2 and i ~= 3 then
      TimerManager:GetInstance():DelayInvoke(function()
        local cfg = i ~= 8 and tipTemplate or nil
        local data = self.TimeCtrlParamData
        if cfg ~= nil or data.config ~= cfg then
          data.config = cfg
          data.isFly = isFly
          EventManager:GetInstance():Broadcast(EventId.LandlordBattleTimeCtrlNotice, data)
        end
      end, i)
    end
  end
end

BattleFieldUtil.MergeFunctions(LandlordMgr, "DataCenter.Landlord.Module.LLAct")
BattleFieldUtil.MergeFunctions(LandlordMgr, "DataCenter.Landlord.Module.LLBattle")
BattleFieldUtil.MergeFunctions(LandlordMgr, "DataCenter.Landlord.Module.LLConfig")
return LandlordMgr
