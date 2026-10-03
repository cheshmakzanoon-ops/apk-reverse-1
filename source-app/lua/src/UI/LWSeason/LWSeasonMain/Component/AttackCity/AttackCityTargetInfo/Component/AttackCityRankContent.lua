local SeasonAttackCityRankContent = BaseClass("SeasonAttackCityRankContent", UIBaseContainer)
local base = UIBaseContainer
local UIItem = require("UI.LWSeason.LWSeasonMain.Component.AttackCity.AttackCityTargetInfo.Component.AttackCityRankContentItem")
local rank_des_path = "select/rankDes"
local name_des_path = "select/nameDes"
local power_des_path = "select/powerDes"
local country_des_path = "select/countryDes"
local self_data_path = "SelfData"
local ShowListPath = "ShowListScroll"
local ShowListContentPath = "ShowListScroll/Viewport/Content"

function SeasonAttackCityRankContent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function SeasonAttackCityRankContent:OnDestroy()
  self:ClearScroll()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function SeasonAttackCityRankContent:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ActivityAttackCityRankDataUpdate, self.RefreshView)
end

function SeasonAttackCityRankContent:OnRemoveListener()
  self:RemoveUIListener(EventId.ActivityAttackCityRankDataUpdate, self.RefreshView)
  base.OnRemoveListener(self)
end

local function OnGetItemByIndex(self, loopScroll, index)
  index = index + 1
  if index < 1 or index > #self.showDataList then
    return nil
  end
  local ShowInfo = self.showDataList[index]
  local item = loopScroll:NewListViewItem("AttackCityRankItem")
  local script = self.showListContent:GetComponent(item.gameObject.name, UIItem)
  if script == nil then
    local objectName = tostring(self.itemIndex)
    self.itemIndex = self.itemIndex + 1
    item.gameObject.name = objectName
    if not item.IsInitHandlerCalled then
      item.IsInitHandlerCalled = true
    end
    script = self.showListContent:AddComponent(UIItem, objectName)
  end
  script:SetActive(true)
  script:SetItemShow(0, ShowInfo)
  return item
end

function SeasonAttackCityRankContent:ComponentDefine()
  self.name_des = self:AddComponent(UIText, name_des_path)
  self.power_des = self:AddComponent(UIText, power_des_path)
  self.rank_des = self:AddComponent(UIText, rank_des_path)
  self.country_des = self:AddComponent(UIText, country_des_path)
  self.name_des:SetLocalText(390288)
  self.power_des:SetLocalText(456533)
  self.rank_des:SetLocalText(456531)
  self.country_des:SetLocalText(455083)
  self.country_des:SetActive(not LuaEntry.Player:IsFromBIGCHINAorUsingLangZH())
  self.self_data = self:AddComponent(UIItem, self_data_path)
  self.showList = self:AddComponent(UILoopListView2, ShowListPath)
  self.showList:InitListView(0, function(loopView, index)
    return OnGetItemByIndex(self, loopView, index)
  end)
  self.showListContent = self:AddComponent(UIBaseContainer, ShowListContentPath)
end

function SeasonAttackCityRankContent:ComponentDestroy()
  self.name_des = nil
  self.power_des = nil
  self.rank_des = nil
  self.self_data = nil
  self.showList = nil
  self.showListContent = nil
end

function SeasonAttackCityRankContent:DataDefine()
  self.itemIndex = 0
end

function SeasonAttackCityRankContent:DataDestroy()
end

function SeasonAttackCityRankContent:SetData(activityId)
  self.activityId = activityId
  if self.activityId == nil then
    return
  end
  local cityWarInfo = DataCenter.WorldAllianceCityDataManager.theCityWarInfo
  if cityWarInfo == nil then
    return
  end
  local fightStartTime = cityWarInfo.fightStartTime
  local fightEndTime = cityWarInfo.fightEndTime
  self.showData = DataCenter.ActivityAttackCityDataManager:GetRankData(self.activityId)
  local isNeedSend = false
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.showData == nil then
    isNeedSend = true
  elseif fightEndTime + self.showData.refreshTime * 60 > self.showData.getTime and fightStartTime - self.showData.refreshTime * 60 < self.showData.getTime and curTime > self.showData.getTime + self.showData.refreshTime then
    isNeedSend = true
  end
  if isNeedSend then
    SFSNetwork.SendMessage(MsgDefines.GetCityWarRank, self.activityId, -1)
  end
  self:RefreshView()
end

function SeasonAttackCityRankContent:RefreshView()
  if self.activityId == nil then
    return
  end
  self.showData = DataCenter.ActivityAttackCityDataManager:GetRankData(self.activityId)
  self.showDataList = {}
  if self.showData ~= nil then
    self.showDataList = self.showData.data
  end
  local selfRankData
  local allianceuid = LuaEntry.Player.allianceId
  if allianceuid == "" then
    selfRankData = nil
    self.self_data:SetActive(false)
  else
    selfRankData = nil
    for i = 1, #self.showDataList do
      if self.showDataList[i].aid == allianceuid then
        selfRankData = self.showDataList[i]
        break
      end
    end
    if selfRankData == nil then
      local oneData = {
        type = RankingTypeServer.DEFAULT,
        isAlliance = false,
        uid = "",
        alName = "",
        secondName = "",
        rank = -1,
        power = "",
        allianceName = "",
        alIcon = "",
        score = "0",
        alAbbr = "",
        leaderName = ""
      }
      local Player = LuaEntry.Player
      local allianceData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
      local nationTemplate = allianceData:GetCountryFlagTemplate()
      oneData.alCountry = nationTemplate.nation
      oneData.isAlliance = true
      oneData.serverId = LuaEntry.Player.serverId
      if Player:IsInAlliance() and allianceData ~= nil then
        oneData.rank = -1
        oneData.alIcon = allianceData.icon
        oneData.aid = Player.allianceId
        oneData.alName = allianceData.allianceName
        oneData.alAbbr = allianceData.abbr
        oneData.leaderName = allianceData.leaderName
        oneData.score = "0"
      end
      selfRankData = oneData
    end
    self.self_data:SetActive(true)
    self.self_data:SetItemShow(0, selfRankData, true)
  end
  if #self.showDataList == 0 then
    self.showList:SetActive(false)
  else
    self.showList:SetActive(true)
    self.showList:SetListItemCount(#self.showDataList, false, false)
    self.showList:RefreshAllShownItem()
  end
end

function SeasonAttackCityRankContent:ClearScroll()
  self.showListContent:RemoveComponents(UIItem)
  self.showList:ClearAllItems()
end

return SeasonAttackCityRankContent
