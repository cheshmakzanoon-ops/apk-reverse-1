local LWActivityArenaRecordsView = BaseClass("LWActivityArenaRecordsView", UIBaseView)
local base = UIBaseView
local UIRecordItem = require("UI.LWActivityArena.Records.Component.LWActivityArenaRecordItem")
local Localization = CS.GameEntry.Localization
local compBook = {
  {
    path = "top/txtTitle",
    name = "txtTitle",
    type = UIText,
    textKey = "801120"
  },
  {
    path = "top/btnClose",
    name = "btnClose",
    type = UIButton,
    onClick = function(self)
      self.ctrl:CloseSelf()
    end
  },
  {
    path = "layoutChallengeTimes",
    name = "layoutChallengeTimes",
    type = nil
  },
  {
    path = "layoutChallengeTimes/btnAdd",
    name = "btnAddTimes",
    type = UIButton,
    onClick = function(self)
      self:OnClickAddTimes()
    end
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
    type = UIText,
    textKey = "302233"
  },
  {
    path = "black",
    name = "btnBlack",
    type = UIButton,
    onClick = function(self)
      self.ctrl:CloseSelf()
    end
  }
}

function LWActivityArenaRecordsView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:Refresh(self:GetUserData())
end

function LWActivityArenaRecordsView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
  self.itemDatas = nil
  self.recordItemMap = nil
end

function LWActivityArenaRecordsView:ComponentDefine()
  self:DefineCompsByBook(compBook)
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

function LWActivityArenaRecordsView:ComponentDestroy()
  self:ClearCompsByBook(compBook)
end

function LWActivityArenaRecordsView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ActivityArenaInfoUpdate, self.OnArenaInfoUpdate)
end

function LWActivityArenaRecordsView:OnRemoveListener()
  self:RemoveUIListener(EventId.ActivityArenaInfoUpdate, self.OnArenaInfoUpdate)
  base.OnRemoveListener(self)
end

function LWActivityArenaRecordsView:Refresh(arenaInfo)
  self.arenaInfo = arenaInfo
  self.itemDatas = {}
  local prefabIdxs = {}
  if arenaInfo.logs then
    for i = #arenaInfo.logs, 1, -1 do
      local log = arenaInfo.logs[i]
      local data = {
        log = log,
        canChallenge = false,
        activityId = arenaInfo.id
      }
      if arenaInfo.state == ActivityArenaState.Fight and (log.battleState == 2 or log.battleState == 4) and arenaInfo.rankInfo then
        for _, rankData in ipairs(arenaInfo.rankInfo.dataList) do
          if tostring(rankData.playerId) == tostring(log.playerId) then
            data.canChallenge = rankData.isBattle > 0
            break
          end
        end
      end
      table.insert(self.itemDatas, data)
      table.insert(prefabIdxs, 0)
    end
  end
  self.scrollRecords:SetDatas(prefabIdxs)
  self.scrollRecords:SetSizeDeltaXY(750, arenaInfo.state == ActivityArenaState.Fight and 895 or 978)
  self.scrollRecords:SetAnchoredPositionXY(0, arenaInfo.state == ActivityArenaState.Fight and 354 or 437)
  self.txtEmpty:SetActive(not arenaInfo.logs or #arenaInfo.logs == 0)
  self.txtRemainTimes:SetActive(arenaInfo.state == ActivityArenaState.Fight)
  self.txtRemainTimes:SetText(Localization:GetString("801109", arenaInfo.remainFree))
  self.btnAddTimes:SetActive(arenaInfo.state == ActivityArenaState.Fight and arenaInfo.remainFree == 0 and 0 < arenaInfo.remainBuy)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.layoutChallengeTimes.transform)
end

function LWActivityArenaRecordsView:OnClickAddTimes()
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWActivityArenaBuyTimes, {anim = true}, self.arenaInfo)
end

function LWActivityArenaRecordsView:OnArenaInfoUpdate(activityId)
  if self.arenaInfo and self.arenaInfo.id == activityId then
    self:Refresh(self.arenaInfo)
  end
end

return LWActivityArenaRecordsView
