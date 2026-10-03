local TileBubbleManager = BaseClass("TileBubbleManager", Singleton)
local ResourceManager = CS.GameEntry.Resource
local Localization = CS.GameEntry.Localization

function TileBubbleManager:__init()
  self.req = nil
  self.gameObject = nil
  self:AddListener()
end

function TileBubbleManager:__delete()
  self.gameObject = nil
  if self.req then
    self.req:Destroy()
    self.req = nil
  end
  self:RemoveListener()
end

function TileBubbleManager:AddListener()
end

function TileBubbleManager:RemoveListener()
end

function TileBubbleManager:ExitWorld()
  self.gameObject = nil
  if not IsNull(self.bgRally) then
    self.bgRally.onPointerClick = nil
  end
  self.bgRally = nil
  if not IsNull(self.bg) then
    self.bg.onPointerClick = nil
  end
  self.bg = nil
  if not IsNull(self.bgFavorite) then
    self.bgFavorite.onPointerClick = nil
  end
  self.bgFavorite = nil
  if not IsNull(self.bgSeasonMasterySkill) then
    self.bgSeasonMasterySkill.onPointerClick = nil
  end
  self.bgSeasonMasterySkill = nil
  if not IsNull(self.bgSeasonGreen) then
    self.bgSeasonGreen.onPointerClick = nil
  end
  self.bgSeasonGreen = nil
  if not IsNull(self.bg_light) then
    self.bg_light.onPointerClick = nil
  end
  self.bg_light = nil
  if not IsNull(self.triggerEpidemicSkill) then
    self.triggerEpidemicSkill.onPointerClick = nil
  end
  self.triggerEpidemicSkill = nil
  if not IsNull(self.bgBFCommandSign) then
    self.bgBFCommandSign.onPointerClick = nil
  end
  self.bgBFCommandSign = nil
  if self.req then
    self.req:Destroy()
    self.req = nil
  end
  self.tranShareBtn = nil
  if IsNotNull(self.touchTriggerShare) then
    self.touchTriggerShare.onPointerClick = nil
    self.touchTriggerShare = nil
  end
end

function TileBubbleManager:ShowBubble(pointId)
  self.pointId = tonumber(pointId)
  if self.req then
    if self.gameObject then
      self:RefreshBubble()
      self.theBubbleShown = true
    end
  else
    local prefabName = "Assets/Main/Prefabs/UI/State/TileBubble.prefab"
    self.req = ResourceManager:InstantiateAsync(prefabName)
    self.req:completed("+", function(req)
      if req.isError then
        return
      end
      self.gameObject = req.gameObject
      self:InitBubble()
      self:RefreshBubble()
      self.theBubbleShown = true
    end)
  end
  CrossServerUtil.TryGetCrossEnableServerList()
end

function TileBubbleManager:HideBubble()
  self.theBubbleShown = false
  if self.gameObject then
    self.gameObject:SetActive(false)
  end
  self:RemoveUpdateTimer()
end

function TileBubbleManager:OnCrossDataUpdate()
  if self.theBubbleShown then
    self:RefreshBubble()
  end
end

function TileBubbleManager:AddUpdateTimer()
  if self.updateSecTimer == nil then
    self.updateSecTimer = TimerManager:GetInstance():GetTimer(1, self.OnUpdateSec, self, false, false, false)
    self.updateSecTimer:Start()
  end
end

function TileBubbleManager:RemoveUpdateTimer()
  if self.updateSecTimer then
    self.updateSecTimer:Stop()
    self.updateSecTimer = nil
  end
end

function TileBubbleManager:OnUpdateSec()
  if self.overTime then
    local mgr = UITimeManager:GetInstance()
    local now = mgr:GetServerTime()
    local remainTime = self.overTime - now
    if 0 < remainTime then
      if self.blackMode == AlAlertType.MissileFactory then
        self.TipMsg:SetText(Localization:GetString("season_activity_1000086_tips28", mgr:MilliSecondToFmtString(remainTime)))
      else
        self.TipMsg:SetText(Localization:GetString("season_alliance_government_skill_19", mgr:MilliSecondToFmtString(remainTime)))
      end
    else
      self.overTime = nil
      self.TipMsg:SetText("")
    end
  end
