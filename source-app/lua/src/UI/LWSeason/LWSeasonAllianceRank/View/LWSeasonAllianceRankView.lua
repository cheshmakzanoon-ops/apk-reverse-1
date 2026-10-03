local LWSeasonAllianceRankView = BaseClass("LWSeasonAllianceRankView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local LWSeasonAllianceRankTabItem = require("UI.LWSeason.LWSeasonAllianceRank.Component.LWSeasonAllianceRankTabItem")
local LWSeasonAllianceRankItem = require("UI.LWSeason.LWSeasonAllianceRank.Component.LWSeasonAllianceRankItem")
local lastActiveTab
local lastActiveSubTab = 3
local info_btn_path = "Root/TopBar/InfoBtn"
local btn_back_path = "Root/BottomBar/BtnBack"
local text_title_path = "Root/TopBar/TextTitle"
local rank_list_path = "Root/RankList"
local content_path = "Root/RankList/Viewport/Content"
local tab_item1_path = "Root/TopBar/Tab/TabItem1"
local tab_item2_path = "Root/TopBar/Tab/TabItem2"
local tab_item3_path = "Root/TopBar/Tab/TabItem3"
local tab_item4_path = "Root/TopBar/Tab/TabItem4"
local tab_item5_path = "Root/TopBar/Tab/TabItem5"
local self_data_path = "Root/Item/SelfData"
local toggle1_path = "Root/TopBar/SubTab/toggle1"
local toggle_txt_off1_path = "Root/TopBar/SubTab/toggle1/toggle_txt_off1"
local toggle_txt_on1_path = "Root/TopBar/SubTab/toggle1/on1/toggle_txt_on1"
local toggle2_path = "Root/TopBar/SubTab/toggle2"
local toggle_txt_off2_path = "Root/TopBar/SubTab/toggle2/toggle_txt_off2"
local toggle_txt_on2_path = "Root/TopBar/SubTab/toggle2/on2/toggle_txt_on2"
local toggle3_path = "Root/TopBar/SubTab/toggle3"
local toggle_txt_off3_path = "Root/TopBar/SubTab/toggle3/toggle_txt_off3"
local toggle_txt_on3_path = "Root/TopBar/SubTab/toggle3/on3/toggle_txt_on3"
local rank_des_path = "Root/TopBar/select/rankDes"
local name_des_path = "Root/TopBar/select/nameDes"
local power_des_path = "Root/TopBar/select/powerDes"
local reward_des_path = "Root/TopBar/select/rewardDes"
local box_path = "Root/BottomBar/Info/box"
local reward_path = "Root/BottomBar/Info/box/Reward"
local btn_reward_path = "Root/BottomBar/Info/BtnReward"
local btn_history_path = "Root/BottomBar/Info/BtnHistory"
local num_path = "Root/BottomBar/Info/box/num"
local no_data_path = "Root/RankList/no_data"

function LWSeasonAllianceRankView:OnCreate()
  base.OnCreate(self)
  local param = self:GetUserData()
  self.param = param
  self.flagGlobal = 0
  self.tabActive = nil
  self.cellCache = {}
  self.serverId = LuaEntry.Player:GetSourceServerId()
  self:ComponentDefine()
end

function LWSeasonAllianceRankView:OnDestroy()
  self:ClearScroll()
  self.cellCache = nil
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWSeasonAllianceRankView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.LWSeasonAllianceRankDataUpdate, self.RefreshRankList)
  self:AddUIListener(EventId.LWSeasonAllianceLootTotalUpdate, self.UpdateLootData)
end

function LWSeasonAllianceRankView:OnRemoveListener()
  self:RemoveUIListener(EventId.LWSeasonAllianceRankDataUpdate, self.RefreshRankList)
  self:RemoveUIListener(EventId.LWSeasonAllianceLootTotalUpdate, self.UpdateLootData)
  base.OnRemoveListener(self)
end

