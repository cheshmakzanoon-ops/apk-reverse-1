local base = UIBaseView
local LWUIZoneMobilizationAttackSubView = BaseClass("LWUIZoneMobilizationAttackSubView", base)
local Localization = CS.GameEntry.Localization
local LWUIZoneMobilizationAttackRewardItemRender = require("UI.LWUIZoneMobilization.LWUIAttackSubView.LWUIZoneMobilizationAttackRewardItemRender")
local UIZoneMobilizationBossNameItem = require("UI.LWUIZoneMobilization.LWUIZoneMobilizationMain.Component.UIZoneMobilizationBossNameItem")
local curHpProgressSlider_path = "BattleContent/CurHpProgressSlider"
local curHpProgressValueText_path = "BattleContent/CurHpProgressSlider/CurHpProgressValueText"
local noPlaceTipsText_path = "NoPlaceTipsText"
local transferContent_path = "TransferContent"
local transferProgressSlider_path = "TransferContent/TransferProgressSlider"
local startPositionText_path = "TransferContent/StartPositionBtn/StartPositionText"
local endPositionText_path = "TransferContent/EndPositionBtn/EndPositionText"
local transferEndTimeText_path = "TransferContent/TransferEndTimeText"
local battleContent_path = "BattleContent"
local damageTipsText_path = "DamageText/DamageTipsText"
local damageText_path = "DamageText"
local battleFinishTipsText_path = "BattleFinishTipsText"
local rewardScrollView_path = "RewardScrollView"
local receiveAllRewardBtn_path = "ReceiveAllRewardBtn"
local receiveAllRewardBtnText_path = "ReceiveAllRewardBtn/ReceiveAllRewardBtnText"
local stageTimeText_path = "BattleContent/StageTimeText"
local startPositionBtn_path = "TransferContent/StartPositionBtn"
local endPositionBtn_path = "TransferContent/EndPositionBtn"
local place_stage_tips_text_path = "PlaceStageTipsText"
local name_group_path = "NameGroup"
local COLOR_STR_FORMAT = "<color=#f53c3d>%s</color>"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:RemoveRewardScroll()
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
  self.curHpProgressSlider = self:AddComponent(UISlider, curHpProgressSlider_path)
  self.curHpProgressValueText = self:AddComponent(UIText, curHpProgressValueText_path)
  self.noPlaceTipsText = self:AddComponent(UIText, noPlaceTipsText_path)
  self.transferContent = self:AddComponent(UIBaseContainer, transferContent_path)
  self.transferProgressSlider = self:AddComponent(UISlider, transferProgressSlider_path)
  self.startPositionText = self:AddComponent(UIText, startPositionText_path)
  self.endPositionText = self:AddComponent(UIText, endPositionText_path)
  self.transferEndTimeText = self:AddComponent(UIText, transferEndTimeText_path)
  self.battleContent = self:AddComponent(UIBaseContainer, battleContent_path)
  self.damageTipsText = self:AddComponent(UIText, damageTipsText_path)
  self.damageText = self:AddComponent(UIText, damageText_path)
  self.battleFinishTipsText = self:AddComponent(UIText, battleFinishTipsText_path)
  self.rewardScrollView = self:AddComponent(UIScrollView, rewardScrollView_path)
  self.receiveAllRewardBtn = self:AddComponent(UIButton, receiveAllRewardBtn_path)
  self.receiveAllRewardBtnText = self:AddComponent(UIText, receiveAllRewardBtnText_path)
  self.stageTimeText = self:AddComponent(UIText, stageTimeText_path)
  self.startPositionBtn = self:AddComponent(UIButton, startPositionBtn_path)
  self.endPositionBtn = self:AddComponent(UIButton, endPositionBtn_path)
  self.place_stage_tips_text = self:AddComponent(UITextMeshProUGUIEx, place_stage_tips_text_path)
  self.damageTipsText:SetLocalText("zone_mobilization_challenge_damege")
  self.receiveAllRewardBtn:SetOnClick(function()
    self:ReceiveAllRewardBtnClick()
  end)
  self.receiveAllRewardBtnText:SetLocalText("zone_mobilization_challenge_accept_all_btn")
  self.rewardScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnRewardItemMoveIn(itemObj, index)
  end)
  self.rewardScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnRewardItemMoveOut(itemObj, index)
  end)
  self.startPositionBtn:SetOnClick(function()
    self:StartPositionBtnClick()
  end)
  self.endPositionBtn:SetOnClick(function()
    self:EndPositionBtnClick()
  end)
  self.name_group = self:AddComponent(UIZoneMobilizationBossNameItem, name_group_path)
