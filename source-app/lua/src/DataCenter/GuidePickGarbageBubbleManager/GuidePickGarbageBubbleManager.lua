local GuidePickGarbageBubbleManager = BaseClass("GuidePickGarbageBubbleManager")
local UIGuidePickGarbageProgressBubble = require("UI.UIGuidePickGarbageBubble.UIGuidePickGarbageProgressBubble")
local UIGuidePickGarbageNormalBubble = require("UI.UIGuidePickGarbageBubble.UIGuidePickGarbageNormalBubble")
local ResourceManager = CS.GameEntry.Resource

local function __init(self)
  self:AddListener()
  self.pickProgress = nil
  self.pickQueue = {}
  self.rewards = {}
end

local function __delete(self)
  self:RemoveListener()
  self.pickProgress = nil
  self.pickQueue = nil
  self.rewards = nil
end

local function InitData(self)
end

local function AddListener(self)
  EventManager:GetInstance():AddListener(EventId.UpdateCityPoint, self.UpdateCityPointHandler)
  EventManager:GetInstance():AddListener(EventId.Guide_video_Play, self.UpdateAllCityPointWhenEnterCityHandler)
end

local function RemoveListener(self)
  EventManager:GetInstance():RemoveListener(EventId.UpdateCityPoint, self.UpdateCityPointHandler)
  EventManager:GetInstance():RemoveListener(EventId.Guide_video_Play, self.UpdateAllCityPointWhenEnterCityHandler)
end

local function RefreshPickProgress(self)
  if self.pickProgress ~= nil then
    local startTime = DataCenter.PickGarbageDataManager.currentPickStartTime
    local endTime = DataCenter.PickGarbageDataManager.currentPickEndTime
    local currentIndex = DataCenter.PickGarbageDataManager:GetCurrentPickIndex()
    self.pickProgress:ReInit(startTime, endTime, currentIndex)
  else
    self:AddPickProgress()
  end
end

local function AddPickProgress(self)
  if self.pickProgress == nil then
    local request = ResourceManager:InstantiateAsync("Assets/Main/Prefabs/March/CollectGarbageUI.prefab")
    request:completed("+", function()
      request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      request.gameObject.name = "PickProgress"
      self.pickProgress = UIGuidePickGarbageProgressBubble.New()
      self.pickProgress:OnCreate(request)
      self:RefreshPickProgress()
    end)
  end
end

local function RemovePickProgress(self)
  if self.pickProgress ~= nil then
    self.pickProgress:OnDestroy()
    if self.pickProgress.gameObject ~= nil then
      self.pickProgress.gameObject:Destroy()
    end
    self.pickProgress = nil
  end
  self:HideGarbageClickEffect()
end

local function AddPickQueue(self, index)
  if self.pickQueue[index] == nil then
    local request = ResourceManager:InstantiateAsync("Assets/Main/Prefabs/Guide/UIGuidePickGarbageNormalBubble.prefab")
    request:completed("+", function()
      request.gameObject:SetActive(true)
      request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      request.gameObject.name = "PickQueue_" .. index
      local tmp = UIGuidePickGarbageNormalBubble.New()
      tmp:OnCreate(request)
      tmp:ReInit(string.format(LoadPath.UIBuildBtns, "UIworld_img_garbage_head"), string.format(LoadPath.UIBuildBtns, BuildBubbleIconName.BgUnSelect), index)
      self.pickQueue[index] = tmp
    end)
  else
    self.pickQueue[index].gameObject:SetActive(true)
  end
end

local function RemovePickQueue(self, index)
  self:HideGarbageClickEffect(index)
  if self.pickQueue[index] ~= nil then
    self.pickQueue[index]:OnDestroy()
    if self.pickQueue[index].gameObject then
      self.pickQueue[index].gameObject:Destroy()
    end
    self.pickQueue[index] = nil
  end
end

local function AddReward(self, index)
  if self.rewards[index] == nil then
    local request = ResourceManager:InstantiateAsync("Assets/Main/Prefabs/Guide/UIGuidePickGarbageNormalBubble.prefab")
    request:completed("+", function()
      request.gameObject:SetActive(true)
      request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      request.gameObject.name = "Reward_" .. index
      local tmp = UIGuidePickGarbageNormalBubble.New()
      local pic = ""
      local pointData = DataCenter.CityPointDataManager:GetPointDataByPointId(index)
      local rewardList = DataCenter.RewardManager:ReturnRewardParamForMessage(pointData.rewardList)
      local rewardType, rewardId
      if rewardList ~= nil and table.count(rewardList) > 0 then
        local reward = rewardList[1]
        rewardType = reward.rewardType
        rewardId = reward.itemId
        pic = DataCenter.RewardManager:GetPicByType(reward.rewardType, reward.itemId)
      end
      tmp:OnCreate(request)
      tmp:ReInit(pic, string.format(LoadPath.UIBuildBtns, BuildBubbleIconName.BgSelect), index, rewardType, rewardId)
      self.rewards[index] = tmp
    end)
  else
    self.rewards[index].gameObject:SetActive(true)
  end
