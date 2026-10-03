local UILWTrainDepartureView = BaseClass("UILWTrainDepartureView", UIBaseView)
local base = UIBaseView
local UnityCanvasGroup = typeof(CS.UnityEngine.CanvasGroup)
local FormationSelectListCellNew = require("UI.UIFormation.UIFormationSelectListNew.Component.FormationSelectListCellNew")
local FormationHeroItem = require("UI.UIFormation.UIFormationSelectListNew.Component.FormationHeroItem")
local FormationHeroAdd = require("UI.UIFormation.UIFormationSelectListNew.Component.FormationHeroAdd")
local UILWTrainScienceItemRender = require("UI.UILWRailway.UILWTrainDeparture.Component.UILWTrainScienceItemRender")
local UILWTrainDepartureConfirm = require("UI.UILWRailway.UILWTrainDeparture.Component.UILWTrainDepartureConfirm")
local LWMaxAdWatchAd = require("UI.LWUIMaxAd.Component.LWMaxAdWatchAd")
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local cur_squad_text_path = "Root/Content/root/ChangeHeroBtn/CurSquadBg/CurSquadText"
local cofirmPanel_path = "Root/ConfirmPanel"
local multi_reward_tip_area_path = "Root/MultiRewardTipArea"
local S5_TRIGGERS_9257_SLOT_DO = "S5_TRIGGERS_9257_SLOT_DO"
local glow_path = "Root/Content/UICommonPopBg/Eff_ui_train_gold/IconRawImage1/car_ssr/Eff_ui_train_smoke_front/glow"
local glow2_path = "Root/Content/UICommonPopBg/Eff_ui_train_gold/IconRawImage1/car_ssr/Eff_ui_train_smoke_front/glow2"
local super_departure_btn_path = "Root/Content/root/SuperDepartureBtn"
local super_departure_btn_text_path = "Root/Content/root/SuperDepartureBtn/SuperDepartureBtnText"

function UILWTrainDepartureView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  if SeasonUtil.GetSeason() == 5 and not SeasonUtil.IsInSeasonPrepareMode() then
    local hasHistory = Setting:GetPrivateBool(S5_TRIGGERS_9257_SLOT_DO, false)
    if not hasHistory then
      EventManager:GetInstance():Broadcast(EventId.PlayPlotGroup, {
        plotGroupId = 9257,
        hideMainUI = false,
        callback = nil
      })
      Setting:SetPrivateBool(S5_TRIGGERS_9257_SLOT_DO, true)
    end
  end
end

