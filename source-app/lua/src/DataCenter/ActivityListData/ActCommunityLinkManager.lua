local ActCommunityLinkManager = BaseClass("ActCommunityLinkManager")
local ActCommunityLinkTemplate = require("DataCenter.ActivityListData.ActCommunityLinkTemplate")
local Localization = CS.GameEntry.Localization
local SIGNKEY = "discord-lastwar-20240508"
local DC_BIND_URL = "http://lw-local-gm.gamespark.net:7777/discord/index.php?method=discord_login"

local function __init(self)
  self.activityId = 0
  self.isSkip = 0
  self.isBind = 0
  self.skipRewarded = 0
  self.bindingRewarded = 0
  self.skipRewardArray = {}
  self.bindRewardArray = {}
  self.language = 0
  self.templateList = nil
  self:AddListener()
end

local function __delete(self)
  self.activityId = nil
  self.isSkip = nil
  self.isBind = nil
  self.skipRewarded = nil
  self.bindingRewarded = nil
  self.skipRewardArray = nil
  self.bindRewardArray = nil
  self.language = nil
  self.templateList = nil
  self:RemoveListener()
end

local function AddListener(self)
end

local function RemoveListener(self)
end

local function GetNowLanguageData(self)
  local lang = CS.GameEntry.Localization:GetLanguage()
  if self.canBindDC == nil or self.templateList == nil or self.language ~= lang then
    local cfg = LocalController:instance():tryGetLine(TableName.Activity_CommunityLink, tostring(lang))
    if cfg == nil then
      cfg = LocalController:instance():getLine(TableName.Activity_CommunityLink, "0")
    end
    local templateList = {}
    for index, value in ipairs(string.split(cfg.community_link, "|")) do
      local template = ActCommunityLinkTemplate.New()
      template:InitData(value)
      table.insert(templateList, template)
    end
    self.templateList = templateList
    if cfg.can_bind_dc then
      self.canBindDC = tonumber(cfg.can_bind_dc) == 1
    else
      self.canBindDC = true
    end
    self.language = lang
  end
  return self.templateList
end

local function SetActId(self, actId)
  self.activityId = actId
  SFSNetwork.SendMessage(MsgDefines.CommunityBindingGetInfo, self.activityId)
end

local function ParseData(self, message)
  if message == nil then
    return
  end
  if message.activityId then
    self.activityId = message.activityId
  end
  if message.isSkip then
    self.isSkip = message.isSkip
  end
  if message.isBind then
    self.isBind = message.isBind
  end
  if message.skipRewarded then
    self.skipRewarded = message.skipRewarded
  end
  if message.bindingRewarded then
    self.bindingRewarded = message.bindingRewarded
  end
  if message.skipRewardArray then
    self.skipRewardArray = message.skipRewardArray
  end
  if message.bindRewardArray then
    self.bindRewardArray = message.bindRewardArray
  end
  EventManager:GetInstance():Broadcast(EventId.ActCommunityLinkRefresh)
end

local function GetState(self)
  if tonumber(self.activityId) == 0 then
    return CommunityLinkState.ClaimedBindingReward
  end
  self:GetNowLanguageData()
  local state = CommunityLinkState.ClaimedBindingReward
  local bindingOpenLvl = LocalController:instance():getLine(TableName.Activity, tonumber(self.activityId)).para
  if self.isSkip == 0 then
    state = CommunityLinkState.NotSkip
  elseif self.skipRewarded == 0 then
    state = CommunityLinkState.CanGetSkipReward
  elseif self.isBind == 0 then
    if DataCenter.BuildManager.MainLv and DataCenter.BuildManager.MainLv >= tonumber(bindingOpenLvl) and self.canBindDC then
      state = CommunityLinkState.CanBinding
    else
      state = CommunityLinkState.CannotBinding
    end
  elseif self.bindingRewarded == 0 then
    state = CommunityLinkState.CanGetBindingReward
  else
    state = CommunityLinkState.ClaimedBindingReward
  end
  return state
end

local function GetRewardNum(self, state)
  local num = 0
  if state == CommunityLinkState.NotSkip or state == CommunityLinkState.CanGetSkipReward or state == CommunityLinkState.CannotBinding then
    num = self.skipRewardArray[1].value
  else
    num = self.bindRewardArray[1].value
  end
  return num
end

local function OnGetSkipReward(self, t)
  DataCenter.RewardManager:AddRewardsAndRes(t)
  DataCenter.RewardManager:ShowCommonReward(t)
  self.skipRewarded = true
  EventManager:GetInstance():Broadcast(EventId.ActCommunityLinkRefresh)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

local function OnGetBindingReward(self, t)
  DataCenter.RewardManager:AddRewardsAndRes(t)
  DataCenter.RewardManager:ShowCommonReward(t)
  self.bindingRewarded = true
  EventManager:GetInstance():Broadcast(EventId.ActCommunityLinkRefresh)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

local function GetRedNum(self)
  local state = self:GetState()
  local num = 0
  if state == CommunityLinkState.NotSkip or state == CommunityLinkState.CanGetSkipReward then
    num = 1
  end
  return num
end

local function GetDCBindUrl(self)
  local timestamp = tostring(toInt(UITimeManager:GetInstance():GetServerTime()))
  local sign = CS.StringUtils.GetMD5(LuaEntry.Player.uid .. timestamp .. SIGNKEY)
  local cfgUrl = LocalController:instance():getLine(TableName.Activity, tonumber(self.activityId)).para_3
  if string.IsNullOrEmpty(cfgUrl) then
    cfgUrl = DC_BIND_URL
  end
  local dcUrl = string.format("%s&sign=%s&timestamp=%s&uid=%s&lang=%s", cfgUrl, sign, timestamp, LuaEntry.Player.uid, Localization:GetLanguageName())
  return dcUrl
end

local function CheckActOpen(self)
  local lang = CS.GameEntry.Localization:GetLanguage()
  local cfg = LuaEntry.DataConfig:TryGetStr("activity_community_ban_language", "k1")
  if not string.IsNullOrEmpty(cfg) then
    local hideList = string.split(cfg, "|")
    for index, value in ipairs(hideList) do
      if lang == tonumber(value) then
        return false
      end
    end
  end
  return true
end

local function NeedShowNew(self)
  local templateList = self:GetNowLanguageData()
  for i, v in ipairs(templateList) do
    if v.needShowNew then
      return true
    end
  end
  return false
end

ActCommunityLinkManager.__init = __init
ActCommunityLinkManager.__delete = __delete
ActCommunityLinkManager.AddListener = AddListener
ActCommunityLinkManager.RemoveListener = RemoveListener
ActCommunityLinkManager.GetNowLanguageData = GetNowLanguageData
ActCommunityLinkManager.SetActId = SetActId
ActCommunityLinkManager.ParseData = ParseData
ActCommunityLinkManager.GetState = GetState
ActCommunityLinkManager.GetRewardNum = GetRewardNum
ActCommunityLinkManager.OnGetSkipReward = OnGetSkipReward
ActCommunityLinkManager.OnGetBindingReward = OnGetBindingReward
ActCommunityLinkManager.GetRedNum = GetRedNum
ActCommunityLinkManager.GetDCBindUrl = GetDCBindUrl
ActCommunityLinkManager.CheckActOpen = CheckActOpen
ActCommunityLinkManager.NeedShowNew = NeedShowNew
return ActCommunityLinkManager
