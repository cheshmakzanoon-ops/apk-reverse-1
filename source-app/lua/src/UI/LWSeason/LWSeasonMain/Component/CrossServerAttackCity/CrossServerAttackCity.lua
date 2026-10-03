local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local SeasonCrossServerAttackCity = BaseClass("SeasonCrossServerAttackCity", base)
local CityItem = require("UI.LWSeason.LWSeasonMain.Component.CrossServerAttackCity.CrossServerAttackCityItem")
local Localization = CS.GameEntry.Localization
local title_path = "RightView/Top/Title"
local info_btn_path = "RightView/Top/InfoBtn"
local btn_info_icon_path = "RightView/Top/BtnList/BtnInfoIcon"
local open_time_tips_path = "RightView/TimeBg/OpenTimeTips"
local open_time_path = "RightView/TimeBg/OpenTime"
local desc1_path = "RightView/Desc1"
local content_path = "RightView/ScrollView/Content"
local cell_path = "RightView/ScrollView/Content/cell"
local desc2_path = "RightView/Desc2"
local btn_goal_path = "Bottom/BtnGoal"
local goal_text_path = "Bottom/BtnGoal/GoalText"
local btn_join_path = "Bottom/BtnJoin"
local bg2_path = "RightView/bg/bg2"
local season3_path = "Mask/season3"
local season1_path = "Mask/season1"
local btn_rank_path = "RightView/Top/BtnList/BtnRank"
local btn_reward_path = "RightView/Top/BtnList/BtnReward"

function SeasonCrossServerAttackCity:OnCreate()
  base.OnCreate(self)
  self.season3 = self:AddComponent(UIRawImage, season3_path)
  self.season1 = self:AddComponent(UIRawImage, season1_path)
  self.bg2 = self:AddComponent(UIRawImage, bg2_path)
  self.title = self:AddComponent(UIText, title_path)
  self.info_btn = self:AddComponent(UIButton, info_btn_path)
  self.btn_info_icon = self:AddComponent(UIButton, btn_info_icon_path)
  self.open_time_tips = self:AddComponent(UIText, open_time_tips_path)
  self.open_time = self:AddComponent(UIText, open_time_path)
  self.desc1 = self:AddComponent(UIText, desc1_path)
  self.desc2 = self:AddComponent(UIText, desc2_path)
  self.btn_goal = self:AddComponent(UIButton, btn_goal_path)
  self.goal_text = self:AddComponent(UIText, goal_text_path)
  self.btn_join = self:AddComponent(UIButton, btn_join_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.theItem = self.transform:Find(cell_path).gameObject
  self.theItem:GameObjectCreatePool()
  self.title:SetText(UIUtil.GetString([[
CROSS-SERVER
<size=66>INTRUSION</size>]], "activity_cross_attack_name"))
  self.goal_text:SetLocalText("season_s1_activity1000006_desc01")
  self.open_time:SetText("")
  self.info_btn:SetOnClick(function()
    local desc = "season_sever_intrusion_004"
    if self.activityData ~= nil and self.activityData.story ~= nil then
      desc = self.activityData.story
    end
    local param = {}
    param.activityId = self.activityId
    param.activityRulesStr = Localization:GetString(desc)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
  end)
  self.btn_info_icon:SetOnClick(function()
    UIUtil.ShowS1HowToPlay(101005)
  end)
  self.btn_goal:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonServerGroup)
  end)
  self.btn_join:SetOnClick(function()
    if LuaEntry.Player:IsInSourceServer() then
      if LuaEntry.Player:IsFirstJoinAlliance() == true then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAllianceFirstJoin, {anim = true})
      else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlCreateJoin, {anim = true}, {guide = false})
      end
    else
      UIUtil.ShowTipsId("season_tips166")
    end
  end)
  self.btn_rank = self:AddComponent(UIButton, btn_rank_path)
  self.btn_reward = self:AddComponent(UIButton, btn_reward_path)
  self.btn_rank:SetOnClick(function()
    local actData = self.activityData
    local seasonType, seasonVersion = SeasonUtil.GetSeasonTypeAndVersion()
    local para_5 = toInt(actData.para_5)
    local para_9 = toInt(actData.para_9)
    if seasonType == SeasonMapType.CityStronghold then
      if para_9 == 1 then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UILWCrossServerAttackCityRank)
      elseif actData ~= nil and actData.rankReward ~= nil then
        local configId = toInt(actData.rankReward)
        local eventId = toInt(actData.para_6)
        UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonRank, {anim = true}, {
          lw_season_rank = true,
          id = configId,
          cmd = MsgDefines.GetSeasonCrossInvasionRankInfo,
          event = eventId
        })
        return
      end
    elseif seasonType == SeasonMapType.Desert then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonRank, {anim = true}, {
        rank = 4,
        title = "season_cross_player_rank",
        nameTxt = "302129",
        scoreTxt = "season_cross_player_rank_value"
      })
    else
      UIUtil.ShowTipsId(120018)
    end
  end)
  self.btn_reward:SetOnClick(function()
    local dataCount = table.count(self.rankRewardList)
    if 1 < dataCount then
      UIManager:GetInstance():OpenWindow(UIWindowNames.LWUICommonRankMultipleReward, {anim = true}, self.rankRewardList)
    elseif dataCount == 1 then
      if self.requestRankId ~= nil and self.requestRankData ~= nil then
        UIManager:GetInstance():OpenWindow(UIWindowNames.LWUICommonRankReward, {anim = true}, self.requestRankData)
      else
        local rankId = toInt(self.rankRewardList[1])
        self.requestRankId = rankId
        self.requestRankData = nil
        SFSNetwork.SendMessage(MsgDefines.GetSeasonRankRewardInfo, rankId)
      end
    end
  end)
