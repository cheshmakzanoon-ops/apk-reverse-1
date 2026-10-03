local UIGhostParkourBattleMainView = BaseClass("UIGhostParkourBattleMainView", UIBaseView)
local base = UIBaseView
local UISurfingBuffItem = require("UI.UISurfing.Inside.Main.Component.UISurfingBuffItem")
local UISurfingBattleGMItem = require("UI.UISurfing.Inside.Main.Component.UISurfingBattleGMItem")
local UIGhostParkourMainPlayerTagItem = require("UI.UIGhostParkour.Inside.Main.Component.UIGhostParkourMainPlayerTagItem")
local UIGhostParkourMainPlayerArrowItem = require("UI.UIGhostParkour.Inside.Main.Component.UIGhostParkourMainPlayerArrowItem")
local UIGhostParkourMainPlayerHeadItem = require("UI.UIGhostParkour.Inside.Main.Component.UIGhostParkourMainPlayerHeadItem")
local back_btn_path = "Root/BottomGroup/BackBtn"
local main_root_path = "MainRoot"
local buff_root_path = "MainRoot/BottomGroup/BuffRoot"
local buff_item_path = "MainRoot/BottomGroup/BuffRoot/BuffItem"
local g_m_path = "MainRoot/GM"
local nitrogen_root_path = "MainRoot/NitrogenRoot"
local progress_path = "MainRoot/NitrogenRoot/NitrogenBg/Progress"
local ranking_txt_path = "MainRoot/RankingRoot/RankingTxt"
local slider_path = "MainRoot/ProgressRoot/Slider"
local time_txt_path = "MainRoot/TimeRoot/TimeTxt"
local energy_num_txt_path = "MainRoot/NitrogenRoot/NitrogenBg/EnergyNumTxt"
local icon_path = "MainRoot/NitrogenRoot/NitrogenBg/Icon"
local speed_txt_path = "MainRoot/SpeedRoot/SpeedTxt"
local dash_board_path = "MainRoot/SpeedRoot/DashBoard"
local sub_root_path = "MainRoot/ProgressRoot/SubRoot"
local sub_path = "MainRoot/ProgressRoot/SubRoot/Sub"
local self_head_root_path = "MainRoot/ProgressRoot/Slider/SelfHeadRoot"
local self_head_path = "MainRoot/ProgressRoot/Slider/SelfHeadRoot/SelfHead"
local player_head_root_path = "MainRoot/ProgressRoot/Slider/PlayerHeadRoot"
local player_head_tag_path = "PlayerRoot/PlayerHeadTag"
local player_head_arrow_path = "PlayerRoot/PlayerHeadArrow"
local playback_root_path = "PlaybackRoot"
local playback_tips_path = "PlaybackRoot/TipsBg/PlaybackTips"
local eff_ui_y_z_p_k_huodenengliang_path = "MainRoot/NitrogenRoot/NitrogenBg/Eff_ui_YZPK_huodenengliang"
local eff_ui_y_z_p_k_suduxian_path = "Eff_ui_YZPK_suduxian"
local player_tag_root_path = "PlayerRoot/PlayerTagRoot"
local player_arrow_root_path = "PlayerRoot/PlayerArrowRoot"
local head_root_path = "MainRoot/ProgressRoot/Slider/HeadRoot"
local eff_ui_y_z_p_k_dash_board_grow_d_path = "MainRoot/SpeedRoot/DashBoard/Eff_ui_YZPK_DashBoard_grow_d"
local slider_glow_path = "MainRoot/SpeedRoot/DashBoard/Eff_ui_YZPK_DashBoard_grow_d/slider_glow"
local eff_ui_y_z_p_k_dash_board_grow_u_path = "MainRoot/SpeedRoot/Eff_ui_YZPK_DashBoard_grow_u"
local eff_ui_y_z_p_k_dash_board_full_path = "MainRoot/SpeedRoot/Eff_ui_YZPK_DashBoard_full"
local Localization = CS.GameEntry.Localization
local HIGHEST_POSY = 230
local LOWEST_POSY = -232
local LEFT_PADDING = 100
local BOTTOM_PADDING = 220
local MIN_FILL_VALUE = 0.1
local MAX_FILL_VALUE = 0.89
local SPEED_EFFECT_MIN_VALUE = 0
local SPEED_EFFECT_MAX_VALUE = 170
local SPEED_TEXT_MIN_SCALE = 1
local SPEED_TEXT_MAX_SCALE = 1.5
local EDGE_OFFSET_VALUE = {0, 0.1}

function UIGhostParkourBattleMainView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitView()
end

