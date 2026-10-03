local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local SeasonFarmerMain = BaseClass("SeasonFarmerMain", base)
local Localization = CS.GameEntry.Localization
local UIMainResourceProgress = require("UI.LWMainUI.Component.UIMainTop.UIMainResourceProgress")
local LWSeasonAllianceTipsItem = require("UI.LWSeason.LWSeasonAllianceRank.Component.LWSeasonAllianceTipsItem")
local SeasonRedPointUtils = require("UI.LWSeason.LWSeasonMain.Utils.SeasonRedPointUtils")
local TitleText_path = "root/RightView/Rect_Top/TopGroup/TitleText"
local TimeText_path = "root/RightView/Rect_Top/TopGroup/TimeText"
local IntroBtn_path = "root/RightView/Rect_Top/InfoBtn"
local BtnDesc_path = "root/RightView/Rect_Bottom/BtnList/BtnDesc"
local BtnBuild_path = "root/RightView/Rect_Bottom/BtnList/BtnBuild"
local BtnReward_path = "root/RightView/Rect_Bottom/BtnList/BtnReward"
local BtnRank_path = "root/RightView/Rect_Top/BtnRank"
local BtnConvert_path = "root/RightView/Rect_Bottom/BtnConvert"
local BtnRewardComparison_path = "root/RightView/Rect_Bottom/BtnList/BtnRewardComparison"
local ProgressBuild_path = "root/RightView/Rect_Top/TopGroup/progressBuild"
local TextBuild_path = "root/RightView/Rect_Top/TopGroup/progressBuild/progressBg/progressText"
local BtnBuildAdd_path = "root/RightView/Rect_Top/TopGroup/progressBuild/AddBtn"
local BtnAchievement_path = "root/RightView/Rect_Bottom/BtnList/BtnAchievement"
local LevelText_path = "root/RightView/Rect_Top/TopGroup/progressBuild/LevelText"
local Res1_path = "root/RightView/Rect_Bottom/Res1"
local RootBuild_path = "root/RightView/Rect_Bottom/RootBuild"
local BuildingIcon_path = "root/RightView/Rect_Bottom/RootBuild/BgBuilding/BuildingIcon"
local PosText_path = "root/RightView/Rect_Bottom/RootBuild/BgBuilding/Pos/PosText"
local BtnDonate_path = "root/RightView/Rect_Bottom/RootBuild/BgBuilding/BtnDonate"
local BuildingName_path = "root/RightView/Rect_Bottom/RootBuild/BgBuilding/BuildingName"
local BuildingRewardNum_path = "root/RightView/Rect_Bottom/RootBuild/BgBuilding/BuildingRewardNum"
local BgBuilding_path = "root/RightView/Rect_Bottom/RootBuild/BgBuilding"
local BgNone_path = "root/RightView/Rect_Bottom/RootBuild/BgNone"
local PosBtn_path = "root/RightView/Rect_Bottom/RootBuild/BgBuilding/Pos"
local DescRoot_path = "root/RightView/Rect_Top/TopGroup/DescRoot"
local DescText_path = "root/RightView/Rect_Top/TopGroup/DescRoot/InfoText"
local bgEffect_path = "root/bgParent/bg/Eff_UI_SeasonFarmerMain_BG"
local building_reward_icon_path = "root/RightView/Rect_Bottom/RootBuild/BgBuilding/BuildingRewardIcon"
local tip_root_path = "root/RightView/Rect_Bottom/RootBuild/BgBuilding/BuildingRewardIcon/TipRoot"
local btn_close_tip_path = "root/RightView/Rect_Bottom/RootBuild/BgBuilding/BuildingRewardIcon/TipRoot/BtnCloseTip"
local tip_box_title_root_path = "root/RightView/Rect_Bottom/RootBuild/BgBuilding/BuildingRewardIcon/TipRoot/TipBox/Title"
local tip_box_title_path = "root/RightView/Rect_Bottom/RootBuild/BgBuilding/BuildingRewardIcon/TipRoot/TipBox/Title/TipBoxTitle"
local tip_box_icon_path = "root/RightView/Rect_Bottom/RootBuild/BgBuilding/BuildingRewardIcon/TipRoot/TipBox/Title/TipBoxIcon"
local tip_box_content_path = "root/RightView/Rect_Bottom/RootBuild/BgBuilding/BuildingRewardIcon/TipRoot/TipBox/ScrollView/Viewport/TipBoxContent"
local tip_box_item_path = "root/RightView/Rect_Bottom/RootBuild/BgBuilding/BuildingRewardIcon/TipRoot/TipBox/ScrollView/Viewport/TipBoxContent/TipBoxItem"
local red_point_build_path = "root/RightView/Rect_Bottom/BtnList/BtnBuild/RedPointBuild"
local red_point_achievement_path = "root/RightView/Rect_Bottom/BtnList/BtnAchievement/RedPointAchievement"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  if LuaEntry.Player:IsInAlliance() then
    SFSNetwork.SendMessage(MsgDefines.SeasonBuilderView)
    SFSNetwork.SendMessage(MsgDefines.FetchCityAttachmentList)
  end
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self:RefreshAchievementRed()
  self:RefreshBuildRed()
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonFarmerStateChange, self.RefreshView)
  self:AddUIListener(EventId.ResourceUpdated, self.OnResourceUpdated)
  self:AddUIListener(EventId.CloseUI, self.OnCloseUI)
  self:AddUIListener(EventId.LWSeasonPersonalRewardGetRedPoint, self.RefreshAchievementRed)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.SeasonFarmerStateChange, self.RefreshView)
  self:RemoveUIListener(EventId.ResourceUpdated, self.OnResourceUpdated)
  self:RemoveUIListener(EventId.CloseUI, self.OnCloseUI)
  self:RemoveUIListener(EventId.LWSeasonPersonalRewardGetRedPoint, self.RefreshAchievementRed)
