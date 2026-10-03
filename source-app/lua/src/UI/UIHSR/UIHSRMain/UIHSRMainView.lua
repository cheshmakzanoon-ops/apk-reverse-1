local UIHSRMainView = BaseClass("UIHSRMainView", UIBaseView)
local HSRProgressComponent = require("UI.UIHSR.HSRProgressComponent")
local ProfitFloatComponent = require("UI.UIHSR.UIHSRMain.ProfitFloatComponent")
local bubble2_path = "Root/Progress/Stations/station2/Bubble2"
local bubble_txt3_path = "Root/Progress/Stations/station3/Bubble3/BubbleTxt3"
local hori_path = "Root/Progress/Stations/station3/Bubble3/hori"
local bubble2_up_path = "Root/Progress/Stations/station2/Bubble2Up"
local bubble_txt2_up_path = "Root/Progress/Stations/station2/Bubble2Up/BubbleTxt2Up"
local bubble2_down_path = "Root/Progress/Stations/station2/Bubble2Down"
local bubble_txt2_down_path = "Root/Progress/Stations/station2/Bubble2Down/BubbleTxt2Down"
local bubble3_up_path = "Root/Progress/Stations/station3/Bubble3Up"
local bubble_txt3_up_path = "Root/Progress/Stations/station3/Bubble3Up/BubbleTxt3Up"
local bubble3_down_path = "Root/Progress/Stations/station3/Bubble3Down"
local bubble_txt3_down_path = "Root/Progress/Stations/station3/Bubble3Down/BubbleTxt3Down"
local bubble_num2_up_path = "Root/Progress/Stations/station2/Bubble2Up/hori/BubbleNum2Up"
local bubble_num2_down_path = "Root/Progress/Stations/station2/Bubble2Down/hori/BubbleNum2Down"
local bubble_num3_up_path = "Root/Progress/Stations/station3/Bubble3Up/hori/BubbleNum3Up"
local bubble_num3_down_path = "Root/Progress/Stations/station3/Bubble3Down/hori/BubbleNum3Down"
local bubble3_path = "Root/Progress/Stations/station3/Bubble3"
local intro_btn_path = "Root/IntroBtn"
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function UIHSRMainView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:Refresh()
  DataCenter.LWSoundManager:PlaySound(5100005, false)
  CommonUtil.PlayerPrefsSetLong(SettingKeys.LATEST_OPEN_HSR_MAIN_UI, UITimeManager:GetInstance():GetServerSeconds())
  if not DataCenter.HSRDataManager:IsDumpLock() then
    local shown = CommonUtil.PlayerPrefsGetBool(SettingKeys.HSR_DUMP_UNLOCK_PLOT, false)
    if not shown then
      EventManager:GetInstance():Broadcast(EventId.PlayPlotGroup, {
        plotGroupId = 9262,
        hideMainUI = false,
        callback = function()
          UIManager:GetInstance():OpenWindow(UIWindowNames.UIHSRDeparture, {anim = true})
        end
      })
    end
  end
end

function UIHSRMainView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIHSRMainView:OnEnable()
  base.OnEnable(self)
  self:PlayAnim(true)
end

function UIHSRMainView:OnDisable()
  base.OnDisable(self)
end

