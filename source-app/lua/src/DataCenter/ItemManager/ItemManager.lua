local ItemManager = BaseClass("ItemManager")
local Localization = CS.GameEntry.Localization

local function __init(self)
  self.lastType = nil
end

local function __delete(self)
  self.lastType = nil
end

local function ItemBuyHandle(self, message)
  local Player = LuaEntry.Player
  if message.errorCode == nil then
    if message.remainGold ~= nil and message.costGold ~= nil then
      Player.gold = message.remainGold
      Player.payTotal = message.costGold
      EventManager:GetInstance():Broadcast(EventId.UpdateGold)
    end
    local itemSFS = message.item
    if itemSFS ~= nil and itemSFS.id ~= nil then
      itemSFS.itemId = itemSFS.id
    end
    DataCenter.ItemData:UpdateOneItem(itemSFS)
    EventManager:GetInstance():BroadcastDeferred(EventId.RefreshItems)
  else
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
  end
end

local function ItemUseHandle(self, message)
  if message.errorCode == nil then
    if message.resource ~= nil then
      LuaEntry.Resource:UpdateResource(message.resource)
    end
    local showReward = true
    if message.opType and message.opType == 1 then
      showReward = false
    end
    local itemId = message.itemId
    local item = DataCenter.ItemData:GetItemById(itemId)
    local preCount = 0
    if item ~= nil then
      preCount = item.count
    end
    DataCenter.ItemData:UpdateOneItem(message, true, false)
    DataCenter.ItemData:OnUseRet(message)
    local dcnt = preCount - message.count
    local template = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
    if template ~= nil then
      local type = template.type
      local type2 = template.type2
      local para = template.para
      local paras = {}
      if para ~= nil and para ~= "" then
        paras = string.split(para, ";")
      end
      if type == GOODS_TYPE.GOODS_TYPE_3 then
        if itemId == 200815 then
          UIUtil.ShowTips(Localization:GetString("320023", dcnt))
        elseif itemId == 200816 then
          UIUtil.ShowTips(Localization:GetString("320024", dcnt))
        elseif itemId == 200817 then
          UIUtil.ShowTips(Localization:GetString("320025", dcnt))
        elseif itemId == 200818 then
          UIUtil.ShowTips(Localization:GetString("320026", dcnt))
        elseif type2 == 999 and paras[3] ~= nil then
          local resName = CommonUtil.GetResourceNameByType(paras[3])
          resName = resName .. tonumber(paras[2]) * dcnt
          UIUtil.ShowTips(Localization:GetString("120028", resName))
        elseif tonumber(template.para1) == 110 then
          local useNum = 1
          if message.usedItemNum then
            useNum = message.usedItemNum
          end
          UIUtil.ShowTips(Localization:GetString("320273", tonumber(template.para2) * useNum))
        elseif tonumber(template.para1) == 100 or tonumber(template.para1) == 102 or tonumber(template.para1) == 2003 or tonumber(template.para1) == 2005 or tonumber(template.para1) == 2009 or tonumber(template.para1) == 2008 or tonumber(template.para1) == 830 or tonumber(template.para1) == 107 or tonumber(template.para1) == 2010 then
          local showNum = tonumber(template.para2) * dcnt
          local nameKey = ""
          if template.name_value and 0 < table.count(template.name_value) then
            for k, v in pairs(template.name_value) do
              nameKey = k
              break
            end
          else
            local intPara1 = toInt(template.para1)
            if table.containsKey(ItemPara1Text, intPara1) then
              nameKey = ItemPara1Text[intPara1]
            end
          end
          local showName = ""
          if not string.IsNullOrEmpty(nameKey) then
            if table.containsKey(PassYearItemIdList, toInt(itemId)) then
              showName = Localization:GetString(nameKey, showNum)
            else
              showName = Localization:GetString(nameKey, string.GetFormattedStr(showNum))
            end
          end
          UIUtil.ShowTips(Localization:GetString("open_box_tips", showName))
        else
          UIUtil.ShowTips(Localization:GetString("120028", dcnt, DataCenter.ItemTemplateManager:GetName(itemId)))
        end
      elseif type == GOODS_TYPE.GOODS_TYPE_151 then
        if not message.itemEffectObj or not message.itemEffectObj.recycled_item then
          UIUtil.ShowTipsId(120120)
        end
      elseif type == GOODS_TYPE.GOODS_TYPE_186 then
        local room = DataCenter.LWBiuBiuDataManager:GetRoom()
        room:UseGoods(message.itemEffectObj)
      elseif type == GOODS_TYPE.GOODS_TYPE_39 then
        UIUtil.ShowTips(Localization:GetString("260008", DataCenter.ItemTemplateManager:GetName(itemId)))
      elseif type == GOODS_TYPE.GOODS_TYPE_15 then
        UIUtil.ShowTips(Localization:GetString("120025") .. "\n" .. Localization:GetString("390488"))
      elseif type == GOODS_TYPE.GOODS_TYPE_111 then
        local vipRemainTime = DataCenter.VIPManager:GetVipRemainTime()
        if 0 < vipRemainTime then
          UIUtil.ShowTips(Localization:GetString(2000877, DataCenter.ItemTemplateManager:GetName(itemId), UITimeManager:GetInstance():SecondToFmtString(vipRemainTime)))
        end
      elseif type == GOODS_TYPE.GOODS_TYPE_4 then
        UIUtil.ShowTips(Localization:GetString("120089"))
      elseif type == GOODS_TYPE.GOODS_TYPE_134 then
        if message.itemEffectObj and message.itemEffectObj.seasonItemCount and message.itemEffectObj.seasonItemCount[itemId] then
          local num = message.itemEffectObj.seasonItemCount[itemId]
          if tonumber(num) < tonumber(template.para1) then
            UIUtil.ShowTips(Localization:GetString("season_tips167", num, template.para1))
          else
            UIUtil.ShowTipsId("season_mastery_181")
          end
        end
      elseif type == GOODS_TYPE.GOODS_TYPE_154 then
        UIUtil.ShowTips(Localization:GetString("season_s3_digging_game_tips02"))
      elseif type == GOODS_TYPE.GOODS_TYPE_178 then
        UIUtil.ShowTips(Localization:GetString("parkour_digging_game_tips02"))
      elseif type == GOODS_TYPE.GOODS_TYPE_190 then
        UIUtil.ShowTipsId(120089)
      elseif type ~= GOODS_TYPE.GOODS_TYPE_5 and type ~= GOODS_TYPE.GOODS_TYPE_13 and type ~= GOODS_TYPE.GOODS_TYPE_33 and type ~= GOODS_TYPE.GOODS_TYPE_106 then
        local activtiy_around = template.activtiy_around
        if activtiy_around ~= nil and activtiy_around ~= "" then
          local overId = template.overdue
          if overId ~= nil and overId ~= "" then
            local overItem = DataCenter.ItemTemplateManager:GetItemTemplate(overId)
            if overItem ~= nil then
              local name = DataCenter.ItemTemplateManager:GetName(overId) .. " * " .. dcnt
              UIUtil.ShowTips(Localization:GetString("120028", name))
            end
          end
        else
          UIUtil.ShowTips(Localization:GetString("120025") .. "\n" .. Localization:GetString("120026", DataCenter.ItemTemplateManager:GetName(itemId)))
        end
      end
      if itemId == "200401" then
        showReward = false
      end
      if (type == GOODS_TYPE.GOODS_TYPE_5 or type == GOODS_TYPE.GOODS_TYPE_25 or type == GOODS_TYPE.GOODS_TYPE_13 or type == GOODS_TYPE.GOODS_TYPE_46 or type == GOODS_TYPE.GOODS_TYPE_59 or type == GOODS_TYPE.GOODS_TYPE_102 or type == GOODS_TYPE.GOODS_TYPE_107 or type == GOODS_TYPE.GOODS_TYPE_106 or type == GOODS_TYPE.GOODS_TYPE_109 or type == GOODS_TYPE.GOODS_TYPE_138 or type == GOODS_TYPE.GOODS_TYPE_140 or type == GOODS_TYPE.GOODS_TYPE_158 or type == GOODS_TYPE.GOODS_TYPE_179) and message.itemEffectObj ~= nil then
        local reward = message.itemEffectObj.reward
        local singleShowReward = message.itemEffectObj.singleShowReward or {}
        if reward ~= nil or next(singleShowReward) then
          if showReward then
            DataCenter.RewardManager:SequenceShowReward(message.itemEffectObj)
          end
          if reward ~= nil then
            DataCenter.RewardManager:AddRewards(reward)
          end
          if next(singleShowReward) then
            DataCenter.RewardManager:AddRewards(singleShowReward)
          end
        elseif message.itemEffectObj.heroId then
          DataCenter.RewardManager:ShowCommonHeroReward(message.itemEffectObj)
        end
      end
    end
    if message.itemEffectObj ~= nil then
      local itemEffectObj = message.itemEffectObj
      if itemEffectObj ~= nil and itemEffectObj.staminaInfo ~= nil then
        LuaEntry.Player:SetStaminaData(itemEffectObj.staminaInfo)
        EventManager:GetInstance():Broadcast(EventId.FormationStaminaUpdate)
        EventManager:GetInstance():Broadcast(EventId.UserItemCoverStamina)
      end
      if itemEffectObj ~= nil and itemEffectObj.pveStaminaInfo ~= nil then
        LuaEntry.Player:SetPveStaminaData(itemEffectObj.pveStaminaInfo)
        EventManager:GetInstance():Broadcast(EventId.PveStaminaUpdate)
      end
      if itemEffectObj ~= nil and itemEffectObj.remainGold ~= nil then
        LuaEntry.Player.gold = itemEffectObj.remainGold
        EventManager:GetInstance():Broadcast(EventId.UpdateGold)
      end
      if itemEffectObj ~= nil and itemEffectObj.recycled_item ~= nil then
        local reward = itemEffectObj.recycled_item
        local showRewardData = {reward = reward}
        if reward ~= nil then
          DataCenter.RewardManager:ShowCommonReward(showRewardData)
          DataCenter.RewardManager:AddRewards(reward)
        end
      end
    end
    if DataCenter.VIPManager:IsVipPointItem(tonumber(itemId)) then
      DataCenter.VIPManager:RequestLatestVipInfo()
      pcall(function()
        DataCenter.VIPManager:VipReqSourceRecord(VipRequestSource.UseVipItem)
      end)
    end
    EventManager:GetInstance():BroadcastDeferred(EventId.RefreshItems)
    EventManager:GetInstance():BroadcastDeferred(EventId.RefreshBagItems)
    EventManager:GetInstance():Broadcast(EventId.UseItemSuccess, itemId)
  else
    local para2 = message.errorPara2
    local errCode = message.errorCode
    if para2 == nil then
      UIUtil.ShowTipsId(errCode)
    elseif type(para2) == "table" and 0 < #para2 then
      UIUtil.ShowTips(Localization:GetString(errCode, table.unpack(para2)))
    end
  end
