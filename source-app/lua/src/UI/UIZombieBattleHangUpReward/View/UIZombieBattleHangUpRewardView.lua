local UIZombieBattleHangUpRewardView = BaseClass("UIZombieBattleHangUpRewardView", UIBaseView)
local UIZombieBattleHangUpResourceCell = require("UI.UIZombieBattleHangUpReward.Component.UIZombieBattleHangUpResourceCell")
local UIZombieBattleHangUpRewardItem = require("UI.UIZombieBattleHangUpReward.Component.UIZombieBattleHangUpRewardItem")
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIScrollView = require("Framework.UI.Component.UIScrollView")
local PanelData = {
  [1] = {y = 61, sizeY = 850},
  [2] = {y = 16, sizeY = 1130}
}

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
  self.btnCloseBG = self:AddComponent(UIButton, "CloseBG")
  self.btnCloseBG:SetOnClick(function()
    self:OnBtnCloseBGClick()
  end)
  self.compBg = self:AddComponent(UIBaseContainer, "Bg")
  self.btnClose = self:AddComponent(UIButton, "Bg/TitleImg/CloseBtn")
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.textTitle = self:AddComponent(UIText, "Bg/TitleImg/TitleText")
  self.textTitle:SetLocalText("armed_truck_idle_reward_title")
  self.compScrollView = self:AddComponent(UIScrollView, "Bg/ScrollView")
  self.btnReceive = self:AddComponent(UIButton, "Bg/ReceiveBtn")
  self.btnReceive:SetOnClick(function()
    self:OnBtnReceiveClick()
  end)
  self.textReceiveBtn = self:AddComponent(UIText, "Bg/ReceiveBtn/ReceiveBtnText")
  self.textReceiveBtn:SetLocalText("800310")
  self.textTip = self:AddComponent(UIText, "Bg/TipText")
  self.tip_text2 = self:AddComponent(UIText, "Bg/TipText2")
  self.tip_text2:SetLocalText("armed_truck_reward_limit_19")
  self.scrollCellPool = {}
  self.itemIndex = 1
  self.compScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.compScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
end

local function ComponentDestroy(self)
  self:ClearScroll()
  self.btnCloseBG = nil
  self.compBg = nil
  self.btnClose = nil
  self.textTitle = nil
  self.compScrollView = nil
  self.btnReceive = nil
  self.textReceiveBtn = nil
  self.textTip = nil
  self.tip_text2 = nil
end

local function DataDefine(self)
  self.param = self:GetUserData()
  self:Refresh()
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function OnBtnCloseBGClick(self)
  self.ctrl:CloseSelf()
end

local function OnBtnCloseClick(self)
  self.ctrl:CloseSelf()
end

local function OnBtnReceiveClick(self)
  if DataCenter.StageManager.idleReward and #DataCenter.StageManager.idleReward > 0 or DataCenter.DomintorStageManager.idleReward and 0 < #DataCenter.DomintorStageManager.idleReward then
    self.ctrl:CloseSelf()
    SFSNetwork.SendMessage(MsgDefines.HangUpRewardMessage, 1)
  end
end

local function OnItemMoveIn(self, itemObj, index)
  local item = self.scrollCellPool[itemObj.name]
  if not item then
    local name = tostring(self.itemIndex)
    itemObj.name = name
    item = self.compScrollView:AddComponent(UIZombieBattleHangUpRewardItem, itemObj)
    self.scrollCellPool[name] = item
    self.itemIndex = self.itemIndex + 1
  end
  if index == 1 then
    item:Refresh(self.param, JeepAdventurePageType.TowerUp)
  elseif index == 2 then
    item:Refresh(self.param, JeepAdventurePageType.Domintor)
  end
end

local function OnItemMoveOut(self, itemObj, index)
end

local function ClearScroll(self)
  self.compScrollView:ClearCells()
  self.compScrollView:RemoveComponents(UIZombieBattleHangUpRewardItem)
  self.scrollCellPool = {}
  self.itemIndex = 1
end

local function Refresh(self)
  local num = 1
  local pos = self.compBg:GetLocalPosition()
  local size = self.compBg:GetSizeDelta()
  if DataCenter.DomintorStageManager.idleRewardStageId then
    num = 2
    self.compBg:SetLocalPositionXYZ(pos.x, PanelData[2].y, pos.z)
    self.compBg:SetSizeDeltaXY(size.x, PanelData[2].sizeY)
  else
    num = 1
    self.compBg:SetLocalPositionXYZ(pos.x, PanelData[1].y, pos.z)
    self.compBg:SetSizeDeltaXY(size.x, PanelData[1].sizeY)
  end
  self.compScrollView:SetTotalCount(num)
  self.compScrollView:RefillCells()
end

UIZombieBattleHangUpRewardView.OnCreate = OnCreate
UIZombieBattleHangUpRewardView.OnDestroy = OnDestroy
UIZombieBattleHangUpRewardView.OnEnable = OnEnable
UIZombieBattleHangUpRewardView.OnDisable = OnDisable
UIZombieBattleHangUpRewardView.ComponentDefine = ComponentDefine
UIZombieBattleHangUpRewardView.ComponentDestroy = ComponentDestroy
UIZombieBattleHangUpRewardView.DataDefine = DataDefine
UIZombieBattleHangUpRewardView.DataDestroy = DataDestroy
UIZombieBattleHangUpRewardView.OnAddListener = OnAddListener
UIZombieBattleHangUpRewardView.OnRemoveListener = OnRemoveListener
UIZombieBattleHangUpRewardView.OnBtnCloseBGClick = OnBtnCloseBGClick
UIZombieBattleHangUpRewardView.OnBtnCloseClick = OnBtnCloseClick
UIZombieBattleHangUpRewardView.OnBtnReceiveClick = OnBtnReceiveClick
UIZombieBattleHangUpRewardView.OnItemMoveIn = OnItemMoveIn
UIZombieBattleHangUpRewardView.OnItemMoveOut = OnItemMoveOut
UIZombieBattleHangUpRewardView.ClearScroll = ClearScroll
UIZombieBattleHangUpRewardView.Refresh = Refresh
return UIZombieBattleHangUpRewardView
