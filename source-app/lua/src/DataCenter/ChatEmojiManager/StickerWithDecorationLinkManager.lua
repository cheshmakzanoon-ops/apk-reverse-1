local StickerWithDecorationLinkManager = BaseClass("StickerWithDecorationLinkManager")

function StickerWithDecorationLinkManager:__init()
  self.stickerIdRepeatLinkDict = nil
  self.stickerIdToUniqueIdDict = nil
  self.stickerIdToDecoIdDict = {}
  self.decoIdToStickerId = {}
  self.goodsIdToStickerCellDict = {}
end

function StickerWithDecorationLinkManager:__delete()
  self.stickerIdRepeatLinkDict = nil
  self.stickerIdToUniqueIdDict = nil
  self.stickerIdToDecoIdDict = nil
  self.decoIdToStickerId = nil
end

function StickerWithDecorationLinkManager:TryInitRepeatLinkDict()
  if self.stickerIdRepeatLinkDict == nil then
    self.stickerIdRepeatLinkDict = {}
    self.stickerIdToUniqueIdDict = {}
    local configStr = LuaEntry.DataConfig:TryGetStr("repeated_sticker", "k1", "")
    if not string.IsNullOrEmpty(configStr) then
      local data = string.string2array_num(configStr, ";", "|")
      for _, v in ipairs(data) do
        if 2 <= #v then
          local uid = v[1]
          self.stickerIdRepeatLinkDict[uid] = v
          for _, id in ipairs(v) do
            self.stickerIdToUniqueIdDict[id] = uid
          end
        end
      end
    end
  end
end

function StickerWithDecorationLinkManager:GetStickerUid(stickerId)
  self:TryInitRepeatLinkDict()
  if self.stickerIdToUniqueIdDict[stickerId] == nil then
    return stickerId
  else
    return self.stickerIdToUniqueIdDict[stickerId]
  end
end

function StickerWithDecorationLinkManager:GetStickerUidByDecoId(decoId)
  local stickerId = self:GetStickerIdByDecoId(decoId)
  return self:GetStickerUid(stickerId)
end

function StickerWithDecorationLinkManager:GetRepeatStickerIdList(stickerId)
  self:TryInitRepeatLinkDict()
  local uid = self:GetStickerUid(stickerId)
  if uid == nil then
    return nil
  end
  if self.stickerIdRepeatLinkDict[uid] == nil then
    return nil
  else
    return self.stickerIdRepeatLinkDict[uid]
  end
end

function StickerWithDecorationLinkManager:GetStickerIdByDecoId(decoId)
  decoId = tonumber(decoId) or 0
  if self.decoIdToStickerId[decoId] == nil then
    local stickerId = 0
    local template = DataCenter.DecorationTemplateManager:GetTemplate(decoId)
    if template and template.customVariable then
      stickerId = tonumber(template.customVariable) or 0
    end
    self.decoIdToStickerId[decoId] = stickerId
  end
  return self.decoIdToStickerId[decoId]
end

function StickerWithDecorationLinkManager:GetDecoIdByStickerId(stickerId)
  stickerId = tonumber(stickerId) or 0
  if self.stickerIdToDecoIdDict[stickerId] == nil then
    local decoId = 0
    local strickerTmp = DataCenter.ChatEmojiTemplateManager:GetStickerTempData(stickerId)
    if strickerTmp then
      decoId = strickerTmp.link_decoration_id
    end
    self.stickerIdToDecoIdDict[stickerId] = decoId
  end
  return self.stickerIdToDecoIdDict[stickerId]
end

function StickerWithDecorationLinkManager:CheckIsUnlockByStickId(stickerId)
  local isUnlock = false
  local needCheckList = {}
  local repeatList = self:GetRepeatStickerIdList(stickerId)
  if repeatList then
    needCheckList = repeatList
  else
    needCheckList = {stickerId}
  end
  local stickerUnlockDict = DataCenter.ChatEmojiManager:GetStickerShowDict()
  for _, id in ipairs(needCheckList) do
    local decoId = self:GetDecoIdByStickerId(id)
    if stickerUnlockDict[id] then
      isUnlock = true
      break
    end
    local decoData = DataCenter.DecorationDataManager:GetSkinDataById(decoId)
    if decoData then
      local inExpireTime = decoData:IsInExpireTime()
      if inExpireTime then
        isUnlock = true
        break
      end
    end
  end
  return isUnlock