function UILWTrainDepartureView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWTrainDepartureView:ComponentDefine()
  self.closeBtn = self:AddComponent(UIButton, "Panel")
  self.closeBtn:SetOnClick(function()
    self:CloseAni()
    self.ctrl:CloseSelf()
  end)
  self.returnBtn = self:AddComponent(UIButton, "Root/Content/UICommonPopBg/CloseBtn")
  self.returnBtn:SetOnClick(function()
    self:CloseAni()
    self.ctrl:CloseSelf()
  end)
  self.goBtn = self:AddComponent(UIButton, "Root/Content/root/GoBtn")
  self.goBtn:SetOnClick(function()
    if self.myTrain and self.myTrain.quality and self.myTrain.quality < 4 and self.myTrain:GetChangeCost() <= 0 then
      UIUtil.TryShowConfirm(TodayNoSecondConfirmType.TrainGoConfirm, Localization:GetString("truck_tips10005"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
        self:OnClickGo()
      end, function()
      end, nil, nil, false, nil, nil)
    else
      self:OnClickGo()
    end
  end)
  self.infoBtn = self:AddComponent(UIButton, "Root/Content/root/iBtn")
  self.infoBtn:SetOnClick(function()
    self:OnInfoClick()
  end)
  self.randomBtn = self:AddComponent(UIButton, "Root/Content/RandomBtn")
  self.randomBtn:SetOnClick(function()
    self:OnRandomBtnClick()
  end)
  self.randomBtn:SetSafeClickMode(true)
  self.changeHeroBtn = self:AddComponent(UIButton, "Root/Content/root/ChangeHeroBtn")
  self.changeHeroBtn:SetOnClick(function()
    self:OnChangeHeroBtnClick()
  end)
  self.titleTxt = self:AddComponent(UIText, "Root/Content/root/TitleTxt")
  self.titleTxt:SetLocalText("457505")
  self.remindsTxt1 = self:AddComponent(UIText, "Root/Content/root/RemindsContent/RemindsTxt1")
  self.remindsTxt1:SetLocalText("457506")
  self.remindsTxt2 = self:AddComponent(UIText, "Root/Content/root/RemindsTxt2")
  self.remindsTxt2:SetLocalText("457507")
  self.remindsTxt3 = self:AddComponent(UIText, "Root/Content/root/RemindsTxt3")
  self.remindsTxt4 = self:AddComponent(UIText, "Root/Content/root/RemindsTxt4")
  self.remindsTxt4:SetLocalText("457566")
  self.remindsTxt5 = self:AddComponent(UIText, "Root/Content/root/RemindsTxt5")
  self.remindsTxt5:SetLocalText("457534")
  self.bg = self:AddComponent(UIRawImage, "Root/Content/UICommonPopBg/Bg")
  self.bgNew = self:AddComponent(UIRawImage, "Root/Content/UICommonPopBg/BgNew")
  self.iconRawImage = self:AddComponent(UIRawImage, "Root/Content/UICommonPopBg/IconRawImage/car")
  self.goldRawImage = self:AddComponent(UIRawImage, "Root/Content/UICommonPopBg/Eff_ui_train_gold/IconRawImage1/car_ssr")
  self.quality = self:AddComponent(UIImage, "Root/Content/QualityImage")
  self.timeTxt = self:AddComponent(UIText, "Root/Content/root/RemindsContent/TimeTxt")
  self.countTxt = self:AddComponent(UIText, "Root/Content/root/Bubble/CountTxt")
  self.rewardContent = self:AddComponent(UIBaseContainer, "Root/Content/root/ScrollView/Viewport/Content")
  self.formationContent = self:AddComponent(UIBaseContainer, "Root/Content/FormationContent")
  self.formationTips = self:AddComponent(UIBaseContainer, "Root/Content/FormationTips")
  self.heroList = self:AddComponent(UIBaseContainer, "Root/Content/root/HeroScrollView/Viewport/HeroList")
  self.tipsArrow = self:AddComponent(UIBaseContainer, "Root/Content/FormationTips/Arrow")
  self.Layout = self:AddComponent(UIBaseContainer, "Root/Content/FormationTips/Layout")
  self.scienceContent = self:AddComponent(UIBaseContainer, "Root/Content/ScienceContent")
  self.cur_squad_text = self:AddComponent(UIText, cur_squad_text_path)
  self.glow = self:AddComponent(UIBaseComponent, glow_path)
  self.glow2 = self:AddComponent(UIBaseComponent, glow2_path)
  local seasonType = SeasonUtil.GetSeasonType()
  local showHeadLamp = seasonType ~= SeasonMapType.Mummy and seasonType ~= SeasonMapType.NineNation
  self.glow:SetActive(showHeadLamp)
  self.glow2:SetActive(showHeadLamp)
  self.scienceItem = self.transform:Find("Root/Content/UILWTrainScienceItemRender").gameObject
  self.scienceItem:GameObjectCreatePool()
  self:HideAllShowTip()
  self.confirmPanel = self:AddComponent(UILWTrainDepartureConfirm, cofirmPanel_path)
  self.confirmPanel:SetActive(false)
  self.bubble = self:AddComponent(UIBaseContainer, "Root/Content/root/Bubble")
  local go_btn_txt = self:AddComponent(UITextMeshProUGUIEx, "Root/Content/root/GoBtn/goBtnTxt")
  go_btn_txt:SetLocalText(457508)
  self.multiRewardTipObj = self:AddComponent(UIBaseContainer, multi_reward_tip_area_path)
  self.root_anim = self.transform:Find("Root"):GetComponent(typeof(CS.UnityEngine.Animator))
  local isOpen = LuaEntry.DataConfig:CheckSwitch("truck_refresh_test")
  if isOpen then
    self.bgNew:SetActive(true)
    self.bg:SetActive(false)
  else
    self.bgNew:SetActive(false)
    self.bg:SetActive(true)
  end
  self.compWatchAd = self:AddComponent(LWMaxAdWatchAd, "Root/Content/WatchAdContent")
  self.itemObjPool = self.transform:Find("Root/Content/root/ItemTemplate").gameObject
  self.itemObjPool:GameObjectCreatePool()
  self.super_departure_btn = self:TryAddComponent(UIButton, super_departure_btn_path)
  self.super_departure_btn_text = self:TryAddComponent(UITextMeshProUGUIEx, super_departure_btn_text_path)
  if self.super_departure_btn_text then
    self.super_departure_btn_text:SetLocalText("super_trucklaunch_btn01")
  end
  if self.super_departure_btn then
    self.super_departure_btn:SetOnClick(function()
      self:CloseAni()
      self.ctrl:CloseSelf()
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWTruckSuperDeparture, {anim = true})
    end)
    local functionOpen = RailwayUtil.IsOpenSuperTruckDeparture()
    self.super_departure_btn:SetActive(functionOpen)
    if functionOpen then
      self.goBtn:SetAnchoredPositionXY(-162, -547)
    else
      self.goBtn:SetAnchoredPositionXY(-2, -547)
    end
  end
