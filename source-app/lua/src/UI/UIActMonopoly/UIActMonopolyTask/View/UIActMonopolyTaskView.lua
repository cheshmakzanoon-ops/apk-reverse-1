local UIActMonopolyTaskView = BaseClass("UIActMonopolyTaskView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIActMonopolyTaskItem = require("UI.UIActMonopoly.UIActMonopolyTask.Component.UIActMonopolyTaskItem")
local closeBtn_path = "UICommonPopUpTitle/CloseBtn"
local colsebg_path = "UICommonPopUpTitle/panel"
local desc_path = "contentView/UIActMonopolySpecialTaskItem/Desc"
local desc2_path = "contentView/UIActMonopolySpecialTaskItem/Desc2"
local introBtn_path = "contentView/UIActMonopolySpecialTaskItem/IntroBtn"
local uiCommonResItem_path = "contentView/UIActMonopolySpecialTaskItem/UICommonResItem"
local content_path = "contentView/UIActMonopolySpecialTaskItem/RewardScroll/Content"
local receiveBtn_path = "contentView/UIActMonopolySpecialTaskItem/ReceiveBtn"
local completedContent_path = "contentView/UIActMonopolySpecialTaskItem/CompletedContent"
local scrollView_path = "contentView/ScrollView"

local function OnCreate(self)
  base.OnCreate(self)
  self.activityId = self:GetUserData()
  self.activityId = tonumber(self.activityId)
  self.activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  self.activityDetailData = DataCenter.ActTaskManager:GetActData(self.activityId)
  local haveGetStage = #self.activityDetailData.score_receives
  local maxStage = #self.activityDetailData.achieveArr
  local targetStage = haveGetStage + 1
  if maxStage < targetStage then
    targetStage = maxStage
  end
  self.haveGetStage = haveGetStage
  self.targetStage = targetStage
  self.targetScoreData = self.activityDetailData.achieveArr[targetStage]
  self.close_btn = self:AddComponent(UIButton, closeBtn_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.colsebg = self:AddComponent(UIButton, colsebg_path)
  self.colsebg:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.introBtn = self:AddComponent(UIButton, introBtn_path)
  self.introBtn:SetOnClick(function()
    self:OnIntroBtnClick()
  end)
  self.desc = self:AddComponent(UIText, desc_path)
  self.desc2 = self:AddComponent(UIText, desc2_path)
  self.resItems = {}
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.uiCommonResItem = self:AddComponent(UIBaseContainer, uiCommonResItem_path)
  self.uiCommonResItem:SetActive(false)
  self.uiCommonResItem.gameObject:GameObjectCreatePool()
  self.receiveBtn = self:AddComponent(UIButton, receiveBtn_path)
  self.receiveBtn:SetOnClick(function()
    self:OnReceiveBtnClick()
  end)
  self.completedContent = self:AddComponent(UIBaseContainer, completedContent_path)
  self.taskContent = self:AddComponent(UIScrollView, scrollView_path)
  self.taskContent:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreateCell(itemObj, index)
  end)
  self.taskContent:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeleteCell(itemObj, index)
  end)
  self:RefreshView()
  self:PlayOpenAni()
end

local function OnDestroy(self)
  self:ClearAllItem()
  base.OnDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.GetActTaskDataUpdateMsg, self.OnGetTaskDataChangeMsg)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.GetActTaskDataUpdateMsg, self.OnGetTaskDataChangeMsg)
end

