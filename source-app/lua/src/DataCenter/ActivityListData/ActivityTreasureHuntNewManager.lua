local ActivityTreasureHuntNewManager = BaseClass("ActivityTreasureHuntNewManager")
local DigActivityData = require("DataCenter/ActivityListData/ActivityTreasureHuntNewData")
local DigActivityTemplate = require("DataCenter/ActivityListData/ActivityTreasureHuntNewTemplate")
local DigActivityParamTemplate = require("DataCenter/ActivityListData/ActivityTreasureHuntNewParamTemplate")
local Localization = CS.GameEntry.Localization

function ActivityTreasureHuntNewManager:__init()
  self.digInfoDic = {}
  self.digTemplateDic = {}
  self.digParamTemplateDic = {}
  self.cacheBuyPickaxeCount = 0
  self.isDigOneBlock = false
  self.isBatchDigRequesting = false
  self:AddListener()
end

function ActivityTreasureHuntNewManager:__delete()
  self.digTemplateDic = nil
  self.digInfoDic = nil
  self.digParamTemplateDic = {}
  self.cacheBuyPickaxeCount = nil
  self.isDigOneBlock = nil
  self.isBatchDigRequesting = nil
  self:RemoveListener()
end

function ActivityTreasureHuntNewManager:AddListener()
end

function ActivityTreasureHuntNewManager:RemoveListener()
end

function ActivityTreasureHuntNewManager:UpdateDigInfo(msg)
  if not msg or not msg.activityId then
    return
  end
  local tempActId = msg.activityId
  if not self.digInfoDic[tempActId] then
    local newDigInfo = DigActivityData.New()
    newDigInfo:ParseData(msg)
    self.digInfoDic[tempActId] = newDigInfo
  else
    self.digInfoDic[tempActId]:ParseData(msg)
  end
  EventManager:GetInstance():Broadcast(EventId.ActivityTreasureHuntNewActivityInfoUpdated)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

function ActivityTreasureHuntNewManager:OnRecvDigRecommendSelect(msg)
  if not msg or not msg.activityId then
    return
  end
  local tempActId = msg.activityId
  if self.digInfoDic[tempActId] then
    self.digInfoDic[tempActId].recommend = msg.recommend
  end
end

function ActivityTreasureHuntNewManager:RequestDigInfo(activityId)
  SFSNetwork.SendMessage(MsgDefines.ActivityTreasureHuntNewGetInfo, activityId)
end

function ActivityTreasureHuntNewManager:OnRecvDigInfo(msg)
  self:UpdateDigInfo(msg)
end

function ActivityTreasureHuntNewManager:ResetIsDigOneBlock()
  self.isDigOneBlock = false
end

function ActivityTreasureHuntNewManager:RequestDigOneBlock(activityId, digIndex)
  if self.isDigOneBlock == true then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.ActivityTreasureHuntNewDigOneBlock, activityId, digIndex)
  self.isDigOneBlock = true
end

function ActivityTreasureHuntNewManager:OnRecvDigResult(msg)
  if not msg then
    return
  end
  DataCenter.RewardManager:AddRewardsAndRes(msg)
  if self.digInfoDic[msg.activityId] then
    local digInfo = self.digInfoDic[msg.activityId]
    if msg.goodsIndex and msg.goodsIndex == 0 then
      self.cacheFinalRewardMsg = msg
    end
    if msg.consume_num then
      digInfo.consume_num = msg.consume_num
    end
    local digResult = digInfo:AddOneDigRecord({
      digIndex = msg.digIndex,
      goodsIndex = msg.goodsIndex
    })
    EventManager:GetInstance():Broadcast(EventId.ActivityTreasureHuntNewDigOneBlockSuccess, digResult)
    local reward = msg.reward
    digInfo:AddToCanClaimReward(reward)
  end
end

function ActivityTreasureHuntNewManager:ShowGetFinalReward(self)
  DataCenter.RewardManager:ShowCommonReward(self.cacheFinalRewardMsg)
end

function ActivityTreasureHuntNewManager:RequestAutoDig(activityId)
  SFSNetwork.SendMessage(MsgDefines.ActivityTreasureHuntNewStartAutoDig, activityId)
