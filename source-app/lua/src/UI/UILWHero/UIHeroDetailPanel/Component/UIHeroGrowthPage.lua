local UIHeroGrowthPage = BaseClass("UIHeroGrowthPage", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local Time = _ENV.Time
local UIEquipItem = require("UI.UILWHero.UIHeroEquipPanel.Component.UIEquipItem")
local UIHeroPropertyDetailTipView = require("UI.UILWHero.UIHeroPropertyDetailTip.View.UIHeroPropertyDetailTipView")
local HeroSimpleModelViewer = require("UI.UILWHero.UIHeroListPanel.Component.HeroSimpleModelViewer")
local UIHeroPropertyChangeItem = require("UI.UILWHero.UIHeroDetailPanel.Component.UIHeroPropertyChangeItem")
local UIHeroPowerChangeItem = require("UI.UILWHero.UIHeroDetailPanel.Component.UIHeroPowerChangeItem")
local SeasonCallbackInfo = require("UI.LWSeason.LWSeasonMain.Component.SeasonCallback.SeasonCallbackInfo")
local UILWArmedUpgradeInfoContentView = require("UI.UILWArmedUpgrade.WarningBubble.UILWArmedUpgradeInfoContentView")
local ResourceManager = CS.GameEntry.Resource
local quickEquipBtnPath = "CenterHeroInfo/EquipDetailPage/QuickEquipBtn"
local quickEquipBtnTextPath = "CenterHeroInfo/EquipDetailPage/QuickEquipBtn/QuickEquipText"
local quickEquipBtnRedPointPath = "CenterHeroInfo/EquipDetailPage/QuickEquipBtn/QuickEquipBtnRedPoint"
local propertyDetailBtnPath = "RightTopInfo/PropertyDetailInfoBtn"
local heroSpineContainerPath = "RightTopInfo/HeroIcon/HeroIconMask/HeroSpineContainer"
local heroQualityIconPath = "RightTopInfo/HeroQualityIcon"
local rightTopHeroQualityBgPath = "RightTopInfo/RightTopQualityBg"
local heroNameTextPath = "RightTopInfo/HeroNameText"
local heroNickNameTextPath = "RightTopInfo/HeroNickNameText"
local heroTypeIconPath = "RightTopInfo/HeroTypeIcon"
local equipAddHpTextPath = "CenterHeroInfo/HeroHpInfo/HpInfoNumber/EquipAddHpText"
local equipAddAtkTextPath = "CenterHeroInfo/HeroAtkInfo/AtkInfoNumber/EquipAddAtkText"
local equipAddDefTextPath = "CenterHeroInfo/HeroDefInfo/DefInfoNumber/EquipAddDefText"
local atkTitleTextPath = "CenterHeroInfo/HeroAtkInfo/AtkInfoTitleText"
local hpTitleTextPath = "CenterHeroInfo/HeroHpInfo/HpInfoTitleText"
local defTitleTextPath = "CenterHeroInfo/HeroDefInfo/DefInfoTitleText"
local scTitleTextPath = "CenterHeroInfo/HeroSdCapacityInfo/SCInfoTitleText"
local costResource1Path = "CenterBottomInfo/HeroPropertyInfo/HeroUpgradeContainer/CostGroup/CostResource1"
local costResource1IconPath = "CenterBottomInfo/HeroPropertyInfo/HeroUpgradeContainer/CostGroup/CostResource1/CostResource1Icon"
local costResource1NumTextPath = "CenterBottomInfo/HeroPropertyInfo/HeroUpgradeContainer/CostGroup/CostResource1/CostResource1Text"
local costResource2Path = "CenterBottomInfo/HeroPropertyInfo/HeroUpgradeContainer/CostGroup/CostResource2"
local costResource2IconPath = "CenterBottomInfo/HeroPropertyInfo/HeroUpgradeContainer/CostGroup/CostResource2/CostResource2Icon"
local costResource2NumTextPath = "CenterBottomInfo/HeroPropertyInfo/HeroUpgradeContainer/CostGroup/CostResource2/CostResource2Text"
local costResource3Path = "CenterBottomInfo/HeroPropertyInfo/HeroUpgradeContainer/CostGroup/CostResource3"
local costResource3IconPath = "CenterBottomInfo/HeroPropertyInfo/HeroUpgradeContainer/CostGroup/CostResource3/CostResource3Icon"
local costResource3NumTextPath = "CenterBottomInfo/HeroPropertyInfo/HeroUpgradeContainer/CostGroup/CostResource3/CostResource3Text"
local powerBtnPath = "RightTopInfo/PowerInfo"
local PowerTextPath = "RightTopInfo/PowerInfo/PowerNumberText"
local UISeasonCallbackInfoPath = "RightTopInfo/PowerInfo/UISeasonCallbackInfo"
local heroLevelTextPath = "CenterHeroInfo/HeroLevelInfo/HeroLevelText"
local atkNumberTextPath = "CenterHeroInfo/HeroAtkInfo/AtkInfoNumber/CurAtkText"
local hpNumberTextPath = "CenterHeroInfo/HeroHpInfo/HpInfoNumber/CurHpText"
local defNumberTextPath = "CenterHeroInfo/HeroDefInfo/DefInfoNumber/CurDefText"
local sdCapacityNumberTextPath = "CenterHeroInfo/HeroSdCapacityInfo/SCInfoNumber/CurSCText"
local atkInfoBtnPath = "CenterHeroInfo/HeroAtkInfo"
local hpInfoBtnPath = "CenterHeroInfo/HeroHpInfo"
local defInfoBtnPath = "CenterHeroInfo/HeroDefInfo"
local scInfoBtnPath = "CenterHeroInfo/HeroSdCapacityInfo"
local upgradeBtnPath = "CenterBottomInfo/HeroPropertyInfo/HeroUpgradeContainer/UpgradeBtn"
local upgradeBtnTextPath = "CenterBottomInfo/HeroPropertyInfo/HeroUpgradeContainer/UpgradeBtn/UpgradeBtnText"
local upgradeBtnRedPointPath = "CenterBottomInfo/HeroPropertyInfo/HeroUpgradeContainer/UpgradeBtn/UpgradeBtnRedPoint"
local upgradeBtnUpdateLevelPath = "CenterBottomInfo/HeroPropertyInfo/HeroUpgradeContainer/UpgradeBtn/UpLevel"
local upgradeContainerPath = "CenterBottomInfo/HeroPropertyInfo/HeroUpgradeContainer"
local templateHeroContainerPath = "CenterBottomInfo/HeroPropertyInfo/TemplateHeroContainer"
local templateHeroGotoBtnPath = "CenterBottomInfo/HeroPropertyInfo/TemplateHeroContainer/TemplateHeroGotoBtn"
local templateHeroGotoBtnTextPath = "CenterBottomInfo/HeroPropertyInfo/TemplateHeroContainer/TemplateHeroGotoBtn/TemplateHeroGotoBtnText"
local templateHeroTextPath = "CenterBottomInfo/HeroPropertyInfo/TemplateHeroContainer/TemplateHeroText"
local costPath = "CenterBottomInfo/HeroPropertyInfo/HeroUpgradeContainer/CostGroup"
local costExpPath = "CenterBottomInfo/HeroPropertyInfo/HeroUpgradeContainer/CostGroup/CostExp"
local costExpIconPath = "CenterBottomInfo/HeroPropertyInfo/HeroUpgradeContainer/CostGroup/CostExp/CostExpIcon"
local costExpTextPath = "CenterBottomInfo/HeroPropertyInfo/HeroUpgradeContainer/CostGroup/CostExp/CostExpText"
local upgradeConditionPath = "CenterBottomInfo/HeroPropertyInfo/HeroUpgradeContainer/UpgradeCondition"
local upgradeConditionIconPath = "CenterBottomInfo/HeroPropertyInfo/HeroUpgradeContainer/UpgradeCondition/UpgradeConditionIcon"
local upgradeConditionTextPath = "CenterBottomInfo/HeroPropertyInfo/HeroUpgradeContainer/UpgradeCondition/UpgradeConditionText"
local centerBottomInfoPath = "CenterBottomInfo"
local btnHeroAirDropPath = "RightTopInfo/HeroShow/BtnAirdrop"
local btnHeroTakeBackPath = "RightTopInfo/HeroShow/BtnTakeback"
local iconSquad1Path = "RightTopInfo/HeroShow/SquadIcons/iconSquad1"
local iconSquad2Path = "RightTopInfo/HeroShow/SquadIcons/iconSquad2"
local iconSquad3Path = "RightTopInfo/HeroShow/SquadIcons/iconSquad3"
local iconSquad4Path = "RightTopInfo/HeroShow/SquadIcons/iconSquad4"
local heroModelContainerPath = "CenterHeroInfo/EquipDetailPage/HeroModelContainer"
local weaponItemPath = "CenterHeroInfo/EquipDetailPage/WeaponItem"
local armorItemPath = "CenterHeroInfo/EquipDetailPage/ArmorItem"
local coreItemPath = "CenterHeroInfo/EquipDetailPage/CoreItem"
local radarItemPath = "CenterHeroInfo/EquipDetailPage/RadarItem"
local atkFlushEffectPath = "CenterHeroInfo/HeroAtkInfo/AttackRefreshEffect"
local hpFlushEffectPath = "CenterHeroInfo/HeroHpInfo/HpRefreshEffect"
local defFlushEffectPath = "CenterHeroInfo/HeroDefInfo/DefRefreshEffect"
local modelEffectPath = "CenterHeroInfo/EquipDetailPage/Eff_ui_hero_xiangqing_shengji_01"
local powerEffectPath = "RightTopInfo/PowerInfo/Effect"
local levelUpEffectPath = "CenterHeroInfo/HeroLevelInfo/Eff_ui_hero_xiangqing_shengji_02"
local upgradeConditionGotoBtnPath = "CenterBottomInfo/HeroPropertyInfo/HeroUpgradeContainer/UpgradeCondition/UpgradeConditionBtn"
local heroStoryPath = "CenterHeroInfo/StoryBtn"
local PropertyChangeContent_Path = "CenterHeroInfo/PropertyChangeContent"
local PowerChangeContent_Path = "CenterHeroInfo/PowerChangeContent"
local heroJobPath = "RightTopInfo/HeroJobIcon"
local hero_img_path = "CenterHeroInfo/EquipDetailPage/HeroModelContainer/HeroImg"
local RescueBtn_path = "CenterBottomInfo/HeroPropertyInfo/TemplateHeroContainer/RescueBtn"
local promote_btn_path = "CenterBottomInfo/HeroPropertyInfo/HeroUpgradeContainer/PromoteBtn"
local img_cost_item1_path = "CenterBottomInfo/HeroPropertyInfo/HeroUpgradeContainer/PromoteBtn/ImgCostItem1"
local text_cost_path = "CenterBottomInfo/HeroPropertyInfo/HeroUpgradeContainer/PromoteBtn/ImgCostItem1/TextCost"
local red_dot_path = "CenterBottomInfo/HeroPropertyInfo/HeroUpgradeContainer/PromoteBtn/RedDot"
local do_btn_des_path = "CenterBottomInfo/HeroPropertyInfo/HeroUpgradeContainer/PromoteBtn/DoBtnDes"
local hero_level_info_path = "CenterHeroInfo/HeroLevelInfo"
local hero_level_max_text_path = "CenterHeroInfo/HeroLevelInfo/HeroLevelMaxText"
local hero_level_icon_path = "CenterHeroInfo/HeroLevelInfo/HeroLevelIcon"
local ui_lw_armed_upgrade_info_content_path = "CenterBottomInfo/UILWArmedUpgradeInfoContent"
local ContentSizeFitter = CS.UnityEngine.UI.ContentSizeFitter
local triggerLongPressTime = 0.5
local longPressInterval = 0.15

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self.selectedEquipItem = nil
  if self.weaponItem then
    self.weaponItem:SetSelected(false)
  end
  if self.armorItem then
    self.armorItem:SetSelected(false)
  end
  if self.coreItem then
    self.coreItem:SetSelected(false)
  end
  if self.radarItem then
    self.radarItem:SetSelected(false)
  end
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnQuickEquipBtnClick(self)
  if self.canQuickEquip then
    SFSNetwork.SendMessage(MsgDefines.HeroEquipInstall, self.curHeroData.uuid, self.quickEquipNewEquips)
  end
end

local function OnQuickUninstallAllBtnClick(self)
  if self.curHeroData and not table.IsNullOrEmpty(self.curHeroData.equipUids) then
    local slots = {}
    for __, equipUuid in pairs(self.curHeroData.equipUids) do
      local equip = DataCenter.EquipDataManager:GetEquipByUuid(equipUuid)
      if equip then
        table.insert(slots, equip.slot)
      end
    end
    SFSNetwork.SendMessage(MsgDefines.HeroEquipUninstall, self.curHeroData.uuid, slots)
  end
end

local function ComponentDefine(self)
  self.heroModelContainer = self:AddComponent(UIBaseContainer, heroModelContainerPath)
  self.weaponItem = self:AddComponent(UIEquipItem, weaponItemPath)
  self.armorItem = self:AddComponent(UIEquipItem, armorItemPath)
  self.coreItem = self:AddComponent(UIEquipItem, coreItemPath)
  self.radarItem = self:AddComponent(UIEquipItem, radarItemPath)
  self.equipItemList = {
    self.weaponItem,
    self.armorItem,
    self.coreItem,
    self.radarItem
  }
  self.quickEquipBtn = self:AddComponent(UIButton, quickEquipBtnPath)
  self.quickEquipBtn:SetOnClick(BindCallback(self, OnQuickEquipBtnClick))
  self.quickEquipBtnText = self:AddComponent(UIText, quickEquipBtnTextPath)
  self.quickEquipBtnRedPoint = self:AddComponent(UIImage, quickEquipBtnRedPointPath)
  self.powerText = self:AddComponent(UIText, PowerTextPath)
  self.seasonCallbackInfo = self:AddComponent(SeasonCallbackInfo, UISeasonCallbackInfoPath)
  self.detailPropertyBtn = self:AddComponent(UIButton, propertyDetailBtnPath)
  self.detailPropertyBtn:SetOnClick(function()
    HeroUtils.OpenHeroDetailPropertyView(self.curHeroData, UIHeroPropertyDetailType.Hero)
  end)
  self.qualityIcon = self:AddComponent(UIImage, heroQualityIconPath)
  self.nameText = self:AddComponent(UIText, heroNameTextPath)
  self.nickNameText = self:AddComponent(UIText, heroNickNameTextPath)
  self.heroSpineContainer = self:AddComponent(UIBaseContainer, heroSpineContainerPath)
  self.heroLevelText = self:AddComponent(UIText, heroLevelTextPath)
  self.atkNumberText = self:AddComponent(UIText, atkNumberTextPath)
  self.hpNumberText = self:AddComponent(UIText, hpNumberTextPath)
  self.defNumberText = self:AddComponent(UIText, defNumberTextPath)
  self.scNumberText = self:AddComponent(UIText, sdCapacityNumberTextPath)
  self.equipAddHpText = self:AddComponent(UIText, equipAddHpTextPath)
  self.equipAddAtkText = self:AddComponent(UIText, equipAddAtkTextPath)
  self.equipAddDefText = self:AddComponent(UIText, equipAddDefTextPath)
  self.atkInfoBtn = self:AddComponent(UIButton, atkInfoBtnPath)
  self.atkInfoBtn:SetOnClick(function()
    if self.curHeroData == nil then
      return
    end
    local param = DataCenter.ArrowTipParamManager:Get(ArrowTipEnumtype.Type.HeroPropertyDetailTip)
    param.alignObject = self.atkInfoBtn
    if LuaEntry.DataConfig:CheckSwitch("hero_attribute_seperate_switch") then
      param.propertyType = 0
      param.heroData = self.curHeroData
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroGroupedPropertyDetailTip, {anim = true}, param)
    else
      param.mainPropName = Localization:GetString(110298)
      param.mainPropValue = self.curHeroData:GetAtk()
      local levelVal, equipVal, rankVal, buildVal, weaponVal, uniqueWeaponVal, dominatorVal = self:CalcHeroAtkSource()
      param.splitProp = {}
      table.insert(param.splitProp, {
        name = Localization:GetString(110300),
        value = levelVal
      })
      table.insert(param.splitProp, {
        name = Localization:GetString(110301),
        value = equipVal
      })
      table.insert(param.splitProp, {
        name = Localization:GetString(110302),
        value = rankVal
      })
      table.insert(param.splitProp, {
        name = Localization:GetString(110311),
        value = buildVal
      })
      if 0 < weaponVal then
        table.insert(param.splitProp, {
          name = Localization:GetString(110310),
          value = weaponVal
        })
      end
      if 0 < uniqueWeaponVal then
        table.insert(param.splitProp, {
          name = Localization:GetString("hero_unique_weapon_title3"),
          value = uniqueWeaponVal
        })
      end
      if 0 < dominatorVal then
        table.insert(param.splitProp, {
          name = Localization:GetString("dominator_train_bonus"),
          value = dominatorVal
        })
      end
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroPropertyDetailTip, {anim = true}, param)
    end
  end)
  self.hpInfoBtn = self:AddComponent(UIButton, hpInfoBtnPath)
  self.hpInfoBtn:SetOnClick(function()
    if self.curHeroData == nil then
      return
    end
    local param = DataCenter.ArrowTipParamManager:Get(ArrowTipEnumtype.Type.HeroPropertyDetailTip)
    param.alignObject = self.hpInfoBtn
    if LuaEntry.DataConfig:CheckSwitch("hero_attribute_seperate_switch") then
      param.propertyType = 1
      param.heroData = self.curHeroData
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroGroupedPropertyDetailTip, {anim = true}, param)
    else
      param.mainPropName = Localization:GetString(110297)
      param.mainPropValue = self.curHeroData:GetMaxHp()
      local levelVal, equipVal, rankVal, buildVal, honorVal, weaponVal, uniqueWeaponVal, dominatorVal = self:CalcHeroHpSource()
      param.splitProp = {}
      table.insert(param.splitProp, {
        name = Localization:GetString(110300),
        value = levelVal
      })
      table.insert(param.splitProp, {
        name = Localization:GetString(110301),
        value = equipVal
      })
      table.insert(param.splitProp, {
        name = Localization:GetString(110302),
        value = rankVal
      })
      table.insert(param.splitProp, {
        name = Localization:GetString(110311),
        value = buildVal
      })
      if 0 < honorVal then
        table.insert(param.splitProp, {
          name = Localization:GetString(110303),
          value = honorVal
        })
      end
      if 0 < weaponVal then
        table.insert(param.splitProp, {
          name = Localization:GetString(110310),
          value = weaponVal
        })
      end
      if 0 < uniqueWeaponVal then
        table.insert(param.splitProp, {
          name = Localization:GetString("hero_unique_weapon_title3"),
          value = uniqueWeaponVal
        })
      end
      if 0 < dominatorVal then
        table.insert(param.splitProp, {
          name = Localization:GetString("dominator_train_bonus"),
          value = dominatorVal
        })
      end
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroPropertyDetailTip, {anim = true}, param)
    end
  end)
  self.defInfoBtn = self:AddComponent(UIButton, defInfoBtnPath)
  self.defInfoBtn:SetOnClick(function()
    if self.curHeroData == nil then
      return
    end
    local param = DataCenter.ArrowTipParamManager:Get(ArrowTipEnumtype.Type.HeroPropertyDetailTip)
    param.alignObject = self.defInfoBtn
    if LuaEntry.DataConfig:CheckSwitch("hero_attribute_seperate_switch") then
      param.propertyType = 2
      param.heroData = self.curHeroData
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroGroupedPropertyDetailTip, {anim = true}, param)
    else
      param.mainPropName = Localization:GetString(110299)
      param.mainPropValue = self.curHeroData:GetDef()
      local levelVal, equipVal, rankVal, buildVal, weaponVal, uniqueWeaponVal, dominatorVal = self:CalcHeroDefSource()
      param.splitProp = {}
      table.insert(param.splitProp, {
        name = Localization:GetString(110300),
        value = levelVal
      })
      table.insert(param.splitProp, {
        name = Localization:GetString(110301),
        value = equipVal
      })
      table.insert(param.splitProp, {
        name = Localization:GetString(110302),
        value = rankVal
      })
      table.insert(param.splitProp, {
        name = Localization:GetString(110311),
        value = buildVal
      })
      if 0 < weaponVal then
        table.insert(param.splitProp, {
          name = Localization:GetString(110310),
          value = weaponVal
        })
      end
      if 0 < uniqueWeaponVal then
        table.insert(param.splitProp, {
          name = Localization:GetString("hero_unique_weapon_title3"),
          value = uniqueWeaponVal
        })
      end
      if 0 < dominatorVal then
        table.insert(param.splitProp, {
          name = Localization:GetString("dominator_train_bonus"),
          value = dominatorVal
        })
      end
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroPropertyDetailTip, {anim = true}, param)
    end
  end)
  self.scfInfoBtn = self:AddComponent(UIButton, scInfoBtnPath)
  self.scfInfoBtn:SetOnClick(function()
    if self.curHeroData == nil then
      return
    end
    local param = DataCenter.ArrowTipParamManager:Get(ArrowTipEnumtype.Type.HeroPropertyDetailTip)
    param.mainPropName = Localization:GetString(211245)
    param.mainPropValue = self.curHeroData:GetSoldierCapacity()
    local levelVal, survivorVal, buildVal, sciVal = self:CalcHeroSCSource()
    param.splitProp = {}
    table.insert(param.splitProp, {
      name = Localization:GetString(110300),
      value = levelVal
    })
    table.insert(param.splitProp, {
      name = Localization:GetString("overview_8"),
      value = survivorVal
    })
    table.insert(param.splitProp, {
      name = Localization:GetString(110311),
      value = buildVal
    })
    table.insert(param.splitProp, {
      name = Localization:GetString(110292),
      value = sciVal
    })
    param.alignObject = self.scfInfoBtn
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroPropertyDetailTip, {anim = true}, param)
  end)
  self.upgradeBtn = self:AddComponent(UIEventTrigger, upgradeBtnPath)
  self.upgradeBtn:OnPointerDown(BindCallback(self, self.OnPointerDown))
  self.upgradeBtn:OnPointerUp(BindCallback(self, self.OnPointerUp))
  self.upgradeBtnText = self:AddComponent(UIText, upgradeBtnTextPath)
  self.upgradeBtnRedPoint = self:AddComponent(UIImage, upgradeBtnRedPointPath)
  self.upgradeBtnUpdateLevel = self:AddComponent(UIBaseContainer, upgradeBtnUpdateLevelPath)
  self.upgradeContainer = self:AddComponent(UIBaseContainer, upgradeContainerPath)
  self.templateHeroContainer = self:AddComponent(UIBaseContainer, templateHeroContainerPath)
  self.templateHeroGotoBtn = self:AddComponent(UIButton, templateHeroGotoBtnPath)
  self.templateHeroGotoBtn:SetOnClick(function()
    if self.curHeroData ~= nil then
      local need = HeroUtils.GetJigsawCost(self.curHeroData.fragId)
      LWResourceLackUtil:GotoGoodsItemLack(self.curHeroData.fragId, need)
    end
  end)
  self.cost = self:AddComponent(UIBaseContainer, costPath)
  self.costExp = self:AddComponent(UIButton, costExpPath)
  self.costExpText = self:AddComponent(UIText, costExpTextPath)
  self.costExpIcon = self:AddComponent(UIImage, costExpIconPath)
  self.upgradeCondition = self:AddComponent(UIText, upgradeConditionPath)
  self.upgradeConditionIcon = self:AddComponent(UIImage, upgradeConditionIconPath)
  self.upgradeConditionText = self:AddComponent(UIText, upgradeConditionTextPath)
  self.costResource1 = self:AddComponent(UIButton, costResource1Path)
  self.costResource1Icon = self:AddComponent(UIImage, costResource1IconPath)
  self.costResource1Text = self:AddComponent(UIText, costResource1NumTextPath)
  self.costResource2 = self:AddComponent(UIButton, costResource2Path)
  self.costResource2Icon = self:AddComponent(UIImage, costResource2IconPath)
  self.costResource2Text = self:AddComponent(UIText, costResource2NumTextPath)
  self.costResource3 = self:AddComponent(UIButton, costResource3Path)
  self.costResource3Icon = self:AddComponent(UIImage, costResource3IconPath)
  self.costResource3Text = self:AddComponent(UIText, costResource3NumTextPath)
  self.costResourceItems = {
    [1] = self.costResource1,
    [2] = self.costResource2,
    [3] = self.costResource3
  }
  self.costResourceIcons = {
    [1] = self.costResource1Icon,
    [2] = self.costResource2Icon,
    [3] = self.costResource3Icon
  }
  self.costResourceTexts = {
    [1] = self.costResource1Text,
    [2] = self.costResource2Text,
    [3] = self.costResource3Text
  }
  self.centerBottomInfo = self:AddComponent(UIBaseContainer, centerBottomInfoPath)
  self.rightTopHeroQualityBg = self:AddComponent(UIImage, rightTopHeroQualityBgPath)
  self.heroTypeIcon = self:AddComponent(UIImage, heroTypeIconPath)
  self.heroTypeBtn = self:AddComponent(UIButton, heroTypeIconPath)
  self.heroTypeBtn:SetOnClick(function()
    local pos = self.heroTypeBtn.transform.position
    local tip = HeroUtils.GetHeroTipInfoTextByType(self.curHeroData.heroType)
    local text = Localization:GetString("129213", Localization:GetString(tip))
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroArmyJobTip, {anim = true}, pos, text)
  end)
  self.atkTitleText = self:AddComponent(UIText, atkTitleTextPath)
  self.hpTitleText = self:AddComponent(UIText, hpTitleTextPath)
  self.defTitleText = self:AddComponent(UIText, defTitleTextPath)
  self.scTitleText = self:AddComponent(UIText, scTitleTextPath)
  self.btnHeroAirDrop = self:AddComponent(UIButton, btnHeroAirDropPath)
  self.btnHeroAirDrop:SetOnClick(function()
    self:OnBtnHeroAirDropClick()
  end)
  self.btnHeroAirDrop:SetActive(false)
  self.btnHeroTakeBack = self:AddComponent(UIButton, btnHeroTakeBackPath)
  self.btnHeroTakeBack:SetOnClick(function()
    self:OnBtnHeroTakeBackClick()
  end)
  self.btnHeroTakeBack:SetActive(false)
  self.iconSquad1 = self:AddComponent(UIImage, iconSquad1Path)
  self.iconSquad2 = self:AddComponent(UIImage, iconSquad2Path)
  self.iconSquad3 = self:AddComponent(UIImage, iconSquad3Path)
  self.iconSquad4 = self:AddComponent(UIImage, iconSquad4Path)
  self.atkFlushEffect = self:AddComponent(UIBaseContainer, atkFlushEffectPath)
  self.hpFlushEffect = self:AddComponent(UIBaseContainer, hpFlushEffectPath)
  self.defFlushEffect = self:AddComponent(UIBaseContainer, defFlushEffectPath)
  self.modelFlushEffect = self:AddComponent(UIBaseContainer, modelEffectPath)
  self.powerEffect = self:AddComponent(UIBaseContainer, powerEffectPath)
  self.lvEffect = self:AddComponent(UIBaseContainer, levelUpEffectPath)
  self.img_job = self:AddComponent(UIImage, heroJobPath)
  self.img_job = self:AddComponent(UIButton, heroJobPath)
  self.img_job:SetOnClick(function()
    local pos = self.img_job.transform.position
    local tip = HeroUtils.GetHeroTipInfoTextByJob(self.curHeroData.meta.job)
    local text = Localization:GetString(tip)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroArmyJobTip, {anim = true}, pos, text)
  end)
  self.upgradeConditionGotoBtn = self:AddComponent(UIButton, upgradeConditionGotoBtnPath)
  self.upgradeConditionGotoBtn:SetOnClick(function()
    if self.curHeroData ~= nil then
      if CS.SceneManager:IsInPVE() then
        UIUtil.ShowTipsId("quick_upgrade_block_tips")
      else
        self:GoToMainBuild()
      end
    end
  end)
  self.upgradeBtnText:SetLocalText(151056)
  self.quickEquipBtnText:SetLocalText(430737)
  self.propertyChangeContent = self:AddComponent(UIBaseContainer, PropertyChangeContent_Path)
  self.powerChangeContent = self:AddComponent(UIBaseContainer, PowerChangeContent_Path)
  self.propertyChangePrefab = self.propertyChangeContent.transform:Find("PropertyChangeItem")
  self.propertyChangePrefab.gameObject:SetActive(false)
  self.propertyChangePrefabNew = self.propertyChangeContent.transform:Find("PropertyChangeItemNew")
  self.propertyChangePrefabNew.gameObject:SetActive(false)
  self.powerChangePrefab = self.powerChangeContent.transform:Find("PowerChangeItem")
  self.powerChangePrefab.gameObject:SetActive(false)
  self.storyBtn = self:AddComponent(UIButton, heroStoryPath)
  self.storyBtn:SetOnClick(function()
    if self.curHeroData ~= nil then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroStoryPanel, {anim = true}, self.curHeroData)
    end
  end)
  self.heroImg = self:AddComponent(HeroSimpleModelViewer, hero_img_path, true)
  self.heroImg:SetRTSize(812, 835)
  self.RescueBtn = self:AddComponent(UIButton, RescueBtn_path)
  self.RescueBtn:SetOnClick(function()
    GoToUtil.CloseAllWindows()
    GoToUtil.GotoDabenPos()
  end)
  self.templateHeroText = self:AddComponent(UIText, templateHeroTextPath)
  self.promote_btn = self:AddComponent(UIButton, promote_btn_path)
  self.img_cost_item1 = self:AddComponent(UIImage, img_cost_item1_path)
  self.text_cost = self:AddComponent(UITextMeshProUGUIEx, text_cost_path)
  self.red_dot = self:AddComponent(UIImage, red_dot_path)
  self.do_btn_des = self:AddComponent(UITextMeshProUGUIEx, do_btn_des_path)
  self.promote_btn:SetActive(false)
  self.promote_btn:SetOnClick(function()
    self:OnPromoteBtnClick()
  end)
  self.red_dot:SetActive(false)
  self.hero_level_max_text = self:AddComponent(UITextMeshProUGUIEx, hero_level_max_text_path)
  self.hero_level_max_text:SetActive(false)
  self.hero_level_info_layout = self:AddComponent(UIHorizontalOrVerticalLayoutGroup, hero_level_info_path)
  self.hero_level_info_layout:SetSpacing(10)
  self.hero_level_icon = self:AddComponent(UIImage, hero_level_icon_path)
  self.hero_level_icon:LoadSprite("Assets/Main/Sprites/UI/UILWHeroDetail/cfm_yingxiong_dengji_LV.png")
  self.hero_level_icon:SetNativeSize()
  self.hero_level_size_fitter = self.heroLevelText.rectTransform:GetComponent(typeof(ContentSizeFitter))
  if self.hero_level_size_fitter then
    self.hero_level_size_fitter.enabled = false
  end
  self.heroLevelText:SetSizeDeltaXY(89, 58)
  self.hero_level_info_layout:ChildControlWidth(false)
  local armedUpgradeOpen = DataCenter.LWArmedUpgradeManager:IsArmedUpgradeOpen(true)
  if armedUpgradeOpen then
    self.armedUpgradeInfoContent = self:AddComponent(UILWArmedUpgradeInfoContentView, ui_lw_armed_upgrade_info_content_path)
  else
    local infoContent = self.transform:Find(ui_lw_armed_upgrade_info_content_path)
    if not IsNull(infoContent) then
      infoContent.gameObject:SetActive(false)
    end
  end
  self.btnHeroTryOut = self:AddComponent(UIButton, "CenterBottomInfo/HeroTryOutBtn")
  self.btnHeroTryOut:SetOnClick(function()
    self:OnBtnHeroTryOutClick()
  end)
  self.redHeroTryOut = self:AddComponent(UIBaseComponent, "CenterBottomInfo/HeroTryOutBtn/HeroTryOutBtnRed")
