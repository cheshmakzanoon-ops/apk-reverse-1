local ChatEmojiManager = BaseClass("ChatEmojiManager")
local Localization = CS.GameEntry.Localization
local recentUseTextId = "chat_meme_panel_emoji_title1"
local allEmojiTextId = "chat_meme_panel_emoji_title2"
local stickerTextId = "chat_meme_panel_stickers"
local emojiMaxRowCount = 7
local stickerMaxRowCount = 4

function ChatEmojiManager:__init()
  self.emojiList = {}
end

function ChatEmojiManager:GetRecentUseEmoji()
  local str = CommonUtil.PlayerPrefsGetString("RecentUseEmoji", "")
  if not string.IsNullOrEmpty(str) then
    str = string.split(str, "|")
    local result = {}
    for _, id in pairs(str) do
      local line = LocalController:instance():getLine(TableName.LW_EMOJI, id)
      if line ~= nil and line.sort >= 1 then
        table.insert(result, id)
      end
    end
    if not table.IsNullOrEmpty(result) then
      return result
    end
  end
end

function ChatEmojiManager:SaveRecentUseEmoji(emojiId)
  local str = CommonUtil.PlayerPrefsGetString("RecentUseEmoji", "")
  emojiId = tostring(emojiId)
  local saveStr = ""
  if not string.IsNullOrEmpty(str) then
    str = string.split(str, "|")
    local index
    for i = 1, #str do
      if str[i] == emojiId then
        index = i
      end
    end
    if index then
      table.remove(str, index)
    end
    table.insert(str, 1, emojiId)
    for i = 1, emojiMaxRowCount do
      if str[i] then
        saveStr = i == 1 and str[i] or saveStr .. "|" .. str[i]
      end
    end
  else
    saveStr = emojiId
  end
  CommonUtil.PlayerPrefsSetString("RecentUseEmoji", saveStr)
end

function ChatEmojiManager:GetRecentEmojiData(emojiDataList, recentUseEmojiList)
  local data = {}
  data.type = ChatEmojiType.Emoji
  data.list = {}
  local emoji = {}
  for i = 1, #recentUseEmojiList do
    emoji = DataCenter.ChatEmojiTemplateManager:GetEmojiDataById(tonumber(recentUseEmojiList[i]))
    table.insert(data.list, emoji)
  end
  table.insert(emojiDataList, data)
end

function ChatEmojiManager:GetAllEmojiData(panelShowDataList)
  local emojiDatas = DataCenter.ChatEmojiTemplateManager:GetShowEmojiList()
  local tempList = {}
  tempList.type = ChatEmojiType.Emoji
  tempList.list = {}
  for i = 1, #emojiDatas do
    table.insert(tempList.list, emojiDatas[i])
    if #tempList.list == emojiMaxRowCount or i == #emojiDatas then
      if tempList.list and #tempList.list > 0 then
        table.insert(panelShowDataList, tempList)
      end
      tempList = {}
      tempList.type = ChatEmojiType.Emoji
      tempList.list = {}
    end
  end
  return panelShowDataList
end

function ChatEmojiManager:GetStickersData(panelShowDataList)
  local saveData = DataCenter.ChatEmojiTemplateManager:GetShowStickerList()
  local strickerShowList = {}
  for k, v in ipairs(saveData) do
    table.insert(strickerShowList, v)
  end
  local tempList = {}
  tempList.type = ChatEmojiType.Sticker
  tempList.list = {}
  local stickerUidDict = {}
  for i = #strickerShowList, 1, -1 do
    local id = strickerShowList[i].id
    local uid = DataCenter.StickerWithDecorationLinkManager:GetStickerUid(id)
    if stickerUidDict[uid] then
      table.remove(strickerShowList, i)
    else
      stickerUidDict[uid] = true
    end
  end
  for i = 1, #strickerShowList do
    table.insert(tempList.list, strickerShowList[i])
    if #tempList.list == stickerMaxRowCount or i == #strickerShowList then
      if tempList.list and #tempList.list > 0 then
        table.insert(panelShowDataList, tempList)
      end
      tempList = {}
      tempList.type = ChatEmojiType.Sticker
      tempList.list = {}
    end
  end
  return panelShowDataList
end

function ChatEmojiManager:GetEmojiPanelData()
  local panelShowDataList = {}
  local recentUseEmojiList = self:GetRecentUseEmoji()
  if recentUseEmojiList then
    local textData = {}
    textData.text = Localization:GetString(recentUseTextId)
    textData.type = ChatEmojiType.Text
    table.insert(panelShowDataList, textData)
    self:GetRecentEmojiData(panelShowDataList, recentUseEmojiList)
  end
  local textData = {}
  textData.type = ChatEmojiType.Text
  textData.text = Localization:GetString(allEmojiTextId)
  table.insert(panelShowDataList, textData)
  self:GetAllEmojiData(panelShowDataList)
  textData = {}
  textData.type = ChatEmojiType.Emoji
  table.insert(panelShowDataList, textData)
  return panelShowDataList
end

function ChatEmojiManager:GetStickerPanelData()
  local panelShowDataList = {}
  local textData = {}
  DataCenter.ChatEmojiTemplateManager:TryRemoveExpiredSticker()
  local strickerShowList = DataCenter.ChatEmojiTemplateManager:GetShowStickerList()
  if strickerShowList ~= nil and 0 < #strickerShowList then
    self:GetStickersData(panelShowDataList)
  end
  textData = {}
  textData.type = ChatEmojiType.Emoji
  table.insert(panelShowDataList, textData)
  return panelShowDataList
end

function ChatEmojiManager:GetStickerShowDict()
  DataCenter.ChatEmojiTemplateManager:TryRemoveExpiredSticker()
  local strickerShowList = DataCenter.ChatEmojiTemplateManager:GetShowStickerList()
  local showDict = {}
  if strickerShowList and 0 < #strickerShowList then
    for k, v in pairs(strickerShowList) do
      showDict[v.id] = true
    end
  end
  return showDict
end

function ChatEmojiManager:__delete()
  self.groupAndLevelDic = nil
  self.templateDic = nil
end

return ChatEmojiManager