end

local function ComponentDefine(self)
  self.TitleText = self:AddComponent(UIText, TitleText_path)
  self.TimeText = self:AddComponent(UIText, TimeText_path)
  self.IntroBtn = self:AddComponent(UIButton, IntroBtn_path)
  self.BtnDesc = self:AddComponent(UIButton, BtnDesc_path)
  self.BtnBuild = self:AddComponent(UIButton, BtnBuild_path)
  self.BtnReward = self:AddComponent(UIButton, BtnReward_path)
  self.BtnRank = self:AddComponent(UIButton, BtnRank_path)
  self.BtnConvert = self:AddComponent(UIButton, BtnConvert_path)
  self.BtnRewardComparison = self:AddComponent(UIButton, BtnRewardComparison_path)
  self.ProgressBuild = self:AddComponent(UISlider, ProgressBuild_path)
  self.TextBuild = self:AddComponent(UIText, TextBuild_path)
  self.BtnBuildAdd = self:AddComponent(UIButton, BtnBuildAdd_path)
  self.BtnAchievement = self:AddComponent(UIButton, BtnAchievement_path)
  self.LevelText = self:AddComponent(UIText, LevelText_path)
  self.Res1 = self:AddComponent(UIBaseContainer, Res1_path)
  self.RootBuild = self:AddComponent(UIBaseContainer, RootBuild_path)
  self.BuildingIcon = self:AddComponent(UIRawImage, BuildingIcon_path)
  self.PosText = self:AddComponent(UIText, PosText_path)
  self.BtnDonate = self:AddComponent(UIButton, BtnDonate_path)
  self.BuildingName = self:AddComponent(UIText, BuildingName_path)
  self.BuildingRewardNum = self:AddComponent(UIText, BuildingRewardNum_path)
  self.BgBuilding = self:AddComponent(UIBaseContainer, BgBuilding_path)
  self.BgNone = self:AddComponent(UIBaseContainer, BgNone_path)
  self.PosBtn = self:AddComponent(UIButton, PosBtn_path)
  self.DescRoot = self:AddComponent(UIBaseContainer, DescRoot_path)
  self.DescText = self:AddComponent(UIBaseContainer, DescText_path)
  self.bgEffect = self:AddComponent(UIBaseContainer, bgEffect_path)
  self.IntroBtn:SetOnClick(BindCallback(self, self.OnBtnIntroClick))
  self.BtnDesc:SetOnClick(BindCallback(self, self.OnBtnDescClick))
  self.BtnBuild:SetOnClick(BindCallback(self, self.OnBtnBuildClick))
  self.BtnReward:SetOnClick(BindCallback(self, self.OnBtnRewardClick))
  self.BtnRewardComparison:SetOnClick(BindCallback(self, self.OnBtnRewardComparisonClick))
  self.BtnRank:SetOnClick(BindCallback(self, self.OnBtnRankClick))
  self.BtnConvert:SetOnClick(BindCallback(self, self.OnBtnConvertClick))
  self.BtnBuildAdd:SetOnClick(BindCallback(self, self.OnBtnBuildLevelClick))
  self.BtnAchievement:SetOnClick(BindCallback(self, self.OnBtnAchievementClick))
  self.TitleText:SetText(Localization:GetString("season_builders_alliance_activity_name"))
  self.top_res1 = self:AddComponent(UIMainResourceProgress, Res1_path)
  self.BtnDonate:SetOnClick(BindCallback(self, self.OnBtnDonateClick))
  self.PosBtn:SetOnClick(function()
    if self.cityPos ~= nil and self.cityPos.x ~= nil and self.cityPos.y ~= nil then
      local v3 = SceneUtils.TileToWorld(self.cityPos, ForceChangeScene.World)
      GoToUtil.CloseAllWindows()
      GoToUtil.GotoWorldPos(v3, CS.SceneManager.World.InitZoom, nil, nil, self.serverId)
    end
  end)
  self.building_reward_icon = self:AddComponent(UIButton, building_reward_icon_path)
  self.tip_root = self:AddComponent(UICanvasGroup, tip_root_path)
  self.btn_close_tip = self:AddComponent(UIButton, btn_close_tip_path)
  self.tip_root:SetActive(false)
  self.tip_box_title_root = self:AddComponent(UIBaseComponent, tip_box_title_root_path)
  self.tip_box_title = self:AddComponent(UIText, tip_box_title_path)
  self.tip_box_icon = self:AddComponent(UIImage, tip_box_icon_path)
  self.tip_box_content = self:AddComponent(UIBaseContainer, tip_box_content_path)
  self.tipBoxTemplate = self.transform:Find(tip_box_item_path).gameObject
  self.tipBoxTemplate:GameObjectCreatePool()
  self.btn_close_tip:SetOnClick(function()
    local sequence = CS.DG.Tweening.DOTween.Sequence()
    sequence:Join(self.tip_root:FadeOut(0.2))
    sequence:Join(self.tip_root.transform:DOScale(Vector3.New(1, 0, 1), 0.2))
    sequence:AppendCallback(function()
      if self.tip_root then
        self.tip_root:SetActive(false)
      end
    end)
  end)
  self.building_reward_icon:SetOnClick(function()
    if self.tip_root:GetActive() and self.tip_root:GetAlpha() ~= 0 then
      return
    end
    self.tip_root:SetAlpha(0)
    self.tip_root:SetActive(true)
    self:InitRewardTips()
    local sequence = CS.DG.Tweening.DOTween.Sequence()
    sequence:Join(self.tip_root:FadeIn(0.2))
    sequence:Join(self.tip_root.transform:DOScale(Vector3.New(1, 1, 1), 0.2))
  end)
  self.red_point_build = self:AddComponent(UIImage, red_point_build_path)
  self.red_point_achievement = self:AddComponent(UIImage, red_point_achievement_path)
  local effectPath = "Assets/_Art_LastWar/Effect/Prefab/UI/xiejiaguitian/Eff_UI_SeasonFarmerMain_BG.prefab"
  self.season_london_effect = UIAsyncNode.New("Eff_UI_SeasonFarmerMain_BG", self.bgEffect.transform, effectPath)