end

function UIHeroGrowthPage:GoToMainBuild()
  local buildList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.FUN_BUILD_MAIN)
  if not table.IsNullOrEmpty(buildList) then
    local buildingData = buildList[1]
    GoToUtil.CloseAllWindows()
    GoToUtil.GotoCityPos(SceneUtils.TileIndexToWorld(buildingData.pointId, ForceChangeScene.City), CS.SceneManager.World.InitZoom, LookAtFocusTime, function()
      TimerManager:GetInstance():DelayInvoke(function()
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIBuildUpgrade, tostring(buildingData.uuid))
      end, 0.15)
    end)
  end
end

local function DataDefine(self)
  self.canQuickEquip = false
  self.quickEquipNewEquips = {}
  self.heroUpgradeState = -1
  self.lastSpinePath = nil
  self.propertyChangePool = {}
  self.powerChangePool = {}
  self.needResources = {}
  self.lastTime = nil
  self.upgradeMsgReturn = nil
  self.isLongPress = nil
  self.isClick = nil
  self.isUpgradeBtnGray = nil
  self.heroPromoteData = nil
  self.heroPromoteRankCondition = false
  self.isShowedQuickEquipGuide = false
  self.curSingleClickNum = 0
  self.triggerTipsNum = LuaEntry.DataConfig:TryGetNum("guild_plus_sep", "k13")
