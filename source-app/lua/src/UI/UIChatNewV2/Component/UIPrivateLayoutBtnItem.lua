local base = UIBaseContainer
local UIPrivateLayoutBtnItem = BaseClass("UIChatViewPinList_v2", base)

function UIPrivateLayoutBtnItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIPrivateLayoutBtnItem:ComponentDefine()
  self.btn = self:AddComponent(UIButton, "")
  self.img = self:AddComponent(UIImage, "img")
  self.text = self:AddComponent(UIText, "text")
  self.btn:SetOnClick(function()
    if self.fun then
      self.fun()
    end
  end)
end

function UIPrivateLayoutBtnItem:ParseInfoByNight(data)
  if not data then
    return
  end
  self.img:LoadSprite(ChatUIThemeConfig.UIPrefix[ChatInterface.GetChatTheme()] .. data.imgName)
  self.text:SetLocalText(data.text)
  self.fun = data.fun
end

function UIPrivateLayoutBtnItem:DataDefine()
end

function UIPrivateLayoutBtnItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIPrivateLayoutBtnItem:ComponentDestroy()
  self.img = nil
  self.text = nil
  self.fun = nil
  self.btn = nil
end

return UIPrivateLayoutBtnItem
