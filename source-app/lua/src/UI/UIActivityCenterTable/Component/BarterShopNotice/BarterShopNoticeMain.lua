local BarterShopNoticeMain = BaseClass("BarterShopNoticeMain", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local ResourceManager = CS.GameEntry.Resource
local UIRadarRallyItem = require("UI.UIActivityCenterTable.Component.RadarRally.UIRadarRallyItem")
local bg_path = "Bg"
local title_path = "Panel/titleBg/Title"
local info_path = "Panel/titleBg/Title/Info"
local time_path = "Panel/Time"
local story_path = "Panel/Story"
local reward_list_path = "Panel/RewardList"
local rest_time_path = "Panel/RestTimeBg/RestTime"
local rest_time_icon_path = "Panel/RestTimeBg/RestTime/Image (1)"
local bossExtraReward_path = "Panel/rallyBossAct"
local bossRemainTimes_path = "Panel/rallyBossAct/bossExtraTimes"
local bossRefreshCd_path = "Panel/rallyBossAct/bossRefreshCd"
local go_path = "Panel/rallyBossAct/GoBtn"
local go_text_path = "Panel/rallyBossAct/GoBtn/GoBtnText"
local go_tip_path = "Panel/rallyBossAct/GoBtn/goBtnTip"
local red_dot_path = "Panel/rallyBossAct/GoBtn/RedDot"
local autoBtn_path = "Panel/rallyBossAct/AutoBtn"
local autoBtnTxt_path = "Panel/rallyBossAct/AutoBtn/autoBtnTxt"
local autoBtnTip_path = "Panel/rallyBossAct/AutoBtn/autoBtnTip"
local autoBtnRed_path = "Panel/rallyBossAct/AutoBtn/autoRedDot"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:DelBossTimer()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  SFSNetwork.SendMessage(MsgDefines.RadarRallyGetBossCount)
  self:Refresh()
end

local function OnDisable(self)
  self:SetAllCellDestroy()
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.bgN = self:AddComponent(UIImage, bg_path)
  self.title_text = self:AddComponent(UIText, title_path)
  self.info_btn = self:AddComponent(UIButton, info_path)
  self.info_btn:SetOnClick(function()
    self:OnInfoClick()
  end)
  self.time_text = self:AddComponent(UIText, time_path)
  self.story_text = self:AddComponent(UIText, story_path)
  self.reward_list_go = self:AddComponent(UIBaseContainer, reward_list_path)
  self.rest_time_text = self:AddComponent(UIText, rest_time_path)
  self.rest_time_icon = self:AddComponent(UIImage, rest_time_icon_path)
  self.bossExtraRewardN = self:AddComponent(UIBaseContainer, bossExtraReward_path)
  self.bossRemainTimesN = self:AddComponent(UIText, bossRemainTimes_path)
  self.bossRefreshCdN = self:AddComponent(UIText, bossRefreshCd_path)
  self.go_btn = self:AddComponent(UIButton, go_path)
  self.go_btn:SetOnClick(function()
    self:OnGoClick()
  end)
  self.go_text = self:AddComponent(UIText, go_text_path)
  self.go_text:SetLocalText(110003)
  self.go_tip = self:AddComponent(UIText, go_tip_path)
  self.go_tip:SetLocalText(143576)
  self.red_dot_go = self:AddComponent(UIBaseContainer, red_dot_path)
  self.autoBtnN = self:AddComponent(UIButton, autoBtn_path)
  self.autoBtnN:SetOnClick(function()
    self:OnClickAutoBtn()
  end)
  self.autoBtnTxtN = self:AddComponent(UIText, autoBtnTxt_path)
  self.autoBtnTipN = self:AddComponent(UIText, autoBtnTip_path)
  self.autoBtnTipN:SetLocalText(143577)
  self.autoBtnRedN = self:AddComponent(UIBaseContainer, autoBtnRed_path)
end

local function ComponentDestroy(self)
  self:SetAllCellDestroy()
  self.title_text = nil
  self.info_btn = nil
  self.time_text = nil
  self.story_text = nil
  self.reward_list_go = nil
  self.rest_time_text = nil
  self.go_btn = nil
  self.red_dot_go = nil
  self.bossExtraRewardN = nil
  self.bossRemainTimesN = nil
  self.bossRefreshCdN = nil
end

local function DataDefine(self)
  self.actId = ""
  self.timer = nil
  self.remainCount = 0
  self.useCount = 0
end

local function DataDestroy(self)
  if self.activityId == EnumActivity.RallyBossAct.ActId then
    DataCenter.DailyActivityManager:UpdateActViewHistory(2)
  end
  self.data = nil
  if self.timer ~= nil then
    self.timer:Stop()
  end
  self.timer = nil
  self:DelBossTimer()
  self.remainCount = nil
  self.useCount = nil
end

local function OnAddListener(self)
  self:AddUIListener(EventId.RadarRallyGetBossCount, self.RadarRallyGetBossCountSignal)
  self:AddUIListener(EventId.UpdateAllianceAutoRallyInfo, self.Refresh)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.RadarRallyGetBossCount, self.RadarRallyGetBossCountSignal)
  self:RemoveUIListener(EventId.UpdateAllianceAutoRallyInfo, self.Refresh)