function UIHSRMainView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textProfitNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.textProfit = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textSold = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textRemain = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.btnGuide = self.viewSkin:AddComponent(self, UIButton, 5)
  self.btnGuide:SetOnClick(function()
    self:OnBtnGuideClick()
  end)
  self.btnRank = self.viewSkin:AddComponent(self, UIButton, 6)
  self.btnRank:SetOnClick(function()
    self:OnBtnRankClick()
  end)
  self.textNextTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.textNextStation = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.textHistory = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.btnSell = self.viewSkin:AddComponent(self, UIButton, 10)
  self.btnSell:SetOnClick(function()
    self:OnBtnSellClick()
  end)
  self.btnRob = self.viewSkin:AddComponent(self, UIButton, 11)
  self.btnRob:SetOnClick(function()
    self:OnBtnRobClick()
  end)
  self.btnStationHistory = self.viewSkin:AddComponent(self, UIButton, 12)
  self.btnStationHistory:SetOnClick(function()
    self:OnBtnStationHistoryClick()
  end)
  self.textRob = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 13)
  self.textSell = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 14)
  self.btnBack = self.viewSkin:AddComponent(self, UIButton, 15)
  self.btnBack:SetOnClick(function()
    self:OnBtnBackClick()
  end)
  self.textMyHistory = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 16)
  self.btnMyHistory = self.viewSkin:AddComponent(self, UIButton, 17)
  self.btnMyHistory:SetOnClick(function()
    self:OnBtnMyHistoryClick()
  end)
  self.textRobNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 18)
  self.compFloat = self.viewSkin:AddComponent(self, UIBaseContainer, 19)
  self.textGoods = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 20)
  self.btnAllHistory = self:AddComponent(UIButton, "Root/Bottom/BtnAllHistory")
  self.btnAllHistory:SetOnClick(function()
    self:OnBtnAllHistoryClick()
  end)
  self.btnRecord = self:AddComponent(UIButton, "Root/RightTop/BtnRecord")
  self.btnRecord:SetOnClick(function()
    self:OnBtnRecordClick()
  end)
  self.all_history_text = self:AddComponent(UITextMeshProUGUIEx, "Root/Bottom/BtnAllHistory/AllHistoryText")
  self.text_title = self:AddComponent(UITextMeshProUGUIEx, "Root/TitleBar/TextTitle")
  self.text_title:SetLocalText("activity_1200044_tips1")
  self.textSell:SetLocalText("activity_1200044_tips10")
  self.textRob:SetLocalText("activity_1200044_tips9")
  self.textMyHistory:SetLocalText("activity_1200044_tips15")
  self.all_history_text:SetLocalText("activity_1200044_tips15")
  self.textHistory:SetLocalText("activity_1200044_tips8")
  self.progress = self:AddComponent(HSRProgressComponent, "Root/Progress")
  self.anim = self:AddComponent(UIAnimator, "")
  self.bubble2 = self:AddComponent(UIImage, bubble2_path)
  self.bubble_txt3 = self:AddComponent(UITextMeshProUGUIEx, bubble_txt3_path)
  self.bubble3Hori = self:AddComponent(UIBaseContainer, hori_path)
  self.floatRoot = self:AddComponent(UIBaseContainer, "Root/Bottom/BtnMyHistory/FloatRoot")
  self.train = self:AddComponent(UIButton, "Root/Progress/Train")
  self.train:SetOnClick(function()
    RailwayUtil.JumpToHSR()
  end)
  self.bubble2_up = self:AddComponent(UIImage, bubble2_up_path)
  self.bubble_txt2_up = self:AddComponent(UITextMeshProUGUIEx, bubble_txt2_up_path)
  self.bubble_txt2_up:SetLocalText("server_train_sell_limit_4")
  self.bubble2_down = self:AddComponent(UIImage, bubble2_down_path)
  self.bubble_txt2_down = self:AddComponent(UITextMeshProUGUIEx, bubble_txt2_down_path)
  self.bubble_txt2_down:SetLocalText("activity_1200044_tips85")
  self.bubble3_up = self:AddComponent(UIImage, bubble3_up_path)
  self.bubble_txt3_up = self:AddComponent(UITextMeshProUGUIEx, bubble_txt3_up_path)
  self.bubble_txt3_up:SetLocalText("server_train_sell_limit_4")
  self.bubble3_down = self:AddComponent(UIImage, bubble3_down_path)
  self.bubble_txt3_down = self:AddComponent(UITextMeshProUGUIEx, bubble_txt3_down_path)
  self.bubble_txt3_down:SetLocalText("activity_1200044_tips85")
  self.bubble3 = self:AddComponent(UIImage, bubble3_path)
  self.bubble_num2_up = self:AddComponent(UITextMeshProUGUIEx, bubble_num2_up_path)
  self.bubble_num2_down = self:AddComponent(UITextMeshProUGUIEx, bubble_num2_down_path)
  self.bubble_num3_up = self:AddComponent(UITextMeshProUGUIEx, bubble_num3_up_path)
  self.bubble_num3_down = self:AddComponent(UITextMeshProUGUIEx, bubble_num3_down_path)
  self.intro_btn = self:AddComponent(UIButton, intro_btn_path)
  self.intro_btn:SetOnClick(function()
    local param = {
      activityRulesStr = Localization:GetString("server_train_station_rule")
    }
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetail, {anim = true}, param)
  end)
end

