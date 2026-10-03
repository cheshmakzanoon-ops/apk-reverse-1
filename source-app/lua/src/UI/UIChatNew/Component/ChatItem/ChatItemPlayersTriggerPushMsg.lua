local IChatItem = require("UI.UIChatNew.Component.ChatItem.IChatItem")
local ChatItemPlayersTriggerPushMsg = BaseClass("ChatItemPlayersTriggerPushMsg", IChatItem)
local base = IChatItem
local rapidjson = require("rapidjson")
local ui_player_head_path = "Content/UIPlayerHead"
local player_name_text_path = "Content/PlayerNameText"
local des_text_path = "Content/DesText"
local btn_path = "Content/Btn"
local event_icon_path = "Content/eventIcon"
local ICON_ASSET_PATH = "Assets/Main/Sprites/UI/LWChat_v2/DefaultSkin/ChatItems/%s.png"
local BG_DEFAULT_PAth = "Assets/Main/TextureEx/UILWRadarCenter/mjc_liaotian_jinli_bg01.png"
local DataDic = {
  [PostType.ZONE_MOBILIZATION_AL_RES_CREATE] = {
    {
      DescDialogId = "zone_mobilization_donated_resource_chat",
      PastDueDialogId = "zone_mobilization_donated_resource_chat_expired",
      IconPath = "wxy_xiusai_wuziqipao_big",
      BgPath = BG_DEFAULT_PAth
    },
    {
      DescDialogId = "zone_mobilization_donated_resource_chat_small",
      PastDueDialogId = "zone_mobilization_donated_resource_chat_expired",
      IconPath = "zxl_xiusai_wuziqipao_big",
      BgPath = BG_DEFAULT_PAth
    }
  },
  [PostType.ZONE_MOBILIZATION_SUPPLIES_CREATE] = {
    {
      DescDialogId = "zone_mobilization_donated_supplies_chat",
      PastDueDialogId = "zone_mobilization_donated_supplies_chat_expired",
      IconPath = "wxy_xiusai_wuziqipao_02_big",
      BgPath = BG_DEFAULT_PAth
    },
    {
      DescDialogId = "zone_mobilization_donated_supplies_chat_small",
      PastDueDialogId = "zone_mobilization_donated_supplies_chat_expired",
      IconPath = "zxl_xiusai_wuziqipao_02_big",
      BgPath = BG_DEFAULT_PAth
    }
  },
  [PostType.ZONE_MOBILIZATION_SUPPLIES_TRIGGER_RED] = {
    DescDialogId = "zone_mobilization_supplies_red_share",
    IconPath = "zxl_saiji_baoxiang_hong",
    BgPath = BG_DEFAULT_PAth
  },
  [PostType.S0_ALLIANCE_BOSS_GIFT_REWARD] = {
    DescDialogId = "s0_alliance_boss_fireworks_desc",
    BgPath = "Assets/Main/TextureEx/UIS0AllianceBoss/lrb_TMDJ_liaotian_jiangli_bg.png"
  }
}

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.bg = self:AddComponent(UIRawImage, "Content")
  self.ui_player_head = self:AddComponent(UICommonHead, ui_player_head_path)
  self.player_name_text = self:AddComponent(UITextMeshProUGUIEx, player_name_text_path)
  self.des_text = self:AddComponent(UITextMeshProUGUIEx, des_text_path)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(function()
    self:BtnClick()
  end)
  self.event_icon = self:AddComponent(UIImage, event_icon_path)
end

local function ComponentDestroy(self)
  self.bg = nil
  self.ui_player_head = nil
  self.player_name_text = nil
  self.des_text = nil
  self.btn = nil
  self.event_icon = nil
end

local function DataDefine(self)
  self._chatData = nil
  self.seqId = nil
  self.roomId = nil
  self.data = nil
  self.playersData = {}
  self.clientUpdateExtra = nil
end

local function DataDestroy(self)
  self._chatData = nil
  self.seqId = nil
  self.roomId = nil
  self.data = nil
  self.playersData = nil
  self.clientUpdateExtra = nil
end

local function UpdateItem(self, chatData)
  self._chatData = chatData
  self.seqId = chatData:getSeqId()
  self.roomId = chatData.roomId
  local data
  if chatData and chatData.extra and chatData.extra.customJsonParam then
    data = rapidjson.decode(chatData.extra.customJsonParam)
    self.clientUpdateExtra = chatData.clientUpdateExtra
  else
    return
  end
  self.data = data
  if data == nil then
    return
  end
  self:SetPlayerData(data)
  local post = chatData.post
  local d = DataDic[post]
  if d == nil then
    return
  end
  self:SetConfigData(d)