end

local function ComponentDestroy(self)
  self:ClearTemplatePool()
  self.weaponItem = nil
  self.armorItem = nil
  self.coreItem = nil
  self.radarItem = nil
  self.equipItemList = nil
  self.quickEquipBtn = nil
  self.quickEquipBtnText = nil
  self.quickEquipBtnRedPoint = nil
  self.powerText = nil
  self.detailPropertyBtn = nil
  self.qualityIcon = nil
  self.nameText = nil
  self.nickNameText = nil
  self.heroSpineContainer = nil
  self.heroLevelText = nil
  self.atkNumberText = nil
  self.hpNumberText = nil
  self.defNumberText = nil
  self.equipAddHpText = nil
  self.equipAddAtkText = nil
  self.equipAddDefText = nil
  self.atkInfoBtn = nil
  self.hpInfoBtn = nil
  self.defInfoBtn = nil
  self.upgradeBtn = nil
  self.upgradeBtnText = nil
  self.upgradeBtnRedPoint = nil
  self.upgradeContainer = nil
  self.templateHeroContainer = nil
  self.templateHeroGotoBtn = nil
  self.cost = nil
  self.costExp = nil
  self.costExpText = nil
  self.costExpIcon = nil
  self.upgradeCondition = nil
  self.upgradeConditionIcon = nil
  self.upgradeConditionText = nil
  self.costResource1 = nil
  self.costResource1Icon = nil
  self.costResource1Text = nil
  self.costResource2 = nil
  self.costResource2Icon = nil
  self.costResource2Text = nil
  self.costResource3 = nil
  self.costResource3Icon = nil
  self.costResource3Text = nil
  self.costResourceItems = nil
  self.costResourceIcons = nil
  self.costResourceTexts = nil
  self.centerBottomInfo = nil
  self.rightTopHeroQualityBg = nil
  self.heroTypeIcon = nil
  self.atkTitleText = nil
  self.hpTitleText = nil
  self.defTitleText = nil
  self.btnHeroAirDrop = nil
  self.btnHeroTakeBack = nil
  self.iconSquad1 = nil
  self.iconSquad2 = nil
  self.iconSquad3 = nil
  self.iconSquad4 = nil
  self.atkFlushEffect = nil
  self.hpFlushEffect = nil
  self.defFlushEffect = nil
  self.modelFlushEffect = nil
  self.powerEffect = nil
  self.lvEffect = nil
  self.upgradeConditionGotoBtn = nil
  self.promote_btn = nil
  self.img_cost_item1 = nil
  self.text_cost = nil
  self.red_dot = nil
  self.do_btn_des = nil
  self.heroPromoteData = nil
  self.heroPromoteRankCondition = nil
  self.hero_level_max_text = nil
  self.hero_level_info_layout = nil
  self.hero_level_icon = nil
  self.armedUpgradeInfoContent = nil
