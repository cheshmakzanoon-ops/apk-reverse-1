local base = UIAsyncNode
local WorkerManAnim = BaseClass("WorkerManAnim", base)
local SimpleAnimation = typeof(CS.SimpleAnimation)

local function CalculateCubicBezierPointFor2C(t, p0, p1, p2)
  local u = 1 - t
  local tt = t * t
  local uu = u * u
  local p = uu * p0
  p = p + 2 * u * t * p1
  p = p + tt * p2
  return p
end

local SEGMENT_COUNT = 20
local paths = CS.System.Array.CreateInstance(typeof(CS.UnityEngine.Vector3), SEGMENT_COUNT)

local function Bezier2Path(startPos, controlPos, endPos)
  for i = 1, SEGMENT_COUNT do
    local t = i / SEGMENT_COUNT
    local pixel = CalculateCubicBezierPointFor2C(t, startPos, controlPos, endPos)
    paths[i - 1] = pixel
  end
  return paths
end

function WorkerManAnim:OnCreate()
  base.OnCreate(self)
  local transform = self.transform
  if IsNull(transform) then
    return
  end
  transform:Set_localScale(1, 1, 1)
  transform:DORotate(Vector3.New(0, 0, 0), 0.01)
  self.animRoot = transform:Find("worker"):GetComponent(SimpleAnimation)
end

function WorkerManAnim:OnDestroy()
  self:PlayOver()
  self.animRoot = nil
  base.OnDestroy(self)
end

function WorkerManAnim:ReInit(buildUuid, buildingData)
  self.buildUuid = buildUuid
  self.buildData = buildingData
  self.isBorn = false
end

function WorkerManAnim:PlayOver()
  if self.effectNode then
    self.effectNode:Delete()
    self.effectNode = nil
  end
  if self.animRoot then
    self.animRoot:Stop()
  end
  if self.walkTween then
    self.walkTween:Kill()
    self.walkTween = nil
  end
  self:SetActive(false)
end

function WorkerManAnim:UpdateData()
  local transform = self.transform
  if self.isBorn ~= true and transform ~= nil and self.buildUuid and self.buildData and self:AsyncLoadDone() then
    local v3Pos = self.buildData:GetCenterVec()
    local startX = v3Pos.x
    self:SetActive(true)
    self.isBorn = true
    if v3Pos.x < 93 then
      startX = 93
      transform:Set_position(93, 0, 0)
    elseif v3Pos.x > 103 then
      startX = 103
      transform:Set_position(103, 0, 0)
    else
      transform:Set_position(v3Pos.x, 0, 0)
    end
    transform:Set_localRotation(0, 0, 0)
    self.animRoot:Play("run")
    self.walkTween = DOTween.Sequence()
    local startPos, targetPos
    if v3Pos.x < 98 then
      startPos = Vector3.New(93, 0, v3Pos.z / 2)
      targetPos = Vector3.New(90, 0, v3Pos.z)
    else
      startPos = Vector3.New(103, 0, v3Pos.z / 2)
      targetPos = Vector3.New(106, 0, v3Pos.z)
    end
    local curveTime = v3Pos.z / 8
    local controlPos = Vector3.New(98, 0, v3Pos.z * 0.8)
    local pathVec = Bezier2Path(startPos, controlPos, targetPos)
    self.walkTween:Append(transform:DOPath(pathVec, curveTime))
    if v3Pos.x < 98 then
      self.walkTween:Join(transform:DORotate(Vector3.New(0, -90, 0), curveTime):SetEase(CS.DG.Tweening.Ease.InSine))
    else
      self.walkTween:Join(transform:DORotate(Vector3.New(0, 90, 0), curveTime):SetEase(CS.DG.Tweening.Ease.InSine))
    end
    self.walkTween:AppendCallback(function()
      if IsNotNull(transform) and IsNotNull(self.animRoot) then
        self.animRoot:Play("building")
      end
    end)
    self.walkTween:AppendInterval(0.1)
    self.walkTween:AppendCallback(function()
      local theWorld = CS.SceneManager.World
      if theWorld then
        local effectPath = "Assets/Main/SeasonRes/S4/Prefabs/Effect/VFX_get_worker.prefab"
        self.effectNode = UIAsyncNode.New("PowerWorkerEffect", theWorld.DynamicObjNode.transform, effectPath, function(go)
          if IsNotNull(go) then
            go.transform:Set_localPosition(v3Pos.x, v3Pos.y, v3Pos.z)
          end
        end)
      end
    end)
    self.walkTween:AppendInterval(1)
    self.walkTween:AppendCallback(function()
      if self.buildData then
        DataCenter.SeasonPowerWorkerManager:SwitchBuildAnim(self.buildData.itemId, self.buildUuid, self.buildData)
      end
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIPowerWorkerCreatedTips)
    end)
    self.walkTween:AppendInterval(3)
    self.walkTween:AppendCallback(function()
      self:PlayOver()
    end)
  end
end

return WorkerManAnim
