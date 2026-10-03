local UILWSeason4MilitaryCenterView = BaseClass("UILWSeason4MilitaryCenterView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UILWSeasonMummyBuilding = require("UI.LWSeason4.MilitaryCenterS4.LWSeason4MilitaryCenter.Component.UILWSeason4MummyBuilding")
local ModelViewer = require("UI.LWSeason4.MilitaryCenterS4.LWSeason4MilitaryCenter.Component.UILWSeason4MilitaryCenterModelViewer")
local rapidjson = require("rapidjson")
local base64 = require("Framework.Common.base64")
local root_path = "Root"
local fire_root_path = "Root/FireRoot"
local top_bar_path = "Root/TopBar"
local bottom_bar_path = "Root/BottomBar"
local rt_image_path = "Root/FireRoot/rtImage"
local bg_path = "Root/FireRoot/bg"
local build_pos_path = "Root/FireRoot/Layout/build_pos"
local btn_build_path = "Root/FireRoot/Layout/btnBuild"
local btn_txt_path = "Root/FireRoot/Layout/btnBuild/btnTxt"
local time_text_path = "Root/FireRoot/Layout/TimeText"
local name_path = "Root/FireRoot/Layout/Name"
local rank_root_path = "Root/BottomBar/RankRoot"
local rank_text_path = "Root/BottomBar/RankRoot/RankText"
local now_rank_text_path = "Root/BottomBar/RankRoot/RankTextNow"
local btn_back_path = "Root/BottomBar/BtnBack"
local text_title_path = "Root/TopBar/TextTitle"
local info_btn_path = "Root/TopBar/InfoBtn"
local res_root_path = "Root/TopBar/ResRoot"
local txt_res_path = "Root/TopBar/ResRoot/Txt_Res"
local txt_res_icon_path = "Root/TopBar/ResRoot/Txt_Res/Txt_Res_Icon"
local plus_path = "Root/TopBar/ResRoot/Txt_Res/plus"
local scroll_view_path = "Root/ScrollView"
local content_path = "Root/ScrollView/Viewport/Content"
local tab_item_work_path = "Root/ScrollView/Tab/TabItemWork"
local tab_item_level_path = "Root/ScrollView/Tab/TabItemLevel"
local tab_item_move_path = "Root/ScrollView/Tab/TabItemMove"
local btn_move_tab_path = "Root/ScrollView/Tab/TabItemMove/BtnMoveTab"
local tips_speed_path = "Root/FireRoot/tipsSpeed"
local build_icon_path = "Root/FireRoot/build_icon"
local hp_bar_path = "Root/FireRoot/HPBar"
local build1_path = "Root/FireRoot/build1"
local build2_path = "Root/FireRoot/build2"
local build3_path = "Root/FireRoot/build3"
local build4_path = "Root/FireRoot/build4"

function UILWSeason4MilitaryCenterView:OnCreate()
  base.OnCreate(self)
  self.buildEndTime = nil
  self:ComponentDefine()
  self:UpdateData()
  SFSNetwork.SendMessage(MsgDefines.FetchMilitaryCenterBuildInfo)
  DataCenter.AllianceStorageManager:CheckAllianceStorage()
  DataCenter.AllianceMineManager:RequestAllianceMineInfo(true)
end

function UILWSeason4MilitaryCenterView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeason4MilitaryCenterView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OpenUI, self.OnOpenUI)
  self:AddUIListener(EventId.UpdateAllAllianceMineList, self.UpdateData)
  self:AddUIListener(EventId.LWSeasonCrossOccupyCityListUpdate, self.OnStoveCenterInfoUpdate)
  self:AddUIListener(EventId.AllianceStoveCenterUpdate, self.OnStoveCenterInfoUpdate)
  self:AddUIListener(EventId.AllianceResourceUpdate, self.OnResUpdate)
end

function UILWSeason4MilitaryCenterView:OnRemoveListener()
  self:RemoveUIListener(EventId.OpenUI, self.OnOpenUI)
  self:RemoveUIListener(EventId.UpdateAllAllianceMineList, self.UpdateData)
  self:RemoveUIListener(EventId.LWSeasonCrossOccupyCityListUpdate, self.OnStoveCenterInfoUpdate)
  self:RemoveUIListener(EventId.AllianceStoveCenterUpdate, self.OnStoveCenterInfoUpdate)
  self:RemoveUIListener(EventId.AllianceResourceUpdate, self.OnResUpdate)
  base.OnRemoveListener(self)
