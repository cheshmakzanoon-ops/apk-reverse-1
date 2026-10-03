local LWPVPArenaPeakRecordsPanel = BaseClass("LWPVPArenaPeakRecordsPanel", UIBaseContainer)
local base = UIBaseContainer
local UIRecordItem = require("UI.LWPVPArena.Main.Component.Peak.LWPVPArenaPeakRecordItem")
local Localization = CS.GameEntry.Localization
local compBook = {
  {
    path = "top/txtTitle",
    name = "txtTitle",
    type = UIText
  },
  {
    path = "top/btnClose",
    name = "btnClose",
    type = UIButton
  },
  {
    path = "layoutChallengeTimes",
    name = "layoutChallengeTimes",
    type = nil
  },
  {
    path = "layoutChallengeTimes/btnAdd",
    name = "btnAdd",
    type = UIButton
  },
  {
    path = "layoutChallengeTimes/txtRemainTimes",
    name = "txtRemainTimes",
    type = UIText
  },
  {
    path = "scrollRecords",
    name = "scrollRecords",
    type = UIDynamicVerticleScrollRectEx
  },
  {
    path = "txtEmpty",
    name = "txtEmpty",
    type = UIText
  },
  {
    path = "black",
    name = "btnBlack",
    type = UIButton
  }
}

function LWPVPArenaPeakRecordsPanel:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function LWPVPArenaPeakRecordsPanel:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
  self.itemDatas = nil
  self.recordItemMap = nil
end

function LWPVPArenaPeakRecordsPanel:ComponentDefine()
  self:DefineCompsByBook(compBook)
  self.txtTitle:SetText(Localization:GetString("801120"))
  self.txtEmpty:SetText(Localization:GetString("302233"))
  self.btnClose:SetOnClick(function()
    if self.holder then
      self.holder:SetActive(false)
    end
  end)
  self.btnBlack:SetOnClick(function()
    if self.holder then
      self.holder:SetActive(false)
    end
  end)
  self.btnAdd:SetOnClick(function()
    LWResourceLackUtil:GotoGoodsItemLack(DataCenter.LWPVPArenaManager:GetChallengeItemId(), 1)
  end)
  self.itemIncNo = 1
  self.recordItemMap = {}
  self.scrollRecords:AddInstantiateItemListener(function(itemObj, prefabIdx)
    itemObj.name = "recordItem_" .. self.itemIncNo
    self.itemIncNo = self.itemIncNo + 1
    local recordItem = self:AddComponent(UIRecordItem, itemObj)
    self.recordItemMap[itemObj] = recordItem
  end)
  self.scrollRecords:AddDisplayItemListener(function(itemObj, dataIdx)
    local recordItem = self.recordItemMap[itemObj]
    if recordItem then
      recordItem:Refresh(self.itemDatas[dataIdx + 1])
    end
    local record = self.itemDatas[dataIdx + 1]
    if record and record.log and not DataCenter.LWKOFBattleManager:IsRecordRequested(record.log) then
      DataCenter.LWKOFBattleManager:RequestRecordsMails(record.log)
    end
  end)
end

function LWPVPArenaPeakRecordsPanel:ComponentDestroy()
  self:ClearCompsByBook(compBook)
end

function LWPVPArenaPeakRecordsPanel:Refresh(recordsData)
  local arenaData = DataCenter.LWPVPArenaManager.rankData
  self.itemDatas = {}
  local prefabIdxs = {}
  if recordsData.logs then
    for i = #recordsData.logs, 1, -1 do
      local log = recordsData.logs[i]
      local data = {log = log, canChallenge = false}
      if (log.battleState == 2 or log.battleState == 4) and arenaData then
        for _, player in ipairs(arenaData.players) do
          if player.uid == log.uid then
            data.canChallenge = player.isBattle > 0
            break
          end
        end
      end
      table.insert(self.itemDatas, data)
      table.insert(prefabIdxs, 0)
    end
  end
  self.scrollRecords:SetDatas(prefabIdxs)
  self.txtEmpty:SetActive(not recordsData.logs or #recordsData.logs == 0)
end

function LWPVPArenaPeakRecordsPanel:RefreshChallengeTimes(challengeTimes, maxChallengeTimes)
  self.txtRemainTimes:SetText(Localization:GetString("801109", challengeTimes))
  self.btnAdd:SetActive(DataCenter.LWPVPArenaManager.state == PVPArenaState.Open and challengeTimes < maxChallengeTimes and DataCenter.LWPVPArenaManager.selfRank)
  TimerManager:GetInstance():GetTimer(2, function()
    if self.layoutChallengeTimes then
      self.layoutChallengeTimes:SetActive(false)
      self.layoutChallengeTimes:SetActive(true)
    end
  end, self, true, true):Start()
end

return LWPVPArenaPeakRecordsPanel
