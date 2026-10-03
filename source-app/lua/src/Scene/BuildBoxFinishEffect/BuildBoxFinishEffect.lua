local BuildBoxFinishEffect = BaseClass("BuildBoxFinishEffect")
local PositionDelta = Vector3.New(0, 0, 0)

local function OnCreate(self, go)
  if go ~= nil then
    self.request = go
    self.gameObject = go.gameObject
    self.transform = go.gameObject.transform
  end
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:RemoveTimer()
  self:ComponentDestroy()
end

local function ComponentDefine(self)
  self.isDoAnim = false
  
  function self.__update_handle()
    self:Update()
  end
  
  UpdateManager:GetInstance():AddUpdate(self.__update_handle)
end

local function ComponentDestroy(self)
end

local function RemoveTimer(self)
  if self.__update_handle ~= nil then
    UpdateManager:GetInstance():RemoveUpdate(self.__update_handle)
    self.__update_handle = nil
  end
end

local function ReInit(self, param)
  self.data = param
  self:UpdatePosition(self.data.pointId)
  self.curTime = 0
  self.isDoAnim = true
  self:Update()
end

local function Update(self)
  if self.isDoAnim then
    self.curTime = self.curTime + Time.deltaTime
    if self.curTime > 3 then
      self:RemoveTimer()
      BuildBoxFinishEffectManager:GetInstance():RemoveOneEffect(self.data.bUuid)
    end
  end
end

local function UpdatePosition(self, index)
  self.transform.position = BuildingUtils.GetBuildModelCenterVec(index, self.data.tileX, self.data.tileY) + PositionDelta
end

BuildBoxFinishEffect.OnCreate = OnCreate
BuildBoxFinishEffect.OnDestroy = OnDestroy
BuildBoxFinishEffect.ComponentDefine = ComponentDefine
BuildBoxFinishEffect.ComponentDestroy = ComponentDestroy
BuildBoxFinishEffect.Update = Update
BuildBoxFinishEffect.RemoveTimer = RemoveTimer
BuildBoxFinishEffect.ReInit = ReInit
BuildBoxFinishEffect.UpdatePosition = UpdatePosition
return BuildBoxFinishEffect
