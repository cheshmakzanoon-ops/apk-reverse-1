local UILWMilitaryCampPanelView = BaseClass("UILWMilitaryCampPanelView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UISelectSoldierItem = require("UI.UILWMilitaryCampPanel.Component.UISelectSoldierItem")
local UISoldierItem = require("UI/UIBuildDispatching/Component/UISoldierItem")
local UISoldierInfoTip = require("UI.UILWMilitaryCampPanel.Component.UISoldierInfoTip")
local goldIconPath = "Assets/Main/Sprites/UI/LWCommon/Sprite/Common_icon_gold.png"
local timeIconPath = "Assets/Main/Sprites/UI/LWCommon/Sprite/guaji_cfm_tubiao_2.png"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:OnOpen()
end

local function ClearScroll(self)
  self.soldierListContent:RemoveComponents(UISelectSoldierItem)
  self.soldierList:ClearAllItems()
end

local function OnDestroy(self)
  ClearScroll(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnTrainCountChange(self, newValue)
  if self.curTrainCount == newValue then
    return
  end
  self.curTrainCount = math.ceil(newValue)
  self.RefreshInfo(self, self.curTrainCount)
end

function UILWMilitaryCampPanelView:GetMiaCompleteState()
  if not self.curTrainCostTime then
    self.curTrainCostTime = 0
    Logger.LogError("curTrainCostTime = nil")
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local endTime = curTime + self.curTrainCostTime * 1000
  local speedUpitems, time = LWResourceLackUtil:GetSpeedUpGoods(endTime, ItemSpdMenu.ItemSpdMenu_Soldier)
  self.speedUpitems = speedUpitems
  if not self.completeImmdiatelyData.speedUpData then
    self.completeImmdiatelyData.speedUpData = {}
  end
  self.completeImmdiatelyData.speedUpData.speedUpItems = speedUpitems
  self.completeImmdiatelyData.speedUpData.speedUpDifferentTime = time
  self.completeImmdiatelyData.speedUpData.speedUpTotalTime = self.curTrainCostTime
  self.miaCompleteState = MiaCompleteState.ItemDeficiencyResDeficiency
  if time <= 0 then
    if 0 < #self.needList then
      self.miaCompleteState = MiaCompleteState.ItemAmpleResDeficiency
    else
      self.miaCompleteState = MiaCompleteState.ItemAmpleResAmple
    end
  elseif 0 < #self.needList then
    self.miaCompleteState = MiaCompleteState.ItemDeficiencyResDeficiency
  else
    self.miaCompleteState = MiaCompleteState.ItemDeficiencyResAmple
  end
end

function UILWMilitaryCampPanelView:OnInstantBtnClick()
  if self.buildingCampTrainingMsgLock then
    UIUtil.ShowTipsId(120289)
    return
  end
  if self.curTrainCostTime == 0 then
    return
  end
  if not self.instantIsUnlock then
    local template = DataCenter.LWFunctionUnlockManager:GetTemplate(LWFunctionUnlockType.SoliderInstantFinish)
    local buildData = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(template.needBuildingType)[1]
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIBuildUpgrade, buildData.uuid)
    self.ctrl.CloseSelf()
    return
  end
  self:GetMiaCompleteState()
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
  local hasSpeedItem = 0 < #self.speedUpitems
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
      SFSNetwork.SendMessage(MsgDefines.BuildingCampTraining, self.buildingUuid, 0, DataCenter.SoldierDataManager:GetSoldierLevelById(self.curTrainSoldierId), self.curTrainCount, nil, speedItems, data.timeGold, data.resGold)
      self.buildingCampTrainingMsgLock = true
    end
    
    UIManager:GetInstance():OpenWindow(UIWindowNames.CompleteImmdiatelyPanel, {anim = true}, self.completeImmdiatelyData)
  else
    local number = math.modf(LuaEntry.Effect:GetGameEffect(EffectDefine.LW_SOLDIER_MAX_STOCK))
    local playerNumber = DataCenter.SoldierDataManager:GetPlayerSoldiersTotalNum()
    local maxCount = number - playerNumber
    if maxCount >= self.curTrainCount then
      local glod = self.timeGlod + self.resGlod
      local hasGlod = LuaEntry.Player.gold
      if glod > hasGlod then
        local data = {}
        table.insert(data, {
          resType = ResourceType.Gold,
          need = glod
        })
        LWResourceLackUtil:GotoResLack(data)
      else
        local param = {
          contentText = Localization:GetString(GameDialogDefine.USE_GOLF_TIP_DES),
          btnNum = 2,
          confirmBtnParam = {
            action = function()
              SFSNetwork.SendMessage(MsgDefines.BuildingCampTraining, self.buildingUuid, 0, DataCenter.SoldierDataManager:GetSoldierLevelById(self.curTrainSoldierId), self.curTrainCount, nil, nil, self.timeGlod, self.resGlod)
              self.buildingCampTrainingMsgLock = true
            end
          }
        }
        UIUtil.TryShowDiamondConfirm(TodayNoSecondConfirmType.UpgradeUseDiamond, param)
      end
    else
      UIUtil.ShowTipsId(120083)
    end
  end
end

function UILWMilitaryCampPanelView:InitInstantBtn()
  self.instantIsUnlock = DataCenter.LWFunctionUnlockManager:CheckCanShow(LWFunctionUnlockType.SoliderInstantFinish)
  if self.instantIsUnlock then
    self.instantBtn:SetActive(true)
  else
    self.instantBtn:SetActive(false)
  end
end

function UILWMilitaryCampPanelView:RefreshInstantBtn()
  self:GetMiaCompleteState()
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
  local hasSpeedItem = 0 < #self.speedUpitems
  local canOpenNewCompleteImmidatelySpeedMatch = hasSpeedItem
  if canOpenNewCompleteImmidatelyResMatch or canOpenNewCompleteImmidatelySpeedMatch then
    self.instantIcon:LoadSprite(timeIconPath)
    self.instantCostText:SetText(UITimeManager:GetInstance():SecondToFmtString(self.curTrainCostTime))
    self.instantCostText:SetColorRGBA(1, 1, 1, 1)
  else
    if not self.curTrainCostTime then
      return
    end
    self.instantIcon:LoadSprite(goldIconPath)
    self.timeGlod = CommonUtil.GetTimeDiamondCost(self.curTrainCostTime)
    self.resGlod = 0
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
    self:RefreshGlod()
    self.instantCostText:SetText(string.GetFormattedSeperatorNum(self.timeGlod + self.resGlod))
  end
end

local function RefreshInfo(self, maxTrainCount)
  self.curTrainCount = maxTrainCount
  self.trainCountText:SetText(math.ceil(self.curTrainCount))
  self.curTrainCostTime = math.ceil(self.curTrainCount * self.perCostTime)
  self.RefreshTextColor(self)
  self.costIronCountText:SetText(string.GetFormattedStr(self.curTrainCostIron))
  self.costMoneyCountText:SetText(string.GetFormattedStr(self.curTrainCostMoney))
  self:GetMiaCompleteState()
  self:RefreshInstantBtn()
  self.trainBtnCostTimeText:SetText(UITimeManager:GetInstance():SecondToFmtString(self.curTrainCostTime))
end

local function RefreshTextColor(self)
  self.resAmple = false
  self.needList = {}
  self.hasIronCount = CommonUtil.GetResOrItemCount(ResourceType.Metal)
  self.hasMoneyCount = CommonUtil.GetResOrItemCount(ResourceType.Food)
  self.curTrainCostMoney = math.ceil(self.curTrainCount * self.perSoldierCostMoney)
  self.curTrainCostIron = math.ceil(self.curTrainCount * self.perSoldierCostIron)
  if self.curTrainCostIron > self.hasIronCount then
    self.costIronCountText:SetColorRGBA(0.937, 0.329, 0.259, 1)
    table.insert(self.needList, {
      resType = ResourceType.Metal,
      need = self.curTrainCostIron,
      count = self.curTrainCostIron - self.hasIronCount
    })
  else
    self.costIronCountText:SetColorRGBA(1, 1, 1, 1)
  end
  if self.curTrainCostMoney > self.hasMoneyCount then
    self.costMoneyCountText:SetColorRGBA(0.937, 0.329, 0.259, 1)
    table.insert(self.needList, {
      resType = ResourceType.Food,
      need = self.curTrainCostMoney,
      count = self.curTrainCostMoney - self.hasMoneyCount
    })
  else
    self.costMoneyCountText:SetColorRGBA(1, 1, 1, 1)
  end
  if self.hasIronCount > self.curTrainCostIron and self.hasMoneyCount > self.curTrainCostMoney then
    self.resAmple = true
  end
end

local function SelectSoldier(self, soldierId, soldierData)
  if self.curTrainSoldierId == soldierId then
    return
  end
  if self.curTrainSoldierId ~= nil then
    local lastSelectItem = self.soldierItems[self.curTrainSoldierId]
    if lastSelectItem ~= nil then
      lastSelectItem:SetSelected(false)
    end
  end
  self.curTrainSoldierId = soldierId
  local selectItem = self.soldierItems[soldierId]
  if selectItem ~= nil then
    selectItem:SetSelected(true)
  end
  self:RefreshUpLevelBtn(self.soldierItems[soldierId].soldierData.isUp)
  self.soldierInfoTip:Refresh(DataCenter.SoldierDataManager:GetTemplate(self.curTrainSoldierId))
  if not self.isTraining then
    local soldierTemplate = DataCenter.SoldierDataManager:GetTemplate(self.curTrainSoldierId)
    self.perSoldierCost = soldierTemplate.trainCost
    self.perSoldierCostIron = self.perSoldierCost[ResourceType.Metal] * (1 - self.totalCostReduction)
    self.perSoldierCostMoney = self.perSoldierCost[ResourceType.Food] * (1 - self.totalCostReduction)
    self.perCostTime = soldierTemplate.trainTime / (1 + self.totalReduceTrainSpeed)
    self.trainCountSlider:SetValue(self.maxTrainCount)
    self:RefreshInfo(self.maxTrainCount)
  end
  self:UpdateView()
  if self.soldierItems and self.soldierItems[soldierId] then
    self:OnClickLockSoldier(self.soldierItems[soldierId].soldierData)
  end
end

function UILWMilitaryCampPanelView:OnClickLockSoldier(soldierData)
  if soldierData == nil then
    return
  end
  local soldierd = DataCenter.SoldierDataManager:GetTemplate(soldierData.id)
  if soldierData.unlocked then
    self:CloseLockSoldierBg()
  else
    self:OpenLockSoldierBg(soldierd, true)
  end
end

function UILWMilitaryCampPanelView:OpenLockSoldierBg(soldierd)
  self.lockBg:SetActive(true)
  self.lockText:SetLocalText(130637, soldierd.train_need_barrack)
  if not string.IsNullOrEmpty(soldierd.train_need_science) then
    self.lockScienceText:SetActive(true)
    local scienceTempalte = DataCenter.ScienceManager:GetScienceTemplate(soldierd.train_need_science)
    if scienceTempalte then
      self.lockScienceText:SetLocalText(211244, Localization:GetString(scienceTempalte.name))
    end
  else
    self.lockScienceText:SetActive(false)
  end
  local isUnlockLevel = self.ctrl.GetIsUnloackByBuildLevel(soldierd, self.buildData.level)
  local isUnLoackScience = self.ctrl.GetIsUnLoackByScience(soldierd)
  self.btnLayout:SetActive(false)
  self.accelerateBtn:SetActive(false)
  self.upBtn:SetActive(not isUnlockLevel)
  self.goToScienceBtn:SetActive(not isUnLoackScience)
  self.lockText:SetColor(isUnlockLevel and MilitaryCampTrainArmyGreedColor or MilitaryCampTrainArmyGreyColor)
  self.lockScienceText:SetColor(isUnLoackScience and MilitaryCampTrainArmyGreedColor or MilitaryCampTrainArmyGreyColor)
  if T11Util.IsSuperSoldier(soldierd.lv) then
    self.lockText:SetLocalText("soldier_eleven_train_unlock_01", soldierd.train_need_barrack, soldierd.train_need_science)
    local color = isUnlockLevel and isUnLoackScience and MilitaryCampTrainArmyGreedColor or MilitaryCampTrainArmyGreyColor
    self.lockText:SetColor(color)
    self.lockScienceText:SetLocalText("soldier_eleven_train_unlock_02")
    local isUnlockBuff = self.ctrl.GetIsUnLockByBuff(soldierd)
    self.lockScienceText:SetColor(isUnlockBuff and MilitaryCampTrainArmyGreedColor or MilitaryCampTrainArmyGreyColor)
    self.upBtn:SetActive(not isUnlockLevel and not isUnLoackScience)
    self.goToScienceBtn:SetActive(not isUnlockBuff)
  end
  local unlockBtnText = T11Util.IsSuperSoldier(soldierd.lv) and "soldier_eleven_train_unlock_btn" or 211251
  self.goToScienceBtnText:SetLocalText(unlockBtnText)
end

function UILWMilitaryCampPanelView:CloseLockSoldierBg()
  self.lockBg:SetActive(false)
  if not self.isTraining then
    self.btnLayout:SetActive(true)
  end
  self.upBtn:SetActive(false)
  self.goToScienceBtn:SetActive(false)
end

local function OnClickSoldierItem(self, soldierData)
  if soldierData == nil then
    return
  end
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.TrainingClickSoldier, false)
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.SoldierClickEffect, false)
  local soldierId = soldierData.id
  SelectSoldier(self, soldierId, soldierData)
