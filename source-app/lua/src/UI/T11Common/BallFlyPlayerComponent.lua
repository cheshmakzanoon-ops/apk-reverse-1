local base = UIBaseContainer
local BallFlyPlayerComponent = BaseClass("BallFlyPlayerComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local SEGMENT_COUNT = 20
local paths = CS.System.Array.CreateInstance(typeof(CS.UnityEngine.Vector3), SEGMENT_COUNT)

function BallFlyPlayerComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function BallFlyPlayerComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function BallFlyPlayerComponent:OnEnable()
  base.OnEnable(self)
end

function BallFlyPlayerComponent:OnDisable()
  base.OnDisable(self)
  if self.allTweenDic then
    for _, v in pairs(self.allTweenDic) do
      v:Kill()
    end
  end
  self.allTweenDic = {}
  if self.ballEffDelayRecycleDic then
    for _, v in pairs(self.ballEffDelayRecycleDic) do
      v:Stop()
    end
  end
  self.ballEffDelayRecycleDic = {}
  if self.compEffUiDecoShengjiTrail then
    self.compEffUiDecoShengjiTrail.gameObject:GameObjectRecycleAll()
  end
end

function BallFlyPlayerComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compEffUiDecoShengjiTrail = self.viewSkin:AddComponent(self, UIBaseComponent, 1)
end

function BallFlyPlayerComponent:ComponentDestroy()
  self.viewSkin = nil
  self.compEffUiDecoShengjiTrail = nil
end

function BallFlyPlayerComponent:DataDefine()
  self.allTweenDic = {}
  self.ballEffDelayRecycleDic = {}
  self.compEffUiDecoShengjiTrail.gameObject:GameObjectCreatePool()
end

function BallFlyPlayerComponent:DataDestroy()
  self.compEffUiDecoShengjiTrail.gameObject:GameObjectRecycleAll()
  for _, v in pairs(self.allTweenDic) do
    v:Kill()
  end
  self.allTweenDic = nil
  for _, v in pairs(self.ballEffDelayRecycleDic) do
    v:Stop()
  end
  self.ballEffDelayRecycleDic = nil
end

function BallFlyPlayerComponent:OnAddListener()
  base.OnAddListener(self)
end

function BallFlyPlayerComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function BallFlyPlayerComponent:PlayOneBallFly(startPos, endPos, duration, callback)
  local ballEff = self.compEffUiDecoShengjiTrail.gameObject:GameObjectSpawn(self.transform)
  local randomSign = math.random(0, 1) == 0 and -1 or 1
  local controlPos = (startPos + endPos) * 0.5 + Vector3.New(1, 0, 0) * math.random(100, 350) * randomSign
  ballEff.transform.position = startPos
  local pathVec = self:Bezier2Path(startPos, controlPos, endPos)
  local randomTime = duration or 1
  local pathTween = ballEff.transform:DOPath(pathVec, randomTime):SetEase(CS.DG.Tweening.Ease.InQuad)
  pathTween:OnComplete(function()
    local cycleDelayTimer
    cycleDelayTimer = TimerManager:GetInstance():DelayInvoke(function()
      ballEff:GameObjectRecycle()
      self.ballEffDelayRecycleDic[cycleDelayTimer] = nil
    end, 0.3)
    self.ballEffDelayRecycleDic[cycleDelayTimer] = cycleDelayTimer
    if callback then
      callback()
    end
    self.allTweenDic[pathTween] = nil
    pathTween = nil
  end)
  self.allTweenDic[pathTween] = pathTween
end

function BallFlyPlayerComponent:Bezier2Path(startPos, controlPos, endPos)
  for i = 1, SEGMENT_COUNT do
    local t = i / SEGMENT_COUNT
    local pixel = self:CalculateCubicBezierPointFor2C(t, startPos, controlPos, endPos)
    paths[i - 1] = pixel
  end
  return paths
end

function BallFlyPlayerComponent:CalculateCubicBezierPointFor2C(t, p0, p1, p2)
  local u = 1 - t
  local tt = t * t
  local uu = u * u
  local p = uu * p0
  p = p + 2 * u * t * p1
  p = p + tt * p2
  return p
end

return BallFlyPlayerComponent
