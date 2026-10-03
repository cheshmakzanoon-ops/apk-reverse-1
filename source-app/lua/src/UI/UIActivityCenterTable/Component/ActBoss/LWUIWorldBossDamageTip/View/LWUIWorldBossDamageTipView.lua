local LWUIWorldBossDamageTipView = BaseClass("LWUIWorldBossDamageTipView", UIBaseView)
local UIHeroCellSmall = require("UI.UIHero2.Common.UIHeroCellSmall")
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local DamageType = {
  TodayFirst = 1,
  MoreThanToday = 2,
  HistoryFirst = 3,
  MoreThanHistory = 4
}
local SettingByDamageType = {
  [DamageType.TodayFirst] = {
    iconImg = "wxy_bossshanghai_shuaxindi02",
    titleKey = "world_boss_today_damage_title",
    contentKey = "world_boss_today_damage_first_desc",
    animName = "blue"
  },
  [DamageType.MoreThanToday] = {
    iconImg = "wxy_bossshanghai_shuaxindi02",
    titleKey = "world_boss_today_damage_title",
    contentKey = "world_boss_today_damage_desc",
    animName = "blue"
  },
  [DamageType.HistoryFirst] = {
    iconImg = "wxy_bossshanghai_shuaxindi01",
    titleKey = "world_boss_total_damage_title",
    contentKey = "world_boss_total_damage_first_desc",
    animName = "gold"
  },
  [DamageType.MoreThanHistory] = {
    iconImg = "wxy_bossshanghai_shuaxindi01",
    titleKey = "world_boss_total_damage_title",
    contentKey = "world_boss_total_damage_desc",
    animName = "gold"
  }
}
local CellBgPath = "Assets/Main/TextureEx/WorldBossDamageTip/%s"

function LWUIWorldBossDamageTipView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWUIWorldBossDamageTipView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIWorldBossDamageTipView:ComponentDefine()
  self.btnClosePanel = self:AddComponent(UIButton, "ClosePanel")
  self.btnClosePanel:SetOnClick(function()
    self:OnBtnClosePanelClick()
  end)
  self.btnClose = self:AddComponent(UIButton, "PopUpTitle/CloseBtn")
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.textTitle1 = self:AddComponent(UITextMeshProUGUIEx, "Root/Title1Text")
  self.textTitle2 = self:AddComponent(UITextMeshProUGUIEx, "Root/Title1Text/Title2Text")
  self.rawImgCellBg = self:AddComponent(UIRawImage, "Root/CellBg")
  self.textCellTip = self:AddComponent(UITextMeshProUGUIEx, "Root/CellBg/TipBg/CellTipText")
  self.compHeroContent = self:AddComponent(UIBaseContainer, "Root/CellBg/HeroContent")
  self.compUIHeroCellSmall = self:AddComponent(UIBaseComponent, "Root/CellBg/UIHeroCellSmall")
  self.textDamage = self:AddComponent(UITextMeshProUGUIEx, "Root/CellBg/DamageText")
  self.textTip1 = self:AddComponent(UITextMeshProUGUIEx, "Root/Tip1Text")
  self.textTip2 = self:AddComponent(UITextMeshProUGUIEx, "Root/Tip2Text")
  self.textTip3 = self:AddComponent(UITextMeshProUGUIEx, "Root/Tip3Text")
  self.btnGo = self:AddComponent(UIButton, "Root/GoBtn")
  self.btnGo:SetOnClick(function()
    self:OnBtnGoClick()
  end)
  self.textBtn = self:AddComponent(UITextMeshProUGUIEx, "Root/GoBtn/BtnBg/BtnText")
  self.animator = self:AddComponent(UIAnimator, "")
  self.heroCellObj = self.compUIHeroCellSmall.gameObject
  self.heroCellObj:GameObjectCreatePool()
  self.textCellTip:SetLocalText("world_boss_damage_now")
  self.textBtn:SetLocalText("world_boss_total_damage_btn")
  self.btnShare = self:AddComponent(UIButton, "Root/shareBtn")
  self.btnShare:SetOnClick(function()
    self:OnShareBtnClick()
  end)
end

