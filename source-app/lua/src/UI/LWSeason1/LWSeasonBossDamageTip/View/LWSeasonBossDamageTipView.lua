local base = UIBaseView
local LWSeasonBossDamageTipView = BaseClass("LWSeasonBossDamageTipView", base)
local UIHeroCellSmall = require("UI.UIHero2.Common.UIHeroCellSmall")
local DamageType = {TodayFirst = 1, MoreThanToday = 2}
local SettingByDamageType = {
  [DamageType.TodayFirst] = {
    iconImg = "wxy_bossshanghai_shuaxindi02",
    titleKey = "activity_s1pre_boss_pop_title_1",
    contentKey = "activity_s1pre_boss_pop_text_1",
    animName = "blue"
  },
  [DamageType.MoreThanToday] = {
    iconImg = "wxy_bossshanghai_shuaxindi02",
    titleKey = "activity_s1pre_boss_pop_title_2",
    contentKey = "activity_s1pre_boss_pop_text_2",
    animName = "blue"
  }
}
local CellBgPath = "Assets/Main/TextureEx/WorldBossDamageTip/%s"
local btn_ClosePanel_path = "ClosePanel"
local btn_CloseBtn_path = "PopUpTitle/CloseBtn"
local txt_Title1Text_path = "Root/Title1Text"
local txt_Title2Text_path = "Root/Title1Text/Title2Text"
local txt_CellTipText_path = "Root/CellBg/TipBg/CellTipText"
local cg_HeroContent_path = "Root/CellBg/HeroContent"
local txt_damageText_path = "Root/CellBg/DamageText"
local txt_Tip1Text_path = "Root/Tip1Text"
local btn_GoBtn_path = "Root/GoBtn"
local txt_BtnText_path = "Root/GoBtn/BtnBg/BtnText"
local btn_UIHeroCellSmall_path = "Root/CellBg/UIHeroCellSmall"
local txt_Tip2Text_path = "Root/Tip2Text"
local txt_Tip3Text_path = "Root/Tip3Text"
local rImg_CellBg_path = "Root/CellBg"
local go_UIPlayerHead_path = "Root/Progress/UIPlayerHead"
local txt_BossName_path = "Root/Progress/txt_BossName"
local sli_slider_path = "Root/Progress/slider"
local txt_progress_path = "Root/Progress/slider/txt_progress"

function LWSeasonBossDamageTipView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:InitData()
end

function LWSeasonBossDamageTipView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWSeasonBossDamageTipView:ComponentDefine()
  self.btn_ClosePanel = self:AddComponent(UIButton, btn_ClosePanel_path)
  self.btn_CloseBtn = self:AddComponent(UIButton, btn_CloseBtn_path)
  self.txt_Title1Text = self:AddComponent(UIText, txt_Title1Text_path)
  self.txt_Title2Text = self:AddComponent(UIText, txt_Title2Text_path)
  self.txt_CellTipText = self:AddComponent(UIText, txt_CellTipText_path)
  self.cg_HeroContent = self:AddComponent(UICanvasGroup, cg_HeroContent_path)
  self.txt_damageText = self:AddComponent(UIText, txt_damageText_path)
  self.txt_Tip1Text = self:AddComponent(UIText, txt_Tip1Text_path)
  self.btn_GoBtn = self:AddComponent(UIButton, btn_GoBtn_path)
  self.txt_BtnText = self:AddComponent(UIText, txt_BtnText_path)
  self.btn_UIHeroCellSmall = self:AddComponent(UIBaseContainer, btn_UIHeroCellSmall_path)
  self.txt_Tip2Text = self:AddComponent(UIText, txt_Tip2Text_path)
  self.txt_Tip3Text = self:AddComponent(UIText, txt_Tip3Text_path)
  self.rImg_CellBg = self:AddComponent(UIRawImage, rImg_CellBg_path)
  self.go_UIPlayerHead = self:AddComponent(UICommonHead, go_UIPlayerHead_path)
  self.txt_BossName = self:AddComponent(UIText, txt_BossName_path)
  self.sli_slider = self:AddComponent(UISlider, sli_slider_path)
  self.txt_progress = self:AddComponent(UIText, txt_progress_path)
  self.animator = self:AddComponent(UIAnimator, "")
  self.btn_ClosePanel:SetOnClick(function()
    self:OnBtnClosePanelClick()
  end)
  self.btn_CloseBtn:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.btn_GoBtn:SetOnClick(function()
    self:OnBtnGoClick()
  end)
  self.txt_CellTipText:SetLocalText("world_boss_damage_now")
  self.txt_BtnText:SetLocalText("world_boss_total_damage_btn")
  self.heroCellObj = self.btn_UIHeroCellSmall.gameObject
  self.heroCellObj:GameObjectCreatePool()
  DataCenter.LWSoundManager:PlaySound(1000110, false)
end

