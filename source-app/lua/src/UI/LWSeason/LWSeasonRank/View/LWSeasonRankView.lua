local LWSeasonRankView = BaseClass("LWSeasonRankView", UIBaseView)
local base = UIBaseView
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local LWSeasonRankItem = require("UI.LWSeason.LWSeasonRank.Component.LWSeasonRankItem")
local CommonSelectCom = require("UI.LWSeason.LWSeasonRank.Component.CommonSelectCom")
local SeasonRankCamp = require("UI.LWSeason.LWSeasonRank.Component.SeasonRankCamp")
local SeasonRankCampOtherType = require("UI.LWSeason.LWSeasonRank.Component.SeasonRankCampOtherType")
local SeasonRankCampS6 = require("UI.LWSeason6.UILWSeasonCampRank.Comp.SeasonRankCampS6")
local lastActiveTab = 1
local btn_back_path = "Root/BottomBar/BtnBack"
local text_title_path = "Root/TopBar/TextTitle"
local icon_path = "Root/Bg/icon"
local rank_des_path = "Root/PackList/select/rankDes"
local name_des_path = "Root/PackList/select/nameDes"
local power_des_path = "Root/PackList/select/powerDes"
local tab_item1_path = "Root/TopBar/Tab/TabItem1"
local tab_item2_path = "Root/TopBar/Tab/TabItem2"
local tab_item3_path = "Root/TopBar/Tab/TabItem3"
local scroll_path = "Root/PackList"
local content_path = "Root/PackList/Viewport/Content"
local self_data_path = "Root/SelfData"
local no_data_path = "Root/PackList/no_data"
local bg_special_path = "Root/BgSpecial"
local bg_path = "Root/Bg"
local tab_path = "Root/TopBar/Tab"
local btn_rank_reward_path = "Root/BottomBar/BtnRankReward"
local tips_path = "Root/BottomBar/tips"
local info_btn_path = "Root/InfoBtn"
local rank_icon_bg_path = "Root/Bg/rankIconBg"
local rank_name_path = "Root/Bg/rankIconBg/rankNameBg/rankName"
local rank_icon_path = "Root/Bg/rankIconBg/rankIcon"
local score_info_btn_path = "Root/TopBar/ScoreInfoBtn"
local common_select_com_path = "Root/ContentRewardBtn/CommonSelectCom"
local condition1_dark_path = "Root/TopBar/Tab/TabItem%s/Condition%sDark"
local condition1_path = "Root/TopBar/Tab/TabItem%s/Condition%sSelect/Condition%s"
local camp_rank_path = "Root/CampRank"
local rank_name_bg_path = "Root/Bg/rankIconBg/rankNameBg"
local btn_reward_path = "Root/ContentRewardBtn/BtnReward"
local btn_s5_money_rank_path = "Root/ContentRewardBtn/BtnS5MoneyRank"
local other_camp_rank_path = "Root/OtherCampRank"
local dynamic_bg_path = "Root/OtherCampRank/dynamicBg"
local content_reward_btn_path = "Root/ContentRewardBtn"

function LWSeasonRankView:OnCreate()
  base.OnCreate(self)
  local param = self:GetUserData()
  self.SpecialRank = nil
  self.lw_season_rank_id = nil
  self.lw_season_rank_config = nil
  self.isFarmer = false
  if param then
    if type(param) == "number" then
      lastActiveTab = toInt(param)
      if lastActiveTab < 1 or 3 < lastActiveTab then
        lastActiveTab = 1
      end
    elseif param.rank and param.title and param.nameTxt and param.scoreTxt then
      self.SpecialRank = param
    elseif param.lw_season_rank and param.id then
      self.lw_season_rank_id = toInt(param.id)
      self.lw_season_event_id = toInt(param.event)
      self.lw_season_rank_config = LocalController:instance():getLine(TableName.LW_Season_rank, self.lw_season_rank_id)
      self.SpecialRank = param
      if self.lw_season_event_id ~= nil and self.lw_season_event_id ~= 0 then
        self.lw_season_score_config = LocalController:instance():getLine(TableName.HeroEvent, self.lw_season_event_id)
      end
    elseif param.isFarmer then
      self.isFarmer = true
    end
  end
  self.RankData = {}
  self:ComponentDefine()
end

