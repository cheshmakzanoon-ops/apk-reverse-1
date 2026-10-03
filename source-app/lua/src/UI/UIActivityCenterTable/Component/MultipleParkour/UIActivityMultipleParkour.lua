local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local UIActivityMultipleParkour = BaseClass("UIActivityMultipleParkour", base)
local Localization = CS.GameEntry.Localization
local btn_single_match_path = "btnLayout/btnSingleMatch"
local txt_single_match_path = "btnLayout/btnSingleMatch/txtSingleMatch"
local dot_single_match_path = "btnLayout/btnSingleMatch/dotSingleMatch"
local btn_endless_match_path = "btnLayout/btnEndlessMatch"
local txt_endless_match_path = "btnLayout/btnEndlessMatch/txtEndlessMatch"
local dot_endless_match_path = "btnLayout/btnEndlessMatch/dotEndlessMatch"
local btn_team_match_path = "btnTeamMatch"
local txt_team_match_path = "btnTeamMatch/txtTeamMatch"
local btn_info_path = "btnInfo"
local txt_title_path = "txtTitle"
local txt_time_path = "TimeContent/txtTime"
local txt_remain_times_title_path = "remainTime/txtRemainTimesTitle"
local txt_remain_times_path = "remainTime/txtRemainTimes"
local reward_title_path = "rewardContent/rewardTitle"
local item_path = "rewardContent/Item"
local content_path = "rewardContent/ScrollView/Viewport/Content"
local btn_rewards_path = "btnRewards"
local txt_rewards_path = "btnRewards/txtRewards"
local dot_rewards_path = "btnRewards/dotRewards"
local txt_dot_rewards_path = "btnRewards/dotRewards/txtDotRewards"
local reward_tip_path = "rewardContent/rewardTip"
local desc_btn_path = "DescBtn"
local desc_text_path = "DescBtn/DescIcon/DescText"
local btn_rank_path = "btnRank"
local txt_rank_path = "btnRank/txtRank"
local forbidMatchTime = 600000

function UIActivityMultipleParkour:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.timer = TimerManager:GetInstance():GetTimer(1, self.OnTick, self, false, false, false)
  self.timer:Start()
  self:Refresh()
  self:OnTick()
  self:CheckFirstShow()
  if DataCenter.MultipleParkourActivityManager.info == nil then
    local datas = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.MultipleParkour.Type)
    if datas and 0 < #datas then
      local data = datas[1]
      if DataCenter.ActivityListDataManager:CheckIsSend(data) then
        local id = data.id
        self.info = data
        SFSNetwork.SendMessage(MsgDefines.ActivityEventInfoGet, tostring(id))
        self:SetWaitingForMsg()
        return
      end
    end
  end
  assert(DataCenter.MultipleParkourActivityManager.info, "DataCenter.MultipleParkourActivityManager.info is nil")
  self:SetWaitingForMsg()
  SFSNetwork.SendMessage(MsgDefines.ActivityEventInfoGet, tostring(DataCenter.MultipleParkourActivityManager.info.id))
end

function UIActivityMultipleParkour:OnDestroy()
  self.content:RemoveComponents(UICommonResItem)
  self.theItem:GameObjectRecycleAll()
  self:ComponentDestroy()
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
  self:ClearWaitingForMsg()
  base.OnDestroy(self)
end

