local UIRadarNormalEvent = BaseClass("UIRadarNormalEvent", UIBaseContainer)
local base = UIBaseContainer
local info_btn_path = "NormalInfoBtn"
local num_text_path = "NormalEventNumText"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function ComponentDefine(self)
  self.infoBtn = self:AddComponent(UIButton, info_btn_path)
  self.num_text = self:AddComponent(UIText, num_text_path)
end

local function DataDefine(self)
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function SetData(self, curNum, totalNum)
  self.curNum = curNum
  self.totalNum = totalNum
  self:RefreshView()
end

local function RefreshView(self)
  self.num_text:SetText(tostring(self.curNum) .. "/" .. tostring(self.totalNum))
end

local function ComponentDestroy(self)
end

local function DataDestroy(self)
end

local function OnInfoClick(self)
  if self.view.normalInfo == nil or not self.view.normalInfo:GetActive() then
    self.view:ShowNormalInfo()
  else
    self.view:HideNormalInfo()
  end
end

UIRadarNormalEvent.OnCreate = OnCreate
UIRadarNormalEvent.OnDestroy = OnDestroy
UIRadarNormalEvent.ComponentDefine = ComponentDefine
UIRadarNormalEvent.ComponentDestroy = ComponentDestroy
UIRadarNormalEvent.DataDefine = DataDefine
UIRadarNormalEvent.DataDestroy = DataDestroy
UIRadarNormalEvent.OnInfoClick = OnInfoClick
UIRadarNormalEvent.SetData = SetData
UIRadarNormalEvent.RefreshView = RefreshView
return UIRadarNormalEvent
