local MailScoutDevelopPage = BaseClass("MailScoutDevelopPage", UIBaseContainer)
local base = UIBaseContainer
local MailScoutScienceItem = require("UI.UILWMail.UILWMailMain.Component.MailScout.MailScoutScienceItem")
local UILWSquadEquipItem = require("UI.UILWSquadEquipPanel.Component.UILWSquadEquipItem")
local MailScoutDecoItem = require("UI.UILWMail.UILWMailMain.Component.MailScout.MailScoutDecoItem")
local MailScoutHonorItem = require("UI.UILWMail.UILWMailMain.Component.MailScout.MailScoutHonorItem")
local UILWTacticalWeaponItem = require("UI.UILWTacticalWeapon.Component.UILWTacticalWeaponItem")
local UIHeroSkillItem = require("UI.UILWHero.UIHeroDetailPanel.Component.UIHeroSkillItem")
local SkillChipItem = require("UI.UILWTacticalWeapon.Component.SkillChipPage.SkillChipItem")
local MailScoutReportConst = require("DataCenter.MailData.DataExtModule.MailScoutReportConst")
local Localization = CS.GameEntry.Localization

function MailScoutDevelopPage:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function MailScoutDevelopPage:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function MailScoutDevelopPage:DataDefine()
end

function MailScoutDevelopPage:DataDestroy()
end

function MailScoutDevelopPage:OnEnable()
  base.OnEnable(self)
end

function MailScoutDevelopPage:OnDisable()
  base.OnDisable(self)
end

function MailScoutDevelopPage:OnAddListener()
  base.OnAddListener(self)
end

function MailScoutDevelopPage:OnRemoveListener()
  base.OnRemoveListener(self)
end

