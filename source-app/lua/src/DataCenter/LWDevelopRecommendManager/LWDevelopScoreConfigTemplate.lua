local LWDevelopScoreConfigTemplate = BaseClass("LWDevelopScoreConfigTemplate")
local Localization = CS.GameEntry.Localization

function LWDevelopScoreConfigTemplate:__init()
  self.id = 0
  self.module = ""
  self.icon = ""
  self.tips = ""
  self.gotoId = 0
  self.smallIcon = ""
  self.name = ""
end

function LWDevelopScoreConfigTemplate:__delete()
  self.id = nil
  self.module = nil
  self.icon = nil
  self.tips = nil
  self.gotoId = nil
  self.smallIcon = nil
  self.name = nil
end

function LWDevelopScoreConfigTemplate:InitData(row)
  if row == nil then
    return
  end
  self.id = row:getIntValue("id") or 0
  self.module = row:getValue("module") or ""
  self.icon = row:getValue("banner") or ""
  self.tips = row:getValue("tips") or ""
  self.gotoId = row:getValue("router_id") or 0
  self.smallIcon = row:getValue("icon") or ""
  self.name = row:getValue("name") or ""
end

function LWDevelopScoreConfigTemplate:GetIconPath()
  return self.icon
end

function LWDevelopScoreConfigTemplate:GetDescription()
  return self.tips
end

function LWDevelopScoreConfigTemplate:GetSmallIconPath()
  return self.smallIcon
end

function LWDevelopScoreConfigTemplate:OnGotoClick()
  if self.gotoId == 1 then
    self:OnGotoHeroLevel()
  elseif self.gotoId == 2 then
    self:OnGotoHeroStar()
  elseif self.gotoId == 3 then
    self:OnGotoHeroSkill()
  elseif self.gotoId == 4 then
    self:OnGotoHeroEquip()
  elseif self.gotoId == 5 then
    self:OnGotoHeroWeapon()
  elseif self.gotoId == 6 then
    self:OnGotoDecoration()
  elseif self.gotoId == 7 then
    self:OnGotoHonor()
  elseif self.gotoId == 8 then
    self:OnGotoSkillChips()
  elseif self.gotoId == 9 then
    self:OnGotoDroneEquip()
  elseif self.gotoId == 10 then
    self:OnGotoDroneLevel()
  elseif self.gotoId == 11 then
    self:OnGotoSoldier()
  elseif self.gotoId == 12 then
    self:OnGotoScience()
  elseif self.gotoId == 13 then
    self:OnGotoWorker()
  elseif self.gotoId == 14 then
    self:OnGotoBuilding()
  end
end

function LWDevelopScoreConfigTemplate:OnGotoHeroLevel()
  local heroDataList = self:GetHeroDataListOrderByPower()
  for i, v in ipairs(heroDataList) do
    local _, _, overFinalLevel, _ = DataCenter.HeroDataManager:GetHeroCanUpgradeInfos(v)
    if not overFinalLevel then
      local heroWindow = UIManager:GetInstance():GetWindow(UIWindowNames.UIHeroDetailPanel)
      if not heroWindow then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroDetailPanel, {anim = false}, v.uuid, {
          v.uuid
        })
      end
      return
    end
  end
end

function LWDevelopScoreConfigTemplate:OnGotoHeroStar()
  local heroDataList = self:GetHeroDataListOrderByPower()
  for i, v in ipairs(heroDataList) do
    if not v:IsReachMaxRank() then
      local heroWindow = UIManager:GetInstance():GetWindow(UIWindowNames.UIHeroDetailPanel)
      if not heroWindow then
        local arrowData = {
          arrowType = HeroDetailGuideArrowType.Rank,
          heroUid = v.uuid
        }
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroDetailPanel, {anim = false}, v.uuid, {
          v.uuid
        }, nil, arrowData)
      end
      return
    end
  end
end