end

local function ComponentDestroy(self)
  self.curHpProgressSlider = nil
  self.curHpProgressValueText = nil
  self.noPlaceTipsText = nil
  self.transferContent = nil
  self.transferProgressSlider = nil
  self.startPositionText = nil
  self.endPositionText = nil
  self.transferEndTimeText = nil
  self.battleContent = nil
  self.damageTipsText = nil
  self.damageText = nil
  self.battleFinishTipsText = nil
  self.rewardScrollView = nil
  self.receiveAllRewardBtn = nil
  self.receiveAllRewardBtnText = nil
  self.stageTimeText = nil
  self.startPositionBtn = nil
  self.endPositionBtn = nil
  self.place_stage_tips_text = nil
  self.name_group = nil
end

local function DataDefine(self)
  self.curStageType = nil
  self.zoneMobilizationAttackInfoData = nil
  self.alreadySendMsg = false
  self.nextStageTime = nil
  self.refreshTime = nil
  self.totalTime = nil
  self.flicker = nil
  self.mark = nil
  self.flickerInternal = nil
end

local function DataDestroy(self)
  self.curStageType = nil
  self.zoneMobilizationAttackInfoData = nil
  self.alreadySendMsg = nil
  self.nextStageTime = nil
  self.refreshTime = nil
  self.totalTime = nil
  self.flicker = nil
  self.mark = nil
  self.flickerInternal = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.GetZoneMobilizationInfoData, self.RefreshView)
  self:AddUIListener(EventId.ReceiveChallengeRewardSuccess, self.OnReceiveRewardSuccess)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.GetZoneMobilizationInfoData, self.RefreshView)
  self:RemoveUIListener(EventId.ReceiveChallengeRewardSuccess, self.OnReceiveRewardSuccess)
  base.OnRemoveListener(self)
end

local function OnReceiveRewardSuccess(self, index)
  self:RefreshReceiveAllRewardBtnShow()
end

local function Update1000MS(self)
  if self.zoneMobilizationAttackInfoData == nil then
    return
  end
  self:CutDownStageTime()
  if self.curStageType then
    if self.curStageType == ZoneMobilizationStageType.Battle_Place then
      self:UpdateBattlePlaceCDTime()
    elseif self.curStageType == ZoneMobilizationStageType.Battle_Transfer then
      self:CutDownTransferTime()
    end
  end
end

local function ReInitData(self)
  self.alreadySendMsg = false
  DataCenter.LWZoneMobilizationManager:RequestZoneMobilizationDonatedInfoData(ZoneMobilizationTabType.Attack)
  self:RefreshView()
end

local function RefreshView(self)
  self.curStageType = DataCenter.LWZoneMobilizationManager:GetCurStageType()
  self.zoneMobilizationAttackInfoData = DataCenter.LWZoneMobilizationManager:GetZoneMobilizationAttackInfoData()
  if self.zoneMobilizationAttackInfoData then
    local stage = self.zoneMobilizationAttackInfoData.stage
    if stage and 0 < stage then
      self.curStageType = DataCenter.LWZoneMobilizationManager:GetStageType(stage)
    end
  end
  if self.curStageType == ZoneMobilizationStageType.Donated or self.curStageType == ZoneMobilizationStageType.Sprint then
    self:ShowDonatedStage()
    self:RefreshRewardShow()
  elseif self.zoneMobilizationAttackInfoData then
    self:RefreshShowStageState()
    self:RefreshReceiveAllRewardBtnShow()
    self:RefreshRewardShow()
    if self.curStageType == ZoneMobilizationStageType.Battle_Place then
      self:ShowBattlePlaceStage()
    elseif self.curStageType == ZoneMobilizationStageType.Battle_Transfer then
      self:ShowTransferStage()
    elseif self.curStageType == ZoneMobilizationStageType.Battle then
      self:ShowBattleStage()
    elseif self.curStageType == ZoneMobilizationStageType.SettlementShow then
      self:ShowSettlementShowStage()
    end
  end
