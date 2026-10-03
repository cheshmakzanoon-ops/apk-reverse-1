local base = UIBaseView
local UIActSnowStormWorldInfo = BaseClass("UIActSnowStormWorldInfo", base)
local UIActSnowStormWorldInfoArea = require("UI.LWSeason.LWSeasonSnowStormWorldInfo.Component.UIActSnowStormWorldInfoArea")
local panelBtn_path = "UICommonPopUpTitle/panel"
local title_path = "safeArea/Root/titleText"
local closeBtn_path = "safeArea/Root/CloseBtn"
local worldInfo_path = "safeArea/Root/worldInfo"
local toggle_path = {
  "safeArea/Root/tabSv/Viewport/Content/Toggle1",
  "safeArea/Root/tabSv/Viewport/Content/Toggle2",
  "safeArea/Root/tabSv/Viewport/Content/Toggle3"
}

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
  self.panelBtn = self:AddComponent(UIButton, panelBtn_path)
  self.title = self:AddComponent(UIText, title_path)
  self.closeBtn = self:AddComponent(UIButton, closeBtn_path)
  self.worldInfo = self:AddComponent(UIActSnowStormWorldInfoArea, worldInfo_path)
  self.toggle = {
    self:AddComponent(UIToggle, toggle_path[1]),
    self:AddComponent(UIToggle, toggle_path[2]),
    self:AddComponent(UIToggle, toggle_path[3])
  }
  for index, value in ipairs(self.toggle) do
    value:SetOnValueChanged(function(t)
      if t then
        self:ShowPage(index)
      end
    end)
  end
  self.panelBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.curTabType = nil
  self.toggle[1]:SetIsOnWithoutNotify(true)
  self:ShowPage(1)
end

local function ComponentDestroy(self)
  self.panelBtn = nil
  self.title = nil
  self.closeBtn = nil
  self.worldInfo = nil
  self.toggle = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function UIActSnowStormWorldInfo:ShowPage(tabType)
  if self.curTabType ~= tabType then
    self.curTabType = tabType
    self.worldInfo:Show(tabType)
  end
end

UIActSnowStormWorldInfo.OnCreate = OnCreate
UIActSnowStormWorldInfo.OnDestroy = OnDestroy
UIActSnowStormWorldInfo.OnEnable = OnEnable
UIActSnowStormWorldInfo.OnDisable = OnDisable
UIActSnowStormWorldInfo.ComponentDefine = ComponentDefine
UIActSnowStormWorldInfo.ComponentDestroy = ComponentDestroy
UIActSnowStormWorldInfo.DataDefine = DataDefine
UIActSnowStormWorldInfo.DataDestroy = DataDestroy
return UIActSnowStormWorldInfo
