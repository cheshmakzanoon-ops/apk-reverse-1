local FormationSelectListCellNewV2 = BaseClass("FormationSelectListCellNewV2", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local focus_img_path = "unLockObj/selectImg"
local unlock_obj_path = "unLockObj"
local btn_path = ""
local empty_obj_path = "unLockObj/emptyObj"
local name_txt_path = "nameNum"
local num_txt_path = "unLockObj/powerNum"
local lock_obj_path = "lockObj"
local march_obj_path = "unLockObj/marchObj"
local state_icon_path = "unLockObj/marchObj/stateIcon"
local attack_effect_path = "unLockObj/marchObj/stateIcon/MarchAttackStateIcon"
local blood_slider_path = "unLockObj/marchObj/bloodSlider"
local blood_img_path = "unLockObj/marchObj/bloodSlider/FillArea/Fill"
local level_path = "unLockObj/Level"
local img_bg_path = "ImageBg"
local img_path = "unLockObj/marchObj/mask/che"
local lock_month_path = "lockObj/lockMonth"
local WAIT_RALLY = MarchStatus.WAIT_RALLY
local COLLECTING = MarchStatus.COLLECTING
local IN_TEAM = MarchStatus.IN_TEAM
local ASSISTANCE = MarchStatus.ASSISTANCE
local UIGray = CS.UIGray

local function OnCreate(self)
  base.OnCreate(self)
  self.focus_img = self:AddComponent(UIImage, focus_img_path)
  self.img_bg = self:AddComponent(UIImage, img_bg_path)
  self.focus_img:SetActive(false)
  self.onDrag = false
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(function()
    self:OnAtkClick(true)
  end)
  self.empty_obj = self:AddComponent(UIBaseContainer, empty_obj_path)
  self.march_obj = self:AddComponent(UIBaseContainer, march_obj_path)
  self.unlock_obj = self:AddComponent(UIBaseContainer, unlock_obj_path)
  self.lock_obj = self:AddComponent(UIBaseContainer, lock_obj_path)
  self.lock_month = self:AddComponent(UIImage, lock_month_path)
  self.name_txt = self:AddComponent(UIText, name_txt_path)
  self.num_txt = self:AddComponent(UIText, num_txt_path)
  self.state_icon = self:AddComponent(UIImage, state_icon_path)
  self.img = self:AddComponent(UIImage, img_path)
  self.attack_effect = self:AddComponent(UIBaseContainer, attack_effect_path)
  self.blood_slider = self:AddComponent(UISlider, blood_slider_path)
  self.blood_img = self:AddComponent(UIImage, blood_img_path)
  self.model = {}
  self.level_text = self:AddComponent(UIText, level_path)
  self.isUpdate = false
  self.startTime = 0
  self.endTime = 0
  self.canClick = true
end

local function OnDestroy(self)
  self.state_icon = nil
  self.attack_effect = nil
  self.blood_slider = nil
  self.blood_img = nil
  self.lock_obj = nil
  self.unlock_obj = nil
  self.empty_obj = nil
  self.name_txt = nil
  self.num_txt = nil
  self.march_obj = nil
  self.level_text = nil
  base.OnDestroy(self)
end

local function OnBeginDrag(self, eventData)
  self.onDrag = true
  if self.canClick == false then
    UIUtil.ShowTipsId(GameDialogDefine.MARCH_IN_OTHER_SERVER)
    return
  end
  if self.dataInfo ~= nil and self.view.ctrl.targetType < 0 then
    if self.dataInfo.canMove == false and 0 < self.dataInfo.isMarch then
      local march = DataCenter.WorldMarchDataManager:GetOwnerFormationMarch(LuaEntry.Player.uid, self.dataInfo.uuid, LuaEntry.Player.allianceId)
      if march ~= nil then
        if march:GetMarchStatus() == MarchStatus.IN_WORM_HOLE or march:GetMarchStatus() == MarchStatus.CROSS_SERVER then
          UIUtil.ShowTipsId(142514)
          return
        end
        CS.WorldScene.selectMarchUuid = march.uuid
        CS.SceneManager.World.marchUuid = march.uuid
        CS.SceneManager.World:TrackMarch(0)
        if march:GetMarchStatus() ~= MarchStatus.ASSISTANCE and march:GetMarchStatus() ~= MarchStatus.COLLECTING then
          self.view.ctrl:SetSelectFormationUuid(self.uuid)
          self.view:OnSelectClick(self.uuid)
        else
          self.view.ctrl:SetSelectFormationUuid(0)
          self.view:OnSelectClick(0)
        end
        WorldMarchTileUIManager:GetInstance():ShowTroop(march.uuid)
        self.view:HideAllShowTip()
      end
    elseif self.dataInfo.useForm == true then
      self.view.ctrl:SetSelectFormationUuid(0)
      self.view:OnSelectClick(0)
      CS.SceneManager.World:SetDragFormationData(self.dataInfo.uuid, self.dataInfo.startPos)
      self.view:HideAllShowTip()
    end
  end
end

local function RefreshCaptain(self, formation)
  local qualityBg = HeroUtils.GetFormationBgByQuality()
  if formation then
    local captain = formation:GetHighestQualityHero()
    if captain then
      qualityBg = HeroUtils.GetFormationBgByQuality(captain.quality)
      local iconPath = HeroUtils.GetHeroIconPath(captain.modelId, HeroIconType.half_portrait, captain:GetSkinId())
      self.img:LoadSpriteAsyncWithCallback(iconPath, function()
        if self.img then
          self.img:SetNativeSize()
        end
      end)
    end
  end
  self.img_bg:LoadSpriteAuto(qualityBg)
end

local function RefreshData(self, show)
  self.isUpdate = false
  self.startTime = 0
  self.endTime = 0
  self.canClick = true
  self.num_txt:SetText("")
  if self.uuid ~= nil then
    local formation = DataCenter.ArmyFormationDataManager:GetOneArmyInfoByUuid(self.uuid)
    if formation ~= nil and formation.state == ArmyFormationState.Free then
      if self.view.ctrl.targetType == MarchTargetType.COLLECT then
        local collectPoint = CS.SceneManager.World:GetResourcePointInfoByIndex(self.view.ctrl.targetPoint)
        if collectPoint then
          local type = GetTableData(TableName.GatherResource, collectPoint.id, "resource_type")
          DataCenter.ArmyFormationDataManager:AutoInitFormationDataForCollect(self.uuid, tonumber(type))
        else
          DataCenter.ArmyFormationDataManager:AutoInitFormationData(self.uuid)
        end
      else
        DataCenter.ArmyFormationDataManager:AutoInitFormationData(self.uuid)
      end
    end
    self.unlock_obj:SetActive(true)
    self.dataInfo = self.view.ctrl:GetFormationItemData(self.uuid)
    local serverId = self.dataInfo.serverId
    if serverId == nil or serverId <= 0 then
      serverId = LuaEntry.Player:GetSelfServerId()
    end
    local targetServerId = 0
    local march = DataCenter.WorldMarchDataManager:GetOwnerFormationMarch(LuaEntry.Player.uid, self.uuid, LuaEntry.Player.allianceId)
    if march ~= nil then
      targetServerId = toInt(march.targetServer)
    end
    if targetServerId <= 0 or not DataCenter.SeasonDataManager:IsInNinePalacesMode(targetServerId) then
      if self.view.ctrl.targetType ~= MarchTargetType.CROSS_SERVER_WORM then
        if serverId ~= LuaEntry.Player:GetCurServerId() and 0 < self.dataInfo.isMarch then
          self.canClick = false
        end
      elseif serverId ~= LuaEntry.Player:GetSelfServerId() and 0 < self.dataInfo.isMarch then
        self.canClick = false
      end
    end
    UIGray.SetGray(self.img.transform, self.canClick == false, true)
    self.level_text:SetText(self.dataInfo.level and "Lv." .. self.dataInfo.level or "")
    if self.dataInfo.isMarch ~= nil and 0 < self.dataInfo.isMarch or self.dataInfo.useForm == true then
      self:RefreshCaptain(formation)
      if 0 < self.dataInfo.isMarch then
        self.state_icon:SetActive(true)
        self.attack_effect:SetActive(self.dataInfo.isBattle)
        self.state_icon:LoadSprite(self.dataInfo.stateImg)
        self.blood_slider:SetActive(true)
        self:RefreshSlider(self.dataInfo.marchUuid, self.dataInfo.hp, self.dataInfo.maxhp)
        local curTime = UITimeManager:GetInstance():GetServerTime()
        if curTime < self.dataInfo.endTime then
          self.startTime = self.dataInfo.startTime
          self.endTime = self.dataInfo.endTime
          self.isUpdate = true
          self:UpdateTime()
        end
      else
        self.state_icon:SetActive(true)
        self.state_icon:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/zyf_chuzheng_kongxian")
        self.blood_slider:SetActive(false)
      end
      self.march_obj:SetActive(true)
      self.empty_obj:SetActive(false)
      self.lock_obj:SetActive(false)
    else
      self.march_obj:SetActive(false)
      self.empty_obj:SetActive(true)
      self.lock_obj:SetActive(false)
    end
    if self.view.ctrl.selectFormationUuid == self.uuid then
      self:OnAtkClick()
    end
  else
    self.unlock_obj:SetActive(false)
    self.lock_obj:SetActive(true)
    if self.lock_month ~= nil then
      self.lock_month:SetActive(false)
      if self.index == 3 then
        local isOpen = DataCenter.MonthCardNewManager:CheckIfMonthCardActive()
        if not isOpen then
          self.lock_month:SetActive(true)
        else
          local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_BUILD_PARKINGLOT_FOUR)
          if buildData and buildData.level == 0 then
            self.lock_month:SetActive(true)
          end
        end
      end
    end
  end
  if type(show) == "number" and show == self.index then
    self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
      local param = {}
      param.position = self.transform.position
      param.positionType = PositionType.Screen
      if param.position ~= nil then
        DataCenter.ArrowManager:ShowArrow(param)
      end
    end, 0.4)
  end
