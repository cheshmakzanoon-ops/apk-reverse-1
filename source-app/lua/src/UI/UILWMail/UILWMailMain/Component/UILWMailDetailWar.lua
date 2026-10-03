local base = require("UI.UILWMail.UILWMailMain.Component.UILWMailDetailBase")
local UILWMailDetailWar = BaseClass("UILWMailDetailWar", base)
local MainResistanceInfo = require("UI.UILWMail.UILWMailMain.Component.MainResistanceInfo")
local MainVirusInfo = require("UI.UILWMail.UILWMailMain.Component.MainVirusInfo")
local MailBattleReportIdCell = require("UI.UILWMail.UILWMailMain.Component.MailBattleReportIdCell")
local MonsterBuffComponent = require("UI.UIWorldPoint.Component.MonsterBuffComponent")
local MailBattleReportType = _ENV.MailBattleReportType
local PageEnum = {
  AIHelper = 1,
  Hero = 2,
  Army = 3,
  Damage = 4,
  MAX = 4
}
local PagePath = {
  [PageEnum.Hero] = "Assets/Main/Prefabs/UI/LWMail/HeroPage.prefab",
  [PageEnum.Army] = "Assets/Main/Prefabs/UI/LWMail/ArmyPage.prefab",
  [PageEnum.Damage] = "Assets/Main/Prefabs/UI/LWMail/DamagePage.prefab",
  [PageEnum.AIHelper] = "Assets/Main/Prefabs/UI/LWMail/AIHelper/BattleHelperPage.prefab"
}
local PageScript = {
  [PageEnum.Hero] = require("UI.UILWMail.UILWMailMain.Component.MailHeroPage"),
  [PageEnum.Army] = require("UI.UILWMail.UILWMailMain.Component.MailArmyPage"),
  [PageEnum.Damage] = require("UI.UILWMail.UILWMailMain.Component.MailDamagePage"),
  [PageEnum.AIHelper] = require("UI.UILWMail.UILWMailMain.Component.MailBattleHelperPage")
}
local ToggleLangKey = {
  [PageEnum.Hero] = GameDialogDefine.REASON_HERO,
  [PageEnum.Army] = GameDialogDefine.ARMY,
  [PageEnum.Damage] = GameDialogDefine.MAIL_DAMAGE_STAT,
  [PageEnum.AIHelper] = GameDialogDefine.MAIL_BATTLE_HELPER
}

function UILWMailDetailWar:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWMailDetailWar:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWMailDetailWar:DataDefine()
  self.mailData = {}
  self.refreshed = {}
end

function UILWMailDetailWar:DataDestroy()
  self.mailData = nil
end

function UILWMailDetailWar:OnEnable()
  base.OnEnable(self)
end

function UILWMailDetailWar:OnDisable()
  base.OnDisable(self)
end

function UILWMailDetailWar:OnAddListener()
  base.OnAddListener(self)
end

function UILWMailDetailWar:OnRemoveListener()
  base.OnRemoveListener(self)
end

local prefix = "ScrollView/Viewport/Content/"