local function ClearAllItem(self)
  self.content:RemoveComponents(UICommonResItem)
  for _, v in ipairs(self.content.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  self.uiCommonResItem.gameObject:GameObjectRecycleAll()
  self.resItems = {}
end

local function RefreshView(self)
  self.taskShowData = {}
  self.taskShowDict = {}
  for k, v in pairs(self.activityDetailData.taskArrDict) do
    local temp = DataCenter.ActivityTaskTemplateManager:GetActTaskTemplate(v.taskId)
    local team = string.IsNullOrEmpty(temp.team) and "taskId" .. v.taskId or temp.team
    if self.taskShowDict[team] == nil then
      self.taskShowDict[team] = {
        team = team,
        targetTaskData = nil,
        taskDataList = {}
      }
    end
    local taskData = {data = v, temp = temp}
    table.insert(self.taskShowDict[team].taskDataList, taskData)
  end
  for k, v in pairs(self.taskShowDict) do
    table.sort(v.taskDataList, function(a, b)
      return a.data.taskId < b.data.taskId
    end)
    for _, data in ipairs(v.taskDataList) do
      v.targetTaskData = data
      if data.data.state ~= TaskState.Received then
        break
      end
    end
    table.insert(self.taskShowData, v)
  end
  table.sort(self.taskShowData, function(a, b)
    local aTaskState = a.targetTaskData.data.state
    local bTaskState = b.targetTaskData.data.state
    if aTaskState == bTaskState then
      return a.targetTaskData.data.taskId < b.targetTaskData.data.taskId
    end
    if aTaskState == TaskState.CanReceive or bTaskState == TaskState.CanReceive then
      return aTaskState == TaskState.CanReceive
    elseif aTaskState == TaskState.Received or bTaskState == TaskState.Received then
      return bTaskState == TaskState.Received
    end
  end)
  self.desc:SetText(Localization:GetString("snow_season_UI0022", self.targetScoreData.targetScore))
  self.desc2:SetText(Localization:GetString("snow_season_UI0023", self.activityDetailData.achieve_score, self.targetScoreData.targetScore))
  if self.haveGetStage < self.targetStage then
    self.receiveBtn:SetActive(true)
    self.completedContent:SetActive(false)
    if self.activityDetailData.achieve_score >= self.targetScoreData.targetScore then
      CS.UIGray.SetGray(self.receiveBtn.transform, false, true)
    else
      CS.UIGray.SetGray(self.receiveBtn.transform, true, true)
    end
  else
    self.receiveBtn:SetActive(false)
    self.completedContent:SetActive(true)
  end
  local dataNum = #self.targetScoreData.reward
  local itemNum = #self.resItems
  if dataNum ~= itemNum then
    self:ClearAllItem()
    for i = 1, dataNum do
      local index = i
      local item = self.uiCommonResItem.gameObject:GameObjectSpawn(self.content.transform)
      item.name = index
      local obj = self.content:AddComponent(UICommonResItem, item.name)
      obj:SetActive(true)
      self.resItems[index] = obj
    end
  end
  local showList = DataCenter.RewardManager:ReturnRewardParamForView(self.targetScoreData.reward)
  for i = 1, dataNum do
    self.resItems[i]:ReInit(showList[i])
  end
  local count = #self.taskShowData
  self.taskContent:SetTotalCount(count)
  if 0 < count then
    self.taskContent:RefillCells()
  end
end

local function PlayOpenAni(self)
end

local function OnGetTaskDataChangeMsg(self)
  if self.activityDetailData == nil then
    return
  end
  self.activityId = tonumber(self.activityId)
  self.activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  self.activityDetailData = DataCenter.ActTaskManager:GetActData(self.activityId)
  local haveGetStage = #self.activityDetailData.score_receives
  local maxStage = #self.activityDetailData.achieveArr
  local targetStage = haveGetStage + 1
  if maxStage < targetStage then
    targetStage = maxStage
  end
  self.haveGetStage = haveGetStage
  self.targetStage = targetStage
  self.targetScoreData = self.activityDetailData.achieveArr[targetStage]
  self:RefreshView()
end

local function OnIntroBtnClick(self)
  if self.activityInfo ~= nil and self.activityInfo.story ~= nil then
    local param = {}
    param.activityId = self.activityId
    param.activityRulesStr = Localization:GetString(self.activityInfo.story)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
  end
end

local function OnCreateCell(self, itemObj, index)
  itemObj.name = tostring(index)
  local item = self.taskContent:AddComponent(UIActMonopolyTaskItem, itemObj)
  item:SetData(self.activityId, self.taskShowData[index].targetTaskData.data)
end

local function OnDeleteCell(self, itemObj, index)
  self.taskContent:RemoveComponent(itemObj.name, UIActMonopolyTaskItem)
end

local function OnReceiveBtnClick(self)
  if self.activityDetailData.achieve_score >= self.targetScoreData.targetScore then
    SFSNetwork.SendMessage(MsgDefines.ActivityScoreReward, self.activityId, #self.activityDetailData.score_receives)
  else
  end
end

UIActMonopolyTaskView.OnCreate = OnCreate
UIActMonopolyTaskView.OnDestroy = OnDestroy
UIActMonopolyTaskView.OnAddListener = OnAddListener
UIActMonopolyTaskView.OnRemoveListener = OnRemoveListener
UIActMonopolyTaskView.ClearAllItem = ClearAllItem
UIActMonopolyTaskView.RefreshView = RefreshView
UIActMonopolyTaskView.PlayOpenAni = PlayOpenAni
UIActMonopolyTaskView.OnIntroBtnClick = OnIntroBtnClick
UIActMonopolyTaskView.OnCreateCell = OnCreateCell
UIActMonopolyTaskView.OnDeleteCell = OnDeleteCell
UIActMonopolyTaskView.OnReceiveBtnClick = OnReceiveBtnClick
UIActMonopolyTaskView.OnGetTaskDataChangeMsg = OnGetTaskDataChangeMsg
return UIActMonopolyTaskView
