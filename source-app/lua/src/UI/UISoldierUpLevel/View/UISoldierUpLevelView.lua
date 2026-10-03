local UISoldierUpLevelView = BaseClass("UISoldierUpLevelView", UIBaseView)
local UISoldierInfoPanel = require("UI/UISoldierUpLevel/Component/UISoldierInfoPanel")
local Localization = CS.GameEntry.Localization
local base = UIBaseView
local goldIconPath = "Assets/Main/Sprites/UI/LWCommon/Sprite/Common_icon_gold.png"
local timeIconPath = "Assets/Main/Sprites/UI/LWCommon/Sprite/guaji_cfm_tubiao_2.png"

function UISoldierUpLevelView:OnCreate()
  base.OnCreate(self)
  self.completeImmdiatelyData = {}
  self:ComponentDefine()
  self:ReInit()
end

function UISoldierUpLevelView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UISoldierUpLevelView:DataDestroy()
  self.count = nil
  self.buildData = nil
  self.maxSoldierId = nil
  self.minSoldierId = nil
  self.buildingCampTrainingMsgLock = nil
  self.completeImmdiatelyData = nil
end

function UISoldierUpLevelView:ComponentDefine()
  self.minSoldierPanel = self:AddComponent(UISoldierInfoPanel, "Root/SoldierTipView1")
  self.maxSoldierPanel = self:AddComponent(UISoldierInfoPanel, "Root/SoldierTipView2")
  self.moneyCostCountText = self:AddComponent(UIText, "Root/TrainContent/CostResourceGroup/CostMoney/MoneyCostCountText")
  self.ironCostCountText = self:AddComponent(UIText, "Root/TrainContent/CostResourceGroup/CostIron/IronCostCountText")
  self.closeBtn = self:AddComponent(UIButton, "UICommonPopUpTitle/CloseBtn")
  self.addBtn = self:AddComponent(UIButton, "Root/TrainContent/addBtn")
  self.subtractBtn = self:AddComponent(UIButton, "Root/TrainContent/subtractBtn")
  self.slider = self:AddComponent(UISlider, "Root/TrainContent/TrainCountSlider")
  self.count_text = self:AddComponent(UIText, "Root/TrainContent/TrainCountGroup/TrainCountText")
  self.curTrainTimeText = self:AddComponent(UIText, "Root/btnLayout/TrainBtn/TimeIcon/CostTimeText")
  self.trainBtnText = self:AddComponent(UIText, "Root/btnLayout/TrainBtn/TrainBtnText")
  self.trainBtn = self:AddComponent(UIButton, "Root/btnLayout/TrainBtn")
  self.titleText = self:AddComponent(UIText, "UICommonPopUpTitle/Common_img_title/titleText")
  self.panelBtn = self:AddComponent(UIButton, "UICommonPopUpTitle/panel")
  self.outSoliderText = self:AddComponent(UIText, "Root/SoldierTipView1/UISoldierItem/outSoliderText")
  self.instantBtn = self:AddComponent(UIButton, "Root/btnLayout/instantBtn")
  self.instantUnLockText = self:AddComponent(UIText, "Root/btnLayout/instantBtn/unLockText")
  self.instantCostText = self:AddComponent(UIText, "Root/btnLayout/instantBtn/instantIcon/CostInstantText")
  self.instantIcon = self:AddComponent(UIImage, "Root/btnLayout/instantBtn/instantIcon")
  self.instantBtnText = self:AddComponent(UIText, "Root/btnLayout/instantBtn/instantBtnText")
  self.instantBtn:SetOnClick(function()
    self:OnInstantBtnClick()
  end)
  self.panelBtn:SetOnClick(function()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UISoldierUpLevel)
  end)
  self.closeBtn:SetOnClick(function()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UISoldierUpLevel)
  end)
  self.trainBtn:SetOnClick(function()
    self:OnTrainBtnClick()
  end)
  self.slider:SetOnValueChanged(function(value)
    self:OnCountSliderValueChanged(value)
  end)
  self.addBtn:SetOnClick(function()
    self:OnAddBtnClick()
  end)
  self.subtractBtn:SetOnClick(function()
    self:OnSubtractBtnClick()
  end)
