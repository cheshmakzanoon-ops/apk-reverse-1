local UIWorldSiegePointSeasonView = BaseClass("UIWorldSiegePointSeasonView", UIBaseView)
local base = UIBaseView
local ResourceManager = CS.GameEntry.Resource
local UIHeroTipView = require("UI.UIHero2.UIHeroTip.View.UIHeroTipView")
local SeasonFrozenStatus = require("UI.UIWorldPoint.Component.SeasonFrozenStatus")
local WorldHeadInfo = require("UI.UIWorldPoint.Component.WorldHeadInfo")
local UIWorldSiegePointBtn = require("UI.LWWorld.UIWorldSiegePointSeason.Component.UIWorldSiegePointBtn")
local UIWorldSiegePointInfo = require("UI.LWWorld.UIWorldSiegePointSeason.Component.UIWorldSiegePointInfo")
local Localization = CS.GameEntry.Localization
local BtnPosition = {}
BtnPosition[1] = {
  Vector3.New(0, -131.5, 0)
}
BtnPosition[2] = {
  Vector3.New(93.5, -124.5, 0),
  Vector3.New(-93.5, -124.5, 0)
}
BtnPosition[3] = {
  Vector3.New(178.5, -63.5, 0),
  Vector3.New(0, -131.5, 0),
  Vector3.New(-178.5, -63.5, 0)
}
BtnPosition[4] = {
  Vector3.New(241.5, -6.5, 0),
  Vector3.New(93.5, -124.5, 0),
  Vector3.New(-93.5, -124.5, 0),
  Vector3.New(-241.5, -6.5, 0)
}
BtnPosition[5] = {
  Vector3.New(297.5, 92.5, 0),
  Vector3.New(178.5, -63.5, 0),
  Vector3.New(0, -131.5, 0),
  Vector3.New(-178.5, -63.5, 0),
  Vector3.New(-297.5, 92.5, 0)
}
local BtnCellCircle = Vector3.New(0, 120, 0)
local pos_go_path = "PosGo"
local build_btn_go_path = "PosGo/BuildBtnScale/BuildBtnGo"
local build_btn_obj_path = "PosGo/BuildBtnScale"
local this_path = ""
local point_obj_path = "PosGo/message/bg/layout"
local bg_path = "PosGo/message/bg"
local message_path = "PosGo/message"
local levelBg_path = "PosGo/message/bg/Top/Title/levelBg"
local common_btn_detail_path = "PosGo/message/bg/Top/Title/btn_detail/Common_btn_detail"
local btn_return_path = "PosGo/message/bg/Top/Title/btn_return"
local btn_detail_path = "PosGo/message/bg/Top/Title/btn_detail"
local owner_name_text_path = "PosGo/message/bg/Top/Title/NameText"
local virus_bg_path = "PosGo/message/bg/Top/Title/VirusBg"
local virus_text_path = "PosGo/message/bg/Top/Title/VirusBg/VirusText"
local the_name_root_path = "PosGo/message/bg/Top/NameRoot"
local the_name_text_path = "PosGo/message/bg/Top/NameRoot/TheNameText"
local city_value_text_path = "PosGo/message/bg/Top/NameRoot/CityValueText"
local city_value_btn_path = "PosGo/message/bg/Top/NameRoot/CityValueText/CityValueBtn"
local btns_path = "PosGo/message/bg/Top/btns"
local btn_king_path = "PosGo/message/bg/Top/btns/Btn_King"
local btn_alliance_share_path = "PosGo/message/bg/Top/btns/Btn_alliance_share"
local btn_share_path = "PosGo/message/bg/Top/btns/Btn_share"
local btn_mark_path = "PosGo/message/bg/Top/btns/Btn_mark"
local bg_missile_factory_path = "PosGo/message/bg/Top/bgMissileFactory"
local bg_bank_path = "PosGo/message/bg/Top/bgBank"
local bg_top_path = "PosGo/message/bg/Top/bgTop"
local btn_alliance_cityrally_path = "PosGo/message/bg/Top/btns/Btn_alliance_cityrally"
local season_title_path = "PosGo/message/bg/SeasonTitle"
local season_frozen_tips_path = "PosGo/message/bg/layout/BuildInfo/seasonFrozenTips"
local temperature_path = "PosGo/message/bg/layout/BuildInfo/temperature"
local temperature_btn_path = "PosGo/message/bg/layout/BuildInfo/temperature/bg/temperatureBtn"
local temperature_txt_path = "PosGo/message/bg/layout/BuildInfo/temperature/temperatureTxt"
local res_product_path = "PosGo/message/bg/layout/BuildInfo/resProduct"
local res_product_btn_path = "PosGo/message/bg/layout/BuildInfo/resProduct/bg/resProductBtn"
local res_product_icon_path = "PosGo/message/bg/layout/BuildInfo/resProduct/resProductIcon"
local res_product_txt_path = "PosGo/message/bg/layout/BuildInfo/resProduct/resProductTxt"
local res_product2_path = "PosGo/message/bg/layout/BuildInfo/resProduct2"
local res_product_btn2_path = "PosGo/message/bg/layout/BuildInfo/resProduct2/bg/resProductBtn2"
local res_product_icon2_path = "PosGo/message/bg/layout/BuildInfo/resProduct2/resProductIcon2"
local res_product_txt2_path = "PosGo/message/bg/layout/BuildInfo/resProduct2/resProductTxt2"
local supplies_info_path = "PosGo/message/bg/layout/BuildInfo/suppliesInfo"
local supplies_info_btn_path = "PosGo/message/bg/layout/BuildInfo/suppliesInfo/bg/suppliesInfoBtn"
local supplies_info_txt_path = "PosGo/message/bg/layout/BuildInfo/suppliesInfo/suppliesInfoTxt"
local refresh_btn_path = "PosGo/BuildBtnScale/BuildBtnGo/RefreshBtn"
local six_build_btn_path = "PosGo/BuildBtnScale/BuildBtnGo/SixBuildBtn"
local p_comp_alliance_war_time_path = "PosGo/message/bg/layout/p_comp_alliance_war_time"
local p_img_bg_alliance_war_time_path = "PosGo/message/bg/layout/p_comp_alliance_war_time/p_img_bg_alliance_war_time"
local SeasonAllianceWarTimeBuildingState = require("UI/LWWorld/UIWorldSiegePointSeason/Component/SeasonAllianceWarTimeBuildingState")
local __MaxBtnCount = #BtnPosition

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.levelBg = self:AddComponent(UIImage, levelBg_path)
  self.common_btn_detail = self:AddComponent(UIImage, common_btn_detail_path)
  self.bg = self:AddComponent(UIBaseComponent, bg_path)
  self.message = self:AddComponent(UIBaseComponent, message_path)
  self.pos_go = self:AddComponent(UIBaseContainer, pos_go_path)
  self.owner_name_text = self:AddComponent(UIText, owner_name_text_path)
  self.virus_bg = self:AddComponent(UIButton, virus_bg_path)
  self.virus_bg:SetOnClick(function()
    local pointInfo = CS.SceneManager.World:GetPointInfo(self.ctrl.pointId)
    if pointInfo and pointInfo.GetStatusByType then
      local status = pointInfo:GetStatusByType(AllianceCityVirusType)
      if not status then
        return
      end
      local temp = DataCenter.StatusManager:GetTemplate(tostring(status.Id))
      if temp then
        local txt = Localization:GetString(temp.info)
        UIUtil.ShowBubbleTips(txt, self.virus_bg.transform.position, 0, -40, 0)
      end
    end
  end)
  self.virus_text = self:AddComponent(UITextMeshProUGUIEx, virus_text_path)
  self.the_name_root = self:AddComponent(UIText, the_name_root_path)
  self.the_name_text = self:AddComponent(UITextMeshProUGUIEx, the_name_text_path)
  if self.the_name_text.OnPointerClick and self.the_name_text.SetRaycastTarget then
    self.the_name_text:OnPointerClick(function(eventData)
      self:OnOwnerNameLinkClicked(eventData)
    end)
  end
  self.city_value_text = self:AddComponent(UIText, city_value_text_path)
  self.build_btn_go = self:AddComponent(UIBaseContainer, build_btn_go_path)
  self.build_btn_obj = self:AddComponent(UIBaseContainer, build_btn_obj_path)
  self.this_anim = self:AddComponent(UIAnimator, this_path)
  self.build_btn_anim = self:AddComponent(UIAnimator, build_btn_go_path)
  self.point_obj = self:AddComponent(UIWorldSiegePointInfo, point_obj_path)
  self.btn_king = self:AddComponent(UIButton, btn_king_path)
  self.supplies_info = self:AddComponent(UIBaseContainer, supplies_info_path)
  self.supplies_info_btn = self:AddComponent(UIButton, supplies_info_btn_path)
  self.supplies_info_txt = self:AddComponent(UITextMeshProUGUIEx, supplies_info_txt_path)
  self.supplies_info:SetActive(false)
  self.supplies_info_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    local selfCity = self.info.isInAlliance and self.info.allianceId == LuaEntry.Player:GetAllianceUid()
    local scaleFactor = UIManager:GetInstance():GetScaleFactor()
    local position = self.supplies_info_btn.transform.position + Vector3.New(25, -30, 0) * scaleFactor
    local param = UIHeroTipView.Param.New()
    param.content = selfCity and Localization:GetString("season_s2_ice_supplies_7") or Localization:GetString("season_s2_ice_supplies_8")
    param.dir = UIHeroTipView.Direction.BELOW
    param.defWidth = 180
    param.pivot = 0.5
    param.position = position
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, {anim = false}, param)
  end)
  self.btn_king:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnKingClick()
  end)
  self.btn_mark = self:AddComponent(UIButton, btn_mark_path)
  self.btn_mark:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnMarkClick()
  end)
  self.btnMarkImg = self:AddComponent(UIImage, btn_mark_path)
  self.btn_share = self:AddComponent(UIButton, btn_share_path)
  self.btn_share:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnShareClick()
  end)
  self.btn_alliance_share = self:AddComponent(UIButton, btn_alliance_share_path)
  self.btn_alliance_share:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnMarkClick(true)
  end)
  self.btn_alliance_cityrally = self:AddComponent(UIButton, btn_alliance_cityrally_path)
  self.btn_alliance_cityrally:SetActive(false)
  self.btn_alliance_cityrally:SetOnClick(function()
    DataCenter.AllianceBaseDataManager:TrySetRally(self.info.pointId, self.info.serverId)
  end)
  self.btn_detail = self:AddComponent(UIButton, btn_detail_path)
  self.btn_detail:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnDetailClick()
  end)
  self.btn_detail:SetActive(true)
  self.btn_return = self:AddComponent(UIButton, btn_return_path)
  self.btn_return:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnReturnClick()
  end)
  self.btn_return:SetActive(false)
  self.AutoAdjustScreenPos = self.transform:Find(pos_go_path):GetComponent(typeof(CS.AutoAdjustScreenPos))
  self.model = {}
  self.refreshSlider = false
  self.season_title = self:AddComponent(WorldHeadInfo, season_title_path)
  self.nonSeasonBtnList = self:AddComponent(UIBaseContainer, btns_path)
  self.season_title:SetActive(false)
  self.nonSeasonBtnList:SetActive(true)
  self.season_frozen_tips = self:AddComponent(SeasonFrozenStatus, season_frozen_tips_path)
  self.season_frozen_tips:SetActive(false)
  self.temperature = self:AddComponent(UIBaseContainer, temperature_path)
  self.temperature_btn = self:AddComponent(UIButton, temperature_btn_path)
  self.temperature_txt = self:AddComponent(UITextMeshProUGUIEx, temperature_txt_path)
  self.temperature:SetActive(false)
  self.temperature_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    UIUtil.ShowDetail(Localization:GetString("season_s2_city_active_info"))
  end)
  self.res_product = self:AddComponent(UIBaseContainer, res_product_path)
  self.res_product_btn = self:AddComponent(UIButton, res_product_btn_path)
  self.res_product_icon = self:AddComponent(UIImage, res_product_icon_path)
  self.res_product_txt = self:AddComponent(UITextMeshProUGUIEx, res_product_txt_path)
  self.res_product_btn:SetOnClick(function()
    local param = {}
    param.type = "desc"
    param.title = ""
    param.desc = "season_s2_city_tips01"
    param.alignObject = self.res_product_btn
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
  end)
  self.res_product:SetActive(false)
  self.res_product2 = self:AddComponent(UIBaseContainer, res_product2_path)
  self.res_product_btn2 = self:AddComponent(UIButton, res_product_btn2_path)
  self.res_product_icon2 = self:AddComponent(UIImage, res_product_icon2_path)
  self.res_product_txt2 = self:AddComponent(UITextMeshProUGUIEx, res_product_txt2_path)
  self.res_product_btn2:SetOnClick(function()
    local param = {}
    param.type = "desc"
    param.title = ""
    param.desc = "season_s2_stronghold_tips01"
    param.alignObject = self.res_product_btn2
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
  end)
  self.res_product2:SetActive(false)
  self.refresh_btn = self:AddComponent(UIButton, refresh_btn_path)
  self.refresh_btn:LoadSpriteAuto("Assets/Main/Sprites/UI/UIBuildBtns/mjc_zhujiemian_qiehuan.png")
  self.refresh_btn:SetActive(false)
  self.refresh_btn:SetOnClick(function()
    self.pos_go:SetActive(false)
    if self.buttonAroundPlane == nil then
      local luaPath = "UI.UIWorldPoint.Component.WorldButtonAroundPlane"
      local prefabPath = "Assets/Main/Prefabs/UI/World/UIWorldPointComponent/ButtonAroundPlane.prefab"
      self.buttonAroundPlane = self:LoadComponentAsync(luaPath, prefabPath, self)
      self.buttonAroundPlane:SetData(self.info, self.ctrl.pointId, UIWorldSiegePointBtn)
    else
      self.buttonAroundPlane:ShowMe(self.info, self.ctrl.pointId, UIWorldSiegePointBtn)
    end
  end)
  self.six_build_btn = self:AddComponent(UIWorldSiegePointBtn, six_build_btn_path)
  self.six_build_btn:SetActive(false)
  self.bg_top = self:AddComponent(UIRawImage, bg_top_path)
  self.bg_top:SetActive(false)
  self.bg_missile_factory = self:AddComponent(UIRawImage, bg_missile_factory_path)
  self.bg_missile_factory:SetActive(false)
  self.p_img_bg_alliance_war_time = self:AddComponent(UIImage, p_img_bg_alliance_war_time_path)
  self.p_comp_alliance_war_time = self:AddComponent(SeasonAllianceWarTimeBuildingState, p_comp_alliance_war_time_path)
  self.p_comp_alliance_war_time:SetActive(false)
  self.bg_bank = self:AddComponent(UIRawImage, bg_bank_path)
  self.bg_bank:SetActive(false)
