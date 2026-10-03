local UIServerBattleWeekInfo = BaseClass("UIServerBattleWeekInfo", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIServerBattleWeekItem = require("UI.UIGovernment.ServerBattleMain.Component.UIServerBattleWeekItem")
local ScoreDsbDuelItem = require("UI.UIGovernment.ServerBattleMain.Component.ScoreDsbDuelItem")
local UIServerBattleWeekScoreSumItem = require("UI.UIGovernment.ServerBattleMain.Component.UIServerBattleWeekScoreSumItem")
local UIServerBattleLastKingServerInfo2 = require("UI.UIGovernment.ServerBattleMain.Component.King.UIServerBattleLastKingServerInfo2")
local server_info_title_path = "Viewport/Content/serverInfoTitle"
local info_btn_path = "Viewport/Content/InfoBtn"
local remain_time_root_path = "Viewport/Content/TimeBg"
local remain_time_path = "Viewport/Content/TimeBg/remainTime"
local score1txt_path = "Viewport/Content/serverInfo/score1txt"
local score2txt_path = "Viewport/Content/serverInfo/score2txt"
local soldier_slider1_path = "Viewport/Content/serverInfo/Score/SoldierSlider1"
local split_path = "Viewport/Content/serverInfo/Score/SoldierSlider1/Fill Area/Fill/split"
local soldier_slider2_path = "Viewport/Content/serverInfo/Score/SoldierSlider2"
local eff_ui_path = "Viewport/Content/serverInfo/Score/Eff_ui_jiasu_jindutiao_shifang"
local server_txt1_path = "Viewport/Content/serverInfo/House1/ServerBg1/ServerTxt1"
local server_txt2_path = "Viewport/Content/serverInfo/House2/ServerBg2/ServerTxt2"
local home_icon1_path = "Viewport/Content/serverInfo/House1/homeIcon1"
local home_icon2_path = "Viewport/Content/serverInfo/House2/homeIcon2"
local home_icon1_root_path = "Viewport/Content/serverInfo/House1"
local home_icon2_root_path = "Viewport/Content/serverInfo/House2"
local server_bg1_path = "Viewport/Content/serverInfo/House1/ServerBg1"
local server_bg2_path = "Viewport/Content/serverInfo/House2/ServerBg2"
local camp_iconA_path = "Viewport/Content/serverInfo/IconCampA"
local camp_iconB_path = "Viewport/Content/serverInfo/IconCampB"
local allianceInfo_path = "Viewport/Content/allianceInfo"
local allianceRoot_path = "Viewport/Content/allianceInfo/allianceRoot"
local a_l_name1_path = "Viewport/Content/allianceInfo/allianceRoot/flagIcon1/ALName1"
local a_l_score1txt_path = "Viewport/Content/allianceInfo/allianceRoot/flagIcon1/ALScore1txt"
local a_l_name2_path = "Viewport/Content/allianceInfo/allianceRoot/flagIcon2/ALName2"
local a_l_score2txt_path = "Viewport/Content/allianceInfo/allianceRoot/flagIcon2/ALScore2txt"
local flag_icon1_path = "Viewport/Content/allianceInfo/allianceRoot/flagIcon1"
local flag_icon2_path = "Viewport/Content/allianceInfo/allianceRoot/flagIcon2"
local mvpInfo_path = "Viewport/Content/allianceInfo/mvpInfo"
local no_score_path = "Viewport/Content/allianceInfo/mvpInfo/NoScore"
local user1_path = "Viewport/Content/allianceInfo/mvpInfo/User1"
local player1_path = "Viewport/Content/allianceInfo/mvpInfo/User1/Player1"
local mvp_score1txt_path = "Viewport/Content/allianceInfo/mvpInfo/User1/mvpScore1txt"
local user2_path = "Viewport/Content/allianceInfo/mvpInfo/User2"
local player2_path = "Viewport/Content/allianceInfo/mvpInfo/User2/Player2"
local mvp_score2txt_path = "Viewport/Content/allianceInfo/mvpInfo/User2/mvpScore2txt"
local content_path = "Viewport/Content/ScrollView/Viewport/Content"
local no_score2_path = "Viewport/Content/ScrollView/Viewport/NoScore2"
local scroll_view_path = "Viewport/Content/ScrollView"
local no_a_l_score1_path = "Viewport/Content/allianceInfo/allianceRoot/NoALScore1"
local no_a_l_score2_path = "Viewport/Content/allianceInfo/allianceRoot/NoALScore2"
local no_mvp_score1_path = "Viewport/Content/allianceInfo/mvpInfo/NoMvpScore1"
local no_mvp_score2_path = "Viewport/Content/allianceInfo/mvpInfo/NoMvpScore2"
local server_info2_path = "Viewport/Content/serverInfo/ServerInfo2"
local btn_alliance_rank_path = "Viewport/Content/allianceInfo/allianceRoot/allianceInfoTitle"
local btn_personal_rank_path = "Viewport/Content/allianceInfo/mvpInfo/mvp"
local lastRequestTime = 0

local function ReInitScoreSumItem(self, item, index, data)
  item:ReInit(index, data.data, data.config, data.maxScore, self.isInit)
end

local function ReInitScoreItem(self, item, index, data)
  item:ReInit(data.config, self.config, self.serverBattleType, data.data, self.leftInfo, self.rightInfo)
  item:SetAlpha(1)
end

local function ReInitScoreDsbDuelItem(self, item, index, data)
  item:ReInit(data.config, self.config, self.serverBattleType, data.data, self.leftInfo, self.rightInfo)
  item:SetAlpha(1)
end

local itemsInfo = {
  {name = "ScoreTitle"},
  {
    name = "ScoreSumItem",
    script = UIServerBattleWeekScoreSumItem,
    func = ReInitScoreSumItem
  },
  {
    name = "ScoreItem",
    script = UIServerBattleWeekItem,
    func = ReInitScoreItem
  },
  {
    name = "ScoreDsbDuel",
    script = ScoreDsbDuelItem,
    func = ReInitScoreDsbDuelItem
  }
}

function UIServerBattleWeekInfo:OnCreate()
  base.OnCreate(self)
  self.title = self:AddComponent(UIText, server_info_title_path)
  self.info_btn = self:AddComponent(UIButton, info_btn_path)
  self.remain_time_root = self:AddComponent(UIBaseComponent, remain_time_root_path)
  self.remain_time = self:AddComponent(UIText, remain_time_path)
  self.score1txt = self:AddComponent(UIText, score1txt_path)
  self.score2txt = self:AddComponent(UIText, score2txt_path)
  self.soldier_slider1 = self:AddComponent(UISlider, soldier_slider1_path)
  self.soldier_slider2 = self:AddComponent(UISlider, soldier_slider2_path)
  self.split = self:AddComponent(UIBaseComponent, split_path)
  self.eff_ui = self:AddComponent(UIBaseComponent, eff_ui_path)
  self.server_txt1 = self:AddComponent(UIText, server_txt1_path)
  self.server_txt2 = self:AddComponent(UIText, server_txt2_path)
  self.home_icon1 = self:AddComponent(UIImage, home_icon1_path)
  self.home_icon2 = self:AddComponent(UIImage, home_icon2_path)
  self.server_bg1 = self:AddComponent(UIButton, server_bg1_path)
  self.server_bg2 = self:AddComponent(UIButton, server_bg2_path)
  self.homeBtn1 = self:AddComponent(UIButton, home_icon1_root_path)
  self.homeBtn2 = self:AddComponent(UIButton, home_icon2_root_path)
  self.homeBtn1:SetOnClick(function()
    if self.leftInfo and self.leftInfo.serverId then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIGovernmentOfficial, {anim = true}, self.leftInfo.serverId)
    end
  end)
  self.homeBtn2:SetOnClick(function()
    if self.rightInfo and self.rightInfo.serverId then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIGovernmentOfficial, {anim = true}, self.rightInfo.serverId)
    end
  end)
  self.camp_iconA = self:AddComponent(UIImage, camp_iconA_path)
  self.camp_iconB = self:AddComponent(UIImage, camp_iconB_path)
  self.campBtnA = self:AddComponent(UIButton, camp_iconA_path)
  self.campBtnB = self:AddComponent(UIButton, camp_iconB_path)
  self.campBtnA:SetOnClick(function()
    if self.leftInfo == nil then
      return
    end
    DataCenter.ZoneWarManager:ShowCampBubbleTips(self.campBtnA.transform, self.leftInfo.campId, self.config, -60)
  end)
  self.campBtnB:SetOnClick(function()
    if self.rightInfo == nil then
      return
    end
    DataCenter.ZoneWarManager:ShowCampBubbleTips(self.campBtnB.transform, self.rightInfo.campId, self.config, -60)
  end)
  self.allianceInfoRoot = self:AddComponent(UILayoutElement, allianceInfo_path)
  self.allianceRoot = self:AddComponent(UIBaseComponent, allianceRoot_path)
  self.al_name1 = self:AddComponent(UIText, a_l_name1_path)
  self.al_score1txt = self:AddComponent(UIText, a_l_score1txt_path)
  self.al_name2 = self:AddComponent(UIText, a_l_name2_path)
  self.al_score2txt = self:AddComponent(UIText, a_l_score2txt_path)
  self.flag_icon1 = self:AddComponent(UIImage, flag_icon1_path)
  self.flag_icon2 = self:AddComponent(UIImage, flag_icon2_path)
  self.mvpInfoRoot = self:AddComponent(UIBaseComponent, mvpInfo_path)
  self.no_score = self:AddComponent(UIText, no_score_path)
  self.user1 = self:AddComponent(UIText, user1_path)
  self.player1 = self:AddComponent(UICommonHead, player1_path)
  self.mvp_score1txt = self:AddComponent(UIText, mvp_score1txt_path)
  self.user2 = self:AddComponent(UIText, user2_path)
  self.player2 = self:AddComponent(UICommonHead, player2_path)
  self.mvp_score2txt = self:AddComponent(UIText, mvp_score2txt_path)
  self.no_a_l_score1 = self:AddComponent(UIText, no_a_l_score1_path)
  self.no_a_l_score2 = self:AddComponent(UIText, no_a_l_score2_path)
  self.no_mvp_score1 = self:AddComponent(UIText, no_mvp_score1_path)
  self.no_mvp_score2 = self:AddComponent(UIText, no_mvp_score2_path)
  self.info_btn:SetOnClick(function()
    local detailContent = self.serverBattleType == ServerBattleType.VSCamp and "season_s2_camp_war_info01" or 801426
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIGovernmentServerBattleScoreDetail, {anim = true}, 801427, detailContent)
  end)
  self.server_battle_info = self:AddComponent(UIServerBattleLastKingServerInfo2, server_info2_path)
  self.server_battle_info:SetActive(false)
  self.btnAllianceRank = self:AddComponent(UIButton, btn_alliance_rank_path)
  self.btnAllianceRank:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIServerBattleScoreRank, {anim = true}, 1)
  end)
  self.btnPersonalRank = self:AddComponent(UIButton, btn_personal_rank_path)
  self.btnPersonalRank:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIServerBattleScoreRank, {anim = true}, 2)
  end)
  self.no_score2 = self:AddComponent(UIText, no_score2_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.ScrollView = self:AddComponent(UILoopListView2, scroll_view_path)
  self.ScrollView:InitListView(0, function(listview, index)
    return self:TryGetScrollItem(listview, index)
  end)
  self.items = {}
end

function UIServerBattleWeekInfo:OnDestroy()
  self:ClearScroll()
  base.OnDestroy(self)
end

function UIServerBattleWeekInfo:OnEnable()
  base.OnEnable(self)
  self:AddUIListener(EventId.CrossKingScheduleRefresh, self.UpdateData)
  self:AddUIListener(EventId.CrossKingRoundInfoNowRefresh, self.UpdateData)
  self:AddUIListener(EventId.GetNewUserInfoSucc, self.OnPlayerDataCallBack)
  self:AddUIListener(EventId.CrossKingRoundInfoNowAdd, self.CrossKingRoundInfoNowAdd)
end

function UIServerBattleWeekInfo:OnDisable()
  self:RemoveUIListener(EventId.CrossKingScheduleRefresh, self.UpdateData)
  self:RemoveUIListener(EventId.CrossKingRoundInfoNowRefresh, self.UpdateData)
  self:RemoveUIListener(EventId.GetNewUserInfoSucc, self.OnPlayerDataCallBack)
  self:RemoveUIListener(EventId.CrossKingRoundInfoNowAdd, self.CrossKingRoundInfoNowAdd)
  base.OnDisable(self)
end

function UIServerBattleWeekInfo:UpdateData()
  local roundInfo = DataCenter.ZoneWarManager:GetCrossKingRoundInfoNow()
  local configSchedule = DataCenter.ZoneWarManager:GetCrossKingSchedule()
  if configSchedule == nil or roundInfo == nil then
    return
  end
  self.endTime = configSchedule.endTime
  self.configSchedule = configSchedule
  self.isInit = false
  if roundInfo then
    self:RefreshUI(roundInfo)
  end
end

function UIServerBattleWeekInfo:ReInit(configSchedule, config, serverBattleType)
  self.isInit = true
  self.config = config
  self.configSchedule = configSchedule
  self.serverBattleType = serverBattleType
  self.dataTime = nil
  self.endTime = configSchedule.endTime
  local roundInfo = DataCenter.ZoneWarManager:GetCrossKingRoundInfoNow()
  if roundInfo then
    self:RefreshUI(roundInfo)
  end
end

function UIServerBattleWeekInfo:DeInit()
  self.ScrollView:RecycleAllItem()
end

function UIServerBattleWeekInfo:RefreshUI(roundInfo)
  local mySeverId, leftInfo, rightInfo = DataCenter.ZoneWarManager:ParseVsRound(roundInfo.curVsRound, true)
  local serverInfo1 = roundInfo.serverInfo[tostring(leftInfo.serverId)] or {cfgId = 511001}
  local serverInfo2 = roundInfo.serverInfo[tostring(rightInfo.serverId)] or {cfgId = 511001}
  if self.leftInfo == nil then
    self:ShowServer(leftInfo, rightInfo, serverInfo1, serverInfo2, mySeverId)
  end
  self.leftInfo = leftInfo
  self.rightInfo = rightInfo
  if leftInfo.scoreSettled == 1 then
    self.endTime = nil
    self.title:SetLocalText("801448")
    self.remain_time_root:SetActive(false)
    self.server_battle_info:SetActive(true)
    self.server_battle_info:ReInitWeek(leftInfo, rightInfo, serverInfo1, serverInfo2, mySeverId)
  else
    self.server_battle_info:SetActive(false)
    self.remain_time_root:SetActive(true)
    self.endTime = self.configSchedule.scoreSettleTime
    self.title:SetLocalText("801447")
  end
  local total = leftInfo.score + rightInfo.score
  self.score1txt:SetText("+" .. string.GetFormattedSeparatorNum(leftInfo.score) .. "pt")
  self.score2txt:SetText("+" .. string.GetFormattedSeparatorNum(rightInfo.score) .. "pt")
  if total == 0 then
    self.soldier_slider1:SetValue(0.506)
    self.soldier_slider2:SetValue(0.506)
  else
    local value = leftInfo.score / total
    self.soldier_slider1:SetValue(value + 0.006)
    self.soldier_slider2:SetValue(1 - value + 0.006)
  end
  local dataTime = roundInfo.now
  if self.dataTime ~= nil and dataTime ~= nil and dataTime - self.dataTime < 10000 then
    return
  end
  self.dataTime = dataTime
  self.eff_ui:SetActive(false)
  self:RefreshMVP(roundInfo)
  self:RefreshScoreList(roundInfo)
  self:Update1000MS()
end

function UIServerBattleWeekInfo:Update1000MS()
  if self.endTime then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local remainTime = self.endTime - curTime
    if 0 < remainTime then
      self.remain_time:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
    else
      self.dataTime = nil
      self.endTime = nil
      self.remain_time:SetText("00:00:00")
    end
  end
end

function UIServerBattleWeekInfo:RefreshMVP(roundInfo)
  local leftInfo = self.leftInfo
  local rightInfo = self.rightInfo
  self.selfMvp = nil
  local vsScoreMVP = roundInfo.vsScoreMVP or DataCenter.ZoneWarManager.vsScoreMVP
  if vsScoreMVP then
    if vsScoreMVP.alliance then
      local myAllianceInfo = vsScoreMVP.alliance[tostring(leftInfo.serverId)]
      local targetAllianceInfo = vsScoreMVP.alliance[tostring(rightInfo.serverId)]
      if not myAllianceInfo or not targetAllianceInfo then
        for serverId, info in pairs(vsScoreMVP.alliance) do
          if DataCenter.ZoneWarManager:IsAlly(toInt(serverId), leftInfo.serverId) then
            myAllianceInfo = info
          elseif DataCenter.ZoneWarManager:IsAlly(toInt(serverId), rightInfo.serverId) then
            targetAllianceInfo = info
          end
        end
      end
      if myAllianceInfo ~= nil or targetAllianceInfo ~= nil then
        self.allianceRoot:SetActive(true)
        if myAllianceInfo then
          self.flag_icon1:SetActive(true)
          self.no_a_l_score1:SetActive(false)
          self.al_name1:SetText("[" .. myAllianceInfo.abbr .. "]" .. myAllianceInfo.alliancename)
          self.al_score1txt:SetText("+" .. string.GetFormattedSeparatorNum(myAllianceInfo.score) .. "pt")
          self.flag_icon1:LoadSprite(string.format(AL_FLAG_SPRITE_PATH, tostring(myAllianceInfo.icon)))
        else
          self.flag_icon1:SetActive(false)
          self.no_a_l_score1:SetActive(true)
        end
        if targetAllianceInfo then
          self.flag_icon2:SetActive(true)
          self.no_a_l_score2:SetActive(false)
          self.al_name2:SetText("[" .. targetAllianceInfo.abbr .. "]" .. targetAllianceInfo.alliancename)
          self.al_score2txt:SetText("+" .. string.GetFormattedSeparatorNum(targetAllianceInfo.score) .. "pt")
          self.flag_icon2:LoadSprite(string.format(AL_FLAG_SPRITE_PATH, tostring(targetAllianceInfo.icon)))
        else
          self.flag_icon2:SetActive(false)
          self.no_a_l_score2:SetActive(true)
        end
      else
        self.allianceRoot:SetActive(false)
      end
    end
    if vsScoreMVP.user then
      local leftUserInfo = vsScoreMVP.user[tostring(leftInfo.serverId)]
      local rightUserInfo = vsScoreMVP.user[tostring(rightInfo.serverId)]
      if not leftUserInfo or not rightUserInfo then
        for serverId, info in pairs(vsScoreMVP.user) do
          if DataCenter.ZoneWarManager:IsAlly(toInt(serverId), leftInfo.serverId) then
            leftUserInfo = info
          elseif DataCenter.ZoneWarManager:IsAlly(toInt(serverId), rightInfo.serverId) then
            rightUserInfo = info
          end
        end
      end
      local myUserInfo
      if DataCenter.ZoneWarManager:IsAlly(LuaEntry.Player.serverId, leftInfo.serverId) then
        myUserInfo = leftUserInfo
      elseif DataCenter.ZoneWarManager:IsAlly(LuaEntry.Player.serverId, rightInfo.serverId) then
        myUserInfo = rightUserInfo
      end
      if leftUserInfo == nil and rightUserInfo == nil then
        self.mvpInfoRoot:SetActive(false)
      else
        self.mvpInfoRoot:SetActive(true)
        self.no_score:SetActive(false)
        if leftUserInfo then
          self.user1:SetActive(true)
          self.no_mvp_score1:SetActive(false)
          if string.IsNullOrEmpty(leftUserInfo.abbr) then
            self.user1:SetText(leftUserInfo.name)
          else
            self.user1:SetText("[" .. leftUserInfo.abbr .. "]" .. leftUserInfo.name)
          end
          self.player1:ParseHeadInfo(leftUserInfo)
          self.player1:SetFlag(leftUserInfo.country)
          self.mvp_score1txt:SetText("+" .. string.GetFormattedSeparatorNum(leftUserInfo.score) .. "pt")
          self.player1:SetEnableClickShowInfo(true, true)
        else
          self.user1:SetActive(false)
          self.no_mvp_score1:SetActive(true)
        end
        if rightUserInfo then
          self.user2:SetActive(true)
          self.no_mvp_score2:SetActive(false)
          if string.IsNullOrEmpty(rightUserInfo.abbr) then
            self.user2:SetText(rightUserInfo.name)
          else
            self.user2:SetText("[" .. rightUserInfo.abbr .. "]" .. rightUserInfo.name)
          end
          self.player2:ParseHeadInfo(rightUserInfo)
          self.player2:SetFlag(rightUserInfo.country)
          self.mvp_score2txt:SetText("+" .. string.GetFormattedSeparatorNum(rightUserInfo.score) .. "pt")
          self.player2:SetEnableClickShowInfo(true, true)
        else
          self.user2:SetActive(false)
          self.no_mvp_score2:SetActive(true)
        end
        if myUserInfo then
          self.selfMvp = myUserInfo.uid == LuaEntry.Player.uid and myUserInfo
          DataCenter.ZoneWarManager:TryShowThumbUp(myUserInfo, "ServerBattleWeekInfo", "zone_war_ui_tittle01")
        end
      end
    end
    local a1 = self.allianceRoot:GetActive()
    local a2 = self.mvpInfoRoot:GetActive()
    if a1 and a2 then
      self.allianceInfoRoot:SetActive(true)
      self.allianceInfoRoot:SetMinHeight(250)
      self.allianceInfoRoot:SetPreferredHeight(250)
    elseif a1 or a2 then
      self.allianceInfoRoot:SetActive(true)
      self.allianceInfoRoot:SetMinHeight(150)
      self.allianceInfoRoot:SetPreferredHeight(150)
    else
      self.allianceInfoRoot:SetActive(false)
    end
  end
end

function UIServerBattleWeekInfo:ShowServer(leftInfo, rightInfo, serverInfo1, serverInfo2, mySeverId)
  if leftInfo.scoreSettled ~= 1 then
    local campIconA = DataCenter.ZoneWarManager:GetCampIcon(leftInfo.serverId, leftInfo.campId)
    local campIconB = DataCenter.ZoneWarManager:GetCampIcon(rightInfo.serverId, rightInfo.campId)
    if campIconA and campIconB then
      self.camp_iconA:LoadSprite(campIconA)
      self.camp_iconB:LoadSprite(campIconB)
      self.camp_iconA:SetActive(true)
      self.camp_iconB:SetActive(true)
      self.homeBtn1:SetActive(false)
      self.homeBtn2:SetActive(false)
      return
    end
  end
  local template = DataCenter.ItemTemplateManager:GetItemTemplate(tostring(serverInfo1.cfgId))
  if template then
    self.home_icon1:LoadSprite(string.format(LoadPath.ItemPath, template.icon))
  end
  template = DataCenter.ItemTemplateManager:GetItemTemplate(tostring(serverInfo2.cfgId))
  if template then
    self.home_icon2:LoadSprite(string.format(LoadPath.ItemPath, template.icon))
  end
  local rightStatus = DataCenter.ZoneWarManager:IsAlly(mySeverId, rightInfo.serverId) and 2 or 1
  local leftStatus = rightStatus == 1 and 2 or 1
  DataCenter.ZoneWarManager:SetServerInfo(self.server_bg1, self.server_txt1, leftInfo.serverId, leftStatus)
  DataCenter.ZoneWarManager:SetServerInfo(self.server_bg2, self.server_txt2, rightInfo.serverId, rightStatus)
  self.homeBtn1:SetActive(true)
  self.homeBtn2:SetActive(true)
  self.camp_iconA:SetActive(false)
  self.camp_iconB:SetActive(false)
end

local __nameCount = 0

function UIServerBattleWeekInfo:TryGetScrollItem(listview, index)
  index = index + 1
  local data = self.showDatalist[index]
  if not data then
    return nil
  end
  local itemInfo = itemsInfo[data.itemType]
  if not itemInfo then
    return nil
  end
  local csItem = listview:NewListViewItem(itemInfo.name)
  local theItem = self.items[csItem]
  if not theItem then
    __nameCount = __nameCount + 1
    csItem.name = string.format("%s_%d", itemInfo.name, __nameCount)
    if itemInfo.script then
      theItem = self.content:AddComponent(itemInfo.script, csItem.name)
      self.items[csItem] = theItem
    end
  end
  if theItem and itemInfo.func then
    itemInfo.func(self, theItem, index, data)
  end
  if index >= self.dataCount - 5 then
    self:RequestNextPage()
  end
  return csItem
end

local function _GetItemRenderTypeByTemplateType(templateType)
  if templateType == 12 then
    return 4
  end
  return 3
end

function UIServerBattleWeekInfo:RefreshScoreList(roundInfo)
  local showDatalist, index = {}, 1
  showDatalist[index] = {itemType = 1}
  index = index + 1
  local scoreSumList, maxScore = DataCenter.ZoneWarManager:GetVsScoreSumList(roundInfo, self.leftInfo, self.rightInfo)
  for i, v in ipairs(scoreSumList) do
    local config = DataCenter.ZoneWarManager:GetZoneWarScoreConfigByType(v.type)
    if config ~= nil and (config.type2 == 1 or config.type2 == 2 or config.type2 == 3) then
      showDatalist[index] = {
        itemType = 2,
        data = v,
        config = config,
        maxScore = maxScore
      }
      index = index + 1
    end
  end
  local vsScoreList = roundInfo.vsScoreList or DataCenter.ZoneWarManager.vsScoreList or {}
  for i, v in ipairs(vsScoreList) do
    local config = DataCenter.ZoneWarManager:GetZoneWarScoreConfigByType(v.type)
    if config ~= nil and (config.type2 == 1 or config.type2 == 2 or config.type2 == 3) then
      showDatalist[index] = {
        itemType = _GetItemRenderTypeByTemplateType(config.type),
        data = v,
        config = config
      }
      index = index + 1
    end
  end
  self.page = 1
  self.pageEnd = false
  self.dataCount = index - 1
  self.showDatalist = showDatalist
  if self.dataCount <= 0 then
    self.no_score2:SetActive(true)
  else
    self.no_score2:SetActive(false)
    self.ScrollView:SetListItemCount(self.dataCount, self.isInit, self.isInit)
    self.ScrollView:RefreshAllShownItem()
  end
end

function UIServerBattleWeekInfo:OnPlayerDataCallBack(uid)
  if self.selfMvp and uid == self.selfMvp.uid then
    DataCenter.ZoneWarManager:TryShowThumbUp(self.selfMvp, "ServerBattleWeekInfo", "zone_war_ui_tittle01")
    self.selfMvp = nil
  end
end

function UIServerBattleWeekInfo:ClearScroll()
  self.items = {}
  self.ScrollView:ClearAllItems()
  self.content:RemoveComponents(UIServerBattleWeekItem)
  self.content:RemoveComponents(UIServerBattleWeekScoreSumItem)
  self.content:RemoveComponents(ScoreDsbDuelItem)
end

function UIServerBattleWeekInfo:RequestNextPage()
  if not (not self.pageEnd and self.page) or Time.time - lastRequestTime < 0.5 then
    return
  end
  lastRequestTime = Time.time
  SFSNetwork.SendMessage(MsgDefines.CrossKingScoreData, self.page + 1)
end

function UIServerBattleWeekInfo:CrossKingRoundInfoNowAdd(t)
  if not (t and t.page and t.pageSize) or not t.vsScoreList then
    return
  end
  if t.page == self.page then
    return
  end
  self.page = t.page
  if #t.vsScoreList < t.pageSize then
    self.pageEnd = true
  end
  local index = self.dataCount + 1
  for i, v in ipairs(t.vsScoreList) do
    local config = DataCenter.ZoneWarManager:GetZoneWarScoreConfigByType(v.type)
    if config ~= nil and (config.type2 == 1 or config.type2 == 2 or config.type2 == 3) then
      self.showDatalist[index] = {
        itemType = _GetItemRenderTypeByTemplateType(config.type),
        data = v,
        config = config
      }
      index = index + 1
    end
  end
  self.dataCount = index - 1
  self.ScrollView:SetListItemCount(self.dataCount, false, false)
  self.ScrollView:RefreshAllShownItem()
end

return UIServerBattleWeekInfo
