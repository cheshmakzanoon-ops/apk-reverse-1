local UILWTrainSceneView = BaseClass("UILWTrainSceneView", UIBaseView)
local base = UIBaseView
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local TrainInfoPanel = require("UI.UILWRailway.UILWTrainScene.Component.TrainInfoPanel")
local TrainTouchItem = require("UI.UILWRailway.UILWTrainScene.Component.TrainTouchItem")
local MyStationBtn = require("UI.UILWRailway.UILWTrainScene.Component.MyStationBtn")
local DepartureBtn = require("UI.UILWRailway.UILWTrainScene.Component.DepartureBtn")
local RenderTextureFormat = CS.UnityEngine.RenderTextureFormat
local RenderTexture = CS.UnityEngine.RenderTexture
local TRAIN_TAB_NUM = 2
local Tab2Name = {
  [TrainTab.Mine] = "457516",
  [TrainTab.Enemy] = "457515",
  [TrainTab.Ally] = "457516"
}
local ADD_DEPARTURE_COUNT = 130005200
local super_departure_btn_path = "Root/Middle/SuperDepartureBtn"
local super_departure_btn_text_path = "Root/Middle/SuperDepartureBtn/SuperDepartureBtnText"
local btn_truck_insurance_path = "Root/Middle/BtnTruckInsurance"
local truck_insurance_ren_point_path = "Root/Middle/BtnTruckInsurance/TruckInsuranceRenPoint"
local btn_truck_insurance_desc_path = "Root/Middle/BtnTruckInsurance/BtnTruckInsuranceDesc"
local full_reward_tips_path = "Root/Middle/BtnTruckInsurance/FullRewardTips"
local full_reward_desc_path = "Root/Middle/BtnTruckInsurance/FullRewardTips/FullRewardDesc"

