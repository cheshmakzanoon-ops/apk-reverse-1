local base = UIBaseContainer
local UIResItemExtraComponent = BaseClass("UIResItemExtraComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UIResItemExtraComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIResItemExtraComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIResItemExtraComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compUICommonResItem = self.viewSkin:AddComponent(self, UICommonResItem, 1)
  self.imgEnglishExtra = self.viewSkin:AddComponent(self, UIImage, 2)
end

function UIResItemExtraComponent:ComponentDestroy()
  self.viewSkin = nil
  self.compUICommonResItem = nil
  self.imgEnglishExtra = nil
end

function UIResItemExtraComponent:DataDefine()
end

function UIResItemExtraComponent:DataDestroy()
end

function UIResItemExtraComponent:OnAddListener()
  base.OnAddListener(self)
end

function UIResItemExtraComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIResItemExtraComponent:ReInit(param)
  self.compUICommonResItem:ReInit(param)
  self.imgEnglishExtra:SetActive(param.isShowExtraFlag)
  if param.isShowExtraFlag then
    self.imgEnglishExtra:LoadSpriteAsyncWithCallback("Assets/Main/Sprites/UI/PyramidSpeedUp/zxl_ewai_wenzi.png", function(sprite)
      if self.imgEnglishExtra then
        self.imgEnglishExtra:SetNativeSize()
      end
    end)
  end
end

return UIResItemExtraComponent