end

local function ShowDonatedStage(self)
  self.name_group:ReInit(false)
  self.transferContent:SetActive(false)
  self.battleContent:SetActive(false)
  self.damageText:SetActive(false)
  self.battleFinishTipsText:SetActive(false)
  self.receiveAllRewardBtn:SetActive(false)
  self.noPlaceTipsText:SetActive(true)
  self.noPlaceTipsText:SetLocalText("zone_mobilization_not_open")
end

local function RefreshShowStageState(self)
  if self.curStageType == ZoneMobilizationStageType.Battle_Place then
    self.name_group:ReInit(false)
  else
    self.name_group:ReInit(true, DataCenter.LWZoneMobilizationManager.bossId, 1, DataCenter.LWZoneMobilizationManager.serverId, false)
  end
  local isPlaced = self.zoneMobilizationAttackInfoData:OurSideIsPlacedBoss()
  local isShowTips = not isPlaced and self.curStageType == ZoneMobilizationStageType.Battle_Place
  self.noPlaceTipsText:SetActive(isShowTips)
  if isShowTips then
    self.noPlaceTipsText:SetLocalText("zone_mobilization_defend_not_found")
  end
  self.transferContent:SetActive(self.curStageType == ZoneMobilizationStageType.Battle_Transfer)
  self.battleContent:SetActive(self.curStageType == ZoneMobilizationStageType.Battle)
  self.damageText:SetActive(self.curStageType == ZoneMobilizationStageType.Battle or self.curStageType == ZoneMobilizationStageType.SettlementShow)
  self.battleFinishTipsText:SetActive(self.curStageType == ZoneMobilizationStageType.SettlementShow)
end

local function ShowBattlePlaceStage(self)
  local endTime = DataCenter.LWZoneMobilizationManager.nextStageTime or 0
  self.nextStageTime = endTime
  self:UpdateBattlePlaceCDTime()
end

local function UpdateBattlePlaceCDTime(self)
  local context = ""
  if self.nextStageTime then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local offset = curTime <= self.nextStageTime and self.nextStageTime - curTime or 0
    if not self.flicker and offset < self.flickerInternal then
      self.flicker = true
    end
    if 0 < offset then
      local timeStr = UITimeManager:GetInstance():MilliSecondToFmtString(offset)
      local result = timeStr
      if self.flicker then
        if self.mark == nil or self.mark == 1 then
          result = string.format(COLOR_STR_FORMAT, timeStr)
          self.mark = 2
        else
          self.mark = 1
        end
      end
      context = Localization:GetString("zone_mobilization_battle_count_down", result)
    end
  end
  self.place_stage_tips_text:SetText(context)
end

local function ShowTransferStage(self)
  local data = self.zoneMobilizationAttackInfoData
  self.startPositionText:SetText(self:SplitPostStr(DataCenter.LWZoneMobilizationManager.serverId, DataCenter.LWZoneMobilizationManager.pointId))
  self.endPositionText:SetText(self:SplitPostStr(data.bossServerId, data.bossPointId))
  self:CutDownTransferTime()
  self.place_stage_tips_text:SetText("")
  self.nextStageTime = nil
end

