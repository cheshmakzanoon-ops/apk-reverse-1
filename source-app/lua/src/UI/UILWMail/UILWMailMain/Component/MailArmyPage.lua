local MailArmyPage = BaseClass("MailArmyPage", UIBaseContainer)
local base = UIBaseContainer
local UILWScienceMainItem = require("UI.UILWScience.UILWScienceMain.Component.UILWScienceMainItem")
local SciBarItem = require("UI.UILWMail.UILWMailMain.Component.SciBarItem")
local UILWSquadEquipItem = require("UI.UILWSquadEquipPanel.Component.UILWSquadEquipItem")
local MailDecoItem = require("UI.UILWMail.UILWMailMain.Component.MailDecoItem")
local MailArmyItem = require("UI.UILWMail.UILWMailMain.Component.MailArmyItemNew")
local MailHonorItem = require("UI.UILWMail.UILWMailMain.Component.MailHonorItem")
local MailOtherItem = require("UI.UILWMail.UILWMailMain.Component.MailOtherItem")
local UILWTacticalWeaponItem = require("UI.UILWTacticalWeapon.Component.UILWTacticalWeaponItem")
local UIHeroSkillItem = require("UI.UILWHero.UIHeroDetailPanel.Component/UIHeroSkillItem")
local MailBattleParseHelper = require("DataCenter.MailData.MailBattleParseHelper")
local SkillChipItem = require("UI.UILWTacticalWeapon.Component.SkillChipPage.SkillChipItem")
local DecoBarItem = require("UI.UILWMail.UILWMailMain.Component.MailBattle.DecoBarItem")
local WeaponAttriLine = require("UI.UILWMail.UILWMailMain.Component.MailBattle.WeaponAttriLine")
local OtherBarItem = require("UI.UILWMail.UILWMailMain.Component.MailBattle.OtherBarItem")
local DominatorView = require("UI.UILWMail.UILWMailMain.Component.MailBattle.DominatorView")
local PowerSliderContent = require("UI.UILWMail.UILWMailMain.Component.MailBattle.PowerSliderContent")
local TacticalCardView = require("UI.UILWMail.UILWMailMain.Component.MailBattle.TacticalCard.TacticalCardView")
local PowerSliderContentAsync = require("UI.UILWMail.UILWMailMain.Component.MailBattle.PowerSliderContentAsync")
local T11SoldierBattleReportComponent = require("UI.UILWMail.UILWMailMain.Component.MailBattle.SoldierEleven.T11SoldierBattleReportComponent")
local UILWMailBattleSkinViewComponent = require("UI.UILWMail.UILWMailMain.Component.MailSkin.UILWMailBattleSkinViewComponent")
local Localization = CS.GameEntry.Localization
local SquadLangKey = {
  [0] = 800351,
  [1] = 800351,
  [2] = 800352,
  [3] = 800353,
  [4] = 800354
}

function MailArmyPage:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function MailArmyPage:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function MailArmyPage:DataDefine()
end

function MailArmyPage:DataDestroy()
end

function MailArmyPage:OnEnable()
  base.OnEnable(self)
end

function MailArmyPage:OnDisable()
  base.OnDisable(self)
end

function MailArmyPage:OnAddListener()
  base.OnAddListener(self)
end

function MailArmyPage:OnRemoveListener()
  base.OnRemoveListener(self)
end