function LWDevelopScoreConfigTemplate:OnGotoHeroSkill()
  local heroDataList = self:GetHeroDataListOrderByPower()
  for i, v in ipairs(heroDataList) do
    if not v:IsAllSkillReachMaxLevel() then
      local heroWindow = UIManager:GetInstance():GetWindow(UIWindowNames.UIHeroDetailPanel)
      if not heroWindow then
        local arrowData = {
          arrowType = HeroDetailGuideArrowType.Skill,
          heroUid = v.uuid
        }
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroDetailPanel, {anim = false}, v.uuid, {
          v.uuid
        }, nil, arrowData)
      end
      return
    end
  end
end

function LWDevelopScoreConfigTemplate:OnGotoHeroWeapon()
  local heroDataList = self:GetHeroDataListOrderByPower()
  for i, v in ipairs(heroDataList) do
    if v:IsUniqueWeaponOpen() then
      local heroWindow = UIManager:GetInstance():GetWindow(UIWindowNames.UIHeroDetailPanel)
      if not heroWindow then
        local arrowData = {
          arrowType = HeroDetailGuideArrowType.UniqueWeapon,
          heroUid = v.uuid
        }
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroDetailPanel, {anim = false}, v.uuid, {
          v.uuid
        }, nil, arrowData)
      end
      return
    end
  end
end

function LWDevelopScoreConfigTemplate:OnGotoHeroEquip()
  local heroDataList = self:GetHeroDataListOrderByPower()
  for i, v in ipairs(heroDataList) do
    local equipUids = v.equipUids
    if equipUids ~= nil then
      local equipListTmp = {}
      for _, v in pairs(equipUids) do
        local equipData = DataCenter.EquipDataManager:GetEquipByUuid(v)
        if equipData ~= nil and not equipData:IsMaxLevel() then
          table.insert(equipListTmp, equipData)
        end
      end
      table.sort(equipListTmp, function(a, b)
        return a.power > b.power
      end)
      if equipListTmp[1] ~= nil then
        local heroWindow = UIManager:GetInstance():GetWindow(UIWindowNames.UIHeroDetailPanel)
        if not heroWindow then
          UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroDetailPanel, {anim = false}, v.uuid, {
            v.uuid
          })
          local equipWindow = UIManager:GetInstance():GetWindow(UIWindowNames.UIHeroEquipDetailPanel)
          if not equipWindow then
            local equipUuids = DataCenter.EquipDataManager:GetAllWearingEquip({
              v.uuid
            })
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroEquipDetailPanel, {anim = false}, equipListTmp[1].uuid, nil, equipUuids, false)
          end
        end
        return
      end
    end
  end
  UIUtil.ShowTipsId("gear_recommend_router_fail_tip")
end

function LWDevelopScoreConfigTemplate:OnGotoDecoration()
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWDecorationBook)
end

function LWDevelopScoreConfigTemplate:OnGotoHonor()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWHeroHOF, {anim = true})
end

function LWDevelopScoreConfigTemplate:GetTacticalWeapon()
  local weapons = DataCenter.TacticalWeaponManager:GetTacticalWeaponInfos()
  if not table.IsNullOrEmpty(weapons) then
    for i, v in pairs(weapons) do
      return v
    end
  end
  return nil
end

function LWDevelopScoreConfigTemplate:OnGotoSkillChips()
  if self:GetTacticalWeapon() == nil then
    UIUtil.ShowTipsId("develop_guide_tip6")
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWTacticalWeapon, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    }, TacticalWeaponPageType.SkillChip)
  end
end

function LWDevelopScoreConfigTemplate:OnGotoDroneEquip()
  if self:GetTacticalWeapon() == nil then
    UIUtil.ShowTipsId("develop_guide_tip6")
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWTacticalWeapon, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    }, TacticalWeaponPageType.Equip)
  end
end