local function CutDownTransferTime(self)
  local endTime = self.zoneMobilizationAttackInfoData.transferEndTime
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
  local totalHp = DataCenter.LWZoneMobilizationManager:GetOwnBossMaxHp()
  local curHp = self.zoneMobilizationAttackInfoData.curHp
  local str = string.GetFormattedSeparatorNum(curHp) .. "/" .. string.GetFormattedSeparatorNum(totalHp)
  self.curHpProgressValueText:SetText(str)
  local progress = Mathf.Clamp01(curHp / totalHp)
  self.curHpProgressSlider:SetValue(progress)
  self:RefreshDamageShow()
  local showTips = false
  local showContent = false
  local attackData = DataCenter.LWZoneMobilizationManager:GetZoneMobilizationAttackInfoData()
  if attackData then
    self:CutDownStageTime()
    if attackData.bossState == ZoneMobilizationBossStatusFlag.Death then
      showTips = true
      self.battleFinishTipsText:SetLocalText("zone_mobilization_kill_tips")
    elseif attackData.bossState == ZoneMobilizationBossStatusFlag.Escape then
      showTips = true
      self.battleFinishTipsText:SetLocalText("zone_mobilization_flee_tips")
    elseif attackData.bossState == ZoneMobilizationBossStatusFlag.Alive then
      showContent = true
      self.refreshTime = attackData.refreshTime
    end
  end
  self.battleFinishTipsText:SetActive(showTips)
  self.battleContent:SetActive(showContent)
end

local function CutDownStageTime(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local nextStageTime = DataCenter.LWZoneMobilizationManager.nextStageTime
  local surplusTime = nextStageTime - curTime
  if surplusTime <= 0 then
    surplusTime = 0
    if not self.alreadySendMsg then
      self.alreadySendMsg = true
      DataCenter.LWZoneMobilizationManager:RequestZoneMobilizationDonatedInfoData(ZoneMobilizationTabType.Attack)
    end
  end
  if self.stageTimeText and self.curStageType and self.curStageType == ZoneMobilizationStageType.Battle then
    local attackData = DataCenter.LWZoneMobilizationManager:GetZoneMobilizationAttackInfoData()
    if attackData and attackData.bossState == ZoneMobilizationBossStatusFlag.Alive and self.refreshTime and curTime <= self.refreshTime then
      self.stageTimeText:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(self.refreshTime - curTime))
    end
  end
end

local function ShowSettlementShowStage(self)
  self:RefreshDamageShow()
  local isAchieveAllDamage = self.zoneMobilizationAttackInfoData:IsAchieveAllDamage()
  if isAchieveAllDamage then
    self.battleFinishTipsText:SetLocalText("zone_mobilization_challenge_win")
  else
    self.battleFinishTipsText:SetLocalText("zone_mobilization_challenge_lose")
  end
  self.battleContent:SetActive(false)
end

local function RefreshDamageShow(self)
  self.damageText:SetText(string.GetFormattedSeparatorNum(self.zoneMobilizationAttackInfoData.damage))
end

local function RefreshReceiveAllRewardBtnShow(self)
  local canReceiveReward = self.zoneMobilizationAttackInfoData:CanReceiveReward()
  self.receiveAllRewardBtn:SetActive(canReceiveReward)
end

local function RefreshRewardShow(self)
  self:RemoveRewardScroll()
  if self.zoneMobilizationAttackInfoData then
    local rewardCount = table.count(self.zoneMobilizationAttackInfoData.rewardList)
    if 0 < rewardCount then
      self.rewardScrollView:SetTotalCount(rewardCount)
      self.rewardScrollView:RefillCells()
    end
  end
end

local function OnRewardItemMoveIn(self, itemObj, index)
  itemObj.name = tostring(index)
  local itemRender = self.rewardScrollView:AddComponent(LWUIZoneMobilizationAttackRewardItemRender, itemObj)
  if itemRender ~= nil then
    local rewardData = self.zoneMobilizationAttackInfoData.rewardList[index]
    itemRender:InitData(index, rewardData, self.zoneMobilizationAttackInfoData.damage)
  end
end

local function OnRewardItemMoveOut(self, itemObj, index)
  self.rewardScrollView:RemoveComponent(itemObj.name, LWUIZoneMobilizationAttackRewardItemRender)
end

local function RemoveRewardScroll(self)
  self.rewardScrollView:ClearCells()
  self.rewardScrollView:RemoveComponents(LWUIZoneMobilizationAttackRewardItemRender)
end

local function ReceiveAllRewardBtnClick(self)
  SFSNetwork.SendMessage(MsgDefines.ZoneMobilizationClaimChallengeReward, 0)
end

local function StartPositionBtnClick(self)
  DataCenter.LWZoneMobilizationManager:GoToBossPosition(DataCenter.LWZoneMobilizationManager.pointId, DataCenter.LWZoneMobilizationManager.serverId)