end

function UISoldierUpLevelView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ResourceUpdated, self.OnResourceUpdate)
  self:AddUIListener(EventId.UpdateGold, self.RefreshGoldColor)
  self:AddUIListener(EventId.InstantUpgradeDataUpdate, self.OnInstantUpgradeDataUpdate)
  self:AddUIListener(EventId.UnLockBuildingCampTrainingMsg, self.UnLockBuildingCampTrainingMsg)
end

function UISoldierUpLevelView:OnRemoveListener()
  self:RemoveUIListener(EventId.ResourceUpdated, self.RefreshRes)
  self:RemoveUIListener(EventId.UpdateGold, self.RefreshGoldColor)
  self:RemoveUIListener(EventId.InstantUpgradeDataUpdate, self.OnInstantUpgradeDataUpdate)
  self:RemoveUIListener(EventId.UnLockBuildingCampTrainingMsg, self.UnLockBuildingCampTrainingMsg)
  base.OnRemoveListener(self)
end

function UISoldierUpLevelView:OnInstantUpgradeDataUpdate(data)
  self:ReInit(data.minData, data.maxData, data.buildData, data.maxCount)
end

function UISoldierUpLevelView:InitInstantBtn()
  self.instantIsUnlock = DataCenter.LWFunctionUnlockManager:CheckCanShow(LWFunctionUnlockType.SoliderInstantFinish)
  if self.instantIsUnlock then
    self.instantBtn:SetActive(true)
  else
    self.instantBtn:SetActive(false)
  end
end

function UISoldierUpLevelView:OnInstantBtnClick()
  if self.buildingCampTrainingMsgLock then
    UIUtil.ShowTipsId(120289)
    return
  end
  if self.time == 0 then
    return
  end
  if not self.instantIsUnlock then
    local template = DataCenter.LWFunctionUnlockManager:GetTemplate(LWFunctionUnlockType.SoliderInstantFinish)
    local buildData = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(template.needBuildingType)[1]
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIBuildUpgrade, buildData.uuid)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UISoldierUpLevel)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWMilitaryCampPanel)
    return
  end
  self:RefreshState(self.time)
  local resNoEnough = self.needList and 0 < #self.needList
  local resHasCanSupplyItems = false
  if resNoEnough then
    for i, needResData in ipairs(self.needList) do
      local exist = LWResourceLackUtil:IsExistLackResourceIteminBag(needResData.resType)
      if exist then
        resHasCanSupplyItems = exist
        break
      end
    end
  end
  local canOpenNewCompleteImmidatelyResMatch = resNoEnough and resHasCanSupplyItems
  local hasSpeedItem = 0 < #self.instantinfo.speedUpitems
  local canOpenNewCompleteImmidatelySpeedMatch = hasSpeedItem
  if canOpenNewCompleteImmidatelyResMatch or canOpenNewCompleteImmidatelySpeedMatch then
    self.completeImmdiatelyData.resLackDatas = {}
    for i, needResData in ipairs(self.needList) do
      local resLackData = {}
      resLackData.resType = needResData.resType
      resLackData.totalNeedCount = needResData.need
      table.insert(self.completeImmdiatelyData.resLackDatas, resLackData)
    end
    
    function self.completeImmdiatelyData.OnClickImmediately(data)
      local speedItems = data.speedUpItems
      local curLevel = DataCenter.SoldierDataManager:GetSoldierLevelById(self.minSoldierId)
      local maxLevel = DataCenter.SoldierDataManager:GetSoldierLevelById(self.maxSoldierId)
      SFSNetwork.SendMessage(MsgDefines.BuildingCampTraining, self.buildData.uuid, 0, maxLevel, self.count, curLevel, speedItems, data.timeGold, data.resGold)
      self.buildingCampTrainingMsgLock = true
    end
    
    UIManager:GetInstance():OpenWindow(UIWindowNames.CompleteImmdiatelyPanel, {anim = true}, self.completeImmdiatelyData)
  else
    local curLevel = DataCenter.SoldierDataManager:GetSoldierLevelById(self.minSoldierId)
    local maxLevel = DataCenter.SoldierDataManager:GetSoldierLevelById(self.maxSoldierId)
    local glod = self.timeGlod + self.resGlod
    local hasGlod = LuaEntry.Player.gold
    if glod > hasGlod then
      LWResourceLackUtil:GotoResLack({
        {
          resType = ResourceType.Gold,
          need = glod
        }
      })
    else
      do
        local param = {
          contentText = Localization:GetString(GameDialogDefine.USE_GOLF_TIP_DES),
          btnNum = 2,
          confirmBtnParam = {
            action = function()
              SFSNetwork.SendMessage(MsgDefines.BuildingCampTraining, self.buildData.uuid, 0, maxLevel, self.count, curLevel, nil, self.timeGlod, self.resGlod)
              self.buildingCampTrainingMsgLock = true
            end
          }
        }
        UIUtil.TryShowDiamondConfirm(TodayNoSecondConfirmType.UpgradeUseDiamond, param)
      end
    end
  end
