local WorldArrow = BaseClass("WorldArrow")
local default_show_time = 3.0

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
  self.isShow = true
  if self.data.showTime == nil then
    local template = DataCenter.ArrowTipTemplateManager:GetTemplateByType(param.arrowType)
    if template == nil then
      self.showTime = default_show_time
    else
      self.showTime = template.time
    end
  else
    self.showTime = self.data.showTime
  end
  if self.modelHeight == nil then
    self.modelHeight = Vector3.New(0, 2, 0)
  end
  if self.data.arrowType == ArrowType.Monster then
    local height = CS.SceneManager.World:GetModelHeight(self.data.uuid)
    if height <= 0 then
      self.modelHeight.y = 3.7
    else
      self.modelHeight.y = height
    end
  elseif self.data.arrowType == ArrowType.Building then
    self.modelHeight.y = CS.SceneManager.World:GetBuildingHeight(self.data.position)
  elseif self.data.arrowType == ArrowType.Guide_Garbage then
    self.modelHeight.y = 2
  elseif self.data.arrowType == ArrowType.BuildBox then
    if self.data.tileX == BuildTilesSize.One then
      self.modelHeight.y = 3
    elseif self.data.tileX == BuildTilesSize.Two then
      self.modelHeight.y = 4
    else
      self.modelHeight.y = 4
    end
  elseif self.data.arrowType == ArrowType.LandLock then
    self.modelHeight.y = 3
  elseif self.data.arrowType == ArrowType.CollectMoney then
    self.modelHeight.y = 4
  end
  local posV3 = self.data.position + self.modelHeight
  self.transform.position = posV3
  self.curTime = 0
  if self.showTime <= 0 then
    self.isDoAnim = false
  else
    self.isDoAnim = true
  end
  local guidState = WorldArrowManager:GetInstance():GetGuidState()
  self:SetObjActive(guidState)
  self:Update()
end

local function SetObjActive(self, state)
  self.gameObject:SetActive(state)
  self.isShow = state
end

local function Update(self)
  if self.isDoAnim and self.isShow then
    self.curTime = self.curTime + Time.deltaTime
    if self.curTime > self.showTime then
      self:RemoveTimer()
      WorldArrowManager:GetInstance():RemoveEffect()
    end
  end
end

WorldArrow.OnCreate = OnCreate
WorldArrow.OnDestroy = OnDestroy
WorldArrow.ComponentDefine = ComponentDefine
WorldArrow.ComponentDestroy = ComponentDestroy
WorldArrow.Update = Update
WorldArrow.RemoveTimer = RemoveTimer
WorldArrow.ReInit = ReInit
WorldArrow.SetObjActive = SetObjActive
return WorldArrow
