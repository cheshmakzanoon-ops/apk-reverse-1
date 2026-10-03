local UIEpidemicBattleStatusView = BaseClass("UIEpidemicBattleStatusView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local actMgr = DataCenter.ActEpidemicZoneManager
local BattlePopBase = require("UI.UIActivityCenterTable.Component.ActEpidemic.BattleBase.BattlePopBase")
local UIEpidemicBattleStatusItem = require("UI.UIActivityCenterTable.Component.ActEpidemic.BattleStatus.Component.UIEpidemicBattleStatusItem")
local UIEpidemicBattleStatusItemAL = require("UI.UIActivityCenterTable.Component.ActEpidemic.BattleStatus.Component.UIEpidemicBattleStatusItemAL")
local panel_path = "panel"
local battle_pop_base_path = "BattlePopBase"
local btn_leave_path = "Root/BtnList/BtnLeave"
local btn_award_path = "Root/BtnList/BtnAward"
local btn_rules_path = "Root/BtnList/BtnRules"
local user_self_path = "Root/Top/UserSelf"
local user_other_path = "Root/Top/UserOther"
local toggle_base_path = "Root/Tab/toggle"
local scroll_view_self_path = "Root/ScrollViewSelf"
local scroll_view_other_path = "Root/ScrollViewOther"
local rank_list_item_path = "Root/RankListItem"
local only_my_path = "Root/OnlyMy"
local text_path = "Root/OnlyMy/Text"

function UIEpidemicBattleStatusView:OnCreate()
  base.OnCreate(self)
  local param = self:GetUserData()
  self.param = param
  self.curIdx = 1
  actMgr:ReqBattleScore()
  actMgr:ReqBattlePlayerInfo()
  self:ComponentDefine()
end

function UIEpidemicBattleStatusView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIEpidemicBattleStatusView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.EpidemicBattlePlayerInfoUpdate, self.UpdateData)
end

function UIEpidemicBattleStatusView:OnRemoveListener()
  self:RemoveUIListener(EventId.EpidemicBattlePlayerInfoUpdate, self.UpdateData)
  base.OnRemoveListener(self)
end

function UIEpidemicBattleStatusView:ComponentDefine()
  local closeCb = BindCallback(self.ctrl, self.ctrl.CloseSelf)
  self.panel = self:AddComponent(UIButton, panel_path)
  self.panel:SetOnClick(closeCb)
  self.battle_pop_base = self:AddComponent(BattlePopBase, battle_pop_base_path)
  self.battle_pop_base:ReInit("winter_battlefield_tips1044", closeCb)
  self.btn_leave = self:AddComponent(UIButton, btn_leave_path)
  self.btn_leave:SetActive(not BattleFieldUtil.isObserve)
  self.btn_award = self:AddComponent(UIButton, btn_award_path)
  self.btn_rules = self:AddComponent(UIButton, btn_rules_path)
  local curRole = actMgr:GetCurRole()
  self.user_self = self:AddComponent(UIEpidemicBattleStatusItemAL, user_self_path)
  self.user_self:ReInit(curRole)
  self.user_self.btn:SetOnClick(function()
    self.ScrollViewSelf:SetActive(true)
    self.ScrollViewOther:SetActive(false)
    self.only_my:SetActive(true)
    self.user_self:SetSelect(true)
    self.user_other:SetSelect(false)
    self:UpdateData()
  end)
  self.user_self:SetSelect(true)
  self.user_other = self:AddComponent(UIEpidemicBattleStatusItemAL, user_other_path)
  self.user_other:ReInit(curRole == EpidemicZoneRole.Lord and EpidemicZoneRole.Farmer or EpidemicZoneRole.Lord)
  self.user_other.btn:SetOnClick(function()
    self.ScrollViewSelf:SetActive(false)
    self.ScrollViewOther:SetActive(true)
    self.only_my:SetActive(false)
    self.user_self:SetSelect(false)
    self.user_other:SetSelect(true)
    self:UpdateData()
  end)
  self.user_other:SetSelect(false)
  for i = 1, 4 do
    local toggle = self:AddComponent(UIToggle, toggle_base_path .. i)
    if i == 1 then
      toggle:SetIsOn(true)
    end
    toggle:SetOnValueChanged(function(tf)
      if tf then
        self.curIdx = i
        self:UpdateData()
      end
    end)
  end
  self.selfCellItem = self:AddComponent(UIEpidemicBattleStatusItem, rank_list_item_path)
  self.ScrollViewSelf = self:AddComponent(UIScrollView, scroll_view_self_path)
  self.ScrollViewSelf:SetOnItemMoveIn(function(itemObj, index)
    self:OnSelfItemMoveIn(itemObj, index)
  end)
  self.ScrollViewSelf:SetOnItemMoveOut(function(itemObj, index)
    self:OnSelfItemMoveOut(itemObj, index)
  end)
  self.ScrollViewOther = self:AddComponent(UIScrollView, scroll_view_other_path)
  self.ScrollViewOther:SetOnItemMoveIn(function(itemObj, index)
    self:OnOtherItemMoveIn(itemObj, index)
  end)
  self.ScrollViewOther:SetOnItemMoveOut(function(itemObj, index)
    self:OnOtherItemMoveOut(itemObj, index)
  end)
  self.btn_leave:SetOnClick(function()
    local cdTime = LuaEntry.DataConfig:TryGetNum("YiBianJinQu_battle", "k13", 0)
    UIUtil.ShowSecondMessageByParam({
      tipText = Localization:GetString("YiBianJinQu_errorcode_9", cdTime),
      btnNum = 2,
      showToggle = false,
      delayConfirm = {delayTime = 3},
      sureAction = function()
        actMgr:ReqBattleLeave()
        BattleFieldUtil.LeaveBattlefield()
      end
    })
  end)
  self.btn_award:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActEpidemicRewardView, {anim = true}, 1)
  end)
  self.btn_rules:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIDesertRules, {anim = true}, BattleFieldType.EpidemicZone)
  end)
  self.only_my = self:AddComponent(UIToggle, only_my_path)
  self.only_my:SetActive(true)
  self.only_my:SetIsOn(false)
  self.only_my:SetOnValueChanged(function(_)
    self:UpdateData()
  end)
  self.text = self:AddComponent(UITextMeshProUGUIEx, text_path)
  self.text:SetLocalText("361058")
  self.ScrollViewSelf:SetActive(true)
  self.ScrollViewOther:SetActive(false)
  self:UpdateData()
