local DetectRewardFormationItem = BaseClass("DetectRewardFormationItem", UIBaseContainer)
local base = UIBaseContainer
local UIHeroCellSmall = require("UI.UIHero2.Common.UIHeroCellSmall")
local FormationDetailGroupItem = require("UI.UILWMail.UILWMailMain.Component.MailScout.FormationDetailGroupItem")

function DetectRewardFormationItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ChangeState(false)
end

function DetectRewardFormationItem:OnDestroy()
  if self.heroCellReqs then
    self:RemoveComponents(UIHeroCellSmall)
    for _, req in pairs(self.heroCellReqs) do
      self:GameObjectDestroy(req)
    end
    self.heroCellReqs = nil
    self.heroCells = nil
  end
  self:HideDetailGroups()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function DetectRewardFormationItem:ComponentDefine()
  self.title_txt = self:AddComponent(UIText, "formationHead/squadNumber/title_txt")
  self.heroCellContainers = {}
  self.heroSlots = {}
  for i = 1, 6 do
    local path = string.format("formationHead/ScrollRect/Viewport/heros/Hero%s", i)
    local heroCell = self:AddComponent(UIBaseContainer, path)
    self.heroCellContainers[i] = heroCell
    local heroSlot = self:AddComponent(UIImage, string.format("formationHead/ScrollRect/Viewport/heros/Hero%s/slot%s", i, i))
    self.heroSlots[i] = heroSlot
  end
  self.detail_btn = self:AddComponent(UIButton, "formationHead/detail_container/detail_btn")
  self.formationDetail = self:AddComponent(UIBaseContainer, "formationDetail")
  self.detail_btn:SetOnClick(function()
    self:ChangeState(not self.showDetail)
  end)
  self.power_info = self:AddComponent(UIBaseContainer, "formationHead/squadNumber/power_info")
  self.power_txt = self:AddComponent(UIText, "formationHead/squadNumber/power_info/power_txt")
  self.squad_number = self:AddComponent(UIBaseContainer, "formationHead/squadNumber")
end

function DetectRewardFormationItem:ComponentDestroy()
  self.title_txt = nil
  self.heroCells = nil
  self.heroCellReqs = nil
  self.heroCellContainers = nil
  self.formationDetail = nil
  self.detail_btn = nil
  self.power_info = nil
  self.power_txt = nil
end

function DetectRewardFormationItem:DataDefine()
  self.heroCells = {}
  self.heroCellReqs = {}
  self.showDetail = nil
  self.groupLinesReqs = {}
end

function DetectRewardFormationItem:DataDestroy()
  self.formation = nil
end

function DetectRewardFormationItem:OnEnable()
  base.OnEnable(self)
end

function DetectRewardFormationItem:OnDisable()
  base.OnDisable(self)
end

function DetectRewardFormationItem:OnAddListener()
  base.OnAddListener(self)
end

function DetectRewardFormationItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

local function GetFormationEquipPower(self)
  if not self.formation then
    return 0
  end
  local totalPower = 0
  for i = 1, #self.formation.hero do
    local heroData = self.formation.hero[i]
    totalPower = totalPower + (heroData.equipPower or 0)
  end
  return totalPower
end

local function GetFormationSkillPower(self)
  if not self.formation then
    return 0
  end
  local totalPower = 0
  for i = 1, #self.formation.hero do
    local heroData = self.formation.hero[i]
    totalPower = totalPower + (heroData.skillPower or 0)
  end
  return totalPower
end

local function GetUniqueWepaonPower(self)
  if not self.formation then
    return 0
  end
  local totalPower = 0
  for i = 1, #self.formation.hero do
    local heroData = self.formation.hero[i]
    totalPower = totalPower + (heroData.weaponPower or 0)
  end
  return totalPower
end

local function IsFormationEquipDisturbed(self)
  if not self.formation then
    return false
  end
  if self.disturbedScoutLv < ScoutLevel.HeroEquip then
    return true
  end
  return false
end

local function IsFormationSkillDisturbed(self)
  if not self.formation then
    return false
  end
  if self.disturbedScoutLv < ScoutLevel.HeroSkill then
    return true
  end
  return false
end

local function IsUniqueWepaonDisturbed(self)
  if not self.formation then
    return false
  end
  if self.disturbedScoutLv < ScoutLevel.HeroUniqueWeaponLv then
    return true
  end
  return false
