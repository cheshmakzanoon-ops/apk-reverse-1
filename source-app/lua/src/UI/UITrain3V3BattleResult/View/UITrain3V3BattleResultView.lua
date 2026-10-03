local UITrain3V3BattleResultView = BaseClass("UITrain3V3BattleResultView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local LayoutLayer = "Layout/"
local UILW3V3BattleResultItem = require("UI.UIArena3V3BattleResult.Component.UILW3V3BattleResultItem")

function UITrain3V3BattleResultView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.battleData, self.selfPlayerInfo, self.otherPlayerInfo = self:GetUserData()
  self:Show()
end

function UITrain3V3BattleResultView:OnDestroy()
  if self.delay then
    self.delay:Stop()
    self.delay = nil
  end
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UITrain3V3BattleResultView:ComponentDefine()
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
  self.rightScoreText = self:AddComponent(UIText, LayoutLayer .. "RightPlayer/RightPlayerScore/rightScoreText")
  self.content = self:AddComponent(UIBaseContainer, LayoutLayer .. "reward/Viewport/Content")
  self.noReward = self:AddComponent(UIBaseComponent, LayoutLayer .. "reward/noReward")
  self.victoryGo = self:AddComponent(UIBaseContainer, LayoutLayer .. "Title/VictoryGo")
  self.loseGo = self:AddComponent(UIBaseContainer, LayoutLayer .. "Title/LoseGo")
  self.victoryGo:SetActive(false)
  self.loseGo:SetActive(false)
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

function UITrain3V3BattleResultView:ComponentDestroy()
  self:RemoveReward()
  self.battleInfoItems = nil
end

function UITrain3V3BattleResultView:Show()
  if self.battleData.isWin == 1 or self.battleData.isWin == true then
    self.victoryGo:SetActive(true)
    self.loseGo:SetActive(false)
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

function UITrain3V3BattleResultView:DataDefine()
end

function UITrain3V3BattleResultView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnKeyCodeEscape, self.OnKeyCodeEscape)
end

function UITrain3V3BattleResultView:OnRemoveListener()
  self:RemoveUIListener(EventId.OnKeyCodeEscape, self.OnKeyCodeEscape)
  base.OnRemoveListener(self)
end

function UITrain3V3BattleResultView:OnKeyCodeEscape()
  TimerManager:GetInstance():DelayFrameInvoke(function()
    self:OnBackBtnClick()
  end, 1)
end

function UITrain3V3BattleResultView:ComponentDestroy()
  self.back_btn = nil
end

function UITrain3V3BattleResultView:RefreshView()
  self.leftPlayerHead:SetHeadAndFrame(self.selfPlayerInfo.uid, self.selfPlayerInfo.pic, self.selfPlayerInfo.picver, nil, self.selfPlayerInfo.headSkinId, self.selfPlayerInfo.headSkinET)
  self.leftPlayerNameLayout:SetData(self.selfPlayerInfo.name, self.selfPlayerInfo.abbr, nil, nil, nil, nil, self.selfPlayerInfo.serverId)
  local opponentPlayerInfo = self.otherPlayerInfo
  headFramePath = DataCenter.DecorationDataManager:GetHeadFrame(opponentPlayerInfo.headSkinId, opponentPlayerInfo.headSkinET, false)
  self.rightPlayerHead:SetData(opponentPlayerInfo.uid, opponentPlayerInfo.pic, opponentPlayerInfo.picver, nil, headFramePath)
  self.rightPlayerNameLayout:SetData(opponentPlayerInfo.name, opponentPlayerInfo.abbr, nil, nil, nil, nil, opponentPlayerInfo.serverId)
  self:RefreshBattleInfoView()
  self:RefreshReward()
end

function UITrain3V3BattleResultView:RefreshReward()
  self:RemoveReward()
  local rewardData = self.battleData.showReward
  if not rewardData or table.count(rewardData) <= 0 then
    self.noReward:SetActive(true)
    return
  end
  self.noReward:SetActive(false)
  local container = self.content
  for i = 1, table.length(rewardData) do
    self.model[i] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      local transform = go.transform
      go:SetActive(true)
      transform:SetParent(container.transform)
      transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      transform:Set_sizeDelta(150, 150)
      transform:Set_pivot(0, 1)
      local nameStr = tostring(NameCount)
      go.name = nameStr
      NameCount = NameCount + 1
      local cell = container:AddComponent(UICommonResItem, nameStr)
      local data = rewardData[i]
      local param = UICommonResItem.Param.New()
      param.rewardType = data.type
      if type(data.value) == "table" then
        param.itemId = data.value.id
        param.count = data.value.num or data.value.count
      else
        param.itemId = data.type
        param.count = data.value
      end
      param.rewardType = data.type
      param.heroUuid = data.heroUuid
      param.isHeroBox = data.isHeroBox
      cell:ReInit(param)
    end)
  end
end

function UITrain3V3BattleResultView:RemoveReward()
  self.content:RemoveComponents(UICommonResItem)
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.model = {}
end

function UITrain3V3BattleResultView:RefreshBattleInfoView()
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
              if v.index <= 5 then
                local posIndex = v.index
                atkTeamData.heroData[posIndex] = v
              else
                local posIndex = v.index - 5
                defTeamData.heroData[posIndex] = v
              end
            end
            if extData.attackerWin then
              atkTeamData.isWin = true
              defTeamData.isWin = false
            else
              atkTeamData.isWin = false
              defTeamData.isWin = true
            end
            itemInfoData.selfData = atkTeamData
            itemInfoData.otherData = defTeamData
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
      else
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

function UITrain3V3BattleResultView:OnBackBtnClick()
  self.ctrl:CloseSelf()
  local curBattleType = DataCenter.LWBattleManager:GetCurBattleType()
  local curEnterType = DataCenter.LWBattleManager:GetPVEEnterType()
  if curBattleType == PVEType.Arena3V3 and curEnterType == PVEEnterType.TrainRob then
    DataCenter.LWBattleManager:Exit(function()
    end)
  end
end

function UITrain3V3BattleResultView:OnStatisticsBtnClick()
  if not self.battleData then
    return
  end
  local mailUuids = {}
  if self.battleData and self.battleData.battleArr then
    for i, v in ipairs(self.battleData.battleArr) do
      if v.mailUid then
        table.insert(mailUuids, v.mailUid)
      end
    end
  end
  if 0 < #mailUuids then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWArena3V3SkirmishResult, {anim = true}, mailUuids)
  end
end

return UITrain3V3BattleResultView
