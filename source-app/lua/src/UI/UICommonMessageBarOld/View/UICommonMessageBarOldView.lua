local UICommonMessageBarOldView = BaseClass("UICommonMessageBarOldView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local CommonMessageBarItem = require("UI/UICommonMessageBarOld/View/CommonMessageBarItemOld")
local closeBtn_path = "Panel"
local messageItem_path = "Panel/msgItem"
local timeBeforeFadeOut = 0.6
local ItemDefaultPosY = -268

local function OnCreate(self)
  base.OnCreate(self)
  self.closeBtnN = self:AddComponent(UIButton, closeBtn_path)
  self.closeBtnN:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.messageItems = {}
  for i = 1, 2 do
    local tempItem = self:AddComponent(CommonMessageBarItem, messageItem_path .. i)
    table.insert(self.messageItems, tempItem)
  end
  self.isReady = true
  self.displayTime = 0
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
  self.closeBtnN = nil
  self.messageItems = nil
  self.msgQueue = nil
  self:DeleteTimer()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self.isReady = true
  if self.closeBtnN then
    self.closeBtnN:SetAnchoredPositionXY(0, self.showHeight or ItemDefaultPosY)
  end
end

local function OnDisable(self)
  base.OnDisable(self)
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
    self.showEndTime = 1
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

local function AddNewMsg_Msg(self, msg, showTime, playerHead, heroHead, showHeight, isAlHelpMsg, alHelpInfo)
  local newMsg = {
    msg = msg,
    playerHead = playerHead,
    heroHead = heroHead,
    isAlHelpMsg = isAlHelpMsg,
    alHelpInfo = DeepCopy(alHelpInfo)
  }
  self.showHeight = showHeight or ItemDefaultPosY
  if self.closeBtnN and self.showHeight then
    self.closeBtnN:SetAnchoredPositionXY(0, self.showHeight)
  end
  self:AddNewMsg(newMsg, showTime, showHeight)
end

local function AddNewMsg_MsgId(self, msgId, showTime, playerHead, heroHead, isAlHelpMsg, alHelpInfo)
  local newMsg = {
    msgId = msgId,
    playerHead = playerHead,
    heroHead = heroHead,
    isAlHelpMsg = isAlHelpMsg,
    alHelpInfo = DeepCopy(alHelpInfo)
  }
  self.showHeight = ItemDefaultPosY
  if self.closeBtnN and self.showHeight then
    self.closeBtnN:SetAnchoredPositionXY(0, self.showHeight)
  end
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
      local displayingItem = self:GetDisplayingItem()
      if displayingItem then
        displayingItem:FadeOut()
      end
      self.displayingIndex = freeIndex
      self.isReady = false
    elseif self.displayTime >= self.showEndTime then
      self.ctrl:CloseSelf()
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
  self.isReady = true
  self.displayTime = self.displayTime + timeBeforeFadeOut
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

UICommonMessageBarOldView.OnCreate = OnCreate
UICommonMessageBarOldView.OnDestroy = OnDestroy
UICommonMessageBarOldView.OnEnable = OnEnable
UICommonMessageBarOldView.OnDisable = OnDisable
UICommonMessageBarOldView.AddNewMsg = AddNewMsg
UICommonMessageBarOldView.AddNewMsg_Msg = AddNewMsg_Msg
UICommonMessageBarOldView.AddNewMsg_MsgId = AddNewMsg_MsgId
UICommonMessageBarOldView.TryDisplayNext = TryDisplayNext
UICommonMessageBarOldView.DeleteTimer = DeleteTimer
UICommonMessageBarOldView.GetNextMsg = GetNextMsg
UICommonMessageBarOldView.TimerAction = TimerAction
UICommonMessageBarOldView.GetOneFreeItem = GetOneFreeItem
UICommonMessageBarOldView.GetDisplayingItem = GetDisplayingItem
return UICommonMessageBarOldView
