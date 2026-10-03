local UILWArena3V3PlayerInfoView = BaseClass("UILWArena3V3PlayerInfoView", UIBaseView)
local base = UIBaseView
local closePanel_path = "panel"
local closeBtn_path = "CloseBtn"
local defTeam1_path = "Root/DefTeam1"
local defTeam2_path = "Root/DefTeam2"
local defTeam3_path = "Root/DefTeam3"
local playerHead_path = "Root/UIPlayerHead"
local playerNameLayout_path = "Root/UIPlayerNameLayout"
local powerText_path = "Root/Power/PowerText"
local scoreText_path = "Root/Score/ScoreText"
local tacticalWeaponBtn_path = "Root/TacticalWeapon"
local tacticalWeaponLevelText_path = "Root/TacticalWeapon/TacticalWeaponLevelNumberText"
local UILW3V3TeamItem = require("UI.UILW3V3Campaign.Component.UILW3V3TeamItem")

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.playerUid = self:GetUserData()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self.active = true
  self:Refresh()
end

local function OnDisable(self)
  self.active = false
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.closePanel = self:AddComponent(UIButton, closePanel_path)
  self.closePanel:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.closeBtn = self:AddComponent(UIButton, closeBtn_path)
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.defTeam1 = self:AddComponent(UILW3V3TeamItem, defTeam1_path)
  self.defTeam2 = self:AddComponent(UILW3V3TeamItem, defTeam2_path)
  self.defTeam3 = self:AddComponent(UILW3V3TeamItem, defTeam3_path)
  self.defTeams = {
    [1] = self.defTeam1,
    [2] = self.defTeam2,
    [3] = self.defTeam3
  }
  self.playerHead = self:AddComponent(UICommonHead, playerHead_path)
  self.playerHead:SetEnableClickShowInfo(true)
  self.playerNameLayout = self:AddComponent(UICommonNameLayout, playerNameLayout_path)
  self.powerText = self:AddComponent(UIText, powerText_path)
  self.scoreText = self:AddComponent(UIText, scoreText_path)
  self.tacticalWeaponBtn = self:AddComponent(UIButton, tacticalWeaponBtn_path)
  self.tacticalWeaponBtn:SetOnClick(function()
    if self.weaponData then
      local selfEquips = self.equips
      local power = self.weaponData:GetPower()
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWTacticalWeaponTip, {anim = true}, self.weaponData, selfEquips, self.tacticalWeaponBtn, self.weaponSkinId, nil, power)
    end
  end)
  self.tacticalWeaponLevelText = self:AddComponent(UIText, tacticalWeaponLevelText_path)
end

local function ComponentDestroy(self)
  self.closePanel = nil
  self.closeBtn = nil
  self.defTeam1 = nil
  self.defTeam2 = nil
  self.defTeam3 = nil
  self.defTeams = nil
  self.playerHead = nil
  self.playerNameLayout = nil
  self.powerText = nil
  self.scoreText = nil
  self.tacticalWeaponBtn = nil
  self.tacticalWeaponLevelText = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function RefreshWeaponInfo(self, weaponData)
  if weaponData then
    self.tacticalWeaponBtn:SetActive(true)
    self.tacticalWeaponLevelText:SetText(weaponData.lv)
    if not self.weaponData then
      self.weaponData = TacticalWeaponInfo.New()
    end
    self.weaponData:CreateFromTemplate(weaponData.id, weaponData.lv, 0, weaponData.props)
    self.weaponData.power = weaponData.power or self.weaponData.power
    self.weaponSkinId = weaponData.uavSkinId
    local equips = {}
    if not string.IsNullOrEmpty(weaponData.uavEquips) then
      local equipIds = string.split(weaponData.uavEquips, "|")
      local expStrList
      if weaponData.uavEquipExps then
        expStrList = string.split(weaponData.uavEquipExps, "|")
      end
      for i = 1, #equipIds do
        local exp = 0
        if expStrList then
          exp = tonumber(expStrList[i])
        end
        local equipId = tonumber(equipIds[i])
        local equipInfo = CommonEquipInfo.New()
        equipInfo:UpdateInfo({cfgId = equipId, exp = exp})
        equips[equipInfo:GetConfigSlot()] = equipInfo
      end
    end
    self.oppoEquips = equips or {}
    self.equips = equips or {}
  else
    self.tacticalWeaponBtn:SetActive(false)
  end
