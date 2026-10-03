local base = UIBaseContainer
local UIActSnowStormWorldInfoArea = BaseClass("UIActSnowStormWorldInfoArea", base)
local SnowStormWorldInfoPlayerInfoGroup = require("UI.LWSeason.LWSeasonSnowStormWorldInfo.Component.SnowStormWorldInfoPlayerInfoGroup")
local Localization = CS.GameEntry.Localization
local SnowStormWorldAllianceMember = require("UI.LWSeason.LWSeasonSnowStormWorldInfo.Component.SnowStormWorldAllianceMember")
local bgRoot_path = "bg"
local groupParent_path = "playerBaseInfo/groupParent"
local selectBg_path = "bg/selectBg"
local playerBase_path = "playerBaseInfo"
local alliancePlayer_path = "playerInfo"
local allianceMemberList_path = "allianceMemberList"
local ScrollView_path = "allianceMemberList/memberList"
local content_path = "allianceMemberList/memberList/Viewport/Content"
local titles_path = "titles"
local temperatureTips_path = "titles/temperatureTip"
local playerGroup_path = {
  "playerBaseInfo/group1",
  "playerBaseInfo/group2",
  "playerBaseInfo/group3",
  "playerBaseInfo/group4"
}
local temperatureGroup_path = {
  "bg/temperature/temperature2",
  "bg/temperature/temperature3",
  "bg/temperature/temperature4"
}
local playerCountGroup_path = {
  "playerBaseInfo/groupParent/firstGroup",
  "playerBaseInfo/groupParent/secondGroup",
  "playerBaseInfo/groupParent/thirdGroup",
  "playerBaseInfo/groupParent/fourthGroup"
}
local countTextGroup_path = {
  "playerBaseInfo/countGroup/countGroup1/count1",
  "playerBaseInfo/countGroup/countGroup2/count2",
  "playerBaseInfo/countGroup/countGroup3/count3",
  "playerBaseInfo/countGroup/countGroup4/count4"
}
local selectParent_path = {
  "playerBaseInfo/selectBgParent1",
  "playerBaseInfo/selectBgParent2",
  "playerBaseInfo/selectBgParent3",
  "playerBaseInfo/selectBgParent4"
}
local playerInfoGroupInfo_path = {
  "playerInfo/playerInfoGroup1",
  "playerInfo/playerInfoGroup2",
  "playerInfo/playerInfoGroup3",
  "playerInfo/playerInfoGroup4"
}
local countTextGroup1_path = {
  "playerBaseInfo/countGroup/countGroup1/countdes1",
  "playerBaseInfo/countGroup/countGroup2/countdes2",
  "playerBaseInfo/countGroup/countGroup3/countdes3",
  "playerBaseInfo/countGroup/countGroup4/countdes4"
}
local subTitles_path = {
  "titles/subTitle1",
  "titles/subTitle2",
  "titles/subTitle3"
}
local temperatures = {
  [1] = "20\194\176C",
  [2] = "0\194\176C",
  [3] = "-20\194\176C"
}

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.bgRoot = self:AddComponent(UIBaseContainer, bgRoot_path)
  self.groupParent = self:AddComponent(UIBaseContainer, groupParent_path)
  self.selectBg = self:AddComponent(UIBaseContainer, selectBg_path)
  self.playerBase = self:AddComponent(UIBaseContainer, playerBase_path)
  self.alliancePlayer = self:AddComponent(UIBaseContainer, alliancePlayer_path)
  self.allianceMemberList = self:AddComponent(UIBaseContainer, allianceMemberList_path)
  self.ScrollView = self:AddComponent(UIScrollView, ScrollView_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.titles = self:AddComponent(UIBaseContainer, titles_path)
  self.temperatureTips = self:AddComponent(UIText, temperatureTips_path)
  self.playerGroup = {
    self:AddComponent(UIBaseContainer, playerGroup_path[1]),
    self:AddComponent(UIBaseContainer, playerGroup_path[2]),
    self:AddComponent(UIBaseContainer, playerGroup_path[3]),
    self:AddComponent(UIBaseContainer, playerGroup_path[4])
  }
  self.temperatureGroup = {
    self:AddComponent(UIText, temperatureGroup_path[1]),
    self:AddComponent(UIText, temperatureGroup_path[2]),
    self:AddComponent(UIText, temperatureGroup_path[3])
  }
  self.playerCountGroup = {
    self:AddComponent(UIBaseContainer, playerCountGroup_path[1]),
    self:AddComponent(UIBaseContainer, playerCountGroup_path[2]),
    self:AddComponent(UIBaseContainer, playerCountGroup_path[3]),
    self:AddComponent(UIBaseContainer, playerCountGroup_path[4])
  }
  self.countTextGroup = {
    self:AddComponent(UIText, countTextGroup_path[1]),
    self:AddComponent(UIText, countTextGroup_path[2]),
    self:AddComponent(UIText, countTextGroup_path[3]),
    self:AddComponent(UIText, countTextGroup_path[4])
  }
  self.selectParent = {
    self:AddComponent(UIBaseContainer, selectParent_path[1]),
    self:AddComponent(UIBaseContainer, selectParent_path[2]),
    self:AddComponent(UIBaseContainer, selectParent_path[3]),
    self:AddComponent(UIBaseContainer, selectParent_path[4])
  }
  self.playerInfoGroupInfo = {
    self:AddComponent(SnowStormWorldInfoPlayerInfoGroup, playerInfoGroupInfo_path[1]),
    self:AddComponent(SnowStormWorldInfoPlayerInfoGroup, playerInfoGroupInfo_path[2]),
    self:AddComponent(SnowStormWorldInfoPlayerInfoGroup, playerInfoGroupInfo_path[3]),
    self:AddComponent(SnowStormWorldInfoPlayerInfoGroup, playerInfoGroupInfo_path[4])
  }
  self.countTextGroup1 = {
    self:AddComponent(UIText, countTextGroup1_path[1]),
    self:AddComponent(UIText, countTextGroup1_path[2]),
    self:AddComponent(UIText, countTextGroup1_path[3]),
    self:AddComponent(UIText, countTextGroup1_path[4])
  }
  self.subTitles = {
    self:AddComponent(UIText, subTitles_path[1]),
    self:AddComponent(UIText, subTitles_path[2]),
    self:AddComponent(UIText, subTitles_path[3])
  }
  local count = #temperatures
  for index, value in ipairs(self.temperatureGroup) do
    if index <= count then
      value:SetText(temperatures[index])
    end
  end
  self.ScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnMemberItemMoveIn(itemObj, index)
  end)
  self.ScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnMemberItemMoveOut(itemObj, index)
  end)