function MailScoutDevelopPage:ComponentDefine()
  self.EquipSlider = self:AddComponent(UISlider, "OverView/OverContent/EquipSliderContent/EquipSlider1")
  self.EquipSliderText = self:AddComponent(UIText, "OverView/OverContent/EquipSliderContent/EquipSlider1/EquipSliderText1")
  self.EquipSliderContent = self:AddComponent(UIBaseContainer, "OverView/OverContent/EquipSliderContent")
  self.SciSlider = self:AddComponent(UISlider, "OverView/OverContent/SciSliderContent/SciSlider1")
  self.SciSliderText = self:AddComponent(UIText, "OverView/OverContent/SciSliderContent/SciSlider1/SciSliderText1")
  self.SciSliderContent = self:AddComponent(UIBaseContainer, "OverView/OverContent/SciSliderContent")
  self.DecoSlider = self:AddComponent(UISlider, "OverView/OverContent/DecoSliderContent/DecoSlider1")
  self.DecoSliderText = self:AddComponent(UIText, "OverView/OverContent/DecoSliderContent/DecoSlider1/DecoSliderText1")
  self.DecoSliderContent = self:AddComponent(UIBaseContainer, "OverView/OverContent/DecoSliderContent")
  self.SoldierSlider = self:AddComponent(UISlider, "OverView/OverContent/SoldierSliderContent/SoldierSlider1")
  self.SoldierSliderText = self:AddComponent(UIText, "OverView/OverContent/SoldierSliderContent/SoldierSlider1/SoldierSliderText1")
  self.SoldierSliderContent = self:AddComponent(UIBaseContainer, "OverView/OverContent/SoldierSliderContent")
  self.honorWallSlider = self:AddComponent(UISlider, "OverView/OverContent/HonorWallSliderContent/HonorWallSlider1")
  self.honorWallSliderText = self:AddComponent(UIText, "OverView/OverContent/HonorWallSliderContent/HonorWallSlider1/HonorWallText1")
  self.honorWallSliderContent = self:AddComponent(UIBaseContainer, "OverView/OverContent/HonorWallSliderContent")
  self.totalPower = self:AddComponent(UIText, "OverView/title/power_info/totalPower_txt")
  self.EquipView = self:AddComponent(UIBaseContainer, "EquipView")
  self.EquipPower = self:AddComponent(UIText, "EquipView/title/power_info/equipPower_txt")
  self.equipReqs = {}
  self.weaponContent = self:AddComponent(UIBaseContainer, "EquipView/WeaponContent")
  self.weapon = self:AddComponent(UIBaseContainer, "EquipView/WeaponContent/top/weapon")
  self.weaponReqs = {}
  self.weaponSkillReqs = {}
  self.weaponAddHp = self:AddComponent(UIText, "EquipView/WeaponContent/bottom/HP")
  self.weaponAddHp1Text = self:AddComponent(UIText, "EquipView/WeaponContent/bottom/HP/HPAdd1")
  self.weaponAddDef = self:AddComponent(UIText, "EquipView/WeaponContent/bottom/DEF")
  self.weaponAddDef1Text = self:AddComponent(UIText, "EquipView/WeaponContent/bottom/DEF/DEFAdd1")
  self.weaponAddAtk = self:AddComponent(UIText, "EquipView/WeaponContent/bottom/ATK")
  self.weaponAddAtk1Text = self:AddComponent(UIText, "EquipView/WeaponContent/bottom/ATK/ATKAdd1")
  self.skillChips = self:AddComponent(UIBaseContainer, "EquipView/WeaponContent/top/skillchips")
  self.twComponentContainers = {}
  for i = 1, 6 do
    local weaponItem = self:AddComponent(UIBaseContainer, "EquipView/WeaponContent/components/comp" .. i)
    table.insert(self.twComponentContainers, weaponItem)
  end
  self.twComponents = self:AddComponent(UIBaseContainer, "EquipView/WeaponContent/components")
  self.weaponSkill = self:AddComponent(UIBaseContainer, "EquipView/WeaponContent/top/skill")
  self.curChipSetIndex_txt = self:AddComponent(UIText, "EquipView/WeaponContent/top/skillchips/curSetIndex_txt")
  self.weaponChangeSet_btn = self:AddComponent(UIButton, "EquipView/WeaponContent/top/skillchips/change_btn")
  self.weaponChangeSet_btn:SetOnClick(function()
    local weapon = self.extData.battleWeapon
    local unlockedSets = weapon.unlockedSets
    if table.IsNullOrEmpty(unlockedSets) then
      return
    end
    for i = 1, #unlockedSets do
      if unlockedSets[i] == self.curChipSetIndex then
        local nextIndex = i + 1
        if nextIndex > #unlockedSets then
          nextIndex = 1
        end
        self:RefreshChips(unlockedSets[nextIndex])
        break
      end
    end
  end)
  self.chips_container = self:AddComponent(UIBaseContainer, "EquipView/WeaponContent/top/skillchips/chips_container")
  self.weapon_top = self:AddComponent(UIBaseContainer, "EquipView/WeaponContent/top")
  self.weapon_bottom = self:AddComponent(UIBaseContainer, "EquipView/WeaponContent/bottom")
  self.SciView = self:AddComponent(UIBaseContainer, "SciView")
  self.SciPower = self:AddComponent(UIText, "SciView/title/power_info/sciPower_txt")
  self.SciContent = self:AddComponent(UIBaseContainer, "SciView/sciContent")
  self.SciItemPrefab = self.transform:Find("SciView/sciContent/UILWScienceMainItem").gameObject
  self.SciItemPrefab:GameObjectCreatePool()
  self.SciItemPrefab:SetActive(false)
  self.DecoPower = self:AddComponent(UIText, "DecoView/title/power_info/decoPower_txt")
  self.DecoContent = self:AddComponent(UIBaseContainer, "DecoView/DecoContent")
  self.DecoView = self:AddComponent(UIBaseContainer, "DecoView")
  self.honorView = self.transform:Find("HonorView").gameObject
  self.honorPower1Text = self:AddComponent(UIText, "HonorView/title/power_info/honorPower_txt")
  self.honorReqs = {}
  self.honorContent = self:AddComponent(UIBaseContainer, "HonorView/HonorContent")
end

function MailScoutDevelopPage:ComponentDestroy()
  self:RemoveSciItems()
  self:RemoveSkillChipItems()
  self:RemoveEquipItems()
  self:RemoveDecoItems()
  self:RemoveHonorItems()
  self.SciItemPrefab = nil
end

