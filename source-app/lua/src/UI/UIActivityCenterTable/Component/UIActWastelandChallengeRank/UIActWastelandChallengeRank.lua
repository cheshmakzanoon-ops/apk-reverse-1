local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local UIActWastelandChallengeRank = BaseClass("UIActWastelandChallengeRank", base)
local Localization = CS.GameEntry.Localization
local RectTransform = typeof(CS.UnityEngine.RectTransform)
local RankItem = require("UI/UIActivityCenterTable/Component/UIActWastelandChallengeRank/WasteLandRankItem")
local UIActWastelandBoxRewardItem = require("UI.UIActivityCenterTable.Component.UIActWastelandChallengeRank.UIActWastelandBoxRewardItem")
local rank_item1_path = "content/Rank/RankItem1"
local rank_item2_path = "content/Rank/RankItem2"
local rank_item3_path = "content/Rank/RankItem3"
local info_version1_path = "content/InfoVersion1"
local des_btn_path = "content/rightTop/DesBtn"
local htp_btn_path = "content/rightTop/HtpBtn"
local intro_btn_path = "content/rightTop/IntroBtn"
local reward_btn_path = "content/rightTop/RewardBtnContent/RewardBtn"
local right_top_rank_btn_path = "content/rightTop/RankBtn/rightTopRankBtn"
local right_top_info_btn_path = "content/rightTop/InfoBtn/InfoBtn"
local jump_btn_path = "bottom/JumpBtn"
local jump_btn_des_path = "bottom/JumpBtn/JumpBtnDes"
local bg_parent_path = "bgParent"
local default_bg_path = "Assets/Main/Prefabs/UI/ActivityCenter/WastelandChallengeRank/desertBg.prefab"
local info_version1_title1_path = "content/InfoVersion1/content1/InfoVersion1_title1"
local info_version1_title2_path = "content/InfoVersion1/content1/InfoVersion1_title2"
local countdown_parent_path = "content/InfoVersion1/content1/countdownParent"
local countdown_path = "content/InfoVersion1/content1/countdownParent/countdownRoot/countdown"
local info_version1_des_path = "content/Rank/Txt_Tip/InfoVersion1_des"
local info_version1_old_des_path = "content/Rank/Txt_Tip_Old/InfoVersion2_des"
local content1_path = "content/InfoVersion1/content1"
local box_content_path = "content/Rank/SliderReward/boxContent"
local self_rank_item_path = "content/Rank/SelfRankItem"
local txt_tip_path = "content/Rank/Txt_Tip"
local txt_tip_old_path = "content/Rank/Txt_Tip_Old"
local txt_empty_path = "content/Rank/Txt_Empty"
local rank_path = "content/Rank"
local txt_space_path = "content/Rank/Txt_Space"
local img_bg_path = "content/Rank/img_bg"

function UIActWastelandChallengeRank:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIActWastelandChallengeRank:OnDestroy()
  self:DeleteTimer()
  self:ComponentDestroy()
  self.rewardReqs = nil
  base.OnDestroy(self)
end

function UIActWastelandChallengeRank:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.LWSeasonWastedlandChallengeRankRewardInfoUpdate, self.OpenRewardWindow)
  self:AddUIListener(EventId.LWSeasonWastedlandChallengeMainRankInfoUpdate, self.RefreshMainRank)
  self:AddUIListener(EventId.LWSeasonWastedlandChallengeRankInfoUpdate, self.RefreshMainRank)
end

function UIActWastelandChallengeRank:OnRemoveListener()
  self:RemoveUIListener(EventId.LWSeasonWastedlandChallengeRankRewardInfoUpdate, self.OpenRewardWindow)
  self:RemoveUIListener(EventId.LWSeasonWastedlandChallengeMainRankInfoUpdate, self.RefreshMainRank)
  self:RemoveUIListener(EventId.LWSeasonWastedlandChallengeRankInfoUpdate, self.RefreshMainRank)
  base.OnRemoveListener(self)
end

