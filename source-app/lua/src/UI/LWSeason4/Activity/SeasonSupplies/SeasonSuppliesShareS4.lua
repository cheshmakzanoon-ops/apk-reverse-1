local base = UIBaseContainer
local SeasonSuppliesShareS4 = BaseClass("SeasonSuppliesShareS4", base)
local Localization = CS.GameEntry.Localization
local SuppliesSignalItem = require("UI.LWSeason4.Activity.SeasonSupplies.Component.SuppliesSignalItem")
local SuppliesShareItem = require("UI.LWSeason4.Activity.SeasonSupplies.Component.SuppliesShareItem")
local SuppliesShowCountItem = require("UI.LWSeason4.Activity.SeasonSupplies.Component.SuppliesShowCountItem")
local infoBtn_path = "Root/IntroBtn"
local name_path = "Root/Txt_ActName"
local endTime_path = "Root/TimeInfoItem/timeBg2/TimeText"
local detailInfo_path = "Root/detailInfo"
local countInfoBtn_path = "Root/Info/count/countInfoBtn"
local countDes_path = "Root/Info/countDes"
local limitDes_path = "Root/limitDes "
local limitBtn_path = "Root/limitDes /limitBtn"
local killNum_path = "Root/Info/suppliesCount/Image/killNum"
local suppliesCount_path = "Root/Info/suppliesCount"
local countScrollView_path = "Root/Info/suppliesCount/Image/countScrollView"
local countParent_path = "Root/Info/suppliesCount/Image/countScrollView/countContent"
local total_path = "Root/Info/count"
local hint_path = "Root/Content/hint"
local noList_path = "Root/Content/hint/noList"
local noAlliance_path = "Root/Content/hint/noAllinace"
local joinAllianceBtn_path = "Root/Content/hint/JoinAlliance"
local explainBtn_path = "Root/explainBtn"
local closeTipBtn_path = "Root/closeTipBtn"
local toggle1_path = "Root/Toggle/Toggle1"
local toggle2_path = "Root/Toggle/Toggle2"
local content1_path = "Root/Content/ScrollView1"
local scrollView1_path = "Root/Content/ScrollView1/Content1"
local content2_path = "Root/Content/ScrollView2"
local scrollView2_path = "Root/Content/ScrollView2/Content2"
local contentBg_path = "Root/Content"

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
  self.infoBtn = self:AddComponent(UIButton, infoBtn_path)
  self.name = self:AddComponent(UIText, name_path)
  self.endTime = self:AddComponent(UIText, endTime_path)
  self.detailInfo = self:AddComponent(UIText, detailInfo_path)
  self.countInfoBtn = self:AddComponent(UIButton, countInfoBtn_path)
  self.countDes = self:AddComponent(UIText, countDes_path)
  self.limitDes = self:AddComponent(UIText, limitDes_path)
  self.limitBtn = self:AddComponent(UIButton, limitBtn_path)
  self.killNum = self:AddComponent(UIText, killNum_path)
  self.suppliesCount = self:AddComponent(UIBaseContainer, suppliesCount_path)
  self.countScrollView = self:AddComponent(UIBaseContainer, countScrollView_path)
  self.countParent = self:AddComponent(GridInfinityScrollView, countParent_path)
  self.total = self:AddComponent(UIText, total_path)
  self.hint = self:AddComponent(UIBaseContainer, hint_path)
  self.noList = self:AddComponent(UIBaseContainer, noList_path)
  self.noAlliance = self:AddComponent(UIBaseContainer, noAlliance_path)
  self.joinAllianceBtn = self:AddComponent(UIButton, joinAllianceBtn_path)
  self.explainBtn = self:AddComponent(UIButton, explainBtn_path)
  self.closeTipBtn = self:AddComponent(UIButton, closeTipBtn_path)
  self.toggle1 = self:AddComponent(UIToggle, toggle1_path)
  self.toggle2 = self:AddComponent(UIToggle, toggle2_path)
  self.content1 = self:AddComponent(UIBaseContainer, content1_path)
  self.scrollView1 = self:AddComponent(GridInfinityScrollView, scrollView1_path)
  self.content2 = self:AddComponent(UIBaseContainer, content2_path)
  self.scrollView2 = self:AddComponent(GridInfinityScrollView, scrollView2_path)
  self.contentBg = self:AddComponent(UIImage, contentBg_path)
  self.infoBtn:SetOnClick(function()
    self:ClickTip()
  end)
  self.limitBtn:SetOnClick(function()
    if self.rewardLeftCount then
      UIUtil.ShowBubbleTipsAuto(Localization:GetString("season4_supplies_UI_31", DataCenter.SeasonSuppliesShareDataManager:GetSuppliesRefreshCount()), self.limitBtn.transform.position, 0, 42, -150, nil, nil, {reversal = true})
    else
      UIUtil.ShowBubbleTipsAuto(Localization:GetString("season4_supplies_UI_27"), self.limitBtn.transform.position, 0, 42, -150, nil, nil, {reversal = true})
    end
  end)
  self.countInfoBtn:SetOnClick(function()
    self:CountBtnClick()
  end)
  self.joinAllianceBtn:SetOnClick(function()
    self:JoinAllianceBtn()
  end)
  self.explainBtn:SetOnClick(function()
    self:ExplainBtn()
  end)
  self.closeTipBtn:SetOnClick(function()
    self:CloseTipBtn()
  end)
  self.suppliesCountInfoFlag = true
  self:CloseTipBtn()
  self.toggle1:SetOnValueChanged(function(isOn)
    if isOn then
      self:OnToggleChange(1)
    end
  end)
  self.toggle2:SetOnValueChanged(function(isOn)
    if isOn then
      self:OnToggleChange(2)
    end
  end)
  self.toggle1:SetIsOn(true)
  self:OnToggleChange(1)