end

function SeasonCrossServerAttackCity:OnDestroy()
  self.btn_rank = nil
  self.btn_reward = nil
  self.content:RemoveComponents(CityItem)
  self.theItem:GameObjectRecycleAll()
  base.OnDestroy(self)
end

function SeasonCrossServerAttackCity:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.LWSeasonCrossAttackCityInfo, self.UpdateData)
  self:AddUIListener(EventId.UpdateMainAllianceRedCount, self.OnJoinAlliance)
  self:AddUIListener(EventId.LWSeasonRankRewardUpdate, self.OpenRewardWindow)
end

function SeasonCrossServerAttackCity:OnRemoveListener()
  self:RemoveUIListener(EventId.LWSeasonCrossAttackCityInfo, self.UpdateData)
  self:RemoveUIListener(EventId.UpdateMainAllianceRedCount, self.OnJoinAlliance)
  self:RemoveUIListener(EventId.LWSeasonRankRewardUpdate, self.OpenRewardWindow)
  base.OnRemoveListener(self)
end

function SeasonCrossServerAttackCity:OpenRewardWindow(data)
  if data == nil or data.rankId == nil then
    return
  end
  local rankReward = data.rankReward or data.rankRewardInfo
  if rankReward == nil or self.requestRankId ~= toInt(data.rankId) then
    return
  end
  self.requestRankData = rankReward
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWUICommonRankReward, {anim = true}, rankReward)
end

