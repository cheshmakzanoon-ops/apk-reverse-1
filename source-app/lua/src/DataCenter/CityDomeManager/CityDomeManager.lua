local CityDomeManager = BaseClass("CityDomeManager")
local CityDome = require("Scene.CityDome.CityDome")

function CityDomeManager:__init()
  self.range = nil
  self.cityDome = nil
  self.afterFinishCallBackList = {}
  self.isPlaying = false
  self:AddListener()
end

function CityDomeManager:__delete()
  self.range = nil
  self.afterFinishCallBackList = {}
  self.isPlaying = false
  self:RemoveListener()
  self:HideCityDomeSignal()
end

function CityDomeManager:Startup()
end

function CityDomeManager:AddListener()
  if self.showCityDomeSignal == nil then
    function self.showCityDomeSignal()
      self:ShowCityDomeSignal()
    end
    
    EventManager:GetInstance():AddListener(EventId.ShowCityDome, self.showCityDomeSignal)
  end
  if self.hideCityDomeSignal == nil then
    function self.hideCityDomeSignal()
      self:HideCityDomeSignal()
    end
    
    EventManager:GetInstance():AddListener(EventId.HideCityDome, self.hideCityDomeSignal)
  end
end

function CityDomeManager:AfterAddListener()
  if self.mainLvUpSignal == nil then
    function self.mainLvUpSignal()
      self:MainLvUpSignal()
    end
    
    EventManager:GetInstance():AddListener(EventId.MainLvUp, self.mainLvUpSignal)
  end
  if self.questRewardSuccessSignal == nil then
    function self.questRewardSuccessSignal()
      self:QuestRewardSuccessSignal()
    end
    
    EventManager:GetInstance():AddListener(EventId.QuestRewardSuccess, self.questRewardSuccessSignal)
  end
  if self.guideSaveIdSignal == nil then
    function self.guideSaveIdSignal()
      self:GuideSaveIdSignal()
    end
    
    EventManager:GetInstance():AddListener(EventId.GuideSaveId, self.guideSaveIdSignal)
  end
end

function CityDomeManager:RemoveListener()
  if self.mainLvUpSignal ~= nil then
    EventManager:GetInstance():RemoveListener(EventId.MainLvUp, self.mainLvUpSignal)
    self.mainLvUpSignal = nil
  end
  if self.questRewardSuccessSignal ~= nil then
    EventManager:GetInstance():RemoveListener(EventId.QuestRewardSuccess, self.questRewardSuccessSignal)
    self.questRewardSuccessSignal = nil
  end
  if self.guideSaveIdSignal ~= nil then
    EventManager:GetInstance():RemoveListener(EventId.GuideSaveId, self.guideSaveIdSignal)
    self.guideSaveIdSignal = nil
  end
  if self.showCityDomeSignal ~= nil then
    EventManager:GetInstance():RemoveListener(EventId.ShowCityDome, self.showCityDomeSignal)
    self.showCityDomeSignal = nil
  end
  if self.hideCityDomeSignal ~= nil then
    EventManager:GetInstance():RemoveListener(EventId.HideCityDome, self.hideCityDomeSignal)
    self.hideCityDomeSignal = nil
  end
end

function CityDomeManager:InitRange()
  self.range = self:GetDomeRange()
  self:AfterAddListener()
end

function CityDomeManager:GetDomeRangeCache()
  if self.range == nil then
    self.range = self:GetDomeRange()
  end
  return self.range
end

function CityDomeManager:GetDomeRange()
  local needMaxLevel = LuaEntry.DataConfig:TryGetNum("canopyvault", "k1")
  if needMaxLevel <= DataCenter.BuildManager.MainLv then
    return DomeRange.Max
  end
  local needQuestId = LuaEntry.DataConfig:TryGetStr("canopyvault", "k2")
  if DataCenter.TaskManager:IsFinishTask(needQuestId) then
    return DomeRange.Max
  end
  local needGuideId = LuaEntry.DataConfig:TryGetNum("canopyvault", "k3")
  if DataCenter.GuideManager:IsDoneThisGuide(needGuideId) then
    return DomeRange.Max
  end
  needMaxLevel = LuaEntry.DataConfig:TryGetNum("canopyvault", "k5")
  if needMaxLevel <= DataCenter.BuildManager.MainLv then
    return DomeRange.Middle
  end
  needQuestId = LuaEntry.DataConfig:TryGetStr("canopyvault", "k6")
  if DataCenter.TaskManager:IsFinishTask(needQuestId) then
    return DomeRange.Middle
  end
  needGuideId = LuaEntry.DataConfig:TryGetNum("canopyvault", "k7")
  if DataCenter.GuideManager:IsDoneThisGuide(needGuideId) then
    return DomeRange.Middle
  end
  return DomeRange.Min
