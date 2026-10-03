local UIRankDetailListView = BaseClass("UIRankDetailListView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local RankListItem = require("UI.UIRank.UIRankDetailList.Component.RankListItem")
local text_title_path = "Root/TopBar/TextTitle"
local btn_back_path = "Root/BottomBar/BtnBack"
local rank_des_path = "Root/ScrollView/select/rankDes"
local name_des_path = "Root/ScrollView/select/nameDes"
local power_des_path = "Root/ScrollView/select/powerDes"
local self_data_path = "Root/SelfData"
local info_btn_path = "Root/TopBar/InfoBtn"
local refresh_btn_path = "Root/BottomBar/RefreshBtn"
local tips_path = "Root/BottomBar/tips"
local scroll_path = "Root/ScrollView"

function UIRankDetailListView:OnCreate()
  base.OnCreate(self)
  self.flagGlobal, self.theType, self.serverId = self:GetUserData()
  self.txt_title = self:AddComponent(UIText, text_title_path)
  self.name_des = self:AddComponent(UIText, name_des_path)
  self.power_des = self:AddComponent(UIText, power_des_path)
  self.rank_des = self:AddComponent(UIText, rank_des_path)
  self.close_btn = self:AddComponent(UIButton, btn_back_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.info_btn = self:AddComponent(UIButton, info_btn_path)
  self.info_btn:SetOnClick(function()
    local param = {
      activityRulesStr = Localization:GetString("451037")
    }
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
  end)
  self.refresh_btn = self:AddComponent(UIButton, refresh_btn_path)
  self.refresh_btn:SetOnClick(function()
    if self.flagGlobal ~= nil and self.theType ~= nil and CS.CommonUtils.IsDebug() then
      SFSNetwork.SendMessage(MsgDefines.GetRankListMessage, self.flagGlobal, self.theType, self.serverId)
    end
  end)
  self.self_data = self:AddComponent(RankListItem, self_data_path)
  self.ScrollView = self:AddComponent(UIScrollView, scroll_path)
  self.tips_text = self:AddComponent(UIText, tips_path)
  self.ScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnRankItemMoveIn(itemObj, index)
  end)
  self.ScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnRankItemMoveOut(itemObj, index)
  end)
  if self.serverId == nil then
    self.serverId = LuaEntry.Player:GetSourceServerId()
  end
  local selfUid = LuaEntry.Player:GetUid()
  local playerInfo = DataCenter.PlayerInfoDataManager:GetPlayerDataByUid(selfUid)
  if playerInfo == nil then
    SFSNetwork.SendMessage(MsgDefines.GetNewUserInfo, selfUid)
  end
  self:InitViewText()
  self:RefreshTips()
  self:RefreshInfoBtn()
end

function UIRankDetailListView:OnDestroy()
  self:ClearScroll()
  self.theType = nil
  self.txt_title = nil
  self.name_des = nil
  self.power_des = nil
  self.rank_des = nil
  self.close_btn = nil
  self.ScrollView = nil
  self.rankList = nil
  self.tips_text = nil
  base.OnDestroy(self)
end

function UIRankDetailListView:InitViewText()
  local theType = self.theType
  self.rank_des:SetLocalText(361013)
  if theType == RankingTypeServer.KILL_ALLIANCE or theType == RankingTypeServer.POWER_ALLIANCE then
    self.name_des:SetLocalText(390288)
  else
    self.name_des:SetLocalText(100184)
  end
  if theType == RankingTypeServer.KILL_ALLIANCE then
    self.txt_title:SetLocalText(129093)
    self.power_des:SetLocalText(104225)
  elseif theType == RankingTypeServer.POWER_ALLIANCE then
    self.txt_title:SetLocalText(129094)
    self.power_des:SetLocalText(100644)
  elseif theType == RankingTypeServer.KILL then
    self.txt_title:SetLocalText(129095)
    self.power_des:SetLocalText(104225)
  elseif theType == RankingTypeServer.POWER then
    self.txt_title:SetLocalText(129096)
    self.power_des:SetLocalText(100644)
  elseif theType == RankingTypeServer.HERO_TOTAL_POWER then
    self.txt_title:SetLocalText(451035)
    self.power_des:SetLocalText(100644)
  elseif theType == RankingTypeServer.PVE_STAGE then
    self.txt_title:SetLocalText(451034)
    self.power_des:SetLocalText(450002, "")
  elseif theType == RankingTypeServer.ONE_HERO_POWER then
    self.txt_title:SetLocalText(451036)
    self.power_des:SetLocalText(100644)
  elseif theType == RankingTypeServer.BUILDING then
    self.txt_title:SetLocalText(129097)
    self.power_des:SetLocalText(GameDialogDefine.LEVEL)
  elseif theType == RankingTypeServer.TRIAL_TOWER_AIRPLANE then
    self.txt_title:SetLocalText("trialtower_025")
    self.power_des:SetLocalText("trialtower_033")
  elseif theType == RankingTypeServer.TRIAL_TOWER_TANK then
    self.txt_title:SetLocalText("trialtower_024")
    self.power_des:SetLocalText("trialtower_033")
  elseif theType == RankingTypeServer.TRIAL_TOWER_MISSILE then
    self.txt_title:SetLocalText("trialtower_026")
    self.power_des:SetLocalText("trialtower_033")
  elseif theType == RankingTypeServer.DOMINATOR_UP_PVE then
    self.txt_title:SetLocalText("armed_truck_dominator_rank_title")
    self.power_des:SetLocalText(450002, "")
  elseif theType == RankingTypeServer.T11_IDLE_GAME then
    self.txt_title:SetLocalText("t11_idle_game_desc_80")
    self.power_des:SetLocalText("t11_idle_game_desc_81")
  end
  DataCenter.RankDataManager:fetchRankData(self.flagGlobal, theType, self.serverId)
  self:RefreshRankList()
