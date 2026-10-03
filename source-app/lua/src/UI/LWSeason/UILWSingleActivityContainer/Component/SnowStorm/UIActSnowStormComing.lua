local base = UIBaseContainer
local UIActSnowStormComing = BaseClass("UIActSnowStormComing", base)
local UISnowStormTaskItem = require("UI.LWSeason.UILWSingleActivityContainer.Component.SnowStorm.UISnowStormTaskItem")
local Localization = CS.GameEntry.Localization
local SnowStormFurnaceRender = require("UI.LWSeason.UILWSingleActivityContainer.Component.SnowStorm.SnowStormFurnaceRender")
local title_path = "content/title"
local description_path = "content/description"
local stormName_path = "content/timeInfo/stormName"
local countdown_path = "content/timeInfo/countdown"
local rewardBtn_path = "content/rightTop/RewardBtn/RewardBtn"
local explainBtn_path = "content/rightTop/ExplainBtn"
local ScrollView_path = "content/TaskHolder/MScroll"
local content_path = "content"
local timeInfo_path = "content/timeInfo"
local taskHolder_path = "content/TaskHolder"
local furnaceHolder_path = "content/furnace"
local personalFurnace_path = "content/furnace/personal"
local allianceFurnace_path = "content/furnace/alliance"
local worldInfoBtn_path = "wolrdInfo"
local accessBtn_path = "content/furnace/warning/accessBtn"
local baseTemWarn_path = "content/furnace/warning/Image/baseWarning"
local jumpBtn_path = "jumpBtn"
local rewardDesGo_path = "content/rewardDes"
local warningGo_path = "content/Warning"
local infoBtn_path = "content/timeInfo/stormName/infoBtn"

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
  self.title = self:AddComponent(UIText, title_path)
  self.description = self:AddComponent(UIText, description_path)
  self.stormName = self:AddComponent(UIText, stormName_path)
  self.countdown = self:AddComponent(UIText, countdown_path)
  self.rewardBtn = self:AddComponent(UIButton, rewardBtn_path)
  self.explainBtn = self:AddComponent(UIButton, explainBtn_path)
  self.ScrollView = self:AddComponent(UIScrollView, ScrollView_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.timeInfo = self:AddComponent(UIBaseContainer, timeInfo_path)
  self.taskHolder = self:AddComponent(UIBaseContainer, taskHolder_path)
  self.furnaceHolder = self:AddComponent(UIBaseContainer, furnaceHolder_path)
  self.personalFurnace = self:AddComponent(SnowStormFurnaceRender, personalFurnace_path)
  self.allianceFurnace = self:AddComponent(SnowStormFurnaceRender, allianceFurnace_path)
  self.worldInfoBtn = self:AddComponent(UIButton, worldInfoBtn_path)
  self.accessBtn = self:AddComponent(UIButton, accessBtn_path)
  self.baseTemWarn = self:AddComponent(UIText, baseTemWarn_path)
  self.jumpBtn = self:AddComponent(UIButton, jumpBtn_path)
  self.rewardDesGo = self:AddComponent(UIBaseContainer, rewardDesGo_path)
  self.warningGo = self:AddComponent(UIBaseContainer, warningGo_path)
  self.infoBtn = self:AddComponent(UIButton, infoBtn_path)
  self.ScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnCellMoveIn(itemObj, index)
  end)
  self.ScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnCellMoveOut(itemObj, index)
  end)
  self.infoBtn:SetOnClick(function()
    self:InfoBtn()
  end)
  self.rewardBtn:SetOnClick(function()
    self:OnClickRewardBtn()
  end)
  self.explainBtn:SetOnClick(function()
    self:OnTipBtn()
  end)
  self.accessBtn:SetOnClick(function()
    self:AccessBtn()
  end)
  self.worldInfoBtn:SetOnClick(function()
    self:WorldInfoBtn()
  end)
  self.jumpBtn:SetOnClick(function()
    self:AccessBtn()
  end)
end

local function ComponentDestroy(self)
  self.title = nil
  self.description = nil
  self.stormName = nil
  self.countdown = nil
  self.rewardBtn = nil
  self.explainBtn = nil
  self.ScrollView = nil
  self.content = nil
  self.timeInfo = nil
  self.taskHolder = nil
  self.furnaceHolder = nil
  self.personalFurnace = nil
  self.allianceFurnace = nil
  self.worldInfoBtn = nil
  self.accessBtn = nil
  self.baseTemWarn = nil
  self.jumpBtn = nil
  self.rewardDesGo = nil
  self.warningGo = nil
  self.infoBtn = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function UIActSnowStormComing:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonSnowStormActivityDataUpdate, self.RefreshSelf)
  self:AddUIListener(EventId.ShowTaskSuccessReward, self.QuestRewardSuccess)
end

function UIActSnowStormComing:OnRemoveListener()
  self:RemoveUIListener(EventId.SeasonSnowStormActivityDataUpdate, self.RefreshSelf)
  self:RemoveUIListener(EventId.ShowTaskSuccessReward, self.QuestRewardSuccess)
  base.OnRemoveListener(self)
