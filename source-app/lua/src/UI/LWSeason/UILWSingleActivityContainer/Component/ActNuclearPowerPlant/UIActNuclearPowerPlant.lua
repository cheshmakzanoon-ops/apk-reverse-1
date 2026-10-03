local base = UIBaseContainer
local UIActNuclearPowerPlant = BaseClass("UIActNuclearPowerPlant", base)
local Localization = CS.GameEntry.Localization
local UIActNuclearServerItem = require("UI.LWSeason.UILWSingleActivityContainer.Component.ActNuclearPowerPlant.UIActNuclearServerItem")
local UIActNuclearMonsterItem = require("UI.LWSeason.UILWSingleActivityContainer.Component.ActNuclearPowerPlant.UIActNuclearMonsterItem")
local UIActNuclearServerInfo = require("UI.LWSeason.UILWSingleActivityContainer.Component.ActNuclearPowerPlant.UIActNuclearServerInfo")
local title_path = "content/title"
local infoBtn_path = "content/root/DesBtn"
local serverListPrefab_path = "content/root/normal/serverList/serverItem"
local serverItemParent_path = "content/root/normal/serverList/Scroll View/Viewport/Content"
local root_path = "content/root/normal"
local serverTab_path = "content/root/normal/Tab/TabItem1"
local monsterTab_path = "content/root/normal/Tab/TabItem2"
local serverList_path = "content/root/normal/serverList"
local monsterList_path = "content/root/normal/monsterList"
local rewardBtn_path = "content/root/normal/rightTop/RewardBtn/RewardBtn"
local rankBtn_path = "content/root/normal/rightTop/RankBtn/rightTopRankBtn"
local gotoBtn_path = "content/root/normal/gotoBtn"
local bottomTip_path = "content/root/tip"
local serverListEmpty_path = "content/root/normal/serverList/serverListEmpty"
local endTimedes_path = "content/root/normal/endTimeDes"
local serverInfoCom_path = "content/root/normal/serverInfo"
local monsterScrollView_path = "content/root/normal/monsterList/monsterScroll"
local tab1Text1_path = "content/root/normal/Tab/TabItem1/Condition1Dark"
local tab1Text2_path = "content/root/normal/Tab/TabItem1/Condition1Select/Condition1"
local rewardRedPoint_path = "content/root/normal/rightTop/RewardBtn/RewardRedPoint"
local SERVER_COUNT = 8

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
  self.needUpdate = false
end

local function OnDisable(self)
  base.OnDisable(self)
  self.needUpdate = false
end

local function ComponentDefine(self)
  self.title = self:AddComponent(UIText, title_path)
  self.infoBtn = self:AddComponent(UIButton, infoBtn_path)
  self.serverListPrefab = self:AddComponent(UIBaseContainer, serverListPrefab_path)
  self.serverItemParent = self:AddComponent(UIBaseContainer, serverItemParent_path)
  self.root = self:AddComponent(UIBaseContainer, root_path)
  self.serverTab = self:AddComponent(UIToggle, serverTab_path)
  self.monsterTab = self:AddComponent(UIToggle, monsterTab_path)
  self.serverList = self:AddComponent(UIBaseContainer, serverList_path)
  self.monsterList = self:AddComponent(UIBaseContainer, monsterList_path)
  self.rewardBtn = self:AddComponent(UIButton, rewardBtn_path)
  self.rankBtn = self:AddComponent(UIButton, rankBtn_path)
  self.gotoBtn = self:AddComponent(UIButton, gotoBtn_path)
  self.bottomTip = self:AddComponent(UIText, bottomTip_path)
  self.serverListEmpty = self:AddComponent(UIBaseContainer, serverListEmpty_path)
  self.endTimedes = self:AddComponent(UIText, endTimedes_path)
  self.serverInfoCom = self:AddComponent(UIActNuclearServerInfo, serverInfoCom_path)
  self.monsterScrollView = self:AddComponent(UIScrollView, monsterScrollView_path)
  self.tab1Text1 = self:AddComponent(UIText, tab1Text1_path)
  self.tab1Text2 = self:AddComponent(UIText, tab1Text2_path)
  self.rewardRedPoint = self:AddComponent(UIBaseContainer, rewardRedPoint_path)
  self.monsterScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnMonsterItemMoveIn(itemObj, index)
  end)
  self.monsterScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnMonsterItemMoveOut(itemObj, index)
  end)
  self.serverTab:SetOnValueChanged(function(tf)
    if tf then
      self:OnTabChanged(1)
    end
  end)
  self.monsterTab:SetOnValueChanged(function(tf)
    if tf then
      self:OnTabChanged(2)
    end
  end)
  self.serverListPrefab:SetActive(false)
  self.infoBtn:SetSafeClickMode(true)
  self.infoBtn:SetOnClick(function()
    self:InfoBtnClick()
  end)
  self.rewardBtn:SetSafeClickMode(true)
  self.rewardBtn:SetOnClick(function()
    self:RewardBtnClick()
  end)
  self.rankBtn:SetSafeClickMode(true)
  self.rankBtn:SetOnClick(function()
    self:RankBtnClick()
  end)
  self.gotoBtn:SetSafeClickMode(true)
  self.gotoBtn:SetOnClick(function()
    self:GotoBtn()
  end)
  self.serverListEmpty:SetActive(false)
