local HeroOverview = BaseClass("HeroOverview", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local MailPageHeroInfoItem = require("UI.UILWMail.UILWMailMain.Component.BattleAIHelperComs.MailPageHeroInfoItem")

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local player1_frontHeroes_path = "PlayerInfo/Player1/rightHero1"
local player1_backHeroes_path = "PlayerInfo/Player1/leftHero1"
local player2_frontHeroes_path = "PlayerInfo/Player2/leftHero2"
local player2_backHeroes_path = "PlayerInfo/Player2/rightHero2"

local function GetHeroSlotPath(idx)
  local prefix
  if idx <= 2 then
    prefix = player1_frontHeroes_path
  elseif idx <= 5 then
    prefix = player1_backHeroes_path
  elseif idx <= 7 then
    prefix = player2_frontHeroes_path
  elseif idx <= 10 then
    prefix = player2_backHeroes_path
  elseif idx == 13 then
    prefix = player1_frontHeroes_path
  elseif idx == 14 then
    prefix = player2_frontHeroes_path
  end
  local path
  if prefix then
    path = string.format("%s/Hero%s", prefix, idx)
  end
  return path
end

local function ComponentDefine(self)
  self.heroCellSlots = {}
  self.player1_frontHeroes = self:AddComponent(UIHorizontalOrVerticalLayoutGroup, player1_frontHeroes_path)
  self.player1_backHeroes = self:AddComponent(UIBaseContainer, player1_backHeroes_path)
  self.player2_frontHeroes = self:AddComponent(UIHorizontalOrVerticalLayoutGroup, player2_frontHeroes_path)
  self.player2_backHeroes = self:AddComponent(UIBaseContainer, player2_backHeroes_path)
  local idx = 1
  for i = 1, 10 do
    local path = GetHeroSlotPath(i)
    self.heroCellSlots[idx] = self:AddComponent(UIBaseContainer, path)
    idx = idx + 1
  end
  self.heroCellSlots[13] = self:AddComponent(UIBaseContainer, GetHeroSlotPath(13))
  self.heroCellSlots[14] = self:AddComponent(UIBaseContainer, GetHeroSlotPath(14))
  self.power1_txt = self:AddComponent(UIText, "PlayerInfo/Player1/HorLayout/Power1")
  self.power2_txt = self:AddComponent(UIText, "PlayerInfo/Player2/HorLayout/Power2")
  self.replay_btn = self:AddComponent(UIButton, "PlayerInfo/ReplayBtn")
  self.replay_btn:LoadSprite("Assets/Main/Sprites/UI/UILWMail/lt_UImail_btn_replay.png")
  self.replay_btn:SetOnClick(function()
    self:OnReplayClick()
  end)
  self.overTitle_txt = self:AddComponent(UIText, "PlayerInfo/OverTitle/OverTitleText")
  self.overTitle_txt:SetLocalText(GameDialogDefine.OVER_ALL)
  self.tips1_btn = self:AddComponent(UIButton, "PlayerInfo/Player1/HorLayout/TipsBtn1")
  self.tips2_btn = self:AddComponent(UIButton, "PlayerInfo/Player2/HorLayout/TipsBtn2")
  self.tips1_btn:SetOnClick(function()
    self:ClickTipBtn(true)
  end)
  self.tips2_btn:SetOnClick(function()
    self:ClickTipBtn(false)
  end)
end

local function ComponentDestroy(self)
  if self.heroCells then
    self:RemoveComponents(MailPageHeroInfoItem)
    self.heroCells = nil
  end
  if self.heroCellReqs then
    for i, v in ipairs(self.heroCellReqs) do
      self:GameObjectDestroy(v)
    end
    self.heroCellReqs = nil
  end
  self.heroCellSlots = nil
  self.power1_txt = nil
  self.power2_txt = nil
  self.replay_btn = nil
  self.overTitle_txt = nil
  self.tips1_btn = nil
  self.tips2_btn = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.isNeedShowDetailPowerInfo = nil
end

local function SetData(self, extData)
  self.extData = extData
  self:RefreshHeroOverView()
end

function HeroOverview:OnLackSoldierTipsBtnClick(targetTipsBtn, soldierCount, soldierCapacity)
  local param = soldierCount / soldierCapacity * 100
  local integerPart, decimalPart = math.modf(param)
  local firstDecimalPart = math.floor(decimalPart * 10) % 10
  if 0 < firstDecimalPart then
    param = integerPart .. "." .. firstDecimalPart
  else
    param = integerPart
  end
  local content = Localization:GetString("458604", param)
  local position = targetTipsBtn.transform.position
  UIUtil:ShowSoldierNumBubbleTips(content, position, 0, -30, 0, nil, {
    soldierCount = math.floor(soldierCount),
    soldierCapacity = math.floor(soldierCapacity)
  })
end

local function GetHeroInfoData(self, index)
  if not self.extData or not self.extData.hero then
    return nil
  end
  local heroData = self.extData.hero[index]
  if not heroData then
    return nil
  end
  local red = heroData.red / heroData.black
  local green = heroData.green / heroData.black
  if heroData.index <= 5 then
    if self.extData.attackerWin and 0 < green then
      green = math.max(green, 0.1)
    end
  elseif not self.extData.attackerWin and 0 < green then
    green = math.max(green, 0.1)
  end
  local player = {}
  if heroData.index <= 5 then
    if self.extData.player then
      player = self.extData.player[1] or {}
    end
  elseif heroData.index > 5 and heroData.index <= 10 then
    if self.extData.player then
      player = self.extData.player[2] or {}
    end
  else
    local heroInfo = heroData.heroInfo
    for i = 1, #self.extData.player do
      local playerData = self.extData.player[i] or {}
      if heroInfo and heroInfo.meta and heroInfo.meta.heroData_type ~= HeroTemplateType.Dominator then
        local armyCfg = DataCenter.LWArmyTemplateManager:TryGetArmyTemplate(playerData.contentId)
        if armyCfg then
          player = self.extData.player[i] or {}
          break
        end
      else
        local armyCfg = DataCenter.LWArmyTemplateManager:TryGetArmyTemplate(playerData.contentId)
        if not armyCfg then
          player = self.extData.player[i] or {}
          break
        end
      end
    end
  end
  return {
    heroId = heroData.heroId,
    heroLevel = heroData.heroLevel,
    rankLv = heroData.rankLv,
    weaponLv = heroData.weaponLevel,
    red = red,
    green = green,
    player = player,
    heroInfo = heroData.heroInfo,
    awakenLv = heroData.awakenLv,
    heroSkinId = heroData.heroSkinId
  }
end

function HeroOverview:RefreshHeroOverView()
  if not self.extData or not self.extData.player[1] then
    if self.extData then
      Logger.LogError("RefreshHeroOverView self.extData.player[1] is nil, mail uuid:" .. self.extData.uuid)
    else
      Logger.LogError("RefreshHeroOverView self.extData is nil")
    end
  end
  local power = string.GetFormattedStr(math.floor(self.extData.player[1].totalHeroPower))
  local powerString = Localization:GetString(GameDialogDefine.BATTLE_POWER, power)
  self.power1_txt:SetText(powerString)
  if self.extData.battleType == MailBattleReportType.ActBoss or self.extData.battleType == MailBattleReportType.ALLIANCE_BOSS or self.extData.battleType == MailBattleReportType.ALLIANCE_MONSTER_CHALLENGE_KIROV or self.extData.battleType == MailBattleReportType.CITY_BATTLE_S1_REST_ATTACK_MONSTER or self.extData.battleType == MailBattleReportType.ALLIANCE_BOSS_S0 then
    self.power2_txt:SetLocalText(310165)
  else
    local showPower = ""
    showPower = string.GetFormattedStr(math.floor(self.extData.player[2].totalHeroPower))
    powerString = Localization:GetString(GameDialogDefine.BATTLE_POWER, showPower)
    self.power2_txt:SetText(powerString)
  end
  local s3_mummy_config_k7 = SeasonUtil.GetMummyConfigNum("k7", 1)
  local leftHasHero, rightHasHero
  self.leftHeroSoldierCapacity, self.leftHeroSoldierCount, self.rightHeroSoldierCapacity, self.rightHeroSoldierCount = 0, 0, 0, 0
  
  local function RefreshHeroAtSlot(i)
    local fixedSoldierType = self.extData.fixedSoldierType
    if not self.extData.hero[i] then
      if i <= 10 then
        if self.heroCells and self.heroCells[i] then
          self.heroCells[i]:SetActive(false)
        end
      elseif 13 <= i and i <= 14 then
        self.heroCellSlots[i]:SetActive(false)
      end
    else
      local heroData = self.extData.hero[i]
      local black_num = toInt(heroData.black)
      if fixedSoldierType == SoldierType.Mummy and s3_mummy_config_k7 ~= 0 and s3_mummy_config_k7 ~= 1 then
        black_num = math.ceil(black_num / s3_mummy_config_k7)
      end
      if i <= 5 then
        leftHasHero = true
        self.leftHeroSoldierCapacity = self.leftHeroSoldierCapacity + black_num
        self.leftHeroSoldierCount = self.leftHeroSoldierCount + heroData.red
      elseif i <= 10 then
        rightHasHero = true
        self.rightHeroSoldierCapacity = self.rightHeroSoldierCapacity + black_num
        self.rightHeroSoldierCount = self.rightHeroSoldierCount + heroData.red
      elseif i == 13 then
        leftHasHero = true
        self.leftHeroSoldierCapacity = self.leftHeroSoldierCapacity + black_num
        self.leftHeroSoldierCount = self.leftHeroSoldierCount + heroData.red
      elseif i == 14 then
        rightHasHero = true
        self.rightHeroSoldierCapacity = self.rightHeroSoldierCapacity + black_num
        self.rightHeroSoldierCount = self.rightHeroSoldierCount + heroData.red
      end
      if self.heroCells and self.heroCells[i] then
        if 13 <= i and i <= 14 then
          self.heroCellSlots[i]:SetActive(true)
        end
        self.heroCells[i]:SetActive(true)
        self.heroCells[i]:SetData(GetHeroInfoData(self, i))
      elseif not self.heroCellReqs or not self.heroCellReqs[i] then
        if not self.heroCellReqs then
          self.heroCellReqs = {}
        end
        self.heroCellReqs[i] = self:GameObjectInstantiateAsync(UIAssets.MailPageHeroInfoItem, function(req)
          local obj = req.gameObject
          if IsNull(obj) then
            return
          end
          if not self.heroCellSlots[i] then
            return
          end
          obj.transform:SetParent(self.heroCellSlots[i].transform)
          if 13 <= i and i <= 14 then
            self.heroCellSlots[i]:SetActive(true)
          end
          obj.transform:Set_localPosition(0, 0, 0)
          obj.transform:Set_localScale(1, 1, 1)
          local name = string.format("Hero%s", i)
          obj.name = name
          if not self.heroCells then
            self.heroCells = {}
          end
          local prefix = GetHeroSlotPath(i)
          self.heroCells[i] = self:AddComponent(MailPageHeroInfoItem, string.format("%s/%s", prefix, name))
          self.heroCells[i]:SetData(GetHeroInfoData(self, i))
        end)
      end
    end
  end
  
  for i = 1, 10 do
    RefreshHeroAtSlot(i)
  end
  for i = 1, 2 do
    RefreshHeroAtSlot(12 + i)
  end
  local showReplay = leftHasHero and rightHasHero and self.extData.pb_BattleReport.version >= 3 and DataCenter.BattleReportControlManager:NeedShow(UIMailRegion.ReplayBtn, self.extData.battleType)
  self.replay_btn:SetActive(showReplay)
  local isExistExtraPowerData = self:IsExistExtraPowerInfo(true) or self:IsExistExtraPowerInfo(false)
  self.isNeedShowDetailPowerInfo = self:CheckIsNeedShowDetailPowerInfo() and isExistExtraPowerData
  if not self.isNeedShowDetailPowerInfo then
    self.tips1_btn:SetActive(self.extData.player[1].armyType == MailTargetType.Player and self.leftHeroSoldierCount < self.leftHeroSoldierCapacity)
    self.tips2_btn:SetActive(self.extData.player[2].armyType == MailTargetType.Player and self.rightHeroSoldierCount < self.rightHeroSoldierCapacity)
  else
    self.tips1_btn:SetActive(self.extData.player[1].armyType == MailTargetType.Player)
    self.tips2_btn:SetActive(self.extData.player[2].armyType == MailTargetType.Player)
  end
  local startIndex = PVPBattleSlot.EnemyUav
  for i = 1, 2 do
    local hasDominator = self.extData.hero[startIndex + i] and self.extData.hero[startIndex + i].heroId > 0
    local container = i == 1 and self.player1_frontHeroes or self.player2_frontHeroes
    if hasDominator then
      container:SetPaddingTop(0)
    else
      container:SetPaddingTop(35)
    end
  end
end

function HeroOverview:OnReplayClick()
  if not self.extData then
    return
  end
  local uuid = self.extData.uuid
  local isAddressMode = BattleReportUtil.IsAddressMode(self.extData.address)
  local address = self.extData.address
  if self.extData.pb_BattleReport and self.extData.pb_BattleReport.round and self.extData.pb_BattleReport.round[1] and self.extData.pb_BattleReport.round[1].battle and self.extData.pb_BattleReport.round[1].battle[1] and self.extData.pb_BattleReport.round[1].battle[1].uuid then
    uuid = self.extData.pb_BattleReport.round[1].battle[1].uuid
    isAddressMode = BattleReportUtil.IsAddressMode(self.extData.pb_BattleReport.round[1].battle[1].address)
    address = self.extData.pb_BattleReport.round[1].battle[1].address
  end
  if BattleReportUtil.UseCDNBattleReport() then
    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIChampionDuelBattleLogDetail) then
      BattleReportUtil.Create(uuid, PVEEnterType.CD_BattleLog, nil, isAddressMode, address)
    else
      BattleReportUtil.Create(uuid, PVEEnterType.Mail, nil, isAddressMode, address)
    end
  else
    SFSNetwork.SendMessage(MsgDefines.MailGetFightReportDetail, uuid)
  end
  PostEventLog.Track(PostEventLog.Defines.click_enter_replay, {
    uuid = tostring(uuid)
  })
  self.replay_btn:LoadSprite("Assets/Main/Sprites/UI/UILWMail/ljq_zhanbao_shalou_di.png")
