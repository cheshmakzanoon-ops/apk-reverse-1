local base = UIBaseContainer
local UIEBH_Basic = BaseClass("UIEBH_Basic", base)
local Localization = CS.GameEntry.Localization
local UIEBH_SoldierCell = require("UI.UIActivityCenterTable.Component.ActEpidemic.BattleHeal.Component.UIEBH_SoldierCell")
local world_node_path = "worldNode"
local tips_btn_path = "worldNode/TipsBtn"
local soldier_cell_path = "SoldierCell"
local treating_content_path = "TreatingContent"
local treating_time_slider_path = "TreatingContent/cfm_tongyong_erji_dichen_1/TreatingTimeSlider"
local treating_time_text_path = "TreatingContent/cfm_tongyong_erji_dichen_1/TreatingTimeText"
local treating_num_text_path = "TreatingContent/cfm_tongyong_erji_dichen_1/TreatingNumText"
local empty_text_path = "EmptyText"
local instant_btn_path = "btnLayout/InstantBtn"
local instant_icon_path = "btnLayout/InstantBtn/instantIcon"
local cost_instant_text_path = "btnLayout/InstantBtn/instantIcon/CostInstantText"
local time_btn_path = "btnLayout/TimeBtn"
local time_text_path = "btnLayout/TimeBtn/TimeIcon/timeText"
local speed_up_btn_path = "btnLayout/SpeedUpBtn"
local receive_btn_path = "btnLayout/ReceiveBtn"
local goldIconPath = "Assets/Main/Sprites/UI/LWCommon/Sprite/Common_icon_gold.png"
local timeIconPath = "Assets/Main/Sprites/UI/LWCommon/Sprite/guaji_cfm_tubiao_2.png"

function UIEBH_Basic:OnCreate()
  base.OnCreate(self)
  self.completeImmediatelyData = {}
  self.instantInfo = {}
  self.soldierList = {}
  self.startSoldierDic = {}
  self.time = 0
  self.hospitalCureMsgLock = false
  self.isTreating = false
  self.isFinishTreating = false
  self.treatingQueue = nil
  self.cacheSoliderCureCount = {}
  self.isEdit = false
  self.world_node = self:AddComponent(UIBaseComponent, world_node_path)
  self.tips_btn = self:AddComponent(UIButton, tips_btn_path)
  self.tips_btn:SetOnClick(function()
    UIUtil.ShowTipsId("Desert_strom_tips1022")
  end)
  self.soldier_cell = self:AddComponent(UIEBH_SoldierCell, soldier_cell_path)
  self.treating_content = self:AddComponent(UIBaseContainer, treating_content_path)
  self.treating_time_slider = self:AddComponent(UISlider, treating_time_slider_path)
  self.treating_time_text = self:AddComponent(UITextMeshProUGUIEx, treating_time_text_path)
  self.treating_num_text = self:AddComponent(UITextMeshProUGUIEx, treating_num_text_path)
  self.empty_text = self:AddComponent(UITextMeshProUGUIEx, empty_text_path)
  self.instant_btn = self:AddComponent(UIButton, instant_btn_path)
  self.instant_btn:SetOnClick(BindCallback(self, self.OnInstantBtnClick))
  self.instant_icon = self:AddComponent(UIImage, instant_icon_path)
  self.cost_instant_text = self:AddComponent(UITextMeshProUGUIEx, cost_instant_text_path)
  self.time_btn = self:AddComponent(UIButton, time_btn_path)
  self.time_btn:SetOnClick(BindCallback(self, self.OnTimeBtnClick))
  self.time_text = self:AddComponent(UITextMeshProUGUIEx, time_text_path)
  self.speed_up_btn = self:AddComponent(UIButton, speed_up_btn_path)
  self.speed_up_btn:SetOnClick(BindCallback(self, self.SpeedUpBtnClick))
  self.receive_btn = self:AddComponent(UIButton, receive_btn_path)
  self.receive_btn:SetOnClick(BindCallback(self, self.ReceiveBtnClick))
  self:UpdateData()
end