function UIGhostParkourBattleMainView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIGhostParkourBattleMainView:ComponentDefine()
  self.back_btn = self:AddComponent(UIButton, back_btn_path)
  self.back_btn:SetOnClick(function()
    self:OnBackBtnClick()
  end)
  self.main_root = self:AddComponent(UIBaseContainer, main_root_path)
  self.main_root:SetActive(false)
  self.buff_root = self:AddComponent(UIBaseContainer, buff_root_path)
  self.buff_item_go = self.transform:Find(buff_item_path).gameObject
  self.buff_item_go:GameObjectCreatePool()
  local isDebug = CS.CommonUtils.IsDebug()
  local isEditor = CS.UnityEngine.Application.isEditor
  local logic = DataCenter.LWBattleManager:GetCurBattleLogic()
  if (isDebug or isEditor) and logic and not logic.isPlayback then
    self.g_m = self:AddComponent(UISurfingBattleGMItem, g_m_path)
    self.g_m:SetActive(true)
  end
  self.nitrogen_btn = self:AddComponent(UIButton, nitrogen_root_path)
  self.nitrogen_btn:SetOnClick(function()
    self:OnNitrogenBtnClick()
  end)
  self.nitrogen_anim = self:AddComponent(UIAnimator, nitrogen_root_path)
  self.nitrogen_anim:Play("V_ui_GhostParkour_default")
  self.progress = self:AddComponent(UIImage, progress_path)
  self.progress:SetFillAmount(0)
  self.ranking_txt = self:AddComponent(UITextMeshProUGUIEx, ranking_txt_path)
  self.slider = self:AddComponent(UISlider, slider_path)
  self.time_txt = self:AddComponent(UITextMeshProUGUIEx, time_txt_path)
  self.energy_num_txt = self:AddComponent(UITextMeshProUGUIEx, energy_num_txt_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.speed_txt = self:AddComponent(UITextMeshProUGUIEx, speed_txt_path)
  self.speed_anim = self.speed_txt.transform:GetComponent(typeof(CS.UnityEngine.Animation))
  self.dash_board = self:AddComponent(UIImage, dash_board_path)
  self.sub_root = self:AddComponent(UIBaseContainer, sub_root_path)
  self.item = self.transform:Find(sub_path).gameObject
  self.item:GameObjectCreatePool()
  self.self_head_root = self:AddComponent(UIBaseContainer, self_head_root_path)
  self.self_head = self:AddComponent(UICommonHead, self_head_path)
  self.self_head:SetEnableClickShowInfo(false)
  self.playback_root = self:AddComponent(UIBaseContainer, playback_root_path)
  self.playback_root:SetActive(false)
  self.playback_tips = self:AddComponent(UITextMeshProUGUIEx, playback_tips_path)
  self.eff_ui_y_z_p_k_huodenengliang = self:AddComponent(UIBaseContainer, eff_ui_y_z_p_k_huodenengliang_path)
  self.eff_ui_y_z_p_k_huodenengliang:SetActive(false)
  self.eff_ui_y_z_p_k_suduxian = self:AddComponent(UIImage, eff_ui_y_z_p_k_suduxian_path)
  self.eff_ui_y_z_p_k_suduxian:SetActive(false)
  local rectSize = self.rectTransform.rect
  local scaleWidth = rectSize.width / DefaultScreenWidth
  local scaleHeight = rectSize.height / DefaultScreenHeight
  self.eff_ui_y_z_p_k_suduxian:SetLocalScaleXYZ(scaleWidth, scaleHeight, 1)
  self.player_tag_root = self:AddComponent(UIBaseContainer, player_tag_root_path)
  self.tag_item = self.transform:Find(player_head_tag_path).gameObject
  self.tag_item:GameObjectCreatePool()
  self.player_arrow_root = self:AddComponent(UIBaseContainer, player_arrow_root_path)
  self.arrow_item = self.transform:Find(player_head_arrow_path).gameObject
  self.arrow_item:GameObjectCreatePool()
  self.head_root = self:AddComponent(UIBaseContainer, head_root_path)
  self.player_head_item = self.transform:Find(player_head_root_path).gameObject
  self.player_head_item:GameObjectCreatePool()
  self.eff_ui_y_z_p_k_dash_board_grow_d = self:AddComponent(UIBaseContainer, eff_ui_y_z_p_k_dash_board_grow_d_path)
  self.eff_ui_y_z_p_k_dash_board_grow_d:SetActive(false)
  self.slider_glow = self:AddComponent(UIBaseContainer, slider_glow_path)
  self.eff_ui_y_z_p_k_dash_board_grow_u = self:AddComponent(UIBaseContainer, eff_ui_y_z_p_k_dash_board_grow_u_path)
  self.eff_ui_y_z_p_k_dash_board_grow_u:SetActive(false)
  self.eff_ui_y_z_p_k_dash_board_full = self:AddComponent(UIBaseContainer, eff_ui_y_z_p_k_dash_board_full_path)
  self.eff_ui_y_z_p_k_dash_board_full:SetActive(false)
end

function UIGhostParkourBattleMainView:ComponentDestroy()
  if self.fullTimer then
    self.fullTimer:Stop()
  end
  self.fullTimer = nil
  if self.clickTimer then
    self.clickTimer:Stop()
  end
  self.clickTimer = nil
  if self.resetTimer then
    self.resetTimer:Stop()
  end
  self.resetTimer = nil
  self.back_btn = nil
  self.main_root = nil
  self.buff_root = nil
  self.buff_item_go:GameObjectRecycleAll()
  self.buff_item_go = nil
  self.g_m = nil
  self.nitrogen_btn = nil
  self.nitrogen_anim = nil
  self.progress = nil
  self.ranking_txt = nil
  self.slider = nil
  self.time_txt = nil
  self.energy_num_txt = nil
  self.icon = nil
  self.speed_txt = nil
  self.speed_anim = nil
  self.dash_board = nil
  self.sub_root = nil
  self.item:GameObjectRecycleAll()
  self.item = nil
  self.self_head_root = nil
  self.self_head = nil
  self.playback_root = nil
  self.playback_tips = nil
  self.eff_ui_y_z_p_k_huodenengliang = nil
  self.eff_ui_y_z_p_k_suduxian = nil
  self.player_tag_root:RemoveComponents(UIGhostParkourMainPlayerTagItem)
  self.player_tag_root = nil
  self.tag_item:GameObjectRecycleAll()
  self.tag_item = nil
  self.player_arrow_root:RemoveComponents(UIGhostParkourMainPlayerArrowItem)
  self.player_arrow_root = nil
  self.arrow_item:GameObjectRecycleAll()
  self.arrow_item = nil
  self.head_root:RemoveComponents(UIGhostParkourMainPlayerHeadItem)
  self.head_root = nil
  self.player_head_item:GameObjectRecycleAll()
  self.player_head_item = nil
  self.eff_ui_y_z_p_k_dash_board_grow_d = nil
  self.slider_glow = nil
  self.eff_ui_y_z_p_k_dash_board_grow_u = nil
  self.eff_ui_y_z_p_k_dash_board_full = nil
end

function UIGhostParkourBattleMainView:DataDefine()
  self.frame = 0
  self.validBuffList = {}
  self.buffList = {}
  self.buffCount = 0
  self.logic = nil
  self.displayTime = nil
  self.pause = nil
  self.canSpeedUp = nil
  self.needEnergy = 0
  self.curEnergy = 0
  self.player_head_roots = {}
  self.player_name_roots = {}
  self.player_arrow_roots = {}
  self.camera = nil
  self.cacheVector3 = Vector3.New(0, 0, 0)
  self.cachePos = Vector3.New(0, 0, 0)
  self.count = 0
  self.hideDistance = LuaEntry.DataConfig:TryGetNum("parkour_ghost_config", "k5", 50)
  self.showTopArrowDis = LuaEntry.DataConfig:TryGetNum("parkour_ghost_config", "k25", 100)
  self.displayDistance = 0
  self.isStart = false
  self.maxSpeed = 0
  self.isGuide = nil
  self.pause = nil
end

function UIGhostParkourBattleMainView:DataDestroy()
  self.frame = nil
  self.validBuffList = nil
  self.buffList = nil
  self.buffCount = nil
  self.logic = nil
  self.displayTime = nil
  self.pause = nil
  self.canSpeedUp = nil
  self.needEnergy = nil
  self.curEnergy = nil
  self.player_head_roots = nil
  self.player_name_roots = nil
  self.player_arrow_roots = nil
  self.camera = nil
  self.cacheVector3 = nil
  self.cachePos = nil
  self.count = nil
  self.hideDistance = nil
  self.showTopArrowDis = nil
  self.displayDistance = nil
  self.isStart = nil
  self.maxSpeed = nil
  self.isGuide = nil
  self.pause = nil
end

function UIGhostParkourBattleMainView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnPVEBattleGetGoods, self.OnPVEBattleGetGoods)
  self:AddUIListener(EventId.SurfingOnBuffAdd, self.OnBuffAdd)
  self:AddUIListener(EventId.SurfingOnBuffRemove, self.OnBuffRemove)
  self:AddUIListener(EventId.GhostParkourOnBattlePaused, self.OnBattlePaused)