function UILWMailDetailWar:ComponentDefine()
  self.coordinateText = self:AddComponent(UIText, prefix .. "CoordinateText")
  local coordinateBtn = self:AddComponent(UIButton, prefix .. "CoordinateText")
  self.timeText = self:AddComponent(UIText, prefix .. "TimeText")
  coordinateBtn:SetOnClick(function()
    self:OnJumpClick()
  end)
  self.coordinateText1 = self:AddComponent(UIText, prefix .. "banner/CoordinateText1")
  local coordinateBtn1 = self:AddComponent(UIButton, prefix .. "banner/CoordinateText1")
  coordinateBtn1:SetOnClick(function()
    self:OnJumpClick1()
  end)
  self.coordinateText2 = self:AddComponent(UIText, prefix .. "banner/CoordinateText2")
  local coordinateBtn2 = self:AddComponent(UIButton, prefix .. "banner/CoordinateText2")
  coordinateBtn2:SetOnClick(function()
    self:OnJumpClick2()
  end)
  self.cityNodeRoot = self:AddComponent(UIBaseContainer, prefix .. "cityNodeRoot")
  self.content = self:AddComponent(UIBaseContainer, prefix)
  self.cityNode = self:AddComponent(UIBaseComponent, prefix .. "cityNode")
  self.cityIcon = self:AddComponent(UIImage, prefix .. "cityNode/cityIcon")
  self.cityLvText = self:AddComponent(UIText, prefix .. "cityNode/cityLvText")
  self.cityNameText = self:AddComponent(UIText, prefix .. "cityNode/cityNameText")
  self.citySliderYellow = self:AddComponent(UISlider, prefix .. "cityNode/citySliderYellow")
  self.citySliderRed = self:AddComponent(UISlider, prefix .. "cityNode/citySliderRed")
  self.citySliderText = self:AddComponent(UIText, prefix .. "cityNode/citySliderText")
  self.rootHpLost = self:AddComponent(UIBaseContainer, prefix .. "cityNode/CityIconBubble")
  self.cityHpLost = self:AddComponent(UIText, prefix .. "cityNode/CityIconBubble/cityHpLost")
  self.skillHpLost = self:AddComponent(UIText, prefix .. "cityNode/CityIconBubble/skillHpLost")
  self.leaderRoot = self:AddComponent(UIBaseComponent, prefix .. "banner")
  self.leaderBgImg = self:AddComponent(UIRawImage, prefix .. "banner/bg")
  self.leaderHead1 = self:AddComponent(UICommonHead, prefix .. "banner/head1")
  self.leaderHead2 = self:AddComponent(UICommonHead, prefix .. "banner/head2")
  self.leaderName1 = self:AddComponent(UIText, prefix .. "banner/PlayerName1")
  self.leaderName2 = self:AddComponent(UIText, prefix .. "banner/PlayerName2")
  self.anonymityBtn1 = self:AddComponent(UIButton, prefix .. "banner/anonymityBtn1")
  self.anonymityBtn1:SetOnClick(function()
    self:OnClickAnonymityBtn1()
  end)
  self.anonymityBtn2 = self:AddComponent(UIButton, prefix .. "banner/anonymityBtn2")
  self.anonymityBtn2:SetOnClick(function()
    self:OnClickAnonymityBtn2()
  end)
  self.winNode = self:AddComponent(UIBaseComponent, prefix .. "banner/Win")
  self.loseNode = self:AddComponent(UIBaseComponent, prefix .. "banner/Lose")
  self.WinText1 = self:AddComponent(UIText, prefix .. "banner/Win/WinText1")
  self.WinText1:SetLocalText("battle_report_attack_victory_limit4")
  self.WinText2 = self:AddComponent(UIText, prefix .. "banner/Lose/WinText2")
  self.WinText2:SetLocalText("battle_report_defend_victory_limit4")
  self.LoseText1 = self:AddComponent(UIText, prefix .. "banner/Win/LoseText1")
  self.LoseText1:SetLocalText("battle_report_defend_defeat_limit4")
  self.LoseText2 = self:AddComponent(UIText, prefix .. "banner/Lose/LoseText2")
  self.LoseText2:SetLocalText("battle_report_attack_defeat_limit4")
  self.lostPowerGo = self:AddComponent(UIBaseContainer, prefix .. "banner/lostPower")
  self.leaderSlider1 = self:AddComponent(UISlider, prefix .. "banner/lostPower/SoldierSlider1")
  self.leaderSlider2 = self:AddComponent(UISlider, prefix .. "banner/lostPower/SoldierSlider2")
  self.sliderText1 = self:AddComponent(UIText, prefix .. "banner/lostPower/SliderText1")
  self.sliderText2 = self:AddComponent(UIText, prefix .. "banner/lostPower/SliderText2")
  self.ResistanceRoot = self:AddComponent(MainResistanceInfo, prefix .. "KangXingRoot")
  self.VirusRoot = self:AddComponent(MainVirusInfo, prefix .. "KangXingVirusRoot")
  self.MonsterBuff = self:AddComponent(MonsterBuffComponent, prefix .. "MonsterBuff")
  self.act_boss_dmg = self:AddComponent(UIBaseContainer, prefix .. "ActBossDmg")
  self.boss_dmg_text2 = self:AddComponent(UIText, prefix .. "ActBossDmg/bossDmgText2")
  self.criticalLabel = self:AddComponent(UIImage, prefix .. "ActBossDmg/bossDmgText2/criticalLabel")
  self.criticalLabel:SetActive(false)
  self.aisillaDmg = self:AddComponent(UIBaseContainer, prefix .. "AisillaDmg")
  self.aisillaDmgText = self:AddComponent(UIText, prefix .. "AisillaDmg/AisillaDmgText")
  self.resNode = self:AddComponent(UIBaseComponent, prefix .. "ResNode")
  self.resText = self:AddComponent(UIText, prefix .. "ResNode/ResText")
  self.weightNode = self:AddComponent(UIBaseComponent, prefix .. "ResNode/Weight")
  self.weightText = self:AddComponent(UIText, prefix .. "ResNode/Weight/WeightText")
  self.weightText:SetLocalText(GameDialogDefine.MAIL_WEIGHT)
  self.weightNum = self:AddComponent(UIText, prefix .. "ResNode/Weight/WeightNum")
  self.weightBtn = self:AddComponent(UIButton, prefix .. "ResNode/Weight/WeightBtn")
  self.weightBtn:SetOnClick(function()
    self:OnWeightClick()
  end)
  self.rewardItem = self.transform:Find("MailResItem").gameObject
  self.rewardItem:GameObjectCreatePool()
  self.rewardItem:SetActive(false)
  self.rewardContent = self:AddComponent(UIBaseContainer, prefix .. "ResNode/Viewport/resContent")
  self.toggle = {}
  self.toggleShowState = {}
  self.toggleGroup = self:AddComponent(UIBaseComponent, prefix .. "ToggleView/Viewport/ToggleGroup")
  self.checkActiveTxts = {}
  self.checkInactiveTxts = {}
  for i = 1, PageEnum.MAX do
    self.toggle[i] = self:AddComponent(UIToggle, prefix .. "ToggleView/Viewport/ToggleGroup/Toggle" .. i)
    self.checkInactiveTxts[i] = self:AddComponent(UIText, string.format("%sToggleView/Viewport/ToggleGroup/Toggle%s/checkInactive_txt%s", prefix, i, i))
    self.checkActiveTxts[i] = self:AddComponent(UIText, string.format("%sToggleView/Viewport/ToggleGroup/Toggle%s/checkActive_txt%s", prefix, i, i))
    self.checkActiveTxts[i]:SetLocalText(ToggleLangKey[i])
    self.checkInactiveTxts[i]:SetLocalText(ToggleLangKey[i])
    self.toggle[i]:SetOnValueChanged(function(t)
      if t then
        self:ShowPage(i)
      end
    end)
    self.toggleShowState[i] = true
  end
  self.pages = {}
  self.req = {}
  self.overtimeTip = self:AddComponent(UIText, prefix .. "overtimeTip")
  self.battleReportIdCell = self:AddComponent(MailBattleReportIdCell, "BattleReportIdCell")
