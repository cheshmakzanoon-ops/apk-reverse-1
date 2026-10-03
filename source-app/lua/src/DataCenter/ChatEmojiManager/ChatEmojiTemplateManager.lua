local logger = require("Framework.Logger.Logger")
local ChatEmojiTemplateManager = BaseClass("ChatEmojiTemplateManager")
local ResourceManager = CS.GameEntry.Resource
local unity_time = CS.UnityEngine.Time
local GameObject = CS.UnityEngine.GameObject
local UnityRectTransform = typeof(CS.UnityEngine.RectTransform)
local UnityRawImage = typeof(CS.UnityEngine.UI.RawImage)
local UnityImage = typeof(CS.UnityEngine.UI.Image)
local SEND_LIMIT_TIME = 5000
local SEND_LIMIT_COUNT = 1

function ChatEmojiTemplateManager:__init()
  self.emojiDic = {}
  self.emojiShowList = {}
  self.chatStickerList = {}
  self.stickerShowDic = {}
  self.stickerShowList = {}
  self.stickerExpiredTimeDict = {}
  self.minExpiredTime = nil
  self.stickerMatDic = {}
  self.stickerNodeDic = {}
  self.stickerUseRecord = {}
  self:InitAll()
end

function ChatEmojiTemplateManager:InitData(msg)
  self:SetStickerDataByMsg(msg)
  self:SetEmojiShowList(msg.emoji or {})
end

function ChatEmojiTemplateManager:SetStickerDataByMsg(msg)
  if msg == nil then
    return
  end
  local stickerUnlockList = {}
  if msg.stickerData then
    for k, v in pairs(msg.stickerData) do
      table.insert(stickerUnlockList, v)
    end
  end
  if msg.stickerInfos then
    for k, v in pairs(msg.stickerInfos) do
      table.insert(stickerUnlockList, v.id)
    end
  end
  self:SetStickerShowList(stickerUnlockList)
  self:SetStickerExpiredTime(msg.stickerInfos)
  self:SetDecorationMapStickerData()
end

function ChatEmojiTemplateManager:GetStickerTempData(stickerId)
  if self.stickerShowDic[stickerId] == nil then
    local temp = LocalController:instance():getLine(TableName.LW_Sticker, tostring(stickerId))
    if temp then
      local rowData = {}
      rowData.id = temp.id
      rowData.sort = temp.sort or -1
      rowData.name = temp.name
      rowData.type = temp.type
      rowData.frame_rate = temp.frame_rate
      rowData.link_decoration_id = temp.link_decoration_id or 0
      rowData.para1 = temp.para1
      rowData.para2 = temp.para2
      rowData.sticker_name = temp.sticker_name
      rowData.unlock_goods = temp.unlock_goods
      self.stickerShowDic[rowData.id] = rowData
    end
  end
  return self.stickerShowDic[stickerId]
end

function ChatEmojiTemplateManager:SetStickerShowList(stickerUnlockList)
  self.stickerShowList = {}
  for _, stickerId in pairs(stickerUnlockList) do
    local tempData = self:GetStickerTempData(stickerId)
    if tempData and tempData.sort >= 1 and (tempData.type == StickerUseTtype.Chat or tempData.type == StickerUseTtype.ChatAndMap) then
      table.insert(self.stickerShowList, tempData)
    end
  end
  table.sort(self.stickerShowList, function(a, b)
    if a.sort < b.sort then
      return true
    end
  end)
  self.chatStickerList = {}
  for _, stickerData in ipairs(self.stickerShowList) do
    table.insert(self.chatStickerList, stickerData)
  end
end

function ChatEmojiTemplateManager:SetStickerExpiredTime(dataList)
  if dataList == nil then
    return
  end
  self.stickerExpiredTimeDict = {}
  self.minExpiredTime = nil
  for _, data in pairs(dataList) do
    self.stickerExpiredTimeDict[data.id] = data.expireTime
    if self.minExpiredTime == nil or data.expireTime < self.minExpiredTime then
      self.minExpiredTime = data.expireTime
    end
  end
end

