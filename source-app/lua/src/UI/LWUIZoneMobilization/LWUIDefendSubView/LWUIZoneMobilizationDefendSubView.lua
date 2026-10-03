local base = UIBaseView
local LWUIZoneMobilizationDefendSubView = BaseClass("LWUIZoneMobilizationDefendSubView", base)
local Localization = CS.GameEntry.Localization
local LWUIZoneMobilizationBoxRewardItemRender = require("UI.LWUIZoneMobilization.LWUIDefendSubView.LWUIZoneMobilizationBoxRewardItemRender")
local LWUIZoneMobilizationDefendRankItemRender = require("UI.LWUIZoneMobilization.LWUIDefendSubView.LWUIZoneMobilizationDefendRankItemRender")
local UIZoneMobilizationBossNameItem = require("UI.LWUIZoneMobilization.LWUIZoneMobilizationMain.Component.UIZoneMobilizationBossNameItem")
local stageTimeContent_path = "StageTimeContent"
local stageTimeText_path = "StageTimeContent/StageTimeText"
local noPlaceTipsText_path = "NoPlaceTipsText"
local transferContent_path = "TransferContent"
local transferProgressSlider_path = "TransferContent/TransferProgressSlider"
local startPositionText_path = "TransferContent/StartPositionBtn/StartPositionText"
local endPositionText_path = "TransferContent/EndPositionBtn/EndPositionText"
local transferEndTimeText_path = "TransferContent/TransferEndTimeText"
local curHpText_path = "CurHpText"
local battleFinishTipsText_path = "BattleFinishTipsText"
local boxRewardContent_path = "BoxRewardContent"
local curHpProgressSlider_path = "BoxRewardContent/CurHpProgressSlider"
local rewardContent_path = "BoxRewardContent/RewardContent"
local boxRewardItemObj_path = "BoxRewardContent/LWUIZoneMobilizationBoxRewardItemRender"
local rankContent_path = "RankContent"
local rankTipsText_path = "RankContent/RankTipsText"
local topThreeRankContent_path = "RankContent/TopThreeRankContent"
local rankItemObj_path = "RankContent/LWUIZoneMobilizationDefendRankItemRender"
local rankNoDataContent_path = "RankNoDataContent"
local rankNoDataTipsText_path = "RankNoDataContent/RankNoDataTipsText"
local boxRewardMaxNumText_path = "BoxRewardContent/BoxRewardMaxNumText"
local rankBtn_path = "RankBtn"
local rankBtnText_path = "RankBtn/RankBtnText"
local startPositionBtn_path = "TransferContent/StartPositionBtn"
local endPositionBtn_path = "TransferContent/EndPositionBtn"
local before_battle_tips_text_path = "BeforeBattleTipsText"
local name_group_path = "NameGroup"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ClearBoxReward()
  self:ClearRankShow()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.stageTimeContent = self:AddComponent(UIBaseContainer, stageTimeContent_path)
  self.stageTimeText = self:AddComponent(UIText, stageTimeText_path)
  self.noPlaceTipsText = self:AddComponent(UIText, noPlaceTipsText_path)
  self.transferContent = self:AddComponent(UIBaseContainer, transferContent_path)
  self.transferProgressSlider = self:AddComponent(UISlider, transferProgressSlider_path)
  self.startPositionText = self:AddComponent(UIText, startPositionText_path)
  self.endPositionText = self:AddComponent(UIText, endPositionText_path)
  self.transferEndTimeText = self:AddComponent(UIText, transferEndTimeText_path)
  self.curHpText = self:AddComponent(UIText, curHpText_path)
  self.battleFinishTipsText = self:AddComponent(UIText, battleFinishTipsText_path)
  self.boxRewardContent = self:AddComponent(UIBaseContainer, boxRewardContent_path)
  self.curHpProgressSlider = self:AddComponent(UISlider, curHpProgressSlider_path)
  self.rewardContent = self:AddComponent(UIBaseContainer, rewardContent_path)
  self.boxRewardItemObj = self:AddComponent(UIBaseContainer, boxRewardItemObj_path)
  self.rankContent = self:AddComponent(UIBaseContainer, rankContent_path)
  self.rankTipsText = self:AddComponent(UIText, rankTipsText_path)
  self.topThreeRankContent = self:AddComponent(UIBaseContainer, topThreeRankContent_path)
  self.rankItemObj = self:AddComponent(UIBaseContainer, rankItemObj_path)
  self.rankNoDataContent = self:AddComponent(UIBaseContainer, rankNoDataContent_path)
  self.rankNoDataTipsText = self:AddComponent(UIText, rankNoDataTipsText_path)
  self.boxRewardMaxNumText = self:AddComponent(UIText, boxRewardMaxNumText_path)
  self.rankBtn = self:AddComponent(UIButton, rankBtn_path)
  self.rankBtnText = self:AddComponent(UIText, rankBtnText_path)
  self.startPositionBtn = self:AddComponent(UIButton, startPositionBtn_path)
  self.endPositionBtn = self:AddComponent(UIButton, endPositionBtn_path)
  self.rankNoDataTipsText:SetLocalText("zone_mobilization_defend_rank_no_data")
  self.rankTipsText:SetLocalText("zone_mobilization_defend_rank_name")
  self.rankBtn:SetOnClick(function()
    self:RankBtnClick()
  end)
  self.rankBtnText:SetLocalText("zone_mobilization_defend_rank_btn")
  self.boxRewardItem = self.transform:Find(boxRewardItemObj_path).gameObject
  self.boxRewardItem:GameObjectCreatePool()
  self.rankItem = self.transform:Find(rankItemObj_path).gameObject
  self.rankItem:GameObjectCreatePool()
  self.startPositionBtn:SetOnClick(function()
    self:StartPositionBtnClick()
  end)
  self.endPositionBtn:SetOnClick(function()
    self:EndPositionBtnClick()
  end)
  self.before_battle_tips_text = self:AddComponent(UITextMeshProUGUIEx, before_battle_tips_text_path)
  self.name_group = self:AddComponent(UIZoneMobilizationBossNameItem, name_group_path)