function LWSeasonAllianceRankView:ComponentDefine()
  self.text_title = self:AddComponent(UIText, text_title_path)
  self.text_title:SetLocalText("season_rank_ui000")
  self.btn_back = self:AddComponent(UIButton, btn_back_path)
  self.btn_back:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.no_data = self:AddComponent(UIText, no_data_path)
  self.no_data:SetActive(false)
  self.info_btn = self:AddComponent(UIButton, info_btn_path)
  self.info_btn:SetOnClick(function()
    local eventId = tonumber(self.tabActive)
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWSeasonAllianceScoreDetail, {anim = false}, 801449, 801450, eventId)
  end)
  self.tab_item1 = self:AddComponent(LWSeasonAllianceRankTabItem, tab_item1_path)
  self.tab_item2 = self:AddComponent(LWSeasonAllianceRankTabItem, tab_item2_path)
  self.tab_item3 = self:AddComponent(LWSeasonAllianceRankTabItem, tab_item3_path)
  self.tab_item4 = self:AddComponent(LWSeasonAllianceRankTabItem, tab_item4_path)
  self.tab_item5 = self:AddComponent(LWSeasonAllianceRankTabItem, tab_item5_path)
  self.self_data = self:AddComponent(LWSeasonAllianceRankItem, self_data_path)
  self.toggle1 = self:AddComponent(UIToggle, toggle1_path)
  self.toggle_txt_off1 = self:AddComponent(UIText, toggle_txt_off1_path)
  self.toggle_txt_on1 = self:AddComponent(UIText, toggle_txt_on1_path)
  self.toggle2 = self:AddComponent(UIToggle, toggle2_path)
  self.toggle_txt_off2 = self:AddComponent(UIText, toggle_txt_off2_path)
  self.toggle_txt_on2 = self:AddComponent(UIText, toggle_txt_on2_path)
  self.toggle3 = self:AddComponent(UIToggle, toggle3_path)
  self.toggle_txt_off3 = self:AddComponent(UIText, toggle_txt_off3_path)
  self.toggle_txt_on3 = self:AddComponent(UIText, toggle_txt_on3_path)
  self.toggle_txt_off1:SetLocalText("season_rank_ui005")
  self.toggle_txt_on1:SetLocalText("season_rank_ui005")
  self.toggle_txt_off2:SetLocalText("season_rank_ui006")
  self.toggle_txt_on2:SetLocalText("season_rank_ui006")
  self.toggle_txt_off3:SetLocalText("season_rank_ui007")
  self.toggle_txt_on3:SetLocalText("season_rank_ui007")
  self.num = self:AddComponent(UIText, num_path)
  self:UpdateLootData()
  self.toggle1:SetOnValueChanged(function(tf)
    if tf then
      if not self.toggle1.selecting then
        DataCenter.LWSoundManager:PlaySound(6100023, false)
      end
      self:OnTabChanged(self.tabActive, 1)
    end
    self.toggle1.selecting = false
  end)
  self.toggle2:SetOnValueChanged(function(tf)
    if tf then
      if not self.toggle2.selecting then
        DataCenter.LWSoundManager:PlaySound(6100023, false)
      end
      self:OnTabChanged(self.tabActive, 2)
    end
    self.toggle2.selecting = false
  end)
  self.toggle3:SetOnValueChanged(function(tf)
    if tf then
      if not self.toggle3.selecting then
        DataCenter.LWSoundManager:PlaySound(6100023, false)
      end
      self:OnTabChanged(self.tabActive, 3)
    end
    self.toggle3.selecting = false
  end)
  self.rank_des = self:AddComponent(UIText, rank_des_path)
  self.name_des = self:AddComponent(UIText, name_des_path)
  self.power_des = self:AddComponent(UIText, power_des_path)
  self.reward_des = self:AddComponent(UIText, reward_des_path)
  self.rank_des:SetText(Localization:GetString("302043"))
  self.name_des:SetText(Localization:GetString("100031"))
  self.power_des:SetText(Localization:GetString("302042"))
  self.reward_des:SetText(Localization:GetString("130065"))
  self.box = self:AddComponent(UIButton, box_path)
  self.rewardIcon = self:AddComponent(UIImage, reward_path)
  self.btn_reward = self:AddComponent(UIButton, btn_reward_path)
  self.btn_history = self:AddComponent(UIButton, btn_history_path)
  self.box:SetOnClick(function()
    if ComponentIsValid(self.rewardIcon) then
      UIUtil.ShowLootRewardList(self.rewardIcon:GetPosition())
    end
  end)
  self.btn_reward:SetOnClick(function()
    self:OnRewardDescriptionBtn()
  end)
  self.btn_history:SetOnClick(function()
    self:OnDistributeRecordBtn()
  end)
  self.ScrollView = self:AddComponent(UIScrollView, rank_list_path)
  self.ScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnRankItemMoveIn(itemObj, index)
  end)
  self.ScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnRankItemMoveOut(itemObj, index)
  end)
  if lastActiveSubTab == 1 then
    self.toggle1:SetIsOn(true)
  elseif lastActiveSubTab == 2 then
    self.toggle2:SetIsOn(true)
  elseif lastActiveSubTab == 3 then
    self.toggle3:SetIsOn(true)
  end
  local eventIds = DataCenter.SeasonDataManager:GetSeasonHeroEventIds()
  local isFarmer = DataCenter.SeasonFarmerManager:IsActive()
  if isFarmer then
    local config = DataCenter.SeasonFarmerTemplateManager:GetMainCfg()
    if config then
      local tempEventId = {}
      table.insert(tempEventId, tostring(config.heroevent))
      for i, v in ipairs(eventIds) do
        table.insert(tempEventId, v)
      end
      eventIds = tempEventId
    end
  end
  if eventIds then
    for i = 1, 5 do
      local item = self["tab_item" .. i]
      if eventIds[i] then
        item:SetTabIndex(eventIds[i])
        item:SetActive(true)
      else
        item:SetActive(false)
      end
      if lastActiveTab == eventIds[i] then
        item:SetIsOn(true)
      end
    end
    if lastActiveTab == nil then
      lastActiveTab = eventIds[1]
      local item = self["tab_item" .. 1]
      item:SetIsOn(true)
    end
  else
    for i = 1, 4 do
      local item = self["tab_item" .. i]
      item:SetActive(false)
    end
  end
  if self.tabActive == nil then
    self:OnTabChanged(lastActiveTab, lastActiveSubTab)
  end