end

function HeroOverview:ClickTipBtn(isLeft)
  if self.isNeedShowDetailPowerInfo then
    self:ShowDetailPowerInfoTip(isLeft)
  else
    self:ShowLackSoldierTip(isLeft)
  end
end

function HeroOverview:ShowDetailPowerInfoTip(isLeft)
  local tips_btn = isLeft and self.tips1_btn or self.tips2_btn
  local player = self:GetCurPlayerInfoWithExtraPowerInfo(isLeft)
  local sourceData = {}
  sourceData.heroPower = player.powerTabMap[1] or 0
  sourceData.armyPower = player.powerTabMap[2] or 0
  sourceData.squadEquipPower = player.powerTabMap[3] or 0
  sourceData.otherPower = player.powerTabMap[4] or 0
  sourceData.dominatorPower = player.powerTabMap[5] or 0
  sourceData.totalPower = sourceData.heroPower + sourceData.armyPower + sourceData.squadEquipPower + sourceData.otherPower + sourceData.dominatorPower
  local extraEffectInfos = player.extraPowers
  sourceData.extraPowerInfo = extraEffectInfos
  local soldierNumInfo = {}
  local heroSoldierCount = isLeft and self.leftHeroSoldierCount or self.rightHeroSoldierCount
  local heroSoliderCapacity = isLeft and self.leftHeroSoldierCapacity or self.rightHeroSoldierCapacity
  soldierNumInfo.soldierCount = math.floor(heroSoldierCount)
  soldierNumInfo.soldierCapacity = math.floor(heroSoliderCapacity)
  soldierNumInfo.isShowLackSoldierTip = player.armyType == MailTargetType.Player and heroSoldierCount < heroSoliderCapacity
  local param = heroSoldierCount / heroSoliderCapacity
  local ratio = 0
  local playerId = isLeft and 1 or 2
  local cardAttrs = self.extData:ParsecCardAttrs(playerId)
  if cardAttrs then
    local effectId = LuaEntry.DataConfig:TryGetNum("battle_card_param", "k10", 0)
    if 0 < effectId and cardAttrs[effectId] and 0 < cardAttrs[effectId] then
      ratio = cardAttrs[effectId]
      local content2 = Localization:GetString("battle_card_supply", string.formatDecimalDown(ratio * 100, 1))
      soldierNumInfo.content2 = content2
    end
  end
  local t11Info = self.extData.player[playerId].soldierEleven
  if t11Info and t11Info.specialEffects then
    local t11EffectVal = 0
    for _, effect in ipairs(t11Info.specialEffects) do
      if effect.id == EffectDefine.LW_Effect_Id_42002 and effect.val and 0 < effect.val then
        t11EffectVal = effect.val
        break
      end
    end
    if 0 < t11EffectVal then
      ratio = ratio + t11EffectVal
      local t11Str = Localization:GetString("t11_supply", string.formatDecimalDown(t11EffectVal * 100, 1))
      if string.IsNullOrEmpty(soldierNumInfo.content2) then
        soldierNumInfo.content2 = t11Str
      else
        soldierNumInfo.content2 = soldierNumInfo.content2 .. "\n" .. t11Str
      end
    end
  end
  if 0 < ratio then
    local inverseSoldierCount = 1 - param
    local inverseRatio = 1 - ratio
    param = 1 - inverseSoldierCount * inverseRatio
  end
  param = param * 100
  local content = Localization:GetString("458604", string.formatDecimalDown(param, 2))
  soldierNumInfo.content = content
  local param = {
    position = tips_btn.transform.position,
    deltaX = 0,
    deltaY = -20,
    sourceData = sourceData,
    soldierNumInfo = soldierNumInfo
  }
  UIManager:GetInstance():OpenWindow(UIWindowNames.ArmyFormationDetailPowerTips, {anims = false}, param)