end

function UIEpidemicBattleStatusView:ComponentDestroy()
  self:ClearScroll()
  self.param = nil
  self.curIdx = 1
end

local function SortList1(a, b)
  if a.score ~= b.score then
    return a.score > b.score
  end
  return a.uid < b.uid
end

local function SortList2(a, b)
  if a.battleScore ~= b.battleScore then
    return a.battleScore > b.battleScore
  end
  return a.uid < b.uid
end

local function SortList4(a, b)
  if a.tacticsScore ~= b.tacticsScore then
    return a.tacticsScore > b.tacticsScore
  end
  return a.uid < b.uid
end

local function SortList3(a, b)
  if a.cooperationScore ~= b.cooperationScore then
    return a.cooperationScore > b.cooperationScore
  end
  return a.uid < b.uid
end

function UIEpidemicBattleStatusView:SortList(list)
  if table.IsNullOrEmpty(list) then
    return
  end
  if self.curIdx == 1 then
    table.sort(list, SortList1)
  elseif self.curIdx == 2 then
    table.sort(list, SortList2)
  elseif self.curIdx == 3 then
    table.sort(list, SortList3)
  elseif self.curIdx == 4 then
    table.sort(list, SortList4)
  end
end

function UIEpidemicBattleStatusView:UpdateData()
  local battleInfo = actMgr:GetBattleInfo()
  local playerInfo = battleInfo.playerInfo
  local myAlUid = LuaEntry.Player:GetAllianceUid()
  local selfRole = actMgr:GetCurRole()
  self.userListSelf = {}
  self.userListOther = {}
  for _, v in ipairs(battleInfo.vsInfo) do
    if v.role == selfRole then
      self.userListSelf = DeepCopy(playerInfo[v.role] or {})
    else
      self.userListOther = playerInfo[v.role] or {}
    end
  end
  self:SortList(self.userListOther)
  if self.ScrollViewSelf:GetActive() then
    self:SortList(self.userListSelf)
    local selfInfo, selfRank
    if not table.IsNullOrEmpty(self.userListSelf) then
      local onlyShowMyAl = self.only_my:GetIsOn()
      local list = {}
      local myUid = LuaEntry.Player:GetUid()
      for rank, v in ipairs(self.userListSelf) do
        v.rank = rank
        if v.uid == myUid then
          selfInfo = v
          selfRank = rank
        end
        if onlyShowMyAl and v.allianceId == myAlUid then
          table.insert(list, v)
        end
      end
      if onlyShowMyAl then
        self.userListSelf = list
      end
    end
    self.selfInfo = selfInfo
    self:OnRefreshAlliance(self.userListSelf, self.ScrollViewSelf)
    self.selfCellItem:SetActive(selfInfo ~= nil)
    if selfInfo ~= nil then
      self.selfCellItem:ReInit(selfInfo, selfRank or 0, true, self.curIdx)
    end
  elseif self.ScrollViewOther:GetActive() then
    for rank, v in ipairs(self.userListOther) do
      v.rank = rank
    end
    self:OnRefreshAlliance(self.userListOther, self.ScrollViewOther)
    self.selfCellItem:SetActive(false)
  end
end

function UIEpidemicBattleStatusView:OnRefreshAlliance(userList, sv)
  if userList == nil then
    return
  end
  if 0 < #userList then
    sv:SetTotalCount(#userList)
    sv:RefillCells()
  end
end

function UIEpidemicBattleStatusView:OnSelfItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  self.ScrollViewSelf:RemoveComponent(itemObj.name, UIEpidemicBattleStatusItem)
  local cellItem = self.ScrollViewSelf:AddComponent(UIEpidemicBattleStatusItem, itemObj)
  if cellItem ~= nil then
    cellItem:ReInit(self.userListSelf[index], index, false, self.curIdx)
  end
end

function UIEpidemicBattleStatusView:OnSelfItemMoveOut(itemObj, index)
  self.ScrollViewSelf:RemoveComponent(itemObj.name, UIEpidemicBattleStatusItem)
end

function UIEpidemicBattleStatusView:OnOtherItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  self.ScrollViewOther:RemoveComponent(itemObj.name, UIEpidemicBattleStatusItem)
  local cellItem = self.ScrollViewOther:AddComponent(UIEpidemicBattleStatusItem, itemObj)
  if cellItem ~= nil then
    cellItem:ReInit(self.userListOther[index], index, false, self.curIdx)
  end
end

function UIEpidemicBattleStatusView:OnOtherItemMoveOut(itemObj, index)
  self.ScrollViewOther:RemoveComponent(itemObj.name, UIEpidemicBattleStatusItem)
end

function UIEpidemicBattleStatusView:ClearScroll()
  self.ScrollViewSelf:ClearCells()
  self.ScrollViewSelf:RemoveComponents(UIEpidemicBattleStatusItem)
  self.ScrollViewOther:ClearCells()
  self.ScrollViewOther:RemoveComponents(UIEpidemicBattleStatusItem)
end

return UIEpidemicBattleStatusView