function LWSeasonRankView:OnDestroy()
  self:ClearScroll()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWSeasonRankView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.PlayerRank, self.RefreshRankList)
  self:AddUIListener(EventId.AllianceRank, self.RefreshRankList)
  self:AddUIListener(EventId.SeasonRankUpdate, self.RefreshRankList)
  self:AddUIListener(EventId.LWSeasonRankRewardUpdate, self.OpenRewardWindow)
end

function LWSeasonRankView:OnRemoveListener()
  self:RemoveUIListener(EventId.PlayerRank, self.RefreshRankList)
  self:RemoveUIListener(EventId.AllianceRank, self.RefreshRankList)
  self:RemoveUIListener(EventId.SeasonRankUpdate, self.RefreshRankList)
  self:RemoveUIListener(EventId.LWSeasonRankRewardUpdate, self.OpenRewardWindow)
  base.OnRemoveListener(self)
end

function LWSeasonRankView:ComponentDefine()
  self.text_title = self:AddComponent(UIText, text_title_path)
  self.btn_back = self:AddComponent(UIButton, btn_back_path)
  self.btn_back:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.icon = self:AddComponent(UIRawImage, icon_path)
  self.rank_des = self:AddComponent(UIText, rank_des_path)
  self.name_des = self:AddComponent(UIText, name_des_path)
  self.power_des = self:AddComponent(UIText, power_des_path)
  self.tab_item1 = self:AddComponent(UIToggle, tab_item1_path)
  self.tab_item2 = self:AddComponent(UIToggle, tab_item2_path)
  self.tab_item3 = self:AddComponent(UIToggle, tab_item3_path)
  self.no_data = self:AddComponent(UIText, no_data_path)
  self.rank_icon = self:AddComponent(UIImage, rank_icon_path)
  self.no_data:SetActive(false)
  self.bg_special = self:AddComponent(UIImage, bg_special_path)
  self.bg = self:AddComponent(UIImage, bg_path)
  self.tab = self:AddComponent(UIBaseContainer, tab_path)
  self.info_btn = self:AddComponent(UIButton, info_btn_path)
  self.tips = self:AddComponent(UIText, tips_path)
  self.btn_rank_reward = self:AddComponent(UIButton, btn_rank_reward_path)
  self.rank_icon_bg = self:AddComponent(UIImage, rank_icon_bg_path)
  self.rank_name = self:AddComponent(UITextMeshProUGUIEx, rank_name_path)
  self.other_camp_rank = self:AddComponent(UIBaseContainer, other_camp_rank_path)
  self.dynamic_bg = self:AddComponent(UIImage, dynamic_bg_path)
  self.rank_icon_btn = self:AddComponent(UIButton, rank_icon_bg_path)
  self.rank_icon_btn:SetOnClick(function()
    local seasonType = SeasonUtil.GetSeasonType()
    local param = self:GetUserData()
    if param == nil and LuaEntry.Player:IsInAlliance() and seasonType == SeasonMapType.CityStronghold then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonCrossOccupyDetail)
    end
  end)
  self.content_btn_layout = self:AddComponent(UIHorizontalOrVerticalLayoutGroup, content_reward_btn_path)
  self.commonSelectCom = self:AddComponent(CommonSelectCom, common_select_com_path)
  self.commonSelectCom:SetActive(false)
  self.score_info_btn = self:AddComponent(UIButton, score_info_btn_path)
  self.seasonRankCamp = self:AddComponent(SeasonRankCamp, camp_rank_path)
  self.btn_reward = self:AddComponent(UIButton, btn_reward_path)
  self.btn_reward:SetSafeClickMode(true)
  self.btn_reward:SetOnClick(function()
    self:OnRewardBtnClick()
  end)
  self.btn_s5_money_rank = self:AddComponent(UIButton, btn_s5_money_rank_path)
  self.btn_s5_money_rank:SetSafeClickMode(true)
  self.btn_s5_money_rank:SetOnClick(function()
    self:OnS5MoneyRankClick()
  end)
  if self.seasonRankCamp ~= nil then
    self.seasonRankCamp:SetActive(false)
  end
  self.score_info_btn:SetOnClick(function()
    self:OnScoreInfoClick()
  end)
  self.rank_name_bg = self:AddComponent(UIImage, rank_name_bg_path)
  self.btn_rank_reward:SetOnClick(function()
    if self.lw_season_rank_id and self.lw_season_rank_config then
      SFSNetwork.SendMessage(MsgDefines.GetSeasonRankRewardInfo, self.lw_season_rank_id)
    elseif self.isFarmer then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonReward, {anim = false}, nil, 1)
    else
      UIUtil.ShowTipsId(120018)
    end
  end)
  self.info_btn:SetActive(false)
  self.rank_icon_bg:SetActive(false)
  self.info_btn:SetOnClick(function()
    self:OnInfoClick()
  end)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.self_data = self:AddComponent(LWSeasonRankItem, self_data_path)
  self.ScrollView = self:AddComponent(UIScrollView, scroll_path)
  self.ScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnRankItemMoveIn(itemObj, index)
  end)
  self.ScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnRankItemMoveOut(itemObj, index)
  end)
  self.normalRankList = {}
  table.insert(self.normalRankList, self.ScrollView)
  table.insert(self.normalRankList, self.self_data)
  self.self_data:SetActive(false)
  self.commonSelectComShowFlag = true
  local SpecialRank = self.SpecialRank
  self.bgActive = false
  if SpecialRank then
    self.bg_special:SetActive(true)
    self.bg:SetActive(false)
    self.tab:SetActive(false)
    self.bgActive = false
    self.ScrollView.transform.offsetMax = Vector2.New(self.ScrollView.transform.offsetMax.x, -92)
    if self.lw_season_rank_id then
      local config = self.lw_season_rank_config
      if config then
        local rank_type = toInt(config.rank_type)
        self.tabActive = self.lw_season_rank_id
        self.text_title:SetLocalText(config.name or "season_main_UI106")
        self.rank_des:SetLocalText("302043")
        if rank_type == 1 then
          self.theType = 2
          self.name_des:SetLocalText("302129")
        else
          self.theType = 1
          self.name_des:SetLocalText("100031")
        end
        self.power_des:SetLocalText(config.score_name or "456533")
        SFSNetwork.SendMessage(self.SpecialRank.cmd, self.lw_season_rank_id)
      end
    else
      self.text_title:SetLocalText(SpecialRank.title or "season_main_UI106")
      self:OnTabChanged(SpecialRank.rank)
    end
  else
    self.bg_special:SetActive(false)
    self.bg:SetActive(true)
    self.bgActive = true
    self.tab:SetActive(true)
    self.ScrollView.transform.offsetMax = Vector2.New(self.ScrollView.transform.offsetMax.x, -440)
    self.text_title:SetLocalText("season_main_UI106")
    self.rankInfo = {}
    local seasonId = DataCenter.SeasonDataManager:GetSeasonId()
    local data = DataCenter.SeasonTemplateManager:GetConfigData(seasonId)
    if self.isFarmer then
      local mainConfig = DataCenter.SeasonFarmerTemplateManager:GetMainCfg()
      local rankInfoConfig = string.split(mainConfig.season_rank_info, ";")
      if rankInfoConfig and #rankInfoConfig == 4 then
        local rankInfo = {}
        rankInfo.type = toInt(rankInfoConfig[1])
        rankInfo.name = rankInfoConfig[2]
        rankInfo.desc = rankInfoConfig[3]
        rankInfo.iconPath = rankInfoConfig[4]
        table.insert(self.rankInfo, rankInfo)
      end
    elseif data and data.seasonRankInfo and #data.seasonRankInfo then
      for index, value in ipairs(data.seasonRankInfo) do
        local flag = true
        if value.type == SeasonRankType.CampRareLand then
          self.commonSelectComShowFlag = true
          if not DataCenter.SeasonFactionWarDataManager:IsGroupingShownMode() then
            flag = false
            self.commonSelectComShowFlag = false
          end
        end
        if flag then
          table.insert(self.rankInfo, value)
        end
      end
    end
    local tabCount = #self.rankInfo
    if tabCount < lastActiveTab then
      lastActiveTab = 1
    end
    local needSelect = false
    local seasonType = SeasonUtil.GetSeasonType(false, true)
    for i = 1, 3 do
      self["tab_item" .. i]:SetActive(self.rankInfo[i] ~= nil)
      if self.rankInfo[i] ~= nil then
        local itemText = self:AddComponent(UITextMeshProUGUIEx, string.format(condition1_dark_path, i, i))
        local itemText1 = self:AddComponent(UITextMeshProUGUIEx, string.format(condition1_path, i, i, i))
        local name = SeasonUtil.SesaonRankTabName(self.rankInfo[i].type)
        itemText:SetLocalText(name)
        itemText1:SetLocalText(name)
        self["tab_item" .. i]:SetActive(self.rankInfo[i] ~= nil)
        if not needSelect then
          if self.rankInfo[i].type == SeasonRankType.AllianceRareLand then
            needSelect = SeasonRankType.AllianceRareLand
          end
          if seasonType == SeasonMapType.NineNationRainforest and self.rankInfo[i].type == SeasonRankType.AlliancePower then
            needSelect = SeasonRankType.AlliancePower
          end
        end
      end
    end
    if needSelect == SeasonRankType.AllianceRareLand then
      local theData = {}
      theData.itemList = {
        [1] = {
          type = SeasonRankType.AllianceRareLand,
          des = Localization:GetString("season_s2_rank_reward_20")
        },
        [2] = {
          type = SeasonRankType.AllianceCamp1RareLand,
          des = Localization:GetString("season_s2_rank_reward_22")
        },
        [3] = {
          type = SeasonRankType.AllianceCamp2RareLand,
          des = Localization:GetString("season_s2_rank_reward_21")
        }
      }
      self.commonSelectCom:Init(theData, function(d, i)
        local result = self:SelectChange(d, i)
        return result
      end)
      self.tips:SetActive(false)
    end
    if seasonType == SeasonMapType.NineNationRainforest and needSelect == SeasonRankType.AlliancePower then
      local theData = {}
      theData.itemList = {
        [1] = {
          type = SeasonRankType.AlliancePower,
          des = Localization:GetString("season_s2_rank_reward_20")
        },
        [2] = {
          type = SeasonRankType.AllianceCamp1Power,
          des = DataCenter.SeasonFactionWarDataManager:GetCampName(SeasonFactionType.Rebels)
        },
        [3] = {
          type = SeasonRankType.AllianceCamp2Power,
          des = DataCenter.SeasonFactionWarDataManager:GetCampName(SeasonFactionType.Gendarmerie)
        }
      }
      self.commonSelectCom:Init(theData, function(d, i)
        local result = self:SelectChange(d, i)
        return result
      end)
      self.tips:SetActive(false)
    end
    self.tab_item1:SetOnValueChanged(function(tf)
      if tf then
        DataCenter.LWSoundManager:PlaySound(6100022, false)
        self:OnTabChanged(1)
      end
    end)
    self.tab_item2:SetOnValueChanged(function(tf)
      if tf then
        DataCenter.LWSoundManager:PlaySound(6100022, false)
        self:OnTabChanged(2)
      end
    end)
    self.tab_item3:SetOnValueChanged(function(tf)
      if tf then
        DataCenter.LWSoundManager:PlaySound(6100022, false)
        self:OnTabChanged(3)
      end
    end)
    if self.lw_season_rank_config then
      self.tips:SetActive(false)
      self.score_info_btn:SetActive(self.lw_season_score_config ~= nil)
      self.btn_rank_reward:SetActive(true)
    elseif self.isFarmer then
      self.tips:SetActive(false)
      self.score_info_btn:SetActive(false)
      self.btn_rank_reward:SetActive(true)
    else
      self.tips:SetActive(true)
      self.score_info_btn:SetActive(false)
      self.btn_rank_reward:SetActive(false)
    end
    if lastActiveTab == 1 then
      self.tab_item1:SetIsOn(true)
    elseif lastActiveTab == 2 then
      self.tab_item2:SetIsOn(true)
    elseif lastActiveTab == 3 then
      self.tab_item3:SetIsOn(true)
    end
    if self.tabActive == nil and self.rankInfo[lastActiveTab] then
      local showTab = self.rankInfo[lastActiveTab]
      if showTab.type == SeasonRankType.AllianceRareLand or seasonType == SeasonMapType.NineNationRainforest and showTab.type == SeasonRankType.AlliancePower then
        self.subIndex = 1
        self.commonSelectCom:SetIndex(self.subIndex)
      end
      self:OnTabChanged(lastActiveTab)
    end
  end
