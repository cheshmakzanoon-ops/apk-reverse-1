local AssemblyNameLabel = BaseClass("AssemblyNameLabel")
local WorldTroopVirus = require("Scene.TroopNameLabel.WorldTroopVirus")
local DisplaySettings = require("DataCenter.WorldBattle.WorldBattleDisplaySettings")
local WorldTroopLightEffect = require("Scene.WorldTroopEffect.WorldTroopLightEffect")

local function OnCreate(self, go)
  if go ~= nil then
    self.request = go
    self.gameObject = go.gameObject
    self.transform = go.gameObject.transform
  end
  self.LightRoot = nil
  self.VirusRoot = nil
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
end

local function ComponentDefine(self)
  self.trans_node = self.transform:Find("Transform")
  self.troop_Circle = self.transform:Find("selectObj/TroopSelect"):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  self.player_name = self.transform:Find("Transform/name"):GetComponent(typeof(CS.SuperTextMesh))
  self.player_nameBg = self.transform:Find("Transform/NameBg")
  self.troop_pin = self.transform:Find("Transform/Pin"):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  self.members = {}
  for i = 1, 5 do
    local member = {}
    local route = "Transform/Member" .. i
    member.transform = self.transform:Find(route)
    member.gameObject = member.transform.gameObject
    member.followComp = member.gameObject:GetComponent(typeof(CS.FollowTarget))
    member.head = self.transform:Find(route .. "/Head"):GetComponent(typeof(CS.UIPlayerHead))
    member.frame = self.transform:Find(route .. "/HeadFrame"):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
    member.gameObject:SetActive(false)
    self.members[i] = member
  end
end

local function ComponentDestroy(self)
  if self.memebers then
    for i = 1, 5 do
      local member = self.members[i]
      if member and member.followComp then
        member.followComp:SetTarget(nil)
      end
    end
    self.members = nil
  end
  if self.trans_node and self.player_name and self.player_name.transform then
    self.player_name.transform:SetParent(self.trans_node)
  end
  if self.trans_node and self.player_nameBg and self.player_nameBg.transform then
    self.player_nameBg.transform:SetParent(self.trans_node)
  end
  self.trans_node = nil
  self.player_name = nil
  self.player_nameBg = nil
  self.troop_Circle = nil
  self.troop_pin = nil
  self.isFollowing = nil
  self.followingSquad = nil
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

local function SetPlayerHeadVisible(self, index, visible)
  if not self.members then
    return
  end
  local member = self.members[index]
  if not member then
    return
  end
  member.gameObject:SetActive(visible)
end

local function SetPlayerHeadData(self, index, uid, pic, picVar, skinId, skinET)
  if not self.members then
    return
  end
  local member = self.members[index]
  if not member then
    return
  end
  if member.head then
    member.head:SetData(uid, pic, picVar)
  end
  if member.frame then
    local framePath = DataCenter.DecorationDataManager:GetHeadFrame(skinId, skinET)
    framePath = framePath or DefaultHeadFramePath
    member.frame:LoadSprite(framePath)
  end
  member.gameObject:SetActive(true)
end

local function SetName(self, marchInfo)
  if IsNull(self.player_name) then
    return
  end
  if not string.IsNullOrEmpty(marchInfo.ownerName) then
    if not string.IsNullOrEmpty(marchInfo.allianceAbbr) then
      self.player_name.text = "[" .. marchInfo.allianceAbbr .. "] " .. marchInfo.ownerName
    else
      self.player_name.text = marchInfo.ownerName
    end
  else
    self.player_name.text = ""
  end
  local camp = DataCenter.WorldTroopLineManager:GetCamp(marchInfo)
  local nameColor = DataCenter.WorldTroopLineManager:GetColor(camp, WorldTroopColorType.name)
  local lineColor = DataCenter.WorldTroopLineManager:GetColor(camp, WorldTroopColorType.light)
  self.player_name.color32 = nameColor
  self.troop_Circle.color = lineColor
  if not marchInfo:ShowFiveHero() then
    Logger.LogError("a assembly march which is not ShowFiveHero() -> true. uuid:" .. marchInfo.uuid .. " type:" .. tostring(marchInfo.type))
  end
  self:SetPlayerHeadData(1, marchInfo.ownerUid, marchInfo.pic, marchInfo.picVer, marchInfo.headSkinId, marchInfo.headSkinET)
  local memberIdx = 2
  for i = 0, marchInfo.armyInfos.Count - 1 do
    local armyInfo = marchInfo.armyInfos[i]
    if armyInfo.uid ~= marchInfo.ownerUid then
      self:SetPlayerHeadData(memberIdx, armyInfo.uid, armyInfo.pic, armyInfo.picVer, armyInfo.headSkinId)
      memberIdx = memberIdx + 1
    end
  end
  for i = memberIdx, 5 do
    self:SetPlayerHeadVisible(i, false)
  end
  SeasonUtil.UpdateTroopIconByMarchInfo(marchInfo, self.troop_pin)
  self:UpdateDisplayMode(marchInfo.uuid)