end

local function OnGetItemByIndex(self, loopScroll, index)
  index = index + 1
  if index < 1 or index > #self.soldierDataList then
    return nil
  end
  local soldierData = self.soldierDataList[index]
  local item = loopScroll:NewListViewItem("UISoldierItem")
  local script = self.soldierListContent:GetComponent(item.gameObject.name, UISelectSoldierItem)
  if script == nil then
    local objectName = tostring(self.itemIndex)
    self.itemIndex = self.itemIndex + 1
    item.gameObject.name = objectName
    if not item.IsInitHandlerCalled then
      item.IsInitHandlerCalled = true
    end
    script = self.soldierListContent:AddComponent(UISelectSoldierItem, objectName)
  end
  script:SetActive(true)
  local elevenData = T11Util.GetSelfCurSoldierData()
  script:SetDataWithCallBack(soldierData, elevenData, BindCallback(self, self.OnClickSoldierItem))
  if soldierData.outCount and soldierData.count then
    script:SetCountText(string.GetFormattedStr(soldierData.count + soldierData.outCount))
  end
  script:SetSelected(self.curTrainSoldierId == soldierData.id)
  if self.isTraining then
  else
  end
  self.soldierItems[soldierData.id] = script
  return item
end

local function GetSoldierDataById(self, id)
  if self.soldierDataList ~= nil then
    for k, v in pairs(self.soldierDataList) do
      if v.id == id then
        return v
      end
    end
  end