end

function ActivityTreasureHuntNewManager:OnRecvAutoDigResult(self, msg)
  if not msg then
    return
  end
  DataCenter.RewardManager:AddRewardsAndRes(msg)
  local digInfo = self.digInfoDic[msg.activityId]
  if not digInfo then
    return
  end
  local resultList = {}
  for i, v in ipairs(msg.digArr) do
    local oneResult = digInfo:AddOneDigRecord(v)
    table.insert(resultList, oneResult)
  end
  table.sort(resultList, function(a, b)
    if a.rewardIndex ~= b.rewardIndex then
      return b.rewardIndex == 0
    else
      return false
    end
  end)
  EventManager:GetInstance():Broadcast(EventId.ActivityTreasureHuntNewGetAutoDigResult, resultList)
end

function ActivityTreasureHuntNewManager:RequestSelectFinalReward(activityId, rewardIndex)
  SFSNetwork.SendMessage(MsgDefines.ActivityTreasureHuntNewSelectFinalDigReward, activityId, rewardIndex)
end

function ActivityTreasureHuntNewManager:OnRecvSelectFinalRewardSucc(msg)
  if not msg then
    return
  end
  if not self.digInfoDic[msg.activityId] then
    return
  end
  self.digInfoDic[msg.activityId]:UpdateSuperReward(msg.bigRewardIndex)
  EventManager:GetInstance():Broadcast(EventId.ActivityTreasureHuntNewFinalResultUpdated)
end

function ActivityTreasureHuntNewManager:RequestBuyOneItem(activityId, count)
  SFSNetwork.SendMessage(MsgDefines.ActivityTreasureHuntNewBuyDigTool, activityId, count)
end

function ActivityTreasureHuntNewManager:OnRecvBuyItemRet(msg)
  if not msg then
    return
  end
  DataCenter.RewardManager:AddRewardsAndRes(msg)
  if msg.activityId and self.digInfoDic[msg.activityId] then
    self.digInfoDic[msg.activityId].itemBoughtTimes = self.digInfoDic[msg.activityId].itemBoughtTimes + self.cacheBuyPickaxeCount
    self.cacheBuyPickaxeCount = 0
  end
  EventManager:GetInstance():Broadcast(EventId.OnbuyPickaxeSucc)
end

function ActivityTreasureHuntNewManager:GetDigTemplate(id)
  id = tonumber(id)
  if id == nil then
    return nil
  end
  if self.digTemplateDic[id] == nil then
    local rowData = LocalController:instance():getLine(TableName.DigActivityDig, id)
    if rowData ~= nil then
      local item = DigActivityTemplate.New()
      item:InitData(rowData)
      self.digTemplateDic[id] = item
    end
  end
  return self.digTemplateDic[id]
end

function ActivityTreasureHuntNewManager:GetDigParamTemplates(digId)
  digId = tonumber(digId)
  if digId == nil then
    return nil
  end
  if self.digParamTemplateDic[digId] == nil then
    LocalController:instance():visitTable(TableName.DigActivityPara, function(id, lineData)
      local item = DigActivityParamTemplate.New()
      item:InitData(lineData)
      if item.digId == digId then
        if not self.digParamTemplateDic[item.digId] then
          self.digParamTemplateDic[item.digId] = {}
        end
        table.insert(self.digParamTemplateDic[item.digId], item)
      end
    end)
  end
  return self.digParamTemplateDic[digId]
end

function ActivityTreasureHuntNewManager:GetProgressBoxRewardRed(activityId)
  local res = 0
  local template = DataCenter.ActivityTreasureHuntNewManager:GetDigTemplateByActivityId(activityId)
  if template ~= nil and not table.IsNullOrEmpty(template.bigRewardPreviewDict) then
    for i = 1, #template.bigRewardPreviewDict do
      local bigRewardData = template.bigRewardPreviewDict[i]
      if not table.IsNullOrEmpty(bigRewardData) then
        local state = self:GetBigRewardClaimStateByLevel(activityId, bigRewardData.level)
        if state == 1 then
          res = res + 1
        end
      end
    end
  end
  return res
