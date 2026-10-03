local base = UIBaseContainer
local SeasonPreviewProgressItem = BaseClass("SeasonPreviewProgressItem", base)
local Localization = CS.GameEntry.Localization
local icon_path = "Icon"
local select_path = "Select"
local today_path = "Today"
local box_path = "Box"
local button_path = "Button"
local grayBox_path = "GrayBox"

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
  self.icon = self:AddComponent(UIBaseContainer, icon_path)
  self.select = self:AddComponent(UIBaseContainer, select_path)
  self.today = self:AddComponent(UIBaseContainer, today_path)
  self.box = self:AddComponent(UIImage, box_path)
  self.button = self:AddComponent(UIButton, button_path)
  self.grayBox = self:AddComponent(UIImage, grayBox_path)
  self.button:SetOnClick(function()
    self:OnItemClick()
  end)
end

local function ComponentDestroy(self)
  self.icon = nil
  self.select = nil
  self.today = nil
  self.box = nil
  self.button = nil
  self.grayBox = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function SetData(self, index, clickHandle)
  self.index = index
  self.clickHandle = clickHandle
  local list = DataCenter.SeasonPreviewManager:GetTaskList()
  local selectingIndex = DataCenter.SeasonPreviewManager:GetSelectingIndex()
  local todayIndex = DataCenter.SeasonPreviewManager:GetTodayIndex()
  self.data = list[index]
  local now = UITimeManager:GetInstance():GetServerTime()
  self.icon:SetActive(now > self.data.dayTime)
  self.today:SetActive(todayIndex == index)
  self.select:SetActive(index == selectingIndex)
  self.box:SetActive(self.data.state == 1)
  self.grayBox:SetActive(self.data.state == 0 and now > self.data.dayTime)
end

local function OnItemClick(self)
  if self.clickHandle then
    pcall(self.clickHandle, self.index)
  end
  if self.data == nil then
    return
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  if self.data.state ~= 1 and (self.data.state ~= 0 or not (now > self.data.dayTime)) then
    return
  end
  if self.data.state == 0 then
    local desc = Localization:GetString("302026")
    local activityType = DataCenter.SeasonPreviewManager.activityType
    local x = self.grayBox.transform.position.x
    local y = self.grayBox.transform.position.y
    local offset = 0
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityRewardTip, desc, activityType, x, y, self.index < 4, self.index, self.grayBox.rectTransform.rect.width * 2)
  elseif self.data.state == 1 then
    DataCenter.SeasonPreviewManager:GetReward(self.data.taskId)
  end
end

SeasonPreviewProgressItem.OnCreate = OnCreate
SeasonPreviewProgressItem.OnDestroy = OnDestroy
SeasonPreviewProgressItem.OnEnable = OnEnable
SeasonPreviewProgressItem.OnDisable = OnDisable
SeasonPreviewProgressItem.ComponentDefine = ComponentDefine
SeasonPreviewProgressItem.ComponentDestroy = ComponentDestroy
SeasonPreviewProgressItem.DataDefine = DataDefine
SeasonPreviewProgressItem.DataDestroy = DataDestroy
SeasonPreviewProgressItem.SetData = SetData
SeasonPreviewProgressItem.OnItemClick = OnItemClick
return SeasonPreviewProgressItem
