local NewPeakArenaChallengeView = BaseClass("NewPeakArenaChallengeView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local NewPeakArenaChallengeItem = require("UI.NewPeakArenaChallenge.Component.NewPeakArenaChallengeItem")
local showAnimIndex = 4

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.userData = self:GetUserData()
  if self.userData and self.userData.type == PVPArenaType.NewGaleArena then
    SFSNetwork.SendMessage(MsgDefines.GaleArenaRefresh, 0)
  else
    SFSNetwork.SendMessage(MsgDefines.NewArenaRefresh, 0)
  end
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
  self.showAnimIndex = nil
end

local function ComponentDefine(self)
  self.btnCloseBg = self:AddComponent(UIButton, "CloseBg")
  self.textTitle = self:AddComponent(UIText, "Root/Top/TitleText")
  self.btnClose = self:AddComponent(UIButton, "Root/Top/CloseBtn")
  self.textChallengeTimes = self:AddComponent(UIText, "Root/ChallengeTimesText")
  self.textEmpty = self:AddComponent(UIText, "Root/EmptyText")
  self.scrollView = self:AddComponent(UIScrollView, "Root/ScrollView")
  self.btnRefresh = self:AddComponent(UIButton, "Root/RefreshBtn")
  self.btnRefresh:SetOnClick(function()
    self:OnBtnRefreshClick()
  end)
  self.textRefreshBtn = self:AddComponent(UIText, "Root/RefreshBtn/RefreshBtnText")
  self.textRefreshBtn:SetLocalText("new_arena_tips_25")
  self.textRefreshBtnCost = self:AddComponent(UIText, "Root/RefreshBtn/RefreshBtnCostPanel/RefreshBtnCostText")
  self.btnFreeRefresh = self:AddComponent(UIButton, "Root/FreeRefreshBtn")
  self.btnFreeRefresh:SetOnClick(function()
    self:OnBtnFreeRefreshClick()
  end)
  self.textFreeRefreshBtn = self:AddComponent(UIText, "Root/FreeRefreshBtn/FreeRefreshBtnText")
  self.compRefreshBtnCostIcon = self:AddComponent(UIBaseContainer, "Root/RefreshBtn/RefreshBtnCostPanel/RefreshBtnCostIcon")
  self.textNoRefreshTip = self:AddComponent(UIText, "Root/NoRefreshTip")
  self.textNoRefreshTip:SetLocalText("new_arena_refresh_max")
  self.textNoRefreshTip:SetActive(false)
  self.btnClose:SetOnClick(Bind(self.ctrl, self.ctrl.CloseSelf))
  self.btnCloseBg:SetOnClick(Bind(self.ctrl, self.ctrl.CloseSelf))
  self.scrollCellPool = {}
  self.itemIndex = 1
  self.scrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.scrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
  self.textTitle:SetLocalText("new_arena_tips_24")
end

local function ComponentDestroy(self)
  self:ClearScroll()
  self.btnCloseBg = nil
  self.textTitle = nil
  self.btnClose = nil
  self.textChallengeTimes = nil
  self.textEmpty = nil
  self.scrollView = nil
  self.btnRefresh = nil
  self.btnFreeRefresh = nil
  self.textRefreshBtn = nil
  self.textRefreshBtnCost = nil
  self.compRefreshBtnCostIcon = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.costGold = 0
  self.__waitingForMsg = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.NewArenaRefresh, self.Refresh)
  self:AddUIListener(EventId.NewGaleArenaRefresh, self.Refresh)
  self:AddUIListener(EventId.NewPeakArenaGetBattlePreview, self.OnNewArenaBattlePreView)
  self:AddUIListener(EventId.NewGaleArenaGetBattlePreview, self.OnNewArenaBattlePreView)
  self:AddUIListener(EventId.NewPeakArenaGetKOFBattlePreview, self.OnNewArenaKofBattlePreView)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.NewArenaRefresh, self.Refresh)
  self:RemoveUIListener(EventId.NewGaleArenaRefresh, self.Refresh)
  self:RemoveUIListener(EventId.NewPeakArenaGetBattlePreview, self.OnNewArenaBattlePreView)
  self:RemoveUIListener(EventId.NewGaleArenaGetBattlePreview, self.OnNewArenaBattlePreView)
  self:RemoveUIListener(EventId.NewPeakArenaGetKOFBattlePreview, self.OnNewArenaKofBattlePreView)
  base.OnRemoveListener(self)
