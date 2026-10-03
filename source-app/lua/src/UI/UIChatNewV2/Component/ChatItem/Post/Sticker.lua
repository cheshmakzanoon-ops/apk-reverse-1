local IChatItemPost = require("UI.UIChatNewV2.Component.ChatItem.IChatItemPost")
local ChatItemPost_Sticker = BaseClass("ChatItemPost_Sticker", IChatItemPost)
local base = IChatItemPost
local logger = require("Framework.Logger.Logger")
local UnityRectTransform = typeof(CS.UnityEngine.RectTransform)
local UnityRawImage = typeof(CS.UnityEngine.UI.RawImage)
local UnityImage = typeof(CS.UnityEngine.UI.Image)
local unity_time = CS.UnityEngine.Time
local Shader = CS.UnityEngine.Shader
local normalSize = 128

function ChatItemPost_Sticker:OnCreate()
  base.OnCreate(self)
  self.isNightMode = ChatInterface.GetChatTheme() == ChatUIThemeConfig.ChatMode.Night
end

function ChatItemPost_Sticker:OnLoaded()
  if self.transform.childCount == 0 then
    local key
    local chatData = self:ChatData()
    if chatData:GetIsBlockMessages() then
      key = chatData:getRoomId() .. chatData:GetClientNoSeqIDIndex()
    else
      key = chatData:getRoomId() .. chatData:getSeqId()
    end
    local goName = ChatStickerDynamicName .. key
    self.goStickerDynamic = ChatManager2:GetInstance().Room:GetStickerNodeDic(key)
    if not IsNull(self.goStickerDynamic) then
      local strList = self:Split(chatData.msg, ":")
      self:SetStickerDynamicState(tonumber(strList[2] or 0))
      self.mask, self.maskComponent = ChatInterface.GetUtil().CreateOrGetBlackMask(self.goStickerDynamic, 0.2, true)
    else
      self.isImgLoaded = false
      self.isMatLoaded = false
      self.goStickerDynamic = self.view.middle.goChatDynamicSticker:GameObjectSpawn(self.transform)
      if not IsNull(self.goStickerDynamic) then
        self.goStickerDynamic.name = goName
        self.stickerRawImage = self.goStickerDynamic:GetComponent(UnityImage)
        local strList = self:Split(chatData.msg, ":")
        local strLength = table.length(strList)
        if strLength ~= 3 and strLength ~= 4 then
          logger.LogError("Sticker\228\184\139\229\143\145\231\154\132\230\182\136\230\129\175\228\184\141\229\175\185\239\188\129" .. chatData.msg .. "\233\149\191\229\186\166\228\184\186\239\188\154" .. strLength)
          return
        end
        local rowCfg = LocalController:instance():getLine(TableName.LW_Sticker, strList[2])
        self:SetStickerSprite(self.stickerRawImage, rowCfg, chatData)
        self:SetStickerDynamicState(rowCfg.id)
        ChatManager2:GetInstance().Room:SetStickerNodeDic(key, self.goStickerDynamic)
        
        local function callback(mat)
          self:SetStickerMaterialState(mat, key, rowCfg, chatData)
        end
        
        self:InitStickerMaterial(rowCfg, callback)
        self.mask, self.maskComponent = ChatInterface.GetUtil().CreateOrGetBlackMask(self.goStickerDynamic, 0.2, true)
      else
        Logger.LogError("ChatItemSticker\226\128\148\226\128\148\226\128\148\226\128\148UpdateItem()\228\184\173  goStickerDynamic\228\187\142\230\177\160\228\184\173\229\144\140\230\173\165\231\148\159\230\136\144\233\162\132\229\136\182\229\164\177\232\180\165")
      end
    end
  else
  end
  if self.mask then
    self.mask.gameObject:SetActive(self.isNightMode)
  end
  if self.maskComponent then
    self.maskComponent.showMaskGraphic = true
  end
end

function ChatItemPost_Sticker:RefreshImgColorAlpha(stickerRawImage)
  local alpha = 0
  if self.isImgLoaded and self.isMatLoaded then
    alpha = 1
  end
  if stickerRawImage then
    local color = stickerRawImage.color
    color.a = alpha
    stickerRawImage.color = color
  end
end

function ChatItemPost_Sticker:Split(str, reps)
  local resultStrList = {}
  string.gsub(str, "[^" .. reps .. "]+", function(w)
    table.insert(resultStrList, w)
  end)
  return resultStrList
end

function ChatItemPost_Sticker:OnRecycle()
  if not IsNull(self.goStickerDynamic) and self.goStickerDynamic.transform and self.view.middle and self.view.middle.stickerPoolNode and self.view.middle.stickerPoolNode.transform then
    self.goStickerDynamic.transform:SetParent(self.view.middle.stickerPoolNode.transform)
    self.goStickerDynamic:SetActive(false)
  end
  self.goStickerDynamic = nil
  self.stickerRawImage = nil
end

function ChatItemPost_Sticker:SetStickerSprite(stickerRawImage, rowCfg, chatData)
  local path
  if rowCfg.id == 5 and chatData:GetHaveDiceRolled() then
    path = string.format(ChatStickerDicePath, chatData:GetDiceResult())
    stickerRawImage:LoadSprite(path)
    self.isImgLoaded = true
  else
    if string.IsNullOrEmpty(rowCfg.para1) then
      path = string.format(ChatStickerDynamicPath, rowCfg.name)
    else
      path = ChatStickerImagePatch .. rowCfg.para1
    end
    local isReady = UIUtil.CheckAssetDownloaded(path)
    if isReady then
      stickerRawImage:LoadSprite(path)
      self.isImgLoaded = true
    else
      stickerRawImage:LoadSpriteAsync(path, function()
        self.isImgLoaded = true
        self:RefreshImgColorAlpha(stickerRawImage)
      end)
    end
  end
  self:RefreshImgColorAlpha(stickerRawImage)