end

local function ComponentDestroy(self)
  self:SetAllCellDestroy()
  if self.delayAutoFitUI then
    self.delayAutoFitUI:Stop()
    self.delayAutoFitUI = nil
  end
  self.bg_top = nil
  self.bg_missile_factory = nil
  self.refresh_btn = nil
  self.pos_go = nil
  self.name_text = nil
  self.build_btn_go = nil
  self.this_anim = nil
  self.build_btn_anim = nil
  self.btn_mark = nil
  self.btn_share = nil
  self.btn_detail = nil
  self.btn_return = nil
  self.AutoAdjustScreenPos = nil
  self.model = nil
  self.refreshSlider = nil
  self.the_name_text = nil
  self.season_frozen_tips = nil
  self.temperature = nil
  self.temperature_btn = nil
  self.temperature_txt = nil
  self.res_product = nil
  self.res_product_btn = nil
  self.res_product_icon = nil
  self.res_product_txt = nil
  self.supplies_info = nil
  self.supplies_info_btn = nil
  self.supplies_info_txt = nil
  self.btn_alliance_cityrally = nil
  self.p_comp_alliance_war_time = nil
end

local function DataDefine(self)
  self.worldPos = nil
  self.buildBtnCells = {}
end

local function DataDestroy(self)
  self.worldPos = nil
  self.buildBtnCells = nil