end

local function ComponentDestroy(self)
  self.stageTimeContent = nil
  self.stageTimeText = nil
  self.noPlaceTipsText = nil
  self.transferContent = nil
  self.transferProgressSlider = nil
  self.startPositionText = nil
  self.endPositionText = nil
  self.transferEndTimeText = nil
  self.curHpText = nil
  self.battleFinishTipsText = nil
  self.boxRewardContent = nil
  self.curHpProgressSlider = nil
  self.rewardContent = nil
  self.boxRewardItemObj = nil
  self.rankContent = nil
  self.rankTipsText = nil
  self.topThreeRankContent = nil
  self.rankItemObj = nil
  self.rankNoDataContent = nil
  self.rankNoDataTipsText = nil
  self.boxRewardMaxNumText = nil
  self.rankBtn = nil
  self.rankBtnText = nil
  self.startPositionBtn = nil
  self.endPositionBtn = nil
  self.before_battle_tips_text = nil
  self.name_group = nil
end

local function DataDefine(self)
  self.curStageType = nil
  self.zoneMobilizationDefendInfoData = nil
  self.alreadySendMsg = false
  self.bossState = nil
  self.totalTime = nil
end

local function DataDestroy(self)
  self.curStageType = nil
  self.zoneMobilizationDefendInfoData = nil
  self.alreadySendMsg = nil
  self.bossState = nil
  self.totalTime = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.GetZoneMobilizationInfoData, self.RefreshView)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.GetZoneMobilizationInfoData, self.RefreshView)
  base.OnRemoveListener(self)
end

local function Update1000MS(self)
  if self.zoneMobilizationDefendInfoData == nil then
    return
  end
  self:CutDownStageTime()
  local isTransfer = self.zoneMobilizationDefendInfoData:IsTransfer()
  if isTransfer then
    self:CutDownTransferTime()
  end
end

local function ReInitData(self)
  self.alreadySendMsg = false
  DataCenter.LWZoneMobilizationManager:RequestZoneMobilizationDonatedInfoData(ZoneMobilizationTabType.Defend)
  self:RefreshView()
end