function ChatEmojiTemplateManager:SetDecorationMapStickerData()
  self.stickerShowList = {}
  for _, v in ipairs(self.chatStickerList) do
    table.insert(self.stickerShowList, v)
  end
  local isNeedResort = false
  local mapStickerDict = {}
  local allTypeDecoration = DataCenter.DecorationTemplateManager:GetTypeDecorations(DecorationType.DecorationType_Emoji)
  for _, v in ipairs(allTypeDecoration) do
    local isUnlock = DataCenter.DecorationDataManager:IsUnlock(v)
    if isUnlock then
      local stickerId = DataCenter.StickerWithDecorationLinkManager:GetStickerIdByDecoId(v)
      local stickerTmp
      if stickerId and 0 < stickerId then
        stickerTmp = self:GetStickerTempData(stickerId)
        if stickerTmp and stickerTmp.sort >= 1 and (stickerTmp.type == StickerUseTtype.Chat or stickerTmp.type == StickerUseTtype.ChatAndMap) then
          local expireTime = DataCenter.StickerWithDecorationLinkManager:GetExpireTimeByStickId(stickerId) / 1000
          mapStickerDict[stickerId] = {expireTime = expireTime, data = stickerTmp}
        end
      end
    end
  end
  for k, v in pairs(mapStickerDict) do
    if 0 < v.expireTime then
      self.stickerExpiredTimeDict[k] = v.expireTime
      if self.minExpiredTime == nil or v.expireTime < self.minExpiredTime then
        self.minExpiredTime = v.expireTime
      end
    end
  end
  for k, v in ipairs(self.stickerShowList) do
    if mapStickerDict[v.id] then
      mapStickerDict[v.id] = nil
    end
  end
  for k, v in pairs(mapStickerDict) do
    isNeedResort = true
    table.insert(self.stickerShowList, v.data)
  end
  if isNeedResort then
    table.sort(self.stickerShowList, function(a, b)
      if a.sort < b.sort then
        return true
      end
    end)
  end
end

function ChatEmojiTemplateManager:TryRemoveExpiredSticker()
  if self.minExpiredTime == nil then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  if curTime < self.minExpiredTime then
    return
  end
  local removeStickerDict = {}
  self.minExpiredTime = nil
  local listCount = #self.stickerShowList
  for i = listCount, 1, -1 do
    local stickerData = self.stickerShowList[i]
    local expireTime = self.stickerExpiredTimeDict[stickerData.id]
    if expireTime ~= nil and curTime > expireTime then
      removeStickerDict[stickerData.id] = true
      table.remove(self.stickerShowList, i)
      self.stickerExpiredTimeDict[stickerData.id] = nil
    end
  end
  for id, expiredTime in pairs(self.stickerExpiredTimeDict) do
    if self.minExpiredTime == nil or expiredTime < self.minExpiredTime then
      self.minExpiredTime = expiredTime
    end
  end
  local chatListCount = #self.chatStickerList
  for i = chatListCount, 1, -1 do
    local stickerData = self.chatStickerList[i]
    if removeStickerDict[stickerData.id] then
      table.remove(self.chatStickerList, i)
    end
  end
end

function ChatEmojiTemplateManager:TryGetStickerExpiredTime(id)
  return self.stickerExpiredTimeDict[id]
end

function ChatEmojiTemplateManager:SetEmojiShowList(emojiUnlockList)
  if type(emojiUnlockList) ~= "table" then
    logger.LogError("ChatEmojiTemplateManager SetEmojiShowList emojiUnlockList Error " .. tostring(emojiUnlockList))
    return
  end
  local rowData
  self.emojiShowList = {}
  LocalController:instance():visitTable(TableName.LW_EMOJI, function(id, lineData)
    rowData = {}
    rowData.id = lineData.id
    rowData.category = lineData.category
    rowData.sort = lineData.sort or -1
    rowData.name = lineData.path
    rowData.path = string.format(ChatEmojiPath, lineData.path)
    local isShow = false
    if rowData.sort > 0 then
      if rowData.category == EmojiCategory.Goods then
        for _, emoji in pairs(emojiUnlockList) do
          if emoji.id == rowData.id then
            isShow = true
            break
          end
        end
      else
        isShow = true
      end
    end
    if isShow then
      table.insert(self.emojiShowList, rowData)
    end
    self.emojiDic[rowData.id] = rowData
  end)
  table.sort(self.emojiShowList, function(a, b)
    return a.sort < b.sort
  end)
end

function ChatEmojiTemplateManager:IsIncludeUnlockId(tab, value)
  for k, v in ipairs(tab) do
    if v == value then
      return true
    end
  end
  return false
end

function ChatEmojiTemplateManager:InitAll()
  self.emojiShowList = {}
  local rowData = {}
  LocalController:instance():visitTable(TableName.LW_EMOJI, function(id, lineData)
    rowData = {}
    rowData.id = lineData.id
    rowData.categroy = lineData.categroy
    rowData.sort = lineData.sort or -1
    rowData.name = lineData.path
    rowData.path = string.format(ChatEmojiPath, lineData.path)
    if rowData.sort >= 1 then
      table.insert(self.emojiShowList, rowData)
    end
    self.emojiDic[rowData.id] = rowData
  end)
  table.sort(self.emojiShowList, function(a, b)
    if a.sort < b.sort then
      return true
    end
  end)
  local cd = LuaEntry.DataConfig:TryGetNum("sticker_chat_limit", "k1", 5)
  SEND_LIMIT_TIME = cd * 1000