end

local function DataDestroy(self)
  self.lastSpinePath = nil
  self.curHeroData = nil
  self.needResources = nil
  self.lastTime = nil
  self.upgradeMsgReturn = nil
  self.isLongPress = nil
  self.isClick = nil
  self.isUpgradeBtnGray = nil
  self.curSingleClickNum = nil
  self.triggerTipsNum = nil
end

local function OnEnable(self)
  base.OnEnable(self)
  self.active = true
  if self.heroImg then
    self.heroImg:SetSceneVisible(true)
  end
end

local function OnDisable(self)
  base.OnDisable(self)
  self.active = false
  self:HideFlushEffect()
  if self.heroImg then
    self.heroImg:SetSceneVisible(false)
  end
end

local function OnHeroEquipUpgrade(self, equipUuid)
  if not self.active then
    return
  end
  local equipData = DataCenter.EquipDataManager:GetEquipByUuid(equipUuid)
  if equipData == nil then
    return
  end
  if self.curHeroData.uuid == equipData.heroUuid then
    self:UpdateView()
  end
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_HERO_EquipUpgrade, false)
end

local function OnHeroEquipRecommendSwitch(self)
  if not self.active then
    return
  end
  self:UpdateView()
end

local function OnHeroEquipChange(self, heroUuid)
  if not self.active then
    return
  end
  if self.curHeroData == nil then
    return
  end
  if self.curHeroData.uuid == heroUuid then
    self:UpdateView()
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_HERO_EquipUpgrade, false)
  end
end

local function OnResOrItemUpdate(self)
  if self.isTemplateHero == true then
    return
  end
  self:RefreshUpgradeBtn()
end

local function ShowFlushEffect(self)
  self.lvEffect:SetActive(false)
  self.modelFlushEffect:SetActive(false)
  self.lvEffect:SetActive(true)
  self.modelFlushEffect:SetActive(true)
end

local function HideFlushEffect(self)
  self.atkFlushEffect:SetActive(false)
  self.defFlushEffect:SetActive(false)
  self.powerEffect:SetActive(false)
  self.lvEffect:SetActive(false)
  self.hpFlushEffect:SetActive(false)
  self.modelFlushEffect:SetActive(false)
end

local function OnHeroUpgrade(self, heroUuid)
  self:UpdateView(true)
  ShowFlushEffect(self)
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_HERO_Upgrade, false)
  if not self.curHeroData then
    self.upgradeMsgReturn = true
    return
  end
  local newUnlockSkill = self.curHeroData:GetLevelUnlockSkill()
  if table.IsNullOrEmpty(newUnlockSkill) then
    self.upgradeMsgReturn = true
    return
  end
  local skillData = newUnlockSkill[1]
  local heroData = self.curHeroData
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroUnlockNewSkillPanel, {anim = true}, skillData, heroData, self.view:GetSkillPageTogglePosition())
  self.curHeroData:SetSkillPageRedPoint()
  self:BreakLongPress()
  self.upgradeMsgReturn = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.HeroEquipInstall, self.OnHeroEquipChange)
  self:AddUIListener(EventId.HeroEquipUninstall, self.OnHeroEquipChange)
  self:AddUIListener(EventId.HeroEquipUpgrade, self.OnHeroEquipUpgrade)
  self:AddUIListener(EventId.RefreshResourceItem, OnResOrItemUpdate)
  self:AddUIListener(EventId.ResourceUpdated, OnResOrItemUpdate)
  self:AddUIListener(EventId.RefreshItems, OnResOrItemUpdate)
  self:AddUIListener(EventId.HeroLvUpSuccess, self.OnHeroUpgrade)
  self:AddUIListener(EventId.HeroBeyondSuccess, self.OnHeroUpgrade)
  self:AddUIListener(EventId.HeorEquipPromote, self.OnHeroEquipUpgrade)
  self:AddUIListener(EventId.HeroEquipRecommendSwitchSuccess, self.OnHeroEquipRecommendSwitch)
  self:AddUIListener(EventId.LWSeasonHeroPromote, self.PromoteSuccess)
  self:AddUIListener(EventId.HeroTryOutReceiveGetInfoMsg, self.RefreshHeroTryOutBtn)
  self:AddUIListener(EventId.HeroTryOutSkipSuccess, self.RefreshHeroTryOutBtn)
  self:AddUIListener(EventId.HeroTryOutRedUpdate, self.RefreshHeroTryOutBtn)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.HeroEquipInstall, self.OnHeroEquipChange)
  self:RemoveUIListener(EventId.HeroEquipUninstall, self.OnHeroEquipChange)
  self:RemoveUIListener(EventId.HeroEquipUpgrade, self.OnHeroEquipUpgrade)
  self:RemoveUIListener(EventId.RefreshResourceItem, OnResOrItemUpdate)
  self:RemoveUIListener(EventId.ResourceUpdated, OnResOrItemUpdate)
  self:RemoveUIListener(EventId.RefreshItems, OnResOrItemUpdate)
  self:RemoveUIListener(EventId.HeroLvUpSuccess, self.OnHeroUpgrade)
  self:RemoveUIListener(EventId.HeroBeyondSuccess, self.OnHeroUpgrade)
  self:RemoveUIListener(EventId.HeorEquipPromote, self.OnHeroEquipUpgrade)
  self:RemoveUIListener(EventId.HeroEquipRecommendSwitchSuccess, self.OnHeroEquipRecommendSwitch)
  self:RemoveUIListener(EventId.LWSeasonHeroPromote, self.PromoteSuccess)
  self:RemoveUIListener(EventId.HeroTryOutReceiveGetInfoMsg, self.OnHeroTryOutReceiveGetInfoMsg)
  self:RemoveUIListener(EventId.HeroTryOutSkipSuccess, self.OnHeroTryOutSkipSuccess)
  self:RemoveUIListener(EventId.HeroTryOutRedUpdate, self.RefreshHeroTryOutBtn)