end

local function ComponentDestroy(self)
  self:ClearScroll()
  self.title = nil
  self.infoBtn = nil
  self.serverListPrefab = nil
  self.serverItemParent = nil
  self.root = nil
  self.serverTab = nil
  self.monsterTab = nil
  self.serverList = nil
  self.monsterList = nil
  self.rewardBtn = nil
  self.rankBtn = nil
  self.gotoBtn = nil
  self.bottomTip = nil
  self.serverListEmpty = nil
  self.endTimedes = nil
  self.serverInfoCom = nil
  self.monsterScrollView = nil
  self.tab1Text1 = nil
  self.tab1Text2 = nil
  self.rewardRedPoint = nil
end

local function DataDefine(self)
  self.serverItem = self.serverListPrefab.gameObject
  self.serverItem:GameObjectCreatePool()
  self.serverItemCom = {}
  for index = 1, SERVER_COUNT do
    local goItem = self.serverItem:GameObjectSpawn(self.serverItemParent.transform)
    goItem.name = "serverItem" .. index
    local com = self.serverItemParent:AddComponent(UIActNuclearServerItem, goItem.name)
    com:SetActive(true)
    table.insert(self.serverItemCom, com)
  end
end

local function DataDestroy(self)
  self.serverTab:SetIsOn(false)
  self.monsterTab:SetIsOn(false)
  self.serverItemParent:RemoveComponents(UIActNuclearServerItem)
  self.serverItem:GameObjectRecycleAll()
  self.serverItemCom = nil
  self.activityId = nil
  self.activityInfo = nil
  self.buildStartTime = nil
  self.serverTemperature = nil
  self.maxValue = nil
  self.finish = true
end

function UIActNuclearPowerPlant:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ActNuclearBuildStartTimeUpdate, self.BuildStartTimeUpdateCal)
  self:AddUIListener(EventId.ActNuclearServerRankUpdate, self.ServerRankUpdate)
  self:AddUIListener(EventId.ActNuclearMonsterListUpdate, self.MonsterListUpdate)
  self:AddUIListener(EventId.ActNuclearRankReweardUpdate, self.OpenRewardPanel)
  self:AddUIListener(EventId.ActNuclearScoreUpdate, self.ServerRankUpdate)
  self:AddUIListener(EventId.ActNuclearTaskRedStateChange, self.RefreshRedPoint)
end

function UIActNuclearPowerPlant:OnRemoveListener()
  self:RemoveUIListener(EventId.ActNuclearBuildStartTimeUpdate, self.BuildStartTimeUpdateCal)
  self:RemoveUIListener(EventId.ActNuclearServerRankUpdate, self.ServerRankUpdate)
  self:RemoveUIListener(EventId.ActNuclearMonsterListUpdate, self.MonsterListUpdate)
  self:RemoveUIListener(EventId.ActNuclearRankReweardUpdate, self.OpenRewardPanel)
  self:RemoveUIListener(EventId.ActNuclearScoreUpdate, self.ServerRankUpdate)
  self:RemoveUIListener(EventId.ActNuclearTaskRedStateChange, self.RefreshRedPoint)
  base.OnRemoveListener(self)