end

local function CanShowFormationEquip(self)
  if self.scoutLv < ScoutLevel.HeroEquip then
    return false
  end
  return true
end

local function CanShowFormationSkill(self)
  if self.scoutLv < ScoutLevel.HeroSkill then
    return false
  end
  return true
end

local function CanShowUniqueWepaon(self)
  if self.disturbedScoutLv < ScoutLevel.HeroUniqueWeaponLv then
    return false
  end
  return true
end

local GROUP_TYPES = {
  [1] = {
    name = "scout_report_panel_name_4",
    icon = "Assets/Main/Sprites/ItemIcons/icon_510100.png",
    getPowerFunc = GetFormationEquipPower,
    isDisturbedFunc = IsFormationEquipDisturbed,
    canShowFunc = CanShowFormationEquip
  },
  [2] = {
    name = "scout_report_panel_name_5",
    icon = "Assets/Main/Sprites/SkillIcons/skill_icon9.png",
    getPowerFunc = GetFormationSkillPower,
    isDisturbedFunc = IsFormationSkillDisturbed,
    canShowFunc = CanShowFormationSkill
  },
  [3] = {
    name = "scout_report_panel_name_6",
    icon = "Assets/Main/Sprites/HeroIconsSmall/hero_icon_Katyusha_zw.png",
    getPowerFunc = GetUniqueWepaonPower,
    isDisturbedFunc = IsUniqueWepaonDisturbed,
    canShowFunc = CanShowUniqueWepaon
  }
}

function DetectRewardFormationItem:SetData(data, version, scoutLv, disturbedScoutLv)
  local formation
  self.scoutLv = scoutLv or 1
  self.disturbedScoutLv = disturbedScoutLv or 1
  if data.user then
    formation = data.formation
    self.formation = formation
    local user = data.user
    local name = UIUtil.FormatAllianceAndName(user.abbr, user.name)
    self.squad_number:SetActive(true)
    self.title_txt:SetText(name)
    if 0 < version then
      if self.scoutLv >= ScoutLevel.SquadPower then
        self.power_info:SetActive(true)
        if self.disturbedScoutLv >= ScoutLevel.SquadPower then
          self.power_txt:SetText(string.GetFormattedStr2(formation.power or 0))
        else
          self.power_txt:SetText(GameDialogDefine.QUESTION_MARK)
        end
      else
        self.power_info:SetActive(false)
      end
    end
    self.detail_btn:SetActive(false)
  else
    formation = data
    self.formation = formation
    if 0 < version then
      self.squad_number:SetActive(true)
      if data.index and 0 < data.index then
        self.title_txt:SetLocalText("scout_report_panel_name_10", data.index)
      else
        self.title_txt:SetLocalText("season_s4_march_info01")
      end
    else
      self.squad_number:SetActive(false)
    end
    if 0 < version then
      if self.scoutLv >= ScoutLevel.SquadPower then
        self.power_info:SetActive(true)
        if self.disturbedScoutLv >= ScoutLevel.SquadPower then
          self.power_txt:SetText(string.GetFormattedStr2(formation.power or 0))
        else
          self.power_txt:SetText(GameDialogDefine.QUESTION_MARK)
        end
        self.detail_btn:SetActive(self.scoutLv >= ScoutLevel.HeroEquip)
      else
        self.power_info:SetActive(false)
        self.detail_btn:SetActive(false)
      end
    else
      self.power_info:SetActive(false)
      self.detail_btn:SetActive(false)
    end
  end
  self.heroMaps = {}
  for _, heroData in pairs(formation.hero) do
    self.heroMaps[heroData.heroIndex.value] = heroData
  end
  
  local function SetHeroData(item, heroData)
    if not item then
      return
    end
    if not heroData then
      item:SetActive(false)
      return
    end
    item:SetActive(true)
    local isDominator = heroData.dominator ~= nil
    if isDominator then
      item:InitWithConfigId(heroData.dominator.dominatorId, nil, nil, heroData.dominator.rankLv)
    else
      local rank = 0
      if heroData.heroRankLevel and heroData.heroRankLevel.value then
        rank = heroData.heroRankLevel.value
      end
      local weaponLevel = 0
      if heroData.weaponLevel and heroData.weaponLevel.value then
        weaponLevel = heroData.weaponLevel.value
      end
      local awakenLv = 0
      if heroData.awakenLv and heroData.awakenLv.value then
        awakenLv = heroData.awakenLv.value
      end
      local heroSkinId = 0
      if heroData.heroSkinId and heroData.heroSkinId.value then
        heroSkinId = heroData.heroSkinId.value
      end
      item:InitWithConfigId(heroData.heroId.value, nil, heroData.heroLevel.value, rank, weaponLevel, awakenLv, heroSkinId)
    end
  end
  
  local function SetHeroCell(i, isDominator)
    local heroData = self.heroMaps[i]
    if heroData == nil and isDominator then
      self.heroCellContainers[i]:SetActive(false)
    else
      self.heroCellContainers[i]:SetActive(true)
      if self.heroCells[i] then
        SetHeroData(self.heroCells[i], self.heroMaps[i])
      elseif self.heroMaps[i] and not self.heroCellReqs[i] then
        local req = self:GameObjectInstantiateAsync(UIAssets.UIHeroCellSmall, function(req)
          local obj = req.gameObject
          if IsNull(obj) then
            return
          end
          local container = self.heroCellContainers[i]
          if not IsNull(container) then
            obj.transform:SetParent(container.transform)
            obj.transform.localScale = Vector3.one
            obj.transform:Set_pivot(0.5, 0.5)
            obj.transform.localPosition = Vector3.zero
            local name = string.format("HeroCell%s", i)
            obj.name = name
            local heroCell = self:AddComponent(UIHeroCellSmall, string.format("formationHead/ScrollRect/Viewport/heros/Hero%s/%s", i, name))
            SetHeroData(heroCell, self.heroMaps[i])
            self.heroCells[i] = heroCell
          end
        end)
        self.heroCellReqs[i] = req
      end
      if self.heroMaps[i] then
        self.heroSlots[i]:SetEnable(false)
      else
        self.heroSlots[i]:SetEnable(true)
      end
    end
  end
  
  for i = 1, 6 do
    local isDominator = i == 6
    SetHeroCell(i, isDominator)
  end
