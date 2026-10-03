local WorldArrowManager = BaseClass("WorldArrowManager", Singleton)
local ResourceManager = CS.GameEntry.Resource
local Setting = CS.GameEntry.Setting
local WorldArrow = require("Scene.WorldArrow.WorldArrow")

local function __init(self)
  self.allEffect = nil
  self.OnCreateEffect = nil
  self.param = nil
  self.guidState = true
end

local function __delete(self)
  if self.allEffect ~= nil then
    local request = self.allEffect.request
    self.allEffect.script:OnDestroy()
    request:Destroy()
  end
  self.allEffect = nil
  self.param = nil
  self.guidState = nil
end

local function UseOldMethod(self, type)
  local template = DataCenter.ArrowTipTemplateManager:GetTemplateByType(type)
  return template == nil
end

local function CheckCanShowAndSaveToLocal(self, type)
  local useOld = self:UseOldMethod(type)
  if useOld == true then
    if type == ArrowType.Farm then
      local num = Setting:GetInt(SettingKeys.WORLDARROW_TYPE_FARM_NUM, 0)
      local checkNum = LuaEntry.DataConfig:TryGetNum("arrow_show", "k3")
      if num >= checkNum then
        return false
      end
      Setting:SetInt(SettingKeys.WORLDARROW_TYPE_FARM_NUM, num + 1)
    elseif type == ArrowType.BuildBox then
      local num = Setting:GetInt(SettingKeys.WORLDARROW_TYPE_BUILD_NUM, 0)
      local checkNum = LuaEntry.DataConfig:TryGetNum("arrow_show", "k3")
      if num >= checkNum then
        return false
      end
      Setting:SetInt(SettingKeys.WORLDARROW_TYPE_BUILD_NUM, num + 1)
    end
  else
    local settingKey = self:GetSettingKey(type)
    local num = Setting:GetInt(settingKey, 0)
    local template = DataCenter.ArrowTipTemplateManager:GetTemplateByType(type)
    if template:CheckCondition(num) == false then
      return false
    end
    Setting:SetInt(settingKey, num + 1)
  end
  return true
end

local function GetSettingKey(self, type)
  return SettingKeys.WORLDARROW_TYPE_NUM .. "_" .. LuaEntry.Player.uid .. "_" .. type
end

local function ShowArrowEffect(self, uuid, position, type, tileX, tileY, time)
  if self:CheckCanShowAndSaveToLocal(type) == false then
    return
  end
  local param = {}
  param.uuid = uuid
  param.position = position
  param.arrowType = type
  param.tileX = tileX or 0
  param.tileY = tileY or 0
  param.showTime = time
  if self.allEffect == nil and self.OnCreateEffect == nil then
    local path = UIAssets.WorldArrow
    local request = ResourceManager:InstantiateAsync(path)
    local par = {}
    par.request = request
    self.OnCreateEffect = request
    request:completed("+", function()
      self.OnCreateEffect = nil
      if request.isError then
        return
      end
      request.gameObject:SetActive(true)
      request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      local effect = WorldArrow.New()
      effect:OnCreate(request)
      effect:ReInit(param)
      par.script = effect
      self.allEffect = par
    end)
  elseif self.allEffect ~= nil then
    self.allEffect.script:ReInit(param)
  end
  EventManager:GetInstance():Broadcast(EventId.ArrowShow)
end

local function RemoveEffect(self)
  if self.allEffect ~= nil then
    local request = self.allEffect.request
    self.allEffect.script:OnDestroy()
    request:Destroy()
  end
  self.allEffect = nil
end

local function IsCreateWorldArrow(self)
  if self.allEffect ~= nil then
    return true
  end
  return false
end

local function SetArrowParam(self, param)
  self.param = param
end

local function GetArrowParam(self)
  return self.param
end

local function SetGuidState(self, state)
  self.guidState = state
  if self.allEffect ~= nil then
    self.allEffect.script:SetObjActive(state)
  end
end

local function GetGuidState(self)
  return self.guidState
end

WorldArrowManager.__init = __init
WorldArrowManager.__delete = __delete
WorldArrowManager.ShowArrowEffect = ShowArrowEffect
WorldArrowManager.RemoveEffect = RemoveEffect
WorldArrowManager.UseOldMethod = UseOldMethod
WorldArrowManager.CheckCanShowAndSaveToLocal = CheckCanShowAndSaveToLocal
WorldArrowManager.GetSettingKey = GetSettingKey
WorldArrowManager.IsCreateWorldArrow = IsCreateWorldArrow
WorldArrowManager.SetArrowParam = SetArrowParam
WorldArrowManager.GetArrowParam = GetArrowParam
WorldArrowManager.SetGuidState = SetGuidState
WorldArrowManager.GetGuidState = GetGuidState
return WorldArrowManager