function UIEBH_Basic:OnDestroy()
  self.soldierList = nil
  self.startSoldierDic = nil
  self.time = nil
  self.hospitalCureMsgLock = false
  self.isTreating = nil
  self.isFinishTreating = nil
  self.treatingQueue = nil
  self.isEdit = nil
  self.completeImmediatelyData = nil
  self:CleanTimer()
  self.tips_btn = nil
  self.soldier_call = nil
  self.treating_content = nil
  self.treating_time_slider = nil
  self.treating_time_text = nil
  self.treating_num_text = nil
  self.empty_text = nil
  self.instant_btn = nil
  self.instant_icon = nil
  self.cost_instant_text = nil
  self.time_btn = nil
  self.time_text = nil
  self.speed_up_btn = nil
  self.receive_btn = nil
  base.OnDestroy(self)
end

function UIEBH_Basic:OnEnabled()
  base.OnEnable(self)
  self:CleanTimer()
  SFSNetwork.SendMessage(MsgDefines.DragonHospitalInfo)
  
  function self.TimerAction()
    SFSNetwork.SendMessage(MsgDefines.DragonHospitalInfo)
  end
  
  local unitTime = DataCenter.DragonBuildTemplateManager:GetItemValue("k14")
  self.timer = TimerManager:GetInstance():GetTimer(unitTime, self.TimerAction, self, false, false, false)
  self.timer:Start()
end

function UIEBH_Basic:OnDisable()
  self:CleanTimer()
  base.OnDisable(self)
end

function UIEBH_Basic:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ResourceUpdated, self.RefreshResCell)
  self:AddUIListener(EventId.InstantCureFinish, self.OnInstantCureFinish)
  self:AddUIListener(EventId.UpdateGold, self.RefreshGlod)
  self:AddUIListener(EventId.HospitalUpdate, self.OnHospitalUpdate)
  self:AddUIListener(EventId.UnLockHospitalCureMsg, self.UnLockHospitalCureMsg)
  self:AddUIListener(EventId.AddSpeedSuccess, self.OnAddSpeedUpSuccess)
end

function UIEBH_Basic:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.ResourceUpdated, self.RefreshResCell)
  self:RemoveUIListener(EventId.InstantCureFinish, self.OnInstantCureFinish)
  self:RemoveUIListener(EventId.UpdateGold, self.RefreshGlod)
  self:RemoveUIListener(EventId.HospitalUpdate, self.OnHospitalUpdate)
  self:RemoveUIListener(EventId.UnLockHospitalCureMsg, self.UnLockHospitalCureMsg)
  self:RemoveUIListener(EventId.AddSpeedSuccess, self.OnAddSpeedUpSuccess)
end

function UIEBH_Basic:CleanTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
    self.TimerAction = nil
  end
end

function UIEBH_Basic:CloseSelf()
  self.view.ctrl:CloseSelf()
end

function UIEBH_Basic:OnAddSpeedUpSuccess(queueType)
  if (queueType == NewQueueType.Hospital or queueType == NewQueueType.DragonHospital) and self.isTreating and self.treatingQueue then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local remainTime = self.treatingQueue.endTime - curTime
    if remainTime <= 0 then
      self:CloseSelf()
    end
  end
end

function UIEBH_Basic:OnInstantCureFinish()
  self:RefreshView()
  self:ShowScroll()
  self:InitInstantBtn()
end

function UIEBH_Basic:OnHospitalUpdate()
  self:RefreshIsTreatingState()
  self:RefreshView()
  self:ShowScroll()
  self:InitInstantBtn()
end

function UIEBH_Basic:UpdateData()
  SFSNetwork.SendMessage(MsgDefines.DragonHospitalInfo)
  self:RefreshIsTreatingState()
  self:RefreshView()
  self:ShowScroll()
  self:InitInstantBtn()
end

function UIEBH_Basic:Update1000MS()
  if self.isTreating then
    self:UpdateTrainingRemainTime()
  end
  if SeasonUtil.IsInSeasonSnowMode() then
    self:ChangeExpenditure()
  end
end

