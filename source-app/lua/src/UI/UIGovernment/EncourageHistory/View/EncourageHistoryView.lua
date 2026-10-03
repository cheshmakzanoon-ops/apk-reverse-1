local EncourageHistoryView = BaseClass("EncourageHistoryView", UIBaseView)
local base = UIBaseView
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local EncourageHistoryItem = require("UI.UIGovernment.EncourageHistory.Component.EncourageHistoryItem")
local btn_back_path = "Root/BottomBar/BtnBack"
local text_title_path = "Root/TopBar/TextTitle"
local scroll_view_path = "Root/ScrollView"
local content_path = "Root/ScrollView/Viewport/Content"
local empty_text_path = "Root/EmptyText"

function EncourageHistoryView:OnCreate()
  base.OnCreate(self)
  self.throneType = self:GetUserData()
  self:ComponentDefine()
  self:UpdateData()
  SFSNetwork.SendMessage(MsgDefines.GetKingdomPresentRecord, LuaEntry.Player:GetSourceServerId(), self.throneType)
end

function EncourageHistoryView:OnDestroy()
  self:ClearScroll()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function EncourageHistoryView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.GovernmentPresentRecordRefresh, self.UpdateData)
end

function EncourageHistoryView:OnRemoveListener()
  self:RemoveUIListener(EventId.GovernmentPresentRecordRefresh, self.UpdateData)
  base.OnRemoveListener(self)
end

function EncourageHistoryView:ComponentDefine()
  self.text_title = self:AddComponent(UIText, text_title_path)
  self.text_title:SetLocalText("457024")
  self.btn_back = self:AddComponent(UIButton, btn_back_path)
  self.btn_back:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.empty_text = self:AddComponent(UIText, empty_text_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.ScrollView = self:AddComponent(UIScrollView, scroll_view_path)
  self.ScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnRankItemMoveIn(itemObj, index)
  end)
  self.ScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnRankItemMoveOut(itemObj, index)
  end)
end

function EncourageHistoryView:ComponentDestroy()
  self.btn_back = nil
end

function EncourageHistoryView:UpdateData()
  local record = DataCenter.GovernmentManager:GetRewardRecord(self.throneType)
  if record ~= nil then
    self.kingName = record:GetPresidentName()
    self.rankList = record:GetShowList()
    if #self.rankList > 0 then
      self.count = #self.rankList
      self.ScrollView:SetTotalCount(self.count)
      self.ScrollView:RefillCells()
      self.empty_text:SetActive(false)
    else
      self.empty_text:SetActive(true)
      self:ClearScroll()
    end
  else
    self.empty_text:SetActive(true)
  end
end

function EncourageHistoryView:OnRankItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.ScrollView:AddComponent(EncourageHistoryItem, itemObj)
  if cellItem ~= nil then
    cellItem:ReInit(index, self.rankList[index], self.kingName)
  end
end

function EncourageHistoryView:OnRankItemMoveOut(itemObj, index)
  self.ScrollView:RemoveComponent(itemObj.name, EncourageHistoryItem)
end

function EncourageHistoryView:ClearScroll()
  self.ScrollView:ClearCells()
  self.ScrollView:RemoveComponents(EncourageHistoryItem)
end

return EncourageHistoryView