end

local function OnEnable(self)
  base.OnEnable(self)
  self.ctrl:InitData(self:GetUserData())
  self:ReInit()
end

local function OnDisable(self)
  AllianceBuildBloodManager:GetInstance():OnCloseAllianceCity(self.info.uuid)
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.WorldAllianceCityDetail, self.SetData)
  self:AddUIListener(EventId.ChangeCameraLod, self.UpdateLod)
  self:AddUIListener(EventId.RefreshBookmark, self.RefreshMarkList)
  self:AddUIListener(EventId.GetTradeDetail, self.SetDataTrade)
  self:AddUIListener(EventId.WorldSiegePointBtnRefresh, self.WorldSiegePointBtnRefresh)
  self:AddUIListener(EventId.UPDATE_CITY_POINTS_DATA, self.WorldSiegePointBtnRefresh)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.WorldAllianceCityDetail, self.SetData)
  self:RemoveUIListener(EventId.ChangeCameraLod, self.UpdateLod)
  self:RemoveUIListener(EventId.RefreshBookmark, self.RefreshMarkList)
  self:RemoveUIListener(EventId.GetTradeDetail, self.SetDataTrade)
  self:RemoveUIListener(EventId.WorldSiegePointBtnRefresh, self.WorldSiegePointBtnRefresh)
  self:RemoveUIListener(EventId.UPDATE_CITY_POINTS_DATA, self.WorldSiegePointBtnRefresh)
