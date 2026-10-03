local LWUIHospitalView = BaseClass("LWUIHospitalView", UIBaseView)
local HospitalSoldierCell = require("UI.LWUIHospital.Component.HospitalSoldierCell")
local UINeedResCell = require("UI.UIBuildUpgrade.Component.UINeedResCell")
local base = UIBaseView
local redImgPath = "Assets/Main/Sprites/UI/LWAllianceZone/Textures/zyf_chengchixinxi_hongse_jindutiao.png"
local greenImgpath = "Assets/Main/Sprites/UI/LWAllianceZone/Textures/lyp_tongmeng_jindutiao_2.png"
local goldIconPath = "Assets/Main/Sprites/UI/LWCommon/Sprite/Common_icon_gold.png"
local timeIconPath = "Assets/Main/Sprites/UI/LWCommon/Sprite/guaji_cfm_tubiao_2.png"
local UIGray = CS.UIGray
local HospitalManager = DataCenter.HospitalManager
local Localization = CS.GameEntry.Localization
local Setting = CS.GameEntry.Setting
local SettingKeys = _ENV.SettingKeys
local bg_path = "Root/BG"
local image_path = "Root/Image"
local world_node_path = "Root/worldNode"
local viewport_path = "Root/ScrollView/Viewport"
local content_path = "Root/ScrollView/Viewport/Content"
local desert_battle_tips_btn_path = "Root/worldNode/DesertBattleTipsBtn"
local speed_up_btn_path = "UICommonPopUpTitle/btnLayout/SpeedUpBtn"
local speed_up_btn_text_path = "UICommonPopUpTitle/btnLayout/SpeedUpBtn/SpeedUpBtnText"
local treating_content_path = "Root/TreatingContent"
local treating_time_slider_path = "Root/TreatingContent/cfm_tongyong_erji_dichen_1/TreatingTimeSlider"
local treating_time_text_path = "Root/TreatingContent/cfm_tongyong_erji_dichen_1/TreatingTimeText"
local treating_num_text_path = "Root/TreatingContent/cfm_tongyong_erji_dichen_1/TreatingNumText"
local receive_btn_path = "UICommonPopUpTitle/btnLayout/ReceiveBtn"
local receive_btn_text_path = "UICommonPopUpTitle/btnLayout/ReceiveBtn/ReceiveBtnText"