function UILWTrainSceneView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWTrainSceneView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWTrainSceneView:ComponentDefine()
  self.closeBtn = self:AddComponent(UIButton, "Root/BottomBar/BtnBack")
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.robImage = self:AddComponent(UIBaseComponent, "Root/Top/titleBg/RobImage")
  self.titleText = self:AddComponent(UIText, "Root/Top/titleBg/SubTitle")
  self.addBtn = self:AddComponent(UIButton, "Root/Top/titleBg/BtnAdd")
  self.addBtn:SetOnClick(function()
    self:OnClickAdd()
  end)
  self.leftBtn = self:AddComponent(UIButton, "Root/Middle/Info/LeftArrow")
  self.leftBtn:SetOnClick(function()
    self:OnClickLeft()
  end)
  self.rightBtn = self:AddComponent(UIButton, "Root/Middle/Info/RightArrow")
  self.rightBtn:SetOnClick(function()
    self:OnClickRight()
  end)
  self.refreshBtn = self:AddComponent(UIButton, "Root/Top/BtnRefresh")
  self.refreshBtn:SetOnClick(function()
    self:OnClickRefresh()
  end)
  self.historyBtn = self:AddComponent(UIButton, "Root/Top/BtnHistory")
  self.historyBtn:SetOnClick(function()
    self:OnClickHistory()
  end)
  self.goToScienceBtn = self:AddComponent(UIButton, "Root/Top/titleBg/GoToScienceBtn")
  self.goToScienceBtn:SetOnClick(function()
    self:GoToScienceBtnClick()
  end)
  self.sceneRawImg = self:AddComponent(UIRawImage, "Scene")
  self.infoPanel = self:AddComponent(TrainInfoPanel, "Root/Middle/Info")
  self.infoPanel:SetActive(false)
  self.touchContent = self:AddComponent(UIBaseContainer, "Root/Middle/Touch")
  self.NoTrain = self:AddComponent(UIBaseComponent, "Root/Middle/NoTrain")
  self.myStationBtn = {}
  for i = 1, 4 do
    self.myStationBtn[i] = self:AddComponent(MyStationBtn, "Root/Middle/Slot/MyStationBtn" .. i)
  end
  self.exhausted = self:AddComponent(UIBaseComponent, "Root/Middle/Slot/exhausted")
  self.slot = self:AddComponent(UIBaseComponent, "Root/Middle/Slot")
  self.slot:SetActive(false)
  self.tabSelectGo = {}
  self.tabTxt = {}
  self.tabClickBtn = {}
  self.tabRedPointBg = {}
  self.tabRedPointNumText = {}
  for i = 1, TRAIN_TAB_NUM do
    local tab_path = "Root/BottomBar/Tab/TabItem" .. i
    self.tabSelectGo[i] = self:AddComponent(UIBaseContainer, tab_path .. "/Condition" .. i .. "Select")
    self.tabTxt[i] = self:AddComponent(UIText, tab_path .. "/Condition" .. i .. "Txt")
    self.tabTxt[i]:SetLocalText(Tab2Name[i])
    local tabSelectTxt = self:AddComponent(UIText, tab_path .. "/Condition" .. i .. "Select/Condition" .. i .. "SelectTxt")
    tabSelectTxt:SetLocalText(Tab2Name[i])
    self.tabClickBtn[i] = self:AddComponent(UIButton, tab_path)
    self.tabClickBtn[i]:SetOnClick(function()
      self:OnTabClick(i)
    end)
    self.tabRedPointBg[i] = self:AddComponent(UIImage, string.format("%s/RedPointBg%d", tab_path, i))
    self.tabRedPointNumText[i] = self:AddComponent(UIText, string.format("%s/RedPointBg%d/RedPointText%d", tab_path, i, i))
  end
  self.blockToggle = self:AddComponent(UIToggle, "Root/Top/backToggle")
  self.blockToggle:SetOnValueChanged(function(isOn)
    if isOn and (LuaEntry.Player:GetUserSetting(UserSettingKey.TrainBlockOwnServer) == nil or LuaEntry.Player:GetUserSetting(UserSettingKey.TrainBlockOwnServer) == "0") then
      SFSNetwork.SendMessage(MsgDefines.UserSetting, UserSettingKey.TrainBlockOwnServer, "1")
    elseif not isOn and LuaEntry.Player:GetUserSetting(UserSettingKey.TrainBlockOwnServer) == "1" then
      SFSNetwork.SendMessage(MsgDefines.UserSetting, UserSettingKey.TrainBlockOwnServer, "0")
    end
  end)
  self.blockToggle:SetIsOn(LuaEntry.Player:GetUserSetting(UserSettingKey.TrainBlockOwnServer) == "1")
  self.blockToggleText = self:AddComponent(UIText, "Root/Top/backToggle/toggleText")
  self.blockToggleText:SetLocalText("truck_tips10006")
  local openDay = DataCenter.LWMyStationDataManager:GetMeta(37)
  if openDay and UITimeManager:GetInstance().GetServerOpenDays() >= tonumber(openDay) then
    self.blockToggle:SetActive(true)
  else
    self.blockToggle:SetActive(false)
  end
  self.multiRewardTipObj = self:AddComponent(UIBaseContainer, "Root/BottomBar/MultiRewardTipArea")
  self.multiRewardBottomTipObj = self:AddComponent(UIBaseContainer, "Root/Middle/MultiRewardTipBottomArea")
  self.super_departure_btn = self:TryAddComponent(UIButton, super_departure_btn_path)
  self.super_departure_btn_text = self:TryAddComponent(UITextMeshProUGUIEx, super_departure_btn_text_path)
  if self.super_departure_btn_text then
    self.super_departure_btn_text:SetLocalText("super_trucklaunch_btn01")
  end
  if self.super_departure_btn then
    self.super_departure_btn:SetOnClick(function()
      self:OnSuperDepartureBtnClick()
    end)
    local isOpen, isGray = self:IsShowSuperTruckDeparture()
    self.super_departure_btn:SetActive(isOpen)
    if isOpen then
      CS.UIGray.SetGray(self.super_departure_btn.transform, isGray, true)
    end
  end
  self.btn_truck_insurance = self:AddComponent(UIButton, btn_truck_insurance_path)
  self.btn_truck_insurance:SetOnClick(function()
    self:OnClickTruckInsurance()
  end)
  self.truck_insurance_ren_point = self:AddComponent(UIBaseContainer, truck_insurance_ren_point_path)
  self.btn_truck_insurance_desc = self:AddComponent(UITextMeshProUGUIEx, btn_truck_insurance_desc_path)
  self.full_reward_tips = self:AddComponent(UIBaseContainer, full_reward_tips_path)
  self.full_reward_desc = self:AddComponent(UITextMeshProUGUIEx, full_reward_desc_path)
