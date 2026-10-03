local WorldHeadInfo = BaseClass("WorldHeadInfo", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local ResourceManager = CS.GameEntry.Resource
local UnityLayoutElement = typeof(CS.UnityEngine.UI.LayoutElement)
local hero_spine_container_path = "lordIconMask/HeroSpineContainer"
local hero_spine_container_path2 = "lordIconMask2/HeroSpineContainer2"
local btn_king_season_path = "btns/Btn_King_season"
local btn_alliance_share_season_path = "btns/Btn_alliance_share_season"
local btn_share_season_path = "btns/Btn_share_season"
local btn_mark_season_path = "btns/Btn_mark_season"
local btn_alliance_cityrally_path = "btns/Btn_alliance_cityrally"
local lord_role_path = "lordRole"
local lord_icon_path = "lordIcon"
local lord_icon_type_path = "lordIcon/lord_icon_type"
local lord_banner_path = "lordBanner"
local lord_banner2_path = "lordBanner2"
local name_text_path = "NameText"
local icon_path = "lordBanner2/icon"

function WorldHeadInfo:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function WorldHeadInfo:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function WorldHeadInfo:ComponentDefine()
  self.hero_spine_container = self:AddComponent(UIBaseContainer, hero_spine_container_path)
  self.hero_spine_container2 = self:AddComponent(UIBaseContainer, hero_spine_container_path2)
  self.lord_banner2 = self:AddComponent(UIRawImage, lord_banner2_path)
  self.icon = self:AddComponent(UIRawImage, icon_path)
  self.lord_icon = self:AddComponent(UIImage, lord_icon_path)
  self.lord_icon_type = self:AddComponent(UIImage, lord_icon_type_path)
  self.lord_role = self:AddComponent(UIImage, lord_role_path)
  self.lord_role:SetActive(false)
  self.btn_king_season = self:AddComponent(UIButton, btn_king_season_path)
  self.btn_king_season:SetOnClick(function()
    self:KingBtn()
  end)
  self.btn_alliance_share_season = self:AddComponent(UIButton, btn_alliance_share_season_path)
  self.btn_alliance_share_season:SetOnClick(function()
    self:AllianceShareBtn()
  end)
  self.btn_share_season = self:AddComponent(UIButton, btn_share_season_path)
  self.btn_share_season:SetOnClick(function()
    self:ShareBtn()
  end)
  self.btn_mark_season = self:AddComponent(UIButton, btn_mark_season_path)
  self.btn_mark_season:SetOnClick(function()
    self:MarkBtn()
  end)
  self.btn_alliance_cityrally = self:AddComponent(UIButton, btn_alliance_cityrally_path)
  self.btn_alliance_cityrally:SetActive(false)
  self.btn_alliance_cityrally:SetOnClick(function()
    DataCenter.AllianceBaseDataManager:TrySetRally(self.param.pointId, self.param.serverId)
  end)
  self.name_text = self:AddComponent(UIText, name_text_path)
  self.lord_banner = self:AddComponent(UIImage, lord_banner_path)
  self.unity_LayoutElement = self.gameObject:GetComponent(UnityLayoutElement)
  self.preHeight = self.unity_LayoutElement.preferredHeight
end

function WorldHeadInfo:ComponentDestroy()
  self.unity_LayoutElement.preferredHeight = self.preHeight
  self.hero_spine_container = nil
  self.hero_spine_container2 = nil
  self.btn_king_season = nil
  self.btn_alliance_share_season = nil
  self.btn_share_season = nil
  self.btn_mark_season = nil
  self.btn_alliance_cityrally = nil
  self.lord_role = nil
  self.lord_banner = nil
  self.lord_banner2 = nil
  self.name_text = nil
  self.icon = nil
  self.unity_LayoutElement = nil
  if self.heroSpineLoadRequest ~= nil then
    self.heroSpineLoadRequest:Destroy()
    self.heroSpineLoadRequest = nil
  end
  self.loadedSpinePath = nil
end

function WorldHeadInfo:RefreshData(param)
  local appearanceId = param.appearanceId
  self.param = param
  self.btn_king_season:SetActive(self.param.king ~= nil)
  self.btn_alliance_share_season:SetActive(self.param.allianceShare ~= nil)
  self.btn_share_season:SetActive(self.param.share ~= nil)
  self.btn_mark_season:SetActive(self.param.mark ~= nil)
  self.btn_alliance_cityrally:SetActive(self.param.showAlliance)
  if self.param.height then
    self.unity_LayoutElement.preferredHeight = self.param.height
  else
    self.unity_LayoutElement.preferredHeight = self.preHeight
  end
  if param.nameText == nil then
    self.name_text:SetActive(false)
  else
    self.name_text:SetActive(true)
    self.name_text:SetText(param.nameText)
  end
  if self.param.isShowIcon == nil then
    self.lord_icon:SetActive(true)
  else
    self.lord_icon:SetActive(self.param.isShowIcon)
  end
  local seasonType = SeasonUtil.GetSeasonType()
  if param.cityId ~= nil and seasonType == SeasonMapType.CityStronghold then
    local serverId = LuaEntry.Player:GetCurServerId()
    local cityMeta = DataCenter.AllianceCityTemplateManager:GetTemplate(param.cityId, serverId)
    if cityMeta ~= nil and cityMeta:IsCityStronghold() then
      local cityIconType = toInt(cityMeta.stronghold_army_type)
      if cityIconType == 1 then
        self.lord_icon_type:SetActive(true)
        self.lord_icon:LoadSprite("Assets/Main/Sprites/UI/UISeason/Sprites/CityPopup/Mjc_saiji2_pop_zhiye_bg.png")
        self.lord_icon_type:LoadSprite("Assets/Main/Sprites/UI/UILWHeroSquad/zyf_biandui_tanke_da.png")
      elseif cityIconType == 2 then
        self.lord_icon_type:SetActive(true)
        self.lord_icon:LoadSprite("Assets/Main/Sprites/UI/UISeason/Sprites/CityPopup/Mjc_saiji2_pop_zhiye_bg.png")
        self.lord_icon_type:LoadSprite("Assets/Main/Sprites/UI/UILWHeroSquad/zyf_biandui_daodan_da.png")
      elseif cityIconType == 3 then
        self.lord_icon_type:SetActive(true)
        self.lord_icon:LoadSprite("Assets/Main/Sprites/UI/UISeason/Sprites/CityPopup/Mjc_saiji2_pop_zhiye_bg.png")
        self.lord_icon_type:LoadSprite("Assets/Main/Sprites/UI/UILWHeroSquad/zyf_biandui_feiji_da.png")
      else
        self.lord_icon_type:SetActive(false)
        self.lord_icon:LoadSprite("Assets/Main/Sprites/UI/UISeason/Sprites/CityPopup/Mjc_saijijianzhu_juntuanicon_01.png")
      end
    else
      self.lord_icon_type:SetActive(false)
      self.lord_icon:LoadSprite("Assets/Main/Sprites/UI/UISeason/Sprites/CityPopup/Mjc_saijijianzhu_juntuanicon_01.png")
    end
  else
    if param.overrideIconPath then
      self.lord_icon:LoadSpriteAuto(param.overrideIconPath)
    elseif SeasonUtil.SeasonHasMummyYardBuild(seasonType) then
      self.lord_icon:LoadSprite("Assets/Main/Sprites/UI/UISeason/Sprites/CityPopup/Mjc_saijijianzhu_juntuanicon_03.png")
    else
      self.lord_icon:LoadSprite("Assets/Main/Sprites/UI/UISeason/Sprites/CityPopup/Mjc_saijijianzhu_juntuanicon_01.png")
    end
    self.lord_icon_type:SetActive(false)
  end
  local lordBannerPath = param.lordBannerPath
  if seasonType == SeasonMapType.Darkness then
    if param.type == WorldPointUIType.Monster and param.special == WorldMonsterSpecialType.CityGhostBoss then
      self.icon:SetActive(true)
      self.icon:LoadSprite("Assets/Main/SeasonRes/S4/Textures/WorldUI/zyf_S4_xuegui_qipaobanshen.png")
    elseif param.monsterType == LWWorldMonsterType.FlowerCar then
      self.lord_icon:LoadSprite("Assets/Main/Sprites/UI/UISeason/Sprites/CityPopup/Mjc_saijijianzhu_juntuanicon_01.png")
      self.icon:SetActive(false)
    elseif param.citType == WorldAllianceCityType.TradingStation then
      lordBannerPath = SeasonUtil.GetNewIconPathInBloodyNight(lordBannerPath)
      self.icon:SetActive(false)
    else
      self.icon:SetActive(false)
    end
  else
    self.icon:SetActive(false)
  end
  if not string.IsNullOrEmpty(lordBannerPath) then
    self.lord_banner2:LoadSprite(lordBannerPath)
    self.lord_banner2:SetActive(true)
    self.lord_banner:SetActive(false)
    if param.banner2AnchoredPositionY then
      self.lord_banner2:SetAnchoredPositionXY(0, param.banner2AnchoredPositionY)
    else
      self.lord_banner2:SetAnchoredPositionXY(0, 0)
    end
    if param.banner2SizeDeltaXY then
      self.lord_banner2:SetSizeDelta(param.banner2SizeDeltaXY)
    elseif param.banner2SizeDeltaY then
      self.lord_banner2:SetSizeDeltaXY(538, param.banner2SizeDeltaY)
    else
      self.lord_banner2:SetSizeDeltaXY(538, 214)
    end
  else
    self.lord_banner2:SetActive(false)
    self.lord_banner:SetActive(true)
  end
  local flag = self.param.citType ~= WorldAllianceCityType.TradingStation
  if self.param.isHideRolle then
    flag = false
  end
  local _spinePath, _spineParent
  if self.param.overrideSpinePath then
    _spinePath = self.param.overrideSpinePath
    _spineParent = self.hero_spine_container2
  elseif not string.IsNullOrEmpty(appearanceId) then
    local newAppearanceId = DataCenter.LWSaveGirlManager:GetJPAppearanceId(appearanceId)
    local spinePath = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.HeroAppearance), newAppearanceId, "show_model_path")
    local show_model_path_city = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.HeroAppearance), newAppearanceId, "show_model_path_city")
    _spineParent = self.hero_spine_container
    if not string.IsNullOrEmpty(show_model_path_city) then
      spinePath = show_model_path_city
      _spineParent = self.hero_spine_container2
    end
    _spinePath = spinePath
  end
  if _spinePath then
    flag = false
  end
  if _spinePath ~= self.loadedSpinePath then
    if self.heroSpineLoadRequest ~= nil then
      self.heroSpineLoadRequest:Destroy()
      self.heroSpineLoadRequest = nil
    end
    self.loadedSpinePath = _spinePath
    if _spinePath then
      self.hero_spine_container:SetActive(false)
      self.hero_spine_container2:SetActive(false)
      self.heroSpineLoadRequest = ResourceManager:InstantiateAsync(_spinePath)
      self.heroSpineLoadRequest:completed("+", function(request)
        if request.isError or request.gameObject == nil then
          return
        end
        local obj = request.gameObject
        local rectTransform = obj:GetComponent(typeof(CS.UnityEngine.RectTransform))
        if rectTransform ~= nil then
          rectTransform:SetParent(_spineParent.transform)
          _spineParent:SetActive(true)
          rectTransform:Set_localScale(1, 1, 1)
          rectTransform:Set_anchoredPosition(0, 0, 0)
        end
      end)
    end
  end
  self.lord_role:SetActive(flag)
end

function WorldHeadInfo:KingBtn()
  if self.param.king and type(self.param.king) == "function" then
    self.param.king()
  end
end

function WorldHeadInfo:AllianceShareBtn()
  if self.param.allianceShare and type(self.param.allianceShare) == "function" then
    self.param.allianceShare()
  end
end

function WorldHeadInfo:ShareBtn()
  if self.param.share and type(self.param.share) == "function" then
    self.param.share()
  end
end

function WorldHeadInfo:MarkBtn()
  if self.param.mark and type(self.param.mark) == "function" then
    self.param.mark()
  end
end

return WorldHeadInfo
