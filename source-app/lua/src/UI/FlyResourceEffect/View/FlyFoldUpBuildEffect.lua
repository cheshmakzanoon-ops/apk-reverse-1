local FlyFoldUpBuildEffect = BaseClass("FlyFoldUpBuildEffect")
local lizi_path = "shouji_lizi_UI"

local function OnCreate(self, go)
  if go ~= nil then
    self.request = go
    self.gameObject = go.gameObject
    self.transform = go.gameObject.transform
  end
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
end

local function ComponentDefine(self)
  self.lizi = self.transform:Find(lizi_path).gameObject
end

local function ComponentDestroy(self)
end

local function DataDefine(self)
  self.param = nil
  
  function self.__update_handle()
    self:Update()
  end
  
  UpdateManager:GetInstance():AddUpdate(self.__update_handle)
  self.isDoAnim = false
  self.curTime = 0
  self.endPos = nil
  self.showLizi = false
  self.startPos = 0
end

local function DataDestroy(self)
  self.param = nil
  UpdateManager:GetInstance():RemoveUpdate(self.__update_handle)
  self.__update_handle = nil
  self.isDoAnim = nil
  self.curTime = nil
  self.endPos = nil
  self.showLizi = nil
  self.startPos = nil
end

local function ReInit(self, param)
  self.param = param
  self:ShowPanel()
end

local function ShowPanel(self)
  self.showLizi = false
  self.gameObject.transform.position = self.param.startPos
  self.gameObject.transform.localScale = Vector3.New(1.2, 1.2, 1.2)
  self.curTime = 0
  self.startPos = self.param.startPos
  self.endPos = self.param.endPos
  local normalize = Vector3.Normalize(Vector3.New(self.endPos.x - self.startPos.x, self.endPos.y - self.startPos.y, self.endPos.z - self.startPos.z))
  self.lizi.transform:Set_localPosition(7, self.lizi.transform.localPosition.y, self.lizi.transform.localPosition.z)
  local temp = self.param.distance / 960
  local deltaY = math.random(15, 30) * normalize.y
  local deltaX = math.random(15, 30) * normalize.x
  self.halfCenterPos = Vector3.New(self.startPos.x - deltaX, self.startPos.y - deltaY, self.startPos.z)
  local y = -230 * normalize.y * temp
  local x = 200 * normalize.x
  self.centerPos = Vector3.New(self.halfCenterPos.x + x, self.halfCenterPos.y + y, self.startPos.z)
  self.isDoAnim = true
end

local function Update(self)
  if self.isDoAnim then
    self.curTime = self.curTime + Time.deltaTime
    if self.curTime < self.param.stopTime then
    elseif self.curTime > self.param.stopTime then
      local tempTime = self.curTime - self.param.stopTime
      if tempTime > self.param.time then
        self.gameObject.transform.position = self:GetBezierPoint(self.startPos, self.endPos, self.centerPos, tempTime / self.param.time)
        self.isDoAnim = false
        EventManager:GetInstance():Broadcast(EventId.FoldUpBuilding)
        self.gameObject:SetActive(false)
        DataCenter.FlyResourceEffectManager:RemoveOneEffect(self.param)
      else
        if self.showLizi == false then
          self.showLizi = true
        end
        local scale = 1.2 - 0.6 * (tempTime / self.param.time)
        self.gameObject.transform.localScale = Vector3.New(scale, scale, scale)
        self.gameObject.transform.position = self:GetBezierPoint(self.startPos, self.endPos, self.centerPos, tempTime / self.param.time)
      end
    end
  end
end

local function GetBezierPoint(self, startPos, endPos, centerPos, t)
  local a = (1 - t) * (1 - t) * startPos.x + 2 * t * (1 - t) * centerPos.x + t * t * endPos.x
  local b = (1 - t) * (1 - t) * startPos.y + 2 * t * (1 - t) * centerPos.y + t * t * endPos.y
  local c = (1 - t) * (1 - t) * startPos.z + 2 * t * (1 - t) * centerPos.y + t * t * endPos.z
  return Vector3.New(a, b, c)
end

FlyFoldUpBuildEffect.OnCreate = OnCreate
FlyFoldUpBuildEffect.OnDestroy = OnDestroy
FlyFoldUpBuildEffect.ComponentDefine = ComponentDefine
FlyFoldUpBuildEffect.ComponentDestroy = ComponentDestroy
FlyFoldUpBuildEffect.DataDefine = DataDefine
FlyFoldUpBuildEffect.DataDestroy = DataDestroy
FlyFoldUpBuildEffect.ReInit = ReInit
FlyFoldUpBuildEffect.ShowPanel = ShowPanel
FlyFoldUpBuildEffect.Update = Update
FlyFoldUpBuildEffect.GetBezierPoint = GetBezierPoint
return FlyFoldUpBuildEffect