function LWSeasonBossDamageTipView:ComponentDestroy()
  self:RemoveHero()
  self.heroCellObj = nil
  self.animator = nil
  self.btn_ClosePanel = nil
  self.btn_CloseBtn = nil
  self.txt_Title1Text = nil
  self.txt_Title2Text = nil
  self.txt_CellTipText = nil
  self.cg_HeroContent = nil
  self.txt_damageText = nil
  self.txt_Tip1Text = nil
  self.btn_GoBtn = nil
  self.txt_BtnText = nil
  self.btn_UIHeroCellSmall = nil
  self.txt_Tip2Text = nil
  self.txt_Tip3Text = nil
  self.rImg_CellBg = nil
  self.go_UIPlayerHead = nil
  self.txt_BossName = nil
  self.sli_slider = nil
  self.txt_progress = nil
end

function LWSeasonBossDamageTipView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.WorldBossDamageRefresh, self.RefreshData)
end

function LWSeasonBossDamageTipView:OnRemoveListener()
  self:RemoveUIListener(EventId.WorldBossDamageRefresh, self.RefreshData)
  base.OnRemoveListener(self)
end

function LWSeasonBossDamageTipView:OnBtnClosePanelClick()
  self.ctrl:CloseSelf()
end

function LWSeasonBossDamageTipView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function LWSeasonBossDamageTipView:OnBtnGoClick()
  self.ctrl:CloseSelf()
end

function LWSeasonBossDamageTipView:InitData()
  local param = self:GetUserData()
  self:RefreshData(param)
end

function LWSeasonBossDamageTipView:RefreshData(param)
  local todayDamage = param.todayDamage
  local historyDamage = param.historyDamage
  local nowDamage = param.nowDamage
  local march = param.march
  self.monsterId = param.monsterId
  self.initHp = param.monsterInfo.initHp
  self.hp = param.monsterInfo.hp
  self.todayDamage = todayDamage
  self.damageType = DamageType.TodayFirst
  self.damageNum = nowDamage
  self.nowDamage = nowDamage
  self:InitHeroList(march)
  if todayDamage <= 0 then
    self.damageType = DamageType.TodayFirst
    self.damageNum = nowDamage
  elseif todayDamage < nowDamage then
    self.damageType = DamageType.MoreThanToday
    self.damageNum = nowDamage - todayDamage
  end
  self.setting = SettingByDamageType[self.damageType]
  self:Refresh()
end

function LWSeasonBossDamageTipView:InitHeroList(marchInfo)
  self.heroList = {}
  local armyUnit = PBController.ParsePb1(marchInfo.armyInfo, "protobuf.ArmyCombatUnit")
  if armyUnit and armyUnit.armyInfo then
    local heroesArr = armyUnit.armyInfo.heroes
    for k, heroData in pairs(heroesArr) do
      table.insert(self.heroList, heroData)
    end
  end
end

function LWSeasonBossDamageTipView:Refresh()
  self.animator:Play(self.setting.animName)
  self.rImg_CellBg:LoadSprite(string.format(CellBgPath, self.setting.iconImg))
  self.txt_Title1Text:SetLocalText(self.setting.titleKey)
  self.txt_Tip2Text:SetLocalText(self.setting.contentKey, string.GetFormattedSeparatorNum(self.damageNum))
  self.txt_damageText:SetText(string.GetFormattedSeparatorNum(self.nowDamage))
  self:RemoveHero()
  for i = 1, table.count(self.heroList) do
    local armyHeroInfo = self.heroList[i]
    local goObj = self.heroCellObj:GameObjectSpawn(self.cg_HeroContent.transform)
    goObj.name = "item_" .. i
    goObj:SetActive(true)
    local itemRender = self.cg_HeroContent:AddComponent(UIHeroCellSmall, goObj.name)
    itemRender:InitWithConfigId(armyHeroInfo.heroId, armyHeroInfo.heroQuality, armyHeroInfo.heroLevel, armyHeroInfo.rankLv, armyHeroInfo.weaponLevel, armyHeroInfo.awakenLv, armyHeroInfo.heroSkinId)
  end
  local playerInfo = DataCenter.MonsterTemplateManager:GetMonsterTemplate(self.monsterId)
  local pic = "Assets/Main/Sprites/HeroIconsSmall/" .. playerInfo.pic .. ".png"
  local headInfo = {pic = pic}
  self.go_UIPlayerHead:ParseHeadInfo(headInfo)
  self.txt_BossName:SetLocalText(playerInfo.name)
  if self.initHp <= 0 then
    self.sli_slider:SetValue(0)
  else
    self.sli_slider:SetValue(self.hp / self.initHp)
  end
  if self.damageType == DamageType.TodayFirst then
    local progress = math.min(self.nowDamage / self.initHp, 1)
    self.txt_progress:SetText("-" .. string.GetFormattedPercentTwoDecimalStr(progress))
  else
    local progress = math.min((self.nowDamage - self.todayDamage) / self.initHp, 1)
    self.txt_progress:SetText("-" .. string.GetFormattedPercentTwoDecimalStr(progress))
  end
end

function LWSeasonBossDamageTipView:RemoveHero()
  self.cg_HeroContent:RemoveComponents(UIHeroCellSmall)
  self.heroCellObj:GameObjectRecycleAll()
end

return LWSeasonBossDamageTipView