function LWUIHospitalView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function LWUIHospitalView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function LWUIHospitalView:ComponentDefine()
  self.close_btn = self:AddComponent(UIButton, "UICommonPopUpTitle/CloseBtn")
  self.title_text = self:AddComponent(UIText, "UICommonPopUpTitle/Common_img_title/titleText")
  self.count_slider = self:AddComponent(UISlider, "Root/BG/Slider")
  self.countSliderImg = self:AddComponent(UIImage, "Root/BG/Slider/FillArea/Fill")
  self.soldiers_scrollView = self:AddComponent(UIScrollView, "Root/ScrollView")
  self.countText = self:AddComponent(UIText, "Root/BG/count")
  self.countNameText = self:AddComponent(UIText, "Root/BG/countName")
  self.panelBtn = self:AddComponent(UIButton, "UICommonPopUpTitle/panel")
  self.rootLayout = self:AddComponent(UIBaseContainer, "Root")
  self.viewport = self:AddComponent(UIImage, viewport_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.timeBtn = self:AddComponent(UIButton, "UICommonPopUpTitle/btnLayout/timeBtn")
  self.timeBtnTime = self:AddComponent(UIText, "UICommonPopUpTitle/btnLayout/timeBtn/TimeIcon/timeText")
  self.timeBtnTitilText = self:AddComponent(UIText, "UICommonPopUpTitle/btnLayout/timeBtn/btnText")
  self.metalResourceCell = self:AddComponent(UINeedResCell, "Root/ItemLayout/cerealNeedResourceCell")
  self.ItemLayout = self:AddComponent(UIBaseContainer, "Root/ItemLayout")
  self.foodResourceCell = self:AddComponent(UINeedResCell, "Root/ItemLayout/oreNeedResourceCell")
  self.instantBtn = self:AddComponent(UIButton, "UICommonPopUpTitle/btnLayout/instantBtn")
  self.instantUnLockText = self:AddComponent(UIText, "UICommonPopUpTitle/btnLayout/instantBtn/unLockText")
  self.instantCostText = self:AddComponent(UIText, "UICommonPopUpTitle/btnLayout/instantBtn/instantIcon/CostInstantText")
  self.instantIcon = self:AddComponent(UIImage, "UICommonPopUpTitle/btnLayout/instantBtn/instantIcon")
  self.instantBtnText = self:AddComponent(UIText, "UICommonPopUpTitle/btnLayout/instantBtn/instantBtnText")
  self.viewText = self:AddComponent(UIText, "Root/viewText")
  self.tipBtn = self:AddComponent(UIButton, "Root/tipBtn")
  self.soldiers_scrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreateCell(itemObj, index)
  end)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.tipBtn:SetOnClick(BindCallback(self, self.OnTipsBtnClick))
  self.timeBtn:SetOnClick(function()
    self:OnTimeBtnClick()
  end)
  self.instantBtn:SetOnClick(function()
    self:OnInstantBtnClick()
  end)
  self.panelBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.soldiers_scrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeleteCell(itemObj, index)
  end)
  self.resType = false
  self.bg = self:AddComponent(UIBaseContainer, bg_path)
  self.image = self:AddComponent(UIImage, image_path)
  self.world_node = self:AddComponent(UIBaseContainer, world_node_path)
  self.desert_battle_tips_btn = self:AddComponent(UIButton, desert_battle_tips_btn_path)
  self.desert_battle_tips_btn:SetOnClick(function()
    UIUtil.ShowTipsId("Desert_strom_tips1022")
  end)
  self.speed_up_btn = self:AddComponent(UIButton, speed_up_btn_path)
  self.speed_up_btn:SetOnClick(function()
    self:SpeedUpBtnClick()
  end)
  self.speed_up_btn_text = self:AddComponent(UITextMeshProUGUIEx, speed_up_btn_text_path)
  self.speed_up_btn_text:SetLocalText(129003)
  self.treating_content = self:AddComponent(UIBaseContainer, treating_content_path)
  self.treating_time_slider = self:AddComponent(UISlider, treating_time_slider_path)
  self.treating_time_text = self:AddComponent(UITextMeshProUGUIEx, treating_time_text_path)
  self.treating_num_text = self:AddComponent(UITextMeshProUGUIEx, treating_num_text_path)
  local worldId = LuaEntry.Player:GetCurWorldId()
  self.bg:SetActive(worldId == 0)
  self.image:SetActive(worldId == 0)
  self.ItemLayout:SetActive(worldId == 0)
  self.world_node:SetActive(0 < worldId)
  self.tipBtn:SetActive(worldId == 0)
  if 0 < worldId then
    SFSNetwork.SendMessage(MsgDefines.DragonHospitalInfo)
    
    function self.TimerAction()
      SFSNetwork.SendMessage(MsgDefines.DragonHospitalInfo)
    end
    
    local unitTime = DataCenter.DragonBuildTemplateManager:GetItemValue("k14")
    self.timer = TimerManager:GetInstance():GetTimer(unitTime, self.TimerAction, self, false, false, false)
    self.timer:Start()
  end
  self.receive_btn = self:AddComponent(UIButton, receive_btn_path)
  self.receive_btn:SetOnClick(function()
    self:ReceiveBtnClick()
  end)
  self.receive_btn_text = self:AddComponent(UITextMeshProUGUIEx, receive_btn_text_path)
  self.receive_btn_text:SetLocalText(110107)
end

function LWUIHospitalView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ResourceUpdated, self.RefreshResCell)
  self:AddUIListener(EventId.InstantCureFinish, self.OnInstantCureFinish)
  self:AddUIListener(EventId.UpdateGold, self.RefreshGlod)
  self:AddUIListener(EventId.HospitalUpdate, self.OnHospitalUpdate)
  self:AddUIListener(EventId.UnLockHospitalCureMsg, self.UnLockHospitalCureMsg)
  self:AddUIListener(EventId.AddSpeedSuccess, self.OnAddSpeedUpSuccess)
end