end

local function SetData(self, activityId)
  self.activityId = activityId
  self:Refresh()
end

local function Refresh(self)
  if not self.activityId then
    return
  end
  local data = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  self.data = data
  self.title_text:SetLocalText(tonumber(data.name))
  if self.activityId ~= EnumActivity.RallyBossAct.ActId then
    local startTime = math.floor(data.startTime)
    local endTime = math.floor(data.actEndTime)
    local startTimeStr = UITimeManager:GetInstance():TimeStampToTimeForLocal(startTime)
    startTimeStr = string.split(startTimeStr, " ")[1]
    startTimeStr = string.gsub(startTimeStr, "-", "/")
    local endTimeStr = UITimeManager:GetInstance():TimeStampToTimeForLocal(endTime)
    endTimeStr = string.split(endTimeStr, " ")[1]
    endTimeStr = string.gsub(endTimeStr, "-", "/")
    self.time_text:SetText(startTimeStr .. " ~ " .. endTimeStr)
    local serverT = UITimeManager:GetInstance():GetServerTime()
    if endTime < serverT then
      if self.timer then
        self.timer:Stop()
      end
      self.rest_time_icon:SetActive(false)
      self.rest_time_text:SetLocalText(370100)
    else
      self.rest_time_icon:SetActive(true)
      self.timer = TimerManager:GetInstance():GetTimer(0.1, self.TimerAction, {self = self, endTime = endTime}, false, false, false)
      self.timer:Start()
    end
  else
    if self.timer then
      self.timer:Stop()
    end
    self.rest_time_icon:SetActive(false)
    self.time_text:SetText("")
    self.rest_time_text:SetText("")
  end
  self.story_text:SetLocalText(tonumber(data.story))
  self.red_dot_go:SetActive(false)
  self:SetAllCellDestroy()
  self.model = {}
  local rewards = string.split(data.reward_goods, "|")
  for i, reward in ipairs(rewards) do
    local spl = string.split(reward, ";")
    local itemId = tonumber(spl[1])
    local rewardType = tonumber(spl[2]) or RewardType.GOODS
    self.model[i] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go.gameObject:SetActive(true)
      go.transform:SetParent(self.reward_list_go.transform)
      go.transform:Set_localScale(0.64, 0.64, 0.64)
      go.name = tostring(i)
      local item = self.reward_list_go:AddComponent(UIRadarRallyItem, tostring(i))
      item:ReInit({itemId = itemId, rewardType = rewardType})
    end)
  end
  if self.activityId == EnumActivity.RallyBossAct.ActId then
    self.bossExtraRewardN:SetActive(true)
    local autoInfo = DataCenter.AllianceBaseDataManager:GetAutoRallyInfo()
    if not autoInfo then
      self.autoBtnTxtN:SetLocalText(143565)
    else
      local serverTime = UITimeManager:GetInstance():GetServerTime()
      if serverTime < autoInfo.endTime then
        self.autoBtnTxtN:SetLocalText(143578)
      else
        self.autoBtnTxtN:SetLocalText(143565)
      end
    end
    local redCount = DataCenter.AllianceBaseDataManager:CheckIfShowAutoRallyRed()
    self.autoBtnRedN:SetActive(0 < redCount)
    local maxTimes = tonumber(self.data.para1)
    local killedNum = DataCenter.MonsterManager:GetKillBossNum()
    local killAddNum = LuaEntry.Effect:GetGameEffect(EffectDefine.AUTO_RALLY_REWARD_NUM_ADD)
    local killMax = math.floor(maxTimes + killAddNum)
    killedNum = math.floor(math.max(0, killedNum))
    killedNum = math.min(killedNum, killMax)
    self.bossRemainTimesN:SetLocalText(302205, killedNum .. "/" .. killMax)
    local remainTime = UITimeManager:GetInstance():GetResSecondsTo24()
    self.bgN:LoadSprite("Assets/Main/TextureEx/UIActivity/UIBarterShop_img_bg")
    if 0 < remainTime then
      self:SetBossRefreshTime()
      self:AddBossTimer()
    else
      self:DelBossTimer()
      self:SetBossRefreshTime()
    end
  else
    self.bossExtraRewardN:SetActive(false)
    self:DelBossTimer()
  end
