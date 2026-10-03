local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local UIActLotteLink = BaseClass("UIActLotteLink", base)
local UIActCommunityLinkBtn = require("UI.UIActivityCenterTable.Component.UIActCommunityLink.UIActCommunityLinkBtn")
local titleText_path = "TopPanel/TitleText"
local desText_path = "TopPanel/DesText"
local tick_time_path = "TopPanel/DesText/RemainTime/bg/TickTime"
local linkBtnPanel_path = "DownPanel/LinkBtnPanel"
local video_btn_path = "MiddlePanel/VideoBtn"
local video_desc_text_path = "MiddlePanel/OfficialBtn/VideoDescText"
local official_btn_path = "MiddlePanel/OfficialBtn"
local state1_desc_text_path = "MiddlePanel/State1DescText"
local state2_desc_text_path = "MiddlePanel/State2DescText"
local btnPath = "Assets/Main/Prefabs/UI/ActivityCenter/ActCommunityLink/UIActCommunityLinkBtn.prefab"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:SetData()
  self.timer = TimerManager:GetInstance():GetTimer(1, self.OnTick, self, false, false, false)
  self.timer:Start()
  self:OnTick()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.titleText = self:AddComponent(UIText, titleText_path)
  self.desText = self:AddComponent(UIText, desText_path)
  self.remainTimeText = self:AddComponent(UIText, tick_time_path)
  self.linkBtnPanel = self:AddComponent(UIBaseContainer, linkBtnPanel_path)
  self.videoBtn = self:AddComponent(UIButton, video_btn_path)
  self.videoDescText = self:AddComponent(UIText, video_desc_text_path)
  self.officialBtn = self:AddComponent(UIButton, official_btn_path)
  self.state1DescText = self:AddComponent(UIText, state1_desc_text_path)
  self.state2DescText = self:AddComponent(UIText, state2_desc_text_path)
  self.videoBtn:SetOnClick(function()
    self:OnVideoBtnClick()
  end)
  self.officialBtn:SetOnClick(function()
    self:OnOfficialBtnClick()
  end)
end

local function ComponentDestroy(self)
  self:ClearLinkBtn()
  self.titleText = nil
  self.desText = nil
  self.linkBtnPanel = nil
  self.videoBtn = nil
  self.officialBtn = nil
end

local function DataDefine(self)
  self.data = nil
  self.needRefresh = false
  self.activityId = 0
  self.curState = 0
  self.state1EndTimestamp = 0
end

local function DataDestroy(self)
  self.data = nil
  self.needRefresh = nil
  self.activityId = nil
  self.vedioUrl = nil
  self.allLinkList = nil
  self.officialBtnKey = nil
  self.officialUrl = nil
  self.state1DescKey = nil
  self.state2DescKey = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.LOAD_COMPLETE, self.OnLoadComplete)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.LOAD_COMPLETE, self.OnLoadComplete)
  base.OnRemoveListener(self)
end

local function SetData(self, activityId)
  base.SetData(self, activityId)
  self.activityId = activityId
  if not self.activityId then
    return
  end
  self.activityData = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  self:Refresh()
end

local function Refresh(self)
  if not self.activityData then
    return
  end
  self:ParseLinkBtnInfo()
  self:OnTick()
  self:GenLinkBtn()
  self:RefreshGoToBtnState()
  if self.activityData.bannerTittle and self.titleText then
    self.titleText:SetLocalText(self.activityData.bannerTittle)
  end
  if self.activityData.story and self.desText then
    self.desText:SetLocalText(self.activityData.story)
  end
  if self.officialBtnKey and self.videoDescText then
    self.videoDescText:SetLocalText(self.officialBtnKey)
  end
  if self.state2DescKey and self.state2DescText then
    self.state2DescText:SetLocalText(self.state2DescKey)
  end
  local prevState = CommonUtil.PlayerPrefsGetInt("LOTTE_TICKET_STATE", -1)
  if self.curState ~= prevState then
    CommonUtil.PlayerPrefsSetInt("LOTTE_TICKET_STATE", self.curState)
    EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
  end
end

local function ParseLinkBtnInfo(self)
  if not self.activityData or not self.activityData.para2 then
    return
  end
  self.allLinkList = {}
  self.videoUrl = self.activityData.para_2
  local officialInfoArr = self.activityData.para_3
  if officialInfoArr then
    officialInfoArr = string.split(officialInfoArr, ";")
    if 2 <= #officialInfoArr then
      self.officialBtnKey = officialInfoArr[1]
      self.officialUrl = officialInfoArr[2]
    end
  end
  local linkBtnInfo = self.activityData.para_4
  local linkBtnInfoArr1 = string.split(linkBtnInfo, "|")
  for _, linkInfo in ipairs(linkBtnInfoArr1) do
    local linkInfo = string.split(linkInfo, ";")
    if 2 <= #linkInfo then
      local info = {}
      info.iconPath = string.format(UIAssets.CommunityLinkBtnIcon, linkInfo[1])
      info.linkUrl = linkInfo[2]
      table.insert(self.allLinkList, info)
    end
  end
  self.curState = -1
  local btnStateInfo = self.activityData.para_6
  local btnStateInfoArr = string.split(btnStateInfo, ";")
  if 2 <= #btnStateInfoArr then
    self.curState = tonumber(btnStateInfoArr[1])
    self.state1EndTimestamp = tonumber(btnStateInfoArr[2]) * 1000
  elseif 1 <= #btnStateInfoArr then
    self.curState = tonumber(btnStateInfoArr[1])
  end
  local btnStateKeyInfo = self.activityData.para_7
  local btnStateKeyArr = string.split(btnStateKeyInfo, "|")
  if 2 <= #btnStateKeyArr then
    self.state1DescKey = btnStateKeyArr[1]
    self.state2DescKey = btnStateKeyArr[2]
  end