function LWUIHospitalView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.ResourceUpdated, self.RefreshResCell)
  self:RemoveUIListener(EventId.InstantCureFinish, self.OnInstantCureFinish)
  self:RemoveUIListener(EventId.UpdateGold, self.RefreshGlod)
  self:RemoveUIListener(EventId.HospitalUpdate, self.OnHospitalUpdate)
  self:RemoveUIListener(EventId.UnLockHospitalCureMsg, self.UnLockHospitalCureMsg)
  self:RemoveUIListener(EventId.AddSpeedSuccess, self.OnAddSpeedUpSuccess)
end

function LWUIHospitalView:OnAddSpeedUpSuccess(queueType)
  if (queueType == NewQueueType.Hospital or queueType == NewQueueType.DragonHospital) and self.isTreating and self.treatingQueue then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local remainTime = self.treatingQueue.endTime - curTime
    if remainTime <= 0 then
      self.ctrl:CloseSelf()
    end
  end
end

function LWUIHospitalView:OnInstantCureFinish()
  self:RefreshView()
  self:ShowScroll()
  self:InitInstantBtn()
end

function LWUIHospitalView:OnHospitalUpdate()
  local worldId = LuaEntry.Player:GetCurWorldId()
  if 0 <= worldId then
    self:RefreshIsTreatingState()
    self:RefreshView()
    self:ShowScroll()
    self:InitInstantBtn()
  end
end

function LWUIHospitalView:ReInit()
  local uuId = self:GetUserData()
  if uuId then
    DataCenter.HospitalManager:SetCurHospitalBuildUuid(uuId)
  end
  if LuaEntry.Player.VirusLayer > 0 then
    SFSNetwork.SendMessage(MsgDefines.GetVirusHospitalSync)
  end
  self:RefreshIsTreatingState()
  self:RefreshView()
  self:ShowScroll()
  self:InitInstantBtn()
end

function LWUIHospitalView:Update1000MS()
  if self.isTreating then
    self:UpdateTrainingRemainTime()
  end
  if SeasonUtil.IsInSeasonSnowMode() then
    self:ChangeExpenditure()
  end
end

function LWUIHospitalView:OnInstantBtnClick()
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
    self.ctrl:CloseSelf()
    return
  end
  self:RefreshState(self.time)
  local resNoEnough = self.resList and 0 < #self.resList
  local resHasCanSupplyItems = false
  if resNoEnough then
    for i, needResData in ipairs(self.resList) do
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
    for i, needResData in ipairs(self.resList) do
      local resLackData = {}
      resLackData.resType = needResData.resType
      resLackData.totalNeedCount = needResData.need
      table.insert(self.completeImmdiatelyData.resLackDatas, resLackData)
    end
    local soldierList = DeepCopy(self.soldierList)
    local expenditureDic = DeepCopy(self.expenditureDic)
    local completeImmediatelyData = DeepCopy(self.completeImmdiatelyData)
    
    function completeImmediatelyData.OnClickImmediately(data)
      self:SendMessage(soldierList, IsGold.NoUseGold, data.speedUpItems, data.timeGold, data.resGold)
      if self.ctrl ~= nil then
        self.ctrl:CloseSelf()
      end
    end
    
    function completeImmediatelyData.CheckBeforeClickImmediately(data)
      if not BattleFieldUtil.InBattleField() then
        local isSpill = self.ctrl.GetSoldiersIsSpill(soldierList)
        if not isSpill then
          UIUtil.ShowTipsId(120083)
          return false
        end
      end
      local isDeadSoldierEnough = self.ctrl:IsDeadSoldierEnough(soldierList)
      if not isDeadSoldierEnough then
        Logger.LogInfo("LWUIHospitalView log: dead soldier not enough")
        return false
      end
      if not self.ctrl:CheckCompleteImmediateResourceIsEnough(expenditureDic, data) then
        UIUtil.ShowTipsId("hospital_cure_resource_change_tips_1")
        return false
      end
      return true
    end
    
    UIManager:GetInstance():OpenWindow(UIWindowNames.CompleteImmdiatelyPanel, {anim = true}, completeImmediatelyData)
  else
    local soldierList = DeepCopy(self.soldierList)
    local expenditureDic = DeepCopy(self.expenditureDic)
    local timeGold = self.timeGlod
    local resGold = self.resGlod
    local gold = timeGold + resGold
    local hasGold = LuaEntry.Player.gold
    if gold > hasGold then
      LWResourceLackUtil:GotoResLack({
        {
          resType = ResourceType.Gold,
          need = gold
        }
      })
    else
      do
        local param = {
          contentText = Localization:GetString(GameDialogDefine.USE_GOLF_TIP_DES),
          btnNum = 2,
          confirmBtnParam = {
            action = function()
              local isDeadSoldierEnough = self.ctrl:IsDeadSoldierEnough(soldierList)
              if not isDeadSoldierEnough then
                Logger.LogInfo("LWUIHospitalView log: dead soldier not enough")
                return
              end
              if not self.ctrl:CheckDiamondConfirmResourceIsEnough(expenditureDic, resGold) then
                UIUtil.ShowTipsId("hospital_cure_resource_change_tips_1")
                return
              end
              self:SendMessage(soldierList, IsGold.UseGold, nil, timeGold, resGold)
              self.ctrl:CloseSelf()
            end
          }
        }
        UIUtil.TryShowDiamondConfirm(TodayNoSecondConfirmType.UpgradeUseDiamond, param)
      end
    end
  end