end

function ActivityTreasureHuntNewManager:GetStoredRewardRed(activityId)
  local finalRewardsFirstLevel = self:GetFinalRewards(activityId, 1)
  if finalRewardsFirstLevel ~= nil then
    local curStoredRewardList = self:GetCanClaimNormalRewardList(activityId)
    if not table.IsNullOrEmpty(curStoredRewardList) then
      for _, v in pairs(curStoredRewardList) do
        if v.value ~= nil then
          for _, j in pairs(finalRewardsFirstLevel) do
            if checknumber(v.value.id) == checknumber(j.itemId) and v.value.num >= j.count then
              return 1
            end
          end
        end
      end
    end
  end
  return 0
end

function ActivityTreasureHuntNewManager:GetDigActivityRed(activityId)
  return self:GetStoredRewardRed(activityId)
end

function ActivityTreasureHuntNewManager:GetDigInfo(activityId)
  if not self.digInfoDic then
    return nil
  end
  return self.digInfoDic[activityId]
end

function ActivityTreasureHuntNewManager:GetDigTemplateByActivityId(activityId)
  local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(activityId)
  if not activityInfo then
    return nil
  end
  return self:GetDigTemplate(activityInfo.subType)
end

function ActivityTreasureHuntNewManager:GetFinalReward(activityId, level, rewardIndex)
  local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(activityId)
  local template = self:GetDigTemplate(activityInfo.subType)
  if template then
    return template:GetFinalReward(level, rewardIndex)
  else
    return nil
  end
end

function ActivityTreasureHuntNewManager:GetRewardsList(activityId, level)
  local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(activityId)
  local template = self:GetDigTemplate(activityInfo.subType)
  if template then
    local digId = template.id
    local paramTemplateList = self:GetDigParamTemplates(digId)
    if paramTemplateList then
      for i, v in ipairs(paramTemplateList) do
        if v.level == level then
          return v.rewards
        end
      end
    end
  end
  return {}
end

function ActivityTreasureHuntNewManager:GetPreviewRewardsList(activityId, level)
  local retList = {}
  local tempList = self:GetRewardsList(activityId, level)
  table.insertto(retList, tempList)
  local digInfo = self.digInfoDic[activityId]
  if digInfo and digInfo.finalRewardIndex > 0 then
    local finalReward = {}
    local reward = self:GetFinalReward(activityId, level, digInfo.finalRewardIndex)
    finalReward.itemId = reward.itemId
    finalReward.count = reward.count
    table.insert(retList, 1, finalReward)
  else
    local finalReward = {}
    finalReward.itemId = ""
    finalReward.count = 0
    table.insert(retList, 1, finalReward)
  end
  return retList
end

function ActivityTreasureHuntNewManager:GetMaxLvCount(activityId)
  local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(activityId)
  local template = self:GetDigTemplate(activityInfo.subType)
  if template then
    local digId = template.id
    local paramTemplateList = self:GetDigParamTemplates(digId)
    if paramTemplateList then
      return #paramTemplateList
    end
  end
  return 0
end

function ActivityTreasureHuntNewManager:GetDigParamTemplateDic(activityId)
  local list = {}
  local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(activityId)
  local template = self:GetDigTemplate(activityInfo.subType)
  if template then
    local digId = template.id
    local paramTemplateList = self:GetDigParamTemplates(digId)
    if paramTemplateList then
      list = paramTemplateList
    end
  end
  return list
end

function ActivityTreasureHuntNewManager:GetDiggedOutReward(activityId, level, blockIndex)
  local retInfo
  local tempInfo = self.digInfoDic[activityId]
  if tempInfo then
    local record = tempInfo.digRecordDic[blockIndex]
    if record then
      if record.rewardIndex == 0 then
        local finalReward = self:GetFinalReward(activityId, level, tempInfo.finalRewardIndex)
        retInfo = {}
        if finalReward == nil then
          Logger.LogError("dig activity final reward not exist, " .. tostring(activityId) .. "," .. tostring(level))
        else
          retInfo.itemId = finalReward.itemId
          retInfo.count = finalReward.count
        end
      else
        local rewardsList = self:GetRewardsList(activityId, level)
        if rewardsList and #rewardsList >= record.rewardIndex then
          retInfo = rewardsList[record.rewardIndex]
        end
      end
    end
  end
  return retInfo
