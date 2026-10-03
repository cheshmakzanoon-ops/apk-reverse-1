local SurprisePointManager = BaseClass("SurprisePointManager")
local SurprisePointTemplate = require("DataCenter.SeasonManager.SurprisePointTemplate")

function SurprisePointManager:__init()
  self.hasGetDic = nil
  self.tempDic = nil
  self.maxCount = 0
  self:AddListener()
end

function SurprisePointManager:__delete()
  self:RemoveListener()
end

function SurprisePointManager:Startup()
end

function SurprisePointManager:AddListener()
  EventManager:GetInstance():AddListenerWithSelf(EventId.OnEnterWorldFromCity, self.RequestSurprisePointInfo, self)
  EventManager:GetInstance():AddListenerWithSelf(EventId.GF_plot_group_done, self.OnPlotGroupDone, self)
end

function SurprisePointManager:RemoveListener()
  EventManager:GetInstance():RemoveListener2(EventId.OnEnterWorldFromCity, self.RequestSurprisePointInfo, self)
  EventManager:GetInstance():RemoveListener2(EventId.GF_plot_group_done, self.OnPlotGroupDone, self)
end

function SurprisePointManager:OnEnterGame()
  self.hasRequest = nil
end

function SurprisePointManager:InitData(data)
end

function SurprisePointManager:GetConfigData(configId)
  if not self.tempDic then
    self.tempDic = {}
  end
  if not self.tempDic[configId] then
    local config = LocalController:instance():getLine(TableName.LW_Map_Surprise, configId)
    if config then
      self.tempDic[configId] = SurprisePointTemplate.New(config)
    else
      return nil
    end
  end
  return self.tempDic[configId]
end

function SurprisePointManager:HasGet(pointId)
  if not self.hasGetDic then
    return false
  end
  if not LuaEntry.Player:IsInSourceServer() then
    return true
  end
  return self.hasGetDic[pointId]
end

function SurprisePointManager:RegisterGet(pointId)
  if not self.hasGetDic then
    self.hasGetDic = {}
  end
  self.hasGetDic[pointId] = true
end

function SurprisePointManager:GetCount()
  if not self.hasGetDic then
    return 0
  end
  return table.count(self.hasGetDic)
end

function SurprisePointManager:GetPrefabPath(info)
  if not info or not LuaEntry.Player:IsInSourceServer() then
    return nil
  end
  if self:HasGet(info.pointIndex) then
    return nil
  end
  local conf = self:GetConfigData(info.configId)
  if not conf then
    return nil
  end
  if conf.effects_condition == 2 and not DataCenter.SeasonGreenManager:IsGreen(info.pointIndex) then
    return nil
  end
  return conf.effects
end

function SurprisePointManager:RequestSurprisePointInfo()
  if BattleFieldUtil.InBattleField() then
    return
  end
  if self.hasRequest or not LuaEntry.Player:IsInSourceServer() then
    return
  end
  if not SeasonUtil.IsInSeason() and not SeasonUtil.IsInSeasonTruceMode() then
    EventManager:GetInstance():RemoveListener2(EventId.OnEnterWorldFromCity, self.RequestSurprisePointInfo, self)
    self.hasRequest = true
    return
  end
  SFSNetwork.SendMessage(MsgDefines.SurprisePointGetInfo)
end

function SurprisePointManager:OnSurprisePointGetInfo(pointIds, maxCount)
  EventManager:GetInstance():RemoveListener2(EventId.OnEnterWorldFromCity, self.RequestSurprisePointInfo, self)
  self.hasRequest = true
  self.maxCount = maxCount or 0
  self.hasGetDic = {}
  if not pointIds then
    return
  end
  for i, pointId in ipairs(pointIds) do
    self.hasGetDic[pointId] = true
  end
end

