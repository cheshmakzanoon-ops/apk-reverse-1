local LWFireworkManager = BaseClass("LWFireworkManager", CEventable)
local Setting = CS.GameEntry.Setting
local Localization = CS.GameEntry.Localization
local LWFireworkInfo = require("DataCenter.LWFirework.LWFireworkInfo")
local LWFireworkQueue = require("DataCenter.LWFirework.LWFireworkQueue")
local QUICK_FIRE_RECORD_NUM = 4
local QUICK_FIRE_RECORD_JUDGE_TIME = 10
local DEFAULT_LOW_GEAR_FIREWORK_THRESHOLD = 6
local DEFAULT_MID_GEAR_FIREWORK_THRESHOLD = 12

function LWFireworkManager:__init()
  self.inQuickMode = false
  self.lastPostLogTime = tonumber(Setting:GetPrivateString(SettingKeys.FIREWORK_LAST_POST_TIME, "0"))
  self.defaultFireworkItemId = Setting:GetPrivateString(SettingKeys.FIREWORK_DEFAULT_ITEM_ID, "")
  if not string.IsNullOrEmpty(self.defaultFireworkItemId) and not LocalController:instance():hasLine(TableName.Firework, tonumber(self.defaultFireworkItemId)) then
    self:AutoSetDefaultFireworkId()
  end
  self.uid2FireworkQueueMap = {}
  self.uid2ClientFirework = {}
  self.uid2PreClientFirework = {}
  self.checkQuickModeFlagThisLoginTime = false
  self.isNeedShowWorldPointGuide = false
  self:AddListener()
  self.updateSecTimer = TimerManager:GetInstance():GetTimer(1, self.OnUpdateSec, self, false, false, true)
  self.updateSecTimer:Start()
  self.curFireworkNumInScene = 0
end

local function DeleteTimer(self)
  if self.updateSecTimer ~= nil then
    self.updateSecTimer:Stop()
    self.updateSecTimer = nil
  end
end

function LWFireworkManager:__delete()
  DeleteTimer(self)
  self.defaultFireworkItemId = nil
  self.uid2FireworkQueueMap = nil
  self.uid2ClientFirework = nil
  self.uid2PreClientFirework = nil
  self.lastPostLogTime = nil
  self.inQuickMode = nil
  self.quickModeRecordQueue = nil
  self.checkQuickModeFlagThisLoginTime = nil
  self.curFireworkNumInScene = nil
  self.isNeedShowWorldPointGuide = nil
end

function LWFireworkManager:Startup()
end

function LWFireworkManager:AddListener()
  self:RegisterEvent(EventId.WorldMarchUpdateDisplayMode, self.OnWorldMarchUpdateDisplayMode)
  self:RegisterEvent(EventId.OnEnterWorld, self.OnEnterWorld)
  self:RegisterEvent(EventId.OnEnterCity, self.OnEnterCity)
end

function LWFireworkManager:OnWorldMarchUpdateDisplayMode()
  local curDisplayLv = DisplaySettings.GetCurrentDisplayLevel()
  if curDisplayLv < -2 then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if curTime > self.lastPostLogTime + OneHourTime * 1000 then
      local count = 0
      local mainBaseList = CS.SceneManager.World and CS.SceneManager.World:GetAllMainBaseListByType(CS.PlayerType.PlayerSelf, CS.PlayerType.PlayerAlliance)
      if mainBaseList then
        for i = 0, mainBaseList.Count - 1 do
          if DataCenter.LWFireworkManager:IsFiringByUid(mainBaseList[i].ownerUid) then
            count = count + 1
          end
        end
        PostEventLog.Track(PostEventLog.Defines.FireworkCount, {completenum = count})
        self.lastPostLogTime = curTime
        Setting:SetPrivateString(SettingKeys.FIREWORK_LAST_POST_TIME, tostring(self.lastPostLogTime))
      end
    end
  end
end

