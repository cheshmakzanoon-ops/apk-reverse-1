local base = UIBaseContainer
local InfoSetContent = BaseClass("InfoSetContent", base)
local Localization = CS.GameEntry.Localization
local BirthdayAgeItem = require("UI.Birthday.BirthdayDataSetPanel.Component.BirthdayAgeItem")

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
end

local function ComponentDestroy(self)
end

local function DataDefine(self)
  self.data = nil
  self.ageListData = nil
  self.nextChangeTime = nil
end

local function DataDestroy(self)
  self.data = nil
  self.ageListData = nil
  self.nextChangeTime = nil
end

function InfoSetContent:SetAgeListData(ageListData)
  self.ageListData = ageListData
end

function InfoSetContent:SetData(data)
  self.data = data
  if self.data.modifyNextTime then
    self.nextChangeTime = self.data.modifyNextTime
  end
  self:RefreshView()
  self:Update1000MS()
end

function InfoSetContent:RefreshItemView()
end

function InfoSetContent:OnClickItemFunc(key)
  self.data.age = key
  EventManager:GetInstance():Broadcast(EventId.BirthdaySetPanelShowDataChange)
end

function InfoSetContent:ClearAllItem()
end

function InfoSetContent:RefreshView()
  self:RefreshItemView()
end

function InfoSetContent:Update1000MS()
end

InfoSetContent.OnCreate = OnCreate
InfoSetContent.OnDestroy = OnDestroy
InfoSetContent.OnEnable = OnEnable
InfoSetContent.OnDisable = OnDisable
InfoSetContent.ComponentDefine = ComponentDefine
InfoSetContent.ComponentDestroy = ComponentDestroy
InfoSetContent.DataDefine = DataDefine
InfoSetContent.DataDestroy = DataDestroy
return InfoSetContent