function UIActWastelandChallengeRank:ComponentDefine()
  self.countdown = self:AddComponent(UITextMeshProUGUIEx, countdown_path)
  self.rank_item1 = self:AddComponent(RankItem, rank_item1_path)
  self.rank_item2 = self:AddComponent(RankItem, rank_item2_path)
  self.rank_item3 = self:AddComponent(RankItem, rank_item3_path)
  self.box_content = self:AddComponent(UIBaseContainer, box_content_path)
  self.self_rank_item = self:AddComponent(RankItem, self_rank_item_path)
  self.bg_parent = self:AddComponent(UIBaseContainer, bg_parent_path)
  self.txt_tip = self:AddComponent(UIBaseContainer, txt_tip_path)
  self.txt_tip_old = self:AddComponent(UIBaseContainer, txt_tip_old_path)
  self.txt_empty = self:AddComponent(UIBaseContainer, txt_empty_path)
  self.txt_space = self:AddComponent(UIBaseContainer, txt_space_path)
  self.info_version1 = self:AddComponent(UIBaseContainer, info_version1_path)
  self.info_version1_title1 = self:AddComponent(UITextMeshProUGUIEx, info_version1_title1_path)
  self.info_version1_title2 = self:AddComponent(UITextMeshProUGUIEx, info_version1_title2_path)
  self.info_version1_des = self:AddComponent(UITextMeshProUGUIEx, info_version1_des_path)
  self.info_version1_des_old = self:AddComponent(UITextMeshProUGUIEx, info_version1_old_des_path)
  self.right_top_rank_btn = self:AddComponent(UIButton, right_top_rank_btn_path)
  self.right_top_info_btn = self:AddComponent(UIButton, right_top_info_btn_path)
  self.jump_btn = self:AddComponent(UIButton, jump_btn_path)
  self.jump_btn_des = self:AddComponent(UITextMeshProUGUIEx, jump_btn_des_path)
  self.countdown_parent = self:AddComponent(UIBaseContainer, countdown_parent_path)
  self.content1 = self:AddComponent(UIBaseContainer, content1_path)
  self.rank = self:AddComponent(UIBaseContainer, rank_path)
  self.right_top_rank_btn:SetOnClick(function()
    self:ShowRank()
  end)
  self.right_top_info_btn:SetOnClick(function()
    self:ShowInfo()
  end)
  for i = 1, 3 do
    self["rank_item" .. i]:RefreshData(nil)
  end
  self.self_rank_item:SetActive(false)
  self.self_rank_item:SetSelfMode(true)
  self.self_rank_item:RefreshData(nil)
  self.reward_btn = self:AddComponent(UIButton, reward_btn_path)
  self.reward_btn:SetOnClick(function()
    self:ShowReward()
  end)
  self.intro_btn = self:AddComponent(UIButton, intro_btn_path)
  self.intro_btn:SetOnClick(function()
    self:InfoClick()
  end)
  
  function self.timer_action(temp)
    self:RefreshTime(temp)
  end
  
  self.des_btn = self:AddComponent(UIButton, des_btn_path)
  self.des_btn:SetOnClick(function()
    self:DesClick()
  end)
  self.htpBtn = self:AddComponent(UIButton, htp_btn_path)
  self.htpBtn:SetOnClick(function()
    self:OnBtnHelpClick()
  end)
  self.jump_btn:SetOnClick(function()
    self:JumpBtnClick()
  end)
  self.reward_btn:SetActive(false)
  self.intro_btn:SetActive(false)
  self.right_top_rank_btn:SetActive(false)
  self.right_top_info_btn:SetActive(false)
  self.jump_btn:SetActive(false)
  self.img_bg = self:AddComponent(UIImage, img_bg_path)
end

function UIActWastelandChallengeRank:ComponentDestroy()
  self.reward_btn = nil
  self.countdown = nil
  self.timer_action = nil
  self.rank_item1 = nil
  self.rank_item2 = nil
  self.rank_item3 = nil
  self.box_content = nil
  self.self_rank_item = nil
  self.info_version1 = nil
  self.info_version1_title1 = nil
  self.info_version1_title2 = nil
  self.info_version1_des = nil
  self.info_version1_des_old = nil
  self.des_btn = nil
  self.right_top_rank_btn = nil
  self.right_top_info_btn = nil
  self.jump_btn = nil
  self.jump_btn_des = nil
  self.bg_parent = nil
  self.countdown_parent = nil
  self.content1 = nil
  self.txt_tip = nil
  self.txt_tip_old = nil
  self.txt_empty = nil
  self.rank = nil
  self.txt_space = nil
  self.img_bg = nil
