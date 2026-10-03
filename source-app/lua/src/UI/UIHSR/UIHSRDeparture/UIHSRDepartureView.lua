local UIHSRDepartureView = BaseClass("UIHSRDepartureView", UIBaseView)
local FormationHeroItem = require("UI.UIFormation.UIFormationSelectListNew.Component.FormationHeroItem")
local HSRProgressComponent = require("UI.UIHSR.HSRProgressComponent")
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray

function UIHSRDepartureView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:Init()
end

function UIHSRDepartureView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIHSRDepartureView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnI = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnI:SetOnClick(function()
    self:OnBtnIClick()
  end)
  self.textSelectText1 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textUnselectText1 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 4)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.imgSelect2 = self.viewSkin:AddComponent(self, UIImage, 5)
  self.btnPanel = self.viewSkin:AddComponent(self, UIButton, 6)
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.textSelectText2 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.textUnselectText2 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.btnTabButton2 = self.viewSkin:AddComponent(self, UIButton, 9)
  self.btnTabButton2:SetOnClick(function()
    self:OnBtnTabButton2Click()
  end)
  self.imgSelect1 = self.viewSkin:AddComponent(self, UIImage, 10)
  self.btnTabButton1 = self.viewSkin:AddComponent(self, UIButton, 11)
  self.btnTabButton1:SetOnClick(function()
    self:OnBtnTabButton1Click()
  end)
  self.compPage1 = self.viewSkin:AddComponent(self, UIBaseComponent, 12)
  self.textRightBubbleTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 13)
  self.btnHistory = self.viewSkin:AddComponent(self, UIButton, 14)
  self.btnHistory:SetOnClick(function()
    self:OnBtnHistoryClick()
  end)
  self.imgRightBubble = self.viewSkin:AddComponent(self, UIImage, 15)
  self.textLeftBubbleTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 16)
  self.imgSlider = self.viewSkin:AddComponent(self, UIImage, 17)
  self.imgLeftBubble = self.viewSkin:AddComponent(self, UIImage, 18)
  self.compStations = self.viewSkin:AddComponent(self, UIBaseComponent, 19)
  self.animatorLeftItem = self.viewSkin:AddComponent(self, UICommonResItem, 20)
  self.animatorRightItem = self.viewSkin:AddComponent(self, UICommonResItem, 21)
  self.textVolume = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 22)
  self.textDescPage1 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 23)
  self.textHistory = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 24)
  self.compUISliderInputField = self.viewSkin:AddComponent(self, UISliderBtnInputField, 25)
  self.compUnlock = self.viewSkin:AddComponent(self, UIBaseComponent, 26)
  self.textRemindsTxt2 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 27)
  self.textHighPriceNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 28)
  self.textHighPriceTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 29)
  self.imgLock = self.viewSkin:AddComponent(self, UIImage, 30)
  self.compPage2 = self.viewSkin:AddComponent(self, UIBaseComponent, 31)
  self.compUIBtnInputField1 = self.viewSkin:AddComponent(self, UISliderBtnInputField, 32)
  self.textPrice = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 33)
  self.compUIBtnInputField2 = self.viewSkin:AddComponent(self, UISliderBtnInputField, 34)
  self.textCount = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 35)
  self.textDescPage2 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 36)
  self.btnGo = self.viewSkin:AddComponent(self, UIButton, 37)
  self.btnGo:SetOnClick(function()
    self:OnBtnGoClick()
  end)
  self.textBotTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 38)
  self.textBotDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 39)
  self.btnChangeHero = self.viewSkin:AddComponent(self, UIButton, 40)
  self.btnChangeHero:SetOnClick(function()
    self:OnBtnChangeHeroClick()
  end)
  self.heroList = self.viewSkin:AddComponent(self, UIBaseContainer, 41)
  self.progress = self:AddComponent(HSRProgressComponent, "Root/Content/Page2/Unlock/HSRProgress")
  self.progress:UseSliderMoveMode(true)
  self.stations = {}
  for i = 0, 10 do
    self.stations[i] = self:AddComponent(UIBaseComponent, "Root/Content/Page1/Progress/Bg/Stations/station" .. i)
  end
  self.cur_squad_text = self:AddComponent(UITextMeshProUGUIEx, "Root/Content/Bottom/ChangeHeroBtn/CurSquadBg/CurSquadText")
  self.textBotTitle:SetLocalText("457507")
  self.textSelectText1:SetLocalText("activity_1200044_tips10")
  self.textUnselectText1:SetLocalText("activity_1200044_tips10")
  self.textSelectText2:SetLocalText("activity_1200044_tips81")
  self.textUnselectText2:SetLocalText("activity_1200044_tips81")
  self.textHistory:SetLocalText("activity_1200044_tips78")
  self.textLeftBubbleTxt:SetLocalText("activity_1200044_tips46")
  self.textRightBubbleTxt:SetLocalText("activity_1200044_tips47")
  self.textHighPriceTxt:SetLocalText("activity_1200044_tips82")
  self.textPrice:SetLocalText("activity_1200044_tips86")
  self.textCount:SetLocalText("activity_1200044_tips87")
  self.textDescPage2:SetLocalText("activity_1200044_tips88")
  self.go_btn_txt = self:AddComponent(UITextMeshProUGUIEx, "Root/Content/Bottom/GoBtn/goBtnTxt")
  self.go_btn_txt:SetLocalText("activity_1200044_tips50")
  local maxSaleNumPerStation = DataCenter.HSRDataManager:GetMaxSaleNumPerStation()
  local count = DataCenter.HSRDataManager:GetConsignPrice()
  local str = Localization:GetString("activity_1200044_tips45", maxSaleNumPerStation)
  str = str .. "\n" .. Localization:GetString("activity_1200044_tips86") .. ":" .. count
  self.textDescPage1:SetText(str)
  self.animatorLeftItem:ReInit({
    rewardType = RewardType.GOODS,
    itemId = DataCenter.HSRDataManager:GetGoodsId()
  })
  self.animatorRightItem:ReInit({
    rewardType = RewardType.GOODS,
    itemId = DataCenter.HSRDataManager:GetGoldId()
  })