function UIEBH_Basic:OnInstantBtnClick()
  if self.hospitalCureMsgLock then
    UIUtil.ShowTipsId(120289)
    return
  end
  if self.time == 0 then
    return
  end
  if SeasonUtil.IsInSeasonSnowMode() then
    self:ChangeExpenditure()
  end
  if not self.instantIsUnlock then
    local template = DataCenter.LWFunctionUnlockManager:GetTemplate(LWFunctionUnlockType.SoliderInstantFinish)
    local buildData = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(template.needBuildingType)[1]
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIBuildUpgrade, buildData.uuid)
    self:CloseSelf()
    return
  end
  self:RefreshState(self.time)
  local hasSpeedItem = 0 < #self.instantInfo.speedUpitems
  local canOpenNewView = hasSpeedItem
  if canOpenNewView then
    self.completeImmediatelyData.resLackDatas = {}
    
    function self.completeImmediatelyData.OnClickImmediately(data)
      local speedItems = data.speedUpItems
      self:SendMessage(IsGold.NoUseGold, speedItems, data.timeGold, data.resGold)
    end
    
    UIManager:GetInstance():OpenWindow(UIWindowNames.CompleteImmdiatelyPanel, {anim = true}, self.completeImmediatelyData)
  else
    local gold = self.timeGold
    local hasGold = LuaEntry.Player.gold
    if gold > hasGold then
      LWResourceLackUtil:GotoResLack({
        {
          resType = ResourceType.Gold,
          need = gold
        }
      })
    else
      local param = {
        contentText = Localization:GetString(GameDialogDefine.USE_GOLF_TIP_DES),
        btnNum = 2,
        confirmBtnParam = {
          action = function()
            self:SendMessage(IsGold.UseGold, nil, self.timeGold)
          end
        }
      }
      UIUtil.TryShowDiamondConfirm(TodayNoSecondConfirmType.UpgradeUseDiamond, param)
    end
  end
end

function UIEBH_Basic:RefreshState(time)
  self.instantInfo = LWResourceLackUtil:GetResState(time, {}, ItemSpdMenu.ItemSpdMenu_Heal) or {}
  if not self.completeImmediatelyData.speedUpData then
    self.completeImmediatelyData.speedUpData = {}
  end
  self.completeImmediatelyData.speedUpData.speedUpItems = self.instantInfo.speedUpitems
  self.completeImmediatelyData.speedUpData.speedUpDifferentTime = self.instantInfo.time
  self.completeImmediatelyData.speedUpData.speedUpTotalTime = time
end

function UIEBH_Basic:RefreshGold()
  local gold = self.timeGold
  if gold then
    local hasGold = LuaEntry.Player.gold
    if gold > hasGold then
      self.cost_instant_text:SetColorRGBA(0.937, 0.329, 0.259, 1)
    else
      self.cost_instant_text:SetColorRGBA(1, 1, 1, 1)
    end
  end
end

function UIEBH_Basic:RefreshBtn(time)
  local hasSpeedItem = #self.instantInfo.speedUpitems > 0
  local canOpenNewCompleteImmidatelySpeedMatch = hasSpeedItem
  if canOpenNewCompleteImmidatelySpeedMatch then
    self.cost_instant_text:SetColorRGBA(1, 1, 1, 1)
    self.instant_icon:LoadSpriteAuto(timeIconPath)
    self.cost_instant_text:SetText(UITimeManager:GetInstance():SecondToFmtString(math.ceil(time)))
  else
    self.instant_icon:LoadSpriteAuto(goldIconPath)
    self.timeGold = 0
    self.timeGold = CommonUtil.GetTimeDiamondCost(self.time)
    self:RefreshGold()
    self.cost_instant_text:SetText(string.GetFormattedSeperatorNum(self.timeGold))
  end
end

function UIEBH_Basic:OnTimeBtnClick()
  if self.time == 0 then
    return
  end
  self:SendMessage(IsGold.NoUseGold)
  self:CloseSelf()
end

function UIEBH_Basic:SendMessage(type, itemIds, timeGold)
  local param = {}
  param.gold = type
  if itemIds then
    param.itemIds = itemIds
  end
  if timeGold then
    param.goldForTime = timeGold
  end
  local arr = {}
  for _, info in pairs(self.soldierList) do
    if info.curCount ~= nil and info.curCount > 0 then
      arr[info.armyId] = info.curCount
    end
  end
  if 0 < table.count(arr) then
    param.arr = arr
    SFSNetwork.SendMessage(MsgDefines.HospitalCure, param)
    if self.isEdit then
      DataCenter.HospitalManager:SetSoldierCureTimeValueLocal(self:CheckCureSoldierMax() and -1 or self.time)
      self.isEdit = false
    end
    self.hospitalCureMsgLock = true
  else
    Logger.LogError("hospital error  soldierCount 0 ----->")
  end