end

function UIActWastelandChallengeRank:OnEnable()
  base.OnEnable(self)
end

function UIActWastelandChallengeRank:OnDisable()
  self.sendRankRewardMsg = false
  base.OnDisable(self)
end

function UIActWastelandChallengeRank:CanShowSelf()
  if self.activityInfo then
    if self.activityInfo.type == 223 then
      return not string.IsNullOrEmpty(self.activityInfo.tableInfo)
    elseif self.activityInfo.type == 224 then
      return self.activityInfo.para_2 ~= nil and checknumber(self.activityInfo.para_2) == 1
    end
  end
  return false
end

function UIActWastelandChallengeRank:SetData(activityId)
  self.activityId = tonumber(activityId)
  if not self.activityId then
    return
  end
  self.activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  self.htpBtn:SetActive(self.activityInfo and not table.IsNullOrEmpty(self.activityInfo.howtoplay))
  local tabData = LocalController:instance():getLine(TableName.Activity, toInt(activityId))
  local bgPath
  if not string.IsNullOrEmpty(tabData.para_6) then
    bgPath = tabData.para_6
  else
    bgPath = default_bg_path
  end
  if DataCenter.BloodyNightDataManager:IsBloodyNight() then
    local darkPath = bgPath:gsub(".prefab", "_xueye.prefab")
    if CS.GameEntry.Resource:HasAsset(darkPath) then
      bgPath = darkPath
    end
  end
  self.bgRequest = self:GameObjectInstantiateAsync(bgPath, function(request)
    if request.isError then
      return
    end
    self.bgRequest = nil
    local go = request.gameObject
    go.transform:SetParent(self.bg_parent.transform)
    go.transform:Set_localScale(1, 1, 1)
    local tfx = go.transform:GetComponent(RectTransform)
    tfx:Set_offsetMax(0, 0)
    tfx:Set_offsetMin(0, 0)
    go.name = "bg"
  end)
  if self.activityInfo then
    self.rankValueDes = self:GetRankValueDes()
    self.serverValueDes = self:GetServerValueDes()
    self.activityRankType = self:GetRankType()
    for i = 1, 3 do
      self["rank_item" .. i]:RefreshData(nil, self.rankValueDes, self.activityRankType, self.serverValueDes)
    end
    if self:CanShowSelf() then
      self.self_rank_item:RefreshData(nil, self.rankValueDes, self.activityRankType, self.serverValueDes)
    end
    self.info_version1:SetActive(true)
    self.countdown_parent:SetActive(true)
    self:RefreshTime()
    self:AddTimer(self.activityInfo)
    self.reward_btn:SetActive(self:CheckRewardBtnState())
    self.intro_btn:SetActive(self:CheckInfoBtnState())
    self.right_top_rank_btn:SetActive(self:CheckRankBtnState())
    self.right_top_info_btn:SetActive(self:CheckCityInfoBtnState())
    self.jump_btn:SetActive(self:CheckJumpBtnState())
    local name = Localization:GetString(self.activityInfo.name)
    self.info_version1_title1:SetText(name)
    local topPos = -260
    if not string.IsNullOrEmpty(self.activityInfo.bannerTittle) then
      self.info_version1_title2:SetActive(true)
      self.info_version1_title2:SetText(Localization:GetString(self.activityInfo.bannerTittle))
    else
      topPos = -140
      self.info_version1_title2:SetActive(false)
      self.info_version1_title2:SetText("")
    end
    self.countdown_parent:SetAnchoredPositionXY(0, topPos)
    if not string.IsNullOrEmpty(self.activityInfo.desc_info) then
      self.info_version1_des:SetText(Localization:GetString(self.activityInfo.desc_info))
      self.info_version1_des_old:SetText(Localization:GetString(self.activityInfo.desc_info))
      if self:CanShowSelf() then
        self.txt_tip_old:SetActive(false)
        self.txt_tip:SetActive(true)
      else
        self.txt_tip_old:SetActive(true)
        self.txt_tip:SetActive(false)
      end
    else
      self.info_version1_des:SetText("")
      self.info_version1_des_old:SetText("")
      self.txt_tip_old:SetActive(false)
      self.txt_tip:SetActive(false)
    end
  else
    self.countdown_parent:SetActive(false)
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content1.rectTransform)
  self:SendMsg()
  self:RefreshMainRank(self.activityId)
  self:RefreshBoxReward()
  self.txt_space:SetActive(false)
  if not self:CanShowSelf() then
    self.txt_space:SetActive(self.activityInfo.type == 223)
  end
  self.img_bg:SetActive(self:CanShowSelf())