end

function LWSeasonRankView:ComponentDestroy()
  if self.campReq then
    self:GameObjectDestroy(self.campReq)
    self.campReq = nil
  end
  self.other_camp_rank:SetActive(false)
  self.btn_back = nil
  self.tabActive = nil
  self.btn_rank_reward = nil
  self.content_btn_layout = nil
  self.tips = nil
  self.rank_icon = nil
  self.info_btn = nil
  self.rank_icon_bg = nil
  self.rank_name = nil
  self.score_info_btn = nil
  self.commonSelectCom = nil
  self.curRankGroup = nil
  self.rank_name_bg = nil
  self.btn_reward = nil
  self.btn_s5_money_rank = nil
  self.other_camp_rank = nil
  self.dynamic_bg = nil
end

function LWSeasonRankView:OpenRewardWindow(data)
  data = data and data.rankReward or data.rankRewardInfo
  if data == nil then
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWUICommonRankReward, {anim = true}, data)
end

function LWSeasonRankView:OnTabChanged(index, ignoreSameIndex)
  if index == 3 then
    self:DoCampSeasonSkin()
  end
  if (ignoreSameIndex == nil or not ignoreSameIndex) and self.tabActive == index then
    return
  end
  if self.SpecialRank == nil then
    lastActiveTab = index
  end
  self:DoCampNeedHideWhenTabChange(index == 3)
  self.tabActive = index
  self.theType = index
  self.info_btn:SetActive(false)
  self.rank_icon_bg:SetActive(false)
  self.btn_s5_money_rank:SetActive(false)
  local rankType
  self.commonSelectCom:SetActive(false)
  if self.rankInfo and self.rankInfo[self.tabActive] then
    rankType = self.rankInfo[self.tabActive].type
    if rankType == SeasonRankType.AllianceRareLand then
      if self.subIndex == 2 then
        rankType = SeasonRankType.AllianceCamp1RareLand
      elseif self.subIndex == 3 then
        rankType = SeasonRankType.AllianceCamp2RareLand
      end
      self.commonSelectCom:SetActive(self.commonSelectComShowFlag)
      self.tips:SetActive(false)
      self.btn_reward:SetActive(true)
      local y = self.btn_reward:GetAnchoredPositionY()
      if self.commonSelectComShowFlag then
        self.btn_reward:SetAnchoredPositionXY(-100, y)
      else
        self.btn_reward:SetAnchoredPositionXY(0, y)
      end
    elseif rankType == SeasonRankType.CampRareLand then
      local y = self.btn_reward:GetAnchoredPositionY()
      self.tips:SetActive(false)
      self.btn_reward:SetActive(true)
      self.info_btn:SetActive(true)
      self.btn_reward:SetAnchoredPositionXY(0, y)
    elseif SeasonUtil.GetSeason() == 1 and (rankType == SeasonRankType.AlliancePower or rankType == SeasonRankType.ServerPower) then
      local y = self.btn_reward:GetAnchoredPositionY()
      self.tips:SetActive(false)
      self.btn_reward:SetActive(true)
      self.info_btn:SetActive(true)
      self.btn_reward:SetAnchoredPositionXY(0, y)
    elseif SeasonUtil.GetSeason() == 5 and (rankType == SeasonRankType.AlliancePower or rankType == SeasonRankType.ServerPower) then
      local y = self.btn_reward:GetAnchoredPositionY()
      self.tips:SetActive(false)
      self.btn_reward:SetActive(true)
      self.info_btn:SetActive(true)
      self.btn_reward:SetAnchoredPositionXY(0, y)
      local isMoneyRankOpen = DataCenter.ActivityListDataManager:IsActivityOpen(EnumActivity.SeasonMoneyRank.Type)
      self.btn_s5_money_rank:SetActive(isMoneyRankOpen)
    elseif SeasonUtil.GetSeason() == 6 then
      if rankType == SeasonRankType.AlliancePower then
        self.info_btn:SetActive(true)
        if self.subIndex == 2 then
          rankType = SeasonRankType.AllianceCamp1Power
        elseif self.subIndex == 3 then
          rankType = SeasonRankType.AllianceCamp2Power
        end
        self.commonSelectCom:SetActive(self.commonSelectComShowFlag)
        local y = self.btn_reward:GetAnchoredPositionY()
        self.tips:SetActive(false)
        self.btn_reward:SetActive(true)
        if self.commonSelectComShowFlag then
          self.btn_reward:SetAnchoredPositionXY(-100, y)
        else
          self.btn_reward:SetAnchoredPositionXY(0, y)
        end
      elseif rankType == SeasonRankType.CampPower then
        self.info_btn:SetActive(true)
        self.btn_reward:SetActive(false)
        self.tips:SetActive(false)
      else
        self.btn_reward:SetActive(false)
        self.tips:SetActive(not self.isFarmer)
      end
    else
      self.btn_reward:SetActive(false)
      self.tips:SetActive(not self.isFarmer)
    end
  end
  if rankType == SeasonRankType.AlliancePower or rankType == SeasonRankType.PersonalPower or rankType == SeasonRankType.ServerPower or rankType == SeasonRankType.AllianceRareLand or rankType == SeasonRankType.AllianceCamp1RareLand or rankType == SeasonRankType.AllianceCamp2RareLand or rankType == SeasonRankType.ServerRareLand or rankType == SeasonRankType.ServerFamer or rankType == SeasonRankType.AllianceCamp1Power or rankType == SeasonRankType.AllianceCamp2Power then
    self.rank_des:SetLocalText("302043")
    self.name_des:SetLocalText("100031")
    if not string.IsNullOrEmpty(self.rankInfo[self.tabActive].name) then
      self.power_des:SetLocalText(self.rankInfo[self.tabActive].name)
      self.rank_name:SetLocalText(self.rankInfo[self.tabActive].name)
    else
      self.power_des:SetLocalText("803025")
    end
    self.rank_icon:LoadSprite(self.rankInfo[self.tabActive].iconPath)
    self.rank_icon_bg:SetActive(true)
    self.info_btn:SetActive(true)
    local imgData = self.ctrl:GetImageNameByRankType(rankType)
    self.icon:LoadSprite(imgData.iconPath)
    self.rank_icon_bg:LoadSprite(imgData.rankIconBgPath)
    self.rank_name_bg:LoadSprite(imgData.nameBgPath)
  elseif self.SpecialRank then
    self.rank_des:SetLocalText("302043")
    self.name_des:SetLocalText(self.SpecialRank.nameTxt or "100031")
    self.power_des:SetLocalText(self.SpecialRank.scoreTxt or "")
  end
  local data = self.RankData[index]
  if rankType then
    self.theType = rankType
    data = self.RankData[rankType]
  end
  if data == nil then
    if rankType then
      SFSNetwork.SendMessage(MsgDefines.GetSeasonRankInfo, rankType)
    else
      SFSNetwork.SendMessage(MsgDefines.GetSeasonRankInfo, index)
    end
  end
  if self.content_btn_layout then
    if CommonUtil.IsArabic() then
    elseif self.commonSelectCom:GetActive() then
      self.content_btn_layout:SetChildAlignment(CS.UnityEngine.TextAnchor.MiddleRight)
    else
      self.content_btn_layout:SetChildAlignment(CS.UnityEngine.TextAnchor.MiddleCenter)
      if self.btn_s5_money_rank and self.btn_s5_money_rank:GetActive() then
        self.content_btn_layout:SetPaddingRight(0)
      else
        self.content_btn_layout:SetPaddingRight(60)
      end
    end
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content_btn_layout.transform)
  end
  self:RefreshRankList(data)
