local ActivityRebateNewManager = BaseClass("ActivityRebateNewManager")
local DigActivityData = require("DataCenter/ActivityListData/ActivityTreasureHuntNewData")
local DigActivityTemplate = require("DataCenter/ActivityListData/ActivityTreasureHuntNewTemplate")
local DigActivityParamTemplate = require("DataCenter/ActivityListData/ActivityTreasureHuntNewParamTemplate")
local Localization = CS.GameEntry.Localization
ActivityRebateNewManager.PackageClass = {
  One = 1,
  Two = 2,
  Three = 3,
  Four = 4,
  Five = 5
}

function ActivityRebateNewManager:__init()
  self.activityInfoDict = {}
  self.activityTemplateDict = nil
  self.buyClassCache = 0
  self.buyPackageIdList = {}
  EventManager:GetInstance():AddListener(EventId.OnPassDay, self.OnPassDay)
end

function ActivityRebateNewManager:__delete()
  self.activityTemplateDict = nil
  self.buyClassCache = nil
  self.buyPackageIdList = nil
  EventManager:GetInstance():RemoveListener(EventId.OnPassDay, self.OnPassDay)
end

function ActivityRebateNewManager:OnGetInfo(message)
  if not message then
    return
  end
  local activityId = message.id or ""
  activityId = tostring(activityId)
  if self.userDataDict == nil then
    self.userDataDict = {}
  end
  self.userDataDict[activityId] = message
  EventManager:GetInstance():Broadcast(EventId.ActivityRebateNewReceiveInfoSuccess)
end

function ActivityRebateNewManager:GetUserInfo(activityId)
  if self.userDataDict ~= nil then
    return self.userDataDict[tostring(activityId)]
  end
end

function ActivityRebateNewManager:InitActivityTemplate()
  if self.activityTemplateDict == nil then
    self.activityTemplateDict = {}
    LocalController:instance():visitTable(TableName.Activity_Rebate, function(id, lineData)
    end)
  end
end

function ActivityRebateNewManager:GetTotalRedCount(activityId)
  return self:GetShopRedCount(activityId)
end

function ActivityRebateNewManager:GetShopRedCount(activityId)
  local redNum = 0
  if self:IsShopRedOn() then
    local shopData = self:GetShopData(activityId)
    if not table.IsNullOrEmpty(shopData) then
      for _, v in pairs(shopData) do
        local costNum = checknumber(v.costNum)
        local costId = checknumber(v.costId)
        local curNum = DataCenter.ItemData:GetItemCount(costId)
        if costNum <= curNum then
          local limit = checknumber(v.buyTimeLimit)
          if limit == -1 then
            redNum = redNum + 1
            break
          else
            local leftTime = limit - checknumber(v.butTimes)
            if 0 < leftTime then
              redNum = redNum + 1
              break
            end
          end
        end
      end
    end
  end
  return redNum
end

function ActivityRebateNewManager:GetDefaultSelectClass(activityId)
  local giftData = self:GetGiftData(activityId)
  for k, v in ipairs(giftData) do
    local giftId = v.exchangeId
    local pack = GiftPackageData.get(tostring(giftId))
    if pack and pack:canGet() and pack:isTimeValid() then
      return k
    end
  end
  return self.PackageClass.One
end

function ActivityRebateNewManager:GetGiftData(activityId)
  local res = {}
  local activityDetailData = self:GetUserInfo(activityId)
  if activityDetailData ~= nil and not table.IsNullOrEmpty(activityDetailData.exchangeAndRewards) then
    for i, v in pairs(activityDetailData.exchangeAndRewards) do
      table.insert(res, v)
    end
    table.sort(res, function(a, b)
      return a.index < b.index
    end)
  end
  return res
end

function ActivityRebateNewManager:GetGiftDataByClass(activityId, class)
  local giftData = self:GetGiftData(activityId)
  for i, v in ipairs(giftData) do
    if i == class then
      return v
    end
  end
end

function ActivityRebateNewManager:GetProgressData(activityId)
  local res = {}
  local activityData = DataCenter.ActivityListDataManager:GetActivityDataById(activityId)
  if activityData ~= nil and activityData.para_5 ~= nil then
    local data = tostring(activityData.para_5)
    if not string.IsNullOrEmpty(data) then
      local strList = string.split(data, "|")
      if not table.IsNullOrEmpty(strList) then
        for i, v in ipairs(strList) do
          local info = string.split(v, ";")
          if #info == 2 then
            local boxData = {
              index = i,
              score = checknumber(info[1]),
              rewardId = checknumber(info[2])
            }
            table.insert(res, boxData)
          end
        end
      end
    end
  end
  return res
end

