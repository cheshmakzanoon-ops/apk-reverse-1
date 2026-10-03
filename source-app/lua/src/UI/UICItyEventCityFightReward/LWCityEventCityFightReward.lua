local LWCityEventCityFightReward = BaseClass("LWCityEventCityFightReward", UIBaseView)
local AchieveItem = require("UI.UICItyEventCityFightReward.Component.UICityEventCityFightRewardAchieveItem")
local base = UIBaseView
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
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
  self.mainAnimator = self:AddComponent(UIAnimator, "")
  self.folderPart = self:AddComponent(UIBaseContainer, "folderPart")
  self.compFolderClose = self:AddComponent(UIBaseContainer, "folderPart/folderClose")
  self.compFolderOpen = self:AddComponent(UIBaseContainer, "folderPart/folderOpen")
  self.textTip1 = self:AddComponent(UIText, "folderPart/tip1")
  self.textTip1:SetText(Localization:GetString("city_event_desc65"))
  self.textTip2 = self:AddComponent(UIText, "folderPart/tip2")
  self.textTip2:SetText(Localization:GetString("city_event_desc66"))
  self.btnClickOpen = self:AddComponent(UIButton, "folderPart/ClickOpen")
  self.btnClickOpen:SetOnClick(function()
    self:OnBtnClickOpenClick()
  end)
  self.textTxtClickOpen = self:AddComponent(UIText, "folderPart/ClickOpen/txtClickOpen")
  self.textTxtClickOpen:SetText(Localization:GetString("city_event_desc67"))
  self.missionPart = self:AddComponent(UIBaseContainer, "missionPart")
  self.textTxtTitle = self:AddComponent(UIText, "missionPart/top/txtTitle")
  local cityEventName = DataCenter.LWBeginnerDirectorManager:GetCurCityEventName()
  self.textTxtTitle:SetLocalText(cityEventName)
  self.textTxtTimerLabel = self:AddComponent(UIText, "missionPart/top/Timer/TimerLabelBg/TxtTimerLabel")
  self.btnClose = self:AddComponent(UIButton, "missionPart/top/btnClose")
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.btnBlack = self:AddComponent(UIButton, "black")
  self.btnBlack:SetOnClick(function()
    self:OnBtnBlackClick()
  end)
  self.btnInfo = self:AddComponent(UIButton, "missionPart/top/btnInfo")
  self.btnInfo:SetOnClick(function()
    self:OnBtnInfoClick()
  end)
  self.btnChange = self:AddComponent(UIButton, "missionPart/top/SelectCity/btnChange")
  self.btnChange:SetOnClick(function()
    self:OnBtnChangeClick()
  end)
  self.btnNoSelect = self:AddComponent(UIButton, "missionPart/top/SelectCity/NoSelect")
  self.btnNoSelect:SetOnClick(function()
    self:OnBtnChangeClick()
  end)
  self.compNoSelect = self:AddComponent(UIBaseContainer, "missionPart/top/SelectCity/NoSelect")
  self.textNoSelectTitle = self:AddComponent(UIText, "missionPart/top/SelectCity/NoSelect/NoSelectTitle")
  self.rawImgSelectedCity = self:AddComponent(UIImage, "missionPart/top/SelectCity/SelectedCity")
  self.textSelectCityTitle = self:AddComponent(UIText, "missionPart/top/SelectCity/SelectedCity/SelectCityTitle")
  self.textSelectCityDesc = self:AddComponent(UIText, "missionPart/top/SelectCity/SelectedCity/SelectCityDesc")
  self.compJoin = self:AddComponent(UIBaseContainer, "missionPart/Join")
  self.textTxtJoin = self:AddComponent(UIText, "missionPart/Join/txtJoin")
  self.btnJoin = self:AddComponent(UIButton, "missionPart/Join/btnJoin")
  self.btnJoin:SetOnClick(function()
    self:OnBtnJoinClick()
  end)
  self.txtBtnJoin = self:AddComponent(UIText, "missionPart/Join/btnJoin/txtBtnJoin")
  self.txtBtnJoin:SetLocalText("city_event_desc64")
  self.btnJumpToCity = self:AddComponent(UIButton, "missionPart/top/SelectCity/SelectedCity")
  self.btnJumpToCity:SetOnClick(function()
    if self.declareWarCityData ~= nil and self.declareWarCityData.pos and self.declareWarCityData.pos.x ~= nil and self.declareWarCityData.pos.y ~= nil then
      local v3 = SceneUtils.TileToWorld(self.declareWarCityData.pos, ForceChangeScene.World)
      GoToUtil.CloseAllWindows()
      GoToUtil.GotoWorldPos(v3, CS.SceneManager.World.InitZoom, nil, nil, LuaEntry.Player:GetCurServerId())
    end
  end)
  self.dynamicVerticalScrollRectExScrollAchieve = self:AddComponent(UIDynamicVerticleScrollRectEx, "missionPart/bg2/scrollAchieve")
  self.itemIncNo = 1
  self.itemMap = {}
  self.dynamicVerticalScrollRectExScrollAchieve:AddInstantiateItemListener(function(itemObj, prefabIdx)
    itemObj.name = "achieveItem_" .. self.itemIncNo
    self.itemIncNo = self.itemIncNo + 1
    local achieveItem = self:AddComponent(AchieveItem, itemObj)
    self.itemMap[itemObj] = achieveItem
  end)
  self.dynamicVerticalScrollRectExScrollAchieve:AddDisplayItemListener(function(itemObj, dataIdx)
    local achieveItem = self.itemMap[itemObj]
    local data = self.rewardDatas[dataIdx + 1]
    achieveItem:Refresh(data, self.cityEventId)
  end)
  self:ReInit()