function LWFireworkManager:OnUpdateSec()
  if self.uid2FireworkQueueMap then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    for k, v in pairs(self.uid2FireworkQueueMap) do
      local size = v:GetSize()
      if 0 < size then
        for i = 1, size do
          local firstData = v:Peek()
          if curTime >= firstData.endTime then
            v:Dequeue()
          else
            break
          end
        end
      else
        self.uid2FireworkQueueMap[k] = nil
      end
    end
    EventManager:GetInstance():Broadcast(EventId.FireworkTimeDataUpdate)
  end
end

function LWFireworkManager:AutoSetDefaultFireworkId()
  local foundId
  LocalController:instance():visitTable(TableName.Firework, function(id, lineData)
    local itemId = tostring(id)
    local itemCount = DataCenter.ItemData:GetItemCount(itemId)
    if itemCount and 0 < itemCount and not foundId then
      foundId = itemId
      return false
    end
  end)
  self:SetDefaultFireworkItemId(foundId or "661501")
end

function LWFireworkManager:GetDefaultFireworkItemId()
  if string.IsNullOrEmpty(self.defaultFireworkItemId) then
    self:AutoSetDefaultFireworkId()
  end
  return self.defaultFireworkItemId
end

function LWFireworkManager:SetDefaultFireworkItemId(defaultFireworkItemId)
  if not string.IsNullOrEmpty(defaultFireworkItemId) then
    Setting:SetPrivateString(SettingKeys.FIREWORK_DEFAULT_ITEM_ID, defaultFireworkItemId)
  end
  self.defaultFireworkItemId = defaultFireworkItemId
end

function LWFireworkManager:UpdateFireworkQueueByUserUid(uid, fireworkInfoList)
  if not uid then
    return
  end
  local itemId = DataCenter.LWFireworkManager:GetDefaultFireworkItemId()
  local requireCount = LuaEntry.DataConfig:TryGetNum("fireworks", "k5")
  local continueFire = false
  self.quickModeRecordQueue = self.quickModeRecordQueue or LWFireworkQueue.New()
  if self.quickModeRecordQueue:GetSize() >= QUICK_FIRE_RECORD_NUM then
    local firstData = self.quickModeRecordQueue:Peek()
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if curTime - firstData < QUICK_FIRE_RECORD_JUDGE_TIME * 1000 then
      continueFire = true
    end
  end
  local remainItemCountMeet = requireCount <= DataCenter.ItemData:GetItemCount(itemId) or self.checkQuickModeFlagThisLoginTime
  if remainItemCountMeet and continueFire then
    self:SetInQuickMode(true)
  end
  local newQueue = LWFireworkQueue.New()
  for k, v in ipairs(fireworkInfoList) do
    local newData = LWFireworkInfo.New()
    newData:SetData(v)
    newQueue:Enqueue(newData)
  end
  self.uid2FireworkQueueMap[uid] = newQueue
  EventManager:GetInstance():Broadcast(EventId.FireworkDataCsUpdate)
end

function LWFireworkManager:UpdateFireworkQueueByUserUidCsData(uid, fireworkInfoList)
  if not uid then
    return
  end
  if not fireworkInfoList or not self.uid2FireworkQueueMap[uid] and fireworkInfoList.Count == 0 then
    return
  end
  local newQueue = LWFireworkQueue.New()
  for i = 0, fireworkInfoList.Count - 1 do
    local newData = LWFireworkInfo.New()
    newData:SetCsData(fireworkInfoList[i])
    newQueue:Enqueue(newData)
  end
  self.uid2FireworkQueueMap[uid] = newQueue
  EventManager:GetInstance():Broadcast(EventId.FireworkDataCsUpdate)
end

function LWFireworkManager:IsFiringByUid(uid)
  if self.uid2FireworkQueueMap[uid] then
    local lastData = self.uid2FireworkQueueMap[uid]:LastPeek()
    return lastData and lastData:GetRemainTime() > 0
  end
  return false
end

function LWFireworkManager:GetQueueCountByUid(uid)
  if self.uid2FireworkQueueMap[uid] then
    return self.uid2FireworkQueueMap[uid]:GetSize()
  end
  return 0
