local MainMiniMapDesItem = require("UI.UIMainMiniMap.Component.MainMiniMapDesItem")
local UIMainMiniMapView = BaseClass("UIMainMiniMapView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local MiniMapChessItem = require("UI.UIMainMiniMap.Component.MiniMapChessItem")
local WorldMiniMapComp = require("UI.UIMainMiniMap.Component.WorldMiniMapComp")
local UIKingBtn = require("UI.LWMainUI.Component.UIMainTop.UIKingBtn")
local obj_path = "safeArea"
local des1_path = "safeArea/topRight/desObj/des1"
local des2_path = "safeArea/topRight/desObj/des2"
local des3_path = "safeArea/topRight/desObj/des3"
local player_btn_path = "safeArea/PlayerBtn"
local player_head_path = "safeArea/PlayerBtn/UIPlayerHead"
local player_level_path = "safeArea/PlayerBtn/LevelBg/LevelText"
local chess_obj_path = "safeArea/topRight/chessInfo"
local chess_popup_path = "safeArea/topRight/chessInfo/popup"
local chess_item_path = "safeArea/topRight/chessInfo/popup/item"
local des_obj_path = "safeArea/topRight/desObj"
local stamina_path = "safeArea/Stamina"
local player_stamina_text_path = "safeArea/Stamina/staminaText"
local player_stamina_slider_path = "safeArea/Stamina/Slider"
local home_btn = "safeArea/HomeBtn/Btn"
local home_btn_name = "safeArea/HomeBtn/Btn/name"
local king_occupy_path = "safeArea/KingOccupy"
local king_server_path = "safeArea/KingOccupy/server"
local king_user_path = "safeArea/KingOccupy/user"
local king_badges_path = "safeArea/KingOccupy/server/KingdomBadges"
local time_tips_path = "safeArea/KingOccupy/timeTips"
local remain_time_path = "safeArea/KingOccupy/timeTips/remainTime"
local season_heat_map_btn_path = "safeArea/BottomContainer/SeasonHeatMapBtn"
local heat_map_switch_path = "safeArea/BottomContainer/SeasonHeatMapBtn/HeatMapSwitch"
local turn_on_btn_path = "safeArea/BottomContainer/SeasonHeatMapBtn/HeatMapSwitch/TurnOnBtn"
local heat_map_switch_name_path = "safeArea/BottomContainer/SeasonHeatMapBtn/HeatMapSwitch/HeatMapSwitchName"
local mode_menu_path = "safeArea/topRight/ModeMenu"
local mini_btn_group_path = "safeArea/topRight/miniBtnGroup"
local info_btn_path = "safeArea/topRight/miniBtnGroup/infoBtn"
local back_home_btn_path = "safeArea/BottomContainer/BackHomeBtn"
local back_home_arrow_path = "safeArea/BottomContainer/BackHomeBtn/arrow"
local back_home_txt_path = "safeArea/BottomContainer/BackHomeBtn/txt"
local skin_btn_path = "safeArea/BottomContainer/SkinBtn"
local skin_color_switch_path = "safeArea/BottomContainer/SkinBtn/SkinColorSwitch"
local turn_on_color_btn_path = "safeArea/BottomContainer/SkinBtn/SkinColorSwitch/TurnOnColorBtn"
local skin_color_switch_name_path = "safeArea/BottomContainer/SkinBtn/SkinColorSwitch/SkinColorSwitchName"
local landlord_act_node_path = "safeArea/topRight/landlordActNode"
local meteorite_notice_node_path = "safeArea/topRight/meteoriteNoticeNode"
local meteorite_news_node_path = "safeArea/topRight/meteoriteNewsNode"
local mini_map_path = "safeArea/topRight/miniMap"
local LL_ACT_BTN_PREFAB = "Assets/Main/Prefabs/UI/UIGovernment/ServerBattle/NewKingActivity.prefab"

local function OnCreate(self)
  base.OnCreate(self)
  if BattleFieldUtil.InBattleField() then
    self.bigMapMode = false
  else
    local curServerId = LuaEntry.Player:GetCurServerId()
    local isBigMapMode, curSameGroup, srcSameGroup, loginSameGroup = SeasonUtil.InSeasonBigMapMode(curServerId)
    self.bigMapMode = isBigMapMode
    self.curSameGroup = curSameGroup
    self.srcSameGroup = srcSameGroup
    self.loginSameGroup = loginSameGroup
  end
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.obj = self:AddComponent(UIBaseContainer, obj_path)
  self.des1 = self:AddComponent(MainMiniMapDesItem, des1_path)
  self.des1:SetText(Localization:GetString("302337"))
  self.des2 = self:AddComponent(MainMiniMapDesItem, des2_path)
  self.des2:SetText(Localization:GetString("302338"))
  self.des3 = self:AddComponent(MainMiniMapDesItem, des3_path)
  self.des3:SetText(Localization:GetString("302336"))
  local llRoot = self.transform:Find(landlord_act_node_path)
  if IsNotNull(llRoot) then
    self.landlordActRoot = self:AddComponent(UIBaseContainer, landlord_act_node_path)
    self.landlordActRoot:SetActive(false)
  end
  self.meteoriteNoticeRoot = self.transform:Find(meteorite_notice_node_path)
  if IsNotNull(self.meteoriteNoticeRoot) then
    self.meteoriteNoticeRoot.gameObject:SetActive(false)
  end
  self.meteoriteNewsRoot = self.transform:Find(meteorite_news_node_path)
  if IsNotNull(self.meteoriteNewsRoot) then
    self.meteoriteNewsRoot.gameObject:SetActive(false)
  end
  local curServerId = LuaEntry.Player:GetCurServerId()
  local isInSingleServerMode = false
  local seasonInfo = SeasonUtil.GetSeasonInfo(curServerId)
  if seasonInfo ~= nil and seasonInfo.isSingleServerMode then
    isInSingleServerMode = true
  end
  self.mini_btn_group = self:AddComponent(UIBaseContainer, mini_btn_group_path)
  self.info_btn = self:AddComponent(UIButton, info_btn_path)
  self.info_btn:SetOnClick(function()
    self:OnMapInfoClick()
  end)
  if self.bigMapMode then
    self.info_btn:LoadSpriteAsync("Assets/Main/SeasonRes/S5/Sprites/MiniMap/v2/ljq_s5_kuazhanqu_ditu.png")
  end
  local needShowInfoBtn = self.bigMapMode and not isInSingleServerMode and seasonInfo ~= nil
  self.info_btn:SetActive(needShowInfoBtn)
  self.mini_btn_group:SetActive(needShowInfoBtn)
  self.player_btn = self:AddComponent(UIButton, player_btn_path)
  self.player_head = self:AddComponent(UICommonHead, player_head_path)
  self.player_level = self:AddComponent(UIText, player_level_path)
  self.stamina_num = self:AddComponent(UIText, player_stamina_text_path)
  self.stamina_slider = self:AddComponent(UISlider, player_stamina_slider_path)
  self.player_head:SetEnableClickShowInfo(true, true)
  self.chessRoot = self:AddComponent(UIButton, chess_obj_path)
  self.desRoot = self:AddComponent(UIBaseContainer, des_obj_path)
  self.staminaRoot = self:AddComponent(UIBaseContainer, stamina_path)
  self.chessRoot:SetOnClick(function()
    self:OnChessBtnClick()
  end)
  self.goHomeBtn = self:AddComponent(UIButton, home_btn)
  self.goHomeBtnName = self:AddComponent(UIText, home_btn_name)
  self.goHomeBtnName:SetLocalText(457602)
  self.goHomeBtn:SetOnClick(function()
    self:GoHomeBtnClick()
  end)
  if self.bigMapMode and not isInSingleServerMode then
    local WorldMiniMapCompS5 = require("UI.UIMainMiniMap.Component.WorldMiniMapCompS5")
    self.miniMap = self:AddComponent(WorldMiniMapCompS5, mini_map_path)
  else
    self.miniMap = self:AddComponent(WorldMiniMapComp, mini_map_path)
  end
  local mySourceServerId = LuaEntry.Player:GetSourceServerId()
  local info = SeasonUtil.GetSeasonInfo(curServerId)
  local seasonType = SeasonMapType.Nothing
  if info ~= nil then
    seasonType = info:GetServerSubdivisionType(false)
  end
  local placeWorldBuild = UIManager:GetInstance():GetWindow(UIWindowNames.UIPlaceWorldBuild)
  local mvCityView = UIManager:GetInstance():GetWindow(UIWindowNames.UIMoveCity)
  if placeWorldBuild ~= nil and placeWorldBuild.View ~= nil then
    self.desRoot:SetActive(false)
    self.staminaRoot:SetActive(false)
    self.player_btn:SetActive(false)
  elseif mvCityView ~= nil and mvCityView.View ~= nil then
    self.player_btn:SetActive(true)
    self.desRoot:SetActive(true)
    self.staminaRoot:SetActive(false)
  else
    self.player_btn:SetActive(true)
    self.desRoot:SetActive(true)
    self.staminaRoot:SetActive(false)
  end
  self.desRoot:SetActive(seasonType == SeasonMapType.Nothing)
  self.chessPopup = self:AddComponent(UIBaseContainer, chess_popup_path)
  self.chessItemPool = self.transform:Find(chess_item_path).gameObject
  self.chessItemPool:GameObjectCreatePool()
  self.king_occupy = self:AddComponent(UIImage, king_occupy_path)
  self.king_server = self:AddComponent(UIText, king_server_path)
  self.king_name_text = self:AddComponent(UIText, king_user_path)
  self.king_badges = self:AddComponent(UIImage, king_badges_path)
  self.time_tips = self:AddComponent(UIBaseContainer, time_tips_path)
  self.time_tips:SetActive(false)
  self.remain_time = self:AddComponent(UITextMeshProUGUIEx, remain_time_path)
  self.king_occupy:SetActive(false)
  self.season_heat_map_btn = self:AddComponent(UIBaseContainer, season_heat_map_btn_path)
  self.heat_map_switch = self:AddComponent(UIToggle, heat_map_switch_path)
  self.turn_on_btn = self:AddComponent(UIButton, turn_on_btn_path)
  self.heat_map_switch_name = self:AddComponent(UITextMeshProUGUIEx, heat_map_switch_name_path)
  self.mode_menu_path = self:AddComponent(UIBaseContainer, mode_menu_path)
  if SeasonUtil.IsInSeasonSnowMode() and seasonType == SeasonMapType.Snow then
    local mgr = UIManager:GetInstance()
    if mgr:IsWindowOpen(UIWindowNames.UIMoveCity) or mgr:IsWindowOpen(UIWindowNames.UIPlaceWorldBuild) then
      self.season_heat_map_btn:SetActive(false)
    else
      self.season_heat_map_btn:SetActive(true)
    end
  else
    self.season_heat_map_btn:SetActive(false)
  end
  self.heat_map_switch_name:SetLocalText("season_s2_map_tips_1")
  self.turn_on_btn:SetOnClick(function()
    self:HeatMapSwitchClick()
  end)
  self.heat_map_switch:SetOnValueChanged(function(isOn)
    self:OnHeatMapSwitch(isOn)
  end)
  self.heat_map_switch:SetIsOn(false)
  self.canShowModeMenu = SeasonUtil.IsInSeasonMummyMode(true) and seasonType == SeasonMapType.Mummy
  self.back_home_btn = self:AddComponent(UIButton, back_home_btn_path)
  self.back_home_arrow = self:AddComponent(UIImage, back_home_arrow_path)
  self.back_home_txt = self:AddComponent(UITextMeshProUGUIEx, back_home_txt_path)
  self.skin_btn = self:AddComponent(UIBaseContainer, skin_btn_path)
  self.skin_color_switch = self:AddComponent(UIToggle, skin_color_switch_path)
  self.turn_on_skin_color_btn = self:AddComponent(UIButton, turn_on_color_btn_path)
  self.skin_color_switch_name = self:AddComponent(UITextMeshProUGUIEx, skin_color_switch_name_path)
  self.seasonType = seasonType
  self.isInBattleServerGroup = info and info:IsInBattleServerGroupInt(mySourceServerId)
  if seasonType == SeasonMapType.Nothing then
    self.chessRoot:SetActive(false)
    self.back_home_btn:SetActive(false)
    self.skin_btn:SetActive(false)
  else
    local cfg = DataCenter.SeasonDataManager:GetUserSeasonInfo()
    if cfg then
      local theWorldChessColorDict = {}
      local data = cfg:GetWorldChessColorSettingList()
      for k, v in ipairs(data) do
        theWorldChessColorDict[v.id] = v
      end
      local theWorldChessColorList = table.values(theWorldChessColorDict)
      table.sort(theWorldChessColorList, function(a, b)
        return a.color_help_weight > b.color_help_weight
      end)
      self.theWorldChessColorList = theWorldChessColorList
    end
    if self.bigMapMode and self.loginSameGroup then
      self.back_home_btn:SetOnClick(function()
        local selfServerId = LuaEntry.Player:GetSelfServerId()
        local my_point_id = LuaEntry.Player:GetMainWorldPos()
        if 0 < selfServerId and 0 < my_point_id then
          local targetPos = SceneUtils.TileIndexToWorld(my_point_id, ForceChangeScene.World, selfServerId)
          local world = CS.SceneManager.World
          if world then
            world:StopCameraMove()
            GoToUtil.GotoWorldPos(targetPos, world.Zoom, 0.1, nil, selfServerId, 0)
          end
        end
      end)
    else
      self.back_home_btn:SetActive(false)
    end
    self.chessRoot:SetActive(table.count(self.theWorldChessColorList) > 0)
    local activeSkinColor = DataCenter.SeasonDataManager:ExistZoneSkinColor(seasonType)
    if activeSkinColor then
      if seasonType == SeasonMapType.NineNationRainforest and info:IsInBattleServerGroupInt(mySourceServerId) then
        local isOn = Setting:GetPrivateBool("season6_map_zone_mode", true)
        self.inMyNineNationRainforest = true
        self.activeSkinColor = isOn
        self.skin_btn:SetActive(true)
        self.skin_color_switch:SetIsOn(isOn)
        self.skin_color_switch_name:SetLocalText("s6_map_ui_13")
        Setting:SetPrivateBool("season6_map_zone_mode", isOn)
        if isOn then
          DataCenter.SeasonDataManager:UpdateZoneSkinColor()
        end
        DataCenter.AllianceCityTipManager:OnCitySkinColorSettingChanged()
        EventManager:GetInstance():Broadcast(EventId.ZoneSkinColorSettingChanged)
      else
        Setting:SetPrivateBool("season_map_zone_mode", false)
        self.inMyNineNationRainforest = false
        self.activeSkinColor = false
        self.skin_color_switch_name:SetLocalText("season_s5_zone_mode")
        self.skin_color_switch:SetIsOn(false)
        self.skin_btn:SetActive(false)
      end
      self.turn_on_skin_color_btn:SetOnClick(function()
        self.activeSkinColor = not self.activeSkinColor
        if seasonType == SeasonMapType.NineNationRainforest and info:IsInBattleServerGroupInt(mySourceServerId) then
          Setting:SetPrivateBool("season6_map_zone_mode", self.activeSkinColor)
        else
          Setting:SetPrivateBool("season_map_zone_mode", self.activeSkinColor)
        end
        self.skin_color_switch:SetIsOn(self.activeSkinColor)
      end)
      self.skin_color_switch:SetOnValueChanged(function(isOn)
        if isOn then
          DataCenter.SeasonDataManager:UpdateZoneSkinColor()
        end
        DataCenter.AllianceCityTipManager:OnCitySkinColorSettingChanged()
        EventManager:GetInstance():Broadcast(EventId.ZoneSkinColorSettingChanged)
      end)
    else
      self.activeSkinColor = nil
      self.skin_btn:SetActive(false)
    end
  end
end

local function ComponentDestroy(self)
  self.chessPopup:RemoveComponents(MiniMapChessItem)
  self.chessItemPool:GameObjectRecycleAll()
  self.chessPopup = nil
  self.chessItemPool = nil
  self.des1 = nil
  self.des2 = nil
  self.des3 = nil
  self.info_btn = nil
  self.mini_btn_group = nil
  self.season_heat_map_btn = nil
  self.heat_map_switch = nil
  self.turn_on_btn = nil
  self.heat_map_switch_name = nil
  self.skin_btn = nil
  self.skin_color_switch = nil
  self.turn_on_skin_color_btn = nil
  self.skin_color_switch_name = nil
  self:HideModeMenu()
  if self.greenMenuHandle then
    self.greenMenuHandle:Destroy()
    self.greenMenuHandle = nil
  end
  if self.llActReq ~= nil then
    self.llActReq:Destroy()
    self.llActReq = nil
  end
  self.landlordActRoot = nil
  self.compLLAct = nil
  self.llInfoComp = nil
  self.llProgressComp = nil
  self.llInfoTipComp = nil
  self.meteoriteNewsRoot = nil
  self.meteoriteNoticeRoot = nil
  self.meteoriteNotice = nil
  self.meteoriteNews = nil
  self.back_home_btn = nil
  self.back_home_arrow = nil
  self.back_home_txt = nil
  self.time_tips = nil
  self.remain_time = nil
end

local function DataDefine(self)
  self.lodCache = -1
  self.isShowMiniMap = true
end

local function DataDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self:UpdateLod(CS.SceneManager.World:GetLodLevel())
end

local function OnDisable(self)
  base.OnDisable(self)
  self.heat_map_switch:SetIsOn(false)
end

local function ShowMiniMap(self)
  self:SetMapActive(true, true)
end

local function HideMiniMap(self)
  self:SetMapActive(false, true)
end

local function SetMapActive(self, value, force)
  if force or value ~= self.isShowMiniMap then
    self.obj:SetActive(value)
    self.isShowMiniMap = value
  end
end

local function ReInit(self)
  if self.miniMap then
    self.miniMap:RefreshCityPoints()
  end
  self:RefreshPlayerInfo()
  self:RefreshStamina()
  self:RefreshHeroIcon()
  self:RefreshMeteorite()
  self:RefreshKingInfo()
  self:RefreshLandlordBattleInfo()
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.WORLD_CAMERA_CHANGE_POINT, self.TryUpdateHomeBubble)
  self:AddUIListener(EventId.ShowMiniMap, self.ShowMiniMap)
  self:AddUIListener(EventId.HideMiniMap, self.HideMiniMap)
  self:AddUIListener(EventId.MainLvUp, self.RefreshPlayerInfo)
  self:AddUIListener(EventId.PlayerStaminaUpdate, self.RefreshStamina)
  self:AddUIListener(EventId.UpdatePlayerHeadIcon, self.RefreshHeroIcon)
  self:AddUIListener(EventId.ChangeCameraLod, self.OnLodChange)
  self:AddUIListener(EventId.MeteoriteBattlePlayerStateChanged, self.OnMeteoritePlayerStateChanged)
  self:AddUIListener(EventId.MeteoriteBattleNotice, self.RefreshMeteoriteNotice)
  self:AddUIListener(EventId.OpenUI, self.OnUIChange)
  self:AddUIListener(EventId.CloseUI, self.OnUIChange)
  self:AddUIListener(EventId.OnSetCrossID, self.OnCrossServer)
  self:AddUIListener(EventId.RefreshKingInfo, self.RefreshKingInfo)
  self:AddUIListener(EventId.LandlordActStageChange, self.RefreshLandlordBattleTime)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.WORLD_CAMERA_CHANGE_POINT, self.TryUpdateHomeBubble)
  self:RemoveUIListener(EventId.ShowMiniMap, self.ShowMiniMap)
  self:RemoveUIListener(EventId.HideMiniMap, self.HideMiniMap)
  self:RemoveUIListener(EventId.MainLvUp, self.RefreshPlayerInfo)
  self:RemoveUIListener(EventId.PlayerStaminaUpdate, self.RefreshStamina)
  self:RemoveUIListener(EventId.UpdatePlayerHeadIcon, self.RefreshHeroIcon)
  self:RemoveUIListener(EventId.ChangeCameraLod, self.OnLodChange)
  self:RemoveUIListener(EventId.MeteoriteBattlePlayerStateChanged, self.OnMeteoritePlayerStateChanged)
  self:RemoveUIListener(EventId.MeteoriteBattleNotice, self.RefreshMeteoriteNotice)
  self:RemoveUIListener(EventId.OpenUI, self.OnUIChange)
  self:RemoveUIListener(EventId.CloseUI, self.OnUIChange)
  self:RemoveUIListener(EventId.OnSetCrossID, self.OnCrossServer)
  self:RemoveUIListener(EventId.RefreshKingInfo, self.RefreshKingInfo)
  self:RemoveUIListener(EventId.LandlordActStageChange, self.RefreshLandlordBattleTime)
