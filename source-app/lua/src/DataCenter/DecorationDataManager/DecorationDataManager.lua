local DecorationDataManager = BaseClass("DecorationDataManager")
local DecorationData = require("DataCenter.DecorationDataManager.DecorationData")
local Localization = CS.GameEntry.Localization
local Setting = CS.GameEntry.Setting
local map_stickers_showData = {
  {
    emptyMarkPath = "ljq_daditubiaoqing_qipao_kong_02",
    markPath = "ljq_daditubiaoqing_qipao_02"
  },
  {
    emptyMarkPath = "ljq_daditubiaoqing_qipao_kong_03",
    markPath = "ljq_daditubiaoqing_qipao_03"
  },
  {
    emptyMarkPath = "ljq_daditubiaoqing_qipao_kong_05",
    markPath = "ljq_daditubiaoqing_qipao_05"
  },
  {
    emptyMarkPath = "ljq_daditubiaoqing_qipao_kong_02",
    markPath = "ljq_daditubiaoqing_qipao_02"
  },
  {
    emptyMarkPath = "ljq_daditubiaoqing_qipao_kong_04",
    markPath = "ljq_daditubiaoqing_qipao_04"
  },
  {
    emptyMarkPath = "ljq_daditubiaoqing_qipao_kong_05",
    markPath = "ljq_daditubiaoqing_qipao_05"
  }
}
local maxStickerCount = 6
local stickerDefStr = "-1,-1,-1,-1,-1,-1"

local function __init(self)
  self.allDecoration = {}
  self:AddListener()
end

local function __delete(self)
  self.allDecoration = {}
  self:RemoveListener()
end

local function AddListener(self)
  EventManager:GetInstance():AddListener(EventId.ChangeSex, self.DoWhenCitySkinChange)
end

local function RemoveListener(self)
  EventManager:GetInstance():RemoveListener(EventId.ChangeSex, self.DoWhenCitySkinChange)
end

local function DoWhenCitySkinChange(self)
  local mainBuild = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_MAIN)
  if mainBuild then
    EventManager:GetInstance():Broadcast(EventId.UserCitySkinUpdate, mainBuild.uuid)
  end
end

local function IsSystemOpen(self)
  local configOpenState = LuaEntry.DataConfig:CheckSwitch("decoration_switch")
  if not configOpenState then
    return false
  end
  local openLv = 1
  openLv = LuaEntry.DataConfig:TryGetNum("decoration_para", "k1")
  local mainLv = DataCenter.BuildManager.MainLv
  local levelValid = openLv <= mainLv
  if levelValid then
    return true
  end
  for k, v in pairs(self.allDecoration) do
    if v ~= nil then
      local type = v.type
      if type == DecorationType.DecorationType_Head_Frame or type == DecorationType.DecorationType_Main_City or type == DecorationType.DecorationType_Main_Effect or type == DecorationType.DecorationType_TittleName or type == DecorationType.DecorationType_Chat_Bubble then
        local id = v.skinId
        if id and 0 < id then
          local template = DataCenter.DecorationTemplateManager:GetTemplate(id)
          if template and not template:IsDefault() then
            return true
          end
        end
      end
    end
  end
  return false
end

local function InitUserSkins(self, message)
  if message.userSkins then
    for _, v in ipairs(message.userSkins) do
      self:UpdateOnUserSkin(v)
      local wear = v.wear
      local type = v.type
      local skinId = v.skinId
      if type == DecorationType.DecorationType_Main_City and wear == 1 then
        EventManager:GetInstance():Broadcast(EventId.BaseSkinIdChange, skinId)
      end
    end
  end
end

local function UpdateOnUserSkin(self, data)
  local skinId = data.skinId
  if self.allDecoration[skinId] == nil then
    self.allDecoration[skinId] = DecorationData.New()
  end
  self.allDecoration[skinId]:ParseData(data)
  self:RefreshUserSkinCache()
end

local function RefreshUserSkinCache()
  local curNameColorId = DataCenter.DecorationDataManager:GetWearingNameColorSkinId()
  local userInfo = ChatInterface.getUserData(LuaEntry.Player.uid)
  if userInfo then
    userInfo:SetGoldNameSkinId(curNameColorId)
  end
end

