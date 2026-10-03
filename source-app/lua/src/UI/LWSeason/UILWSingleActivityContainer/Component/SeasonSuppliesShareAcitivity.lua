local base = UIBaseContainer
local SeasonSuppliesShareAcitivity = BaseClass("SeasonSuppliesShareAcitivity", base)
local Localization = CS.GameEntry.Localization
local SupplliesShareItem = require("UI.LWSeason.UILWSingleActivityContainer.Component.SupplliesShareItem")
local SuppliesShowCountItem = require("UI.LWSeason.UILWSingleActivityContainer.Component.SuppliesShowCountItem")
local infoBtn_path = "Root/IntroBtn"
local name_path = "Root/Txt_ActName"
local endTime_path = "Root/TimeContent/Txt_Times"
local detailInfo_path = "Root/detailInfo"
local countInfoBtn_path = "Root/count/countInfoBtn"
local countDes_path = "Root/countDes"
local limitDes_path = "Root/limitDes "
local shareItemParent_path = "Root/ScrollView/Content"
local scrollView_path = "Root/ScrollView"
local suppliesCount_path = "Root/suppliesCount"
local countScrollView_path = "Root/suppliesCount/Image/countScrollView"
local countParent_path = "Root/suppliesCount/Image/countScrollView/countContent"
local total_path = "Root/count"
local hint_path = "Root/hint"
local noList_path = "Root/hint/noList"
local noAlliance_path = "Root/hint/noAllinace"
local joinAllianceBtn_path = "Root/hint/JoinAlliance"
local explainBtn_path = "Root/explainBtn"
local closeTipBtn_path = "Root/closeTipBtn"

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
  self.shareItemParent = self:AddComponent(GridInfinityScrollView, shareItemParent_path)
  self.scrollView = self:AddComponent(UIBaseContainer, scrollView_path)
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
  self.infoBtn:SetOnClick(function()
    self:ClickTip()
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
  self.suppliesCount:SetActive(false)
  self.suppliesCountInfoFlag = false
end

local function ComponentDestroy(self)
  self.infoBtn = nil
  self.name = nil
  self.endTime = nil
  self.detailInfo = nil
  self.countInfoBtn = nil
  self.countDes = nil
  self.limitDes = nil
  self.shareItemParent = nil
  self.scrollView = nil
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
end

local function DataDefine(self)
  self.itemlistGO = {}
  local bindFunc1 = BindCallback(self, self.OnInitItemScroll)
  local bindFunc2 = BindCallback(self, self.OnUpdateItemScroll)
  local bindFunc3 = BindCallback(self, self.OnDestroyItemScroll)
  self.shareItemParent:Init(bindFunc1, bindFunc2, bindFunc3)
  self.countItemlistGO = {}
  bindFunc1 = BindCallback(self, self.OnInitShowCountScroll)
  bindFunc2 = BindCallback(self, self.OnUpdateShowCountScroll)
  bindFunc3 = BindCallback(self, self.OnDestroyShowcountScroll)
  self.countParent:Init(bindFunc1, bindFunc2, bindFunc3)
end

local function DataDestroy(self)
  self.itemlistGO = nil
  self.countItemlistGO = nil
  self.shareSuppliesPoint = nil
  self.remainData = nil
  self:ClearScroll()
end

function SeasonSuppliesShareAcitivity:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.GetActivitySuppliesShareInfoEvent, self.ActivityDataUpdate)
end

function SeasonSuppliesShareAcitivity:OnRemoveListener()
  self:RemoveUIListener(EventId.GetActivitySuppliesShareInfoEvent, self.ActivityDataUpdate)
  base.OnRemoveListener(self)
end

function SeasonSuppliesShareAcitivity:RefreshList()
  if self.shareSuppliesPoint then
    local count = #self.shareSuppliesPoint
    if count == 0 then
      self.scrollView:SetActive(false)
    else
      self.scrollView:SetActive(true)
      self.shareItemParent:SetItemCount(count)
      self.shareItemParent:ForceUpdate()
    end
  else
    self.scrollView:SetActive(false)
  end
end

function SeasonSuppliesShareAcitivity:RefreshCountList()
  if self.remainData then
    local count = #self.remainData
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

function SeasonSuppliesShareAcitivity:SetData(activityId, activityData)
  self.activityId = tonumber(activityId)
  if not self.activityId then
    self.infoBtn:SetActive(false)
    self.explainBtn:SetActive(false)
    return
  end
  self.activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if self.activityInfo == nil then
    self.infoBtn:SetActive(false)
    self.explainBtn:SetActive(false)
    return
  end
  self.infoBtn:SetActive(not string.IsNullOrEmpty(self.activityInfo.story))
  self.explainBtn:SetActive(self.activityInfo.ppt_show > 0)
  self.name:SetLocalText(self.activityInfo.name)
  self.detailInfo:SetLocalText(self.activityInfo.desc_info)
  self:Update1000MS()
  self:RefreshShareInfoData(true)
end

function SeasonSuppliesShareAcitivity:ClickTip()
  if self.activityInfo ~= nil and self.activityInfo.story ~= nil then
    local param = {}
    param.activityId = self.activityId
    param.activityRulesStr = Localization:GetString(self.activityInfo.story)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
  end