end

function UIMainMiniMapView:OnCrossServer()
  self:RefreshKingInfo()
  self:RefreshLandlordBattleInfo()
end

function UIMainMiniMapView:OnUIChange()
  local mgr = UIManager:GetInstance()
  local open_count = mgr:GetStackWindowCount()
  if mgr:IsWindowOpen(UIWindowNames.UILLTaskBarTip) then
    open_count = open_count - 1
  end
  open_count = math.max(open_count, 0)
  if open_count == 0 or open_count == 1 then
    self:SetMapActive(true, true)
  else
    self:SetMapActive(false, true)
  end
end

function UIMainMiniMapView:TryUpdateHomeBubble()
  if self.bigMapMode and self.loginSameGroup then
    local show, dist, pos_x, pos_y, eulerAngles_z = UIUtil.CalcMilePointer(0, 0)
    if show then
      if self.worldWorldCenterBackBtnRotation ~= eulerAngles_z then
        self.worldWorldCenterBackBtnRotation = eulerAngles_z
        self.back_home_arrow:SetEulerAnglesXYZ(0, 0, eulerAngles_z)
      end
      if self.worldWorldCenterBackName ~= dist then
        self.worldWorldCenterBackName = dist
        self.back_home_txt:SetText(dist .. Localization:GetString(GameDialogDefine.KILOMETRE))
      end
    end
    self.back_home_btn:SetActive(show)
  end