end

function UIActNuclearPowerPlant:SetData(activityId)
  self.activityId = tonumber(activityId)
  if not self.activityId then
    return
  end
  self.activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  self.settleTime = self.activityInfo.settleTime or self.activityInfo.settleTime or 0
  self.endTime = self.activityInfo.endTime
  self.version = DataCenter.SeasonNuclearPowerPlantDataManager:ActivityVersion()
  self.needUpdate = false
  local now = UITimeManager:GetInstance():GetServerTime()
  local countdown = self.settleTime - now
  local countdownStr = ""
  if 0 < countdown then
    countdownStr = Localization:GetString("season_reward_ui_007") .. UITimeManager:GetInstance():MilliSecondToFmtString(countdown)
    self.needUpdate = true
  else
    countdown = self.endTime - now
    if 0 < countdown then
      countdownStr = Localization:GetString("2010114") .. ":" .. UITimeManager:GetInstance():MilliSecondToFmtString(countdown)
      self.needUpdate = true
    end
  end
  self.endTimedes:SetText(countdownStr)
  self.title:SetText(Localization:GetString(self.activityInfo.name))
  self.maxValue = DataCenter.SeasonNuclearPowerPlantDataManager:GetScoreMax()
  local t = string.split(self.activityInfo.para_3, "|")
  self.serverTemperature = {}
  if t and #t == SERVER_COUNT then
    for index = 1, SERVER_COUNT do
      self.serverTemperature[index] = toInt(t[index])
    end
  else
    for index = 1, SERVER_COUNT do
      self.serverTemperature[index] = 0
    end
    local c = #t
    Logger.LogError("UIActNuclearPowerPlant Temperature quantity configuration error: " .. tostring(c))
  end
  self.curIndex = 0
  self.buildStartTime = DataCenter.SeasonNuclearPowerPlantDataManager:GetBuildStartTime(self.activityId)
  local now = UITimeManager:GetInstance():GetServerTime()
  self.serverInfoCom:SetActive(false)
  if self.version == 0 then
    local atHome = LuaEntry.Player:AtHomeNow()
    if 0 < self.buildStartTime and now > self.buildStartTime and atHome then
      self.root:SetActive(true)
      self.serverTab:SetIsOn(true)
      SFSNetwork.SendMessage(MsgDefines.NuclearRankView, toInt(self.activityId), 1)
      SFSNetwork.SendMessage(MsgDefines.ViewBehemothBossList)
      self.bottomTip:SetLocalText("season_s2_activity_1000047_description_04")
    else
      self.root:SetActive(false)
      self.bottomTip:SetLocalText("season_s2_activity_1000047_description_26")
    end
    self.tab1Text1:SetLocalText("season_s2_activity_1000047_description_02")
    self.tab1Text2:SetLocalText("season_s2_activity_1000047_description_02")
  elseif self.version == 1 then
    self.tab1Text1:SetLocalText("season_s2_activity_1000047_description_40")
    self.tab1Text2:SetLocalText("season_s2_activity_1000047_description_40")
    if 0 < self.buildStartTime and now > self.buildStartTime then
      self.root:SetActive(true)
      self.serverTab:SetIsOn(true)
      SFSNetwork.SendMessage(MsgDefines.NuclearServerScoreView, DataCenter.SeasonNuclearPowerPlantDataManager:GetActivityLegalServerId())
      SFSNetwork.SendMessage(MsgDefines.ViewBehemothBossList)
      self.bottomTip:SetLocalText("season_s2_activity_1000047_description_04")
    else
      self.root:SetActive(false)
      self.bottomTip:SetLocalText("season_s2_activity_1000047_description_26")
    end
  else
    self.tab1Text1:SetLocalText("season_s2_activity_1000047_description_02")
    self.tab1Text2:SetLocalText("season_s2_activity_1000047_description_02")
    self.root:SetActive(false)
    self.bottomTip:SetLocalText("season_s2_activity_1000047_description_26")
  end
  self:InitRedPoint()
  self:RefreshRedPoint()
end

