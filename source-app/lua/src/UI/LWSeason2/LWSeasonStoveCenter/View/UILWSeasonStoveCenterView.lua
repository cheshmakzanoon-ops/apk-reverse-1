local UILWSeasonStoveCenterView = BaseClass("UILWSeasonStoveCenterView", UIBaseView)
local base = UIBaseView
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local UILWSeasonStoveCenterItem = require("UI.LWSeason2.LWSeasonStoveCenter.Component.UILWSeasonStoveCenterItem")
local UILWSeasonStoveCenterPower = require("UI.LWSeason2.LWSeasonStoveCenter.Component.UILWSeasonStoveCenterPower")
local UILWSeasonStoveCenterMove = require("UI.LWSeason2.LWSeasonStoveCenter.Component.UILWSeasonStoveCenterMove")
local StoveCenterModelViewer = require("UI.LWSeason2.LWSeasonStoveCenter.Component.UILWSeasonStoveCenterModelViewer")
local rapidjson = require("rapidjson")
local base64 = require("Framework.Common.base64")
local build_pos_path = "Root/FireRoot/Layout/build_pos"
local btn_build_path = "Root/FireRoot/Layout/btnBuild"
local btn_txt_path = "Root/FireRoot/Layout/btnBuild/btnTxt"
local time_text_path = "Root/FireRoot/Layout/TimeText"
local name_path = "Root/FireRoot/Layout/Name"
local rank_root_path = "Root/FireRoot/RankRoot"
local rank_text_path = "Root/FireRoot/RankRoot/RankText"
local btn_back_path = "Root/BottomBar/BtnBack"
local text_title_path = "Root/TopBar/TextTitle"
local info_btn_path = "Root/TopBar/InfoBtn"
local res_root_path = "Root/FireRoot/ResRoot"
local txt_res_path = "Root/FireRoot/ResRoot/Txt_Res"
local txt_res_icon_path = "Root/FireRoot/ResRoot/Txt_Res/Txt_Res_Icon"
local hp_bar_path = "Root/FireRoot/HPBar"
local plus_path = "Root/FireRoot/ResRoot/Txt_Res/plus"
local stove_center_level_path = "Root/StoveCenterLevel"
local scroll_view_path = "Root/ScrollView"
local tab_item_work_path = "Root/ScrollView/Tab/TabItemWork"
local tab_item_level_path = "Root/ScrollView/Tab/TabItemLevel"
local tab_item_move_path = "Root/ScrollView/Tab/TabItemMove"
local btn_move_tab_path = "Root/ScrollView/Tab/TabItemMove/BtnMoveTab"
local tips_speed_path = "Root/FireRoot/tipsSpeed"
local rt_image_path = "Root/FireRoot/rtImage"
local build_icon_path = "Root/FireRoot/build_icon"
local s2_open_path = "S2Open"
local mask_partical_path = "Root/FireRoot/mask_partical"

function UILWSeasonStoveCenterView:OnCreate()
  base.OnCreate(self)
  self.theSoundId = -1
  self.workState = -1
  self.buildEndTime = nil
  self:ComponentDefine()
  self:UpdateData()
  DataCenter.AllianceStorageManager:CheckAllianceStorage()
  DataCenter.AllianceMineManager:RequestAllianceMineInfo(true)
end

function UILWSeasonStoveCenterView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonStoveCenterView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OpenUI, self.OnOpenUI)
  self:AddUIListener(EventId.UpdateAllAllianceMineList, self.UpdateData)
  self:AddUIListener(EventId.LWSeasonCrossOccupyCityListUpdate, self.OnStoveCenterInfoUpdate)
  self:AddUIListener(EventId.AllianceStoveCenterUpdate, self.OnStoveCenterInfoUpdate)
  self:AddUIListener(EventId.AllianceResourceUpdate, self.OnResUpdate)
end

function UILWSeasonStoveCenterView:OnRemoveListener()
  self:RemoveUIListener(EventId.OpenUI, self.OnOpenUI)
  self:RemoveUIListener(EventId.UpdateAllAllianceMineList, self.UpdateData)
  self:RemoveUIListener(EventId.LWSeasonCrossOccupyCityListUpdate, self.OnStoveCenterInfoUpdate)
  self:RemoveUIListener(EventId.AllianceStoveCenterUpdate, self.OnStoveCenterInfoUpdate)
  self:RemoveUIListener(EventId.AllianceResourceUpdate, self.OnResUpdate)
  base.OnRemoveListener(self)
end

function UILWSeasonStoveCenterView:OnResUpdate()
  if self.txt_res ~= nil then
    local resStone = LuaEntry.Resource:GetCntByResType(ResourceType.AllianceStone)
    self.txt_res:SetText(string.GetFormattedStr(resStone))
  end
