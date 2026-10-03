local CityDomeProtectEffect = BaseClass("CityDomeProtectEffect")

local function OnCreate(self, request, parent)
  if request ~= nil then
    self.request = request
    self.gameObject = request.gameObject
    self.transform = request.gameObject.transform
  end
  self.tParent = parent
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
end

local function ComponentDefine(self)
  local anim = self.transform:Find("anim")
  if anim then
    self.simpleAnim = anim:GetComponent(typeof(CS.SimpleAnimation))
  end
end

local function ComponentDestroy(self)
  self.gameObject = nil
  self.transform = nil
end

local function DataDefine(self)
  self.isUpdate = false
  self.param = nil
  self.curPosition = nil
end

local function DataDestroy(self)
  self.param = nil
  self.curPosition = nil
  self.timer_action = nil
  self.tParent = nil
  self:DeleteTimer()
end

local function DeleteTimer(self)
  self.isUpdate = false
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

local function AddTimer(self)
  self.isUpdate = true
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false, false, false)
  end
  self.timer:Start()
end

local function CheckIsFinish(self)
  if self.isUpdate == true and self.param ~= nil then
    local curTime = UITimeManager:GetInstance():GetServerSeconds()
    if curTime > self.param.endTime then
      self.isUpdate = false
      CityDomeProtectEffectManager:GetInstance():RemoveBuildProtectEffect(self.param.bUuid)
    end
  end
end

local function ReInit(self, param)
  self.timer = nil
  
  function self.timer_action(temp)
    self:CheckIsFinish()
  end
  
  self:AddTimer()
  self.param = param
  self:ShowPanel()
end

local function ShowPanel(self)
  local theServerId = LuaEntry.Player:GetSelfServerId()
  local pointInfo = CS.SceneManager.World:GetPointInfo(self.param.posIndex)
  if pointInfo and pointInfo.PointType == WorldPointType.PlayerBuilding then
    local _uuid = pointInfo.uuid
    theServerId = pointInfo.serverId
    if _uuid ~= self.param.bUuid then
      local msg = string.format("City.Shell Exception:lastPosIndex:%s, posIndex:%s, lastUuid:%s, uuid:%s", self.param.posIndex, pointInfo.pointIndex, self.param.bUuid, _uuid)
      Logger.LogError(msg)
      self.isUpdate = false
      CityDomeProtectEffectManager:GetInstance():RemoveBuildProtectEffect(self.param.bUuid)
      return
    else
      local curTime = UITimeManager:GetInstance():GetServerSeconds()
      if curTime > pointInfo.protectEndTime then
        local msg = string.format("City.Shell Exception:Time over")
        Logger.LogError(msg)
        self.isUpdate = false
        CityDomeProtectEffectManager:GetInstance():RemoveBuildProtectEffect(self.param.bUuid)
        return
      end
    end
  end
  if IsNull(self.tParent) and self.param and self.param.posIndex and GameObjectIsValid(self.gameObject) then
    self.gameObject.transform.position = SceneUtils.TileIndexToWorld(self.param.posIndex, ForceChangeScene.World, theServerId)
  end
end

local function Show(self)
  if self.simpleAnim then
    self.simpleAnim:Play("show")
  end
end

local function Hide(self)
  if self.simpleAnim then
    self.simpleAnim:Play("hide")
  end
end

local function GetDomeLevel(self)
  if self.param ~= nil then
    return self.param.domeLv
  end
  return 0
end

CityDomeProtectEffect.OnCreate = OnCreate
CityDomeProtectEffect.OnDestroy = OnDestroy
CityDomeProtectEffect.ComponentDefine = ComponentDefine
CityDomeProtectEffect.ComponentDestroy = ComponentDestroy
CityDomeProtectEffect.DataDefine = DataDefine
CityDomeProtectEffect.DataDestroy = DataDestroy
CityDomeProtectEffect.ReInit = ReInit
CityDomeProtectEffect.ShowPanel = ShowPanel
CityDomeProtectEffect.CheckIsFinish = CheckIsFinish
CityDomeProtectEffect.AddTimer = AddTimer
CityDomeProtectEffect.DeleteTimer = DeleteTimer
CityDomeProtectEffect.Show = Show
CityDomeProtectEffect.Hide = Hide
CityDomeProtectEffect.GetDomeLevel = GetDomeLevel
return CityDomeProtectEffect