local function GetSkinDataById(self, skinId)
  return self.allDecoration[skinId]
end

local function CovertSkin(self, skinId, index)
  SFSNetwork.SendMessage(MsgDefines.CoverSkin, skinId, index)
end

local function CovertSkinHandler(self, message)
  if message.errorCode ~= nil then
    local errorCode = message.errorCode
    if errorCode ~= SeverErrorCode then
      UIUtil.ShowTips(Localization:GetString(message.errorCode))
    end
    return
  end
  UIUtil.ShowTipsId(120120)
  if message.skin then
    self:UpdateOnUserSkin(message.skin)
    if toInt(message.skin.type) == DecorationType.DecorationType_Emoji then
      DataCenter.ChatEmojiTemplateManager:SetDecorationMapStickerData()
    end
    EventManager:GetInstance():Broadcast(EventId.UserSkinUpdate, toInt(message.skin.type))
    if message.skin.skinId and message.skin.type ~= DecorationType.DecorationType_Emoji then
      DataCenter.DecorationDataManager:WearSkin(message.skin.skinId)
    end
  end
end

local function PushSkinUpdateHandler(self, message)
  if message.errorCode ~= nil then
    local errorCode = message.errorCode
    if errorCode ~= SeverErrorCode then
      UIUtil.ShowTips(Localization:GetString(message.errorCode))
    end
    return
  end
  if message.skins then
    local isHaveMapSticker = false
    for _, v in ipairs(message.skins) do
      self:UpdateOnUserSkin(v)
      if v.type == DecorationType.DecorationType_Head_Frame then
        EventManager:GetInstance():Broadcast(EventId.UpdatePlayerHeadIcon)
      elseif v.type == DecorationType.DecorationType_Main_City then
        self:DoWhenCitySkinChange()
      elseif v.type == DecorationType.DecorationType_Emoji then
        isHaveMapSticker = true
      end
    end
    if isHaveMapSticker then
      DataCenter.ChatEmojiTemplateManager:SetDecorationMapStickerData()
    end
    EventManager:GetInstance():Broadcast(EventId.UserSkinUpdate)
  end
  if message.lastUpdateTime then
    LuaEntry.Player:SetLastUpdateTime(message.lastUpdateTime)
  end
end

local function WearSkin(self, skinId)
  SFSNetwork.SendMessage(MsgDefines.WearSkin, skinId)
end

local function WearSkinHandler(self, message)
  if message.errorCode ~= nil then
    local errorCode = message.errorCode
    if errorCode ~= SeverErrorCode then
      UIUtil.ShowTips(Localization:GetString(message.errorCode))
    end
    return
  end
  if message.oldSkinId then
    local skinData = self:GetSkinDataById(toInt(message.oldSkinId))
    if skinData then
      skinData:SetIsWear(false)
    end
  end
  if message.skinId then
    local skinData = self:GetSkinDataById(toInt(message.skinId))
    if skinData then
      skinData:SetIsWear(true)
      EventManager:GetInstance():Broadcast(EventId.UserSkinUpdate, skinData.type)
      if skinData.type == DecorationType.DecorationType_Main_City then
        self:DoWhenCitySkinChange()
      end
      if skinData.type == DecorationType.DecorationType_Head_Frame then
        EventManager:GetInstance():Broadcast(EventId.UpdatePlayerHeadIcon)
      end
    end
  end
  if message.lastUpdateTime then
    LuaEntry.Player:SetLastUpdateTime(message.lastUpdateTime)
  end
end

local function TakeOffSkin(self, skinId)
  SFSNetwork.SendMessage(MsgDefines.TakeOffSkin, skinId)
end

local function TakeOffSkinHandler(self, message)
  if message.errorCode ~= nil then
    local errorCode = message.errorCode
    if errorCode ~= SeverErrorCode then
      UIUtil.ShowTips(Localization:GetString(message.errorCode))
    end
    return
  end
  local skinData = self:GetSkinDataById(toInt(message.skinId))
  if skinData then
    skinData:SetIsWear(false)
    EventManager:GetInstance():Broadcast(EventId.UserSkinUpdate, skinData.type)
    if skinData.type == DecorationType.DecorationType_Main_City then
      self:DoWhenCitySkinChange()
    end
    if skinData.type == DecorationType.DecorationType_Head_Frame then
      EventManager:GetInstance():Broadcast(EventId.UpdatePlayerHeadIcon)
    end
  end
  if message.lastUpdateTime then
    LuaEntry.Player:SetLastUpdateTime(message.lastUpdateTime)
  end