function UIActNuclearPowerPlant:RefreshServerList()
  local serverRank = DataCenter.SeasonNuclearPowerPlantDataManager:GetServerRankData()
  self.serverListEmpty:SetActive(#serverRank == 0)
  for index = 1, SERVER_COUNT do
    local com = self.serverItemCom[index]
    local data = serverRank[index]
    if data then
      com:SetActive(true)
      com:SetData(data, self.maxValue, self.serverTemperature[index])
    else
      com:SetActive(false)
    end
  end
end

function UIActNuclearPowerPlant:RefreshMonsterList()
  local data = DataCenter.SeasonNuclearPowerPlantDataManager:GetMonsterList()
  self.monsterListData = data
  self:ClearScroll()
  local count = #self.monsterListData
  if 0 < count then
    self.monsterScrollView:SetTotalCount(count)
    self.monsterScrollView:RefillCells()
  end
end

function UIActNuclearPowerPlant:InfoBtnClick()
  if self.activityInfo ~= nil and self.activityInfo.story ~= nil then
    local param = {}
    param.activityId = self.activityId
    param.activityRulesStr = Localization:GetString(self.activityInfo.story)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
  end
end

function UIActNuclearPowerPlant:OnTabChanged(index)
  self.curIndex = index
  if index == 1 then
    self:ClearScroll()
    if self.version == 0 then
      self.serverList:SetActive(true)
      self:RefreshServerList()
    elseif self.version == 1 then
      self.serverList:SetActive(false)
      self.serverInfoCom:SetActive(true)
      self.serverInfoCom:SetData(DataCenter.SeasonNuclearPowerPlantDataManager:GetServerRankDataCache())
    end
  elseif index == 2 then
    self:RefreshMonsterList()
    if self.version == 0 then
      self.serverList:SetActive(false)
    elseif self.version == 1 then
      self.serverInfoCom:SetActive(false)
    end
  end
end

function UIActNuclearPowerPlant:BuildStartTimeUpdateCal()
  self.buildStartTime = DataCenter.SeasonNuclearPowerPlantDataManager:GetBuildStartTime(self.activityId)
  local now = UITimeManager:GetInstance():GetServerTime()
  if self.buildStartTime > 0 and now > self.buildStartTime then
    self.root:SetActive(true)
  end
  if self.curIndex == 1 then
    if self.version == 0 then
      self.serverList:SetActive(true)
      self:RefreshServerList()
    elseif self.version == 1 then
      self.serverList:SetActive(false)
      self.serverInfoCom:SetActive(true)
      self.serverInfoCom:SetData(DataCenter.SeasonNuclearPowerPlantDataManager:GetServerRankDataCache())
    end
  elseif self.curIndex == 2 then
    self:RefreshMonsterList()
  else
    self.serverTab:SetIsOn(true)
    SFSNetwork.SendMessage(MsgDefines.NuclearRankView, toInt(self.activityId), 1)
    SFSNetwork.SendMessage(MsgDefines.ViewBehemothBossList)
  end
end

function UIActNuclearPowerPlant:ServerRankUpdate()
  self.buildStartTime = DataCenter.SeasonNuclearPowerPlantDataManager:GetBuildStartTime(self.activityId)
  local now = UITimeManager:GetInstance():GetServerTime()
  if self.buildStartTime > 0 and now > self.buildStartTime then
    self.root:SetActive(true)
  end
  if self.curIndex == 1 then
    if self.version == 0 then
      self.serverList:SetActive(true)
      self:RefreshServerList()
    elseif self.version == 1 then
      self.serverList:SetActive(false)
      self.serverInfoCom:SetActive(true)
      self.serverInfoCom:SetData(DataCenter.SeasonNuclearPowerPlantDataManager:GetServerRankDataCache())
    end
  end
end

function UIActNuclearPowerPlant:MonsterListUpdate()
  if self.curIndex == 2 then
    self:RefreshMonsterList()
  end
end

function UIActNuclearPowerPlant:RewardBtnClick()
  if self.version == 0 then
    local reward = DataCenter.SeasonNuclearPowerPlantDataManager:GetRankRewardInfo(NuclearPowerRankType.buildingZone)
    if reward and 0 < #reward then
      UIManager:GetInstance():OpenWindow(UIWindowNames.LWUICommonRankReward, {anim = true}, reward)
    else
      SFSNetwork.SendMessage(MsgDefines.NuclearRankRewardView, toInt(self.activityId), NuclearPowerRankType.buildingZone)
    end
  elseif self.version == 1 then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActSnowStormReward, {anim = true}, UIActSnowStormRewardPanelType.NuclearBuilding)
  end
