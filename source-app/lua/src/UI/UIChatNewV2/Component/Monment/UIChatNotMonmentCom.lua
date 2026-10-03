local base = UIBaseContainer
local UIChatNotMonmentCom = BaseClass("UIChatNotMonmentCom", UIBaseContainer)
local Config = {
  iconPath = "Assets/Main/Sprites/UI/LWChat_v2/DefaultSkin/Moment/zyf_pengyouquanshuaxin_tu.png",
  text = "moment_blank_default",
  showBtn = true
}

function UIChatNotMonmentCom:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

function UIChatNotMonmentCom:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIChatNotMonmentCom:DataDefine()
  self.refreshCallBack = nil
end

function UIChatNotMonmentCom:DataDestroy()
  self.refreshCallBack = nil
end

function UIChatNotMonmentCom:ComponentDefine()
  self.text = self:AddComponent(UIText, "notMomentText")
  self.icon = self:AddComponent(UIImage, "notMomentIcon")
  self.btn = self:AddComponent(UIButton, "postBtn")
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
  local color = ChatUIThemeConfig.TextColor[ChatInterface.GetChatTheme()]
  self.text:SetColor(color)
end

function UIChatNotMonmentCom:OnBtnClick()
  if self.refreshCallBack then
    self.refreshCallBack()
  end
end

function UIChatNotMonmentCom:SetOnRefreshCallBack(refreshCallBack)
  self.refreshCallBack = refreshCallBack
end

function UIChatNotMonmentCom:ComponentDestroy()
  self.text = nil
  self.icon = nil
  self.btn = nil
  self.group = nil
end

function UIChatNotMonmentCom:ReInit(group)
  if self.group == group then
    return
  end
  self.group = group
  local showConfig = Config
  if showConfig then
    self.text:SetLocalText(showConfig.text)
    self.icon:LoadSprite(showConfig.iconPath)
    self.icon:SetNativeSize()
    self.btn:SetActive(showConfig.showBtn)
  end
end

return UIChatNotMonmentCom
