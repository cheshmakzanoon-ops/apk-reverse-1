local base = UIBaseView
local LWSeasonAwardsView = BaseClass("LWSeasonAwardsView", base)
local Localization = CS.GameEntry.Localization
local LWSeasonComboBox = require("UI.LWSeasonShared.Component.LWSeasonComboBox")
local AllianceMemberListCom = require("UI.LWSeason.LWSeasonAwards.Component.AllianceMemberListCom")
local MemberRankAwardItem = require("UI.LWSeason.LWSeasonAwards.Component.UILWAllianceMemberRankAwardItem")
local tenMins = 600000
local flag_path = "Root/MiddleContentContainer/FlagIcon"
local name_path = "Root/MiddleContentContainer/NameText"
local count1_path = "Root/MiddleContentContainer/rewards/reward1/count1"
local count2_path = "Root/MiddleContentContainer/rewards/reward2/count2"
local count3_path = "Root/MiddleContentContainer/rewards/reward3/count3"
local count4_path = "Root/MiddleContentContainer/rewards/reward4/count4"
local backBtn_path = "Root/BottomBar/BtnBack"
local countdownText_path = "Root/BottomBar/countdownText"
local rewardTierDes_path = "Root/MiddleContentContainer/Des"
local rewardBtn1_path = "Root/MiddleContentContainer/rewards/reward1/rewardBtn1"
local rewardBtn2_path = "Root/MiddleContentContainer/rewards/reward2/rewardBtn2"
local rewardBtn3_path = "Root/MiddleContentContainer/rewards/reward3/rewardBtn3"
local rewardBtn4_path = "Root/MiddleContentContainer/rewards/reward4/rewardBtn4"
local rewardImmediate_path = "Root/BottomBar/BtnReward"
local desBtn_path = "Root/DesBtn"
local publishTime_path = "Root/BottomBar/publishTime"
local rewardObj1_path = "Root/MiddleContentContainer/rewards/reward1"
local rewardObj2_path = "Root/MiddleContentContainer/rewards/reward2"
local rewardObj3_path = "Root/MiddleContentContainer/rewards/reward3"
local rewardObj4_path = "Root/MiddleContentContainer/rewards/reward4"
local sort_title_path = "Root/MiddleContentContainer/memberList/SortTitle"
local scroll_view_path = "Root/MiddleContentContainer/memberList/ScrollView"
local rank_list_path = "Root/MiddleContentContainer/memberList/RankList"
local select_mode_path = "Root/MiddleContentContainer/memberList/SelectMode"