end

local function GetCurrentSkinByType(self, type, original)
  if type == DecorationType.DecorationType_Emoji then
    return nil
  end
  local allTemplate = DataCenter.DecorationTemplateManager:GetTypeDecorations(type)
  local defaultId
  for _, v in pairs(allTemplate) do
    local template = DataCenter.DecorationTemplateManager:GetTemplate(v)
    if template ~= nil then
      if template:IsDefault() then
        defaultId = template.id
      end
      local data = self:GetSkinDataById(template.id)
      local skinId = data and data:GetActiveSkinId(original, true)
      if skinId and 0 < skinId then
        return skinId
      end
    end
  end
  return defaultId
end

local function GetHeadFrame(self, headSkinId, headSkinET)
  if not self:IsSystemOpen() then
    return DefaultHeadFramePath
  end
  if headSkinId == nil then
    return nil
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  if headSkinET ~= nil and headSkinET ~= 0 and headSkinET <= now then
    return nil
  end
  local template = DataCenter.DecorationTemplateManager:GetTemplate(headSkinId)
  if template == nil then
    return nil
  end
  return template.img
end

local function GetChatBubbleAndMsgColor(self, chatBubbleId, chatBubbleET)
  local color = ChatUIThemeConfig.TextColor[ChatInterface.GetChatTheme()]
  local replyColor = ChatUIThemeConfig.TextReplyColor[ChatInterface.GetChatTheme()]
  if not self:IsSystemOpen() then
    return DefaultChatBubblePath, color, replyColor
  end
  if chatBubbleId == nil then
    return nil
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  if chatBubbleET ~= nil and chatBubbleET ~= 0 and chatBubbleET <= now then
    return nil
  end
  local template = DataCenter.DecorationTemplateManager:GetTemplate(chatBubbleId)
  if template == nil then
    return nil
  end
  if template.type ~= DecorationType.DecorationType_Chat_Bubble then
    Logger.LogError("GetChatBubbleAndMsgColor Error! template.type invalid\239\188\154" .. tostring(template.type))
    return nil
  end
  local color = string.split(template.customVariable, "|")
  local txtColor, replyColor
  if not string.IsNullOrEmpty(color[1]) then
    local varArr = string.split(color[1], ",")
    txtColor = Color.New(tonumber(varArr[1]), tonumber(varArr[2]), tonumber(varArr[3]), 1)
  end
  if not string.IsNullOrEmpty(color[2]) then
    local varArr = string.split(color[2], ",")
    replyColor = Color.New(tonumber(varArr[1]), tonumber(varArr[2]), tonumber(varArr[3]), 1)
  end
  return template.img, txtColor, replyColor
end

local function GetSelfHeadFrame(self)
  if self:IsSystemOpen() then
    for k, v in pairs(self.allDecoration) do
      if v ~= nil and v.type == DecorationType.DecorationType_Head_Frame and v:IsWear() then
        return self:GetHeadFrame(v.skinId, v.expireTime)
      end
    end
    return nil
  end
  local headBgImg
  local golloesHeadBg = DataCenter.MonthCardNewManager:GetGolloesHeadBg()
  if golloesHeadBg and golloesHeadBg ~= "" then
    headBgImg = golloesHeadBg
  end
  if headBgImg and headBgImg ~= "" then
    return string.format(LoadPath.CommonNewPath, headBgImg)
  end
  return nil
end

local function GetSelfHeadFrameAndET(self)
  if self:IsSystemOpen() then
    for k, v in pairs(self.allDecoration) do
      if v ~= nil and v.type == DecorationType.DecorationType_Head_Frame and v:IsWear() then
        return v.skinId, v.expireTime
      end
    end
    return nil, nil
  end
  return nil, nil
end

local function GetSelfChatBubbleAndMsgColor(self)
  if self:IsSystemOpen() then
    if not self.allDecoration then
      return
    end
    for k, v in pairs(self.allDecoration) do
      if v ~= nil and v.type == DecorationType.DecorationType_Chat_Bubble and v:IsWear() then
        return self:GetChatBubbleAndMsgColor(v.skinId, v.expireTime)
      end
    end
  end
  return nil