end

local function RefreshPlayerInfo(self)
  self.player_level:SetText(DataCenter.BuildManager.MainLv)
end

local function RefreshStamina(self)
  local maxNum = 100
  local curNum = LuaEntry.Player:GetCurStamina()
  local config = DataCenter.ArmyFormationDataManager:GetConfigData()
  if config ~= nil then
    maxNum = config.FormationStaminaMax
  end
  local tempValue = math.min(1, curNum / maxNum)
  self.stamina_slider:SetValue(tempValue)
  self.stamina_num:SetText(string.GetFormattedSeperatorNum(math.floor(curNum)) .. "/" .. string.GetFormattedSeperatorNum(math.floor(maxNum)))
end

local function RefreshHeroIcon(self)
  local uid = LuaEntry.Player:GetUid()
  local pic = LuaEntry.Player:GetPic()
  local picVer = LuaEntry.Player.picVer
  self.player_head:SetData(uid, pic, picVer, nil, LuaEntry.Player:GetHeadBgImg())
end

function UIMainMiniMapView:RefreshMeteorite()
  self:RefreshMeteoriteNews()
  self:RefreshMeteoriteNotice()
end

function UIMainMiniMapView:OnChessBtnClick()
  if self.chessDataShown == nil then
    local goItem, theItem
    local data = self.theWorldChessColorList
    self.chessPopup:RemoveComponents(MiniMapChessItem)
    self.chessItemPool:GameObjectRecycleAll()
    for k, v in ipairs(data) do
      if v and v.color_help_weight ~= -1 then
        goItem = self.chessItemPool:GameObjectSpawn(self.chessPopup.transform)
        goItem.name = "chess_" .. UIUtil.GetLoopListItemIndex()
        goItem:SetActive(true)
        theItem = self.chessPopup:AddComponent(MiniMapChessItem, goItem.name)
        theItem:ReInit(k, v)
      end
    end
    self.chessDataShown = true
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.chessPopup.rectTransform)
  end
  if self.chessPopup:GetActive() then
    self.chessPopup:SetActive(false)
  end
  self.chessPopup:SetActive(true)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.chessPopup.rectTransform)
