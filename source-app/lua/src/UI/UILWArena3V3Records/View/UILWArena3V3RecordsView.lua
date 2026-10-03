local UILWArena3V3RecordsView = BaseClass("UILWArena3V3RecordsView", UIBaseView)
local base = UIBaseView
local UIRecordItem = require("UI.UILWArena3V3Records.Component.UILWArena3V3RecordItem")
local Localization = CS.GameEntry.Localization
local compBook = {
  {
    path = "root/top",
    name = "top",
    type = UIImage
  },
  {
    path = "root/top/txtTitle",
    name = "txtTitle",
    type = UIText
  },
  {
    path = "root/top/btnClose",
    name = "btnClose",
    type = UIButton
  },
  {
    path = "root/layoutChallengeTimes",
    name = "layoutChallengeTimes",
    type = nil
  },
  {
    path = "root/layoutChallengeTimes/txtRemainTimes",
    name = "txtRemainTimes",
    type = UIText
  },
  {
    path = "root/scrollRecords",
    name = "scrollRecords",
    type = UIDynamicVerticleScrollRectEx
  },
  {
    path = "root/txtEmpty",
    name = "txtEmpty",
    type = UIText
  },
  {
    path = "bg",
    name = "btnBlack",
    type = UIButton
  }
}

function UILWArena3V3RecordsView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.logs, self.gotoRecordTime = self:GetUserData()
  self:Refresh(self.logs)
end

function UILWArena3V3RecordsView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
  self.itemDatas = nil
  self.recordItemMap = nil
end

function UILWArena3V3RecordsView:ComponentDefine()
  self:DefineCompsByBook(compBook)
  self.txtTitle:SetText(Localization:GetString("801120"))
  self.txtEmpty:SetText(Localization:GetString("302233"))
  self.btnClose:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.btnBlack:SetOnClick(function()
    self.ctrl:CloseSelf()
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
    if not DataCenter.LW3V3Manager:IsRecordRequested(record) then
      DataCenter.LW3V3Manager:RequestRecordsMails(record)
    end
  end)
end

function UILWArena3V3RecordsView:ComponentDestroy()
  self:ClearCompsByBook(compBook)
end

function UILWArena3V3RecordsView:Refresh(recordsData)
  self.itemDatas = {}
  local prefabIdxs = {}
  if recordsData then
    for i = #recordsData, 1, -1 do
      local log = recordsData[i]
      table.insert(self.itemDatas, log)
      table.insert(prefabIdxs, 0)
    end
  end
  self.scrollRecords:SetDatas(prefabIdxs)
  if self.gotoRecordTime then
    local dataIndex, recordData
    for i = 1, #self.itemDatas do
      local log = self.itemDatas[i]
      if log.time == self.gotoRecordTime then
        dataIndex = i - 1
        recordData = log
        break
      end
    end
    if dataIndex then
      self.scrollRecords:SetScrollOffset(self.scrollRecords:GetScrollOffsetOfDataIdx(dataIndex, 0))
      local selfPlayerInfo = DataCenter.LW3V3Manager:PackSelfPlayerInfo()
      selfPlayerInfo.lastRank = recordData.oldRank
      selfPlayerInfo.curRank = recordData.curRank
      local otherPlayerInfo = recordData.playerInfo
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIArena3V3BattleResult, {anim = false}, recordData, selfPlayerInfo, otherPlayerInfo)
    end
  end
  self.txtEmpty:SetActive(not recordsData or #recordsData == 0)
end

function UILWArena3V3RecordsView:RefreshChallengeTimes(challengeTimes, maxChallengeTimes)
  self.txtRemainTimes:SetText(Localization:GetString("801109", challengeTimes))
  TimerManager:GetInstance():GetTimer(2, function()
    self.layoutChallengeTimes:SetActive(false)
    self.layoutChallengeTimes:SetActive(true)
  end, self, true, true):Start()
end

return UILWArena3V3RecordsView
