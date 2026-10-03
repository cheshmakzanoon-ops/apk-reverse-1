local TroopNameLabel = BaseClass("TroopNameLabel")
local WorldTroopVirus = require("Scene.TroopNameLabel.WorldTroopVirus")
local player_name_path = "Transform/BannerNode/name"
local player_name_bg_path = "Transform/BannerNode/NameBg"
local player_select_path = "Transform/BannerNode/SettleIcon"
local troop_icon_path = "Transform/BannerNode/SettleIcon/SettleIcon"
local banner_path = "Transform/BannerNode"
local DisplaySettings = require("DataCenter.WorldBattle.WorldBattleDisplaySettings")
local WorldTroopLightEffect = require("Scene.WorldTroopEffect.WorldTroopLightEffect")
local pin_path = "Pin"
local Localization = CS.GameEntry.Localization

local function OnCreate(self, go)
  if go ~= nil then
    self.request = go
    self.gameObject = go.gameObject
    self.transform = go.gameObject.transform
  end
  self.VirusRoot = nil
  self.LightRoot = nil
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
end

local function ComponentDefine(self)
  self.player_select = self.transform:Find(player_select_path).gameObject
  self.bannerNode = self.transform:Find(banner_path)
  self.troop_icon = self.transform:Find(troop_icon_path):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  self.player_name = self.transform:Find(player_name_path):GetComponent(typeof(CS.TextMeshProEx))
  self.player_bg_name = self.transform:Find(player_name_bg_path)
  self.helpIcon = self.transform:Find("Transform/BannerNode/name/iconHelp")
  self.selectTran = self.transform:Find("selectObj")
  self.troop_Circle = self.transform:Find("selectObj/TroopSelect"):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  self.player_head = self.transform:Find("Transform/BannerNode/Head"):GetComponent(typeof(CS.UIPlayerHead))
  self.player_headSp = self.transform:Find("Transform/BannerNode/Head"):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  self.player_headBg = self.transform:Find("Transform/BannerNode/HeadBg"):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  self.player_headFrame = self.transform:Find("Transform/BannerNode/HeadFrame"):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  self.transformNode = self.transform:Find("Transform")
  self.troop_pin = self.transformNode:Find(pin_path):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  self.curIconState = TroopIconShowState.Hide
  self.player_select:SetActive(false)
  if self.helpIcon then
    self.helpIcon.gameObject:SetActive(false)
    self.helpIconSpr = self.helpIcon:GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  end
end

local function ComponentDestroy(self)
  self.player_select = nil
  self.name_bg = nil
  self.helpIcon = nil
  self.helpIconSpr = nil
  self.player_name = nil
  self.player_bg_name = nil
  self.player_head_mat = nil
  self.player_frame_mat = nil
  self.selectTran = nil
  self.bannerNode = nil
  if self.LightRoot ~= nil then
    self.LightRoot:Delete()
    self.LightRoot = nil
  end
  if self.VirusRoot ~= nil then
    self.VirusRoot:OnDestroy()
    self.VirusRoot:Delete()
    self.VirusRoot = nil
  end
end

local function SetPlayerHeadVisible(self, visible)
  if self.player_head and self.player_head.gameObject then
    self.player_head.gameObject:SetActive(visible)
  end
  if self.player_headFrame and self.player_headFrame.gameObject then
    self.player_headFrame.gameObject:SetActive(visible)
  end
  if self.player_headBg and self.player_headBg.gameObject then
    self.player_headBg.gameObject:SetActive(visible)
  end
end

function TroopNameLabel:SetNameVisible(visible)
  if self.player_name then
    self.player_name.gameObject:SetActive(visible)
  end
  if self.player_bg_name then
    self.player_bg_name.gameObject:SetActive(visible)
  end
end

