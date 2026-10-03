local base = UIBaseContainer
local UIChatViewTopTip = BaseClass("UIChatViewTopTip", base)
local compBook = {
  {
    path = "tipCallBackBtn",
    name = "callBackBtn",
    type = UIButton,
    onClick = function(self)
      self:OnCallBackClick()
    end
  },
  {
    path = "closeBtn",
    name = "closeBtn",
    type = UIButton,
    onClick = function(self)
      self:OnCloseBtnClick()
    end
  },
  {
    path = "content",
    name = "contentText",
    type = UIText
  },
  {
    path = "tipCallBackBtn/callBackText",
    name = "callBackText",
    type = UIText
  },
  {
    path = "",
    name = "canvasGroup",
    rawType = CS.UnityEngine.CanvasGroup
  }
}

function UIChatViewTopTip:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIChatViewTopTip:OnDestroy()
  if self.tween then
    self.tween:Kill()
    self.tween = nil
  end
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIChatViewTopTip:ComponentDefine()
  self:DefineCompsByBook(compBook)
end

function UIChatViewTopTip:ComponentDestroy()
  self:ClearCompsByBook(compBook)
end

function UIChatViewTopTip:OnCallBackClick()
  local isClose = true
  if self.data.callBack then
    isClose = self.data.callBack()
  end
  if isClose then
    self:OnCloseBtnClick()
  end
end

function UIChatViewTopTip:OnCloseBtnClick()
  if self.data.closeCallBack then
    self.data.closeCallBack()
  end
  if self.canvasGroup then
    if not self.tween then
      self.tween = self.canvasGroup:DOFade(0, 0.2):OnComplete(function()
        self:SetActive(false)
        EventManager:GetInstance():Broadcast(EventId.ChatPinUpdate)
      end)
    end
  else
    EventManager:GetInstance():Broadcast(EventId.ChatPinUpdate)
  end
end

function UIChatViewTopTip:ReInit(data)
  self.canvasGroup.alpha = 1
  self.data = data
  self.contentText:SetLocalText(self.data.content)
  self.callBackText:SetLocalText(self.data.callBackText)
end

return UIChatViewTopTip
