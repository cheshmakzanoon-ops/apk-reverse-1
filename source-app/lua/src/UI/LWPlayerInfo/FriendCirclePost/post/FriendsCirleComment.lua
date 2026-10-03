local IChatItem = require("UI.UIChatNew.Component.ChatItem.IChatItem")
local FriendsCirleComment = BaseClass("FriendsCirleComment", IChatItem)
local frame = require("UI.LWPlayerInfo.FriendCirclePost.FriendCircleFrame")
local base = IChatItem
local comImg = "Moment/zyf_pyq_pinglun_icon"
local comFinImg = "Moment/zyf_pyq_yipinglun_icon"

function FriendsCirleComment:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function FriendsCirleComment:ComponentDefine()
  self.frame = self:AddComponent(frame, "Bg/RightPart/FriendCircleFrame")
  self.commentNumCom = self:AddComponent(UIBaseContainer, "Bg/Leftpart")
  self.commentNumText = self:AddComponent(UIText, "Bg/Leftpart/TxtCommentNum")
  self.imgComment = self:AddComponent(UIImage, "Bg/Leftpart/ImgComment")
  self.lineIcon = self:AddComponent(UIText, "Bg/Line")
  self.bgImg = self:AddComponent(UIImage, "Bg")
  
  function self.frame.onLoadCallback(size)
    self:UpdateSize(size)
  end
end

function FriendsCirleComment:OnAddListener()
end

function FriendsCirleComment:OnRemoveListener()
end

function FriendsCirleComment:UpdateItem(chatData, index, isLast)
  base.UpdateItem(self, chatData, index)
  if not self.frame then
    self.frame = self:AddComponent(frame, "Bg/RightPart/FriendCircleFrame")
    
    function self.frame.onLoadCallback(size)
      self:UpdateSize(size)
    end
    
    self.frame:SetContentViewScript(self._contentViewScript)
  end
  self.frame:SetMaxWidth(self:GetSizeDelta().x + 40)
  self.commentNumCom:SetActive(self._chatData.isFrist)
  self.commentNumText:SetText(self._chatData.commentNum)
  self.commentNumText:SetColorHex(ChatUIThemeConfig.MomentColor[ChatInterface.GetChatTheme()].countText)
  self.frame:SetActive(true)
  self.lineIcon:SetActive(not isLast)
  self.frame:UpdateItem(chatData, index)
  self.bgImg:SetColorHex(ChatUIThemeConfig.MomentColor[ChatInterface.GetChatTheme()].momentImgBg)
  if chatData.self_comment then
    self.imgComment:LoadSprite(ChatUIThemeConfig.UIPrefix[ChatInterface.GetChatTheme()] .. comFinImg)
  else
    self.imgComment:LoadSprite(ChatUIThemeConfig.UIPrefix[ChatInterface.GetChatTheme()] .. comImg)
  end
end

function FriendsCirleComment:UpdateSize(sizeY)
  self.rectTransform:SetSizeWithCurrentAnchors(CS.UnityEngine.RectTransform.Axis.Vertical, sizeY * 0.8 + 60)
end

function FriendsCirleComment:OnRecycleItem()
  self.frame:OnRecycleItem()
  self:RemoveComponents(frame)
  self.frame:SetMaxWidth()
  self.frame = nil
end

function FriendsCirleComment:SetContentViewScript(chatMainView)
  base.SetContentViewScript(self, chatMainView)
  self.frame:SetContentViewScript(chatMainView)
end

return FriendsCirleComment