function MailScoutDevelopPage:Refresh(mailExt)
  self.extData = mailExt:GetExtData()
  self.scoutLv = mailExt.scoutLv or 1
  self.disturbedScoutLv = mailExt.disturbedScoutLv or 1
  if mailExt then
    mailExt:ParseTacticalWeapon()
  end
  self:PrepareData()
  self:RefreshView()
end

function MailScoutDevelopPage:PrepareData()
  self.progress = self.extData.armyProcess
  self.army = self.extData.army
  self.target = self.army.target
end

function MailScoutDevelopPage:RefreshView()
  self:RefreshOverView()
  self:RefreshEquipView()
  self:RefreshSciView()
  self:RefreshDecoView()
  self:RefreshHonorView()
  local weapon = self.extData.battleWeapon
  if not weapon then
    return
  end
  local unlockedSets = weapon.unlockedSets
  local unlockChips = self.scoutLv >= ScoutLevel.TWSkillChip
  if unlockChips and not table.IsNullOrEmpty(unlockedSets) then
    local defaultChoose = unlockedSets[1]
    self:RefreshChips(defaultChoose)
    self.weaponChangeSet_btn:SetActive(1 < table.count(unlockedSets))
  else
    self.skillChips:SetActive(false)
  end
end

local Slider_Type = {
  Honor = 1,
  Deco = 2,
  Sci = 3,
  Equip = 4,
  Soldier = 5
}
local Slider_Config = {
  [Slider_Type.Honor] = {
    name = "honorWallSliderContent",
    slider = "honorWallSlider",
    text = "honorWallSliderText",
    scoutLevel = ScoutLevel.HonorWallPower
  },
  [Slider_Type.Deco] = {
    name = "DecoSliderContent",
    slider = "DecoSlider",
    text = "DecoSliderText",
    scoutLevel = ScoutLevel.DecoPower
  },
  [Slider_Type.Sci] = {
    name = "SciSliderContent",
    slider = "SciSlider",
    text = "SciSliderText",
    scoutLevel = ScoutLevel.SciencePower
  },
  [Slider_Type.Equip] = {
    name = "EquipSliderContent",
    slider = "EquipSlider",
    text = "EquipSliderText",
    scoutLevel = ScoutLevel.TacticalWeaponPower
  },
  [Slider_Type.Soldier] = {
    name = "SoldierSliderContent",
    slider = "SoldierSlider",
    text = "SoldierSliderText",
    scoutLevel = ScoutLevel.InCitySoldierCount
  }
}

function MailScoutDevelopPage:RefreshOverView()
  local maxPower = 0
  local totalPower = 0
  local soldierPower = self.target.soldierPower or 0
  local powerMap = {}
  local scoutLv = self.scoutLv
  local disturbedScoutLv = self.disturbedScoutLv
  powerMap[Slider_Type.Honor] = self.progress.honorPower
  powerMap[Slider_Type.Deco] = self.progress.decoPower
  powerMap[Slider_Type.Sci] = self.progress.sciencePower
  powerMap[Slider_Type.Equip] = self.progress.formationEquipPower
  powerMap[Slider_Type.Soldier] = soldierPower
  local isDistrubed = false
  for i = 1, #powerMap do
    if scoutLv < Slider_Config[i].scoutLevel then
      powerMap[i] = 0
    elseif disturbedScoutLv < Slider_Config[i].scoutLevel then
      isDistrubed = true
      powerMap[i] = 0
    end
    local power = powerMap[i]
    if maxPower < power then
      maxPower = power
    end
    totalPower = totalPower + power
  end
  if isDistrubed then
    self.totalPower:SetText(GameDialogDefine.QUESTION_MARK)
  else
    self.totalPower:SetText(string.GetFormattedStr(math.floor(totalPower)))
  end
  for i = 1, #Slider_Config do
    local config = Slider_Config[i]
    local content = self[config.name]
    if scoutLv < config.scoutLevel then
      content:SetActive(false)
    else
      content:SetActive(true)
      if disturbedScoutLv < config.scoutLevel then
        self[config.slider]:SetValue(0)
        self[config.text]:SetText(GameDialogDefine.QUESTION_MARK)
      else
        self[config.slider]:SetValue(powerMap[i] / maxPower)
        self[config.text]:SetText(string.GetFormattedStr(math.floor(powerMap[i])))
      end
    end
  end
