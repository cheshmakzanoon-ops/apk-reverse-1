local WorldAllianceCollectResDes = BaseClass("WorldAllianceCollectResDes", UIAsyncContainer)
local base = UIAsyncContainer
local Localization = CS.GameEntry.Localization
local main_obj_path = "BuildInfo"
local des_obj_path = "BuildDetails"
local icon_path = "BuildInfo/Image"
local des_txt_path = "BuildDetails/ScrollView/Viewport/Content/desTxt"
local slider_path = "BuildInfo/Slider"
local rest_num_path = "BuildInfo/restNum"
local rest_des_path = "BuildInfo/restDes"
local reset_time_path = "BuildInfo/resetTime"
local animator_path = ""

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  self:DeleteTimer()
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.animator = self:AddComponent(UIAnimator, animator_path)
  self.main_obj = self:AddComponent(UIBaseContainer, main_obj_path)
  self.des_obj = self:AddComponent(UIBaseContainer, des_obj_path)
  self.main_obj_canvas = self:AddComponent(UICanvasGroup, main_obj_path)
  self.des_obj_canvas = self:AddComponent(UICanvasGroup, des_obj_path)
  self.main_obj_canvas:SetAlpha(1)
  self.des_obj_canvas:SetAlpha(1)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.des_txt = self:AddComponent(UIText, des_txt_path)
  self.slider = self:AddComponent(UISlider, slider_path)
  self.rest_des = self:AddComponent(UIText, rest_des_path)
  self.rest_num = self:AddComponent(UIText, rest_num_path)
  self.reset_time = self:AddComponent(UIText, reset_time_path)
end

local function ComponentDestroy(self)
  self.icon = nil
  self.des_txt = nil
end

local function DataDefine(self)
  self.param = nil
  self.isUpdate = false
  self.collectStartTime = 0
  self.reset_des = Localization:GetString("142510")
  
  function self.timer_action(temp)
    self:RefreshTime()
  end
end

local function DataDestroy(self)
  self.param = nil
end

local function OnInfoClick(self)
  if self.data == nil or IsNull(self.gameObject) then
    return
  end
  self.animator:Enable(true)
  self.animator:Play("switchEnter", 0, 0)
end

local function OnReturnClick(self)
  if self.data == nil or IsNull(self.gameObject) then
    return
  end
  self.animator:Enable(true)
  self.animator:Play("switchOut", 0, 0)
end

local function RefreshData(self, param)
  self.data = param
  self.isUpdate = false
  self.isReset = false
  self.resetEndTime = 0
  self:UpdateData()
end

function WorldAllianceCollectResDes:UpdateData()
  if IsNull(self.gameObject) then
    return
  end
  if self.serverDataCache then
    self:UpdateInfo(self.serverDataCache)
  end
  if self.data then
    self.icon:LoadSprite(self.data.icon)
    self.des_txt:SetLocalText(self.data.desc)
    self.reset_time:SetText("")
    self.rest_des:SetText(Localization:GetString("142509") .. math.floor(self.data.collectSpeedDes) .. "/h")
    CS.SceneManager.World:SetShowCollectTypeForLua(self.data.resourceType)
  end
end

local function DeleteTimer(self)
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

local function AddTimer(self)
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false, false, false)
  end
  self.timer:Start()
end

local function RefreshTime(self)
  if self.isUpdate == true and self.serverData ~= nil then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local deltaTime = curTime - self.collectStartTime
    if deltaTime < 0 then
      deltaTime = 0
    end
    local realNum = deltaTime * self.serverData.speed / 1000
    if realNum < 0 then
      realNum = 0
    end
    local restNum = self.serverData.remainRes - realNum
    if 0 < restNum then
      local tempValue = math.min(restNum / math.max(self.serverData.initRes, 1), 1)
      self.slider:SetValue(tempValue)
      self.rest_num:SetText(string.GetFormattedSeperatorNum(math.floor(restNum)) .. "/" .. string.GetFormattedSeperatorNum(math.floor(self.serverData.initRes)))
      if 0 >= self.serverData.speed then
        self.collectStartTime = 0
        self.isUpdate = false
      end
    else
      self.collectStartTime = 0
      self.isUpdate = false
      self.rest_num:SetText("0/" .. string.GetFormattedSeperatorNum(math.floor(self.serverData.initRes)))
      self.slider:SetValue(0)
    end
  end
  if self.isReset == true then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local deltaTime = self.resetEndTime - curTime
    if 0 < deltaTime then
      self.reset_time:SetText(self.reset_des .. UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime))
    else
      self.reset_time:SetText("")
      self.isReset = false
      if self.serverData ~= nil and self.serverData.remainRes ~= nil and self.serverData.remainRes < 1 then
        self.rest_num:SetText(string.GetFormattedSeperatorNum(math.floor(self.serverData.initRes) .. "/" .. string.GetFormattedSeperatorNum(math.floor(self.serverData.initRes))))
        self.slider:SetValue(1)
      end
    end
  end
end

local function UpdateInfo(self, data)
  self.isUpdate = false
  self.isReset = false
  self.serverData = data.playerData
  if IsNull(self.gameObject) then
    self.serverDataCache = data
    return
  end
  self.serverDataCache = nil
  if self.serverData ~= nil then
    if self.serverData.remainRes > 1 then
      self.collectStartTime = UITimeManager:GetInstance():GetServerTime()
      self.isUpdate = true
      self:AddTimer()
      self:RefreshTime()
    else
      self.rest_num:SetText("0/" .. string.GetFormattedSeperatorNum(math.floor(self.serverData.initRes)))
      self.slider:SetValue(0)
    end
    self.resetEndTime = self.serverData.expireTime
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local deltaTime = self.resetEndTime - curTime
    if 0 < deltaTime then
      self.reset_time:SetText(self.reset_des .. UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime))
      self.isReset = true
      self:AddTimer()
      self:RefreshTime()
    else
      self.reset_time:SetText("")
      self.isReset = false
      if self.serverData.remainRes <= 1 then
        self.rest_num:SetText(string.GetFormattedSeperatorNum(math.floor(self.serverData.initRes) .. "/" .. string.GetFormattedSeperatorNum(math.floor(self.serverData.initRes))))
        self.slider:SetValue(1)
      end
    end
  end
end

WorldAllianceCollectResDes.OnCreate = OnCreate
WorldAllianceCollectResDes.OnDestroy = OnDestroy
WorldAllianceCollectResDes.OnEnable = OnEnable
WorldAllianceCollectResDes.OnDisable = OnDisable
WorldAllianceCollectResDes.ComponentDefine = ComponentDefine
WorldAllianceCollectResDes.ComponentDestroy = ComponentDestroy
WorldAllianceCollectResDes.DataDefine = DataDefine
WorldAllianceCollectResDes.DataDestroy = DataDestroy
WorldAllianceCollectResDes.RefreshData = RefreshData
WorldAllianceCollectResDes.UpdateInfo = UpdateInfo
WorldAllianceCollectResDes.RefreshTime = RefreshTime
WorldAllianceCollectResDes.AddTimer = AddTimer
WorldAllianceCollectResDes.DeleteTimer = DeleteTimer
WorldAllianceCollectResDes.OnReturnClick = OnReturnClick
WorldAllianceCollectResDes.OnInfoClick = OnInfoClick
return WorldAllianceCollectResDes