end

function ChatEmojiTemplateManager:GetEmojiDataByName(name)
  for i = 1, #self.emojiShowList do
    if self.emojiShowList[i].name == name then
      return self.emojiShowList[i]
    end
  end
end

function ChatEmojiTemplateManager:GetEmojiDataById(id)
  return self.emojiDic[id]
end

function ChatEmojiTemplateManager:GetShowEmojiList()
  return self.emojiShowList
end

function ChatEmojiTemplateManager:GetStickerDataById(id)
  self:TryRemoveExpiredSticker()
  for k, v in pairs(self.stickerShowList) do
    if v.id == id then
      return v
    end
  end
end

function ChatEmojiTemplateManager:GetShowStickerList()
  return self.stickerShowList
end

function ChatEmojiTemplateManager:ShowStickerByCfgId(targetTransform, key, cfgId, scale)
  local rowCfg = LocalController:instance():getLine(TableName.LW_Sticker, tostring(cfgId))
  if rowCfg == nil then
    logger.LogError("Sticker\231\148\159\230\136\144\230\151\182\239\188\140\228\188\160\229\133\165id\228\184\141\229\156\168\233\133\141\231\189\174\232\161\168\228\184\173\239\188\154" .. cfgId)
  end
  local request = ResourceManager:InstantiateAsync(ChatStickerItemPath)
  request:completed("+", function()
    if request.isError then
      return
    end
    local stickerRawImage = request.gameObject:GetComponent(UnityImage)
    local path
    local startPosX = 0
    if string.IsNullOrEmpty(rowCfg.para1) then
      path = string.format(ChatStickerDynamicPath, rowCfg.name)
      startPosX = 0
    else
      path = ChatStickerImagePatch .. rowCfg.para1
      startPosX = tonumber(rowCfg.para2) or 0
    end
    stickerRawImage:LoadSpriteAsync(path)
    if targetTransform then
      request.gameObject.transform:SetParent(targetTransform)
    else
      logger.LogError("Sticker\231\148\159\230\136\144\230\151\182\239\188\140\228\188\160\229\133\165Transform\228\184\186\231\169\186")
    end
    scale = scale or 1
    request.gameObject.transform:Set_localScale(scale, scale, scale)
    local goRect = request.gameObject:GetComponent(UnityRectTransform)
    goRect:Set_anchoredPosition(0, 0)
    request.gameObject:SetActive(true)
    local materialName = "MapSticker"
    local asset = ResourceManager:LoadAsset(string.format(ChatstickerMaterialPath, materialName), typeof(CS.UnityEngine.Material))
    if asset == nil then
      logger.LogError("Sticker\229\175\185\229\186\148\231\154\132\230\157\144\232\180\168\229\138\160\232\189\189\229\164\177\232\180\165\239\188\154" .. materialName)
      return nil
    end
    local mat = CS.UnityEngine.Material.Instantiate(asset.asset)
    self.stickerMatDic[key] = mat
    mat:SetFloat("_PlaySpeed", ChatStickerPlaySpeed)
    mat:SetFloat("_CurShowIndex", 0)
    mat:SetFloat("_StartTime", unity_time.timeSinceLevelLoad)
    mat:DisableKeyword("_FULLIMAGE_ON")
    mat:SetFloat("_StartX", startPosX)
    stickerRawImage.material = mat
  end)
  self.stickerNodeDic[key] = request
end

function ChatEmojiTemplateManager:KillStickerByKey(key)
  if self.stickerNodeDic[key] ~= nil then
    self.stickerNodeDic[key]:Destroy()
    self.stickerNodeDic[key] = nil
  end
  if self.stickerMatDic[key] ~= nil then
    GameObject.Destroy(self.stickerMatDic[key])
    self.stickerMatDic[key] = nil
  end
end

function ChatEmojiTemplateManager:TrySendSticker(callback, t)
  local now = UITimeManager:GetInstance():GetServerTime()
  local record = self.stickerUseRecord[SEND_LIMIT_COUNT]
  if record == nil then
    table.insert(self.stickerUseRecord, 1, now)
    callback(t)
    return
  end
  if now - record < SEND_LIMIT_TIME then
    UIUtil.ShowTipsId("sticker_send_limit_tips")
    return
  end
  table.remove(self.stickerUseRecord, #self.stickerUseRecord)
  table.insert(self.stickerUseRecord, 1, now)
  callback(t)
end

function ChatEmojiTemplateManager:__delete()
  self.emojiList = nil
  self.emojiDic = nil
end

return ChatEmojiTemplateManager
