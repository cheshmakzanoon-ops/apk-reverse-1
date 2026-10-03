local UIBattlefieldDsbDuelBattleRankView = BaseClass("UIBattlefieldDsbDuelBattleRankView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIBattlefieldDsbDuelBattleRankViewRoleItem = require("UI.DsbDuelBattlefield.Rank.UIBattlefieldDsbDuelBattleRankViewRoleItem")
local UIBattlefieldDsbDuelBattleRankViewRankItem = require("UI.DsbDuelBattlefield.Rank.UIBattlefieldDsbDuelBattleRankViewRankItem")

function UIBattlefieldDsbDuelBattleRankView:OnCreate()
  base.OnCreate(self)
  self.listGO = {}
  self.itemList = {}
  self:ComponentDefine()
  self:DataDefine()
  self:StartAutoTick()
end

function UIBattlefieldDsbDuelBattleRankView:OnDestroy()
  self:DestroyTimer()
  self.lastRequestTime = nil
  self.playerInfos = nil
  self.myRoleNotice = nil
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
  self.listGO = nil
  self.itemList = nil
end

function UIBattlefieldDsbDuelBattleRankView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTmpTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.compRole4 = self.viewSkin:AddComponent(self, UIBattlefieldDsbDuelBattleRankViewRoleItem, 2)
  self.compRole3 = self.viewSkin:AddComponent(self, UIBattlefieldDsbDuelBattleRankViewRoleItem, 3)
  self.compRole2 = self.viewSkin:AddComponent(self, UIBattlefieldDsbDuelBattleRankViewRoleItem, 4)
  self.compRole1 = self.viewSkin:AddComponent(self, UIBattlefieldDsbDuelBattleRankViewRoleItem, 5)
  self.scrollRectScroller = self.viewSkin:AddComponent(self, UIScrollRect, 6)
  self.gridInfinityScrollViewContent = self.viewSkin:AddComponent(self, GridInfinityScrollView, 7)
  self.btnRules = self.viewSkin:AddComponent(self, UIButton, 8)
  self.btnRules:SetOnClick(function()
    self:OnBtnRulesClick()
  end)
  self.btnQuit = self.viewSkin:AddComponent(self, UIButton, 9)
  self.btnQuit:SetOnClick(function()
    self:OnBtnQuitClick()
  end)
  self.btnReward = self.viewSkin:AddComponent(self, UIButton, 10)
  self.btnReward:SetOnClick(function()
    self:OnBtnRewardClick()
  end)
  self.btnBackground = self.viewSkin:AddComponent(self, UIButton, 11)
  self.btnBackground:SetOnClick(function()
    self:OnBtnBackgroundClick()
  end)
  self.compScroller = self.viewSkin:AddComponent(self, UIBaseContainer, 12)
  self.textBtnReward = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 13)
  self.textBtnQuit = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 14)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 15)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.textBtnReward:SetLocalText("458131")
  self.textBtnQuit:SetLocalText("YiBianJinQu_battle_detail_tips_2")
  self.roleComps = {
    self.compRole1,
    self.compRole2,
    self.compRole3,
    self.compRole4
  }
  local _ = self:GetUserData()
  local defaultRole = _ and _.role or BattlefieldDsbDuelUtils.GetMyRoleId()
  if defaultRole == BattlefieldDsbConst.RoleType.None then
    defaultRole = BattlefieldDsbDuelUtils.GetMyRoleId()
  end
  local battleInfo = BattlefieldDsbDuelUtils.BattleInfo
  self.gridInfinityScrollViewContent:Init(BindCallback(self, self.OnInitCell), BindCallback(self, self.OnUpdateCell), BindCallback(self, self.OnDestroyCell))
  if battleInfo then
    self:RequestRankInfo()
    self:RefreshRoles()
    self:RefreshRoleSelection(BattlefieldDsbDuelUtils.GetRole(defaultRole), true)
  end
end