end

local function GenLinkBtn(self)
  self:ClearLinkBtn()
  if not self.allLinkList or #self.allLinkList < 0 then
    return
  end
  self.itemReqs = {}
  for index, linkInfo in ipairs(self.allLinkList) do
    local req = self:GameObjectInstantiateAsync(btnPath, function(req)
      if req == nil or IsNull(req.gameObject) then
        return
      end
      local item = req.gameObject
      item.name = "linkBtn" .. index
      item:SetActive(true)
      item.transform:SetParent(self.linkBtnPanel.transform)
      local cell = self.linkBtnPanel:AddComponent(UIActCommunityLinkBtn, item.name)
      cell:SetData(linkInfo, function()
        self:OnClickCommunityBtn(linkInfo.linkUrl)
      end)
    end)
    table.insert(self.itemReqs, req)
  end
end

local function ClearLinkBtn(self)
  self.linkBtnPanel:RemoveComponents(UIActCommunityLinkBtn)
  if self.itemReqs then
    for index, value in ipairs(self.itemReqs) do
      self:GameObjectDestroy(value)
    end
    self.itemReqs = nil
  end
end

local function OpenLinkUrl(self, url)
  Logger.LogInfo("OpenLinkUrl: " .. url)
  CS.SDKManager.OpenURL(url)
end

local function OnClickCommunityBtn(self, url)
  self:OpenLinkUrl(url)
end

local function OnTick(self)
  if not self.activityData then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local endTime = self.activityData.endTime
  local remainTime = endTime - curTime
  if 0 < remainTime then
    self.remainTimeText:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
  else
    self.remainTimeText:SetText("00:00:00")
  end
  if self.curState and self.curState == 1 then
    local isNeedSwitchState = self.state1EndTimestamp and curTime >= self.state1EndTimestamp
    if isNeedSwitchState then
      self.curState = 3
      self:RefreshGoToBtnState()
    elseif self.state1DescKey and not IsNull(self.state1DescText) then
      local state1RemainTimeVal = self.state1EndTimestamp - curTime
      local state1RemainTime = UITimeManager:GetInstance():MilliSecondToFmtString(state1RemainTimeVal)
      local state1Str = CS.GameEntry.Localization:GetString(self.state1DescKey, state1RemainTime)
      self.state1DescText:SetText(state1Str)
    end
  end
end

local function RefreshGoToBtnState(self)
  if self.curState == nil then
    if not IsNull(self.officialBtn) then
      self.officialBtn.gameObject:SetActive(true)
    end
    return
  end
  if not IsNull(self.officialBtn) then
    self.officialBtn.gameObject:SetActive(self.curState == 3)
  end
  if not IsNull(self.state1DescText) then
    self.state1DescText.gameObject:SetActive(self.curState == 1)
  end
  if not IsNull(self.state2DescText) then
    self.state2DescText.gameObject:SetActive(self.curState == 2)
  end
end

local function OnVideoBtnClick(self)
  if self.videoUrl == nil then
    return
  end
  self:OpenLinkUrl(self.videoUrl)
end

local function OnOfficialBtnClick(self)
  if self.officialUrl == nil then
    return
  end
  self:OpenLinkUrl(self.officialUrl)
end

UIActLotteLink.OnCreate = OnCreate
UIActLotteLink.OnDestroy = OnDestroy
UIActLotteLink.OnEnable = OnEnable
UIActLotteLink.OnDisable = OnDisable
UIActLotteLink.ComponentDefine = ComponentDefine
UIActLotteLink.ComponentDestroy = ComponentDestroy
UIActLotteLink.DataDefine = DataDefine
UIActLotteLink.DataDestroy = DataDestroy
UIActLotteLink.OnAddListener = OnAddListener
UIActLotteLink.OnRemoveListener = OnRemoveListener
UIActLotteLink.SetData = SetData
UIActLotteLink.Refresh = Refresh
UIActLotteLink.OpenLinkUrl = OpenLinkUrl
UIActLotteLink.OnClickCommunityBtn = OnClickCommunityBtn
UIActLotteLink.OnTick = OnTick
UIActLotteLink.ParseLinkBtnInfo = ParseLinkBtnInfo
UIActLotteLink.GenLinkBtn = GenLinkBtn
UIActLotteLink.ClearLinkBtn = ClearLinkBtn
UIActLotteLink.OnVideoBtnClick = OnVideoBtnClick
UIActLotteLink.OnOfficialBtnClick = OnOfficialBtnClick
UIActLotteLink.RefreshGoToBtnState = RefreshGoToBtnState
return UIActLotteLink