end

function MailScoutDevelopPage:RefreshEquipView()
  self:RemoveEquipItems()
  local tacticalWeapon = self.extData.battleWeapon
  if self.scoutLv < ScoutLevel.TacticalWeaponPower then
    self.EquipView:SetActive(false)
    return
  else
    self.EquipView:SetActive(true)
    if self.disturbedScoutLv < ScoutLevel.TacticalWeaponPower then
      self.EquipPower:SetText(GameDialogDefine.QUESTION_MARK)
    else
      self.EquipPower:SetText(string.GetFormattedStr(math.floor(self.progress.formationEquipPower)))
    end
  end
  if not tacticalWeapon or self.scoutLv < ScoutLevel.TacticalWeaponLv then
    self.weaponContent:SetActive(false)
    return
  end
  self.weaponContent:SetActive(true)
  local equipData1 = {
    [1] = 1,
    [2] = 2,
    [3] = 3,
    [4] = 4,
    [5] = 5
  }
  local weaponEffects = {
    HeroEffectDefine.TacticalWeaponHp_Result,
    HeroEffectDefine.TacticalWeaponDef_Result,
    HeroEffectDefine.TacticalWeaponAtk_Result
  }
  local weaponEffectSideItem = {
    self.weaponAddHp1Text,
    self.weaponAddDef1Text,
    self.weaponAddAtk1Text
  }
  local disturbedScoutLv = self.disturbedScoutLv
  if tacticalWeapon and tacticalWeapon.id > 0 then
    self.weaponContent:SetActive(true)
    
    local function CreateEquipAndSkill(weaponInfo, weaponId, weaponLevel, weaponSkinId)
      local weaponItemReq = self:GameObjectInstantiateAsync(UIAssets.UILWTacticalWeaponItem, function(req)
        if IsNull(req.gameObject) then
          return
        end
        local item = req.gameObject
        item.name = "UILWTacticalWeaponItem1"
        item.transform:SetParent(self.weapon.transform)
        item.transform:Set_pivot(0.5, 0.5)
        item.transform:Set_localScale(0.9, 0.9, 0.9)
        item.transform:Set_localPosition(0, 0, 0)
        local obj = self.weapon:AddComponent(UILWTacticalWeaponItem, item.name)
        obj:SetConfigId(weaponId, weaponLevel, weaponSkinId)
        if disturbedScoutLv < ScoutLevel.TacticalWeaponLv then
          obj:SetLevelText(GameDialogDefine.QUESTION_MARK)
        end
      end)
      table.insert(self.weaponReqs, weaponItemReq)
      if weaponInfo.skillInfos and weaponInfo.skillInfos[1] then
        local skillArrIndex = -1
        for i, v in pairs(weaponInfo.skillInfos) do
          if skillArrIndex < 0 then
            skillArrIndex = i
          elseif v.skillId < weaponInfo.skillInfos[skillArrIndex].skillId then
            skillArrIndex = i
          end
        end
        local skillReq = self:GameObjectInstantiateAsync(UIAssets.UIHeroSkillItem, function(req)
          if IsNull(req.gameObject) then
            return
          end
          local item = req.gameObject
          item.name = "UIHeroSkillItem1"
          item.transform:SetParent(self.weaponSkill.transform)
          item.transform:Set_pivot(0.5, 0.5)
          item.transform:Set_sizeDelta(93.6, 121.3)
          item.transform:Set_localScale(1, 1, 1)
          item.transform:Set_localPosition(0, -8, 0)
          local obj = self.weaponSkill:AddComponent(UIHeroSkillItem, item.name)
          obj:SetTemplateData(weaponInfo.skillInfos[skillArrIndex].skillId, weaponInfo.skillInfos[skillArrIndex].skillLv, nil, {
            showSkillName = false,
            showSkillLevel = false,
            showLock = false,
            showRedPoint = false,
            unlockLevel = false,
            showStar = true
          })
        end)
        table.insert(self.weaponSkillReqs, skillReq)
      end
    end
    
    if tacticalWeapon then
      local weaponInfo = tacticalWeapon.weaponInfo
      local weaponId = tacticalWeapon.id
      local weaponLevel = tacticalWeapon.level
      local weaponSkinId = tacticalWeapon.skinId
      CreateEquipAndSkill(weaponInfo, weaponId, weaponLevel, weaponSkinId, true)
    end
    for i = 1, #weaponEffects do
      if disturbedScoutLv < ScoutLevel.TacticalWeaponLv then
        weaponEffectSideItem[i]:SetText(GameDialogDefine.QUESTION_MARK)
      else
        local realEffect = tacticalWeapon.effect[weaponEffects[i]]
        if realEffect == nil then
          weaponEffectSideItem[i]:SetText("-")
        else
          weaponEffectSideItem[i]:SetText(HeroUtils.GetFormattedPropertyValue(weaponEffects[i], realEffect))
        end
      end
    end
  else
    self.weaponContent:SetActive(false)
    return
  end
  local unlockWeaponComponents = self.scoutLv >= ScoutLevel.TWComponentLv
  if unlockWeaponComponents then
    self.twComponents:SetActive(true)
    for _, v in pairs(self.progress.equipId) do
      local equipData = CommonEquipInfo.New()
      equipData:UpdateInfo({cfgId = v})
      equipData1[equipData:GetConfigSlot()] = equipData
    end
    local isDistrubed = self.disturbedScoutLv < ScoutLevel.TWComponentLv
    if isDistrubed then
      for i = 1, 6 do
        self.equipReqs[i] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(req)
          if IsNull(req.gameObject) then
            return
          end
          local item = req.gameObject
          item.name = "UILWSquadEquipItem" .. i
          local transform = item.transform
          local parent = self.twComponentContainers[i]
          transform:SetParent(parent.transform)
          transform:Set_localScale(0.8, 0.8, 0.8)
          transform:Set_localPosition(0, 0, 0)
          transform:Set_pivot(0.5, 0.5)
          local fullPath = string.format("comp%d/%s", i, item.name)
          local obj = self.twComponents:AddComponent(UICommonResItem, fullPath)
          obj:ReInit(MailScoutReportConst.questionmark_config)
        end)
      end
    else
      for i = 1, 6 do
        self.equipReqs[i] = self:GameObjectInstantiateAsync(UIAssets.UILWSquadEquipItem, function(req)
          if IsNull(req.gameObject) then
            return
          end
          local item = req.gameObject
          item.name = "UILWSquadEquipItem" .. i
          local parent = self.twComponentContainers[i]
          item.transform:SetParent(parent.transform)
          item.transform:Set_localScale(0.64, 0.64, 0.64)
          item.transform:Set_localPosition(0, 0, 0)
          local fullPath = string.format("comp%d/%s", i, item.name)
          local obj = self.twComponents:AddComponent(UILWSquadEquipItem, fullPath)
          obj:SetDataForMail(equipData1[i])
        end)
      end
    end
  else
    self.twComponents:SetActive(false)
  end
