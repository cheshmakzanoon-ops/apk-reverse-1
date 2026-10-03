local DetectEventHelpTipContent = BaseClass("DetectEventHelpTipContent", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local CommonMessageBarItem = require("UI.UILWRadarCenter.UIDetectEvent.Component.CommonMessageBarItem")
local closeBtn_path = ""
local messageItem_path = "msgItem"
local flyEndEffect_path = "flyEndEffect"
local timeBeforeFadeOut = 0.6

local function OnCreate(self)
  base.OnCreate(self)
  self.messageItems = {}
  for i = 1, 2 do
    local tempItem = self:AddComponent(CommonMessageBarItem, messageItem_path .. i)
    table.insert(self.messageItems, tempItem)
  end
  self.flyEndEffect = self:AddComponent(UIBaseContainer, flyEndEffect_path)
  self.flyEndEffect:SetActive(false)
  self.isOpen = false
  self.isReady = false
  self.displayTime = 0
  self.showEndTime = 0
  self.inUseItems = self.messageItems
  self.outUseItems = {}
  self.displayingIndex = 0
  self:TryDisplayNext()
end

local function OnDestroy(self)
  if self.messageItems then
    for i, v in ipairs(self.messageItems) do
      v:ResetItem()
    end
  end
  self.flyEndEffect = nil
  self.isOpen = false
  self.isReady = false
  self.messageItems = nil
  self.msgQueue = nil
  self:DeleteTimer()
  base.OnDestroy(self)
end

local function OnAddListener(self)
  self:AddUIListener(EventId.GetAllDetectInfo, self.OnGetDetectInfoChange)
  self:AddUIListener(EventId.DetectInfoChange, self.OnGetDetectInfoChange)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.GetAllDetectInfo, self.OnGetDetectInfoChange)
  self:RemoveUIListener(EventId.DetectInfoChange, self.OnGetDetectInfoChange)
end

local function SetClose(self)
  self.isOpen = false
  self:HideAllItem()
end

local function SetOpen(self)
  self.isOpen = true
  TimerManager:GetInstance():DelayInvoke(function()
    self:RefreshShowData()
  end, 1)
end

local function AddNewMsg(self, newMsg, showTime)
  if not self.msgQueue then
    self.msgQueue = {}
  end
  if self.msgQueue == nil then
    self.msgQueue = {}
  end
  if showTime ~= nil then
    self.showEndTime = showTime
  else
    self.showEndTime = 3
  end
  table.insert(self.msgQueue, newMsg)
  self:TryDisplayNext()
  if not self.timer then
    self.timer = TimerManager:GetInstance():GetTimer(timeBeforeFadeOut, self.TimerAction, self, false, false, false)
    self.timer:Start()
  end
  if self.isReady then
    self.timer:Reset()
  end
end

local function AddNewMsg_Msg(self, msg, showTime, playerHead, msgUid)
  local newMsg = {
    msg = msg,
    playerHead = playerHead,
    msgUid = msgUid
  }
  self:AddNewMsg(newMsg, showTime)
end

local function TryDisplayNext(self)
  if self.isReady then
    if self.msgQueue and #self.msgQueue > 0 then
      local freeItem, freeIndex = self:GetOneFreeItem()
      local nextMsg = self:GetNextMsg()
      freeItem:ResetItem()
      freeItem:FadeIn(nextMsg)
      self.displayTime = 0
      local effectPath = "Assets/_Art/Effect/prefab/ui/VFX_leida_trail.prefab"
      local startPos = freeItem.playerHeadN.transform.position
      self.view.eventPosCal.transform.localPosition = self.view.ctrl:GetDetectEventPosition(nextMsg.msgUid)
      local endPos = self.view.eventPosCal.transform.position
      DataCenter.RadarCenterDataManager:AddOneHelpRecordUid(nextMsg.msgUid)
      TimerManager:GetInstance():DelayInvoke(function()
        UIUtil.DoFlySimpleFunc(effectPath, startPos, endPos, 1, nil, function()
          if self.flyEndEffect then
            self.flyEndEffect.transform.position = endPos
            self.flyEndEffect:SetActive(false)
            self.flyEndEffect:SetActive(true)
          end
        end)
      end, 0.5)
      local displayingItem = self:GetDisplayingItem()
      if displayingItem then
        displayingItem:FadeOut()
      end
      self.displayingIndex = freeIndex
      self.isReady = false
    elseif self.displayTime >= self.showEndTime then
      self.isOpen = false
      local displayingItem = self:GetDisplayingItem()
      if displayingItem then
        displayingItem:FadeOut()
      end
      self:DeleteTimer()
    end
  end