end

function UIHSRDepartureView:ComponentDestroy()
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
  self.viewSkin = nil
  self.btnI = nil
  self.textSelectText1 = nil
  self.textUnselectText1 = nil
  self.btnClose = nil
  self.imgSelect2 = nil
  self.btnPanel = nil
  self.textSelectText2 = nil
  self.textUnselectText2 = nil
  self.btnTabButton2 = nil
  self.imgSelect1 = nil
  self.btnTabButton1 = nil
  self.compPage1 = nil
  self.textRightBubbleTxt = nil
  self.btnHistory = nil
  self.imgRightBubble = nil
  self.textLeftBubbleTxt = nil
  self.imgSlider = nil
  self.imgLeftBubble = nil
  self.compStations = nil
  self.animatorLeftItem = nil
  self.animatorRightItem = nil
  self.textVolume = nil
  self.textDescPage1 = nil
  self.textHistory = nil
  self.compUISliderInputField = nil
  self.compUnlock = nil
  self.textRemindsTxt2 = nil
  self.textHighPriceNum = nil
  self.textHighPriceTxt = nil
  self.imgLock = nil
  self.compPage2 = nil
  self.compUIBtnInputField1 = nil
  self.textPrice = nil
  self.compUIBtnInputField2 = nil
  self.textCount = nil
  self.textDescPage2 = nil
  self.btnGo = nil
  self.textBotTitle = nil
  self.textBotDesc = nil
  self.btnChangeHero = nil
  self.compHeroList = nil
  self.compFormationContent = nil
  self.stations = {}
end

function UIHSRDepartureView:DataDefine()
  self.consignNum = DataCenter.HSRDataManager:GetGoodsCountCanConsign()
  self.dumpNum = DataCenter.HSRDataManager:GetGoodsCountInBag()
  self.dumpPrice = DataCenter.HSRDataManager:GetConsignPrice()
  self.formation = DataCenter.LWMyStationDataManager:GetMaxBattlePowerDefenceFormation()
  self.curDefenceFormationIndex = 1
  if self.formation and self.formation.index then
    self.curDefenceFormationIndex = self.formation.index
    DataCenter.LWMyStationDataManager.curDefenceSquadIndexInView = self.formation.index
  end
end

function UIHSRDepartureView:DataDestroy()
  DataCenter.LWMyStationDataManager.curDefenceSquadIndexInView = 1
  self.curDefenceFormationIndex = 1
end

function UIHSRDepartureView:OnEnable()
  base.OnEnable(self)
  self.curDefenceFormationIndex = DataCenter.LWMyStationDataManager.curDefenceSquadIndexInView
  self:RefreshAll()
end

function UIHSRDepartureView:OnDisable()
  base.OnDisable(self)
end

function UIHSRDepartureView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshTruckHero, self.RefreshSquad)
  self:AddUIListener(EventId.HSRGetOnSuccess, self.OnHSRGetOnSuccess)
end

function UIHSRDepartureView:OnRemoveListener()
  self:RemoveUIListener(EventId.RefreshTruckHero, self.RefreshSquad)
  self:RemoveUIListener(EventId.HSRGetOnSuccess, self.OnHSRGetOnSuccess)
  base.OnRemoveListener(self)
end

function UIHSRDepartureView:OnBtnIClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWHowToPlay, {anim = true}, {
    howToPlayList = {500008}
  })
end