end

function MailScoutDevelopPage:RefreshChips(index)
  if self.curChipSetIndex and self.curChipSetIndex == index then
    return
  end
  self.curChipSetIndex = index
  self:RemoveSkillChipItems()
  self.curChipSetIndex_txt:SetText(index)
  local tacticalWeapon = self.extData.battleWeapon
  local skillChips = tacticalWeapon.skillchipSets[index]
  if not self.skillChipReqs then
    self.skillChipReqs = {}
  end
  local skillChipIsDisturbed = self.disturbedScoutLv < ScoutLevel.TWSkillChip
  local isShowChipLv = self.scoutLv >= ScoutLevel.TWSkillChipLv
  local isChipLvDisturbed = self.disturbedScoutLv < ScoutLevel.TWSkillChipLv
  for i = 1, 4 do
    local container = self.chips_container
    local skillChipInfo
    skillChipInfo = skillChips[i]
    local req
    if skillChipIsDisturbed then
      req = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(req)
        if IsNull(req.gameObject) then
          return
        end
        local item = req.gameObject
        item.name = string.format("UILWTWSkillChipItem%d", i)
        local transform = item.transform
        transform:SetParent(container.transform)
        transform:Set_sizeDelta(78, 78)
        transform:Set_localScale(0.65, 0.65, 0.65)
        transform:Set_pivot(0.5, 0.5)
        local obj = container:AddComponent(UICommonResItem, item.name)
        obj:ReInit(MailScoutReportConst.questionmark_config)
      end)
      table.insert(self.skillChipReqs, req)
    else
      req = self:GameObjectInstantiateAsync(UIAssets.UILWTWSkillChipItem, function(req)
        if IsNull(req.gameObject) then
          return
        end
        local item = req.gameObject
        item.name = string.format("UILWTWSkillChipItem%d", i)
        item.transform:SetParent(container.transform)
        item.transform:Set_sizeDelta(78, 78)
        item.transform:Set_localScale(0.5, 0.5, 0.5)
        local obj = container:AddComponent(SkillChipItem, item.name)
        local index = 4 < i and i - 4 or i
        if skillChipInfo then
          obj:SetTemplate(skillChipInfo.cfgId, skillChipInfo.lv, skillChipInfo.star)
          if not isShowChipLv then
            obj:SetLevelTextStr("")
          elseif isChipLvDisturbed then
            obj:SetLevelTextStr(GameDialogDefine.QUESTION_MARK)
          end
        else
          obj:SetSlot(index)
        end
      end)
    end
    if req then
      table.insert(self.skillChipReqs, req)
    end
  end
