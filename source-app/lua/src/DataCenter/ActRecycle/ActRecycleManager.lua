local ActRecycleManager = BaseClass("ActRecycleManager")
local ActivityCycleTemplate = require("DataCenter/ActRecycle/ActivityCycleTemplate")
local ActivityCycleShopTemplate = require("DataCenter/ActRecycle/ActivityCycleShopTemplate")
local ActRecycleData = require("DataCenter.ActRecycle.ActRecycleData")
local ActRecycleMultiDrawKey = "act_recycle_multi_draw"
local ActRecycleSkipAnimKey = "act_recycle_skip_anim"

function ActRecycleManager:__init()
  self.activityCycleTemplateDict = {}
  self.activityCycleShopTemplateDict = {}
  self.dataDict = {}
end

function ActRecycleManager:__delete()
  self.activityCycleTemplateDict = nil
  self.activityCycleShopTemplateDict = nil
  self.dataDict = nil
end

function ActRecycleManager:GetData(activityId)
  local id = tostring(activityId)
  if id == nil then
    return nil
  end
  return self.dataDict[id]
end

function ActRecycleManager:UpdateData(activityId, data)
  local id = tostring(activityId)
  if id == nil then
    return
  end
  if self.dataDict[id] == nil then
    self.dataDict[id] = ActRecycleData.New()
  end
  self.dataDict[id]:UpdateData(data, activityId)
end

function ActRecycleManager:GetActivityCycleTemplateById(id)
  if self.activityCycleTemplateDict[id] == nil then
    local rowData = LocalController:instance():getLine(TableName.ACTIVITY_CYCLE, id)
    if rowData ~= nil then
      local template = ActivityCycleTemplate.New()
      template:UpdateData(rowData)
      self.activityCycleTemplateDict[id] = template
    end
  end
  return self.activityCycleTemplateDict[id]
end

function ActRecycleManager:GetActivityCycleShopTemplateById(id)
  if self.activityCycleShopTemplateDict[id] == nil then
    local rowData = LocalController:instance():getLine(TableName.ACTIVITY_CYCLE_SHOP, id)
    if rowData ~= nil then
      local template = ActivityCycleShopTemplate.New()
      template:UpdateData(rowData)
      self.activityCycleShopTemplateDict[id] = template
    end
  end
  return self.activityCycleShopTemplateDict[id]
end

function ActRecycleManager:SendExchangeShopConsume(activityId, shopId, num)
  SFSNetwork.SendMessage(MsgDefines.RecycleConsume, activityId, shopId, num)
end

function ActRecycleManager:SendExchangeShopBuy(activityId, shopId, num)
  SFSNetwork.SendMessage(MsgDefines.RecycleBuy, activityId, shopId, num)
end

function ActRecycleManager:OnExchangeShopSuccess(msg)
  if msg == nil or table.IsNullOrEmpty(msg.reward) then
    return
  end
  DataCenter.RewardManager:AddRewardsAndRes(msg)
  DataCenter.RewardManager:ShowCommonReward(msg, nil, nil, nil, nil, nil, function()
    EventManager:GetInstance():Broadcast(EventId.ActRecycleExchangeRefreshProgressMsg)
  end)
  if msg.activityId then
    local actData = self:GetData(msg.activityId)
    if actData then
      actData:UpdateShopBuyTimes(msg.id, msg.curNum)
      actData:TryUpdateDailyLimit(msg)
      actData:TryUpdateTotalBoxItemGetCount(msg)
    end
  end
  EventManager:GetInstance():Broadcast(EventId.RefreshCommonExchangeShopPanel)
  EventManager:GetInstance():Broadcast(EventId.ActRecycleExchangeSuccessMsg)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

function ActRecycleManager:IsLotteryItemEnough(activityId, num)
  local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(activityId)
  if activityInfo ~= nil then
    local mainTemplate = DataCenter.ActRecycleManager:GetActivityCycleTemplateById(activityInfo.subType)
    if mainTemplate ~= nil then
      local cost = mainTemplate:GetCostData()
      if cost ~= nil then
        local haveNum = DataCenter.ItemData:GetItemCount(cost.itemId)
        local costNum = num * cost.num
        return haveNum >= costNum
      end
    end
  end
  return false
