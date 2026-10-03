local WorldDetectZombieBusTrain = BaseClass("WorldDetectZombieBusTrain", UIAsyncContainer)
local base = UIAsyncContainer
local Localization = CS.GameEntry.Localization
local main_obj_path = "BuildInfo"
local main_time_remain_path = "BuildInfo/TimeRemain"
local content_path = "BuildInfo/ScrollView/Viewport/Content"
local animator_path = ""

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.animator = self:AddComponent(UIAnimator, animator_path)
  self.main_obj = self:AddComponent(UIBaseContainer, main_obj_path)
  self.main_obj_canvas = self:AddComponent(UICanvasGroup, main_obj_path)
  self.main_obj_canvas:SetAlpha(1)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.commonResItemPrefab = self.transform:Find("BuildInfo/ScrollView/Viewport/Content/UICommonResItem").gameObject
  self.commonResItemPrefab:GameObjectCreatePool()
  self.commonResItemPrefab:SetActive(false)
  self.mainRemainTimeTxt = self:AddComponent(UIText, main_time_remain_path)
end

local function ComponentDestroy(self)
  self.content:RemoveComponents(UICommonResItem)
  self.commonResItemPrefab.gameObject:GameObjectRecycleAll()
  self.commonResItemPrefab = nil
  self.mainRemainTimeTxt = nil
end

local function DataDefine(self)
  self.data = nil
end

local function DataDestroy(self)
  self.data = nil
  self.endTime = nil
end

local function RefreshData(self, data)
  self.data = data
  local zombieBusTrainEvent = DataCenter.RadarCenterDataManager:GetZombieBusTrainEvent()
  self.rewardList = DataCenter.RewardManager:ReturnRewardParamForMessage(zombieBusTrainEvent.busReward) or {}
  self:AddRewardToContainer(self.rewardList)
  local marchUuid = zombieBusTrainEvent.marchUuid or 0
  local info = CS.SceneManager.World:GetMarch(marchUuid)
  if info then
    self.endTime = info.endTime
  end
  self:RefreshTime()
end

function WorldDetectZombieBusTrain:RefreshTime()
  local remainTime = 0
  if self.endTime ~= nil then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local time = self.endTime - curTime
    remainTime = math.max(time, 0)
  else
    remainTime = 1
  end
  local str = UITimeManager:GetInstance():MilliSecondToFmtStringFloor(remainTime)
  self.mainRemainTimeTxt:SetText(Localization:GetString("radar_zombiebus_001", str))
  if remainTime <= 0 then
    self.view.ctrl:CloseSelf()
  end
end

function WorldDetectZombieBusTrain:Update1000MS()
  self:RefreshTime()
end

local function AddRewardToContainer(self, list)
  self.content:RemoveComponents(UICommonResItem)
  self.commonResItemPrefab.gameObject:GameObjectRecycleAll()
  if list then
    for i, data in ipairs(list) do
      local go = self.commonResItemPrefab:GameObjectSpawn(self.content.transform)
      local nameStr = "UICommonResItem" .. i
      go.name = nameStr
      local cell = self.content:AddComponent(UICommonResItem, nameStr)
      cell:ReInit(data)
    end
  end
end

WorldDetectZombieBusTrain.OnCreate = OnCreate
WorldDetectZombieBusTrain.OnDestroy = OnDestroy
WorldDetectZombieBusTrain.OnEnable = OnEnable
WorldDetectZombieBusTrain.OnDisable = OnDisable
WorldDetectZombieBusTrain.ComponentDefine = ComponentDefine
WorldDetectZombieBusTrain.ComponentDestroy = ComponentDestroy
WorldDetectZombieBusTrain.DataDefine = DataDefine
WorldDetectZombieBusTrain.DataDestroy = DataDestroy
WorldDetectZombieBusTrain.RefreshData = RefreshData
WorldDetectZombieBusTrain.AddRewardToContainer = AddRewardToContainer
return WorldDetectZombieBusTrain
