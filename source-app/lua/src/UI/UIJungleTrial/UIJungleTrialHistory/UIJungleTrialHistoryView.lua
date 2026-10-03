local UIJungleTrialHistoryView = BaseClass("UIJungleTrialHistoryView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local JungleTrialHistoryItem = require("UI.UIJungleTrial.UIJungleTrialHistory.JungleTrialHistoryItem")
local panel_path = "panel"
local close_btn_path = "Root/Common_img_title/CloseBtn"
local no_log_txt_path = "Root/MiddleContent/noLogTxt"
local scroll_view_path = "Root/MiddleContent/ScrollView"

function UIJungleTrialHistoryView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:Refresh()
  DataCenter.JungleTrialDataManager:FetchHistoryData()
end

function UIJungleTrialHistoryView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIJungleTrialHistoryView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.JungleTrialHistoryRefresh, self.Refresh)
  self:AddUIListener(EventId.JungleTrialMonsterRefresh, self.Refresh)
end

function UIJungleTrialHistoryView:OnRemoveListener()
  self:RemoveUIListener(EventId.JungleTrialHistoryRefresh, self.Refresh)
  self:RemoveUIListener(EventId.JungleTrialMonsterRefresh, self.Refresh)
  base.OnRemoveListener(self)
end

function UIJungleTrialHistoryView:ComponentDefine()
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.no_log_txt = self:AddComponent(UITextMeshProUGUIEx, no_log_txt_path)
  self.ScrollView = self:AddComponent(UIScrollView, scroll_view_path)
  self.ScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnRankItemMoveIn(itemObj, index)
  end)
  self.ScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnRankItemMoveOut(itemObj, index)
  end)
  self.close_btn1 = self:AddComponent(UIButton, panel_path)
  self.close_btn1:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
end

function UIJungleTrialHistoryView:ComponentDestroy()
  self:ClearScroll()
  self.dataList = nil
  self.close_btn = nil
  self.no_log_txt = nil
  self.scroll_view = nil
  self.content = nil
end

function UIJungleTrialHistoryView:Refresh()
  local allData = DataCenter.JungleTrialDataManager:GetJungleTrialHistory()
  local aliveList = DataCenter.JungleTrialDataManager:GetChomperList()
  local aliveSet = {}
  for _, v in pairs(aliveList) do
    aliveSet[v.monsterUuid] = v.createTime
  end
  self.dataList = {}
  for _, v in ipairs(allData) do
    v.isAlive = aliveSet[v.monsterUuid] == v.createTime
    table.insert(self.dataList, v)
  end
  table.sort(self.dataList, function(a, b)
    if a.isAlive ~= b.isAlive then
      return a.isAlive
    end
    return a.createTime > b.createTime
  end)
  local dataCount = #self.dataList
  if 0 < dataCount then
    self.no_log_txt:SetActive(false)
    self.ScrollView:SetActive(true)
    self.ScrollView:SetTotalCount(dataCount)
    self.ScrollView:RefillCells()
  else
    self.no_log_txt:SetActive(true)
    self.ScrollView:SetActive(false)
  end
end

function UIJungleTrialHistoryView:OnRankItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.ScrollView:AddComponent(JungleTrialHistoryItem, itemObj)
  if cellItem ~= nil then
    cellItem:SetData(self.dataList[index])
  end
end

function UIJungleTrialHistoryView:OnRankItemMoveOut(itemObj, index)
  self.ScrollView:RemoveComponent(itemObj.name, JungleTrialHistoryItem)
end

function UIJungleTrialHistoryView:ClearScroll()
  self.ScrollView:ClearCells()
  self.ScrollView:RemoveComponents(JungleTrialHistoryItem)
end

return UIJungleTrialHistoryView