local function SetName(self, marchInfo)
  if IsNull(self.player_name) then
    return
  end
  if not string.IsNullOrEmpty(marchInfo.ownerName) then
    local showName = MarchUtil.IsWerewolf(marchInfo) and Localization:GetString(GameDialogDefine.WEREWOLF) or DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(marchInfo.ownerUid, marchInfo.ownerName)
    if not string.IsNullOrEmpty(marchInfo.allianceAbbr) then
      self.player_name.text = "[" .. marchInfo.allianceAbbr .. "] " .. showName
    else
      self.player_name.text = showName
    end
  else
    self.player_name.text = ""
  end
  if self.helpIconSpr and marchInfo.isAssistAllyMarch then
    local mySourceServerId = LuaEntry.Player:GetSourceServerId()
    local myMarch = marchInfo.ownerUid == LuaEntry.Player.uid
    local isSameCamp = myMarch or DataCenter.SeasonFactionWarDataManager:IsInSameCampByServer(marchInfo.ownerServer, mySourceServerId)
    self.helpIcon.gameObject:SetActive(true)
    if isSameCamp then
      self.helpIconSpr:LoadSprite("Assets/Main/SeasonRes/S6/Sprites/AllyFriendS6/mjc_TMJM_icon_1_jiemeng.png")
    else
      self.helpIconSpr:LoadSprite("Assets/Main/SeasonRes/S6/Sprites/AllyFriendS6/mjc_TMJM_icon_1_jiemeng_red.png")
    end
    local textWidth = self.player_name:GetWidth()
    self.helpIcon:Set_localPosition(-0.005 * textWidth - 0.15, 0, 0)
  end
  local camp = DataCenter.WorldTroopLineManager:GetCamp(marchInfo)
  local nameColor = DataCenter.WorldTroopLineManager:GetColor(camp, WorldTroopColorType.name)
  local lineColor = DataCenter.WorldTroopLineManager:GetColor(camp, WorldTroopColorType.light)
  self.player_name.color32 = nameColor
  self.troop_Circle.color = lineColor
  self.troop_Circle.gameObject:SetActive(marchInfo:GetMarchType() ~= NewMarchType.TRAIN and marchInfo:GetMarchType() ~= NewMarchType.ZONE_TRAIN)
  if marchInfo:ShowFiveHero() then
    if marchInfo.ownerUid == "fakeUser" then
      self.player_head:SetFakeData()
      self.player_headFrame:LoadSprite(DefaultHeadFramePath)
    else
      self.player_head:SetData(marchInfo.ownerUid, marchInfo.pic, marchInfo.picVer)
      local headFramePath = DataCenter.DecorationDataManager:GetHeadFrame(marchInfo.headSkinId, marchInfo.headSkinET)
      headFramePath = headFramePath or DefaultHeadFramePath
      self.player_headFrame:LoadSprite(headFramePath)
    end
    self.showPlayerHead = true
  else
    self.showPlayerHead = false
  end
  SeasonUtil.UpdateTroopIconByMarchInfo(marchInfo, self.troop_pin)
  self:UpdateDisplayMode(marchInfo.uuid)
end

local function CarRebuildState(self, marchInfo)
  if marchInfo:GetMarchType() == NewMarchType.CAR_REBUILD then
    self.player_head:SetData(marchInfo.ownerUid, marchInfo.pic, marchInfo.picVer)
    local headFramePath = DataCenter.DecorationDataManager:GetHeadFrame(marchInfo.headSkinId, marchInfo.headSkinET)
    headFramePath = headFramePath or DefaultHeadFramePath
    self.player_headFrame:LoadSprite(headFramePath)
    self.showPlayerHead = true
    self.needHideHead = false
    self.player_select:SetActive(false)
    self:RefreshPlayerIconState()
  end
end

local function ShowIcon(self, state)
  if self.curIconState ~= state then
    self.curIconState = state
    if self.curIconState == TroopIconShowState.Idle then
      self.player_select:SetActive(true)
      self.troop_icon:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/Common_icon_march_station")
      self.needHideHead = false
    elseif self.curIconState == TroopIconShowState.Broken then
      self.player_select:SetActive(true)
      self.troop_icon:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/Common_icon_march_fail")
      self.needHideHead = true
    else
      self.player_select:SetActive(false)
      self.needHideHead = true
    end
    self:RefreshPlayerIconState()
  end
end

function TroopNameLabel:RefreshPlayerIconState()
  self:SetPlayerHeadVisible(not self.needHideHead and self.showPlayerHead and DisplaySettings.ShowPlayerDogHead())
end