end

local function GetHeroDataByLeft(self, isLeft)
  local heroDataList = {}
  local leftStartIndex = 1
  local leftEndIndex = 5
  local rightStartIndnex = 6
  local rightEndIndex = 10
  local startIndex = isLeft and leftStartIndex or rightStartIndnex
  local endIndex = isLeft and leftEndIndex or rightEndIndex
  for i = startIndex, endIndex do
    local heroData = self:GetHeroData(i)
    table.insert(heroDataList, heroData)
  end
  return heroDataList
end

local function GetHeroData(self, index)
  if not self.extData or not self.extData.hero then
    return nil
  end
  local heroData = self.extData.hero[index]
  if not heroData then
    return nil
  end
  return self.extData.hero[index]
end

function HeroOverview:ShowLackSoldierTip(isLeft)
  local tips_btn = isLeft and self.tips1_btn or self.tips2_btn
  local heroSoldierCount = isLeft and self.leftHeroSoldierCount or self.rightHeroSoldierCount
  local heroSoliderCapacity = isLeft and self.leftHeroSoldierCapacity or self.leftHeroSoldierCapacity
  self:OnLackSoldierTipsBtnClick(tips_btn, heroSoldierCount, heroSoliderCapacity)
end

function HeroOverview:CheckIsNeedShowDetailPowerInfo()
  local unlockMainLv = LuaEntry.DataConfig:TryGetNum("power_new_unlock", "k1")
  local curMainLv = DataCenter.BuildManager.MainLv
  if not unlockMainLv or unlockMainLv > curMainLv then
    return false
  end
  local unlockServerDay = LuaEntry.DataConfig:TryGetNum("power_new_unlock", "k2")
  local openServerDay = UITimeManager:GetInstance():GetOpenServerDay()
  if not unlockServerDay or unlockServerDay > openServerDay then
    return false
  end
  return true