end

function LWUIHospitalView:RefreshState(time)
  self.instantinfo = LWResourceLackUtil:GetResState(time, self.resList, ItemSpdMenu.ItemSpdMenu_Heal)
  if not self.completeImmdiatelyData.speedUpData then
    self.completeImmdiatelyData.speedUpData = {}
  end
  self.completeImmdiatelyData.speedUpData.speedUpItems = self.instantinfo.speedUpitems
  self.completeImmdiatelyData.speedUpData.speedUpDifferentTime = self.instantinfo.time
  self.completeImmdiatelyData.speedUpData.speedUpTotalTime = time
end

function LWUIHospitalView:RefreshGlod()
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

function LWUIHospitalView:RefreshBtn(time)
  local resNoEnough = self.resList and #self.resList > 0
  local resHasCanSupplyItems = false
  if resNoEnough then
    for i, needResData in ipairs(self.resList) do
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
    self.instantCostText:SetColorRGBA(1, 1, 1, 1)
    self.instantIcon:LoadSprite(timeIconPath)
    self.instantCostText:SetText(UITimeManager:GetInstance():SecondToFmtString(math.ceil(time)))
  else
    self.instantIcon:LoadSprite(goldIconPath)
    self.timeGlod = 0
    self.timeGlod = CommonUtil.GetTimeDiamondCost(self.time)
    self.resGlod = 0
    if #self.resList > 0 then
      local glodCount = 0
      local count
      for i, v in pairs(self.resList) do
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

function LWUIHospitalView:OnYellowBtnClick()
  if self.spendGold == 0 then
    return
  end
  self:SendMessage(self.soldierList, IsGold.UseGold)
  self.ctrl:CloseSelf()
end

function LWUIHospitalView:OnTimeBtnClick()
  if self.time == 0 then
    return
  end
  if 0 < #self.resList then
    LWResourceLackUtil:GotoResLack(self.resList)
    return
  end
  self:SendMessage(self.soldierList, IsGold.NoUseGold)
  self.ctrl:CloseSelf()
end

function LWUIHospitalView:SendMessage(soldierList, type, itemIds, timeGold, resGold)
  local param = {}
  param.gold = type
  if itemIds then
    param.itemIds = itemIds
  end
  if timeGold then
    param.goldForTime = timeGold
  end
  if resGold then
    param.goldForResource = resGold
  end
  local arr = {}
  if not table.IsNullOrEmpty(soldierList) then
    for i, info in pairs(soldierList) do
      if info.curCount ~= nil and info.curCount > 0 then
        arr[info.armyId] = info.curCount
      end
    end
  end
  if 0 < table.count(arr) then
    param.arr = arr
    SFSNetwork.SendMessage(MsgDefines.HospitalCure, param)
    if self.isEdit then
      HospitalManager:SetSoldierCureTimeValueLocal(self:CheckCureSoldierMax() and -1 or self.time)
      self.isEdit = false
    end
    self.hospitalCureMsgLock = true
  else
    Logger.LogError("hospital error  soldierCount 0 ----->")
  end