function UIBattlefieldDsbDuelBattleRankView:ComponentDestroy()
  self.viewSkin = nil
  self.textTmpTitle = nil
  self.compRole4 = nil
  self.compRole3 = nil
  self.compRole2 = nil
  self.compRole1 = nil
  self.scrollRectScroller = nil
  self.gridInfinityScrollViewContent = nil
  self.btnRules = nil
  self.btnQuit = nil
  self.btnReward = nil
  self.btnBackground = nil
  self.compScroller = nil
  self.textBtnReward = nil
  self.textBtnQuit = nil
  self.btnClose = nil
end

function UIBattlefieldDsbDuelBattleRankView:DataDefine()
end

function UIBattlefieldDsbDuelBattleRankView:DataDestroy()
  self:ClearItems()
end

function UIBattlefieldDsbDuelBattleRankView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.DsbDuelBattlePlayerInfoChanged, self.OnBattlePlayerInfoChanged)
end

function UIBattlefieldDsbDuelBattleRankView:OnRemoveListener()
  self:RemoveUIListener(EventId.DsbDuelBattlePlayerInfoChanged, self.OnBattlePlayerInfoChanged)
  base.OnRemoveListener(self)
end

function UIBattlefieldDsbDuelBattleRankView:OnBtnBackgroundClick()
  self.ctrl:CloseSelf()
end

function UIBattlefieldDsbDuelBattleRankView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function UIBattlefieldDsbDuelBattleRankView:RefreshRoles()
  local battleInfo = BattlefieldDsbDuelUtils.BattleInfo
  if not battleInfo then
    return
  end
  local info = {}
  info.rankedRoles = {}
  local myRoleId = BattlefieldDsbDuelUtils.GetMyRoleId()
  for rank = BattlefieldDsbConst.RoleType.MIN, BattlefieldDsbConst.RoleType.MAX do
    local comp = self.roleComps[rank]
    local role = battleInfo:GetRoleByRank(rank)
    if role == BattlefieldDsbConst.EmptyRole then
      comp:SetActive(true)
      comp:Refresh(self, rank, role)
    else
      local temp = {
        rank = rank,
        score = role.score
      }
      table.insert(info.rankedRoles, temp)
      if role:GetRoleID() == myRoleId then
        info.my = temp
      end
      if comp then
        if not role then
          comp:SetActive(false)
        else
          comp:SetActive(true)
          comp:Refresh(self, rank, role)
        end
      end
    end
  end
  self.myRoleNotice = self:GetMyRoleNotice(info)
end

function UIBattlefieldDsbDuelBattleRankView:GetMyRoleNotice(info)
  if not info then
    return
  end
  local sb = StringBuilder.New()
  local myRole = info.my
  local myScore = myRole.score
  sb:AppendLine(Localization:GetString("dsb_duel_interface_1044", string.GetFormattedSeparatorNum(myScore)))
  local isUnder = false
  for rank, _ in ipairs(info.rankedRoles) do
    if _ ~= myRole then
      if myScore >= _.score then
        sb:AppendLine(Localization:GetString("dsb_duel_interface_1043", _.rank, string.GetFormattedSeparatorNum(myScore - _.score)))
      else
        sb:AppendLine(Localization:GetString("dsb_duel_interface_1042", _.rank, string.GetFormattedSeparatorNum(_.score - myScore)))
      end
    end
  end
  return sb:ToString()
end

function UIBattlefieldDsbDuelBattleRankView:RefreshRoleSelection(role, manualRefresh)
  if not role then
    return
  end
  self.roleSelection = role
  local activeComp
  for idx = BattlefieldDsbConst.RoleType.MIN, BattlefieldDsbConst.RoleType.MAX do
    local comp = self.roleComps[idx]
    if comp then
      local active = comp:RefreshRoleSelection(role)
      if active then
        activeComp = comp
      end
    end
  end
  self:RefreshRankMembers()
  if self.roleSelection:GetRoleID() == BattlefieldDsbDuelUtils.GetMyRoleId() and self.myRoleNotice then
    if manualRefresh then
      UIUtil.ShowBubbleTipsAuto(self.myRoleNotice, activeComp:GetTipPos(), 0, 0, 0, nil, nil, {reversal = true})
    elseif UIManager:GetInstance():IsWindowOpen(UIWindowNames.UICommonTipsAuto) then
      UIManager:GetInstance():DestroyWindow(UIWindowNames.UICommonTipsAuto)
      UIUtil.ShowBubbleTipsAuto(self.myRoleNotice, activeComp:GetTipPos(), 0, 0, 0, nil, nil, {reversal = true})
    end
  end
