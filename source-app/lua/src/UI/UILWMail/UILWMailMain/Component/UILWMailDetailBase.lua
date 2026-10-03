local UILWMailDetailBase = BaseClass("UILWMailDetailBase", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local MailBattleParseHelper = require("DataCenter.MailData.MailBattleParseHelper")
local MailResItem = require("UI.UIMailNew.UIMailMainPanel.Component.MailResItem")

function UILWMailDetailBase:OnCreate()
  base.OnCreate(self)
end

function UILWMailDetailBase:ClearReward()
  self.rewardContent:RemoveComponents(MailResItem)
  self.rewardItem.gameObject:GameObjectRecycleAll()
end

local function TruckBattleReportRewardSort(a, b)
  local rewardAType = a.rewardType
  local rewardBType = b.rewardType
  if rewardAType == nil or rewardBType == nil then
    return false
  end
  if rewardAType == RewardType.GOODS and rewardBType == RewardType.GOODS then
    local itemDataA = DataCenter.ItemTemplateManager:GetItemTemplate(a.itemId)
    local itemDataB = DataCenter.ItemTemplateManager:GetItemTemplate(b.itemId)
    if itemDataA and itemDataB then
      return itemDataA.quality > itemDataB.quality
    end
  elseif rewardAType ~= RewardType.METAL and rewardAType ~= RewardType.FOOD and rewardAType ~= RewardType.WOOD then
    return true
  end
  return false
end

function UILWMailDetailBase:ShowReward(reward)
  self:ClearReward()
  local totalCnt = 0
  local pay = self.mailData:GetMailPay()
  if pay ~= nil then
    local goldCnt = pay.gold or 0
    if 0 < goldCnt then
      totalCnt = totalCnt + 1
      self:ShowRewardItem({
        rewardType = RewardType.GOLD,
        itemId = "gold",
        count = goldCnt
      })
    end
  end
  if reward ~= nil and 0 < table.count(reward.rewardInfo) then
    local tabReward = reward.rewardInfo
    local sortFunc
    if self.mailData.type == MailType.TRUCK_BATTLE_REPORT then
      sortFunc = TruckBattleReportRewardSort
    end
    local showRewardList = self:CollectShowMailReward(tabReward, sortFunc)
    for _, rewardInfo in pairs(showRewardList) do
      totalCnt = totalCnt + 1
      self:ShowRewardItem(rewardInfo, totalCnt)
    end
  end
  self.rewardContent:SetAnchoredPosition(Vector2.zero)
  return totalCnt
end

function UILWMailDetailBase:ShowRewardItem(rewardData, totalCnt)
  local objName = totalCnt
  local item = self.rewardItem:GameObjectSpawn(self.rewardContent.transform)
  item.name = objName
  local obj = self.rewardContent:AddComponent(MailResItem, item.name)
  obj:RefreshData(rewardData)
end

function UILWMailDetailBase:CollectShowMailReward(rewardData, sortFunc)
  local showRewardList = {}
  for _, itemInfo in pairs(rewardData) do
    if itemInfo.type then
      local rewardType = itemInfo.type.value
      local itemId = 0
      if itemInfo.id then
        itemId = itemInfo.id.value
      end
      local itemCount = 0
      if itemInfo.num then
        itemCount = itemInfo.num.value
      end
      table.insert(showRewardList, {
        rewardType = rewardType,
        itemId = itemId,
        count = itemCount
      })
    else
      table.insert(showRewardList, itemInfo)
    end
  end
  if sortFunc then
    table.sort(showRewardList, sortFunc)
  end
  return showRewardList
end

function UILWMailDetailBase:ShowTop(hideVirus)
  local data = self.extData
  local player1 = data.player[1]
  local player2 = data.player[2]
  local _strTime = MailShowHelper.GetAbstractCreateTime(self.mailData)
  self.timeText:SetText(_strTime)
  if data.battleType == MailBattleReportType.CROSS_ARENA then
    self.coordinateText:SetText("")
  elseif data.battleType == MailBattleReportType.DARKNESS_MONSTER_ATTACK_CITY and player1 and player1.user and player1.user.name then
    self.coordinateText:SetLocalText("season_s4_activity_1200010_desc37", player1.user.name)
  else
    local battlePointId = toInt(data._battlePointId)
    if 0 < battlePointId then
      self.location = SceneUtils.IndexToTilePos(battlePointId, ForceChangeScene.World)
      local posStr = self.view.ctrl:FormatCoordinateText(self.location, player2 ~= nil and player2.recServerId or data._battleServerId)
      if string.IsNullOrEmpty(posStr) then
        self.coordinateText:SetText("")
      else
        self.coordinateText:SetLocalText("mail_tips_10001", posStr)
      end
    else
      self.coordinateText:SetText("")
    end
  end
  local cityShow = false
  local isAllianceCity = false
  if data.allianceCityInfo and 0 > data.allianceCityInfo.delta then
    cityShow = true
    isAllianceCity = true
    self.cityNode:SetActive(true)
    self.cityIcon:LoadSprite(data.city.pic)
    self.cityLvText:SetLocalText(GameDialogDefine.LEVEL_NUMBER, data.city.level)
    self.cityNameText:SetText(data.city.name)
    self.citySliderYellow:SetValue(data.allianceCityInfo.durabilityBeforeStart / data.allianceCityInfo.maxDurability)
    self.citySliderRed:SetValue(data.allianceCityInfo.durability / data.allianceCityInfo.maxDurability)
    self.citySliderText:SetText(string.format("%s/%s", data.allianceCityInfo.durability, data.allianceCityInfo.maxDurability))
    self.cityHpLost:SetText(data.allianceCityInfo.delta)
    if self.rootHpLost ~= nil and self.skillHpLost ~= nil then
      self.skillHpLost:SetActive(false)
      CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.cityHpLost.transform)
      CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.skillHpLost.transform)
      CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.rootHpLost.transform)
    end
  elseif data and data.hpData and data.player and data.battleType == MailBattleReportType.SEASON_DESERT_BATTLE and data.targetType == MailTargetType.SeasonDesert then
    local hpData = data.hpData
    local player = player2
    if player and player.isFlat and player.meta then
      cityShow = false
      self.cityNode:SetActive(false)
      self.cityIcon:LoadSprite(player.pic)
      if player.meta.level and 0 < player.meta.level then
        self.cityLvText:SetLocalText(GameDialogDefine.LEVEL_NUMBER, player.meta.level)
      else
        self.cityLvText:SetText("")
      end
      self.cityNameText:SetLocalText(player.meta.name)
      self.citySliderYellow:SetValue(hpData.oldHp / hpData.maxHp)
      self.citySliderRed:SetValue(hpData.newHp / hpData.maxHp)
      self.citySliderText:SetText(string.format("%s/%s", hpData.newHp, hpData.maxHp))
      self.cityHpLost:SetText(hpData.newHp - hpData.oldHp)
      if self.rootHpLost ~= nil and self.skillHpLost ~= nil then
        self.skillHpLost:SetActive(false)
        CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.cityHpLost.transform)
        CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.skillHpLost.transform)
        CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.rootHpLost.transform)
      end
    end
  elseif data and data.hpData and data.player and data.battleType == MailBattleReportType.SEASON_PLAYER_BUILDING_BATTLE and data.targetType == MailTargetType.SeasonBuilding then
    local hpData = data.hpData
    local player = player2
    if player and player.isFlat and player.meta then
      cityShow = true
      self.cityNode:SetActive(true)
      self.cityIcon:LoadSprite(player.pic)
      if player.meta.level and 0 < player.meta.level then
        self.cityLvText:SetLocalText(GameDialogDefine.LEVEL_NUMBER, player.meta.level)
      else
        self.cityLvText:SetText("")
      end
      self.cityNameText:SetLocalText(player.meta.name)
      self.citySliderYellow:SetValue(hpData.oldHp / hpData.maxHp)
      self.citySliderRed:SetValue(hpData.newHp / hpData.maxHp)
      self.citySliderText:SetText(string.format("%s/%s", hpData.newHp, hpData.maxHp))
      self.cityHpLost:SetText(hpData.newHp - hpData.oldHp)
      if self.rootHpLost ~= nil and self.skillHpLost ~= nil then
        self.skillHpLost:SetActive(false)
        CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.cityHpLost.transform)
        CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.skillHpLost.transform)
        CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.rootHpLost.transform)
      end
    end
  elseif data and data.hpData and data.player and (data.battleType == MailBattleReportType.SEASON_AL_BUILDING_BATTLE or data.battleType == MailBattleReportType.ALLIANCE_BUILDING_FURNACE) and data.targetType == MailTargetType.SeasonCenter then
    local hpData = data.hpData
    local player = player2
    if player and player.isFlat and player.meta then
      cityShow = true
      self.cityNode:SetActive(true)
      self.cityIcon:LoadSprite(player.pic)
      self.cityLvText:SetText("")
      self.cityNameText:SetLocalText(player.meta.name)
      self.citySliderYellow:SetValue(hpData.oldHp / hpData.maxHp)
      self.citySliderRed:SetValue(hpData.newHp / hpData.maxHp)
      self.citySliderText:SetText(string.format("%s/%s", hpData.newHp, hpData.maxHp))
      self.cityHpLost:SetText(hpData.newHp - hpData.oldHp)
      if self.rootHpLost ~= nil and self.skillHpLost ~= nil then
        local shieldSkillResult = hpData.shieldSkill
        if shieldSkillResult ~= nil then
          if shieldSkillResult.skillId ~= nil and shieldSkillResult.oldShield ~= nil and shieldSkillResult.newShield ~= nil and shieldSkillResult.maxShield ~= nil then
            self.skillHpLost:SetActive(true)
            self.skillHpLost:SetText(shieldSkillResult.newShield - shieldSkillResult.oldShield)
          else
            self.skillHpLost:SetActive(false)
          end
        else
          self.skillHpLost:SetActive(false)
        end
        CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.cityHpLost.transform)
        CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.skillHpLost.transform)
        CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.rootHpLost.transform)
      end
    end
  elseif data and data.battleType == MailBattleReportType.ROB_STRONGHOLD_BANK then
    cityShow = true
    self.cityNode:SetActive(false)
    if self.cityNodeRoot then
      self.cityNodeRoot:SetActive(true)
      if self.BankMailCityNode == nil then
        local luaPath = "UI.LWSeason5.LWBank.Group.BankMailCityNode"
        local prefabPath = "Assets/Main/SeasonRes/S5/Prefabs/UI/Bank/Group/BankMailCityNode.prefab"
        self.BankMailCityNode = UIBaseComponent.LoadComponentAsync(self, luaPath, prefabPath, self.cityNodeRoot)
      end
      self.BankMailCityNode:ReInit(data, player2)
    end
  else
    self.cityNode:SetActive(false)
    if self.cityNodeRoot then
      self.cityNodeRoot:SetActive(false)
    end
  end
  if self.leaderBg1 ~= nil and self.leaderBg2 ~= nil then
    self.leaderBg1:SetActive(not cityShow)
    self.leaderBg2:SetActive(cityShow)
  end
  if data.battleType == MailBattleReportType.ALLIANCE_BUILDING_FURNACE or data.targetType == MailTargetType.SeasonCenter and SeasonUtil.IsInSeasonSnowMode() then
    if self.ResistanceRoot then
      self.ResistanceRoot:SetActive(false)
    end
    if self.VirusRoot then
      self.VirusRoot:SetActive(false)
    end
  else
    if self.ResistanceRoot then
      self.ResistanceRoot:SetActive(not hideVirus and self.ResistanceRoot:SetData(data))
    end
    if self.VirusRoot then
      self.VirusRoot:SetActive(not hideVirus and self.VirusRoot:SetData(data))
    end
  end
  if self.MonsterBuff then
    self.MonsterBuff:SetActive(data.monsterBuffList)
    if data.monsterBuffList then
      self.MonsterBuff:SetData(data.monsterBuffList)
    end
  end
  self.anonymityBtn1:SetActive(false)
  self.anonymityBtn2:SetActive(false)
  self.hideType1 = HideType.None
  self.hideType2 = HideType.None
  local hasCoordinate1 = true
  if data.battleType == MailBattleReportType.CROSS_ARENA then
    self.coordinateText1:SetText("")
    hasCoordinate1 = false
    self.coordinateText2:SetText("")
  else
    if player1.armyType == MailTargetType.Player then
      if MailBattleParseHelper.IsWerewolf(player1) then
        self.hideType1 = HideType.Werewolf
        self:ShowAnonymityBtn1()
      end
      if player1.isActiveAnonymity then
        self.coordinateText1:SetLocalText(130262)
        self:ShowAnonymityBtn1()
      else
        local player1Server = self.extData:GetBattleServerId()
        local battleWorldId = self.extData:GetBattleWorldId()
        local bInBattle = toInt(battleWorldId) > 0
        if player1Server == -1 then
          player1Server = player1.recServerId
          if player1Server == nil and player1.user ~= nil then
            player1Server = player1.user.curServerId or player1.user.srcServerId
          end
        end
        if not bInBattle and player1 ~= nil and player1.user ~= nil and player1Server ~= player1.user.srcServerId then
          bInBattle = 0 < toInt(player1.user.worldId)
          if not bInBattle then
            player1Server = player1.user.curServerId or player1Server
            if toInt(player1Server) <= 0 then
              player1Server = player1.user.curServerId or player1.user.srcServerId
            end
          end
        end
        self.location1 = SceneUtils.IndexToTilePos(tonumber(player1.user.pointId), ForceChangeScene.World)
        self.player1Server = player1Server
        self.coordinateText1:SetText(self.view.ctrl:FormatCoordinateText(self.location1, player1Server))
      end
    else
      self.coordinateText1:SetText("")
      hasCoordinate1 = false
      self.location1 = nil
    end
    if MailBattleParseHelper.IsWerewolf(player2) then
      self.hideType2 = HideType.Werewolf
      self:ShowAnonymityBtn2()
    end
    local metaOutpost
    if player2 ~= nil and player2.armyType == MailTargetType.SeasonOutpost then
      metaOutpost = player2.meta
    end
    if metaOutpost ~= nil then
      local serverId = player2.recServerId
      if serverId == nil and player2.user ~= nil then
        serverId = player2.user.curServerId
      end
      if serverId == nil then
        serverId = LuaEntry.Player:GetSourceServerId()
      end
      self.location2 = SceneUtils.IndexToTilePos(tonumber(metaOutpost:GetPointId()), ForceChangeScene.World)
      self.coordinateText2:SetText(self.view.ctrl:FormatCoordinateText(self.location2, metaOutpost:GetCurServerId(serverId)))
    elseif player2 ~= nil and player2.isActiveAnonymity then
      self.hideType2 = HideType.Anonymity
      self.coordinateText2:SetLocalText(130262)
      self:ShowAnonymityBtn2()
    elseif player2 ~= nil and player2.user and player2.user.pointId then
      self.location2 = SceneUtils.IndexToTilePos(tonumber(player2.user.pointId), ForceChangeScene.World)
      self.coordinateText2:SetText(self.view.ctrl:FormatCoordinateText(self.location2, player2.recServerId or player2.user.curServerId))
    else
      local battleServerId = 0
      if data then
        battleServerId = toInt(data._battleServerId)
      end
      self.location2 = self.location
      self.coordinateText2:SetText(self.view.ctrl:FormatCoordinateText(self.location2, player2.recServerId or battleServerId))
    end
  end
  self.leaderName1:SetSizeDeltaY(hasCoordinate1 and 40 or 70)
  self.leaderHead1:SetEnableClickShowInfo(true, true)
  self.leaderHead2:SetEnableClickShowInfo(true, true)
  if self.leaderHead2.frameBg then
    if player2.armyType == MailTargetType.Player or player2.armyType == MailTargetType.Army then
      self.leaderHead2.frameBg:SetActive(true)
    else
      self.leaderHead2.frameBg:SetActive(false)
    end
  end
  if self.hideType1 == HideType.Werewolf then
    self.leaderHead1:ShowWerewolf()
    self.leaderName1:SetLocalText(GameDialogDefine.WEREWOLF)
  else
    self.leaderHead1:ParseHeadInfo(player1)
    self.leaderName1:SetText(player1.name)
  end
  if self.hideType2 == HideType.Werewolf then
    self.leaderHead2:ShowWerewolf()
    self.leaderName2:SetLocalText(GameDialogDefine.WEREWOLF)
  else
    if player2 ~= nil and player2.armyType == MailTargetType.SeasonOutpost and data.isMuster == false and player2.meta ~= nil and player2.old_pic ~= nil then
      player2.pic = player2.old_pic
      player2.name = player2.old_name
      player2.level = player2.old_level
      if self.leaderHead2.frameBg then
        self.leaderHead2.frameBg:SetActive(true)
      end
    end
    self.leaderHead2:ParseHeadInfo(player2)
    self.leaderName2:SetText(player2.name)
  end
  self.winNode:SetActive(data.attackerWin)
  self.loseNode:SetActive(not data.attackerWin)
  local sliderMaxNum = player1.soldierCountBeforeStart or 0
  local sliderCurNum = player1.soldierCount
  local sliderPercent = sliderMaxNum == 0 and 0 or sliderCurNum / sliderMaxNum
  if data.attackerWin and 0 < sliderPercent then
    sliderPercent = math.max(sliderPercent, 0.1)
  end
  self.leaderSlider1:SetValue(sliderPercent)
  local sliderDeadNum = string.GetFormattedSeperatorNum(math.floor(sliderCurNum - sliderMaxNum))
  self.sliderText1:SetText(sliderDeadNum)
  sliderMaxNum = player2.soldierCountBeforeStart or 0
  sliderCurNum = player2.soldierCount
  sliderPercent = sliderMaxNum == 0 and 0 or sliderCurNum / sliderMaxNum
  if not data.attackerWin and 0 < sliderPercent then
    sliderPercent = math.max(sliderPercent, 0.1)
  end
  self.leaderSlider2:SetValue(sliderPercent)
  sliderDeadNum = string.GetFormattedSeperatorNum(math.floor(sliderCurNum - sliderMaxNum))
  self.sliderText2:SetText(sliderDeadNum)
  if self.champion_duel_node then
    local showIdx = 0
    local championDuelScore = data.pb_BattleReport and data.pb_BattleReport.championDuelScore or nil
    if championDuelScore then
      local myUid = LuaEntry.Player:GetUid()
      local uid = player1 and player1.user and player1.user.uid
      if myUid == uid then
        showIdx = 1
      else
        uid = player2 and player2.user and player2.user.uid
        if myUid == uid then
          showIdx = 2
        end
      end
      if 0 < showIdx then
        local have = false
        for i, v in ipairs(championDuelScore) do
          if i == showIdx then
            have = true
            local sNum = v.aliveScore or 0
            self.champion_duel_surviveNum:SetText(sNum)
            local kNum = v.killScore or 0
            self.champion_duel_killedNum:SetText(kNum)
            local wNum = v.winScore or 0
            self.champion_duel_winNum:SetText(wNum)
            local total = sNum + kNum + wNum
            self.champion_duel_totalText:SetLocalText("champion_duel_tips1182", total)
            break
          end
        end
        if not have then
          showIdx = 0
        end
      end
    end
    self.champion_duel_node:SetActive(0 < showIdx)
  end
  local totalCnt = 0
  if data.reward ~= nil and 0 < table.count(data.reward.rewardInfo) then
    totalCnt = self:ShowReward(data.reward)
  end
  local plunderMeteoriteInfo = data.pb_BattleReport and data.pb_BattleReport.plunderMeteoriteInfo or nil
  if plunderMeteoriteInfo then
    local crystal = plunderMeteoriteInfo.crystal or 0
    if 0 < crystal then
      if totalCnt == 0 then
        self:ClearReward()
      end
      totalCnt = totalCnt + 1
      self:ShowRewardItem({
        rewardType = RewardType.RESOURCE_ITEM,
        itemId = ResourceType.MeteoriteCrystallization,
        count = crystal
      }, totalCnt)
    end
    local nucleus = plunderMeteoriteInfo.nucleus or 0
    if 0 < nucleus then
      if totalCnt == 0 then
        self:ClearReward()
      end
      totalCnt = totalCnt + 1
      self:ShowRewardItem({
        rewardType = RewardType.RESOURCE_ITEM,
        itemId = ResourceType.MeteoriteNucleusOfStar,
        count = nucleus
      }, totalCnt)
    end
  end
  if 0 < totalCnt then
    if 0 < data.plunderValue then
      self.resText:SetActive(false)
      self.weightNode:SetActive(true)
      self.weightNum:SetText(string.GetFormattedStr(data.plunderValue) .. "/" .. string.GetFormattedStr(data.maxPlunderValue))
    else
      self.resText:SetActive(true)
      self.weightNode:SetActive(false)
      if IsMailNewFightType(self.mailData.type) then
        if data.isDefend then
          self.resText:SetLocalText(GameDialogDefine.MAIL_PVP_RES_BE_LOOT)
        else
          self.resText:SetLocalText(GameDialogDefine.MAIL_PVP_RES_LOOT)
        end
      else
        self.resText:SetLocalText(GameDialogDefine.MAIL_PVE_LOOT)
      end
    end
  end
  self.resNode:SetActive(0 < totalCnt)
