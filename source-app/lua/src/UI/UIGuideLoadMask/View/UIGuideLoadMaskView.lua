local UIGuideLoadMaskView = BaseClass("UIGuideLoadMaskView", UIBaseView)
local base = UIBaseView
local title_text_path = "TitleBg/Text_num"
local des_text_path = "DesText"
local bg_img_path = "BgImg"

function UIGuideLoadMaskView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function UIGuideLoadMaskView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIGuideLoadMaskView:ComponentDefine()
  self.title_text = self:AddComponent(UIText, title_text_path)
  self.des_text = self:AddComponent(UIText, des_text_path)
  self.bg_img = self:AddComponent(UIImage, bg_img_path)
end

function UIGuideLoadMaskView:ComponentDestroy()
  self.title_text = nil
  self.des_text = nil
  self.bg_img = nil
end

function UIGuideLoadMaskView:DataDefine()
  self.param = nil
end

function UIGuideLoadMaskView:DataDestroy()
  self.param = nil
end

function UIGuideLoadMaskView:OnEnable()
  base.OnEnable(self)
end

function UIGuideLoadMaskView:OnDisable()
  base.OnDisable(self)
end

function UIGuideLoadMaskView:ReInit()
  self.param = self:GetUserData()
  self.bg_img:LoadSprite("Assets/Main/TextureEx/UIChapter/" .. self.param.bgName)
  self.title_text:SetText(self.param.titleDes)
  self.des_text:SetText(self.param.des)
end

function UIGuideLoadMaskView:OnAddListener()
  base.OnAddListener(self)
end

function UIGuideLoadMaskView:OnRemoveListener()
  base.OnRemoveListener(self)
end

return UIGuideLoadMaskView