function SurprisePointManager:ClickSurprisePoint(info)
  if not info then
    return
  end
  if not LuaEntry.Player:IsInSourceServer() then
    UIUtil.ShowTipsId("map_surprise_s3_tips_3")
    return
  end
  if self:HasGet(info.pointIndex) then
    UIUtil.ShowTips(self:GetCountTips())
    return
  end
  local seasonType = SeasonUtil.GetSeasonType()
  if seasonType == SeasonMapType.Darkness and DataCenter.BloodyNightDataManager:IsDawn(LuaEntry.Player:GetCurServerId()) then
    SFSNetwork.SendMessage(MsgDefines.SurprisePointDetail, info.pointIndex)
    return true
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  if self.lastClickTime and now - self.lastClickTime < 300 then
    return
  end
  self.lastClickTime = now
  local conf = self:GetConfigData(info.configId)
  if not conf then
    return
  end
  local openTime = info.openTime
  if openTime ~= nil then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local remainTime = openTime - curTime
    if 0 < remainTime then
      if conf.plot and conf.notopen_plot ~= nil and 0 < conf.notopen_plot then
        EventManager:GetInstance():Broadcast(EventId.PlayPlotGroup, {
          plotGroupId = conf.notopen_plot,
          hideMainUI = false
        })
        return
      end
      return
    end
  end
  local showTime = info.showTime
  if showTime <= 0 then
    return
  end
  if seasonType == SeasonMapType.Darkness then
    if conf.reward_condition == 3 and not CS.LightDataManager.GetInstance():IsLightUpInPointId(info.pointIndex) then
      return
    end
  elseif conf.reward_condition == 2 and not DataCenter.SeasonGreenManager:IsGreen(info.pointIndex) then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.SurprisePointDetail, info.pointIndex)
  return true
end

function SurprisePointManager:OnSurprisePointDetail(message)
  if not message or not message.configId then
    return
  end
  if message.rewardState == 1 then
    self:RegisterGet(message.pointId)
    UIUtil.ShowTips(self:GetCountTips())
    return
  end
  local conf = self:GetConfigData(message.configId)
  if not conf then
    return
  end
  if UIUtil.CheckEventTrigger(OpMode.ClickBtnWorldSurprisePoint) then
    return
  end
  if conf.plot and conf.plot > 0 then
    self.plotGroupId = conf.plot
    self.lastMessage = message
    EventManager:GetInstance():Broadcast(EventId.PlayPlotGroup, {
      plotGroupId = self.plotGroupId,
      hideMainUI = false
    })
    return
  end
  self.plotGroupId = nil
  SFSNetwork.SendMessage(MsgDefines.SurprisePointGetReward, message.pointId)
end

function SurprisePointManager:OnPlotGroupDone(plotGroupId)
  if self.plotGroupId and self.plotGroupId == plotGroupId then
    if self.lastMessage then
      SFSNetwork.SendMessage(MsgDefines.SurprisePointGetReward, self.lastMessage.pointId, self.lastMessage.worldId)
    end
    self.lastMessage = nil
    self.plotGroupId = nil
  end
end

function SurprisePointManager:OnSurprisePointGetReward(message)
  if not message or message.rewardState ~= 1 then
    return
  end
  self:RegisterGet(message.pointId)
  CS.SceneManager.World:HideObject(message.pointId)
  if message.reward or message.resource then
    local tips
    local conf = self:GetConfigData(message.configId)
    if conf and not string.IsNullOrEmpty(conf.reward_tips) then
      tips = conf.reward_tips
    end
    DataCenter.RewardManager:AddRewardsAndRes(message)
    DataCenter.RewardManager:ShowCommonReward(message, nil, nil, nil, nil, nil, nil, CS.GameEntry.Localization:GetString(tips), self:GetCountTips())
  end
end

function SurprisePointManager:GetCountTips()
  local curCount = self:GetCount()
  if curCount < self.maxCount then
    return CS.GameEntry.Localization:GetString("map_surprise_s3_tips_1", self.maxCount - curCount)
  end
  return CS.GameEntry.Localization:GetString("map_surprise_s3_tips_2")
end

return SurprisePointManager