end

function HeroOverview:IsExistExtraPowerInfo(isLeft)
  local player = self:GetCurPlayerInfoWithExtraPowerInfo(isLeft)
  return player and player.powerTabMap and table.count(player.powerTabMap) > 0
end

function HeroOverview:GetCurPlayerInfoWithExtraPowerInfo(isLeft)
  if not self.extData then
    return nil
  end
  local ret
  local index = isLeft and 1 or 2
  local isMuster = self.extData.isMuster
  if isMuster then
    ret = self.extData.pb_BattleReport.combinePlayer[index].player
    if not (ret and ret.powerTabMap) or table.count(ret.powerTabMap) <= 0 then
      ret = self.extData.pb_BattleReport.player[index]
    end
  else
    ret = self.extData.pb_BattleReport.player[index]
    if not (ret and ret.powerTabMap) or table.count(ret.powerTabMap) <= 0 and self.extData.pb_BattleReport.combinePlayer[index] then
      ret = self.extData.pb_BattleReport.combinePlayer[index].player
    end
  end
  return ret
end

HeroOverview.OnCreate = OnCreate
HeroOverview.OnDestroy = OnDestroy
HeroOverview.OnEnable = OnEnable
HeroOverview.OnDisable = OnDisable
HeroOverview.ComponentDefine = ComponentDefine
HeroOverview.ComponentDestroy = ComponentDestroy
HeroOverview.DataDefine = DataDefine
HeroOverview.DataDestroy = DataDestroy
HeroOverview.SetData = SetData
HeroOverview.GetHeroData = GetHeroData
HeroOverview.GetHeroDataByLeft = GetHeroDataByLeft
return HeroOverview
