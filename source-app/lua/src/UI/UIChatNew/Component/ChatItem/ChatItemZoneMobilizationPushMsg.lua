local ChatItemPlayersTriggerPushMsg = require("UI.UIChatNew.Component.ChatItem.ChatItemPlayersTriggerPushMsg")
local ChatItemZoneMobilizationPushMsg = BaseClass("ChatItemZoneMobilizationPushMsg", ChatItemPlayersTriggerPushMsg)
local base = ChatItemPlayersTriggerPushMsg
local ICON_ASSET_PATH = "Assets/Main/Sprites/UI/LWChat_v2/DefaultSkin/ChatItems/%s.png"

local function OnCreate(self)
  base.OnCreate(self)
end

local function OnDestroy(self)
  base.OnDestroy(self)
end

local function SetConfigData(self, data)
  if data == nil then
    return
  end
  if self._chatData.post == PostType.ZONE_MOBILIZATION_AL_RES_CREATE then
    local configId = self.data.buildId
    if configId then
      local line = LocalController:instance():tryGetLine(TableName.AllianceMine, configId)
      if line then
        local special_flag = line.special_flag
        local index = tonumber(special_flag) == 1 and 2 or 1
        local d = data[index]
        self.des_text:SetLocalText(d.DescDialogId)
        self.event_icon:LoadSprite(string.format(ICON_ASSET_PATH, d.IconPath))
        self.event_icon:SetNativeSize()
      end
    end
  elseif self._chatData.post == PostType.ZONE_MOBILIZATION_SUPPLIES_CREATE then
    local configId = self.data.cfgId
    if configId then
      local line = LocalController:instance():tryGetLine(TableName.LWIceSupplies, configId)
      if line then
        local index = line.type == WorldSuppliesType.ZoneMobilizationType and 1 or 2
        local d = data[index]
        self.des_text:SetLocalText(d.DescDialogId)
        self.event_icon:LoadSprite(string.format(ICON_ASSET_PATH, d.IconPath))
        self.event_icon:SetNativeSize()
      end
    end
  end
  if data.BgPath then
    self.bg:LoadSprite(data.BgPath)
  end
end

ChatItemZoneMobilizationPushMsg.OnCreate = OnCreate
ChatItemZoneMobilizationPushMsg.OnDestroy = OnDestroy
ChatItemZoneMobilizationPushMsg.SetConfigData = SetConfigData
return ChatItemZoneMobilizationPushMsg