function SeasonCrossServerAttackCity:SetData(activityId)
  base.SetData(self, activityId)
  local seasonIndex = SeasonUtil.GetSeason()
  self.season1:SetActive(seasonIndex == 1)
  self.season3:SetActive(seasonIndex == 3)
  self.bg2:SetActive(seasonIndex == 3)
  local actData = DataCenter.ActivityListDataManager:GetActivityDataById(activityId)
  if actData then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local seasonStartTime = DataCenter.SeasonDataManager:GetSeasonStartTime()
    local para1 = actData.para1
    local para4 = actData.para4
    local para_5 = actData.para_5
    local para_6 = actData.para_6
    local para_7 = actData.para_7
    local limitTime = actData.limitTime
    local startTime = actData.startTime
    local endTime = actData.endTime
    local rankRewardList = {}
    if actData.rankRewardParam then
      for k, v in pairs(actData.rankRewardParam) do
        table.insert(rankRewardList, v)
      end
    end
    if para_5 ~= nil and para_5 ~= "" and para_5 ~= 0 then
      table.insert(rankRewardList, para_5)
    end
    self.rankRewardList = rankRewardList
    self.fightStartTime = startTime + toInt(para4) * OneHourTime * 1000
    self.fightEndTime = endTime
    self.activityData = actData
    if curTime < self.fightStartTime then
      self.open_time_tips:SetText(UIUtil.GetString("\230\180\187\229\138\168\229\141\179\229\176\134\229\188\128\229\144\175", "372114"))
    elseif curTime < self.fightEndTime then
      self.open_time_tips:SetText(UIUtil.GetString("\230\180\187\229\138\168\231\187\147\230\157\159\228\186\142", "372420"))
    else
      self.open_time_tips:SetText(UIUtil.GetString("\230\180\187\229\138\168\229\183\178\231\187\147\230\157\159", "2010333"))
    end
    if string.IsNullOrEmpty(actData.bannerTittle) then
      self.desc1:SetLocalText("activity_cross_attack_desc1")
    else
      self.desc1:SetLocalText(actData.bannerTittle)
    end
    if string.IsNullOrEmpty(actData.desc_info) then
      self.desc2:SetLocalText("activity_cross_attack_desc2")
    else
      self.desc2:SetLocalText(actData.desc_info)
    end
    if seasonIndex == 3 and not string.IsNullOrEmpty(actData.activity_pic) then
      local path = "Assets/Main/TextureEx/Season/Activity/" .. actData.activity_pic .. ".png"
      if CS.GameEntry.Resource:HasAsset(path) then
        self.bg2:LoadSprite(path)
      else
        Logger.LogError(path)
      end
    end
  end
  local seasonType, seasonVersion = SeasonUtil.GetSeasonTypeAndVersion()
  local isNewS1 = 1 <= seasonVersion and seasonType == SeasonMapType.CityStronghold
  self.btn_rank:SetActive(0 < table.count(self.rankRewardList))
  self.btn_reward:SetActive(isNewS1)
  if LuaEntry.Player:IsInAlliance() then
    self.btn_join:SetActive(false)
    self.btn_goal:SetActive(true)
  else
    self.btn_join:SetActive(true)
    self.btn_goal:SetActive(false)
    self.desc2:SetLocalText("300707")
  end
  local dataList = DataCenter.SeasonDataManager.ActCrossAttackDesertInfo
  if dataList then
    self:UpdateData(dataList)
  end
  self:Update1000MS()
  SFSNetwork.SendMessage(MsgDefines.SeasonCrossAttackCityInfo)
end

function SeasonCrossServerAttackCity:OnJoinAlliance()
  if LuaEntry.Player:IsInAlliance() then
    local seasonType, seasonVersion = SeasonUtil.GetSeasonTypeAndVersion()
    local isNewS1 = 1 <= seasonVersion and seasonType == SeasonMapType.CityStronghold
    self.btn_join:SetActive(false)
    self.btn_goal:SetActive(true)
    self.desc2:SetLocalText("activity_cross_attack_desc2")
  else
    self.btn_join:SetActive(true)
    self.btn_goal:SetActive(false)
    self.desc2:SetLocalText("300707")
  end
  SFSNetwork.SendMessage(MsgDefines.SeasonCrossAttackCityInfo)
end

function SeasonCrossServerAttackCity:UpdateData()
  if self.activityData == nil then
    return
  end
  local dataList = DataCenter.SeasonDataManager.ActCrossAttackDesertInfo
  if dataList == nil then
    return
  end
  local goItem, theItem
  self.content:RemoveComponents(CityItem)
  self.theItem:GameObjectRecycleAll()
  for i, v in ipairs(dataList) do
    v.buildId = toInt(v.buildingId)
    if WorldAllianceBuildUtil.IsAllianceCenterFlag(v.buildId) then
      local template = DataCenter.AllianceMineManager:GetAllianceMineTemplate(v.buildId)
      if template == nil then
        Logger.Log("[Debug] \229\187\186\231\173\145ID\228\184\141\229\173\152\229\156\168" .. v.buildId)
      else
        goItem = self.theItem:GameObjectSpawn(self.content.transform)
        goItem.name = "item_" .. i
        goItem:SetActive(true)
        theItem = self.content:AddComponent(CityItem, goItem.name)
        theItem:ReInit(i, v, self.fightStartTime, self.fightEndTime)
      end
    else
      Logger.Log("[Debug] \229\187\186\231\173\145ID\228\184\141\229\173\152\229\156\168" .. v.buildId)
    end
  end
end

function SeasonCrossServerAttackCity:Update1000MS()
  local deltaTime = 0
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.fightStartTime and curTime < self.fightStartTime then
    deltaTime = self.fightStartTime - curTime
  else
    if self.fightEndTime and curTime < self.fightEndTime then
      deltaTime = self.fightEndTime - curTime
    else
    end
  end
  if 0 < deltaTime then
    local showTime = UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime)
    self.open_time:SetText(showTime)
  else
    self.open_time:SetText("00:00:00")
  end
end

return SeasonCrossServerAttackCity