end

function UILWTrainDepartureView:ComponentDestroy()
  self:ClearReward()
  self:ClearFormation()
  self:ClearHeroList()
  self:OnClearHeroList()
  self:ClearScienceList()
  self.closeBtn = nil
  self.returnBtn = nil
  self.buyBtn = nil
  self.rentBtn = nil
  self.rentBtnText = nil
  self.rentPriceText = nil
  self.contractTitleTxt = nil
  self.discountTxt = nil
  self.priceTxt = nil
  self.contractRemindsTxt1 = nil
  self.contractRemindsTxt2 = nil
  self.scienceContent = nil
  self.scienceItem = nil
  self.root_anim = nil
  self.compWatchAd = nil
  self.itemObjPool = nil
  self.super_departure_btn = nil
  self.super_departure_btn_text = nil
end

function UILWTrainDepartureView:DataDefine()
  self.buildUuid = self:GetUserData()
  self.formation = DataCenter.LWMyStationDataManager:GetMaxBattlePowerFreeDefenceFormation()
  if self.formation and self.formation.index then
    self.curDefenceFormationIndex = self.formation.index
    DataCenter.LWMyStationDataManager.curDefenceSquadIndexInView = self.formation.index
  end
  self.__waitChangeTrain = false
end

function UILWTrainDepartureView:DataDestroy()
  DataCenter.LWMyStationDataManager.curDefenceSquadIndexInView = 1
  self.curDefenceFormationIndex = 1
  self:ClearWaitChangeTrain()
end

function UILWTrainDepartureView:OnEnable()
  base.OnEnable(self)
  self.curDefenceFormationIndex = DataCenter.LWMyStationDataManager.curDefenceSquadIndexInView
  self:RefreshAll()
  self:RefreshTravelTotalTime()
end

function UILWTrainDepartureView:OnDisable()
  base.OnDisable(self)
end

function UILWTrainDepartureView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ChangeTrainSuccess, self.RefreshTrain)
  self:AddUIListener(EventId.RefreshTruckHero, self.OnRefreshTruckDefenceHero)
  self:AddUIListener(EventId.ChangeTruckItemNumChange, self.RefreshTrain)
  self:AddUIListener(EventId.DepartureTrainSuccess, self.OnDepartureTrainSuccess)
  self:AddUIListener(EventId.MultiRewardDataUpdate, self.RefreshTrain)
  self:AddUIListener(EventId.ChangeTrainCallback, self.OnChangeTrainCallback)