end

function LWUIHospitalView:GetExpenditureParam(itemId, info)
  local param = {}
  param.resourceType = itemId
  param.count = self.ctrl:GetHealCostResourceCount(info.exp)
  local count = LuaEntry.Resource:GetCntByResType(itemId)
  local own = 0
  if count ~= nil then
    own = count
  end
  param.isRed = own < param.count
  if param.isRed then
    table.insert(self.resList, {
      resType = param.resourceType,
      need = param.count,
      count = param.count - own
    })
  end
  return param
end

function LWUIHospitalView:InitInstantBtn()
  self.instantIsUnlock = DataCenter.LWFunctionUnlockManager:CheckCanShow(LWFunctionUnlockType.SoliderInstantFinish)
  if self.instantIsUnlock then
    self.instantBtn:SetActive(not self.isTreating and not self.isFinishTreating)
  else
    self.instantBtn:SetActive(false)
  end
end

function LWUIHospitalView:RefreshView()
  self.instantCostText:SetColorRGBA(1, 1, 1, 1)
  self.soldierList = self.ctrl:GetSoldier()
  self.startSoldierDic = self.ctrl:GetStartSoldierCountDic()
  local deadSoldierCount = self.ctrl:GetMaxDeadSoldier()
  self.countText:SetText(tostring(deadSoldierCount) .. "/" .. tostring(self.ctrl:GetHospitalMaxVolume()))
  self.countNameText:SetLocalText(130350)
  self.title_text:SetLocalText(135120)
  local count = self.ctrl:GetMaxDeadSoldier() / self.ctrl:GetHospitalMaxVolume()
  if count <= 0.5 then
    self.countSliderImg:LoadSprite(greenImgpath)
  else
    self.countSliderImg:LoadSprite(redImgPath)
  end
  self.count_slider:SetValue(count)
  self.timeBtnTitilText:SetLocalText(135229)
  local worldId = LuaEntry.Player:GetCurWorldId()
  local isTreatingOrFinish = self.isTreating or self.isFinishTreating
  if deadSoldierCount == 0 then
    self.viewText:SetActive(true)
    self.viewText:SetLocalText(135230)
    self.ItemLayout:SetActive(false)
    self.world_node:SetActive(false)
    UIGray.SetGray(self.timeBtn.transform, true, false)
  else
    UIGray.SetGray(self.timeBtn.transform, false, true)
    self.ItemLayout:SetActive(worldId == 0 and not isTreatingOrFinish)
    self.viewText:SetActive(false)
    self.soldiers_scrollView:SetVerticalNormalizedPosition(1)
    self.world_node:SetActive(0 < worldId)
  end
  self.bg:SetActive(worldId == 0)
  self.image:SetActive(0 < deadSoldierCount or self.isTreating)
  self.treating_content:SetActive(isTreatingOrFinish)
  self.speed_up_btn:SetActive(self.isTreating)
  self.timeBtn:SetActive(not isTreatingOrFinish)
  self.instantBtn:SetActive(not isTreatingOrFinish)
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
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.rootLayout.rectTransform)
end

function LWUIHospitalView:ChangeSoliderCount(index, count, isEdit)
  if self.soldierList[index] then
    self.soldierList[index].curCount = count
  end
  self.cacheSoliderCureCount[index] = count
  self.isEdit = isEdit
  self:ChangeExpenditure()
  if self.showTipsBubble and isEdit then
    self.showTipsBubble = false
    self:ShowCommonTipsPanel()
    Setting:SetBool(SettingKeys.HOSPITAL_CURE_RULES_BUBBLE_FIRST_REMIND, false)
  end
end

function LWUIHospitalView:ChangeExpenditure()
  self.expenditureDic = {}
  self.time = 0
  for i = 1, #self.soldierList do
    self:GetOneSoldierExpenditure(tonumber(self.soldierList[i].armyId), self.soldierList[i].curCount or 0)
  end
  self:RefreshResCell()
  local healSpeedUp = LuaEntry.Effect:GetGameEffect(EffectDefine.LW_HOSPITAL_HEALSPEEDUP) or 0
  local seasonSpeedUp = SeasonUtil.GetSeasonBuffValue(EffectDefine.LW_HOSPITAL_HEALSPEEDUP)
  healSpeedUp = healSpeedUp + seasonSpeedUp
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
  self.timeBtnTime:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(self.time * 1000))
  self:RefreshState(self.time)
  self:RefreshBtn(self.time)