end

local function GoHomeBtnClick(self)
  local selfServerId = LuaEntry.Player:GetSelfServerId()
  local mainIndex = LuaEntry.Player:GetMainWorldPos()
  local worldPos = SceneUtils.TileIndexToWorld(mainIndex, ForceChangeScene.World)
  if BattleFieldUtil.InBattleField() then
    GoToUtil.GotoWorldPos(worldPos, nil, 0.02, function()
      SceneUtils.ChangeToCity(function()
      end)
    end, selfServerId)
  else
    if mainIndex == nil or mainIndex <= 0 then
      local markInfo = DataCenter.AllianceRallyPointDataManager:GetMyAllianceRallyPoint()
      if markInfo then
        mainIndex = markInfo:GetPointIndex()
      end
    end
    if CS.SceneManager.World.InitZoom >= 200 then
      GoToUtil.GotoWorldPos(worldPos, 150, 0.1, nil, selfServerId, 0)
    else
      GoToUtil.GotoWorldPos(worldPos, CS.SceneManager.World.InitZoom, 0.1, nil, selfServerId, 0)
    end
  end
end

local function HeatMapSwitchClick(self)
  local isOn = self.heat_map_switch:GetIsOn()
  self.heat_map_switch:SetIsOn(not isOn)
end

local function OnHeatMapSwitch(self, isOn)
  if isOn then
    CS.UnityEngine.Shader.EnableKeyword("HEATMAP_ON")
  else
    CS.UnityEngine.Shader.DisableKeyword("HEATMAP_ON")
  end