local function OnCreate(self)
  base.OnCreate(self)
  SFSNetwork.SendMessage(MsgDefines.LWSeasonSettlementRewardInfo)
  self.allianceMemberDevotesRank = DataCenter.SeasonRewardDataManager:FetchAllianceMemberDevotesRank()
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshView()
  self.rewardImmediate:SetActive(false)
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.flag = self:AddComponent(UIImage, flag_path)
  self.name = self:AddComponent(UIText, name_path)
  self.count1 = self:AddComponent(UIText, count1_path)
  self.count2 = self:AddComponent(UIText, count2_path)
  self.count3 = self:AddComponent(UIText, count3_path)
  self.count4 = self:AddComponent(UIText, count4_path)
  self.backBtn = self:AddComponent(UIButton, backBtn_path)
  self.countdownText = self:AddComponent(UIText, countdownText_path)
  self.rewardTierDes = self:AddComponent(UIText, rewardTierDes_path)
  self.rewardBtn1 = self:AddComponent(UIButton, rewardBtn1_path)
  self.rewardBtn2 = self:AddComponent(UIButton, rewardBtn2_path)
  self.rewardBtn3 = self:AddComponent(UIButton, rewardBtn3_path)
  self.rewardBtn4 = self:AddComponent(UIButton, rewardBtn4_path)
  self.rewardImmediate = self:AddComponent(UIButton, rewardImmediate_path)
  self.desBtn = self:AddComponent(UIButton, desBtn_path)
  self.publishTime = self:AddComponent(UIText, publishTime_path)
  self.rewardObj1 = self:AddComponent(UIBaseContainer, rewardObj1_path)
  self.rewardObj2 = self:AddComponent(UIBaseContainer, rewardObj2_path)
  self.rewardObj3 = self:AddComponent(UIBaseContainer, rewardObj3_path)
  self.rewardObj4 = self:AddComponent(UIBaseContainer, rewardObj4_path)
  self.backBtn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.rewardBtn3:SetOnClick(function()
    self:ShowRewardInfoTip(4, self.rewardBtn3)
  end)
  self.rewardBtn2:SetOnClick(function()
    self:ShowRewardInfoTip(3, self.rewardBtn2)
  end)
  self.rewardBtn1:SetOnClick(function()
    self:ShowRewardInfoTip(2, self.rewardBtn1)
  end)
  self.rewardBtn4:SetOnClick(function()
    self:ShowRewardInfoTip(5, self.rewardBtn4)
  end)
  self.rewardImmediate:SetOnClick(function()
    self:RewardImmediateBtn()
  end)
  self.desBtn:SetOnClick(function()
    self:DesBtnClick()
  end)
  self.rewardImmediate:SetActive(false)
  self.allianceMemList = self:AddComponent(AllianceMemberListCom, scroll_view_path)
  self.sort_title = self:AddComponent(UITextMeshProUGUIEx, sort_title_path)
  self.rank_list = self:AddComponent(UIScrollView, rank_list_path)
  self.select_mode = self:AddComponent(LWSeasonComboBox, select_mode_path)
  self.rank_list:SetOnItemMoveIn(function(itemObj, index)
    self:OnRankItemMoveIn(itemObj, index)
  end)
  self.rank_list:SetOnItemMoveOut(function(itemObj, index)
    self:OnRankItemMoveOut(itemObj, index)
  end)
end

local function ComponentDestroy(self)
  self.flag = nil
  self.name = nil
  self.count1 = nil
  self.count2 = nil
  self.count3 = nil
  self.count4 = nil
  self.backBtn = nil
  self.countdownText = nil
  self.rewardTierDes = nil
  self.rewardBtn1 = nil
  self.rewardBtn2 = nil
  self.rewardBtn3 = nil
  self.rewardBtn4 = nil
  self.rewardImmediate = nil
  self.desBtn = nil
  self.publishTime = nil
  self.rewardObj1 = nil
  self.rewardObj2 = nil
  self.rewardObj3 = nil
  self.rewardObj4 = nil
  self:ClearScroll()
  self.sort_title = nil
  self.rank_list = nil
  self.select_mode = nil
  self.allianceMemList = nil
  self.configHelp = nil
end

local function DataDefine(self)
  self.rewardTier = self:GetUserData()
  DataCenter.SeasonRewardDataManager:SetOpenRewardTier(self.rewardTier)
end

local function DataDestroy(self)
  self.rewardTier = nil
  DataCenter.SeasonRewardDataManager:SetOpenRewardTier(self.rewardTier)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.LWSeasonAllianceRewardMember, self.RefreshContent)
  self:AddUIListener(EventId.LWSeasonAllianceRewardCountUpdate, self.RefreshRewardInfo)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.LWSeasonAllianceRewardMember, self.RefreshContent)
  self:RemoveUIListener(EventId.LWSeasonAllianceRewardCountUpdate, self.RefreshRewardInfo)
  base.OnRemoveListener(self)
end

