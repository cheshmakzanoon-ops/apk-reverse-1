local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local UIActCommunityLink = BaseClass("UIActCommunityLink", base)
local UIActCommunityLinkBtn = require("UI.UIActivityCenterTable.Component.UIActCommunityLink.UIActCommunityLinkBtn")
local numText_path = "DownPanel/GetRewardBtn/NumText"
local bindingText_path = "DownPanel/GetRewardBtn/BindingText"
local claimedText_path = "DownPanel/GetRewardBtn/ClaimedText"
local getRewardBtn_path = "DownPanel/GetRewardBtn"
local linkBtnPanel_path = "DownPanel/LinkBtnPanel"
local titleText_path = "TopPanel/TitleText"
local desText_path = "TopPanel/DesText"
local canClaimText_path = "DownPanel/GetRewardBtn/CanClaimText"
local rewardEffect_path = "DownPanel/RewardEffect"
local btnPath = "Assets/Main/Prefabs/UI/ActivityCenter/ActCommunityLink/UIActCommunityLinkBtn.prefab"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:SetData()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.numText = self:AddComponent(UIText, numText_path)
  self.bindingText = self:AddComponent(UIText, bindingText_path)
  self.claimedText = self:AddComponent(UIText, claimedText_path)
  self.getRewardBtn = self:AddComponent(UIButton, getRewardBtn_path)
  self.linkBtnPanel = self:AddComponent(UIBaseContainer, linkBtnPanel_path)
  self.titleText = self:AddComponent(UIText, titleText_path)
  self.desText = self:AddComponent(UIText, desText_path)
  self.canClaimText = self:AddComponent(UIText, canClaimText_path)
  self.rewardEffect = self:AddComponent(UIBaseContainer, rewardEffect_path)
  self.getRewardBtn:SetOnClick(function()
    self:OnClickGetRewardBtn()
  end)
  self.titleText:SetLocalText("activity_name_2300001")
  self.desText:SetLocalText("activity_desc_2300001")
  self.bindingText:SetLocalText("activity_binding_btn_01")
  self.canClaimText:SetLocalText("100447")
  self.claimedText:SetLocalText("170003")
  self.rewardEffect:SetActive(false)
end

local function ComponentDestroy(self)
  self:ClearLinkBtnPanel()
  self.numText = nil
  self.bindingText = nil
  self.claimedText = nil
  self.getRewardBtn = nil
  self.linkBtnPanel = nil
  self.titleText = nil
  self.desText = nil
  self.canClaimText = nil
  self.rewardEffect = nil
end

local function DataDefine(self)
  self.data = nil
  self.needRefresh = false
  self.activityId = 0
  self.state = CommunityLinkState.ClaimedBindingReward
end

local function DataDestroy(self)
  self.data = nil
  self.needRefresh = nil
  self.activityId = nil
  self.state = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.APP_APPLICATION_PAUSE, self.OnApplicationPause)
  self:AddUIListener(EventId.LOAD_COMPLETE, self.OnLoadComplete)
  self:AddUIListener(EventId.ActCommunityLinkRefresh, self.Refresh)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.APP_APPLICATION_PAUSE, self.OnApplicationPause)
  self:RemoveUIListener(EventId.LOAD_COMPLETE, self.OnLoadComplete)
  self:RemoveUIListener(EventId.ActCommunityLinkRefresh, self.Refresh)
  base.OnRemoveListener(self)
end

local function SetData(self, activityId)
  base.SetData(self, activityId)
  self.activityId = activityId
  if not self.activityId then
    return
  end
  self.data = DataCenter.ActCommunityLinkManager:GetNowLanguageData()
  self:RefreshLinkBtnPanel()
  self:SendGetInfoMsg()
end

local function ClearLinkBtnPanel(self)
  self.linkBtnPanel:RemoveComponents(UIActCommunityLinkBtn)
  if self.itemReqs then
    for index, value in ipairs(self.itemReqs) do
      self:GameObjectDestroy(value)
    end
    self.itemReqs = nil
  end
end

local function RefreshLinkBtnPanel(self)
  self:ClearLinkBtnPanel()
  self.itemReqs = {}
  if not table.IsNullOrEmpty(self.data) then
    local count = #self.data
    for index, value in ipairs(self.data) do
      local nowIndex = index
      local req = self:GameObjectInstantiateAsync(btnPath, function(req)
        if req == nil or IsNull(req.gameObject) then
          return
        end
        local item = req.gameObject
        item.name = "linkBtn" .. index
        item:SetActive(true)
        item.transform:SetParent(self.linkBtnPanel.transform)
        local cell = self.linkBtnPanel:AddComponent(UIActCommunityLinkBtn, item.name)
        cell:SetData(value, function()
          self:OnClickCommunityBtn(value.linkUrl)
        end)
        if nowIndex == count then
          EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
        end
      end)
      table.insert(self.itemReqs, req)
    end
  end