end

local function SetEquipSlotPosition(self)
  if self.curHeroData == nil then
    return
  end
  local heroTemplate = self.curHeroData.meta
  local canShowHeroEquip = self.curHeroData:IsUnlockEquipFunction()
  canShowHeroEquip = canShowHeroEquip and not self.isTemplateHero
end

local function OnEquipDetailPanelClose(self)
  if self.selectedEquipItem ~= nil then
    self.selectedEquipItem:SetSelected(false)
  end
end

local function RefreshEquipmentSlots(self)
  if self.curHeroData == nil then
    return
  end
  local canShowHeroEquip = self.curHeroData:IsUnlockEquipFunction()
  canShowHeroEquip = canShowHeroEquip and not self.isTemplateHero
  if not canShowHeroEquip then
    self.weaponItem:SetActive(false)
    self.armorItem:SetActive(false)
    self.coreItem:SetActive(false)
    self.radarItem:SetActive(false)
    return
  else
    self.weaponItem:SetActive(true)
    self.armorItem:SetActive(true)
    self.coreItem:SetActive(true)
    self.radarItem:SetActive(true)
  end
  self.weaponItemData = nil
  self.armorItemData = nil
  self.coreItemData = nil
  self.radarItemData = nil
  local equipUids = self.curHeroData.equipUids
  if equipUids ~= nil then
    for _, v in pairs(equipUids) do
      local equipData = DataCenter.EquipDataManager:GetEquipByUuid(v)
      if equipData ~= nil then
        if equipData.slot == EquipmentSlotType.Weapon then
          self.weaponItemData = equipData
        elseif equipData.slot == EquipmentSlotType.Armor then
          self.armorItemData = equipData
        elseif equipData.slot == EquipmentSlotType.Core then
          self.coreItemData = equipData
        elseif equipData.slot == EquipmentSlotType.Radar then
          self.radarItemData = equipData
        end
      end
    end
  end
  
  local function OnClickEmptySlot(self, slotType)
    if slotType == nil then
      return
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroEquipListPanel, {anim = true}, self.curHeroData, slotType)
  end
  
  local function OnClickEquipItem(self, equipData, alignObject)
    if equipData == nil then
      return
    end
    if equipData.slot == EquipmentSlotType.Weapon then
      self.weaponItem:SetSelected(true)
      self.selectedEquipItem = self.weaponItem
    elseif equipData.slot == EquipmentSlotType.Armor then
      self.armorItem:SetSelected(true)
      self.selectedEquipItem = self.armorItem
    elseif equipData.slot == EquipmentSlotType.Core then
      self.coreItem:SetSelected(true)
      self.selectedEquipItem = self.coreItem
    elseif equipData.slot == EquipmentSlotType.Radar then
      self.radarItem:SetSelected(true)
      self.selectedEquipItem = self.radarItem
    end
    local heroUuids
    if self.view then
      heroUuids = self.view:GetHeroUuidsList()
    end
    local equipUuids = DataCenter.EquipDataManager:GetAllWearingEquip(heroUuids)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroEquipDetailPanel, {anim = true}, equipData.uuid, BindCallback(self, OnEquipDetailPanelClose), equipUuids, true)
  end
  
  DataCenter.EquipRecommendManager:SetRecommendDataDirty()
  self.weaponItem:SetData(EquipmentSlotType.Weapon, self.curHeroData, self.weaponItemData, BindCallback(self, OnClickEmptySlot), BindCallback(self, OnClickEquipItem))
  self.armorItem:SetData(EquipmentSlotType.Armor, self.curHeroData, self.armorItemData, BindCallback(self, OnClickEmptySlot), BindCallback(self, OnClickEquipItem))
  self.coreItem:SetData(EquipmentSlotType.Core, self.curHeroData, self.coreItemData, BindCallback(self, OnClickEmptySlot), BindCallback(self, OnClickEquipItem))
  self.radarItem:SetData(EquipmentSlotType.Radar, self.curHeroData, self.radarItemData, BindCallback(self, OnClickEmptySlot), BindCallback(self, OnClickEquipItem))
end

local function CollectPower(self)
  local power = 0
  if self.weaponItemData ~= nil then
    power = power + self.weaponItemData.power
  end
  if self.armorItemData ~= nil then
    power = power + self.armorItemData.power
  end
  if self.coreItemData ~= nil then
    power = power + self.coreItemData.power
  end
  if self.radarItemData ~= nil then
    power = power + self.radarItemData.power
  end
  return math.floor(power)
end

local function GetAllEquipProperties(self)
  local properties = {}
  if self.weaponItemData ~= nil then
    local allProperty = self.weaponItemData:GetAllProperty()
    for k, v in pairs(allProperty) do
      if properties[k] == nil then
        properties[k] = v
      else
        properties[k] = properties[k] + v
      end
    end
  end
  if self.armorItemData ~= nil then
    local allProperty = self.armorItemData:GetAllProperty()
    for k, v in pairs(allProperty) do
      if properties[k] == nil then
        properties[k] = v
      else
        properties[k] = properties[k] + v
      end
    end
  end
  if self.coreItemData ~= nil then
    local allProperty = self.coreItemData:GetAllProperty()
    for k, v in pairs(allProperty) do
      if properties[k] == nil then
        properties[k] = v
      else
        properties[k] = properties[k] + v
      end
    end
  end
  if self.radarItemData ~= nil then
    local allProperty = self.radarItemData:GetAllProperty()
    for k, v in pairs(allProperty) do
      if properties[k] == nil then
        properties[k] = v
      else
        properties[k] = properties[k] + v
      end
    end
  end
  local propertiesDataList = {}
  for k, v in pairs(properties) do
    local data = {}
    data.id = k
    data.value = v
    table.insert(propertiesDataList, data)
  end
  table.sort(propertiesDataList, function(a, b)
    local effectATemplate = DataCenter.EffectNumberTemplateManager:GetEffectNumberTemplateById(a.id)
    local effectBTemplate = DataCenter.EffectNumberTemplateManager:GetEffectNumberTemplateById(b.id)
    return effectATemplate.sequence < effectBTemplate.sequence
  end)
  return propertiesDataList
end

local function QuickChangeEquip(heroData, weaponItemData, armorItemData, coreItemData, radarItemData)
  if heroData == nil then
    return false
  end
  local canQuickEquip = false
  local newEquips = {}
  local highestPower = 0
  local highestEquipUuid = 0
  local weaponEquips = DataCenter.EquipDataManager:GetAllEquipListBySlotTypeAndHeroType(EquipmentSlotType.Weapon, heroData.heroType, false)
  if weaponItemData ~= nil then
    highestPower = weaponItemData.power
  end
  for i, v in pairs(weaponEquips) do
    if highestPower < v.power then
      highestPower = v.power
      highestEquipUuid = v.uuid
    end
  end
  if highestEquipUuid ~= 0 then
    canQuickEquip = true
    newEquips[EquipmentSlotType.Weapon] = highestEquipUuid
  end
  local armorEquips = DataCenter.EquipDataManager:GetAllEquipListBySlotTypeAndHeroType(EquipmentSlotType.Armor, heroData.heroType, false)
  highestPower = 0
  highestEquipUuid = 0
  if armorItemData ~= nil then
    highestPower = armorItemData.power
  end
  for i, v in pairs(armorEquips) do
    if highestPower < v.power then
      highestPower = v.power
      highestEquipUuid = v.uuid
    end
  end
  if highestEquipUuid ~= 0 then
    canQuickEquip = true
    newEquips[EquipmentSlotType.Armor] = highestEquipUuid
  end
  local coreEquips = DataCenter.EquipDataManager:GetAllEquipListBySlotTypeAndHeroType(EquipmentSlotType.Core, heroData.heroType, false)
  highestPower = 0
  highestEquipUuid = 0
  if coreItemData ~= nil then
    highestPower = coreItemData.power
  end
  for i, v in pairs(coreEquips) do
    if highestPower < v.power then
      highestPower = v.power
      highestEquipUuid = v.uuid
    end
  end
  if highestEquipUuid ~= 0 then
    canQuickEquip = true
    newEquips[EquipmentSlotType.Core] = highestEquipUuid
  end
  local radarEquips = DataCenter.EquipDataManager:GetAllEquipListBySlotTypeAndHeroType(EquipmentSlotType.Radar, heroData.heroType, false)
  highestPower = 0
  highestEquipUuid = 0
  if radarItemData ~= nil then
    highestPower = radarItemData.power
  end
  for i, v in pairs(radarEquips) do
    if highestPower < v.power then
      highestPower = v.power
      highestEquipUuid = v.uuid
    end
  end
  if highestEquipUuid ~= 0 then
    canQuickEquip = true
    newEquips[EquipmentSlotType.Radar] = highestEquipUuid
  end
  return canQuickEquip, newEquips
end

local function RefreshQuickEqiupBtnRedPoint(self)
  if not self.view then
    return
  end
  local canShowHeroEquip = self.curHeroData:IsUnlockEquipFunction()
  canShowHeroEquip = canShowHeroEquip and not self.isTemplateHero
  if not canShowHeroEquip then
    self.quickEquipBtn:SetActive(false)
    return
  end
  self.canQuickEquip, self.quickEquipNewEquips = QuickChangeEquip(self.curHeroData, self.weaponItemData, self.armorItemData, self.coreItemData, self.radarItemData)
  local showRedPoint = self.canQuickEquip
  self.quickEquipBtn:SetActive(showRedPoint)
  self.quickEquipBtnRedPoint:SetActive(showRedPoint and HeroRedPointManager:GetInstance():IsHeroInSquad(self.curHeroData.uuid))
end