end

local function ComponentDestroy(self)
  if self.closeAnimTimer then
    self.closeAnimTimer:Stop()
    self.closeAnimTimer = nil
  end
  if self.folderChangeAnimTimer then
    self.folderChangeAnimTimer:Stop()
    self.folderChangeAnimTimer = nil
  end
  if self.folderToLoopTimer then
    self.folderToLoopTimer:Stop()
    self.folderToLoopTimer = nil
  end
  self.compFolderClose = nil
  self.compFolderOpen = nil
  self.textTip1 = nil
  self.textTip2 = nil
  self.btnClickOpen = nil
  self.textTxtClickOpen = nil
  self.textTxtTitle = nil
  self.textTxtTimerLabel = nil
  self.btnClose = nil
  self.btnBlack = nil
  self.btnInfo = nil
  self.btnChange = nil
  self.compNoSelect = nil
  self.textNoSelectTitle = nil
  self.rawImgSelectedCity = nil
  self.textSelectCityTitle = nil
  self.textSelectCityDesc = nil
  self.compJoin = nil
  self.textTxtJoin = nil
  self.txtBtnJoin = nil
  self.btnJoin = nil
  self.dynamicVerticalScrollRectExScrollAchieve = nil
  self.mainAnimator = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.declareWarCityData = nil
  self.itemIncNo = 1
  self.itemMap = nil
  self.rewardDatas = nil
  self.cityEventId = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.CityEventTaskUpdate, self.ReInit)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.CityEventTaskUpdate, self.ReInit)
  base.OnRemoveListener(self)
end

local function OnBtnClickOpenClick(self)
  if self.folderToLoopTimer then
    return
  end
  if self.folderChangeAnimTimer then
    self.folderChangeAnimTimer:Stop()
    self.folderChangeAnimTimer = nil
  end
  self.folderPart:SetActive(false)
  self.missionPart:SetActive(true)
  if self.mainAnimator then
    local success, time = self.mainAnimator:PlayAnimationReturnTime("UICityEventCityFightRewardChange")
    if success then
      self.folderChangeAnimTimer = TimerManager:GetInstance():DelayInvoke(function()
        self.mainAnimator:Play("UICityEventCityFightRewardMissionpartLoop", 0, 0)
        self.folderChangeAnimTimer:Stop()
        self.folderChangeAnimTimer = nil
      end, time)
    else
      self.mainAnimator:Play("UICityEventCityFightRewardMissionpartLoop", 0, 0)
    end
    local key = "CityFightFirstOpen_" .. self.cityEventId
    CommonUtil.PlayerPrefsSetBool(key, true)
  end