end

local function SetSoldierTtemInteractable(self, interactable)
  if self.soldierItems == nil then
    return
  end
  for _, v in pairs(self.soldierItems) do
    v:SetInteractable(interactable)
  end
end

local function OnClickIron(self)
  if self.hasIronCount < self.curTrainCostIron then
    local data = {}
    table.insert(data, {
      resType = ResourceType.Metal,
      need = self.curTrainCostIron
    })
    LWResourceLackUtil:GotoResLack(data)
  end
end

local function OnClickMoney(self)
  if self.hasMoneyCount < self.curTrainCostMoney then
    local data = {}
    table.insert(data, {
      resType = ResourceType.Food,
      need = self.curTrainCostMoney
    })
    LWResourceLackUtil:GotoResLack(data)
  end
end

local function ComponentDefine(self)
  self.btnClose = self:AddComponent(UIButton, "UICommonPopUpTitle/CloseBtn")
  self.btnClose:SetOnClick(BindCallback(self, self.OnBtnCloseClick))
  self.bgCloseBtn = self:AddComponent(UIButton, "UICommonPopUpTitle/panel")
  self.bgCloseBtn:SetOnClick(BindCallback(self, self.OnBtnCloseClick))
  self.textTitle = self:AddComponent(UIText, "UICommonPopUpTitle/Common_img_title/titleText")
  self.soldierInfoTip = self:AddComponent(UISoldierInfoTip, "Root/soldierInfoTip")
  self.trainContent = self:AddComponent(UIBaseContainer, "Root/TrainContent")
  self.trainCountSlider = self:AddComponent(UISlider, "Root/TrainContent/TrainCountSlider")
  self.trainCountSlider:SetOnValueChanged(function(value)
    self:OnTrainCountValueChanged(value)
  end)
  self.trainCountText = self:AddComponent(UIText, "Root/TrainContent/TrainCountGroup/TrainCountText")
  self.costIronCountText = self:AddComponent(UIText, "Root/TrainContent/CostResourceGroup/CostIron/IronCostCountText")
  self.costMoneyCountText = self:AddComponent(UIText, "Root/TrainContent/CostResourceGroup/CostMoney/MoneyCostCountText")
  self.upLevelBtn = self:AddComponent(UIButton, "Root/upLevelBtn")
  self.trainingContent = self:AddComponent(UIBaseContainer, "Root/TrainingCountContent")
  self.trainingCountSlider = self:AddComponent(UISlider, "Root/TrainingCountContent/TrainingCountSlider")
  self.trainingCountText = self:AddComponent(UIText, "Root/TrainingCountContent/TrainingCountText")
  self.trainingStateText = self:AddComponent(UIText, "Root/TrainingCountContent/TrainingStateText")
  self.trainingSoldierItem = self:AddComponent(UISoldierItem, "Root/TrainingCountContent/UISoldierItem")
  self.addBtn = self:AddComponent(UIButton, "Root/TrainContent/addBtn")
  self.subtractBtn = self:AddComponent(UIButton, "Root/TrainContent/subtractBtn")
  self.trainBtn = self:AddComponent(UIButton, "Root/btnLayout/TrainBtn")
  self.trainBtn:SetOnClick(BindCallback(self, self.OnTrainBtnClick))
  self.trainBtnText = self:AddComponent(UIText, "Root/btnLayout/TrainBtn/TrainBtnText")
  self.trainBtnCostTimeText = self:AddComponent(UIText, "Root/btnLayout/TrainBtn/TimeIcon/CostTimeText")
  self.upBtn = self:AddComponent(UIButton, "Root/LockHorLayout/UpBtn")
  self.upBtnText = self:AddComponent(UIText, "Root/LockHorLayout/UpBtn/UpBtnText")
  self.upBtn:SetOnClick(function()
    local data = DataCenter.SoldierDataManager:GetTemplate(self.curTrainSoldierId)
    local isUnlockLevel = self.ctrl.GetIsUnloackByBuildLevel(data, self.buildData.level)
    if not isUnlockLevel then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIBuildUpgrade, {
        anim = true,
        UIMainAnim = UIMainAnimType.AllHide
      }, self.buildingUuid, self.buildData.itemId)
      self:OnBtnCloseClick()
      return
    end
  end)
  self.upLevelBtn:SetOnClick(function()
    self:UpLevelBtnClick()
  end)
  self.soldierInfoBtn = self:AddComponent(UIButton, "Root/soldierInfoBtn")
  self.soldierInfoBtn:SetOnClick(function()
    self.soldierInfoTip:SetActive(true)
    self.soldierInfoTip:Refresh(DataCenter.SoldierDataManager:GetTemplate(self.curTrainSoldierId))
  end)
  self.addBtn:SetOnClick(function()
    self:OnAddBtnClick()
  end)
  self.subtractBtn:SetOnClick(function()
    self:OnSubtractBtnClick()
  end)
  self.accelerateBtn = self:AddComponent(UIButton, "Root/AccelerateBtn")
  self.accelerateBtn:SetOnClick(BindCallback(self, self.OnAccelerateBtnClick))
  self.accelerateBtnText = self:AddComponent(UIText, "Root/AccelerateBtn/AccelerateText")
  self.lockBg = self:AddComponent(UIBaseContainer, "Root/lockBg")
  self.lockText = self:AddComponent(UIText, "Root/lockBg/levelText")
  self.lockScienceText = self:AddComponent(UIText, "Root/lockBg/scienceText")
  self.soldierList = self:AddComponent(UILoopListView2, "Root/SoldierScrollBg/SoldierScroll")
  self.soldierList:InitListView(0, function(loopView, index)
    return OnGetItemByIndex(self, loopView, index)
  end)
  self.leftRedPoint = self:AddComponent(UIButton, "Root/SoldierScrollBg/LeftRedPoint")
  self.leftRedPoint:SetOnClick(BindCallback(self.OnClickLeftRedPoint, self))
  self.soldierScrollRect = self:AddComponent(UIScrollRect, "Root/SoldierScrollBg/SoldierScroll")
  self.soldierScrollRect:AddValueChangeListener(BindCallback(self.RefreshLeftRedPoint, self))
  self.soldierListContent = self:AddComponent(UIBaseContainer, "Root/SoldierScrollBg/SoldierScroll/Viewport/Content")
  self.costIronBtn = self:AddComponent(UIButton, "Root/TrainContent/CostResourceGroup/CostIron")
  self.costIronBtn:SetOnClick(BindCallback(self, OnClickIron))
  self.costMoneyBtn = self:AddComponent(UIButton, "Root/TrainContent/CostResourceGroup/CostMoney")
  self.costMoneyBtn:SetOnClick(BindCallback(self, OnClickMoney))
  self.btnLayout = self:AddComponent(UIBaseContainer, "Root/btnLayout")
  self.instantBtn = self:AddComponent(UIButton, "Root/btnLayout/instantBtn")
  self.instantUnLockText = self:AddComponent(UIText, "Root/btnLayout/instantBtn/unLockText")
  self.instantCostText = self:AddComponent(UIText, "Root/btnLayout/instantBtn/instantIcon/CostInstantText")
  self.instantIcon = self:AddComponent(UIImage, "Root/btnLayout/instantBtn/instantIcon")
  self.instantBtnText = self:AddComponent(UIText, "Root/btnLayout/instantBtn/instantBtnText")
  self.instantBtn:SetSafeClickMode(true)
  self.instantBtn:SetOnClick(function()
    self:OnInstantBtnClick()
  end)
  self.textTitle:SetLocalText(110281)
  self.trainBtnText:SetLocalText(110283)
  self.accelerateBtnText:SetLocalText(100159)
  self.upBtnText:SetLocalText(151038)
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.TrainingSoldiersView, false)
  self.goToScienceBtn = self:AddComponent(UIButton, "Root/LockHorLayout/GoToScienceBtn")
  self.goToScienceBtn:SetOnClick(function()
    local data = DataCenter.SoldierDataManager:GetTemplate(self.curTrainSoldierId)
    if T11Util.IsSuperSoldier(data.lv) then
      T11Util.GoToT11Building()
    else
      local scienceId
      if not string.IsNullOrEmpty(data.train_need_science) then
        scienceId = CommonUtil.GetScienceBaseType(tonumber(data.train_need_science))
      end
      local isUnLoackScience = self.ctrl.GetIsUnLoackByScience(data)
      if not isUnLoackScience then
        local data = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_SCIENE)
        if data == nil then
          GoToUtil.GotoBuildListByBuildId(BuildingTypes.FUN_BUILD_SCIENE)
        else
          GoToUtil.GotoScience(scienceId, nil, data.uuid)
        end
      end
    end
  end)
  self.goToScienceBtnText = self:AddComponent(UIText, "Root/LockHorLayout/GoToScienceBtn/GoToScienceBtnText")
  self.goToScienceBtnText:SetLocalText(211251)
