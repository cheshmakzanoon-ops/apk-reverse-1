local FSMachine = require("Common.FSMachine")
local State = {}
State.__index = State
setmetatable(State, FSMachine.State)
local Resource = CS.GameEntry.Resource
local Camera = CS.UnityEngine.Camera
local MobileTouchCamera = CS.BitBenderGames.MobileTouchCamera
local Constant = require("Scene.LWHummerScene.LWHummerSceneConstant")

function State.Create()
  local copy = {}
  setmetatable(copy, State)
  copy:Init()
  return copy
end

function State:Init()
  self.syncCamera = false
  self.canInput = false
end

function State:OnEnter(loadDoneCallback)
  if not self.owner or not self.owner.data then
    return
  end
  self.data = self.owner.data
  self.loadDoneCallback = loadDoneCallback
  self.needLoadProgress = 0
  self:InitCamera()
  self:InitScene()
end

function State:OnExit()
end

function State:InitCamera()
  self:AddLoadProgress()
  self.cameraReq = Resource:InstantiateAsync(self.data:GetCameraPath())
  self.cameraReq:completed("+", function(request)
    if not self.owner or not self.owner.inLogic then
      request:Destroy()
      return
    end
    local height = 20
    local fov = 60
    local rotation = 42
    local camera = request.gameObject:GetComponent(typeof(Camera))
    camera.fieldOfView = fov
    camera.transform:Set_eulerAngles(rotation, 0, 0)
    self.owner.camera = camera
    local touchCamera = camera:GetComponent(typeof(MobileTouchCamera))
    touchCamera.CanMoveing = false
    touchCamera.CamZoom = height
    touchCamera.LodLevel = 1
    self.owner.touchCamera = touchCamera
    local offsetZ = height / math.tan(rotation * math.pi / 180)
    touchCamera:SetZoomParams(1, height, offsetZ, 25)
    touchCamera.CamZoomMin = 20
    local camPos = self.owner.data:GetPlayerBirthPos() + self.owner.data.stage.cameraOffset
    self.owner:LookAt(camPos)
    self:InitInput()
    self:InitPlayer()
    self:InitDominator()
    self:DelLoadProgress()
  end)
end

function State:InitInput()
  local touchInput = self.owner.touchCamera.touchInput
  
  function self.onFingerDown(pos)
    self.owner:OnFingerDown(pos)
  end
  
  function self.onFingerUp()
    self.owner:OnFingerUp()
  end
  
  touchInput:OnFingerDown("+", self.onFingerDown)
  touchInput:OnFingerUp("+", self.onFingerUp)
end

function State:InitScene()
  self:AddLoadProgress()
  self.owner.staticMgr = CS.PVEStaticManager()
  self.owner.staticMgr:InitLW(10, 10)
  self.owner.staticMgr:SetVisibleChunk(Constant.PRELOAD_GROUND_RANGE)
  self.owner:LoadSceneByCount(Constant.INIT_LOAD_SCENE_COUNT, function()
    self:DelLoadProgress()
  end)
  self.owner.rvoMgr = CS.LWBattleRVOManager()
  local timeStep = 0.033
  local neighborDist = 2
  local maxNeighbors = 8
  local timeHorizon = 1
  local timeHorizonObst = 1
  local radius = 1
  local maxSpeed = 20
  self.owner.rvoMgr:InitLW(timeStep, neighborDist, maxNeighbors, timeHorizon, timeHorizonObst, radius, maxSpeed)
end

function State:InitPlayer()
  self:AddLoadProgress()
  self.owner:AddPlayer(function()
    self:DelLoadProgress()
  end)
end

function State:InitDominator()
  if self.data:GetCurDominatorId() then
    self:AddLoadProgress()
    self.owner:AddDominator(function()
      self:DelLoadProgress()
    end)
  end
end

function State:Dispose()
  if self.owner then
    if self.owner.touchCamera and self.owner.touchCamera.touchInput then
      local touchInput = self.owner.touchCamera.touchInput
      if self.onFingerDown then
        touchInput:OnFingerDown("-", self.onFingerDown)
      end
      if self.onFingerUp then
        touchInput:OnFingerUp("-", self.onFingerUp)
      end
    end
    if self.owner.staticMgr then
      self.owner.staticMgr:UnInit()
      self.owner.staticMgr = nil
    end
    if self.owner.rvoMgr then
      self.owner.rvoMgr:Destory()
      self.owner.rvoMgr = nil
    end
  end
  if self.cameraReq then
    self.cameraReq:Destroy()
  end
end

function State:AddLoadProgress()
  self.needLoadProgress = self.needLoadProgress + 1
end

function State:DelLoadProgress()
  self.needLoadProgress = self.needLoadProgress - 1
  if self.needLoadProgress <= 0 and self.loadDoneCallback and self.owner then
    self.loadDoneCallback()
  end
end

return State
