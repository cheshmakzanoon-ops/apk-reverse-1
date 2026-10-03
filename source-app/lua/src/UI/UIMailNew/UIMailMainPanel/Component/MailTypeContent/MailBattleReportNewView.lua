local MailBattleReportNewView = BaseClass("MailBattleReportNewView", UIBaseContainer)
local base = UIBaseContainer
local MailContentTitle = require("UI.UIMailNew.UIMailMainPanel.Component.MailContentTitle")
local MailPlayerReport = require("UI.UIMailNew.UIMailMainPanel.Component.MailTypeContent.BattleTypeNew.MailPlayerReport")
local MailPlayerReportTotal = require("UI.UIMailNew.UIMailMainPanel.Component.MailTypeContent.BattleTypeNew.MailPlayerReportTotal")
local _cp_looplistview = "ScrollView"
local _cp_looplistview_content = "ScrollView/Viewport/Content"
local eConfigType = {
  eContentTitle = 1,
  eBattleTotal = 2,
  eBattleTeamItem = 3
}
local eConfig = {
  [eConfigType.eContentTitle] = {
    Prefab = "UIMailItemTitle",
    Script = MailContentTitle
  },
  [eConfigType.eBattleTotal] = {
    Prefab = "MailPlayerReportTotal",
    Script = MailPlayerReportTotal
  },
  [eConfigType.eBattleTeamItem] = {
    Prefab = "MailPlayerReport",
    Script = MailPlayerReport
  }
}

function MailBattleReportNewView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.Event_ShowBattleReportDetail, self.ShowBattleReportDetail)
end

function MailBattleReportNewView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.Event_ShowBattleReportDetail, self.ShowBattleReportDetail)
end

function MailBattleReportNewView:ShowBattleReportDetail(message)
  if table.IsNullOrEmpty(message) then
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIMailDetailReportView, {anim = false}, message)
end

function MailBattleReportNewView:OnCreate()
  base.OnCreate(self)
  self._totalItemCnt = 0
  self.showTotalMessage = false
  self._cellList = {}
  self._looplistview = self:AddComponent(UILoopListView2, _cp_looplistview)
  self._looplistview_content = self:AddComponent(UIBaseContainer, _cp_looplistview_content)
  self._looplistview:InitListView(0, function(listview, index)
    return self:GetScrollItem(listview, index)
  end)
end

function MailBattleReportNewView:OnDestroy()
  self._cellList = {}
  for _, config in pairs(eConfig) do
    local component = config.Script
    self._looplistview_content:RemoveComponents(component)
  end
  self._looplistview:ClearAllItems()
end

function MailBattleReportNewView:OnDisable()
  base.OnDisable(self)
end

function MailBattleReportNewView:GetConfigByIndex(index)
  if index == 1 then
    return eConfig[eConfigType.eContentTitle]
  elseif self.showTotalMessage == true and index == 2 then
    return eConfig[eConfigType.eBattleTotal]
  else
    return eConfig[eConfigType.eBattleTeamItem]
  end
end

function MailBattleReportNewView:GetScrollItem(listview, index)
  index = index + 1
  if index < 1 or index > self._totalItemCnt then
    return nil
  end
  local config_data = self:GetConfigByIndex(index)
  local item = listview:NewListViewItem(config_data.Prefab)
  if self._cellList[item] == nil then
    NameCount = NameCount + 1
    local nameStr = tostring(NameCount)
    item.gameObject.name = nameStr
    local mailItem = self._looplistview_content:AddComponent(config_data.Script, nameStr)
    self._cellList[item] = mailItem
  end
  xpcall(function()
    self:SetItemData(self._cellList[item], index)
  end, function()
    Logger.LogError(" \229\164\167BUG.\231\190\164\233\135\140\229\143\145\228\184\128\228\184\139\229\144\167\239\188\129\239\188\129\239\188\129 ")
  end)
  return item
end

function MailBattleReportNewView:SetItemData(handler, index)
  if index == 1 then
    self:SetItemData_CommonTitle(handler)
  elseif self.showTotalMessage == true then
    handler:SetData(self._maildata, index - 2, self.needShowReplay, self.jumpType)
  else
    handler:SetData(self._maildata, index - 1, self.needShowReplay, self.jumpType)
  end
end

function MailBattleReportNewView:SetItemData_CommonTitle(handler)
  local param = {}
  param.main = MailShowHelper.GetMainTitle(self._maildata)
  param.sub = MailShowHelper.GetMailSummary(self._maildata)
  param.time = MailShowHelper.GetAbstractCreateTime(self._maildata)
  param.mailInfo = self._maildata
  handler:SetData(param)
end

function MailBattleReportNewView:setData(maildata, showReplay, jumpType)
  self._maildata = maildata
  self.needShowReplay = showReplay
  self.jumpType = jumpType
  maildata:GetMailExt():SortRound()
  local roundCount = maildata:GetMailExt():GetTotalRoundCnt()
  if 1 < roundCount and maildata.type ~= MailType.ELITE_FIGHT_MAIL then
    self.showTotalMessage = true
    self._totalItemCnt = maildata:GetMailExt():GetTotalRoundCnt() + 2
  else
    self.showTotalMessage = false
    self._totalItemCnt = maildata:GetMailExt():GetTotalRoundCnt() + 1
  end
  self._looplistview:SetListItemCount(self._totalItemCnt, true, true)
  self._looplistview:RefreshAllShownItem()
end

return MailBattleReportNewView