end

function UIGhostParkourBattleMainView:OnRemoveListener()
  self:RemoveUIListener(EventId.OnPVEBattleGetGoods, self.OnPVEBattleGetGoods)
  self:RemoveUIListener(EventId.SurfingOnBuffAdd, self.OnBuffAdd)
  self:RemoveUIListener(EventId.SurfingOnBuffRemove, self.OnBuffRemove)
  self:RemoveUIListener(EventId.GhostParkourOnBattlePaused, self.OnBattlePaused)
  base.OnRemoveListener(self)
end

local GetTimeFormat = DataCenter.LWGhostParkourDataManager.GetTimeFormat

local function Round1(x)
  return Mathf.Floor(x * 10 + 0.5) / 10
end

function UIGhostParkourBattleMainView:Update()
  if self.pause then
    return
  end
  if not self.isStart then
    return
  end
  if self.logic then
    local logic = self.logic
    local totalRuntime = logic:GetCurTotalRunTime()
    local currentInt = Mathf.Floor(totalRuntime * 1000)
    if currentInt ~= self.displayTime then
      self.displayTime = currentInt
      self.time_txt:SetText(GetTimeFormat(self, currentInt))
    end
    local curSpeed = logic:GetCurSpeed()
    curSpeed = Round1(curSpeed)
    if curSpeed ~= self.displaySpeed then
      self.speed_txt:SetText(curSpeed)
      if self.maxSpeed > 0 then
        local value = curSpeed / self.maxSpeed
        value = (MAX_FILL_VALUE - MIN_FILL_VALUE) * value + MIN_FILL_VALUE
        if value < MIN_FILL_VALUE then
          value = MIN_FILL_VALUE
        elseif value > MAX_FILL_VALUE then
          value = MAX_FILL_VALUE
        end
        if value <= 0.5 then
          self.speed_txt:SetLocalScaleXYZ(SPEED_TEXT_MIN_SCALE, SPEED_TEXT_MIN_SCALE, SPEED_TEXT_MIN_SCALE)
        else
          local scale = (value - 0.5) / 0.5 * (SPEED_TEXT_MAX_SCALE - SPEED_TEXT_MIN_SCALE) + SPEED_TEXT_MIN_SCALE
          self.speed_txt:SetLocalScaleXYZ(scale, scale, scale)
        end
        if 0.5 <= value and curSpeed > self.displaySpeed then
          if not self.playSpeedAnim then
            if IsNotNull(self.speed_anim) then
              self.speed_anim:Play("V_ui_UIGhostParkourBattleMain_SpeedTxt_shake")
            end
            self.playSpeedAnim = true
          end
        elseif self.playSpeedAnim then
          if IsNotNull(self.speed_anim) then
            self.speed_anim:Stop()
          end
          self.playSpeedAnim = false
        end
        if curSpeed > self.displaySpeed then
          local growValue = (SPEED_EFFECT_MAX_VALUE - SPEED_EFFECT_MIN_VALUE) * value
          self.slider_glow:SetEulerAnglesXYZ(0, 180, growValue)
          if not self.playSpeedupEffect then
            self.eff_ui_y_z_p_k_dash_board_grow_d:SetActive(false)
            self.eff_ui_y_z_p_k_dash_board_grow_d:SetActive(true)
            self.eff_ui_y_z_p_k_dash_board_grow_u:SetActive(false)
            self.eff_ui_y_z_p_k_dash_board_grow_u:SetActive(true)
            self.playSpeedupEffect = true
          end
        elseif self.playSpeedupEffect then
          self.eff_ui_y_z_p_k_dash_board_grow_d:SetActive(false)
          self.eff_ui_y_z_p_k_dash_board_grow_u:SetActive(false)
          self.playSpeedupEffect = false
        end
        if self.playFullEffect then
          self.eff_ui_y_z_p_k_dash_board_full:SetActive(false)
          self.playFullEffect = false
        end
        self.dash_board:SetFillAmount(value)
        self.displaySpeed = curSpeed
      end
    else
      if self.displaySpeed == self.maxSpeed then
        if not self.playSpeedAnim then
          if IsNotNull(self.speed_anim) then
            self.speed_anim:Play("V_ui_UIGhostParkourBattleMain_SpeedTxt_shake")
          end
          self.playSpeedAnim = true
        end
        if not self.playFullEffect then
          self.eff_ui_y_z_p_k_dash_board_full:SetActive(false)
          self.eff_ui_y_z_p_k_dash_board_full:SetActive(true)
          self.playFullEffect = true
        end
      else
        if self.playSpeedAnim then
          if IsNotNull(self.speed_anim) then
            self.speed_anim:Stop()
          end
          self.playSpeedAnim = false
        end
        if self.playFullEffect then
          self.eff_ui_y_z_p_k_dash_board_full:SetActive(false)
          self.playFullEffect = false
        end
      end
      if self.playSpeedupEffect then
        self.eff_ui_y_z_p_k_dash_board_grow_d:SetActive(false)
        self.eff_ui_y_z_p_k_dash_board_grow_u:SetActive(false)
        self.playSpeedupEffect = false
      end
    end
    local distance = logic:GetCurDistanceData()
    if distance ~= self.displayDistance then
      self.displayDistance = distance
      local value = distance / self.maxMeters
      value = value < 1 and value or 1
      self.slider:SetValue(value)
      local posy = self.total_posy * value + LOWEST_POSY
      self.self_head_root:SetAnchoredPositionXY(30, posy)
    end
    local rank = 1
    if 0 < self.count then
      local posArr = logic:GetPlayersPosition()
      if posArr and #posArr == self.count and self.player_name_roots and self.player_arrow_roots then
        local pos, z, nameRoot, arrow
        local localPos = logic:GetCurPos()
        if localPos == nil then
          if self.rank ~= rank then
            self.rank = rank
            self.ranking_txt:SetLocalText("ghost_parkour_rank_num", rank)
          end
          return
        end
        for i, v in ipairs(self.player_head_roots) do
          if v then
            pos = posArr[i]
            z = pos and pos.z or 0
            if distance < z then
              rank = rank + 1
            end
            self:SetPlayerPosy(v, z)
            nameRoot = self.player_name_roots[i]
            arrow = self.player_arrow_roots[i]
            self:UpdatePlayerNameUI(pos, nameRoot, arrow, localPos, distance, i)
          end
        end
      end
    end
    if self.rank ~= rank then
      self.rank = rank
      self.ranking_txt:SetLocalText("ghost_parkour_rank_num", rank)
    end
  end
