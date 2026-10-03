local WorldRetryCollectDes = BaseClass("WorldRetryCollectDes", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local icon_path = "content/Image"
local des_txt_path = "content/desTxt"
local specialContent_path = "specialContent"
local specialTimeTxt_path = "specialContent/specialTimeTxt"
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
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.des_txt = self:AddComponent(UIText, des_txt_path)
  self.specialContent = self:AddComponent(UIBaseContainer, specialContent_path)
  self.specialTimeTxt = self:AddComponent(UIText, specialTimeTxt_path)
end

local function ComponentDestroy(self)
  self.icon = nil
  self.des_txt = nil
  self.specialContent = nil
  self.specialTimeTxt = nil
end

local function DataDefine(self)
  self.param = nil
  self.detectExpireTime = 0
end

local function DataDestroy(self)
  self.param = nil
  self.detectExpireTime = nil
end

local function RefreshData(self, param)
  self.data = param
  self.icon:LoadSprite(self.data.icon)
  self.des_txt:SetLocalText(self.data.des)
  local detectData = DataCenter.RadarCenterDataManager:GetDetectEventInfo(self.data.uuid)
  if detectData then
    self.detectExpireTime = detectData.endTime
  end
  self:Update1000MS()
end

local function Update1000MS(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.detectExpireTime and curTime < self.detectExpireTime then
    local remainTime = self.detectExpireTime - curTime
    local timeStr = UITimeManager:GetInstance():MilliSecondToFmtString(remainTime)
    self.specialTimeTxt:SetText(timeStr)
  else
    local timeStr = UITimeManager:GetInstance():MilliSecondToFmtString(0)
    self.specialTimeTxt:SetText(timeStr)
  end
end

WorldRetryCollectDes.OnCreate = OnCreate
WorldRetryCollectDes.OnDestroy = OnDestroy
WorldRetryCollectDes.OnEnable = OnEnable
WorldRetryCollectDes.OnDisable = OnDisable
WorldRetryCollectDes.ComponentDefine = ComponentDefine
WorldRetryCollectDes.ComponentDestroy = ComponentDestroy
WorldRetryCollectDes.DataDefine = DataDefine
WorldRetryCollectDes.DataDestroy = DataDestroy
WorldRetryCollectDes.RefreshData = RefreshData
WorldRetryCollectDes.Update1000MS = Update1000MS
return WorldRetryCollectDes