end

local function ComponentDestroy(self)
  for index, value in ipairs(self.playerCountGroup) do
    value.transform:SetParent(self.groupParent.transform)
  end
  self.bgRoot:SetActive(false)
  self.allianceMemberList:SetActive(false)
  self.playerBase:SetActive(false)
  self.alliancePlayer:SetActive(false)
  self.bgRoot = nil
  self.groupParent = nil
  self.selectBg = nil
  self.playerBase = nil
  self.alliancePlayer = nil
  self.allianceMemberList = nil
  self.ScrollView = nil
  self.content = nil
  self.titles = nil
  self.temperatureTips = nil
  self.playerGroup = nil
  self.temperatureGroup = nil
  self.playerCountGroup = nil
  self.countTextGroup = nil
  self.selectParent = nil
  self.playerInfoGroupInfo = nil
  self.countTextGroup1 = nil
  self.subTitles = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self:ClearScroll()
  self.cellCache = nil
end

function UIActSnowStormWorldInfoArea:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonSnowStormActivityMainBuildTempUpdate, self.OnUpdateMainBuildTemp)
  self:AddUIListener(EventId.SeasonSnowStormActivityAllianceMemTempUpdate, self.OnUpdateAllianceMemberTemp)
end

function UIActSnowStormWorldInfoArea:OnRemoveListener()
  self:RemoveUIListener(EventId.SeasonSnowStormActivityAllianceMemTempUpdate, self.OnUpdateAllianceMemberTemp)
  self:RemoveUIListener(EventId.SeasonSnowStormActivityMainBuildTempUpdate, self.OnUpdateMainBuildTemp)
  base.OnRemoveListener(self)
end

function UIActSnowStormWorldInfoArea:Show(type)
  self.type = type
  if type == 1 then
    self.bgRoot:SetActive(true)
    self.allianceMemberList:SetActive(false)
    self.playerBase:SetActive(true)
    self.alliancePlayer:SetActive(false)
    self.titles:SetActive(true)
    self:RefreshMainBuildEvnTemp()
    SFSNetwork.SendMessage(MsgDefines.AllMainBuildEnvTmpInfo)
  elseif type == 2 then
    self.bgRoot:SetActive(true)
    self.allianceMemberList:SetActive(false)
    self.playerBase:SetActive(false)
    self.alliancePlayer:SetActive(true)
    self.titles:SetActive(true)
    self:RefreshAllianceMemeber()
    SFSNetwork.SendMessage(MsgDefines.AllianceMemberEnvTempInfo)
  elseif type == 3 then
    self.playerBase:SetActive(false)
    self.alliancePlayer:SetActive(false)
    self.bgRoot:SetActive(false)
    self.allianceMemberList:SetActive(true)
    self.titles:SetActive(false)
    SFSNetwork.SendMessage(MsgDefines.AllianceMemberEnvTempInfo)
    self:RefreshAllianceMemberAssistanceList()
  end
end