end

function StickerWithDecorationLinkManager:CheckIsUnlockByDecoId(decoId)
  local isUnlock = false
  local stickerId = self:GetStickerIdByDecoId(decoId)
  if stickerId then
    isUnlock = self:CheckIsUnlockByStickId(stickerId)
  end
  return isUnlock
end

function StickerWithDecorationLinkManager:CheckIsPermanentUnlockByStickId(decoId)
  local stickerId = self:GetStickerIdByDecoId(decoId)
  if not stickerId then
    return false
  end
  local isPermanentUnlock = false
  if not stickerId then
    return isPermanentUnlock
  end
  local needCheckList = {}
  local repeatList = self:GetRepeatStickerIdList(stickerId)
  if repeatList then
    needCheckList = repeatList
  else
    needCheckList = {stickerId}
  end
  local stickerUnlockDict = DataCenter.ChatEmojiManager:GetStickerShowDict()
  for _, id in ipairs(needCheckList) do
    local decoId = self:GetDecoIdByStickerId(id)
    if stickerUnlockDict[id] then
      isPermanentUnlock = true
      break
    end
    local decoData = DataCenter.DecorationDataManager:GetSkinDataById(decoId)
    if decoData and decoData.expireTime <= 0 then
      isPermanentUnlock = true
      break
    end
    local decoTemp = DataCenter.DecorationTemplateManager:GetTemplate(decoId)
    if decoTemp and decoTemp.gainMethod then
      for _, method in ipairs(decoTemp.gainMethod) do
        local goodsId = method.id
        local curItemIdCount = DataCenter.ItemData:GetItemCount(goodsId)
        if 0 < curItemIdCount then
          isPermanentUnlock = true
          break
        end
      end
    end
    local stickerTemp = DataCenter.ChatEmojiTemplateManager:GetStickerTempData(id)
    if stickerTemp and 0 < stickerTemp.unlock_goods then
      local goodsId = stickerTemp.unlock_goods
      local curItemIdCount = DataCenter.ItemData:GetItemCount(goodsId)
      if 0 < curItemIdCount then
        isPermanentUnlock = true
        break
      end
    end
  end
  return isPermanentUnlock
end

function StickerWithDecorationLinkManager:GetExpireTimeByStickId(stickerId)
  local expireTime = 0
  local needCheckList = {}
  local repeatList = self:GetRepeatStickerIdList(stickerId)
  if repeatList then
    needCheckList = repeatList
  else
    needCheckList = {stickerId}
  end
  for _, id in ipairs(needCheckList) do
    local decoId = self:GetDecoIdByStickerId(id)
    local seTime = DataCenter.ChatEmojiTemplateManager:TryGetStickerExpiredTime(id)
    if seTime and 0 < seTime then
      expireTime = seTime * 1000
      break
    end
    local decoData = DataCenter.DecorationDataManager:GetSkinDataById(decoId)
    if decoData then
      local deTime = decoData:GetExpireTime()
      if deTime and 0 < deTime then
        expireTime = deTime
        break
      end
    end
  end
  return expireTime
end

function StickerWithDecorationLinkManager:GetExpireTimeByDecoId(decoId)
  local expireTime = 0
  local stickerId = self:GetStickerIdByDecoId(decoId)
  if stickerId then
    expireTime = self:GetExpireTimeByStickId(stickerId)
  end
  return expireTime
end

function StickerWithDecorationLinkManager:GetStickerCellByGoodsId(goodsId)
  goodsId = checknumber(goodsId)
  if table.count(self.goodsIdToStickerCellDict) == 0 then
    self.goodsIdToStickerCellDict = {}
    LocalController:instance():visitTable(TableName.LW_Sticker, function(id, cell)
      if cell.unlock_goods > 0 then
        self.goodsIdToStickerCellDict[cell.unlock_goods] = DeepCopy(cell)
      end
    end)
  end
  return table.TryGetValue(self.goodsIdToStickerCellDict, goodsId)
end

return StickerWithDecorationLinkManager