end

function UILWMilitaryCampPanelView:TryShowArrow()
end

local function DataDefine(self)
  self.curTrainCount = 0
  self.perSoldierCostIron = 0
  self.perSoldierCostMoney = 0
  self.perCostTime = 0
  self.effectValue = 0
  self.maxTrainCount = 0
  self.soldierItems = {}
  self.itemIndex = 0
  self.hasInitListener = false
  self.resAmple = false
  self.buildingCampTrainingMsgLock = false
  self.completeImmdiatelyData = {}
end

local function ComponentDestroy(self)
  self.lockBg:SetActive(false)
  self.btnClose = nil
  self.bgCloseBtn = nil
  self.textTitle = nil
  self.emptyStateIcon = nil
  self.emptyStateText = nil
  self.trainContent = nil
  self.trainCountSlider = nil
  self.trainCountText = nil
  self.costIronCountText = nil
  self.costMoneyCountText = nil
  self.trainingContent = nil
  self.trainingCountSlider = nil
  self.trainingCountText = nil
  self.trainingStateText = nil
  self.trainingSoldierItem = nil
  self.trainBtn = nil
  self.trainBtnText = nil
  self.trainBtnCostTimeText = nil
  self.accelerateBtn = nil
  self.accelerateBtnText = nil
  self.soldierList = nil
  self.soldierListContent = nil
  self.resAmple = nil
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
end