end

function LWFireworkManager:GetFireworkQueueByUid(uid)
  if self.uid2FireworkQueueMap[uid] then
    return self.uid2FireworkQueueMap[uid]
  end
end

function LWFireworkManager:GetFireworkQueueRemainTimeByUid(uid)
  local ret = 0
  if self.uid2FireworkQueueMap[uid] and not self.uid2FireworkQueueMap[uid]:IsEmpty() then
    return self.uid2FireworkQueueMap[uid]:LastPeek():GetRemainTime()
  end
  return ret
end

function LWFireworkManager:GetMaxQueueCount()
  if not self.maxQueueCount then
    self.maxQueueCount = LuaEntry.DataConfig:TryGetNum("fireworks", "k1", 1)
  end
  return self.maxQueueCount
end

function LWFireworkManager:IsInQuickMode()
  return self.inQuickMode
end

function LWFireworkManager:SetInQuickMode(isInQuickMode)
  self.inQuickMode = isInQuickMode
  if isInQuickMode then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIFireworkQuickTip, {anim = true})
    self.checkQuickModeFlagThisLoginTime = true
  else
  end
  EventManager:GetInstance():Broadcast(EventId.RefreshAllAllianceMainBuildingsInView)
end

function LWFireworkManager:UseFireworkItem(playerUid)
  if BattleFieldUtil.InBattleField() then
    UIUtil.ShowTipsId("firework_tips_1019")
    return
  end
  local defaultFireworkId = DataCenter.LWFireworkManager:GetDefaultFireworkItemId()
  local resCount = DataCenter.ItemData:GetItemCount(defaultFireworkId)
  if 0 < resCount then
    local isFiring = DataCenter.LWFireworkManager:IsFiringByUid(playerUid)
    if isFiring then
      local queueCount = DataCenter.LWFireworkManager:GetQueueCountByUid(playerUid)
      if queueCount >= DataCenter.LWFireworkManager:GetMaxQueueCount() then
        UIUtil.ShowTipsId("firework_tips_1004")
      else
        if DataCenter.SecondConfirmManager:GetTodayCanShowSecondConfirm(TodayNoSecondConfirmType.ShowFireworkQueue) then
          UIManager:GetInstance():OpenWindow(UIWindowNames.UIFireworkQueue, {anim = true}, {uid = playerUid})
        else
          local itemData = DataCenter.ItemData:GetItemById(defaultFireworkId)
          self:SendUseFireworkMessage(playerUid, itemData)
        end
        if DataCenter.LWFireworkManager:IsInQuickMode() then
          local m = DataCenter.AllianceMemberDataManager:GetAllianceMemberByUid(playerUid)
          local name = m and m.name or ""
          local showName = m and DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(playerUid, m.name) or name
          local time = UITimeManager:GetInstance():MilliSecondToFmtString(DataCenter.LWFireworkManager:GetFireworkQueueRemainTimeByUid(playerUid))
          UIUtil.ShowTips(Localization:GetString("firework_tips_1010", time, showName))
        end
      end
    else
      local itemData = DataCenter.ItemData:GetItemById(defaultFireworkId)
      self:SendUseFireworkMessage(playerUid, itemData)
    end
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIFireworkGoodsLack, {anim = true})
  end
end

function LWFireworkManager:SendUseFireworkMessage(playerUid, itemData)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIWorldPoint)
  if not itemData then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.ItemUse, {
    uuid = itemData.uuid,
    num = 1,
    prtUid = playerUid
  })
  local info = CS.SceneManager.World:GetBaseMainInfoByOwnerUid(playerUid)
  if info then
    self:SetPreClientFirework(playerUid, itemData.goods.quality - 2)
    EventManager:GetInstance():Broadcast(EventId.WorldBuildTopBubbleRefresh, info.uuid)
    return nil
  end
end

