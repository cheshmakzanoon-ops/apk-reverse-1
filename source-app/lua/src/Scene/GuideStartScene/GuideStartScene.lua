local GuideStartScene = BaseClass("GuideStartScene")
local OriginalPositionDelta = Vector3.New(0, 0, 0)
local BuildPerRoadTime = 0.5
local BuildTime = 2.0
local BuildMainTime = 3
local TimeLineStartTime = 0
local all_timeline_path = "Global_Talk/Talk_timeline_01"
local fog_control_path = "Global_Talk"
local light_path = "Scene_City(Clone)/Light_City"
local city_volumePath = "Scene_City(Clone)/PostProcessVolume"
local BuildObjectType = {Build = 1, Road = 2}

local function OnCreate(self, go)
  if go ~= nil then
    self.gameObject = go.gameObject
    self.transform = go.gameObject.transform
  end
  self:ComponentDefine()
  self:DataDefine()
  self:VolumeSetting(false)
  self:LightSetting()
end

local function VolumeSetting(self, toggle)
  local volume = self.transform.parent.parent:Find(city_volumePath)
  if volume ~= nil then
    volume.gameObject:SetActive(toggle)
  end
end

local function LightSetting(self)
  local light = self.transform.parent.parent:Find(light_path)
  if light ~= nil then
    light.localRotation = Quaternion.Euler(35, -27.317, 0)
    local lightComp = light:GetComponent(typeof(CS.UnityEngine.Light))
    lightComp.color = Color.New(1, 0.9529411764705882, 0.9098039215686274, 1)
  end
end

local function ResetLightSetting(self)
  local light = self.transform.parent.parent:Find(light_path)
  if light ~= nil then
    light.localRotation = Quaternion.Euler(35, 50, 0)
    local lightComp = light:GetComponent(typeof(CS.UnityEngine.Light))
    lightComp.color = Color.New(1, 1, 1, 1)
  end
end

local function OnDestroy(self)
  self:VolumeSetting(true)
  self:ResetLightSetting()
  self:ComponentDestroy()
  self:DataDestroy()
end

local function ComponentDefine(self)
  self.all_timeline = self.transform:Find(all_timeline_path):GetComponent(typeof(CS.GuideTimelineMarker))
  self.director = self.transform:Find(all_timeline_path):GetComponent(typeof(CS.UnityEngine.Playables.PlayableDirector))
  self.fog_control = self.transform:Find(fog_control_path):GetComponent(typeof(CS.FogControll))
  
  function self.all_timeline.IsContinue()
    return self.isTimelineContinue
  end
end

local function ComponentDestroy(self)
  self.fog_control:Close()
  self.all_timeline.IsContinue = nil
  self.all_timeline = nil
  self.director = nil
  self.fog_control = nil
  self.gameObject = nil
  self.transform = nil
end

local function DataDefine(self)
  self.timer = nil
  
  function self.timer_action(temp)
    self:TimeCallBack()
  end
  
  function self.build_timer_action(temp)
    self:BuildTimeCallBack()
  end
  
  self.isTimelineContinue = false
end

local function DataDestroy(self)
  self.isTimelineContinue = nil
  self:DeleteBuildTimer()
  self:DeleteTimer()
end

local function ReInit(self)
  GoToUtil.GotoPos(self:GetOriginalCamera(), CS.SceneManager.World.InitZoom)
  self.transform.position = ResetPosition
  self.director.time = TimeLineStartTime
  self.director:Stop()
end

local function GetOriginalPos()
  return SceneUtils.TileToWorld(DataCenter.BuildManager.main_city_pos)
end

local function GetOriginalCamera()
  local v3 = SceneUtils.TileToWorld(DataCenter.BuildManager.main_city_pos)
  v3.x = v3.x + OriginalPositionDelta.x
  v3.y = v3.y + OriginalPositionDelta.y
  v3.z = v3.z + OriginalPositionDelta.z
  return v3
end

local function MoveCamera(self)
  local originalPos = SceneUtils.TileToWorld(DataCenter.BuildManager.main_city_pos)
  local moveTime = LookAtFocusTime
  GoToUtil.GotoPos(originalPos, CS.SceneManager.World.InitZoom, moveTime)
  self:AddTimer(moveTime + 1)
end

local function DeleteTimer(self)
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

local function AddTimer(self, time)
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(time, self.timer_action, self, true, false, false)
  end
  self.timer:Start()
end

local function TimeCallBack(self)
  self:DeleteTimer()
  self:DoBuildingAnim()
end

local function DoBuildingAnim(self)
  self:GetAllObject()
  self.buildIndex = 0
  self:BuildTimeCallBack()
end