end

function UILWSeason4MilitaryCenterView:OnResUpdate()
  if self.txt_res ~= nil then
    local resStone = LuaEntry.Resource:GetCntByResType(ResourceType.AllianceStone)
    self.txt_res:SetText(string.GetFormattedStr(resStone))
  end
end

function UILWSeason4MilitaryCenterView:OnOpenUI(name)
  if name ~= UIWindowNames.UILWSeason4MilitaryCenter then
  end
end

function UILWSeason4MilitaryCenterView:SetOnTop()
end

function UILWSeason4MilitaryCenterView:ComponentDefine()
  self.bg = self:AddComponent(UIRawImage, bg_path)
  self.rt_image = self:AddComponent(ModelViewer, rt_image_path)
  self.rt_image:ReloadScene(self.bg)
  self.root = self:AddComponent(UIBaseContainer, root_path)
  self.fire_root = self:AddComponent(UIBaseContainer, fire_root_path)
  self.top_bar = self:AddComponent(UIImage, top_bar_path)
  self.bottom_bar = self:AddComponent(UIImage, bottom_bar_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.build1 = self:AddComponent(UILWSeasonMummyBuilding, build1_path)
  self.build2 = self:AddComponent(UILWSeasonMummyBuilding, build2_path)
  self.build3 = self:AddComponent(UILWSeasonMummyBuilding, build3_path)
  self.build4 = self:AddComponent(UILWSeasonMummyBuilding, build4_path)
  self.build_icon = self:AddComponent(UIRawImage, build_icon_path)
  self.name = self:AddComponent(UITextMeshProUGUIEx, name_path)
  self.text_title = self:AddComponent(UIText, text_title_path)
  self.name:SetLocalText("season_s3_alliance_center_name01")
  self.text_title:SetLocalText("season_s3_alliance_building_ui01")
  self.btn_back = self:AddComponent(UIButton, btn_back_path)
  self.btn_back:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.info_btn = self:AddComponent(UIButton, info_btn_path)
  self.info_btn:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeason4CenterRule)
  end)
  self.plus = self:AddComponent(UIButton, plus_path)
  self.res_root = self:AddComponent(UIButton, res_root_path)
  self.plus:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWResourceInfo, {anim = true}, ResourceType.AllianceStone)
    UIUtil.CheckEventTrigger(OpMode.ClickBtnResource, ResourceType.AllianceStone)
    if CS.CommonUtils.IsDebug() or CS.UnityEngine.Application.isEditor then
      SFSNetwork.SendMessage(MsgDefines.GMAddResourceMessage, ResourceType.AllianceStone, 10000)
    end
  end)
  self.res_root:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWResourceInfo, {anim = true}, ResourceType.AllianceStone)
    UIUtil.CheckEventTrigger(OpMode.ClickBtnResource, ResourceType.AllianceStone)
    if CS.CommonUtils.IsDebug() or CS.UnityEngine.Application.isEditor then
      SFSNetwork.SendMessage(MsgDefines.GMAddResourceMessage, ResourceType.AllianceStone, 10000)
    end
  end)
  self.txt_res = self:AddComponent(UIText, txt_res_path)
  self.txt_res_icon = self:AddComponent(UIImage, txt_res_icon_path)
  self.txt_res_icon:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(ResourceType.AllianceStone))
  self.build_pos = self:AddComponent(UITextMeshProUGUIEx, build_pos_path)
  self.build_pos:SetActive(false)
  self.build_pos:OnPointerClick(function(eventData)
    if self.linkInfo then
      GoToUtil.TryJumpToWorld(self.linkInfo)
    else
      self:OnPointerClick(eventData.position)
    end
  end)
  self.btn_txt = self:AddComponent(UITextMeshProUGUIEx, btn_txt_path)
  self.btn_build = self:AddComponent(UIButton, btn_build_path)
  self.btn_build:SetOnClick(function()
    if self.linkInfo then
      GoToUtil.TryJumpToWorld(self.linkInfo)
    elseif DataCenter.AllianceBaseDataManager:IsR4orR5() then
      local curTime = UITimeManager:GetInstance():GetServerTime()
      local settleTime = DataCenter.SeasonDataManager:GetSeasonSettleTime()
      if curTime > settleTime then
        UIUtil.ShowTipsId("season_tips195")
        return
      end
      local effectValue = DataCenter.LWSeasonTrendsManager:GetEffectValue(EffectDefine.LW_SEASON_ALLIANCE_CENTER_OPEN_DARKNESS)
      if effectValue == nil or effectValue == 0 then
        UIUtil.ShowTipsId(390994)
        return
      end
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeason4CenterCondition, {anim = true}, BuildingTypes.SEASON_POWER_CENTER)
    else
      UIUtil.ShowTipsId(803040)
    end
  end)
  self.hp_bar = self:AddComponent(UISlider, hp_bar_path)
  self.time_text = self:AddComponent(UITextMeshProUGUIEx, time_text_path)
  self.rank_root = self:AddComponent(UIButton, rank_root_path)
  self.rank_text = self:AddComponent(UITextMeshProUGUIEx, rank_text_path)
  self.now_rank_text = self:AddComponent(UITextMeshProUGUIEx, now_rank_text_path)
  self.scroll_view = self:AddComponent(UIScrollRect, scroll_view_path)
  self.rank_root:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonRank, {anim = true}, 1)
  end)
  self.tips_speed = self:AddComponent(UITextMeshProUGUIEx, tips_speed_path)
  self.tab_item_work = self:AddComponent(UIToggle, tab_item_work_path)
  self.tab_item_level = self:AddComponent(UIToggle, tab_item_level_path)
  self.tab_item_move = self:AddComponent(UIToggle, tab_item_move_path)
  self.btn_move_tab = self:AddComponent(UIButton, btn_move_tab_path)
  self.build_icon:SetActive(true)
  self.tab_item_work:SetOnValueChanged(function(tf)
    if tf then
      self:ToggleWork()
      self:OnTabChanged(1)
    end
  end)
  self.tab_item_level:SetOnValueChanged(function(tf)
    if tf then
      self:ToggleLevelUp()
      self:OnTabChanged(2)
    end
  end)
  self.tab_item_move:SetOnValueChanged(function(tf)
    if tf then
      self:ToggleMove()
      self:OnTabChanged(3)
    end
  end)
  self.btn_move_tab:SetOnClick(function()
    if self.theStoveCenter and toInt(self.theStoveCenter.level) >= 1 then
      if not self.tab_item_move:GetIsOn() then
        self.tab_item_move:SetIsOn(true)
      end
    else
      UIUtil.ShowTips(Localization:GetString("300505", 1))
    end
  end)
  self.tab_item_work:SetIsOn(true)
  if self.tabWork == nil or self.tabIndex == nil then
    self:ToggleWork()
    self:OnTabChanged(1)
  end
