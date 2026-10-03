local Setting = CS.GameEntry.Setting
local BackGestureManager = BaseClass("BackGestureManager", CEventable)
local GameObject = CS.UnityEngine.GameObject
local NavigationGestureInputModuleListener = CS.NavigationGestureInputModuleListener

function BackGestureManager:__init()
  self.gameObject = nil
  self.isOn = nil
  self:RegisterEvent(EventId.ChangeOtherScene, self.OnChangeOtherScene)
  self:RegisterEvent(EventId.ChangeBaseScene, self.OnChangeBaseScene)
end

function BackGestureManager:__delete()
  self.isOn = nil
  if IsNotNull(self.gameObject) then
    CS.UnityEngine.GameObject.Destroy(self.gameObject)
    self.gameObject = nil
  end
end

function BackGestureManager:GetNeedShowSetting()
  local switch = false
  if CS.SDKManager.IS_UNITY_ANDROID() then
    switch = LuaEntry.DataConfig:CheckSwitch("navigation_gesture_android")
  elseif CS.SDKManager.IS_UNITY_IOS() then
    switch = LuaEntry.DataConfig:CheckSwitch("navigation_gesture_ios")
  end
  if switch then
    local sceneType = DataCenter.LWSceneStateManager:GetCurScene()
    if not self:IsInShowScene(sceneType) then
      switch = false
    end
  end
  return switch
end

function BackGestureManager:ChangeSwitchState(isOn)
  if self.isOn == isOn then
    return
  end
  self.isOn = isOn
  if isOn then
    if IsNull(self.gameObject) then
      self.gameObject = GameObject("BackGestureRoot")
      self.gameObject:AddComponent(typeof(NavigationGestureInputModuleListener))
      self.gameObject:SetActive(true)
    else
      self.gameObject:SetActive(true)
    end
  elseif IsNotNull(self.gameObject) then
    self.gameObject:SetActive(false)
  end
end

function BackGestureManager:OnInitMessage()
  local sceneType = DataCenter.LWSceneStateManager:GetCurScene()
  self:OnChangeScene(sceneType)
end

function BackGestureManager:GetSwitch()
  return Setting:GetBool(SettingKeys.BACK_GESTURE, true)
end

function BackGestureManager:SetSwitch(isOn)
  Setting:SetBool(SettingKeys.BACK_GESTURE, isOn)
  if isOn then
    PostEventLog.Track(PostEventLog.Defines.NAVIGATION_GESTURE_SWITCH, {status = 1})
  else
    PostEventLog.Track(PostEventLog.Defines.NAVIGATION_GESTURE_SWITCH, {status = 0})
  end
end

function BackGestureManager:OnChangeOtherScene(sceneType)
  self:OnChangeScene(sceneType)
end

function BackGestureManager:OnChangeBaseScene(sceneType)
  self:OnChangeScene(sceneType)
end

function BackGestureManager:OnChangeScene(sceneType)
  local needShow = self:GetNeedShowSetting()
  local isOn = false
  if needShow then
    isOn = self:GetSwitch()
  end
  if isOn and not self:IsInShowScene(sceneType) then
    isOn = false
  end
  ProfilerUtil.BeginSample("BackGestureManager.ChangeSwitchState")
  self:ChangeSwitchState(isOn)
  ProfilerUtil.EndSample()
end

function BackGestureManager:IsInShowScene(sceneType)
  return sceneType ~= nil and (sceneType == SceneType.City or sceneType == SceneType.World)
end

return BackGestureManager
