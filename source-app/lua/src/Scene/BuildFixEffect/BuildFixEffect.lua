local BuildFixEffect = BaseClass("BuildFixEffect")

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
  self:UpdatePosition(self.data.posIndex)
  self.curTime = 0
  self.isDoAnim = true
  self:Update()
end

local function Update(self)
  if self.isDoAnim then
    self.curTime = self.curTime + Time.deltaTime
    if self.curTime > 1 then
      self:RemoveTimer()
      BuildFixEffectManager:GetInstance():RemoveOneEffect(self.data.bUuid)
    end
  end
end

local function UpdatePosition(self, index)
  local worldPos = BuildingUtils.GetBuildModelCenterVec(index, self.data.tileX, self.data.tileY)
  self.transform.position = worldPos
end

BuildFixEffect.OnCreate = OnCreate
BuildFixEffect.OnDestroy = OnDestroy
BuildFixEffect.ComponentDefine = ComponentDefine
BuildFixEffect.ComponentDestroy = ComponentDestroy
BuildFixEffect.Update = Update
BuildFixEffect.RemoveTimer = RemoveTimer
BuildFixEffect.ReInit = ReInit
BuildFixEffect.UpdatePosition = UpdatePosition
return BuildFixEffect