local function GetAllObject(self)
  self.allBuildPoint = {}
  local allBuild = DataCenter.BuildManager.Buildings
  for k, v in pairs(allBuild) do
    local param = {}
    param.pointId = v.pointId
    local pos = SceneUtils.IndexToTilePos(param.pointId)
    param.x = pos.x
    param.y = pos.y
    param.type = BuildObjectType.Build
    param.buildId = v.type
    if param.buildId == BuildingTypes.FUN_BUILD_MAIN then
      param.time = BuildMainTime
    else
      param.time = BuildTime
    end
    table.insert(self.allBuildPoint, param)
  end
  local allRoad = DataCenter.BoardManager:GetAllRoadData()
  for k, v in ipairs(allRoad) do
    local param = {}
    param.pointId = v.pointId
    local pos = SceneUtils.IndexToTilePos(param.pointId)
    param.x = pos.x
    param.y = pos.y
    param.type = BuildObjectType.Road
    param.time = BuildPerRoadTime
    table.insert(self.allBuildPoint, param)
  end
  local mainPos = DataCenter.BuildManager.main_city_pos
  local manPosX = mainPos.x
  local manPosY = mainPos.y
  table.sort(self.allBuildPoint, function(a, b)
    local disA = (a.x - manPosX) * (a.x - manPosX) + (a.y - manPosY) * (a.y - manPosY)
    local disB = (b.x - manPosX) * (b.x - manPosX) + (b.y - manPosY) * (b.y - manPosY)
    if disA < disB then
      return true
    end
    return false
  end)
end

local function DeleteBuildTimer(self)
  if self.buildTimer ~= nil then
    self.buildTimer:Stop()
    self.buildTimer = nil
  end
end

local function AddBuildTimer(self, time)
  if self.buildTimer == nil then
    self.buildTimer = TimerManager:GetInstance():GetTimer(time, self.build_timer_action, self, true, false, false)
  end
  self.buildTimer:Start()
end

local function BuildTimeCallBack(self)
  self:DeleteBuildTimer()
  self.buildIndex = self.buildIndex + 1
  if self.buildIndex > table.count(self.allBuildPoint) then
  else
    local param = self.allBuildPoint[self.buildIndex]
    if param ~= nil then
      local lastParam = self.allBuildPoint[self.buildIndex - 1]
      if param.type == BuildObjectType.Road and lastParam ~= nil and lastParam ~= BuildObjectType.Road then
        local time = 0
        local str = ""
        for i = self.buildIndex, table.count(self.allBuildPoint) do
          local tempParam = self.allBuildPoint[i]
          if tempParam ~= nil and tempParam.type == BuildObjectType.Road then
            time = time + tempParam.time
            if i ~= self.buildIndex then
              str = str .. ";"
            end
            str = str .. tempParam.pointId
            local build = CS.SceneManager.World:GetObjectByPointId(tempParam.pointId)
            if build ~= nil then
              build:SetIsVisible(true)
            end
          end
        end
        CS.SceneManager.World:StartPrintRoadByPathStr(str, true, BuildPerRoadTime)
      end
      self:AddBuildTimer(param.time)
      if lastParam ~= nil and lastParam.type == BuildObjectType.Road then
        local build = CS.SceneManager.World:GetObjectByPointId(lastParam.pointId)
        if build ~= nil then
          build:DoGuideStartAnim(param.time)
        end
      end
      if param.type ~= BuildObjectType.Road then
        local build = CS.SceneManager.World:GetObjectByPointId(param.pointId)
        if build ~= nil then
          build:DoGuideStartAnim(param.time)
        end
      end
    end
  end
end

local function SetTimeLineContinuePlay(self, isContinue)
  self.isTimelineContinue = isContinue
end

local function GotoTime(self, time)
  self.director.time = time
end

local function StartPlay(self)
  self.director.time = TimeLineStartTime
  self.director:Play()
  self.fog_control:Open()
end

GuideStartScene.OnCreate = OnCreate
GuideStartScene.OnDestroy = OnDestroy
GuideStartScene.ComponentDefine = ComponentDefine
GuideStartScene.ComponentDestroy = ComponentDestroy
GuideStartScene.DataDefine = DataDefine
GuideStartScene.DataDestroy = DataDestroy
GuideStartScene.ReInit = ReInit
GuideStartScene.GetOriginalPos = GetOriginalPos
GuideStartScene.DeleteTimer = DeleteTimer
GuideStartScene.AddTimer = AddTimer
GuideStartScene.TimeCallBack = TimeCallBack
GuideStartScene.DoBuildingAnim = DoBuildingAnim
GuideStartScene.GetAllObject = GetAllObject
GuideStartScene.DeleteBuildTimer = DeleteBuildTimer
GuideStartScene.AddBuildTimer = AddBuildTimer
GuideStartScene.BuildTimeCallBack = BuildTimeCallBack
GuideStartScene.MoveCamera = MoveCamera
GuideStartScene.SetTimeLineContinuePlay = SetTimeLineContinuePlay
GuideStartScene.GetOriginalCamera = GetOriginalCamera
GuideStartScene.GotoTime = GotoTime
GuideStartScene.StartPlay = StartPlay
GuideStartScene.ResetLightSetting = ResetLightSetting
GuideStartScene.LightSetting = LightSetting
GuideStartScene.VolumeSetting = VolumeSetting
return GuideStartScene
