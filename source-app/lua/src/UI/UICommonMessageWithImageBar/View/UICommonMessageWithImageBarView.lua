local UICommonMessageWithImageBarView = BaseClass("UICommonMessageWithImageBarView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UICommonMessageWithImageBarItem = require("UI.UICommonMessageWithImageBar.View.UICommonMessageWithImageBarItem")
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
    local tempItem = self:AddComponent(UICommonMessageWithImageBarItem, messageItem_path .. i)
    table.insert(self.messageItems, tempItem)
    table.insert(self.itemStates, itemState.Free)
  end
  self.isReady = true
  self.displayTime = 0
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

local function AddNewMsg(self, newMsgObj, showTime)
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
  table.insert(self.msgQueue, newMsgObj)
  local hasFreeItemNow = self:TryDisplayNext()
  if not self.timer then
    self.timer = TimerManager:GetInstance():GetTimer(timeBeforeFadeOut, self.TimerAction, self, false, false, false)
    self.timer:Start()
  end
  if hasFreeItemNow then
    self.timer:Reset()
  end
end

local function AddNewMsg_Msg(self, msg1, imgPath, msg2, showTime, showHeight)
  self.showHeight = ItemDefaultPosY
  if showHeight then
    self.showHeight = showHeight
  end
  if self.closeBtnN then
    self.closeBtnN:SetAnchoredPositionXY(self.closeBtnN:GetAnchoredPositionX(), self.showHeight)
  end
  local newMsgObj = {
    msg1 = msg1,
    imgPath = imgPath,
    msg2 = msg2
  }
  self:AddNewMsg(newMsgObj, showTime)
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
  elseif self.displayTime >= self.showEndTime then
    self.ctrl:CloseSelf()
  end
  return false
end

local function GetNextMsg(self)
  while self.msgQueue do
    if #self.msgQueue > 0 then
      local msg = self.msgQueue[1]
      table.remove(self.msgQueue, 1)
      if msg then
        do return msg end
        else
          break
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

UICommonMessageWithImageBarView.OnCreate = OnCreate
UICommonMessageWithImageBarView.OnDestroy = OnDestroy
UICommonMessageWithImageBarView.OnEnable = OnEnable
UICommonMessageWithImageBarView.OnDisable = OnDisable
UICommonMessageWithImageBarView.AddNewMsg = AddNewMsg
UICommonMessageWithImageBarView.AddNewMsg_Msg = AddNewMsg_Msg
UICommonMessageWithImageBarView.TryDisplayNext = TryDisplayNext
UICommonMessageWithImageBarView.DeleteTimer = DeleteTimer
UICommonMessageWithImageBarView.GetNextMsg = GetNextMsg
UICommonMessageWithImageBarView.TimerAction = TimerAction
UICommonMessageWithImageBarView.GetItemIndex = GetItemIndex
return UICommonMessageWithImageBarView