end

function TileBubbleManager:InitBubble()
  local transform = self.gameObject.transform
  self.anim = transform:Find("Anim"):GetComponent(typeof(CS.SimpleAnimation))
  self.coord = transform:Find("Anim/Coord1"):GetComponent(typeof(CS.TextMeshProEx))
  self.TipMsg = transform:Find("Anim/TipMsg"):GetComponent(typeof(CS.TextMeshProEx))
  self.moveCity = transform:Find("Anim/MoveCity")
  self.bg = transform:Find("Anim/MoveCity/Trigger"):GetComponent(typeof(CS.TouchObjectEventTrigger))
  
  function self.bg.onPointerClick()
    MoveCityUtil.OnClickMoveCity(self.serverId, self.pointId)
  end
  
  self.bg.previewType = CS.WorldPreviewType.HighThanMultiObjects
  local txt = transform:Find("Anim/MoveCity/Txt1"):GetComponent(typeof(CS.TextMeshProEx))
  txt.text = Localization:GetString(GameDialogDefine.MOVE_CITY)
  self.epidemicSkill = transform:Find("Anim/EpidemicSkill")
  self.bgEpidemicSkill = transform:Find("Anim/EpidemicSkill/Bg"):GetComponent(typeof(CS.SpriteMeshRenderer))
  self.triggerEpidemicSkill = transform:Find("Anim/EpidemicSkill/Trigger"):GetComponent(typeof(CS.TouchObjectEventTrigger))
  
  function self.triggerEpidemicSkill.onPointerClick()
    self:OnClickEpidemicSkill()
  end
  
  self.triggerEpidemicSkill.previewType = CS.WorldPreviewType.HighThanMultiObjects
  self.txtEpidemicSkill = transform:Find("Anim/EpidemicSkill/Txt"):GetComponent(typeof(CS.TextMeshProEx))
  self.txtEpidemicSkill.text = Localization:GetString("YiBianJinQu_trivial_tips_28")
  self.bfCommandSign = transform:Find("Anim/BFCommandSign")
  self.bgBFCommandSign = transform:Find("Anim/BFCommandSign/Trigger"):GetComponent(typeof(CS.TouchObjectEventTrigger))
  
  function self.bgBFCommandSign.onPointerClick()
    self:OnClickBFCommandSign()
  end
  
  self.bgBFCommandSign.previewType = CS.WorldPreviewType.HighThanMultiObjects
  local txtBFCommandSign = transform:Find("Anim/BFCommandSign/Txt"):GetComponent(typeof(CS.TextMeshProEx))
  txtBFCommandSign.text = Localization:GetString("YiBianJinQu_ping_button_1")
  self.rally = transform:Find("Anim/Rally")
  self.bgRally = transform:Find("Anim/Rally/Trigger"):GetComponent(typeof(CS.TouchObjectEventTrigger))
  
  function self.bgRally.onPointerClick()
    self:OnSetRallyClick()
  end
  
  self.bgRally.previewType = CS.WorldPreviewType.HighThanMultiObjects
  local txtRally = transform:Find("Anim/Rally/Txt2"):GetComponent(typeof(CS.TextMeshProEx))
  txtRally.text = Localization:GetString(GameDialogDefine.SET_ALLIANCE_RALLY_PT)
  self.favorite = transform:Find("Anim/Favorite")
  self.bgFavorite = transform:Find("Anim/Favorite/Trigger"):GetComponent(typeof(CS.TouchObjectEventTrigger))
  
  function self.bgFavorite.onPointerClick()
    self:OnFavoriteClick()
  end
  
  self.bgFavorite.previewType = CS.WorldPreviewType.HighThanMultiObjects
  local txtFavorite = transform:Find("Anim/Favorite/Txt4"):GetComponent(typeof(CS.TextMeshProEx))
  txtFavorite.text = Localization:GetString("129048")
  self.seasonMasterySkill = transform:Find("Anim/SeasonMasterySkill")
  self.bgSeasonMasterySkill = transform:Find("Anim/SeasonMasterySkill/Trigger"):GetComponent(typeof(CS.TouchObjectEventTrigger))
  
  function self.bgSeasonMasterySkill.onPointerClick()
    self:OnSeasonMasterySkillClick()
  end
  
  self.bgSeasonMasterySkill.previewType = CS.WorldPreviewType.HighThanMultiObjects
  local txtSeasonMasterySkill = transform:Find("Anim/SeasonMasterySkill/Txt3"):GetComponent(typeof(CS.TextMeshProEx))
  txtSeasonMasterySkill.text = Localization:GetString("season_mastery_006")
  self.temperature = transform:Find("Anim/Temperature"):GetComponent(typeof(CS.TextMeshProEx))
  self.temperatureIcon = transform:Find("Anim/Temperature/icon"):GetComponent(typeof(CS.SpriteMeshRenderer))
  self.seasonGreen = nil
  self.bgSeasonGreen = nil
  self.season_light = transform:Find("Anim/SeasonLight")
  self.icon_light = transform:Find("Anim/SeasonLight/IconLight"):GetComponent(typeof(CS.SpriteMeshRenderer))
  self.txt_light = transform:Find("Anim/SeasonLight/TxtLight"):GetComponent(typeof(CS.TextMeshProEx))
  self.bg_light = transform:Find("Anim/SeasonLight/Trigger"):GetComponent(typeof(CS.TouchObjectEventTrigger))
  
  function self.bg_light.onPointerClick()
    self:OnSeasonLightClick()
  end
  
  self.bg_light.previewType = CS.WorldPreviewType.HighThanMultiObjects
  self.tranShareBtn = transform:Find("Anim/Coord1/imgShare")
  if IsNotNull(self.tranShareBtn) then
    self.touchTriggerShare = transform:Find("Anim/Coord1/imgShare/Trigger"):GetComponent(typeof(CS.TouchObjectEventTrigger))
    if IsNotNull(self.touchTriggerShare) then
      function self.touchTriggerShare.onPointerClick()
        self:OnClickedShare()
      end
    end
  end