end

function UILWTrainSceneView:ComponentDestroy()
  self:RemoveAllTouchItem()
  self.closeBtn = nil
  self.titleText = nil
  for i = 1, TRAIN_TAB_NUM do
    self.tabSelectGo[i] = nil
    self.tabClickBtn[i] = nil
  end
  self.tabTxt = nil
  self.tabSelectGo = nil
  self.tabClickBtn = nil
  self.tabRedPointBg = nil
  self.tabRedPointNumText = nil
  self.infoPanel = nil
  if self.renderTexture ~= nil then
    RenderTexture.ReleaseTemporary(self.renderTexture)
    self.renderTexture = nil
  end
  self.super_departure_btn = nil
  self.super_departure_btn_text = nil
  self.btn_truck_insurance = nil
  self.truck_insurance_ren_point = nil
  self.btn_truck_insurance_desc = nil
  self.full_reward_tips = nil
  self.full_reward_desc = nil
end

function UILWTrainSceneView:DataDefine()
  self.curTab = nil
end

function UILWTrainSceneView:DataDestroy()
  self.curTab = nil
end

function UILWTrainSceneView:Init()
  local gotoPage, buildUuid = self:GetUserData()
  if self.curTab then
    self:OnTabClick(self.curTab)
  elseif gotoPage then
    self:OnTabClick(gotoPage)
    if buildUuid then
      if gotoPage == TrainTab.Mine then
        self:DelayJumpToMyTrain(buildUuid)
      elseif gotoPage == TrainTab.Enemy then
        self:DelayJumpToEnemyTrain(buildUuid)
      end
    end
  else
    self:OnTabClick(TrainTab.Enemy)
  end
  self:RefreshRedPoint()
  self:RefreshMyTruck()
  if self.renderTexture == nil then
    local rtFormat = RenderTextureFormat.ARGB32
    self.renderTexture = RenderTexture.GetTemporary(Screen.width, Screen.height, 24, rtFormat)
    self.renderTexture.name = "SkillPreviewRT"
    self.sceneRawImg:SetTexture(self.renderTexture)
    self.sceneRawImg:SetEnable(true)
    self.sceneRawImg:SetColor(Color.white)
  end
  DataCenter.TrainSceneManager:Enter({
    trainTab = self.curTab
  })
end

function UILWTrainSceneView:UnInit()
  DataCenter.TrainSceneManager:Exit()
end

function UILWTrainSceneView:OnEnable()
  base.OnEnable(self)
  self:Init()
end

function UILWTrainSceneView:OnDisable()
  base.OnDisable(self)
  self:UnInit()
end

function UILWTrainSceneView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.TrainSceneCameraInitFinish, self.OnTrainSceneInitFinish)
  self:AddUIListener(EventId.TrainPlaceFinish, self.OnTrainPlaceFinish)
  self:AddUIListener(EventId.RefreshMyTruck, self.RefreshMyTruck)
  self:AddUIListener(EventId.UPDATE_SCIENCE_DATA, self.OnUpdateScienceData)
  self:AddUIListener(EventId.UserSettingChanged, self.RefreshBlockToggle)
  self:AddUIListener(EventId.CheckMyTrainRefreshReceived, self.OnCheckMyTrainRefreshReceived)
  self:AddUIListener(EventId.GetTruckInsuranceReward, self.RefreshTruckInsuranceBtn)
  self:AddUIListener(EventId.RefreshTruckInsuranceRefundPage, self.RefreshTruckInsuranceBtn)
  self:AddUIListener(EventId.MonthCardInfoUpdated, self.RefreshTruckInsuranceBtn)