function MailArmyPage:ComponentDefine()
  self.OverTitleText = self:AddComponent(UIText, "OverView/OverTitle/OverTitleLine/OverTitleText")
  self.OverTitleText:SetLocalText(GameDialogDefine.OVER_ALL)
  self.OverPower1 = self:AddComponent(UIText, "OverView/OverTitle/OverPower1")
  self.OverPower2 = self:AddComponent(UIText, "OverView/OverTitle/OverPower2")
  self.leaderHead1 = self:AddComponent(UICommonHead, "OverView/PlayerHeadContent/head1")
  self.leaderHead2 = self:AddComponent(UICommonHead, "OverView/PlayerHeadContent/head2")
  self.leaderName1 = self:AddComponent(UIText, "OverView/PlayerHeadContent/PlayerName1")
  self.leaderName2 = self:AddComponent(UIText, "OverView/PlayerHeadContent/PlayerName2")
  self.leaderLv1 = self:AddComponent(UIText, "OverView/PlayerHeadContent/PlayerLevel1")
  self.leaderLv2 = self:AddComponent(UIText, "OverView/PlayerHeadContent/PlayerLevel2")
  self.squad1 = self:AddComponent(UIText, "OverView/PlayerHeadContent/Squad1")
  self.squad2 = self:AddComponent(UIText, "OverView/PlayerHeadContent/Squad2")
  self.EquipSlider1 = self:AddComponent(UISlider, "OverView/OverContent/EquipSliderContent/EquipSlider1")
  self.EquipSlider2 = self:AddComponent(UISlider, "OverView/OverContent/EquipSliderContent/EquipSlider2")
  self.EquipSliderText1 = self:AddComponent(UIText, "OverView/OverContent/EquipSliderContent/EquipSlider1/EquipSliderText1")
  self.EquipSliderText2 = self:AddComponent(UIText, "OverView/OverContent/EquipSliderContent/EquipSlider2/EquipSliderText2")
  self.SciSlider1 = self:AddComponent(UISlider, "OverView/OverContent/SciSliderContent/SciSlider1")
  self.SciSlider2 = self:AddComponent(UISlider, "OverView/OverContent/SciSliderContent/SciSlider2")
  self.SciSliderText1 = self:AddComponent(UIText, "OverView/OverContent/SciSliderContent/SciSlider1/SciSliderText1")
  self.SciSliderText2 = self:AddComponent(UIText, "OverView/OverContent/SciSliderContent/SciSlider2/SciSliderText2")
  self.DecoSlider1 = self:AddComponent(UISlider, "OverView/OverContent/DecoSliderContent/DecoSlider1")
  self.DecoSlider2 = self:AddComponent(UISlider, "OverView/OverContent/DecoSliderContent/DecoSlider2")
  self.DecoSliderText1 = self:AddComponent(UIText, "OverView/OverContent/DecoSliderContent/DecoSlider1/DecoSliderText1")
  self.DecoSliderText2 = self:AddComponent(UIText, "OverView/OverContent/DecoSliderContent/DecoSlider2/DecoSliderText2")
  self.SoldierSlider1 = self:AddComponent(UISlider, "OverView/OverContent/SoldierSliderContent/SoldierSlider1")
  self.SoldierSlider2 = self:AddComponent(UISlider, "OverView/OverContent/SoldierSliderContent/SoldierSlider2")
  self.SoldierSliderText1 = self:AddComponent(UIText, "OverView/OverContent/SoldierSliderContent/SoldierSlider1/SoldierSliderText1")
  self.SoldierSliderText2 = self:AddComponent(UIText, "OverView/OverContent/SoldierSliderContent/SoldierSlider2/SoldierSliderText2")
  self.honorWallSlider1 = self:AddComponent(UISlider, "OverView/OverContent/HonorWallSliderContent/HonorWallSlider1")
  self.honorWallSlider2 = self:AddComponent(UISlider, "OverView/OverContent/HonorWallSliderContent/HonorWallSlider2")
  self.honorWallSliderText1 = self:AddComponent(UIText, "OverView/OverContent/HonorWallSliderContent/HonorWallSlider1/HonorWallText1")
  self.honorWallSliderText2 = self:AddComponent(UIText, "OverView/OverContent/HonorWallSliderContent/HonorWallSlider2/HonorWallText2")
  self.honorWallSliderContent = self.transform:Find("OverView/OverContent/HonorWallSliderContent").gameObject
  self.otherSlider1 = self:AddComponent(UISlider, "OverView/OverContent/OtherContent/OtherSlider1")
  self.otherSlider2 = self:AddComponent(UISlider, "OverView/OverContent/OtherContent/OtherSlider2")
  self.otherSliderText1 = self:AddComponent(UIText, "OverView/OverContent/OtherContent/OtherSlider1/OtherText1")
  self.otherSliderText2 = self:AddComponent(UIText, "OverView/OverContent/OtherContent/OtherSlider2/OtherText2")
  self.otherSliderContent = self.transform:Find("OverView/OverContent/OtherContent").gameObject
  self.dominatorSliderContent = self:AddComponent(UIBaseContainer, "OverView/OverContent/DominatorSliderContent")
  self.tacticalCardSliderContent = self:AddComponent(UIBaseContainer, "OverView/OverContent/TacticalCardSliderContent")
  self.skinSliderContent = self:AddComponent(UIBaseContainer, "OverView/OverContent/SkinSliderContent")
  self.overTitle_btn = self:AddComponent(UIButton, "OverView/OverTitle/OverTitleLine/detail_btn")
  self.overTitle_btn:SetOnClick(function()
    local param = DataCenter.ArrowTipParamManager:Get(ArrowTipEnumtype.Type.HeroSimpleTip)
    param.title = nil
    param.content = Localization:GetString("power_display_new200")
    param.alignObject = self.OverTitleText.transform
    param.yPosFix = -40
    param.width = 400
    param.showArrow = false
    param.preferTop = true
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroSimpleTip, {anim = true}, param)
  end)
  self.overTitle_btn:SetActive(false)
  local EquipTitleText = self:AddComponent(UIText, "EquipView/EquipTitle/EquipTitleText")
  EquipTitleText:SetLocalText(2000530)
  self.EquipPower1 = self:AddComponent(UIText, "EquipView/EquipTitle/EquipPower1")
  self.EquipPower2 = self:AddComponent(UIText, "EquipView/EquipTitle/EquipPower2")
  self.equipReqs = {}
  self.EquipContent1 = self:AddComponent(UIBaseContainer, "EquipView/EquipContent/Equips/EquipLeft")
  self.EquipContent2 = self:AddComponent(UIBaseContainer, "EquipView/EquipContent/Equips/EquipRight")
  self.weaponContent = self:AddComponent(UIBaseContainer, "EquipView/WeaponContent")
  self.weaponLeft = self:AddComponent(UIBaseContainer, "EquipView/WeaponContent/Weapons/WeaponLeft")
  self.weaponRight = self:AddComponent(UIBaseContainer, "EquipView/WeaponContent/Weapons/WeaponRight")
  self.weaponReqs = {}
  self.weaponSkillReqs = {}
  self.leftSkillChips = self:AddComponent(UIBaseContainer, "EquipView/ChipContent/Chips/LeftSkillChips")
  self.rightSkillChips = self:AddComponent(UIBaseContainer, "EquipView/ChipContent/Chips/RightSkillChips")
  self.skillChipContent = self:AddComponent(UIBaseContainer, "EquipView/ChipContent")
  self.weaponAttriContent = self:AddComponent(UIBaseContainer, "EquipView/AttriContent")
  self.SciTitleText = self:AddComponent(UIText, "SciView/SciTitle/SciTitleLine/SciText")
  self.SciTitleText:SetLocalText(100025)
  self.sciDetail_btn = self:AddComponent(UIButton, "SciView/SciTitle/SciTitleLine/sciDetail_btn")
  self.sciDetail_btn:SetOnClick(function()
    local param = DataCenter.ArrowTipParamManager:Get(ArrowTipEnumtype.Type.HeroSimpleTip)
    param.title = nil
    param.content = Localization:GetString("power_display_new205")
    param.alignObject = self.SciTitleText.transform
    param.yPosFix = -40
    param.width = 400
    param.showArrow = false
    param.preferTop = true
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroSimpleTip, {anim = true}, param)
  end)
  self.sciDetail_btn:SetActive(false)
  self.SciPower1 = self:AddComponent(UIText, "SciView/SciTitle/SciPower1")
  self.SciPower2 = self:AddComponent(UIText, "SciView/SciTitle/SciPower2")
  self.SciContent1 = self:AddComponent(UIBaseContainer, "SciView/SciContent/SciLeft")
  self.SciContent2 = self:AddComponent(UIBaseContainer, "SciView/SciContent/SciRight")
  self.SciItemPrefab = self.transform:Find("SciView/SciContent/SciLeft/UILWScienceMainItem").gameObject
  self.SciItemPrefab:GameObjectCreatePool()
  self.SciItemPrefab:SetActive(false)
  self.SciDropdown = self:AddComponent(UIBaseComponent, "SciView/SciDropdown")
  self.SciToggle = self:AddComponent(UIToggle, "SciView/SciDropdown/DropdownTxt/SciToggle")
  self.SciToggle:SetOnValueChanged(function(bool)
    self:OnClickSciToggle(bool)
  end)
  self.SciBarList = self:AddComponent(UIBaseContainer, "SciView/SciBarList")
  local DecoTitleText = self:AddComponent(UIText, "DecoView/DecoTitle/DecoTitleText")
  DecoTitleText:SetLocalText(100071)
  self.DecoPower1 = self:AddComponent(UIText, "DecoView/DecoTitle/DecoPower1")
  self.DecoPower2 = self:AddComponent(UIText, "DecoView/DecoTitle/DecoPower2")
  self.DecoContent = self:AddComponent(UIBaseContainer, "DecoView/DecoContent")
  self.DecoDropDown = self:AddComponent(UIBaseComponent, "DecoView/DecoDropdown")
  self.DecoToggle = self:AddComponent(UIToggle, "DecoView/DecoDropdown/DropdownTxt/DecoToggle")
  self.DecoToggle:SetOnValueChanged(function(bool)
    self:OnClickDecoToggle(bool)
  end)
  self.DecoBarList = self:AddComponent(UIBaseContainer, "DecoView/DecoBarList")
  local ArmyTitleText = self:AddComponent(UIText, "ArmyView/ArmyTitle/ArmyTitleText")
  ArmyTitleText:SetLocalText(150128)
  self.ArmyPower1 = self:AddComponent(UIText, "ArmyView/ArmyTitle/ArmyPower1")
  self.ArmyPower2 = self:AddComponent(UIText, "ArmyView/ArmyTitle/ArmyPower2")
  self.armyReqs = {}
  self.ArmyContent = self:AddComponent(UIBaseContainer, "ArmyView/ArmyContent")
  self.ArmyViewRoot = self.transform:Find("ArmyView").gameObject
  self.leftSoldierTotalMoraleText = self:AddComponent(UIText, "ArmyView/ArmyMoraleTotalContent/LeftSoldierTotalMoraleText")
  self.rightSoldierTotalMoraleText = self:AddComponent(UIText, "ArmyView/ArmyMoraleTotalContent/RightSoldierTotalMoraleText")
  self.leftSoldierTotalNumText = self:AddComponent(UIText, "ArmyView/ArmyMoraleTotalContent/LeftSoldierTotalNumText")
  self.rightSoldierTotalNumText = self:AddComponent(UIText, "ArmyView/ArmyMoraleTotalContent/RightSoldierTotalNumText")
  self.soldierMoraleTipsText = self:AddComponent(UIText, "ArmyView/Warning/warnText")
  self.armyMoraleTotalContent = self.transform:Find("ArmyView/ArmyMoraleTotalContent").gameObject
  self.soldierMoraleTipsContent = self.transform:Find("ArmyView/Warning").gameObject
  self.honorView = self.transform:Find("HonorView").gameObject
  self.honorTitleText = self:AddComponent(UIText, "HonorView/HonorTitle/TitleRoot/HonorTitleText")
  self.honorTitleText:SetLocalText(130199)
  self.honorPower1Text = self:AddComponent(UIText, "HonorView/HonorTitle/HonorPower1")
  self.honorPower2Text = self:AddComponent(UIText, "HonorView/HonorTitle/HonorPower2")
  self.honorReqs = {}
  self.honorContent = self:AddComponent(UIBaseContainer, "HonorView/HonorContent")
  self.otherView = self.transform:Find("OtherView").gameObject
  self.otherDetailArrObj = self:AddComponent(UIBaseContainer, "OtherView/OtherDropdown")
  self.otherTitleText = self:AddComponent(UIText, "OtherView/OtherTitle/TitleRoot/OtherTitleText")
  self.otherTitleText:SetLocalText("power_display_new_104")
  self.otherPower1Text = self:AddComponent(UIText, "OtherView/OtherTitle/OtherPower1")
  self.otherPower2Text = self:AddComponent(UIText, "OtherView/OtherTitle/OtherPower2")
  self.otherReqs = {}
  self.otherContent = self:AddComponent(UIBaseContainer, "OtherView/OtherContent")
  self.otherToggle = self:AddComponent(UIToggle, "OtherView/OtherDropdown/DropdownTxt/OtherToggle")
  self.otherToggle:SetOnValueChanged(function(bool)
    self:OnClickOtherToggle(bool)
  end)
  self.OtherBarList = self:AddComponent(UIBaseContainer, "OtherView/OtherBarList")
  self.dominatorConatiner = self:AddComponent(UIBaseContainer, "DominatorContainer")
  self.tacticalCardContainer = self:AddComponent(UIBaseContainer, "TacticalCardContainer")
  self.soldierElevenContainer = self:AddComponent(UIBaseContainer, "T11SoldierContainer")
  self.skinContainer = self:AddComponent(UIBaseContainer, "SkinContainer")
end

function MailArmyPage:ComponentDestroy()
  self:ClearPowerSliders()
  self:ClearWeaponAttrs()
  self:RemoveSciItems()
  self:RemoveSciBars()
  self:RemoveEquipItems()
  self:RemoveDecoItems()
  self:RemoveDecoBars()
  self:RemoveArmyItems()
  self:RemoveHonorItems()
  self:RemoveOtherItems()
  self.SciItemPrefab = nil
end

function MailArmyPage:Refresh(extData)
  self.extData = extData
  self:PrepareData()
  self:RefreshView()
end

function MailArmyPage:PrepareData()
  self.progress1 = self.extData.player[1].progress
  self.progress2 = self.extData.player[2].progress
  self.totalPower1 = self.extData.player[1].soldierPowerBeforeStart + self.progress1.formationEquipPower + self.progress1.sciencePower + self.progress1.decoPower + self.progress1.honorPower
  self.totalPower2 = self.extData.player[2].soldierPowerBeforeStart + self.progress2.formationEquipPower + self.progress2.sciencePower + self.progress2.decoPower + self.progress2.honorPower
  self.sortedDecoEffects = nil
  if self.progress1 and self.progress1.dominator then
    self.totalPower1 = self.totalPower1 + self.progress1.dominator.power
  end
  if self.progress2 and self.progress2.dominator then
    self.totalPower2 = self.totalPower2 + self.progress2.dominator.power
  end
  if self.extData.player[1] and self.extData.player[1].battleCard then
    self.totalPower1 = self.totalPower1 + self.extData.player[1].battleCard.power
  end
  if self.extData.player[2] and self.extData.player[2].battleCard then
    self.totalPower2 = self.totalPower2 + self.extData.player[2].battleCard.power
  end
  if self.progress1 and self.progress1.skinProgress then
    self.totalPower1 = self.totalPower1 + self.progress1.skinProgress.power
  end
  if self.progress2 and self.progress2.skinProgress then
    self.totalPower2 = self.totalPower2 + self.progress2.skinProgress.power
  end