end

function UILWMailDetailWar:ComponentDestroy()
  for i = 1, #PageScript do
    self.content:RemoveComponents(PageScript[i])
  end
  self.pages = {}
  for _, v in pairs(self.req) do
    v:Destroy()
  end
  self.req = {}
  self:ClearReward()
  self.coordinateText = nil
  self.timeText = nil
  self.leaderName1 = nil
  self.leaderName2 = nil
  self.winNode = nil
  self.loseNode = nil
  self.leaderSlider1 = nil
  self.leaderSlider2 = nil
  self.sliderText1 = nil
  self.sliderText2 = nil
  self.resNode = nil
  self.resText = nil
  self.resIcon1 = nil
  self.resNum1 = nil
  self.resIcon2 = nil
  self.resNum2 = nil
  self.resIcon3 = nil
  self.resNum3 = nil
  self.heroCells = nil
  self.heroReds = nil
  self.heroGreens = nil
  self.rewardItem = nil
  self.rewardContent = nil
  self.BackText1 = nil
  self.CheckText1 = nil
  self.BackText2 = nil
  self.CheckText2 = nil
  self.BackText3 = nil
  self.CheckText3 = nil
  self.Power1 = nil
  self.Power2 = nil
  self.propertyCell = nil
  self.propertyContent = nil
  self.soldierCell = nil
  self.soldierContent = nil
  self.act_boss_dmg = nil
  self.boss_dmg_text2 = nil
  self.criticalLabel = nil
  self.lostPowerGo = nil
  self.EquipItem = nil
  self.EquipContent = nil
  self.SkillItem = nil
  self.SkillContent = nil
  self.aisillaDmg = nil
  self.aisillaDmgText = nil
  self.battleReportIdCell = nil