end

local function ItemBuyAndUseHandle(self, message)
  if message.errorCode == nil then
    if message.state == 1 then
      self:ItemUseHandle(message)
    end
  else
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
  end
end

local function PushItemDelHandle(self, message)
  DataCenter.ItemData:UpdateOneItem(message, true, true)
end

local function ItemEffectStateList(self, message)
  if message.errorCode == nil then
    local stateObj = message.effectState
    local list = {}
    if stateObj ~= nil then
      for k, v in pairs(stateObj) do
        local intKey = tonumber(k)
        local numValue = tonumber(v)
        local param = {}
        param.intKey = intKey
        param.numValue = numValue
        list[intKey] = numValue
      end
      DataCenter.ItemData:SetAllStatusItem(list)
    end
  end
end

local function SetLastType(self, type)
  self.lastType = type
end

local function GetLastType(self)
  return self.lastType
end

ItemManager.__init = __init
ItemManager.__delete = __delete
ItemManager.ItemBuyHandle = ItemBuyHandle
ItemManager.ItemUseHandle = ItemUseHandle
ItemManager.ItemBuyAndUseHandle = ItemBuyAndUseHandle
ItemManager.PushItemDelHandle = PushItemDelHandle
ItemManager.ItemEffectStateList = ItemEffectStateList
ItemManager.SetLastType = SetLastType
ItemManager.GetLastType = GetLastType
return ItemManager