end

function TileBubbleManager:RefreshShareButton()
  if IsNull(self.tranShareBtn) or IsNull(self.coord) then
    return
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.coord.rectTransform)
  local width = self.coord:GetWidth()
  if 0 < width then
    self.tranShareBtn.gameObject:SetActive(true)
    self.tranShareBtn.localPosition = Vector3.New(width * 0.5 + 0.4, 0, 0)
  else
    self.tranShareBtn.gameObject:SetActive(false)
  end
end

function TileBubbleManager:OnClickedShare()
  if not self.pointId then
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPositionShare, {anim = true}, {
    pos = self.pointId,
    posType = WorldPointUIType.None,
    postType = PostType.Text_PointShare,
    sid = self.serverId,
    uid = LuaEntry.Player:GetUid()
  })
end

function TileBubbleManager:RefreshBubble()
  if self.gameObject then
    local isDragonWorld = BattleFieldUtil.InBattleField()
    local isInSeason = false
    local seasonType = SeasonMapType.Nothing
    local worldPos = SceneUtils.TileIndexToWorld(self.pointId)
    local tilePos = SceneUtils.IndexToTilePos(self.pointId)
    local curServerId = LuaEntry.Player:GetCurServerId()
    local seasonInfo = SeasonUtil.GetSeasonInfo(curServerId)
    if seasonInfo then
      isInSeason = seasonInfo:ServerInReady() and seasonInfo:InNormalMode()
      seasonType = seasonInfo:GetServerType(false)
    end
    if seasonType == SeasonMapType.NineNation then
      local touchPos = CS.SceneManager.World.curTouchPoint
      local xIndex = Mathf.Clamp(touchPos.x / TileSize, 0, 2999) // WORLD_TILE_COUNT_MAX
      local yIndex = Mathf.Clamp(touchPos.z / TileSize, 0, 2999) // WORLD_TILE_COUNT_MAX
      local bigZone = toInt(xIndex + 3 * yIndex + 1)
      self.serverId = seasonInfo:GetNinePalacesServer(bigZone)
      worldPos = SceneUtils.TileToWorld(tilePos, ForceChangeScene.World, self.serverId)
      if CS.CommonUtils.IsDebug() then
        Logger.Log(string.format("#%s worldPos(X:%s Y:%s) => tilePos(X:%s Y:%s)", self.serverId, worldPos.x, worldPos.z, tilePos.x, tilePos.y))
        self.coord.text = string.format("<color=#ff0000>\231\172\172%s\229\140\186</color> #%s (X:%s Y:%s)", bigZone, self.serverId, tilePos.x, tilePos.y)
      else
        self.coord.text = string.format("#%s (X:%s Y:%s)", self.serverId, tilePos.x, tilePos.y)
      end
    else
      self.serverId = curServerId
      self.coord.text = Localization:GetString(GameDialogDefine.SHOW_POS, tilePos.x, tilePos.y)
    end
    self:RefreshShareButton()
    self.gameObject.transform.position = worldPos
    self.gameObject:SetActive(true)
    local overTime, blackMode = DataCenter.AllianceSkillManager:GetBlackAreaOverTime(self.pointId)
    if overTime == 0 then
      self.TipMsg:SetText("")
      self.overTime = nil
    else
      self.overTime = overTime
      self.blackMode = blackMode
      self:AddUpdateTimer()
      self:OnUpdateSec()
    end
    local showSetRally = UIUtil.CanPutAllianceRallyPoint(self.pointId, self.serverId)
    local showMoveCity = MoveCityUtil.CanMoveCity(self.serverId)
    local showEpidemicSkill = BattleFieldUtil.CanUseSkill()
    local showBFCommandSign = BattleFieldUtil.CanUsePingSign()
    local favorData = DataCenter.WorldFavoDataManager:GetBookmark(self.pointId * 10, LuaEntry.Player:GetCurServerId(), true)
    local showFavorite = not isDragonWorld and favorData ~= nil
    local showSeasonMasterySkill = DataCenter.MasteryManager:IsShowWorldMasteryBtn() and not isDragonWorld
    self.rally.gameObject:SetActive(showSetRally)
    if showSetRally and SeasonUtil.IsInSeasonNineNationMode() then
      local rallyIcon = self.gameObject.transform:Find("Anim/Rally/Bg"):GetComponent(typeof(CS.SpriteMeshRenderer))
      rallyIcon:LoadSprite(self.serverId ~= LuaEntry.Player:GetSourceServerId() and "Assets/Main/Sprites/UI/UILWWorld/lyt_lianmengjijiedian_anniu.png" or "Assets/Main/Sprites/UI/UILWWorld/LXY_lianmengjijiedian_anniu01.png")
    end
    self.moveCity.gameObject:SetActive(showMoveCity)
    self.epidemicSkill.gameObject:SetActive(showEpidemicSkill)
    if showEpidemicSkill and self.bgEpidemicSkill ~= nil then
      local skillId = DataCenter.ActEpidemicZoneManager:GetCurSkillId()
      local template = DataCenter.ActEpidemicZoneManager:GetTemplateSkillById(skillId)
      local map_icon = template ~= nil and template.map_icon or nil
      if not string.IsNullOrEmpty(map_icon) then
        self.bgEpidemicSkill:LoadSprite(map_icon)
      end
    end
    self.bfCommandSign.gameObject:SetActive(showBFCommandSign)
    self.favorite.gameObject:SetActive(showFavorite)
    self.seasonMasterySkill.gameObject:SetActive(showSeasonMasterySkill)
    local space = 3
    local btns = {}
    if showSetRally then
      table.insert(btns, {
        offset = #btns * space,
        obj = self.rally
      })
    end
    if showMoveCity then
      table.insert(btns, {
        offset = #btns * space,
        obj = self.moveCity
      })
    end
    if showEpidemicSkill then
      table.insert(btns, {
        offset = #btns * space,
        obj = self.epidemicSkill
      })
    end
    if showBFCommandSign then
      table.insert(btns, {
        offset = #btns * space,
        obj = self.bfCommandSign
      })
    end
    if showFavorite then
      table.insert(btns, {
        offset = #btns * space,
        obj = self.favorite
      })
    end
    if showSeasonMasterySkill then
      table.insert(btns, {
        offset = #btns * space,
        obj = self.seasonMasterySkill
      })
    end
    local green = self:RefreshGreen()
    if green then
      table.insert(btns, {
        offset = #btns * space,
        obj = green
      })
    end
    local gOffset = (#btns - 1) * space / 2
    for i = 1, #btns do
      local value = btns[i]
      local offset = value.offset - gOffset
      value.obj:Set_localPosition(offset, 0, 0)
    end
    self.anim:Play("EnterBubble")
    if self.season_light ~= nil then
      local sunrise = DataCenter.BloodyNightDataManager:IsSunrise()
      if not sunrise and not isDragonWorld and isInSeason and seasonType == SeasonMapType.Darkness then
        local brightness = CS.LightDataManager.GetInstance():GetMaxLightLevelInPointId(self.pointId)
        self.season_light.gameObject:SetActive(true)
        if brightness <= 0 then
          self.txt_light.text = ""
          self.icon_light:LoadSprite("Assets/Main/SeasonRes/S4/Sprites/UI/PowerHouseS4/ljq_saijis4_qipaoa_03.png")
        else
          if brightness == 1 then
            self.icon_light:LoadSprite("Assets/Main/SeasonRes/S4/Sprites/UI/PowerHouseS4/ljq_saijis4_qipaoa_04.png")
          elseif brightness == 2 then
            self.icon_light:LoadSprite("Assets/Main/SeasonRes/S4/Sprites/UI/PowerHouseS4/ljq_saijis4_qipaoa_05.png")
          elseif brightness == 3 then
            self.icon_light:LoadSprite("Assets/Main/SeasonRes/S4/Sprites/UI/PowerHouseS4/ljq_saijis4_qipaoa_06.png")
          elseif brightness == 4 then
            self.icon_light:LoadSprite("Assets/Main/SeasonRes/S4/Sprites/UI/PowerHouseS4/ljq_saijis4_qipaoa_07.png")
          else
            self.icon_light:LoadSprite("Assets/Main/SeasonRes/S4/Sprites/UI/PowerHouseS4/ljq_saijis4_qipaoa_09.png")
          end
          self.txt_light.text = "L" .. brightness
        end
      else
        self.season_light.gameObject:SetActive(false)
      end
    end
    self:RefreshTemperature()
  end
end

function TileBubbleManager:OnClickEpidemicSkill()
  DataCenter.ActEpidemicZoneManager:TryUseSkill(self.pointId, true)
end

function TileBubbleManager:OnClickBFCommandSign()
  BattleFieldUtil.OpenPingSign(self.pointId, true)
end

function TileBubbleManager:OnSetRallyClick()
  TileBubbleManager.TrySetRally(self.pointId, self.serverId)
end

function TileBubbleManager.TrySetRally(thePintId, serverId)
  local mySourceServerId = LuaEntry.Player:GetSourceServerId()
  local isBigMapMode, curSameGroup, srcSameGroup, loginSameGroup = SeasonUtil.InSeasonBigMapMode(serverId)
  if isBigMapMode and curSameGroup then
  elseif not LuaEntry.Player:AtHomeNow() then
    UIUtil.ShowTipsId(500019)
    return
  end
  serverId = serverId or mySourceServerId
  local markType = serverId == mySourceServerId and MarkType.Alliance_rally or MarkType.Alliance_OtherServerRally
  local pointId = thePintId * 10 + 1
  local pos = SceneUtils.IndexToTilePos(thePintId, ForceChangeScene.World)
  local content
  if markType == MarkType.Alliance_rally then
    content = Localization:GetString(GameDialogDefine.SET_ALLIANCE_RALLY_PT_CONFIRM, pos.x, pos.y)
  elseif markType == MarkType.Alliance_OtherServerRally then
    content = Localization:GetString("s5_allianceflag_tips01", pos.x, pos.y, serverId)
  end
  UIUtil.ClickUICloseWorldUI()
  UIUtil.ShowMessage(content, 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
    DataCenter.AllianceRallyPointDataManager:TryAddRallyPoint(pointId, serverId, markType, "455018")
  end, nil, nil, nil, nil, nil, nil, nil, nil, nil, CS.UnityEngine.TextAnchor.UpperLeft)
end

function TileBubbleManager:GetPoint()
  return self.pointId
end

function TileBubbleManager:OnSeasonMasterySkillClick()
  DataCenter.MasteryManager:ClickWorldMasteryBtn({
    pointId = self.pointId,
    serverId = self.serverId
  })
  UIUtil.ClickUICloseWorldUI()
end

function TileBubbleManager:OnSeasonLightClick()
  local brightness = CS.LightDataManager.GetInstance():GetMaxLightLevelInPointId(self.pointId)
  if brightness <= 0 then
    UIUtil.ShowTipsId("season4_tips004")
  else
    UIUtil.ShowTips(Localization:GetString("season4_tips005", brightness))
  end
end

function TileBubbleManager:OnFavoriteClick()
  local share_param = {}
  share_param.sid = self.serverId
  share_param.pos = self.pointId * 10
  local tilePos = SceneUtils.IndexToTilePos(self.pointId)
  share_param.oname = string.format("#%d X:%d Y:%d", share_param.sid, tilePos.x, tilePos.y)
  share_param.panelType = MarkGroup.Personal
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPositionAdd, {anim = true}, share_param)
end