end

function UIActNuclearPowerPlant:OpenRewardPanel()
  local reward = DataCenter.SeasonNuclearPowerPlantDataManager:GetRankRewardInfo(NuclearPowerRankType.buildingZone)
  if reward and 0 < #reward then
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWUICommonRankReward, {anim = true}, reward)
  end
end

function UIActNuclearPowerPlant:RankBtnClick()
  if self.activityInfo then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonTrendsRank, CommonRankPanelType.NuclearPlatRank, self.activityId)
  end
end

function UIActNuclearPowerPlant:GotoBtn()
  local serverId = DataCenter.SeasonNuclearPowerPlantDataManager:GetActivityLegalServerId()
  local kingCityId, kingCityPosIndex = SeasonUtil.GetKingCityId(serverId)
  GoToUtil.CloseAllWindows()
  GoToUtil.MoveToWorldPointAndOpen(kingCityPosIndex, nil, nil, serverId, 0)
end

function UIActNuclearPowerPlant:Update1000MS()
  if self.needUpdate then
    local now = UITimeManager:GetInstance():GetServerTime()
    local countdown = self.settleTime - now
    local countdownStr = ""
    if 0 < countdown then
      countdownStr = Localization:GetString("season_reward_ui_007") .. UITimeManager:GetInstance():MilliSecondToFmtString(countdown)
    else
      countdown = self.endTime - now
      if 0 < countdown then
        countdownStr = Localization:GetString("2010114") .. ":" .. UITimeManager:GetInstance():MilliSecondToFmtString(countdown)
      else
        self.needUpdate = false
        self.endTimedes:SetText("")
        return
      end
    end
    self.endTimedes:SetText(countdownStr)
  end
end

function UIActNuclearPowerPlant:OnMonsterItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.monsterScrollView:AddComponent(UIActNuclearMonsterItem, itemObj)
  if cellItem ~= nil then
    cellItem:SetData(self.monsterListData[index])
  end
end

function UIActNuclearPowerPlant:OnMonsterItemMoveOut(itemObj, index)
  self.monsterScrollView:RemoveComponent(itemObj.name, UIActNuclearMonsterItem)
end

function UIActNuclearPowerPlant:ClearScroll()
  self.monsterScrollView:ClearCells()
  self.monsterScrollView:RemoveComponents(UIActNuclearMonsterItem)
end

function UIActNuclearPowerPlant:InitRedPoint()
  if self.version == 1 then
    if CS.ClientSwitch.IsOn(CS.ClientSwitch.DISABLE_RED_POINT_TREE) then
      return
    end
    self:BindRedPointUI(self.rewardRedPoint, nil, {
      RedDef.Season,
      tostring(self.activityId)
    })
  end
end

function UIActNuclearPowerPlant:RefreshRedPoint()
  if self.version == 1 then
    if not CS.ClientSwitch.IsOn(CS.ClientSwitch.DISABLE_RED_POINT_TREE) then
      return
    end
    self.rewardRedPoint:SetActive(DataCenter.SeasonNuclearPowerPlantDataManager:GetActivityTaskRedState())
  else
    self.rewardRedPoint:SetActive(false)
  end
end

UIActNuclearPowerPlant.OnCreate = OnCreate
UIActNuclearPowerPlant.OnDestroy = OnDestroy
UIActNuclearPowerPlant.OnEnable = OnEnable
UIActNuclearPowerPlant.OnDisable = OnDisable
UIActNuclearPowerPlant.ComponentDefine = ComponentDefine
UIActNuclearPowerPlant.ComponentDestroy = ComponentDestroy
UIActNuclearPowerPlant.DataDefine = DataDefine
UIActNuclearPowerPlant.DataDestroy = DataDestroy
return UIActNuclearPowerPlant