end

function LWSeasonRankView:RefreshRankList(data)
  if data == nil then
    return
  end
  local rankGroup = SeasonUtil.SesaonRankGroup(data.rank_type)
  if rankGroup == SeasonRankGroup.Camp then
    for index, value in ipairs(self.normalRankList) do
      value:SetActive(false)
    end
    self.bg:SetActive(false)
    if self.seasonRankCamp then
      self.seasonRankCamp:SetActive(true)
      self.seasonRankCamp:Refresh(data)
    end
    if data and data.rank_type and self.RankData[data.rank_type] == nil then
      self.RankData[data.rank_type] = data
    end
    return
  else
    for index, value in ipairs(self.normalRankList) do
      value:SetActive(true)
    end
    self.bg:SetActive(self.bgActive)
    if self.seasonRankCamp then
      self.seasonRankCamp:SetActive(false)
    end
  end
  local showSelf = true
  if data.rank_type == SeasonRankType.AllianceCamp1RareLand or data.rank_type == SeasonRankType.AllianceCamp1Power then
    if DataCenter.SeasonFactionWarDataManager.myCampId ~= SeasonFactionType.Rebels then
      showSelf = false
    end
  elseif (data.rank_type == SeasonRankType.AllianceCamp2RareLand or data.rank_type == SeasonRankType.AllianceCamp2Power) and DataCenter.SeasonFactionWarDataManager.myCampId ~= SeasonFactionType.Gendarmerie then
    showSelf = false
  end
  if showSelf and data and (data.rank and #data.rank > 0 or data.ranks and 0 < #data.ranks) then
    if data.self and data.self.score or LuaEntry.Player:IsInAlliance() then
      self.self_data:SetActive(true)
      self.ScrollView.transform.offsetMin = Vector2.New(self.ScrollView.transform.offsetMin.x, 350)
      self:RefreshSelfContent(data.self, data.rank or data.ranks)
    else
      self.self_data:SetActive(false)
      self.ScrollView.transform.offsetMin = Vector2.New(self.ScrollView.transform.offsetMin.x, 200)
    end
  else
    self.self_data:SetActive(false)
    self.ScrollView.transform.offsetMin = Vector2.New(self.ScrollView.transform.offsetMin.x, 200)
  end
  if self.lw_season_rank_config == nil then
    if self.tabActive == nil then
      return
    end
    if data and data.rank_type and self.RankData[data.rank_type] == nil then
      self.RankData[data.rank_type] = data
    end
    if data and data.rank_type ~= self.theType then
      return
    end
  end
  self:ClearScroll()
  if self.theType == nil then
    self.rankList = nil
    self.no_data:SetActive(true)
  elseif data then
    self.rankList = data.rank or data.ranks or data.ls
    if self.rankList and 0 < #self.rankList then
      self.no_data:SetActive(false)
      self.ScrollView:SetTotalCount(#self.rankList)
      self.ScrollView:RefillCells()
    else
      self.no_data:SetActive(true)
    end
  end
end

function LWSeasonRankView:RefreshSelfContent(dataSelf, dataAll)
  local currentData
  local theType = self.theType
  local player = LuaEntry.Player
  local serverId = tonumber(player:GetSourceServerId())
  local myScore = 0
  local isAlliance = SeasonUtil.SesaonRankOfAlliance(theType)
  local isPersonal = SeasonUtil.SesaonRankOfPersaon(theType)
  local isServer = SeasonUtil.SesaonRankOfServer(theType)
  if dataSelf then
    myScore = dataSelf.score or 0
    for k, v in ipairs(dataAll) do
      local dataAid = v.aid or v.allianceId
      if isAlliance and player.allianceId == dataAid or isPersonal and v.uid == player.uid or isServer and tonumber(v.serverId) == serverId then
        currentData = v
        break
      end
    end
  end
  if currentData then
    self.self_data:SetItemShow(self.theType, currentData, true)
  else
    local data = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
    if isAlliance then
      if data == nil then
        self.self_data:SetActive(false)
        self.ScrollView.transform.offsetMin = Vector2.New(self.ScrollView.transform.offsetMin.x, 200)
        return
      end
      self.self_data:SetItemShow(self.theType, {
        abbr = data.abbr,
        aid = data.uid,
        icon = data.icon,
        name = data.allianceName,
        serverId = serverId,
        score = myScore
      }, true)
    elseif isPersonal then
      if data == nil then
        data = {}
      end
      self.self_data:SetItemShow(self.theType, {
        abbr = data.abbr,
        headPic = player.pic,
        headPicVer = player.picVer or 0,
        name = player.name,
        uid = player.uid,
        serverId = serverId,
        score = myScore
      }, true)
    elseif isServer then
      self.self_data:SetItemShow(self.theType, {serverId = serverId, score = myScore}, true)
    end
  end
end

function LWSeasonRankView:OnRankItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.ScrollView:AddComponent(LWSeasonRankItem, itemObj)
  if cellItem ~= nil then
    cellItem:SetItemShow(self.theType, self.rankList[index], false)
  end
end

function LWSeasonRankView:OnRankItemMoveOut(itemObj, index)
  self.ScrollView:RemoveComponent(itemObj.name, LWSeasonRankItem)
end

function LWSeasonRankView:ClearScroll()
  self.ScrollView:ClearCells()
  self.ScrollView:RemoveComponents(LWSeasonRankItem)
end

function LWSeasonRankView:OnPlayerDetailClick(serverId, playerUid)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {anim = true}, {serverId = serverId, uid = playerUid})
end

function LWSeasonRankView:OnAllianceDetailClick(serverId, allianceId, allianceName)
  UIUtil.TryShowAllianceInfo(serverId, allianceId, allianceName)
end

function LWSeasonRankView:OnInfoClick()
  if self.rankInfo and self.rankInfo[self.tabActive] and not string.IsNullOrEmpty(self.rankInfo[self.tabActive].desc) then
    local param = {}
    param.activityRulesStr = Localization:GetString(self.rankInfo[self.tabActive].desc)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
  end
end

function LWSeasonRankView:OnScoreInfoClick()
  if self.lw_season_score_config ~= nil then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonScoreDetail, {anim = false}, self.lw_season_score_config)
  end