end

function UILWSeason4MilitaryCenterView:OnStoveCenterInfoUpdate_UpdateFog()
  local buildingData = DataCenter.AllianceMineManager.militaryCenterBuildInfos
  if buildingData ~= nil then
    local s4data = buildingData.darknessSeason
    if s4data ~= nil and self.rt_image ~= nil then
      self.rt_image:UpdateFog(s4data.isLightPoint, s4data.isBloodNight)
    end
  end
end

function UILWSeason4MilitaryCenterView:OnStoveCenterInfoUpdate()
  local resStone = LuaEntry.Resource:GetCntByResType(ResourceType.AllianceStone)
  local myAliRankIndex = toInt(DataCenter.SeasonFactionWarDataManager.myAliRankIndex)
  if myAliRankIndex == 0 then
    self.now_rank_text:SetText(Localization:GetString("456529") .. " No.100+")
  else
    self.now_rank_text:SetText(Localization:GetString("456529") .. " No." .. myAliRankIndex)
  end
  self.txt_res:SetText(string.GetFormattedStr(resStone))
  self.rank_root:SetActive(toInt(resStone) > 0)
  if self.tabIndex == 1 and self.tabWork ~= nil then
    self.tabWork:UpdateData()
  end
  if self.theStoveCenter ~= nil and self.theStoveCenter.status ~= AllianceMineStatus.Build and self.theStoveCenter.status ~= AllianceMineStatus.FoldUp then
    self.build1:UpdateStatus()
    self.build2:UpdateStatus()
    self.build3:UpdateStatus()
    self.build4:UpdateStatus()
  end
  self.rt_image:UpdateStatus(self.active_building_list)
  local product_value = 0
  local CrossOccupyCityList = DataCenter.SeasonDataManager.CrossOccupyCityList or {}
  local CrossOccupyStrongholdList = DataCenter.SeasonDataManager.CrossOccupyStrongholdList or {}
  local cityMeta
  for k, v in pairs(CrossOccupyCityList) do
    cityMeta = DataCenter.AllianceCityTemplateManager:GetTemplate(toInt(v.cityId), v.serverId)
    if cityMeta and cityMeta.season_snow_stone_value ~= 0 and cityMeta.season_snow_stone_id == ResourceType.AllianceStone then
      product_value = product_value + toInt(cityMeta.season_snow_stone_value or 0)
    end
  end
  for k, v in pairs(CrossOccupyStrongholdList) do
    cityMeta = DataCenter.AllianceCityTemplateManager:GetTemplate(toInt(v.id), v.serverId)
    if cityMeta and cityMeta.season_snow_stone_value ~= 0 and cityMeta.season_snow_stone_id == ResourceType.AllianceStone then
      product_value = product_value + toInt(cityMeta.season_snow_stone_value or 0)
    end
  end
  local theStoveCenter = DataCenter.AllianceMineManager:GetAllianceStoveCenter()
  self.theStoveCenter = theStoveCenter
  if theStoveCenter and theStoveCenter.status == AllianceMineStatus.Normal and not theStoveCenter:Injuried() then
    local meta = DataCenter.AllianceMineManager:GetAllianceMineTemplate(theStoveCenter.level + BuildingTypes.SEASON_POWER_CENTER)
    if meta and meta.hour_product_stone then
      local stone_value = meta.hour_product_stone[ResourceType.AllianceStone] or 0
      product_value = product_value + toInt(stone_value)
    end
  end
  if 0 < product_value then
    self.tips_speed:SetActive(true)
    self.tips_speed:SetLocalText("390968", string.GetFormattedStr2(product_value))
  else
    self.tips_speed:SetActive(false)
  end
  self:OnStoveCenterInfoUpdate_UpdateFog()