end

function UILWMailDetailWar:RefreshContent()
  self:RefreshData()
  self:RefreshView()
  if self.mailData and self.mailData:HasMummyJoin() then
    self.leaderBgImg:LoadSprite("Assets/Main/SeasonRes/Shared/Textures/MummyAttack/ljq_zhanbao_banner.png")
  else
    self.leaderBgImg:LoadSprite("Assets/Main/TextureEx/UILWMail/ljq_zhanbao_beijing_01.png")
  end
end

function UILWMailDetailWar:RefreshData()
  self.mailData = self.view.ctrl:GetCurrentMailData()
  self.extData = self.mailData:GetMailExt()
  if self.extData.isMuster then
    self.extData = self.view.ctrl:GetMusterSoloMailData()
    self.battleReportIdCell:SetData(self.extData.uuid)
  else
    local uuid = self.extData.uuid
    if self.extData.pb_BattleReport and self.extData.pb_BattleReport.round and self.extData.pb_BattleReport.round[1] and self.extData.pb_BattleReport.round[1].battle and self.extData.pb_BattleReport.round[1].battle[1] and self.extData.pb_BattleReport.round[1].battle[1].uuid then
      uuid = self.extData.pb_BattleReport.round[1].battle[1].uuid
    end
    self.battleReportIdCell:SetData(uuid)
  end
  self.pageRefreshed = {}
end

function UILWMailDetailWar:IsShowAIHelper()
  local advices = self.extData:GetHelperAdvices()
  return not table.IsNullOrEmpty(advices)
end

function UILWMailDetailWar:RefreshView()
  self:ShowTop(false)
  self:RefreshAssistanceStatus()
  self:ShowActBoss()
  local player1 = self.extData.player[1]
  local player2 = self.extData.player[2]
  local showArmyPage = player1.progress and player2.progress and (player2.armyType == MailTargetType.Player or player2.armyType == MailTargetType.SeasonOutpost)
  self.toggle[PageEnum.Army]:SetActive(showArmyPage)
  self.toggleShowState[PageEnum.Army] = showArmyPage
  local isShowAIHelper = self:IsShowAIHelper()
  self.toggle[PageEnum.AIHelper]:SetActive(isShowAIHelper)
  self.toggleShowState[PageEnum.AIHelper] = isShowAIHelper
  if isShowAIHelper then
    self.toggle[PageEnum.AIHelper]:SetIsOn(true)
    self:ShowPage(PageEnum.AIHelper)
  else
    self.toggle[PageEnum.Hero]:SetIsOn(true)
    self:ShowPage(PageEnum.Hero)
  end
  self.overtimeTip:SetActive(self.extData.overTime == PVPBattleOvertimeType.Overtime)
  self.content:SetAnchoredPosition(Vector2.zero)
  self.toggleGroup:SetAnchoredPosition(Vector2.zero)