end

function UIWorldSiegePointSeasonView:CityDestroyED()
  if not self.info then
    return
  end
  return self.info.state == AllianceCityState.DESTROY
end

local function ReInit(self)
  if self.buttonAroundPlane ~= nil then
    self.buttonAroundPlane:SetActive(false)
  end
  self.pos_go:SetActive(true)
  self.info = self.ctrl:GetAllianceCityData(self.ctrl.cityId)
  self.virus_bg:SetActive(false)
  self.p_comp_alliance_war_time:SetActive(false)
  if self.info ~= nil then
    self:JumpTo()
    self.point_obj:InitData(self.info)
    local pointInfo = CS.SceneManager.World:GetPointInfo(self.ctrl.pointId)
    if pointInfo then
      local layer = pointInfo:GetCityVirusLayer()
      if 0 < layer then
        self.virus_bg:SetActive(true)
        self.virus_text:SetText(tostring(layer))
      end
    end
    self.p_img_bg_alliance_war_time:SetColorRGBA(0.94, 0.93, 0.92, 1)
    self.levelBg:SetActive(true)
    self.nonSeasonBtnList:SetAnchoredPositionXY(538, -38)
    if self.info.type == WorldAllianceCityType.Mountain then
      self.levelBg:LoadSprite("Assets/Main/Sprites/pve/cfm_tongyong_erji_dichen_yuanjiao_4.png")
      self.common_btn_detail:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/FX_common_xiangqing.png")
    elseif SeasonUtil.GetSeasonSubdivisionType(nil, ServerEnum.View) == SeasonMapType.NineNationRainforest and self.info.type == WorldAllianceCityType.Stronghold then
      self.levelBg:SetActive(false)
      self.common_btn_detail:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/zxl_tongyong_xiangqing_hei.png")
      self.p_img_bg_alliance_war_time:SetColorRGBA(0.87, 0.94, 0.79, 1)
      self.nonSeasonBtnList:SetAnchoredPositionXY(538, 72)
    else
      self.levelBg:LoadSprite("Assets/Main/Sprites/UI/UISeason/Sprites/CityPopup/Mjc_saijijianzhu_bg_04.png")
      self.common_btn_detail:LoadSprite("Assets/Main/Sprites/UI/UILWBuild/dl_tongyong_inf.png")
    end
    if (self.info.state == AllianceCityState.NEUTRAL or self.info.state == AllianceCityState.SERVER_NEUTRAL) and self.info.type ~= WorldAllianceCityType.Canon and self.info.type ~= WorldAllianceCityType.MissileFactory and self.info.type ~= WorldAllianceCityType.CrossZoneOutpostCanon then
      if pointInfo ~= nil then
        self.season_frozen_tips:Refresh(WorldPointUIType.AllianceCity, pointInfo.thermalConductor, self.info.type, self.ctrl.uuid)
      end
      self.temperature:SetActive(false)
    else
      self.season_frozen_tips:SetActive(false)
      if self.info.temperatureCfg ~= nil and self.info.temperatureCfg.active_temperature_original ~= 0 and self.info.type == WorldAllianceCityType.City then
        local tmp = self.info.temperatureCfg.active_temperature_original
        self.temperature:SetActive(true)
        self.temperature_txt:SetText(Localization:GetString("season_s2_city_open_info") .. " +" .. tmp .. "\194\176C")
      else
        self.temperature:SetActive(false)
      end
    end
    local dataConfig = self.info.meta
    if dataConfig ~= nil then
      local curServerId = LuaEntry.Player:GetCurServerId()
      local seasonInfo = SeasonUtil.GetSeasonInfo(curServerId)
      if seasonInfo:GetServerType(false) == SeasonMapType.NineNation then
        local itemProductId = dataConfig.itemProductId
        local itemProductCount = dataConfig.itemProductCount
        if itemProductId and itemProductCount then
          local meta = DataCenter.ItemTemplateManager:TryGetItemTemplate(itemProductId)
          if meta and not self:CityDestroyED() then
            local seasonIndex = toInt(seasonInfo.seasonId)
            local icon, name, desc, name_value = meta:GetDetailInfo(seasonIndex)
            local iconUrl = string.format(LoadPath.ItemPath, icon)
            self.res_product:SetActive(true)
            self.res_product_icon:LoadSprite(iconUrl)
            self.res_product_txt:SetText("+" .. string.GetFormattedSeparatorNum(itemProductCount) .. "/h")
            self.res_product_btn:SetActive(SeasonMapType.NineNation == SeasonUtil.GetSeasonType())
          end
        else
          self.res_product:SetActive(false)
        end
        local res_speed = dataConfig:GetResourceProductCount(ResourceType.FLINT)
        if res_speed ~= 0 then
          self.res_product2:SetActive(true)
          self.res_product_txt2:SetText("+" .. string.GetFormattedSeparatorNum(res_speed) .. "/h")
          self.res_product_icon2:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(ResourceType.FLINT, nil, SeasonMapType.NineNation))
          self.res_product_btn2:SetActive(true)
        else
          self.res_product2:SetActive(false)
        end
      else
        local seasonType = SeasonUtil.GetCurWorldSeasonType(true)
        local showBtn = LuaEntry.Player:IsInSelfServer() or seasonType == SeasonUtil.GetSeasonType()
        if self.info.season_snow_stone_value ~= 0 and not self:CityDestroyED() then
          self.res_product:SetActive(true)
          self.res_product_txt:SetText("+" .. string.GetFormattedSeparatorNum(self.info.season_snow_stone_value) .. "/h")
          self.res_product_icon:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(ResourceType.AllianceStone, nil, seasonType))
          self.res_product_btn:SetActive(showBtn)
        else
          self.res_product:SetActive(false)
        end
        local res_speed = self.info.meta:GetResourceProductCount(ResourceType.FLINT)
        if res_speed ~= 0 then
          self.res_product2:SetActive(true)
          self.res_product_txt2:SetText("+" .. string.GetFormattedSeparatorNum(res_speed) .. "/h")
          self.res_product_icon2:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(ResourceType.FLINT, nil, seasonType))
          self.res_product_btn2:SetActive(showBtn)
        else
          self.res_product2:SetActive(false)
        end
      end
    else
      self.res_product2:SetActive(false)
      self.res_product:SetActive(false)
    end
    local nameTextRaycastEnable = false
    if self.info.type == WorldAllianceCityType.Canon or self.info.type == WorldAllianceCityType.MissileFactory or self.info.type == WorldAllianceCityType.CrossZoneOutpostCanon then
      if string.IsNullOrEmpty(self.info.userName) then
        self.owner_name_text:SetText(Localization:GetString(self.info.name))
      else
        self.owner_name_text:SetText(self.info.userName)
      end
      self.the_name_root:SetActive(false)
    elseif string.IsNullOrEmpty(self.info.userName) then
      self.the_name_root:SetActive(true)
      self.owner_name_text:SetText(Localization:GetString("140205", self.info.level, ""))
      local alAbbr = self.info.alAbbr
      if alAbbr == nil or alAbbr == "" then
        self.the_name_text:SetText(Localization:GetString(self.info.name))
      else
        local owner = UIUtil.FormatServerAllianceName(self.info.ownerServerId, self.info.alAbbr)
        local ownerLink = string.format("<link=%s><u>%s</u></link>", tostring(self.info.allianceId), owner .. Localization:GetString(self.info.name))
        self.the_name_text:SetText(ownerLink)
        nameTextRaycastEnable = true
      end
    else
      self.the_name_root:SetActive(true)
      self.owner_name_text:SetText(Localization:GetString("140205", self.info.level, ""))
      self.the_name_text:SetText(self.info.userName)
    end
    self.the_name_text:SetRaycastTarget(nameTextRaycastEnable)
    if self.ctrl.seasonType == SeasonMapType.NineNationRainforest then
      if self.info.destroyServerId ~= nil and self.info.isKingCity then
        self.the_name_text:SetText(Localization:GetString("season_s6_activity_1200116_desc06"))
      elseif self:CityDestroyED() then
        self.the_name_text:SetText(Localization:GetString("season_s6_activity_1200112_desc28"))
      end
    end
    local ServerType = SeasonUtil.CurServerTypeInSeason()
    if ServerType == SeasonMapType.Snow then
      local tData = DataCenter.WorldAllianceCityDataManager:GetCitySuppliesNum(self.ctrl.cityId)
      local flag = true
      if self.info.type == WorldAllianceCityType.City then
        flag = true
      elseif self.info.type == WorldAllianceCityType.Stronghold then
        local seasonConfig = DataCenter.SeasonDataManager:GetServerCurrentSeasonConfig()
        if seasonConfig then
          local t = string.split(seasonConfig.lw_supplies_refresh, "|")
          if t and 4 < #t and t[5] == "0" then
            flag = false
          end
        end
      end
      if flag and not DataCenter.ActivityListDataManager:IsActivityOpen(EnumActivity.SeasonSuppliesShare.Type) then
        flag = false
      end
      local selfCity = self.info.isInAlliance and self.info.allianceId == LuaEntry.Player:GetAllianceUid()
      if flag then
        self.supplies_info:SetActive(true)
        local num
        if selfCity then
          num = tostring(tData)
        else
          num = "???"
        end
        self.supplies_info_txt:SetText(num)
      else
        self.supplies_info:SetActive(false)
      end
    else
      self.supplies_info:SetActive(false)
    end
    self.btn_king:SetActive(false)
    self.btn_alliance_share:SetActive(LuaEntry.Player:IsInAlliance())
    self:RefreshMarkBtnImg()
    self:ShowBtn()
    self:SetData()
    self:AutoFitUI(5)
  end