end

function UIBattlefieldDsbDuelBattleRankView:RefreshRankMembers()
  if not self.roleSelection or not self.playerInfos then
    return
  end
  self.itemData = self.playerInfos[self.roleSelection.roleId] or {}
  self.gridInfinityScrollViewContent:SetItemCount(#self.itemData)
end

function UIBattlefieldDsbDuelBattleRankView:ClearItems()
  self.compScroller:RemoveComponents(UIBattlefieldDsbDuelBattleRankViewRankItem)
  self.gridInfinityScrollViewContent:DestroyChildNode()
  self.listGO = {}
  self.itemList = {}
end

function UIBattlefieldDsbDuelBattleRankView:OnInitCell(go, index)
  local item = self.compScroller:AddComponent(UIBattlefieldDsbDuelBattleRankViewRankItem, go)
  item:SetActive(false)
  self.listGO[go] = item
end

function UIBattlefieldDsbDuelBattleRankView:OnUpdateCell(go, index)
  local cellItem = self.listGO[go]
  if cellItem then
    local theIndex = index + 1
    cellItem:SetActive(true)
    cellItem:ReInit(theIndex, self.itemData[theIndex])
    self.itemList[theIndex] = cellItem
  end
end

function UIBattlefieldDsbDuelBattleRankView:OnDestroyCell(go, index)
end

function UIBattlefieldDsbDuelBattleRankView:OnBtnQuitClick()
  if BattleFieldUtil.isObserve then
    BattleFieldUtil.LeaveBattlefield()
  else
    UIUtil.ShowSecondMessageByParam({
      tipText = Localization:GetString("458143"),
      btnNum = 2,
      showToggle = false,
      delayConfirm = {delayTime = 3},
      sureAction = function()
        self.ctrl:CloseSelf()
        local battleInfo = BattlefieldDsbDuelUtils.BattleInfo
        if battleInfo then
          battleInfo:TryLeaveBattlefield()
          BattleFieldUtil.LeaveBattlefield()
        end
      end
    })
  end
end

local _GAP = 5

function UIBattlefieldDsbDuelBattleRankView:RequestRankInfo()
  local cur = UITimeManager:GetInstance():GetServerSeconds()
  local battleInfo = BattlefieldDsbDuelUtils.BattleInfo
  if not battleInfo then
    return
  end
  if self.lastRequestTime then
    local gap = cur - self.lastRequestTime
    if gap < _GAP then
      return
    end
  end
  self.lastRequestTime = cur
  SFSNetwork.SendMessage(MsgDefines.DsbBattlePlayerInfo, BattlefieldDsbDuelUtils.GetCurrentTeam())
  if cur >= battleInfo:GetBattleEndTime() then
    self:DestroyTimer()
  end
end

function UIBattlefieldDsbDuelBattleRankView:OnBattlePlayerInfoChanged()
  local battleInfo = BattlefieldDsbDuelUtils.BattleInfo
  if not battleInfo then
    return
  end
  self.playerInfos = battleInfo:GetBattlePlayerInfos()
  self:RefreshRoles()
  self:RefreshRoleSelection(self.roleSelection, false)
end

function UIBattlefieldDsbDuelBattleRankView:StartAutoTick()
  if not self.refreshTimer then
    self.refreshTimer = TimerManager:GetInstance():GetTimer(_GAP, self.RequestRankInfo, self, false, false, true)
    self.refreshTimer:Start()
  end
end

function UIBattlefieldDsbDuelBattleRankView:DestroyTimer()
  if self.refreshTimer ~= nil then
    self.refreshTimer:Stop()
    self.refreshTimer = nil
  end
end

function UIBattlefieldDsbDuelBattleRankView:OnBtnRulesClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIDesertRules, {anim = true}, BattleFieldType.DsbDuel)
end

function UIBattlefieldDsbDuelBattleRankView:OnBtnRewardClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIBFDsbDuelActRewardView, {anim = true}, 1)
end

return UIBattlefieldDsbDuelBattleRankView