end

function UIMainMiniMapView:UpdateLod(lod)
  if self.lodCache ~= lod then
    local old = toInt(self.lodCache)
    self.lodCache = lod
    if 6 <= lod and self.canShowModeMenu then
      self:ShowModeMenu()
    else
      self:HideModeMenu()
    end
    if self.inMyNineNationRainforest then
      if self.skin_btn ~= nil then
        if 6 <= lod then
          self.skin_btn:SetActive(true)
        else
          self.skin_btn:SetActive(false)
        end
      end
    elseif self.activeSkinColor ~= nil and self.skin_btn ~= nil then
      if 6 <= lod then
        self.skin_btn:SetActive(true)
        if old < 6 then
          self.activeSkinColor = false
          self.skin_color_switch:SetIsOn(false)
          Setting:SetPrivateBool("season_map_zone_mode", false)
          DataCenter.AllianceCityTipManager:OnCitySkinColorSettingChanged()
          EventManager:GetInstance():Broadcast(EventId.ZoneSkinColorSettingChanged)
        else
        end
      else
        self.activeSkinColor = false
        self.skin_btn:SetActive(false)
        self.skin_color_switch:SetIsOn(false)
        Setting:SetPrivateBool("season_map_zone_mode", false)
        DataCenter.AllianceCityTipManager:OnCitySkinColorSettingChanged()
        EventManager:GetInstance():Broadcast(EventId.ZoneSkinColorSettingChanged)
      end
    end
    self:RefreshMeteoriteNews()
    self:RefreshLandlordBattleInfo()
  end