end

function UIWorldSiegePointSeasonView:JumpTo(force_)
  if self.worldPos and not force_ then
    return
  end
  local mainCamera = CS.SceneManager.World.Camera
  local worldPos1 = mainCamera:GetRaycastGroundPoint(Vector3.New(Screen.width * 0.5, Screen.height * 0.5, 0))
  local worldPos2 = mainCamera:GetRaycastGroundPoint(Vector3.New(Screen.width * 0.5, Screen.height * 0.25, 0))
  local worldPos = SceneUtils.TileIndexToWorld(self.ctrl.pointId)
  local offset = worldPos1.z - worldPos2.z
  if self.info.type == WorldAllianceCityType.Canon or self.info.type == WorldAllianceCityType.MissileFactory or self.info.type == WorldAllianceCityType.King then
    offset = offset - 3 * TileSize
  end
  worldPos.z = math.min(worldPos.z + offset, 1999.9)
  GoToUtil.GotoPos(worldPos, CS.SceneManager.World.Zoom, LookAtFocusTime, function()
  end, self.info.serverId)
  self.worldPos = worldPos
  self.AutoAdjustScreenPos:Init(worldPos + Vector3.New(0, 0, TileSize - offset))
end

function UIWorldSiegePointSeasonView:AutoFitUI(delay_time)
  if self.delayAutoFitUI then
    self.delayAutoFitUI:Stop()
  end
end

function UIWorldSiegePointSeasonView:ReAutoFitUI()
end

local function RefreshMarkList(self)
  self:RefreshMarkBtnImg()
end