end

function UILWTrainSceneView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.TrainSceneCameraInitFinish, self.OnTrainSceneInitFinish)
  self:RemoveUIListener(EventId.TrainPlaceFinish, self.OnTrainPlaceFinish)
  self:RemoveUIListener(EventId.RefreshMyTruck, self.RefreshMyTruck)
  self:RemoveUIListener(EventId.UPDATE_SCIENCE_DATA, self.OnUpdateScienceData)
  self:RemoveUIListener(EventId.UserSettingChanged, self.RefreshBlockToggle)
  self:RemoveUIListener(EventId.CheckMyTrainRefreshReceived, self.OnCheckMyTrainRefreshReceived)
  self:RemoveUIListener(EventId.GetTruckInsuranceReward, self.RefreshTruckInsuranceBtn)
  self:RemoveUIListener(EventId.RefreshTruckInsuranceRefundPage, self.RefreshTruckInsuranceBtn)
  self:RemoveUIListener(EventId.MonthCardInfoUpdated, self.RefreshTruckInsuranceBtn)
end

function UILWTrainSceneView:OnTrainSceneInitFinish()
  if self.renderTexture ~= nil then
    local camera = DataCenter.TrainSceneManager.camera
    camera.targetTexture = self.renderTexture
    local height = self.sceneRawImg.rectTransform.rect.height
    camera.orthographicSize = height * 0.01
    if height > DefaultScreenHeight then
      DataCenter.TrainSceneManager:FixRow(math.floor((height / DefaultScreenHeight - 1) * 10))
    else
      DataCenter.TrainSceneManager:FixRow(0)
    end
  end
end