end

function UILWSeasonStoveCenterView:OnOpenUI(name)
  if name ~= UIWindowNames.UILWSeasonStoveCenter and self.effectRoot then
    self.effectRoot:SetActive(false)
  end
end

function UILWSeasonStoveCenterView:SetOnTop()
  if self.effectRoot then
    self.effectRoot:SetActive(true)
    self.s2_open:SetActive(false)
  end
end

function UILWSeasonStoveCenterView:ComponentDefine()
  self.effectRoot = self:AddComponent(UIImage, mask_partical_path)
  self.s2_open = self:AddComponent(UIBaseContainer, s2_open_path)
  self.build_icon = self:AddComponent(UIRawImage, build_icon_path)
  self.rt_image = self:AddComponent(StoveCenterModelViewer, rt_image_path)
  self.name = self:AddComponent(UITextMeshProUGUIEx, name_path)
  self.text_title = self:AddComponent(UIText, text_title_path)
  self.name:SetLocalText("season_s2_alliance_building_name01")
  self.text_title:SetLocalText("season_s2_alliance_building_name01")
  self.btn_back = self:AddComponent(UIButton, btn_back_path)
  self.btn_back:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.info_btn = self:AddComponent(UIButton, info_btn_path)
  self.info_btn:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonStoveCenterRule)
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
      local effectValue = DataCenter.LWSeasonTrendsManager:GetEffectValue(EffectDefine.LW_SEASON_STOVE_CENTER_OPEN)
      if effectValue == nil or effectValue == 0 then
        UIUtil.ShowTipsId(390994)
        return
      end
      self.effectRoot:SetActive(false)
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonStoveCondition, {anim = true}, BuildingTypes.SEASON_STOVE_CENTER)
    else
      UIUtil.ShowTipsId(803040)
    end
  end)
  self.hp_bar = self:AddComponent(UISlider, hp_bar_path)
  self.time_text = self:AddComponent(UITextMeshProUGUIEx, time_text_path)
  self.rank_root = self:AddComponent(UIButton, rank_root_path)
  self.rank_text = self:AddComponent(UITextMeshProUGUIEx, rank_text_path)
  self.stove_center_level = self:AddComponent(UILWSeasonStoveCenterItem, stove_center_level_path)
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
  self.rt_image:ReloadScene(self.build_icon)
  self.tab_item_work:SetOnValueChanged(function(tf)
    if tf then
      self:ToggleWork()
    end
  end)
  self.tab_item_level:SetOnValueChanged(function(tf)
    if tf then
      self:ToggleLevelUp()
    end
  end)
  self.tab_item_move:SetOnValueChanged(function(tf)
    if tf then
      self:ToggleMove()
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
  if Setting:GetPrivateInt("StoveCenterOpen", 0) == 1 then
    self.s2_open:SetActive(false)
  else
    self.s2_open:SetActive(true)
    Setting:SetPrivateInt("StoveCenterOpen", 1)
  end
  self.tab_item_work:SetIsOn(true)
  if self.tabWork == nil then
    self:ToggleWork()
  end
end

function UILWSeasonStoveCenterView:OnStoveCenterInfoUpdate()
  local resStone = LuaEntry.Resource:GetCntByResType(ResourceType.AllianceStone)
  local myAliRankIndex = toInt(DataCenter.SeasonFactionWarDataManager.myAliRankIndex)
  if myAliRankIndex == 0 then
    self.rank_text:SetText(Localization:GetString("2901004") .. [[

<size=32>No.100+</size>]])
  else
    self.rank_text:SetText(Localization:GetString("2901004") .. [[

<size=32>No.]] .. myAliRankIndex .. "</size>")
  end
  self.txt_res:SetText(string.GetFormattedStr(resStone))
  self.rank_root:SetActive(toInt(resStone) > 0)
  local product_value = 0
  local CrossOccupyCityList = DataCenter.SeasonDataManager.CrossOccupyCityList or {}
  local CrossOccupyStrongholdList = DataCenter.SeasonDataManager.CrossOccupyStrongholdList or {}
  local cityMeta
  for k, v in pairs(CrossOccupyCityList) do
    cityMeta = DataCenter.AllianceCityTemplateManager:GetTemplate(toInt(v.cityId), v.serverId)
    if cityMeta and cityMeta.season_snow_stone_value ~= 0 then
      product_value = product_value + toInt(cityMeta.season_snow_stone_value or 0)
    end
  end
  for k, v in pairs(CrossOccupyStrongholdList) do
    cityMeta = DataCenter.AllianceCityTemplateManager:GetTemplate(toInt(v.id), v.serverId)
    if cityMeta and cityMeta.season_snow_stone_value ~= 0 then
      product_value = product_value + toInt(cityMeta.season_snow_stone_value or 0)
    end
  end
  if 0 < product_value then
    self.tips_speed:SetActive(true)
    self.tips_speed:SetLocalText("390968", string.GetFormattedStr2(product_value))
  else
    self.tips_speed:SetActive(false)
  end
  local status = DataCenter.AllianceMineManager:GetAllianceStoveCenterStatus()
  if status then
    if status.state == 1 then
      if self.workState == 2 then
        self.rt_image:Play("LimitToWork")
      else
        self.rt_image:Play("NormalToWork")
      end
    elseif status.state == 2 then
      self.rt_image:Play("WorkToLimit")
    elseif self.workState == 2 then
      self.rt_image:Play("LimitToNormal")
    elseif self.workState == 1 then
      self.rt_image:Play("WorkToNormal")
    else
      self.rt_image:Play("Default")
    end
    self.workState = status.state
  else
    self.rt_image:Stop()
  end
end

function UILWSeasonStoveCenterView:ToggleWork()
  if self.tabWork == nil then
    self.tabWork = self:AddComponent(UILWSeasonStoveCenterPower, "Root/ScrollView/Viewport/Content/Work")
  end
  self.tabWork:UpdateData()
end

function UILWSeasonStoveCenterView:ToggleLevelUp()
  if self.tabLevel == nil then
    self.tabLevel = self:AddComponent(UILWSeasonStoveCenterItem, "Root/ScrollView/Viewport/Content/Level")
  end
  self.tabLevel:UpdateData()
end

function UILWSeasonStoveCenterView:ToggleMove()
  if self.tabCarrier == nil then
    self.tabCarrier = self:AddComponent(UILWSeasonStoveCenterMove, "Root/ScrollView/Viewport/Content/Move")
  end
  self.tabCarrier:UpdateData()
end

function UILWSeasonStoveCenterView:OnPointerClick(clickPos)
  if self.build_pos == nil then
    return
  end
  local linkId = self.build_pos:TryGetPointerClickLinkID(clickPos)
  if string.IsNullOrEmpty(linkId) then
    return
  end
  GoToUtil.TryJumpToWorld(rapidjson.decode(base64.decode(linkId)))
end

function UILWSeasonStoveCenterView:ComponentDestroy()
  self.s2_open = nil
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
  self.rt_image = nil
  self.effectRoot = nil
end

function UILWSeasonStoveCenterView:Update1000MS()
  if self.buildEndTime and self.buildEndTime > 0 then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local remainTime = self.buildEndTime - curTime
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

function UILWSeasonStoveCenterView:UpdateData()
  local theStoveCenter = DataCenter.AllianceMineManager:GetAllianceStoveCenter()
  self.theStoveCenter = theStoveCenter
  if theStoveCenter == nil or theStoveCenter.status == AllianceMineStatus.FoldUp then
    self.linkInfo = nil
    self.hp_bar:SetActive(false)
    self.btn_build:SetActive(true)
    self.time_text:SetText("")
    self.build_pos:SetActive(false)
    self.stove_center_level:SetActive(true)
    self.scroll_view:SetActive(false)
    self.buildEndTime = nil
    if theStoveCenter == nil then
      self.btn_txt:SetLocalText("110015")
    else
      self.btn_txt:SetLocalText("390451")
    end
    self.stove_center_level:UpdateData()
  else
    if theStoveCenter.status == AllianceMineStatus.Build then
      self.buildEndTime = theStoveCenter:GetBuildEndTime()
      self.isInjuried = false
      self.btn_build:SetActive(true)
      self.build_pos:SetActive(true)
      self.time_text:SetText("")
      self.hp_bar:SetActive(true)
      self.stove_center_level:SetActive(true)
      self.scroll_view:SetActive(false)
      self.btn_txt:SetLocalText("390210")
      self.stove_center_level:UpdateData()
    else
      DataCenter.AllianceMineManager:FetchFurnaceInfos()
      self.isInjuried = theStoveCenter:Injuried()
      self.hp_bar:SetActive(self.isInjuried)
      self.btn_build:SetActive(false)
      self.build_pos:SetActive(true)
      self.time_text:SetText("")
      self.btn_txt:SetLocalText("110015")
      self.stove_center_level:SetActive(false)
      self.scroll_view:SetActive(true)
      self.name:SetText("Lv." .. theStoveCenter.level .. " " .. Localization:GetString("season_s2_alliance_building_name01"))
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
  self:OnStoveCenterInfoUpdate()
end

return UILWSeasonStoveCenterView