local function RefreshUpgradeBtn(self)
  if self.isTemplateHero == true then
    self.templateHeroContainer:SetActive(true)
    self.upgradeContainer:SetActive(false)
    local bomb = DataCenter.LWSaveGirlManager:IsSavingHero(self.curHeroData.heroId)
    if bomb then
      self.templateHeroGotoBtn:SetActive(false)
      self.templateHeroText:SetActive(false)
      self.RescueBtn:SetActive(true)
    else
      self.templateHeroGotoBtn:SetActive(true)
      self.templateHeroText:SetActive(true)
      self.RescueBtn:SetActive(false)
    end
    return
  else
    self.templateHeroContainer:SetActive(false)
    self.upgradeContainer:SetActive(true)
  end
  local canUpgrade, canUpgradeWithoutExpItems, overFinalLevel, reachLevelLimit = DataCenter.HeroDataManager:GetHeroCanUpgradeInfos(self.curHeroData)
  self.upgradeBtnUpdateLevel:SetActive(false)
  if overFinalLevel then
    self.isUpgradeBtnGray = true
    UIGray.SetGray(self.upgradeBtn.transform, true, false)
    self.upgradeCondition:SetActive(true)
    self.upgradeConditionIcon:SetActive(false)
    self.upgradeConditionGotoBtn:SetActive(false)
    self.cost:SetActive(false)
    self.upgradeConditionText:SetLocalText(150027)
    self.upgradeConditionText:SetColor(Color.New(1, 0.463, 0.38, 1))
    self.upgradeBtnRedPoint:SetActive(false)
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.upgradeCondition.rectTransform)
  elseif reachLevelLimit then
    self.isUpgradeBtnGray = true
    UIGray.SetGray(self.upgradeBtn.transform, true, true)
    self.upgradeCondition:SetActive(true)
    self.upgradeConditionIcon:SetActive(true)
    self.upgradeConditionGotoBtn:SetActive(true)
    self.cost:SetActive(false)
    self.upgradeConditionText:SetLocalText(151105, DataCenter.BuildManager.MainLv + 1)
    self.upgradeConditionText:SetColor(Color.New(1, 0.463, 0.38, 1))
    self.upgradeBtnRedPoint:SetActive(false)
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.upgradeCondition.rectTransform)
  else
    self.isUpgradeBtnGray = false
    UIGray.SetGray(self.upgradeBtn.transform, false, true)
    self.upgradeCondition:SetActive(false)
    self.cost:SetActive(true)
    self.costResources = HeroUtils.GetLevelUpCostResources(self.curHeroData.level)
    local resourceIndex = 1
    local costResourceKeys = table.keys(self.costResources)
    table.sort(costResourceKeys)
    self.sortedCostResourceKeys = costResourceKeys
    for _, resourceId in pairs(self.sortedCostResourceKeys) do
      local cost = self.costResources[resourceId]
      local have = LuaEntry.Resource:GetCntByResType(resourceId)
      if not (cost <= 0) then
        self.costResourceItems[resourceIndex]:SetActive(true)
        self.costResourceIcons[resourceIndex]:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(resourceId))
        local colorStr = cost <= have and "<color=#00FF00>" or "<color=#FF0000>"
        self.costResourceTexts[resourceIndex]:SetText(string.format("%s%s</color>/%s", colorStr, string.GetFormattedStr(have), string.GetFormattedStr(cost)))
        resourceIndex = resourceIndex + 1
      end
    end
    if resourceIndex <= table.count(self.costResourceItems) then
      for i = resourceIndex, table.count(self.costResourceItems) do
        self.costResourceItems[i]:SetActive(false)
      end
    end
    self.costExpCount = HeroUtils.GetLevelUpNeedExp(self.curHeroData.level)
    if 0 < self.costExpCount then
      self.costExp:SetActive(true)
      self.hasExpCount = self.view.ctrl:GetAllExpItems()
      local colorStr = self.hasExpCount >= self.costExpCount and "<color=#00FF00>" or "<color=#FF0000>"
      self.costExpText:SetText(string.format("%s%s</color>/%s", colorStr, string.GetFormattedStr(self.hasExpCount), string.GetFormattedStr(self.costExpCount)))
    else
      self.costExp:SetActive(false)
    end
    self.upgradeBtnRedPoint:SetActive(HeroRedPointManager:GetInstance():CheckCanShowRedPoint(HeroRedPointType.HeroDetail_UpgradeBtn, self.curHeroData.uuid))
    self.upgradeBtnUpdateLevel:SetActive(false)
  end
end

local function RefreshHeroBaseInfo(self)
  if not self.curHeroData then
    return
  end
  if self.curHeroData.heroType then
    local heroType = self.curHeroData.heroType
    heroType = math.min(heroType, 3)
    heroType = math.max(heroType, 1)
    self.heroTypeIcon:LoadSprite(HeroUtils.GetHeroTypeIcon(heroType))
    self.heroTypeIcon:SetNativeSize()
  end
  if self.curHeroData.meta and self.curHeroData.meta.job then
    self.img_job:SetActive(true)
    self.img_job:LoadSprite(HeroUtils.GetHeroJobIcon(self.curHeroData.meta.job, 2))
  else
    self.img_job:SetActive(false)
  end
  if self.curHeroData.quality then
    local quality = self.curHeroData.quality
    quality = math.min(quality, 5)
    quality = math.max(quality, 1)
    self.qualityIcon:LoadSprite(HeroUtils.GetHeroQualityTagImg(self.curHeroData.quality))
    self.qualityIcon:SetNativeSize()
  end
  self.heroLevelText:SetText(self.curHeroData.level)
  local heroName = self.curHeroData:GetName()
  if GMUtils.GetBool(GMConst.DebugDisplayGameID, false) then
    heroName = heroName .. string.format("[%s]", self.curHeroData.heroId)
  end
  self.nameText:SetText(heroName)
  self.nickNameText:SetText(self.curHeroData:GetNickName())
  RefreshUpgradeBtn(self)
  self.storyBtn:SetActive(self.curHeroData:ShowHeroStory())
  triggerLongPressTime = 0.5
end

local function RefreshHeroBaseProperty(self)
  self.lastAtk = self.upgradeAtk
  self.lastHp = self.upgradeHp
  self.lastDef = self.upgradeDef
  self.upgradeAtk = self.curHeroData:GetAtk()
  self.upgradeHp = self.curHeroData:GetMaxHp()
  self.upgradeDef = self.curHeroData:GetDef()
  self.upgradeSoldiersCapacity = self.curHeroData:GetSoldierCapacity()
  self.scNumberText:SetText(string.GetFormattedStr(self.upgradeSoldiersCapacity))
  self.atkNumberText:SetText(string.GetFormattedStr(self.upgradeAtk))
  self.hpNumberText:SetText(string.GetFormattedStr(self.upgradeHp))
  self.defNumberText:SetText(string.GetFormattedStr(self.upgradeDef))
  self.equipAddHpText:SetActive(false)
  self.equipAddAtkText:SetActive(false)
  self.equipAddDefText:SetActive(false)
end

local function RefreshHeroInfo(self)
  if not self.curHeroData then
    return
  end
  RefreshHeroBaseInfo(self)
  RefreshHeroBaseProperty(self)
  self:CheckHeroBuildShow()
end

local function UpdateView(self, withProperty)
  RefreshHeroInfo(self)
  RefreshEquipmentSlots(self)
  RefreshQuickEqiupBtnRedPoint(self)
  self:RefreshHeroTryOutBtn()
  self.powerText:SetText(self.curHeroData.power)
  self:ShowPropertyChangeAnim(self.curHeroData.uuid, withProperty)
end

local function SetData(self, heroData)
  self.curSingleClickNum = 0
  if heroData ~= nil then
    self.curHeroData = heroData
    self.isTemplateHero = self.view:IsTemplateHero()
  else
    self.promote_btn:SetActive(false)
    return
  end
  self:RefreshPromotionBtnState()
  self.heroImg:SetHeroIdDynamic(self.curHeroData)
  self.view.ctrl:SaveHeroProp(heroData.uuid)
  SetEquipSlotPosition(self)
  self:UpdateView()
  self.hasSetData = true
  if self.seasonCallbackInfo then
    self.seasonCallbackInfo:TrySetItemById(SeasonCallbackType.Hero, self.curHeroData.heroId)
  end
  if self.armedUpgradeInfoContent then
    self.armedUpgradeInfoContent:ReInit(heroData.heroId)
  end
  self:CheckShowArrowAtQuickEquipBtn()
end

local function OnPointerDown(self)
  self.isClick = true
  self.lastTime = Time.time
end

local function OnPointerUp(self)
  if self.isClick then
    self:OnHeroUpgradeBtnClick()
  end
  self:BreakLongPress()
end

local function Update100MS(self)
  if self.lastTime == nil or self.isUpgradeBtnGray then
    return
  end
  if not self.isLongPress then
    if Time.time - self.lastTime < triggerLongPressTime then
      return
    end
    self.lastTime = Time.time
    self.isLongPress = true
    self.isClick = false
  end
  if Time.time - self.lastTime < longPressInterval then
    return
  end
  if self.upgradeMsgReturn ~= nil and not self.upgradeMsgReturn then
    return
  end
  self.lastTime = Time.time
  self:OnHeroUpgradeBtnClick()
end

local function BreakLongPress(self)
  self.isLongPress = false
  self.lastTime = nil
end

local function OnHeroUpgradeBtnClick(self)
  local heroLevelLimit = DataCenter.BuildManager.MainLv * DataCenter.HeroParamDataManager.heroLevelLimitByCityLevel
  if heroLevelLimit <= self.curHeroData.level then
    UIUtil.ShowTipsId(151105)
    self:BreakLongPress()
    return
  end
  local needExp = HeroUtils.GetLevelUpNeedExp(self.curHeroData.level)
  local hasEnoughExp, expCount = self.view.ctrl:CheckItemsCanToNextLv(self.curHeroData.exp, needExp)
  if not hasEnoughExp then
    if CS.SceneManager:IsInPVE() then
      UIUtil.ShowTipsId("quick_upgrade_tips")
    else
      LWResourceLackUtil:GotoResourceItemLackWithAutoExit(ResourceItemId.HeroExp, needExp, false)
    end
    self:BreakLongPress()
    return
  end
  if self.needResources then
    table.clear(self.needResources)
  else
    self.needResources = {}
  end
  local costResources = HeroUtils.GetLevelUpCostResources(self.curHeroData.level)
  for resourceId, resourceNum in pairs(costResources) do
    local have = LuaEntry.Resource:GetCntByResType(resourceId)
    local cost = resourceNum
    if have < cost then
      table.insert(self.needResources, {resType = resourceId, need = cost})
    end
  end
  if #self.needResources > 0 then
    if CS.SceneManager:IsInPVE() then
      UIUtil.ShowTipsId("quick_upgrade_tips")
    else
      LWResourceLackUtil:GotoResLack(self.needResources)
    end
    self:BreakLongPress()
    return
  end
  self.expBookQualityList = self.view.ctrl:AutoUseExpItems(self.curHeroData.uuid)
  if self.expBookQualityList then
    self.upgradeMsgReturn = false
  else
    self:BreakLongPress()
  end
end