end

function UIActSnowStormComing:SetData(activityId, data)
  self.activityId = tonumber(activityId)
  if not self.activityId then
    return
  end
  self.activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if self.activityInfo == nil then
    return
  end
  self.title:SetLocalText(self.activityInfo.name)
  self.description:SetLocalText(self.activityInfo.desc_info)
  self.curActivity = DataCenter.SeasonSnowStormDataManager.curActivity
  DataCenter.SeasonSnowStormDataManager:RequestCurActivityInfo()
  self:RefreshPanel()
  self:Update1000MS()
end

function UIActSnowStormComing:RefreshPanel()
  self.state = nil
  if self.curActivity then
    self.content:SetActive(true)
    local state = DataCenter.SeasonSnowStormDataManager:GetActivityStateData()
    self.state = state
    self.warningGo:SetActive(state == ActivitySnowStormState.NoStart or state == ActivitySnowStormState.Warning or state == ActivitySnowStormState.SnowStorm)
    self.rewardDesGo:SetActive(state == ActivitySnowStormState.Reward)
    self.timeInfo:SetActive(state == ActivitySnowStormState.Warning or state == ActivitySnowStormState.SnowStorm or state == ActivitySnowStormState.Reward)
    self.stormName:SetActive(state ~= ActivitySnowStormState.Reward)
    if state == ActivitySnowStormState.NoStart then
      self.endTime = self.curActivity.startTime
      self:ShowNotStart()
    elseif state == ActivitySnowStormState.Warning then
      self.endTime = self.curActivity.stormStartTime
      self:ShowWarning()
    elseif state == ActivitySnowStormState.SnowStorm then
      self.endTime = self.curActivity.stormEndTime
      self:SnowStorm()
    elseif state == ActivitySnowStormState.Reward then
      self.endTime = self.curActivity.endTime
      self:ShowRewardTime()
    elseif state == ActivitySnowStormState.End then
      self:ShowNotStart()
      local seasonMain = UIManager:GetInstance():GetWindow(UIWindowNames.LWSeason2Main)
      if seasonMain and seasonMain.View and seasonMain.View.UpdateData then
        seasonMain.View:UpdateData(true)
      end
    end
  else
    self.content:SetActive(false)
  end
end

function UIActSnowStormComing:ShowWarning()
  self.taskHolder:SetActive(true)
  self.furnaceHolder:SetActive(false)
  self.worldInfoBtn:SetActive(false)
  self.jumpBtn:SetActive(true)
  local configId = self.curActivity.cfgId
  local eventConfig = LocalController:instance():getLine(TableName.StormEvent, configId)
  local dataTemperature = DataCenter.HeatSourceTemplateManager:GetTemplate(tonumber(eventConfig.env_temperature))
  self.stormName:SetLocalText("season_s2_storm_event_05", dataTemperature.level)
  self:ShowTask()
end

function UIActSnowStormComing:ShowNotStart()
  self.taskHolder:SetActive(false)
  self.furnaceHolder:SetActive(false)
  self.worldInfoBtn:SetActive(false)
  self.jumpBtn:SetActive(false)
  self.stormName:SetText("")
end

function UIActSnowStormComing:SnowStorm()
  self.furnaceHolder:SetActive(true)
  self.allianceFurnace:SetData(1)
  self.personalFurnace:SetData(2)
  self.taskHolder:SetActive(false)
  self.worldInfoBtn:SetActive(true)
  self.jumpBtn:SetActive(false)
  local temperature = DataCenter.TemperatureManager:GetMyBaseTemperature()
  local tempString = string.format("%.1f", temperature)
  if 0 <= temperature then
    local greenText = "<color=#56f565>(" .. Localization:GetString("season_s2_storm_event_24") .. ")</color>"
    local str = Localization:GetString("season_s2_storm_event_13", tempString, greenText)
    self.baseTemWarn:SetText(str)
    self.accessBtn:SetActive(false)
  else
    local redText = "<color=#ff4b4b>(" .. Localization:GetString("season_s2_storm_event_25") .. ")</color>"
    local str = Localization:GetString("season_s2_storm_event_13", tempString, redText)
    self.baseTemWarn:SetText(str)
    self.accessBtn:SetActive(true)
  end
  local configId = self.curActivity.cfgId
  local eventConfig = LocalController:instance():getLine(TableName.StormEvent, configId)
  local dataTemperature = DataCenter.HeatSourceTemplateManager:GetTemplate(tonumber(eventConfig.env_temperature))
  self.stormName:SetLocalText("season_s2_storm_event_06", dataTemperature.level)
end

function UIActSnowStormComing:ShowRewardTime()
  self.furnaceHolder:SetActive(false)
  self.allianceFurnace:SetData(1)
  self.personalFurnace:SetData(2)
  self.taskHolder:SetActive(true)
  self.worldInfoBtn:SetActive(true)
  self.jumpBtn:SetActive(false)
  self:ShowTask()
end

