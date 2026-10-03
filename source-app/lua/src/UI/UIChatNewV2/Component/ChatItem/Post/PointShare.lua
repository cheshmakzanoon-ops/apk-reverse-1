local IChatItemPost = require("UI.UIChatNewV2.Component.ChatItem.IChatItemPost")
local ChatItemPost_PointShare = BaseClass("ChatItemPost_PointShare", IChatItemPost)
local base = IChatItemPost
local rapidjson = require("rapidjson")
local UnityImage = typeof(CS.UnityEngine.UI.Image)
local _cp_chatShareTitle = "Image/ShareTitle"
local _cp_chatShareIcon = "Image/Icon"
local _cp_chatShareSpecialIcon = "Image/SpecialIcon"
local _cp_chatShareSubTitle = "Image/SubTitle"
local _cp_chatShareMsg = "ShareIconNode/ShareMsg/ShareMsg"
local _cp_chatShareMsgNode = "ShareIconNode/ShareMsg"
local _cp_chatShareStarRoot = "Image/starList"
local _cp_chatShare_starTemplate = "Image/starList/starTemplate"
local color_bg_path = "Image/starList/colorBg"
local color_icon_path = "Image/starList/colorBg/colorIcon"
local my_color_bg_path = "Image/starList/myColorBg"
local my_color_icon_path = "Image/starList/myColorBg/myColorIcon"

function ChatItemPost_PointShare:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function ChatItemPost_PointShare:OnAddListener()
  self:AddUIListener(EventId.ChatUserInfoUpdate, self.OnChatUserInfoUpdate)
end

function ChatItemPost_PointShare:OnRemoveListener()
  self:RemoveUIListener(EventId.ChatUserInfoUpdate, self.OnChatUserInfoUpdate)
end

function ChatItemPost_PointShare:ComponentDefine()
  self.bg = self:AddComponent(UIImage, "")
  self._chatShareTitle = self:AddComponent(UIText, _cp_chatShareTitle)
  self._chatShareSubTitle = self:AddComponent(UIText, _cp_chatShareSubTitle)
  self._chatShareIcon = self:AddComponent(UIImage, _cp_chatShareIcon)
  self._chatShareMsg = self:AddComponent(UITextMeshProUGUIEx, _cp_chatShareMsg)
  self._chatShareMsgNode = self:AddComponent(UIBaseContainer, _cp_chatShareMsgNode)
  self._chatShareSpecialIcon = self:AddComponent(UIImage, _cp_chatShareSpecialIcon)
  self._chatShareSpecialIcon:SetActive(false)
  self._chatShareStarRoot = self:AddComponent(UIBaseComponent, _cp_chatShareStarRoot)
  self._chatShareStarRoot:SetActive(false)
  self._starTemplate = self.transform:Find(_cp_chatShare_starTemplate).gameObject
  self._starTemplate:GameObjectCreatePool()
  self._starTemplate:SetActive(false)
  self.colorBg = self:AddComponent(UIBaseComponent, color_bg_path)
  self.colorIcon = self:AddComponent(UIImage, color_icon_path)
  self.colorBg:SetActive(false)
  self.myColorBg = self:AddComponent(UIBaseComponent, my_color_bg_path)
  self.myColorIcon = self:AddComponent(UIImage, my_color_icon_path)
  self.myColorBg:SetActive(false)
  self.starImg = self:AddComponent(UIBaseComponent, "Image/StarImg")
  self.posImg = self:AddComponent(UIBaseComponent, "Image/PosImg")
  self.starImg:SetActive(false)
  self.statusImg = self:AddComponent(UIImage, "StatusLayer/StatusIcon")
  self.statusText = self:AddComponent(UIText, "StatusLayer")
end

function ChatItemPost_PointShare:OnDestroy()
  if self._starTemplate then
    self._starTemplate:GameObjectRecycleAll()
  end
  base.OnDestroy(self)
end

function ChatItemPost_PointShare:OnLoaded()
  local chatdata = self:ChatData()
  if chatdata == nil then
    return
  end
  self._chatData = chatdata
  self:UpdateSharePoint()
end

function ChatItemPost_PointShare:OnChatUserInfoUpdate()
  if self.param and self.param.uid and self.param.posType == WorldPointUIType.City then
    local message = self._chatData:getMessageWithExtra(true)
    message = string.gsub(message, "[(]", "<u>(")
    message = string.gsub(message, "[)]", ")</u>")
    self._chatShareMsg:SetText(message)
  end
end