end

function UIEBH_Basic:InitInstantBtn()
  self.instantIsUnlock = DataCenter.LWFunctionUnlockManager:CheckCanShow(LWFunctionUnlockType.SoliderInstantFinish)
  if self.instantIsUnlock then
    self.instant_btn:SetActive(not self.isTreating and not self.isFinishTreating)
  else
    self.instant_btn:SetActive(false)
  end
end

function UIEBH_Basic:RefreshView()
  self.cost_instant_text:SetColorRGBA(1, 1, 1, 1)
  self.soldierList = DataCenter.HospitalManager:GetDeadHospital()
  self.startSoldierDic = self.view.ctrl:GetStartSoldierCountDic()
  local isTreatingOrFinish = self.isTreating or self.isFinishTreating
  local deadSoldierCount = self.view.ctrl:GetMaxDeadSoldier()
  if deadSoldierCount == 0 then
    self.world_node:SetActive(false)
    self.empty_text:SetActive(true)
    if not isTreatingOrFinish then
      CS.UIGray.SetGray(self.time_btn.transform, true, false)
    end
  else
    self.world_node:SetActive(true)
    self.empty_text:SetActive(false)
    if not isTreatingOrFinish then
      CS.UIGray.SetGray(self.time_btn.transform, false, true)
    end
  end
  self.treating_content:SetActive(isTreatingOrFinish)
  self.speed_up_btn:SetActive(self.isTreating)
  self.time_btn:SetActive(not isTreatingOrFinish)
  self.instant_btn:SetActive(not isTreatingOrFinish)
  self.receive_btn:SetActive(self.isFinishTreating)
  if isTreatingOrFinish then
    self:RefreshTreatingInfoShowView()
  end
  for i, v in pairs(self.soldierList) do
    if self.cacheSoliderCureCount[i] ~= nil then
      v.curCount = self.cacheSoliderCureCount[i]
    else
      v.curCount = self.startSoldierDic[v.armyId]
      self.cacheSoliderCureCount[i] = v.curCount
    end
  end
  self:ChangeExpenditure()
end

function UIEBH_Basic:ChangeSoliderCount(index, count, isEdit)
  if self.soldierList[index] then
    self.soldierList[index].curCount = count
  end
  self.cacheSoliderCureCount[index] = count
  self.isEdit = isEdit
  self:ChangeExpenditure()
end

function UIEBH_Basic:ChangeExpenditure()
  self.time = 0
  for i = 1, #self.soldierList do
    self:GetOneSoldierExpenditure(tonumber(self.soldierList[i].armyId), self.soldierList[i].curCount or 0)
  end
  self:RefreshResCell()
  local healSpeedUp = LuaEntry.Effect:GetGameEffect(EffectDefine.LW_HOSPITAL_HEALSPEEDUP) or 0
  if SeasonUtil.IsInSeasonSnowMode() then
    local temp = DataCenter.TemperatureManager:GetMyBaseTemperature()
    local curMeta = DataCenter.TemperatureTemplateManager:GetTemplate(math.floor(temp))
    healSpeedUp = healSpeedUp + curMeta:GetValue(EffectDefine.LW_HOSPITAL_HEALSPEEDUP)
  end
  self.time = self.time / (1 + healSpeedUp)
  local dragonSpeedUp
  if BattleFieldUtil.InBattleField(BattleFieldType.Desert) then
    dragonSpeedUp = BattleFieldUtil.GetEffectById(EffectDefine.LW_DRAGON_SOLDIER_HOSPITAL_SPEED_ADD_PERCENT)
  elseif BattleFieldUtil.InBattleField(BattleFieldType.EpidemicZone) then
    dragonSpeedUp = BattleFieldUtil.GetEffectById(EffectDefine.LW_EFF_EPIDEMIC_HOSPITAL_SPEED_ADD)
  end
  if dragonSpeedUp ~= nil and dragonSpeedUp ~= 0 then
    self.time = self.time / (1 + dragonSpeedUp * 1.0E-4)
  end
  self.time_text:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(self.time * 1000))
  self:RefreshState(self.time)
  self:RefreshBtn(self.time)
