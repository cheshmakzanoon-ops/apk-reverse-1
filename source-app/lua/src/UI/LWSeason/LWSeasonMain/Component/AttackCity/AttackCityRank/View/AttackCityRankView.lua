local SeasonAttackCityRankView = BaseClass("SeasonAttackCityRankView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local AttackCityRankItem = require("UI.LWSeason.LWSeasonMain.Component.AttackCity.AttackCityRank.Component.AttackCityRankItem")
local text_title_path = "Root/TopBar/TextTitle"
local btn_back_path = "Root/BottomBar/BtnBack"
local rank_des_path = "Root/ScrollView/select/rankDes"
local name_des_path = "Root/ScrollView/select/nameDes"
local power_des_path = "Root/ScrollView/select/powerDes"
local self_data_path = "Root/SelfData"
local info_btn_path = "Root/TopBar/InfoBtn"
local btn_rank_reward_path = "Root/BottomBar/BtnRankReward"
local scroll_path = "Root/ScrollView"
local cacheRankData
local cacheRankDataTime = 0

function SeasonAttackCityRankView:OnCreate()
  base.OnCreate(self)
  self.rankList = nil
  self.activityId = self:GetUserData()
  self.txt_title = self:AddComponent(UIText, text_title_path)
  self.name_des = self:AddComponent(UIText, name_des_path)
  self.power_des = self:AddComponent(UIText, power_des_path)
  self.rank_des = self:AddComponent(UIText, rank_des_path)
  self.close_btn = self:AddComponent(UIButton, btn_back_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.info_btn = self:AddComponent(UIButton, info_btn_path)
  self.info_btn:SetActive(false)
  self.info_btn:SetOnClick(function()
  end)
  self.self_data = self:AddComponent(AttackCityRankItem, self_data_path)
  self.ScrollView = self:AddComponent(UIScrollView, scroll_path)
  self.ScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnRankItemMoveIn(itemObj, index)
  end)
  self.ScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnRankItemMoveOut(itemObj, index)
  end)
  self.btn_rank_reward = self:AddComponent(UIButton, btn_rank_reward_path)
  self.btn_rank_reward:SetActive(true)
  self.btn_rank_reward:SetOnClick(function()
    self:RequestRewardInfo()
  end)
  self:InitViewText()
  self.self_data:SetActive(false)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if cacheRankDataTime == nil or cacheRankDataTime == 0 or cacheRankData == nil or cacheRankData.activityId ~= self.activityId or 300000 < curTime - cacheRankDataTime then
    SFSNetwork.SendMessage(MsgDefines.SeasonAttackCityRank, self.activityId)
  else
    self:OnRankInfoUpdate(cacheRankData)
  end
end

function SeasonAttackCityRankView:OnDestroy()
  self:ClearScroll()
  self.txt_title = nil
  self.name_des = nil
  self.power_des = nil
  self.rank_des = nil
  self.close_btn = nil
  self.ScrollView = nil
  self.rankList = nil
  self.btn_rank_reward = nil
  base.OnDestroy(self)
end

function SeasonAttackCityRankView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.LWSeasonAttackCityRankRewardUpdate, self.OpenRewardWindow)
  self:AddUIListener(EventId.LWSeasonAttackCityRankInfoUpdate, self.OnRankInfoUpdate)
end

function SeasonAttackCityRankView:OnRemoveListener()
  self:RemoveUIListener(EventId.LWSeasonAttackCityRankRewardUpdate, self.OpenRewardWindow)
  self:RemoveUIListener(EventId.LWSeasonAttackCityRankInfoUpdate, self.OnRankInfoUpdate)
  base.OnRemoveListener(self)
end

function SeasonAttackCityRankView:InitViewText()
  self.txt_title:SetLocalText("season_trends_rank_name015")
  self.rank_des:SetLocalText("361013")
  self.name_des:SetLocalText("390288")
  self.power_des:SetLocalText("season_trends_rank_score_name005")
end

function SeasonAttackCityRankView:OnRankInfoUpdate(data)
  if data == nil or data.activityId ~= self.activityId then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  cacheRankDataTime = curTime
  cacheRankData = data
  self.rankList = data.rank or {}
  self.selfScore = data.selfScore or 0
  self:RefreshRankList()
  local dataInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if dataInfo == nil or dataInfo.rankRewardParam == nil then
    self.btn_rank_reward:SetActive(false)
  end
end

function SeasonAttackCityRankView:RefreshRankList()
  self:ClearScroll()
  if self.rankList then
    if #self.rankList > 0 then
      self.ScrollView:SetTotalCount(#self.rankList)
      self.ScrollView:RefillCells()
    end
    local myAid = LuaEntry.Player:GetAllianceUid()
    if string.IsNullOrEmpty(myAid) then
      self.self_data:SetActive(false)
    else
      self:RefreshSelfContent(myAid)
    end
  end
end

function SeasonAttackCityRankView:RefreshSelfContent(myAid)
  local myData
  for k, v in ipairs(self.rankList) do
    if v and v.aid == myAid then
      myData = v
    end
  end
  if myData == nil then
    local allianceData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
    myData = {}
    myData.rank = "100+"
    myData.icon = allianceData.icon
    myData.aid = myAid
    myData.abbr = allianceData.abbr
    myData.name = allianceData.allianceName
    myData.firstName = "[" .. allianceData.abbr .. "]" .. allianceData.allianceName
    myData.score = self.selfScore
    myData.serverId = LuaEntry.Player:GetSourceServerId()
  end
  self.self_data:SetActive(true)
  self.self_data:SetItemShow(myData, true)
end

function SeasonAttackCityRankView:OnRankItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.ScrollView:AddComponent(AttackCityRankItem, itemObj)
  if cellItem ~= nil then
    cellItem:SetItemShow(self.rankList[index], false)
  end
end

function SeasonAttackCityRankView:OnRankItemMoveOut(itemObj, index)
  self.ScrollView:RemoveComponent(itemObj.name, AttackCityRankItem)
end

function SeasonAttackCityRankView:ClearScroll()
  self.ScrollView:ClearCells()
  self.ScrollView:RemoveComponents(AttackCityRankItem)
end

function SeasonAttackCityRankView:RequestRewardInfo()
  SFSNetwork.SendMessage(MsgDefines.SeasonAttackCityRankReward, self.activityId)
end

function SeasonAttackCityRankView:OpenRewardWindow(data)
  if data == nil or data.activityId ~= self.activityId then
    return
  end
  local reward = data.rankReward
  if reward and 0 < #reward then
    for k, v in ipairs(reward) do
      if v and v.rank then
        local rankRange = string.split(v.rank, "-")
        if 1 < #rankRange then
          v.minRanking = toInt(rankRange[1])
          v.maxRanking = toInt(rankRange[2])
        elseif 0 < #rankRange then
          v.minRanking = toInt(rankRange[1])
          v.maxRanking = toInt(rankRange[1])
        end
        v.rewards = DataCenter.RewardManager:ParseRewardsInfo(v.rewards)
      end
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWUICommonRankReward, {anim = true}, reward)
  end
end

function SeasonAttackCityRankView:OnCellClick(d)
  if d and d.aid then
    UIUtil.TryShowAllianceInfo(d.serverId, d.aid, d.name)
  end
end

return SeasonAttackCityRankView