end

local function Refresh(self)
  if self.playerUid == nil then
    return
  end
  local defTeam1Info = DataCenter.LW3V3Manager:GetDefTeamByIndex(self.playerUid, 1)
  local defTeam2Info = DataCenter.LW3V3Manager:GetDefTeamByIndex(self.playerUid, 2)
  local defTeam3Info = DataCenter.LW3V3Manager:GetDefTeamByIndex(self.playerUid, 3)
  local defTeamsInfo = {}
  defTeamsInfo = {
    [1] = defTeam1Info,
    [2] = defTeam2Info,
    [3] = defTeam3Info
  }
  for i = 1, 3 do
    local teamInfo = defTeamsInfo[i]
    if teamInfo then
      local heroesUuid = teamInfo:GetLocalAllHeroes()
      local heroesData = {}
      for index, uuid in pairs(heroesUuid) do
        local heroData = teamInfo:GetHeroDataByUuid(uuid)
        heroesData[index] = heroData
      end
      local defTeamItem = self.defTeams[i]
      if defTeamItem then
        if teamInfo.power then
          defTeamItem:SetData(heroesData, string.GetFormattedStr(teamInfo.power), teamInfo:GetDominatorData())
        else
          defTeamItem:SetData(heroesData, string.GetFormattedStr(teamInfo:GetTotalCapacity()), teamInfo:GetDominatorData())
        end
      end
    end
  end
  local playerData = DataCenter.LW3V3ArenaManager:GetPlayerData(self.playerUid)
  if playerData then
    local playerInfo = playerData.playerInfo
    local playerUid, playerServerId
    if playerInfo then
      local headFramePath = DataCenter.DecorationDataManager:GetHeadFrame(playerInfo.headSkinId, playerInfo.headSkinET, false)
      self.playerHead:SetData(playerInfo.uid, playerInfo.pic, playerInfo.picver, nil, headFramePath)
      self.playerNameLayout:SetData(playerInfo.name, playerInfo.abbr, nil, nil, nil, nil, playerInfo.serverId)
      if playerData.formationPower then
        self.powerText:SetText(playerData.formationPower)
      else
        self.powerText:SetText(playerInfo.power)
      end
      playerUid = playerInfo.uid
      playerServerId = playerInfo.serverId
    end
    self.scoreText:SetText(playerData.score)
    local weaponData = DataCenter.TacticalWeaponManager:GetOtherPlayerWeaponInfo(playerUid, playerServerId)
    self:RefreshWeaponInfo(weaponData)
  end
end

local function OnGetOtherPlayerWeaponInfo(self, playerUid)
  if playerUid == self.playerUid then
    local weaponData = DataCenter.TacticalWeaponManager:GetOtherPlayerWeaponInfo(playerUid)
    self:RefreshWeaponInfo(weaponData)
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.GetOtherWeaponInfo, self.OnGetOtherPlayerWeaponInfo)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.GetOtherWeaponInfo, self.OnGetOtherPlayerWeaponInfo)
end

UILWArena3V3PlayerInfoView.OnCreate = OnCreate
UILWArena3V3PlayerInfoView.OnDestroy = OnDestroy
UILWArena3V3PlayerInfoView.OnEnable = OnEnable
UILWArena3V3PlayerInfoView.OnDisable = OnDisable
UILWArena3V3PlayerInfoView.ComponentDefine = ComponentDefine
UILWArena3V3PlayerInfoView.ComponentDestroy = ComponentDestroy
UILWArena3V3PlayerInfoView.DataDefine = DataDefine
UILWArena3V3PlayerInfoView.DataDestroy = DataDestroy
UILWArena3V3PlayerInfoView.Refresh = Refresh
UILWArena3V3PlayerInfoView.OnAddListener = OnAddListener
UILWArena3V3PlayerInfoView.OnRemoveListener = OnRemoveListener
UILWArena3V3PlayerInfoView.RefreshWeaponInfo = RefreshWeaponInfo
UILWArena3V3PlayerInfoView.OnGetOtherPlayerWeaponInfo = OnGetOtherPlayerWeaponInfo
return UILWArena3V3PlayerInfoView