function ChatItemPost_PointShare:UpdateSharePoint()
  self._chatShareIcon:SetActive(false)
  self.starImg:SetActive(false)
  if self._chatShareSpecialIcon then
    self._chatShareSpecialIcon:SetActive(false)
  end
  if not string.IsNullOrEmpty(self._chatData.attachmentId) then
    self.param = rapidjson.decode(self._chatData.attachmentId)
  end
  local message = self._chatData:getMessageWithExtra(true)
  message = string.gsub(message, "[(]", "<u>(")
  message = string.gsub(message, "[)]", ")</u>")
  self._chatShareMsg:SetAlignment(CS.TMPro.TextAlignmentOptions.TopLeft)
  self._chatShareMsg:SetText(message)
  self._chatShareSubTitle:SetText("")
  local isMyChat = self._chatData:isMyChat()
  if isMyChat then
    self.bg:LoadSprite(ChatInterface.GetChatUIPath(UIAssets.ChatItemBg_right))
  else
    self.bg:LoadSprite(ChatInterface.GetChatUIPath(UIAssets.ChatItemBg_left))
  end
  if self._chatShareStarRoot and self._starTemplate and self._chatData.dispatchTaskStar ~= nil then
    self._chatShareTitle:SetLocalText(456288)
    self._chatShareStarRoot:SetActive(true)
    local taskStarLevel = self._chatData.dispatchTaskStar
    self._starTemplate:GameObjectRecycleAll()
    local sprites = DataCenter.ActDispatchTaskDataManager:GetStarSprites(taskStarLevel)
    for i = 1, #sprites do
      local star = self._starTemplate:GameObjectSpawn(self._chatShareStarRoot.transform)
      star.name = "star" .. i
      star:GetComponent(UnityImage):LoadSprite(ChatInterface.GetChatUIPath("ChatItems/" .. tostring(sprites[i])))
      star:SetActive(true)
    end
    if self._chatData.dispatchTaskColor ~= nil then
      local iconPath = ""
      if self._chatData.dispatchTaskColor == 3 then
        iconPath = ChatInterface.GetChatUIPath("ChatItems/lrb_liaotian_yinmirenwu_title_lan.png")
      elseif self._chatData.dispatchTaskColor == 4 then
        iconPath = ChatInterface.GetChatUIPath("ChatItems/lrb_liaotian_yinmirenwu_title_zi.png")
      elseif self._chatData.dispatchTaskColor == 5 then
        iconPath = ChatInterface.GetChatUIPath("ChatItems/lrb_liaotian_yinmirenwu_title_cheng.png")
      end
      if string.IsNullOrEmpty(iconPath) then
        if self.colorBg then
          self.colorBg:SetActive(false)
        end
        if self.myColorBg then
          self.myColorBg:SetActive(false)
        end
      elseif self.IsMyChat then
        if self.colorBg then
          self.colorBg:SetActive(false)
        end
        if self.myColorBg then
          self.myColorBg:SetActive(true)
        end
        if self.myColorIcon then
          self.myColorIcon:LoadSprite(iconPath)
        end
      else
        if self.colorBg then
          self.colorBg:SetActive(true)
        end
        if self.myColorBg then
          self.myColorBg:SetActive(false)
        end
        if self.colorIcon then
          self.colorIcon:LoadSprite(iconPath)
        end
      end
    else
      if self.colorBg then
        self.colorBg:SetActive(false)
      end
      if self.myColorBg then
        self.myColorBg:SetActive(false)
      end
    end
    if self._chatData.dispatchTaskIsSpecial then
      self.starImg:SetActive(true)
    end
  else
    if self._chatShareStarRoot then
      self._chatShareStarRoot:SetActive(false)
    end
    self._chatShareTitle:SetLocalText(110073)
  end
  if self._chatData.post == PostType.March then
    self._chatShareIcon:SetActive(true)
    local param = rapidjson.decode(self._chatData.attachmentId)
    self._chatShareIcon:LoadSprite(QualityImagePath[param.quality])
    self._chatShareSubTitle:SetLocalText(457601)
    if not string.IsNullOrEmpty(param.specialIconPath) and self._chatShareSpecialIcon then
      self._chatShareSpecialIcon:SetActive(true)
      self._chatShareSpecialIcon:LoadSprite(param.specialIconPath)
    end
  elseif self._chatData.post == PostType.HELP_STOP_FIRE then
    self._chatShareTitle:SetLocalText("outfire_msg_tittle")
  end
  if not self._chatShareMsg and not self.isShareError then
    self.isShareError = true
  end
  if self.param and self.param.statusLayer and self.param.statusLayer > 0 then
    self.statusImg:LoadSprite(self.param.statusIcon)
    self.statusImg:SetNativeSize()
    self.statusText:SetText(self.param.statusLayer)
    self.statusText:SetActive(true)
    if self.param.askVirusHelp then
      self._chatShareTitle:SetLocalText("season_virus_need_help")
    end
  else
    self.statusText:SetActive(false)
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self._chatShareMsgNode.rectTransform)
end

function ChatItemPost_PointShare:HandleClick()
  EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_SHARE_EXECUTE_CMD, self._chatData)
  return true
end

return ChatItemPost_PointShare