end

function UIGhostParkourBattleMainView:Update100MS()
  if self.pause then
    return
  end
  if self.buffCount and self.buffCount > 0 then
    for _, v in pairs(self.validBuffList) do
      if v then
        v:OnUpdate()
      end
    end
  end
end

function UIGhostParkourBattleMainView:InitView()
  local logic = DataCenter.LWBattleManager:GetCurBattleLogic()
  self.logic = logic
  if logic == nil then
    Logger.LogError("GhostParkour -- [InitView] logic is nil")
    return
  end
  self.isGuide = logic.isGuide
  if self.isGuide then
    self.main_root:SetActive(true)
    self.isStart = true
    self:InitPlayPanel()
  end
  self.maxSpeed = logic:GetNitrogenBuffSpeed() or 0
  local message = self:GetUserData()
  self.camera = CS.UnityEngine.Camera.main
  if message then
    local isPlayback = logic.isPlayback
    self.isPlayback = isPlayback
    if isPlayback then
      self:InitPlaybackPanel(message)
      self.playback_root:SetActive(true)
      self.playback_tips:SetLocalText("ghost_parkour_replay")
    else
      self:InitPlayPanel(message)
    end
  end
  self.needEnergy = logic and logic:GetNitrogenNeedEnergy() or 0
  self.posy_center = (HIGHEST_POSY + LOWEST_POSY) / 2
  self.total_posy = HIGHEST_POSY - LOWEST_POSY
  if logic then
    local totalRuntime = 0
    self.displayTime = totalRuntime
    self.time_txt:SetText(GetTimeFormat(self, totalRuntime))
    local displaySpeed = 0
    displaySpeed = Round1(displaySpeed)
    self.displaySpeed = displaySpeed
    self.speed_txt:SetText(displaySpeed)
    if self.maxSpeed > 0 then
      local value = displaySpeed / self.maxSpeed
      value = (MAX_FILL_VALUE - MIN_FILL_VALUE) * value + MIN_FILL_VALUE
      if value < MIN_FILL_VALUE then
        value = MIN_FILL_VALUE
      elseif value > MAX_FILL_VALUE then
        value = MAX_FILL_VALUE
      end
      self.dash_board:SetFillAmount(value)
    end
    self.maxMeters = logic:GetMaxMeters()
    local distance = 0
    self.displayDistance = distance
    local progressValue = Mathf.Clamp(distance / self.maxMeters, 0, 1)
    self.slider:SetValue(progressValue)
    local posy = self.total_posy * progressValue + LOWEST_POSY
    self.self_head_root:SetAnchoredPositionXY(30, posy)
    if 0 < self.count then
      local posArr = logic:GetPlayersPosition()
      if posArr and #posArr == self.count and self.player_head_roots then
        for i, v in ipairs(self.player_head_roots) do
          if v then
            v:SetAnchoredPositionXY(30, posy)
          end
        end
      end
    end
    local rank = 1
    self.rank = rank
    self.ranking_txt:SetLocalText("ghost_parkour_rank_num", rank)
  end
  self.curEnergy = 0
  self.progress:SetFillAmount(0)
  self.energy_num_txt:SetText(0 .. "/" .. self.needEnergy)
  local num = LuaEntry.DataConfig:TryGetNum("parkour_ghost_config_c", "k4") or 16
  self:SpawnSubItems(num)
  local goodsId = LuaEntry.DataConfig:TryGetNum("parkour_ghost_config_c", "k2") or 0
  local itemTemplate = DataCenter.ItemTemplateManager:TryGetItemTemplate(goodsId)
  if itemTemplate then
    local iconUrl = string.format(LoadPath.ItemPath, itemTemplate.icon)
    self.icon:LoadSpriteAuto(iconUrl)
  end