end

function LWSeasonAllianceRankView:ComponentDestroy()
  self.btn_back = nil
  self.tabActive = nil
  self.num = nil
end

function LWSeasonAllianceRankView:OnTabChanged(index, subIndex)
  if index then
    lastActiveTab = index
  else
    return
  end
  if subIndex then
    lastActiveSubTab = subIndex
  else
    subIndex = lastActiveSubTab
  end
  self.tabActive = index
  Logger.Log(string.format("OnTabChanged(%s, %s)", index, subIndex))
  SFSNetwork.SendMessage(MsgDefines.LWSeasonAllianceDevotesRankInfo, self.tabActive, subIndex, 1, -1)
end

function LWSeasonAllianceRankView:RefreshRankList(param)
  if self.tabActive == nil then
    return
  end
  if self.tabActive == param.eventId and lastActiveSubTab == param.subType then
    self:ClearScroll()
    local rankData = DataCenter.SeasonAllianceRankDataManager:GetRankData(self.tabActive, lastActiveSubTab)
    self.rankList = rankData.ranks
    if self.rankList then
      if #self.rankList > 0 then
        self.ScrollView:SetTotalCount(#self.rankList)
        self.ScrollView:RefillCells()
        self.no_data:SetActive(false)
      else
        self.no_data:SetActive(true)
      end
    else
      self.no_data:SetActive(true)
    end
    self:RefreshSelfContent(rankData.selfRank)
  end
  self:UpdateLootData()
end

function LWSeasonAllianceRankView:RefreshSelfContent(data)
  local currentData
  local theType = self.theType
  if self.rankList then
    for i = 1, #self.rankList do
      if self.rankList[i].uid == LuaEntry.Player.uid then
        currentData = self.rankList[i]
      end
    end
  end
  if currentData == nil then
    currentData = self.ctrl:GetSelfData(data)
  end
  self.self_data:SetActive(true)
  self.self_data:SetItemShow(currentData, self, true, lastActiveSubTab)
end

function LWSeasonAllianceRankView:OnRankItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.ScrollView:AddComponent(LWSeasonAllianceRankItem, itemObj)
  if cellItem ~= nil then
    cellItem:SetItemShow(self.rankList[index], self, false, lastActiveSubTab)
    self.cellCache[index] = cellItem
  end
end

function LWSeasonAllianceRankView:OnRankItemMoveOut(itemObj, index)
  self.ScrollView:RemoveComponent(itemObj.name, LWSeasonAllianceRankItem)
  self.cellCache[index] = nil
end

function LWSeasonAllianceRankView:ClearScroll()
  self.ScrollView:ClearCells()
  self.ScrollView:RemoveComponents(LWSeasonAllianceRankItem)
  self.cellCache = {}
end

function LWSeasonAllianceRankView:OnDistributeRecordBtn()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWCommonRecordLog, {anim = true}, CommonRecordPanelType.SeasonRewardRecord)
end

function LWSeasonAllianceRankView:OnRewardDescriptionBtn()
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWSeasonAllianceRankRewardInfo, {anim = true})
end

function LWSeasonAllianceRankView:UpdateLootData(toUid)
  local lootNum = DataCenter.SeasonAllianceRankDataManager:GetLootTotal()
  self.num:SetText(string.format("X %s", tostring(lootNum)))
  if toUid and self.cellCache then
    for key, value in pairs(self.cellCache) do
      if value.data.uid == toUid then
        local rankData = self.rankList[key]
        if rankData then
          self.cellCache[key]:SetItemShow(rankData, self, false, lastActiveSubTab)
        end
        break
      end
    end
    local rankData = DataCenter.SeasonAllianceRankDataManager:GetRankData(self.tabActive, lastActiveSubTab)
    self:RefreshSelfContent(rankData.selfRank)
  end
end

function LWSeasonAllianceRankView:GetRankInfo()
  return {
    eventId = self.tabActive,
    subType = lastActiveSubTab
  }
end

return LWSeasonAllianceRankView
