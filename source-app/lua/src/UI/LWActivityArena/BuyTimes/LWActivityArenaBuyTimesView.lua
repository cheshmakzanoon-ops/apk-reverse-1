local LWActivityArenaBuyTimesView = BaseClass("LWActivityArenaBuyTimesView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local Notifier = require("Common.Notifier")
local compBook = {
  {
    path = "txtTitle",
    name = "txtTitle",
    type = UIText,
    textKey = "500270"
  },
  {
    path = "btnClose",
    name = "btnClose",
    type = UIButton,
    onClick = function(self)
      self.ctrl:CloseSelf()
    end
  },
  {
    path = "black",
    name = "btnBlack",
    type = UIButton,
    onClick = function(self)
      self.ctrl:CloseSelf()
    end
  },
  {
    path = "txtContent",
    name = "txtContent",
    type = UIText,
    textKey = "801111"
  },
  {
    path = "txtTip",
    name = "txtTip",
    type = UIText,
    textKey = "500271"
  },
  {
    path = "txtTimes",
    name = "txtTimes",
    type = UIText,
    textKey = "500272"
  },
  {
    path = "btnBuy",
    name = "btnBuy",
    type = UIButton,
    onClick = function(self)
      self:OnClickBuy()
    end
  },
  {
    path = "btnBuy/txtBuy",
    name = "txtBuy",
    type = UIText,
    textKey = "129011"
  },
  {
    path = "btnBuy/layout",
    name = "btnLayout",
    type = nil
  },
  {
    path = "btnBuy/layout/txtCount",
    name = "txtCount",
    type = UIText,
    text = ""
  },
  {
    path = "Slider",
    name = "slider",
    type = UISlider
  },
  {
    path = "subBtn",
    name = "subBtn",
    type = UIButton
  },
  {
    path = "addBtn",
    name = "addBtn",
    type = UIButton
  },
  {
    path = "curCountIpt",
    name = "curCountIpt",
    type = UIInput
  }
}

function LWActivityArenaBuyTimesView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  local arenaInfo, callback = self:GetUserData()
  self:Refresh(arenaInfo, callback)
  self.__waiting_for_server = nil
end

function LWActivityArenaBuyTimesView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWActivityArenaBuyTimesView:ComponentDefine()
  self:DefineCompsByBook(compBook)
  self.subBtn:SetOnClick(function()
    self:OnClickSubBtn()
  end)
  self.addBtn:SetOnClick(function()
    self:OnClickAddBtn()
  end)
  self.slider:SetOnValueChanged(function(value)
    self:OnSliderValueChange(value)
  end)
  self.curCountIpt:SetOnEndEdit(function(value)
    self:OnCurNumIptValueChange(value)
  end)
end

function LWActivityArenaBuyTimesView:ComponentDestroy()
  self:ClearCompsByBook(compBook)
end

function LWActivityArenaBuyTimesView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ServerError, self.OnError)
  self:AddUIListener(EventId.ActivityArenaBuyTimesBack, self.OnSuccess)
end

function LWActivityArenaBuyTimesView:OnRemoveListener()
  self:RemoveUIListener(EventId.ServerError, self.OnError)
  self:RemoveUIListener(EventId.ActivityArenaBuyTimesBack, self.OnSuccess)
  base.OnRemoveListener(self)
end

function LWActivityArenaBuyTimesView:Refresh(arenaInfo, callback)
  self.arenaInfo = arenaInfo
  self.callback = callback
  if not self.costMap then
    self.costMap = {}
    local strs = string.split(self.arenaInfo.buy_diamond_cost, "|")
    for _, str in ipairs(strs) do
      local arr = string.split(str, ";")
      self.costMap[tonumber(arr[1])] = tonumber(arr[2])
    end
  end
  self.txtTimes:SetText(Localization:GetString("500272", arenaInfo.remainBuy .. "/" .. arenaInfo.buy_times_limit))
  self.curCount = 1
  self:TrySetCurNum(self.curCount)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.btnLayout.transform)
end