end

local function Refresh(self)
  self.state = DataCenter.ActCommunityLinkManager:GetState()
  self.numText:SetText(DataCenter.ActCommunityLinkManager:GetRewardNum(self.state))
  self.bindingText:SetActive(false)
  self.canClaimText:SetActive(false)
  self.claimedText:SetActive(false)
  self.rewardEffect:SetActive(false)
  if self.state == CommunityLinkState.CanGetSkipReward then
    self.canClaimText:SetActive(true)
    self.rewardEffect:SetActive(true)
  elseif self.state == CommunityLinkState.CannotBinding then
    self.claimedText:SetActive(true)
  elseif self.state == CommunityLinkState.CanBinding then
    self.bindingText:SetActive(true)
  elseif self.state == CommunityLinkState.CanGetBindingReward then
    self.canClaimText:SetActive(true)
    self.rewardEffect:SetActive(true)
  elseif self.state == CommunityLinkState.ClaimedBindingReward then
    self.claimedText:SetActive(true)
  end
  if self.needRefresh then
    self.needRefresh = false
    EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
    Logger.LogInfo("UIActCommunityLink isBind: " .. DataCenter.ActCommunityLinkManager.isBind)
    Logger.LogInfo("UIActCommunityLink state: " .. self.state)
  end
end

local function OpenLinkUrl(self, url)
  Logger.LogInfo("OpenLinkUrl: " .. url)
  PostEventLog.Track(PostEventLog.Defines.UIActCommunityLink, {url = url})
  CS.SDKManager.OpenURL(url)
end

local function OnClickCommunityBtn(self, url)
  if self.state == CommunityLinkState.NotSkip then
    SFSNetwork.SendMessage(MsgDefines.CommunitySkip, self.activityId)
  end
  self:OpenLinkUrl(url)
end

local function OnClickGetRewardBtn(self)
  if self.state == CommunityLinkState.NotSkip then
    UIUtil.ShowTipsId("activity_binding_tips_01")
  elseif self.state == CommunityLinkState.CanGetSkipReward then
    SFSNetwork.SendMessage(MsgDefines.CommunityReveiveSkipReward, self.activityId)
  elseif self.state == CommunityLinkState.CanBinding then
    local dcUrl = DataCenter.ActCommunityLinkManager:GetDCBindUrl()
    self:OpenLinkUrl(dcUrl)
  elseif self.state == CommunityLinkState.CanGetBindingReward then
    SFSNetwork.SendMessage(MsgDefines.CommunityReveiveBindingReward, self.activityId)
  end
end

local function OnApplicationPause(self, isPaused)
  if not isPaused then
    if self.needRefresh then
      Logger.LogInfo("UIActCommunityLink OnApplicationPause SendGetInfoMsg")
      self:SendGetInfoMsg()
    end
  elseif self.state ~= nil and self.state == CommunityLinkState.NotSkip or self.state == CommunityLinkState.CanBinding then
    self.needRefresh = true
  end
end

local function OnLoadComplete(self)
  if self.state ~= nil and self.state == CommunityLinkState.NotSkip or self.state == CommunityLinkState.CanBinding then
    self.needRefresh = true
    Logger.LogInfo("UIActCommunityLink OnLoadComplete SendGetInfoMsg")
    self:SendGetInfoMsg()
  end
end

local function SendGetInfoMsg(self)
  SFSNetwork.SendMessage(MsgDefines.CommunityBindingGetInfo, self.activityId)
end

UIActCommunityLink.OnCreate = OnCreate
UIActCommunityLink.OnDestroy = OnDestroy
UIActCommunityLink.OnEnable = OnEnable
UIActCommunityLink.OnDisable = OnDisable
UIActCommunityLink.ComponentDefine = ComponentDefine
UIActCommunityLink.ComponentDestroy = ComponentDestroy
UIActCommunityLink.DataDefine = DataDefine
UIActCommunityLink.DataDestroy = DataDestroy
UIActCommunityLink.OnAddListener = OnAddListener
UIActCommunityLink.OnRemoveListener = OnRemoveListener
UIActCommunityLink.SetData = SetData
UIActCommunityLink.Refresh = Refresh
UIActCommunityLink.OpenLinkUrl = OpenLinkUrl
UIActCommunityLink.OnClickGetRewardBtn = OnClickGetRewardBtn
UIActCommunityLink.OnClickCommunityBtn = OnClickCommunityBtn
UIActCommunityLink.OnApplicationPause = OnApplicationPause
UIActCommunityLink.SendGetInfoMsg = SendGetInfoMsg
UIActCommunityLink.OnLoadComplete = OnLoadComplete
UIActCommunityLink.RefreshLinkBtnPanel = RefreshLinkBtnPanel
UIActCommunityLink.ClearLinkBtnPanel = ClearLinkBtnPanel
return UIActCommunityLink
