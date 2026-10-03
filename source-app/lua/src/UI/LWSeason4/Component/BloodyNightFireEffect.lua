local base = UIAsyncNode
local BloodyNightFireEffect = BaseClass("BloodyNightFireEffect", base)
local maxDistance = 40

function BloodyNightFireEffect:OnCreate()
  base.OnCreate(self)
  local transform = self.transform
  if IsNull(transform) then
    return
  end
  transform:Set_localScale(1, 1, 1)
  transform:Set_localPosition(0, 0, 0)
  self.isBloodyNight = false
  self.lastWorldPos = nil
end

function BloodyNightFireEffect:OnDestroy()
  base.OnDestroy(self)
end

function BloodyNightFireEffect:OnAddListener()
  base.OnAddListener(self)
  EventManager:GetInstance():AddListenerWithSelf(EventId.BloodyNightActivityRefresh, self.OnBloodyNightUpdate, self)
  EventManager:GetInstance():AddListenerWithSelf(EventId.WORLD_CAMERA_CHANGE_POINT, self.RefreshCameraPoint, self)
end

function BloodyNightFireEffect:OnRemoveListener()
  EventManager:GetInstance():RemoveListener2(EventId.BloodyNightActivityRefresh, self.OnBloodyNightUpdate, self)
  EventManager:GetInstance():RemoveListener2(EventId.WORLD_CAMERA_CHANGE_POINT, self.RefreshCameraPoint, self)
  base.OnRemoveListener(self)
end

local invisiblePos = Vector3.New(10000, 0, 10000)

function BloodyNightFireEffect:GetEffectPos(pos)
  local lod = self.lodCache or 9527
  if lod <= 3 then
    return pos
  end
  return invisiblePos
end

function BloodyNightFireEffect:RefreshCameraPoint()
  if self.isBloodyNight then
    local curPos = CS.SceneManager.World.CurTarget
    if self.lastWorldPos == nil then
      self.transform.position = self:GetEffectPos(curPos)
      self.lastWorldPos = curPos
    elseif math.abs(curPos.x - self.lastWorldPos.x) > maxDistance or math.abs(curPos.z - self.lastWorldPos.z) > maxDistance then
      self.transform.position = self:GetEffectPos(curPos)
      self.lastWorldPos = curPos
    end
  end
end

function BloodyNightFireEffect:UpdateLod(lod)
  if self.lodCache ~= lod then
    self.lodCache = lod
    if self.transform == nil or self.gameObject == nil then
      return
    end
    if GameObjectIsValid(self.gameObject) then
      if not self.isBloodyNight or self.lodCache > 3 then
        self.transform.position = Vector3.New(10000, 0, 10000)
      elseif self.lastWorldPos then
        self.transform.position = self.lastWorldPos
      else
        local curPos = CS.SceneManager.World.CurTarget
        self.transform.position = curPos
        self.lastWorldPos = curPos
      end
    end
  end
end

function BloodyNightFireEffect:OnBloodyNightUpdate()
  local isBloodyNight = DataCenter.BloodyNightDataManager:IsBloodyNight()
  if isBloodyNight then
    if self.isBloodyNight ~= isBloodyNight then
      local curPos = CS.SceneManager.World.CurTarget
      self.transform.position = self:GetEffectPos(curPos)
      self.lastWorldPos = curPos
    end
  else
    self.transform.position = Vector3.New(10000, 0, 10000)
  end
  self.isBloodyNight = isBloodyNight
end

function BloodyNightFireEffect:UpdateData()
  if not GameObjectIsValid(self.gameObject) then
    return
  end
  if not SceneUtils.GetIsInWorld() then
    self:SetActive(false)
    return
  end
  local isBloodyNight = DataCenter.BloodyNightDataManager:IsBloodyNight()
  if isBloodyNight then
    local curPos = CS.SceneManager.World.CurTarget
    self.transform.position = self:GetEffectPos(curPos)
    self.lastWorldPos = curPos
  else
    self.transform.position = Vector3.New(10000, 0, 10000)
  end
  self.isBloodyNight = isBloodyNight
end

return BloodyNightFireEffect