local function RefreshView(self)
  self.curStageType = DataCenter.LWZoneMobilizationManager:GetCurStageType()
  self.zoneMobilizationDefendInfoData = DataCenter.LWZoneMobilizationManager:GetZoneMobilizationDefendInfoData()
  if self.curStageType == ZoneMobilizationStageType.Donated or self.curStageType == ZoneMobilizationStageType.Sprint then
    self:ShowDonatedStage()
    self:RefreshBoxRewardShow()
  elseif self.zoneMobilizationDefendInfoData then
    local enemyIsPlaced = self.zoneMobilizationDefendInfoData:EnemySideIsPlacedBoss()
    local isTransfer = self.zoneMobilizationDefendInfoData:IsTransfer()
    self:RefreshShowStageState(enemyIsPlaced, isTransfer)
    self:RefreshRankShow()
    if isTransfer then
      self:ShowTransferStage()
    else
      self:RefreshCurHpShow()
      self:RefreshBoxRewardShow()
      if self.curStageType == ZoneMobilizationStageType.Battle then
        self:ShowBattleStage()
      elseif self.curStageType == ZoneMobilizationStageType.SettlementShow then
        self:ShowSettlementShowStage()
      end
    end
  end
end

local function ShowDonatedStage(self)
  self.name_group:ReInit(false)
  self.stageTimeContent:SetActive(false)
  self.transferContent:SetActive(false)
  self.curHpText:SetActive(false)
  self.rankContent:SetActive(false)
  self.noPlaceTipsText:SetActive(false)
  self.before_battle_tips_text:SetActive(true)
  self.before_battle_tips_text:SetLocalText("zone_mobilization_not_open")
  self.rankNoDataContent:SetActive(true)
  self.boxRewardContent:SetActive(true)
  self.bossState = nil
end

local function RefreshShowStageState(self, enemyIsPlaced, isTransfer)
  if self.curStageType == ZoneMobilizationStageType.Battle_Place and not isTransfer then
    self.name_group:ReInit(false)
  else
    self.name_group:ReInit(true, self.zoneMobilizationDefendInfoData.bossId, 2, self.zoneMobilizationDefendInfoData.bossSrcServerId, false)
  end
  self.noPlaceTipsText:SetActive(not enemyIsPlaced)
  if not enemyIsPlaced then
    self.noPlaceTipsText:SetLocalText("zone_mobilization_challenge_not_found")
  end
  self.before_battle_tips_text:SetActive(false)
  self.transferContent:SetActive(isTransfer)
  self.curHpText:SetActive(not isTransfer)
  self.boxRewardContent:SetActive(not isTransfer)
  self.stageTimeContent:SetActive(self.curStageType == ZoneMobilizationStageType.Battle)
  self.battleFinishTipsText:SetActive(self.curStageType == ZoneMobilizationStageType.SettlementShow)
end

local function ShowTransferStage(self)
  local data = self.zoneMobilizationDefendInfoData
  self.startPositionText:SetText(self:SplitPostStr(data.bossSrcServerId, data.bossSrcPointId))
  self.endPositionText:SetText(self:SplitPostStr(DataCenter.LWZoneMobilizationManager.serverId, data.bossPointId))
  self:CutDownTransferTime()
end

local function CutDownTransferTime(self)
  local endTime = self.zoneMobilizationDefendInfoData.transferEndTime
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local surplusTime = endTime - curTime
  if surplusTime <= 0 then
    surplusTime = 0
  end
  if self.transferEndTimeText then
    self.transferEndTimeText:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(surplusTime))
  end
  if 0 < self.totalTime then
    local curProgress = Mathf.Clamp01((self.totalTime - surplusTime) / self.totalTime)
    if self.transferProgressSlider then
      self.transferProgressSlider:SetValue(curProgress)
    end
  end
end

local function SplitPostStr(self, serverId, pointId)
  local pos = SceneUtils.IndexToTilePos(pointId, ForceChangeScene.World)
  local posStr = Localization:GetString("zone_mobilization_coordinates", serverId, pos.x, pos.y)
  return "<u>" .. posStr .. "</u>"
end

local function ShowBattleStage(self)
  self:CutDownStageTime()
  local showTips = false
  local showContent = false
  if self.curStageType and self.curStageType == ZoneMobilizationStageType.Battle then
    local defendData = DataCenter.LWZoneMobilizationManager:GetZoneMobilizationDefendInfoData()
    if defendData then
      if defendData.bossState == ZoneMobilizationBossStatusFlag.Death then
        showTips = true
        self.battleFinishTipsText:SetLocalText("zone_mobilization_kill_tips")
      elseif defendData.bossState == ZoneMobilizationBossStatusFlag.Escape then
        showTips = true
        self.battleFinishTipsText:SetLocalText("zone_mobilization_flee_tips")
      elseif defendData.bossState == ZoneMobilizationBossStatusFlag.Alive then
        showContent = true
      end
    end
  end
  self.battleFinishTipsText:SetActive(showTips)
  self.stageTimeContent:SetActive(showContent)