function UIHSRDepartureView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function UIHSRDepartureView:OnBtnPanelClick()
  self.ctrl:CloseSelf()
end

function UIHSRDepartureView:OnBtnTabButton1Click()
  self.curPage = 1
  self.imgSelect1:SetActive(true)
  self.imgSelect2:SetActive(false)
  self.compPage1:SetActive(true)
  self.compPage2:SetActive(false)
  self:RefreshPageConsignment()
end

function UIHSRDepartureView:OnBtnTabButton2Click()
  self.curPage = 2
  self.imgSelect1:SetActive(false)
  self.imgSelect2:SetActive(true)
  self.compPage1:SetActive(false)
  self.compPage2:SetActive(true)
  self:RefreshPageDump()
end

function UIHSRDepartureView:OnBtnHistoryClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHSRStationHistorySimpleList, {anim = true})
end

function UIHSRDepartureView:OnBtnGoClick()
  local activityData = DataCenter.HSRDataManager:GetActivityData()
  if activityData and activityData.joinTimes <= 0 then
    UIUtil.ShowTipsId("server_train_insufficient_tips")
    return
  end
  local _, progress = DataCenter.HSRDataManager:GetDrivingProgress()
  local totalStationCount = DataCenter.HSRDataManager:GetStationCount()
  local getOnStation = math.ceil(progress)
  if getOnStation == totalStationCount then
    UIUtil.ShowTipsId("season_s5_zone_train_tips_2")
    return
  end
  if self.curPage == 1 then
    if self.consignNum > DataCenter.HSRDataManager:GetGoodsCountInBag() then
      UIUtil.ShowTipsId("120021")
      return
    end
    DataCenter.HSRDataManager:GetOnHSR(nil, self.consignNum, self.curDefenceFormationIndex)
  elseif not self.unlockTime then
    if self.dumpNum > DataCenter.HSRDataManager:GetGetOnCount() then
      UIUtil.ShowTipsId("server_train_insufficient_tips")
      local seq = CS.DG.Tweening.DOTween.Sequence()
      seq:Append(self.textBotDesc.transform:DOScale(Vector3(1.4, 1.5, 1), 0.2):SetEase(CS.DG.Tweening.Ease.InOutQuad))
      seq:Append(self.textBotDesc.transform:DOScale(Vector3(1, 1, 1), 0.3):SetEase(CS.DG.Tweening.Ease.InOutQuad))
      return
    end
    if self.dumpNum > DataCenter.HSRDataManager:GetGoodsCountInBag() then
      UIUtil.ShowTipsId("120021")
      return
    end
    DataCenter.HSRDataManager:GetOnHSR(self.dumpPrice, self.dumpNum, self.curDefenceFormationIndex)
  end
end

function UIHSRDepartureView:OnBtnChangeHeroClick()
  local param = {}
  param.curDefenceFormationIndex = self.curDefenceFormationIndex
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroPVPFormation, {anim = true}, EnterHeroSquadPanelWay.HSRDeparture, param)
end

function UIHSRDepartureView:Init()
  local maxSaleNumPerStation = DataCenter.HSRDataManager:GetMaxSaleNumPerStation()
  self.compUISliderInputField:Init(1, math.max(1, DataCenter.HSRDataManager:GetGoodsCountCanConsign()), self.consignNum, function(num)
    self.consignNum = num
    self.compUISliderInputField:SetTipText(num .. "/" .. DataCenter.HSRDataManager:GetGoodsCountInBag(), CS.TMPro.TextAlignmentOptions.Center)
    local count = DataCenter.HSRDataManager:GetConsignPrice()
    self.textVolume:SetText(toInt(num * count))
    self:RefreshPageConsignmentBubble()
  end)
  local minPrice, maxPrice = DataCenter.HSRDataManager:GetDumpPriceInterval()
  self.compUIBtnInputField1:Init(math.ceil(minPrice * self.dumpPrice), math.ceil(maxPrice * self.dumpPrice), self.dumpPrice, function(price)
    self.dumpPrice = toInt(price)
    self.compUIBtnInputField1:SetTipText(self.dumpPrice, CS.TMPro.TextAlignmentOptions.Center)
  end, toInt(self.dumpPrice / 5))
  local minNum, maxNum = DataCenter.HSRDataManager:GetDumpNumInterval()
  self.compUIBtnInputField2:Init(maxSaleNumPerStation * minNum, maxSaleNumPerStation * maxNum, self.dumpNum, function(num)
    self.dumpNum = toInt(num)
    self.compUIBtnInputField2:SetTipText(self.dumpNum .. "/" .. DataCenter.HSRDataManager:GetGoodsCountInBag(), CS.TMPro.TextAlignmentOptions.Center)
  end, toInt(maxSaleNumPerStation))
  self:OnBtnTabButton1Click()
  self:RefreshSquad()
  self.timer = TimerManager:GetInstance():DelayInvoke(function()
    if not DataCenter.HSRDataManager:IsDumpLock() then
      local shown = CommonUtil.PlayerPrefsGetBool(SettingKeys.HSR_DUMP_UNLOCK_PLOT, false)
      if self.btnTabButton2 and not shown then
        local param = {
          position = self.btnTabButton2.transform.position + Vector3(50, -50, 0),
          positionType = PositionType.Screen,
          isAutoClose = 3
        }
        DataCenter.ArrowManager:ShowFingerArrow(param)
        CommonUtil.PlayerPrefsSetBool(SettingKeys.HSR_DUMP_UNLOCK_PLOT, true)
      end
    end
  end, 0.5)