end

local function RefreshMarchData(self)
  self.isUpdate = false
  self.startTime = 0
  self.endTime = 0
  self.num_txt:SetText("")
  self.canClick = true
  if self.uuid ~= nil then
    local formation = DataCenter.ArmyFormationDataManager:GetOneArmyInfoByUuid(self.uuid)
    if formation.state == ArmyFormationState.March then
      self.dataInfo = self.view.ctrl:GetFormationItemData(self.uuid)
      local serverId = self.dataInfo.serverId
      if serverId == nil or serverId <= 0 then
        serverId = LuaEntry.Player:GetSelfServerId()
      end
      if self.view.ctrl.targetType ~= MarchTargetType.CROSS_SERVER_WORM then
        if serverId ~= LuaEntry.Player:GetCurServerId() and 0 < self.dataInfo.isMarch then
          self.canClick = false
        end
      elseif serverId ~= LuaEntry.Player:GetSelfServerId() and 0 < self.dataInfo.isMarch then
        self.canClick = false
      end
      UIGray.SetGray(self.img.transform, self.canClick == false, true)
      if 0 < self.dataInfo.isMarch then
        self.state_icon:SetActive(true)
        self.attack_effect:SetActive(self.dataInfo.isBattle)
        self.state_icon:LoadSprite(self.dataInfo.stateImg)
        self.blood_slider:SetActive(true)
        self:RefreshSlider(self.dataInfo.marchUuid, self.dataInfo.hp, self.dataInfo.maxhp)
        local curTime = UITimeManager:GetInstance():GetServerTime()
        if curTime < self.dataInfo.endTime then
          self.startTime = self.dataInfo.startTime
          self.endTime = self.dataInfo.endTime
          self.isUpdate = true
          self:UpdateTime()
        end
      else
        self.state_icon:SetActive(true)
        self.state_icon:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/zyf_chuzheng_kongxian")
      end
      if self.view.ctrl.selectFormationUuid == self.uuid then
        self:OnAtkClick()
      end
    else
      self:RefreshData()
    end
  end
