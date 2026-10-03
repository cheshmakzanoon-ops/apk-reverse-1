local WorldDesertEffectFire = BaseClass("WorldDesertEffectFire")

local function OnCreate(self, go)
  if go ~= nil then
    self.request = go
    self.gameObject = go.gameObject
    self.transform = go.gameObject.transform
    
    function self.timer_action()
      self:UpdateTime()
    end
    
    self.isDoAnim = false
    self:AddTimer()
  end
end

local function OnDestroy(self)
  self.isDoAnim = false
  self:RemoveTimer()
end

local function ReInit(self, uuid, pointId, endTime)
  if IsNull(self.gameObject) then
    return
  end
  self.uuid = uuid
  self.pointId = pointId
  self.endTime = endTime
  local posV3 = SceneUtils.TileIndexToWorld(self.pointId, ForceChangeScene.World)
  self.transform.position = posV3
  self.isDoAnim = true
  self:UpdateTime()
end

local function RemoveTimer(self)
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

local function AddTimer(self)
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false, false, false)
  end
  self.timer:Start()
end

local function UpdateTime(self)
  if self.isDoAnim and self.endTime <= UITimeManager:GetInstance():GetServerTime() then
    self.isDoAnim = false
    self.gameObject:SetActive(true)
    WorldDesertEffectManager:GetInstance():RemoveOneEffect(self.uuid)
  end
end

WorldDesertEffectFire.OnCreate = OnCreate
WorldDesertEffectFire.OnDestroy = OnDestroy
WorldDesertEffectFire.ReInit = ReInit
WorldDesertEffectFire.RemoveTimer = RemoveTimer
WorldDesertEffectFire.UpdateTime = UpdateTime
WorldDesertEffectFire.AddTimer = AddTimer
return WorldDesertEffectFire
