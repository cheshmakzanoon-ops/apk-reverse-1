local UICityEventKillZombieRewardView = BaseClass("UICityEventKillZombieRewardView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local AchieveItem = require("UI.UICityEventKillZombieReward.Component.UICityEventKillZombieRewardAchieveItem")
local txt_title_path = "Main/top/txtTitle"
local btn_close_path = "Main/top/btnClose"
local txt_Timer_Label_path = "Main/top/Timer/TimerLabelBg/TxtTimerLabel"
local scroll_achieve_path = "Main/bg2/scrollAchieve"
local black_path = "black"
local tab_partOne_off_path = "Main/tabs/tabPartOne/tabPartOne_off"
local txt_tab_partOne_off_path = "Main/tabs/tabPartOne/tabPartOne_off/txtTabPartOne_off"
local tab_partOne_on_path = "Main/tabs/tabPartOne/tabPartOne_on"
local txt_tab_partOne_on_path = "Main/tabs/tabPartOne/tabPartOne_on/txtTabPartOne_on"
local tab_partTwo_off_path = "Main/tabs/tabPartTwo/tabPartTwo_off"
local txt_tab_partTwo_off_path = "Main/tabs/tabPartTwo/tabPartTwo_off/txtTabPartTwo_off"
local tab_partTwo_on_path = "Main/tabs/tabPartTwo/tabPartTwo_on"
local txt_tab_partTwo_on_path = "Main/tabs/tabPartTwo/tabPartTwo_on/txtTabPartTwo_on"
local btn_JoinAl = "Main/top/btnJoin"
local txt_JoinAl = "Main/top/btnJoin/txtJoin"
local PartType = {PartOne = 1, PartTwo = 2}

function UICityEventKillZombieRewardView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function UICityEventKillZombieRewardView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UICityEventKillZombieRewardView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.CityEventTaskUpdate, self.ReInit)
end

function UICityEventKillZombieRewardView:OnRemoveListener()
  self:RemoveUIListener(EventId.CityEventTaskUpdate, self.ReInit)
  base.OnRemoveListener(self)
end

function UICityEventKillZombieRewardView:ComponentDefine()
  self.mainAnimator = self:AddComponent(UIAnimator, "")
  self.txt_title = self:AddComponent(UITextMeshProUGUIEx, txt_title_path)
  self.btn_close = self:AddComponent(UIButton, btn_close_path)
  self.scroll_achieve = self:AddComponent(UIDynamicVerticleScrollRectEx, scroll_achieve_path)
  self.tab_partOne_off = self:AddComponent(UIButton, tab_partOne_off_path)
  self.txt_tab_partOne_off = self:AddComponent(UITextMeshProUGUIEx, txt_tab_partOne_off_path)
  self.tab_partOne_on = self:AddComponent(UIImage, tab_partOne_on_path)
  self.txt_tab_partOne_on = self:AddComponent(UITextMeshProUGUIEx, txt_tab_partOne_on_path)
  self.tab_partTwo_off = self:AddComponent(UIButton, tab_partTwo_off_path)
  self.txt_tab_partTwo_off = self:AddComponent(UITextMeshProUGUIEx, txt_tab_partTwo_off_path)
  self.tab_partTwo_on = self:AddComponent(UIImage, tab_partTwo_on_path)
  self.txt_tab_partTwo_on = self:AddComponent(UITextMeshProUGUIEx, txt_tab_partTwo_on_path)
  local partOneTabKey = Localization:GetString("city_event_desc61")
  self.txt_tab_partOne_off:SetText(partOneTabKey)
  self.txt_tab_partOne_on:SetText(partOneTabKey)
  local partTwoTabKey = Localization:GetString("city_event_desc62")
  self.txt_tab_partTwo_off:SetText(partTwoTabKey)
  self.txt_tab_partTwo_on:SetText(partTwoTabKey)
  self.tab_partOne_off:SetOnClick(function()
    self:SwitchTab(PartType.PartOne)
  end)
  self.tab_partTwo_off:SetOnClick(function()
    self:SwitchTab(PartType.PartTwo)
  end)
  self.tabsOn = {
    [PartType.PartOne] = self.tab_partOne_on,
    [PartType.PartTwo] = self.tab_partTwo_on
  }
  self.tabsOff = {
    [PartType.PartOne] = self.tab_partOne_off,
    [PartType.PartTwo] = self.tab_partTwo_off
  }
  self.btn_close:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.txt_Timer_label = self:AddComponent(UITextMeshProUGUIEx, txt_Timer_Label_path)
  self.itemIncNo = 1
  self.itemMap = {}
  self.scroll_achieve:AddInstantiateItemListener(function(itemObj, prefabIdx)
    itemObj.name = "achieveItem_" .. self.itemIncNo
    self.itemIncNo = self.itemIncNo + 1
    local achieveItem = self:AddComponent(AchieveItem, itemObj)
    self.itemMap[itemObj] = achieveItem
  end)
  self.scroll_achieve:AddDisplayItemListener(function(itemObj, dataIdx)
    local achieveItem = self.itemMap[itemObj]
    local data = self.rewardDatas[dataIdx + 1]
    achieveItem:Refresh(data, self.showTaskBtn)
  end)
  self.black = self:AddComponent(UIButton, black_path)
  self.black:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.txt_Join = self:AddComponent(UITextMeshProUGUIEx, txt_JoinAl)
  self.txt_Join:SetLocalText("city_event_desc64")
  self.joinBtn = self:AddComponent(UIButton, btn_JoinAl)
  self.joinBtn:SetOnClick(function()
    local params = {
      guide = false,
      al_success_callback = function()
        UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWAlCreateJoin)
        self:ReInit()
      end,
      al_lose_callback = function()
      end
    }
    if LuaEntry.Player:IsFirstJoinAlliance() == true then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAllianceFirstJoin, {anim = true}, params)
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlCreateJoin, {anim = true}, params)
    end
  end)
  local cityEventName = DataCenter.LWBeginnerDirectorManager:GetCurCityEventName()
  self.txt_title:SetLocalText(cityEventName)
