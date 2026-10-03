local MeteoriteHitBaseGlassEffectManager = BaseClass("MeteoriteHitBaseGlassEffectManager")
local ResourceManager = CS.GameEntry.Resource
local MeteoriteHitBaseGlassEffect = require("UI.MeteoriteHitEffect.MeteoriteHitBaseGlassEffect")
local AutoCloseTime = 8
local WarningUITime = 4
local ShowEffectMaxCount = 3
local ShowEffectDuring = 0.3
local ShowMaxBaseLevel = 15

local function __init(self)
  self.allEffect = {}
  self.timer = nil
  
  function self.timer_action(temp)
    self:ShowEffectTimeCallBack()
  end
  
  self.posList = {}
  self:AddListener()
end

local function __delete(self)
  self:StopPosTimer()
  self:StopShowUITime()
  self:DeleteTimer()
  self:RemoveListener()
  for k, v in pairs(self.allEffect) do
    self:RemoveOne(k)
  end
  self.allEffect = nil
  self.timer = nil
  self.timer_action = nil
  self.posList = nil
end

local function Startup()
end

local function ClearEffect(self)
  for k, v in pairs(self.allEffect) do
    self:RemoveOne(k)
  end
  self.allEffect = {}
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
  return LuaEntry.DataConfig:TryGetNum("meteorite", "k1")
end

local function ShowEffectTimeCallBack(self)
  if DataCenter.BuildManager.MainLv < ShowMaxBaseLevel then
    local world = CS.SceneManager.World
    if world == nil then
      return
    end
    local lod = world:GetLodLevel()
    if lod < 3 then
      local buildInfo = CS.UIUtils.GetBuildPointByMeteoriteHitGlass()
      if buildInfo ~= nil then
        if buildInfo.ownerUid == LuaEntry.Player.uid then
          EventManager:GetInstance():Broadcast(EventId.UIMainWarningShow, WarningType.Meteorite)
          self.warningTimer = TimerManager:GetInstance():GetTimer(WarningUITime, self.DelayShowEffects, buildInfo, true, false, false)
          self.warningTimer:Start()
        else
          self:ShowEffects(buildInfo)
        end
      end
    end
  end
end

local function DelayShowEffects(buildInfo)
  DataCenter.MeteoriteHitBaseGlassEffectManager:StopShowUITime()
  EventManager:GetInstance():Broadcast(EventId.UIMainWarningHide, WarningType.Meteorite)
  DataCenter.MeteoriteHitBaseGlassEffectManager:ShowEffects(buildInfo)
end

local function ShowEffects(self, buildInfo)
  if buildInfo ~= nil then
    local randomCount = math.random(1, ShowEffectMaxCount)
    local template = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(BuildingTypes.FUN_BUILD_MAIN, buildInfo.level)
    if template ~= nil then
      EventManager:GetInstance():Broadcast(EventId.OnMeteoriteHitGlass, buildInfo.uuid)
      local offset = CS.WorldPointManager.GetCircleRange(buildInfo.tileSize)
      local pos1 = SceneUtils.IndexToTilePos(buildInfo.mainIndex)
      pos1.x = pos1.x - offset
      pos1.y = pos1.y - offset
      local range = template.offer_range + offset - 2
      self:StopPosTimer()
      for i = 1, randomCount do
        local randomX = math.random(-range, range)
        local randomY = math.random(-range, range)
        if randomX * randomX + randomY * randomY <= range * range then
          local can = true
          for k, v in pairs(self.posList) do
            if v.randomX == randomX and v.randomY == randomY then
              can = false
              break
            end
          end
          if can then
            local v2 = {}
            v2.x = pos1.x + randomX
            v2.y = pos1.y + randomY
            local pos = SceneUtils.TileToWorld(v2)
            if self.allEffect[pos] ~= nil then
              can = false
            end
            if can then
              local param = {}
              param.pos = pos
              param.randomX = randomX
              param.randomY = randomY
              table.insert(self.posList, param)
            end
          end
        end
      end
      for k, v in ipairs(self.posList) do
        local time = k - 1
        if 0 < time then
          v.timer = TimerManager:GetInstance():GetTimer(k * ShowEffectDuring, self.DelayShowEffect, v.pos, true, false, false)
          v.timer:Start()
        else
          self:ShowOneEffect(v.pos)
        end
      end
    end
  end