end

local function OnBtnCloseClick(self)
  self:CloseWithAnim()
end

local function OnBtnBlackClick(self)
  self:CloseWithAnim()
end

local function OnBtnInfoClick(self)
  UIUtil.ShowIntro(Localization:GetString("302027"), Localization:GetString("2800015"), Localization:GetString("city_event_desc60"))
end

local function OnBtnChangeClick(self)
  local valid = DataCenter.AllianceBaseDataManager:IsR4orR5()
  if not valid then
    UIUtil.ShowTipsId("120173")
    return
  end
  SFSNetwork.SendMessage(MsgDefines.GetCityWarInfo)
  SFSNetwork.SendMessage(MsgDefines.GetCrossOccupyCityList)
  if SeasonUtil.GetSeasonType() == SeasonMapType.CityStronghold then
    SFSNetwork.SendMessage(MsgDefines.GetCrossOccupyStrongholdList)
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UISeasonAttackCityDetail, {anim = true}, true)
end

local function OnBtnJoinClick(self)
  local params = {
    guide = false,
    al_success_callback = function()
      UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWAlCreateJoin)
      self:ReInit()
    end,
    al_lose_callback = function()
    end
  }
  if LuaEntry.Player:IsFirstJoinAlliance() == true then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAllianceFirstJoin, {anim = true}, params)
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlCreateJoin, {anim = true}, params)
  end
end

function LWCityEventCityFightReward:ReInit()
  self.valid = false
  local cityEventId = DataCenter.LWBeginnerDirectorManager:GetCurCityEventID()
  if cityEventId ~= BeginnerDirectorEvent.CityFight and cityEventId ~= BeginnerDirectorEvent.CityFight2 and cityEventId ~= BeginnerDirectorEvent.CityFight3 then
    self:CloseWithAnim()
    return
  end
  if DataCenter.LWBeginnerDirectorManager:IsCurCityEventAllTaskReceived() then
    self:CloseWithAnim()
    return
  end
  self.valid = true
  self.endTime = DataCenter.LWBeginnerDirectorManager:GetCurCityEventEndTime()
  self:UpdateTime()
  local isInAlliance = LuaEntry.Player:IsInAlliance()
  self.compJoin:SetActive(not isInAlliance)
  self.textTxtJoin:SetLocalText("city_event_desc64")
  local declareWarCityData = isInAlliance and self:GetMyAlCityFightDeclareWarData() or nil
  self.declareWarCityData = declareWarCityData
  if declareWarCityData then
    self.rawImgSelectedCity:SetActive(true)
    self.rawImgSelectedCity:LoadSprite(declareWarCityData:GetIconPath(false))
    self.textSelectCityDesc:SetLocalText("city_event_desc75")
    self.compNoSelect:SetActive(false)
  else
    self.rawImgSelectedCity:SetActive(false)
    self.compNoSelect:SetActive(true)
    self.textNoSelectTitle:SetLocalText("city_event_desc68")
  end
  self.btnChange:SetActive(true)
  local key = "CityFightFirstOpen_" .. cityEventId
  local firstOpened = CommonUtil.PlayerPrefsGetBool(key, false)
  local animationIn = not self.cityEventId or self.cityEventId ~= cityEventId
  if self.mainAnimator and animationIn then
    if not firstOpened then
      if self.folderToLoopTimer then
        self.folderToLoopTimer:Stop()
        self.folderToLoopTimer = nil
      end
      local success, time = self.mainAnimator:PlayAnimationReturnTime("UICityEventCityFightRewardIn")
      if success then
        self.folderToLoopTimer = TimerManager:GetInstance():DelayInvoke(function()
          self.mainAnimator:Play("UICityEventCityFightRewardLoop", 0, 0)
          self.folderToLoopTimer:Stop()
          self.folderToLoopTimer = nil
        end, time)
      else
        self.mainAnimator:Play("UICityEventCityFightRewardLoop", 0, 0)
      end
      self.folderPart:SetActive(true)
      self.missionPart:SetActive(false)
    else
      self.mainAnimator:Play("UICityEventCityFightRewardMissionpartLoop", 0, 0)
      self.folderPart:SetActive(false)
      self.missionPart:SetActive(true)
    end
  end
  self.cityEventId = cityEventId
  local cityEventTaskArr = DataCenter.LWBeginnerDirectorManager:GetCurCityEventTaskArr()
  table.sort(cityEventTaskArr, function(a, b)
    if a.state ~= b.state and (a.state > 1 or b.state > 1) then
      return a.state < b.state
    else
      local taskIdA = tonumber(a.taskId)
      local taskIdB = tonumber(b.taskId)
      return taskIdA < taskIdB
    end
  end)
  self.rewardDatas = cityEventTaskArr
  self.dynamicVerticalScrollRectExScrollAchieve:SetDatas(self.rewardDatas)
  self.dynamicVerticalScrollRectExScrollAchieve:UpdateItems()
  DataCenter.AllianceMineManager:RequestAllianceMineInfo(true)