end

function UICityEventKillZombieRewardView:ComponentDestroy()
  if self.closeAnimTimer then
    self.closeAnimTimer:Stop()
    self.closeAnimTimer = nil
  end
  self.mainAnimator = nil
  self.txt_title = nil
  self.btn_close = nil
  self.scroll_achieve = nil
  self.black = nil
  self.itemMap = nil
  self.tab_partOne_off = nil
  self.txt_tab_partOne_off = nil
  self.tab_partOne_on = nil
  self.txt_tab_partOne_on = nil
  self.tab_partTwo_off = nil
  self.txt_tab_partTwo_off = nil
  self.tab_partTwo_on = nil
  self.txt_tab_partTwo_on = nil
end

function UICityEventKillZombieRewardView:DataDefine()
end

function UICityEventKillZombieRewardView:DataDestroy()
  self.pageTwoUnlocked = nil
  self.curTab = nil
  self.rewardDatas = nil
end

function UICityEventKillZombieRewardView:ReInit()
  self.valid = false
  local cityEventId = DataCenter.LWBeginnerDirectorManager:GetCurCityEventID()
  if cityEventId ~= BeginnerDirectorEvent.BigWorldKillZombie then
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
  self.joinBtn:SetActive(false)
  local pageTasks = DataCenter.LWBeginnerDirectorManager:GetCurCityEventPageTasks()
  local partOneTask = pageTasks[1] or {}
  local partOneAllReceived = true
  for i, task in ipairs(partOneTask) do
    if task.state ~= TaskState.Received then
      partOneAllReceived = false
      break
    end
  end
  self.pageTwoUnlocked = partOneAllReceived
  self:SwitchTab(self.pageTwoUnlocked and PartType.PartTwo or PartType.PartOne)
end

function UICityEventKillZombieRewardView:SwitchTab(type)
  if type == PartType.PartTwo and not self.pageTwoUnlocked then
    UIUtil.ShowTips(Localization:GetString("city_event_desc63"))
    return
  end
  self.curTab = type
  for k, v in pairs(self.tabsOn) do
    v:SetActive(k == type)
  end
  for k, v in pairs(self.tabsOff) do
    v:SetActive(k ~= type)
  end
  local isInAlliance = LuaEntry.Player:IsInAlliance()
  if type == PartType.PartTwo then
    self.joinBtn:SetActive(not isInAlliance)
  end
  local pageTasks = DataCenter.LWBeginnerDirectorManager:GetCurCityEventPageTasks()
  local partTypeTaskIndex = type == PartType.PartOne and 1 or 2
  local cityEventTaskArr = pageTasks[partTypeTaskIndex] or {}
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
  self.showTaskBtn = type ~= PartType.PartTwo or isInAlliance
  self.scroll_achieve:SetDatas(self.rewardDatas)
  self.scroll_achieve:UpdateItems()
end

function UICityEventKillZombieRewardView:CloseWithAnim()
  if self.closeAnimTimer then
    self.closeAnimTimer:Stop()
    self.closeAnimTimer = nil
  end
  if self.mainAnimator then
    local success, time = self.mainAnimator:PlayAnimationReturnTime("UICityEventKillZombieRewardsOut")
    if success then
      self.closeAnimTimer = TimerManager:GetInstance():DelayInvoke(function()
        self.ctrl:CloseSelf()
      end, time)
    else
      self.ctrl:CloseSelf()
    end
  end
end

function UICityEventKillZombieRewardView:Update1000MS()
  if self.valid then
    self:UpdateTime()
  end
end

function UICityEventKillZombieRewardView:UpdateTime()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local diff = self.endTime - curTime
  self.txt_Timer_label:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(diff))
  if diff <= 0 then
    self.valid = false
    self:CloseWithAnim()
  end
end

return UICityEventKillZombieRewardView
