local WorldTroopLightEffect = BaseClass("WorldTroopLightEffect")
local DisplaySettings = require("DataCenter.WorldBattle.WorldBattleDisplaySettings")
local ResourceManager = CS.GameEntry.Resource
local lightCenter_localPosX = 0
local lightCenter_localPosZ = 1
local lightOne_localPosX = -0.7
local lightOne_localPosZ = 2.4
local lightTwo_localPosX = 0.7
local lightTwo_localPosZ = 2.4

function WorldTroopLightEffect:__init(name, transform, prefabPath)
  ProfilerUtil.BeginSample("WorldTroopLightEffect:__init")
  self.isDawn = DataCenter.BloodyNightDataManager:IsDawn(LuaEntry.Player:GetCurServerId())
  if self.isDawn then
    return
  end
  if self.gameObjectRoot ~= nil then
    self:UpdateDisplayLevel()
    ProfilerUtil.EndSample()
    return
  end
  self.gameObjectRoot = CS.UnityEngine.GameObject(name)
  self.gameObjectRoot.transform:SetParent(transform)
  self.gameObjectRoot.transform:Set_localScale(1, 1, 1)
  self.gameObjectRoot.transform:Set_localPosition(0, 0, 0)
  local request = ResourceManager:InstantiateAsync(prefabPath)
  request:completed("+", function()
    if request.isError or transform == nil or IsNull(transform) then
      return
    end
    local go = request.gameObject
    go.name = "lightOne"
    go:SetActive(self.goIsActive == nil or self.goIsActive == true)
    go.transform:SetParent(self.gameObjectRoot.transform)
    go.transform:Set_localScale(1, 1, 1)
    go.transform:Set_localPosition(0, 0, 0)
    go.transform:Set_localRotation(0, 0, 0, 1)
    self.lightOneObj = go
    self:UpdateDisplayLevel()
  end)
  self.addListenerCount = 0
  self.request = request
  
  function self.OnLodUpdateFun(obj)
    self:UpdateDisplayLevel()
  end
  
  function self.OnBloodyNightActivityRefresh(obj)
    self:TryHideLightOnBloodyNightActivityRefresh()
  end
  
  EventManager:GetInstance():AddListenerWithSelf(EventId.AfterWorldCameraLodChanged, self.OnLodUpdateFun, self)
  EventManager:GetInstance():AddListenerWithSelf(EventId.BloodyNightActivityRefresh, self.OnBloodyNightActivityRefresh, self)
  ProfilerUtil.EndSample()
end

function WorldTroopLightEffect:__delete()
  if self.gameObjectRoot ~= nil then
    self:OnDestroy()
    CS.UnityEngine.GameObject.Destroy(self.gameObjectRoot)
  end
  if self.request then
    self.request:Destroy()
    self.request = nil
  end
  self.gameObjectRoot = nil
  self.lightOneObj = nil
  self.lightTwoObj = nil
  EventManager:GetInstance():RemoveListener2(EventId.AfterWorldCameraLodChanged, self.OnLodUpdateFun)
  EventManager:GetInstance():RemoveListener2(EventId.BloodyNightActivityRefresh, self.OnBloodyNightActivityRefresh)
end

function WorldTroopLightEffect:OnCreate()
end

function WorldTroopLightEffect:OnDestroy()
end

function WorldTroopLightEffect:SetActive(active)
  self.goIsActive = active
  if IsNotNull(self.gameObjectRoot) then
    self.gameObjectRoot:SetActive(active)
  end
end

function WorldTroopLightEffect:SetRotation(x, y, z, w)
  if self.gameObjectRoot ~= nil then
    self.gameObjectRoot.transform:Set_localRotation(x, y, z, w)
  end
  self.rotation_x = x
  self.rotation_y = y
  self.rotation_z = z
  self.rotation_w = w
end

function WorldTroopLightEffect:HideLight()
  if self.lightOneObj ~= nil then
    self.lightOneObj:SetActive(false)
    if self.lightTwoObj ~= nil then
      self.lightTwoObj:SetActive(false)
    end
  end
end

function WorldTroopLightEffect:ShowOneLight()
  if self.lightOneObj ~= nil and not IsNull(self.lightOneObj) and not IsNull(self.lightOneObj.transform) then
    self.lightOneObj:SetActive(true)
    self.lightOneObj.transform:Set_localPosition(lightCenter_localPosX, 0, lightCenter_localPosZ)
    if self.lightTwoObj ~= nil then
      self.lightTwoObj:SetActive(false)
    end
  end
end

function WorldTroopLightEffect:ShowTwoLight()
  if self.lightOneObj ~= nil and not IsNull(self.lightOneObj) and not IsNull(self.lightOneObj.transform) then
    self.lightOneObj:SetActive(true)
    self.lightOneObj.transform:Set_localPosition(lightOne_localPosX, 0, lightOne_localPosZ)
    if self.lightTwoObj == nil then
      self.lightTwoObj = CS.UnityEngine.GameObject.Instantiate(self.lightOneObj)
      self.lightTwoObj.name = "lightTwo"
      self.lightTwoObj.transform:SetParent(self.gameObjectRoot.transform)
    end
    self.lightTwoObj:SetActive(true)
    self.lightTwoObj.transform:Set_localPosition(lightTwo_localPosX, 0, lightTwo_localPosZ)
    self.lightTwoObj.transform:Set_localRotation(0, 0, 0, 1)
  end
end

function WorldTroopLightEffect:UpdateDisplayLevel()
  ProfilerUtil.BeginSample("WorldTroopLightEffect:UpdateDisplayLevel")
  if self.isDawn then
    self:HideLight()
    return
  end
  local displayLv = DisplaySettings.GetCurrentDisplayLevel()
  local currentLevel = DisplaySettings.LevelLimit
  local currentLod = DisplaySettings.currentLod
  if displayLv < 0 then
    self:HideLight()
  elseif 3 <= currentLod then
    self:HideLight()
  elseif currentLevel == DisplaySettings.Levels.High then
    self:ShowTwoLight()
  elseif currentLevel == DisplaySettings.Levels.Mid then
    self:ShowOneLight()
  else
    self:HideLight()
  end
  ProfilerUtil.EndSample()
end

function WorldTroopLightEffect:OnLodUpdate(lod)
  self:UpdateDisplayLevel()
end

function WorldTroopLightEffect:TryHideLightOnBloodyNightActivityRefresh()
  local isDawn = DataCenter.BloodyNightDataManager:IsDawn(LuaEntry.Player:GetCurServerId())
  if isDawn then
    self:HideLight()
    self.isDawn = true
  end
end

return WorldTroopLightEffect
