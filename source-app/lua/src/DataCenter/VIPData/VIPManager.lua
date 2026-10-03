local VIPManager = BaseClass("VIPManager", CEventable)
local VIPDataInfo = require("DataCenter.VIPData.VIPDataInfo")

function VIPManager:__init()
  self.vipinfo = nil
  self._dailyPointConfig = {}
  self._vipPointGoodConfig = {}
  self.vipTipRecored = {}
  self.displayingTipType = nil
  self:RegisterEvent(EventId.OnEnterVipPanel, self.OnEnterVipPanel)
  self:RegisterEvent(EventId.OnEnterVipShopPanel, self.OnEnterVipShop)
  self:RegisterEvent(EventId.VipEndTimeChange, self.OnVipEndTimeChanged)
  self:RegisterEvent(EventId.OnPassDay, self.OnPassDay)
  self.vipReqSourceDic = {}
end

function VIPManager:__delete()
  self.vipinfo = nil
  self._dailyPointConfig = nil
  self._vipPointGoodConfig = nil
  self._requestRewardInfo = false
  self.vipReqSourceDic = nil
end

function VIPManager:InitData(message)
  if message.vip ~= nil then
    local tempData = VIPDataInfo.New()
    tempData:UpdateVipInfo(message.vip)
    self.vipinfo = tempData
    self._requestRewardInfo = true
    DataCenter.VIPTemplateManager:InitAllTemplate()
  end
end

function VIPManager:RequestRewardInfo()
  if self._requestRewardInfo == true then
    SFSNetwork.SendMessage(MsgDefines.VipGetRewardInfo)
    self._requestRewardInfo = false
  end
end

function VIPManager:UpdateVipInfo(message, isLoginScore)
  if message ~= nil then
    if self.vipinfo == nil then
      self.vipinfo = VIPDataInfo.New()
    end
    self.vipinfo:UpdateVip(message, isLoginScore)
  end
end

function VIPManager:UpdateVipBoxRewardInfo(message)
  if self.vipinfo == nil then
    return
  end
  self.vipinfo:UpdateVipBoxRewardInfo(message)
end

function VIPManager:GetVipData()
  if self.vipinfo then
    return self.vipinfo
  end
  return nil
end

function VIPManager:RequestLatestVipInfo()
  SFSNetwork.SendMessage(MsgDefines.VipInfo)
end

function VIPManager:RequestVipGetDailyPoint()
  SFSNetwork.SendMessage(MsgDefines.VipAddLoginScore)
end

function VIPManager:ReceiveFreeReward()
  SFSNetwork.SendMessage(MsgDefines.VipGetEveryDayReward)
end

function VIPManager:GetEveryDayRewardMessageHandle(message)
  if message.vipInfo ~= nil then
    self:UpdateVipInfo(message.vipInfo)
  end
  if message.reward ~= nil then
    DataCenter.RewardManager:ShowCommonReward(message)
    DataCenter.RewardManager:AddRewardsAndRes(message)
  end
  EventManager:GetInstance():Broadcast(EventId.VipRefreshFree)
end

function VIPManager:ReceivePrivilegeReward(level)
  SFSNetwork.SendMessage(MsgDefines.VipAddLoginScore, level)
end

function VIPManager:TodayPoint()
  if self.vipinfo == nil then
    return 0
  end
  return self:GetDailyPointNum(self.vipinfo:GetLoginDays())
end

function VIPManager:TomorrowPoint()
  if self.vipinfo == nil then
    return 0
  end
  return self:GetDailyPointNum(self.vipinfo:GetLoginDays() + 1)
end