end

function UIGhostParkourBattleMainView:InitPlayPanel(message)
  local player = LuaEntry.Player
  if player then
    local uid = player:GetUid()
    local headPic = player:GetPic()
    local headPicVer = player:GetPicVer()
    self.self_head:SetHead(uid, headPic, headPicVer, nil, nil)
  end
  if message == nil then
    return
  end
  if message.matchList then
    local matchList = message.matchList
    local count = table.count(matchList)
    self.count = count
    if count == 1 then
      local player1 = matchList[1]
      if player1.markFlag ~= 1 then
        self:SpawnOneTagItem(1, player1)
        self:SpawnOneArrowItem(1, player1)
        self:SpawnOneHeadItem(1, player1)
      else
        self.count = 0
      end
    elseif count == 2 then
      local player1 = matchList[1]
      local index = 0
      if player1.markFlag ~= 1 then
        index = index + 1
        self:SpawnOneTagItem(index, player1)
        self:SpawnOneArrowItem(index, player1)
        self:SpawnOneHeadItem(index, player1)
      else
        self.count = self.count - 1
      end
      local player2 = matchList[2]
      if player2.markFlag ~= 1 then
        index = index + 1
        self:SpawnOneTagItem(index, player2)
        self:SpawnOneArrowItem(index, player2)
        self:SpawnOneHeadItem(index, player2)
      else
        self.count = self.count - 1
      end
    end
  end