local function DataDestroy(self)
  self.curTrainCount = nil
  self.perSoldierCostIron = nil
  self.perSoldierCostMoney = nil
  self.perCostTime = nil
  self.effectValue = nil
  self.maxTrainCount = nil
  self.buildData = nil
  self.buildLvTemplate = nil
  self.buildingUuid = nil
  self.soldierItems = nil
  self.itemIndex = 0
  self.hasInitListener = false
  self.totalTrainMaxAddition = nil
  self.totalCostReduction = nil
  self.buildingCampTrainingMsgLock = nil
  self.completeImmdiatelyData = nil
end

local function OnEnable(self)
  base.OnEnable(self)
  self.active = true
  self:TryShowArrow()
end

local function OnDisable(self)
  base.OnDisable(self)
  self.active = false
end

local function OnResourceChange(self)
  self.RefreshTextColor(self)
  self.RefreshInstantBtn(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.BuildingHeroDispatching, self.OnDataChange)
  self:AddUIListener(EventId.UPDATE_BUILD_DATA, self.OnDataChange)
  self:AddUIListener(EventId.ResourceUpdated, OnResourceChange)
  self:AddUIListener(EventId.InstantTrainingFinish, self.OnInstantFinish)
  self:AddUIListener(EventId.UpdateGold, self.RefreshGlod)
  self:AddUIListener(EventId.UnLockBuildingCampTrainingMsg, self.UnLockBuildingCampTrainingMsg)
  self.hasInitListener = true
end

local function OnRemoveListener(self)
  if self.hasInitListener then
    self:RemoveUIListener(EventId.BuildingHeroDispatching, self.OnDataChange)
    self:RemoveUIListener(EventId.UPDATE_BUILD_DATA, self.OnDataChange)
    self:RemoveUIListener(EventId.ResourceUpdated, OnResourceChange)
    self:RemoveUIListener(EventId.InstantTrainingFinish, self.OnInstantFinish)
    self:RemoveUIListener(EventId.UpdateGold, self.RefreshGlod)
    self:RemoveUIListener(EventId.UnLockBuildingCampTrainingMsg, self.UnLockBuildingCampTrainingMsg)
  end
  base.OnRemoveListener(self)
end

function UILWMilitaryCampPanelView:RefreshGlod()
  if self.timeGlod and self.resGlod then
    local glod = self.timeGlod + self.resGlod
    local hasGlod = LuaEntry.Player.gold
    if glod > hasGlod then
      self.instantCostText:SetColorRGBA(0.937, 0.329, 0.259, 1)
    else
      self.instantCostText:SetColorRGBA(1, 1, 1, 1)
    end
  end
end

