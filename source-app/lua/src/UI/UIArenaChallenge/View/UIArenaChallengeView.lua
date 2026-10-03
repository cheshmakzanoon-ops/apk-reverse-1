local base = UIBaseView
local UIArenaChallengeView = BaseClass("UIArenaChallengeView", base)
local Localization = CS.GameEntry.Localization
local ArenaRankItem = require("UI.UIActivityCenterTable.Component.ArenaMain.ArenaRankItem")
local title_path = "UICommonPopUpTitle/Common_img_title/titleText"
local closeBtn_path = "UICommonPopUpTitle/CloseBtn"
local selfObj_path = "offset/layout/selfObj"
local refreshBtn_path = "offset/refreshBtn"
local refreshBtnTxt_path = "offset/refreshBtn/refreshBtnTxt"
local challengeTimes_path = "offset/top/challengeTimes"
local ticket_path = "offset/top/tickets"
local ticketCount_path = "offset/top/tickets/ticketNum"
local buyTicketBtn_path = "offset/top/tickets/Common_btn_add"
local playerTxt_path = "offset/layout/listTitle/playerTxt"
local scoreTxt_path = "offset/layout/listTitle/scoreTxt"
local svTarget_path = "offset/layout/ScrollView"
local targetContent_path = "offset/layout/ScrollView/Viewport/Content"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitData()
end

local function OnDestroy(self)
  self:ClearScroll()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.titleN = self:AddComponent(UIText, title_path)
  self.titleN:SetLocalText(372258)
  self.closeBtnN = self:AddComponent(UIButton, closeBtn_path)
  self.closeBtnN:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.refreshBtnN = self:AddComponent(UIButton, refreshBtn_path)
  self.refreshBtnN:SetOnClick(function()
    self:OnClickRefreshBtn()
  end)
  self.refreshBtnTxtN = self:AddComponent(UIText, refreshBtnTxt_path)
  self.refreshBtnTxtN:SetLocalText(110028)
  self.challengeTimesN = self:AddComponent(UIText, challengeTimes_path)
  self.ticketN = self:AddComponent(UIBaseContainer, ticket_path)
  self.ticketN:SetActive(false)
  self.ticketCountN = self:AddComponent(UIText, ticketCount_path)
  self.buyTicketBtnN = self:AddComponent(UIButton, buyTicketBtn_path)
  self.buyTicketBtnN:SetOnClick(function()
    self:OnClickBuyTicketBtn()
  end)
  self.playerTxtN = self:AddComponent(UIText, playerTxt_path)
  self.playerTxtN:SetLocalText(100184)
  self.scoreTxtN = self:AddComponent(UIText, scoreTxt_path)
  self.scoreTxtN:SetLocalText(302042)
  self.svTargetN = self:AddComponent(UIScrollView, svTarget_path)
  self.svTargetN:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.svTargetN:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
  self.targetContentN = self:AddComponent(UIBaseContainer, targetContent_path)
end

local function ComponentDestroy(self)
  self.titleN = nil
  self.closeBtnN = nil
  self.refreshBtnN = nil
  self.refreshBtnTxtN = nil
  self.challengeTimesN = nil
  self.ticketCountN = nil
  self.buyTicketBtnN = nil
  self.playerTxtN = nil
  self.scoreTxtN = nil
  self.svTargetN = nil
  self.targetContentN = nil
end

local function DataDefine(self)
  self.targetList = nil
  self.challengeItemsDic = {}
  self.curDetailIndex = nil
end

local function DataDestroy(self)
  self.targetList = nil
  self.challengeItemsDic = nil
  self.curDetailIndex = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnUpdateArenaBaseInfo, self.RefreshAll)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.OnUpdateArenaBaseInfo, self.RefreshAll)
  base.OnRemoveListener(self)
end

local function InitData(self)
  self:RefreshAll()
  SFSNetwork.SendMessage(MsgDefines.GetArenaInfo, 1)
end

