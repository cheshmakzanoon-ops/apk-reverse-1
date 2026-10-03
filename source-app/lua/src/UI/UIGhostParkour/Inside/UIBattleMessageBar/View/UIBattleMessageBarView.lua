local UIBattleMessageBarView = BaseClass("UIBattleMessageBarView", UIBaseView)
local base = UIBaseView
local UIBattleMessageBarItem = require("UI.UIGhostParkour.Inside.UIBattleMessageBar.View.UIBattleMessageBarItem")
local closeBtn_path = "Panel"
local messageItem_path = "Panel/msgItem"
local timeBeforeFadeOut = 1.5
local itemState = {
  Free = 1,
  Showing = 2,
  FadeOut = 3
}
local ItemDefaultPosY = 266

local function OnCreate(self)
  base.OnCreate(self)
  self.closeBtnN = self:AddComponent(UIButton, closeBtn_path)
  self.closeBtnN:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.messageItems = {}
  self.itemStates = {}
  for i = 1, 3 do
    local tempItem = self:AddComponent(UIBattleMessageBarItem, messageItem_path .. i)
    table.insert(self.messageItems, tempItem)
    table.insert(self.itemStates, itemState.Free)
  end
  self.isReady = true
  self.displayTime = 0
  self.inUseItems = self.messageItems
  self.outUseItems = {}
  self.displayingIndex = 0
  self.closeBtnN:SetAnchoredPositionXY(self.closeBtnN:GetAnchoredPositionX(), self.showHeight or ItemDefaultPosY)
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
  local hasFreeItemNow = self:TryDisplayNext()
  if not self.timer then
    self.timer = TimerManager:GetInstance():GetTimer(timeBeforeFadeOut, self.TimerAction, self, false, false, false)
    self.timer:Start()
  end
  if hasFreeItemNow then
    self.timer:Reset()
  end
end

local function AddNewMsg_Msg(self, msg, showTime, playerHead, heroHead, showHeight)
  self.showHeight = ItemDefaultPosY
  if showHeight then
    self.showHeight = showHeight
  end
  if self.closeBtnN then
    self.closeBtnN:SetAnchoredPositionXY(self.closeBtnN:GetAnchoredPositionX(), self.showHeight)
  end
  local newMsg = {
    msg = msg,
    playerHead = playerHead,
    heroHead = heroHead
  }
  self:AddNewMsg(newMsg, showTime)
end

local function AddNewMsg_MsgId(self, msgId, showTime, playerHead, heroHead, offsetY)
  local newMsg = {
    msgId = msgId,
    playerHead = playerHead,
    heroHead = heroHead,
    offsetY = offsetY
  }
  self:AddNewMsg(newMsg, showTime)
end

local function TryDisplayNext(self)
  if self.msgQueue and #self.msgQueue > 0 then
    local freeItemIndex = self:GetItemIndex(itemState.Free)
    if 0 < freeItemIndex and self.messageItems[freeItemIndex] then
      local showingItemIndex = self:GetItemIndex(itemState.Showing)
      if 0 < showingItemIndex and self.messageItems[showingItemIndex] then
        local fadeOutItemIndex = self:GetItemIndex(itemState.FadeOut)
        if 0 < fadeOutItemIndex and self.messageItems[fadeOutItemIndex] then
          self.messageItems[fadeOutItemIndex]:ResetItem()
          self.itemStates[fadeOutItemIndex] = itemState.Free
        end
        self.messageItems[showingItemIndex]:FadeOut(function()
          if self.itemStates and self.itemStates[showingItemIndex] == itemState.FadeOut then
            self.itemStates[showingItemIndex] = itemState.Free
          end
        end)
        self.itemStates[showingItemIndex] = itemState.FadeOut
      end
      local nextMsg = self:GetNextMsg()
      self.messageItems[freeItemIndex]:ResetItem()
      self.messageItems[freeItemIndex]:FadeIn(nextMsg)
      self.itemStates[freeItemIndex] = itemState.Showing
      self.displayTime = 0
      local panelPos = self.showHeight or ItemDefaultPosY
      if nextMsg.offsetY then
        panelPos = panelPos + nextMsg.offsetY
      end
      self.closeBtnN:SetAnchoredPositionXY(0, panelPos)
      return true
    end
  elseif self.displayTime >= (self.showEndTime or 1) then
    self.ctrl:CloseSelf()
  end
  return false
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
  self:TryDisplayNext()
end

local function DeleteTimer(self)
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

local function GetItemIndex(self, state)
  if self.itemStates then
    for i, v in pairs(self.itemStates) do
      if v == state then
        return i
      end
    end
  end
  return 0
end

UIBattleMessageBarView.OnCreate = OnCreate
UIBattleMessageBarView.OnDestroy = OnDestroy
UIBattleMessageBarView.OnEnable = OnEnable
UIBattleMessageBarView.OnDisable = OnDisable
UIBattleMessageBarView.AddNewMsg = AddNewMsg
UIBattleMessageBarView.AddNewMsg_Msg = AddNewMsg_Msg
UIBattleMessageBarView.AddNewMsg_MsgId = AddNewMsg_MsgId
UIBattleMessageBarView.TryDisplayNext = TryDisplayNext
UIBattleMessageBarView.DeleteTimer = DeleteTimer
UIBattleMessageBarView.GetNextMsg = GetNextMsg
UIBattleMessageBarView.TimerAction = TimerAction
UIBattleMessageBarView.GetItemIndex = GetItemIndex
return UIBattleMessageBarView
