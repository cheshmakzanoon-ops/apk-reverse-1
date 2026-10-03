local SeasonFarmerManager = BaseClass("SeasonFarmerManager")

function SeasonFarmerManager:__init()
  self.activityId = nil
  self.effectList = nil
  self.allianceBuildInfo = {}
  self:AddListener()
end

function SeasonFarmerManager:__delete()
  self:RemoveListener()
end

function SeasonFarmerManager:Startup()
end

function SeasonFarmerManager:AddListener()
  EventManager:GetInstance():AddListenerWithSelf(EventId.Al_Leave, self.OnALLeave, self)
  EventManager:GetInstance():AddListenerWithSelf(EventId.Al_Join, self.OnALJoin, self)
end

function SeasonFarmerManager:RemoveListener()
  EventManager:GetInstance():RemoveListener2(EventId.Al_Leave, self.OnALLeave, self)
  EventManager:GetInstance():RemoveListener2(EventId.Al_Join, self.OnALJoin, self)
end

function SeasonFarmerManager:InitData(data)
  self.activityId = data.id
  self.effectList = nil
end

function SeasonFarmerManager:SyncBubbleData()
  local bubble_limit = 0
  local todayClickCount = 0
  local cfg = DataCenter.SeasonFarmerTemplateManager:GetMainCfg()
  if cfg then
    bubble_limit = toInt(cfg.bubble_limit)
  end
  local keyDay = "ClickCityAttachmentBubbleDay"
  local keyCount = "ClickCityAttachmentBubbleCount"
  local todayZeroTime = UITimeManager:GetInstance():TodayZero()
  local strTodayTime = Setting:GetPrivateString(keyDay, nil)
  if strTodayTime == nil or strTodayTime == "" or tostring(todayZeroTime) ~= strTodayTime then
    Setting:SetPrivateInt(keyCount, 0)
    Setting:SetPrivateString(keyDay, tostring(todayZeroTime))
    todayClickCount = 0
  else
    todayClickCount = Setting:GetPrivateInt(keyCount, 0)
  end
  Setting:SetPrivateInt("CityAttachmentBubbleCount", bubble_limit - todayClickCount)
end

function SeasonFarmerManager:GetConfigData(configId)
end

function SeasonFarmerManager:GetConfigDataByServerId(_)
end

function SeasonFarmerManager:GetActivityId()
  return self.activityId
end

function SeasonFarmerManager:GetActivityData()
end

function SeasonFarmerManager:CleanBuildReward()
  local allianceBuildInfo = self.allianceBuildInfo
  if allianceBuildInfo and allianceBuildInfo.rewardList then
    allianceBuildInfo.rewardList = {}
  end
end

function SeasonFarmerManager:CountOfBuildReward()
  local allianceBuildInfo = self.allianceBuildInfo
  local leftNum = 0
  if self:IsOpen() and allianceBuildInfo and allianceBuildInfo.rewardList then
    for k, v in pairs(allianceBuildInfo.rewardList) do
      if v and 0 < toInt(v.leftNum) then
        leftNum = leftNum + toInt(v.leftNum)
      end
    end
  end
  return leftNum
end

function SeasonFarmerManager:IsOpen()
  if not SeasonUtil.IsSeasonActivityOpen(self.activityId) then
    return false
  end
  return SeasonUtil.GetFarmerConfigId() ~= 0
end

function SeasonFarmerManager:IsActive()
  return self.allianceBuildInfo.hasAllianceBuilder and LuaEntry.Player:IsInAlliance() and SeasonUtil.IsInSeason()
end

function SeasonFarmerManager:GetStartTime()
  local data = self.activityId and DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if data then
    return data.startTime or 0
  end
  return 0
end

function SeasonFarmerManager:OnLeaveAlliance()
  self.allianceBuildInfo = {}
  SFSNetwork.SendMessage(MsgDefines.GetCityAttachmentEffectInfo)
end

function SeasonFarmerManager:OnBuilderStateChange(netData)
  if self.allianceBuildInfo.hasAllianceBuilder ~= netData.hasAllianceBuilder then
    DataCenter.RadarCenterDataManager:UpdateBuildersAllianceDrop(netData.hasAllianceBuilder)
  end
  self.allianceBuildInfo.hasAllianceBuilder = netData.hasAllianceBuilder
  if netData.builderExpInfo then
    self.allianceBuildInfo.builderExpInfo = netData.builderExpInfo
    if netData.builderExpInfo.curExp then
      local allianceData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
      if allianceData then
        allianceData.resFarmerExp = toInt(netData.builderExpInfo.curExp)
      end
    end
  end
  if netData.ownerList then
    self.allianceBuildInfo.ownerList = netData.ownerList
  end
  if netData.rewardList then
    self.allianceBuildInfo.rewardList = netData.rewardList
  end
  SeasonUtil.SendFarmerAchievementData()
  EventManager:GetInstance():Broadcast(EventId.SeasonFarmerStateChange)
end

function SeasonFarmerManager:GetCurBuildingInfo()
  if table.IsNullOrEmpty(self.allianceBuildInfo) then
    return nil
  end
  local list = self.allianceBuildInfo.ownerList
  if list then
    for k, v in pairs(list) do
      if v.state == 0 then
        return v
      end
    end
  end
  return nil
end

function SeasonFarmerManager:GotoCurBuilding()
  local buildInfo = self:GetCurBuildingInfo()
  if not buildInfo then
    UIUtil.ShowTipsId("season_builders_alliance_tips_6")
    return
  end
  local pos = SceneUtils.IndexToTilePos(buildInfo.pointId, ForceChangeScene.World)
  local v3 = SceneUtils.TileToWorld(pos, ForceChangeScene.World)
  GoToUtil.CloseAllWindows()
  GoToUtil.GotoWorldPos(v3, CS.SceneManager.World.InitZoom, nil, nil, buildInfo.serverId)
end

function SeasonFarmerManager:OnALLeave()
  self.allianceBuildInfo = {}
  SFSNetwork.SendMessage(MsgDefines.GetCityAttachmentEffectInfo)
end

function SeasonFarmerManager:OnALJoin()
  SFSNetwork.SendMessage(MsgDefines.GetCityAttachmentEffectInfo)
  SFSNetwork.SendMessage(MsgDefines.FetchCityAttachmentList)
end

function SeasonFarmerManager:SetCityAttachmentEffectInfo(effectInfo)
  self.effectList = effectInfo
  EventManager:GetInstance():Broadcast(EventId.LuaEntryEffectRefreshStatus)
end

function SeasonFarmerManager:GetCityAttachmentEffectInfo()
  return self.effectList
end

function SeasonFarmerManager:HasView()
  if not self.activityId then
    return false
  end
  local key = string.format("SeasonFarmerView_%s_%s", self.activityId, SeasonUtil.GetSeasonId())
  return Setting:GetPrivateBool(key, false)
end

function SeasonFarmerManager:SetView()
  if not self.activityId or self:HasView() then
    return
  end
  local key = string.format("SeasonFarmerView_%s_%s", self.activityId, SeasonUtil.GetSeasonId())
  Setting:SetPrivateBool(key, true)
end

return SeasonFarmerManager