function LWFireworkManager:GetMainBuildingWorldPosByOwner(ownerUid)
  local info = CS.SceneManager.World:GetBaseMainInfoByOwnerUid(ownerUid)
  if not info then
    return nil
  end
  local worldPos = SceneUtils.TileIndexToWorld(info.mainIndex, ForceChangeScene.World, info.serverId)
  return worldPos
end

function LWFireworkManager:GetRandomFiringPlayerUid()
  self:OnUpdateSec()
  if self.uid2FireworkQueueMap then
    for k, v in pairs(self.uid2FireworkQueueMap) do
      if v and v:GetSize() > 0 then
        return k
      end
    end
  end
end

function LWFireworkManager:RecordQueueFireBySelf()
  self.quickModeRecordQueue = self.quickModeRecordQueue or LWFireworkQueue.New()
  local size = self.quickModeRecordQueue:GetSize()
  if size < QUICK_FIRE_RECORD_NUM then
    self.quickModeRecordQueue:Enqueue(UITimeManager:GetInstance():GetServerTime())
  else
    self.quickModeRecordQueue:Dequeue()
    self.quickModeRecordQueue:Enqueue(UITimeManager:GetInstance():GetServerTime())
  end
end

function LWFireworkManager:HasAnyFireworkGoods()
  local flag = false
  LocalController:instance():visitTable(TableName.Firework, function(id, lineData)
    local itemId = tostring(id)
    local itemCount = DataCenter.ItemData:GetItemCount(itemId)
    if itemCount and 0 < itemCount then
      flag = true
    end
  end)
  return flag
end

function LWFireworkManager:SetNeedShowWorldPointGuide(value)
  self.isNeedShowWorldPointGuide = value
end

function LWFireworkManager:GetNeedShowWorldPointGuide()
  return self.isNeedShowWorldPointGuide
end

function LWFireworkManager:SetClientFirework(uid, value)
  self.uid2ClientFirework[uid] = value
end

function LWFireworkManager:HasClientFirework(uid)
  return self.uid2ClientFirework[uid]
end

function LWFireworkManager:SetPreClientFirework(uid, quality)
  if not self:IsReachThresholdFireworkNumInScene() then
    self.uid2PreClientFirework[uid] = quality
  end
end

function LWFireworkManager:GetPreClientFirework(uid)
  return self.uid2PreClientFirework[uid]
end

function LWFireworkManager:OnEnterWorld()
  self:ResetCurFireworkNumInScene()
end

function LWFireworkManager:OnEnterCity()
  self:ResetCurFireworkNumInScene()
end

function LWFireworkManager:AddCurFireworkNumInScene()
  self.curFireworkNumInScene = (self.curFireworkNumInScene or 0) + 1
end

function LWFireworkManager:SubCurFireworkNumInScene()
  self.curFireworkNumInScene = math.max((self.curFireworkNumInScene or 0) - 1, 0)
end

function LWFireworkManager:ResetCurFireworkNumInScene()
  self.curFireworkNumInScene = 0
end

function LWFireworkManager:GetFireworkMaxNum(isLowGearQuality)
  if self.fireworkMaxNum then
    return self.fireworkMaxNum
  else
    return isLowGearQuality and DEFAULT_LOW_GEAR_FIREWORK_THRESHOLD or DEFAULT_MID_GEAR_FIREWORK_THRESHOLD
  end
end

function LWFireworkManager:SetFireworkMaxNum(maxNum)
  maxNum = tonumber(maxNum)
  if not maxNum then
    return
  end
  maxNum = math.floor(maxNum)
  if maxNum < 0 then
    maxNum = 0
  end
  self.fireworkMaxNum = maxNum
end

function LWFireworkManager:IsReachThresholdFireworkNumInScene()
  local isLowGearQuality = GameQualitySettings.IsLowGearQuality()
  local isMiddleGearQuality = GameQualitySettings.IsMidGearQuality()
  if isLowGearQuality or isMiddleGearQuality then
    local maxNum = self:GetFireworkMaxNum(isLowGearQuality)
    return maxNum <= (self.curFireworkNumInScene or 0)
  end
  return false
end

return LWFireworkManager