function UILWTrainSceneView:OnTrainPlaceFinish(trainList)
  self.trainList = trainList
  self.NoTrain:SetActive(#trainList <= 0 and self.curTab ~= TrainTab.Mine)
  self:RemoveAllTouchItem()
  for i = 1, #trainList do
    local prefabPath = trainList[i].trainData.type == TrainType.Train and "Assets/Main/Prefabs/UI/UILWRailway/TrainTouchItem.prefab" or "Assets/Main/Prefabs/UI/UILWRailway/TruckTouchItem.prefab"
    self.touchItemReqs[i] = self:GameObjectInstantiateAsync(prefabPath, function(req)
      if IsNull(req.gameObject) then
        return
      end
      local go = req.gameObject
      local transform = go.transform
      go:SetActive(true)
      transform:SetParent(self.touchContent.transform)
      transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      local nameStr = tostring(NameCount)
      go.name = nameStr
      NameCount = NameCount + 1
      local item = self.touchContent:AddComponent(TrainTouchItem, nameStr)
      item:Refresh(self.trainList[i])
    end)
  end
  self:RefreshRedPoint()
  if self.curTab == TrainTab.Mine then
    for i = 1, 4 do
      self.myStationBtn[i]:SetActive(true)
      self.myStationBtn[i]:SetData(i)
      local trainWorldPos = DataCenter.TrainSceneManager:GetMyTrainWorldPos(i)
      local screenPos = DataCenter.TrainSceneManager:GetTouchItemScreenPos(trainWorldPos)
      local worldPos = CS.GameEntry.UICamera:ScreenToWorldPoint(Vector3(screenPos.x, screenPos.y, 1))
      self.myStationBtn[i]:SetPosition(worldPos)
    end
    for i = 1, #trainList do
      local index = trainList[i].trainData.index
      if index then
        self.myStationBtn[index]:SetActive(false)
      end
    end
  end
end

function UILWTrainSceneView:RemoveAllTouchItem()
  self.touchContent:RemoveComponents(TrainTouchItem)
  if self.touchItemReqs then
    for _, v in pairs(self.touchItemReqs) do
      v:Destroy()
    end
  end
  self.touchItemReqs = {}
end

function UILWTrainSceneView:OnTabClick(tab)
  if self.curTab == tab then
    return
  end
  self:DeSelectTrain()
  self.curTab = tab
  for i = 1, TRAIN_TAB_NUM do
    self.tabSelectGo[i]:SetActive(i == tab)
    self.tabTxt[i]:SetActive(i ~= tab)
  end
  EventManager:GetInstance():Broadcast(EventId.TrainTabChange, tab)
  self.slot:SetActive(tab == TrainTab.Mine)
  self.refreshBtn:SetActive(tab == TrainTab.Enemy)
  self.robImage:SetActive(tab == TrainTab.Enemy)
  if tab == TrainTab.Mine then
    local cur, max = DataCenter.LWMyStationDataManager:GetDepartureCount()
    self.titleText:SetText(Localization:GetString(457565) .. ": " .. cur .. "/" .. max)
    self.exhausted:SetActive(max <= cur)
    self:RefreshScienceBtnState()
    if self.super_departure_btn then
      local isOpen, isGray = self:IsShowSuperTruckDeparture()
      self.super_departure_btn:SetActive(isOpen)
      CS.UIGray.SetGray(self.super_departure_btn.transform, isGray, true)
    end
  elseif tab == TrainTab.Enemy then
    local cur, max = DataCenter.LWMyStationDataManager:GetRobCount()
    self.titleText:SetText(Localization:GetString(457510) .. ": " .. cur .. "/" .. max)
    self.goToScienceBtn:SetActive(false)
    if self.super_departure_btn then
      self.super_departure_btn:SetActive(false)
    end
  end
  self:RefreshTruckInsuranceBtn()
end

function UILWTrainSceneView:RefreshMyTruck()
  if self.curTab == TrainTab.Mine then
    local cur, max = DataCenter.LWMyStationDataManager:GetDepartureCount()
    self.titleText:SetText(Localization:GetString(457565) .. ": " .. cur .. "/" .. max)
    self.exhausted:SetActive(max <= cur)
    if self.super_departure_btn then
      local isOpen, isGray = self:IsShowSuperTruckDeparture()
      self.super_departure_btn:SetActive(isOpen)
      CS.UIGray.SetGray(self.super_departure_btn.transform, isGray, true)
    end
  end
end

function UILWTrainSceneView:RefreshRedPoint()
  for i = 1, TRAIN_TAB_NUM do
    local count = 0
    if i == TrainTab.Enemy then
      local cur, max = DataCenter.LWMyStationDataManager:GetRobCount()
      count = max - cur
    elseif i == TrainTab.Mine then
      count = DataCenter.LWMyStationDataManager:GetRealReadyCountPlusRewardCount()
    end
    self.tabRedPointBg[i]:SetActive(0 < count)
    self.tabRedPointNumText[i]:SetText(count)
  end
end

function UILWTrainSceneView:RefreshTruckInsuranceBtn()
  local isOpenTruckInsurance = DataCenter.MonthCardNewManager:IsOpenTruckInsurance()
  self.btn_truck_insurance:SetActive(isOpenTruckInsurance and self.curTab == TrainTab.Mine)
  if not isOpenTruckInsurance or self.curTab ~= TrainTab.Mine then
    return
  end
  if self.curTab == TrainTab.Mine then
    self.btn_truck_insurance_desc:SetLocalText("month_card_title_01")
    self.full_reward_desc:SetLocalText("month_card_tips_04")
    local isShowTruckInsuranceRedDot = DataCenter.MonthCardNewManager:IsShowTruckInsuranceRedDot()
    self.truck_insurance_ren_point:SetActive(isShowTruckInsuranceRedDot)
    local isTruckInsuranceToLimit = DataCenter.MonthCardNewManager:IsTruckInsuranceToLimit()
    self.full_reward_tips:SetActive(isTruckInsuranceToLimit)
  end
end

function UILWTrainSceneView:OnClickTruckInsurance()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UITruckRewardInsurance)
end