end

local function SetUuidAndIndex(self, index, uuid)
  self.index = index
  self.name_txt:SetText(self.index)
  self.uuid = uuid
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  self.onDrag = false
  base.OnDisable(self)
end

local function RefreshSlider(self, uuid, hp, maxhp)
  if uuid ~= nil and self.dataInfo ~= nil and self.dataInfo.marchUuid ~= nil and uuid == self.dataInfo.marchUuid then
    local percent = hp / math.max(maxhp, 1)
    if percent < 1 then
      self.blood_img:LoadSprite("Assets/Main/Sprites/UI/UIMain/UIMainNew/UITroopsNew_pro_red.png")
    else
      self.blood_img:LoadSprite("Assets/Main/Sprites/UI/UIMain/UIMainNew/UITroopsNew_pro_green.png")
    end
    if 1 < percent then
      percent = 1
    end
    self.blood_slider:SetValue(percent)
  end
end

local function OnAtkClick(self, isInClick)
  if self.onDrag == true and isInClick == true then
    return
  end
  if isInClick == true and self.canClick == false then
    local march = DataCenter.WorldMarchDataManager:GetOwnerFormationMarch(LuaEntry.Player.uid, self.uuid, LuaEntry.Player.allianceId)
    if march ~= nil then
      if march:GetMarchStatus() == MarchStatus.IN_WORM_HOLE or march:GetMarchStatus() == MarchStatus.CROSS_SERVER then
        UIUtil.ShowTipsId(142514)
        return
      elseif self.view.ctrl.targetType == MarchTargetType.CROSS_SERVER_WORM then
        UIUtil.ShowTips(Localization:GetString("121422", self.view.ctrl.targetServerId))
        return
      end
      local targetServerId = toInt(march.targetServer)
      if (targetServerId <= 0 or not DataCenter.SeasonDataManager:IsInNinePalacesMode(targetServerId)) and self.view.ctrl.targetType >= 0 then
        UIUtil.ShowTipsId(GameDialogDefine.MARCH_IN_OTHER_SERVER)
        return
      end
    end
  end
  if self.view.ctrl.targetType >= 0 then
    local monsterSpecialType = self.view.ctrl.monsterSpecialType
    if self.uuid ~= nil then
      local posX = self.img_bg.transform.position.x
      local posY = self.img_bg.transform.position.y + 120 * self.transform.parent.lossyScale.y
      if self.view.ctrl.targetType == MarchTargetType.FAKE_ATTACK then
        self.view.ctrl:SetSelectFormationUuid(self.uuid)
        self.view:ShowDisguiseArmyTip(posX, posY, self.dataInfo)
        self.view:OnSelectClick(self.uuid)
      elseif MarchUtil.IsRallyMarch(self.view.ctrl.targetType) then
        if 0 < self.dataInfo.isMarch then
          self.view:HideAllShowTip()
          UIUtil.ShowSingleTip(Localization:GetString("129110"))
        elseif self.dataInfo.useForm then
          self.view.ctrl:SetSelectFormationUuid(self.uuid)
          self.view:ShowFormationArmyTip(posX, posY, self.dataInfo)
          self.view:OnSelectClick(self.uuid)
        else
          self.view.ctrl:SetSelectFormationUuid(self.uuid)
          self.view:ShowFormationCreateTip(posX, posY, self.dataInfo)
          self.view:OnSelectClick(self.uuid)
        end
      elseif 0 < self.dataInfo.isMarch then
        if self.view.ctrl.targetType == MarchTargetType.EXPLORE then
          self.view:HideAllShowTip()
          UIUtil.ShowSingleTip(Localization:GetString("129109"))
        elseif self.view.ctrl.targetType == MarchTargetType.DIRECT_ATTACK_ACT_BOSS or self.view.ctrl.targetType == MarchTargetType.DIRECT_ATTACK_ACT_BERSERK_BOSS or monsterSpecialType and (monsterSpecialType == WorldMonsterSpecialType.S1RestCityDefendMonster or monsterSpecialType == WorldMonsterSpecialType.S1RestBloodyQueenGunner) then
          self.view:HideAllShowTip()
          UIUtil.ShowTips(Localization:GetString("302244"), nil, nil, nil, true)
        elseif self.view.ctrl.targetType == MarchTargetType.GO_WORM_HOLE then
          self.view:HideAllShowTip()
          UIUtil.ShowSingleTip(Localization:GetString("143611"))
        else
          self.view.ctrl:SetSelectFormationUuid(self.uuid)
          self.view:ShowFormationArmyTip(posX, posY, self.dataInfo)
          self.view:OnSelectClick(self.uuid)
        end
      elseif self.dataInfo.useForm == true then
        self.view.ctrl:SetSelectFormationUuid(self.uuid)
        self.view:ShowFormationArmyTip(posX, posY, self.dataInfo)
        self.view:OnSelectClick(self.uuid)
      else
        self.view.ctrl:SetSelectFormationUuid(self.uuid)
        self.view:ShowFormationCreateTip(posX, posY, self.dataInfo)
        self.view:OnSelectClick(self.uuid)
      end
    end
  elseif self.canClick == false then
    if isInClick ~= nil and isInClick == true then
      self.dataInfo = self.view.ctrl:GetFormationItemData(self.uuid)
      local serverId = self.dataInfo.serverId
      local worldId = self.dataInfo.worldId
      local worldType = self.dataInfo.worldType
      if serverId == nil or serverId <= 0 then
        serverId = LuaEntry.Player:GetSelfServerId()
      end
      local str = Localization:GetString("110216", serverId)
      if worldId ~= nil and 0 < worldId and 0 < worldType then
        if worldType == BattleFieldType.Desert then
          str = Localization:GetString("458227", serverId)
        elseif worldType == BattleFieldType.WinterStorm then
          str = Localization:GetString("winter_battlefield_tips1006")
        end
      end
      UIUtil.ShowMessage(str, 2, "", "", function()
        self:OnJumpToFormationPos(isInClick)
      end)
    end
  else
    self:OnJumpToFormationPos(isInClick)
  end
  if self.uuid == nil then
    self.view:HideAllShowTip()
    if self.index == 3 then
      local isOpen = DataCenter.MonthCardNewManager:CheckIfMonthCardActive()
      if not isOpen then
        UIManager:GetInstance():OpenWindow(UIWindowNames.LWBuyDiamond, {anim = true}, WelfareTagType.MonthCard)
        return
      else
        local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_BUILD_PARKINGLOT_FOUR)
        if buildData and buildData.level == 0 then
          GoToUtil.GotoCityByBuildId(BuildingTypes.LW_BUILD_PARKINGLOT_FOUR, WorldTileBtnType.GolloesCamp)
          return
        end
      end
    end
    UIUtil.ShowSingleTip(Localization:GetString(GameDialogDefine.UNLOCK_ARMY_FORMATION))
  end