end

function UIMainMiniMapView:OnLodChange(lod)
  self:UpdateLod(lod)
end

function UIMainMiniMapView:ShowModeMenu()
  if self.isShowModeMenu then
    return
  end
  self.isShowModeMenu = true
  self.mode_menu_path:SetActive(true)
  if self.modeMenu then
    self.modeMenu:RefreshView(false)
  else
    if self.greenMenuHandle then
      return
    end
    local scriptPath = require("UI.UIMainMiniMap.Component.MiniMapGreenMenu")
    local prefabPath = "Assets/Main/Prefabs/UI/LWMainUI/MiniMapGreenMenu.prefab"
    self.greenMenuHandle = UIUtil.LoadPrefab(prefabPath, scriptPath, self.mode_menu_path, "MiniMapGreenMenu", function(item)
      self.modeMenu = item
      self.modeMenu:RefreshView(false)
    end)
  end
  local seasonType = SeasonUtil.GetSeasonType()
  if seasonType ~= SeasonMapType.Nothing then
    local offsetMax = self.mode_menu_path.transform.offsetMax
    self.mode_menu_path.transform.offsetMax = Vector2.New(offsetMax.x, -211)
  end
end

function UIMainMiniMapView:HideModeMenu()
  if self.isShowModeMenu then
    self.isShowModeMenu = false
    self.mode_menu_path:SetActive(false)
    if self.modeMenu then
      self.modeMenu:RefreshView(false)
    end
  end
end

function UIMainMiniMapView:RefreshMeteoriteNews()
  if IsNull(self.meteoriteNewsRoot) then
    return
  end
  local currentState = DataCenter.ActMeteoriteBattleManager:GetMeteoriteEffectPlayerState()
  if currentState and currentState <= 0 then
    if self.meteoriteNews then
      self.meteoriteNews:SetActive(false)
    end
    return
  end
  if not self.meteoriteNews then
    self.meteoriteNews = self:LoadComponentAsync(MeteoriteBattleUtils.MetoriteNewsLuaPath, UIAssets.UIMeteoriteNewsItemRenderer, self.meteoriteNewsRoot, function()
      if self.meteoriteNews.rectTransform then
        self.meteoriteNews.rectTransform.anchoredPosition = Vector2.zero
      end
      self.meteoriteNews:Refresh(self.lodCache, currentState)
    end, nil, self.meteoriteNewsRoot.gameObject)
  else
    self.meteoriteNews:Refresh(self.lodCache, currentState)
  end
end

function UIMainMiniMapView:OnMeteoritePlayerStateChanged()
  self:RefreshMeteoriteNews()
end

local function RefreshMeteoriteNoticeComp(comp)
  if not comp then
    return
  end
  local currenrNotice = DataCenter.ActMeteoriteBattleManager:GetCurrentNotice()
  if not currenrNotice then
    comp:Close()
    return
  end
  if comp then
    comp:Refresh(currenrNotice)
  end
end