end

function LWUIHospitalView:RefreshResCell()
  self.resList = {}
  for itemID, info in pairs(self.expenditureDic) do
    local param = self:GetExpenditureParam(itemID, info)
    if self.cells[itemID] then
      self.cells[itemID]:ReInit(param)
    end
  end
  self:RefreshState(self.time)
  self:RefreshBtn(self.time)
end

function LWUIHospitalView:GetOneSoldierExpenditure(armyId, count)
  local soldierTemplate = DataCenter.SoldierDataManager:GetTemplate(armyId)
  if not self.expenditureDic then
    self.expenditureDic = {}
  end
  if soldierTemplate then
    if not self.expenditureDic[ResourceType.Metal] then
      self.expenditureDic[ResourceType.Metal] = {}
      self.expenditureDic[ResourceType.Metal].exp = 0
    end
    if not self.expenditureDic[ResourceType.Food] then
      self.expenditureDic[ResourceType.Food] = {}
      self.expenditureDic[ResourceType.Food].exp = 0
    end
    local cureCostMetal = soldierTemplate.cureCost[ResourceType.Metal] or 0
    local cureCostFood = soldierTemplate.cureCost[ResourceType.Food] or 0
    if cureCostMetal == 0 and cureCostFood == 0 then
    else
      self.expenditureDic[ResourceType.Metal].exp = self.expenditureDic[ResourceType.Metal].exp + count * cureCostMetal
      self.expenditureDic[ResourceType.Food].exp = self.expenditureDic[ResourceType.Food].exp + count * cureCostFood
    end
    self.time = self.time + soldierTemplate.cureTime * count
  end
end

function LWUIHospitalView:ShowScroll()
  self:ClearScroll()
  local count = #self.soldierList
  self.soldiers_scrollView:SetTotalCount(count)
  if 0 < count then
    self.soldiers_scrollView:RefillCells()
  end
end

function LWUIHospitalView:ClearScroll()
  self.soldiers_scrollView:ClearCells()
  self.soldiers_scrollView:RemoveComponents(HospitalSoldierCell)
end

function LWUIHospitalView:OnCreateCell(itemObj, index)
  itemObj.name = tostring(index)
  local item = self.soldiers_scrollView:AddComponent(HospitalSoldierCell, itemObj)
  self.soldierList[index].index = index
  self.soldierList[index].callback = function(index, count, isEdit)
    self:ChangeSoliderCount(index, count, isEdit)
  end
  if self.cacheSoliderCureCount[index] ~= nil then
    self.soldierList[index].curCount = self.cacheSoliderCureCount[index]
  else
    self.soldierList[index].curCount = self.startSoldierDic[self.soldierList[index].armyId] or 1
  end
  local isTreatingOrFinish = self.isTreating or self.isFinishTreating
  item:ReInit(self.soldierList[index], isTreatingOrFinish)
end

function LWUIHospitalView:OnDeleteCell(itemObj, index)
  self.soldiers_scrollView:RemoveComponent(itemObj.name, HospitalSoldierCell)
end

function LWUIHospitalView:UnLockHospitalCureMsg()
  self.hospitalCureMsgLock = false
end

function LWUIHospitalView:RefreshIsTreatingState()
  self.isTreating = false
  self.treatingQueue = nil
  self.isFinishTreating = false
  local worldId = LuaEntry.Player:GetCurWorldId()
  if worldId == 0 then
    self.treatingQueue = DataCenter.QueueDataManager:GetQueueByType(NewQueueType.Hospital)
  else
    self.treatingQueue = DataCenter.QueueDataManager:GetQueueByType(NewQueueType.DragonHospital)
  end
  if self.treatingQueue ~= nil then
    local state = self.treatingQueue:GetQueueState()
    self.isTreating = state == NewQueueState.Work
    self.isFinishTreating = state == NewQueueState.Finish
  end
end

