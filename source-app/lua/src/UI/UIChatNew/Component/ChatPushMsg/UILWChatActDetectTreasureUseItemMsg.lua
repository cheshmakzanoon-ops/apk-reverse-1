local base = require("UI.UIChatNew.Component.ChatItem.IChatItem")
local UILWChatActDetectTreasureUseItemMsg = BaseClass("UILWChatActDetectTreasureUseItemMsg", base)
local rapidjson = require("rapidjson")
local base64 = require("Framework.Common.base64")
local hasIconWidth = 540
local notIconWidth = 590
local hight = 60
local ui_player_head_path = "Content/UIPlayerHead"
local player_name_text_path = "Content/PlayerNameText"
local des_text_path = "Content/DesText"
local btn_path = "Content/Btn"
local defPath = "Assets/Main/TextureEx/UILWRadarCenter/mjc_liaotian_jinli_bg01.png"
local event_icon_path = "Content/eventIcon"

function UILWChatActDetectTreasureUseItemMsg:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UILWChatActDetectTreasureUseItemMsg:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWChatActDetectTreasureUseItemMsg:ComponentDefine()
  self.ui_player_head = self:AddComponent(UICommonHead, ui_player_head_path)
  self.player_name_text = self:AddComponent(UITextMeshProUGUIEx, player_name_text_path)
  self.des_text = self:AddComponent(UITextMeshProUGUIEx, des_text_path)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.bg = self:AddComponent(UIRawImage, "Content")
  self.btn:SetOnClick(function()
    self:BtnClick()
  end)
  self.event_icon = self:AddComponent(UIImage, event_icon_path)
end

function UILWChatActDetectTreasureUseItemMsg:ComponentDestroy()
  self.ui_player_head = nil
  self.player_name_text = nil
  self.des_text = nil
  self.btn = nil
  self.event_icon = nil
end

function UILWChatActDetectTreasureUseItemMsg:UpdateItem(_chat_data, _index)
  self._chatData = _chat_data
  self.des_text:SetLocalText("activity_sports_uitips_023")
  self.bg:LoadSprite(defPath)
  if _chat_data and _chat_data.extra and _chat_data.extra.customJsonParam then
    local jsonObj = rapidjson.decode(_chat_data.extra.customJsonParam)
    if jsonObj and jsonObj and jsonObj.eventId then
      local eventId = jsonObj.eventId
      local template = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(eventId)
      if template then
        local digIcon
        if template.type == DetectEventType.TREASURE_ACTIVITY or template.type == DetectEventType.OFF_SEASON_TREASURE then
          digIcon = template.icon
          self.des_text:SetLocalText(template.chat_share_text)
        end
        if not string.IsNullOrEmpty(template.icon_custom) then
          self.event_icon:LoadSprite(template.icon_custom)
        else
          self.event_icon:LoadSprite(string.format(LoadPath.RadarCenterPath, digIcon))
        end
        self.event_icon:SetNativeSize()
      end
      local ownerName = ""
      if jsonObj and jsonObj.owner then
        ownerName = jsonObj.owner.name
      end
      local showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(jsonObj.owner.uid, ownerName)
      self.player_name_text:SetText(showName)
      local uid
      local pic = ""
      local picVer = 0
      local headSkinId, headSkinET
      if jsonObj and jsonObj.owner then
        local ownerData = jsonObj.owner
        if ownerData.headPic then
          pic = ownerData.headPic
        end
        if ownerData.headPicVer then
          picVer = ownerData.headPicVer
        end
        if ownerData.headSkinId then
          headSkinId = ownerData.headSkinId
        end
        if ownerData.headSkinET then
          headSkinET = ownerData.headSkinET
        end
        if ownerData.uid then
          uid = ownerData.uid
        end
        self.ui_player_head:SetHeadAndFrame(uid, pic, picVer, nil, headSkinId, headSkinET)
        self.ui_player_head:SetEnableClickShowInfo(true, true)
      end
    end
  end
end

function UILWChatActDetectTreasureUseItemMsg:BtnClick()
  local isInNineNationTruceMode = UIUtil.IsInNineNationTruceMode()
  if not isInNineNationTruceMode and not UIUtil.CheckDetectCanCrossServer() and not LuaEntry.Player:IsInSelfServer() then
    UIUtil.ShowTipsId("server_tips_002")
    return
  end
  if self._chatData ~= nil and self._chatData and self._chatData.extra and self._chatData.extra.customJsonParam then
    local jsonObj = rapidjson.decode(self._chatData.extra.customJsonParam)
    if jsonObj and jsonObj.uuid then
      local uuid = jsonObj.uuid
      local targetServer = jsonObj.targetServer
      SFSNetwork.SendMessage(MsgDefines.DetectEventGetTreasureClaimInfo, uuid, nil, targetServer)
      PostEventLog.Track(PostEventLog.Defines.ActRadarTreasureUseItemMsgClick, {})
    end
  end
end

return UILWChatActDetectTreasureUseItemMsg