end

function SeasonFarmerMain:OnCloseUI()
  self:RefreshAchievementRed()
  self:RefreshBuildRed()
end

local function ComponentDestroy(self)
  if self.season_london_effect then
    self.season_london_effect:Delete()
    self.season_london_effect = nil
  end
  self.TitleText = nil
  self.TimeText = nil
  self.IntroBtn = nil
  self.BtnDesc = nil
  self.BtnBuild = nil
  self.BtnReward = nil
  self.BtnRank = nil
  self.BtnConvert = nil
  self.BtnRewardComparison = nil
  self.ProgressBuild = nil
  self.TextBuild = nil
  self.BtnBuildAdd = nil
  self.BtnAchievement = nil
  self.LevelText = nil
  self.Res1 = nil
  self.RootBuild = nil
  self.BuildingIcon = nil
  self.PosText = nil
  self.BtnDonate = nil
  self.BuildingName = nil
  self.BuildingRewardNum = nil
  self.BgBuilding = nil
  self.BgNone = nil
  self.PosBtn = nil
  self.DescRoot = nil
  self.DescText = nil
  self.bgEffect = nil
  if self.theItem then
    self.theItem:GameObjectRecycleAll()
  end
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function SeasonFarmerMain:SetData(activityId)
  base.SetData(self, activityId)
  local data = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if data == nil then
    return
  end
  self.activityData = data
  self.StartTime = data.startTime
  self.EndTime = data.endTime
  self:RefreshView()
  self:Update1000MS()
  DataCenter.SeasonFarmerManager:SetView()
  self:InitRedPoint()