function UIActivityMultipleParkour:ComponentDefine()
  self.btn_single_match = self:AddComponent(UIButton, btn_single_match_path)
  self.txt_single_match = self:AddComponent(UITextMeshProUGUIEx, txt_single_match_path)
  self.btn_single_match:SetOnClick(function()
    self:OnSingleMatchClick()
  end)
  self.btn_team_match = self:AddComponent(UIButton, btn_team_match_path)
  self.txt_team_match = self:AddComponent(UITextMeshProUGUIEx, txt_team_match_path)
  self.btn_team_match:SetOnClick(function()
    self:OnTeamMatchClick()
  end)
  self.btn_info = self:AddComponent(UIButton, btn_info_path)
  self.btn_info:SetOnClick(function()
    self:OnInfoBtnClick()
  end)
  self.txt_title = self:AddComponent(UITextMeshProUGUIEx, txt_title_path)
  self.txt_time = self:AddComponent(UITextMeshProUGUIEx, txt_time_path)
  self.txt_remain_times_title = self:AddComponent(UITextMeshProUGUIEx, txt_remain_times_title_path)
  self.txt_remain_times = self:AddComponent(UITextMeshProUGUIEx, txt_remain_times_path)
  self.txt_title:SetText(Localization:GetString("dev_multiple_stage_04"))
  self.txt_single_match:SetText(Localization:GetString("multiply_door_tips_021"))
  self.txt_team_match:SetText(Localization:GetString("dev_multiple_stage_11"))
  self.reward_title = self:AddComponent(UITextMeshProUGUIEx, reward_title_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.theItem = self.transform:Find(item_path).gameObject
  self.theItem:GameObjectCreatePool()
  self.reward_title:SetText(Localization:GetString(500265))
  self.txt_remain_times_title:SetText(Localization:GetString("dev_multiple_stage_12"))
  self.btn_rewards = self:AddComponent(UIButton, btn_rewards_path)
  self.txt_rewards = self:AddComponent(UITextMeshProUGUIEx, txt_rewards_path)
  self.dot_rewards = self:AddComponent(UIImage, dot_rewards_path)
  self.txt_dot_rewards = self:AddComponent(UITextMeshProUGUIEx, txt_dot_rewards_path)
  self.txt_rewards:SetText(Localization:GetString(500265))
  self.reward_tip = self:AddComponent(UITextMeshProUGUIEx, reward_tip_path)
  self.reward_tip:SetText(Localization:GetString("dev_multiple_stage_22"))
  self.reward_tip:SetActive(false)
  self.btn_rewards:SetActive(true)
  self.btn_rewards:SetOnClick(function()
    self:OnRewardBtnClick()
  end)
  self.dot_single_match = self:AddComponent(UIImage, dot_single_match_path)
  self.dot_single_match:SetActive(false)
  self.dot_endless_match = self:AddComponent(UIImage, dot_endless_match_path)
  self.dot_endless_match:SetActive(false)
  self.desc_btn = self:AddComponent(UIButton, desc_btn_path)
  self.desc_text = self:AddComponent(UITextMeshProUGUIEx, desc_text_path)
  self.desc_text:SetLocalText("gogncheng_liantu_tips1001")
  self.desc_btn:SetOnClick(function()
    self:OnDescBtnClick()
  end)
  self.btn_endless_match = self:AddComponent(UIButton, btn_endless_match_path)
  self.txt_endless_match = self:AddComponent(UITextMeshProUGUIEx, txt_endless_match_path)
  self.txt_endless_match:SetText(Localization:GetString("multiply_door_tips_011"))
  self.btn_endless_match:SetOnClick(function()
    self:OnEndlessBtnClick()
  end)
  self.btn_rank = self:AddComponent(UIButton, btn_rank_path)
  self.txt_rank = self:AddComponent(UITextMeshProUGUIEx, txt_rank_path)
  self.txt_rank:SetText(Localization:GetString("multiply_door_tips_010"))
  self.btn_rank:SetOnClick(function()
    self:OnRankBtnClick()
  end)
end

function UIActivityMultipleParkour:ComponentDestroy()
  self.btn_single_match = nil
  self.txt_single_match = nil
  self.btn_team_match = nil
  self.txt_team_match = nil
  self.btn_info = nil
  self.txt_title = nil
  self.txt_time = nil
  self.txt_remain_times_title = nil
  self.txt_remain_times = nil
  self.reward_tip = nil
  self.dot_single_match = nil
  self.dot_endless_match = nil
  self.desc_btn = nil
  self.desc_text = nil
  self.btn_endless_match = nil
  self.txt_endless_match = nil
  self.btn_rank = nil
  self.txt_rank = nil
end

function UIActivityMultipleParkour:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.MultipleParkourActivityInfoChanged, self.OnActivityInfoChanged)
  self:AddUIListener(EventId.MultipleParkourSingleMatchResult, self.OnMultipleParkourSingleMatchResult)
  self:AddUIListener(EventId.MultipleParkourTaskRewardChanged, self.OnMultipleParkourTaskRewardChanged)
end

function UIActivityMultipleParkour:OnRemoveListener()
  self:RemoveUIListener(EventId.MultipleParkourActivityInfoChanged, self.OnActivityInfoChanged)
  self:RemoveUIListener(EventId.MultipleParkourSingleMatchResult, self.OnMultipleParkourSingleMatchResult)
  self:RemoveUIListener(EventId.MultipleParkourTaskRewardChanged, self.OnMultipleParkourTaskRewardChanged)
  base.OnRemoveListener(self)
end

function UIActivityMultipleParkour:OnActivityInfoChanged(activityId)
  if self.info and tonumber(activityId) == tonumber(self.info.id) then
    self:ClearWaitingForMsg()
    self:Refresh()
  end
end

function UIActivityMultipleParkour:OnMultipleParkourTaskRewardChanged(activityId)
  if self.info and tonumber(activityId) == tonumber(self.info.id) then
    self:RefreshRewardRedDot()
  end
end

function UIActivityMultipleParkour:OnMultipleParkourSingleMatchResult()
  self:ClearWaitingForMsg()
end