end

function UILWTrainDepartureView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.ChangeTrainSuccess, self.RefreshTrain)
  self:RemoveUIListener(EventId.RefreshTruckHero, self.OnRefreshTruckDefenceHero)
  self:RemoveUIListener(EventId.ChangeTruckItemNumChange, self.RefreshTrain)
  self:RemoveUIListener(EventId.DepartureTrainSuccess, self.OnDepartureTrainSuccess)
  self:RemoveUIListener(EventId.MultiRewardDataUpdate, self.RefreshTrain)
  self:RemoveUIListener(EventId.ChangeTrainCallback, self.OnChangeTrainCallback)
end

function UILWTrainDepartureView:RefreshAll()
  self:RefreshTrain()
  self:RefreshHero()
  self:RefreshWatchAd()
end

function UILWTrainDepartureView:CheckIsNeedShowMultiRewardTip()
  local isDuringMultiReward = MultiRewardDropUtils.GetTruckCurCanEnjoyMaxMultiValue()
  self.multiRewardTipObj:SetActive(1 < isDuringMultiReward)
end

function UILWTrainDepartureView:OnChangeTrainCallback()
  self:ClearWaitChangeTrain()
end

function UILWTrainDepartureView:OnBatchChangeTrainSuccess(changeTruckList)
  if self.myTrain then
    for i, v in pairs(changeTruckList) do
      if self.myTrain.index == v then
        self:RefreshTrain()
      end
    end
  end
end

function UILWTrainDepartureView:RefreshTrain()
  self.myTrain = DataCenter.LWMyStationDataManager:GetMyTrainByBuildUuid(self.buildUuid)
  local myTrain = self.myTrain
  if not myTrain then
    Logger.LogError("\231\129\171\232\189\166\230\149\176\230\141\174\230\137\190\228\184\141\229\136\176\239\188\129")
    return
  end
  local today, daily = DataCenter.LWMyStationDataManager:GetDepartureCount()
  self.remindsTxt3:SetText(string.format("%s: %s/%s", Localization:GetString("457565"), today, daily))
  local quality = myTrain.quality
  local isOpen = LuaEntry.DataConfig:CheckSwitch("truck_refresh_test")
  if isOpen then
    self.bgNew:LoadSprite(QualityTrainBigImproveBgPath[quality])
  else
    self.bg:LoadSprite(QualityTrainBigBgPath[quality])
  end
  self.iconRawImage:LoadSprite(myTrain:GetBgIcon())
  self.iconRawImage:SetNativeSize()
  self.quality:LoadSprite(myTrain:GetQualityPath())
  if quality <= 4 then
    self.root_anim:Play("V_ui_UILWTrainDeparture_switch_normal", 0, 0)
  elseif quality == 5 then
    self.goldRawImage:LoadSprite(myTrain:GetBgIcon())
    self.goldRawImage:SetNativeSize()
    self.root_anim:Play("V_ui_UILWTrainDeparture_switch_gold", 0, 0)
    DataCenter.LWSoundManager:PlaySound("50202", false)
  else
    self.root_anim:Play("V_ui_UILWTrainDeparture_switch_dear", 0, 0)
    DataCenter.LWSoundManager:PlaySound("50203", false)
  end
  self:RefreshTravelTotalTime()
  local cost = myTrain:GetChangeCost()
  if 0 < cost then
    local own = DataCenter.ItemData:GetItemCount(DataCenter.LWMyStationDataManager:GET_CHANGE_TRAIN_ITEM_ID())
    self.countTxt:SetText(string.format("%s/%s", own, cost))
  else
    self.countTxt:SetLocalText("121059")
  end
  self:RefreshReward()
  self:RefreshScience()
  self:CheckIsNeedShowMultiRewardTip()
end

function UILWTrainDepartureView:CloseAni()
  local quality = self.myTrain.quality
  if quality <= 4 then
    self.root_anim:Play("V_ui_UILWTrainDeparture_switch_normal", 0, 1.0)
  elseif quality == 5 then
    self.root_anim:Play("V_ui_UILWTrainDeparture_switch_gold", 0, 1.0)
  else
    self.root_anim:Play("V_ui_UILWTrainDeparture_switch_dear", 0, 1.0)
  end
