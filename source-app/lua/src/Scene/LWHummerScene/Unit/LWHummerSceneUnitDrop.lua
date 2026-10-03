local base = require("Scene.LWHummerScene.Unit.LWHummerSceneUnitBase")
local LWHummerSceneUnitDrop = BaseClass("LWHummerSceneUnitDrop", base)
local Constant = require("Scene.LWHummerScene.LWHummerSceneConstant")
local CSTweening = CS.DG.Tweening

function LWHummerSceneUnitDrop:OnDestroy()
  base.OnDestroy(self)
  if self.tween then
    self.tween:Kill()
    self.tween = nil
  end
  self.flyTime = nil
end

function LWHummerSceneUnitDrop:__init(param)
end

function LWHummerSceneUnitDrop:OnInited()
  base.OnInited(self)
  local x, y, z = self.transform:Get_localPosition()
  local control = Vector3.New(x / 2, y + 7, z / 2)
  local path = {
    Constant.DROP_FLY_TARGRT,
    control,
    control
  }
  self.flyTime = Constant.DROP_FLY_TIME
  self.tween = self.transform:DOLocalPath(path, self.flyTime, CSTweening.PathType.CubicBezier, CSTweening.PathMode.Ignore, 10, Color.cyan)
  TimerManager:GetInstance():DelayInvoke(function()
    if self.tween then
      self.tween:Kill()
      self.tween = nil
    end
  end, self.flyTime)
end

function LWHummerSceneUnitDrop:OnUpdate(dt)
  base.OnUpdate(self, dt)
  if self.flyTime then
    self.flyTime = self.flyTime - dt
    if self.flyTime <= 0 then
      self.logic:RemoveUnit(self)
    end
  end
end

return LWHummerSceneUnitDrop