end

function LWSeasonRankView:OnRewardBtnClick()
  local seasonType = SeasonUtil.GetSeasonType(true, true)
  if seasonType == SeasonMapType.NineNationRainforest then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWS6Reward, {anim = false})
  elseif seasonType == SeasonMapType.NineNation then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeason5Reward, {anim = false})
  elseif self.theType == SeasonRankType.CampRareLand then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonReward, {anim = false}, 2)
  elseif self.theType == SeasonRankType.AlliancePower then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonReward, {anim = false}, 1)
  elseif self.theType == SeasonRankType.ServerPower then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonReward, {anim = false}, 2)
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonReward, {anim = false})
  end
end

function LWSeasonRankView:SelectChange(itemData, index)
  if (itemData.type == SeasonRankType.AllianceCamp1RareLand or itemData.type == SeasonRankType.AllianceCamp2RareLand) and not DataCenter.SeasonFactionWarDataManager:IsGroupingShownMode() then
    UIUtil.ShowTipsId("season_s2_rank_reward_19")
    return false
  end
  self.subIndex = index
  self:OnTabChanged(self.tabActive, true)
  return true
end

function LWSeasonRankView:SetOnTop()
  if self.theType == SeasonRankType.CampRareLand then
    self.seasonRankCamp:RefreshAnimation()
  end
