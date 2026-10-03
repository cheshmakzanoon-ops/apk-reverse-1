local UIArena3V3BattleResultView = BaseClass("UIArena3V3BattleResultView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local LayoutLayer = "Layout/"
local MailParseHelper = require("DataCenter.MailData.MailParseHelper")
local UILW3V3BattleResultItem = require("UI.UIArena3V3BattleResult.Component.UILW3V3BattleResultItem")

function UIArena3V3BattleResultView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.battleData, self.selfPlayerInfo, self.otherPlayerInfo = self:GetUserData()
  self:Show()
end

function UIArena3V3BattleResultView:OnDestroy()
  if self.delay then
    self.delay:Stop()
    self.delay = nil
  end
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIArena3V3BattleResultView:ComponentDefine()
  self.backBtn = self:AddComponent(UIButton, LayoutLayer .. "BackBtn")
  self.backBtn:SetOnClick(function()
    self:OnBackBtnClick()
  end)
  self.layout = self:AddComponent(UIBaseContainer, LayoutLayer)
  self.canvasGroup = self.transform:Find(LayoutLayer).gameObject:GetComponent(typeof(CS.UnityEngine.CanvasGroup))
  self.canvasGroup.alpha = 0
  self.victoryText = self:AddComponent(UIText, LayoutLayer .. "Title/VictoryGo/VictoryText")
  self.levelText = self:AddComponent(UIText, LayoutLayer .. "LevelText")
  self.backBtnText = self:AddComponent(UIText, LayoutLayer .. "BackBtn/BackBtnText")
  self.backBtnText:SetText(Localization:GetString("300520"))
  self.leftPlayer = self:AddComponent(UIBaseContainer, LayoutLayer .. "LeftPlayer")
  self.leftPlayerHead = self:AddComponent(UICommonHead, LayoutLayer .. "LeftPlayer/LeftPlayerHead")
  self.leftPlayerNameLayout = self:AddComponent(UICommonNameLayout, LayoutLayer .. "LeftPlayer/LeftPlayerName")
  self.rightPlayer = self:AddComponent(UIBaseContainer, LayoutLayer .. "RightPlayer")
  self.rightPlayerHead = self:AddComponent(UICommonHead, LayoutLayer .. "RightPlayer/RightPlayerHead")
  self.rightPlayerNameLayout = self:AddComponent(UICommonNameLayout, LayoutLayer .. "RightPlayer/RightPlayerName")
  self.leftScoreText = self:AddComponent(UIText, LayoutLayer .. "LeftPlayer/LeftPlayerScore/leftScoreText")
  self.leftScoreAddText = self:AddComponent(UIText, LayoutLayer .. "LeftPlayer/LeftPlayerScore/leftScoreAddText")
  self.rightScoreText = self:AddComponent(UIText, LayoutLayer .. "RightPlayer/RightPlayerScore/rightScoreText")
  self.rightScoreAddText = self:AddComponent(UIText, LayoutLayer .. "RightPlayer/RightPlayerScore/rightScoreAddText")
  self.oldRank = self:AddComponent(UIText, LayoutLayer .. "rankChange/oldRank")
  self.newRank = self:AddComponent(UIText, LayoutLayer .. "rankChange/newRank")
  self.victoryGo = self:AddComponent(UIBaseContainer, LayoutLayer .. "Title/VictoryGo")
  self.loseGo = self:AddComponent(UIBaseContainer, LayoutLayer .. "Title/LoseGo")
  self.victoryGo:SetActive(false)
  self.loseGo:SetActive(false)
  self.victoryAllGo = self:AddComponent(UIBaseContainer, LayoutLayer .. "Title/VictoryAllGo")
  self.victoryAllGo:SetActive(false)
  self.victoryAllText = self:AddComponent(UIText, LayoutLayer .. "Title/VictoryAllGo/VictoryAllText")
  self.victoryAllText:SetLocalText("new_arena_tips_90")
  self.victoryAllScoreText = self:AddComponent(UIText, LayoutLayer .. "Title/VictoryAllGo/VictoryAllScoreText")
  self.statisticsBtn = self:AddComponent(UIButton, LayoutLayer .. "StatisticsBtn")
  self.statisticsBtn:SetOnClick(function()
    self:OnStatisticsBtnClick()
  end)
  self.battleInfoItems = {}
  for i = 1, 3 do
    local infoItem = self:AddComponent(UILW3V3BattleResultItem, LayoutLayer .. "battleContent/PVPArenaBattleInfoItem" .. i)
    self.battleInfoItems[i] = infoItem
  end
end

function UIArena3V3BattleResultView:ComponentDestroy()
  self.battleInfoItems = nil
end

function UIArena3V3BattleResultView:Show()
  if self.battleData.win == 1 or self.battleData.win == true then
    self.loseGo:SetActive(false)
    if self.battleData.extraAddScore then
      self.victoryGo:SetActive(false)
      self.victoryAllGo:SetActive(true)
      self.victoryAllScoreText:SetLocalText("new_arena_tips_91", self.battleData.extraAddScore)
    else
      self.victoryGo:SetActive(true)
      self.victoryAllGo:SetActive(false)
    end
  else
    self.victoryGo:SetActive(false)
    self.loseGo:SetActive(true)
  end
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_stage_win_bgm)
  if self.delay then
    self.delay:Stop()
    self.delay = nil
  end
  self.delay = TimerManager:GetInstance():DelayInvoke(function()
    self.canvasGroup:DOFade(1, 0.2)
    self:RefreshView()
  end, 1.5)