end

function UIGhostParkourBattleMainView:InitPlaybackPanel(message)
  if message == nil then
    return
  end
  if message.firstInfo then
    local firstInfo = message.firstInfo
    if firstInfo.markFlag ~= 1 then
      local uid = firstInfo.uid
      local pic = firstInfo.pic
      local picver = firstInfo.picver
      self.self_head:SetHead(uid, pic, picver, nil, nil)
    end
  end
  if message.otherInfo then
    local count = 1
    self.count = count
    local otherInfo = message.otherInfo
    if otherInfo.markFlag ~= 1 then
      self:SpawnOneTagItem(1, otherInfo)
      self:SpawnOneArrowItem(1, otherInfo)
      self:SpawnOneHeadItem(1, otherInfo)
    else
      self.count = 0
    end
  end
end

function UIGhostParkourBattleMainView:OnStart()
  self.main_root:SetActive(true)
  self.isStart = true
end

function UIGhostParkourBattleMainView:SetPlayerPosy(headRoot, distance)
  local value = distance / self.maxMeters
  value = value < 1 and value or 1
  local posy = self.total_posy * value + LOWEST_POSY
  headRoot:SetAnchoredPositionXY(30, posy)
end

local function GetZRollDist(worldPos, cameraPosWSz)
  local distance = worldPos.z - cameraPosWSz
  if distance < 0 then
    distance = 0
  end
  return distance * distance
end

local function GetCurvedWorldPos(camPos, worldPos, rollZ, rollW, cachePos)
  cachePos.x = 0
  cachePos.y = 0
  cachePos.z = rollZ
  local relativeCam = camPos - cachePos
  local distToPlayerZ = GetZRollDist(worldPos, relativeCam.z)
  cachePos.x = worldPos.x - distToPlayerZ * rollW
  cachePos.y = worldPos.y
  cachePos.z = worldPos.z
  return cachePos
end

function UIGhostParkourBattleMainView:UpdatePlayerNameUI(playerWorldPos, tag, arrow, localPos, distance, index)
  if self.camera == nil then
    self.camera = CS.UnityEngine.Camera.main
  end
  local offset = playerWorldPos.z - distance
  if self.showTopArrowDis >= 9999 and offset > self.hideDistance then
    arrow:SetAnchoredPositionXY(314, -1123)
    tag:SetActive(false)
    return
  end
  if 2 < offset and offset <= self.hideDistance then
    local curvedWorldPos = GetCurvedWorldPos(self.camera.transform.position, playerWorldPos, -18, 8.0E-4, self.cachePos)
    local viewportPos = self.camera:WorldToViewportPoint(curvedWorldPos)
    local inView = viewportPos.z > 0 and 0 <= viewportPos.x and viewportPos.x <= 1 and 0 <= viewportPos.y and 1 >= viewportPos.y
    if inView then
      tag:SetActive(true)
      local containerRect = UIManager:GetInstance():GetUIContainerRect()
      local screenX = 0
      local screenY = 0
      if IsNotNull(containerRect) then
        screenX = containerRect.sizeDelta.x
        screenY = containerRect.sizeDelta.y
      end
      local x = viewportPos.x
      if CommonUtil.IsArabicAutoMirrorOpen() then
        x = 1 - x
      end
      local uiX = x * screenX
      local uiY = viewportPos.y * screenY
      self.cacheVector3.x = 30 + uiX
      self.cacheVector3.y = 50 + uiY
      tag:SetAnchoredPositionXY(self.cacheVector3.x, self.cacheVector3.y)
    else
      tag:SetActive(false)
    end
    arrow:SetAnchoredPositionXY(314, -1123)
  elseif -1 < offset and offset <= 2 then
    arrow:SetAnchoredPositionXY(314, -1123)
    tag:SetActive(false)
  else
    if offset >= self.hideDistance and offset < self.showTopArrowDis then
      arrow:SetAnchoredPositionXY(314, -1123)
      tag:SetActive(false)
      return
    end
    tag:SetActive(false)
    local toTarget = playerWorldPos - localPos
    local localRight = Vector3.right
    local localUp = Vector3.up
    local flatPos = Vector3.ProjectOnPlane(toTarget, localUp)
    local flatDir = flatPos.normalized
    local localForward = Vector3.forward
    local dotForward = Vector3.Dot(flatDir, localForward)
    local dotRight = Vector3.Dot(flatDir, localRight)
    local leftPadding = LEFT_PADDING
    local bottomPadding = BOTTOM_PADDING
    local screenX = 0
    local screenY = 0
    local baseWidth = DefaultScreenWidth
    local baseHeight = DefaultScreenHeight
    local containerRect = UIManager:GetInstance():GetUIContainerRect()
    if IsNotNull(containerRect) then
      screenX = containerRect.sizeDelta.x
      screenY = containerRect.sizeDelta.y
      if screenX <= 0 then
        screenX = baseWidth
      end
      if screenY <= 0 then
        screenY = baseHeight
      end
    end
    local posX = 0
    local posY = 0
    local screenXHalf = screenX * 0.5
    local screenYHalf = screenY * 0.5
    local angle = Mathf.Atan2(dotRight, dotForward) * Mathf.Rad2Deg
    if -45 < angle and angle < 45 then
      local t = Mathf.InverseLerp(-45, 45, angle)
      if t < 0.5 then
        t = t + EDGE_OFFSET_VALUE[index]
      else
        t = t - EDGE_OFFSET_VALUE[index]
      end
      local leftX = -(screenXHalf - leftPadding)
      local x = (screenX - leftPadding * 2) * t + leftX
      local y = screenYHalf - bottomPadding
      posX = x
      posY = y
    elseif 45 <= angle and angle < 135 then
      local t = Mathf.InverseLerp(45, 135, angle)
      local bottomY = -(screenYHalf - bottomPadding)
      local y = (screenY - bottomPadding * 2) * t + bottomY
      posX = screenXHalf - leftPadding
      posY = y
    elseif angle <= -45 and -135 < angle then
      local t = Mathf.InverseLerp(-135, -45, angle)
      local bottomY = -(screenYHalf - bottomPadding)
      local y = (screenY - bottomPadding * 2) * t + bottomY
      posX = -(screenXHalf - leftPadding)
      posY = y
    else
      local t = Mathf.InverseLerp(-180, 180, angle)
      if t < 0.5 then
        t = t + EDGE_OFFSET_VALUE[index]
      else
        t = t - EDGE_OFFSET_VALUE[index]
      end
      local leftX = -(screenXHalf - leftPadding)
      local x = (screenX - leftPadding * 2) * t + leftX
      posX = x
      posY = -(screenYHalf - bottomPadding)
    end
    arrow:SetAnchoredPositionXY(posX, posY)
    arrow:SetArrowRotation(-angle, offset)
    toTarget:ReturnPool()
    localRight:ReturnPool()
    localUp:ReturnPool()
    flatPos:ReturnPool()
    flatDir:ReturnPool()
    localForward:ReturnPool()
  end