end

local function SetNewItemFlag(self, itemId)
  if not self:IsSystemOpen() then
    return
  end
  Setting:SetPrivateInt("decoration_item_flag_" .. LuaEntry.Player.uid .. tostring(itemId), 1)
end

local function GetNewItemFlag(self, itemId)
  Setting:GetPrivateInt("decoration_item_flag_" .. LuaEntry.Player.uid .. tostring(itemId), 0)
end

local function IsNewDecorationItem(self, itemId)
  if not self:IsSystemOpen() then
    return false
  end
  local allItems = DataCenter.DecorationTemplateManager:GetDecorationItem()
  if allItems ~= nil and allItems[itemId] ~= nil then
    local flag = self:GetNewItemFlag(itemId)
    return flag == 1
  end
  return false
end

local function GetAllActiveDecoration(self)
  local result = {}
  for _, v in pairs(self.allDecoration) do
    if v ~= nil and v:IsInExpireTime() then
      table.insert(result, v.skinId)
    end
  end
  return result
end

local function GetDefaultSkinIdByType(self, type)
  local allTemplate = DataCenter.DecorationTemplateManager:GetTypeDecorations(type)
  local defaultId = -1
  for _, v in pairs(allTemplate) do
    local template = DataCenter.DecorationTemplateManager:GetTemplate(v)
    if template ~= nil and template:IsDefault() then
      defaultId = template.id
      return defaultId
    end
  end
  if defaultId < 0 then
    Logger.Log("\230\156\170\230\159\165\230\137\190\229\136\176\233\187\152\232\174\164ID")
  end
  return defaultId
end

local function GetCityBuildingDecoration(self)
  local skinId = self:GetCurrentSkinByType(DecorationType.DecorationType_Main_City)
  if skinId == nil then
    return nil
  end
  local template = DataCenter.DecorationTemplateManager:GetTemplate(skinId)
  if template == nil or template:IsDefault() then
    return nil
  end
  return template.model
end

function DecorationDataManager:GetWorldBuildingDecoration()
  return self:GetWorldBuildingSkinPath(self:GetCurrentSkinByType(DecorationType.DecorationType_Main_City))
end

function DecorationDataManager:GetWorldBuildingSkinWithDefault(skinId, mainLevel, useDefault_)
  local template = DataCenter.DecorationTemplateManager:GetTemplate(skinId)
  if template and template:IsDefault() then
    return BuildingUtils.GetWorldBuildingModelName(BuildingTypes.FUN_BUILD_MAIN, mainLevel or DataCenter.BuildManager.MainLv, useDefault_)
  end
  return DataCenter.DecorationDataManager:GetWorldBuildingSkinPath(skinId)
end

function DecorationDataManager:GetWorldBuildingSkinPath(skinId)
  if skinId == nil then
    return nil
  end
  local template = DataCenter.DecorationTemplateManager:GetTemplate(skinId)
  if template == nil or template:IsDefault() then
    return nil
  end
  return template.model_world
end

function DecorationDataManager:GetSelfHeadFrameId()
  if self:IsSystemOpen() then
    for k, v in pairs(self.allDecoration) do
      if v ~= nil and v.type == DecorationType.DecorationType_Head_Frame and v:IsActiveWear() then
        return v.skinId
      end
    end
    return nil
  end
  return nil
end

function DecorationDataManager:GetOwnTacticalWeaponSkin()
  local decorationIds = {}
  for k, v in pairs(self.allDecoration) do
    if v ~= nil and v.type == DecorationType.DecorationType_TacticalWeapon and v:IsInExpireTime() then
      table.insert(decorationIds, v.skinId)
    end
  end
  return decorationIds
end

function DecorationDataManager:GetWearingNameColorSkinId()
  for _, v in pairs(self.allDecoration) do
    if v ~= nil and v:GetDecorationType() == DecorationType.DecorationType_ChatNameColor and v:IsInExpireTime() and v:IsWear() then
      return v:GetSkinId()
    end
  end
  return 0
end

function DecorationDataManager:IsGoldName(skinId)
  return skinId == 70001 or skinId == 70002 or skinId == 70003
end