function VIPManager:GetDailyPointNum(loginDays)
  local k1 = LuaEntry.DataConfig:TryGetStr("vip_aps", "k1")
  local dailyPointConfig = string.split(k1, ";")
  if dailyPointConfig == nil or #dailyPointConfig < 1 then
    return 0
  end
  if loginDays >= #dailyPointConfig then
    return dailyPointConfig[#dailyPointConfig]
  end
  if loginDays < 0 then
    return 0
  end
  return dailyPointConfig[loginDays]
end

function VIPManager:GetPointGoodList()
  local k2 = LuaEntry.DataConfig:TryGetStr("vip_aps", "k2")
  local vipPointGoodConfig = string.split(k2, ";")
  return vipPointGoodConfig
end

function VIPManager:GetRenewGoodList()
  local k3 = LuaEntry.DataConfig:TryGetStr("vip_aps", "k3")
  local vipRenewGoodConfig = string.split(k3, "|")
  return vipRenewGoodConfig
end

function VIPManager:CanGetDailyPoint()
  if self.vipinfo then
    return self.vipinfo:CanGetDailyPoint()
  end
  return false
end

function VIPManager:FreeGoodCanGet(level)
  if self.vipinfo == nil then
    return false
  end
  return level == self.vipinfo.level and self.vipinfo:CanGetDailyFreeReward()
end

function VIPManager:UpdateVipPoint(vipPoint)
  if self.vipinfo == nil then
    return
  end
  self.vipinfo:UpdateVipPoint(vipPoint)
end

function VIPManager:GetVipTemplate(level)
  local vipData = DataCenter.VIPTemplateManager:GetTemplate(level)
  return vipData
end

function VIPManager:GetCurVipData()
  if self.vipinfo == nil then
    return nil
  end
  return self:GetVipTemplate(self.vipinfo.level)
end

function VIPManager:GetNextVipData()
  if self.vipinfo == nil then
    return nil
  end
  local nextLevel = self.vipinfo.level + 1
  if nextLevel > DataCenter.VIPTemplateManager.maxLevel then
    nextLevel = DataCenter.VIPTemplateManager.maxLevel
  end
  return self:GetVipTemplate(nextLevel)
end

function VIPManager:GetVipDatas()
  local vipData = DataCenter.VIPTemplateManager:GetAllTemplate()
  return vipData
end

function VIPManager:IsVipPointItem(id)
  local vipConfig = self:GetPointGoodList()
  if vipConfig and next(vipConfig) then
    for i = 1, #vipConfig do
      if id == tonumber(vipConfig[i]) then
        return true
      end
    end
  end
  return false
end

function VIPManager:IsVipPack(Id)
  local vipdata = self:GetVipDatas()
  if vipdata and next(vipdata) then
    for i = 1, #vipdata do
      if tonumber(vipdata[i].reward2) == tonumber(Id) then
        return true
      end
    end
  end
  return false
end

function VIPManager:OnVipPackPurchase(id)
  self:RequestLatestVipInfo()
  pcall(function()
    DataCenter.VIPManager:VipReqSourceRecord(VipRequestSource.PackPurchase)
  end)
end

function VIPManager:AnalyzePayGoodState(level, reward2)
  if self.vipinfo == nil then
    return VipPayGoodState.Lock
  end
  local state = self.vipinfo:GetPrivilegeRewardState(level)
  if state == -1 then
    return VipPayGoodState.Lock
  end
  if state == 0 then
    local hasBought = GiftPackageData.hasBought(tostring(reward2))
    return hasBought and VipPayGoodState.HasGet or VipPayGoodState.CanBuy
  end
  if state == 1 then
    return VipPayGoodState.HasGet
  end
end

function VIPManager:CheckOpen()
  local configOpenState = LuaEntry.DataConfig:CheckSwitch("vip_xitong")
  return configOpenState
end

function VIPManager:GetRedNum()
  if not self.vipinfo then
    return 0
  end
  local num = 0
  local tipNum = 0
  if self:CanGetDailyPoint() then
    tipNum = tipNum + 1
  end
  if next(self.vipinfo) and self:FreeGoodCanGet(self.vipinfo.level) then
    num = num + 1
  end
  local isV18Red = DataCenter.VipExtendManager:IsRed()
  if isV18Red then
    num = num + 1
  end
  local isVip18ContactRed = DataCenter.VipExtendManager:IsVip18ContactRed()
  if isVip18ContactRed then
    num = num + 1
  end
  return num + tipNum, num, tipNum
end

function VIPManager:CheckVipLvOpen()
  local mgr = DataCenter.LWFunctionUnlockManager
  local unlock = mgr:CheckCanShow(LWFunctionUnlockType.MainUI_VIP)
  return unlock
end

function VIPManager:GetPackVipLv(packId)
  for _, data in pairs(self:GetVipDatas()) do
    if tonumber(packId) == data.reward2 then
      return data.level
    end
  end
  return -1
end

function VIPManager:GetVipTipRecord(id)
  return self.vipTipRecored[id]
end

function VIPManager:SetVipTipRecord(id)
  self.vipTipRecored[id] = true
end

function VIPManager:UnsetVipTipRecord(id)
  self.vipTipRecored[id] = nil
end

function VIPManager:OnEnterVipPanel()
  if self.displayingTipType == VipTipType.Expired then
    self:SetVipTipRecord(VipTipType.Expired)
    EventManager:GetInstance():Broadcast(EventId.RefreshVipTip)
  elseif self.displayingTipType == VipTipType.ExpireSoon then
    self:SetVipTipRecord(VipTipType.ExpireSoon)
    EventManager:GetInstance():Broadcast(EventId.RefreshVipTip)
  end
end

function VIPManager:OnEnterVipShop()
  if self.displayingTipType == VipTipType.ShopRefreshed then
    local curTime = UITimeManager:GetInstance():GetServerSeconds()
    Setting:SetString(SettingKeys.LAST_TIME_SHOW_VIP_SHOP_REFRESH, tostring(curTime))
    EventManager:GetInstance():Broadcast(EventId.RefreshVipTip)
  end
end

function VIPManager:SetDisplayingTipType(tipType)
  self.displayingTipType = tipType
end

function VIPManager:GetDisplayingTipType()
  return self.displayingTipType
end

function VIPManager:ClearDisplayingTipType()
  self.displayingTipType = nil
end

function VIPManager:OnVipEndTimeChanged()
  self:UnsetVipTipRecord(VipTipType.Expired)
  self:UnsetVipTipRecord(VipTipType.ExpireSoon)
end

function VIPManager:OnPassDay()
  DataCenter.DispatchRequestManager:Append(function()
    SFSNetwork.SendMessage(MsgDefines.VipInfo)
    pcall(function()
      DataCenter.VIPManager:VipReqSourceRecord(VipRequestSource.PassDay)
    end)
  end)
end

function VIPManager:GetVipRemainTime()
  local vipInfo = self:GetVipData()
  if vipInfo then
    return vipInfo:GetRemainTime()
  end
  return 0
end

function VIPManager:GetAllVipPacks()
  if not self.allVipPacks then
    self.allVipPacks = {}
    local vipdata = self:GetVipDatas()
    if vipdata and next(vipdata) then
      for i = 1, #vipdata do
        self.allVipPacks[i] = {
          level = vipdata[i].level,
          packId = vipdata[i].reward2
        }
      end
    end
  end
  return self.allVipPacks
end

function VIPManager:GetVipPackContainsItem(resourceId, goodsId, resItemId)
  if not resourceId and not goodsId and not resItemId then
    return nil
  end
  if resourceId and resourceId <= 0 and goodsId and goodsId <= 0 and resItemId and resItemId <= 0 then
    return nil
  end
  local allVipPacks = DataCenter.VIPManager:GetAllVipPacks()
  local needs = {}
  if resourceId and 0 < resourceId then
    needs[ResTypeToReward[resourceId]] = ResTypeToReward[resourceId]
  end
  if goodsId and 0 < goodsId then
    needs[RewardType.GOODS] = goodsId
  end
  if resItemId and 0 < resItemId then
    needs[RewardType.RESOURCE_ITEM] = resItemId
  end
  local giftPackId
  local vipLevel = 0
  for i = 1, #allVipPacks do
    local pack = allVipPacks[i].packId
    vipLevel = allVipPacks[i].level
    local giftPackData = GiftPackManager.get(tostring(pack))
    if giftPackData and not giftPackData:isBought() then
      local items = giftPackData:getItems(false)
      for i = 1, #items do
        local item = items[i]
        local rewardType = item.rewardType
        if rewardType and needs[rewardType] then
          local itemId = item.itemId
          if itemId == nil or itemId == needs[rewardType] then
            giftPackId = pack
            break
          end
        end
      end
      if giftPackId then
        break
      end
    end
  end
  return giftPackId, vipLevel
end

function VIPManager:GetLeastUnboughtVipPack()
  local allVipPacks = DataCenter.VIPManager:GetAllVipPacks()
  local giftPackId
  local vipLevel = 0
  for i = 1, #allVipPacks do
    local pack = allVipPacks[i].packId
    vipLevel = allVipPacks[i].level
    local giftPackData = GiftPackManager.get(tostring(pack))
    if giftPackData and not giftPackData:isBought() then
      giftPackId = pack
      break
    end
  end
  return giftPackId, vipLevel
end

function VIPManager:VipReqSourceRecord(sourId)
  local param = self.vipReqSourceDic[sourId]
  if not param then
    param = {}
    param.count = 0
    param.time = Time.time
  end
  if Time.time - param.time >= 1 then
    param.count = 0
  end
  param.count = param.count + 1
  param.time = Time.time
  if param.count > 500 then
    Logger.LogError("[VipInfo] req times is too many!!!!   sourId:" .. sourId .. "  count:" .. param.count)
    param.count = 0
  end
  self.vipReqSourceDic[sourId] = param
end

return VIPManager