end

local function CutDownStageTime(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local nextStageTime = DataCenter.LWZoneMobilizationManager.nextStageTime
  local surplusTime = nextStageTime - curTime
  if surplusTime <= 0 then
    surplusTime = 0
    if not self.alreadySendMsg then
      self.alreadySendMsg = true
      DataCenter.LWZoneMobilizationManager:RequestZoneMobilizationDonatedInfoData(ZoneMobilizationTabType.Defend)
    end
  end
  if self.stageTimeText and self.curStageType and self.curStageType == ZoneMobilizationStageType.Battle then
    local defendData = DataCenter.LWZoneMobilizationManager:GetZoneMobilizationDefendInfoData()
    if defendData and defendData.bossState == ZoneMobilizationBossStatusFlag.Alive then
      local ts = defendData.refreshTime
      if ts and curTime <= ts then
        self.stageTimeText:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(ts - curTime))
      end
    end
  end
end

local function ShowSettlementShowStage(self)
  local isWin = self.zoneMobilizationDefendInfoData.curHp <= 0
  if isWin then
    self.battleFinishTipsText:SetLocalText("zone_mobilization_defend_win")
  else
    self.battleFinishTipsText:SetLocalText("zone_mobilization_challenge_lose")
  end
  self.stageTimeContent:SetActive(false)
end

local function RefreshCurHpShow(self)
  local totalHp = DataCenter.LWZoneMobilizationManager:GetOppositeBossMaxHp()
  if self.curStageType == ZoneMobilizationStageType.Battle or self.curStageType == ZoneMobilizationStageType.SettlementShow then
    local str = string.GetFormattedSeparatorNum(self.zoneMobilizationDefendInfoData.curHp) .. "/" .. string.GetFormattedSeparatorNum(totalHp)
    self.curHpText:SetText(Localization:GetString("zone_mobilization_defend_hp_remain") .. str)
  else
    local str = string.GetFormattedSeparatorNum(self.zoneMobilizationDefendInfoData.curHp)
    self.curHpText:SetText(Localization:GetString("zone_mobilization_defend_hp_now") .. str)
  end
end

local function RefreshBoxRewardShow(self)
  self:ClearBoxReward()
  if self.zoneMobilizationDefendInfoData then
    local totalHp = DataCenter.LWZoneMobilizationManager:GetOppositeBossMaxHp()
    local bossCurHp = self.zoneMobilizationDefendInfoData.curHp
    if not self.zoneMobilizationDefendInfoData:EnemySideIsPlacedBoss() then
      bossCurHp = totalHp
    end
    local surplusHpPercent = bossCurHp / totalHp * 100
    self.boxRewardMaxNumText:SetText("100%")
    local boxRewardList = self.zoneMobilizationDefendInfoData.rewardList
    local rewardCount = table.count(boxRewardList)
    for i = 1, rewardCount do
      local obj = self.boxRewardItem:GameObjectSpawn(self.rewardContent.transform)
      obj.name = "item_" .. i
      obj:SetActive(true)
      local itemRender = self.rewardContent:AddComponent(LWUIZoneMobilizationBoxRewardItemRender, obj.name)
      itemRender:InitData(i, boxRewardList[i], surplusHpPercent)
    end
    local progress = Mathf.Clamp01(bossCurHp / totalHp)
    self.curHpProgressSlider:SetValue(progress)
  end
end

local function ClearBoxReward(self)
  self.rewardContent:RemoveComponents(LWUIZoneMobilizationBoxRewardItemRender)
  self.boxRewardItem:GameObjectRecycleAll()
end

