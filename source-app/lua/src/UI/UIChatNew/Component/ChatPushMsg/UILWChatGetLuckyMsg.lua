local base = require("UI.UIChatNew.Component.ChatItem.IChatItem")
local UILWChatGetLuckyMsg = BaseClass("UILWChatGetLuckyMsg", base)
local Localization = CS.GameEntry.Localization
local rapidjson = require("rapidjson")

function UILWChatGetLuckyMsg:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UILWChatGetLuckyMsg:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWChatGetLuckyMsg:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compUIPlayerHead = self.viewSkin:AddComponent(self, UICommonHead, 1)
  self.textPlayerName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textDes = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.imgLuckIcon = self.viewSkin:AddComponent(self, UIImage, 4)
  self.btnClick = self.viewSkin:AddComponent(self, UIButton, 5)
  self.btnClick:SetOnClick(function()
    self:OnBtnClickClick()
  end)
  self.rawImgContent = self.viewSkin:AddComponent(self, UIRawImage, 6)
  if not IsNull(self.textDes.unity_tmpro) then
    function self.textDes.unity_tmpro.onPointerClick(eventData)
      self:OnPointerClick(eventData)
    end
  end
end

function UILWChatGetLuckyMsg:ComponentDestroy()
  self.viewSkin = nil
  self.compUIPlayerHead = nil
  self.textPlayerName = nil
  self.textDes = nil
  self.imgLuckIcon = nil
  self.btnClick = nil
  self.rawImgContent = nil
end

function UILWChatGetLuckyMsg:DataDefine()
end

function UILWChatGetLuckyMsg:DataDestroy()
end

function UILWChatGetLuckyMsg:OnAddListener()
  base.OnAddListener(self)
end

function UILWChatGetLuckyMsg:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWChatGetLuckyMsg:OnBtnClickClick()
  return
end

function UILWChatGetLuckyMsg:OnPointerClick(eventData)
  if not eventData then
    return
  end
  local clickPos = eventData.position
  local linkId = self.textDes:TryGetPointerClickLinkID(clickPos)
  if string.IsNullOrEmpty(linkId) then
    return
  end
  local status_config = DataCenter.StatusManager:GetTemplate(tonumber(linkId))
  if not status_config.icon or not status_config.description then
    return
  end
  local param = {}
  param.icon = status_config.icon
  param.descTip = Localization:GetString(status_config.description)
  param.screenPos = clickPos
  param.yPosFix = 40
  param.width = 460
  param.preferTop = false
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILuckyBuffTips, {anim = true}, param)
end

function UILWChatGetLuckyMsg:UpdateItem(_chat_data, _index)
  self._chatData = _chat_data
  if _chat_data and _chat_data.extra and _chat_data.extra.customJsonParam then
    local jsonObj = rapidjson.decode(_chat_data.extra.customJsonParam)
    if not jsonObj or not jsonObj.bigRewardInfo then
      return
    end
    local rewardInfo = jsonObj.bigRewardInfo
    local uid = rewardInfo.uid
    local playerName = rewardInfo.name
    local pic = ""
    local picVer = 0
    local headSkinId, headSkinET
    if rewardInfo.headPic then
      pic = rewardInfo.headPic
    end
    if rewardInfo.headPicVer then
      picVer = rewardInfo.headPicVer
    end
    if rewardInfo.headSkinId then
      headSkinId = rewardInfo.headSkinId
    end
    if rewardInfo.headSkinET then
      headSkinET = rewardInfo.headSkinET
    end
    local showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(uid, playerName)
    self.textPlayerName:SetText(showName)
    self.compUIPlayerHead:SetHeadAndFrame(uid, pic, picVer, nil, headSkinId, headSkinET)
    self.compUIPlayerHead:SetEnableClickShowInfo(true, true)
    if jsonObj.senderInfo then
      if jsonObj.packetId then
        local temp = DataCenter.RedPacketTemplateManager:GetTemplate(jsonObj.packetId)
        local desc_text = ""
        if jsonObj.senderInfo.uid == uid then
          desc_text = Localization:GetString(temp.mySendKey)
        else
          local senderName = jsonObj.senderInfo.name
          desc_text = Localization:GetString(temp.otherSendKey, senderName)
        end
        if jsonObj.luckSiphonConfigId and temp.type == RedPacketType.LuckyBuff then
          local lucky_config = DataCenter.LuckyBuffManager:GetLuckyConfigById(jsonObj.luckSiphonConfigId)
          local lucky_status_id = lucky_config.lw_status
          local modifiedText = desc_text
          if lucky_status_id then
            modifiedText = string.gsub(desc_text, "<color=", string.format("<link=%s><u><color=", lucky_status_id))
            modifiedText = string.gsub(modifiedText, "</color>", "</color></u></link>")
          end
          self.textDes:SetText(modifiedText)
        elseif temp.type == RedPacketType.LuckyWithoutBuff then
          self.textDes:SetText(desc_text)
        end
        self.rawImgContent:LoadSpriteAuto(temp.GetRawImgPath(temp.luky_pic))
      end
      self.btnClick:SetActive(false)
    end
  end
end

return UILWChatGetLuckyMsg