end

function LWCityEventCityFightReward:Update1000MS()
  if self.valid then
    self:UpdateTime()
  end
end

function LWCityEventCityFightReward:GetMyAlCityFightDeclareWarData()
  local DeclareWarDataList = DataCenter.AllianceDeclareWarManager:GetAllianceDeclareWarData()
  if DeclareWarDataList ~= nil then
    local allianceId = LuaEntry.Player:GetAllianceUid()
    for _, WarData in ipairs(DeclareWarDataList) do
      if WarData.aId == allianceId then
        local cityId = WarData.content
        local cityConfig = DataCenter.AllianceCityTemplateManager:GetTemplate(cityId)
        return cityConfig
      end
    end
  end
end

function LWCityEventCityFightReward:UpdateTime()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local diff = self.endTime - curTime
  self.textTxtTimerLabel:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(diff))
  if diff <= 0 then
    self.valid = false
    self:CloseWithAnim()
  end
end

function LWCityEventCityFightReward:CloseWithAnim()
  if self.closeAnimTimer then
    self.closeAnimTimer:Stop()
    self.closeAnimTimer = nil
  end
  if self.mainAnimator then
    local success, time = self.mainAnimator:PlayAnimationReturnTime("UICityEventCityFightRewardOut")
    if success then
      self.closeAnimTimer = TimerManager:GetInstance():DelayInvoke(function()
        self.ctrl:CloseSelf()
      end, time)
    else
      self.ctrl:CloseSelf()
    end
  end
end

LWCityEventCityFightReward.OnCreate = OnCreate
LWCityEventCityFightReward.OnDestroy = OnDestroy
LWCityEventCityFightReward.OnEnable = OnEnable
LWCityEventCityFightReward.OnDisable = OnDisable
LWCityEventCityFightReward.ComponentDefine = ComponentDefine
LWCityEventCityFightReward.ComponentDestroy = ComponentDestroy
LWCityEventCityFightReward.DataDefine = DataDefine
LWCityEventCityFightReward.DataDestroy = DataDestroy
LWCityEventCityFightReward.OnAddListener = OnAddListener
LWCityEventCityFightReward.OnRemoveListener = OnRemoveListener
LWCityEventCityFightReward.OnBtnCloseClick = OnBtnCloseClick
LWCityEventCityFightReward.OnBtnBlackClick = OnBtnBlackClick
LWCityEventCityFightReward.OnBtnInfoClick = OnBtnInfoClick
LWCityEventCityFightReward.OnBtnChangeClick = OnBtnChangeClick
LWCityEventCityFightReward.OnBtnJoinClick = OnBtnJoinClick
LWCityEventCityFightReward.OnBtnClickOpenClick = OnBtnClickOpenClick
return LWCityEventCityFightReward