end

function UIActWastelandChallengeRank:SendMsg()
  SFSNetwork.SendMessage(MsgDefines.LWSeasonWastelandMainInfo, self.activityId, self.activityRankType)
  SFSNetwork.SendMessage(MsgDefines.LWSeasonWastedRankShowInfo, self.activityId, self.activityRankType)
end

function UIActWastelandChallengeRank:AddTimer(actListData)
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, actListData, false, false, false)
  end
  self.timer:Start()
end

function UIActWastelandChallengeRank:RefreshTime()
  local data = self.activityInfo
  if data then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if data.endTime and curTime < data.endTime then
      self.countdown:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(data.endTime - curTime))
    elseif data.endViewTime and curTime < data.endViewTime then
      local msg = Localization:GetString("370100")
      self.countdown:SetText(msg .. "\n" .. UITimeManager:GetInstance():MilliSecondToFmtString(data.endViewTime - curTime))
    else
      self:DeleteTimer()
      self.countdown_parent:SetActive(false)
    end
  else
    self:DeleteTimer()
    self.countdown_parent:SetActive(false)
  end
end

function UIActWastelandChallengeRank:DeleteTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function UIActWastelandChallengeRank:ShowRank()
  if self.activityInfo.type == EnumActivity.SeasonAttackWorldDesertActivity.Type then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonTrendsRank, CommonRankPanelType.WastedlandRank, self.activityId)
  elseif self.activityInfo.type == EnumActivity.SeasonKillMonsterRank.Type then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonTrendsRank, CommonRankPanelType.WastedlandRank, self.activityId)
  elseif self.activityInfo.type == EnumActivity.SeasonStrongholdRank.Type then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonTrendsRank, CommonRankPanelType.WastedlandRankWithAlliance, self.activityId, CommonActivityRankType.ALLINCE)
  end
end

function UIActWastelandChallengeRank:ShowReward()
  self.sendRankRewardMsg = true
  SFSNetwork.SendMessage(MsgDefines.LWSeasonWastedRankShowInfo, self.activityId, self.activityRankType)
end

function UIActWastelandChallengeRank:ShowInfo()
  if self.activityInfo.type == EnumActivity.SeasonStrongholdRank.Type then
    UIManager:GetInstance():OpenWindow(UIWindowNames.BankCity, {anim = true}, self.activityId)
  end
end

function UIActWastelandChallengeRank:OpenRewardWindow(activityId)
  if self.sendRankRewardMsg then
    self.sendRankRewardMsg = false
    if activityId and self.activityId then
      local reward = DataCenter.LWSeasonTrendsManager:GetWastedlandRankRewardList(self.activityId, self.activityRankType)
      if reward and 0 < #reward then
        UIManager:GetInstance():OpenWindow(UIWindowNames.LWUICommonRankReward, {anim = true}, reward)
      end
    end
  else
    self:RefreshMainRank(activityId)
  end
end

function UIActWastelandChallengeRank:DesClick()
  if self.activityInfo ~= nil and self.activityInfo.story ~= nil then
    local param = {}
    param.activityId = self.activityId
    param.activityRulesStr = Localization:GetString(self.activityInfo.story)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
  end
end