function UIActSnowStormComing:ShowTask()
  local configId = self.curActivity.cfgId
  local eventConfig = LocalController:instance():getLine(TableName.StormEvent, configId)
  local dataTemperature = DataCenter.HeatSourceTemplateManager:GetTemplate(tonumber(eventConfig.env_temperature))
  self.taskList = {}
  for index, value in ipairs(eventConfig.quest) do
    local taskData = DataCenter.TaskManager:FindTaskInfo(value)
    if taskData then
      local p = 0
      if taskData.state == TaskState.CanReceive then
        p = 3
      elseif taskData.state == TaskState.Received then
        p = 1
      else
        p = 2
      end
      local template = DataCenter.QuestTemplateManager:GetQuestTemplate(value)
      local data = {
        taskId = value,
        order = p,
        secondOrder = template.order
      }
      table.insert(self.taskList, data)
    end
  end
  table.sort(self.taskList, function(lkey, rkey)
    if lkey.order == rkey.order then
      if lkey.secondOrder == rkey.secondOrder then
        return lkey.taskId < rkey.taskId
      else
        return lkey.secondOrder > rkey.taskId
      end
    else
      return lkey.order > rkey.order
    end
  end)
  self:ClearScroll()
  local cnt = table.count(self.taskList)
  if cnt == 0 then
    self.ScrollView:SetActive(false)
  else
    if not self.ScrollView:GetActive() then
      self.ScrollView:SetActive(true)
    end
    self.ScrollView:SetTotalCount(#self.taskList)
    self.ScrollView:RefillCells()
  end
end

function UIActSnowStormComing:ClearScroll()
  self.ScrollView:ClearCells()
  self.ScrollView:RemoveComponents(UISnowStormTaskItem)
end

function UIActSnowStormComing:OnCellMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.ScrollView:AddComponent(UISnowStormTaskItem, itemObj)
  cellItem:SetData(self.taskList[index], rewardPrefab)
end

function UIActSnowStormComing:OnCellMoveOut(itemObj, index)
  self.ScrollView:RemoveComponent(itemObj.name, UISnowStormTaskItem)
end

function UIActSnowStormComing:Update1000MS()
  if not self.activityId then
    return
  end
  if self.activityInfo == nil then
    return
  end
  if self.state == nil or self.state == ActivitySnowStormState.End then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local leftTime = self.endTime - curTime
  if leftTime < 0 then
    self:RefreshPanel()
    return
  end
  local countDownTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
  self.countdown:SetText(countDownTimeStr)
end

function UIActSnowStormComing:OnClickRewardBtn()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActSnowStormReward, {anim = true}, UIActSnowStormRewardPanelType.SnowStormReward)
end

function UIActSnowStormComing:RefreshSelf()
  self.curActivity = DataCenter.SeasonSnowStormDataManager.curActivity
  self:RefreshPanel()
end

function UIActSnowStormComing:OnTipBtn()
  if self.activityInfo ~= nil and self.activityInfo.story ~= nil then
    local param = {}
    param.activityId = self.activityId
    param.activityRulesStr = Localization:GetString(self.activityInfo.story)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
  end
end

function UIActSnowStormComing:InfoBtn()
  local configId = self.curActivity.cfgId
  local eventConfig = LocalController:instance():getLine(TableName.StormEvent, configId)
  local dataTemperature = DataCenter.HeatSourceTemplateManager:GetTemplate(tonumber(eventConfig.env_temperature))
  local data = {}
  data.des = Localization:GetString("season_s2_storm_event_07", dataTemperature.level, dataTemperature.default_temperature)
  data.posX = self.infoBtn.transform.position.x
  data.posY = self.infoBtn.transform.position.y
  data.isLeft = false
  data.cellW = 0
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWCommonShowBubbleTip, {anim = true}, data)
end

function UIActSnowStormComing:AccessBtn()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UITemperatureMain, {anim = true}, 3)
end

function UIActSnowStormComing:WorldInfoBtn()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActSnowStormWorldInfo, {anim = true})
end

function UIActSnowStormComing:QuestRewardSuccess(msg)
  local state = DataCenter.SeasonSnowStormDataManager:GetActivityStateData()
  self.state = state
  if state == ActivitySnowStormState.Reward or state == ActivitySnowStormState.Warning then
    self:ShowTask()
    local t = {}
    t.reward = msg.reward
    DataCenter.RewardManager:ShowCommonReward(t)
    EventManager:GetInstance():Broadcast(EventId.SnowStormTaskSuccessReward)
  end
end

UIActSnowStormComing.OnCreate = OnCreate
UIActSnowStormComing.OnDestroy = OnDestroy
UIActSnowStormComing.OnEnable = OnEnable
UIActSnowStormComing.OnDisable = OnDisable
UIActSnowStormComing.ComponentDefine = ComponentDefine
UIActSnowStormComing.ComponentDestroy = ComponentDestroy
UIActSnowStormComing.DataDefine = DataDefine
UIActSnowStormComing.DataDestroy = DataDestroy
return UIActSnowStormComing