end

function ActivityTreasureHuntNewManager:GetDiggedOutRewardIndex(activityId, level, blockIndex)
  local retIndex = -1
  local tempInfo = self.digInfoDic[activityId]
  if tempInfo then
    local record = tempInfo.digRecordDic[blockIndex]
    if record then
      retIndex = record.rewardIndex
    end
  end
  return retIndex
end

function ActivityTreasureHuntNewManager:GetSelectedFinalRewardInfo(activityId, level)
  local finalRewardIndex = 0
  local digInfo = self.digInfoDic[activityId]
  if digInfo then
    finalRewardIndex = digInfo.finalRewardIndex
  end
  local isSuperLv = self:CheckIfIsSuperLv(activityId, level)
  return finalRewardIndex, isSuperLv
end

function ActivityTreasureHuntNewManager:CheckIfIsSuperLv(activityId, level)
  local isSuperLv = false
  local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(activityId)
  local digTemplate = self:GetDigTemplate(activityInfo.subType)
  if digTemplate then
    isSuperLv = table.hasvalue(digTemplate.superLevels, level)
  end
  return isSuperLv
end

function ActivityTreasureHuntNewManager:GetFinalRewards(activityId, curLevel)
  local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(activityId)
  local template = self:GetDigTemplate(activityInfo.subType)
  if template then
    local digId = template.id
    local paramTemplateList = self:GetDigParamTemplates(digId)
    if paramTemplateList then
      for i, v in ipairs(paramTemplateList) do
        if v.level == curLevel then
          return v.big_reward, v.big_reward
        end
      end
    end
  end
end

function ActivityTreasureHuntNewManager:GetFinRewardByIndex(digId, curLevel, index)
  local res
  local paramTemplateList = self:GetDigParamTemplates(digId)
  if paramTemplateList then
    for i, v in ipairs(paramTemplateList) do
      if v.level == curLevel then
        res = v.big_reward[index]
        break
      end
    end
  end
  if res == nil then
    local a = 1
  end
  return res
end

function ActivityTreasureHuntNewManager:GetFinalRewardGotTimes(activityId, isSuperLv, rewardIndex)
  local digInfo = self.digInfoDic[activityId]
  local gotDic
  if isSuperLv then
    gotDic = digInfo.superRewardGotTimesDic
  else
    gotDic = digInfo.normalRewardGotTimesDic
  end
  if gotDic[rewardIndex] then
    return gotDic[rewardIndex].gotTimes
  else
    return 0
  end
end

function ActivityTreasureHuntNewManager:GetPickaxId(activityId)
  local digTemplate = self:GetDigTemplateByActivityId(activityId)
  if not digTemplate then
    return nil
  end
  return digTemplate.pickaxId
end

function ActivityTreasureHuntNewManager:GetPickaxCount(activityId)
  local pickaxId = self:GetPickaxId(activityId)
  return DataCenter.ItemData:GetItemCount(pickaxId) or 0
end

function ActivityTreasureHuntNewManager:GetStopLevel(activityId)
  local stopLevel = 0
  local digTemplate = self:GetDigTemplateByActivityId(activityId)
  if digTemplate then
    stopLevel = digTemplate.stop_level
  end
  return stopLevel
end

function ActivityTreasureHuntNewManager:GetPickaxePackageInfo(activityId)
  local digTemplate = self:GetDigTemplateByActivityId(activityId)
  if not digTemplate then
    return nil
  end
  local packInfo = GiftPackManager.GetFirstGiftPackByShowType(6, digTemplate.pickaxId)
  return packInfo
end