end

function SeasonFarmerMain:RefreshView()
  if not DataCenter.SeasonFarmerManager:IsActive() then
    self.BtnAchievement:SetActive(false)
    self.BtnReward:SetActive(false)
    self.BtnRewardComparison:SetActive(true)
    self.BtnConvert:SetActive(true)
    self.BtnBuildAdd:SetActive(false)
    self.ProgressBuild:SetActive(false)
    self.DescRoot:SetActive(true)
    self.RootBuild:SetActive(false)
    self.top_res1:SetActive(false)
    self:RefreshDesc()
    return
  end
  self.BtnAchievement:SetActive(true)
  self.BtnReward:SetActive(true)
  self.BtnRewardComparison:SetActive(false)
  self.BtnConvert:SetActive(false)
  self.BtnBuildAdd:SetActive(true)
  self.ProgressBuild:SetActive(true)
  self.DescRoot:SetActive(false)
  self.RootBuild:SetActive(true)
  self.top_res1:SetActive(true)
  self.top_res1:ReInit(self:GetResourceParam(ResourceType.AllianceFarmerExpItem))
  self:OnResourceUpdated()
  self:RefreshBuildingLevel()
  self:RefreshCurBuildingInfo()
end

function SeasonFarmerMain:Update1000MS()
  if self.activityData ~= nil and self.StartTime and self.EndTime then
    local deltaTime = 0
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if curTime < self.StartTime then
      deltaTime = self.StartTime - curTime
    elseif curTime < self.EndTime then
      deltaTime = self.EndTime - curTime
    end
    if 0 < deltaTime then
      local showTime = UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime)
      self.TimeText:SetText(showTime)
      if self.nextTime ~= nil and 0 < self.nextTime and curTime > self.nextTime then
        self:RefreshView()
      end
    else
      self.TimeText:SetText("00:00:00")
    end
  end
end

function SeasonFarmerMain:GetResourceParam(resourceType)
  local param = {}
  param.resourceType = resourceType
  param.iconName = DataCenter.ResourceManager:GetResourceIconByType(resourceType)
  param.showExpandAnimation = false
  param.showExpandParam = false
  return param
end

function SeasonFarmerMain:OnResourceUpdated()
  if self.top_res1 and self.top_res1.activeSelf then
    self.top_res1:Refresh()
  end
end

function SeasonFarmerMain:RefreshDesc()
  if self.theItem then
    return
  end
  local mainCfg = DataCenter.SeasonFarmerTemplateManager:GetMainCfg()
  local descStr = mainCfg and mainCfg.activity_description
  if not descStr then
    return
  end
  local descList = string.split(descStr, "|")
  local dataCount = #descList
  if dataCount <= 0 then
    return
  end
  if self.theItem == nil then
    self.theItem = self.transform:Find(DescText_path).gameObject
    self.theItem:GameObjectCreatePool()
  else
    self.theItem:GameObjectRecycleAll()
  end
  local goItem
  for i = 1, dataCount do
    goItem = self.theItem:GameObjectSpawn(self.DescRoot.transform)
    goItem.name = "ItemDescText_" .. i
    goItem:SetActive(true)
    local text = self:AddComponent(UIText, string.format("%s/%s", DescRoot_path, goItem.name))
    text:SetLocalText(descList[i])
  end
end