end

function UISoldierUpLevelView:OnCountSliderValueChanged(value)
  if not (self.expenseCostIron and self.expenseCostMoney) or not self.perCostTime then
    return
  end
  self.money = math.ceil(value * self.expenseCostMoney)
  self.iron = math.ceil(value * self.expenseCostIron)
  self.moneyCostCountText:SetText(string.GetFormattedStr(self.money))
  self.ironCostCountText:SetText(string.GetFormattedStr(self.iron))
  self.count = math.ceil(value)
  self.count_text:SetText(self.count)
  self.time = math.ceil(value * self.perCostTime)
  self.curTrainTimeText:SetText(UITimeManager:GetInstance():SecondToFmtString(math.ceil(self.time)))
  self:RefreshRes()
  self:RefreshState(self.time)
  self:RefreshBtn(self.time)
end

function UISoldierUpLevelView:OnResourceUpdate()
  self:RefreshRes()
  self:RefreshState(self.time)
  self:RefreshBtn(self.time)
end

function UISoldierUpLevelView:RefreshState(time)
  self.instantinfo = LWResourceLackUtil:GetResState(time, self.needList)
  if not self.completeImmdiatelyData.speedUpData then
    self.completeImmdiatelyData.speedUpData = {}
  end
  self.completeImmdiatelyData.speedUpData.speedUpItems = self.instantinfo.speedUpitems
  self.completeImmdiatelyData.speedUpData.speedUpDifferentTime = self.instantinfo.time
  self.completeImmdiatelyData.speedUpData.speedUpTotalTime = time
end

function UISoldierUpLevelView:RefreshGoldColor()
  if self.timeGlod and self.resGlod then
    local glod = self.timeGlod + self.resGlod
    local hasGlod = LuaEntry.Player.gold
    self.instantCostText:SetText(string.GetFormattedSeperatorNum(self.timeGlod + self.resGlod))
    if glod > hasGlod then
      self.instantCostText:SetColorRGBA(0.937, 0.329, 0.259, 1)
    else
      self.instantCostText:SetColorRGBA(1, 1, 1, 1)
    end
  end
end

function UISoldierUpLevelView:RefreshBtn(time)
  local resNoEnough = self.needList and #self.needList > 0
  local resHasCanSupplyItems = false
  if resNoEnough then
    for i, needResData in ipairs(self.needList) do
      local exist = LWResourceLackUtil:IsExistLackResourceIteminBag(needResData.resType)
      if exist then
        resHasCanSupplyItems = exist
        break
      end
    end
  end
  local canOpenNewCompleteImmidatelyResMatch = resNoEnough and resHasCanSupplyItems
  local hasSpeedItem = 0 < #self.instantinfo.speedUpitems
  local canOpenNewCompleteImmidatelySpeedMatch = hasSpeedItem
  self.timeGlod = 0
  self.resGlod = 0
  if canOpenNewCompleteImmidatelyResMatch or canOpenNewCompleteImmidatelySpeedMatch then
    self.instantIcon:LoadSprite(timeIconPath)
    self.instantCostText:SetText(UITimeManager:GetInstance():SecondToFmtString(math.ceil(time)))
  else
    self.instantIcon:LoadSprite(goldIconPath)
    self.timeGlod = CommonUtil.GetTimeDiamondCost(self.time)
    if #self.needList > 0 then
      local glodCount = 0
      local count
      for i, v in pairs(self.needList) do
        count = LuaEntry.Resource:GetCntByResType(v.resType)
        glodCount = CommonUtil.GetResGoldByType(v.resType, v.need - count)
        if glodCount then
          self.resGlod = self.resGlod + glodCount
        end
      end
    end
    self:RefreshGoldColor()
  end