end

local function RemoveReward(self, index)
  if self.rewards[index] ~= nil then
    if self.rewards[index].gameObject then
      self.rewards[index].gameObject:Destroy()
    end
    self.rewards[index] = nil
  end
end

local function UpdateCityPointHandler(data)
  if not DataCenter.CityPioneerManager:IsBeforePrologue() then
    DataCenter.GuidePickGarbageBubbleManager:DoUpdateCityPoint(data)
  end
end

local function UpdateAllCityPointWhenEnterCityHandler()
  if not DataCenter.CityPioneerManager:IsBeforePrologue() then
    local list = DataCenter.CityPointDataManager:GetAllPointData()
    table.walk(list, function(k, v)
      DataCenter.GuidePickGarbageBubbleManager:DoUpdateCityPoint(v.pointId)
    end)
  end
end

local function DoUpdateCityPoint(self, pointId)
  local pointData = DataCenter.CityPointDataManager:GetPointDataByPointId(pointId)
  if pointData ~= nil and pointData.type == CityPointType.GarbageReward then
    DataCenter.GuidePickGarbageBubbleManager:AddReward(pointId)
  else
    DataCenter.GuidePickGarbageBubbleManager:RemoveReward(pointId)
  end
end

local function HideGarbageClickEffect(self, index)
  if self.garbage ~= nil and self.garbage.gameObject ~= nil and (index == nil or tostring(index) == self.garbage.gameObject.name) then
    self.garbage.gameObject:SetActive(false)
  end
end

local function ShowGarbageClickEffect(self, index)
  if self.garbage ~= nil and self.garbage.gameObject ~= nil then
    self.garbage.gameObject:SetActive(true)
    self.garbage.gameObject.name = tostring(index)
    local worldPointPos = SceneUtils.TileIndexToWorld(index, ForceChangeScene.World, LuaEntry.Player:GetSelfServerId())
    self.garbage.gameObject.transform.position = worldPointPos
  else
    self.garbage = ResourceManager:InstantiateAsync(TouchTerrainEffect)
    self.garbage:completed("+", function()
      if self.garbage.isError then
        return
      end
      self.garbage.gameObject:SetActive(true)
      local worldPointPos = SceneUtils.TileIndexToWorld(index, ForceChangeScene.World, LuaEntry.Player:GetSelfServerId())
      self.garbage.gameObject.transform:Set_localScale(1.3, 1.3, 1.3)
      self.garbage.gameObject.transform.position = worldPointPos
      self.garbage.gameObject.name = tostring(index)
    end)
  end
end

local function GetBubbleByPoint(self, pointId)
  if self.rewards ~= nil and self.rewards[pointId] ~= nil then
    return self.rewards[pointId]:GetGuideObject()
  end
end

GuidePickGarbageBubbleManager.__init = __init
GuidePickGarbageBubbleManager.__delete = __delete
GuidePickGarbageBubbleManager.AddListener = AddListener
GuidePickGarbageBubbleManager.RemoveListener = RemoveListener
GuidePickGarbageBubbleManager.RefreshPickProgress = RefreshPickProgress
GuidePickGarbageBubbleManager.AddPickProgress = AddPickProgress
GuidePickGarbageBubbleManager.RemovePickProgress = RemovePickProgress
GuidePickGarbageBubbleManager.AddPickQueue = AddPickQueue
GuidePickGarbageBubbleManager.RemovePickQueue = RemovePickQueue
GuidePickGarbageBubbleManager.AddReward = AddReward
GuidePickGarbageBubbleManager.RemoveReward = RemoveReward
GuidePickGarbageBubbleManager.UpdateCityPointHandler = UpdateCityPointHandler
GuidePickGarbageBubbleManager.UpdateAllCityPointWhenEnterCityHandler = UpdateAllCityPointWhenEnterCityHandler
GuidePickGarbageBubbleManager.InitData = InitData
GuidePickGarbageBubbleManager.DoUpdateCityPoint = DoUpdateCityPoint
GuidePickGarbageBubbleManager.HideGarbageClickEffect = HideGarbageClickEffect
GuidePickGarbageBubbleManager.ShowGarbageClickEffect = ShowGarbageClickEffect
GuidePickGarbageBubbleManager.GetBubbleByPoint = GetBubbleByPoint
return GuidePickGarbageBubbleManager