local function UpdateSoldierList(self)
  self.soldierDataList, self.maxId, self.minId = self.ctrl:GetSoldierDataList(self.canTrainSoldierTypeList)
  if self.soldierDataList == nil or #self.soldierDataList == 0 then
    self.soldierList:SetActive(false)
    return
  end
  self.soldierList:SetActive(true)
  self.soldierList:SetListItemCount(#self.soldierDataList, false, false)
end

local function OnOpen(self)
  self.buildingUuid, self.jumpToParam = self:GetUserData()
  if self.buildingUuid == nil then
    self:OnBtnCloseClick()
  end
  self.buildData = DataCenter.BuildManager:GetBuildingDataByUuid(self.buildingUuid)
  self.buildLvTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(self.buildData.itemId, self.buildData.level)
  if self.buildData == nil or self.buildLvTemplate == nil then
    self:OnBtnCloseClick()
  end
  self.maxTrainCount = tonumber(self.buildLvTemplate.para1)
  local totalTrainMaxAddition = 0
  local totalCostReduction = 0
  local totalReduceTrainSpeed = 0
  local totalTrainMaxNum = 0
  for k, v in pairs(self.buildData.assignedHeroList) do
    local workerData = DataCenter.WorkerDataManager:GetWorkerDataByUid(tonumber(v))
    if workerData ~= nil then
      totalTrainMaxAddition = totalTrainMaxAddition + Mathf.RoundTo(workerData:GetWorkerProperty(WorkerEffectDefine.TrainLimitRate), 4)
      totalCostReduction = totalCostReduction + Mathf.RoundTo(workerData:GetWorkerProperty(WorkerEffectDefine.TrainCostRate), 4)
      totalReduceTrainSpeed = totalReduceTrainSpeed + Mathf.RoundTo(workerData:GetWorkerProperty(WorkerEffectDefine.TrainTimeRate), 4)
      totalTrainMaxNum = totalTrainMaxNum + workerData:GetWorkerProperty(WorkerEffectDefine.TrainLimitNum)
    end
  end
  totalTrainMaxAddition = totalTrainMaxAddition + Mathf.RoundTo(LuaEntry.Effect:GetGameEffect(WorkerEffectDefine.TrainLimitRate), 4)
  totalCostReduction = totalCostReduction + Mathf.RoundTo(LuaEntry.Effect:GetGameEffect(WorkerEffectDefine.TrainCostRate), 4)
  totalReduceTrainSpeed = totalReduceTrainSpeed + Mathf.RoundTo(LuaEntry.Effect:GetGameEffect(WorkerEffectDefine.TrainTimeRate), 4)
  self.totalTrainMaxAddition = totalTrainMaxAddition
  self.totalCostReduction = totalCostReduction
  self.totalReduceTrainSpeed = totalReduceTrainSpeed
  self.maxTrainCount = math.floor((self.maxTrainCount + totalTrainMaxNum) * (1 + totalTrainMaxAddition))
  self.trainCountSlider.unity_uislider.maxValue = self.maxTrainCount
  self.trainCountSlider.unity_uislider.minValue = 0
  self.canTrainSoldierTypeList = self.ctrl.GetUnloackSoldier(self.buildData.level)
  local maxCanTrainSoldierId = tonumber(self.canTrainSoldierTypeList[#self.canTrainSoldierTypeList])
  self.hasIronCount = CommonUtil.GetResOrItemCount(ResourceType.Metal)
  self.hasMoneyCount = CommonUtil.GetResOrItemCount(ResourceType.Food)
  UpdateSoldierList(self)
  self.isTraining = BuildingUtils.IsBuildingFunctioning(self.buildData)
  self.finishTrain = BuildingUtils.IsBuildingFinishFunctioning(self.buildData)
  if self.isTraining and self.finishTrain then
    self:OnBtnCloseClick()
    return
  end
  self.trainingId = DataCenter.SoldierDataManager:GetSoldierIdByLevel(self.buildData.prodStatus)
  local selectSoldierId
  if self.isTraining then
    selectSoldierId = self.trainingId
  elseif self.jumpToParam then
    selectSoldierId = self.jumpToParam.soldierId
  else
    selectSoldierId = self.maxId
  end
  local index = 1
  if self.soldierDataList ~= nil then
    for k, v in pairs(self.soldierDataList) do
      if v.id == selectSoldierId then
        index = k
        break
      end
    end
  end
  self.soldierList:MovePanelToItemIndex(index - 1, 0)
  SelectSoldier(self, selectSoldierId)
  self:InitInstantBtn()
  self:RefreshLeftRedPoint()
  if self.jumpToParam then
    if self.jumpToParam.openSoldierUpLevelPanel then
      self:UpLevelBtnClick()
    else
      UIUtil.ShowTipsId("barrack_tips_busyTrylater_01")
    end
  end
end

function UILWMilitaryCampPanelView:OnAddBtnClick()
  if self.trainCountSlider.unity_uislider.value < self.trainCountSlider.unity_uislider.maxValue then
    self.trainCountSlider:SetValue(self.trainCountSlider.unity_uislider.value + 1)
  end
end

function UILWMilitaryCampPanelView:OnSubtractBtnClick()
  if self.trainCountSlider.unity_uislider.value > self.trainCountSlider.unity_uislider.minValue then
    self.trainCountSlider:SetValue(self.trainCountSlider.unity_uislider.value - 1)
  end
end

function UILWMilitaryCampPanelView:GetSoldierData(id)
  if self.soldierDataList ~= nil then
    for __, v in pairs(self.soldierDataList) do
      if v ~= nil and v.id == id then
        return v
      end
    end
  end
end

function UILWMilitaryCampPanelView:OnInstantFinish()
  self.soldierDataList, self.maxId, self.minId = self.ctrl:GetSoldierDataList(self.canTrainSoldierTypeList)
  self:RefreshInfo(self.curTrainCount)
  local selectItem = self.soldierItems[self.curTrainSoldierId]
  if selectItem ~= nil then
    selectItem:SetSelected(true)
    local data = self:GetSoldierData(self.curTrainSoldierId)
    if data then
      local elevenData = T11Util.GetSelfCurSoldierData()
      selectItem:SetDataWithCallBack(data, elevenData, BindCallback(self, self.OnClickSoldierItem))
      if data.outCount and data.count then
        selectItem:SetCountText(string.GetFormattedStr(data.count + data.outCount))
      end
      local curSoldierIndex = 0
      for index, value in ipairs(self.soldierDataList) do
        if self.curTrainSoldierId == value.id then
          curSoldierIndex = index
          break
        end
      end
      local nextData = self.soldierDataList[curSoldierIndex + 1]
      local nextSelectItem
      if nextData then
        nextSelectItem = self.soldierItems[nextData.id]
      end
      if nextSelectItem then
        nextSelectItem:SetDataWithCallBack(nextData, elevenData, BindCallback(self, self.OnClickSoldierItem))
      end
    end
    self:RefreshUpLevelBtn(selectItem.soldierData.isUp)
  end
  local minSolderData = GetSoldierDataById(self, self.curTrainSoldierId)
  local maxSolderData = GetSoldierDataById(self, self.maxId)
  if minSolderData.count == 0 or not minSolderData.count then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UISoldierUpLevel)
    return
  end
  local data = {}
  data.minData = minSolderData
  data.maxData = maxSolderData
  data.buildData = self.buildData
  data.maxCount = self.maxTrainCount
  EventManager:GetInstance():Broadcast(EventId.InstantUpgradeDataUpdate, data)
end

local function UpdateView(self)
  self.isTraining = BuildingUtils.IsBuildingFunctioning(self.buildData)
  self.finishTrain = BuildingUtils.IsBuildingFinishFunctioning(self.buildData)
  if self.isTraining and self.finishTrain then
    self:OnBtnCloseClick()
    return
  end
  self.hasWorker = true
  if self.isTraining then
    self.trainContent.gameObject:SetActive(false)
    self.trainingContent.gameObject:SetActive(true)
    self.btnLayout:SetActive(false)
    self.accelerateBtn:SetActive(true)
    if self.hasWorker then
      self.trainingStateText:SetColorRGBA(0.239, 0.239, 0.239, 1)
      if self.updateTimer == nil then
        self.updateTimer = TimerManager:GetInstance():GetTimer(1, self.UpdateTrainingRemainTime, self, false, false, false)
        self.updateTimer:Start()
        self:UpdateTrainingRemainTime()
      end
    else
      self.trainingStateText:SetColorRGBA(0.937, 0.329, 0.259, 1)
      if self.updateTimer ~= nil then
        self.updateTimer:Stop()
        self.updateTimer = nil
      end
      self:UpdateTrainingRemainTime()
    end
    local soldierData
    if self.soldierDataList ~= nil then
      for __, v in pairs(self.soldierDataList) do
        if v ~= nil and v.id == self.curTrainSoldierId then
          soldierData = v
          break
        end
      end
    end
    if soldierData ~= nil and soldierData.id == self.trainingId then
      local elevenData = T11Util.GetSelfCurSoldierData()
      self.trainingSoldierItem:SetData(soldierData, elevenData)
      self.trainingSoldierItem:SetCountTextVisible(false)
      self.lockBg:SetActive(false)
    elseif not soldierData.unlocked then
      self.lockBg:SetActive(true)
    end
  else
    self.trainContent.gameObject:SetActive(true)
    self.trainingContent.gameObject:SetActive(false)
    self.btnLayout:SetActive(true)
    self.accelerateBtn:SetActive(false)
    if self.updateTimer ~= nil then
      self.updateTimer:Stop()
      self.updateTimer = nil
    end
  end
end

local function OnDataChange(self)
  self.isTraining = BuildingUtils.IsBuildingFunctioning(self.buildData)
  self:UpdateView()
end

local function OnBtnCloseClick(self)
  self.ctrl.CloseSelf()
end

local function OnTrainCountValueChanged(self, value)
  OnTrainCountChange(self, value)
end

local function UpdateTrainingRemainTime(self)
  if self.buildData == nil then
    return
  end
  if self.isTraining and not self.finishTrain then
    self.trainingCountText:SetText(BuildingUtils.GetBuildingPredictedProduceCount(self.buildData))
    if self.hasWorker then
      self.trainingStateText:SetLocalText(110284, UITimeManager:GetInstance():MilliSecondToFmtString(BuildingUtils.GetBuildingFunctioningRemainTime(self.buildData)))
    else
      self.trainingStateText:SetLocalText(110286, UITimeManager:GetInstance():MilliSecondToFmtString(BuildingUtils.GetBuildingFunctioningRemainTime(self.buildData)))
    end
    self.trainingCountSlider:SetValue(BuildingUtils.GetBuildilngFunctioningProgress(self.buildData))
  elseif self.finishTrain then
    self:OnBtnCloseClick()
    return
  end
  if self.buildData ~= nil then
    self.isTraining = BuildingUtils.IsBuildingFunctioning(self.buildData) and not BuildingUtils.IsBuildingFinishFunctioning(self.buildData)
    self.finishTrain = BuildingUtils.IsBuildingFinishFunctioning(self.buildData)
  end
end

function UILWMilitaryCampPanelView:GotoResLack()
  local haveMetalCount = LuaEntry.Resource:GetCntByResType(ResourceType.Metal)
  local haveFoodCount = LuaEntry.Resource:GetCntByResType(ResourceType.Food)
  if haveMetalCount < self.curTrainCostIron or haveFoodCount < self.curTrainCostMoney then
    local data = {}
    if haveFoodCount < self.curTrainCostMoney then
      table.insert(data, {
        resType = ResourceType.Food,
        need = self.curTrainCostMoney
      })
    end
    if haveMetalCount < self.curTrainCostIron then
      table.insert(data, {
        resType = ResourceType.Metal,
        need = self.curTrainCostIron
      })
    end
    LWResourceLackUtil:GotoResLack(data)
    return true
  end
end

local function OnTrainBtnClick(self)
  if self.curTrainCount <= 0 then
    return
  end
  if self:GotoResLack() then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.BuildingCampTraining, self.buildingUuid, 0, DataCenter.SoldierDataManager:GetSoldierLevelById(self.curTrainSoldierId), self.curTrainCount)
  self:OnBtnCloseClick()
end

local function OnAccelerateBtnClick(self)
  if self.isTraining then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UISpeed, ItemSpdMenu.ItemSpdMenu_Soldier, self.buildingUuid)
  end