end

function CityDomeManager:MainLvUpSignal()
  self:CheckAndDoChangeRange()
end

function CityDomeManager:QuestRewardSuccessSignal()
  self:CheckAndDoChangeRange()
end

function CityDomeManager:GuideSaveIdSignal()
  self:CheckAndDoChangeRange()
end

function CityDomeManager:CheckAndDoChangeRange()
  local range = self:GetDomeRange()
  if self.range ~= range then
    self:DoChangeRange()
    self.range = range
  end
end

function CityDomeManager:DoChangeRange()
  self.isPlaying = true
  if self.range == DomeRange.Zero then
    self:ChangeRangeCallBack()
  elseif self.range == DomeRange.Min then
    self:DirectionExpend()
  elseif self.range == DomeRange.Middle then
    self:DirectionExpend()
  end
end

function CityDomeManager:ChangeRangeCallBack()
  self.isPlaying = false
  EventManager:GetInstance():Broadcast(EventId.SetCityPeopleAndCarVisible, CityPeopleAndCarVisibleType.AllShow)
  EventManager:GetInstance():Broadcast(EventId.DomeRangeChanged, self:GetDomeRangeCache())
  self:DoAfterFinishCallBack()
end

function CityDomeManager:IsInDome(worldPos, exRadius)
  if worldPos == nil then
    return false
  end
  local mainPos = self:GetDomePos()
  if mainPos then
    local worldRadius = self:GetDomeRadius() + (exRadius or 0)
    local disX = math.abs(worldPos.x - mainPos.x)
    local disZ = math.abs(worldPos.z - mainPos.z)
    return worldRadius >= disX and worldRadius >= disZ
  end
  return false
end

function CityDomeManager:IsInDomeByPoint(pointId)
  return self:IsInDome(SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.City))
end

function CityDomeManager:GetDomeRadius()
  local range = self:GetDomeRangeCache()
  if DomeRadius[range] ~= nil then
    return DomeRadius[range]
  end
  return DomeRadius[DomeRange.Max]
end

function CityDomeManager:ShowCityDomeSignal()
  if not DataCenter.GuideManager:IsStartCanShowBuild() or self.cityDome == nil then
  end
end

function CityDomeManager:HideCityDomeSignal()
  if self.cityDome ~= nil then
    self.cityDome:Destroy()
    self.cityDome = nil
  end
end

function CityDomeManager:GetDomePos()
  local mainBuild = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_MAIN)
  if mainBuild ~= nil then
    return mainBuild:GetCenterVec()
  end
end

function CityDomeManager:IsPlayingExpendDome()
  return self.isPlaying
end

function CityDomeManager:AddAfterFinishCallBack(callBack)
  table.insert(self.afterFinishCallBackList, callBack)
end

function CityDomeManager:DoAfterFinishCallBack()
  for k, v in ipairs(self.afterFinishCallBackList) do
    v()
  end
  self.afterFinishCallBackList = {}
  DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.AfterCityDomeExpend, tostring(self:GetDomeRangeCache()))
end

function CityDomeManager:GetDomeLevel()
  local range = self:GetDomeRangeCache()
  if DomeLevel[range] ~= nil then
    return DomeLevel[range]
  end
  return DomeLevel[DomeRange.Max]
end

function CityDomeManager:DirectionExpend()
  self.range = self:GetDomeRange()
  CS.SceneManager.World:ClearReInitObject()
  DataCenter.LandLockManager:DestroyAll()
  CS.SceneManager.World:ReInitObject()
  DataCenter.LandLockManager:RefreshAll()
  self:ChangeRangeCallBack()
end

return CityDomeManager
