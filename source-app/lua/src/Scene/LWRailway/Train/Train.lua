local Train = BaseClass("Train")
local Coach = require("Scene.LWRailway.Train.Carriage.Coach")
local Locomotive = require("Scene.LWRailway.Train.Carriage.Locomotive")
local TrainBubble = require("Scene/LWRailway/Train/TrainBubble")
local GameObject = CS.UnityEngine.GameObject
local Resource = CS.GameEntry.Resource
local FAR_DAY = 4098245047000
local ANIM_SPEED_MUL = 0.36
local FAR_AWAY = Vector3.New(10000, 10000, 10000)
local RAIL_LOD = 2
local EFFECT_LENGTH = 50

function Train:__init(trainData, marchInfo, parent, isFake)
  self.trainData = trainData
  self.marchInfo = marchInfo
  self.uuid = self.trainData.uuid
  self.parent = parent
  self.isFake = isFake
  self.forward = Vector3.New(0, 0, 1)
  self.railRefreshTs = FAR_DAY
  self:Init()
end

function Train:__delete()
  self:Destroy()
end

function Train:Destroy()
  self:DestroyBubble()
  if self.carriages then
    for _, carriage in pairs(self.carriages) do
      carriage:Destroy()
    end
    self.carriages = nil
    self.locomotive = nil
  end
  if self.gameObject then
    GameObject.Destroy(self.gameObject)
    self.gameObject = nil
    self.transform = nil
  end
  if self.fsm then
    self.fsm:Delete()
    self.fsm = nil
  end
  self.parent = nil
  self.forward = nil
  if self.railwayReq then
    self.railwayReq:Destroy()
  end
  self.railwayReq = nil
  self.railwayEff = nil
  self.railwayEffPlay = nil
end

function Train:Init()
  local data = self.trainData
  self.gameObject = GameObject("Train" .. data.uuid)
  self.transform = self.gameObject.transform
  self.transform:SetParent(self.parent)
  self.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
  self.transform:Set_localEulerAngles(ResetPosition.x, ResetPosition.y, ResetPosition.z)
  self.transform:Set_localPosition(0, 0, 0)
  self.carriages = {}
  self.locomotive = Locomotive.New(self, 1, self.transform)
  self.carriages[1] = self.locomotive
  for i = 2, data.carriageCount do
    self.carriages[i] = Coach.New(self, i, self.transform)
  end
  self.timeOffset = DataCenter.LWMyStationDataManager:GET_CARRIAGE_LENGTH() * data.slowness
  if self.trainData.type == TrainType.Train then
    self:InitRailwayEffect()
  end
end

function Train:InitRailwayEffect()
  self.railwayReq = Resource:InstantiateAsync("Assets/Main/Prefabs/World/RailwayEffect.prefab")
  self.railwayReq:completed("+", function(request)
    local go = request.gameObject
    if IsNull(go) then
      return
    end
    local transform = go.transform
    transform:SetParent(DataCenter.LWTrainManager.effectNode)
    transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    self.railwayEff = transform
    self.railwayEffPlay = transform:GetComponent(typeof(CS.UnityEngine.Playables.PlayableDirector))
    self.railwayEffPlay:RebuildGraph()
    local trainSpeed = 0.5
    if self.trainData.meta then
      trainSpeed = self.trainData.meta.speed
    end
    local anim_speed = ANIM_SPEED_MUL * trainSpeed
    self.railwayEffPlay.playableGraph:GetRootPlayable(0):SetSpeed(anim_speed)
    self.animSlowness = 1 / anim_speed
    if self.isFake then
      self:RefreshRail()
    else
      local lod = CS.SceneManager.World:GetLodLevel()
      self:OnChangeCameraLod(lod)
    end
  end)
end

function Train:Refresh(uuid, marchInfo)
  self.marchInfo = marchInfo
  local trainData = DataCenter.LWTrainDataManager:GetOneTrain(uuid)
  self.trainData = trainData
  self.uuid = self.trainData.uuid
  if self.carriages then
    for _, carriage in pairs(self.carriages) do
      carriage:RefreshView()
    end
  end
end

function Train:GetPosition()
  if self.transform then
    return self.transform.position
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  return self.trainData:CalculateTransform(now)
end

function Train:OnUpdate()
  local now = UITimeManager:GetInstance():GetServerTime()
  local ts = now
  for i = 1, self.trainData.carriageCount do
    self.carriages[i]:OnUpdate(ts)
    ts = ts - self.timeOffset
  end
  if now > self.railRefreshTs then
    self:RefreshRail()
  else
  end
end

function Train:Translate(dir)
  self.transform:Translate(dir)
end

function Train:SetLocalPosition(x, y, z)
  self.transform:Set_localPosition(x, y, z)
end

function Train:SetPositionIndex(index)
  self.positionIndex = index
end

function Train:GetPositionIndex()
  return self.positionIndex
end

function Train:ShowSelectRing(bool)
  if self.locomotive then
    self.locomotive:ShowSelectRing(bool)
  end
end