end

function SeasonSuppliesShareAcitivity:RefreshShareInfoData(sendMsg)
  local shareData = DataCenter.SeasonSuppliesShareDataManager:GetActivityInfo(sendMsg)
  self.remainData = shareData and shareData.remainData or {}
  local totalNum = self.remainData and self.remainData.totalNum or 0
  self.shareSuppliesPoint = shareData and shareData.suppliesPointData or {}
  self.rewardCount = shareData and shareData.rewardCount or 0
  local countLimit = shareData and shareData.rewardMax or 0
  if shareData and shareData.rewardLeftCount then
    self.limitDes:SetLocalText("season4_supplies_UI_28", shareData.rewardLeftCount, countLimit)
  else
    self.limitDes:SetLocalText("season_s2_ice_supplies_26", string.format("%s/%s", countLimit - self.rewardCount, countLimit))
  end
  self.total:SetText(totalNum)
  self:RefreshCountList()
  if LuaEntry.Player:IsInAlliance() == false then
    self.hint:SetActive(true)
    self.noAlliance:SetActive(true)
    self.noList:SetActive(false)
    self.joinAllianceBtn:SetActive(true)
  elseif 0 < #self.shareSuppliesPoint then
    self.hint:SetActive(false)
    self:RefreshList()
  else
    self.hint:SetActive(true)
    self.noAlliance:SetActive(false)
    self.noList:SetActive(true)
    self.joinAllianceBtn:SetActive(false)
  end
end

function SeasonSuppliesShareAcitivity:OnInitItemScroll(go, index)
  local item = self.scrollView:AddComponent(SupplliesShareItem, go)
  self.itemlistGO[go] = item
end

function SeasonSuppliesShareAcitivity:OnUpdateItemScroll(go, index)
  index = index + 1
  if self.shareSuppliesPoint then
    if index <= #self.shareSuppliesPoint then
      local item = self.itemlistGO[go]
      local data = self.shareSuppliesPoint[index]
      item:SetData(data)
      go:SetActive(true)
    end
  else
    go:SetActive(false)
  end
end

function SeasonSuppliesShareAcitivity:OnDestroyItemScroll(go, index)
end

function SeasonSuppliesShareAcitivity:OnInitShowCountScroll(go, index)
  local item = self.countScrollView:AddComponent(SuppliesShowCountItem, go)
  self.countItemlistGO[go] = item
end

function SeasonSuppliesShareAcitivity:OnUpdateShowCountScroll(go, index)
  index = index + 1
  if self.remainData then
    if index <= #self.remainData then
      local item = self.countItemlistGO[go]
      local data = self.remainData[index]
      item:SetData(data)
      go:SetActive(true)
    end
  else
    go:SetActive(false)
  end
end

function SeasonSuppliesShareAcitivity:OnDestroyShowcountScroll(go, index)
end

function SeasonSuppliesShareAcitivity:ClearScroll()
  self.scrollView:RemoveComponents(SupplliesShareItem)
  self.shareItemParent:DestroyChildNode()
  self.countScrollView:RemoveComponents(SuppliesShowCountItem)
  self.countParent:DestroyChildNode()
end

function SeasonSuppliesShareAcitivity:Update1000MS()
  if not self.activityId then
    return
  end
  if self.activityInfo == nil then
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

function SeasonSuppliesShareAcitivity:ActivityDataUpdate()
  self:RefreshShareInfoData(false)
end

function SeasonSuppliesShareAcitivity:CountBtnClick()
  self.suppliesCount:SetActive(true)
  self.closeTipBtn:SetActive(true)
  self.suppliesCountInfoFlag = true
end

function SeasonSuppliesShareAcitivity:CloseTipBtn()
  self.closeTipBtn:SetActive(false)
  if self.suppliesCountInfoFlag then
    self.suppliesCount:SetActive(false)
    self.suppliesCountInfoFlag = false
  end
end

function SeasonSuppliesShareAcitivity:JoinAllianceBtn()
  GoToUtil.CloseAllWindows()
  if LuaEntry.Player:IsFirstJoinAlliance() == true then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAllianceFirstJoin, {anim = true})
    return
  end
  local params = {guide = false}
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlCreateJoin, {anim = true}, params)
end

function SeasonSuppliesShareAcitivity:ExplainBtn()
  if self.activityInfo ~= nil and self.activityInfo.ppt_show ~= nil then
    local group = toInt(self.activityInfo.ppt_show)
    if group ~= 0 then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWWorldTip, {anim = false}, group)
    end
  end
end

SeasonSuppliesShareAcitivity.OnCreate = OnCreate
SeasonSuppliesShareAcitivity.OnDestroy = OnDestroy
SeasonSuppliesShareAcitivity.OnEnable = OnEnable
SeasonSuppliesShareAcitivity.OnDisable = OnDisable
SeasonSuppliesShareAcitivity.ComponentDefine = ComponentDefine
SeasonSuppliesShareAcitivity.ComponentDestroy = ComponentDestroy
SeasonSuppliesShareAcitivity.DataDefine = DataDefine
SeasonSuppliesShareAcitivity.DataDestroy = DataDestroy
return SeasonSuppliesShareAcitivity