end

local function DelayShowEffect(pos)
  for k, v in pairs(DataCenter.MeteoriteHitBaseGlassEffectManager.posList) do
    if v.pos == pos then
      v.timer:Stop()
      v.timer = nil
      break
    end
  end
  DataCenter.MeteoriteHitBaseGlassEffectManager:ShowOneEffect(pos)
end

local function ShowOneEffect(self, pos)
  local world = CS.SceneManager.World
  if world == nil then
    return
  end
  local request = ResourceManager:InstantiateAsync(UIAssets.MeteoriteHitBaseGlass)
  local temp = {}
  temp.request = request
  self.allEffect[pos] = temp
  request:completed("+", function()
    if request.isError or CS.SceneManager.World == nil then
      return
    end
    request.gameObject:SetActive(true)
    local meteoriteHitBaseGlassEffect = MeteoriteHitBaseGlassEffect.New()
    meteoriteHitBaseGlassEffect:OnCreate(request)
    temp.script = meteoriteHitBaseGlassEffect
    local param = {}
    param.pos = pos
    param.timer = TimerManager:GetInstance():GetTimer(AutoCloseTime, self.TimeCallBack, temp, true, false, false)
    param.timer:Start()
    meteoriteHitBaseGlassEffect:ReInit(param)
    meteoriteHitBaseGlassEffect.transform:Set_position(pos.x, pos.y, pos.z)
  end)
end

local function TimeCallBack(param)
  if param.script.param.timer ~= nil then
    param.script.param.timer:Stop()
    param.script.param.timer = nil
  end
  DataCenter.MeteoriteHitBaseGlassEffectManager:RemoveOne(param.script.param.pos)
end

local function RemoveOne(self, pos)
  local temp = self.allEffect[pos]
  if temp ~= nil then
    if temp.script then
      if temp.script.param.timer ~= nil then
        temp.script.param.timer:Stop()
        temp.script.param.timer = nil
      end
      temp.script:OnDestroy()
    end
    self.allEffect[pos] = nil
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
  DataCenter.MeteoriteHitBaseGlassEffectManager:CheckLod()
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

local function StopShowUITime(self)
  if self.warningTimer ~= nil then
    self.warningTimer:Stop()
    self.warningTimer = nil
  end
end

local function StopPosTimer(self)
  for k, v in pairs(self.posList) do
    if v.timer ~= nil then
      v.timer:Stop()
      v.timer = nil
    end
  end
  self.posList = {}
end

MeteoriteHitBaseGlassEffectManager.__init = __init
MeteoriteHitBaseGlassEffectManager.__delete = __delete
MeteoriteHitBaseGlassEffectManager.Startup = Startup
MeteoriteHitBaseGlassEffectManager.ClearEffect = ClearEffect
MeteoriteHitBaseGlassEffectManager.GetDuringTime = GetDuringTime
MeteoriteHitBaseGlassEffectManager.ShowEffectTimeCallBack = ShowEffectTimeCallBack
MeteoriteHitBaseGlassEffectManager.ShowOneEffect = ShowOneEffect
MeteoriteHitBaseGlassEffectManager.DeleteTimer = DeleteTimer
MeteoriteHitBaseGlassEffectManager.AddTimer = AddTimer
MeteoriteHitBaseGlassEffectManager.RemoveOne = RemoveOne
MeteoriteHitBaseGlassEffectManager.TimeCallBack = TimeCallBack
MeteoriteHitBaseGlassEffectManager.AddListener = AddListener
MeteoriteHitBaseGlassEffectManager.RemoveListener = RemoveListener
MeteoriteHitBaseGlassEffectManager.ChangeCameraLodSignal = ChangeCameraLodSignal
MeteoriteHitBaseGlassEffectManager.CheckLod = CheckLod
MeteoriteHitBaseGlassEffectManager.ShowEffects = ShowEffects
MeteoriteHitBaseGlassEffectManager.StopShowUITime = StopShowUITime
MeteoriteHitBaseGlassEffectManager.StopPosTimer = StopPosTimer
MeteoriteHitBaseGlassEffectManager.DelayShowEffects = DelayShowEffects
MeteoriteHitBaseGlassEffectManager.DelayShowEffect = DelayShowEffect
return MeteoriteHitBaseGlassEffectManager