local function RefreshRankShow(self)
  local rankList = self.zoneMobilizationDefendInfoData.rankList
  local rankCount = table.count(rankList)
  self.rankContent:SetActive(0 < rankCount)
  self.rankNoDataContent:SetActive(rankCount == 0)
  if 0 < rankCount then
    self:ClearRankShow()
    local maxScore = rankList[1].score
    for i = 1, rankCount do
      local obj = self.rankItem:GameObjectSpawn(self.topThreeRankContent.transform)
      obj.name = "item_" .. i
      obj:SetActive(true)
      local itemRender = self.topThreeRankContent:AddComponent(LWUIZoneMobilizationDefendRankItemRender, obj.name)
      itemRender:InitData(i, rankList[i], maxScore)
    end
  end
end

local function ClearRankShow(self)
  self.topThreeRankContent:RemoveComponents(LWUIZoneMobilizationDefendRankItemRender)
  self.rankItem:GameObjectRecycleAll()
end

local function RankBtnClick(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIZoneMobilizationAllianceRank, {anim = true}, ZoneMobilizationRankType.Damage)
end

local function StartPositionBtnClick(self)
  if self.zoneMobilizationDefendInfoData then
    DataCenter.LWZoneMobilizationManager:GoToBossPosition(self.zoneMobilizationDefendInfoData.bossSrcPointId, self.zoneMobilizationDefendInfoData.bossSrcServerId)
  end
end

local function EndPositionBtnClick(self)
  if self.zoneMobilizationDefendInfoData then
    DataCenter.LWZoneMobilizationManager:GoToBossPosition(self.zoneMobilizationDefendInfoData.bossPointId, DataCenter.LWZoneMobilizationManager.serverId)
  end
end

local function GetProgressTotalTime(self)
  self.totalTime = DataCenter.LWZoneMobilizationManager:GetTransferTotalTime()
  return self.totalTime
end

LWUIZoneMobilizationDefendSubView.OnCreate = OnCreate
LWUIZoneMobilizationDefendSubView.OnDestroy = OnDestroy
LWUIZoneMobilizationDefendSubView.OnEnable = OnEnable
LWUIZoneMobilizationDefendSubView.OnDisable = OnDisable
LWUIZoneMobilizationDefendSubView.ComponentDefine = ComponentDefine
LWUIZoneMobilizationDefendSubView.ComponentDestroy = ComponentDestroy
LWUIZoneMobilizationDefendSubView.DataDefine = DataDefine
LWUIZoneMobilizationDefendSubView.DataDestroy = DataDestroy
LWUIZoneMobilizationDefendSubView.OnAddListener = OnAddListener
LWUIZoneMobilizationDefendSubView.OnRemoveListener = OnRemoveListener
LWUIZoneMobilizationDefendSubView.Update1000MS = Update1000MS
LWUIZoneMobilizationDefendSubView.ReInitData = ReInitData
LWUIZoneMobilizationDefendSubView.RefreshView = RefreshView
LWUIZoneMobilizationDefendSubView.ShowDonatedStage = ShowDonatedStage
LWUIZoneMobilizationDefendSubView.RefreshShowStageState = RefreshShowStageState
LWUIZoneMobilizationDefendSubView.ShowTransferStage = ShowTransferStage
LWUIZoneMobilizationDefendSubView.CutDownTransferTime = CutDownTransferTime
LWUIZoneMobilizationDefendSubView.SplitPostStr = SplitPostStr
LWUIZoneMobilizationDefendSubView.ShowBattleStage = ShowBattleStage
LWUIZoneMobilizationDefendSubView.CutDownStageTime = CutDownStageTime
LWUIZoneMobilizationDefendSubView.ShowSettlementShowStage = ShowSettlementShowStage
LWUIZoneMobilizationDefendSubView.RefreshCurHpShow = RefreshCurHpShow
LWUIZoneMobilizationDefendSubView.RefreshBoxRewardShow = RefreshBoxRewardShow
LWUIZoneMobilizationDefendSubView.ClearBoxReward = ClearBoxReward
LWUIZoneMobilizationDefendSubView.RefreshRankShow = RefreshRankShow
LWUIZoneMobilizationDefendSubView.ClearRankShow = ClearRankShow
LWUIZoneMobilizationDefendSubView.RankBtnClick = RankBtnClick
LWUIZoneMobilizationDefendSubView.StartPositionBtnClick = StartPositionBtnClick
LWUIZoneMobilizationDefendSubView.EndPositionBtnClick = EndPositionBtnClick
LWUIZoneMobilizationDefendSubView.getters.totalTime = GetProgressTotalTime
return LWUIZoneMobilizationDefendSubView