local function CheckHeroBuildShow(self)
  self.btnHeroAirDrop:SetActive(false)
  self.btnHeroTakeBack:SetActive(false)
  if not self.isTemplateHero then
    local inSquad1 = DataCenter.BuildHeroManager:CheckHeroSquad(self.curHeroData.uuid, 1)
    local inSquad2 = DataCenter.BuildHeroManager:CheckHeroSquad(self.curHeroData.uuid, 2)
    local inSquad3 = DataCenter.BuildHeroManager:CheckHeroSquad(self.curHeroData.uuid, 3)
    local inSquad4 = DataCenter.BuildHeroManager:CheckHeroSquad(self.curHeroData.uuid, 4)
    self.iconSquad1:SetActive(inSquad1)
    self.iconSquad2:SetActive(inSquad2)
    self.iconSquad3:SetActive(inSquad3)
    self.iconSquad4:SetActive(inSquad4)
    if inSquad1 or inSquad2 or inSquad3 or inSquad4 then
      return
    end
    if not IsNull(CS.SceneManager) and CS.SceneManager:IsInCity() then
      if self.curHeroData and DataCenter.BuildHeroManager:HasBuildHero(self.curHeroData.heroId) then
        self.btnHeroTakeBack:SetActive(true)
      else
        self.btnHeroAirDrop:SetActive(true)
      end
    end
  end
end

local function OnBtnHeroAirDropClick(self)
  if not self.isTemplateHero then
    self.btnHeroAirDrop:SetActive(false)
    self.btnHeroTakeBack:SetActive(true)
    DataCenter.BuildHeroManager:AddNewHero(self.curHeroData.heroId)
    UIUtil.ShowTipsId(800355)
  end
end

local function OnBtnHeroTakeBackClick(self)
  if not self.isTemplateHero then
    self.btnHeroAirDrop:SetActive(true)
    self.btnHeroTakeBack:SetActive(false)
    DataCenter.BuildHeroManager:DeleteBuildHero(self.curHeroData.heroId)
    UIUtil.ShowTipsId(800357)
  end
end

local function GetHeroSpineContainer(self)
  return self.heroSpineContainer
end

local function CalcHeroHpSource(self)
  local hp = DataCenter.HeroLevelPropertyTemplateManager:GetTemplateHp(self.curHeroData.propertyTemplateType, self.curHeroData.level)
  local factor = self.curHeroData.meta.hpFactor
  local levelVal = math.floor(hp * factor * (1 + self.curHeroData:GetProperty(HeroEffectDefine.HpAddRate) + self.curHeroData:GetProperty(HeroEffectDefine.TankHeroHpAddRate) + self.curHeroData:GetProperty(HeroEffectDefine.MissileHeroHpAddRate) + self.curHeroData:GetProperty(HeroEffectDefine.AircraftHeroHpAddRate)))
  local equipVal = math.floor(self.curHeroData:GetProperty(HeroEffectDefine.Equip_HP_Result))
  local rankVal = math.floor(self.curHeroData:GetProperty(HeroEffectDefine.Hero_HP_Result)) - levelVal
  local buildVal = self.curHeroData:GetBuildingAdditionByType(HeroicForceType.Life)
  local tacticalWeaponVal = math.floor(self.curHeroData:GetProperty(HeroEffectDefine.TacticalWeaponHp_Result))
  local uniqueWeaponVal = math.floor(self.curHeroData:GetProperty(HeroEffectDefine.UniqueWeaponHp_result) + self.curHeroData:GetProperty(HeroEffectDefine.UniqueWeaponHp_UW_Unit_Self) + self.curHeroData:GetProperty(HeroEffectDefine.UniqueWeaponHp_UW_Unit_All))
  local dominatorVal = math.floor(self.curHeroData:GetProperty(HeroEffectDefine.DominatorAffordHeroHp))
  levelVal = math.max(levelVal, 0)
  equipVal = math.max(equipVal, 0)
  rankVal = math.max(rankVal, 0)
  buildVal = math.max(buildVal, 0)
  tacticalWeaponVal = math.max(tacticalWeaponVal, 0)
  uniqueWeaponVal = math.max(uniqueWeaponVal, 0)
  dominatorVal = math.max(dominatorVal, 0)
  local honorVal = math.floor(self.curHeroData:GetProperty(HeroEffectDefine.Honor_HP_Result))
  return levelVal, equipVal, rankVal, buildVal, honorVal, tacticalWeaponVal, uniqueWeaponVal, dominatorVal
end

local function CalcHeroAtkSource(self)
  local atk = DataCenter.HeroLevelPropertyTemplateManager:GetTemplateAtk(self.curHeroData.propertyTemplateType, self.curHeroData.level)
  local factor = self.curHeroData.meta.atkFactor
  local levelVal = math.floor(atk * factor * (1 + self.curHeroData:GetProperty(HeroEffectDefine.AllAttackAddRate) + self.curHeroData:GetProperty(HeroEffectDefine.TankAttackAddRate) + self.curHeroData:GetProperty(HeroEffectDefine.MissileAttackAddRate) + self.curHeroData:GetProperty(HeroEffectDefine.AircraftAttackAddRate)))
  local equipVal = math.floor(self.curHeroData:GetProperty(HeroEffectDefine.Equip_ATK_Result))
  local rankVal = math.floor(self.curHeroData:GetProperty(HeroEffectDefine.Hero_ATK_Result)) - levelVal
  local buildVal = self.curHeroData:GetBuildingAdditionByType(HeroicForceType.Attack)
  local tacticalWeaponVal = math.floor(self.curHeroData:GetProperty(HeroEffectDefine.TacticalWeaponAtk_Result))
  local uniqueWeaponVal = math.floor(self.curHeroData:GetProperty(HeroEffectDefine.UniqueWeaponAtk_result) + self.curHeroData:GetProperty(HeroEffectDefine.UniqueWeaponAtk_UW_Unit_Self) + self.curHeroData:GetProperty(HeroEffectDefine.UniqueWeaponAtk_UW_Unit_All))
  local dominatorVal = math.floor(self.curHeroData:GetProperty(HeroEffectDefine.DominatorAffordHeroAtk))
  levelVal = math.max(levelVal, 0)
  equipVal = math.max(equipVal, 0)
  rankVal = math.max(rankVal, 0)
  buildVal = math.max(buildVal, 0)
  tacticalWeaponVal = math.max(tacticalWeaponVal, 0)
  uniqueWeaponVal = math.max(uniqueWeaponVal, 0)
  dominatorVal = math.max(dominatorVal, 0)
  return levelVal, equipVal, rankVal, buildVal, tacticalWeaponVal, uniqueWeaponVal, dominatorVal
end

local function CalcHeroDefSource(self)
  local def = DataCenter.HeroLevelPropertyTemplateManager:GetTemplateDef(self.curHeroData.propertyTemplateType, self.curHeroData.level)
  local factor = self.curHeroData.meta.defFactor
  local levelVal = math.floor(def * factor * (1 + self.curHeroData:GetProperty(HeroEffectDefine.AllDefenseAddRate) + self.curHeroData:GetProperty(HeroEffectDefine.TankDefenseAddRate) + self.curHeroData:GetProperty(HeroEffectDefine.MissileDefenseAddRate) + self.curHeroData:GetProperty(HeroEffectDefine.AircraftDefenseAddRate)))
  local equipVal = math.floor(self.curHeroData:GetProperty(HeroEffectDefine.Equip_DEF_Result))
  local rankVal = math.floor(self.curHeroData:GetProperty(HeroEffectDefine.Hero_DEF_Result)) - levelVal
  local buildVal = self.curHeroData:GetBuildingAdditionByType(HeroicForceType.Defence)
  local tacticalWeaponVal = math.floor(self.curHeroData:GetProperty(HeroEffectDefine.TacticalWeaponDef_Result))
  local uniqueWeaponVal = math.floor(self.curHeroData:GetProperty(HeroEffectDefine.UniqueWeaponDef_result) + self.curHeroData:GetProperty(HeroEffectDefine.UniqueWeaponDef_UW_Unit_Self) + self.curHeroData:GetProperty(HeroEffectDefine.UniqueWeaponDef_UW_Unit_All))
  local dominatorVal = math.floor(self.curHeroData:GetProperty(HeroEffectDefine.DominatorAffordHeroDef))
  levelVal = math.max(levelVal, 0)
  equipVal = math.max(equipVal, 0)
  rankVal = math.max(rankVal, 0)
  buildVal = math.max(buildVal, 0)
  tacticalWeaponVal = math.max(tacticalWeaponVal, 0)
  uniqueWeaponVal = math.max(uniqueWeaponVal, 0)
  dominatorVal = math.max(dominatorVal, 0)
  return levelVal, equipVal, rankVal, buildVal, tacticalWeaponVal, uniqueWeaponVal, dominatorVal
end

function UIHeroGrowthPage:CalcHeroSCSource()
  return self.curHeroData:CalcHeroSCSource()
end

local function ShowPropertyChangeAnim(self, heroUuid, withProperty)
  local res = self.view.ctrl:GetHeroPropChange(heroUuid)
  if res then
    if withProperty and res.hpChange >= 0 and 0 <= res.atkChange and 0 <= res.defChange then
      self:ShowPropertyChange(res.hpChange, res.atkChange, res.defChange)
    end
    if 0 < res.powerChange then
      self:ShowPowerChange(res.powerChange)
    else
      self.powerText:SetText(self.curHeroData.power)
    end
    self.view.ctrl:SaveHeroProp(heroUuid)
  end
end

local function ShowPropertyChange(self, hp, atk, def)
  local item = self.GetPropertyTemplate(self)
  if self.showPropertyChangeCallBack == nil then
    function self.showPropertyChangeCallBack(i)
      self:RecyclePropertyTemplate(i)
    end
  end
  item:SetDataAndPlay(hp, atk, def, self.showPropertyChangeCallBack)
end

local function RecyclePropertyTemplate(self, item)
  if item and item.gameObject then
    item.gameObject:SetActive(false)
    table.insert(self.propertyChangePool, item)
  end
end