end

function UIHSRDepartureView:RefreshAll()
  if self.curPage == 1 then
    self:RefreshPageConsignment()
  elseif self.curPage == 2 then
    self:RefreshPageDump()
  end
  self:RefreshSquad()
end

function UIHSRDepartureView:RefreshPageConsignment()
  self.compUISliderInputField:SetMaxNum(math.max(1, DataCenter.HSRDataManager:GetGoodsCountCanConsign()))
  self.compUISliderInputField:SetCurNum(self.consignNum)
  self:RefreshPageConsignmentBubble()
end

function UIHSRDepartureView:RefreshPageConsignmentBubble()
  local _, progress = DataCenter.HSRDataManager:GetDrivingProgress()
  local totalStationCount = DataCenter.HSRDataManager:GetStationCount()
  self.imgSlider:SetFillAmount(progress / totalStationCount)
  local getOnStation = math.ceil(progress)
  if getOnStation == totalStationCount then
    UIGray.SetGray(self.btnGo.transform, true, false)
    self.imgLeftBubble:SetActive(false)
    self.imgRightBubble:SetActive(false)
  else
    UIGray.SetGray(self.btnGo.transform, false, true)
    self.imgLeftBubble:SetActive(true)
    self.imgRightBubble:SetActive(true)
  end
  self.imgLeftBubble:SetPosition(self.stations[getOnStation]:GetPosition())
  local maxSaleNumPerStation = DataCenter.HSRDataManager:GetMaxSaleNumPerStation()
  local getOffStation = getOnStation + math.ceil(self.consignNum / maxSaleNumPerStation)
  getOffStation = math.min(getOffStation, totalStationCount)
  self.imgRightBubble:SetPosition(self.stations[getOffStation]:GetPosition())
end

function UIHSRDepartureView:RefreshPageDump()
  local isLock = DataCenter.HSRDataManager:IsDumpLock()
  self.imgLock:SetActive(isLock)
  self.compUnlock:SetActive(not isLock)
  if isLock then
    self.unlockTime = isLock
    UIGray.SetGray(self.btnGo.transform, true, false)
    self:Update1000MS()
    return
  end
  self.unlockTime = nil
  UIGray.SetGray(self.btnGo.transform, false, true)
  local activityData = DataCenter.HSRDataManager:GetActivityData()
  if not activityData then
    Logger.LogError("UIHSRDepartureView:RefreshPageDump activityData is nil")
    return
  end
  self.textHighPriceNum:SetText(string.GetFormattedSeparatorNum(activityData.totalNum))
  local shown = CommonUtil.PlayerPrefsGetBool(SettingKeys.HSR_DUMP_HOWTOPLAY_PLOT, false)
  if not shown then
    EventManager:GetInstance():Broadcast(EventId.PlayPlotGroup, {plotGroupId = 9263, hideMainUI = false})
    CommonUtil.PlayerPrefsSetBool(SettingKeys.HSR_DUMP_HOWTOPLAY_PLOT, true)
  end
end

function UIHSRDepartureView:RefreshSquad()
  local activityData = DataCenter.HSRDataManager:GetActivityData()
  if activityData then
    self.textBotDesc:SetText(Localization:GetString("server_train_daily_sell_limit_7") .. activityData.joinTimes)
  end
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

function UIHSRDepartureView:ClearHeroList()
  self.heroList:RemoveComponents(FormationHeroItem)
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.model = {}
end

function UIHSRDepartureView:Update1000MS()
  if self.curPage == 1 then
    self:RefreshPageConsignment()
  elseif self.curPage == 2 and self.unlockTime then
    local now = UITimeManager:GetInstance():GetServerTime()
    local timeStr = UITimeManager:GetInstance():MilliSecondToFmtString(self.unlockTime - now)
    self.textRemindsTxt2:SetLocalText("activity_commander_tips2", timeStr)
  end
end

function UIHSRDepartureView:OnHSRGetOnSuccess()
  self.ctrl:CloseSelf()
end

return UIHSRDepartureView