function LWUIHospitalView:RefreshTreatingInfoShowView()
  local treatingTotalCount = 0
  local treatingSoldierList = DataCenter.HospitalManager:GetTreatingHospital()
  for i = 1, table.count(treatingSoldierList) do
    local treatingSoldierInfo = treatingSoldierList[i]
    treatingTotalCount = treatingTotalCount + treatingSoldierInfo.heal
  end
  self.treating_num_text:SetText(treatingTotalCount)
  self:UpdateTrainingRemainTime()
end

function LWUIHospitalView:UpdateTrainingRemainTime()
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

function LWUIHospitalView:SpeedUpBtnClick()
  if self.treatingQueue ~= nil and self.isTreating then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UISpeed, ItemSpdMenu.ItemSpdMenu_Heal, self.treatingQueue.uuid)
  end
end

function LWUIHospitalView:ReceiveBtnClick()
  local uuId = self:GetUserData()
  DataCenter.HospitalManager:CheckSendFinish(uuId)
  self.ctrl:CloseSelf()
end

function LWUIHospitalView:DataDefine()
  self.soldierList = {}
  self.expenditureDic = {}
  self.startSoldierDic = {}
  self.time = 0
  self.spendGold = 0
  self.cells = {
    [ResourceType.Food] = self.foodResourceCell,
    [ResourceType.Metal] = self.metalResourceCell
  }
  self.hospitalCureMsgLock = false
  self.isTreating = false
  self.isFinishTreating = false
  self.treatingQueue = nil
  self.cacheSoliderCureCount = {}
  self.isEdit = false
  self.rulesParam = nil
  self.showTipsBubble = Setting:GetBool(SettingKeys.HOSPITAL_CURE_RULES_BUBBLE_FIRST_REMIND, true)
  self.completeImmdiatelyData = {}
end

function LWUIHospitalView:ComponentDestroy()
  self.close_btn = nil
  self.title_text = nil
  self.count_slider = nil
  self.countSliderImg = nil
  self.soldiers_scrollVie = nil
  self.countText = nil
  self.countNameText = nil
  self.panelBtn = nil
  self.yellowBtn = nil
  self.yellowBtnTitilText = nil
  self.yellowBtnImg = nil
  self.yellowBtnText = nil
  self.timeBtn = nil
  self.timeBtnTime = nil
  self.timeBtnTitilText = nil
  self.desert_battle_tips_btn = nil
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
    self.TimerAction = nil
  end
  self.speed_up_btn = nil
  self.speed_up_btn_text = nil
  self.treating_content = nil
  self.treating_time_slider = nil
  self.treating_time_text = nil
  self.treating_num_text = nil
  self.receive_btn = nil
  self.receive_btn_text = nil
  self.completeImmdiatelyData = nil
end

function LWUIHospitalView:DataDestroy()
  self.soldierList = nil
  self.expenditureDic = nil
  self.startSoldierDic = nil
  self.time = nil
  self.spendGold = nil
  self.cells = nil
  self.hospitalCureMsgLock = nil
  self.isTreating = nil
  self.isFinishTreating = nil
  self.treatingQueue = nil
  self.isEdit = nil
  self.rulesParam = nil
  self.showTipsBubble = nil
end

local function CheckCureSoldierMax(self)
  if self.soldierList then
    local count = 0
    for i, v in ipairs(self.soldierList) do
      if v and v.curCount then
        count = count + v.curCount
      end
    end
    local maxDeadSoldier = self.ctrl:GetMaxDeadSoldier()
    return count >= maxDeadSoldier
  end
end

local function OnTipsBtnClick(self)
  if self.rulesParam == nil then
    self.rulesParam = {
      activityRulesStr = Localization:GetString("hospital_quick_rule")
    }
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, self.rulesParam)
end

local function ShowCommonTipsPanel(self)
  local content = Localization:GetString("hospital_quick_tips")
  local parameter = {reversal = true}
  UIUtil.ShowBubbleTips(content, self.tipBtn.transform.position, 0, 30, -40, nil, nil, parameter)
end

LWUIHospitalView.CheckCureSoldierMax = CheckCureSoldierMax
LWUIHospitalView.OnTipsBtnClick = OnTipsBtnClick
LWUIHospitalView.ShowCommonTipsPanel = ShowCommonTipsPanel
return LWUIHospitalView