function UILWTrainSceneView:OnClickAdd()
end

function UILWTrainSceneView:OnClickTrain(train)
  if self.curTab == TrainTab.Enemy then
    self:SelectTrain(train)
  elseif self.curTab == TrainTab.Mine then
    if train.trainData:GetTrainState() == TrainState.ArrivedFinal then
      RailwayUtil.ApplyArriveReward(train.trainData)
    else
      self:SelectTrain(train)
    end
  end
end

function UILWTrainSceneView:SelectTrain(train)
  self.selectTrain = train
  self.infoPanel:SetActive(true)
  self.infoPanel:SetData(train.trainData, self.curTab)
  DataCenter.TrainSceneManager:ShowSelectRing(train)
  self:CheckIsNeedShowMultiRewardTip()
  self:RefreshSuperDepartureBtnPos(true)
  if train.trainData:IsMyTrain() then
    DataCenter.LWTrainDataManager:TryCheckTrainRefresh(train.trainData)
  end
end

function UILWTrainSceneView:DeSelectTrain()
  if self.selectTrain then
    self.selectTrain:ShowSelectRing(false)
  end
  self.selectTrain = nil
  self.infoPanel:SetActive(false)
  self:CheckIsNeedShowMultiRewardTip()
  self:RefreshSuperDepartureBtnPos(false)
end