local function RefreshAll(self)
  local selfInfo = DataCenter.ArenaManager:GetSelfInfo()
  local maxChallengeTimes = LuaEntry.DataConfig:TryGetNum("arena", "k2")
  self.challengeTimesN:SetText(Localization:GetString("372262", maxChallengeTimes - selfInfo.fightTimes .. "/" .. maxChallengeTimes))
  local good = DataCenter.ItemData:GetItemById(ArenaTicketId)
  local num = good and good.count or 0
  self.ticketCountN:SetText(num)
  self.targetList = DataCenter.ArenaManager:GetChallengeTargetList()
  if 0 < #self.targetList then
    self.svTargetN:SetActive(true)
    self.svTargetN:SetTotalCount(#self.targetList)
    self.svTargetN:RefillCells(1)
  else
    self.svTargetN:SetActive(false)
  end
end

local function OnItemMoveIn(self, itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.svTargetN:AddComponent(ArenaRankItem, itemObj)
  local param = {}
  param.showChallenge = true
  param.index = index
  param.isShowHeroes = self.curDetailIndex == index
  
  function param.callback(targetIndex)
    self:JumpToIndex(targetIndex)
  end
  
  cellItem:SetItem(self.targetList[index], param)
  self.challengeItemsDic[index] = cellItem
end

local function OnItemMoveOut(self, itemObj, index)
  self.challengeItemsDic[index] = nil
  self.svTargetN:RemoveComponent(itemObj.name, ArenaRankItem)
end

local function ClearScroll(self)
  self.svTargetN:ClearCells()
  self.svTargetN:RemoveComponents(ArenaRankItem)
end

local function JumpToIndex(self, targetIndex)
  if self.curDetailIndex and self.challengeItemsDic[self.curDetailIndex] then
    self.challengeItemsDic[self.curDetailIndex]:ShowHeroesByExternal(false)
  end
  if not self.curDetailIndex or targetIndex ~= self.curDetailIndex then
    self.challengeItemsDic[targetIndex]:ShowHeroesByExternal(true)
    self.svTargetN:ScrollToCell(targetIndex, 1000)
    self.curDetailIndex = targetIndex
  else
    self.curDetailIndex = nil
    TimerManager:GetInstance():DelayInvoke(function()
      self.svTargetN:StopMovement()
    end, 0.1)
  end
end

local function OnClickRefreshBtn(self)
  SFSNetwork.SendMessage(MsgDefines.GetArenaInfo, 1)
end

local function OnClickBuyTicketBtn(self)
  local price = DataCenter.ArenaManager:GetTicketPrice()
  local str = Localization:GetString("372261", price)
  UIUtil.ShowBuyMessage(str, 2, nil, nil, function()
    SFSNetwork.SendMessage(MsgDefines.BuyArenaTicket)
  end, nil, nil, nil, price, nil)
end

UIArenaChallengeView.OnCreate = OnCreate
UIArenaChallengeView.OnDestroy = OnDestroy
UIArenaChallengeView.OnAddListener = OnAddListener
UIArenaChallengeView.OnRemoveListener = OnRemoveListener
UIArenaChallengeView.ComponentDefine = ComponentDefine
UIArenaChallengeView.ComponentDestroy = ComponentDestroy
UIArenaChallengeView.DataDefine = DataDefine
UIArenaChallengeView.DataDestroy = DataDestroy
UIArenaChallengeView.InitData = InitData
UIArenaChallengeView.RefreshAll = RefreshAll
UIArenaChallengeView.OnItemMoveIn = OnItemMoveIn
UIArenaChallengeView.OnItemMoveOut = OnItemMoveOut
UIArenaChallengeView.ClearScroll = ClearScroll
UIArenaChallengeView.JumpToIndex = JumpToIndex
UIArenaChallengeView.OnClickRefreshBtn = OnClickRefreshBtn
UIArenaChallengeView.OnClickBuyTicketBtn = OnClickBuyTicketBtn
return UIArenaChallengeView
