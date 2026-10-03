local EarthOrderSceneObj = BaseClass("EarthOrderSceneObj")
local ResourceManager = CS.GameEntry.Resource
local Localization = CS.GameEntry.Localization
local rocket_anim_path = "RocketNode/A_diqiudidan_LM_HJ/A_diqiudidan@LM_HJ_skin"
local camera_anim_path = "Camera"
local box_path = "BoxNode%s"
local rocket_root_path = "RocketNode/A_diqiudidan_LM_HJ/A_diqiudidan@LM_HJ_skin/Main/HJ_To_unity/base/root"
local rocket_node_path = "RocketNode/EffectSmokeNode"
local rocket_door_path = "RocketNode/EffectDoorNode"
local title_text_path = "O_dqdd_huojian_02_ui/TitleText"
local country_icon_path = "O_dqdd_huojian_02_ui/CountryIcon"
local RocketAnim = {
  openDoor = "LM_HJ_kaimen",
  launch = "LM_HJ_shengkong"
}
local CameraAnim = {
  launch = "UI_dqdd_camera_zhenping_ Animation",
  idle = "UI_dqdd_camera_idle_Animation",
  stop = "UI_dqdd_camera_idle"
}
local CloseTime = 1
local IconDeltaX = 0.335

local function OnCreate(self, go)
  if go ~= nil then
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
  self.rocket_anim = self.transform:Find(rocket_anim_path):GetComponent(typeof(CS.UnityEngine.Animator))
  self.camera_anim = self.transform:Find(camera_anim_path):GetComponent(typeof(CS.UnityEngine.Animator))
  self.rocket_root = self.transform:Find(rocket_root_path).transform
  self.rocket_node = self.transform:Find(rocket_node_path).transform
  self.rocket_door = self.transform:Find(rocket_door_path).transform
  self.title_text = self.transform:Find(title_text_path):GetComponent(typeof(CS.SuperTextMesh))
  self.country_icon = self.transform:Find(country_icon_path):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
end

local function ComponentDestroy(self)
  for k, v in pairs(self.effect) do
    if v ~= nil then
      v:Destroy()
    end
  end
  self.rocket_anim = nil
  self.camera_anim = nil
  self.rocket_root = nil
  self.rocket_node = nil
  self.rocket_door = nil
  self.title_text = nil
  self.country_icon = nil
  self.gameObject = nil
  self.transform = nil
end

local function DataDefine(self)
  self.param = nil
  self.box = {}
  self.effect = {}
  self.cameraTimer = nil
  self.launchTimer = nil
  
  function self.timer_action(temp)
    self:RefreshTime()
  end
end

local function DataDestroy(self)
  if self.cameraTimer ~= nil then
    self.cameraTimer:Stop()
    self.cameraTimer = nil
  end
  if self.launchTimer ~= nil then
    self.launchTimer:Stop()
    self.launchTimer = nil
  end
  self.param = nil
  self.box = nil
  self.effect = nil
  self.timer_action = nil
  self:DeleteTimer()
end

local function ReInit(self, param)
  self.param = param
  self:AddTimer()
  self:RefreshTime()
end

local function RefreshTime(self)
  local now = UITimeManager:GetInstance():GetServerTime()
  local leftTime = self.param.endTime - now
  if self.param.lastTime ~= leftTime then
    self.param.lastTime = leftTime
    if leftTime <= 0 then
      local vipEffect = LuaEntry.Effect:GetGameEffect(EffectDefine.EARTH_ORDER_VIP)
      if 0 < vipEffect then
        self.title_text.text = Localization:GetString("320295")
        self.country_icon:LoadSprite(string.format(LoadPath.UIVipPath, "UIVip_bg_vip3"))
        self.country_icon.transform:Set_localScale(0.3, 0.3, 0)
        self:DeleteTimer()
      else
        self.title_text.text = Localization:GetString("129073")
        self.country_icon:LoadSprite(string.format(LoadPath.CommonNewPath, "Common_icon_rocketMark"))
        self.country_icon.transform:Set_localScale(0.3, 0.3, 0)
        self:DeleteTimer()
      end
    else
      self.title_text.text = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
      self.country_icon:LoadSprite(string.format(LoadPath.CommonNewPath, "Common_icon_rocketTime"))
      self.country_icon.transform:Set_localScale(-1, 1, 0)
    end
  end
end

local function AddTimer(self)
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false, false, false)
  end
  self.timer:Start()
end

local function DeleteTimer(self)
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

local function GetBoxNodePosition(self, index)
  if self.box[index] == nil then
    self.box[index] = self.transform:Find(string.format(box_path, index)).transform
  end
  return self.box[index].position
end

local function PlayLaunchAnim(self)
  self.rocket_anim:Play(RocketAnim.launch, 0, 0)
  self.launchTimer = TimerManager:GetInstance():GetTimer(CloseTime, function()
    if self.launchTimer ~= nil then
      self.launchTimer:Stop()
      self.launchTimer = nil
    end
    self.camera_anim:Play(CameraAnim.launch, 0, 0)
  end, self, true, false, false)
  self.launchTimer:Start()
  self:LoadEffect(UIAssets.UIRocketCloseDoorEffect, self.rocket_door)
  self:LoadEffect(UIAssets.UIRocketFireEffect, self.rocket_root)
  self:LoadEffect(UIAssets.UIRocketSmokeEffect, self.rocket_node)
end

local function PlayEnterAnim(self)
  local ret, time = UIUtil.PlayAnimationReturnTime(self.camera_anim, CameraAnim.idle)
  if ret then
    self.cameraTimer = TimerManager:GetInstance():GetTimer(time, function()
      if self.cameraTimer ~= nil then
        self.cameraTimer:Stop()
        self.cameraTimer = nil
      end
    end, self, true, false, false)
    self.cameraTimer:Start()
  end
end

local function EndEnterAnim(self)
  self.rocket_anim:Play(RocketAnim.openDoor, 0, 0)
  self:LoadEffect(UIAssets.UIRocketOpenDoorEffect, self.rocket_door)
end

local function LoadEffect(self, name, rootTransform)
  local request = ResourceManager:InstantiateAsync(name)
  table.insert(self.effect, request)
  request:completed("+", function()
    if request.isError then
      return
    end
    request.gameObject:SetActive(true)
    request.gameObject.transform:SetParent(rootTransform)
    request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    request.gameObject.transform:Set_localPosition(0, 0, 0)
  end)
end

EarthOrderSceneObj.OnCreate = OnCreate
EarthOrderSceneObj.OnDestroy = OnDestroy
EarthOrderSceneObj.ComponentDefine = ComponentDefine
EarthOrderSceneObj.ComponentDestroy = ComponentDestroy
EarthOrderSceneObj.DataDefine = DataDefine
EarthOrderSceneObj.DataDestroy = DataDestroy
EarthOrderSceneObj.ReInit = ReInit
EarthOrderSceneObj.GetBoxNodePosition = GetBoxNodePosition
EarthOrderSceneObj.PlayEnterAnim = PlayEnterAnim
EarthOrderSceneObj.PlayLaunchAnim = PlayLaunchAnim
EarthOrderSceneObj.EndEnterAnim = EndEnterAnim
EarthOrderSceneObj.LoadEffect = LoadEffect
EarthOrderSceneObj.RefreshTime = RefreshTime
EarthOrderSceneObj.AddTimer = AddTimer
EarthOrderSceneObj.DeleteTimer = DeleteTimer
return EarthOrderSceneObj
