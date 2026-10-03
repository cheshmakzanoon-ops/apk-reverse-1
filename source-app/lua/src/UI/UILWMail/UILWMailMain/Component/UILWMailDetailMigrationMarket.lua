local UILWMailDetailMigrationMarket = BaseClass("UILWMailDetailMigrationMarket", UIBaseContainer)
local base = UIBaseContainer
local UILWMailDetailMigrationMarketItem = require("UI.UILWMail.UILWMailMain.Component.UILWMailDetailMigrationMarketItem")
local rapidjson = require("rapidjson")
local detail_title_path = "System/DetailTitle"
local d_message_path = "System/DMessage"
local d_scroll_path = "System/DScroll"
local btn_path = "System/Btn"
local detail_time_path = "System/DetailTimeBg/DetailTime"

function UILWMailDetailMigrationMarket:OnCreate()
  base.OnCreate(self)
  self.detail_title = self:AddComponent(UITextMeshProUGUIEx, detail_title_path)
  self.d_message = self:AddComponent(UITextMeshProUGUIEx, d_message_path)
  self.d_scroll = self:AddComponent(UIScrollView, d_scroll_path)
  self.d_scroll:SetOnItemMoveIn(function(itemObj, index)
    self:OnRankItemMoveIn(itemObj, index)
  end)
  self.d_scroll:SetOnItemMoveOut(function(itemObj, index)
    self:OnRankItemMoveOut(itemObj, index)
  end)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(BindCallback(self, self.OnClick))
  local actId = DataCenter.ActMigrationManager:GetCurActId()
  self.btn:SetActive(actId ~= nil)
  self.detail_time = self:AddComponent(UITextMeshProUGUIEx, detail_time_path)
end

function UILWMailDetailMigrationMarket:OnDestroy()
  if self.lastTime and self.lastTime > 0 then
    DataCenter.ActMigrationManager:UpdateMarketTime(self.lastTime)
  end
  self.lastTime = nil
  self:ClearList()
  self.detail_title = nil
  self.d_message = nil
  self.d_scroll = nil
  self.btn = nil
  self.detail_time = nil
  self.list = nil
  base.OnDestroy(self)
end

function UILWMailDetailMigrationMarket:ClearList()
  self.d_scroll:ClearCells()
  self.d_scroll:RemoveComponents(UILWMailDetailMigrationMarketItem)
end

function UILWMailDetailMigrationMarket:RefreshContent()
  self.mailUid = self.view.ctrl:GetCurrentMail()
  self.mailData = self.view.ctrl:GetCurrentMailData()
  self.detail_title:SetText(MailShowHelper.GetMainTitle(self.mailData))
  self.d_message:SetText(self.mailData:GetMailMessage())
  local _strTime = MailShowHelper.GetAbstractCreateTime(self.mailData)
  self.detail_time:SetText(_strTime)
  local data = rapidjson.decode(self.mailData.contents)
  local listStr = data.obj.marketList or ""
  self.list = rapidjson.decode(listStr) or {}
  local cnt = #self.list
  local time = 0
  if 0 < cnt then
    for _, v in pairs(self.list) do
      if time < v.time then
        time = v.time
      end
    end
  end
  self.lastTime = time
  self:ClearList()
  self.d_scroll:SetTotalCount(cnt)
  self.d_scroll:RefillCells()
  self.d_scroll:SetVerticalNormalizedPosition(1)
  self.d_scroll:ScrollToCell(1, 500)
end

function UILWMailDetailMigrationMarket:OnRankItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.d_scroll:AddComponent(UILWMailDetailMigrationMarketItem, itemObj)
  if cellItem ~= nil then
    cellItem:SetData(self.list[index], index, self)
  end
end

function UILWMailDetailMigrationMarket:OnRankItemMoveOut(itemObj, index)
  self.d_scroll:RemoveComponent(itemObj.name, UILWMailDetailMigrationMarketItem)
end

function UILWMailDetailMigrationMarket:OnClick()
  DataCenter.ActMigrationManager:JumpToTab(4)
end

function UILWMailDetailMigrationMarket:UpdateInvite(index)
  local info = self.list[index]
  if info then
    info.bInvited = true
  end
end

return UILWMailDetailMigrationMarket