end

function UILWSeason4MilitaryCenterView:OnTabChanged(tabIndex)
  self.tabIndex = tabIndex
  if self.tabWork ~= nil then
    self.tabWork:SetActive(tabIndex == 1)
    if tabIndex == 1 then
      self.tabWork:UpdateData()
    end
  end
  if self.tabLevel ~= nil then
    self.tabLevel:SetActive(tabIndex == 2)
    if tabIndex == 2 then
      self.tabLevel:UpdateData()
    end
  end
  if self.tabCarrier ~= nil then
    self.tabCarrier:SetActive(tabIndex == 3)
    if tabIndex == 3 then
      self.tabCarrier:UpdateData()
    end
  end
end

function UILWSeason4MilitaryCenterView:TryShowLevelModel(showLevelModel)
  if showLevelModel then
    if self.stove_center_level == nil then
      local MilitaryCenterLevel = "UI.LWSeason4.MilitaryCenterS4.LWSeason4MilitaryCenter.Component.UILWSeason4MilitaryCenterLevel"
      local prefabPath = "Assets/Main/SeasonRes/S4/Prefabs/UI/UIMilitaryCenter/MilitaryCenterLevel.prefab"
      self.stove_center_level = UIBaseComponent.LoadComponentAsync(self, MilitaryCenterLevel, prefabPath, self.root, function(view, go, stove_center_level)
        if self.fire_root and ComponentIsValid(self) and GameObjectIsValid(go) and ComponentIsValid(stove_center_level) then
          self.fire_root:SetSiblingIndex(1)
          stove_center_level:SetSiblingIndex(2)
          self.scroll_view:SetSiblingIndex(3)
          self.top_bar:SetSiblingIndex(4)
          self.bottom_bar:SetSiblingIndex(5)
        end
      end)
    else
      self.stove_center_level:UpdateData()
    end
    self.stove_center_level:SetActive(true)
    self.scroll_view:SetActive(false)
  else
    if self.stove_center_level ~= nil then
      self.stove_center_level:SetActive(false)
    end
    self.scroll_view:SetActive(true)
  end