end

function ChatItemPost_Sticker:SetStickerDynamicState(rowCfgId)
  local goRect = self.goStickerDynamic:GetComponent(UnityRectTransform)
  self.goStickerDynamic.transform:SetParent(self.transform)
  self.goStickerDynamic.transform:Set_localScale(1, 1, 1)
  goRect:Set_anchoredPosition(0, 0)
  local finalSize = normalSize
  local chatItemPostLayoutCS = self.gameObject:GetComponent(typeof(CS.ChatItemPostLayout))
  if not IsNull(chatItemPostLayoutCS) then
    chatItemPostLayoutCS.minSize = Vector2.New(finalSize, finalSize)
  end
  self:SetSizeDeltaXY(finalSize, finalSize)
  goRect:SetSizeWithCurrentAnchors(CS.UnityEngine.RectTransform.Axis.Horizontal, finalSize)
  goRect:SetSizeWithCurrentAnchors(CS.UnityEngine.RectTransform.Axis.Vertical, finalSize)
  self.goStickerDynamic:SetActive(true)
end

function ChatItemPost_Sticker:InitStickerMaterial(rowCfg, callback)
  local materialName = "MapSticker"
  local mat = ChatManager2:GetInstance().Room:PopStickerMaterial(materialName)
  if mat ~= nil then
    callback(mat)
  else
    ChatManager2:GetInstance().Room:LoadStickerMatAssetAsyn(materialName, callback)
  end
end

function ChatItemPost_Sticker:SetStickerMaterialState(mat, key, rowCfg, chatData)
  self.playSpeed = Shader.PropertyToID("_PlaySpeed")
  self.mainTex = Shader.PropertyToID("_MainTex")
  self.startX = Shader.PropertyToID("_StartX")
  self.curShowIndex = Shader.PropertyToID("_CurShowIndex")
  self.startTime = Shader.PropertyToID("_StartTime")
  mat:SetFloat(self.playSpeed, ChatStickerPlaySpeed)
  mat:SetFloat(self.curShowIndex, 0)
  mat:SetFloat(self.startTime, unity_time.timeSinceLevelLoad)
  mat:DisableKeyword("_FULLIMAGE_ON")
  local startPosX = tonumber(rowCfg.para2)
  if startPosX == nil then
    startPosX = 0
  end
  mat:SetFloat(self.startX, startPosX)
  local goStickerDynamic = ChatManager2:GetInstance().Room:GetStickerNodeDic(key)
  if goStickerDynamic then
    ChatManager2:GetInstance().Room:SetStickerMatOfNodeDic(key, mat)
    local goStickerDynamic = ChatManager2:GetInstance().Room:GetStickerNodeDic(key)
    local stickerRawImage = goStickerDynamic:GetComponent(UnityImage)
    if IsNull(stickerRawImage) then
      Logger.LogError("\229\189\147\229\137\141Sticker\228\184\138\230\156\170\229\140\133\229\144\171RawImage\231\187\132\228\187\182\239\188\129")
      return
    end
    stickerRawImage.material = mat
    self.isMatLoaded = true
    self:RefreshImgColorAlpha(stickerRawImage)
    self:SetSpecialStickerShow(key, rowCfg, chatData)
  else
    ChatManager2:GetInstance().Room:RecycleUnusedMat(key, mat)
  end
end

function ChatItemPost_Sticker:SetSpecialStickerShow(key, rowCfg, chatData)
  if rowCfg.id == 5 then
    local diceTimer = TimerManager:GetInstance():DelayInvoke(function()
      ChatManager2:GetInstance().Room:ClearStickerDiceData(key)
      local goStickerDynamic = ChatManager2:GetInstance().Room:GetStickerNodeDic(key)
      if goStickerDynamic then
        local stickerRawImage = goStickerDynamic:GetComponent(UnityImage)
        if IsNull(stickerRawImage) then
          Logger.LogError("\233\170\176\229\173\144\232\161\168\230\131\133\229\128\146\232\174\161\230\151\182\231\187\147\230\157\159\229\144\142\239\188\140\229\189\147\229\137\141Sticker\228\184\138\230\156\170\229\140\133\229\144\171RawImage\231\187\132\228\187\182\239\188\129")
          return
        end
        local stickerMat = ChatManager2:GetInstance().Room:GetStickerMat(key)
        if not stickerMat then
          Logger.LogError("\233\170\176\229\173\144\232\161\168\230\131\133\229\128\146\232\174\161\230\151\182\231\187\147\230\157\159\229\144\142\239\188\140\228\184\141\229\173\152\229\156\168\229\175\185\229\186\148\230\157\144\232\180\168\239\188\129")
          return
        end
        stickerMat:EnableKeyword("_FULLIMAGE_ON")
        self:SetStickerSprite(stickerRawImage, rowCfg, chatData)
      end
    end, rowCfg.frame_rate / ChatStickerPlaySpeed)
    ChatManager2:GetInstance().Room:SetStickerDiceDataDic(key, diceTimer, chatData)
  end
end

return ChatItemPost_Sticker