function UIHSRMainView:ComponentDestroy()
  self.viewSkin = nil
  self.textProfitNum = nil
  self.textProfit = nil
  self.textSold = nil
  self.textRemain = nil
  self.btnGuide = nil
  self.btnRank = nil
  self.textNextTime = nil
  self.textNextStation = nil
  self.textHistory = nil
  self.btnSell = nil
  self.btnRob = nil
  self.btnStationHistory = nil
  self.textRob = nil
  self.textSell = nil
  self.btnBack = nil
  self.textMyHistory = nil
  self.btnMyHistory = nil
  self.textRobNum = nil
  self.compFloat = nil
  self.textGoods = nil
end

function UIHSRMainView:DataDefine()
  DataCenter.HSRDataManager:FetchActivityData()
end

function UIHSRMainView:DataDestroy()
end

function UIHSRMainView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.HSRActivityDataRefresh, self.Refresh)
  self:AddUIListener(EventId.HSRGetOnSuccess, self.HSRGetOnSuccess)
  self:AddUIListener(EventId.HSRPersonalHistoryDetailRefresh, self.HandlePersonalHistoryData)
end

function UIHSRMainView:OnRemoveListener()
  self:RemoveUIListener(EventId.HSRActivityDataRefresh, self.Refresh)
  self:RemoveUIListener(EventId.HSRGetOnSuccess, self.HSRGetOnSuccess)
  self:RemoveUIListener(EventId.HSRPersonalHistoryDetailRefresh, self.HandlePersonalHistoryData)
  base.OnRemoveListener(self)
end

function UIHSRMainView:OnBtnGuideClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHSRPersonalHistoryList, {anim = true})
end

function UIHSRMainView:OnBtnRecordClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWHowToPlay, {anim = true}, {
    howToPlayList = {500008}
  })
end

function UIHSRMainView:OnBtnRankClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHSRRank, {anim = true}, {
    titleText = {
      "activity_1200044_tips73",
      "activity_1200044_tips72"
    },
    toggleTextList = {
      "activity_1200044_tips73",
      "activity_1200044_tips72"
    },
    rankTitleList = {
      {
        "100184",
        "activity_1200044_tips83"
      },
      {
        "100184",
        "activity_1200044_tips87"
      }
    },
    bottomDesc = "302316"
  })
end

function UIHSRMainView:OnBtnSellClick()
  local _, progress = DataCenter.HSRDataManager:GetDrivingProgress()
  local totalStationCount = DataCenter.HSRDataManager:GetStationCount()
  local getOnStation = math.ceil(progress)
  if getOnStation == totalStationCount then
    UIUtil.ShowTipsId("season_s5_zone_train_tips_2")
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHSRDeparture, {anim = true})
end

function UIHSRMainView:OnBtnRobClick()
  RailwayUtil.JumpToHSR()
end

function UIHSRMainView:OnBtnStationHistoryClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHSRStationHistorySimpleList, {anim = true})
end

function UIHSRMainView:OnBtnBackClick()
  self.ctrl:CloseSelf()
end

function UIHSRMainView:OnBtnMyHistoryClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHSRPersonalHistoryDetail, {anim = true})
end

function UIHSRMainView:OnBtnAllHistoryClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHSRPersonalHistoryList, {anim = true})
end