end

function UILWTrainDepartureView:OnRefreshTruckDefenceHero()
  self:RefreshHero()
end

function UILWTrainDepartureView:OnDepartureTrainSuccess(buildUuid)
  if self.buildUuid == buildUuid then
    self.ctrl:CloseSelf()
  end
end

function UILWTrainDepartureView:RefreshTravelTotalTime()
  if not self.myTrain or not self.myTrain.uuid then
    return
  end
  local time = self.myTrain:GetTravelTotalTime()
  local timeStr = UITimeManager:GetInstance():MilliSecondToFmtStringWithoutDay(time)
  self.timeTxt:SetText(timeStr)
  local effectSpeedValue = LuaEntry.Effect:GetGameEffect(EffectDefine.LW_IMPROVE_TRAIN_SPEED)
  if 0 < effectSpeedValue then
    self.timeTxt:SetColor(EffectGreenColor)
  else
    self.timeTxt:SetColor(WhiteColor)
  end
end

function UILWTrainDepartureView:OnChangeHeroBtnClick()
  if not self.myTrain or not self.myTrain.uuid then
    return
  end
  local param = {}
  param.curDefenceFormationIndex = self.curDefenceFormationIndex
  param.trainUuid = self.myTrain.uuid
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroPVPFormation, {anim = true}, EnterHeroSquadPanelWay.TruckDeparture, param)
end

function UILWTrainDepartureView:OnClickGo()
  if self.myTrain and self.myTrain.uuid then
    EventManager:GetInstance():Broadcast(EventId.GF_click_departure_btn)
    local curFormation = DataCenter.LWMyStationDataManager:GetDefenceFormationByIndex(self.curDefenceFormationIndex)
    DataCenter.LWMyStationDataManager:TryDepartureTrain(self.myTrain.uuid, curFormation)
  end
  if self.ctrl then
    self.ctrl:CloseSelf()
  end
end

function UILWTrainDepartureView:OnRandomBtnClick()
  if not self.myTrain or not self.myTrain.uuid then
    return
  end
  EventManager:GetInstance():Broadcast(EventId.GF_click_random_btn)
  if self.__waitChangeTrain then
    return
  end
  local cost = self.myTrain:GetChangeCost()
  local own = DataCenter.ItemData:GetItemCount(DataCenter.LWMyStationDataManager:GET_CHANGE_TRAIN_ITEM_ID())
  if cost <= own then
    if self.myTrain.isSpecialURQuality then
      self.bubble:SetActive(false)
      self.confirmPanel:ShowConfirm(nil, "truck_tips10004", false, function()
        DataCenter.LWMyStationDataManager:TryChangeTrain(self.myTrain.uuid)
        self.bubble:SetActive(true)
        self:SetWaitChangeTrain()
      end, function()
        self.bubble:SetActive(true)
      end)
    elseif self.myTrain:GetIsContainHighGoods() then
      self.bubble:SetActive(false)
      self.confirmPanel:ShowConfirm(nil, "truck_tips10001", false, function()
        DataCenter.LWMyStationDataManager:TryChangeTrain(self.myTrain.uuid)
        self.bubble:SetActive(true)
        self:SetWaitChangeTrain()
      end, function()
        self.bubble:SetActive(true)
      end)
    else
      DataCenter.LWMyStationDataManager:TryChangeTrain(self.myTrain.uuid)
      self:SetWaitChangeTrain()
    end
  else
    LWResourceLackUtil:GotoGoodsItemLack(DataCenter.LWMyStationDataManager:GET_CHANGE_TRAIN_ITEM_ID(), cost - own)
  end
end

