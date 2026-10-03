local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local SeasonGreenMain = BaseClass("SeasonGreenMain", base)
local Localization = CS.GameEntry.Localization
local AllianceCityItem = require("UI.LWSeason3.LWSeasonGreen.SeasonGreenMain.Component.GreenAllianceCityItem")
local SuppliesShareItem = require("UI.LWSeason3.LWSeasonGreen.SeasonGreenMain.Component.SuppliesShareItem")
local ToggleInfo = {
  [1] = {
    name = "season_oasis_UI_8",
    func = "RefreshServerProgress"
  },
  [2] = {
    name = "season_oasis_UI_9",
    func = "RefreshAllianceProgress"
  },
  [3] = {
    name = "season_oasis_UI_10",
    func = "RefreshTreasureList"
  }
}
local infoBtn_path = "Root/top/IntroBtn"
local imageBg_path = "mask/ImageBg"
local rankBtn_path = "Root/top/rankBtn"
local name_path = "Root/top/left/Txt_ActName"
local endTime_path = "Root/top/left/TimeContent/Txt_Times"
local detailInfo_path = "Root/top/left/detailInfo"
local noList_path = "Root/bot/Page/noList"
local Toggle_path = "Root/bot/Toggle"
local Page_path = "Root/bot/Page"
local SuppliesCountGroup_path = "Root/bot/SuppliesCountGroup"
local GreenRewardGroup_path = "Root/top/left/GreenRewardGroup"
local GreenAreaItem_path = "Root/bot/Page/Page1/GreenAreaItem"
local ScrollView2_path = "Root/bot/Page/Page2/ScrollView2"
local Content2_path = "Root/bot/Page/Page2/ScrollView2/Content2"
local ScrollView3_path = "Root/bot/Page/Page3/ScrollView3"
local Content3_path = "Root/bot/Page/Page3/ScrollView3/Content3"
local effect2_path = "mask/ImageBg/mask/Eff_ui_ forest"
local effect1_path = "mask/ImageBg/mask/Eff_ui_city"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ShowRewardGroup()
  self:RefreshSuppliesCount()
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
  self.infoBtn = self:AddComponent(UIButton, infoBtn_path)
  self.imageBg = self:AddComponent(UIRawImage, imageBg_path)
  self.rankBtn = self:AddComponent(UIButton, rankBtn_path)
  self.name = self:AddComponent(UIText, name_path)
  self.endTime = self:AddComponent(UIText, endTime_path)
  self.detailInfo = self:AddComponent(UIText, detailInfo_path)
  self.noList = self:AddComponent(UIText, noList_path)
  self.Toggle = self:AddComponent(UIBaseContainer, Toggle_path)
  self.Page = self:AddComponent(UIBaseContainer, Page_path)
  self.SuppliesCountGroup = self:AddComponent(UIBaseContainer, SuppliesCountGroup_path)
  self.GreenRewardGroup = self:AddComponent(UIBaseContainer, GreenRewardGroup_path)
  self.GreenAreaItem = self:AddComponent(UIBaseContainer, GreenAreaItem_path)
  self.ScrollView2 = self:AddComponent(UIScrollRect, ScrollView2_path)
  self.Content2 = self:AddComponent(GridInfinityScrollView, Content2_path)
  self.ScrollView3 = self:AddComponent(UIScrollRect, ScrollView3_path)
  self.Content3 = self:AddComponent(GridInfinityScrollView, Content3_path)
  self.effect2 = self:AddComponent(UIBaseContainer, effect2_path)
  self.effect1 = self:AddComponent(UIBaseContainer, effect1_path)
  self.infoBtn:SetOnClick(function()
    local param = {}
    param.activityId = self.activityId
    param.activityRulesStr = Localization:GetString(self.activityData.story)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
  end)
  self.rankBtn:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.SeasonGreenRankPanel, {anim = true})
  end)
  self.togglesTbN = {}
  for i, v in ipairs(ToggleInfo) do
    local toggle = self:AddComponent(UIButton, string.format("%s/Toggle%s", Toggle_path, i))
    toggle:SetOnClick(function()
      self:ChangeShowType(i)
    end)
    local newTog = {}
    newTog.toggleN = toggle
    newTog.chooseN = toggle:AddComponent(UIBaseContainer, "select")
    newTog.redN = toggle:AddComponent(UIBaseContainer, "RedPoint")
    newTog.redNumN = toggle:AddComponent(UIText, "RedPoint/RedNum")
    newTog.nameN = toggle:AddComponent(UIText, "activityName")
    newTog.nameNS = toggle:AddComponent(UIText, "select/activityNameS")
    newTog.showNewN = toggle:AddComponent(UIBaseContainer, "NewDot")
    newTog.showNewN:SetActive(false)
    newTog.ShowNewTxtN = toggle:AddComponent(UIText, "NewDot/Bg/Text")
    newTog.pageN = self:AddComponent(UIBaseContainer, string.format("%s/Page%s", Page_path, i))
    newTog.func = self[v.func]
    newTog.nameN:SetLocalText(v.name)
    newTog.nameNS:SetLocalText(v.name)
    self.togglesTbN[i] = newTog
  end