end

local function OnBtnRefreshClick(self)
  if self.costGold > LuaEntry.Player.gold then
    GoToUtil.GotoPayTips(self.costGold)
  else
    UIUtil.ShowUseDiamondConfirm(TodayNoSecondConfirmType.RefreshNewPeakBattleList, Localization:GetString("new_arena_tips_40"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      if self.userData and self.userData.type == PVPArenaType.NewGaleArena then
        SFSNetwork.SendMessage(MsgDefines.GaleArenaRefresh, 1)
      else
        SFSNetwork.SendMessage(MsgDefines.NewArenaRefresh, 1)
      end
    end, function()
    end)
  end
end

local function OnBtnFreeRefreshClick(self)
  if self.userData and self.userData.type == PVPArenaType.NewGaleArena then
    SFSNetwork.SendMessage(MsgDefines.GaleArenaRefresh, 1)
  else
    SFSNetwork.SendMessage(MsgDefines.NewArenaRefresh, 1)
  end
end

local function Refresh(self, data)
  if self.userData and self.userData.type == PVPArenaType.NewGaleArena then
    self.textChallengeTimes:SetLocalText("801109", DataCenter.NewGaleArenaManager.rankData.battleTimes or 0)
  else
    self.textChallengeTimes:SetLocalText("801109", DataCenter.NewPeakArenaManager.rankData.battleTimes or 0)
  end
  self.refreshCount = data.refreshCount
  self.freeRefreshCount = 0
  self.refreshPrice = {}
  local price = data.refresh_price
  if not string.IsNullOrEmpty(price) then
    local priceList = string.split(price, "|")
    for i = 1, #priceList do
      if tonumber(priceList[i]) == 0 then
        self.freeRefreshCount = self.freeRefreshCount + 1
      end
      table.insert(self.refreshPrice, tonumber(priceList[i]))
    end
  end
  self.costGold = 0
  if self.refreshCount >= #self.refreshPrice then
    self.textNoRefreshTip:SetActive(true)
    self.btnFreeRefresh:SetActive(false)
    self.btnRefresh:SetActive(false)
  elseif self.refreshCount >= self.freeRefreshCount then
    local cost = self.refreshPrice[self.refreshCount + 1]
    self.costGold = cost
    self.textNoRefreshTip:SetActive(false)
    self.btnFreeRefresh:SetActive(false)
    self.btnRefresh:SetActive(true)
    self.textRefreshBtnCost:SetText(string.GetFormattedSeperatorNum(cost))
  else
    self.textNoRefreshTip:SetActive(false)
    self.btnFreeRefresh:SetActive(true)
    self.btnRefresh:SetActive(false)
    self.textFreeRefreshBtn:SetText(Localization:GetString("new_arena_refresh_free") .. " " .. self.refreshCount .. "/" .. self.freeRefreshCount)
  end
  if data.battleList and 0 < #data.battleList then
    self.textEmpty:SetActive(false)
    self.scrollView:SetActive(true)
    self.showDatalist = data.battleList
    table.sort(self.showDatalist, function(a, b)
      return a.rank < b.rank
    end)
    self.scrollView:SetTotalCount(#self.showDatalist)
    self.scrollView:RefillCells()
  else
    self.textEmpty:SetActive(true)
    self.scrollView:SetActive(false)
  end
end

local function OnItemMoveIn(self, itemObj, index)
  local item = self.scrollCellPool[itemObj.name]
  if not item then
    local name = tostring(self.itemIndex)
    itemObj.name = name
    item = self.scrollView:AddComponent(NewPeakArenaChallengeItem, itemObj)
    self.scrollCellPool[name] = item
    self.itemIndex = self.itemIndex + 1
  end
  item:SetData(self.showDatalist[index])
  if self.showAnimIndex == nil then
    self.showAnimIndex = 1
  end
  if self.showAnimIndex <= showAnimIndex then
    item:SetAlpha(0)
    TimerManager:GetInstance():DelayInvoke(function()
      item:PlayAnim()
    end, self.showAnimIndex * 0.03)
    self.showAnimIndex = self.showAnimIndex + 1
  end
end

local function OnItemMoveOut(self, itemObj, index)
end

local function ClearScroll(self)
  self.scrollView:ClearCells()
  self.scrollView:RemoveComponents(NewPeakArenaChallengeItem)
  self.scrollCellPool = {}
  self.itemIndex = 1
  self.showDatalist = {}
end

local function OnBtnCheckClick(self, uid)
  if self.__waitingForMsg then
    return
  end
  self.__waitingForMsg = true
  self.__tmpFlag_check = true
  if self.userData and self.userData.type == PVPArenaType.NewGaleArena then
    DataCenter.NewGaleArenaManager:SendNewArenaBattlePreView(uid)
  else
    DataCenter.NewPeakArenaManager:SendNewArenaBattlePreView(uid)
  end
end

local function OnBtnChallangeClick(self, uid)
  if self.__waitingForMsg then
    return
  end
  local battleTimes = 0
  if self.userData and self.userData.type == PVPArenaType.NewGaleArena then
    battleTimes = DataCenter.NewGaleArenaManager.rankData.battleTimes or 0
  else
    battleTimes = DataCenter.NewPeakArenaManager.rankData.battleTimes or 0
  end
  if battleTimes <= 0 then
    UIUtil.ShowTipsId(801110)
  else
    self.__waitingForMsg = true
    self.__tmpFlag_check = false
    if self.userData and self.userData.type == PVPArenaType.NewGaleArena then
      DataCenter.NewGaleArenaManager:SendNewArenaBattlePreView(uid, true)
    else
      DataCenter.NewPeakArenaManager:SendNewArenaBattlePreView(uid, true)
    end
  end
end

local function OnNewArenaBattlePreView(self, data)
  self.__waitingForMsg = false
  if self.__tmpFlag_check then
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWActivityArenaViewOther, {anim = true}, data.otherInfo)
  else
    local param = {}
    param.type = PVEType.FakePVP
    if self.userData and self.userData.type == PVPArenaType.NewGaleArena then
      param.enterType = PVEEnterType.NewGaleArena
    else
      param.enterType = PVEEnterType.NewPeakArena
    end
    param.levelId = -1
    param.sceneId = 51
    param.extraData = {}
    param.extraData.ownerInfo = data.ownerInfo
    param.extraData.otherInfo = data.otherInfo
    DataCenter.LWBattleManager:Enter(param)
  end
end

local function OnNewArenaKofBattlePreView(self, data)
  self.__waitingForMsg = false
  DataCenter.LWKOFBattleManager:SetType(TypeKOF.NewPeakArena)
  if self.__tmpFlag_check then
    UIManager:GetInstance():OpenWindow(UIWindowNames.NewPeakArenaOther, {anim = true}, data.otherInfo)
  else
    local param = {}
    param.type = PVEType.KOF
    param.enterType = PVEEnterType.NewPeakArena
    param.levelId = -1
    param.sceneId = 51
    param.extraData = {}
    param.extraData.squadIndex = 1
    param.extraData.openWindow = true
    DataCenter.LWBattleManager:Enter(param)
  end
end

NewPeakArenaChallengeView.OnCreate = OnCreate
NewPeakArenaChallengeView.OnDestroy = OnDestroy
NewPeakArenaChallengeView.OnEnable = OnEnable
NewPeakArenaChallengeView.OnDisable = OnDisable
NewPeakArenaChallengeView.ComponentDefine = ComponentDefine
NewPeakArenaChallengeView.ComponentDestroy = ComponentDestroy
NewPeakArenaChallengeView.DataDefine = DataDefine
NewPeakArenaChallengeView.DataDestroy = DataDestroy
NewPeakArenaChallengeView.OnAddListener = OnAddListener
NewPeakArenaChallengeView.OnRemoveListener = OnRemoveListener
NewPeakArenaChallengeView.OnBtnRefreshClick = OnBtnRefreshClick
NewPeakArenaChallengeView.OnBtnFreeRefreshClick = OnBtnFreeRefreshClick
NewPeakArenaChallengeView.Refresh = Refresh
NewPeakArenaChallengeView.OnItemMoveIn = OnItemMoveIn
NewPeakArenaChallengeView.OnItemMoveOut = OnItemMoveOut
NewPeakArenaChallengeView.ClearScroll = ClearScroll
NewPeakArenaChallengeView.OnBtnCheckClick = OnBtnCheckClick
NewPeakArenaChallengeView.OnBtnChallangeClick = OnBtnChallangeClick
NewPeakArenaChallengeView.OnNewArenaBattlePreView = OnNewArenaBattlePreView
NewPeakArenaChallengeView.OnNewArenaKofBattlePreView = OnNewArenaKofBattlePreView
return NewPeakArenaChallengeView