end

local function OnJumpToFormationPos(self, isInClick)
  if self.uuid ~= nil then
    local marchInfo = DataCenter.WorldMarchDataManager:GetOwnerFormationMarch(LuaEntry.Player.uid, self.uuid, LuaEntry.Player.allianceId)
    if marchInfo ~= nil then
      local GotoWorldPos = GoToUtil.GotoWorldPos
      if marchInfo.worldId > 0 then
        GotoWorldPos = GoToUtil.GotoDragonPos
      end
      local marchStatus = marchInfo:GetMarchStatus()
      if marchStatus == MarchStatus.IN_WORM_HOLE or marchStatus == MarchStatus.CROSS_SERVER then
        GotoWorldPos(SceneUtils.TileIndexToWorld(marchInfo.startPos, ForceChangeScene.World), CS.SceneManager.World.InitZoom, nil, nil, marchInfo.serverId, marchInfo.worldId, marchInfo:GetWorldType())
      elseif marchInfo:GetMarchType() == NewMarchType.EXPLORE then
        local troop = CS.SceneManager.World:GetTroop(marchInfo.uuid)
        if troop ~= nil then
          GotoWorldPos(troop:GetPosition(), CS.SceneManager.World.InitZoom, nil, nil, marchInfo.serverId, marchInfo.worldId, marchInfo:GetWorldType())
        else
          GoToUtil.GotoMarchCurPos(marchInfo, CS.SceneManager.World.InitZoom)
        end
        self.view:HideAllShowTip()
      elseif marchStatus == COLLECTING then
        GotoWorldPos(SceneUtils.TileIndexToWorld(marchInfo.startPos, ForceChangeScene.World))
        local position = SceneUtils.TileIndexToWorld(marchInfo.startPos, ForceChangeScene.World)
        WorldArrowManager:GetInstance():ShowArrowEffect(0, position, ArrowType.Building)
        self.view:HideAllShowTip()
      elseif marchStatus == ASSISTANCE then
        GotoWorldPos(SceneUtils.TileIndexToWorld(marchInfo.startPos, ForceChangeScene.World), CS.SceneManager.World.InitZoom, nil, nil, marchInfo.serverId)
        local position = SceneUtils.TileIndexToWorld(marchInfo.startPos, ForceChangeScene.World)
        position.x = position.x - 1
        position.y = position.y
        position.z = position.z - 1
        WorldArrowManager:GetInstance():ShowArrowEffect(0, position, ArrowType.Building)
      elseif marchStatus == WAIT_RALLY then
        GotoWorldPos(SceneUtils.TileIndexToWorld(marchInfo.startPos, ForceChangeScene.World), CS.SceneManager.World.InitZoom, nil, nil, marchInfo.serverId)
        local position = SceneUtils.TileIndexToWorld(marchInfo.startPos, ForceChangeScene.World)
        position.x = position.x - 1
        position.y = position.y
        position.z = position.z - 1
        WorldArrowManager:GetInstance():ShowArrowEffect(0, position, ArrowType.Building)
        self.view:HideAllShowTip()
      elseif marchStatus == IN_TEAM then
        local teamMarch = DataCenter.WorldMarchDataManager:GetAllianceMarchesInTeam(LuaEntry.Player.allianceId, marchInfo.teamUuid)
        if teamMarch ~= nil and isInClick ~= nil and isInClick == true then
          if teamMarch:GetMarchStatus() == WAIT_RALLY then
            GotoWorldPos(SceneUtils.TileIndexToWorld(teamMarch.startPos, ForceChangeScene.World), CS.SceneManager.World.InitZoom, nil, nil, marchInfo.serverId)
            local position = SceneUtils.TileIndexToWorld(teamMarch.startPos, ForceChangeScene.World, marchInfo:GetWorldType())
            position.x = position.x - 1
            position.y = position.y
            position.z = position.z - 1
            WorldArrowManager:GetInstance():ShowArrowEffect(0, position, ArrowType.Building)
          else
            self.view.ctrl:SetSelectFormationUuid(self.uuid)
            self.view:OnSelectClick(self.uuid)
            CS.SceneManager.World:TrackMarch(teamMarch.uuid)
            WorldMarchTileUIManager:GetInstance():ShowTroop(teamMarch.uuid)
          end
        end
        self.view:HideAllShowTip()
      else
        self.view.ctrl:SetSelectFormationUuid(self.uuid)
        self.view:OnSelectClick(self.uuid)
        GoToUtil.GotoMarchCurPos(marchInfo, nil, function()
          if isInClick ~= nil and isInClick == true then
            CS.SceneManager.World:TrackMarch(marchInfo.uuid)
          end
          WorldMarchTileUIManager:GetInstance():ShowTroop(marchInfo.uuid)
          self.view:HideAllShowTip()
        end)
      end
    elseif self.dataInfo ~= nil and self.dataInfo.useForm == true then
      self.view.ctrl:SetSelectFormationUuid(self.uuid)
      self.view:OnSelectClick(self.uuid)
      if self.img_bg.transform ~= nil then
        local posX = self.img_bg.transform.position.x
        local posY = self.img_bg.transform.position.y + 30
        self.view:ShowFormationArmyTip(posX, posY, self.dataInfo)
      end
    else
      self.view.ctrl:SetSelectFormationUuid(self.uuid)
      self.view:OnSelectClick(self.uuid)
      if self.img_bg.transform ~= nil then
        do
          local posX = self.img_bg.transform.position.x
          local posY = self.img_bg.transform.position.y + 30
          self.view:ShowFormationCreateTip(posX, posY, self.dataInfo)
        end
      end
    end
  end