end

local function ComponentDestroy(self)
  self:ClearAllianceScroll()
  self:ClearTreasureScroll()
  self.togglesTbN = nil
  if self.greenAreaHandle then
    self.greenAreaHandle:Destroy()
    self.greenAreaHandle = nil
  end
  if self.suppliesCountHandle then
    self.suppliesCountHandle:Destroy()
    self.suppliesCountHandle = nil
  end
  if self.rewardGroupHandle then
    self.rewardGroupHandle:Destroy()
    self.rewardGroupHandle = nil
  end
  self.infoBtn = nil
  self.imageBg = nil
  self.rankBtn = nil
  self.name = nil
  self.endTime = nil
  self.detailInfo = nil
  self.noList = nil
  self.Toggle = nil
  self.Page = nil
  self.SuppliesCountGroup = nil
  self.GreenRewardGroup = nil
  self.GreenAreaItem = nil
  self.ScrollView2 = nil
  self.Content2 = nil
  self.ScrollView3 = nil
  self.Content3 = nil
  self.effect2 = nil
  self.effect1 = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function SeasonGreenMain:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonGreenCityAllianceInfo, self.RefreshViewWithEvent)
  self:AddUIListener(EventId.GetActivitySuppliesShareInfoEvent, self.RefreshViewWithEvent)
end

function SeasonGreenMain:OnRemoveListener()
  self:RemoveUIListener(EventId.SeasonGreenCityAllianceInfo, self.RefreshViewWithEvent)
  self:RemoveUIListener(EventId.GetActivitySuppliesShareInfoEvent, self.RefreshViewWithEvent)
  base.OnRemoveListener(self)
end

function SeasonGreenMain:SetData(activityId)
  base.SetData(self, activityId)
  local data = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if data == nil then
    return
  end
  self.activityData = data
  self.name:SetLocalText(data.name)
  self.StartTime = data.startTime
  if SeasonUtil.IsInSeasonPrepareMode() then
    self.EndTime = DataCenter.SeasonDataManager.nextSeasonStartTime
  else
    self.EndTime = data.endTime
  end
  self.curStage = DataCenter.SeasonGreenManager:GetStage()
  local mainCfg = DataCenter.SeasonGreenManager:GetMainCfg()
  if self.curStage == 2 and mainCfg then
    self.detailInfo:SetLocalText(mainCfg.second_desc)
    self.imageBg:LoadSprite(mainCfg.second_banner, string.format(LoadPath.UISeasonGreenTex, "mjc_S3_gjlz_banner1"))
    self.effect1:SetActive(false)
    self.effect2:SetActive(true)
  else
    self.detailInfo:SetLocalText(data.desc_info)
    if string.IsNullOrEmpty(data.activity_pic) then
      self.imageBg:LoadSprite(string.format(LoadPath.UISeasonGreenTex, "mjc_S3_gjlz_banner1"))
    else
      self.imageBg:LoadSprite(string.format(LoadPath.UISeasonGreenTex, data.activity_pic), string.format(LoadPath.UISeasonGreenTex, "mjc_S3_gjlz_banner1"))
    end
    self.effect1:SetActive(true)
    self.effect2:SetActive(false)
  end
  self:RefreshView()
  self:Update1000MS()