local function GetPropertyTemplate(self)
  if #self.propertyChangePool > 0 then
    local out = self.propertyChangePool[#self.propertyChangePool]
    self.propertyChangePool[#self.propertyChangePool] = nil
    out.transform:SetAsLastSibling()
    out.gameObject:SetActive(true)
    return out
  end
  local go
  go = CS.UnityEngine.GameObject.Instantiate(self.propertyChangePrefab)
  NameCount = NameCount + 1
  local nameStr = tostring(NameCount)
  go.name = nameStr
  go.transform:SetParent(self.propertyChangeContent.transform)
  go.transform:Set_localScale(1, 1, 1)
  go.transform:SetAsLastSibling()
  go.gameObject:SetActive(true)
  local item = self.propertyChangeContent:AddComponent(UIHeroPropertyChangeItem, nameStr)
  return item
end

local function ShowPowerChange(self, power)
  if self.showPowerChangeCallBack == nil then
    function self.showPowerChangeCallBack(i)
      self:RecyclePowerTemplate(i)
    end
  end
  if self.showPowerChangeCallBackStep2 == nil then
    function self.showPowerChangeCallBackStep2()
      if self.powerEffect then
        self.powerEffect:SetActive(false)
        
        self.powerEffect:SetActive(true)
      end
      if self.powerText and self.curHeroData then
        self.powerText:SetText(self.curHeroData.power)
      end
    end
  end
  local path = "Assets/_Art_LastWar/Effect/Prefab/UI/Yingxiongxiangqing/Eff_ui_hero_xiangqing_shengji_jingyan.prefab"
  local src = self.powerChangeContent.transform.position
  local dest = self.powerText.transform.position
  local parent = UIManager:GetInstance():GetLayer(UILayer.TopMost.Name).transform
  DataCenter.FlyController.DoFlyWithBezierFunc(path, src, dest, 1, parent, self.showPowerChangeCallBackStep2)
end

local function RecyclePowerTemplate(self, item)
  item.gameObject:SetActive(false)
  table.insert(self.powerChangePool, item)
end

local function GetPowerTemplate(self)
end

local function ClearTemplatePool(self)
  self.propertyChangeContent:RemoveComponents(UIHeroPropertyChangeItem)
  self.powerChangeContent:RemoveComponents(UIHeroPowerChangeItem)
  self.showPowerChangeCallBack = nil
  self.showPropertyChangeCallBack = nil
  self.showPowerChangeCallBackStep2 = nil
end

local function GetHeroModelContainer(self)
  return self.heroModelContainer
end

function UIHeroGrowthPage:RefreshPromotionBtnState()
  local actData = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.ActHeroPromotion.Type)
  if actData and #actData == 1 then
    self.promoteActivityId = actData[1].id
    self.heroPromoteData = DataCenter.SeasonDataManager:GetHeroCanPromoteData(self.curHeroData.heroId, actData[1].id)
    if self.heroPromoteData then
      local curRankId = self.curHeroData:GetRank()
      local maxRankId = self.curHeroData:GetMaxRank()
      self.promote_btn:SetActive(true)
      local item = DataCenter.ItemData:GetItemById(self.heroPromoteData.costItemId)
      local goods = DataCenter.ItemTemplateManager:GetItemTemplate(self.heroPromoteData.costItemId)
      if item then
        self.text_cost:SetText(tostring(item.count) .. "/" .. tostring(self.heroPromoteData.costCount))
      else
        self.text_cost:SetText(tostring(0) .. "/" .. tostring(self.heroPromoteData.costCount))
      end
      self.img_cost_item1:LoadSprite(string.format(LoadPath.ItemPath, goods.icon))
      self.do_btn_des:SetLocalText("season_hero_promotion_002")
      if curRankId >= maxRankId then
        self.heroPromoteRankCondition = true
        CS.UIGray.SetGray(self.promote_btn.transform, false, true)
      else
        self.heroPromoteRankCondition = false
        CS.UIGray.SetGray(self.promote_btn.transform, true, true)
      end
      return
    end
  end
  self.promote_btn:SetActive(false)
end

function UIHeroGrowthPage:OnPromoteBtnClick()
  if not self.heroPromoteRankCondition then
    UIUtil.ShowTipsId("season_tips170")
    return
  end
  if self:GetCondition() then
    local _actOpen = DataCenter.ActivityListDataManager:CheckIfActivityOpen(EnumActivity.ActHeroPromotion.Type)
    if _actOpen then
      SeasonUtil.OpenSeasonActivityByType(EnumActivity.ActHeroPromotion.Type, nil, self.curHeroData.heroId)
    else
      UIUtil.ShowMessage(Localization:GetString("season_hero_promote_rule"), 2, nil, nil, function()
        if self.curHeroData.heroId > 0 then
          DataCenter.BuildHeroManager:RemoveHeroFromDropList(self.curHeroData.heroId)
        end
        SFSNetwork.SendMessage(MsgDefines.LWSeasonHeroTransition, self.curHeroData.uuid, self.promoteActivityId)
      end, nil, nil, nil, nil, nil, nil, nil, nil, nil, CS.UnityEngine.TextAnchor.UpperLeft)
    end
  end
end

function UIHeroGrowthPage:GetCondition()
  if self.heroPromoteData then
    local item = DataCenter.ItemData:GetItemById(self.heroPromoteData.costItemId)
    if item then
      if self.heroPromoteData.costCount <= item.count then
        return true
      else
        if CS.SceneManager:IsInPVE() then
          UIUtil.ShowTipsId("quick_upgrade_tips")
        else
          LWResourceLackUtil:GotoGoodsItemLack(self.heroPromoteData.costItemId, self.heroPromoteData.costCount)
        end
        return false
      end
    else
      if CS.SceneManager:IsInPVE() then
        UIUtil.ShowTipsId("quick_upgrade_tips")
      else
        LWResourceLackUtil:GotoGoodsItemLack(self.heroPromoteData.costItemId, self.heroPromoteData.costCount)
      end
      return false
    end
  end
  return false
end

function UIHeroGrowthPage:PromoteSuccess(heroId)
  self.view.ctrl:GetAllExpItems()
  GoToUtil.CloseAllWindows()
  local title = Localization:GetString("season_hero_promotion_005")
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWCommonHeroCardShow, heroId, title, self.activityId)
end

function UIHeroGrowthPage:RefreshHeroTryOutBtn()
  local isShow = false
  if self.curHeroData and self.curHeroData.heroId > 0 and DataCenter.HeroTryOutManager:IsShowHeroTryOutEntrance(self.curHeroData.heroId) then
    isShow = true
    local showRed = DataCenter.HeroTryOutManager:IsShowEntranceRedByHeroId(self.curHeroData.heroId)
    self.redHeroTryOut:SetActive(showRed)
  end
  self.btnHeroTryOut:SetActive(isShow)
end

function UIHeroGrowthPage:OnBtnHeroTryOutClick()
  if CS.SceneManager:IsInPVE() then
    UIUtil.ShowTipsId("quick_upgrade_block_tips")
    return
  end
  if self.curHeroData and self.curHeroData.heroId > 0 then
    if DataCenter.HeroTryOutManager:IsShowHeroTryOutEntrance(self.curHeroData.heroId) then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWHeroTryOutTask, {anim = true}, self.curHeroData.heroId)
      self.redHeroTryOut:SetActive(false)
      DataCenter.HeroTryOutManager:SetHasShownHeroDetailEntranceRed(self.curHeroData.heroId)
    else
      DataCenter.HeroTryOutManager:PrintRealInfoLog("click when data is not valid")
    end
  end
end

function UIHeroGrowthPage:CheckShowArrowAtQuickEquipBtn()
  self.curHeroUuid, self.heroUuidList, self.callBack, self.guideArrowData = self.view:GetUserData()
  if not (self.guideArrowData and self.guideArrowData.showQuickEquipBtnGuide) or self.isShowedQuickEquipGuide then
    return
  end
  local param = {}
  param.positionType = PositionType.Screen
  param.position = self.quickEquipBtn.transform.position + Vector3.New(50, -50, 0)
  param.isAutoClose = 1
  DataCenter.ArrowManager:ShowFingerArrow(param)
  self.isShowedQuickEquipGuide = true
end

UIHeroGrowthPage.OnCreate = OnCreate
UIHeroGrowthPage.OnDestroy = OnDestroy
UIHeroGrowthPage.OnEnable = OnEnable
UIHeroGrowthPage.OnDisable = OnDisable
UIHeroGrowthPage.OnAddListener = OnAddListener
UIHeroGrowthPage.OnRemoveListener = OnRemoveListener
UIHeroGrowthPage.ComponentDefine = ComponentDefine
UIHeroGrowthPage.DataDefine = DataDefine
UIHeroGrowthPage.ComponentDestroy = ComponentDestroy
UIHeroGrowthPage.DataDestroy = DataDestroy
UIHeroGrowthPage.UpdateView = UpdateView
UIHeroGrowthPage.OnHeroEquipUpgrade = OnHeroEquipUpgrade
UIHeroGrowthPage.OnHeroEquipChange = OnHeroEquipChange
UIHeroGrowthPage.SetData = SetData
UIHeroGrowthPage.RefreshUpgradeBtn = RefreshUpgradeBtn
UIHeroGrowthPage.OnPointerDown = OnPointerDown
UIHeroGrowthPage.OnPointerUp = OnPointerUp
UIHeroGrowthPage.Update100MS = Update100MS
UIHeroGrowthPage.BreakLongPress = BreakLongPress
UIHeroGrowthPage.OnHeroUpgradeBtnClick = OnHeroUpgradeBtnClick
UIHeroGrowthPage.CheckHeroBuildShow = CheckHeroBuildShow
UIHeroGrowthPage.OnBtnHeroAirDropClick = OnBtnHeroAirDropClick
UIHeroGrowthPage.OnBtnHeroTakeBackClick = OnBtnHeroTakeBackClick
UIHeroGrowthPage.OnQuickUninstallAllBtnClick = OnQuickUninstallAllBtnClick
UIHeroGrowthPage.OnHeroUpgrade = OnHeroUpgrade
UIHeroGrowthPage.GetHeroSpineContainer = GetHeroSpineContainer
UIHeroGrowthPage.ShowFlushEffect = ShowFlushEffect
UIHeroGrowthPage.HideFlushEffect = HideFlushEffect
UIHeroGrowthPage.CalcHeroHpSource = CalcHeroHpSource
UIHeroGrowthPage.CalcHeroAtkSource = CalcHeroAtkSource
UIHeroGrowthPage.CalcHeroDefSource = CalcHeroDefSource
UIHeroGrowthPage.ShowPropertyChange = ShowPropertyChange
UIHeroGrowthPage.RecyclePropertyTemplate = RecyclePropertyTemplate
UIHeroGrowthPage.GetPropertyTemplate = GetPropertyTemplate
UIHeroGrowthPage.ShowPropertyChangeAnim = ShowPropertyChangeAnim
UIHeroGrowthPage.ShowPowerChange = ShowPowerChange
UIHeroGrowthPage.RecyclePowerTemplate = RecyclePowerTemplate
UIHeroGrowthPage.GetPowerTemplate = GetPowerTemplate
UIHeroGrowthPage.ClearTemplatePool = ClearTemplatePool
UIHeroGrowthPage.GetHeroModelContainer = GetHeroModelContainer
UIHeroGrowthPage.OnHeroEquipRecommendSwitch = OnHeroEquipRecommendSwitch
return UIHeroGrowthPage