end

function UIGhostParkourBattleMainView:AddBuffItem(param)
  if param == nil then
    return
  end
  local buff = param.buff
  if buff then
    local buffId = buff.meta.id
    local level = param.level or 1
    local item = self.validBuffList[buffId]
    if item == nil then
      if self.buffList and self.buffList[buffId] then
        item = self.buffList[buffId]
        self.buffList[buffId] = nil
        if item then
          self.validBuffList[buffId] = item
          self.buffCount = self.buffCount + 1
          if not item:GetActive() then
            item:SetActive(true)
            item.transform:SetAsLastSibling()
          end
          item:UpdateData(buff, level)
          return
        end
      end
      local go = self.buff_item_go:GameObjectSpawn(self.buff_root.transform)
      local name = buffId .. "_" .. buffId
      go.name = name
      item = self.buff_root:AddComponent(UISurfingBuffItem, name)
      item:SetActive(true)
      item:SetData(buff, level)
      self.validBuffList[buffId] = item
      self.buffCount = self.buffCount + 1
    else
      if not item:GetActive() then
        item:SetActive(true)
        item.transform:SetAsLastSibling()
      end
      item:UpdateData(buff, level)
    end
  end
end

function UIGhostParkourBattleMainView:RemoveBuff(buff)
  if buff then
    local buffId = buff.meta.id
    local item = self.validBuffList[buffId]
    if item then
      self.validBuffList[buffId] = nil
      self.buffCount = self.buffCount - 1
      item:SetActive(false)
      item:ResetData()
      self.buffList[buffId] = item
    end
  end
end

function UIGhostParkourBattleMainView:SpawnSubItems(count)
  local trans = self.sub_root.transform
  for i = 1, count - 1 do
    local goItem = self.item:GameObjectSpawn(trans)
    goItem.name = "item_" .. i
    goItem:SetActive(true)
  end
end

function UIGhostParkourBattleMainView:OnPVEBattleGetGoods(param)
  local count = param and param.goodsCount or 1
  self.curEnergy = self.curEnergy + count
  if self.curEnergy >= self.needEnergy then
    if self.canSpeedUp then
      return
    end
    self.canSpeedUp = true
    self.progress:SetFillAmount(1)
    self.energy_num_txt:SetText(self.needEnergy .. "/" .. self.needEnergy)
    local success, duration = self.nitrogen_anim:PlayAnimationReturnTime("V_ui_GhostParkour_nengliang")
    if success then
      if self.fullTimer then
        self.fullTimer:Stop()
      end
      self.fullTimer = TimerManager:GetInstance():DelayInvoke(function()
        if self.fullTimer then
          self.fullTimer:Stop()
        end
        if self.nitrogen_anim then
          self.nitrogen_anim:Play("V_ui_GhostParkour_nengliang_idle")
        end
      end, duration)
      DataCenter.LWSoundManager:PlaySound(11042, false)
    end
  else
    self.eff_ui_y_z_p_k_huodenengliang:SetActive(false)
    self.eff_ui_y_z_p_k_huodenengliang:SetActive(true)
    self.canSpeedUp = false
    self.progress:SetFillAmount(self.curEnergy / self.needEnergy)
    self.energy_num_txt:SetText(self.curEnergy .. "/" .. self.needEnergy)
  end