end

function SeasonGreenMain:RefreshView(isEvent)
  if not self.curStage or self.curStage <= 0 then
    return
  end
  self.isEvent = isEvent
  if self.curStage == 2 then
    self:RefreshSecondStage()
  else
    self:RefreshFirstStage()
  end
  self.isEvent = false
end

function SeasonGreenMain:RefreshViewWithEvent()
  self:RefreshView(true)
end

function SeasonGreenMain:Update1000MS()
  if self.activityData then
    UIUtil.SetLeftTimeText(self.endTime, self.StartTime, self.EndTime)
  end
end

function SeasonGreenMain:RefreshFirstStage()
  self.togglesTbN[1].toggleN:SetActive(false)
  self.tabIndex = Mathf.Clamp(self.tabIndex or 2, 2, 3)
  self:ChangeShowType(self.tabIndex)
end

function SeasonGreenMain:RefreshSecondStage()
  self.togglesTbN[1].toggleN:SetActive(true)
  self.tabIndex = Mathf.Clamp(self.tabIndex or 1, 1, 3)
  self:ChangeShowType(self.tabIndex)
end

function SeasonGreenMain:ChangeShowType(tabIndex)
  for i, v in ipairs(self.togglesTbN) do
    local sel = i == tabIndex
    v.chooseN:SetActive(sel)
    v.pageN:SetActive(sel)
    v.func(self, sel)
  end
  self.tabIndex = tabIndex
end

function SeasonGreenMain:RefreshServerProgress(sel)
  if not sel then
    return
  end
  self.noList:SetActive(false)
  if self.greenArea then
    self.greenArea:RefreshView()
  else
    if self.greenAreaHandle then
      return
    end
    local scriptPath = require("UI.LWSeason3.LWSeasonGreen.SeasonGreenMain.Component.GreenAreaItem")
    local prefabPath = "Assets/Main/SeasonRes/S3/Prefabs/UI/LWSeason3/SeasonActivity/SeasonGreen/Component/GreenAreaItem.prefab"
    self.greenAreaHandle = UIUtil.LoadPrefab(prefabPath, scriptPath, self.GreenAreaItem, "GreenAreaItem", function(item)
      self.greenArea = item
      self.greenArea:RefreshView()
    end)
  end
end

function SeasonGreenMain:RefreshAllianceProgress(sel)
  if not sel then
    return
  end
  self.noList:SetActive(false)
  if not LuaEntry.Player:IsInAlliance() then
    self.noList:SetLocalText("season_oasis_UI_38")
    self.noList:SetActive(true)
    self:ClearAllianceScroll()
    return
  end
  if not self.hasRequestAlliance then
    self.hasRequestAlliance = true
    SFSNetwork.SendMessage(MsgDefines.SeasonGreenCityAllianceInfo)
  end
  self.allianceList = DataCenter.SeasonGreenManager.allianceCityInfo
  local listCount = self.allianceList and #self.allianceList or 0
  if listCount <= 0 then
    self.noList:SetLocalText("season_oasis_UI_38")
    self.noList:SetActive(true)
    self:ClearAllianceScroll()
    return
  end
  if not self.allianceItemList then
    self.allianceItemList = {}
    local bindFunc1 = BindCallback(self, self.OnInitAllianceScroll)
    local bindFunc2 = BindCallback(self, self.OnUpdateAllianceScroll)
    local bindFunc3 = BindCallback(self, self.OnDestroyAllianceScrollItem)
    self.Content2:Init(bindFunc1, bindFunc2, bindFunc3)
  end
  self.Content2:SetItemCount(listCount)
end

function SeasonGreenMain:ClearAllianceScroll()
  if self.allianceItemList then
    self.allianceItemList = nil
    self.ScrollView2:RemoveComponents(AllianceCityItem)
    self.Content2:DestroyChildNode()
  end
end

function SeasonGreenMain:OnInitAllianceScroll(go, index)
  self.allianceItemList[go] = self.ScrollView2:AddComponent(AllianceCityItem, go)
end