function LWUIWorldBossDamageTipView:ComponentDestroy()
  self:RemoveHero()
  self.heroCellObj = nil
  self.btnShare = nil
  self.btnClosePanel = nil
  self.btnClose = nil
  self.textTitle1 = nil
  self.textTitle2 = nil
  self.rawImgCellBg = nil
  self.textCellTip = nil
  self.compHeroContent = nil
  self.compUIHeroCellSmall = nil
  self.textDamage = nil
  self.textTip1 = nil
  self.textTip2 = nil
  self.textTip3 = nil
  self.btnGo = nil
  self.textBtn = nil
  self.animator = nil
end

function LWUIWorldBossDamageTipView:DataDefine()
  local param = self:GetUserData()
  self:RefreshData(param)
end

function LWUIWorldBossDamageTipView:RefreshData(param)
  local todayDamage = param.todayDamage
  local historyDamage = param.historyDamage
  local nowDamage = param.nowDamage
  local march = param.march
  self.damageType = DamageType.TodayFirst
  self.damageNum = nowDamage
  self.nowDamage = nowDamage
  self:InitHeroList(march)
  if historyDamage <= 0 then
    self.damageType = DamageType.HistoryFirst
    self.damageNum = nowDamage
  elseif historyDamage < nowDamage then
    self.damageType = DamageType.MoreThanHistory
    self.damageNum = nowDamage - historyDamage
  elseif todayDamage <= 0 then
    self.damageType = DamageType.TodayFirst
    self.damageNum = nowDamage
  elseif todayDamage < nowDamage then
    self.damageType = DamageType.MoreThanToday
    self.damageNum = nowDamage - todayDamage
  end
  self.setting = SettingByDamageType[self.damageType]
  self:Refresh()
end

function LWUIWorldBossDamageTipView:DataDestroy()
  self.damageType = nil
  self.damageNum = nil
  self.setting = nil
  self.nowDamage = nil
  self.marchInfo = nil
end

function LWUIWorldBossDamageTipView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.WorldBossDamageRefresh, self.RefreshData)
end

function LWUIWorldBossDamageTipView:OnRemoveListener()
  self:RemoveUIListener(EventId.WorldBossDamageRefresh, self.RefreshData)
  base.OnRemoveListener(self)
end

function LWUIWorldBossDamageTipView:OnBtnClosePanelClick()
  self.ctrl:CloseSelf()
end

function LWUIWorldBossDamageTipView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function LWUIWorldBossDamageTipView:OnBtnGoClick()
  self.ctrl:CloseSelf()
end

function LWUIWorldBossDamageTipView:Refresh()
  self.animator:Play(self.setting.animName)
  self.rawImgCellBg:LoadSprite(string.format(CellBgPath, self.setting.iconImg))
  self.textTitle1:SetLocalText(self.setting.titleKey)
  self.textTip2:SetLocalText(self.setting.contentKey, string.GetFormattedSeparatorNum(self.damageNum))
  self.textDamage:SetText(string.GetFormattedSeparatorNum(self.nowDamage))
  self:RemoveHero()
  for i = 1, table.count(self.heroList) do
    local armyHeroInfo = self.heroList[i]
    local goObj = self.heroCellObj:GameObjectSpawn(self.compHeroContent.transform)
    goObj.name = "item_" .. i
    goObj:SetActive(true)
    local itemRender = self.compHeroContent:AddComponent(UIHeroCellSmall, goObj.name)
    itemRender:InitWithConfigId(armyHeroInfo.heroId, armyHeroInfo.heroQuality, armyHeroInfo.heroLevel, armyHeroInfo.rankLv, armyHeroInfo.weaponLevel, armyHeroInfo.awakenLv, armyHeroInfo.heroSkinId)
  end
end

function LWUIWorldBossDamageTipView:InitHeroList(marchInfo)
  self.heroList = {}
  local armyUnit = PBController.ParsePb1(marchInfo.armyInfo, "protobuf.ArmyCombatUnit")
  if armyUnit and armyUnit.armyInfo then
    local heroesArr = armyUnit.armyInfo.heroes
    for k, heroData in pairs(heroesArr) do
      table.insert(self.heroList, heroData)
    end
  end
end

function LWUIWorldBossDamageTipView:RemoveHero()
  self.compHeroContent:RemoveComponents(UIHeroCellSmall)
  self.heroCellObj:GameObjectRecycleAll()
end

function LWUIWorldBossDamageTipView:OnShareBtnClick()
  local share_param = {}
  share_param.postType = PostType.WorldBossNewRecord
  share_param.damageNum = string.GetFormattedSeparatorNum(self.nowDamage)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPositionShare, {anim = true}, share_param)
end

return LWUIWorldBossDamageTipView