end

local function ShowIcon(self, state)
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
    if self.troop_pin and self.troop_pin.gameObject then
      self.troop_pin.gameObject:SetActive(false)
    end
    self:StopFollowAndResetComponents()
  else
    local showTroopPin = DisplaySettings.ShowTroopPin(squad.displayLevel)
    if self.troop_pin and self.troop_pin.gameObject then
      self.troop_pin.gameObject:SetActive(showTroopPin)
    end
    if DisplaySettings.OnlyDisplayLeader(squad.displayLevel) then
      self:StopFollowAndResetComponents()
    else
      self:StartFollowSquadHeros(marchUuid)
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
      elseif toInt(marchInfo.ownerLightUuid) > 0 then
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
        local theModelGo = self.transform:Find("Transform/Member1")
        local baseVirusLayer = marchInfo.baseVirusLayer or 0
        local extraVirusLayer = marchInfo.extraVirusLayer or 0
        if theModelGo ~= nil and (baseVirusLayer ~= 0 or extraVirusLayer ~= 0) then
          self.VirusRoot = WorldTroopVirus.New(theModelGo, Vector3.New(0, 0.3, 0), Vector3.New(0.278, 0.278, 1), squad.displayLevel, marchInfo)
        end
      end
    end
  end
end

local function StopFollowAndResetComponents(self)
  if self.isFollowing == nil or self.isFollowing == false then
    return
  end
  if self.members then
    for i = 1, 5 do
      local member = self.members[i]
      if member and member.transform and member.followComp then
        if i == 1 then
          member.transform:Set_localPosition(-0.5, 0.04, 0)
        else
          local lx = -0.15 + (i - 2) * 0.28
          member.transform:Set_localPosition(lx, -0.017, 0)
        end
        member.followComp:SetTarget(nil)
      end
    end
  end
  if self.player_nameBg and self.trans_node then
    self.player_nameBg:SetParent(self.trans_node)
    self.player_nameBg:Set_localPosition(0.322, 0.2, 0)
  end
  if self.player_name and self.trans_node then
    self.player_name.transform:SetParent(self.trans_node)
    self.player_name.transform:Set_localPosition(-0.259, 0.1618, 0)
    self.player_name.alignment = CS.SuperTextMesh.Alignment.MidLeft
    self.player_name:Rebuild()
  end
  self.isFollowing = false
end

local function StartFollowSquadHeros(self, marchUuid)
  if self.isFollowing == true or self.player_nameBg == nil or self.player_name == nil then
    return
  end
  if not self.followingSquad then
    local squad = DataCenter.WorldBattleManager:GetSquad(marchUuid)
    self.followingSquad = squad
  end
  if not self.followingSquad or not self.followingSquad.transform then
    self:StopFollowAndResetComponents()
    return
  end
  local target = self.followingSquad.transform
  for i = 1, 5 do
    local member = self.members[i]
    local offset = self.followingSquad.formation.GetOffsetByIndex(i)
    member.followComp:SetTargetAndOffsetXYZ(target, offset.x, offset.y + (i == 1 and 6 or 4), offset.z)
  end
  self.player_nameBg:SetParent(self.members[1].transform)
  self.player_nameBg:Set_localPosition(0, -0.2, 0)
  self.player_name.transform:SetParent(self.player_nameBg)
  self.player_name.transform:Set_localPosition(0, -0.03, 0)
  self.player_name.alignment = CS.SuperTextMesh.Alignment.MidCenter
  self.player_name:Rebuild()
  self.isFollowing = true
end

AssemblyNameLabel.OnCreate = OnCreate
AssemblyNameLabel.OnDestroy = OnDestroy
AssemblyNameLabel.ComponentDefine = ComponentDefine
AssemblyNameLabel.ComponentDestroy = ComponentDestroy
AssemblyNameLabel.SetName = SetName
AssemblyNameLabel.ShowIcon = ShowIcon
AssemblyNameLabel.UpdateDisplayMode = UpdateDisplayMode
AssemblyNameLabel.SetPlayerHeadVisible = SetPlayerHeadVisible
AssemblyNameLabel.SetPlayerHeadData = SetPlayerHeadData
AssemblyNameLabel.StopFollowAndResetComponents = StopFollowAndResetComponents
AssemblyNameLabel.StartFollowSquadHeros = StartFollowSquadHeros
return AssemblyNameLabel