function ActivityTreasureHuntNewManager:TryBuyPickaxe(activityId)
  local digTemplate = DataCenter.ActivityTreasureHuntNewManager:GetDigTemplateByActivityId(activityId)
  local digInfo = DataCenter.ActivityTreasureHuntNewManager:GetDigInfo(activityId)
  if digTemplate.pickaxBuyMax - digInfo.itemBoughtTimes <= 0 then
    UIUtil.ShowTipsId(372451)
    return
  end
  local pickaxId = DataCenter.ActivityTreasureHuntNewManager:GetPickaxId(activityId)
  if not pickaxId then
    return
  end
  local param = {}
  param.goodsInfo = {}
  param.goodsInfo.rewardType = RewardType.GOODS
  param.goodsInfo.itemId = pickaxId
  param.goodsInfo.count = 1
  local limit = digTemplate.pickaxBuyMax - digInfo.itemBoughtTimes
  param.goodsInfo.limitCount = limit
  param.goodsInfo.eachPrice = digTemplate.pickaxPrice
  param.consumeInfo = {}
  param.consumeInfo.currencyType = RewardType.GOLD
  param.consumeInfo.currencyId = ""
  
  function param.callback(buyCount)
    self.cacheBuyPickaxeCount = buyCount
    self:RequestBuyOneItem(activityId, buyCount)
  end
  
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIMultiBuy, {anim = true}, param)
end

function ActivityTreasureHuntNewManager:CheckIfPickaxeEnough(activityId, showTip)
  local pickaxeId = self:GetPickaxId(activityId)
  local tempCount = DataCenter.ItemData:GetItemCount(pickaxeId)
  if tempCount <= 0 then
    if showTip then
      UIUtil.ShowMessage(Localization:GetString("372452"), 2, nil, nil, function()
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIGetPickaxe, {anim = true}, activityId)
      end, nil, nil)
    end
    return false
  end
  return true
end

function ActivityTreasureHuntNewManager:GetBigRewardClaimStateByLevel(activityId, level)
  local digInfo = DataCenter.ActivityTreasureHuntNewManager:GetDigInfo(activityId)
  if digInfo ~= nil then
    local curLevel = digInfo.finishedLv + 1
    if level > curLevel then
      return 0
    end
    if not table.IsNullOrEmpty(digInfo.claimedLv) then
      for _, v in pairs(digInfo.claimedLv) do
        if checknumber(level) == checknumber(v) then
          return 2
        end
      end
    end
    return 1
  end
  return 0
end

function ActivityTreasureHuntNewManager:RequestClaimBigReward(activityId)
  SFSNetwork.SendMessage(MsgDefines.ActivityTreasureHuntNewClaimDigBigReward, activityId)
end

function ActivityTreasureHuntNewManager:OnRequestClaimBigReward(msg)
  if msg == nil or table.IsNullOrEmpty(msg.reward) then
    return
  end
  DataCenter.RewardManager:AddRewardsAndRes(msg)
  DataCenter.RewardManager:ShowCommonReward(msg)
  if msg.aid ~= nil then
    DataCenter.ActivityTreasureHuntNewManager:RequestDigInfo(msg.aid)
  end
  EventManager:GetInstance():Broadcast(EventId.ActivityTreasureHuntNewClaimBigRewardSuccess)
end

function ActivityTreasureHuntNewManager:GetCanClaimNormalRewardList(activityId)
  local digInfo = DataCenter.ActivityTreasureHuntNewManager:GetDigInfo(activityId)
  if digInfo ~= nil and not table.IsNullOrEmpty(digInfo.normalRewardCanClaim) then
    return digInfo.normalRewardCanClaim
  end
end

function ActivityTreasureHuntNewManager:GetCostNum(activityId)
  local consume_num = -1
  local digInfo = DataCenter.ActivityTreasureHuntNewManager:GetDigInfo(activityId)
  if digInfo ~= nil then
    consume_num = digInfo.consume_num
  end
  return consume_num
end