end

function LWSeasonRankView:DoCampSeasonSkin()
  local seasonType = SeasonUtil.GetSeasonType(false, true)
  local needChange = seasonType == SeasonMapType.Darkness or seasonType == SeasonMapType.NineNationRainforest
  if self.campReq == nil and needChange then
    local loadMap = {
      [SeasonMapType.Darkness] = "Assets/Main/SeasonRes/S4/Prefabs/UI/LWSeasonRank/S4CampRank.prefab",
      [SeasonMapType.NineNationRainforest] = "Assets/Main/SeasonRes/S6/Prefabs/UI/CampRank/S6CampRank.prefab"
    }
    local compScript = {
      [SeasonMapType.Darkness] = SeasonRankCampOtherType,
      [SeasonMapType.NineNationRainforest] = SeasonRankCampS6
    }
    self:RemoveComponent(self.seasonRankCamp:GetName(), SeasonRankCamp)
    self.seasonRankCamp = nil
    self.other_camp_rank:SetActive(true)
    self.dynamic_bg:SetActive(true)
    self.campReq = self:GameObjectInstantiateAsync(loadMap[seasonType], function(request)
      if request.isError then
        return
      end
      self.dynamic_bg:SetActive(false)
      local go = request.gameObject
      go.transform:SetParent(self.other_camp_rank.transform)
      self.seasonRankCamp = self.other_camp_rank:AddComponent(compScript[seasonType], go.name)
      self.seasonRankCamp:SetLocalScaleXYZ(1, 1, 1)
      self.seasonRankCamp:SetAnchoredPositionXY(0, 0)
      self.seasonRankCamp:SetSizeDeltaXY(0, 0)
      self:OnTabChanged(lastActiveTab, true)
    end)
  end
end

function LWSeasonRankView:DoCampNeedHideWhenTabChange(show)
  local seasonType = SeasonUtil.GetSeasonType(false, true)
  local needChange = seasonType == SeasonMapType.Darkness or seasonType == SeasonMapType.NineNationRainforest
  if needChange then
    self.other_camp_rank:SetActive(show)
  end
end

function LWSeasonRankView:OnS5MoneyRankClick()
  local seasonType = SeasonUtil.GetSeasonType(false, true)
  if seasonType ~= SeasonMapType.NineNation then
    return
  end
  local win = UIManager:GetInstance():GetWindow(UIWindowNames.UILWSingleActivityContainer)
  if win and win.State ~= 2 then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSingleActivityContainer)
  end
  GoToUtil.GotoSeasonActivityView(EnumActivity.SeasonMoneyRank.Type)
end

return LWSeasonRankView