function DecorationDataManager:IsUnlock(skinId)
  local template = DataCenter.DecorationTemplateManager:GetTemplate(skinId)
  if template == nil then
    return false
  end
  if template:IsDefault() then
    return true
  end
  local skinData = self.allDecoration[skinId]
  if skinData then
    return skinData:IsInExpireTime()
  elseif template.type == DecorationType.DecorationType_Emoji then
    local isUnLock = DataCenter.StickerWithDecorationLinkManager:CheckIsUnlockByDecoId(skinId)
    if isUnLock then
      return true
    end
  end
  return false
end

function DecorationDataManager:IsOtherUnlock(skinId, disPlaySkinArr)
  local template = skinId and DataCenter.DecorationTemplateManager:GetTemplate(skinId)
  if template == nil then
    return false
  end
  if template:IsDefault() then
    return true
  end
  if disPlaySkinArr == nil then
    return false
  end
  for _, v in ipairs(disPlaySkinArr) do
    if v.skinId == skinId then
      if v.expireTime <= 0 then
        return true
      end
      return UITimeManager:GetInstance():GetServerTime() < v.expireTime
    end
  end
  return false
end

function DecorationDataManager:SaveStickerData(stickerStr)
  CommonUtil.PlayerPrefsSetString("mapStickers", stickerStr)
  EventManager:GetInstance():Broadcast(EventId.DecorationSetMapSticker)
end

function DecorationDataManager:GetDefaultStickerStr()
  local allTemplate = DataCenter.DecorationTemplateManager:GetDefaultDecorationsByType(DecorationType.DecorationType_Emoji)
  if not allTemplate then
    return stickerDefStr
  end
  local str = ""
  local id
  for i = 1, maxStickerCount do
    id = allTemplate[i] or -1
    str = string.IsNullOrEmpty(str) and id or str .. "," .. id
  end
  if string.IsNullOrEmpty(str) then
    return stickerDefStr
  end
  return str
end

function DecorationDataManager:GetSaveStickerStr()
  local str = CommonUtil.PlayerPrefsGetString("mapStickers", "")
  if string.IsNullOrEmpty(str) then
    str = self:GetDefaultStickerStr()
    self:SaveStickerData(str)
  end
  return str
end

function DecorationDataManager:GetStickerData()
  local str = self:GetSaveStickerStr()
  str = string.split(str, ",")
  local index, isUnLocak
  for i = 1, #str do
    index = tonumber(str[i])
    isUnLocak = DataCenter.DecorationDataManager:IsUnlock(index)
    if isUnLocak then
      str[i] = index
    else
      str[i] = -1
    end
  end
  return str
end

function DecorationDataManager:GetStickerPlaneIndex()
  local stickers = self:GetStickerData()
  local initIndex = 1
  for i = 1, #stickers do
    if stickers[i] == -1 then
      return i
    end
  end
  return initIndex
end

function DecorationDataManager:GetDecorationSkillIdList(decorationId, hideSeasonSkill_)
  if decorationId == nil then
    return {}
  end
  local template = DataCenter.DecorationTemplateManager:GetTemplate(decorationId)
  if not template or template.type ~= DecorationType.DecorationType_Main_City or #template.skill_id_list <= 0 then
    return {}
  end
  local showSkillTempList = {}
  for i, skillId in ipairs(template.skill_id_list) do
    local skillTemp = DataCenter.DecorationSkillTemplateManager:GetTemplate(skillId)
    if skillTemp then
      table.insert(showSkillTempList, skillTemp)
    end
  end
  local showSkillIdList = {}
  for i, skillTemp in ipairs(showSkillTempList) do
    local isShow = true
    if self:IsSeasonSkinSkill(skillTemp) then
      if hideSeasonSkill_ then
        isShow = false
      end
      local seasonCallback = DataCenter.SeasonCallbackManager:GetConfigDataByCallbackId(SeasonCallbackType.Base, decorationId, true)
      if not seasonCallback then
        isShow = false
      end
    end
    if isShow then
      table.insert(showSkillIdList, skillTemp.id)
    end
  end
  return showSkillIdList
end

