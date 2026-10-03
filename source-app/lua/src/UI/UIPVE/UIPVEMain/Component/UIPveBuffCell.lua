local UIPveBuffCell = BaseClass("UIPveBuffCell", UIBaseContainer)
local base = UIBaseContainer
local slider_text_path = "TimeText"
local slider_icon_path = "BuffIcon"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.slider_text = self:AddComponent(UIText, slider_text_path)
  self.slider_icon = self:AddComponent(UIImage, slider_icon_path)
end

local function ComponentDestroy(self)
  self.slider_text = nil
  self.slider_icon = nil
end

local function DataDefine(self)
  self.param = nil
  self.laseTime = nil
end

local function DataDestroy(self)
  self.param = nil
  self.laseTime = nil
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function ReInit(self, param)
  self.param = param
  local template = DataCenter.PveBuffTemplateManager:GetTemplate(param.id)
  if template ~= nil then
    self.allNum = template.time * 1000
    self.slider_icon:LoadSprite(string.format(LoadPath.PVEScene, template.pic))
  end
end

local function ChangeTime(self, time)
  self.param.endTime = time
end

local function RefreshNum(self, curTime)
  if DataCenter.BattleLevel:IsPaused() then
    self.param.endTime = self.param.endTime + Time.unscaledDeltaTime * 1000
  end
  local leftTime = self.param.endTime - curTime
  local tempTimeSec = math.ceil(leftTime / 1000)
  if tempTimeSec ~= self.laseTime then
    self.laseTime = tempTimeSec
    local tempTimeValue = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
    self.slider_text:SetText(tempTimeValue)
  end
end

UIPveBuffCell.OnCreate = OnCreate
UIPveBuffCell.OnDestroy = OnDestroy
UIPveBuffCell.ComponentDefine = ComponentDefine
UIPveBuffCell.ComponentDestroy = ComponentDestroy
UIPveBuffCell.DataDefine = DataDefine
UIPveBuffCell.DataDestroy = DataDestroy
UIPveBuffCell.OnEnable = OnEnable
UIPveBuffCell.OnDisable = OnDisable
UIPveBuffCell.OnAddListener = OnAddListener
UIPveBuffCell.OnRemoveListener = OnRemoveListener
UIPveBuffCell.ChangeTime = ChangeTime
UIPveBuffCell.RefreshNum = RefreshNum
UIPveBuffCell.ReInit = ReInit
return UIPveBuffCell