end

local function RefreshLeftRedPoint(self)
  local leftIndex = -1
  for index, value in ipairs(self.soldierDataList) do
    if value.isUp then
      leftIndex = index
      break
    end
  end
  if leftIndex == -1 then
    self.leftRedPoint:SetActive(false)
  else
    local inViewLeftIndex = leftIndex
    local leftPos = math.huge
    for i = 1, #self.soldierDataList do
      local item = self.soldierList:GetShownItemByItemIndex(i - 1)
      if item then
        local pos = self.soldierList:GetItemCornerPosInViewPort(item)
        if pos.x > 0 and leftPos > pos.x then
          leftPos = pos.x
          inViewLeftIndex = i
        end
      end
    end
    self.leftRedPoint:SetActive(leftIndex < inViewLeftIndex)
  end
end

local function OnClickLeftRedPoint(self)
  local leftIndex = -1
  local selectSoldierId
  for index, value in ipairs(self.soldierDataList) do
    if value.isUp then
      leftIndex = index
      selectSoldierId = value.id
      break
    end
  end
  if leftIndex == -1 then
    self.leftRedPoint:SetActive(false)
  else
    self.soldierList:MovePanelToItemIndex(leftIndex - 1, 0)
    SelectSoldier(self, selectSoldierId)
  end