end

function UISoldierUpLevelView:RefreshRes()
  self.needList = {}
  local hasIronCount = CommonUtil.GetResOrItemCount(ResourceType.Metal)
  local hasMoneyCount = CommonUtil.GetResOrItemCount(ResourceType.Food)
  if hasIronCount < self.iron then
    table.insert(self.needList, {
      resType = ResourceType.Metal,
      need = self.iron,
      count = self.iron - hasIronCount
    })
  end
  if hasMoneyCount < self.money then
    table.insert(self.needList, {
      resType = ResourceType.Food,
      need = self.money,
      count = self.money - hasMoneyCount
    })
  end
  self:SetTextBtnColor(hasIronCount < self.iron, self.ironCostCountText)
  self:SetTextBtnColor(hasMoneyCount < self.money, self.moneyCostCountText)
end

function UISoldierUpLevelView:SetTextBtnColor(isOn, text)
  if isOn then
    text:SetColorRGBA(0.937, 0.329, 0.259, 1)
  else
    text:SetColorRGBA(1, 1, 1, 1)
  end
end

function UISoldierUpLevelView:OnTrainBtnClick()
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.SoldierUpLevelClick, false)
  if self.count == 0 then
    return
  end
  local hasIronCount = CommonUtil.GetResOrItemCount(ResourceType.Metal)
  local hasMoneyCount = CommonUtil.GetResOrItemCount(ResourceType.Food)
  if hasMoneyCount < self.money or hasIronCount < self.iron then
    local data = {}
    if hasMoneyCount < self.money then
      table.insert(data, {
        resType = ResourceType.Food,
        need = self.money
      })
    end
    if hasIronCount < self.iron then
      table.insert(data, {
        resType = ResourceType.Metal,
        need = self.iron
      })
    end
    LWResourceLackUtil:GotoResLack(data)
    return
  end
  local curLevel = DataCenter.SoldierDataManager:GetSoldierLevelById(self.minSoldierId)
  local maxLevel = DataCenter.SoldierDataManager:GetSoldierLevelById(self.maxSoldierId)
  SFSNetwork.SendMessage(MsgDefines.BuildingCampTraining, self.buildData.uuid, 0, maxLevel, self.count, curLevel)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWMilitaryCampPanel)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UISoldierUpLevel)
end

function UISoldierUpLevelView:ComponentDestroy()
  self.minSoldierPanel = nil
  self.maxSoldierPanel = nil
  self.moneyCostCountText = nil
  self.ironCostCountText = nil
  self.closeBtn = nil
  self.addBtn = nil
  self.subtractBtn = nil
  self.slider = nil
  self.count_text = nil
  self.curTrainTimeText = nil
  self.trainBtnText = nil
  self.trainBtn = nil
end

function UISoldierUpLevelView:OnAddBtnClick()
  if self.slider.unity_uislider.value < self.slider.unity_uislider.maxValue then
    self.slider:SetValue(self.slider.unity_uislider.value + 1)
  end
end

function UISoldierUpLevelView:OnSubtractBtnClick()
  if self.slider.unity_uislider.value > self.slider.unity_uislider.minValue then
    self.slider:SetValue(self.slider.unity_uislider.value - 1)
  end
end