function UIActWastelandChallengeRank:JumpBtnClick()
  if self.activityInfo.type == EnumActivity.SeasonKillMonsterRank.Type then
    GoToUtil.GoToByTypeAndParam(QuestGoType.GoWorldSearch)
  elseif self.activityInfo.type == EnumActivity.SeasonStrongholdRank.Type then
    if LuaEntry.Player:IsInAlliance() == false then
      if LuaEntry.Player:IsFirstJoinAlliance() == true then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAllianceFirstJoin, {anim = true})
        return
      end
      local params = {guide = false}
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlCreateJoin, {anim = true}, params)
    else
      local serverId, cityId = SeasonUtil.GetStrongholdInBattle()
      if serverId == nil or cityId == nil then
        GoToUtil.GotoNearestCityStronghold(true)
      else
        local meta = DataCenter.AllianceCityTemplateManager:GetTemplate(cityId, serverId)
        if meta == nil then
          GoToUtil.GotoNearestCityStronghold(true)
        else
          meta:JumpTo()
        end
      end
    end
  end
end

function UIActWastelandChallengeRank:InfoClick()
  if self.activityInfo ~= nil and self.activityInfo.ppt_show ~= nil then
    local group = toInt(self.activityInfo.ppt_show)
    if group ~= 0 then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWWorldTip, {anim = false}, group)
    end
  end
end

function UIActWastelandChallengeRank:RefreshBoxReward()
  local rewardList = DataCenter.LWSeasonWastelandDataManager:GetBoxRewardByActivityId(self.activityId)
  local canShow = 0 < #rewardList
  self.box_content:SetActive(canShow)
  if canShow and self.rewardReqs == nil then
    self.rewardReqs = self:GameObjectInstantiateAsync(UIAssets.WastelandChallengeBoxReward, function(req)
      if IsNull(req.gameObject) then
        return
      end
      local go = req.gameObject
      local nameStr = "UIActWastelandBoxRewardItem"
      go.name = nameStr
      go:SetActive(true)
      local transform = go.transform
      transform:SetParent(self.box_content.transform)
      transform:Set_localScale(1, 1, 1)
      transform:Set_pivot(0, 1)
      local item = self.box_content:AddComponent(UIActWastelandBoxRewardItem, nameStr)
      item:ReInit(self.activityId)
    end)
  end
end

function UIActWastelandChallengeRank:GetSelfRankData(oneData)
  local Player = LuaEntry.Player
  local allianceData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
  oneData.isAlliance = false
  oneData.serverId = LuaEntry.Player:GetSourceServerId()
  if allianceData == nil or allianceData.abbr == nil or allianceData.abbr == "" then
    oneData.firstName = Player:GetName()
  elseif LuaEntry.Player:IsInAlliance() then
    oneData.firstName = "[" .. allianceData.abbr .. "] " .. Player:GetName()
    oneData.allianceAbbr = allianceData.abbr
    oneData.abbr = allianceData.abbr
    oneData.allianceName = allianceData.allianceName
  else
    oneData.firstName = Player:GetName()
  end
  if self.activityRankType == CommonActivityRankType.PERSONAL then
    oneData.uid = Player:GetUid()
  elseif allianceData ~= nil then
    oneData.uid = allianceData.uid
  end
  oneData.pic = Player:GetPic()
  oneData.picVer = Player.picVer
  oneData.headFrame = Player:GetHeadBgImg()
  oneData.srcServer = Player:GetSourceServerId()
  oneData.name = Player:GetName()
  return oneData
end

function UIActWastelandChallengeRank:RefreshMainRank(activityId)
  if self.activityId == activityId then
    local rewardList = DataCenter.LWSeasonTrendsManager:GetWastedlandRankRewardList(self.activityId, self.activityRankType)
    if rewardList == nil then
      return
    end
    rewardList.rankConfigId = self:GetRankConfigId()
    local medalRank = DataCenter.LWSeasonTrendsManager:GetWastedlandMedalRank(activityId, self.activityRankType) or {}
    local hasRankInfo = 0 < #medalRank
    local rankItemStr = "rank_item"
    self.txt_empty:SetActive(not hasRankInfo)
    for i = 1, 3 do
      self[rankItemStr .. i]:SetActive(hasRankInfo)
    end
    if self:CanShowSelf() then
      self.self_rank_item:SetActive(hasRankInfo)
    end
    if not hasRankInfo then
      self.rank:SetActive(true)
      CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.rank.rectTransform)
      return
    end
    for i = 1, 3 do
      self[rankItemStr .. i]:RefreshData(medalRank[i], self.rankValueDes, self.activityRankType, self.serverValueDes, rewardList)
    end
    if self:CanShowSelf() then
      local selfRank = DataCenter.LWSeasonTrendsManager:GetWastedSelfRankData(activityId, self.activityRankType)
      if selfRank then
        self.self_rank_item:RefreshData(self:GetSelfRankData(selfRank), self.rankValueDes, self.activityRankType, self.serverValueDes, rewardList)
      end
    end
  end