end

function UILWMailDetailWar:RefreshAssistanceStatus()
  local data = self.extData
  if data.battleType ~= MailBattleReportType.City then
    self.LoseText2:SetLocalText("battle_report_attack_defeat_limit4")
    self.WinText2:SetLocalText("battle_report_defend_victory_limit4")
    return
  end
  if not data:IsAssistanceProtectedCity() then
    self.LoseText2:SetLocalText("battle_report_attack_defeat_limit4")
    self.WinText2:SetLocalText("battle_report_defend_victory_limit4")
    return
  end
  if data.attackerWin then
    self.LoseText2:SetLocalText("world_tip10022")
  else
    self.WinText2:SetLocalText("world_tip10021")
  end
end

function UILWMailDetailWar:ShowActBoss()
  if self.extData.battleType == MailBattleReportType.ActBoss or self.extData.battleType == MailBattleReportType.ACT_BERSERK_BOSS or self.extData.battleType == MailBattleReportType.CITY_BATTLE_S1_REST_ATTACK_MONSTER then
    self.act_boss_dmg:SetActive(true)
    local combinePlayer = self.extData.pb_BattleReport.combinePlayer[1]
    if not combinePlayer.totalDamageDouble then
      self.boss_dmg_text2:SetLocalText(129013)
    else
      local total = combinePlayer.totalDamageDouble == 0 and combinePlayer.totalDamage or combinePlayer.totalDamageDouble
      self.boss_dmg_text2:SetText(string.GetFormattedSeperatorNum(math.ceil(total)))
    end
    self.lostPowerGo:SetActive(false)
  elseif self.extData.battleType == MailBattleReportType.ALLIANCE_BOSS or self.extData.battleType == MailBattleReportType.ALLIANCE_BOSS_S0 then
    self.act_boss_dmg:SetActive(true)
    local totalDamage = 0
    local parentMailData = self.view.ctrl:GetCurrentMailData()
    local parentExtData = parentMailData:GetMailExt()
    local allBossSandValid = parentExtData.pb_BattleReport.allianceBossSand and 0 < #parentExtData.pb_BattleReport.allianceBossSand
    if allBossSandValid then
      for _, v in ipairs(parentExtData.pb_BattleReport.allianceBossSand) do
        if v.uid and v.uid == self.extData.player[1].uid then
          totalDamage = v.damage
          self.boss_dmg_text2:SetText(string.GetFormattedSeperatorNum(math.ceil(totalDamage)))
          local isCrit = false
          if v.isCrit then
            isCrit = true
          end
          self.criticalLabel:SetActive(isCrit)
          break
        end
      end
    else
      for _, v in pairs(parentExtData.pb_BattleReport.combinePlayer) do
        if v.player.uid and v.player.uid == self.extData.player[1].uid then
          totalDamage = v.totalDamageDouble
          self.boss_dmg_text2:SetText(string.GetFormattedSeperatorNum(math.ceil(totalDamage)))
          break
        end
      end
    end
    self.lostPowerGo:SetActive(false)
  elseif self.extData.battleType == MailBattleReportType.MONSTER_INVASION_BOSS then
    self.lostPowerGo:SetActive(false)
    self.act_boss_dmg:SetActive(false)
    if self.extData.monsterInvasionInfo then
      self.aisillaDmg:SetActive(true)
      local monsterInvasionInfo = self.extData.monsterInvasionInfo
      local dmg = monsterInvasionInfo.damage or 0
      local hp = monsterInvasionInfo.curHp or 0
      local contextId
      if monsterInvasionInfo.isCrit then
        contextId = "activity_godzilla_attack_crit"
      else
        contextId = "activity_godzilla_attack"
      end
      self.aisillaDmgText:SetLocalText(contextId, string.GetFormattedSeperatorNum(dmg), hp)
    end
  elseif self.extData.battleType == MailBattleReportType.ALLIANCE_MONSTER_CHALLENGE_KIROV then
    self.act_boss_dmg:SetActive(true)
    local totalDamage = 0
    local parentMailData = self.view.ctrl:GetCurrentMailData()
    local parentExtData = parentMailData:GetMailExt()
    if parentExtData and parentExtData.pb_BattleReport and parentExtData.pb_BattleReport.combinePlayer then
      for _, v in pairs(parentExtData.pb_BattleReport.combinePlayer) do
        if v.player.uid and v.player.uid == self.extData.player[1].uid then
          totalDamage = v.totalDamageDouble
          self.boss_dmg_text2:SetText(string.GetFormattedSeperatorNum(math.ceil(totalDamage)))
          break
        end
      end
    end
    self.lostPowerGo:SetActive(false)
  else
    self.act_boss_dmg:SetActive(false)
    self.lostPowerGo:SetActive(true)
  end
  if self.extData.battleType ~= MailBattleReportType.MONSTER_INVASION_BOSS then
    self.aisillaDmg:SetActive(false)
  end