function SeasonFarmerMain:RefreshCurBuildingInfo()
  self.serverId = LuaEntry.Player.serverId
  self.cityPos = nil
  if DataCenter.SeasonFarmerManager:IsActive() then
    local buildInfo = DataCenter.SeasonFarmerManager:GetCurBuildingInfo()
    local buildData = buildInfo and DataCenter.SeasonFarmerTemplateManager:GetBuildTemplateById(buildInfo.buildId)
    if buildData then
      self.serverId = LuaEntry.Player:GetSourceServerId()
      local cityPos = SceneUtils.IndexToTilePos(buildInfo.pointId, ForceChangeScene.World)
      self.cityPos = cityPos
      self.BuildingIcon:LoadSprite(buildData:GetIconPath())
      local posStr = UIUtil.FormatServerPosition(nil, cityPos.x, cityPos.y)
      self.PosText:SetText(string.format("<u>%s</u>", posStr))
      local curExp = toInt(buildInfo.exp)
      local needExp = toInt(buildData.cost)
      local progress = string.percentage(curExp, needExp, 2)
      self.BuildingName:SetText(string.format("%s (%s)", Localization:GetString(buildData.name), progress))
      if buildInfo.isFirst then
        local cityInfo = DataCenter.SeasonFarmerTemplateManager:GetCityAttachmentTemplate(buildInfo.cityId)
        local chest_num = cityInfo:GetChestNumBySlot(buildInfo.slot + 1)
        self.BuildingRewardNum:SetText(string.format("\195\151%s", chest_num))
        self.building_reward_icon:SetActive(true)
        self.BuildingRewardNum:SetActive(true)
      else
        self.building_reward_icon:SetActive(false)
        self.BuildingRewardNum:SetActive(false)
      end
      self.BgBuilding:SetActive(true)
      self.BgNone:SetActive(false)
      return
    end
  end
  self.BgBuilding:SetActive(false)
  self.BgNone:SetActive(true)
end

function SeasonFarmerMain:RefreshBuildingLevel()
  local builderExpInfo = DataCenter.SeasonFarmerManager.allianceBuildInfo.builderExpInfo or {}
  local myLevel = toInt(builderExpInfo.level or 1)
  local curExp = toInt(builderExpInfo.curExp or 0)
  local levelCfg = DataCenter.SeasonFarmerTemplateManager:GetExpTemplateByLevel(myLevel)
  self.LevelText:SetText("Lv." .. myLevel)
  if builderExpInfo and levelCfg and levelCfg.exp then
    self.ProgressBuild:SetValue(math.min(curExp / levelCfg.exp, 1))
    self.TextBuild:SetText(string.GetFormattedSeparatorNum(curExp) .. "/" .. string.GetFormattedSeparatorNum(levelCfg.exp))
  else
    self.ProgressBuild:SetValue(0)
    if levelCfg and levelCfg.exp then
      self.TextBuild:SetText("0/" .. string.GetFormattedSeparatorNum(levelCfg.exp))
    else
      self.TextBuild:SetText("0/100000")
    end
  end
end

function SeasonFarmerMain:OnBtnIntroClick()
  local param = {}
  param.activityRulesStr = Localization:GetString(GetTableData(TableName.Activity, self.activityId, "desc"))
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
end

function SeasonFarmerMain:OnBtnDescClick()
  local mainCfg = DataCenter.SeasonFarmerTemplateManager:GetMainCfg()
  if mainCfg and not string.IsNullOrEmpty(mainCfg.ppt_group) then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWWorldTip, {anim = false}, mainCfg.ppt_group)
    return
  end
  UIUtil.ShowTipsId(120018)
end

function SeasonFarmerMain:OnBtnBuildClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonCityAttachment, {anim = true, hideTop = true})
end

function SeasonFarmerMain:OnBtnRewardComparisonClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.FarmerRewardCompare, {anim = true})
end

function SeasonFarmerMain:OnBtnRewardClick()
  local isFarmer = DataCenter.SeasonFarmerManager:IsActive()
  if isFarmer then
    if DataCenter.SeasonFarmerManager:IsOpen() and DataCenter.SeasonFarmerManager:IsActive() then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonReward, {anim = false}, nil, 1)
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonReward, {anim = false})
    end
  end
end

function SeasonFarmerMain:OnBtnRankClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonRank, {anim = true}, {isFarmer = true})
end

function SeasonFarmerMain:OnBtnConvertClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.SeasonFarmerConvert, {anim = true})
end

function SeasonFarmerMain:OnBtnGetClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWResourceInfo, {anim = true}, ResourceType.AllianceFarmerExpItem)
end