function LWDevelopScoreConfigTemplate:OnGotoDroneLevel()
  if self:GetTacticalWeapon() == nil then
    UIUtil.ShowTipsId("develop_guide_tip6")
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWTacticalWeapon, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    }, TacticalWeaponPageType.Basic)
  end
end

function LWDevelopScoreConfigTemplate:OnGotoSoldier()
  GoToUtil.GoBarracks()
end

function LWDevelopScoreConfigTemplate:OnGotoScience()
  GoToUtil.GotoScience()
end

function LWDevelopScoreConfigTemplate:OnGotoWorker()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorkerOverviewList, {anim = true})
end

function LWDevelopScoreConfigTemplate:OnGotoBuilding()
  local list = DataCenter.BuildManager:GetCanUpgradeBuildUuidListFilterd(true)
  if table.count(list) > 0 then
    table.sort(list, function(a, b)
      local retA = DataCenter.BuildManager:CheckBuildUpgradeResAndItem(a)
      local retB = DataCenter.BuildManager:CheckBuildUpgradeResAndItem(b)
      if retA.enough ~= retB.enough then
        return retA.enough and true or false
      end
      local buildDataA = DataCenter.BuildManager:GetBuildingDataByUuid(a)
      local buildDataB = DataCenter.BuildManager:GetBuildingDataByUuid(b)
      return buildDataA.level < buildDataB.level
    end)
    local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(list[1])
    GoToUtil.GotoCityByBuildUuid(buildData.uuid, WorldTileBtnType.City_Upgrade)
  else
    UIUtil.ShowTipsId("build_queue_tips_1")
  end
end

function LWDevelopScoreConfigTemplate:GetHeroDataListOrderByPower()
  local allHeroes = DataCenter.HeroDataManager:GetAllHeroList()
  local tmp = {}
  local i = 1
  for k, v in pairs(allHeroes) do
    tmp[i] = v
    i = i + 1
  end
  table.sort(tmp, function(heroA, heroB)
    if heroA.power ~= heroB.power then
      return heroA.power > heroB.power
    end
    if heroA.rarity ~= heroB.rarity then
      return heroA.rarity < heroB.rarity
    end
    if heroA.level ~= heroB.level then
      return heroA.level > heroB.level
    end
    if heroA.quality ~= heroB.quality then
      return heroA.quality > heroB.quality
    end
    return heroA.heroId < heroB.heroId
  end)
  return tmp
end

function LWDevelopScoreConfigTemplate:GetName()
  return self.name
end

function LWDevelopScoreConfigTemplate:GetSourceType()
  if self.module == "heroLevel" then
    return PowerOverviewPowerSourceType.heroLevelPower
  elseif self.module == "heroStar" then
    return PowerOverviewPowerSourceType.heroRankPower
  elseif self.module == "heroSkill" then
    return PowerOverviewPowerSourceType.heroSkillPower
  elseif self.module == "heroEquip" then
    return PowerOverviewPowerSourceType.heroEquipPower
  elseif self.module == "decoration" then
    return PowerOverviewPowerSourceType.heroDecoPower
  elseif self.module == "honor" then
    return PowerOverviewPowerSourceType.heroHonorPower
  elseif self.module == "skillChips" then
    return PowerOverviewPowerSourceType.weaponChipPower
  elseif self.module == "droneEquip" then
    return PowerOverviewPowerSourceType.weaponEquipPower
  elseif self.module == "droneLevel" then
    return PowerOverviewPowerSourceType.weaponLevelPower
  elseif self.module == "soldier" then
    return PowerOverviewPowerSourceType.armyPower
  elseif self.module == "science" then
    return PowerOverviewPowerSourceType.sciencePower
  elseif self.module == "worker" then
    return PowerOverviewPowerSourceType.buildingWorkerPower
  elseif self.module == "building" then
    return PowerOverviewPowerSourceType.buildingDecoPower
  end
end

return LWDevelopScoreConfigTemplate
