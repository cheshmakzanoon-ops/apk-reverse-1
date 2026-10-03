local WorldCollectDes = BaseClass("WorldCollectDes", UIAsyncContainer)
local base = UIAsyncContainer
local Localization = CS.GameEntry.Localization
local icon_path = "content/Image"
local des_txt_path = "content/desTxt"
local slider_path = "content/specialObj/Slider"
local rest_num_path = "content/specialObj/restNum"
local rest_des_path = "content/specialObj/restDes"
local special_obj_path = "content/specialObj"
local specialContent_path = "specialContent"
local specialDesTxt_path = "specialContent/specialDesTxt"
local specialDesImg_path = "specialContent/specialDesImg"
local specialTimeTip_path = "specialContent/specialTimeTip"
local specialTimeTxt_path = "specialContent/specialTimeTip/specialTimeTxt"
local refreshTime = 0

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
  self.icon = self:AddComponent(UIImage, icon_path)
  self.des_txt = self:AddComponent(UIText, des_txt_path)
  self.special_obj = self:AddComponent(UIBaseContainer, special_obj_path)
  self.slider = self:AddComponent(UISlider, slider_path)
  self.rest_des = self:AddComponent(UIText, rest_des_path)
  self.rest_num = self:AddComponent(UIText, rest_num_path)
  self.specialContent = self:AddComponent(UIBaseContainer, specialContent_path)
  self.specialDesTxt = self:AddComponent(UIText, specialDesTxt_path)
  self.specialDesImg = self:AddComponent(UIImage, specialDesImg_path)
  self.specialTimeTip = self:AddComponent(UIText, specialTimeTip_path)
  self.specialTimeTxt = self:AddComponent(UIText, specialTimeTxt_path)
  self.specialContent:SetActive(false)
end

local function ComponentDestroy(self)
  self.icon = nil
  self.des_txt = nil
  self.special_obj = nil
  self.slider = nil
  self.rest_des = nil
  self.rest_num = nil
  self.specialContent = nil
  self.specialDesTxt = nil
  self.specialDesImg = nil
  self.specialTimeTip = nil
  self.specialTimeTxt = nil
end

local function DataDefine(self)
  self.param = nil
  self.isUpdate = false
  self.collectStartTime = 0
  self.isDetectCollect = false
  self.detectExpireTime = 0
  
  function self.timer_action(temp)
    self:RefreshTime()
  end
end

local function DataDestroy(self)
  self.param = nil
end

local function RefreshData(self, param)
  self.data = param
  self.isUpdate = false
  self.isDetectCollect = false
  self.icon:LoadSprite(self.data.icon)
  if self.view.ctrl.type == WorldPointUIType.CollectPoint or self.view.ctrl.type == WorldPointUIType.EpidemicBuild then
    self.des_txt:SetText("")
    self.special_obj:SetActive(true)
    self.rest_num:SetText("")
    self.slider:SetValue(0)
    self.rest_des:SetText(Localization:GetString("104291", Localization:GetString("100206")))
    local infoId = self.data.id
    local resCfg = DataCenter.GatherResourceTemplateManager:GetTemplate(infoId)
    if resCfg == nil then
      Logger.LogError(string.format("WorldCollectDes.RefreshData fail, resCfg is nil, info id = %s", infoId or "NULL"))
      self.specialContent:SetActive(false)
    elseif resCfg.type == 1 then
      self.specialContent:SetActive(true)
      self.specialDesTxt:SetLocalText("800810", resCfg.detect_show)
      local imgPath = CSharpCallLuaInterface.GetResourceDetectInfoIconBgById(infoId)
      self.specialDesImg:LoadSprite(imgPath)
      self.isDetectCollect = true
      self.detectExpireTime = 0
      local serverData = DataCenter.WorldPointDetailManager:GetDetailByPointId(self.view.ctrl.pointId)
      if serverData then
        self.detectExpireTime = serverData.eventExpireTime
      end
      self.specialTimeTip:SetLocalText(800823)
      self:TimeViewRefresh()
    else
      self.specialContent:SetActive(false)
    end
  elseif self.view.ctrl.type == WorldPointUIType.CityResPoint then
    self.des_txt:SetLocalText(self.data.desc)
    self.special_obj:SetActive(false)
  end
  self:RefreshTopBg()
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
end

local function UpdateInfo(self, data)
  self.isUpdate = false
  self.serverData = data.playerData
  if self.serverData ~= nil and (self.view.ctrl.type == WorldPointUIType.CollectPoint or self.view.ctrl.type == WorldPointUIType.EpidemicBuild) then
    if self.serverData.remainRes > 0 then
      self.collectStartTime = UITimeManager:GetInstance():GetServerTime()
      self.isUpdate = true
      self:AddTimer()
      self:RefreshTime()
    else
      self.rest_num:SetText("0/" .. string.GetFormattedSeperatorNum(math.floor(self.serverData.initRes)))
      self.slider:SetValue(0)
    end
  else
    self.rest_num:SetText("")
    self.slider:SetValue(0)
  end
  self:RefreshTopBg()
end

local function Update(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime > refreshTime + 1000 then
    refreshTime = curTime
    self:TimeViewRefresh()
  end
end

local function TimeViewRefresh(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.isDetectCollect then
    if self.detectExpireTime == 0 then
      local serverData = DataCenter.WorldPointDetailManager:GetDetailByPointId(self.view.ctrl.pointId)
      if serverData then
        self.detectExpireTime = serverData.eventExpireTime
      end
    end
    local remainTime = self.detectExpireTime - curTime
    if remainTime < 0 then
      remainTime = 0
    end
    local timeStr = UITimeManager:GetInstance():MilliSecondToFmtString(remainTime)
    self.specialTimeTxt:SetText(timeStr)
  end
end

function WorldCollectDes:RefreshTopBg()
  if not self.view then
    return
  end
  self.view:SetTopBg()
end

WorldCollectDes.OnCreate = OnCreate
WorldCollectDes.OnDestroy = OnDestroy
WorldCollectDes.OnEnable = OnEnable
WorldCollectDes.OnDisable = OnDisable
WorldCollectDes.ComponentDefine = ComponentDefine
WorldCollectDes.ComponentDestroy = ComponentDestroy
WorldCollectDes.DataDefine = DataDefine
WorldCollectDes.DataDestroy = DataDestroy
WorldCollectDes.RefreshData = RefreshData
WorldCollectDes.UpdateInfo = UpdateInfo
WorldCollectDes.RefreshTime = RefreshTime
WorldCollectDes.AddTimer = AddTimer
WorldCollectDes.DeleteTimer = DeleteTimer
WorldCollectDes.Update = Update
WorldCollectDes.TimeViewRefresh = TimeViewRefresh
return WorldCollectDes