local function UpdateDisplayMode(self, marchUuid)
  local squad = DataCenter.WorldBattleManager:GetSquad(marchUuid)
  if not squad then
    if self.VirusRoot ~= nil then
      self.VirusRoot:HideVirus()
    end
    if self.LightRoot ~= nil then
      self.LightRoot:SetActive(false)
    end
    if ComponentIsValid(self.troop_pin) then
      self.troop_pin.gameObject:SetActive(false)
    end
    self:RefreshRootPosition(0)
  else
    local showTroopPin = DisplaySettings.ShowTroopPin(squad.displayLevel)
    if ComponentIsValid(self.troop_pin) then
      self.troop_pin.gameObject:SetActive(showTroopPin)
    end
    if self.troop_Circle then
      self.troop_Circle.enabled = not DisplaySettings.HideTroopLineMiddleSprite()
    end
    local canShowEffect = WorldSimpleModeUtils.ShowMummyMembers()
    if showTroopPin or not canShowEffect then
      if self.VirusRoot ~= nil then
        self.VirusRoot:HideVirus()
      end
      if self.LightRoot ~= nil then
        self.LightRoot:SetActive(false)
      end
    else
      local seasonType = SeasonUtil.GetSeasonType()
      local marchInfo = CS.SceneManager.World:GetMarch(marchUuid)
      if marchInfo == nil then
        if self.LightRoot ~= nil then
          self.LightRoot:SetActive(false)
        end
      elseif 0 < toInt(marchInfo.ownerLightUuid) then
        local canShowTroopLight = WorldSimpleModeUtils.CanShowTroopLight()
        if canShowTroopLight then
          if self.LightRoot == nil then
            local troop = CS.SceneManager.World:GetTroop(marchUuid)
            if troop ~= nil then
              self.LightRoot = WorldTroopLightEffect.New("TroopLight", self.transform, "Assets/_Art_LastWar/Effect/Prefab/S4/Eff_ljw_s4_budui_light.prefab")
              local quaternion = troop:GetRotation()
              self.LightRoot:SetRotation(quaternion.x, quaternion.y, quaternion.z, quaternion.w)
            end
          else
            self.LightRoot:UpdateDisplayLevel()
          end
        elseif self.LightRoot ~= nil then
          self.LightRoot:UpdateDisplayLevel()
        end
      end
      if self.VirusRoot ~= nil then
        if marchInfo == nil then
          self.VirusRoot:HideVirus()
        else
          self.VirusRoot:UpdateVirusInfo(squad.displayLevel, marchInfo)
        end
      elseif seasonType == SeasonMapType.CityStronghold and marchInfo ~= nil then
        local theModelGo = self.transform:Find("Transform")
        local baseVirusLayer = marchInfo.baseVirusLayer or 0
        local extraVirusLayer = marchInfo.extraVirusLayer or 0
        if theModelGo ~= nil and (baseVirusLayer ~= 0 or extraVirusLayer ~= 0) then
          self.VirusRoot = WorldTroopVirus.New(theModelGo, Vector3.New(0, 0.79, 0), Vector3.New(0.333, 0.333, 1), squad.displayLevel, marchInfo)
        end
      end
    end
    self:RefreshRootPosition(DisplaySettings.GetCurrentDisplayLevel())
  end
  self:RefreshPlayerIconState()
end

local posArray = {
  Vector3.New(0, 0, 0),
  Vector3.New(0, -0.212, -0.68),
  Vector3.New(0, -0.344, -1.1),
  Vector3.New(0, -0.344, -1.1)
}
local scaleArray = {
  Vector3.New(1, 1, 1),
  Vector3.New(1, 1, 1),
  Vector3.New(1, 1, 1),
  Vector3.New(0.85, 0.85, 0.85)
}
local selectionScaleArray = {
  Vector3.New(1.3, 1.3, 1.3),
  Vector3.New(0.8, 0.8, 0.8),
  Vector3.New(0.5, 0.5, 0.5),
  Vector3.New(0.5, 0.5, 0.5)
}

function TroopNameLabel:RefreshRootPosition(displayLevel)
  displayLevel = displayLevel or 0
  if self.bannerNode then
    local defaultPos = posArray[1]
    local defaultScale = scaleArray[1]
    displayLevel = -displayLevel + 1
    self.bannerNode.localPosition = posArray[displayLevel] or defaultPos
    self.bannerNode.localScale = scaleArray[displayLevel] or defaultScale
  end
  if self.selectTran then
    local defaultScale = selectionScaleArray[1]
    self.selectTran.localScale = selectionScaleArray[displayLevel] or defaultScale
  end
end

function TroopNameLabel:SetNameAndShowIconByData(Data)
  if Data then
    if IsNull(self.player_name) then
      return
    end
    local showName = MarchUtil.IsWerewolf(Data) and Localization:GetString(GameDialogDefine.WEREWOLF) or Data.name
    if not string.IsNullOrEmpty(showName) then
      if not string.IsNullOrEmpty(Data.abbr) then
        self.player_name.text = "[" .. Data.abbr .. "] " .. showName
      else
        self.player_name.text = showName
      end
    else
      self.player_name.text = ""
    end
    local camp = WorldCamp.Ally
    local nameColor = DataCenter.WorldTroopLineManager:GetColor(camp, WorldTroopColorType.name)
    self.player_name.color32 = nameColor
    self.troop_Circle.gameObject:SetActive(true)
    self.player_head:SetData(Data.uid, Data.pic, Data.picver)
    local headFramePath = DataCenter.DecorationDataManager:GetHeadFrame(Data.headSkinId, Data.headSkinET)
    headFramePath = headFramePath or DefaultHeadFramePath
    self.player_headFrame:LoadSprite(headFramePath)
    self.player_head.gameObject:SetActive(true)
    self.player_headFrame.gameObject:SetActive(true)
    self.player_headBg.gameObject:SetActive(true)
    self.player_select:SetActive(false)
    self.troop_pin.gameObject:SetActive(false)
  end
end

TroopNameLabel.OnCreate = OnCreate
TroopNameLabel.OnDestroy = OnDestroy
TroopNameLabel.ComponentDefine = ComponentDefine
TroopNameLabel.ComponentDestroy = ComponentDestroy
TroopNameLabel.SetName = SetName
TroopNameLabel.ShowIcon = ShowIcon
TroopNameLabel.UpdateDisplayMode = UpdateDisplayMode
TroopNameLabel.SetPlayerHeadVisible = SetPlayerHeadVisible
TroopNameLabel.CarRebuildState = CarRebuildState
return TroopNameLabel