local function RefreshView(self)
  self.endTime = DataCenter.SeasonDataManager:GetSeasonEndTime()
  self.updateCountdown = true
  local alInfos = self.ctrl:GetAlInfos()
  if alInfos then
    self.flag:LoadSprite(string.format(AL_FLAG_SPRITE_PATH, alInfos.icon))
    self.name:SetText(alInfos.name)
  else
    self.name:SetText("")
  end
  self:RefreshRewardInfo()
  local configId = DataCenter.SeasonRewardDataManager:GetAllianceRewardConfigData(self.rewardTier)
  if configId then
    local line = LocalController:instance():getLine(TableName.LW_Season_Alliance_Reward, configId)
    if line then
      self.configHelp = line.help
      self.rewardTierDes:SetText(Localization:GetString("season_reward_ui_009", Localization:GetString(line.tier_name)))
    end
  end
  self:InitComboBox()
  self:RefreshContent()
  self:Update1000MS()
end

local function Update1000MS(self)
  if self.updateCountdown and self.endTime then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local remainTime = self.endTime - curTime
    if 0 < remainTime then
      local str = UITimeManager:GetInstance():MilliSecondToFmtString(remainTime)
      str = "<color=#ffcd87>" .. str .. "</color>"
      self.countdownText:SetText(Localization:GetString("season_reward_ui_012") .. str)
    else
      self.countdownText:SetText("")
    end
  end
end

local function ShowRewardInfoTip(self, index, btn)
  local reward = DataCenter.SeasonRewardDataManager:GetAllianceRewardData(self.rewardTier)
  local configId = DataCenter.SeasonRewardDataManager:GetAllianceRewardConfigData(self.rewardTier)
  if reward and configId then
    local line = LocalController:instance():getLine(TableName.LW_Season_Alliance_Reward, configId)
    self.configHelp = line.help
    reward = reward[index]
    if reward and line then
      local diamond = 0
      if index == 5 then
        diamond = line.commander_diamonds or 0
      else
        local diamonds = string.split(line.diamonds, "|")
        diamond = diamonds[index] or 0
      end
      local parame = reward.reward
      local isLeft = index == 2 or index == 5
      local x = btn.transform.position.x
      local y = btn.transform.position.y
      local width = btn.rectTransform.rect.width
      if isLeft then
        width = width * 0.75
      else
      end
      local btnAnchor = isLeft and CommonBoxShowRewardTipAnchor.Left or CommonBoxShowRewardTipAnchor.Right
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWCommonBoxShowRewardTip, Localization:GetString("370101", diamond), x, y, btnAnchor, width, 0, parame)
    end
  end
end

local function RefreshRewardInfo(self)
  local rewardRemain = DataCenter.SeasonRewardDataManager:GetRewardRemain(self.rewardTier)
  local size = #rewardRemain
  if size ~= 0 then
    for i = 1, 4 do
      self["rewardObj" .. i]:SetActive(i <= size)
      if i <= size then
        self["count" .. i]:SetText(Localization:GetString("season_reward_ui_010", rewardRemain[i]))
      end
    end
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local remainTime = self.endTime - curTime
  local flag = remainTime > tenMins
  local assigned = DataCenter.SeasonRewardDataManager:CheckAllMemberAssigned()
  self.rewardImmediate:SetActive(flag and assigned)
  local showPublish = DataCenter.SeasonRewardDataManager:SeasonRewardShowPublishedTime()
  self.publishTime:SetActive(showPublish)
  if showPublish then
    local str = DataCenter.SeasonRewardDataManager:SeasonRewardPublishTimeStr()
    self.publishTime:SetText(Localization:GetString("season_s1_rank_reward_4", str))
  end
  if DataCenter.SeasonRewardDataManager:SeasonRewardAllPublished() then
    self.updateCountdown = false
    self.countdownText:SetText(Localization:GetString("season_extra_tips_12"))
  end
end