end

local function RefreshUpLevelBtn(self, isUp)
  if self.isTraining then
    self.upLevelBtn:SetActive(false)
  else
    local showBtn = false
    local soldierIndex = 0
    for index, value in ipairs(self.soldierDataList) do
      if self.curTrainSoldierId == value.id then
        soldierIndex = index
        break
      end
    end
    if soldierIndex <= 8 then
      showBtn = true
    elseif soldierIndex == 9 then
      local hasScience = DataCenter.ScienceManager:HasScienceByIdAndLevel(120011100, 1)
      if hasScience then
        showBtn = true
      end
    elseif soldierIndex == 10 then
      local hasUnlocked = T11Util.IsUnlockT11()
      local show = T11Util.IfShowT11InCamp()
      if hasUnlocked and show then
        showBtn = true
      end
    end
    showBtn = showBtn and self.soldierDataList[soldierIndex].unlocked == true
    self.upLevelBtn:SetActive(showBtn)
    if showBtn then
      local nextData = self.soldierDataList[soldierIndex + 1]
      local nextSoldierLock = true
      if nextData then
        nextSoldierLock = not self.soldierDataList[soldierIndex + 1].unlocked
      end
      local selectSoldierNoHave = self.soldierDataList[soldierIndex].count == nil
      CS.UIGray.SetGray(self.upLevelBtn.transform, nextSoldierLock or selectSoldierNoHave, true)
    end
  end
end

local function UnLockBuildingCampTrainingMsg(self)
  self.buildingCampTrainingMsgLock = false
end

local function UpLevelBtnClick(self)
  local minSolderData = GetSoldierDataById(self, self.curTrainSoldierId)
  local maxSolderData = GetSoldierDataById(self, self.maxId)
  local soldierIndex = 0
  for index, value in ipairs(self.soldierDataList) do
    if self.curTrainSoldierId == value.id then
      soldierIndex = index
      break
    end
  end
  local nextData = self.soldierDataList[soldierIndex + 1]
  if nextData == nil then
    Logger.LogInfo("UILWMilitaryCampPanelView error soldierIndex: " .. soldierIndex)
    return
  end
  local nextSoldierLock = not nextData.unlocked
  if nextSoldierLock then
    local soldierd = DataCenter.SoldierDataManager:GetTemplate(nextData.id)
    UIUtil.ShowTips(Localization:GetString("camp_tips_01", soldierd.train_need_barrack, tostring(soldierd.lv)))
    return
  end
  local selectSoldierNoHave = minSolderData.count == nil
  if selectSoldierNoHave then
    UIUtil.ShowTipsId("camp_tips_02")
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UISoldierUpLevel, {anim = true}, minSolderData, maxSolderData, self.buildData, self.maxTrainCount)
end

UILWMilitaryCampPanelView.OnCreate = OnCreate
UILWMilitaryCampPanelView.OnDestroy = OnDestroy
UILWMilitaryCampPanelView.OnEnable = OnEnable
UILWMilitaryCampPanelView.OnDisable = OnDisable
UILWMilitaryCampPanelView.OnAddListener = OnAddListener
UILWMilitaryCampPanelView.OnRemoveListener = OnRemoveListener
UILWMilitaryCampPanelView.ComponentDefine = ComponentDefine
UILWMilitaryCampPanelView.DataDefine = DataDefine
UILWMilitaryCampPanelView.ComponentDestroy = ComponentDestroy
UILWMilitaryCampPanelView.DataDestroy = DataDestroy
UILWMilitaryCampPanelView.OnOpen = OnOpen
UILWMilitaryCampPanelView.OnBtnCloseClick = OnBtnCloseClick
UILWMilitaryCampPanelView.UpdateView = UpdateView
UILWMilitaryCampPanelView.OnTrainCountValueChanged = OnTrainCountValueChanged
UILWMilitaryCampPanelView.OnTrainBtnClick = OnTrainBtnClick
UILWMilitaryCampPanelView.OnAccelerateBtnClick = OnAccelerateBtnClick
UILWMilitaryCampPanelView.UpdateTrainingRemainTime = UpdateTrainingRemainTime
UILWMilitaryCampPanelView.OnClickSoldierItem = OnClickSoldierItem
UILWMilitaryCampPanelView.OnDataChange = OnDataChange
UILWMilitaryCampPanelView.OnTrainCountChange = OnTrainCountChange
UILWMilitaryCampPanelView.RefreshTextColor = RefreshTextColor
UILWMilitaryCampPanelView.RefreshInfo = RefreshInfo
UILWMilitaryCampPanelView.RefreshLeftRedPoint = RefreshLeftRedPoint
UILWMilitaryCampPanelView.OnClickLeftRedPoint = OnClickLeftRedPoint
UILWMilitaryCampPanelView.RefreshUpLevelBtn = RefreshUpLevelBtn
UILWMilitaryCampPanelView.UnLockBuildingCampTrainingMsg = UnLockBuildingCampTrainingMsg
UILWMilitaryCampPanelView.UpLevelBtnClick = UpLevelBtnClick
return UILWMilitaryCampPanelView