end

function UIGhostParkourBattleMainView:OnBackBtnClick()
  if self.context == nil then
    if self.isPlayback then
      self.context = Localization:GetString("ghost_parkour_exit_check_playback")
    else
      self.context = Localization:GetString("ghost_parkour_exit_check")
    end
  end
  UIUtil.ShowConfirmNew({
    contentText = self.context,
    btnNum = 2,
    showToggle = false,
    confirmBtnParam = {
      action = function()
        DataCenter.LWBattleManager:SetGameOver(true)
        if self.logic then
          self.logic:ExitSurfing()
        end
        DataCenter.LWGhostParkourDataManager:GoBackToActivityPanel()
      end
    }
  })
end

function UIGhostParkourBattleMainView:OnBuffAdd(param)
  self:AddBuffItem(param)
end

function UIGhostParkourBattleMainView:OnBuffRemove(buff)
  self:RemoveBuff(buff)
end

function UIGhostParkourBattleMainView:OnBattlePaused(pause)
  self.pause = pause
end

function UIGhostParkourBattleMainView:SyncTime(time)
  self.pause = true
  self.time_txt:SetText(GetTimeFormat(self, time))
end

function UIGhostParkourBattleMainView:OnNitrogenBtnClick()
  if self.isGuide or self.isPlayback then
    return
  end
  if self.canSpeedUp then
    self.canSpeedUp = false
    self:RefreshEnergy()
    if self.logic then
      self.logic:OnNitrogenSpeedUp()
    end
    self:OnNitrogenClickHandler()
  end
end

function UIGhostParkourBattleMainView:RefreshEnergy()
  if self.fullTimer then
    self.fullTimer:Stop()
  end
  self.curEnergy = 0
  self.progress:SetFillAmount(0)
  self.energy_num_txt:SetText(0 .. "/" .. self.needEnergy)
  self:OnNitrogenClickHandler()
end

function UIGhostParkourBattleMainView:OnNitrogenClickHandler()
  local success, duration = self.nitrogen_anim:PlayAnimationReturnTime("V_ui_GhostParkour_nengliang_restore")
  if success then
    if self.resetTimer then
      self.resetTimer:Stop()
    end
    self.resetTimer = TimerManager:GetInstance():DelayInvoke(function()
      if self.resetTimer then
        self.resetTimer:Stop()
      end
      self.nitrogen_anim:Play("V_ui_GhostParkour_default")
    end, duration)
    if self.clickTimer then
      self.clickTimer:Stop()
    end
    self.clickTimer = TimerManager:GetInstance():DelayInvoke(function()
      if self.clickTimer then
        self.clickTimer:Stop()
      end
      self.eff_ui_y_z_p_k_suduxian:SetActive(false)
      self.eff_ui_y_z_p_k_suduxian:SetActive(true)
    end, 0.15)
  end
  if IsNotNull(self.speed_anim) then
    self.speed_anim:Play("V_ui_UIGhostParkourBattleMain_SpeedTxt_shake")
  end
end

function UIGhostParkourBattleMainView:OnNitrogenSpeedUpFinished()
  self.eff_ui_y_z_p_k_suduxian:SetActive(false)
  if IsNotNull(self.speed_anim) then
    self.speed_anim:Stop()
  end
  self.playSpeedAnim = false
end

function UIGhostParkourBattleMainView:SpawnOneTagItem(index, data)
  if data == nil then
    return
  end
  local goItem = self.tag_item:GameObjectSpawn(self.player_tag_root.transform)
  local name = "tag_item_" .. UIUtil.GetLoopListItemIndex()
  goItem.name = name
  goItem:SetActive(true)
  local theItem = self.player_tag_root:AddComponent(UIGhostParkourMainPlayerTagItem, name)
  theItem:ReInit(data)
  theItem:SetAnchoredPositionXY(314, -1123)
  self.player_name_roots[index] = theItem
end

function UIGhostParkourBattleMainView:SpawnOneArrowItem(index, data)
  if data == nil then
    return
  end
  local goItem = self.arrow_item:GameObjectSpawn(self.player_arrow_root.transform)
  local name = "arrow_item_" .. UIUtil.GetLoopListItemIndex()
  goItem.name = name
  goItem:SetActive(true)
  local theItem = self.player_arrow_root:AddComponent(UIGhostParkourMainPlayerArrowItem, name)
  theItem:ReInit(data)
  theItem:SetAnchoredPositionXY(314, -1123)
  self.player_arrow_roots[index] = theItem
end

function UIGhostParkourBattleMainView:SpawnOneHeadItem(index, data)
  if data == nil then
    return
  end
  local goItem = self.player_head_item:GameObjectSpawn(self.head_root.transform)
  local name = "head_item_" .. UIUtil.GetLoopListItemIndex()
  goItem.name = name
  goItem:SetActive(true)
  local theItem = self.head_root:AddComponent(UIGhostParkourMainPlayerHeadItem, name)
  theItem:ReInit(data)
  self.player_head_roots[index] = theItem
end

return UIGhostParkourBattleMainView