end

local function GetNextMsg(self)
  while true do
    if self.msgQueue and #self.msgQueue > 0 then
      local msg = self.msgQueue[1]
      table.remove(self.msgQueue, 1)
      if msg then
        return msg
      end
    end
  end
end

local function TimerAction(self)
  if self.displayTime == nil then
    return
  end
  self.displayTime = self.displayTime + timeBeforeFadeOut
  if self.displayTime >= self.showEndTime then
    self.isReady = true
  end
  self:TryDisplayNext()
end

local function DeleteTimer(self)
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

local function GetOneFreeItem(self)
  if self.displayingIndex ~= 1 then
    return self.messageItems[1], 1
  else
    return self.messageItems[2], 2
  end
end

local function GetDisplayingItem(self)
  if self.displayingIndex ~= 0 then
    return self.messageItems[self.displayingIndex]
  else
    return nil
  end
end

local function OnGetDetectInfoChange(self)
  self:RefreshShowData()
end

local function RefreshShowData(self)
  if not self.isOpen then
    return
  end
  self:HideAllItem()
  self.isReady = true
  self.msgQueue = nil
  self.flyEndEffect:SetActive(false)
  DataCenter.RadarCenterDataManager:UpdateHelperRecordTab()
  local beHelpedUidList = DataCenter.RadarCenterDataManager:GetBeHelpedDetectUid()
  local helpRecordUidList = DataCenter.RadarCenterDataManager:GeteHelperRecordTab()
  local showList = {}
  for k, uid in ipairs(beHelpedUidList) do
    if helpRecordUidList[uid] == nil then
      table.insert(showList, uid)
    end
  end
  for k, uid in ipairs(showList) do
    local data = DataCenter.RadarCenterDataManager:GetDetectEventInfo(uid)
    if data ~= nil then
      local strMsg = Localization:GetString("801341", data.completeByHelper.name)
      local playerHead = {
        uid = data.completeByHelper.uid,
        pic = data.completeByHelper.pic,
        picVer = data.completeByHelper.picVer
      }
      self:AddNewMsg_Msg(strMsg, 1, playerHead, uid)
    end
  end
end

local function HideAllItem(self)
  for k, item in pairs(self.messageItems) do
    item:ResetItem()
  end
  self.displayingIndex = 0
end

DetectEventHelpTipContent.OnCreate = OnCreate
DetectEventHelpTipContent.OnDestroy = OnDestroy
DetectEventHelpTipContent.OnAddListener = OnAddListener
DetectEventHelpTipContent.OnRemoveListener = OnRemoveListener
DetectEventHelpTipContent.SetOpen = SetOpen
DetectEventHelpTipContent.SetClose = SetClose
DetectEventHelpTipContent.AddNewMsg = AddNewMsg
DetectEventHelpTipContent.AddNewMsg_Msg = AddNewMsg_Msg
DetectEventHelpTipContent.TryDisplayNext = TryDisplayNext
DetectEventHelpTipContent.DeleteTimer = DeleteTimer
DetectEventHelpTipContent.GetNextMsg = GetNextMsg
DetectEventHelpTipContent.TimerAction = TimerAction
DetectEventHelpTipContent.GetOneFreeItem = GetOneFreeItem
DetectEventHelpTipContent.GetDisplayingItem = GetDisplayingItem
DetectEventHelpTipContent.OnGetDetectInfoChange = OnGetDetectInfoChange
DetectEventHelpTipContent.RefreshShowData = RefreshShowData
DetectEventHelpTipContent.HideAllItem = HideAllItem
return DetectEventHelpTipContent