end

function UILWMailDetailWar:ShowPage(pageIndex)
  if self.isLoading then
    return
  end
  for i = 1, PageEnum.MAX do
    if self.toggleShowState[i] then
      self.checkActiveTxts[i]:SetEnable(i == pageIndex)
      self.checkInactiveTxts[i]:SetEnable(i ~= pageIndex)
    end
  end
  for _, v in pairs(self.pages) do
    v:SetActive(false)
  end
  if self.pages[pageIndex] then
    self.pages[pageIndex]:SetActive(true)
    if not self.pageRefreshed[pageIndex] then
      self.pages[pageIndex]:Refresh(self.extData)
      self.pageRefreshed[pageIndex] = true
    end
  else
    self.isLoading = true
    self.req[pageIndex] = self:GameObjectInstantiateAsync(PagePath[pageIndex], function(req)
      if IsNull(req) then
        return
      end
      local gameObject = req.gameObject
      local transform = gameObject.transform
      gameObject:SetActive(true)
      transform:SetParent(self.content.transform)
      transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      local name = gameObject.name
      self.isLoading = false
      self.pages[pageIndex] = self.content:AddComponent(PageScript[pageIndex], name)
      self.pages[pageIndex]:Refresh(self.extData)
      self.pageRefreshed[pageIndex] = true
    end)
  end
end

function UILWMailDetailWar:ShowAnonymityBtn1()
  TimerManager:GetInstance():DelayFrameInvoke(function()
    if not self.leaderName1 then
      return
    end
    local pos = self.leaderName1:GetLocalPosition()
    local width = self.leaderName1:GetWidth() + self.anonymityBtn1:GetSizeDelta().x * 0.5
    pos.x = pos.x + width
    self.anonymityBtn1:SetLocalPosition(pos)
    self.anonymityBtn1:SetActive(true)
  end, 2)
end

function UILWMailDetailWar:ShowAnonymityBtn2()
  TimerManager:GetInstance():DelayFrameInvoke(function()
    if not self.leaderName2 then
      return
    end
    local pos = self.leaderName2:GetLocalPosition()
    local width = self.leaderName2:GetWidth() + self.anonymityBtn2:GetSizeDelta().x * 0.5
    pos.x = pos.x - width
    self.anonymityBtn2:SetLocalPosition(pos)
    self.anonymityBtn2:SetActive(true)
  end, 2)
end

return UILWMailDetailWar
