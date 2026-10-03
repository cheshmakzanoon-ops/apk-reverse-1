local MeteoriteHitPlaneEffectManager = BaseClass("MeteoriteHitPlaneEffectManager")
local ResourceManager = CS.GameEntry.Resource
local MeteoriteHitPlaneEffect = require("UI.MeteoriteHitEffect.MeteoriteHitPlaneEffect")
local AutoCloseTime = 4
local ShowMaxBaseLevel = 15

local function __init(self)
  self.allEffect = {}
  self.timer = nil
  
  function self.timer_action(temp)
    self:ShowEffectTimeCallBack()
  end
  
  self:AddListener()
end

local function __delete(self)
  self:DeleteTimer()
  self:RemoveListener()
  for k, v in pairs(self.allEffect) do
    self:RemoveOne(k)
  end
  self.allEffect = nil
  self.timer = nil
  self.timer_action = nil
end

local function ClearEffect(self)
  for k, v in pairs(self.allEffect) do
    self:RemoveOne(k)
  end
  self.allEffect = {}
end

local function Startup()
end

local function DeleteTimer(self)
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

local function AddTimer(self)
  self.timer = TimerManager:GetInstance():GetTimer(self:GetDuringTime(), self.timer_action, self, false, false, false)
  self.timer:Start()
end

local function GetDuringTime(self)
  return LuaEntry.DataConfig:TryGetNum("crater", "k1")
end

local function ShowEffectTimeCallBack(self)
  if DataCenter.BuildManager.MainLv < ShowMaxBaseLevel then
    local world = CS.SceneManager.World
    if world == nil then
      return
    end
    local lod = world:GetLodLevel()
    if lod <= 3 then
      local loginServerId = LuaEntry.Player:GetSelfServerId()
      if not UIUtil.IsInView(SceneUtils.TileToWorld(DataCenter.BuildManager.main_city_pos, ForceChangeScene.World, loginServerId)) then
        local point = CS.UIUtils.GetPointByMeteoriteHitPlane()
        if 0 < point then
          self:ShowOneEffect(point)
        end
      end
    end
  end
end

local function IsCanShowEffectByPoint(self, point)
  return self.allEffect[point] == nil
end

local function ShowOneEffect(self, posIndex)
  local request = ResourceManager:InstantiateAsync(UIAssets.MeteoriteHitPlane)
  local temp = {}
  temp.request = request
  self.allEffect[posIndex] = temp
  request:completed("+", function()
    if request.isError then
      return
    end
    request.gameObject:SetActive(true)
    local meteoriteHitPlaneEffect = MeteoriteHitPlaneEffect.New()
    meteoriteHitPlaneEffect:OnCreate(request)
    temp.script = meteoriteHitPlaneEffect
    local param = {}
    param.posIndex = posIndex
    meteoriteHitPlaneEffect:ReInit(param)
    local v = SceneUtils.TileIndexToWorld(posIndex)
    meteoriteHitPlaneEffect.transform:Set_position(v.x, v.y, v.z)
    param.timer = TimerManager:GetInstance():GetTimer(AutoCloseTime, self.TimeCallBack, temp, true, false, false)
    param.timer:Start()
  end)
end

local function TimeCallBack(param)
  if param.script.param.timer ~= nil then
    param.script.param.timer:Stop()
    param.script.param.timer = nil
  end
  DataCenter.MeteoriteHitPlaneEffectManager:RemoveOne(param.script.param.posIndex)
end

local function RemoveOne(self, point)
  local temp = self.allEffect[point]
  if temp ~= nil then
    if temp.script then
      if temp.script.param.timer ~= nil then
        temp.script.param.timer:Stop()
        temp.script.param.timer = nil
      end
      temp.script:OnDestroy()
    end
    self.allEffect[point] = nil
    local request = temp.request
    if request ~= nil then
      request:Destroy()
    end
  end
end

local function AddListener(self)
  EventManager:GetInstance():AddListener(EventId.ChangeCameraLod, self.ChangeCameraLodSignal)
end

local function RemoveListener(self)
  EventManager:GetInstance():RemoveListener(EventId.ChangeCameraLod, self.ChangeCameraLodSignal)
end

local function ChangeCameraLodSignal()
  DataCenter.MeteoriteHitPlaneEffectManager:CheckLod()
end

local function CheckLod(self)
  local world = CS.SceneManager.World
  if world == nil then
    return
  end
  local lod = world:GetLodLevel()
  if 4 <= lod then
    for k, v in pairs(self.allEffect) do
      self:RemoveOne(k)
    end
  end
end

local function GetPointByMeteoriteHitPlane(self)
end

MeteoriteHitPlaneEffectManager.__init = __init
MeteoriteHitPlaneEffectManager.__delete = __delete
MeteoriteHitPlaneEffectManager.Startup = Startup
MeteoriteHitPlaneEffectManager.ClearEffect = ClearEffect
MeteoriteHitPlaneEffectManager.GetDuringTime = GetDuringTime
MeteoriteHitPlaneEffectManager.ShowEffectTimeCallBack = ShowEffectTimeCallBack
MeteoriteHitPlaneEffectManager.IsCanShowEffectByPoint = IsCanShowEffectByPoint
MeteoriteHitPlaneEffectManager.ShowOneEffect = ShowOneEffect
MeteoriteHitPlaneEffectManager.DeleteTimer = DeleteTimer
MeteoriteHitPlaneEffectManager.AddTimer = AddTimer
MeteoriteHitPlaneEffectManager.RemoveOne = RemoveOne
MeteoriteHitPlaneEffectManager.TimeCallBack = TimeCallBack
MeteoriteHitPlaneEffectManager.AddListener = AddListener
MeteoriteHitPlaneEffectManager.RemoveListener = RemoveListener
MeteoriteHitPlaneEffectManager.ChangeCameraLodSignal = ChangeCameraLodSignal
MeteoriteHitPlaneEffectManager.CheckLod = CheckLod
return MeteoriteHitPlaneEffectManager