local function RefreshMarkBtnImg(self)
  local realPoint = self.ctrl.pointId * 10 + 1
  local favorData = DataCenter.WorldFavoDataManager:GetBookmark(realPoint, LuaEntry.Player:GetCurServerId(), true)
  if favorData then
    self.btnMarkImg:LoadSprite("Assets/Main/Sprites/UI/UILWBuild/dl_daditu_yishoucang.png")
  else
    self.btnMarkImg:LoadSprite("Assets/Main/Sprites/UI/UILWBuild/dl_daditu_shoucang.png")
  end
end

local function SetData(self)
  local hasGhostBoss = false
  local seasonType = SeasonUtil.GetSeasonSubdivisionType(nil, ServerEnum.View)
  local serverData = self.ctrl:GetAllianceCityDetail(self.ctrl.cityId, self.ctrl.worldCityType)
  self.hasGhostBoss = false
  if serverData ~= nil then
    self.serverData = serverData
    self.point_obj:RefreshData(serverData, self.ctrl.worldCityType)
    if seasonType == SeasonMapType.Darkness and serverData.hasGhost and string.IsNullOrEmpty(self.info.allianceId) and DataCenter.BloodyNightDataManager:IsBloodyNight() then
      hasGhostBoss = true
      self.season_title:SetActive(false)
      self.nonSeasonBtnList:SetActive(true)
      self.bg_top:SetActive(true)
      self.bg_top:LoadSprite("Assets/Main/SeasonRes/S4/Textures/WorldUI/zyf_S4_xuegui_qipaobanshen.png")
      self.hasGhostBoss = true
      pcall(self.AutoFitUI, self, 0.1)
    end
    if self.info.type == WorldAllianceCityType.Canon or self.info.type == WorldAllianceCityType.CrossZoneOutpostCanon or self.info.type == WorldAllianceCityType.MissileFactory then
      self.season_title:SetActive(false)
      self.nonSeasonBtnList:SetActive(true)
      if self.info.type == WorldAllianceCityType.MissileFactory then
        self.bg_missile_factory:LoadSprite("Assets/Main/TextureEx/Season/FactionDeclareWar/mjc_guanzhijineng_zhanshen_bg01.png")
        self.bg_missile_factory:SetActive(true)
      end
      return
    end
    if self.info.meta:IsBank() then
      hasGhostBoss = true
      self.season_title:SetActive(false)
      self.nonSeasonBtnList:SetActive(true)
      local pic = self.info.meta:getValue("pop_pic")
      if string.IsNullOrEmpty(pic) then
        self.bg_bank:SetActive(false)
      else
        self.bg_bank:SetActive(true)
        self.bg_bank:LoadSpriteAsync(pic)
        self.bg_bank:SetSizeDeltaX(557)
        self.bg_bank:SetAnchoredPositionXY(0, 150)
      end
    elseif seasonType == SeasonMapType.NineNationRainforest and self.info.type == WorldAllianceCityType.Stronghold then
      hasGhostBoss = true
      self.season_title:SetActive(false)
      self.nonSeasonBtnList:SetActive(true)
      self.bg_bank:SetActive(true)
      self.bg_bank:LoadSpriteAsync("Assets/Main/SeasonRes/S6/Textures/Fishing/mjc_s6_judian_bg_banner.png")
      self.bg_bank:SetSizeDeltaX(544.8)
      self.bg_bank:SetAnchoredPositionXY(0, 250)
    else
      self.bg_bank:SetActive(false)
    end
    if seasonType == SeasonMapType.Snow then
      self.season_title:SetActive(false)
      self.nonSeasonBtnList:SetActive(true)
      return
    end
    if not hasGhostBoss and (self.info.state == AllianceCityState.NEUTRAL or self.info.state == AllianceCityState.SERVER_NEUTRAL or self.info.state == AllianceCityState.DESTROY) then
      self.season_title:SetActive(true)
      self.nonSeasonBtnList:SetActive(false)
      local param = {
        cityId = self.ctrl.cityId
      }
      if not string.IsNullOrEmpty(self.info.avatar_big) then
        param.appearanceId = self.info.avatar_big
      end
      
      function param.share()
        DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
        self:OnShareClick()
      end
      
      function param.mark()
        DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
        self:OnMarkClick()
      end
      
      if LuaEntry.Player:IsInAlliance() then
        function param.allianceShare()
          DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
          
          self:OnMarkClick(true)
        end
      end
      local cityTemplate = DataCenter.AllianceCityTemplateManager:GetTemplate(self.ctrl.cityId, LuaEntry.Player:GetCurServerId())
      local city_bubble_icon = cityTemplate and cityTemplate.city_bubble_icon
      local city_bubble_banner = cityTemplate and cityTemplate.city_bubble_banner
      if not string.IsNullOrEmpty(city_bubble_icon) then
        param.overrideIconPath = city_bubble_icon
      end
      param.isShowIcon = serverData.type ~= WorldAllianceCityType.TradingStation
      param.citType = self.info.type
      if not string.IsNullOrEmpty(city_bubble_banner) then
        param.lordBannerPath = city_bubble_banner
        param.banner2SizeDeltaXY = {x = 533, y = 214}
      else
        param.lordBannerPath = cityTemplate:getValue("pop_pic")
      end
      param.pointId = self.info.pointId
      param.showAlliance = DataCenter.AllianceBaseDataManager:CanSetAllianceCityRallyBySiegePoint(self.info)
      param.serverId = self.info.serverId
      if self.info.state == AllianceCityState.DESTROY and serverData and serverData.ruinObj and serverData.ruinObj.currOwnerCampId then
        local campId = serverData.ruinObj.currOwnerCampId
        param.overrideIconPath = SeasonUtil.GetSeason6CampMidIconPath(campId)
        param.overrideSpinePath = SeasonUtil.GetSeason6CampCityAvatarPrefabPath(campId)
      end
      self.season_title:RefreshData(param)
    else
      self.season_title:SetActive(false)
      self.nonSeasonBtnList:SetActive(true)
    end
    if serverData.cityBattleS1RestInfo and serverData.cityBattleS1RestInfo.status ~= RecaptureActCityBattleCityStatus.MONSTER_OCCUPIED then
      self.season_title:SetActive(false)
      self.nonSeasonBtnList:SetActive(true)
    end
    self:RefreshAllianceWarTime(serverData)
  end
  self:RefreshCityValue(serverData)