end

function UIArena3V3BattleResultView:DataDefine()
end

function UIArena3V3BattleResultView:OnAddListener()
  base.OnAddListener(self)
end

function UIArena3V3BattleResultView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIArena3V3BattleResultView:OnKeyCodeEscape()
  TimerManager:GetInstance():DelayFrameInvoke(function()
    self:OnBackBtnClick()
  end, 1)
end

function UIArena3V3BattleResultView:ComponentDestroy()
  self.back_btn = nil
end

function UIArena3V3BattleResultView:RefreshView()
  local lastRank = self.selfPlayerInfo.lastRank
  local curRank = self.selfPlayerInfo.curRank
  if lastRank then
    self.oldRank:SetText(Localization:GetString("302043") .. "  " .. lastRank)
  else
    self.oldRank:SetText("")
  end
  if curRank then
    self.newRank:SetText(curRank)
  else
    self.newRank:SetText("")
  end
  local headFramePath = DataCenter.DecorationDataManager:GetHeadFrame(self.selfPlayerInfo.headSkinId, nil, false)
  self.leftPlayerHead:SetData(self.selfPlayerInfo.uid, self.selfPlayerInfo.pic, self.selfPlayerInfo.picver, nil, headFramePath)
  self.leftPlayerNameLayout:SetData(self.selfPlayerInfo.name, self.selfPlayerInfo.abbr, nil, nil, nil, nil, self.selfPlayerInfo.srcServer)
  local opponentPlayerInfo = self.otherPlayerInfo
  headFramePath = DataCenter.DecorationDataManager:GetHeadFrame(opponentPlayerInfo.headSkinId, opponentPlayerInfo.headSkinET, false)
  self.rightPlayerHead:SetData(opponentPlayerInfo.uid, opponentPlayerInfo.pic, opponentPlayerInfo.picver, nil, headFramePath)
  self.rightPlayerNameLayout:SetData(opponentPlayerInfo.name, opponentPlayerInfo.abbr, nil, nil, nil, nil, opponentPlayerInfo.srcServer)
  local ownerOldScore = self.battleData.ownerOldScore
  local ownerNewScore = self.battleData.ownerNewScore
  local otherOldScore = self.battleData.otherOldScore
  local otherNewScore = self.battleData.otherNewScore
  if ownerOldScore then
    local addColor = Color.New(0.37254901960784315, 0.9372549019607843, 0.5294117647058824, 1)
    local delColor = Color.New(0.9764705882352941, 0.4392156862745098, 0.4666666666666667, 1)
    local ownerChangeScore = ownerNewScore - ownerOldScore
    self.leftScoreText:SetText(ownerNewScore)
    local ownerAddStr = 0 <= ownerChangeScore and "+" .. ownerChangeScore or ownerChangeScore
    self.leftScoreAddText:SetText(ownerAddStr)
    local ownerAddColor = 0 <= ownerChangeScore and addColor or delColor
    self.leftScoreAddText:SetColor(ownerAddColor)
    local otherChangeScore = otherNewScore - otherOldScore
    self.rightScoreText:SetText(otherNewScore)
    local otherAddStr = 0 <= otherChangeScore and "+" .. otherChangeScore or otherChangeScore
    self.rightScoreAddText:SetText(otherAddStr)
    local otherAddColor = 0 <= otherChangeScore and addColor or delColor
    self.rightScoreAddText:SetColor(otherAddColor)
  else
    self.leftScoreText:SetText("")
    self.leftScoreAddText:SetText("")
    self.rightScoreText:SetText("")
    self.rightScoreAddText:SetText("")
  end
  self:RefreshBattleInfoView()
end