end

function UIEBH_Basic:RefreshResCell()
  self:RefreshState(self.time)
  self:RefreshBtn(self.time)
end

function UIEBH_Basic:GetOneSoldierExpenditure(armyId, count)
  local soldierTemplate = DataCenter.SoldierDataManager:GetTemplate(armyId)
  if soldierTemplate then
    self.time = self.time + soldierTemplate.cureTime * count
  end
end

function UIEBH_Basic:ShowScroll()
  local l = #self.soldierList
  local isTreatingOrFinish = self.isTreating or self.isFinishTreating
  self.soldier_cell:SetActive(not isTreatingOrFinish and 0 < l)
  if not isTreatingOrFinish and 0 < l then
    local data = self.soldierList[1]
    data.index = 1
    data.callback = BindCallback(self, self.ChangeSoliderCount)
    if self.cacheSoliderCureCount[1] ~= nil then
      data.curCount = self.cacheSoliderCureCount[1]
    else
      data.curCount = self.startSoldierDic[data.armyId] or 1
    end
    self.soldier_cell:ReInit(data, isTreatingOrFinish)
  end
end

function UIEBH_Basic:UnLockHospitalCureMsg()
  self.hospitalCureMsgLock = false
end

function UIEBH_Basic:RefreshIsTreatingState()
  self.isTreating = false
  self.treatingQueue = nil
  self.isFinishTreating = false
  self.treatingQueue = DataCenter.QueueDataManager:GetQueueByType(NewQueueType.DragonHospital)
  if self.treatingQueue ~= nil then
    local state = self.treatingQueue:GetQueueState()
    self.isTreating = state == NewQueueState.Work
    self.isFinishTreating = state == NewQueueState.Finish
  end
end

function UIEBH_Basic:RefreshTreatingInfoShowView()
  local treatingTotalCount = 0
  local treatingSoldierList = DataCenter.HospitalManager:GetTreatingHospital()
  for i = 1, table.count(treatingSoldierList) do
    local treatingSoldierInfo = treatingSoldierList[i]
    treatingTotalCount = treatingTotalCount + treatingSoldierInfo.heal
  end
  self.treating_num_text:SetText(treatingTotalCount)
  self:UpdateTrainingRemainTime()
end

function UIEBH_Basic:UpdateTrainingRemainTime()
  if (self.isTreating or self.isFinishTreating) and self.treatingQueue then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local remainTime = self.treatingQueue.endTime - curTime
    if remainTime < 0 then
      remainTime = 0
    end
    if self.treating_time_text ~= nil then
      self.treating_time_text:SetLocalText("hospital_curing_tips", UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
    end
    local totalTime = self.treatingQueue.endTime - self.treatingQueue.startTime
    local curProgress = Mathf.Clamp(1 - remainTime / totalTime, 0, 1)
    self.treating_time_slider:SetValue(curProgress)
    if remainTime == 0 then
      self.treating_time_text:SetLocalText(170008)
      self.speed_up_btn:SetActive(false)
      self.receive_btn:SetActive(true)
    end
  end
end

function UIEBH_Basic:SpeedUpBtnClick()
  if self.treatingQueue ~= nil and self.isTreating then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UISpeed, ItemSpdMenu.ItemSpdMenu_Heal, self.treatingQueue.uuid)
  end
end

function UIEBH_Basic:ReceiveBtnClick()
  local uuId = self:GetUserData()
  DataCenter.HospitalManager:CheckSendFinish(uuId)
  self:CloseSelf()
end

function UIEBH_Basic:CheckCureSoldierMax()
  if self.soldierList then
    local count = 0
    for _, v in ipairs(self.soldierList) do
      if v and v.curCount then
        count = count + v.curCount
      end
    end
    local maxDeadSoldier = self.view.ctrl:GetMaxDeadSoldier()
    return count >= maxDeadSoldier
  end
end

return UIEBH_Basic