end

function DetectRewardFormationItem:ChangeState(state)
  self.showDetail = state
  self.formationDetail:SetActive(self.showDetail)
  if self.showDetail then
    self.detail_btn:SetLocalScaleXYZ(1, -1, 1)
    self:ShowDetailGroups()
  else
    self.detail_btn:SetLocalScaleXYZ(1, 1, 1)
    self:HideDetailGroups()
  end
end

function DetectRewardFormationItem:ShowDetailGroups()
  self.formationDetail:SetActive(true)
  for i = 1, #GROUP_TYPES do
    local groupType = GROUP_TYPES[i]
    local type_name = groupType.name
    local icon = groupType.icon
    local canShow = groupType.canShowFunc(self)
    if canShow then
      local power = groupType.getPowerFunc(self)
      local isDisturbed = groupType.isDisturbedFunc(self)
      if isDisturbed or not (power <= 0) then
        local req = self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/LWMail/MailScout/FormationGroupItem.prefab", function(req)
          local obj = req.gameObject
          if IsNull(obj) then
            return
          end
          local container = self.formationDetail
          obj.transform:SetParent(container.transform)
          obj.transform.localScale = Vector3.one
          obj.transform:Set_pivot(0.5, 0.5)
          obj.transform.localPosition = Vector3.zero
          local name = string.format("GroupLine%s", i)
          obj.name = name
          local groupLine = container:AddComponent(FormationDetailGroupItem, name)
          groupLine:SetData(type_name, icon, power, self.formation, i, isDisturbed)
        end)
        self.groupLinesReqs[#self.groupLinesReqs + 1] = req
      end
    end
  end
end

function DetectRewardFormationItem:HideDetailGroups()
  self.formationDetail:SetActive(false)
  self:DestroyDetailLines()
end

function DetectRewardFormationItem:DestroyDetailLines()
  if #self.groupLinesReqs > 0 then
    self.formationDetail:RemoveComponents(FormationDetailGroupItem)
    for _, req in pairs(self.groupLinesReqs) do
      self:GameObjectDestroy(req)
    end
    self.groupLinesReqs = {}
  end
end

return DetectRewardFormationItem