function UIHSRMainView:Update1000MS()
  self.bubble2:SetActive(false)
  self.bubble3:SetActive(false)
  self.bubble2_up:SetActive(false)
  self.bubble2_down:SetActive(false)
  self.bubble3_up:SetActive(false)
  self.bubble3_down:SetActive(false)
  if self.nextTime then
    local now = UITimeManager:GetInstance():GetServerTime()
    if now < self.nextTime then
      local restTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(self.nextTime - now)
      local nextTime, progress = DataCenter.HSRDataManager:GetDrivingProgress()
      if progress <= 0 then
        self.textNextTime:SetLocalText("activity_1200044_tips12", restTimeStr)
      else
        self.textNextTime:SetLocalText("activity_1200044_tips5", restTimeStr)
      end
    else
      TimerManager:GetInstance():DelayInvoke(function()
        DataCenter.HSRDataManager:FetchActivityData()
      end, 5)
      self.nextTime = nil
    end
  elseif self.countDown then
    local now = UITimeManager:GetInstance():GetServerTime()
    if now < self.countDown then
      local restTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(self.countDown - now)
      self.textNextTime:SetText(Localization:GetString("activity_1200044_tips100") .. restTimeStr)
    else
      TimerManager:GetInstance():DelayInvoke(function()
        DataCenter.HSRDataManager:FetchActivityData()
      end, 5)
      self.countDown = nil
    end
  end
  local activityData = DataCenter.HSRDataManager:GetActivityData()
  if not activityData then
    return
  end
  if not DataCenter.HSRDataManager:GetHSRData() then
    return
  end
  local sellingState = DataCenter.HSRDataManager:GetSellingState()
  if sellingState == HSRSellState.Loading then
    self.bubble2:SetActive(true)
    self.bubble3:SetActive(true)
    self.bubble3Hori:SetActive(false)
    self.bubble_txt3:SetLocalText("activity_1200044_tips101")
  elseif activityData.buyMaxNumList and activityData.expectBuyNum then
    local curExpectBuyNum = activityData.expectBuyNum.curExpectBuyNum
    if curExpectBuyNum and curExpectBuyNum.expectBuyNum then
      self.bubble2_up:SetActive(true)
      self.bubble_num2_up:SetText(curExpectBuyNum.expectBuyNum)
      local nextStationId = curExpectBuyNum.stationId
      for _, v in pairs(activityData.buyMaxNumList) do
        if v.station == nextStationId then
          self.bubble2_down:SetActive(true)
          self.bubble_num2_down:SetText(v.buyMaxNum)
          break
        end
      end
    end
    local nextExpectBuyNum = activityData.expectBuyNum.nextExpectBuyNum
    if nextExpectBuyNum and nextExpectBuyNum.expectBuyNum then
      self.bubble3_up:SetActive(true)
      self.bubble_num3_up:SetText(nextExpectBuyNum.expectBuyNum)
      local nextStationId = nextExpectBuyNum.stationId
      for _, v in pairs(activityData.buyMaxNumList) do
        if v.station == nextStationId then
          self.bubble3_down:SetActive(true)
          self.bubble_num3_down:SetText(v.buyMaxNum)
          break
        end
      end
    end
  end
end

function UIHSRMainView:Refresh()
  self:PlayAnim()
  self.textNextTime:SetText("")
  self.nextTime = nil
  self.countDown = nil
  local activityData = DataCenter.HSRDataManager:GetActivityData()
  if not activityData then
    Logger.LogWarning("UIHSRMainView:RefreshProgress activityData is nil")
    self.progress:SetActive(false)
    self.btnRob:SetActive(false)
    self.btnSell:SetActive(false)
    self.btnMyHistory:SetActive(false)
    self.btnAllHistory:SetActive(false)
    self.btnStationHistory:SetActive(false)
    return
  end
  self.btnStationHistory:SetActive(true)
  local lastGetOnHSRUuid = CommonUtil.PlayerPrefsGetLong(SettingKeys.HSR_GET_ON_SUCCESS, 0)
  if DataCenter.HSRDataManager:GetHSRData() == nil then
    self.textNextStation:SetLocalText("activity_1200044_tips99")
    if activityData.nextTrainTime and 0 < activityData.nextTrainTime then
      self.countDown = activityData.nextTrainTime
      self:Update1000MS()
    end
    self.progress:SetActive(false)
    self.btnRob:SetActive(false)
    self.textRobNum:SetText("")
    self.btnSell:SetActive(false)
    self.btnMyHistory:SetActive(false)
    self.btnAllHistory:SetActive(true)
    if lastGetOnHSRUuid ~= 0 then
      CommonUtil.PlayerPrefsSetLong(SettingKeys.HSR_GET_ON_SUCCESS, 0)
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIHSRPersonalHistoryDetail, {anim = true}, lastGetOnHSRUuid)
    end
    return
  end
  self.progress:SetActive(true)
  local _, _, _, state = DataCenter.HSRDataManager:GetCurPosition()
  if state == TrainState.Travelling then
    self.btnRob:SetActive(true)
    self.textRobNum:SetLocalText("activity_1200044_tips70", activityData.lootTimes or 0)
    self.btnSell:SetAnchoredPositionXY(190, 135)
    self.btnMyHistory:SetAnchoredPositionXY(190, 135)
  else
    self.btnRob:SetActive(false)
    self.textRobNum:SetText("")
    self.btnSell:SetAnchoredPositionXY(0, 135)
    self.btnMyHistory:SetAnchoredPositionXY(0, 135)
  end
  if lastGetOnHSRUuid ~= 0 and (lastGetOnHSRUuid == DataCenter.HSRDataManager:GetCurHSRUuid() and state == TrainState.ArrivedFinal or lastGetOnHSRUuid ~= DataCenter.HSRDataManager:GetCurHSRUuid()) then
    CommonUtil.PlayerPrefsSetLong(SettingKeys.HSR_GET_ON_SUCCESS, 0)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHSRPersonalHistoryDetail, {anim = true}, lastGetOnHSRUuid)
  end
  self.btnAllHistory:SetActive(false)
  local nextTime, progress = DataCenter.HSRDataManager:GetDrivingProgress()
  self.nextTime = nextTime
  self:Update1000MS()
  local getOnStationIndex = math.ceil(progress) + 1
  local getOnStation = activityData.buyMaxNumList[getOnStationIndex]
  if progress <= 0 then
    self.textNextStation:SetLocalText("server_train_ui_title_start")
  else
    self.textNextStation:SetLocalText("activity_1200044_tips4", UIUtil.FormatServerName(getOnStation.serverId))
  end
  local sellingState = DataCenter.HSRDataManager:GetSellingState()
  if sellingState == HSRSellState.Unboard then
    self.btnSell:SetActive(true)
    self.btnMyHistory:SetActive(false)
  else
    self.btnSell:SetActive(false)
    self.btnMyHistory:SetActive(true)
    if activityData.uuid then
      DataCenter.HSRDataManager:FetchMyHistoryByTrain(activityData.uuid)
    end
  end
  self.textGoods:SetText(activityData.remainNum)
  if activityData.passengerInfo then
    self.textRemain:SetLocalText("activity_1200044_tips20", activityData.passengerInfo.remainNum, activityData.passengerInfo.totalNum)
    self.textSold:SetLocalText("activity_1200044_tips17", activityData.passengerInfo.sellNum)
    self.textProfit:SetLocalText("activity_1200044_tips18", "")
    self.textProfitNum:SetText(string.GetFormattedSeparatorNum(activityData.passengerInfo.profit))
  else
    self.textRemain:SetText("")
    self.textSold:SetText("")
    self.textProfit:SetText("")
    self.textProfitNum:SetText("")
  end
