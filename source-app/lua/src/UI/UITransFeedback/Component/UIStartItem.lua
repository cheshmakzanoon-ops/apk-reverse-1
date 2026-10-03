local UIStartItem = BaseClass("UIStartItem", UIBaseContainer)
local base = UIBaseContainer
local Theme = {
  {
    startImg = "Assets/Main/Sprites/UI/LWChat_v2/DefaultSkin/ChatItems/mjc_FJDZ_xing_jin.png",
    notStartImg = "Assets/Main/Sprites/UI/LWChat_v2/DefaultSkin/ChatItems/zyf_fanyifankui_xingxing_di.png"
  },
  {
    startImg = "Assets/Main/Sprites/UI/LWChat_v2/NightSkin/ChatItems/zyf_fanyifankui_xingxing_yejian.png",
    notStartImg = "Assets/Main/Sprites/UI/LWChat_v2/NightSkin/ChatItems/zyf_fanyifankui_xingxing_di.png"
  }
}

function UIStartItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIStartItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIStartItem:ComponentDefine()
  self.starBtn = self:AddComponent(UIButton, "IconBtn")
  self.starIcon = self:AddComponent(UIImage, "IconBtn")
  self.starBtn:SetOnClick(function()
    if self.callBack then
      self.callBack(self.index)
    end
  end)
end

function UIStartItem:ComponentDestroy()
  self.starBtn = nil
  self.starIcon = nil
end

function UIStartItem:ReInit(index, callBack)
  self.index = index
  self.callBack = callBack
  self:SetStartOpen(false)
end

function UIStartItem:SetStartOpen(isOn)
  local themPath = Theme[ChatInterface.GetChatTheme()]
  local path = isOn and themPath.startImg or themPath.notStartImg
  self.starIcon:LoadSprite(path)
end

return UIStartItem
