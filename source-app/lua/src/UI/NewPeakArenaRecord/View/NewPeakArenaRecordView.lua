local NewPeakArenaRecordView = BaseClass("NewPeakArenaRecordView", UIBaseView)
local base = UIBaseView
local UIRecordItem = require("UI.NewPeakArenaRecord.Component.NewPeakArenaRecordItem")
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
local showAnimIndex = 5

function NewPeakArenaRecordView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.logs, self.gotoRecordTime, self.pvpArenaType = self:GetUserData()
  self:Refresh(self.logs)
end

function NewPeakArenaRecordView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
  self.itemDatas = nil
  self.recordItemMap = nil
  self.showAnimIndex = nil
end

function NewPeakArenaRecordView:ComponentDefine()
  self:DefineCompsByBook(compBook)
  self.txtTitle:SetText(Localization:GetString("new_arena_tips_26"))
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
      if self.showAnimIndex == nil then
        self.showAnimIndex = 1
      end
      if self.showAnimIndex <= showAnimIndex then
        recordItem:SetAlpha(0)
        TimerManager:GetInstance():DelayInvoke(function()
          recordItem:PlayAnim()
        end, self.showAnimIndex * 0.03)
        self.showAnimIndex = self.showAnimIndex + 1
      end
    end
    local record = self.itemDatas[dataIdx + 1]
    if not DataCenter.LWKOFBattleManager:IsRecordRequested(record) then
      DataCenter.LWKOFBattleManager:RequestRecordsMails(record)
    end
  end)
end

function NewPeakArenaRecordView:ComponentDestroy()
  self:ClearCompsByBook(compBook)
end

function NewPeakArenaRecordView:Refresh(recordsData)
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

function NewPeakArenaRecordView:RefreshChallengeTimes(challengeTimes, maxChallengeTimes)
  self.txtRemainTimes:SetText(Localization:GetString("801109", challengeTimes))
  TimerManager:GetInstance():GetTimer(2, function()
    self.layoutChallengeTimes:SetActive(false)
    self.layoutChallengeTimes:SetActive(true)
  end, self, true, true):Start()
end

return NewPeakArenaRecordView