function SeasonGreenMain:OnUpdateAllianceScroll(go, index)
  local data = self.allianceList[index + 1]
  if data then
    self.allianceItemList[go]:ReInit(index, data)
    self.allianceItemList[go]:SetActive(true)
  else
    self.allianceItemList[go]:SetActive(false)
  end
end

function SeasonGreenMain:OnDestroyAllianceScrollItem(go, index)
end

function SeasonGreenMain:RefreshTreasureList(sel)
  if not sel then
    return
  end
  self.noList:SetActive(false)
  local shareData = DataCenter.SeasonSuppliesShareDataManager:GetActivityInfo(not self.isEvent)
  self.treasureList = shareData and shareData.suppliesPointData
  local listCount = self.treasureList and #self.treasureList or 0
  if listCount <= 0 then
    self.noList:SetLocalText("map_surprise_s3_plot_2")
    self.noList:SetActive(true)
    self:ClearTreasureScroll()
    return
  end
  if not self.treasureItemList then
    self.treasureItemList = {}
    local bindFunc1 = BindCallback(self, self.OnInitTreasureScroll)
    local bindFunc2 = BindCallback(self, self.OnUpdateTreasureScroll)
    local bindFunc3 = BindCallback(self, self.OnDestroyTreasureScrollItem)
    self.Content3:Init(bindFunc1, bindFunc2, bindFunc3)
  end
  self.Content3:SetItemCount(listCount)
end

function SeasonGreenMain:RefreshSuppliesCount()
  if self.suppliesCountGroup then
    self.suppliesCountGroup:RefreshView()
  else
    if self.suppliesCountHandle then
      return
    end
    local scriptPath = require("UI.LWSeason3.LWSeasonGreen.SeasonGreenMain.Component.SuppliesCountGroup")
    local prefabPath = "Assets/Main/SeasonRes/S3/Prefabs/UI/LWSeason3/SeasonActivity/SeasonGreen/Component/SuppliesCountGroup.prefab"
    self.suppliesCountHandle = UIUtil.LoadPrefab(prefabPath, scriptPath, self.SuppliesCountGroup, "SuppliesCountGroup", function(item)
      self.suppliesCountGroup = item
      self.suppliesCountGroup:RefreshView()
    end)
  end
end

function SeasonGreenMain:ClearTreasureScroll()
  if self.treasureItemList then
    self.treasureItemList = nil
    self.ScrollView3:RemoveComponents(SuppliesShareItem)
    self.Content3:DestroyChildNode()
  end
end

function SeasonGreenMain:OnInitTreasureScroll(go, index)
  self.treasureItemList[go] = self.ScrollView3:AddComponent(SuppliesShareItem, go)
end

function SeasonGreenMain:OnUpdateTreasureScroll(go, index)
  local data = self.treasureList[index + 1]
  local item = self.treasureItemList[go]
  if data then
    item:ReInit(index, data)
    item:SetActive(true)
  else
    item:SetActive(false)
  end
end

function SeasonGreenMain:OnDestroyTreasureScrollItem(go, index)
end

function SeasonGreenMain:ShowRewardGroup()
  if self.rewardGroup then
    self.rewardGroup:RefreshView()
  else
    if self.rewardGroupHandle then
      return
    end
    local scriptPath = require("UI.LWSeason3.LWSeasonGreen.SeasonGreenMain.Component.GreenRewardGroup")
    local prefabPath = "Assets/Main/SeasonRes/S3/Prefabs/UI/LWSeason3/SeasonActivity/SeasonGreen/Component/GreenRewardGroup.prefab"
    self.rewardGroupHandle = UIUtil.LoadPrefab(prefabPath, scriptPath, self.GreenRewardGroup, "GreenRewardGroup", function(item)
      self.rewardGroup = item
      self.rewardGroup:RefreshView()
    end)
  end
end

SeasonGreenMain.OnCreate = OnCreate
SeasonGreenMain.OnDestroy = OnDestroy
SeasonGreenMain.OnEnable = OnEnable
SeasonGreenMain.OnDisable = OnDisable
SeasonGreenMain.ComponentDefine = ComponentDefine
SeasonGreenMain.ComponentDestroy = ComponentDestroy
SeasonGreenMain.DataDefine = DataDefine
SeasonGreenMain.DataDestroy = DataDestroy
return SeasonGreenMain