local function RewardImmediateBtn(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local remainTime = self.endTime - curTime
  local flag = remainTime > tenMins
  if flag then
    local time = LuaEntry.DataConfig:TryGetNum("reward_confirmation_countdown", "k1")
    if time == nil then
      time = 10
    end
    local delayParam = {
      delayTime = time,
      des1 = "season_alliance_reward_tips_1",
      des2 = "season_alliance_reward_tips_2"
    }
    UIUtil.ShowSecondMessage(Localization:GetString("season_extra_tips_07"), Localization:GetString("season_extra_tips_08"), 2, "", "", function()
      local curTime = UITimeManager:GetInstance():GetServerTime()
      local remainTime = self.endTime - curTime
      local flag = remainTime > tenMins
      if flag then
        SFSNetwork.SendMessage(MsgDefines.LWSeasonSettlementAlliRewardAll)
      end
    end, nil, nil, nil, nil, nil, nil, nil, nil, false, nil, delayParam)
  end
end

function LWSeasonAwardsView:DesBtnClick()
  if not string.IsNullOrEmpty(self.configHelp) then
    local param = {}
    param.activityRulesStr = Localization:GetString(self.configHelp)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
  end
end

function LWSeasonAwardsView:InitComboBox()
  local eventIds = DataCenter.SeasonDataManager:GetSeasonHeroEventIds()
  local isFarmer = DataCenter.SeasonFarmerManager:IsActive()
  local ComboBoxDataList = {}
  if isFarmer then
    local config = DataCenter.SeasonFarmerTemplateManager:GetMainCfg()
    if config then
      local eventId = toInt(config.heroevent)
      if 0 < eventId then
        local heroEventMeta = LocalController:instance():getLine(TableName.HeroEvent, eventId)
        if heroEventMeta then
          local name = Localization:GetString(heroEventMeta.name)
          table.insert(ComboBoxDataList, {
            txt = Localization:GetString("season_reward_opt_01", name),
            key = eventId,
            isLocal = true
          })
        end
      end
    end
  end
  for i, v in ipairs(eventIds) do
    local eventId = toInt(v)
    if 0 < eventId then
      local heroEventMeta = LocalController:instance():getLine(TableName.HeroEvent, eventId)
      if heroEventMeta then
        local name = Localization:GetString(heroEventMeta.name)
        table.insert(ComboBoxDataList, {
          txt = Localization:GetString("season_reward_opt_01", name),
          key = eventId,
          isLocal = true
        })
      end
    end
  end
  self.sort_title:SetLocalText("season_reward_opt_02")
  table.insert(ComboBoxDataList, {
    txt = Localization:GetString("season_reward_opt_02"),
    key = 0,
    isLocal = true
  })
  self.select_mode:SelectedIndexChanged(nil)
  self.select_mode:FillData(ComboBoxDataList, #ComboBoxDataList)
  self.select_mode:SelectedIndexChanged(function(index, data)
    self:OnSelectedIndexChanged(index, data)
  end)
end

function LWSeasonAwardsView:OnSelectedIndexChanged(index, data)
  self.selectData = data
  self:RefreshContent()
end

function LWSeasonAwardsView:RefreshContent()
  local eventId = 0
  local data = self.selectData
  if data then
    eventId = data.key
  end
  if eventId == 0 then
    self.sort_title:SetLocalText("season_reward_opt_02")
    self.allianceMemList:SetActive(true)
    self.rank_list:SetActive(false)
    self.allianceMemList:RefreshContent()
  elseif data then
    if data.isLocal == true then
      self.sort_title:SetText(data.txt)
    else
      self.sort_title:SetLocalText(data.txt)
    end
    self.allianceMemList:SetActive(false)
    local memberList = DataCenter.SeasonRewardDataManager.seasonRewardMemeberList
    local dataCount = table.count(memberList)
    if dataCount == 0 then
      self.rank_list:SetActive(false)
    else
      local allianceMemberDevotesRank = DataCenter.SeasonRewardDataManager.allianceMemberDevotesRank
      local allianceMemberDevotesRankDict = DataCenter.SeasonRewardDataManager.allianceMemberDevotesRankDict
      local memberListNew = {}
      local rankData, rankDataDict
      if allianceMemberDevotesRank then
        rankData = allianceMemberDevotesRank[tostring(eventId)]
      end
      if allianceMemberDevotesRankDict then
        rankDataDict = allianceMemberDevotesRankDict[tostring(eventId)]
      end
      if rankData ~= nil and rankDataDict == nil then
        rankDataDict = {}
        if allianceMemberDevotesRankDict == nil then
          DataCenter.SeasonRewardDataManager.allianceMemberDevotesRankDict = {}
        end
        for k, v in ipairs(rankData) do
          rankDataDict[v.uid] = v
        end
        DataCenter.SeasonRewardDataManager.allianceMemberDevotesRankDict[tostring(eventId)] = rankDataDict
      end
      if rankDataDict == nil then
        rankDataDict = {}
      end
      if table.count(self.memberListNew) ~= table.count(memberList) then
        local ctrl = self.ctrl
        for uid, uData in pairs(memberList) do
          local oneData = ctrl:SwitchMemberData(uData)
          if oneData.rank ~= 5 then
            local tmp = rankDataDict[uid]
            if tmp then
              oneData.event_score = toInt(tmp.score)
              oneData.event_rank = toInt(tmp.rank)
            else
              oneData.event_score = 0
              oneData.event_rank = 999
            end
            table.insert(memberListNew, oneData)
          end
        end
        self.memberListNew = memberListNew
      else
        memberListNew = self.memberListNew
        for uid, oneData in pairs(memberListNew) do
          local tmp = rankDataDict[uid]
          if tmp then
            oneData.event_score = toInt(tmp.score)
            oneData.event_rank = toInt(tmp.rank)
          else
            oneData.event_score = 0
            oneData.event_rank = 999
          end
        end
      end
      table.sort(memberListNew, function(a, b)
        if a.event_rank == b.event_rank then
          if a.rank == b.rank then
            if a.power == b.power then
              return a.mainCityLv > b.mainCityLv
            else
              return a.power > b.power
            end
          else
            return a.rank > b.rank
          end
        end
        return a.event_rank < b.event_rank
      end)
      self.rank_list:SetActive(true)
      self.rank_list:SetTotalCount(#memberListNew)
      self.rank_list:RefillCells()
    end
  end
  self:RefreshRewardInfo()
end

function LWSeasonAwardsView:OnRankItemMoveIn(itemObj, index)
  itemObj.name = "RankItem_" .. UIUtil.GetLoopListItemIndex()
  local cellItem = self.rank_list:AddComponent(MemberRankAwardItem, itemObj)
  if cellItem ~= nil then
    cellItem:SetData(index, self.memberListNew[index])
  end
end

function LWSeasonAwardsView:OnRankItemMoveOut(itemObj, index)
  self.rank_list:RemoveComponent(itemObj.name, MemberRankAwardItem)
end

function LWSeasonAwardsView:ClearScroll()
  self.rank_list:ClearCells()
  self.rank_list:RemoveComponents(MemberRankAwardItem)
end

LWSeasonAwardsView.OnCreate = OnCreate
LWSeasonAwardsView.OnDestroy = OnDestroy
LWSeasonAwardsView.ComponentDefine = ComponentDefine
LWSeasonAwardsView.ComponentDestroy = ComponentDestroy
LWSeasonAwardsView.DataDefine = DataDefine
LWSeasonAwardsView.DataDestroy = DataDestroy
LWSeasonAwardsView.OnAddListener = OnAddListener
LWSeasonAwardsView.OnRemoveListener = OnRemoveListener
LWSeasonAwardsView.RefreshView = RefreshView
LWSeasonAwardsView.Update1000MS = Update1000MS
LWSeasonAwardsView.ShowRewardInfoTip = ShowRewardInfoTip
LWSeasonAwardsView.RewardImmediateBtn = RewardImmediateBtn
LWSeasonAwardsView.RefreshRewardInfo = RefreshRewardInfo
return LWSeasonAwardsView