end

local function ComponentDestroy(self)
  self.infoBtn = nil
  self.name = nil
  self.endTime = nil
  self.detailInfo = nil
  self.countInfoBtn = nil
  self.countDes = nil
  self.limitDes = nil
  self.limitBtn = nil
  self.killNum = nil
  self.suppliesCount = nil
  self.countScrollView = nil
  self.countParent = nil
  self.total = nil
  self.hint = nil
  self.noList = nil
  self.noAlliance = nil
  self.joinAllianceBtn = nil
  self.explainBtn = nil
  self.closeTipBtn = nil
  self.toggle1 = nil
  self.toggle2 = nil
  self.content1 = nil
  self.scrollView1 = nil
  self.content2 = nil
  self.scrollView2 = nil
  self.contentBg = nil
end

local function DataDefine(self)
  self.itemListGO = {}
  local bindFunc1 = BindCallback(self, self.OnInitItemScroll)
  local bindFunc2 = BindCallback(self, self.OnUpdateItemScroll)
  local bindFunc3 = BindCallback(self, self.OnDestroyItemScroll)
  self.scrollView1:Init(bindFunc1, bindFunc2, bindFunc3)
  self.itemListGO2 = {}
  local bindFunc21 = BindCallback(self, self.OnInitItemScroll2)
  local bindFunc22 = BindCallback(self, self.OnUpdateItemScroll2)
  local bindFunc23 = BindCallback(self, self.OnDestroyItemScroll2)
  self.scrollView2:Init(bindFunc21, bindFunc22, bindFunc23)
  self.countItemListGO = {}
  bindFunc1 = BindCallback(self, self.OnInitShowCountScroll)
  bindFunc2 = BindCallback(self, self.OnUpdateShowCountScroll)
  bindFunc3 = BindCallback(self, self.OnDestroyShowCountScroll)
  self.countParent:Init(bindFunc1, bindFunc2, bindFunc3)
end

local function DataDestroy(self)
  self.content1:RemoveComponents(SuppliesSignalItem)
  self.scrollView1:DestroyChildNode()
  self.content2:RemoveComponents(SuppliesShareItem)
  self.scrollView2:DestroyChildNode()
  self.countScrollView:RemoveComponents(SuppliesShowCountItem)
  self.countParent:DestroyChildNode()
  self.itemListGO = nil
  self.itemListGO2 = nil
  self.countItemListGO = nil
  self.signalSuppliesList = nil
  self.shareSuppliesList = nil
  self.unlockArr = nil
end

function SeasonSuppliesShareS4:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.GetActivitySuppliesShareInfoEvent, self.ActivityDataUpdate)
  self:AddUIListener(EventId.PersonalDiscoverSuppliesInfo, self.ActivityDataUpdate)
end

function SeasonSuppliesShareS4:OnRemoveListener()
  self:RemoveUIListener(EventId.GetActivitySuppliesShareInfoEvent, self.ActivityDataUpdate)
  self:RemoveUIListener(EventId.PersonalDiscoverSuppliesInfo, self.ActivityDataUpdate)
  base.OnRemoveListener(self)