end

local function EndPositionBtnClick(self)
  local data = self.zoneMobilizationAttackInfoData
  if data then
    DataCenter.LWZoneMobilizationManager:GoToBossPosition(data.bossPointId, data.bossServerId)
  end
end

local function GetProgressTotalTime(self)
  self.totalTime = DataCenter.LWZoneMobilizationManager:GetTransferTotalTime()
  return self.totalTime
end

local function GetFlickerInternal(self)
  self.flickerInternal = LuaEntry.DataConfig:TryGetNum("zone_mobilization", "k29", 0) * 1000
  return self.flickerInternal
end

LWUIZoneMobilizationAttackSubView.OnCreate = OnCreate
LWUIZoneMobilizationAttackSubView.OnDestroy = OnDestroy
LWUIZoneMobilizationAttackSubView.OnEnable = OnEnable
LWUIZoneMobilizationAttackSubView.OnDisable = OnDisable
LWUIZoneMobilizationAttackSubView.ComponentDefine = ComponentDefine
LWUIZoneMobilizationAttackSubView.ComponentDestroy = ComponentDestroy
LWUIZoneMobilizationAttackSubView.DataDefine = DataDefine
LWUIZoneMobilizationAttackSubView.DataDestroy = DataDestroy
LWUIZoneMobilizationAttackSubView.OnAddListener = OnAddListener
LWUIZoneMobilizationAttackSubView.OnRemoveListener = OnRemoveListener
LWUIZoneMobilizationAttackSubView.OnReceiveRewardSuccess = OnReceiveRewardSuccess
LWUIZoneMobilizationAttackSubView.Update1000MS = Update1000MS
LWUIZoneMobilizationAttackSubView.ReInitData = ReInitData
LWUIZoneMobilizationAttackSubView.RefreshView = RefreshView
LWUIZoneMobilizationAttackSubView.ShowDonatedStage = ShowDonatedStage
LWUIZoneMobilizationAttackSubView.RefreshShowStageState = RefreshShowStageState
LWUIZoneMobilizationAttackSubView.ShowBattlePlaceStage = ShowBattlePlaceStage
LWUIZoneMobilizationAttackSubView.UpdateBattlePlaceCDTime = UpdateBattlePlaceCDTime
LWUIZoneMobilizationAttackSubView.ShowTransferStage = ShowTransferStage
LWUIZoneMobilizationAttackSubView.CutDownTransferTime = CutDownTransferTime
LWUIZoneMobilizationAttackSubView.SplitPostStr = SplitPostStr
LWUIZoneMobilizationAttackSubView.ShowBattleStage = ShowBattleStage
LWUIZoneMobilizationAttackSubView.CutDownStageTime = CutDownStageTime
LWUIZoneMobilizationAttackSubView.ShowSettlementShowStage = ShowSettlementShowStage
LWUIZoneMobilizationAttackSubView.RefreshDamageShow = RefreshDamageShow
LWUIZoneMobilizationAttackSubView.RefreshReceiveAllRewardBtnShow = RefreshReceiveAllRewardBtnShow
LWUIZoneMobilizationAttackSubView.RefreshRewardShow = RefreshRewardShow
LWUIZoneMobilizationAttackSubView.OnRewardItemMoveIn = OnRewardItemMoveIn
LWUIZoneMobilizationAttackSubView.OnRewardItemMoveOut = OnRewardItemMoveOut
LWUIZoneMobilizationAttackSubView.RemoveRewardScroll = RemoveRewardScroll
LWUIZoneMobilizationAttackSubView.ReceiveAllRewardBtnClick = ReceiveAllRewardBtnClick
LWUIZoneMobilizationAttackSubView.StartPositionBtnClick = StartPositionBtnClick
LWUIZoneMobilizationAttackSubView.EndPositionBtnClick = EndPositionBtnClick
LWUIZoneMobilizationAttackSubView.getters.totalTime = GetProgressTotalTime
LWUIZoneMobilizationAttackSubView.getters.flickerInternal = GetFlickerInternal
return LWUIZoneMobilizationAttackSubView