function ActivityTreasureHuntNewManager:GetHistoryTotalRewardData(activityId)
  local res = {}
  local digInfo = DataCenter.ActivityTreasureHuntNewManager:GetDigInfo(activityId)
  if digInfo ~= nil and not table.IsNullOrEmpty(digInfo.historyTotalReward) then
    local rewardListTmp = {}
    for i, v in pairs(digInfo.historyTotalReward) do
      if v.value ~= nil then
        if rewardListTmp[v.value.id] ~= nil then
          rewardListTmp[v.value.id].count = rewardListTmp[v.value.id].count + v.value.num
        else
          rewardListTmp[v.value.id] = {
            count = v.value.num,
            type = v.type
          }
        end
      end
    end
    for i, v in pairs(rewardListTmp) do
      table.insert(res, {
        itemId = checknumber(i),
        count = v.count,
        type = v.type
      })
    end
  end
  return res
end

function ActivityTreasureHuntNewManager:RequestClaimStoredReward(activityId)
  SFSNetwork.SendMessage(MsgDefines.ActivityTreasureHuntNewClaimDigStoredReward, activityId)
end

function ActivityTreasureHuntNewManager:OnRequestClaimStoredReward(msg)
  if msg == nil or table.IsNullOrEmpty(msg.reward) then
    return
  end
  DataCenter.RewardManager:AddRewardsAndRes(msg)
  DataCenter.RewardManager:ShowCommonReward(msg, nil, nil, nil, nil, nil, function()
    if msg.aid ~= nil then
      DataCenter.ActivityTreasureHuntNewManager:RequestDigInfo(msg.aid)
    end
    EventManager:GetInstance():Broadcast(EventId.ActivityTreasureHuntNewClaimStoredRewardSuccess)
  end)
end

function ActivityTreasureHuntNewManager:CheckOpenBatchDig(activityId)
  local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(activityId)
  local digTemplate = self:GetDigTemplate(activityInfo.subType)
  if digTemplate and digTemplate.animation_type == 1 then
    return true
  end
  return false
end

function ActivityTreasureHuntNewManager:RequestBatchDig(activityId)
  if self.isBatchDigRequesting then
    Logger.LogInfo("ActivityTreasureHuntNewManager:RequestBatchDig is requesting, return")
    return false
  end
  self.isBatchDigRequesting = true
  SFSNetwork.SendMessage(MsgDefines.StartActivityBatchDigV2, activityId)
  return true
end

function ActivityTreasureHuntNewManager:OnReqBatchDigError()
  self.isBatchDigRequesting = false
  EventManager:GetInstance():Broadcast(EventId.ActivityTreasureHuntNewDigBatchBlockFail)
end

function ActivityTreasureHuntNewManager:OnReqBatchDig(msg)
  self.isBatchDigRequesting = false
  if not msg then
    return
  end
  if not msg.resultArr then
    Logger.LogError("ActivityTreasureHuntNewManager:OnReqBatchDig msg.resultArr is nil")
  else
    local rewardList = {}
    for _, v in pairs(msg.resultArr) do
      if v and v.reward then
        for _, reward in pairs(v.reward) do
          table.insert(rewardList, reward)
        end
      end
    end
    DataCenter.RewardManager:AddRewardsAndRes({reward = rewardList})
  end
  if self.digInfoDic[msg.activityId] then
    local digInfo = self.digInfoDic[msg.activityId]
    local rewardArr = {}
    if msg.resultArr then
      for _, v in pairs(msg.resultArr) do
        if v and v.reward then
          for _, reward in pairs(v.reward) do
            table.insert(rewardArr, reward)
          end
        end
      end
      digInfo:AddToCanClaimReward(rewardArr)
    end
    if msg.goodsIndex and msg.goodsIndex == 0 then
      self.cacheFinalRewardMsg = msg
    end
    if msg.consume_num then
      digInfo.consume_num = msg.consume_num
    end
    local resultArr = msg.resultArr
    if table.IsNullOrEmpty(resultArr) then
      return
    end
    local digResultList = {}
    for i, v in ipairs(resultArr) do
      local digResult = digInfo:AddOneDigRecord(v)
      table.insert(digResultList, digResult)
    end
    EventManager:GetInstance():Broadcast(EventId.ActivityTreasureHuntNewDigBatchBlockSuccess, digResultList)
  end
end

return ActivityTreasureHuntNewManager