end

function MailArmyPage:RefreshView()
  self:RefreshOverView()
  self:RefreshEquipView()
  self:RefreshSciView()
  self:RefreshDecoView()
  self:RefreshArmyView()
  self:RefreshHonorView()
  self:RefreshOtherPower()
  self:RefreshDominator()
  self:RefreshTacticalCard()
  self:RefreshSoldierEleven()
  self:RefreshSkinDecoration()
end

local SHOW_TITLE_LINE_VERSION = 5
local SHOW_SCI_DETAIL_VERSION = 6
local POWERSLIDERCONTENT_PREFAB_PATH = "Assets/Main/Prefabs/UI/LWMail/MailBattle/PowerSliderContent.prefab"

function MailArmyPage:RefreshOverView()
  local data = self.extData
  local player1 = data.player[1]
  local player2 = data.player[2]
  self.OverPower1:SetLocalText(GameDialogDefine.BATTLE_POWER, string.GetFormattedStr(math.floor(self.totalPower1)))
  self.OverPower2:SetLocalText(GameDialogDefine.BATTLE_POWER, string.GetFormattedStr(math.floor(self.totalPower2)))
  if MailBattleParseHelper.IsWerewolf(player1) then
    self.leaderHead1:ShowWerewolf()
    self.leaderName1:SetLocalText(GameDialogDefine.WEREWOLF)
  else
    self.leaderHead1:SetHead(player1.uid, player1.pic, player1.picVer, nil, player1.frameBg)
    self.leaderName1:SetText(player1.abbrName)
  end
  if MailBattleParseHelper.IsWerewolf(player2) then
    self.leaderHead2:ShowWerewolf()
    self.leaderName2:SetLocalText(GameDialogDefine.WEREWOLF)
  else
    self.leaderHead2:SetHead(player2.uid, player2.pic, player2.picVer, nil, player2.frameBg)
    self.leaderName2:SetText(player2.abbrName)
  end
  self.leaderLv1:SetText("Lv." .. player1.user.level)
  self.leaderLv2:SetText("Lv." .. player2.user.level)
  self.squad1:SetLocalText(SquadLangKey[player1.contentId])
  self.squad2:SetLocalText(SquadLangKey[player2.contentId])
  local maxEquipPower = math.max(self.progress1.formationEquipPower, self.progress2.formationEquipPower)
  maxEquipPower = math.max(maxEquipPower, 1)
  local maxSciPower = math.max(self.progress1.sciencePower, self.progress2.sciencePower)
  maxSciPower = math.max(maxSciPower, 1)
  local maxDecoPower = math.max(self.progress1.decoPower, self.progress2.decoPower)
  maxDecoPower = math.max(maxDecoPower, 1)
  local maxSoldierPower = math.max(player1.soldierPowerBeforeStart, player2.soldierPowerBeforeStart)
  maxSoldierPower = math.max(maxSoldierPower, 1)
  local maxHonorPower = math.max(self.progress1.honorPower, self.progress2.honorPower)
  maxHonorPower = math.max(maxHonorPower, 1)
  local version = data:GetVersion()
  if version >= SHOW_TITLE_LINE_VERSION then
    self.overTitle_btn:SetActive(true)
  else
    self.overTitle_btn:SetActive(false)
  end
  self.EquipSlider1:SetValue(self.progress1.formationEquipPower / maxEquipPower)
  self.EquipSlider2:SetValue(self.progress2.formationEquipPower / maxEquipPower)
  self.EquipSliderText1:SetText(string.GetFormattedStr(self.progress1.formationEquipPower))
  self.EquipSliderText2:SetText(string.GetFormattedStr(self.progress2.formationEquipPower))
  self.SciSlider1:SetValue(self.progress1.sciencePower / maxSciPower)
  self.SciSlider2:SetValue(self.progress2.sciencePower / maxSciPower)
  self.SciSliderText1:SetText(string.GetFormattedStr(self.progress1.sciencePower))
  self.SciSliderText2:SetText(string.GetFormattedStr(self.progress2.sciencePower))
  self.DecoSlider1:SetValue(self.progress1.decoPower / maxDecoPower)
  self.DecoSlider2:SetValue(self.progress2.decoPower / maxDecoPower)
  self.DecoSliderText1:SetText(string.GetFormattedStr(self.progress1.decoPower))
  self.DecoSliderText2:SetText(string.GetFormattedStr(self.progress2.decoPower))
  self.SoldierSlider1:SetValue(player1.soldierPowerBeforeStart / maxSoldierPower)
  self.SoldierSlider2:SetValue(player2.soldierPowerBeforeStart / maxSoldierPower)
  self.SoldierSliderText1:SetText(string.GetFormattedStr(player1.soldierPowerBeforeStart))
  self.SoldierSliderText2:SetText(string.GetFormattedStr(player2.soldierPowerBeforeStart))
  local honorWall1 = self.progress1.honorWall or {}
  local honorWall2 = self.progress2.honorWall or {}
  if #honorWall1 == 0 and #honorWall2 == 0 then
    self.honorWallSliderContent:SetActive(false)
  else
    self.honorWallSliderContent:SetActive(true)
    self.honorWallSlider1:SetValue(self.progress1.honorPower / maxHonorPower)
    self.honorWallSlider2:SetValue(self.progress2.honorPower / maxHonorPower)
    self.honorWallSliderText1:SetText(string.GetFormattedStr(self.progress1.honorPower))
    self.honorWallSliderText2:SetText(string.GetFormattedStr(self.progress2.honorPower))
  end
  local playerOtherPower1 = self:GetOtherPowerValue(player1)
  local playerOtherPower2 = self:GetOtherPowerValue(player2)
  local maxOtherPower = math.max(playerOtherPower1, playerOtherPower2)
  maxOtherPower = math.max(maxOtherPower, 1)
  if playerOtherPower1 == 0 and playerOtherPower2 == 0 then
    self.otherSliderContent:SetActive(false)
  else
    self.otherSliderContent:SetActive(true)
    self.otherSlider1:SetValue(playerOtherPower1 / maxOtherPower)
    self.otherSlider2:SetValue(playerOtherPower2 / maxOtherPower)
    self.otherSliderText1:SetText(string.GetFormattedStr(playerOtherPower1))
    self.otherSliderText2:SetText(string.GetFormattedStr(playerOtherPower2))
  end
  local dominatorPower1 = 0
  if self.progress1 and self.progress1.dominator then
    dominatorPower1 = self.progress1.dominator.power
  end
  local dominatorPower2 = 0
  if self.progress2 and self.progress2.dominator then
    dominatorPower2 = self.progress2.dominator.power
  end
  self:ClearPowerSliders()
  if 0 < dominatorPower1 or 0 < dominatorPower2 then
    self.dominatorSliderContent:SetActive(true)
    if not self.dominatorPowerSlider then
      self.dominatorPowerSlider = self:LoadComponentAsync(PowerSliderContentAsync, POWERSLIDERCONTENT_PREFAB_PATH, self.dominatorSliderContent)
    end
    self.dominatorPowerSlider:SetData(dominatorPower1, dominatorPower2, Localization:GetString("dominator_name"), "Assets/Main/Sprites/UI/UILWMail/zxl_youjian_zhuzai.png")
  else
    self.dominatorSliderContent:SetActive(false)
  end
  local tacticalCardPower1 = 0
  local tacticalCardPower2 = 0
  if self.extData.player[1] and self.extData.player[1].battleCard then
    tacticalCardPower1 = self.extData.player[1].battleCard.power
  end
  if self.extData.player[2] and self.extData.player[2].battleCard then
    tacticalCardPower2 = self.extData.player[2].battleCard.power
  end
  if 0 < tacticalCardPower1 or 0 < tacticalCardPower2 then
    self.tacticalCardSliderContent:SetActive(true)
    if not self.tacticalCardPowerSlider then
      self.tacticalCardPowerSlider = self:LoadComponentAsync(PowerSliderContentAsync, POWERSLIDERCONTENT_PREFAB_PATH, self.tacticalCardSliderContent)
    end
    self.tacticalCardPowerSlider:SetData(tacticalCardPower1, tacticalCardPower2, Localization:GetString("battle_card_report_title"), UIAssets.TacticalCardSystemIcon)
  else
    self.tacticalCardSliderContent:SetActive(false)
  end
  local skinPower1 = 0
  local skinPower2 = 0
  if self.progress1 and self.progress1.skinProgress then
    skinPower1 = self.progress1.skinProgress.power
  end
  if self.progress2 and self.progress2.skinProgress then
    skinPower2 = self.progress2.skinProgress.power
  end
  if 0 < skinPower1 or 0 < skinPower2 then
    self.skinSliderContent:SetActive(true)
    if not self.skinPowerSlider then
      self.skinPowerSlider = self:LoadComponentAsync(PowerSliderContentAsync, POWERSLIDERCONTENT_PREFAB_PATH, self.skinSliderContent)
    end
    self.skinPowerSlider:SetData(skinPower1, skinPower2, Localization:GetString(2900047), UIAssets.MailSkinSystemIcon)
  else
    self.skinSliderContent:SetActive(false)
  end