end

function UIHSRMainView:HandlePersonalHistoryData(uuid)
  local activityData = DataCenter.HSRDataManager:GetActivityData()
  if not (activityData and activityData.uuid) or activityData.uuid ~= uuid then
    return
  end
  local hisData = DataCenter.HSRDataManager:GetMyHistoryByUuid(uuid)
  if not hisData or not hisData.trade then
    return
  end
  local data = hisData.trade
  if data.sellNum > 0 then
    local lastProfitData = Setting:GetPrivateString("HSR_PROFIT_FLY_TEXT", "0,0,0")
    lastProfitData = string.split(lastProfitData, ",")
    if #lastProfitData == 3 then
      local lastUuid = tonumber(lastProfitData[1])
      local lastSoldNum = tonumber(lastProfitData[2])
      local lastProfit = tonumber(lastProfitData[3])
      if uuid ~= lastUuid then
        lastSoldNum = 0
        lastProfit = 0
      end
      if lastSoldNum < data.sellNum then
        self:ShowFlyText(data.sellNum - lastSoldNum, data.profit - lastProfit)
        local str = uuid .. "," .. data.sellNum .. "," .. data.profit
        Setting:SetPrivateString("HSR_PROFIT_FLY_TEXT", str)
      end
    end
  end
end

function UIHSRMainView:ShowFlyText(soldNum, profit)
  UIUtil.ShowFloatAnim(self.floatRoot, "Assets/Main/SeasonRes/S5/Prefabs/UI/HSR/ProfitFloat.prefab", Vector2.zero, ProfitFloatComponent, {soldNum = soldNum, profit = profit})
end

function UIHSRMainView:PlayAnim(isForce)
  local sellingState = DataCenter.HSRDataManager:GetSellingState()
  local animState = (sellingState == HSRSellState.Selling or sellingState == HSRSellState.Loading) and CarriagePos.Carriage or CarriagePos.Locomotive
  if not isForce and animState == self.animState then
    return
  end
  self.animState = animState
  if animState == CarriagePos.Carriage then
    if CommonUtil.ArabicAutoMirrorFactor() > 0 then
      self.anim:Play("V_ui_UIHSRMain_switch", 0, 0)
    else
      self.anim:Play("V_ui_UIHSRMain_switch_flip", 0, 0)
    end
  elseif CommonUtil.ArabicAutoMirrorFactor() > 0 then
    self.anim:Play("V_ui_UIHSRMain_in", 0, 0)
  else
    self.anim:Play("V_ui_UIHSRMain_in_flip", 0, 0)
  end
end

function UIHSRMainView:HSRGetOnSuccess()
end

return UIHSRMainView