end

function UILWMailDetailBase:OnJumpClick2()
  if self.extData.player[2].isActiveAnonymity then
    UIUtil.ShowTipsId("season_mastery_174")
  elseif self.location2 then
    self.view.ctrl:OnJumpClick(self.location2.x, self.location2.y, self.extData:GetBattleServerId())
  end
end

function UILWMailDetailBase:OnJumpClick1()
  if self.extData.player[1].isActiveAnonymity then
    UIUtil.ShowTipsId("season_mastery_174")
  elseif self.location1 ~= nil then
    local data = self.extData
    local serverId = data:GetBattleServerId()
    if self.player1Server then
      serverId = self.player1Server
    else
      local player1 = data.player[1]
      serverId = player1 and player1.user and player1.user.srcServerId or serverId
    end
    self.view.ctrl:OnJumpClick(self.location1.x, self.location1.y, serverId)
  end
end

function UILWMailDetailBase:OnJumpClick()
  local data = self.extData
  local player1 = data.player[1]
  if data.battleType == MailBattleReportType.DARKNESS_MONSTER_ATTACK_CITY and player1 and player1.user and player1.user.uid then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {anim = true, hideTop = false}, player1.user.uid)
  elseif self.location ~= nil then
    self.view.ctrl:OnJumpClick(self.location.x, self.location.y, self.extData:GetBattleServerId())
  end
end

function UILWMailDetailBase:OnWeightClick()
  local content = Localization:GetString(GameDialogDefine.MAIL_WEIGHT_TIP)
  UIUtil.ShowBubbleTips(content, self.weightBtn.transform.position, 0, 0, -20)
end

function UILWMailDetailBase:OnClickAnonymityBtn1()
  local langKey = self.hideType1 == HideType.Werewolf and "season_s4_activity_1200011_desc25" or "season_mastery_tips_24"
  UIUtil.ShowBubbleTips(Localization:GetString(langKey), self.anonymityBtn1.transform.position, 0, -20, 0)
end

function UILWMailDetailBase:OnClickAnonymityBtn2()
  local langKey = self.hideType2 == HideType.Werewolf and "season_s4_activity_1200011_desc25" or "season_mastery_tips_24"
  UIUtil.ShowBubbleTips(Localization:GetString(langKey), self.anonymityBtn2.transform.position, 0, -20, 0)
end

return UILWMailDetailBase