end

function ActRecycleManager:SendLottery(activityId, num)
  SFSNetwork.SendMessage(MsgDefines.RecycleLottery, tonumber(activityId), num)
end

function ActRecycleManager:OnLotterySuccess(msg)
  if msg == nil then
    return
  end
  DataCenter.RewardManager:AddRewardsAndRes(msg)
  EventManager:GetInstance():Broadcast(EventId.ActRecycleLotterySuccessMsg, msg)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

function ActRecycleManager:IsMultiDrawOn()
  return CS.GameEntry.Setting:GetBool(ActRecycleMultiDrawKey .. LuaEntry.Player.uid, false)
end

function ActRecycleManager:SetMultiDrawOn(on)
  CS.GameEntry.Setting:SetBool(ActRecycleMultiDrawKey .. LuaEntry.Player.uid, on)
end

function ActRecycleManager:IsSkipLotteryAnim()
  return CS.GameEntry.Setting:GetBool(ActRecycleSkipAnimKey .. LuaEntry.Player.uid, false)
end

function ActRecycleManager:SetSkipLotteryAnim(on)
  CS.GameEntry.Setting:SetBool(ActRecycleSkipAnimKey .. LuaEntry.Player.uid, on)
end

function ActRecycleManager:PrintRealErrorLog(msg)
  Logger.LogError(string.format("ActRecycle Error Log: [%s]", tostring(msg)))
end

function ActRecycleManager:GetLotteryRedCount(activityId)
  local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(activityId)
  if activityInfo == nil then
    return 0
  end
  local mainTemplate = DataCenter.ActRecycleManager:GetActivityCycleTemplateById(activityInfo.subType)
  if mainTemplate == nil then
    return 0
  end
  local cost = mainTemplate:GetCostData()
  if cost == nil then
    return 0
  end
  local haveNum = DataCenter.ItemData:GetItemCount(cost.itemId)
  local costNum = 1 * cost.num
  local isEnough = haveNum >= costNum
  if isEnough then
    return 1
  else
    return 0
  end
end

function ActRecycleManager:GetExchangeShopRedCount(activityId)
  local actData = self:GetData(activityId)
  if actData == nil then
    return 0
  end
  return actData:GetExchangeShopRed()
end

function ActRecycleManager:GetTotalRedCount(activityId)
  local res = 0
  res = res + self:GetLotteryRedCount(activityId)
  res = res + self:GetExchangeShopRedCount(activityId)
  return res
end

function ActRecycleManager:Get2025ChristmasLotteryAnimBoxIcon(quality, isOpen)
  if isOpen then
    if quality == 1 then
      return "Assets/Main/TextureEx/LWUIActRecycle/2025christmas/Tex_wsh_2025Christmas_train_boxopen_green.png"
    end
    if quality == 2 then
      return "Assets/Main/TextureEx/LWUIActRecycle/2025christmas/Tex_wsh_2025Christmas_train_boxopen_blue.png"
    end
    if quality == 3 then
      return "Assets/Main/TextureEx/LWUIActRecycle/2025christmas/Tex_wsh_2025Christmas_train_boxopen_purple.png"
    end
    if quality == 4 then
      return "Assets/Main/TextureEx/LWUIActRecycle/2025christmas/Tex_wsh_2025Christmas_train_boxopen_gold.png"
    end
  else
    if quality == 1 then
      return "Assets/Main/TextureEx/LWUIActRecycle/2025christmas/Tex_wsh_2025Christmas_train_box_green.png"
    end
    if quality == 2 then
      return "Assets/Main/TextureEx/LWUIActRecycle/2025christmas/Tex_wsh_2025Christmas_train_box_blue.png"
    end
    if quality == 3 then
      return "Assets/Main/TextureEx/LWUIActRecycle/2025christmas/Tex_wsh_2025Christmas_train_box_purple.png"
    end
    if quality == 4 then
      return "Assets/Main/TextureEx/LWUIActRecycle/2025christmas/Tex_wsh_2025Christmas_train_box_gold.png"
    end
  end
  return ""
end

return ActRecycleManager