function UIArena3V3BattleResultView:RefreshBattleInfoView()
  self.battleShowDataList = {}
  if self.battleData.battleArr ~= nil then
    for i = 1, #self.battleData.battleArr do
      local data = self.battleData.battleArr[i]
      local battleState = data.battleState
      local reportUuid = data.reportUuid
      local mailUid = data.mailUid
      local mailData = DataCenter.MailDataManager:GetMailInfoById(mailUid)
      if mailData ~= nil then
        local extData = mailData:GetMailExt()
        if extData ~= nil then
          local itemInfoData = {}
          itemInfoData.reportUuid = reportUuid
          itemInfoData.mailUid = mailUid
          itemInfoData.recordTime = self.battleData.time
          table.insert(self.battleShowDataList, itemInfoData)
          local atkTeamData = {}
          atkTeamData.heroData = {}
          local defTeamData = {}
          defTeamData.heroData = {}
          if extData.reportIntegrity then
            for k, v in pairs(extData.hero) do
              if PVPBattleSlot.SelfHero1 <= v.index and v.index <= PVPBattleSlot.SelfHero5 then
                local posIndex = v.index
                atkTeamData.heroData[posIndex] = v
              elseif PVPBattleSlot.EnemyHero1 <= v.index and v.index <= PVPBattleSlot.EnemyHero5 then
                local posIndex = v.index - 5
                defTeamData.heroData[posIndex] = v
              elseif v.index == PVPBattleSlot.SelfDominator then
                atkTeamData.dominatorData = {
                  heroId = v.heroId,
                  rankLv = v.rankLv
                }
              elseif v.index == PVPBattleSlot.EnemyDominator then
                defTeamData.dominatorData = {
                  heroId = v.heroId,
                  rankLv = v.rankLv
                }
              end
            end
            if extData.attackerWin then
              atkTeamData.isWin = true
              defTeamData.isWin = false
            else
              atkTeamData.isWin = false
              defTeamData.isWin = true
            end
            local selfPlayerUid = LuaEntry.Player.uid
            local player1Uid = extData.player[1].uid
            if selfPlayerUid == player1Uid then
              itemInfoData.selfData = atkTeamData
              itemInfoData.otherData = defTeamData
            else
              itemInfoData.selfData = defTeamData
              itemInfoData.otherData = atkTeamData
            end
          else
            local atkTeam = DataCenter.LW3V3Manager:GetAtkTeamByIndex(i)
            if atkTeam then
              local atkHeroes = atkTeam:GetLocalAllHeroes()
              if type(atkHeroes) == "table" then
                for index, uuid in pairs(atkHeroes) do
                  local heroData = atkTeam:GetHeroDataByUuid(uuid)
                  atkTeamData.heroData[index] = heroData
                end
              end
              if atkTeam.dominatorData then
                atkTeamData.dominatorData = atkTeam.dominatorData
              end
            end
            local defTeam = DataCenter.LW3V3Manager:GetOpponentDefenceTeam(i)
            if defTeam then
              local defHeroes = defTeam:GetLocalAllHeroes()
              if type(defHeroes) == "table" then
                for index, uuid in pairs(defHeroes) do
                  local heroData = defTeam:GetHeroDataByUuid(uuid)
                  defTeamData.heroData[index] = heroData
                end
              end
              if defTeam.dominatorData then
                defTeamData.dominatorData = defTeam.dominatorData
              end
            end
            local isWin = false
            local msg = self:GetUserData()
            local battleStateArr = msg and msg.battleStateArr
            if battleStateArr then
              local res = battleStateArr[i] or 0
              isWin = res == 1
            end
            atkTeamData.isWin = isWin
            defTeamData.isWin = not isWin
            itemInfoData.selfData = atkTeamData
            itemInfoData.otherData = defTeamData
          end
        end
      end
    end
  end
  for i = 1, #self.battleInfoItems do
    local itemData = self.battleShowDataList[i]
    if itemData then
      self.battleInfoItems[i]:SetActive(true)
      self.battleInfoItems[i]:SetData(itemData)
    else
      self.battleInfoItems[i]:SetActive(false)
    end
  end
  if #self.battleShowDataList ~= #self.battleInfoItems then
    self.statisticsBtn:SetActive(false)
  else
    self.statisticsBtn:SetActive(true)
  end
end

function UIArena3V3BattleResultView:OnBackBtnClick()
  self.ctrl:CloseSelf()
  local curBattleType = DataCenter.LWBattleManager:GetCurBattleType()
  if curBattleType == PVEType.Arena3V3 then
    DataCenter.LWBattleManager:Exit(function()
      DataCenter.LWPVPArenaManager.ShowPVPArenaMain(PVPArenaType.Arena3V3, nil)
    end)
  end
end

function UIArena3V3BattleResultView:OnStatisticsBtnClick()
  if not self.battleData then
    return
  end
  local mailUuids = {}
  local reportIntegrity = true
  if self.battleData and self.battleData.battleArr then
    for i, v in ipairs(self.battleData.battleArr) do
      if not MailParseHelper.CheckMailBattleReportIntegrity(v.mailUid, true) then
        reportIntegrity = false
      end
      if v.mailUid then
        table.insert(mailUuids, v.mailUid)
      end
    end
  end
  if not reportIntegrity then
    UIUtil.ShowTipsId(GameDialogDefine.BATTLE_REPORT_LOADING)
    return
  end
  if 0 < #mailUuids then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWArena3V3SkirmishResult, {anim = true}, mailUuids)
  end
end

return UIArena3V3BattleResultView