function SeasonFarmerMain:OnBtnBuildLevelClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWResourceInfo, {anim = true}, ResourceType.AllianceFarmerExp)
end

function SeasonFarmerMain:OnBtnAchievementClick()
  local isFarmer = DataCenter.SeasonFarmerManager:IsActive()
  if isFarmer then
    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UILWSingleActivityContainer) then
      EventManager:GetInstance():Broadcast(EventId.UILWSingleActivityContainerOpenPanel, {
        activityId = "SeasonScoreReward",
        param = isFarmer
      })
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSingleActivityContainer, {
        anim = true,
        UIMainAnim = UIMainAnimType.AllHide
      }, "SeasonScoreReward", nil, isFarmer)
    end
  else
    UIUtil.ShowTipsId(120018)
  end
end

function SeasonFarmerMain:OnBtnDonateClick()
  local buildInfo = DataCenter.SeasonFarmerManager:GetCurBuildingInfo()
  if buildInfo then
    local serverId = LuaEntry.Player:GetSourceServerId()
    local pointId = buildInfo.pointId
    local pos = SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World)
    GoToUtil.CloseAllWindows()
    GoToUtil.GotoWorldPos(pos, nil, nil, function()
      GoToUtil.OnClickWorldPoint(pointId, WorldPointType.CITY_ATTACHMENT_BUILD, nil)
    end, serverId, 0)
  end
end

function SeasonFarmerMain:InitRewardTips()
  self.tip_box_content:RemoveComponents(LWSeasonAllianceTipsItem)
  self.tipBoxTemplate:GameObjectRecycleAll()
  local goItem, theItem
  local extraRewards = DataCenter.SeasonDataManager:GetLootRewardList()
  if extraRewards ~= nil then
    for i, item in ipairs(extraRewards) do
      goItem = self.tipBoxTemplate:GameObjectSpawn(self.tip_box_content.transform)
      goItem.name = "item_" .. i
      goItem:SetActive(true)
      theItem = self.tip_box_content:AddComponent(LWSeasonAllianceTipsItem, goItem.name)
      theItem:ReInit(item)
    end
  end
  extraRewards = DataCenter.SeasonDataManager:GetSeasonConfig()
  local value = extraRewards.loot_reward_value
  local text = Localization:GetString("2000155")
  self.tip_box_title:SetText(text .. value)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.tip_box_title_root.rectTransform)
end

function SeasonFarmerMain:InitRedPoint()
  if CS.ClientSwitch.IsOn(CS.ClientSwitch.DISABLE_RED_POINT_TREE) then
    return
  end
  self:BindRedPointUI(self.red_point_achievement, nil, {
    RedDef.Season,
    RedDef.SeasonMainTab,
    RedDef.SeasonFarmer,
    RedDef.SeasonFarmerAchievement
  })
  self:BindRedPointUI(self.red_point_build, nil, {
    RedDef.Season,
    RedDef.SeasonMainTab,
    RedDef.SeasonFarmer,
    RedDef.SeasonFarmerBuildReward
  })
end

function SeasonFarmerMain:RefreshAchievementRed()
  if not CS.ClientSwitch.IsOn(CS.ClientSwitch.DISABLE_RED_POINT_TREE) then
    return
  end
  self.red_point_achievement:SetActive(SeasonUtil.CheckSeasonFarmerAchievement())
end

function SeasonFarmerMain:RefreshBuildRed()
  if not CS.ClientSwitch.IsOn(CS.ClientSwitch.DISABLE_RED_POINT_TREE) then
    return
  end
  self.red_point_build:SetActive(DataCenter.SeasonFarmerManager:CountOfBuildReward() > 0)
end

SeasonFarmerMain.OnCreate = OnCreate
SeasonFarmerMain.OnDestroy = OnDestroy
SeasonFarmerMain.OnEnable = OnEnable
SeasonFarmerMain.OnDisable = OnDisable
SeasonFarmerMain.ComponentDefine = ComponentDefine
SeasonFarmerMain.ComponentDestroy = ComponentDestroy
SeasonFarmerMain.DataDefine = DataDefine
SeasonFarmerMain.DataDestroy = DataDestroy
SeasonFarmerMain.OnAddListener = OnAddListener
SeasonFarmerMain.OnRemoveListener = OnRemoveListener
return SeasonFarmerMain