end

local function SetAllCellDestroy(self)
  self.reward_list_go:RemoveComponents(UIRadarRallyItem)
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
end

local function TimerAction(param)
  if param.self.rest_time_text then
    local curTime = math.floor(UITimeManager:GetInstance():GetServerTime())
    local restTime = math.max(param.endTime - curTime, 0)
    if restTime <= 0 then
      param.self.rest_time_icon:SetActive(false)
      param.self.rest_time_text:SetLocalText(370100)
      param.self.timer:Stop()
      param.self.timer = nil
    else
      local restTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(restTime)
      param.self.rest_time_text:SetText(restTimeStr)
    end
  end
end

local function AddBossTimer(self)
  function self.BossTimerAction()
    self:SetBossRefreshTime()
  end
  
  if self.bossTimer == nil then
    self.bossTimer = TimerManager:GetInstance():GetTimer(1, self.BossTimerAction, self, false, false, false)
  end
  self.bossTimer:Start()
end

local function SetBossRefreshTime(self)
  local remainTime = UITimeManager:GetInstance():GetResSecondsTo24()
  if 0 < remainTime then
    self.bossRefreshCdN:SetLocalText(302206, UITimeManager:GetInstance():MilliSecondToFmtString(remainTime * 1000))
  else
    self:DelBossTimer()
    self:Refresh()
  end
end

local function DelBossTimer(self)
  if self.bossTimer ~= nil then
    self.bossTimer:Stop()
    self.bossTimer = nil
  end
end

local function OnInfoClick(self)
  if self.activityId == EnumActivity.RallyBossAct.ActId then
    UIUtil.ShowIntro(Localization:GetString(self.data.name), Localization:GetString("302203"), Localization:GetString("302232"))
  else
    UIUtil.ShowIntro(Localization:GetString(self.data.name), Localization:GetString("100239"), Localization:GetString("302077"))
  end
end

local function OnGoClick(self)
  if self.activityId == EnumActivity.RallyBossAct.ActId then
    GoToUtil.GotoOpenView(UIWindowNames.UISearch, UISearchType.Boss)
    return
  end
  if self.remainCount > 0 then
    local maxDistance = tonumber(self.data.para1) or 100000
    local list = DataCenter.AllianceWarDataManager:GetRadarRallyActivityAllianceWars(maxDistance)
    if 0 < #list then
      GoToUtil.GotoOpenView(UIWindowNames.UIAllianceWarMainTable, 2, list[1].uuid)
    else
      GoToUtil.GoRadarProbe(nil, DetectEventType.DetectEventRadarRally)
    end
  elseif 0 < self.useCount then
    UIUtil.ShowTipsId(372134)
  end
end

local function OnClickAutoBtn(self)
  if LuaEntry.Player:IsInAlliance() then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceAutoJoinRally)
  else
    UIUtil.ShowTipsId(371059)
  end
end

local function RadarRallyGetBossCountSignal(self, message)
  self.remainCount = message.remainCount
  self.useCount = message.useCount
end

BarterShopNoticeMain.OnCreate = OnCreate
BarterShopNoticeMain.OnDestroy = OnDestroy
BarterShopNoticeMain.OnEnable = OnEnable
BarterShopNoticeMain.OnDisable = OnDisable
BarterShopNoticeMain.ComponentDefine = ComponentDefine
BarterShopNoticeMain.ComponentDestroy = ComponentDestroy
BarterShopNoticeMain.DataDefine = DataDefine
BarterShopNoticeMain.DataDestroy = DataDestroy
BarterShopNoticeMain.OnAddListener = OnAddListener
BarterShopNoticeMain.OnRemoveListener = OnRemoveListener
BarterShopNoticeMain.Refresh = Refresh
BarterShopNoticeMain.TimerAction = TimerAction
BarterShopNoticeMain.SetAllCellDestroy = SetAllCellDestroy
BarterShopNoticeMain.OnInfoClick = OnInfoClick
BarterShopNoticeMain.OnGoClick = OnGoClick
BarterShopNoticeMain.RadarRallyGetBossCountSignal = RadarRallyGetBossCountSignal
BarterShopNoticeMain.SetData = SetData
BarterShopNoticeMain.AddBossTimer = AddBossTimer
BarterShopNoticeMain.SetBossRefreshTime = SetBossRefreshTime
BarterShopNoticeMain.DelBossTimer = DelBossTimer
BarterShopNoticeMain.OnClickAutoBtn = OnClickAutoBtn
return BarterShopNoticeMain