end

function UILWSeason4MilitaryCenterView:ToggleWork()
  if self.tabWork == nil then
    local MilitaryCenterWork = "UI.LWSeason4.MilitaryCenterS4.LWSeason4MilitaryCenter.Component.UILWSeason4MilitaryCenterWork"
    local prefabPath = "Assets/Main/SeasonRes/S4/Prefabs/UI/UIMilitaryCenter/MilitaryCenterWork.prefab"
    self.tabWork = UIBaseComponent.LoadComponentAsync(self, MilitaryCenterWork, prefabPath, self.content)
  end
end

function UILWSeason4MilitaryCenterView:ToggleLevelUp()
  if self.tabLevel == nil then
    local MilitaryCenterLevel = "UI.LWSeason4.MilitaryCenterS4.LWSeason4MilitaryCenter.Component.UILWSeason4MilitaryCenterLevel"
    local prefabPath = "Assets/Main/SeasonRes/S4/Prefabs/UI/UIMilitaryCenter/MilitaryCenterLevel.prefab"
    self.tabLevel = UIBaseComponent.LoadComponentAsync(self, MilitaryCenterLevel, prefabPath, self.content)
  end
end

function UILWSeason4MilitaryCenterView:ToggleMove()
  if self.tabCarrier == nil then
    local MilitaryCenterMove = "UI.LWSeason4.MilitaryCenterS4.LWSeason4MilitaryCenter.Component.UILWSeason4MilitaryCenterMove"
    local prefabPath = "Assets/Main/SeasonRes/S4/Prefabs/UI/UIMilitaryCenter/MilitaryCenterMove.prefab"
    self.tabCarrier = UIBaseComponent.LoadComponentAsync(self, MilitaryCenterMove, prefabPath, self.content)
  end
end

function UILWSeason4MilitaryCenterView:OnPointerClick(clickPos)
  if self.build_pos == nil then
    return
  end
  local linkId = self.build_pos:TryGetPointerClickLinkID(clickPos)
  if string.IsNullOrEmpty(linkId) then
    return
  end
  GoToUtil.TryJumpToWorld(rapidjson.decode(base64.decode(linkId)))
end

function UILWSeason4MilitaryCenterView:ComponentDestroy()
  self.build1 = nil
  self.build2 = nil
  self.build3 = nil
  self.build4 = nil
  self.btn_back = nil
  self.btn_build = nil
  self.hp_bar = nil
  self.btn_txt = nil
  self.info_btn = nil
  self.res_root = nil
  self.txt_res = nil
  self.txt_res_icon = nil
  self.build_pos = nil
  self.stove_center_level = nil
  self.scroll_view = nil
  self.name = nil
  self.time_text = nil
  self.rank_root = nil
  self.rank_text = nil
  self.tab_item_work = nil
  self.tab_item_level = nil
  self.tab_item_move = nil
  self.btn_move_tab = nil
  self.tips_speed = nil
  self.fire_root = nil
  self.scroll_view = nil
  self.top_bar = nil
  self.bottom_bar = nil
  self.content = nil
  self.rt_image = nil
end

function UILWSeason4MilitaryCenterView:Update100MS()
  if self.theStoveCenter and self.theStoveCenter.status ~= AllianceMineStatus.Build and self.theStoveCenter.status ~= AllianceMineStatus.FoldUp and self.stove_center_level ~= nil then
    self.stove_center_level:SetActive(false)
  end
end