end

local function SetDataTrade(self, tradeData)
  self:SetData()
  self.serverData = tradeData
  self.point_obj:RefreshSuppliesNum(tradeData)
  self.point_obj:RefreshAssistance(tradeData)
end

local function SetAllCellDestroy(self)
  self.build_btn_go:RemoveComponents(UIWorldSiegePointBtn)
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.model = {}
end

local function ShowBtn(self)
  if self.buttonAroundPlane ~= nil then
    self.buttonAroundPlane:SetActive(false)
  end
  self.btnList = self.info.btnList
  self.btnCount = self.btnList and #self.btnList or 0
  self.btn_alliance_cityrally:SetActive(DataCenter.AllianceBaseDataManager:CanSetAllianceCityRallyBySiegePoint(self.info))
  if self.btnCount > 0 then
    self.refresh_btn:SetActive(self.btnCount > __MaxBtnCount)
    self.build_btn_obj:SetActive(true)
    local fiveBtnList = UIUtil.GetBtnShown(self.btnList, __MaxBtnCount)
    local theBtnCount = #fiveBtnList
    if not self.info.skipBtnSort then
      table.sort(fiveBtnList, function(a, b)
        return b < a
      end)
    end
    for k, v in ipairs(fiveBtnList) do
      local param = {}
      param.index = k
      param.btnType = v
      param.info = self.info
      local index = CommonUtil.IsArabicAutoMirrorOpen() and theBtnCount - k + 1 or k
      param.position = BtnPosition[theBtnCount][index] - BtnCellCircle
      if self.buildBtnCells[k] ~= nil then
        self.buildBtnCells[k]:SetActive(false)
        self.buildBtnCells[k]:ReInit(param)
        self.buildBtnCells[k]:SetActive(true)
      else
        if self.model[k] ~= nil then
          self:GameObjectDestroy(self.model[k])
          self.model[k] = nil
        end
        self.model[k] = self:GameObjectInstantiateAsync(UIAssets.UIWorldTileBuildBtn, function(request)
          if request.isError then
            return
          end
          local go = request.gameObject
          local transform = go.transform
          go:SetActive(true)
          transform:SetParent(self.build_btn_go.transform)
          transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
          transform.localPosition = BtnCellCircle
          local nameStr = tostring(param.index)
          go.name = nameStr
          self.buildBtnCells[param.index] = self.build_btn_go:AddComponent(UIWorldSiegePointBtn, nameStr)
          self.buildBtnCells[param.index]:ReInit(param)
        end)
      end
    end
    for i = theBtnCount + 1, __MaxBtnCount do
      if self.buildBtnCells[i] ~= nil then
        self.buildBtnCells[i]:SetActive(false)
      elseif self.model[i] ~= nil then
        self:GameObjectDestroy(self.model[i])
        self.model[i] = nil
      end
    end
  else
    self.refresh_btn:SetActive(false)
    self.build_btn_obj:SetActive(false)
  end
end

local function OnMarkClick(self, isAlliance)
  local panelType = MarkGroup.Personal
  if isAlliance then
    panelType = MarkGroup.Alliance
  end
  if self.info ~= nil then
    local name = ""
    if self.info.userName ~= nil and self.info.userName ~= "" then
      name = self.info.userName
    else
      name = self.info.name
    end
    if not string.IsNullOrEmpty(self.info.alAbbr) then
      name = "[" .. self.info.alAbbr .. "]" .. Localization:GetString(name)
    end
    local realPoint = self.ctrl.pointId * 10 + 1
    local level = self.info.level
    if self.info.type == WorldAllianceCityType.Canon or self.info.type == WorldAllianceCityType.CrossZoneOutpostCanon or self.info.type == WorldAllianceCityType.MissileFactory then
      level = nil
    end
    self.ctrl:OnMarkClick(LuaEntry.Player:GetCurServerId(), realPoint, name, level, panelType)
  end
end

local function OnShareClick(self, isAlliance)
  if CoppaUtil.IsCoppaLimitWithTips() then
    return
  end
  if self.info ~= nil then
    local name = ""
    if self.info.userName ~= nil and self.info.userName ~= "" then
      name = self.info.userName
    else
      name = self.info.name
    end
    local level = self.info.level
    if self.info.type == WorldAllianceCityType.Canon or self.info.type == WorldAllianceCityType.CrossZoneOutpostCanon or self.info.type == WorldAllianceCityType.MissileFactory then
      level = nil
    end
    self.ctrl:OnShareClick(LuaEntry.Player:GetCurServerId(), self.ctrl.pointId, name, "", level, self.info.alAbbr)
  end
end

local function OnDetailClick(self)
  if self.info ~= nil then
    self.point_obj:OnInfoClick()
    self.btn_detail:SetActive(false)
    self.btn_return:SetActive(true)
  end
end

local function OnReturnClick(self)
  if self.info ~= nil then
    self.point_obj:OnReturnClick()
    self.btn_detail:SetActive(true)
    self.btn_return:SetActive(false)
  end
end

local function OnKingClick(self)
  if self.info ~= nil and LuaEntry.Player:IsPresident() then
    UIUtil.DestroyWorldSiegePoint()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIGovernmentMain, {anim = true}, self.ctrl.serverId, self.ctrl.cityId)
  end
end