function UILWTrainDepartureView:SetWaitChangeTrain()
  if not self.__waitChangeTrain then
    self.__waitChangeTrain = true
    if self.delayWaitChangeTrain then
      self.delayWaitChangeTrain:Stop()
    end
    self.delayWaitChangeTrain = TimerManager:GetInstance():DelayInvoke(function()
      self.__waitChangeTrain = false
      self.delayWaitChangeTrain = nil
    end, 30)
  end
end

function UILWTrainDepartureView:ClearWaitChangeTrain()
  self.__waitChangeTrain = false
  if self.delayWaitChangeTrain then
    self.delayWaitChangeTrain:Stop()
    self.delayWaitChangeTrain = nil
  end
end

function UILWTrainDepartureView:ClearHeroList()
  self.heroList:RemoveComponents(FormationHeroItem)
  self.heroList:RemoveComponents(FormationHeroAdd)
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.model = {}
end

function UILWTrainDepartureView:RefreshHero()
  self:ClearHeroList()
  self.formation = DataCenter.LWMyStationDataManager:GetDefenceFormationByIndex(self.curDefenceFormationIndex)
  if not self.formation then
    return
  end
  self.cur_squad_text:SetLocalText("city_trade_tips1017", self.formation.index)
  local dominatorUuid = self.formation:GetLocalDominatorUuid()
  if dominatorUuid and 0 < dominatorUuid then
    local dominatorInfo = DataCenter.DominatorManager:GetInfoByUuid(dominatorUuid)
    if dominatorInfo and self.model[6] == nil then
      self.model[6] = self:GameObjectInstantiateAsync(UIAssets.FormationHeroItem, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        local go_tf = go.transform
        go.gameObject:SetActive(true)
        go_tf:SetParent(self.heroList.transform)
        go_tf:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        go_tf:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
        go.name = "6"
        local cell = self.heroList:AddComponent(FormationHeroItem, go.name)
        cell:InitWithConfigId(dominatorInfo.dominatorId, nil, nil, dominatorInfo:GetCurRankLv())
      end)
    end
  end
  for i = 1, 5 do
    local heroUuid = self.formation.remoteIndexToHeroDic[i]
    if self.model[i] == nil then
      self.model[i] = self:GameObjectInstantiateAsync(UIAssets.FormationHeroItem, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        local go_tf = go.transform
        go.gameObject:SetActive(true)
        go_tf:SetParent(self.heroList.transform)
        go_tf:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        go_tf:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
        go.name = i
        local cell = self.heroList:AddComponent(FormationHeroItem, go.name)
        cell:InitData(heroUuid)
      end)
    end
  end
end

function UILWTrainDepartureView:ClearReward()
  self.rewardContent:RemoveComponents(UICommonResItem)
  if self.itemObjPool then
    self.itemObjPool:GameObjectRecycleAll()
  end
  self.rewardItems = {}
end