end

function SeasonSuppliesShareS4:SetData(activityId, activityData)
  self.activityId = tonumber(activityId)
  if not self.activityId then
    self.infoBtn:SetActive(false)
    self.explainBtn:SetActive(false)
    return
  end
  self.activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  local activityInfo = self.activityInfo
  if not activityInfo then
    self.infoBtn:SetActive(false)
    self.explainBtn:SetActive(false)
    return
  end
  self.infoBtn:SetActive(not string.IsNullOrEmpty(activityInfo.story))
  self.explainBtn:SetActive(activityInfo.ppt_show > 0)
  self.name:SetLocalText(activityInfo.name)
  self.detailInfo:SetLocalText(activityInfo.desc_info)
  self:RefreshShareInfoData(true)
  self:RefreshPersonalInfoData(true)
  self:Update1000MS()
end

function SeasonSuppliesShareS4:RefreshShareInfoData(sendMsg)
  local shareData = DataCenter.SeasonSuppliesShareDataManager:GetActivityInfo(sendMsg)
  self.rewardCount = shareData and shareData.rewardCount or 0
  self.rewardLeftCount = shareData and shareData.rewardLeftCount
  local countLimit = shareData and shareData.rewardMax or 0
  if self.rewardLeftCount then
    self.limitDes:SetLocalText("season4_supplies_UI_28", self.rewardLeftCount, countLimit)
  else
    self.limitDes:SetLocalText("season4_supplies_UI_26", string.format("%s/%s", countLimit - self.rewardCount, countLimit))
  end
  self.shareSuppliesList = shareData and shareData.suppliesPointData or {}
  if self.index == 2 then
    self:RefreshList()
  end
end

function SeasonSuppliesShareS4:RefreshPersonalInfoData(sendMsg)
  local personalData = DataCenter.WorldPointDetailManager:GetPersonalDiscoverSuppliesInfo(sendMsg)
  self.personalData = personalData
  self.unlockArr = personalData and personalData.unlockInfoArr or {}
  self.signalSuppliesList = personalData and personalData.discoverSupplies or {}
  self.killGhostKing = self.personalData and self.personalData.KillGhostKing or 0
  self.countDes:SetText(Localization:GetString("season4_supplies_UI_3", personalData and personalData.remain or 0))
  local curData
  for i, data in ipairs(self.unlockArr) do
    curData = data
    if data.condition and self.killGhostKing < data.condition then
      break
    end
  end
  self.total:SetText(Localization:GetString("season4_supplies_UI_4", string.format("%s/%s", self.killGhostKing, curData and curData.condition or 0)))
  if self.index == 1 then
    self:RefreshList()
  end
end

function SeasonSuppliesShareS4:Update1000MS()
  if not self.activityId or not self.activityInfo then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local leftTime = self.activityInfo.endTime - curTime
  if leftTime < 0 then
    leftTime = 0
  end
  local countDownTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
  self.endTime:SetText(countDownTimeStr)
end

function SeasonSuppliesShareS4:OnToggleChange(index)
  if self.index == index then
    return
  end
  self.index = index
  self:RefreshList()
end

function SeasonSuppliesShareS4:RefreshList()
  if self.index == 1 then
    self.hint:SetActive(false)
    local count = self.signalSuppliesList and #self.signalSuppliesList or 0
    self.contentBg:SetEnable(count == 0)
    if 0 < count then
      self.hint:SetActive(false)
      self.content1:SetActive(true)
      self.scrollView1:SetItemCount(count)
      self.scrollView1:ForceUpdate()
      return
    end
    self.content1:SetActive(false)
  elseif LuaEntry.Player:IsInAlliance() == false then
    self.hint:SetActive(true)
    self.noAlliance:SetActive(true)
    self.noList:SetActive(false)
    self.joinAllianceBtn:SetActive(true)
    return
  else
    local count = self.shareSuppliesList and #self.shareSuppliesList or 0
    self.contentBg:SetEnable(count == 0)
    if 0 < count then
      self.hint:SetActive(false)
      self.content2:SetActive(true)
      self.scrollView2:SetItemCount(count)
      self.scrollView2:ForceUpdate()
      return
    end
    self.content2:SetActive(false)
  end
  self.hint:SetActive(true)
  self.noAlliance:SetActive(false)
  self.noList:SetActive(true)
  self.joinAllianceBtn:SetActive(false)
end

