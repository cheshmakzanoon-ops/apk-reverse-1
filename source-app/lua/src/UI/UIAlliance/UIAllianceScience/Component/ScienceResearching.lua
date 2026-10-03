local ScienceResearching = BaseClass("ScienceResearching", UIBaseContainer)
local base = UIBaseContainer
local researching_icon_path = "Science/Icon"
local researching_level_path = "Science/LvTxt"
local researching_slider_path = "Slider"
local researching_left_time_path = "Slider/SliderText"
local SliderLength = 528

local function OnCreate(self)
  base.OnCreate(self)
  self.isUpdate = false
  self.lastChangeTextDeltaTime = 0
  self.lastChangeImageDeltaTime = 0
  self.researching_icon = self:AddComponent(UIImage, researching_icon_path)
  self.researching_level = self:AddComponent(UIText, researching_level_path)
  self.researching_slider = self:AddComponent(UISlider, researching_slider_path)
  self.researching_left_time = self:AddComponent(UIText, researching_left_time_path)
end

local function OnDestroy(self)
  self.isUpdate = nil
  self.lastChangeTextDeltaTime = nil
  self.lastChangeImageDeltaTime = nil
  self.researching_go = nil
  self.researching_icon = nil
  self.researching_level = nil
  self.researching_slider = nil
  self.researching_left_time = nil
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function Update(self)
  if self.isUpdate then
    self:UpdateSlider()
  end
end

local function UpdateSlider(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local deltaTime = 0
  local maxTime = 0
  if curTime < self.science.finishTime then
    self.isUpdate = true
    deltaTime = self.science.finishTime - curTime
    maxTime = self.science.finishTime - self.science.startTime
  else
    self.isUpdate = false
  end
  if self.isUpdate then
    if TimeBarUtil.CheckIsNeedChangeBar(deltaTime, self.lastChangeImageDeltaTime, maxTime, SliderLength) then
      self.lastChangeImageDeltaTime = deltaTime
      local tempValue = 1 - deltaTime / maxTime
      self.researching_slider:SetValue(tempValue)
    end
    if TimeBarUtil.CheckIsNeedChangeText(deltaTime, self.lastChangeTextDeltaTime) then
      self.lastChangeTextDeltaTime = deltaTime
      self.researching_left_time:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime))
    end
  else
    self.lastChangeTextDeltaTime = 0
    self.lastChangeImageDeltaTime = 0
    self.researching_slider:SetValue(1)
    self.researching_left_time:SetLocalText(170008)
    SFSNetwork.SendMessage(MsgDefines.AllScienceRefresh)
  end
end

local function RefreshData(self, data)
  self.science = data
  if self.science ~= nil then
    self.researching_icon:LoadSprite(string.format(LoadPath.ScienceIcons, self.science.icon))
    self.researching_level:SetText(self.science.curLevel .. "/" .. self.science.maxLevel)
    self:UpdateSlider()
  end
end

ScienceResearching.OnCreate = OnCreate
ScienceResearching.OnDestroy = OnDestroy
ScienceResearching.OnEnable = OnEnable
ScienceResearching.OnDisable = OnDisable
ScienceResearching.RefreshData = RefreshData
ScienceResearching.UpdateSlider = UpdateSlider
ScienceResearching.Update = Update
return ScienceResearching
