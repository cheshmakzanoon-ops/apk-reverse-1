local LWSeasonServerGroupItem = BaseClass("LWSeasonServerGroupItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UnityLayoutElement = typeof(CS.UnityEngine.UI.LayoutElement)
local UIServerBattleZoneInfo = require("UI.UIGovernment.ServerBattleMain.Component.UIServerBattleZoneInfo")
local zone_item_up_path = "ZoneItemUp"
local btn_build_path = "BtnBuild"
local btn_text_path = "BtnBuild/BtnText"

function LWSeasonServerGroupItem:OnCreate()
  base.OnCreate(self)
  self.unity_LayoutElement = self.gameObject:GetComponent(UnityLayoutElement)
  self.canvasGroup = self:AddComponent(UICanvasGroup, "")
  self.zoneItem = self:AddComponent(UIServerBattleZoneInfo, zone_item_up_path)
  self.btn_build = self:AddComponent(UIButton, btn_build_path)
  self.btn_text = self:AddComponent(UIText, btn_text_path)
  self.btn_build:SetOnClick(function()
    if not self.isViewMode and DataCenter.LWZombieRushManager:IsChallenging() then
      UIUtil.ShowMessage(CS.GameEntry.Localization:GetString("zombieRush_tips_12"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
        self:OnClickGo()
      end, function()
      end)
      return
    end
    self:OnClickGo()
  end)
end

function LWSeasonServerGroupItem:OnDestroy()
  self.unity_LayoutElement = nil
  base.OnDestroy(self)
end

function LWSeasonServerGroupItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnGetServerKingData, self.OnGetServerKingData)
end

function LWSeasonServerGroupItem:OnRemoveListener()
  self:RemoveUIListener(EventId.OnGetServerKingData, self.OnGetServerKingData)
  base.OnRemoveListener(self)
end

function LWSeasonServerGroupItem:OnGetServerKingData()
  if self.serverId then
    local thePresident = DataCenter.GovernmentManager.CrossKingdomKing[self.serverId]
    local kingInfo = DataCenter.GovernmentManager:GetCrossServerKingInfo(self.serverId)
    local cfgId = kingInfo and kingInfo.badges.cfgId or 511001
    local status = 0
    if LuaEntry.Player:GetSourceServerId() == self.serverId then
      status = 2
    end
    local king = kingInfo and kingInfo.king or thePresident
    self.zoneItem:ReInit(king, ServerBattleType.VS4, status, self.serverId, {cfgId = cfgId})
    self.unity_LayoutElement.minHeight = 370
    self.unity_LayoutElement.preferredHeight = 370
    if self.theSeasonType == SeasonMapType.Snow then
      local server_bg = self.zoneItem.server_bg
      if server_bg ~= nil then
        local campId = DataCenter.SeasonFactionWarDataManager:GetCampIdByServerId(self.serverId)
        if campId == 1 then
          server_bg:LoadSpriteAuto("Assets/Main/SeasonRes/S2/Sprites/CommonS2/lrb_S2_saijifenzu_fuwuqibg_red.png")
        elseif campId == 2 then
          server_bg:LoadSpriteAuto("Assets/Main/SeasonRes/S2/Sprites/CommonS2/lrb_S2_saijifenzu_fuwuqibg_blue.png")
        elseif status == 2 then
          server_bg:LoadSpriteAuto("Assets/Main/SeasonRes/S2/Sprites/CommonS2/lrb_S2_saijifenzu_fuwuqibg_blue.png")
        else
          server_bg:LoadSpriteAuto("Assets/Main/SeasonRes/S2/Sprites/CommonS2/lrb_S2_saijifenzu_fuwuqibg_gray.png")
        end
      end
      self.btn_build:SetAnchoredPositionXY(0, -15)
    end
  end
end

function LWSeasonServerGroupItem:IsServerKingBattleDay()
  local configSchedule = DataCenter.ZoneWarManager.configSchedule
  if configSchedule then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if curTime >= configSchedule.crossStartTime and curTime < configSchedule.roundSettleTime then
      return true
    end
  end
  return false
end

function LWSeasonServerGroupItem:ReInit(index, data, theSeasonType)
  self.index = index
  self.serverId = toInt(data)
  self.theSeasonType = theSeasonType
  local jumpMode = self.view.param
  if self.serverId == 0 then
    if self.canvasGroup then
      self.canvasGroup:SetAlpha(0)
    end
    return
  end
  if self.canvasGroup then
    self.canvasGroup:SetAlpha(1)
  end
  self:OnGetServerKingData()
  if jumpMode == JumpServerMode.CrossServerKing then
    if self:IsServerKingBattleDay() then
      if DataCenter.ZoneWarManager:IsCampBattle() or DataCenter.ZoneWarManager:IsDefenceServer(self.serverId) then
        self.isViewMode = false
        self.btn_text:SetLocalText("2000229")
      else
        self.isViewMode = true
        self.btn_text:SetLocalText("110036")
      end
    else
      self.isViewMode = true
      self.btn_text:SetLocalText("110036")
    end
    if self.isViewMode then
      self.btn_build:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_3.png")
    else
      self.btn_build:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_2.png")
    end
  elseif self.view.paramData and jumpMode == JumpServerMode.PutAllianceBuild then
    self.isViewMode = false
    self.btn_text:SetLocalText("110108")
    self.btn_build:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_3.png")
  else
    local mySourceServerId = LuaEntry.Player:GetSourceServerId()
    local info = SeasonUtil.GetSeasonInfo(mySourceServerId)
    local theSeasonType = SeasonMapType.Nothing
    if info ~= nil then
      theSeasonType = info:GetServerType(true)
    end
    if theSeasonType == SeasonMapType.NineNation and info:InPreviewMode() then
      self.btn_build:SetActive(false)
    else
      self.btn_build:SetActive(true)
      if self:IsViewMode() then
        self.isViewMode = true
        self.btn_text:SetLocalText("110036")
      else
        self.isViewMode = false
        self.btn_text:SetLocalText("2000229")
      end
      if self.isViewMode then
        self.btn_build:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_3.png")
      else
        self.btn_build:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_2.png")
      end
    end
  end
end

function LWSeasonServerGroupItem:IsViewMode()
  return not SeasonUtil.CanMoveCityTo(self.serverId)
end

function LWSeasonServerGroupItem:OnClickGo()
  local serverId = self.serverId
  if serverId == 0 then
    UIUtil.ShowTipsId("avatar_tips006")
    return
  end
  local jumpMode = self.view.param
  local gotoPointIndex = LuaEntry.Player:GetMainWorldPos()
  if gotoPointIndex == nil or gotoPointIndex == 0 or gotoPointIndex < 0 then
    local markInfo = DataCenter.AllianceRallyPointDataManager:GetMyAllianceRallyPoint()
    if markInfo then
      gotoPointIndex = markInfo:GetPointIndex()
    end
  end
  if gotoPointIndex == nil or gotoPointIndex == 0 or gotoPointIndex < 0 then
    gotoPointIndex = 200200
  end
  local position = SceneUtils.TileIndexToWorld(gotoPointIndex, ForceChangeScene.World)
  if jumpMode == JumpServerMode.CrossServerKing then
  elseif serverId ~= LuaEntry.Player:GetSelfServerId() and serverId ~= LuaEntry.Player:GetSourceServerId() then
    local dataList = DataCenter.SeasonDataManager.ActCrossAttackDesertInfo
    if dataList then
      for i, v in ipairs(dataList) do
        if v and v.serverId == serverId then
          v.buildId = toInt(v.buildingId)
          if WorldAllianceBuildUtil.IsAllianceCenterFlag(v.buildId) then
            gotoPointIndex = v.pointId
            math.randomseed(SafeLocalOsTime())
            local tilePos = SceneUtils.IndexToTilePos(gotoPointIndex, ForceChangeScene.World)
            local x = math.random(tilePos.x - 7, tilePos.x + 7)
            local y = math.random(tilePos.y - 7, tilePos.y + 7)
            if x < WorldTileCount and y < WorldTileCount and 0 < x and 0 < y then
              position.x = (x + 0.5) * TileSize
              position.y = 0
              position.z = (y + 0.5) * TileSize
              gotoPointIndex = SceneUtils.TileXYToIndex(x, y, ForceChangeScene.World)
            end
          end
          break
        end
      end
    end
  end
  if self.view.paramData and jumpMode == JumpServerMode.PutAllianceBuild then
    if serverId == LuaEntry.Player:GetSourceServerId() then
      UIUtil.ShowTipsId("season_select_server_desc2")
      return
    end
    if DataCenter.AllianceMineManager:ExistAllianceFlagInServer(serverId) then
      UIUtil.ShowTipsId("season_tips127")
      return
    end
    local buildId = toInt(self.view.paramData.buildingId)
    local seasonType, seasonVersion = SeasonUtil.GetSeasonTypeAndVersion()
    if seasonType == SeasonMapType.CityStronghold and 0 < seasonVersion then
      local jumpParam = {
        viewMode = false,
        serverId = serverId,
        pos = position,
        pointId = gotoPointIndex,
        putMode = JumpServerMode.PutAllianceBuild,
        buildId = buildId
      }
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonServerDetail, {anim = true}, jumpParam)
    else
      SeasonUtil.PutAllianceBuild(serverId, buildId, gotoPointIndex, position)
    end
  else
    local useViewMode = self.isViewMode
    if jumpMode == nil then
      local seasonType, seasonVersion = SeasonUtil.GetSeasonTypeAndVersion()
      if seasonType == SeasonMapType.CityStronghold and 0 <= seasonVersion then
        local isOpen = DataCenter.ActivityListDataManager:CheckIfActivityOpen(EnumActivity.SeasonCrossAttackCityActivity.Type)
        if isOpen then
          local jumpParam = {
            viewMode = useViewMode,
            serverId = serverId,
            pos = position,
            pointId = gotoPointIndex
          }
          UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonServerDetail, {anim = true}, jumpParam)
          return
        end
      end
    end
    GoToUtil.CloseAllWindows()
    if LuaEntry.Player:GetSelfServerId() == serverId then
      GoToUtil.GotoWorldPos(position, MoveCityCameraHeight, nil, function()
      end, serverId)
    elseif LuaEntry.Player:GetSourceServerId() == serverId then
      CrossServerUtil.BackToSrcServer()
    elseif useViewMode then
      GoToUtil.GotoWorldPos(position, MoveCityCameraHeight, nil, function()
      end, serverId)
    elseif jumpMode == JumpServerMode.CrossServerKing then
      CrossServerUtil.JumpToServerByServerId(serverId, MoveCrossServerType.CrossServerKingBattle, gotoPointIndex)
    else
      CrossServerUtil.JumpToServerByServerId(serverId, MoveCrossServerType.SeasonBattleDesert, gotoPointIndex)
    end
  end
end

return LWSeasonServerGroupItem