end

function UIActWastelandChallengeRank:GetRankValueDes()
  if self.activityInfo.type == EnumActivity.SeasonAttackWorldDesertActivity.Type then
    return Localization:GetString("season_trailblazer_rank_score_name") .. ": "
  elseif self.activityInfo.type == EnumActivity.SeasonStrongholdRank.Type then
    if string.IsNullOrEmpty(self.activityInfo.para_1) then
      return Localization:GetString("season_tips236") .. ": "
    else
      return Localization:GetString(self.activityInfo.para_1) .. ": "
    end
  elseif self.activityInfo.type == EnumActivity.SeasonKillMonsterRank.Type then
    return Localization:GetString("season_tips237") .. ": "
  end
  return ""
end

function UIActWastelandChallengeRank:GetRankConfigId()
  local rankConfigId = -1
  if string.IsNullOrEmpty(self.activityInfo.rankReward) then
    return rankConfigId
  end
  if self.activityInfo.type == EnumActivity.SeasonAttackWorldDesertActivity.Type or self.activityInfo.type == EnumActivity.SeasonKillMonsterRank.Type then
    rankConfigId = tonumber(self.activityInfo.rankReward)
  elseif self.activityInfo.type == EnumActivity.SeasonStrongholdRank.Type then
    local rankRewards = string.split(self.activityInfo.rankReward, "|")
    rankConfigId = tonumber(rankRewards[2])
  end
  return rankConfigId
end

function UIActWastelandChallengeRank:GetServerValueDes()
  if self.activityInfo.type == EnumActivity.SeasonStrongholdRank.Type then
    return Localization:GetString("457067")
  end
  return ""
end

function UIActWastelandChallengeRank:GetRankType()
  local rankType = CommonActivityRankType.PERSONAL
  if self.activityInfo.type == EnumActivity.SeasonAttackWorldDesertActivity.Type or self.activityInfo.type == EnumActivity.SeasonKillMonsterRank.Type then
    rankType = CommonActivityRankType.PERSONAL
  elseif self.activityInfo.type == EnumActivity.SeasonStrongholdRank.Type then
    rankType = CommonActivityRankType.ALLINCE
  end
  return rankType
end

function UIActWastelandChallengeRank:CheckInfoBtnState()
  if self.activityInfo ~= nil and self.activityInfo.ppt_show ~= nil then
    local group = toInt(self.activityInfo.ppt_show)
    if group ~= 0 then
      return true
    end
  end
  return false
end

function UIActWastelandChallengeRank:CheckRankBtnState()
  if self.activityInfo.type == EnumActivity.SeasonAttackWorldDesertActivity.Type then
    return false
  elseif self.activityInfo.type == EnumActivity.SeasonStrongholdRank.Type or self.activityInfo.type == EnumActivity.SeasonKillMonsterRank.Type then
    return true
  end
  return false
end

function UIActWastelandChallengeRank:CheckCityInfoBtnState()
  if self.activityInfo.type == EnumActivity.SeasonStrongholdRank.Type then
    return DataCenter.SeasonBankManager:IsCurOpen()
  end
  return false
end

function UIActWastelandChallengeRank:CheckJumpBtnState()
  if self.activityInfo.type == EnumActivity.SeasonAttackWorldDesertActivity.Type then
    return false
  elseif self.activityInfo.type == EnumActivity.SeasonStrongholdRank.Type or self.activityInfo.type == EnumActivity.SeasonKillMonsterRank.Type then
    return true
  end
  return false
end

function UIActWastelandChallengeRank:CheckRewardBtnState()
  return true
end

function UIActWastelandChallengeRank:OnBtnHelpClick()
  if not self.activityInfo then
    return
  end
  local param = {}
  param.howToPlayList = self.activityInfo.howtoplay
  param.story = self.activityInfo.story
  param.defaulfTitle = self.activityInfo.name
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWHowToPlay, {anim = true}, param)
end

return UIActWastelandChallengeRank
