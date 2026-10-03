local UILW3V3RevengeView = BaseClass("UILW3V3RevengeView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local RevengeItem = require("UI.UILW3V3Revenge.Component.UILW3V3RevengeItem")
local btn_close_path = "bg/bg_top/btnClose"
local txt_remain_times_path = "txtRemainTimes"
local scroll_path = "scroll"
local black_path = "black"
local txt_title_path = "bg/bg_top/txtTitle"
local empty_tip_path = "emptyTip"
local item_self_path = "itemSelf"
local btn_info_path = "bg/bg_top/btnInfo"

function UILW3V3RevengeView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function UILW3V3RevengeView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UILW3V3RevengeView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.Arena3V3GetRevengeList, self.OnGetRevengeList)
  self:AddUIListener(EventId.Arena3V3RevengeGiveUp, self.OnRevengeGiveUp)
  self:AddUIListener(EventId.Arena3V3OpponentMatch, self.OnOpponentMatch)
  self:AddUIListener(EventId.Arena3V3GetDenfenseTeam, self.OnGetBattlePreview)
end

function UILW3V3RevengeView:OnRemoveListener()
  self:RemoveUIListener(EventId.Arena3V3GetRevengeList, self.OnGetRevengeList)
  self:RemoveUIListener(EventId.Arena3V3RevengeGiveUp, self.OnRevengeGiveUp)
  self:RemoveUIListener(EventId.Arena3V3OpponentMatch, self.OnOpponentMatch)
  self:RemoveUIListener(EventId.Arena3V3GetDenfenseTeam, self.OnGetBattlePreview)
  base.OnRemoveListener(self)
end

function UILW3V3RevengeView:ComponentDefine()
  self.btn_close = self:AddComponent(UIButton, btn_close_path)
  self.txt_remain_times = self:AddComponent(UIText, txt_remain_times_path)
  self.scroll = self:AddComponent(UIScrollView, scroll_path)
  self.black = self:AddComponent(UIButton, black_path)
  self.txt_title = self:AddComponent(UITextMeshProUGUIEx, txt_title_path)
  self.empty_tip = self:AddComponent(UITextMeshProUGUIEx, empty_tip_path)
  self.btn_info = self:AddComponent(UIButton, btn_info_path)
  self.txt_title:SetText(Localization:GetString("arena_score_002"))
  self.empty_tip:SetText(Localization:GetString("arena_score_007"))
  self.scrollCellPool = {}
  self.itemIndex = 1
  self.scroll:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemCreateCell(itemObj, index)
  end)
  self.scroll:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemDeleteCell(itemObj, index)
  end)
  self.btn_close:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.black:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.item_self = self:AddComponent(RevengeItem, item_self_path)
  self.btn_info:SetOnClick(function()
    UIUtil.ShowIntro(Localization:GetString("302027"), nil, Localization:GetString("arena_score_004"))
  end)
end

function UILW3V3RevengeView:DataDefine()
  self:UnsetWaitingForMsg()
end

function UILW3V3RevengeView:ComponentDestroy()
  self.scroll:ClearCells()
  self.scroll:RemoveComponents(RevengeItem)
  self.scrollCellPool = nil
  self.txt_remain_times = nil
  self.scroll = nil
  self.black = nil
  self.btn_close = nil
  self.txt_title = nil
  self.empty_tip = nil
  self.item_self = nil
  self.btn_info = nil
end

function UILW3V3RevengeView:DataDestroy()
  self:UnsetWaitingForMsg()
end

function UILW3V3RevengeView:OnItemCreateCell(itemObj, index)
  local item = self.scrollCellPool[itemObj.name]
  if not item then
    local name = tostring(self.itemIndex)
    itemObj.name = name
    self.itemIndex = self.itemIndex + 1
    item = self.scroll:AddComponent(RevengeItem, itemObj)
    self.scrollCellPool[name] = item
  end
  local data = self.datas[index]
  item:Refresh(data)
end

function UILW3V3RevengeView:OnItemDeleteCell(itemObj, index)
end

function UILW3V3RevengeView:ReInit()
  SFSNetwork.SendMessage(MsgDefines.Get3V3ArenaRevengeList)
end

function UILW3V3RevengeView:OnRevengeGiveUp(msg)
  if not msg then
    return
  end
  local uid = msg.uid
  if not uid then
    return
  end
  local find = false
  if self.datas then
    for i = #self.datas, 1, -1 do
      local data = self.datas[i]
      if data.uid and data.uid == uid then
        find = true
        table.remove(self.datas, i)
        break
      end
    end
  end
  if find then
    local count = self.datas and #self.datas or 0
    self.scroll:SetTotalCount(count)
    self.scroll:RefillCells()
    self.empty_tip:SetActive(count == 0)
  end
end

function UILW3V3RevengeView:OnGetRevengeList(msg)
  if not msg then
    return
  end
  self.datas = msg.players
  local count = self.datas and #self.datas or 0
  self.scroll:SetTotalCount(count)
  self.scroll:RefillCells()
  local battleTimes = DataCenter.LW3V3ArenaManager.battleTimes or 0
  self.txt_remain_times:SetText(Localization:GetString("801109", battleTimes))
  self.empty_tip:SetActive(count == 0)
  local playerData = DataCenter.LW3V3ArenaManager:GetPlayerData(LuaEntry.Player.uid)
  if playerData then
    self.item_self:SetActive(true)
    self.item_self:Refresh(playerData, true)
  else
    self.item_self:SetActive(false)
  end
end

function UILW3V3RevengeView:RequestDefenceTeam(uid)
  if self.__waitingForMsg then
    return
  end
  self:SetWaitingForMsg()
  DataCenter.LW3V3ArenaManager:RequestPlayerDefenceTeam(uid)
end

function UILW3V3RevengeView:RequestRevengeMatch(uid)
  if self.__waitingForMsg then
    return
  end
  self:SetWaitingForMsg()
  SFSNetwork.SendMessage(MsgDefines.Get3V3ArenaRevengeMatch, uid)
end

function UILW3V3RevengeView:OnOpponentMatch()
  self:UnsetWaitingForMsg()
end

function UILW3V3RevengeView:OnGetBattlePreview(uuid)
  self:UnsetWaitingForMsg()
end

function UILW3V3RevengeView:SetWaitingForMsg()
  if not self.__waitingForMsg then
    self.__waitingForMsg = true
    if self.delayTimer then
      self.delayTimer:Stop()
      self.delayTimer = nil
    end
    self.delayTimer = TimerManager:GetInstance():GetTimer(60, function()
      self.__waitingForMsg = false
    end, self, true, true)
    self.delayTimer:Start()
  end
end

function UILW3V3RevengeView:UnsetWaitingForMsg()
  self.__waitingForMsg = false
  if self.delayTimer then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
end

return UILW3V3RevengeView