function ActivityRebateNewManager:GetCurrentProgressScore(activityId)
  local userData = self:GetUserInfo(activityId)
  if userData ~= nil and userData.totalScore ~= nil then
    return checknumber(userData.totalScore)
  end
  return 0
end

function ActivityRebateNewManager:GetProgressBoxState(index, activityId)
  local progressData = self:GetProgressData(activityId)
  if progressData[index] ~= nil then
    local curScore = self:GetCurrentProgressScore(activityId)
    if curScore < progressData[index].score then
      return 0
    end
    local userData = self:GetUserInfo(activityId)
    if userData ~= nil and userData.boxReceive ~= nil then
      local realIndex = index - 1
      for i, v in pairs(userData.boxReceive) do
        if checknumber(v) == realIndex then
          return 2
        end
      end
      return 1
    end
  end
  return 0
end

function ActivityRebateNewManager:GetProgressBoxRewardData(rewardId)
  local res = {}
  local rewardConfig = LocalController:instance():getLine(TableName.RewardConfig, tonumber(rewardId))
  if rewardConfig ~= nil then
    local itemValues = rewardConfig:getValue("item") or ""
    local numValues = rewardConfig:getValue("num") or ""
    if not string.IsNullOrEmpty(itemValues) and not string.IsNullOrEmpty(numValues) then
      local ids = string.split(itemValues, "|")
      local nums = string.split(numValues, "|")
      if ids ~= nil and 0 < #ids then
        for i, id in pairs(ids) do
          local oneData = {}
          oneData.itemId = id
          oneData.count = nums[i] or 0
          oneData.rewardType = RewardType.GOODS
          table.insert(res, oneData)
        end
      end
    end
  end
  return res
end

function ActivityRebateNewManager:OnReceiveInfo(message)
  if message == nil or self.userDataDict == nil then
    return
  end
  local activityId = message.activityId or ""
  if self.userDataDict[tostring(activityId)] == nil then
    return
  end
  self.userDataDict[tostring(activityId)].totalScore = message.totalScore or 0
  EventManager:GetInstance():Broadcast(EventId.ActivityRebateNewReceiveProgressInfoSuccess)
end

function ActivityRebateNewManager:SendClaimProgress(index, activityId)
  SFSNetwork.SendMessage(MsgDefines.ActivityRebateNewClaimProgress, {activityId = activityId, index = index})
end

function ActivityRebateNewManager:OnClaimProgress(msg)
  if msg == nil or table.IsNullOrEmpty(msg.reward) then
    return
  end
  DataCenter.RewardManager:AddRewardsAndRes(msg)
  DataCenter.RewardManager:ShowCommonReward(msg)
  if msg.activityId ~= nil then
    SFSNetwork.SendMessage(MsgDefines.ActivityEventInfoGet, tostring(msg.activityId))
  end
end

function ActivityRebateNewManager:IsShopRedOn()
  return false
end

function ActivityRebateNewManager:SetShopRedOn(value)
  CS.GameEntry.Setting:SetBool("activity_rebate_new_shop_red_" .. LuaEntry.Player.uid, value)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

function ActivityRebateNewManager:GetShopData(activityId)
  local userData = self:GetUserInfo(activityId)
  if userData ~= nil and userData.shopArr ~= nil then
    return userData.shopArr
  end
end

function ActivityRebateNewManager:GetShopGoodsId(activityId)
  local activityData = DataCenter.ActivityListDataManager:GetActivityDataById(activityId)
  if activityData ~= nil then
    return checknumber(activityData.para_2)
  end
  return 0
end

function ActivityRebateNewManager:SendBuyShopItem(activityId, shopId, num)
  SFSNetwork.SendMessage(MsgDefines.ActivityRebateNewBuyShopItem, {
    activityId = activityId,
    shopId = tostring(shopId),
    num = num
  })
end

function ActivityRebateNewManager:OnBuyShopItemSuccess(msg)
  if msg == nil or table.IsNullOrEmpty(msg.reward) then
    return
  end
  DataCenter.RewardManager:AddRewardsAndRes(msg)
  DataCenter.RewardManager:ShowCommonReward(msg)
  if msg.activityId ~= nil then
    SFSNetwork.SendMessage(MsgDefines.ActivityEventInfoGet, tostring(msg.activityId))
  end
end

function ActivityRebateNewManager:BuyGift(info, activityId)
  self.buyClassCache = 0
  local giftData = self:GetGiftData(activityId)
  for i, v in ipairs(giftData) do
    local pack = GiftPackageData.get(tostring(v.exchangeId))
    if pack ~= nil and pack:getID() == info:getID() then
      self.buyClassCache = i
    end
  end
  if self.buyPackageIdList == nil then
    self.buyPackageIdList = {}
  end
  table.insert(self.buyPackageIdList, info:getID())
  DataCenter.PayManager:CallPayment(info)