function UIMainMiniMapView:RefreshMeteoriteNotice()
  if IsNull(self.meteoriteNoticeRoot) then
    return
  end
  local battleInfo = DataCenter.ActMeteoriteBattleManager:GetBattleWorldInfo()
  if not battleInfo then
    if self.meteoriteNotice then
      self.meteoriteNotice:Close()
    else
      self.meteoriteNoticeRoot.gameObject:SetActive(false)
    end
  elseif not self.meteoriteNotice then
    self.meteoriteNotice = self:LoadComponentAsync(MeteoriteBattleUtils.NoticeItemRenderLuaPath, UIAssets.UIMeteoriteNoticeItemRenderer, self.meteoriteNoticeRoot, function()
      RefreshMeteoriteNoticeComp(self.meteoriteNotice)
    end, nil, self.meteoriteNoticeRoot.gameObject)
  else
    RefreshMeteoriteNoticeComp(self.meteoriteNotice)
  end
end

function UIMainMiniMapView:OnClickedMeteoriteNews()
  DataCenter.ActMeteoriteBattleManager:OpenActWindowPls()
end

function UIMainMiniMapView:OnMapInfoClick()
  local curServerId = LuaEntry.Player:GetCurServerId()
  local seasonType = SeasonUtil.GetSeasonType(false, true, ServerEnum.View)
  if seasonType == SeasonMapType.NineNation then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonMapDetailV2, {anim = true, playEffect = false}, curServerId)
  elseif seasonType == SeasonMapType.NineNationRainforest then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonMapDetailV6, {anim = true, playEffect = false}, curServerId)
  end
end

function UIMainMiniMapView:RefreshKingInfo()
  if BattleFieldUtil.InBattleField() then
    self.king_occupy:SetActive(false)
  elseif CrossServerUtil.IsJumpToServerMode() then
    self.king_occupy:SetActive(false)
  else
    self.king_occupy:SetActive(true)
    local serverId = LuaEntry.Player:GetCurServerId()
    local badgesIconPath = DataCenter.ZoneWarManager:GetKingdomBadgesIconPath(serverId)
    local kingInfo = DataCenter.GovernmentManager:GetCrossServerKingInfo(serverId)
    local king = kingInfo and kingInfo.king or nil
    self.king_badges:LoadSprite(badgesIconPath)
    if king ~= nil then
      if king.serverId == serverId then
        self.king_name_text:SetText(UIUtil.FormatAllianceAndName(king.allianceAbbr, king.name, king.uid))
      else
        self.king_name_text:SetText(UIUtil.FormatServerAllianceName(king.serverId, king.allianceAbbr, king.name, king.uid))
      end
      self.king_name_text:SetActive(true)
    else
      self.king_name_text:SetActive(false)
    end
    if self.bigMapMode then
      local info = SeasonUtil.GetSeasonInfo(serverId)
      if info ~= nil then
        local mapIndex = info:GetNinePalacesIndex(serverId)
        if mapIndex == 5 and king == nil then
          local kingCfg = DataCenter.AllianceCityTemplateManager:GetKingCityData(serverId)
          if kingCfg and kingCfg.lod_icon ~= nil and kingCfg.lod_icon ~= "" then
            self.king_badges:LoadSprite(kingCfg.lod_icon)
          else
            self.king_badges:LoadSprite("Assets/Main/Sprites/ItemIcons/lrb_zhanqvduijue_tubiao_fuwuqi02.png")
          end
        end
      end
      self.king_badges:SetSizeDeltaXY(99, 99)
      self.king_occupy:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/FX_common_4xp.png")
      self.king_occupy:SetColorRGBA(0, 0, 0, 0.7)
    end
    self.king_server:SetText(Localization:GetString("457067") .. " #" .. serverId)
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.king_occupy.rectTransform)
  end
end

function UIMainMiniMapView:RefreshLandlordBattleTime()
  local showFlag = self:CheckShowLL()
  local isInLandlordBattle = showFlag and DataCenter.LandlordMgr:IsInBattle()
  self.time_tips:SetActive(isInLandlordBattle)
  if isInLandlordBattle then
    local stageInfo = DataCenter.LandlordMgr:GetActCurStageInfo()
    self.endTime = stageInfo and stageInfo.eTime * 1000 or 0
    self:Update1000MS()
  else
    self.endTime = nil
  end
end

function UIMainMiniMapView:RefreshLandlordBattleInfo()
  if self.mini_btn_group == nil then
    return
  end
  self:RefreshLandlordActBtn()
  self:RefreshLandlordInfo()
  self:RefreshLandlordProgress()
  self:RefreshLandlordBattleTime()
end

function UIMainMiniMapView:CheckShowLL()
  if not self.bigMapMode or self.lodCache < 3 then
    return false
  end
  local curStage = DataCenter.LandlordMgr:GetActCurStage()
  local showFlag = curStage >= LLConst.LandlordStage.GROUP
  if showFlag then
    local curSId = LuaEntry.Player:GetCurServerId()
    local centerId = DataCenter.SeasonDataManager:GetNinePalacesServer(5, ServerEnum.View)
    showFlag = curSId == centerId
  end
  return showFlag
end