function LWActivityArenaBuyTimesView:TrySetCurNum(num)
  local tmpNum = tonumber(num) or self.curCount
  if tmpNum <= 0 then
    tmpNum = 1
  elseif tmpNum > self.arenaInfo.remainBuy then
    tmpNum = self.arenaInfo.remainBuy
  end
  tmpNum = Mathf.Round(tmpNum)
  self.curCount = tmpNum
  self.curCountIpt:SetText(self.curCount)
  self.slider:SetValue(self.curCount / self.arenaInfo.remainBuy)
  local buyTimes = self.arenaInfo.buy_times_limit - self.arenaInfo.remainBuy
  self.cost = 0
  for i = 1, self.curCount do
    self.cost = self.cost + self.costMap[buyTimes + i] or self.costMap[#self.costMap]
  end
  self.txtContent:SetText(Localization:GetString("801111", self.cost, self.curCount))
  self.txtCount:SetText(string.GetFormattedGoldNum(self.cost))
end

function LWActivityArenaBuyTimesView:OnClickSubBtn()
  local num = self.curCount - 1
  self:TrySetCurNum(num)
end

function LWActivityArenaBuyTimesView:OnClickAddBtn()
  local num = self.curCount + 1
  self:TrySetCurNum(num)
end

function LWActivityArenaBuyTimesView:OnSliderValueChange(value)
  local num = self.arenaInfo.remainBuy * value
  self:TrySetCurNum(num)
end

function LWActivityArenaBuyTimesView:OnCurNumIptValueChange(value)
  self:TrySetCurNum(value)
end

function LWActivityArenaBuyTimesView:OnClickBuy()
  if self.__waiting_for_server then
    return
  end
  local gold = LuaEntry.Player.gold
  if gold < self.cost then
    GoToUtil.GotoPayTips(self.cost)
  else
    UIUtil.ShowUseDiamondConfirm(TodayNoSecondConfirmType.BuyActivityArenaTimes, Localization:GetString("500273"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      self.__waiting_for_server = true
      local arenaInfoId = self.arenaInfo.id
      if arenaInfoId ~= nil and tonumber(arenaInfoId) == DataCenter.LWNewbieArenaV2Manager:GetArenaInfoId() then
        SFSNetwork.SendMessage(MsgDefines.ActivityArenaV2BuyTimes, arenaInfoId, self.curCount)
      else
        SFSNetwork.SendMessage(MsgDefines.ActivityArenaBuyTimes, arenaInfoId, self.curCount)
      end
    end, function()
    end, nil, nil, false, DataCenter.ResourceManager:GetResourceIconByType(ResourceType.Gold), nil)
  end
end

function LWActivityArenaBuyTimesView:OnError(msgName)
  if msgName == MsgDefines.ActivityArenaBuyTimes then
    self.__waiting_for_server = nil
  elseif msgName == MsgDefines.ActivityArenaV2BuyTimes then
    self.__waiting_for_server = nil
  end
end

function LWActivityArenaBuyTimesView:OnSuccess(msgTbl)
  self.__waiting_for_server = nil
  if self.arenaInfo then
    self.arenaInfo.remainFree = msgTbl.remainFree
    self.arenaInfo.remainBuy = msgTbl.remainBuy
  end
  if msgTbl.remainGold ~= nil and type(msgTbl.remainGold) == "number" then
    LuaEntry.Player.gold = msgTbl.remainGold
    EventManager:GetInstance():Broadcast(EventId.UpdateGold)
  end
  local newbieArenaV2 = false
  local arenaInfoId = self.arenaInfo.id
  if arenaInfoId ~= nil and tonumber(arenaInfoId) == DataCenter.LWNewbieArenaV2Manager:GetArenaInfoId() then
    newbieArenaV2 = true
  end
  if newbieArenaV2 then
    Notifier.Dispatch("LWNewbieArenaV2PageArea.RefreshChallengeTimes")
  else
    Notifier.Dispatch("UIArenaNewbieArea.RefreshChallengeTimes")
  end
  self.ctrl:CloseSelf()
  if self.callback then
    self.callback()
  end
end

return LWActivityArenaBuyTimesView