local function UpdateLod(self, lod)
  if 2 < lod then
    self.ctrl:CloseSelf(false)
  end
end

function UIWorldSiegePointSeasonView:InitCityValue()
  if self.city_value_btn then
    return
  end
  self.city_value_btn = self:AddComponent(UIButton, city_value_btn_path)
  self.city_value_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnCityValueClick()
  end)
  self.city_value_image = self:AddComponent(UIImage, city_value_btn_path)
end

function UIWorldSiegePointSeasonView:RefreshCityValue(serverData)
  if serverData then
    local viewSeasonInfo = SeasonUtil.GetSeasonInfo(LuaEntry.Player:GetCurServerId())
    local config = viewSeasonInfo and viewSeasonInfo.seasonConfig
    if config and config.type == SeasonMapType.Mummy and self:RefreshGreenValue(serverData) then
      return
    end
  end
  self.city_value_text:SetActive(false)
end

function UIWorldSiegePointSeasonView:RefreshGreenValue(serverData)
  if not serverData.greenRate or not DataCenter.SeasonGreenManager:IsGreenCity(self.ctrl.cityId) then
    return false
  end
  self:InitCityValue()
  local greenRate = serverData.greenRate * 100
  self.city_value_text:SetText(string.format("(%0.0f%%)", greenRate))
  if greenRate >= DataCenter.SeasonGreenManager.cityGreenCondition then
    self.city_value_text:SetColorRGBA(0.372549, 0.937255, 0.5294118, 1)
    self.city_value_image:LoadSprite(string.format(LoadPath.CommonNewPath, "Common_img_select_yes"))
    self.city_value_image:SetNativeSize()
  else
    self.city_value_text:SetColorRGBA(1, 0.7469491, 0, 1)
    self.city_value_image:LoadSprite(string.format(LoadPath.CommonNewPath, "zyf_chengchixinxi_xiangqing"))
    self.city_value_image:SetNativeSize()
  end
  self.city_value_text:SetActive(true)
  return true
end

function UIWorldSiegePointSeasonView:OnCityValueClick()
  if SeasonUtil.CurServerTypeInSeason() == SeasonMapType.Mummy then
    UIUtil.ShowBubbleTips(Localization:GetString("season_oasis_UI_1", DataCenter.SeasonGreenManager.cityGreenCondition), self.city_value_btn.transform.position, 0, -35, 0)
  end
end

function UIWorldSiegePointSeasonView:Update1000MS()
  if self.reInitDirty then
    self.reInitDirty = false
    self:ReInit()
  end
end

function UIWorldSiegePointSeasonView:WorldSiegePointBtnRefresh()
  self.reInitDirty = true
end

function UIWorldSiegePointSeasonView:ReAutoFitUI()
end

function UIWorldSiegePointSeasonView:OnOwnerNameLinkClicked(eventData)
  if not eventData or self.the_name_text == nil or self:CityDestroyED() then
    return
  end
  local allianceId = self.info.allianceId
  if string.IsNullOrEmpty(allianceId) then
    return
  end
  UIUtil.TryShowAllianceInfo(nil, allianceId, nil)
end

function UIWorldSiegePointSeasonView:RefreshAllianceWarTime(cityData)
  self.p_comp_alliance_war_time:SetActive(false)
  if DataCenter.UILWSeasonAllianceWarTimeManager:IsFuncOpen(false) and DataCenter.UILWSeasonAllianceWarTimeManager:CanShowOnBuilding() then
    local cityType = checknumber(self.ctrl.worldCityType)
    if (cityType == WorldAllianceCityType.City or cityType == WorldAllianceCityType.Stronghold) and cityData ~= nil and cityData.warTimeIndex ~= nil then
      local timeIndex = checknumber(cityData.warTimeIndex)
      if 0 <= timeIndex and timeIndex <= 2 then
        self.p_comp_alliance_war_time:SetActive(true)
        local data = {}
        data.TimeIndex = timeIndex
        data.PointId = self.ctrl.pointId
        self.p_comp_alliance_war_time:ReInit(data)
      end
    end
  end
end

UIWorldSiegePointSeasonView.OnCreate = OnCreate
UIWorldSiegePointSeasonView.OnDestroy = OnDestroy
UIWorldSiegePointSeasonView.OnEnable = OnEnable
UIWorldSiegePointSeasonView.OnDisable = OnDisable
UIWorldSiegePointSeasonView.ComponentDefine = ComponentDefine
UIWorldSiegePointSeasonView.ComponentDestroy = ComponentDestroy
UIWorldSiegePointSeasonView.DataDefine = DataDefine
UIWorldSiegePointSeasonView.DataDestroy = DataDestroy
UIWorldSiegePointSeasonView.OnAddListener = OnAddListener
UIWorldSiegePointSeasonView.OnRemoveListener = OnRemoveListener
UIWorldSiegePointSeasonView.ReInit = ReInit
UIWorldSiegePointSeasonView.ShowBtn = ShowBtn
UIWorldSiegePointSeasonView.SetAllCellDestroy = SetAllCellDestroy
UIWorldSiegePointSeasonView.SetData = SetData
UIWorldSiegePointSeasonView.SetDataTrade = SetDataTrade
UIWorldSiegePointSeasonView.OnMarkClick = OnMarkClick
UIWorldSiegePointSeasonView.OnShareClick = OnShareClick
UIWorldSiegePointSeasonView.OnDetailClick = OnDetailClick
UIWorldSiegePointSeasonView.OnReturnClick = OnReturnClick
UIWorldSiegePointSeasonView.OnKingClick = OnKingClick
UIWorldSiegePointSeasonView.UpdateLod = UpdateLod
UIWorldSiegePointSeasonView.RefreshMarkBtnImg = RefreshMarkBtnImg
UIWorldSiegePointSeasonView.RefreshMarkList = RefreshMarkList
return UIWorldSiegePointSeasonView