function UIMainMiniMapView:RefreshLandlordActBtn()
  if self.landlordActRoot == nil then
    return
  end
  local showFlag = self:CheckShowLL()
  self.landlordActRoot:SetActive(showFlag)
  if showFlag then
    if self.llActReq == nil then
      self.llActReq = self:GameObjectInstantiateAsync(LL_ACT_BTN_PREFAB, function(req)
        if req.isError then
          self.llActReq:Destroy()
          self.llActReq = nil
          return
        end
        local go = req.gameObject
        go.name = "LLActBtn"
        local tf = go.transform
        tf.parent = self.landlordActRoot.transform
        tf:Reset()
        self.compLLAct = self.landlordActRoot:AddComponent(UIKingBtn, go.name)
        self.compLLAct:RefreshShowState()
      end)
    elseif self.compLLAct ~= nil then
      self.compLLAct:RefreshShowState()
    end
  end
end

function UIMainMiniMapView:RefreshLandlordInfo()
  local showFlag = self:CheckShowLL()
  if self.llInfoComp ~= nil then
    self.llInfoComp:SetActive(showFlag)
  elseif showFlag then
    self.llInfoComp = self:LoadComponentAsync(LLConst.CLS_MINIMAP_INFO, LLConst.PREFAB_MINIMAP_INFO, self.mini_btn_group)
    self.llInfoComp:SetSiblingIndex(0)
    self.llInfoComp:SetClickCb(BindCallback(self, self.ShowLandlordInfoTip))
    self.llInfoComp:SetActive(true)
  end
  if showFlag then
    self.mini_btn_group:SetActive(true)
  elseif not self.info_btn:GetActive() then
    self.mini_btn_group:SetActive(false)
  end
end

function UIMainMiniMapView:RefreshLandlordProgress()
  local showFlag = self:CheckShowLL()
  if self.llProgressComp ~= nil then
    self.llProgressComp:SetActive(showFlag)
  elseif showFlag then
    self.llProgressComp = self:LoadComponentAsync(LLConst.CLS_MINIMAP_PROGRESS, LLConst.PREFAB_MINIMAP_PROGRESS, self.obj, function()
      if self.llProgressComp then
        self.llProgressComp:SetAnchoredPositionXY(0, 240)
      end
    end)
    self.llProgressComp:SetCamp(DataCenter.LandlordMgr:GetMyGroup(), true, true)
    self.llProgressComp:SetActive(true)
  end
end

function UIMainMiniMapView:ShowLandlordInfoTip()
  if self.llInfoTipComp == nil then
    self.llInfoTipComp = self:LoadComponentAsync(LLConst.CLS_MINIMAP_INFO_TIP, LLConst.PREFAB_MINIMAP_INFO_TIP, self.obj, function()
      if self.llInfoTipComp and self.llInfoComp then
        local worldPos = self.llInfoComp:GetPosition()
        local localPos = self.obj.transform:InverseTransformPoint(worldPos)
        self.llInfoTipComp:SetLocalPositionXYZ(localPos.x - 55, localPos.y + 50, localPos.z)
      end
    end)
  end
  self.llInfoTipComp:SetActive(true)
end

function UIMainMiniMapView:Update1000MS()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.endTime and curTime < self.endTime then
    local remainTime = self.endTime - curTime
    self.remain_time:SetText(UITimeManager:GetInstance():SecondToFmtStringWithoutHour(remainTime / 1000))
  elseif self.endTime and curTime >= self.endTime then
    self.endTime = nil
    self.remain_time:SetText("")
    self.time_tips:SetActive(false)
  end
end

function UIMainMiniMapView:Description()
  local sb = StringBuilder.New()
  sb:AppendFormatLine("curLod:%s", self.lodCache)
  return sb:ToString()
end

UIMainMiniMapView.OnCreate = OnCreate
UIMainMiniMapView.OnDestroy = OnDestroy
UIMainMiniMapView.OnEnable = OnEnable
UIMainMiniMapView.OnDisable = OnDisable
UIMainMiniMapView.ComponentDefine = ComponentDefine
UIMainMiniMapView.ComponentDestroy = ComponentDestroy
UIMainMiniMapView.DataDefine = DataDefine
UIMainMiniMapView.DataDestroy = DataDestroy
UIMainMiniMapView.ReInit = ReInit
UIMainMiniMapView.SetMapActive = SetMapActive
UIMainMiniMapView.OnAddListener = OnAddListener
UIMainMiniMapView.OnRemoveListener = OnRemoveListener
UIMainMiniMapView.ShowMiniMap = ShowMiniMap
UIMainMiniMapView.HideMiniMap = HideMiniMap
UIMainMiniMapView.RefreshPlayerInfo = RefreshPlayerInfo
UIMainMiniMapView.RefreshStamina = RefreshStamina
UIMainMiniMapView.RefreshHeroIcon = RefreshHeroIcon
UIMainMiniMapView.GoHomeBtnClick = GoHomeBtnClick
UIMainMiniMapView.HeatMapSwitchClick = HeatMapSwitchClick
UIMainMiniMapView.OnHeatMapSwitch = OnHeatMapSwitch
return UIMainMiniMapView