end

local function OnSelectClick(self, uuid)
  if self.uuid ~= nil and self.uuid == uuid then
    self.focus_img:SetActive(true)
    if self.dataInfo ~= nil and self.view.ctrl.targetType >= 0 then
      if self.dataInfo.marchUuid ~= nil then
        CS.SceneManager.World.marchUuid = self.dataInfo.marchUuid
      end
    elseif self.dataInfo ~= nil and self.dataInfo.marchUuid ~= nil then
      CS.SceneManager.World.marchUuid = self.dataInfo.marchUuid
    end
  else
    self.focus_img:SetActive(false)
    if self.dataInfo ~= nil then
    end
  end
end

local function ShowTroopActionArrow(self)
  if self.dataInfo == nil then
    return false
  end
  if self.dataInfo.isMarch > 0 or self.dataInfo.useForm == true then
    return false
  end
  local param = {
    arrowType = ArrowType.Normal,
    positionType = PositionType.Screen,
    position = Vector3.New(self.gameObject.transform.position.x, self.gameObject.transform.position.y, 0) + Vector3.New(0, 50, 0)
  }
  DataCenter.ArrowManager:ShowArrow(param)
  return true
end

local function UpdateTime(self)
  if self.isUpdate then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local deltaTime = self.endTime - curTime
    if 0 < deltaTime then
      self.num_txt:SetText(UITimeManager:GetInstance():MilliSecondToFmtStringSpecial(deltaTime))
    else
      self.num_txt:SetText("")
      self.isUpdate = false
    end
  end
end

FormationSelectListCellNewV2.OnCreate = OnCreate
FormationSelectListCellNewV2.OnDestroy = OnDestroy
FormationSelectListCellNewV2.OnEnable = OnEnable
FormationSelectListCellNewV2.OnDisable = OnDisable
FormationSelectListCellNewV2.RefreshData = RefreshData
FormationSelectListCellNewV2.SetUuidAndIndex = SetUuidAndIndex
FormationSelectListCellNewV2.OnAtkClick = OnAtkClick
FormationSelectListCellNewV2.OnSelectClick = OnSelectClick
FormationSelectListCellNewV2.RefreshSlider = RefreshSlider
FormationSelectListCellNewV2.OnBeginDrag = OnBeginDrag
FormationSelectListCellNewV2.RefreshMarchData = RefreshMarchData
FormationSelectListCellNewV2.ShowTroopActionArrow = ShowTroopActionArrow
FormationSelectListCellNewV2.UpdateTime = UpdateTime
FormationSelectListCellNewV2.OnJumpToFormationPos = OnJumpToFormationPos
FormationSelectListCellNewV2.RefreshCaptain = RefreshCaptain
return FormationSelectListCellNewV2
