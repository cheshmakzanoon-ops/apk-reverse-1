local CacheData = BaseClass("CacheData")
local type = typeof(CS.TMPro.TMP_SpriteAsset)
local path = "Assets/Main/TMPAsset/EmojiAssets/googleEmoji-0.asset"
local Resource = CS.GameEntry.Resource
local NativeFontFallbackWrapper = CS.NativeFontFallbackWrapper

function CacheData:__init()
  NativeFontFallbackWrapper.Instance:Init()
  self.chatInputDataDic = {}
  self.mobilTestDic = {}
  self:AddListeners()
end

function CacheData:AddListeners()
  EventManager:GetInstance():AddListenerWithSelf(EventId.SwitchAccount, self.OnSwitchAccount, self)
end

function CacheData:RemoveListener()
  EventManager:GetInstance():RemoveListener2(EventId.SwitchAccount, self.OnSwitchAccount)
end

function CacheData:GetInputData(roomId)
  if not roomId then
    return
  end
  if not self.chatInputDataDic[roomId] then
    self.chatInputDataDic[roomId] = {}
  end
  return self.chatInputDataDic[roomId]
end

function CacheData:ClearChatInputDataByRoomId(roomId)
  if not roomId or not self.chatInputDataDic[roomId] then
    return
  end
  self.chatInputDataDic[roomId] = {}
end

function CacheData:OnSwitchAccount()
  self.chatInputDataDic = {}
end

function CacheData:MobilTestLogInfo(mobilId, viewName)
  if not mobilId or string.IsNullOrEmpty(viewName) then
    return
  end
  if self.mobilTestDic[mobilId] and self.mobilTestDic[mobilId] == viewName then
    return
  end
  self.mobilTestDic[mobilId] = viewName
  Logger.LogInfo("MobilInputId     id : " .. mobilId .. "  viewName :   " .. viewName)
end

function CacheData:LoadEmojiAsset(callback)
  if self.emojiAsset and self.emojiAsset.asset then
    callback(self.emojiAsset.asset)
    return
  end
  self.emojiAsset = Resource:LoadAssetAsync(path, type)
  
  local function Onloaded(asset)
    if asset == nil then
      logger.LogError("emojiAssets load error\239\188\154" .. path)
      return
    end
    callback(asset.asset)
  end
  
  if self.emojiAsset and self.emojiAsset.completed then
    self.emojiAsset.completed = self.emojiAsset.completed + Onloaded
  else
    self.emojiAsset.completed = Onloaded
  end
end

function CacheData:__delete()
  self:RemoveListener()
  if IsNotNull(self.emojiAsset) then
    self.emojiAsset.completed = nil
  end
end

function CacheData:Startup()
end

return CacheData