function UILWSeason4MilitaryCenterView:Update1000MS()
  if self.buildEndTime and self.buildEndTime > 0 then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local remainTime = self.buildEndTime - curTime
    if self.theStoveCenter and self.theStoveCenter.status == AllianceMineStatus.Normal then
      remainTime = 0
    end
    if remainTime <= 0 then
      self.buildEndTime = nil
      self.btn_build:SetActive(false)
      self.time_text:SetText("")
      self.hp_bar:SetValue(1)
      self.hp_bar:SetActive(false)
      return
    end
    self.hp_bar:SetValue(self.theStoveCenter:GetHPRate())
    self.time_text:SetText(Localization:GetString("100238") .. UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
  elseif self.isInjuried then
    self.hp_bar:SetValue(self.theStoveCenter:GetHPRate())
  end
end

function UILWSeason4MilitaryCenterView:UpdateData()
  local theStoveCenter = DataCenter.AllianceMineManager:GetAllianceStoveCenter()
  self.theStoveCenter = theStoveCenter
  if theStoveCenter == nil or theStoveCenter.status == AllianceMineStatus.FoldUp then
    self.linkInfo = nil
    self.hp_bar:SetActive(false)
    self.btn_build:SetActive(true)
    self.time_text:SetText("")
    self.build_pos:SetActive(false)
    self.buildEndTime = nil
    if theStoveCenter == nil then
      self.btn_txt:SetLocalText("110015")
    else
      self.btn_txt:SetLocalText("390451")
    end
    self:TryShowLevelModel(true)
  else
    if theStoveCenter.status == AllianceMineStatus.Build then
      self.buildEndTime = theStoveCenter:GetBuildEndTime()
      self.isInjuried = false
      self.btn_build:SetActive(true)
      self.build_pos:SetActive(true)
      self.time_text:SetText("")
      self.hp_bar:SetActive(true)
      self.btn_txt:SetLocalText("390210")
      self:TryShowLevelModel(true)
    else
      DataCenter.AllianceMineManager:FetchFurnaceInfos()
      self.isInjuried = theStoveCenter:Injuried()
      self.hp_bar:SetActive(self.isInjuried)
      self.btn_build:SetActive(false)
      self.build_pos:SetActive(true)
      self.time_text:SetText("")
      self.btn_txt:SetLocalText("110015")
      self:TryShowLevelModel(false)
      self.name:SetText("Lv." .. theStoveCenter.level .. " " .. Localization:GetString("season_s3_alliance_center_name01"))
      if self.tabIndex ~= nil then
        self:OnTabChanged(self.tabIndex)
      else
        self.tab_item_work:SetIsOn(true)
        if self.tabWork == nil or self.tabIndex == nil then
          self:ToggleWork()
          self:OnTabChanged(1)
        end
      end
    end
    local serverId = theStoveCenter.srcServerId or theStoveCenter.curServerId or LuaEntry.Player:GetSourceServerId()
    local posStr = UIUtil.FormatServerPosition(serverId, theStoveCenter.posV2.x, theStoveCenter.posV2.y)
    local link = {
      action = "Jump",
      pointId = theStoveCenter.pointId,
      server = serverId,
      worldId = 0
    }
    local json = rapidjson.encode(link)
    local strLink = string.format("<link=\"%s\"><u>%s</u></link>", base64.encode(json), posStr)
    self.linkInfo = link
    self.build_pos:SetText(strLink)
    self:Update1000MS()
  end
  self.build1:SetActive(false)
  self.build2:SetActive(false)
  self.build3:SetActive(false)
  self.build4:SetActive(false)
  if theStoveCenter ~= nil and theStoveCenter.status ~= AllianceMineStatus.Build and self.theStoveCenter.status ~= AllianceMineStatus.FoldUp then
    local BuildIds = {
      BuildingTypes.SEASON_POWER_CENTER_PLUGIN1,
      BuildingTypes.SEASON_POWER_CENTER_PLUGIN2,
      BuildingTypes.SEASON_POWER_CENTER_PLUGIN3
    }
    local active_building = {}
    for index, buildId in ipairs(BuildIds) do
      local meta = DataCenter.AllianceMineManager:GetAllianceMineTemplate(buildId + 1)
      if meta then
        table.insert(active_building, meta)
        local buildObj = self["build" .. index]
        if buildObj then
          buildObj:SetActive(true)
          buildObj:ReInit(buildId, meta)
        end
      end
    end
    local meta = DataCenter.AllianceMineManager:GetAllianceMineTemplate(BuildingTypes.SEASON_POWER_CENTER)
    if meta then
      self.active_building_list = active_building
      self.name:SetText("Lv." .. theStoveCenter.level .. " " .. Localization:GetString(meta.name))
    end
  end
  self:OnStoveCenterInfoUpdate()
end

return UILWSeason4MilitaryCenterView