end

function MailArmyPage:ClearPowerSliders()
  if self.dominatorPowerSlider then
    self:RemoveAsyncComponent(self.dominatorPowerSlider)
    self.dominatorPowerSlider = nil
  end
  if self.tacticalCardPowerSlider then
    self:RemoveAsyncComponent(self.tacticalCardPowerSlider)
    self.tacticalCardPowerSlider = nil
  end
  if self.skinPowerSlider then
    self:RemoveAsyncComponent(self.skinPowerSlider)
    self.skinPowerSlider = nil
  end
end

function MailArmyPage:ClearWeaponAttrs()
  self.weaponAttriContent:RemoveComponents(WeaponAttriLine)
  if self.weaponAttrReqs then
    for _, v in pairs(self.weaponAttrReqs) do
      self:GameObjectDestroy(v)
    end
  end
  self.weaponAttrReqs = {}
end

function MailArmyPage:RefreshEquipView()
  self:RemoveEquipItems()
  local equipData1 = {
    [1] = 1,
    [2] = 2,
    [3] = 3,
    [4] = 4,
    [5] = 5
  }
  local equipData2 = {
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
  local expList1 = self.progress1.exp
  if expList1 and #expList1 == #self.progress1.equipId then
    for i, v in ipairs(self.progress1.equipId) do
      local equipData = CommonEquipInfo.New()
      equipData:UpdateInfo({
        cfgId = v,
        exp = expList1[i]
      })
      equipData1[equipData:GetConfigSlot()] = equipData
    end
  else
    for _, v in ipairs(self.progress1.equipId) do
      local equipData = CommonEquipInfo.New()
      equipData:UpdateInfo({cfgId = v})
      equipData1[equipData:GetConfigSlot()] = equipData
    end
  end
  local expList2 = self.progress2.exp
  if expList2 and #expList2 == #self.progress2.equipId then
    for i, v in ipairs(self.progress2.equipId) do
      local equipData = CommonEquipInfo.New()
      equipData:UpdateInfo({
        cfgId = v,
        exp = expList2[i]
      })
      equipData2[equipData:GetConfigSlot()] = equipData
    end
  else
    for _, v in ipairs(self.progress2.equipId) do
      local equipData = CommonEquipInfo.New()
      equipData:UpdateInfo({cfgId = v})
      equipData2[equipData:GetConfigSlot()] = equipData
    end
  end
  for i = 1, 6 do
    self.equipReqs[i] = self:GameObjectInstantiateAsync(UIAssets.UILWSquadEquipItem, function(req)
      if IsNull(req.gameObject) then
        return
      end
      local item = req.gameObject
      item.name = "UILWSquadEquipItem" .. i
      item.transform:SetParent(self.EquipContent1.transform)
      item.transform:Set_localScale(0.64, 0.64, 1)
      local obj = self.EquipContent1:AddComponent(UILWSquadEquipItem, item.name)
      obj:SetDataForMail(equipData1[i])
    end)
    self.equipReqs[i + 6] = self:GameObjectInstantiateAsync(UIAssets.UILWSquadEquipItem, function(req)
      if IsNull(req.gameObject) then
        return
      end
      local item = req.gameObject
      item.name = "UILWSquadEquipItem" .. i + 6
      item.transform:SetParent(self.EquipContent2.transform)
      item.transform:Set_localScale(0.64, 0.64, 1)
      local obj = self.EquipContent2:AddComponent(UILWSquadEquipItem, item.name)
      obj:SetDataForMail(equipData2[i])
    end)
  end
  self.EquipPower1:SetLocalText(GameDialogDefine.BATTLE_POWER, string.GetFormattedStr(math.floor(self.progress1.formationEquipPower)))
  self.EquipPower2:SetLocalText(GameDialogDefine.BATTLE_POWER, string.GetFormattedStr(math.floor(self.progress2.formationEquipPower)))
  local leftWeapon = self.extData.weapon[11]
  local rightWeapon = self.extData.weapon[12]
  if self.extData and self.extData.weapon and (leftWeapon or rightWeapon) then
    self.weaponContent:SetActive(true)
    
    local function CreateEquipAndSkill(weaponInfo, weaponId, weaponLevel, weaponSkinId, container, isLeft)
      local weaponItemReq = self:GameObjectInstantiateAsync(UIAssets.UILWTacticalWeaponItem, function(req)
        if IsNull(req.gameObject) then
          return
        end
        local item = req.gameObject
        item.name = "UILWTacticalWeaponItem1"
        item.transform:SetParent(container.transform)
        item.transform:Set_localScale(0.9, 0.9, 0.9)
        local obj = container:AddComponent(UILWTacticalWeaponItem, item.name)
        obj:SetConfigId(weaponId, weaponLevel, weaponSkinId)
        if isLeft then
          obj.transform:SetAsFirstSibling()
        else
          obj.transform:SetAsLastSibling()
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
        local skillInfo = SkillInfo.New()
        skillInfo:CreateFromTemplate(weaponInfo.skillInfos[skillArrIndex].skillId, true, weaponInfo.skillInfos[skillArrIndex].skillLv)
        local skillReq = self:GameObjectInstantiateAsync(UIAssets.UIHeroSkillItem, function(req)
          if IsNull(req.gameObject) then
            return
          end
          local item = req.gameObject
          item.name = "UIHeroSkillItem1"
          item.transform:SetParent(container.transform)
          item.transform:Set_sizeDelta(93.6, 121.3)
          item.transform:Set_localScale(1, 1, 1)
          local obj = container:AddComponent(UIHeroSkillItem, item.name)
          obj:SetData(skillInfo, {
            showSkillName = false,
            showSkillLevel = false,
            showLock = false,
            showRedPoint = false,
            unlockLevel = false,
            showStar = true
          })
          if isLeft then
            obj.transform:SetAsLastSibling()
          else
            obj.transform:SetAsFirstSibling()
          end
        end)
        table.insert(self.weaponSkillReqs, skillReq)
      end
    end
    
    if leftWeapon then
      local weaponInfo = leftWeapon
      local weaponId = weaponInfo.heroId
      local weaponLevel = weaponInfo.heroLevel
      local weaponSkinId = weaponInfo.skinId
      CreateEquipAndSkill(weaponInfo, weaponId, weaponLevel, weaponSkinId, self.weaponLeft, true)
    end
    if rightWeapon then
      local weaponInfo = rightWeapon
      local weaponId = weaponInfo.heroId
      local weaponLevel = weaponInfo.heroLevel
      local weaponSkinId = weaponInfo.skinId
      CreateEquipAndSkill(weaponInfo, weaponId, weaponLevel, weaponSkinId, self.weaponRight, false)
    end
    local weaponRealEffect = {
      [1] = {left = nil, right = nil},
      [2] = {left = nil, right = nil},
      [3] = {left = nil, right = nil}
    }
    for i = 1, 2 do
      local weaponInfo = i == 1 and leftWeapon or rightWeapon
      if weaponInfo then
        local effectMap = weaponInfo.effect
        for j = 1, #weaponEffects do
          local effect = effectMap[weaponEffects[j]]
          if effect then
            weaponRealEffect[j][i == 1 and "left" or "right"] = effect
          end
        end
      end
    end
    self:ClearWeaponAttrs()
    for i = 1, #weaponEffects do
      local request = self:GameObjectInstantiateAsync(UIAssets.WeaponAttriLine, function(req)
        if IsNull(req.gameObject) then
          return
        end
        local item = req.gameObject
        item.name = "WeaponAttriLine" .. i
        item.transform:SetParent(self.weaponAttriContent.transform)
        item.transform:Set_localScale(1, 1, 1)
        local obj = self.weaponAttriContent:AddComponent(WeaponAttriLine, item.name)
        obj:SetData(weaponEffects[i], weaponRealEffect[i].left, weaponRealEffect[i].right, true, false)
      end)
      table.insert(self.weaponAttrReqs, request)
    end
    local hasEquipSkillChip = false
    if not (not leftWeapon or table.IsNullOrEmpty(leftWeapon.skillChips)) or rightWeapon and not table.IsNullOrEmpty(rightWeapon.skillChips) then
      hasEquipSkillChip = true
    end
    if not hasEquipSkillChip then
      self.skillChipContent:SetActive(false)
    else
      self.skillChipContent:SetActive(true)
      do
        local leftChipTotalStar = 0
        local rightChipTotalStar = 0
        for i = 1, 8 do
          local playerIndex = 1
          local container = self.leftSkillChips
          if 4 < i then
            container = self.rightSkillChips
            playerIndex = 2
          end
          local customTierEffectValue = 0
          local effectMap = self.extData:GetEffectFromPlayer(playerIndex)
          if effectMap then
            customTierEffectValue = effectMap[50231] or 0
          end
          local skillChipInfo
          if i <= 4 and leftWeapon and leftWeapon.skillChips then
            skillChipInfo = leftWeapon.skillChips[i]
            if skillChipInfo then
              leftChipTotalStar = leftChipTotalStar + skillChipInfo:GetStar()
            end
          elseif 4 < i and rightWeapon and rightWeapon.skillChips then
            skillChipInfo = rightWeapon.skillChips[4 - (i - 4 - 1)]
            if skillChipInfo then
              rightChipTotalStar = rightChipTotalStar + skillChipInfo:GetStar()
            end
          end
          local skillChipReq = self:GameObjectInstantiateAsync(UIAssets.UILWTWSkillChipItem, function(req)
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
              obj:SetData(skillChipInfo, index)
              obj:SetOnClick(function(holder, chipInfo, slotIndex)
                UIManager:GetInstance():OpenWindow(UIWindowNames.UILWTWSkillChipDetail, {anim = true}, chipInfo, false, false, customTierEffectValue)
              end)
            else
              obj:SetSlot(index)
            end
          end)
          table.insert(self.skillChipReqs, skillChipReq)
        end
        local leftChipTotalLevel = 0
        local rightChipTotalLevel = 0
        if self.extData and self.extData.player[1] then
          leftChipTotalLevel = self.extData.player[1].chipTotalLevel
        end
        if self.extData and self.extData.player[2] then
          rightChipTotalLevel = self.extData.player[2].chipTotalLevel
        end
        local req = self:GameObjectInstantiateAsync(UIAssets.WeaponAttriLine, function(_req)
          if IsNull(_req.gameObject) then
            return
          end
          local item = _req.gameObject
          local nameStr = "UILWTWSkillChipItemTotal"
          item.name = nameStr
          item.transform:SetParent(self.skillChipContent.transform)
          item.transform:Set_localScale(1, 1, 1)
          local obj = self.skillChipContent:AddComponent(WeaponAttriLine, nameStr)
          obj:SetDataAlt("report_helper_eval_14", nil, leftChipTotalLevel, rightChipTotalLevel, false, false)
        end)
        table.insert(self.skillChipAttrs, req)
        req = self:GameObjectInstantiateAsync(UIAssets.WeaponAttriLine, function(_req)
          if IsNull(_req.gameObject) then
            return
          end
          local item = _req.gameObject
          local nameStr = "UILWTWSkillChipItemTotalStar"
          item.name = nameStr
          item.transform:SetParent(self.skillChipContent.transform)
          item.transform:Set_localScale(1, 1, 1)
          local obj = self.skillChipContent:AddComponent(WeaponAttriLine, nameStr)
          obj:SetDataAlt("report_helper_numeric_11", nil, leftChipTotalStar, rightChipTotalStar, false, true)
        end)
        table.insert(self.skillChipAttrs, req)
        local leftWeaponBuff, rightWeaponBuff = 0, 0
        local leftWeaponDebuff, rightWeaponDebuff = 0, 0
        if leftWeapon and leftWeapon.stat then
          leftWeaponBuff = leftWeapon.stat.damage
          leftWeaponDebuff = leftWeapon.stat.injured
        end
        if rightWeapon and rightWeapon.stat then
          rightWeaponBuff = rightWeapon.stat.damage
          rightWeaponDebuff = rightWeapon.stat.injured
        end
      end
    end
  else
    self.weaponContent:SetActive(false)
  end
end

function MailArmyPage:RemoveEquipItems()
  self.EquipContent1:RemoveComponents(UILWSquadEquipItem)
  self.EquipContent2:RemoveComponents(UILWSquadEquipItem)
  if self.equipReqs then
    for _, v in pairs(self.equipReqs) do
      self:GameObjectDestroy(v)
    end
    self.equipReqs = {}
  end
  self.weaponLeft:RemoveComponents(UILWTacticalWeaponItem)
  self.weaponRight:RemoveComponents(UILWTacticalWeaponItem)
  self.weaponLeft:RemoveComponents(UIHeroSkillItem)
  self.weaponRight:RemoveComponents(UIHeroSkillItem)
  if self.weaponReqs then
    for _, v in pairs(self.weaponReqs) do
      self:GameObjectDestroy(v)
    end
    self.weaponReqs = {}
  end
  if self.weaponSkillReqs then
    for _, v in pairs(self.weaponSkillReqs) do
      self:GameObjectDestroy(v)
    end
    self.weaponSkillReqs = {}
  end
  self.leftSkillChips:RemoveComponents(SkillChipItem)
  self.rightSkillChips:RemoveComponents(SkillChipItem)
  if self.skillChipReqs then
    for _, v in pairs(self.skillChipReqs) do
      self:GameObjectDestroy(v)
    end
  end
  self.skillChipReqs = {}
  if self.skillChipAttrs then
    for _, v in pairs(self.skillChipAttrs) do
      self:GameObjectDestroy(v)
    end
  end
  self.skillChipAttrs = {}
  self.skillChipContent:RemoveComponents(WeaponAttriLine)
  self.skillChipContent:RemoveComponents(DecoBarItem)
end

function MailArmyPage:RefreshSciView()
  self:RemoveSciItems()
  local science1, science2 = MailBattleParseHelper.DecodeShowScience(self.progress1, self.progress2)
  for i = 1, #science1 do
    local item = self.SciItemPrefab:GameObjectSpawn(self.SciContent1.transform)
    item.name = "UILWScienceMainItem" .. i
    item.transform:SetParent(self.SciContent1.transform)
    item.transform:Set_localScale(0.48, 0.48, 1)
    item.transform:Set_pivot(CommonUtil.IsArabicAutoMirrorOpen() and 1 or 0, 1)
    item.transform:Set_anchorMin(CommonUtil.IsArabicAutoMirrorOpen() and 1 or 0, 1)
    item.transform:Set_anchorMax(CommonUtil.IsArabicAutoMirrorOpen() and 1 or 0, 1)
    local obj = self.SciContent1:AddComponent(UILWScienceMainItem, item.name)
    obj:SetDataByCfgId(science1[i].scienceTabId, science1[i].progress * 0.01)
  end
  for i = 1, #science2 do
    local item = self.SciItemPrefab:GameObjectSpawn(self.SciContent2.transform)
    item.name = "UILWScienceMainItem" .. -i
    item.transform:SetParent(self.SciContent2.transform)
    item.transform:Set_localScale(0.48, 0.48, 1)
    item.transform:Set_pivot(CommonUtil.IsArabicAutoMirrorOpen() and 1 or 0, 1)
    item.transform:Set_anchorMin(CommonUtil.IsArabicAutoMirrorOpen() and 1 or 0, 1)
    item.transform:Set_anchorMax(CommonUtil.IsArabicAutoMirrorOpen() and 1 or 0, 1)
    local obj = self.SciContent2:AddComponent(UILWScienceMainItem, item.name)
    obj:SetDataByCfgId(science2[i].scienceTabId, science2[i].progress * 0.01)
  end
  self.SciPower1:SetLocalText(GameDialogDefine.BATTLE_POWER, string.GetFormattedStr(math.floor(self.progress1.sciencePower)))
  self.SciPower2:SetLocalText(GameDialogDefine.BATTLE_POWER, string.GetFormattedStr(math.floor(self.progress2.sciencePower)))
  if MailBattleParseHelper.HasScienceEffect(self.extData.player[1]) and MailBattleParseHelper.HasScienceEffect(self.extData.player[2]) then
    self.SciDropdown:SetActive(true)
  else
    self.SciDropdown:SetActive(false)
  end
  self.SciToggle:SetIsOn(false)
  self.SciBarList:SetActive(false)
  self:RemoveSciBars()
  local version = self.extData:GetVersion()
  if version >= SHOW_SCI_DETAIL_VERSION then
    self.sciDetail_btn:SetActive(true)
  else
    self.sciDetail_btn:SetActive(false)
  end
end

function MailArmyPage:RemoveSciItems()
  self.SciContent1:RemoveComponents(UILWScienceMainItem)
  self.SciContent2:RemoveComponents(UILWScienceMainItem)
  self.SciItemPrefab.gameObject:GameObjectRecycleAll()
end

function MailArmyPage:OnClickSciToggle(bool)
  self.SciBarList:SetActive(bool)
  self:RemoveSciBars()
  if bool then
    MailBattleParseHelper.DecodeScienceEffect(self.extData.player[1])
    MailBattleParseHelper.DecodeScienceEffect(self.extData.player[2])
    local effectsDic1 = self.progress1.sciEffectsDic
    local effectsDic2 = self.progress2.sciEffectsDic
    local metaList = DataCenter.MailEffectTemplateManager:GetAllTemplate()
    for i = 1, #metaList do
      local meta = metaList[i]
      local value1, value2 = 0, 0
      local effectId = 0
      for j = 1, #meta.effectId do
        effectId = meta.effectId[j]
        local effValue = effectsDic1[effectId] or 0
        value1 = value1 + effValue
        effValue = effectsDic2[effectId] or 0
        value2 = value2 + effValue
      end
      if value1 ~= 0 or value2 ~= 0 then
        self.sciBarReqs[i] = self:GameObjectInstantiateAsync(UIAssets.SciBarItem, function(req)
          if IsNull(req.gameObject) then
            return
          end
          local item = req.gameObject
          item.name = "SciBarItem" .. i
          item.transform:SetParent(self.SciBarList.transform)
          item.transform:Set_localScale(1, 1, 1)
          local obj = self.SciBarList:AddComponent(SciBarItem, item.name)
          obj:SetData(metaList[i], effectsDic1, effectsDic2, value1, value2, self.extData:GetMyCamp(), effectId)
        end)
      end
    end
  end
end

function MailArmyPage:RemoveSciBars()
  self.SciBarList:RemoveComponents(SciBarItem)
  if self.sciBarReqs then
    for _, v in pairs(self.sciBarReqs) do
      v:Destroy()
    end
  end
  self.sciBarReqs = {}
end

function MailArmyPage:RefreshDecoView()
  self:RemoveDecoItems()
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
  local deco2 = {
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
  self.progress1.deco = self.progress1.deco or {}
  self.progress2.deco = self.progress2.deco or {}
  for _, v in pairs(self.progress1.deco) do
    deco1[6 - v.decoQualityId] = v
  end
  for _, v in pairs(self.progress2.deco) do
    deco2[6 - v.decoQualityId] = v
  end
  for i = 1, 3 do
    self.decoReqs[i] = self:GameObjectInstantiateAsync(UIAssets.MailDecoItem, function(req)
      if IsNull(req.gameObject) then
        return
      end
      local item = req.gameObject
      item.name = "MailDecoItem" .. i
      item.transform:SetParent(self.DecoContent.transform)
      item.transform:Set_localScale(1, 1, 1)
      local obj = self.DecoContent:AddComponent(MailDecoItem, item.name)
      obj:SetData(deco1[i], deco2[i])
    end)
  end
  self.DecoPower1:SetLocalText(GameDialogDefine.BATTLE_POWER, string.GetFormattedStr(math.floor(self.progress1.decoPower)))
  self.DecoPower2:SetLocalText(GameDialogDefine.BATTLE_POWER, string.GetFormattedStr(math.floor(self.progress2.decoPower)))
  if MailBattleParseHelper.HasDecoEffect(self.extData.player[1]) and MailBattleParseHelper.HasDecoEffect(self.extData.player[2]) then
    self.DecoDropDown:SetActive(true)
  else
    self.DecoDropDown:SetActive(false)
  end
  self.DecoToggle:SetIsOn(false)
  self.DecoBarList:SetActive(false)
  self:RemoveDecoBars()
end

function MailArmyPage:OnClickDecoToggle(bool)
  self.DecoBarList:SetActive(bool)
  self:RemoveDecoBars()
  if bool then
    if table.IsNullOrEmpty(self.sortedDecoEffects) then
      MailBattleParseHelper.DecodeDecoEffect(self.extData.player[1])
      MailBattleParseHelper.DecodeDecoEffect(self.extData.player[2])
      local effectsDic1 = self.progress1.decoEffectsDic
      local effectsDic2 = self.progress2.decoEffectsDic
      local effects = {}
      for i = 1, 2 do
        local effectsDic = i == 1 and effectsDic1 or effectsDic2
        for k, v in pairs(effectsDic) do
          local effectTemplate = DataCenter.EffectNumberTemplateManager:GetTemplate(k)
          if effectTemplate and effectTemplate.display_type_gallery ~= EffectNumberDisplayTypeGallery.NoneBattle then
            if not effects[k] then
              effects[k] = {}
              local otherIndex = i == 1 and 2 or 1
              effects[k][otherIndex] = 0
            end
            effects[k][i] = v
          end
        end
      end
      local sortedEffects = {}
      for k, v in pairs(effects) do
        table.insert(sortedEffects, {
          effectId = k,
          val1 = v[1] or 0,
          val2 = v[2] or 0
        })
      end
      table.sort(sortedEffects, function(a, b)
        local aSequence = DataCenter.EffectNumberTemplateManager:GetEffectNumberTemplateSequence(a.effectId)
        local bSequence = DataCenter.EffectNumberTemplateManager:GetEffectNumberTemplateSequence(b.effectId)
        if aSequence == bSequence then
          return a.effectId < b.effectId
        else
          return aSequence < bSequence
        end
      end)
      self.sortedDecoEffects = sortedEffects
    end
    for i = 1, #self.sortedDecoEffects do
      local effectId = self.sortedDecoEffects[i].effectId
      local value1 = self.sortedDecoEffects[i].val1 or 0
      local value2 = self.sortedDecoEffects[i].val2 or 0
      if value1 ~= 0 or value2 ~= 0 then
        self.decoBarReqs[i] = self:GameObjectInstantiateAsync(UIAssets.DecoBarItem, function(req)
          if IsNull(req.gameObject) then
            return
          end
          local item = req.gameObject
          item.name = "DecoBarItem" .. i
          item.transform:SetParent(self.DecoBarList.transform)
          item.transform:Set_localScale(1, 1, 1)
          local obj = self.DecoBarList:AddComponent(DecoBarItem, item.name)
          obj:SetData(effectId, value1, value2, self.extData:GetMyCamp())
        end)
      end
    end
  end
end

function MailArmyPage:RemoveDecoBars()
  self.DecoBarList:RemoveComponents(DecoBarItem)
  if self.decoBarReqs then
    for _, v in pairs(self.decoBarReqs) do
      self:GameObjectDestroy(v)
    end
  end
  self.decoBarReqs = {}
end

function MailArmyPage:RemoveDecoItems()
  self.DecoContent:RemoveComponents(MailDecoItem)
  if self.decoReqs then
    for _, v in pairs(self.decoReqs) do
      v:Destroy()
    end
  end
  self.decoReqs = {}
end

function MailArmyPage:RefreshArmyView()
  local soldierTotalPower1 = self.extData.player[1].soldierPowerBeforeStart or 0
  local soldierTotalPower2 = self.extData.player[2].soldierPowerBeforeStart or 0
  local army1 = self.extData.player[1].soldierBeforeStart or {}
  local army2 = self.extData.player[2].soldierBeforeStart or {}
  if #army1 == 0 and #army2 == 0 then
    self.ArmyViewRoot:SetActive(false)
    return 0
  else
    self.ArmyViewRoot:SetActive(true)
  end
  self:RemoveArmyItems()
  table.sort(army1, function(a, b)
    return a.soldierId > b.soldierId
  end)
  table.sort(army2, function(a, b)
    return a.soldierId > b.soldierId
  end)
  local armyList, totalMorale1, totalMorale2, totalSoldierCount1, totalSoldierCount2 = self.extData:GetArmyMoraleInfo()
  local armyCount = 0
  for k, v in ipairs(armyList) do
    armyCount = armyCount + 1
    self.armyReqs[k] = self:GameObjectInstantiateAsync(UIAssets.MailArmyItemNew, function(req)
      if IsNull(req.gameObject) then
        return
      end
      local item = req.gameObject
      item.name = "MailArmyItemNew" .. k
      item.transform:SetParent(self.ArmyContent.transform)
      item.transform:Set_localScale(1, 1, 1)
      local obj = self.ArmyContent:AddComponent(MailArmyItem, item.name)
      obj:SetData(v)
    end)
  end
  self.ArmyPower1:SetText(Localization:GetString("100253") .. " " .. string.GetFormattedStr(math.floor(soldierTotalPower1)))
  self.ArmyPower2:SetText(Localization:GetString("100253") .. " " .. string.GetFormattedStr(math.floor(soldierTotalPower2)))
  self.armyMoraleTotalContent:SetActive(1 < armyCount)
  self.leftSoldierTotalMoraleText:SetText(string.GetFormattedStr(math.floor(totalMorale1)))
  self.leftSoldierTotalNumText:SetText(string.GetFormattedSeperatorNum(math.floor(totalSoldierCount1)))
  self.rightSoldierTotalMoraleText:SetText(string.GetFormattedStr(math.floor(totalMorale2)))
  self.rightSoldierTotalNumText:SetText(string.GetFormattedSeperatorNum(math.floor(totalSoldierCount2)))
  self:RefreshMoraleTipInfo(totalMorale1, totalMorale2)
end

function MailArmyPage:RemoveArmyItems()
  self.ArmyContent:RemoveComponents(MailArmyItem)
  if self.armyReqs then
    for _, v in pairs(self.armyReqs) do
      v:Destroy()
    end
    self.armyReqs = {}
  end
end

function MailArmyPage:RefreshMoraleTipInfo(morale1, morale2)
  local doubleValue, damageValue = 0, 0
  local key = ""
  if morale2 < morale1 then
    morale2 = math.max(morale2, 1)
    key = "battle_report_tips_10001"
    doubleValue = morale1 / morale2
  else
    key = "battle_report_tips_10002"
    morale1 = math.max(morale1, 1)
    doubleValue = morale2 / morale1
  end
  damageValue = doubleValue * 100
  local integerPart, decimalPart = math.modf(damageValue)
  local show = 1 < doubleValue
  self.soldierMoraleTipsContent:SetActive(show)
  if show then
    doubleValue = integerPart / 100
    integerPart = math.max(100, math.min(200, integerPart))
    damageValue = integerPart .. "%"
    self.soldierMoraleTipsText:SetText(Localization:GetString(key, doubleValue, damageValue))
  end
end

function MailArmyPage:RefreshHonorView()
  self:RemoveHonorItems()
  local honorWall1 = self.progress1.honorWall or {}
  local honorWall2 = self.progress2.honorWall or {}
  if #honorWall1 == 0 and #honorWall2 == 0 then
    self.honorView:SetActive(false)
  else
    self.honorView:SetActive(true)
    for i = 1, 3 do
      self.honorReqs[i] = self:GameObjectInstantiateAsync(UIAssets.MailHonorItem, function(req)
        if IsNull(req.gameObject) then
          return
        end
        local item = req.gameObject
        item.name = "HonorItem" .. i
        item.transform:SetParent(self.honorContent.transform)
        item.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        local obj = self.honorContent:AddComponent(MailHonorItem, item.name)
        obj:SetData(i, honorWall1[i], honorWall2[i])
      end)
    end
    self.honorPower1Text:SetText(Localization:GetString(100253) .. " " .. string.GetFormattedStr(math.floor(self.progress1.honorPower)))
    self.honorPower2Text:SetText(Localization:GetString(100253) .. " " .. string.GetFormattedStr(math.floor(self.progress2.honorPower)))
  end
end

function MailArmyPage:RemoveHonorItems()
  self.honorContent:RemoveComponents(MailHonorItem)
  if self.honorReqs then
    for _, v in pairs(self.honorReqs) do
      v:Destroy()
    end
    self.honorReqs = {}
  end
end

function MailArmyPage:GetNewTabPowerValue(player, tabType)
  if not (player and player.otherTabPowerInfo and player.otherTabPowerInfo.isOpen) or not player.otherTabPowerInfo.powerInfo then
    return 0
  end
  for _, v in ipairs(player.otherTabPowerInfo.powerInfo) do
    if v.tabType == tabType then
      return v.value or 0
    end
  end
  return 0
end

function MailArmyPage:GetOtherPowerValueByType(player, extraPowerType)
  local powerValue = BattleReportUtil.GetNewOtherPowerValue(player, extraPowerType)
  if extraPowerType == ExtraPowerInfoType.Mastery then
    powerValue = powerValue + self:GetNewTabPowerValue(player, NewOtherPowerInfoType.CampScience)
    powerValue = powerValue + self:GetNewTabPowerValue(player, NewOtherPowerInfoType.Militray)
  end
  return powerValue
end

function MailArmyPage:RefreshOtherPower()
  self:RemoveOtherItems()
  self.otherToggle:SetIsOn(false)
  self.OtherBarList:SetActive(false)
  local isPlayer1ExistExtraData = BattleReportUtil.IsContainsOtherPowerData(self.extData.player[1])
  local isPlayer2ExistExtraData = BattleReportUtil.IsContainsOtherPowerData(self.extData.player[2])
  if not isPlayer1ExistExtraData and not isPlayer2ExistExtraData then
    self.otherView:SetActive(false)
    return
  end
  if BattleReportUtil.ShouldHideOtherPower(self.extData) then
    self.otherView:SetActive(false)
    return
  end
  local playerOtherPower1 = self:GetOtherPowerValue(self.extData.player[1])
  local playerOtherPower2 = self:GetOtherPowerValue(self.extData.player[2])
  if playerOtherPower1 == 0 and playerOtherPower2 == 0 then
    self.otherView:SetActive(false)
    return
  end
  self.otherPower1Text:SetText(Localization:GetString(100253) .. " " .. string.GetFormattedStr(math.floor(playerOtherPower1)))
  self.otherPower2Text:SetText(Localization:GetString(100253) .. " " .. string.GetFormattedStr(math.floor(playerOtherPower2)))
  self.otherView:SetActive(true)
  local allNeedShowOtherPowerType = {}
  table.insert(allNeedShowOtherPowerType, ExtraPowerInfoType.AllianceScience)
  table.insert(allNeedShowOtherPowerType, ExtraPowerInfoType.Mastery)
  table.insert(allNeedShowOtherPowerType, ExtraPowerInfoType.BattleField)
  for i, v in ipairs(allNeedShowOtherPowerType) do
    local extraPowerType = v
    local extraPower1 = self:GetOtherPowerValueByType(self.extData.player[1], extraPowerType)
    local extraPower2 = self:GetOtherPowerValueByType(self.extData.player[2], extraPowerType)
    if extraPower1 ~= 0 or extraPower2 ~= 0 then
      self.otherReqs[i] = self:GameObjectInstantiateAsync(UIAssets.MailOtherItem, function(req)
        if IsNull(req.gameObject) then
          return
        end
        local item = req.gameObject
        item.name = "OtherItem" .. i
        item.transform:SetParent(self.otherContent.transform)
        item.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        local obj = self.otherContent:AddComponent(MailOtherItem, item.name)
        obj:SetData(extraPowerType, self.extData.player[1], self.extData.player[2])
      end)
    end
  end
  local isPlayer1ExistExtraDetailData = BattleReportUtil.IsContainsOtherPowerDetailData(self.extData.player[1])
  local isPlayer2ExistExtraDetailData = BattleReportUtil.IsContainsOtherPowerDetailData(self.extData.player[2])
  if not isPlayer1ExistExtraDetailData and not isPlayer2ExistExtraDetailData then
    self.otherDetailArrObj:SetActive(false)
    return
  end
  self.otherDetailArrObj:SetActive(true)
end

function MailArmyPage:RemoveOtherItems()
  self.otherContent:RemoveComponents(MailOtherItem)
  if self.otherReqs then
    for _, v in pairs(self.otherReqs) do
      v:Destroy()
    end
    self.otherReqs = {}
  end
end

function MailArmyPage:RemoveOtherBars()
  self.OtherBarList:RemoveComponents(OtherBarItem)
  if self.otherBarReqs then
    for _, v in pairs(self.otherBarReqs) do
      self:GameObjectDestroy(v)
    end
  end
  self.otherBarReqs = {}
end

function MailArmyPage:GetOtherPowerValue(player)
  if not player then
    return 0
  end
  if not player.extraPowers and (not player.otherTabPowerInfo or not player.otherTabPowerInfo.isOpen) then
    return 0
  end
  if BattleReportUtil.ShouldHideOtherPower(self.extData) then
    return 0
  end
  local allianceSciencePower = self:GetOtherPowerValueByType(player, ExtraPowerInfoType.AllianceScience)
  local masteryPower = self:GetOtherPowerValueByType(player, ExtraPowerInfoType.Mastery)
  local battleFieldPower = self:GetOtherPowerValueByType(player, ExtraPowerInfoType.BattleField)
  return allianceSciencePower + masteryPower + battleFieldPower
end

function MailArmyPage:OtherBarGroupKey(meta, rowId)
  local g = meta and meta.groupid
  if g ~= nil and tostring(g) ~= "" then
    return "g_" .. tostring(g)
  end
  return "r_" .. tostring(rowId)
end

function MailArmyPage:SortedTemplateRowIds(metaDict)
  local ids = {}
  for id in pairs(metaDict) do
    ids[#ids + 1] = id
  end
  table.sort(ids)
  return ids
end

function MailArmyPage:BuildOtherBarGroups(metaDict)
  local groupsByKey = {}
  for _, rowId in ipairs(self:SortedTemplateRowIds(metaDict)) do
    local key = self:OtherBarGroupKey(metaDict[rowId], rowId)
    if not groupsByKey[key] then
      groupsByKey[key] = {}
    end
    groupsByKey[key][#groupsByKey[key] + 1] = rowId
  end
  local list = {}
  for _, rowIds in pairs(groupsByKey) do
    table.sort(rowIds)
    list[#list + 1] = {
      rowIds = rowIds,
      sortKey = rowIds[1]
    }
  end
  table.sort(list, function(a, b)
    return a.sortKey < b.sortKey
  end)
  return list
end

function MailArmyPage:MergeOtherBarGroupMeta(rowIds, metaDict)
  local sortedIds = {}
  for i, v in ipairs(rowIds) do
    sortedIds[i] = v
  end
  table.sort(sortedIds)
  local seen, order = {}, {}
  local effectEntries = {}
  local groupTabTypes = {}
  for _, rowId in ipairs(sortedIds) do
    local m = metaDict[rowId]
    if m and m.effectId then
      local tabType = tonumber(m.othertabtype) or 0
      if tabType ~= 0 then
        groupTabTypes[tabType] = true
      end
      for j = 1, #m.effectId do
        local eid = tonumber(m.effectId[j]) or 0
        if eid ~= 0 then
          local pairKey = tostring(tabType) .. "_" .. tostring(eid)
          if not seen[pairKey] then
            seen[pairKey] = true
            order[#order + 1] = eid
            effectEntries[#effectEntries + 1] = {
              rowId = rowId,
              tabType = tabType,
              effectId = eid
            }
          end
        end
      end
    end
  end
  local first = metaDict[sortedIds[1]]
  local effectName, gotoType, gotoParam = {}, {}, {}
  for i, eid in ipairs(order) do
    effectName[i] = ""
    gotoType[i] = 0
    gotoParam[i] = 0
    local filled = false
    for _, rowId in ipairs(sortedIds) do
      if filled then
        break
      end
      local m = metaDict[rowId]
      if m and m.effectId then
        for j = 1, #m.effectId do
          if m.effectId[j] == eid then
            if m.effectName and m.effectName[j] then
              effectName[i] = m.effectName[j]
            end
            if m.gotoType and m.gotoType[j] ~= nil then
              gotoType[i] = tonumber(m.gotoType[j]) or 0
            end
            if m.gotoParam and m.gotoParam[j] ~= nil then
              gotoParam[i] = tonumber(m.gotoParam[j]) or 0
            end
            filled = true
            break
          end
        end
      end
    end
  end
  return {
    desc = first and first.desc,
    icon = first and first.icon,
    groupid = first and first.groupid,
    effectId = order,
    effectName = effectName,
    gotoType = gotoType,
    gotoParam = gotoParam,
    rowIds = sortedIds,
    effectEntries = effectEntries,
    groupTabTypes = groupTabTypes
  }
end

function MailArmyPage:SumOtherGroupValue(otherEffectsRaw, mergedMeta)
  if otherEffectsRaw == nil or mergedMeta == nil or mergedMeta.effectEntries == nil then
    return 0
  end
  local total = 0
  for _, tab in pairs(otherEffectsRaw) do
    if tab and tab.effects then
      local tabType = tonumber(tab.tabType) or 0
      for _, entry in ipairs(mergedMeta.effectEntries) do
        if entry.tabType == tabType then
          for _, effect in ipairs(tab.effects) do
            if effect and tonumber(effect.id) == entry.effectId then
              total = total + (tonumber(effect.val) or 0)
            end
          end
        end
      end
    end
  end
  return total
end

function MailArmyPage:SumOtherGroupValueFromDic(effectsDic, mergedMeta)
  if effectsDic == nil or mergedMeta == nil or mergedMeta.effectEntries == nil then
    return 0
  end
  local total = 0
  local seenEffectId = {}
  for _, entry in ipairs(mergedMeta.effectEntries) do
    local effectId = tonumber(entry.effectId)
    if effectId and not seenEffectId[effectId] then
      seenEffectId[effectId] = true
      total = total + (tonumber(effectsDic[effectId]) or 0)
    end
  end
  return total
end

function MailArmyPage:SumOtherGroupValueCompat(otherEffectsRaw, effectsDic, mergedMeta)
  if otherEffectsRaw ~= nil then
    local value = self:SumOtherGroupValue(otherEffectsRaw, mergedMeta)
    return value
  end
  return self:SumOtherGroupValueFromDic(effectsDic, mergedMeta)
end

function MailArmyPage:OnClickOtherToggle(bool)
  self.OtherBarList:SetActive(bool)
  self:RemoveOtherBars()
  if bool then
    MailBattleParseHelper.DecodeOtherEffect(self.extData.player[1])
    MailBattleParseHelper.DecodeOtherEffect(self.extData.player[2])
    local effectsDic1 = self.progress1.otherEffectsDic
    local effectsDic2 = self.progress2.otherEffectsDic
    local metaDict = DataCenter.MailExtraEffectTemplateManager:GetAllTemplate()
    for gi, grp in ipairs(self:BuildOtherBarGroups(metaDict)) do
      local mergedMeta = self:MergeOtherBarGroupMeta(grp.rowIds, metaDict)
      local value1 = self:SumOtherGroupValueCompat(self.progress1.otherEffectsRaw, effectsDic1, mergedMeta)
      local value2 = self:SumOtherGroupValueCompat(self.progress2.otherEffectsRaw, effectsDic2, mergedMeta)
      if value1 ~= 0 or value2 ~= 0 then
        do
          local reqKey = "og_" .. tostring(grp.sortKey) .. "_" .. gi
          self.otherBarReqs[reqKey] = self:GameObjectInstantiateAsync(UIAssets.OtherBarItem, function(req)
            if IsNull(req.gameObject) then
              return
            end
            local item = req.gameObject
            item.name = "OtherBarItem" .. grp.sortKey .. "_" .. gi
            item.transform:SetParent(self.OtherBarList.transform)
            item.transform:Set_localScale(1, 1, 1)
            local obj = self.OtherBarList:AddComponent(OtherBarItem, item.name)
            obj:SetData(mergedMeta, effectsDic1, effectsDic2, value1, value2, self.extData:GetMyCamp(), mergedMeta.effectId, self.progress1.otherEffectsRaw, self.progress2.otherEffectsRaw)
          end)
        end
      end
    end
  end
end

function MailArmyPage:RemoveDominator()
  if self.dominatorReq then
    self.dominatorConatiner:RemoveAllComponentes()
    self:GameObjectDestroy(self.dominatorReq)
    self.dominatorReq = nil
  end
  self.dominatorConatiner:SetActive(false)
end

local DOMINATOR_PREFAB_PATH = "Assets/Main/Prefabs/UI/LWMail/MailBattle/dominator/DominatorView.prefab"

function MailArmyPage:RefreshDominator()
  self:RemoveDominator()
  local hasDominator = self.progress1.dominator and not table.IsNullOrEmpty(self.progress1.dominator.dominatorTrainInfos)
  hasDominator = hasDominator or self.progress2.dominator and not table.IsNullOrEmpty(self.progress2.dominator.dominatorTrainInfos)
  if not hasDominator then
    self.dominatorConatiner:SetActive(false)
  else
    self.dominatorConatiner:SetActive(true)
    self.dominatorReq = self:GameObjectInstantiateAsync(DOMINATOR_PREFAB_PATH, function(req)
      if IsNull(req.gameObject) then
        return
      end
      local item = req.gameObject
      item.name = "MailDominatorView"
      item.transform:SetParent(self.dominatorConatiner.transform)
      item.transform:Set_localScale(1, 1, 1)
      local obj = self.dominatorConatiner:AddComponent(DominatorView, item.name)
      obj:SetData(self.extData)
    end)
  end
end

local TACTICALCARD_PREFAB_PATH = "Assets/Main/Prefabs/UI/LWMail/MailBattle/TacticalCard/TacticalCardView.prefab"

function MailArmyPage:RefreshTacticalCard()
  self:RemoveTacticalCard()
  local hasTacticalCard = self.extData:IsHasTacticalCard()
  if not hasTacticalCard then
    self.tacticalCardContainer:SetActive(false)
    return
  end
  self.tacticalCardContainer:SetActive(true)
  self.tacticalCardReq = self:GameObjectInstantiateAsync(TACTICALCARD_PREFAB_PATH, function(req)
    if IsNull(req.gameObject) then
      return
    end
    local item = req.gameObject
    item.name = "MailTacticalCardView"
    item.transform:SetParent(self.tacticalCardContainer.transform)
    item.transform:Set_localScale(1, 1, 1)
    local obj = self.tacticalCardContainer:AddComponent(TacticalCardView, item.name)
    obj:SetData(self.extData)
  end)
end

function MailArmyPage:RemoveTacticalCard()
  if self.tacticalCardReq then
    self.tacticalCardContainer:RemoveAllComponentes()
    self:GameObjectDestroy(self.tacticalCardReq)
    self.tacticalCardReq = nil
  end
  self.tacticalCardContainer:SetActive(false)
end

local soldierEleven = "Assets/Main/Prefabs/UI/T11/T11SoldierBattleReport/T11SoldierBattleReport.prefab"

function MailArmyPage:RefreshSoldierEleven()
  self:RemoveSoldierEleven()
  local hasSoldierEleven, showPlayer1Skill, showPlayer2Skill = self.extData:IsHasSoldierEleven()
  if not hasSoldierEleven then
    self.soldierElevenContainer:SetActive(false)
    return
  end
  local fixedSoldierType = self.extData.fixedSoldierType
  self.soldierElevenContainer:SetActive(true)
  self.soldierElevenReq = self:GameObjectInstantiateAsync(soldierEleven, function(req)
    if IsNull(req.gameObject) then
      return
    end
    local item = req.gameObject
    item.name = "soldierEleven"
    item.transform:SetParent(self.soldierElevenContainer.transform)
    item.transform:Set_localScale(1, 1, 1)
    local obj = self.soldierElevenContainer:AddComponent(T11SoldierBattleReportComponent, item.name)
    obj:SetData(self.extData, showPlayer1Skill, showPlayer2Skill, fixedSoldierType)
  end)
end

function MailArmyPage:RemoveSoldierEleven()
  if self.soldierElevenReq then
    self.soldierElevenContainer:RemoveAllComponentes()
    self:GameObjectDestroy(self.soldierElevenReq)
    self.soldierElevenReq = nil
  end
  self.soldierElevenContainer:SetActive(false)
end

function MailArmyPage:RefreshSkinDecoration()
  self:RemoveSkinDecoration()
  local hasSkin1 = self.progress1.skinProgress ~= nil and checknumber(self.progress1.skinProgress.power) > 0
  local hasSkin2 = self.progress2.skinProgress ~= nil and 0 < checknumber(self.progress2.skinProgress.power)
  local hasSkin = hasSkin1 or hasSkin2
  if not hasSkin then
    self.skinContainer:SetActive(false)
    return
  end
  self.skinContainer:SetActive(true)
  self.skinViewReq = self:GameObjectInstantiateAsync(UIAssets.UILWMailBattleSkinView, function(req)
    if req.isError then
      return
    end
    local item = req.gameObject
    item.name = "UILWMailBattleSkinView"
    item.transform:SetParent(self.skinContainer.transform)
    item.transform:Set_localScale(1, 1, 1)
    local obj = self.skinContainer:AddComponent(UILWMailBattleSkinViewComponent, item.name)
    obj:ReInit(self.extData)
  end)
end

function MailArmyPage:RemoveSkinDecoration()
  if self.skinViewReq then
    self.skinContainer:RemoveAllComponentes()
    self:GameObjectDestroy(self.skinViewReq)
    self.skinViewReq = nil
  end
  self.skinContainer:SetActive(false)
end

return MailArmyPage