function UILWTrainDepartureView:RefreshReward()
  self:ClearReward()
  if not self.myTrain or not self.myTrain.uuid then
    return
  end
  local rewardList = self.myTrain:GetFullRewardData()
  self.remindsTxt5:SetActive(#rewardList < 5)
  self.orange = 0
  for i, data in ipairs(rewardList) do
    local go = self.itemObjPool:GameObjectSpawn(self.rewardContent.transform)
    local index = i
    local nameStr = "UICommonResItem" .. index
    go.name = nameStr
    go:SetActive(true)
    go.transform:Set_localScale(0.9, 0.9, 0.9)
    local item = self.rewardContent:AddComponent(UICommonResItem, nameStr)
    local param = UICommonResItem.Param.New()
    param.rewardType = data.type
    if type(data.value) == "table" then
      param.itemId = data.value.id
      param.count = data.value.num
    else
      param.itemId = data.type
      param.count = self.myTrain:CorrectResourceRewardCount(data.value)
      local effectValue = LuaEntry.Effect:GetGameEffect(EffectDefine.LW_BASIC_RESOURCE_PRODUCT_PROMOTION)
      param.isShowArrow = 0 < effectValue
    end
    param.rewardType = data.type
    param.heroUuid = data.heroUuid
    param.isHeroBox = data.isHeroBox
    item:ReInit(param)
    self.rewardItems[index] = item
    local goods = DataCenter.ItemTemplateManager:GetItemTemplate(param.itemId)
    if goods and goods.color == 5 then
      self.orange = self.orange + 1
    end
    local curMultiVal = self.myTrain.multiple
    local isDuringMultiReward = 1 < MultiRewardDropUtils.GetTruckCurCanEnjoyMaxMultiValue()
    if curMultiVal and 1 < curMultiVal and isDuringMultiReward then
      item:ShowMultiMark(curMultiVal)
    else
      item:HideMultiMark()
    end
    self:LogItemHide(item)
  end
end

function UILWTrainDepartureView:ClearFormation()
  self.formationContent:RemoveComponents(FormationSelectListCellNew)
  if self.formationReqs then
    for _, req in pairs(self.formationReqs) do
      req:Destroy()
    end
  end
  self.formationReqs = {}
  self.formationCells = {}
end

function UILWTrainDepartureView:RefreshFormation()
  self:ClearFormation()
  for i = 1, self.formationData.maxNum do
    self.formationReqs[i] = self:GameObjectInstantiateAsync(UIAssets.UIMainFormationSelectListCellNew, function(request)
      if IsNull(request.gameObject) then
        return
      end
      local go = request.gameObject
      go.gameObject:SetActive(true)
      go.transform:SetParent(self.formationContent.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      local index = i
      local nameStr = "UIMainFormationSelectCellNew" .. index
      go.name = nameStr
      local cell = self.formationContent:AddComponent(FormationSelectListCellNew, nameStr)
      cell:SetUuidAndIndex(i, self.formationData.list[i])
      cell:RefreshData()
      self.formationCells[i] = cell
    end)
  end
end

function UILWTrainDepartureView:OnSelectClick(uuid)
  table.walk(self.formationCells, function(k, v)
    v:OnSelectClick(uuid)
  end)
  self.selectUuid = uuid
end

function UILWTrainDepartureView:ShowFormationArmyTip(posX, posY, formationData)
  self.formationTips:SetActive(true)
  self:RefreshHeroList(posX, posY, formationData)
end

function UILWTrainDepartureView:ShowFormationCreateTip(posX, posY, formationData)
  self.formationTips:SetActive(true)
  self:RefreshHeroList(posX, posY, formationData)
end

function UILWTrainDepartureView:HideAllShowTip()
  self.formationTips:SetActive(false)
end

function UILWTrainDepartureView:RefreshHeroList(posX, posY, formationData)
  self.tipsArrow:SetPositionXYZ(posX, posY, 0)
  self:OnClearHeroList()
  if 0 < formationData.isMarch or formationData.useForm then
    for i = 1, 5 do
      local heroUuid
      for _, heroData in pairs(formationData.heroDataList) do
        if heroData.index == i then
          heroUuid = heroData.heroUuid
          break
        end
      end
      if heroUuid then
        if self.model[i] == nil then
          self.model[i] = self:GameObjectInstantiateAsync(UIAssets.FormationHeroItem, function(request)
            if request.isError then
              return
            end
            local go = request.gameObject
            local go_tf = go.transform
            go.gameObject:SetActive(true)
            go_tf:SetParent(self.Layout.transform)
            go_tf:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
            go_tf:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
            go.name = i
            local cell = self.Layout:AddComponent(FormationHeroItem, go.name)
            cell:InitData(heroUuid)
          end)
        end
      elseif self.model[i] == nil then
        self.model[i] = self:GameObjectInstantiateAsync(UIAssets.FormationSelectHeroAdd, function(request)
          if request.isError then
            return
          end
          local go = request.gameObject
          local go_tf = go.transform
          go.gameObject:SetActive(true)
          go_tf:SetParent(self.Layout.transform)
          go_tf:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
          go_tf:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
          go.name = i
          local cell = self.Layout:AddComponent(FormationHeroAdd, go.name)
          cell:RefreshData(i, self.selectUuid, formationData.useForm, GarageBuildIds[formationData.index])
        end)
      end
    end
    if 0 < formationData.isMarch then
    else
      local formation = DataCenter.ArmyFormationDataManager:GetOneArmyInfoByUuid(self.selectUuid)
      if not formation then
        return
      end
      formation:ConscriptSoldier()
    end
  end
end

function UILWTrainDepartureView:OnClearHeroList()
  self.Layout:RemoveComponents(FormationHeroItem)
  self.Layout:RemoveComponents(FormationHeroAdd)
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.model = {}
end

function UILWTrainDepartureView:OnInfoClick()
  local param = {}
  param.activityRulesStr = Localization:GetString("457530")
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
end

function UILWTrainDepartureView:GetWidgetTransform(name)
  if name == "RandomBtn" then
    return self.randomBtn.transform
  elseif name == "GoBtn" then
    return self.goBtn.transform
  end
end

function UILWTrainDepartureView:RefreshScience()
  self:ClearScienceList()
  local trainDepartureScienceId = 13
  local tabState = DataCenter.ScienceTemplateManager:GetTabState(trainDepartureScienceId)
  if tabState == ScienceTabState.UnLock then
    self.scienceContent:SetActive(true)
    self:CreateScienceItem()
  else
    self.scienceContent:SetActive(false)
  end
end

function UILWTrainDepartureView:CreateScienceItem()
  local isSpecialURQuality = self.myTrain.isSpecialURQuality
  local metaId = isSpecialURQuality and 38 or 35
  local metaVal = DataCenter.LWAllyStationDataManager:GetMeta(metaId)
  if metaVal ~= nil then
    self.scienceContent:SetActive(true)
    local scienceIdArr = string.split_ss_array(metaVal, ",")
    for i = 1, #scienceIdArr do
      local goItem = self.scienceItem:GameObjectSpawn(self.scienceContent.transform)
      goItem.name = "item_" .. i
      goItem:SetActive(true)
      local itemRender = self.scienceContent:AddComponent(UILWTrainScienceItemRender, goItem.name)
      itemRender:SetData(scienceIdArr[i])
    end
  else
    self.scienceContent:SetActive(false)
    Logger.LogError("\230\178\161\230\156\137\232\142\183\229\143\150\229\136\176\229\143\175\230\152\190\231\164\186\231\154\132\231\167\145\230\138\128\233\133\141\231\189\174\230\149\176\230\141\174")
  end
end

function UILWTrainDepartureView:ClearScienceList()
  self.scienceContent:RemoveComponents(UILWTrainScienceItemRender)
  self.scienceItem:GameObjectRecycleAll()
end

function UILWTrainDepartureView:RefreshWatchAd()
  self.compWatchAd:RefreshView(AdCollectionId.Train)
end

function UILWTrainDepartureView:LogItemHide(item)
  if item then
    local x, y, z = item:GetLocalScaleXYZ()
    if x == 0 then
      Logger.LogError("UILWTrainDepartureViewItem X = 0")
    end
    if y == 0 then
      Logger.LogError("UILWTrainDepartureViewItem Y = 0")
    end
    if z == 0 then
      Logger.LogError("UILWTrainDepartureViewItem Z = 0")
    end
    local canvasGroup = item.gameObject:GetComponent(UnityCanvasGroup)
    if canvasGroup and canvasGroup.alpha == 0 then
      Logger.LogError("UILWTrainDepartureViewItem Alpha = 0")
    end
    if item.canvasGroup then
      if item.canvasGroup:GetAlpha() == 0 then
        Logger.LogError("UILWTrainDepartureViewItemClick Alpha = 0")
      end
      x, y, z = item.canvasGroup:GetLocalScaleXYZ()
      if x == 0 then
        Logger.LogError("UILWTrainDepartureViewItemClick X = 0")
      end
      if y == 0 then
        Logger.LogError("UILWTrainDepartureViewItemClick Y = 0")
      end
      if z == 0 then
        Logger.LogError("UILWTrainDepartureViewIte Click Z = 0")
      end
    end
  end
end

return UILWTrainDepartureView
