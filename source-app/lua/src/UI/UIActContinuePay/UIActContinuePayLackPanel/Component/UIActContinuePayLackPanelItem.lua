local UIActContinuePayLackPanelItem = BaseClass("UIActContinuePayLackPanelItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local price_txt_path = "PriceText"
local times_txt_path = "TimesText"
local go_btn_path = "GoBtn"
local go_btn_text_path = "GoBtn/GoBtnText"
local receive_btn_path = "ReceiveBtn"
local receive_btn_txt_path = "ReceiveBtn/ReceiveBtnText"
local duigou_img_path = "duigouImg"
local progress_txt_path = "ProgressText"

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
  self.progress_txt = self:AddComponent(UIText, progress_txt_path)
  self.price_txt = self:AddComponent(UIText, price_txt_path)
  self.times_txt = self:AddComponent(UIText, times_txt_path)
  self.times_txt:SetLocalText("\231\188\186key")
  self.go_btn = self:AddComponent(UIButton, go_btn_path)
  self.go_btn:SetOnClick(function()
    self:OnGoClick()
  end)
  self.go_btn_text = self:AddComponent(UIText, go_btn_text_path)
  self.receive_btn = self:AddComponent(UIButton, receive_btn_path)
  self.receive_btn:SetOnClick(function()
    self:OnReceiveClick()
  end)
  self.receive_btn_txt = self:AddComponent(UIText, receive_btn_txt_path)
  self.duigou_img = self:AddComponent(UIImage, duigou_img_path)
end

local function ComponentDestroy(self)
  self.go_btn = nil
  self.receive_btn = nil
  self.duigou_img = nil
  self.go_btn_text = nil
  self.receive_btn_txt = nil
  self.price_txt = nil
  self.times_txt = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function UIActContinuePayLackPanelItem:SetData(taskId)
  self.activityId = DataCenter.ContinuePayActivityManager:GetActivityId()
  self.taskId = tonumber(taskId)
  if self.taskId then
    self.taskInfo = DataCenter.ActivityTaskTemplateManager:GetActTaskTemplate(self.taskId)
    local taskData = DataCenter.ContinuePayActivityManager:GetTaskDataByTaskId(self.taskId)
    self.taskValue = taskData
    self:RefreshShow()
  end
end

function UIActContinuePayLackPanelItem:RefreshShow()
  if not self.taskInfo or not self.taskValue then
    return
  end
  local process = ""
  local curNum = self.taskValue.num and self.taskValue.num or 0
  curNum = curNum / 100
  local targetNum = tonumber(self.taskInfo.para2) / 100
  if 0 <= curNum - targetNum then
    curNum = targetNum
  end
  curNum = DataCenter.PayManager:GetDisplayText(curNum)
  targetNum = DataCenter.PayManager:GetDisplayText(targetNum)
  process = curNum .. "/" .. targetNum
  self.price_txt:SetLocalText("\231\188\186key")
  self.progress_txt:SetText(process)
  local state = self.taskValue.state
  if state == TaskState.Received then
    self.duigou_img:SetActive(true)
    self.progress_txt:SetActive(false)
    self.receive_btn:SetActive(false)
    self.go_btn:SetActive(false)
  elseif state == TaskState.CanReceive then
    self.duigou_img:SetActive(false)
    self.progress_txt:SetActive(true)
    self.receive_btn:SetActive(true)
    self.go_btn:SetActive(false)
  else
    self.duigou_img:SetActive(false)
    self.progress_txt:SetActive(true)
    self.receive_btn:SetActive(false)
    self.go_btn:SetActive(true)
  end
end

function UIActContinuePayLackPanelItem:OnGoClick()
  if self.taskId and self.taskInfo then
    GoToUtil.GoToByQuestId(self.taskInfo)
  end
end

function UIActContinuePayLackPanelItem:OnReceiveClick()
  if self.taskId and self.taskValue and self.taskValue.state == TaskState.CanReceive then
    DataCenter.ContinuePayActivityManager:RequestGetTaskReward(self.activityId, self.taskId)
  end
end

UIActContinuePayLackPanelItem.OnCreate = OnCreate
UIActContinuePayLackPanelItem.OnDestroy = OnDestroy
UIActContinuePayLackPanelItem.OnEnable = OnEnable
UIActContinuePayLackPanelItem.OnDisable = OnDisable
UIActContinuePayLackPanelItem.ComponentDefine = ComponentDefine
UIActContinuePayLackPanelItem.ComponentDestroy = ComponentDestroy
UIActContinuePayLackPanelItem.DataDefine = DataDefine
UIActContinuePayLackPanelItem.DataDestroy = DataDestroy
return UIActContinuePayLackPanelItem