function UIActSnowStormWorldInfoArea:RefreshMainBuildEvnTemp()
  local countGroup = DataCenter.SeasonSnowStormDataManager:GetAllMainBuildingTempData()
  local percent = DataCenter.SeasonSnowStormDataManager.allMainBuildEnvTempPercent
  if percent then
    self.temperatureTips:SetText(Localization:GetString("season_s2_storm_event_30", string.format("%.2f", percent * 100)))
  else
    self.temperatureTips:SetText("")
  end
  self.subTitles[1]:SetLocalText("season_s2_storm_event_27")
  self.subTitles[2]:SetLocalText("season_s2_storm_event_28")
  self.subTitles[3]:SetLocalText("season_s2_storm_event_29")
  local total = 0
  for index, value in ipairs(self.countTextGroup) do
    local count = countGroup[index].value
    total = total + count
    self.countTextGroup1[index]:SetText("")
    if count == 0 then
      self.countTextGroup1[index].transform:Set_localPosition(self.countTextGroup1[index].transform:Get_localPosition(), 7, 0)
    else
      self.countTextGroup1[index].transform:Set_localPosition(self.countTextGroup1[index].transform:Get_localPosition(), -33, 0)
    end
  end
  for index, value in ipairs(self.countTextGroup) do
    local count = countGroup[index].value
    local percent = 0
    if total ~= 0 then
      percent = count / total
    end
    percent = percent * 100
    value:SetText(string.format("%.2f", percent) .. "%")
  end
  table.sort(countGroup, function(a, b)
    return a.value > b.value
  end)
  for index, value in ipairs(countGroup) do
    if value.value ~= 0 then
      local groupTrans = self.playerCountGroup[index]
      local parent = self.playerGroup[value.index]
      groupTrans.transform:SetParent(parent.transform)
      groupTrans:SetAnchoredPositionXY(0, 0)
    end
  end
  local selfIndex = DataCenter.SeasonSnowStormDataManager:GetSelfTemperatureArea()
  if 0 < selfIndex then
    self.selectBg:SetActive(true)
    self.selectBg.transform:SetParent(self.selectParent[selfIndex].transform)
    self.selectBg:SetAnchoredPositionXY(-31, 0)
    self.selectBg.transform:SetParent(self.bgRoot.transform)
    self.selectBg.transform:SetAsFirstSibling()
  else
    self.selectBg:SetActive(false)
  end
end

function UIActSnowStormWorldInfoArea:RefreshAllianceMemeber()
  local listData, less, total = DataCenter.SeasonSnowStormDataManager:GetAllianceMemberTempData()
  self.temperatureTips:SetText(Localization:GetString("season_s2_storm_event_31", less))
  for index, value in ipairs(self.playerInfoGroupInfo) do
    value:SetData(listData[index])
  end
  local selfIndex = DataCenter.SeasonSnowStormDataManager:GetSelfTemperatureArea()
  if 0 < selfIndex then
    self.selectBg:SetActive(true)
    self.selectBg.transform:SetParent(self.selectParent[selfIndex].transform)
    self.selectBg:SetAnchoredPositionXY(-31, 0)
    self.selectBg.transform:SetParent(self.bgRoot.transform)
    self.selectBg.transform:SetAsFirstSibling()
  else
    self.selectBg:SetActive(false)
  end
end

function UIActSnowStormWorldInfoArea:OnUpdateMainBuildTemp()
  if self.type == 1 then
    self:RefreshMainBuildEvnTemp()
  end
end

function UIActSnowStormWorldInfoArea:OnUpdateAllianceMemberTemp()
  if self.type == 2 then
    self:RefreshAllianceMemeber()
  elseif self.type == 3 then
    self:RefreshAllianceMemberAssistanceList()
  end
end

function UIActSnowStormWorldInfoArea:OnMemberItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.ScrollView:AddComponent(SnowStormWorldAllianceMember, itemObj)
  if cellItem ~= nil then
    cellItem:SetData(self.rankList[index])
    self.cellCache[index] = cellItem
  end
end

function UIActSnowStormWorldInfoArea:OnMemberItemMoveOut(itemObj, index)
  self.ScrollView:RemoveComponent(itemObj.name, SnowStormWorldAllianceMember)
  self.cellCache[index] = nil
end

function UIActSnowStormWorldInfoArea:ClearScroll()
  self.ScrollView:ClearCells()
  self.ScrollView:RemoveComponents(SnowStormWorldAllianceMember)
  self.cellCache = {}
end

function UIActSnowStormWorldInfoArea:RefreshAllianceMemberAssistanceList()
  self:ClearScroll()
  self.rankList = DataCenter.SeasonSnowStormDataManager:GetAllianceMemberAssistanceList()
  if self.rankList and #self.rankList > 0 then
    self.ScrollView:SetTotalCount(#self.rankList)
    self.ScrollView:RefillCells()
  end
end

UIActSnowStormWorldInfoArea.OnCreate = OnCreate
UIActSnowStormWorldInfoArea.OnDestroy = OnDestroy
UIActSnowStormWorldInfoArea.OnEnable = OnEnable
UIActSnowStormWorldInfoArea.OnDisable = OnDisable
UIActSnowStormWorldInfoArea.ComponentDefine = ComponentDefine
UIActSnowStormWorldInfoArea.ComponentDestroy = ComponentDestroy
UIActSnowStormWorldInfoArea.DataDefine = DataDefine
UIActSnowStormWorldInfoArea.DataDestroy = DataDestroy
return UIActSnowStormWorldInfoArea
