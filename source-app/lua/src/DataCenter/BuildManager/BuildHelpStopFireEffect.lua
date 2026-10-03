local BuildHelpStopFireEffect = BaseClass("BuildHelpStopFireEffect")
local Localization = CS.GameEntry.Localization
local ResourceManager = CS.GameEntry.Resource
local PlayableDirector = CS.UnityEngine.Playables.PlayableDirector
local ModelName = "Assets/_Art_LastWar/Models/Characters/Worker/miehuo_ben/prefab/miehuo_test_B.prefab"
local HideTime = 3
local TimerDelay = 0.5
local human_1_path = "ROOT/A_Miehuo_ben_01"
local human_2_path = "ROOT/A_Miehuo_ben_02"

local function OnCreate(self)
  self.deltaTime = 0
  self.bindOnTimelineEnd = Bind(self, self.OnTimelineEnd)
end

local function OnDestroy(self)
  if self.director then
    self.director:stopped("-", self.bindOnTimelineEnd)
    self.director = nil
  end
  if self.request then
    self.request:Destroy()
  end
  self.request = nil
  self.gameObject = nil
  self.deltaTime = 0
  self.timer_action = nil
  self.param = nil
  self.player1 = nil
  self.player2 = nil
end

local function AddTimer(self)
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(TimerDelay, self.timer_action, self, false, false, false)
  end
  self.timer:Start()
end

local function DeleteTimer(self)
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

local function OnLodChange(self, lod)
  if not IsNull(self.gameObject) then
    self.gameObject:SetActive(lod < 3 and self.deltaTime < HideTime)
  end
end

local function Update(self)
  if not IsNull(self.gameObject) then
    self.deltaTime = self.deltaTime + TimerDelay
    if self.deltaTime >= HideTime then
      self.gameObject:SetActive(false)
      if self.param then
        DataCenter.BuildHelpStopFireManager:RemoveOneEffect(self.param.buid)
      end
    end
  end
end

local function ReInit(self, param)
  self.param = param
  self.deltaTime = 0
  if self.gameObject then
    self.gameObject:SetActive(true)
    self:PlayTimeline()
  else
    local request = ResourceManager:InstantiateAsync(ModelName)
    self.request = request
    request:completed("+", function()
      if request.isError then
        return
      end
      request.gameObject:SetActive(true)
      request.gameObject.transform:SetParent(CS.SceneManager.World.DynamicObjNode)
      request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      local v3 = SceneUtils.TileIndexToWorld(self.param.posIndex)
      request.gameObject.transform.position = v3
      self.gameObject = request.gameObject
      self.gameObject:SetActive(true)
      self:PlayTimeline()
    end)
  end
end

local function ReInitRebuild(self, param)
  self.param = param
  self.deltaTime = 0
  if self.gameObject then
    self.gameObject:SetActive(true)
    self:PlayTimeline()
  else
    local request = ResourceManager:InstantiateAsync(ModelName)
    self.request = request
    request:completed("+", function()
      if request.isError then
        return
      end
      request.gameObject:SetActive(true)
      request.gameObject.transform:SetParent(CS.SceneManager.World.DynamicObjNode)
      request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      self.player1 = request.gameObject.transform:Find(human_1_path).gameObject
      self.player2 = request.gameObject.transform:Find(human_2_path).gameObject
      self.player1.gameObject.transform:Set_localScale(1.5, 1.5, 1.5)
      self.player2.gameObject.transform:Set_localScale(1.5, 1.5, 1.5)
      local v3 = self.param.posIndex
      request.gameObject.transform.position = v3
      self.gameObject = request.gameObject
      self.gameObject:SetActive(true)
      self:PlayTimeline()
    end)
  end
end

local function PlayTimeline(self)
  local director = self.gameObject:GetComponent(typeof(PlayableDirector))
  if not IsNull(director) then
    director.time = 0
    director:Play()
    director:stopped("+", self.bindOnTimelineEnd)
    self.director = director
  end
end

local function OnTimelineEnd(self)
  if self.param then
    self.gameObject:SetActive(false)
    DataCenter.BuildHelpStopFireManager:RemoveOneEffect(self.param.buid)
  end
end

BuildHelpStopFireEffect.OnCreate = OnCreate
BuildHelpStopFireEffect.OnDestroy = OnDestroy
BuildHelpStopFireEffect.DeleteTimer = DeleteTimer
BuildHelpStopFireEffect.AddTimer = AddTimer
BuildHelpStopFireEffect.OnLodChange = OnLodChange
BuildHelpStopFireEffect.Update = Update
BuildHelpStopFireEffect.ReInit = ReInit
BuildHelpStopFireEffect.PlayTimeline = PlayTimeline
BuildHelpStopFireEffect.OnTimelineEnd = OnTimelineEnd
BuildHelpStopFireEffect.ReInitRebuild = ReInitRebuild
return BuildHelpStopFireEffect