end

function MailScoutDevelopPage:RemoveEquipItems()
  self.twComponents:RemoveComponents(UILWSquadEquipItem)
  self.twComponents:RemoveComponents(UICommonResItem)
  if self.equipReqs then
    for _, v in pairs(self.equipReqs) do
      v:Destroy()
    end
    self.equipReqs = {}
  end
  self.weapon:RemoveComponents(UILWTacticalWeaponItem)
  self.weaponSkill:RemoveComponents(UIHeroSkillItem)
  if self.weaponReqs then
    for _, v in pairs(self.weaponReqs) do
      v:Destroy()
    end
    self.weaponReqs = {}
  end
  if self.weaponSkillReqs then
    for _, v in pairs(self.weaponSkillReqs) do
      v:Destroy()
    end
    self.weaponSkillReqs = {}
  end
end

function MailScoutDevelopPage:RemoveSkillChipItems()
  self.chips_container:RemoveComponents(SkillChipItem)
  self.chips_container:RemoveComponents(UICommonResItem)
  if self.skillChipReqs then
    for _, v in pairs(self.skillChipReqs) do
      v:Destroy()
    end
  end
  self.skillChipReqs = {}
end

function MailScoutDevelopPage:RefreshSciView()
  self:RemoveSciItems()
  if self.scoutLv < ScoutLevel.SciencePower then
    self.SciView:SetActive(false)
    return
  else
    self.SciView:SetActive(true)
    if self.disturbedScoutLv >= ScoutLevel.SciencePower then
      self.SciPower:SetText(string.GetFormattedStr(math.floor(self.progress.sciencePower)))
    else
      self.SciPower:SetText(GameDialogDefine.QUESTION_MARK)
    end
  end
  if self.scoutLv < ScoutLevel.ScienceDetail then
    self.SciContent:SetActive(false)
    return
  end
  self.SciContent:SetActive(true)
  local science1 = self.progress.science
  local isDisturbed = self.disturbedScoutLv < ScoutLevel.ScienceDetail
  for i = 1, #science1 do
    local item = self.SciItemPrefab:GameObjectSpawn(self.SciContent.transform)
    item.name = "UILWScienceMainItem" .. i
    item.transform:SetParent(self.SciContent.transform)
    item.transform:Set_localScale(1, 1, 1)
    item.transform:Set_pivot(CommonUtil.IsArabicAutoMirrorOpen() and 1 or 0, 1)
    item.transform:Set_anchorMin(CommonUtil.IsArabicAutoMirrorOpen() and 1 or 0, 1)
    item.transform:Set_anchorMax(CommonUtil.IsArabicAutoMirrorOpen() and 1 or 0, 1)
    local obj = self.SciContent:AddComponent(MailScoutScienceItem, item.name)
    obj:SetDataByCfgId(science1[i].scienceTabId, science1[i].progress * 0.01, isDisturbed)
  end