end

function UIRankDetailListView:RefreshRankList()
  self:ClearScroll()
  self.rankList = self.ctrl:GetRankList(self.flagGlobal, self.theType, self.serverId)
  if #self.rankList > 0 then
    self.ScrollView:SetTotalCount(#self.rankList)
    self.ScrollView:RefillCells()
  end
  self:RefreshSelfContent()
end

function UIRankDetailListView:RefreshSelfContent()
  local serverId = toInt(self.serverId)
  if serverId ~= LuaEntry.Player:GetSourceServerId() then
    local isBigMapMode, curSame, srcSame, loginSame = SeasonUtil.InSeasonBigMapMode(serverId)
    if isBigMapMode and loginSame then
      local mapIndex = DataCenter.SeasonDataManager:GetNinePalacesIndex(serverId)
      if mapIndex == 5 then
      else
        self.self_data:SetActive(false)
        return
      end
    else
      self.self_data:SetActive(false)
      return
    end
  end
  local currentData
  local theType = self.theType
  local myUid = LuaEntry.Player.uid
  local myAllianceId = LuaEntry.Player.allianceId
  local dataList = self.rankList
  if theType == RankingTypeServer.KILL or theType == RankingTypeServer.HERO_TOTAL_POWER or theType == RankingTypeServer.PVE_STAGE or theType == RankingTypeServer.ONE_HERO_POWER or theType == RankingTypeServer.POWER or theType == RankingTypeServer.BUILDING or theType == RankingTypeServer.TRIAL_TOWER_TANK or theType == RankingTypeServer.TRIAL_TOWER_MISSILE or theType == RankingTypeServer.TRIAL_TOWER_AIRPLANE or theType == RankingTypeServer.DOMINATOR_UP_PVE or theType == RankingTypeServer.T11_IDLE_GAME then
    for i = 1, #dataList do
      if dataList[i].uid == myUid then
        currentData = dataList[i]
        break
      end
    end
  elseif theType == RankingTypeServer.POWER_ALLIANCE or theType == RankingTypeServer.KILL_ALLIANCE then
    for i = 1, #dataList do
      if dataList[i].uid == myAllianceId then
        currentData = dataList[i]
        break
      end
    end
  end
  if currentData == nil then
    currentData = self.ctrl:GetSelfData(self.flagGlobal, theType)
  end
  self.self_data:SetActive(true)
  self.self_data:SetItemShow(self.flagGlobal, currentData, true)
end

function UIRankDetailListView:Init()
end

function UIRankDetailListView:OnRankItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.ScrollView:AddComponent(RankListItem, itemObj)
  if cellItem ~= nil then
    cellItem:SetItemShow(self.flagGlobal, self.rankList[index], false)
  end
end

function UIRankDetailListView:OnRankItemMoveOut(itemObj, index)
  self.ScrollView:RemoveComponent(itemObj.name, RankListItem)
end

function UIRankDetailListView:ClearScroll()
  self.ScrollView:ClearCells()
  self.ScrollView:RemoveComponents(RankListItem)
end

function UIRankDetailListView:RefreshTips()
  local theType = self.theType
  if theType == RankingTypeServer.T11_IDLE_GAME then
    self.tips_text:SetActive(false)
  else
    self.tips_text:SetActive(true)
  end
end

function UIRankDetailListView:RefreshInfoBtn()
  local theType = self.theType
  if theType == RankingTypeServer.T11_IDLE_GAME then
    self.info_btn:SetActive(false)
  else
    self.info_btn:SetActive(true)
  end
end

function UIRankDetailListView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.PlayerRank, self.RefreshRankList)
  self:AddUIListener(EventId.AllianceRank, self.RefreshRankList)
  self:AddUIListener(EventId.RefreshRankingData, self.RefreshRankList)
end

function UIRankDetailListView:OnRemoveListener()
  self:RemoveUIListener(EventId.PlayerRank, self.RefreshRankList)
  self:RemoveUIListener(EventId.AllianceRank, self.RefreshRankList)
  self:RemoveUIListener(EventId.RefreshRankingData, self.RefreshRankList)
  base.OnRemoveListener(self)
end

function UIRankDetailListView:OnPlayerDetailClick(serverId, playerUid)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {anim = true}, {serverId = serverId, uid = playerUid})
end

function UIRankDetailListView:OnAllianceDetailClick(serverId, allianceId, allianceName)
  UIUtil.TryShowAllianceInfo(serverId, allianceId, allianceName)
end

return UIRankDetailListView