function UILWTrainSceneView:OnClickLeft()
  for i = 1, #self.trainList do
    if self.trainList[i].uuid == self.selectTrain.uuid then
      if i == 1 then
        self:SelectTrain(self.trainList[#self.trainList])
        return
      else
        self:SelectTrain(self.trainList[i - 1])
        return
      end
    end
  end
end

function UILWTrainSceneView:OnClickRight()
  for i = 1, #self.trainList do
    if self.trainList[i].uuid == self.selectTrain.uuid then
      if i == #self.trainList then
        self:SelectTrain(self.trainList[1])
        return
      else
        self:SelectTrain(self.trainList[i + 1])
        return
      end
    end
  end
end

function UILWTrainSceneView:OnClickRefresh()
  self:DoRefresh()
end

function UILWTrainSceneView:OnClickHistory()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWTruckRecord, {anim = false}, {})
end

function UILWTrainSceneView:DelayJumpToMyTrain(buildUuid)
  TimerManager:GetInstance():DelayInvoke(function()
    local trainData = DataCenter.LWMyStationDataManager:GetMyTrainByBuildUuid(buildUuid)
    if trainData and trainData.uuid then
      local train = DataCenter.TrainSceneManager:GetTrain(trainData.uuid)
      if train and self.SelectTrain then
        self:SelectTrain(train)
      end
    end
  end, 1)
end

function UILWTrainSceneView:DelayJumpToEnemyTrain(uuid)
  uuid = checknumber(uuid)
  TimerManager:GetInstance():DelayInvoke(function()
    if table.count(self.trainList) > 0 then
      for _, trainData in pairs(self.trainList) do
        if trainData.trainData ~= nil and checknumber(trainData.trainData.uuid) == uuid then
          self:SelectTrain(trainData)
          return
        end
      end
    end
  end, 1)
end

function UILWTrainSceneView:DoRefresh()
  UIUtil.PlayCutSceneAnim(function()
    if self then
      self:DeSelectTrain()
      DataCenter.LWTrainDataManager:TryGetTrainList(true)
    end
  end)
end

function UILWTrainSceneView:OnUpdateScienceData(scienceId)
  if scienceId == ADD_DEPARTURE_COUNT and self.curTab == TrainTab.Mine then
    self:RefreshScienceBtnState()
    self:RefreshMyTruck()
  end
end

function UILWTrainSceneView:RefreshScienceBtnState()
  local trainDepartureScienceId = 13
  local tabState = DataCenter.ScienceTemplateManager:GetTabState(trainDepartureScienceId)
  if tabState == ScienceTabState.UnLock then
    local effectValue = LuaEntry.Effect:GetGameEffect(EffectDefine.MAX_DAILY_COUNT_ADD)
    self.goToScienceBtn:SetActive(effectValue == 0)
  else
    self.goToScienceBtn:SetActive(false)
  end
end

function UILWTrainSceneView:GoToScienceBtnClick()
  GoToUtil.GotoScience(ADD_DEPARTURE_COUNT, nil, nil, true)
end

function UILWTrainSceneView:RefreshBlockToggle(userSettingKey)
  if userSettingKey == UserSettingKey.TrainBlockOwnServer then
    self.blockToggle:SetIsOn(LuaEntry.Player:GetUserSetting(UserSettingKey.TrainBlockOwnServer) == "1")
    self:OnClickRefresh()
  end
end

function UILWTrainSceneView:OnCheckMyTrainRefreshReceived(uuid)
  if self.selectTrain and self.selectTrain.uuid == uuid then
    self.infoPanel:TryRefreshMyTrain()
  end
end

function UILWTrainSceneView:CheckIsNeedShowMultiRewardTip()
  local isDuringMultiReward = MultiRewardDropUtils.GetTruckCurCanEnjoyMaxMultiValue()
  self.multiRewardTipObj:SetActive(false)
  self.multiRewardBottomTipObj:SetActive(false)
  local isShow = 1 < isDuringMultiReward
  if not isShow then
    return
  end
  if self.infoPanel and self.infoPanel.activeSelf then
    self.multiRewardBottomTipObj:SetActive(true)
  else
    self.multiRewardTipObj:SetActive(true)
  end
end

function UILWTrainSceneView:IsShowSuperTruckDeparture()
  local isFunctionOn = LuaEntry.DataConfig:CheckSwitch("super_truck_launch")
  if not isFunctionOn then
    return false, false
  end
  local trainDatas = DataCenter.LWMyStationDataManager:GetMyTrains()
  if table.count(trainDatas) == 0 then
    return false, false
  end
  local cur, max = DataCenter.LWMyStationDataManager:GetDepartureCount()
  if max <= cur then
    return true, true
  end
  local vipData = DataCenter.VIPManager:GetVipData()
  if vipData and vipData.level >= 12 then
    local vipIsActive = vipData:IsVIPActive()
    if not vipIsActive then
      return true, true
    end
    if vipData.level == 12 then
      return true, true
    end
    local effectValue = LuaEntry.Effect:GetGameEffect(EffectDefine.Truck_Super_Departure_50248) or 0
    return 0 < effectValue, false
  end
  return false, false
end

function UILWTrainSceneView:RefreshSuperDepartureBtnPos(isSelect)
  if self.super_departure_btn == nil then
    return
  end
  local isDuringMultiReward = MultiRewardDropUtils.GetTruckCurCanEnjoyMaxMultiValue()
  local isShowMultiRewardTips = 1 < isDuringMultiReward
  if isShowMultiRewardTips then
    if isSelect then
      self.super_departure_btn:SetAnchoredPositionXY(0, 535)
    else
      self.super_departure_btn:SetAnchoredPositionXY(0, 165)
    end
  elseif isSelect then
    self.super_departure_btn:SetAnchoredPositionXY(0, 485)
  else
    self.super_departure_btn:SetAnchoredPositionXY(0, 90)
  end
end

function UILWTrainSceneView:OnSuperDepartureBtnClick()
  local vipData = DataCenter.VIPManager:GetVipData()
  if vipData then
    if vipData.level <= 12 then
      UIUtil.ShowTipsId("super_trucklaunch_tips01")
      return
    end
    local vipIsActive = vipData:IsVIPActive()
    if not vipIsActive then
      UIUtil.ShowTipsId("super_trucklaunch_tips07")
      return
    end
  end
  local cur, max = DataCenter.LWMyStationDataManager:GetDepartureCount()
  if max <= cur then
    UIUtil.ShowTipsId("super_trucklaunch_tips08")
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWTruckSuperDeparture, {anim = true})
end

return UILWTrainSceneView