end

local function SetConfigData(self, data)
  if data == nil then
    return
  end
  if data.DescDialogId then
    self.des_text:SetLocalText(data.DescDialogId)
  end
  if data.BgPath then
    self.bg:LoadSpriteAuto(data.BgPath)
  end
  if data.IconPath then
    self.event_icon:LoadSpriteAuto(string.format(ICON_ASSET_PATH, data.IconPath))
    self.event_icon:SetNativeSize()
  end
end

local function SetPlayerData(self, jsonObj)
  if jsonObj and jsonObj and jsonObj.playerInfo then
    local playerInfo = jsonObj.playerInfo
    local name = ""
    if playerInfo.name then
      name = playerInfo.name
    end
    local uid
    if playerInfo.uid then
      uid = playerInfo.uid
    end
    local showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(uid, name)
    self.player_name_text:SetText(showName)
    local pic = ""
    local picVer = 0
    local headSkinId, headSkinET
    if playerInfo.headPic then
      pic = playerInfo.headPic
    end
    if playerInfo.headPicVer then
      picVer = playerInfo.headPicVer
    end
    if playerInfo.headSkinId then
      headSkinId = playerInfo.headSkinId
    end
    if playerInfo.headSkinET then
      headSkinET = playerInfo.headSkinET
    end
    self.ui_player_head:SetHeadAndFrame(uid, pic, picVer, nil, headSkinId, headSkinET)
    self.ui_player_head:SetEnableClickShowInfo(false, false)
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(ChatEventEnum.CHAT_ROOM_ONEMSG_UPDATA, self.OnUpdateMsg)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(ChatEventEnum.CHAT_ROOM_ONEMSG_UPDATA, self.OnUpdateMsg)
  base.OnRemoveListener(self)
end

local function OnUpdateMsg(self, chatData)
  if chatData and chatData.seqId == self.seqId and chatData.roomid == self.roomId then
    local roomData = ChatManager2:GetInstance().Room:GetRoomData(self.roomId)
    if roomData then
      chatData = roomData:getChatDataBySeqId(self.seqId)
      if chatData and chatData.post == PostType.ZOMBIE_RUSH_ELITE_BOSS_ATTACK then
        self:UpdateData(chatData)
      end
    end
  end
end

local function UpdateData(self, chatData)
  if chatData then
    self._chatData = chatData
    self.data = rapidjson.decode(chatData.extra.customJsonParam)
    self.clientUpdateExtra = chatData.clientUpdateExtra
  end
end

local function BtnClick(self)
  if not LuaEntry.Player:IsInSelfServer() then
    UIUtil.ShowTipsId("server_tips_002")
    return
  end
  if self._chatData and self.data then
    if self.clientUpdateExtra == "expire" then
      UIUtil.ShowTipsId(DataDic[self._chatData.post].PastDueDialogId)
      return
    end
    if self.data.pointId and self.data.pointId > 0 then
      local point = self.data.pointId
      local serverId = self.data.serverId
      if serverId == nil or serverId <= 0 then
        serverId = LuaEntry.Player:GetSourceServerId()
      end
      GoToUtil.CloseAllWindows()
      local pos = SceneUtils.TileIndexToWorld(point)
      GoToUtil.GotoWorldPos(pos, nil, nil, nil, serverId)
    else
      Logger.LogError("the point is invalid")
    end
  end
end

ChatItemPlayersTriggerPushMsg.OnCreate = OnCreate
ChatItemPlayersTriggerPushMsg.OnDestroy = OnDestroy
ChatItemPlayersTriggerPushMsg.ComponentDefine = ComponentDefine
ChatItemPlayersTriggerPushMsg.ComponentDestroy = ComponentDestroy
ChatItemPlayersTriggerPushMsg.DataDefine = DataDefine
ChatItemPlayersTriggerPushMsg.DataDestroy = DataDestroy
ChatItemPlayersTriggerPushMsg.UpdateItem = UpdateItem
ChatItemPlayersTriggerPushMsg.OnAddListener = OnAddListener
ChatItemPlayersTriggerPushMsg.OnRemoveListener = OnRemoveListener
ChatItemPlayersTriggerPushMsg.OnUpdateMsg = OnUpdateMsg
ChatItemPlayersTriggerPushMsg.BtnClick = BtnClick
ChatItemPlayersTriggerPushMsg.SetPlayerData = SetPlayerData
ChatItemPlayersTriggerPushMsg.SetConfigData = SetConfigData
ChatItemPlayersTriggerPushMsg.UpdateData = UpdateData
return ChatItemPlayersTriggerPushMsg