function SeasonSuppliesShareS4:RefreshCountList()
  if self.unlockArr then
    self.killNum:SetText(Localization:GetString("season4_supplies_UI_17", self.killGhostKing))
    local count = #self.unlockArr
    if count == 0 then
      self.countScrollView:SetActive(false)
    else
      self.countScrollView:SetActive(true)
      self.countParent:SetItemCount(count)
      self.countParent:ForceUpdate()
    end
  else
    self.countScrollView:SetActive(false)
  end
end

function SeasonSuppliesShareS4:ClickTip()
  if self.activityInfo and self.activityInfo.story then
    local param = {}
    param.activityId = self.activityId
    param.activityRulesStr = Localization:GetString(self.activityInfo.story)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
  end
end

function SeasonSuppliesShareS4:OnInitItemScroll(go, index)
  self.itemListGO[go] = self.content1:AddComponent(SuppliesSignalItem, go)
end

function SeasonSuppliesShareS4:OnUpdateItemScroll(go, index)
  index = index + 1
  if self.signalSuppliesList then
    if index <= #self.signalSuppliesList then
      local item = self.itemListGO[go]
      local data = self.signalSuppliesList[index]
      item:SetData(data)
      go:SetActive(true)
    end
  else
    go:SetActive(false)
  end
end

function SeasonSuppliesShareS4:OnDestroyItemScroll(go, index)
end

function SeasonSuppliesShareS4:OnInitItemScroll2(go, index)
  self.itemListGO2[go] = self.content2:AddComponent(SuppliesShareItem, go)
end

function SeasonSuppliesShareS4:OnUpdateItemScroll2(go, index)
  index = index + 1
  if self.shareSuppliesList then
    if index <= #self.shareSuppliesList then
      local item = self.itemListGO2[go]
      local data = self.shareSuppliesList[index]
      item:SetData(data)
      go:SetActive(true)
    end
  else
    go:SetActive(false)
  end
end

function SeasonSuppliesShareS4:OnDestroyItemScroll2(go, index)
end

function SeasonSuppliesShareS4:OnInitShowCountScroll(go, index)
  local item = self.countScrollView:AddComponent(SuppliesShowCountItem, go)
  self.countItemListGO[go] = item
end

function SeasonSuppliesShareS4:OnUpdateShowCountScroll(go, index)
  index = index + 1
  if self.unlockArr then
    if index <= #self.unlockArr then
      local item = self.countItemListGO[go]
      local data = self.unlockArr[index]
      item:SetData(data, self.killGhostKing)
      go:SetActive(true)
    end
  else
    go:SetActive(false)
  end
end

function SeasonSuppliesShareS4:OnDestroyShowCountScroll(go, index)
end

function SeasonSuppliesShareS4:ActivityDataUpdate()
  self:RefreshShareInfoData(false)
  self:RefreshPersonalInfoData(false)
end

function SeasonSuppliesShareS4:CountBtnClick()
  self.suppliesCount:SetActive(true)
  self.closeTipBtn:SetActive(true)
  self.suppliesCountInfoFlag = true
  self:RefreshCountList()
end

function SeasonSuppliesShareS4:CloseTipBtn()
  self.closeTipBtn:SetActive(false)
  if self.suppliesCountInfoFlag then
    self.suppliesCount:SetActive(false)
    self.suppliesCountInfoFlag = false
  end
end

function SeasonSuppliesShareS4:JoinAllianceBtn()
  GoToUtil.CloseAllWindows()
  if LuaEntry.Player:IsFirstJoinAlliance() == true then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAllianceFirstJoin, {anim = true})
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlCreateJoin, {anim = true}, {guide = false})
end

function SeasonSuppliesShareS4:ExplainBtn()
  if self.activityInfo and self.activityInfo.ppt_show then
    local group = toInt(self.activityInfo.ppt_show)
    if group ~= 0 then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWWorldTip, {anim = false}, group)
    end
  end
end

SeasonSuppliesShareS4.OnCreate = OnCreate
SeasonSuppliesShareS4.OnDestroy = OnDestroy
SeasonSuppliesShareS4.OnEnable = OnEnable
SeasonSuppliesShareS4.OnDisable = OnDisable
SeasonSuppliesShareS4.ComponentDefine = ComponentDefine
SeasonSuppliesShareS4.ComponentDestroy = ComponentDestroy
SeasonSuppliesShareS4.DataDefine = DataDefine
SeasonSuppliesShareS4.DataDestroy = DataDestroy
return SeasonSuppliesShareS4