function UIActivityMultipleParkour:Refresh()
  local info = DataCenter.MultipleParkourActivityManager.info
  if not info then
    return
  end
  self.info = info
  self:ShowReward()
  self:RefreshRewardRedDot()
  self.dot_endless_match:SetActive(self.info.dayTimes == 0)
end

function UIActivityMultipleParkour:ShowReward()
  if not self.info then
    return
  end
  self.content:RemoveComponents(UICommonResItem)
  self.theItem:GameObjectRecycleAll()
  local doorId = self.info.doorId or 1
  local doorTemplate = DataCenter.MultipleParkourDoorTemplateManager:GetTemplate(doorId)
  if doorTemplate then
    local rewards = doorTemplate:GetRewardShowList()
    local goItem, theItem
    self.content:RemoveComponents(UICommonResItem)
    self.theItem:GameObjectRecycleAll()
    for i, item in ipairs(rewards) do
      local theName = "item_" .. i
      goItem = self.theItem:GameObjectSpawn(self.content.transform)
      goItem.name = theName
      goItem:SetActive(true)
      theItem = self.content:AddComponent(UICommonResItem, theName)
      theItem:ReInit(item)
    end
  end
end

function UIActivityMultipleParkour:RefreshRewardRedDot()
  if not self.info then
    return
  end
  local count = self.info.rewardCount
  self.dot_rewards:SetActive(0 < count)
  self.txt_dot_rewards:SetText(count)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

function UIActivityMultipleParkour:OnTick()
  if not self.info then
    return
  end
  local serverTime = UITimeManager:GetInstance():GetServerTime()
  local endTime = self.info.endTime
  if endTime then
    local remain = endTime - serverTime
    if 0 < remain then
      self.txt_time:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remain))
    else
      self.txt_time:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(0))
    end
  end
end

function UIActivityMultipleParkour:OnSingleMatchClick()
  if not self.info then
    return
  end
  local serverTime = UITimeManager:GetInstance():GetServerTime()
  local endTime = self.info.endTime
  if endTime then
    local remain = endTime - serverTime
    if remain < forbidMatchTime then
      UIUtil.ShowTips(Localization:GetString("multiply_door_tips_031"))
      return
    end
  end
  self:SingleMarchImp()
end

function UIActivityMultipleParkour:OnEndlessBtnClick()
  if not self.info then
    return
  end
  local serverTime = UITimeManager:GetInstance():GetServerTime()
  local endTime = self.info.endTime
  if endTime then
    local remain = endTime - serverTime
    if remain < forbidMatchTime then
      UIUtil.ShowTips(Localization:GetString("multiply_door_tips_031"))
      return
    end
  end
  if self.__waitingForMsg then
    UIUtil.ShowTips(Localization:GetString("multiply_door_tips_026"))
    return
  end
  self:SetWaitingForMsg()
  DataCenter.MultipleParkourManager:SimulatorSingleMatchEndless(true)
end

function UIActivityMultipleParkour:SingleMarchImp()
  if self.__waitingForMsg then
    UIUtil.ShowTips(Localization:GetString("multiply_door_tips_026"))
    return
  end
  self:SetWaitingForMsg()
  DataCenter.MultipleParkourManager:SimulatorSingleMatch()
end

function UIActivityMultipleParkour:OnTeamMatchClick()
end

function UIActivityMultipleParkour:OnInfoBtnClick()
  UIUtil.ShowIntro(Localization:GetString("302027"), Localization:GetString("2800015"), Localization:GetString("dev_multiple_rule_01"))
end

function UIActivityMultipleParkour:OnRewardBtnClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityMultipleParkourRewards, {anim = true})
end

function UIActivityMultipleParkour:OnDescBtnClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWWorldTip, {anim = false}, 5)
end

function UIActivityMultipleParkour:OnRankBtnClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIMultipleParkourRank, {anim = false})
end

function UIActivityMultipleParkour:CheckFirstShow()
  local firstShow = Setting:GetPrivateInt("UIActivityMultipleParkourFirstShow", 0)
  if firstShow == 0 then
    Setting:SetPrivateInt("UIActivityMultipleParkourFirstShow", 1)
    self:OnDescBtnClick()
  end
end

function UIActivityMultipleParkour:SetWaitingForMsg()
  if not self.__waitingForMsg then
    self.__waitingForMsg = true
    if self.delayTimer then
      self.delayTimer:Stop()
    end
    self.delayTimer = TimerManager:GetInstance():GetTimer(6, function()
      self.__waitingForMsg = false
    end, self, true, true)
    self.delayTimer:Start()
  end
end

function UIActivityMultipleParkour:ClearWaitingForMsg()
  self.__waitingForMsg = false
  if self.delayTimer then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
end

return UIActivityMultipleParkour