end

function ActivityRebateNewManager:GetBuyClassCache()
  return self.buyClassCache
end

function ActivityRebateNewManager:IsRebateNewActivityPackage(exchangeId)
  local result = false
  if self.buyPackageIdList ~= nil then
    for i, v in pairs(self.buyPackageIdList) do
      if v == exchangeId then
        result = true
        break
      end
    end
  end
  if result then
    local activityId = self:GetActivityIdByExchangeId(exchangeId)
    if string.IsNullOrEmpty(activityId) then
      result = false
    end
  end
  return result
end

function ActivityRebateNewManager:GetActivityIdByExchangeId(exchangeId)
  local actList = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.ActivityRebateNew.Type)
  if not table.IsNullOrEmpty(actList) then
    for _, v in pairs(actList) do
      local activityData = v
      if activityData.para_4 ~= nil then
        local exchangeIdList = string.split(tostring(activityData.para_4), "|")
        if not table.IsNullOrEmpty(exchangeIdList) then
          for _, id in pairs(exchangeIdList) do
            if tostring(exchangeId) == id then
              return activityData.id
            end
          end
        end
      end
    end
  end
  return ""
end

function ActivityRebateNewManager:ShowGiftReward(message)
  local function IsCostItem(itemId, activityId)
    local activityData = DataCenter.ActivityListDataManager:GetActivityDataById(activityId)
    
    if activityData ~= nil and activityData.para_2 ~= nil and tostring(itemId) == tostring(activityData.para_2) then
      return true
    end
    return false
  end
  
  if message == nil then
    return
  end
  local exchangeId = message.itemId or ""
  local activityId = self:GetActivityIdByExchangeId(exchangeId)
  if string.IsNullOrEmpty(activityId) then
    return
  end
  local normalRewards = {}
  local luckyRewards = {}
  if message.gold ~= nil then
    local tempParam = {}
    tempParam.rewardType = RewardType.GOLD
    tempParam.itemId = ""
    tempParam.count = tonumber(message.goldAdd)
    table.insert(normalRewards, tempParam)
  end
  if message.reward ~= nil then
    local origin = message.reward
    local newList = {}
    for i = table.count(origin), 1, -1 do
      newList[#newList + 1] = origin[i]
    end
    local rewards = DataCenter.RewardManager:ReturnRewardParamForMessage(newList)
    if not table.IsNullOrEmpty(rewards) then
      for i, v in pairs(rewards) do
        local itemId = v.itemId or ""
        if IsCostItem(itemId, activityId) then
          table.insert(normalRewards, v)
        else
          table.insert(luckyRewards, v)
        end
      end
    end
  end
  local param = {
    activityId = activityId,
    normalRewards = normalRewards,
    luckyRewards = luckyRewards
  }
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityRebateNewPackageReward, {
    anim = true,
    playEffect = false,
    UIMainAnim = UIMainAnimType.LeftRightBottomHide
  }, param)
end

function ActivityRebateNewManager:GetCurActivityId()
  if self.userDataDict ~= nil then
    for i, v in pairs(self.userDataDict) do
      return tostring(i)
    end
  end
  return nil
end

function ActivityRebateNewManager:OnPassDay()
  local activityId = DataCenter.ActivityRebateNewManager:GetCurActivityId()
  if not string.IsNullOrEmpty(activityId) then
    SFSNetwork.SendMessage(MsgDefines.ActivityEventInfoGet, activityId)
  end
end

function ActivityRebateNewManager:GetPackageIconByClass(class)
  if class == self.PackageClass.One then
    return "Assets/Main/Sprites/UI/UIActivityRebateNew/FX_quanmianbeizhan_icon_duihuanjuan01.png"
  end
  if class == self.PackageClass.Two then
    return "Assets/Main/Sprites/UI/UIActivityRebateNew/FX_quanmianbeizhan_icon_duihuanjuan02.png"
  end
  if class == self.PackageClass.Three then
    return "Assets/Main/Sprites/UI/UIActivityRebateNew/FX_quanmianbeizhan_icon_duihuanjuan03.png"
  end
  if class == self.PackageClass.Four then
    return "Assets/Main/Sprites/UI/UIActivityRebateNew/FX_quanmianbeizhan_icon_duihuanjuan04.png"
  end
  if class == self.PackageClass.Five then
    return "Assets/Main/Sprites/UI/UIActivityRebateNew/FX_quanmianbeizhan_icon_duihuanjuan05.png"
  end
  return ""
end

return ActivityRebateNewManager