function Train:OnChangeCameraLod(lod)
  if not self.railwayEff then
    return
  end
  if self.lod == nil then
    if lod <= RAIL_LOD then
      self:RefreshRail()
    else
      self:HideRail()
    end
  elseif self.lod > RAIL_LOD and lod <= RAIL_LOD then
    self:RefreshRail()
  elseif self.lod <= RAIL_LOD and lod > RAIL_LOD then
    self:HideRail()
  end
  self.lod = lod
end

function Train:RefreshRail()
  if not self.railwayEff then
    return
  end
  local transform = self.railwayEff
  local now = UITimeManager:GetInstance():GetServerTime()
  if self.isFake then
    transform:Set_localPosition(0, 0, -24)
    transform:Set_localRotation(Quaternion.identity:Split())
    self.railwayEffPlay.time = 5.5
    self.railwayEffPlay:Play()
    self.railRefreshTs = 4100 * self.animSlowness + now
    return
  end
  local pos, dir, rot, state, percent, frame1 = self.trainData:CalculateTransform(now)
  if not frame1 then
  elseif state == CarriageState.Hide or state == CarriageState.PullIn then
    local lerpValue = (now - frame1.ts) / self.trainData.timeLength
    self.railWorldPos = frame1.pos - dir * EFFECT_LENGTH
    transform:Set_position(self.railWorldPos:Split())
    transform:Set_rotation(Quaternion.LookRotation(dir):Split())
    self.railwayEffPlay.time = 10.17 + 4.43 * lerpValue
    self.railwayEffPlay:Play()
    self.railRefreshTs = FAR_DAY
  elseif state == CarriageState.PullOut then
    local lerpValue = (now - frame1.ts) / self.trainData.timeLength
    self.railWorldPos = frame1.pos + dir * 3
    transform:Set_position(self.railWorldPos:Split())
    transform:Set_rotation(Quaternion.LookRotation(dir):Split())
    self.railwayEffPlay.time = 0.5 + 4.43 * lerpValue
    self.railwayEffPlay:Play()
    self.railRefreshTs = (9100 - now + frame1.ts) * self.animSlowness + now
  elseif state == CarriageState.Straight then
    if now - frame1.ts < self.trainData.timeLength then
      local lerpValue = (now - frame1.ts) / self.trainData.timeLength
      self.railWorldPos = frame1.pos + dir * 3
      transform:Set_position(self.railWorldPos:Split())
      transform:Set_rotation(Quaternion.LookRotation(dir):Split())
      self.railwayEffPlay.time = 0.5 + 4.43 * lerpValue
      self.railwayEffPlay:Play()
      self.railRefreshTs = (9100 - now + frame1.ts) * self.animSlowness + now
    else
      self.railWorldPos = pos - dir * 24
      transform:Set_position(self.railWorldPos:Split())
      transform:Set_rotation(Quaternion.LookRotation(dir):Split())
      self.railwayEffPlay.time = 5.5
      self.railwayEffPlay:Play()
      self.railRefreshTs = 4100 * self.animSlowness + now
    end
  else
    self:HideRail()
  end
end

function Train:HideRail()
  self.railRefreshTs = FAR_DAY
  self.railWorldPos = FAR_AWAY
  self.railwayEff:Set_position(self.railWorldPos:Split())
end

function Train:ShowBubble(param)
  if IsNull(self.transform) then
    return
  end
  self.bubbleParam = param
  if self.bubble then
    self.bubble:Refresh(param)
  elseif not self.bubbleReq then
    self.bubbleReq = CS.GameEntry.Resource:InstantiateAsync(UIAssets.TrainBubble)
    self.bubbleReq:completed("+", function()
      local go = self.bubbleReq.gameObject
      if IsNull(go) then
        return
      end
      go:SetActive(true)
      local transform = go.transform
      transform:SetParent(self.transform)
      transform:Set_localScale(1, 1, 1)
      transform:Set_localPosition(0, 2, 0)
      transform:Set_eulerAngles(45, 0, 0)
      transform.name = "TrainBubble" .. self.uuid
      self.bubble = TrainBubble.New()
      self.bubble:Init(transform)
      self.bubble:Refresh(self.bubbleParam)
    end)
  end
end

function Train:DestroyBubble()
  if self.bubble then
    self.bubble:Destroy()
  end
  self.bubble = nil
  if self.bubbleReq then
    self.bubbleReq:Destroy()
  end
  self.bubbleReq = nil
  self.bubbleParam = nil
end

function Train:OnPullInUpdate()
  if not self.isFake then
    self:Translate(self.forward * Time.deltaTime * self.trainData.speed * 1000)
  end
end

function Train:OnPullInStart()
  if not self.isFake then
    self:RefreshRail()
  end
end

function Train:OnPullOutStart()
  if not self.isFake then
    self:SetLocalPosition(0, 0, 0)
    self:RefreshRail()
  end
end

function Train:OnStraightStart()
  if not self.isFake then
    self:SetLocalPosition(0, 0, 0)
  end
end

function Train:PlayAnim(animName)
  for _, v in pairs(self.carriages) do
    v:PlayAnim(animName)
  end
end

return Train