end

function MailScoutDevelopPage:RemoveSciItems()
  self.SciContent:RemoveComponents(MailScoutScienceItem)
  self.SciItemPrefab.gameObject:GameObjectRecycleAll()
end

function MailScoutDevelopPage:RefreshDecoView()
  self:RemoveDecoItems()
  local unlockDeco = self.scoutLv >= ScoutLevel.DecoPower
  if not unlockDeco then
    self.DecoView:SetActive(false)
    return
  else
    self.DecoView:SetActive(true)
  end
  local deco1 = {
    [1] = {
      decoQualityId = 5,
      totalCount = 0,
      totalLv = 0
    },
    [2] = {
      decoQualityId = 4,
      totalCount = 0,
      totalLv = 0
    },
    [3] = {
      decoQualityId = 3,
      totalCount = 0,
      totalLv = 0
    }
  }
  self.progress.deco = self.progress.deco or {}
  for _, v in pairs(self.progress.deco) do
    deco1[6 - v.decoQualityId] = v
  end
  local scoutLv = self.scoutLv
  local disturbedScoutLv = self.disturbedScoutLv
  if scoutLv >= ScoutLevel.DecoDetail then
    for i = 1, 3 do
      self.decoReqs[i] = self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/LWMail/MailScout/DecoItem.prefab", function(req)
        if IsNull(req.gameObject) then
          return
        end
        local item = req.gameObject
        item.name = "MailDecoItem" .. i
        item.transform:SetParent(self.DecoContent.transform)
        item.transform:Set_localScale(1, 1, 1)
        local obj = self.DecoContent:AddComponent(MailScoutDecoItem, item.name)
        obj:SetData(deco1[i], disturbedScoutLv < ScoutLevel.DecoDetail)
      end)
    end
  end
  if disturbedScoutLv >= ScoutLevel.DecoPower then
    self.DecoPower:SetText(string.GetFormattedStr(math.floor(self.progress.decoPower)))
  else
    self.DecoPower:SetText(GameDialogDefine.QUESTION_MARK)
  end
end

function MailScoutDevelopPage:RemoveDecoItems()
  self.DecoContent:RemoveComponents(MailScoutDecoItem)
  if self.decoReqs then
    for _, v in pairs(self.decoReqs) do
      self:GameObjectDestroy(v)
    end
  end
  self.decoReqs = {}
end

function MailScoutDevelopPage:RefreshHonorView()
  self:RemoveHonorItems()
  local honorWall1 = self.progress.honorWall or {}
  local hideHonor = self.scoutLv < ScoutLevel.HonorWallDetail
  if hideHonor then
    self.honorView:SetActive(false)
  else
    self.honorView:SetActive(true)
    local scoutLv = self.scoutLv
    local disturbedScoutLv = self.disturbedScoutLv
    if scoutLv >= ScoutLevel.HonorWallDetail then
      for i = 1, 3 do
        self.honorReqs[i] = self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/LWMail/MailScout/MailScoutHonorItem.prefab", function(req)
          if IsNull(req.gameObject) then
            return
          end
          local item = req.gameObject
          item.name = "HonorItem" .. i
          item.transform:SetParent(self.honorContent.transform)
          item.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
          local obj = self.honorContent:AddComponent(MailScoutHonorItem, item.name)
          obj:SetData(i, honorWall1[i], disturbedScoutLv < ScoutLevel.HonorWallDetail)
        end)
      end
    end
    if disturbedScoutLv >= ScoutLevel.HonorWallPower then
      self.honorPower1Text:SetText(string.GetFormattedStr(math.floor(self.progress.honorPower)))
    else
      self.honorPower1Text:SetText(GameDialogDefine.QUESTION_MARK)
    end
  end
end

function MailScoutDevelopPage:RemoveHonorItems()
  self.honorContent:RemoveComponents(MailScoutHonorItem)
  if self.honorReqs then
    for _, v in pairs(self.honorReqs) do
      self.honorContent:GameObjectDestroy(v)
    end
    self.honorReqs = {}
  end
end

return MailScoutDevelopPage