function DecorationDataManager:GetIfShowJumpToDecorationShop(decorationId, decorationType)
  local template = DataCenter.DecorationTemplateManager:GetTemplate(decorationId)
  if not template then
    return false
  end
  local switchOn = LuaEntry.DataConfig:CheckSwitch("decorationshop")
  if not switchOn then
    return false
  end
  local canJump = template.goto_buy and tonumber(template.goto_buy) == 1
  local isLock = not DataCenter.DecorationDataManager:IsUnlock(decorationId)
  local shopType = CommonShopType.DecorationShop
  local isSaleInShop = DataCenter.CommonShopManager:IsSaleInDecorationShop(decorationId, shopType)
  local haveItem = false
  if template.gainMethod then
    for k, v in ipairs(template.gainMethod) do
      local goodTemp = DataCenter.ItemTemplateManager:GetItemTemplate(v.id)
      if goodTemp and goodTemp.type == GOODS_TYPE.GOODS_TYPE_113 then
        local decoTime = tonumber(goodTemp.para2) or 0
        if decoTime <= 0 then
          local curNum = DataCenter.ItemData:GetItemCount(v.id)
          if curNum <= 0 then
            haveItem = true
            break
          end
        end
      end
    end
  end
  return canJump and isLock and isSaleInShop and haveItem
end

function DecorationDataManager:GetMapStickerUIData()
  return map_stickers_showData
end

function DecorationDataManager:IsSeasonSkinSkill(skillTemp)
  if not skillTemp then
    return false
  end
  if skillTemp.type == DecorationSkillType.Season or skillTemp.type == DecorationSkillType.SeasonMummy or skillTemp.type == DecorationSkillType.SeasonRainforest then
    return true
  end
  return false
end

function DecorationDataManager:GetCurrentSkinByTypeDebug(type)
  local allTemplate = DataCenter.DecorationTemplateManager:GetTypeDecorations(type)
  local defaultId
  for _, v in pairs(allTemplate) do
    local template = DataCenter.DecorationTemplateManager:GetTemplate(v)
    if template ~= nil then
      local data = self:GetSkinDataById(template.id)
      if data and data:IsActiveWear() then
        return template.id
      end
    end
  end
  return defaultId
end

DecorationDataManager.__init = __init
DecorationDataManager.__delete = __delete
DecorationDataManager.IsSystemOpen = IsSystemOpen
DecorationDataManager.InitUserSkins = InitUserSkins
DecorationDataManager.UpdateOnUserSkin = UpdateOnUserSkin
DecorationDataManager.CovertSkin = CovertSkin
DecorationDataManager.CovertSkinHandler = CovertSkinHandler
DecorationDataManager.WearSkin = WearSkin
DecorationDataManager.WearSkinHandler = WearSkinHandler
DecorationDataManager.TakeOffSkin = TakeOffSkin
DecorationDataManager.TakeOffSkinHandler = TakeOffSkinHandler
DecorationDataManager.GetSkinDataById = GetSkinDataById
DecorationDataManager.GetCurrentSkinByType = GetCurrentSkinByType
DecorationDataManager.PushSkinUpdateHandler = PushSkinUpdateHandler
DecorationDataManager.GetSelfHeadFrame = GetSelfHeadFrame
DecorationDataManager.GetSelfChatBubbleAndMsgColor = GetSelfChatBubbleAndMsgColor
DecorationDataManager.GetHeadFrame = GetHeadFrame
DecorationDataManager.GetChatBubbleAndMsgColor = GetChatBubbleAndMsgColor
DecorationDataManager.GetCityBuildingDecoration = GetCityBuildingDecoration
DecorationDataManager.IsNewDecorationItem = IsNewDecorationItem
DecorationDataManager.GetNewItemFlag = GetNewItemFlag
DecorationDataManager.SetNewItemFlag = SetNewItemFlag
DecorationDataManager.GetAllActiveDecoration = GetAllActiveDecoration
DecorationDataManager.AddListener = AddListener
DecorationDataManager.RemoveListener = RemoveListener
DecorationDataManager.DoWhenCitySkinChange = DoWhenCitySkinChange
DecorationDataManager.GetDefaultSkinIdByType = GetDefaultSkinIdByType
DecorationDataManager.RefreshUserSkinCache = RefreshUserSkinCache
DecorationDataManager.GetSelfHeadFrameAndET = GetSelfHeadFrameAndET
return DecorationDataManager