function UISoldierUpLevelView:ReInit(minData, maxData, bBuildData, mMaxCount)
  local minSoldierData, maxSoldierData, buildData, maxCount
  if minData and maxData and bBuildData then
    minSoldierData, maxSoldierData, buildData, maxCount = minData, maxData, bBuildData, mMaxCount
  else
    minSoldierData, maxSoldierData, buildData, maxCount = self:GetUserData()
  end
  if not (minSoldierData and maxSoldierData) or not buildData then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UISoldierUpLevel)
    return
  end
  local temp = DeepCopy(minSoldierData)
  if temp.outCount then
    temp.count = temp.count + temp.outCount or 0
  end
  self.minSoldierPanel:ReInit(temp)
  self.maxSoldierPanel:ReInit(maxSoldierData)
  self.slider.unity_uislider.maxValue = math.min(minSoldierData.count, maxCount)
  self.slider.unity_uislider.minValue = 0
  self:InitExpense(minSoldierData.id, maxSoldierData.id, buildData)
  self.buildData = buildData
  self.outSoliderText:SetText(minSoldierData.outCount and Localization:GetString("135218") .. " " .. string.GetFormattedStr(minSoldierData.outCount) or "")
  self.maxSoldierId = maxSoldierData.id
  self.minSoldierId = minSoldierData.id
  self.trainBtnText:SetLocalText(110150)
  self.titleText:SetLocalText(170499)
  self.instantCostText:SetColorRGBA(1, 1, 1, 1)
  self:ShowMaxCount(maxCount, minSoldierData.count)
  self:InitInstantBtn()
end

function UISoldierUpLevelView:ShowMaxCount(maxCount, soldierCount)
  local hasIronCount = CommonUtil.GetResOrItemCount(ResourceType.Metal)
  local hasMoneyCount = CommonUtil.GetResOrItemCount(ResourceType.Food)
  local ironCount = math.floor(hasIronCount / self.expenseCostIron)
  local moneyCount = math.floor(hasMoneyCount / self.expenseCostMoney)
  local count = math.min(ironCount, moneyCount)
  count = math.min(count, maxCount)
  soldierCount = soldierCount and soldierCount or 0
  count = math.min(soldierCount, count)
  self.slider:SetValue(count)
  self:OnCountSliderValueChanged(count)
end

function UISoldierUpLevelView:InitExpense(minId, maxId, buildData)
  local totalCostReduction = 0
  local totalReduceTrainSpeed = 0
  for k, v in pairs(buildData.assignedHeroList) do
    local workerData = DataCenter.WorkerDataManager:GetWorkerDataByUid(tonumber(v))
    if workerData ~= nil then
      totalCostReduction = totalCostReduction + Mathf.RoundTo(workerData:GetWorkerProperty(WorkerEffectDefine.TrainCostRate), 4)
      totalReduceTrainSpeed = totalReduceTrainSpeed + Mathf.RoundTo(workerData:GetWorkerProperty(WorkerEffectDefine.TrainTimeRate), 4)
    end
  end
  self.totalCostReduction = totalCostReduction + Mathf.RoundTo(LuaEntry.Effect:GetGameEffect(WorkerEffectDefine.TrainCostRate), 4)
  self.totalReduceTrainSpeed = totalReduceTrainSpeed + Mathf.RoundTo(LuaEntry.Effect:GetGameEffect(WorkerEffectDefine.TrainTimeRate), 4)
  local add = 1 - self.totalCostReduction
  local minSoldierTemp = DataCenter.SoldierDataManager:GetTemplate(minId)
  local maxSoldierTemp = DataCenter.SoldierDataManager:GetTemplate(maxId)
  local minPerSoldierCostIron = minSoldierTemp.trainCost[ResourceType.Metal] * add
  local minPerSoldierCostMoney = minSoldierTemp.trainCost[ResourceType.Food] * add
  local maxPerSoldierCostIron = maxSoldierTemp.trainCost[ResourceType.Metal] * add
  local maxPerSoldierCostMoney = maxSoldierTemp.trainCost[ResourceType.Food] * add
  local minPerCostTime = minSoldierTemp.trainTime / (1 + self.totalReduceTrainSpeed)
  local maxPerCostTime = maxSoldierTemp.trainTime / (1 + self.totalReduceTrainSpeed)
  self.perCostTime = maxPerCostTime - minPerCostTime
  self.expenseCostMoney = maxPerSoldierCostMoney - minPerSoldierCostMoney
  self.expenseCostIron = maxPerSoldierCostIron - minPerSoldierCostIron
end

function UISoldierUpLevelView:UnLockBuildingCampTrainingMsg()
  self.buildingCampTrainingMsgLock = false
end

return UISoldierUpLevelView
