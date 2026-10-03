local UIEpidemicBattleCommanderSetView = BaseClass("UIEpidemicBattleCommanderSetView", UIBaseView)
local base = UIBaseView
local UIEpidemicBattleCommanderSetItem = require("UI.UIActivityCenterTable.Component.ActEpidemic.BattleCommanderSet.Component.UIEpidemicBattleCommanderSetItem")
local panel_path = "panel"
local dialog_title_text_path = "PopUpTitle/Common_img_title/titleText"
local close_btn_path = "PopUpTitle/CloseBtn"
local scroll_view_path = "PopUpTitle/Common_bg_orange2/ScrollView"
local content_path = "PopUpTitle/Common_bg_orange2/ScrollView/Viewport/Content"
local flag_path = "PopUpTitle/Common_bg_orange2/ScrollView/Flag"
local text_num_path = "PopUpTitle/Common_bg_orange2/Di/NumText"

function UIEpidemicBattleCommanderSetView:OnCreate()
  base.OnCreate(self)
  local infos = string.string2array_i_oneSep(LuaEntry.DataConfig:TryGetStr("YiBianJinQu", "k6", "3,20,10"), ",")
  self.maxNumCom = infos[1] or 3
  self.itemList = {}
  self.list = {}
  self.states = {}
  self.curIdx = DataCenter.ActEpidemicZoneManager:GetCurGroupIdx()
  self.curNum = 0
  self.clickCB = BindCallback(self, self.ChangeState)
  self.dialog_title_text = self:AddComponent(UIText, dialog_title_text_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.dialog_title_text:SetLocalText("Desert_strom_commander_1017")
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.close_btn1 = self:AddComponent(UIButton, panel_path)
  self.close_btn1:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.text_num = self:AddComponent(UIText, text_num_path)
  self.flag = self:AddComponent(UIBaseComponent, flag_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.scroll_view = self:AddComponent(UILoopListView2, scroll_view_path)
  self.scroll_view:InitListView(0, function(listview, index)
    return self:OnGetItemByIndex(listview, index)
  end)
  self.scroll_view:SetOnDragingAction(function(_)
    self:CheckFlagShow()
  end)
  self.scroll_view:SetOnEndDragAction(function(_)
    self:DelayCheckFlagShow()
  end)
  self:UpdateData()
end

function UIEpidemicBattleCommanderSetView:OnDestroy()
  SFSNetwork.SendMessage(MsgDefines.AlRank, LuaEntry.Player:GetAllianceUid())
  self:ClearDelay()
  self:ClearScroll()
  self.list = {}
  self.states = {}
  self.curIdx = 0
  self.curNum = 0
  self.clickCB = nil
  base.OnDestroy(self)
end

function UIEpidemicBattleCommanderSetView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.EpidemicActPlayerListRefresh, self.UpdateState)
end

function UIEpidemicBattleCommanderSetView:OnRemoveListener()
  self:RemoveUIListener(EventId.EpidemicActPlayerListRefresh, self.UpdateState)
  base.OnRemoveListener(self)
end

function UIEpidemicBattleCommanderSetView:ClearScroll()
  self.content:RemoveComponents(UIEpidemicBattleCommanderSetItem)
  self.scroll_view:ClearAllItems()
  self.scroll_view:SetListItemCount(0, false, false)
  self.scroll_view:RefreshAllShownItem()
  self.itemList = {}
end

function UIEpidemicBattleCommanderSetView:ChangeState(item, uid, state)
  local tmp = state and 1 or -1
  if self.curNum + tmp > self.maxNumCom then
    if item ~= nil then
      item:UpdateActive(not state)
    end
    UIUtil.ShowTipsId("Desert_strom_commander_1025")
    return
  end
  self.states[uid] = state
  self.curNum = self.curNum + tmp
  DataCenter.ActEpidemicZoneManager:ReqCommanderOpt(self.curIdx, state and 1 or 2, uid)
  self:RefreshCurNum()
  return true
end

function UIEpidemicBattleCommanderSetView:OnGetItemByIndex(listview, index)
  local len = #self.list
  local idx = index + 1
  if idx < 1 or len < idx then
    return nil
  end
  local csItem = listview:NewListViewItem("Item")
  local item = self.itemList[csItem]
  if item == nil then
    local prefabIndex = self.prefabIndex or 0
    local nameStr = "Item" .. prefabIndex
    self.prefabIndex = prefabIndex + 1
    csItem.gameObject.name = nameStr
    item = self.content:AddComponent(UIEpidemicBattleCommanderSetItem, nameStr)
    self.itemList[csItem] = item
  end
  if item ~= nil then
    local pInfo = self.list[idx]
    item:ReInit(idx, pInfo, self.clickCB)
    item:UpdateActive(self.states[item.uid])
  end
  return csItem
end

function UIEpidemicBattleCommanderSetView:UpdateState()
  local num = 0
  local dic = {}
  local pList = ActEpidemicUtils.GetPlayersByGroup(self.curIdx)
  for _, info in pairs(pList) do
    if info.group == self.curIdx then
      local uid = info.uid
      local bCommander = DataCenter.ActEpidemicZoneManager:IsCommander(uid)
      if bCommander then
        num = num + 1
        dic[uid] = bCommander
      end
    end
  end
  self.states = dic
  self.curNum = num
  self:RefreshCurNum()
  for _, v in pairs(self.itemList) do
    if v and v.uid then
      v:UpdateActive(self.states[v.uid])
    end
  end
  self:CheckFlagShow()
end

local function SortList(a, b)
  if a.commander ~= b.commander then
    if a.commander then
      return true
    end
    if b.commander then
      return false
    end
  end
  if a.inBF ~= b.inBF then
    if a.inBF then
      return true
    end
    if b.inBF then
      return false
    end
  end
  return a.power > b.power
end

function UIEpidemicBattleCommanderSetView:UpdateData()
  local pList = ActEpidemicUtils.GetPlayersByGroup(self.curIdx) or {}
  local list = {}
  self.states = {}
  self.curNum = 0
  for _, info in pairs(pList) do
    if info.group == self.curIdx then
      local uid = info.uid
      local bCommander = DataCenter.ActEpidemicZoneManager:IsCommander(uid)
      local player = DataCenter.AllianceMemberDataManager:GetAllianceMemberByUid(uid)
      local inBF = player ~= nil and player.online or false
      table.insert(list, {
        uid = uid,
        lv = info.lv,
        name = info.name,
        pic = info.pic,
        picVer = info.picVer,
        power = info.power,
        commander = bCommander,
        inBF = inBF
      })
      if bCommander then
        self.states[uid] = true
        self.curNum = self.curNum + 1
      end
    end
  end
  if 0 < #list then
    table.sort(list, SortList)
  end
  self.list = list
  self:RefreshCurNum()
  self:RefreshList()
end

function UIEpidemicBattleCommanderSetView:RefreshList()
  local cnt = #self.list
  if 0 < cnt then
    self.scroll_view:SetListItemCount(cnt, false, false)
    self.scroll_view:RefreshAllShownItem()
    self:DelayCheckFlagShow()
  else
    self:ClearScroll()
    self.flag:SetActive(false)
  end
end

function UIEpidemicBattleCommanderSetView:RefreshCurNum()
  self.text_num:SetText(self.curNum .. "/" .. self.maxNumCom)
end

function UIEpidemicBattleCommanderSetView:ClearDelay()
  if self.delay then
    self.delay:Stop()
  end
  self.delay = nil
end

function UIEpidemicBattleCommanderSetView:DelayCheckFlagShow()
  self:ClearDelay()
  self.delay = TimerManager:GetInstance():DelayInvoke(function()
    self:CheckFlagShow()
  end, 1.5)
end

function UIEpidemicBattleCommanderSetView:CheckFlagShow()
  self:ClearDelay()
  local rect = self.scroll_view.rectTransform.rect
  local y = self.content:GetAnchoredPositionY()
  local sH = rect.height
  local showFlag = false
  local cH = 150
  local cY = 0
  for i, v in pairs(self.list) do
    local commander = self.states[v.uid]
    if commander then
      cY = 0 - (cH + 5) * (i - 1)
      local top = y + cY + sH
      local check = top - cH * 0.5
      if check < 0 then
        showFlag = true
        break
      end
    end
  end
  self.flag:SetActive(showFlag)
end

return UIEpidemicBattleCommanderSetView