function TileBubbleManager:RefreshTemperature()
  if SeasonUtil.IsCurWorldInSeasonSnowModeWithoutGroup() and not BattleFieldUtil.InBattleField() then
    self.temperature.gameObject:SetActive(true)
    local temp = DataCenter.TemperatureManager:GetTemperatureByIndex(self.pointId)
    self.temperature.text = Localization:GetString("season_s2_common_temperature", temp)
    local meta = DataCenter.TemperatureTemplateManager:GetTemplate(math.floor(temp))
    self.temperature.color32 = UIUtil.HexToColor32(meta.text_color)
    self.temperatureIcon:LoadSprite("Assets/Main/Sprites/UI/UISeason/UISeason2/FX_S2saiji_icon03.png")
  else
    self.temperature.gameObject:SetActive(false)
  end
end

function TileBubbleManager:RefreshGreen()
  local transform = self.gameObject.transform
  if not self.seasonGreen then
    self.seasonGreen = transform:Find("Anim/SeasonGreen")
  end
  if self.seasonGreen == nil then
    return nil
  end
  if not (not BattleFieldUtil.InBattleField() and SeasonUtil.IsInSeasonMummyMode()) or not DataCenter.SeasonGreenManager:IsActive() then
    self.seasonGreen.gameObject:SetActive(false)
    return nil
  end
  if not self.bgSeasonGreen then
    self.bgSeasonGreen = self.seasonGreen:Find("Trigger"):GetComponent(typeof(CS.TouchObjectEventTrigger))
    
    function self.bgSeasonGreen.onPointerClick()
      self:OnSeasonGreenClick()
    end
    
    self.bgSeasonGreen.previewType = CS.WorldPreviewType.HighThanMultiObjects
    self.txtSeasonGreen = self.seasonGreen:Find("Txt3"):GetComponent(typeof(CS.TextMeshProEx))
    self.txtSeasonGreen.text = Localization:GetString("season_oasis_UI_3")
    self.bgSeasonGreenGray = self.seasonGreen:Find("Lock")
  end
  if DataCenter.SeasonGreenManager:CanGreen(self.pointId) then
    if self.txtSeasonGreen then
      self.txtSeasonGreen.color32 = Color32.New(159, 245, 55, 255)
    end
    if self.bgSeasonGreenGray then
      self.bgSeasonGreenGray.gameObject:SetActive(false)
    end
  else
    if self.txtSeasonGreen then
      self.txtSeasonGreen.color32 = Color32.New(210, 210, 210, 255)
    end
    if self.bgSeasonGreenGray then
      self.bgSeasonGreenGray.gameObject:SetActive(true)
    end
  end
  self.seasonGreen.gameObject:SetActive(true)
  return self.seasonGreen
end

function TileBubbleManager:OnSeasonGreenClick()
  DataCenter.SeasonGreenManager:MarchToGreen(self.pointId)
  UIUtil.ClickUICloseWorldUI()
end

return TileBubbleManager
