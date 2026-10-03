local UICityEventZombieSeaRewardsView = BaseClass("UICityEventZombieSeaRewardsView", UIBaseView)
local StageSecondAchieveItem = require("UI.UICityEventZombieSeaReward.Component.UICityEventZombieSeaSecondAchieveItem")
local StageFirstAchieveItem = require("UI.UICityEventZombieSeaReward.Component.UICityEventZombieSeaFirstAchieveItem")
local StageFirstGoalItem = require("UI.UICityEventZombieSeaReward.Component.UICityEventZombieSeaFirstGoalsItem")
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local txt_title_path = "bg/top/txtTitle"
local txt_subTitle_path = "bg/top/txtSubTitle"
local btn_close_path = "bg/top/btnClose"
local black_path = "black"
local txt_timer_path = "bg/top/Timer/txtTime"
local stage_second_panel_path = "bg/StageSecond"
local stage_second_Title_path = "bg/StageSecond/txtStageSecondTitle"
local stage_second_scroll_achieve_path = "bg/StageSecond/bg2/stageSecondScrollAchieve"
local stage_first_panel_path = "bg/StageFirst"
local stage_first_Slider_path = "bg/StageFirst/FirstPagePanel/ProgressGo/Progress/Slider"
local stage_first_goals_Path = "bg/StageFirst/FirstPagePanel/ProgressGo/Progress/Goals/GoalItem%d"
local stage_first_goalsProgresValue = {
  0.4,
  0.7,
  1
}
local stage_first_btn_receive = "bg/StageFirst/FirstPagePanel/PageRewardItem/btnReceive"
local stage_first_txt_receive = "bg/StageFirst/FirstPagePanel/PageRewardItem/btnReceive/txtReceive"
local stage_first_img_Received = "bg/StageFirst/FirstPagePanel/PageRewardItem/btnReceive/imgReceived"
local stage_first_img_NoComplete = "bg/StageFirst/FirstPagePanel/PageRewardItem/btnReceive/imgNoComplete"
local stage_first_Reward_item = "bg/StageFirst/FirstPagePanel/PageRewardItem/scrollRewards/rewardTemplate"
local stage_first_Reward_item_Content = "bg/StageFirst/FirstPagePanel/PageRewardItem/scrollRewards/Viewport/Content"
local stage_first_scroll_achieve_path = "bg/StageFirst/FirstRewardsPanel/firstScrollAchieve"
local stage_first_Title_path = "bg/StageFirst/FirstRewardsPanel/txtFirstRewardsTitle"
local main_animatorPath = ""
local GO_BUTTON_TXT = "110003"
local RECEIVE_BUTTON_TXT = "170004"
local ALREADY_RECEIVE = "170003"
local firstPagesTitle = {
  "city_event_desc70",
  "city_event_desc71",
  "city_event_desc72"
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
  self.txt_title = self:AddComponent(UITextMeshProUGUIEx, txt_title_path)
  self.txt_subTitle = self:AddComponent(UITextMeshProUGUIEx, txt_subTitle_path)
  self.btn_close = self:AddComponent(UIButton, btn_close_path)
  local cityEventName = DataCenter.LWBeginnerDirectorManager:GetCurCityEventName()
  self.txt_title:SetLocalText(cityEventName)
  local cityEventDesc = DataCenter.LWBeginnerDirectorManager:GetCurCityEventDesc()
  self.txt_subTitle:SetLocalText(cityEventDesc)
  self.btn_close:SetOnClick(function()
    self:CloseWithAnim()
  end)
  self.black = self:AddComponent(UIButton, black_path)
  self.black:SetOnClick(function()
    self:CloseWithAnim()
  end)
  self.txt_Timer = self:AddComponent(UITextMeshProUGUIEx, txt_timer_path)
  self.stageSecondPanel = self:AddComponent(UIBaseContainer, stage_second_panel_path)
  self.stageSecondTitle = self:AddComponent(UITextMeshProUGUIEx, stage_second_Title_path)
  self.stageSecondTitle:SetLocalText("city_event_desc55")
  self.stageSecondScrollAchieve = self:AddComponent(UIDynamicVerticleScrollRectEx, stage_second_scroll_achieve_path)
  self.stageSecondItemIncNo = 1
  self.stageSecondItemMap = {}
  self.stageSecondScrollAchieve:AddInstantiateItemListener(function(itemObj, prefabIdx)
    itemObj.name = "stageSecondAchieveItem_" .. self.stageSecondItemIncNo
    self.stageSecondItemIncNo = self.stageSecondItemIncNo + 1
    local achieveItem = self:AddComponent(StageSecondAchieveItem, itemObj)
    self.stageSecondItemMap[itemObj] = achieveItem
  end)
  self.stageSecondScrollAchieve:AddDisplayItemListener(function(itemObj, dataIdx)
    local achieveItem = self.stageSecondItemMap[itemObj]
    local data = self.rewardDatas[dataIdx + 1]
    achieveItem:Refresh(data)
  end)
  self.stageFirstPanel = self:AddComponent(UIBaseContainer, stage_first_panel_path)
  self.stageFirstSlider = self:AddComponent(UISlider, stage_first_Slider_path)
  self.stageFirstSubTitle = self:AddComponent(UITextMeshProUGUIEx, stage_first_Title_path)
  self.stageFirstGoals = {}
  for i = 1, 3 do
    self.stageFirstGoals[i] = self:AddComponent(StageFirstGoalItem, string.format(stage_first_goals_Path, i))
  end
  self.stageFirstBtnReceive = self:AddComponent(UIButton, stage_first_btn_receive)
  self.stageFirstBtnReceive:SetOnClick(function()
    local curShowPageState = self.firstStagePageState[self.showFirstStagePageIndex] or TaskState.NoComplete
    if curShowPageState == TaskState.CanReceive then
      SFSNetwork.SendMessage(MsgDefines.LWBeginnerCityEventPageReward, BeginnerDirectorEvent.ZombieSeaFirstStage, self.showFirstStagePageIndex - 1)
    end
  end)
  self.stageFirstTxtReceive = self:AddComponent(UITextMeshProUGUIEx, stage_first_txt_receive)
  self.stageFirstImgReceived = self:AddComponent(UIImage, stage_first_img_Received)
  self.stageFirstImgNoComplete = self:AddComponent(UIImage, stage_first_img_NoComplete)
  self.stageFirstRewardItem = self:AddComponent(UIBaseContainer, stage_first_Reward_item)
  self.stageFirstRewardItemGameObject = self.stageFirstRewardItem.gameObject
  self.stageFirstRewardItemGameObject:SetActive(false)
  self.stageFirstRewardItemGameObject:GameObjectCreatePool()
  self.stageFirstRewardContent = self:AddComponent(UIBaseContainer, stage_first_Reward_item_Content)
  self.stageFirstScrollAchieve = self:AddComponent(UIDynamicVerticleScrollRectEx, stage_first_scroll_achieve_path)
  self.stageFristItemIncNo = 1
  self.stageFirstItemMap = {}
  self.stageFirstScrollAchieve:AddInstantiateItemListener(function(itemObj, prefabIdx)
    itemObj.name = "stageFirstAchieveItem_" .. self.stageFristItemIncNo
    self.stageFristItemIncNo = self.stageFristItemIncNo + 1
    local achieveItem = self:AddComponent(StageFirstAchieveItem, itemObj)
    self.stageFirstItemMap[itemObj] = achieveItem
  end)
  self.stageFirstScrollAchieve:AddDisplayItemListener(function(itemObj, dataIdx)
    local achieveItem = self.stageFirstItemMap[itemObj]
    local data = self.rewardDatas[dataIdx + 1]
    achieveItem:Refresh(data)
  end)
  self.mainAnimator = self:AddComponent(UIAnimator, main_animatorPath)
  self:ReInit()
end

local function ComponentDestroy(self)
  if self.closeAnimTimer then
    self.closeAnimTimer:Stop()
    self.closeAnimTimer = nil
  end
  if self.AniToLoopTimer then
    self.AniToLoopTimer:Stop()
    self.AniToLoopTimer = nil
  end
  self.stageFirstRewardContent:RemoveComponents(UICommonResItem)
  self.stageFirstRewardItemGameObject:GameObjectRecycleAll()
  self.txt_title = nil
  self.txt_subTitle = nil
  self.btn_close = nil
  self.black = nil
  self.txt_Timer = nil
  self.stageSecondPanel = nil
  self.stageSecondTitle = nil
  self.stageSecondScrollAchieve = nil
  self.stageFirstPanel = nil
  self.stageFirstSlider = nil
  self.stageFirstBtnReceive = nil
  self.stageFirstTxtReceive = nil
  self.stageFirstImgReceived = nil
  self.stageFirstImgNoComplete = nil
  self.stageFirstRewardItem = nil
  self.stageFirstRewardItemGameObject = nil
  self.stageFirstRewardContent = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.stageSecondItemIncNo = nil
  self.stageSecondItemMap = nil
  self.stageFirstGoals = nil
  self.showFirstStagePageIndex = nil
  self.firstStagePageState = nil
  self.stageFirstItemMap = nil
  self.rewardDatas = nil
  self.cityEventId = nil
end

function UICityEventZombieSeaRewardsView:ReInit()
  self.valid = false
  local cityEventId = DataCenter.LWBeginnerDirectorManager:GetCurCityEventID()
  if cityEventId ~= BeginnerDirectorEvent.ZombieSeaFirstStage and cityEventId ~= BeginnerDirectorEvent.ZombieSeaSecondStage then
    self:CloseWithAnim()
    return
  end
  if DataCenter.LWBeginnerDirectorManager:IsCurCityEventAllTaskReceived() then
    self:CloseWithAnim()
    return
  end
  self.valid = true
  self.endTime = DataCenter.LWBeginnerDirectorManager:GetCurCityEventEndTime()
  self:UpdateTime()
  local key = "ZombieSeaFirstOpen_" .. cityEventId
  local alreadyShowed = CommonUtil.PlayerPrefsGetBool(key, false)
  local animationIn = not self.cityEventId or self.cityEventId ~= cityEventId
  local animationInName, animationLoopName
  if cityEventId == BeginnerDirectorEvent.ZombieSeaFirstStage then
    animationInName = "V_ui_UICityEventZombieSeaRewards_in_1"
    animationLoopName = "V_ui_UICityEventZombieSeaRewards_loop_1"
    self:ShowFirstState()
  elseif cityEventId == BeginnerDirectorEvent.ZombieSeaSecondStage then
    animationInName = "V_ui_UICityEventZombieSeaRewards_in"
    animationLoopName = "V_ui_UICityEventZombieSeaRewards_loop"
    self:ShowSecondState()
  end
  if self.mainAnimator and animationIn then
    if not alreadyShowed then
      if self.AniToLoopTimer then
        self.AniToLoopTimer:Stop()
        self.AniToLoopTimer = nil
      end
      local success, time = self.mainAnimator:PlayAnimationReturnTime(animationInName)
      if success then
        self.AniToLoopTimer = TimerManager:GetInstance():DelayInvoke(function()
          self.mainAnimator:Play(animationLoopName, 0, 0)
          self.AniToLoopTimer:Stop()
          self.AniToLoopTimer = nil
          CommonUtil.PlayerPrefsSetBool(key, true)
        end, time)
      else
        self.mainAnimator:Play(animationLoopName, 0, 0)
        CommonUtil.PlayerPrefsSetBool(key, true)
      end
    else
      self.mainAnimator:Play(animationLoopName, 0, 0)
    end
  end
  self.cityEventId = cityEventId
end

function UICityEventZombieSeaRewardsView:ShowSecondState()
  self.stageSecondPanel:SetActive(true)
  self.stageFirstPanel:SetActive(false)
  local cityEventTaskArr = DataCenter.LWBeginnerDirectorManager:GetCurCityEventTaskArr() or {}
  table.sort(cityEventTaskArr, function(a, b)
    if a.state ~= b.state and (a.state > 1 or b.state > 1) then
      return a.state < b.state
    else
      local taskIdA = tonumber(a.taskId)
      local taskIdB = tonumber(b.taskId)
      return taskIdA < taskIdB
    end
  end)
  self.rewardDatas = cityEventTaskArr
  self.stageSecondScrollAchieve:SetDatas(cityEventTaskArr)
  self.stageSecondScrollAchieve:UpdateItems()
end

function UICityEventZombieSeaRewardsView:ShowFirstState()
  self.stageFirstPanel:SetActive(true)
  self.stageSecondPanel:SetActive(false)
  local pageStates = DataCenter.LWBeginnerDirectorManager:GetCurCityEventPages()
  local pageTasks = DataCenter.LWBeginnerDirectorManager:GetCurCityEventPageTasks()
  self.showFirstStagePageIndex = 1
  self.firstStagePageState = {}
  self.stageFirstSlider:SetValue(0)
  local goalCount = #self.stageFirstGoals
  for goalIndex = 1, goalCount do
    local goal = self.stageFirstGoals[goalIndex]
    local goalState = TaskState.NoComplete
    local goalPageState = pageStates[goalIndex]
    if goalPageState and goalPageState == 1 then
      goalState = TaskState.Received
      local fillProgressValue = stage_first_goalsProgresValue[goalIndex]
      self.stageFirstSlider:SetValue(fillProgressValue)
      self.showFirstStagePageIndex = math.min(goalIndex + 1, goalCount)
    else
      local pageTask = pageTasks[goalIndex]
      local allTaskComplete = true
      for i, task in ipairs(pageTask) do
        if task.state == TaskState.NoComplete then
          allTaskComplete = false
          break
        end
      end
      if allTaskComplete and self.showFirstStagePageIndex == goalIndex then
        goalState = TaskState.CanReceive
        local fillProgressValue = stage_first_goalsProgresValue[goalIndex]
        self.stageFirstSlider:SetValue(fillProgressValue)
      else
        goalState = TaskState.NoComplete
      end
    end
    goal:SetState(goalState)
    self.firstStagePageState[goalIndex] = goalState
  end
  local curShowTaskState = self.firstStagePageState[self.showFirstStagePageIndex] or TaskState.NoComplete
  self.stageFirstImgReceived:SetActive(curShowTaskState == TaskState.Received or curShowTaskState == TaskState.NoComplete)
  self.stageFirstImgNoComplete:SetActive(false)
  self.stageFirstSubTitle:SetLocalText(firstPagesTitle[self.showFirstStagePageIndex])
  if curShowTaskState == TaskState.Received then
    self.stageFirstTxtReceive:SetLocalText(ALREADY_RECEIVE)
  elseif curShowTaskState == TaskState.CanReceive or curShowTaskState == TaskState.NoComplete then
    self.stageFirstTxtReceive:SetLocalText(RECEIVE_BUTTON_TXT)
  end
  local pageRewards = DataCenter.LWBeginnerDirectorManager:GetCurCityEventPageRewards()
  local showPageReward = pageRewards[self.showFirstStagePageIndex]
  self.stageFirstRewardContent:RemoveComponents(UICommonResItem)
  self.stageFirstRewardItemGameObject:GameObjectRecycleAll()
  if showPageReward then
    for i, item in ipairs(showPageReward) do
      local theName = "stageFirstRewardItem_" .. i
      local goItem = self.stageFirstRewardItemGameObject:GameObjectSpawn(self.stageFirstRewardContent.transform)
      goItem.name = theName
      goItem:SetActive(true)
      local theItem = self.stageFirstRewardContent:AddComponent(UICommonResItem, theName)
      theItem:ReInit(item)
    end
  end
  local cityEventTaskArr = pageTasks[self.showFirstStagePageIndex] or {}
  table.sort(cityEventTaskArr, function(a, b)
    if a.state ~= b.state and (a.state > 1 or b.state > 1) then
      return a.state < b.state
    else
      local taskIdA = tonumber(a.taskId)
      local taskIdB = tonumber(b.taskId)
      return taskIdA < taskIdB
    end
  end)
  self.rewardDatas = cityEventTaskArr
  self.stageFirstScrollAchieve:SetDatas(cityEventTaskArr)
  self.stageFirstScrollAchieve:UpdateItems()
end

function UICityEventZombieSeaRewardsView:Update1000MS()
  if self.valid then
    self:UpdateTime()
  end
end

function UICityEventZombieSeaRewardsView:CloseWithAnim()
  if self.closeAnimTimer then
    self.closeAnimTimer:Stop()
    self.closeAnimTimer = nil
  end
  if self.mainAnimator then
    local success, time = self.mainAnimator:PlayAnimationReturnTime("V_ui_UICityEventZombieSeaRewards_out")
    if success then
      self.closeAnimTimer = TimerManager:GetInstance():DelayInvoke(function()
        self.ctrl:CloseSelf()
      end, time)
    else
      self.ctrl:CloseSelf()
    end
  end
end

function UICityEventZombieSeaRewardsView:UpdateTime()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local diff = self.endTime - curTime
  if self.txt_Timer then
    self.txt_Timer:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(diff))
  end
  if diff <= 0 then
    self.valid = false
    self:CloseWithAnim()
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.CityEventRefresh, self.ReInit)
  self:AddUIListener(EventId.CityEventTaskUpdate, self.ReInit)
  self:AddUIListener(EventId.CityEventPageUpdate, self.ReInit)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.CityEventRefresh, self.ReInit)
  self:RemoveUIListener(EventId.CityEventTaskUpdate, self.ReInit)
  self:RemoveUIListener(EventId.CityEventPageUpdate, self.ReInit)
  base.OnRemoveListener(self)
end

UICityEventZombieSeaRewardsView.OnCreate = OnCreate
UICityEventZombieSeaRewardsView.OnDestroy = OnDestroy
UICityEventZombieSeaRewardsView.OnEnable = OnEnable
UICityEventZombieSeaRewardsView.OnDisable = OnDisable
UICityEventZombieSeaRewardsView.ComponentDefine = ComponentDefine
UICityEventZombieSeaRewardsView.ComponentDestroy = ComponentDestroy
UICityEventZombieSeaRewardsView.DataDefine = DataDefine
UICityEventZombieSeaRewardsView.DataDestroy = DataDestroy
UICityEventZombieSeaRewardsView.OnAddListener = OnAddListener
UICityEventZombieSeaRewardsView.OnRemoveListener = OnRemoveListener
return UICityEventZombieSeaRewardsView
