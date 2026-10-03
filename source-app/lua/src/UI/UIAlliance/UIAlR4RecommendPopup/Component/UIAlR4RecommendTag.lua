local base = UIBaseContainer
local UIAlR4RecommendTag = BaseClass("UIAlR4RecommendTag", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local BG_COLOR_PATH = {
  "Assets/Main/Sprites/UI/UILWAlliance/lrb_TJR4_title_lv.png",
  "Assets/Main/Sprites/UI/UILWAlliance/lrb_TJR4_title_lan.png",
  "Assets/Main/Sprites/UI/UILWAlliance/lrb_TJR4_title_zi.png",
  "Assets/Main/Sprites/UI/UILWAlliance/lrb_TJR4_title_cheng.png"
}

function UIAlR4RecommendTag:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIAlR4RecommendTag:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIAlR4RecommendTag:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgTag = self.viewSkin:AddComponent(self, UIImage, 1)
  self.btnTag = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnTag:SetOnClick(function()
    self:OnBtnTagClick()
  end)
  self.textTag = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
end

function UIAlR4RecommendTag:ComponentDestroy()
  self.viewSkin = nil
  self.imgTag = nil
  self.btnTag = nil
  self.textTag = nil
end

function UIAlR4RecommendTag:DataDefine()
  self.tagConfig = {}
end

function UIAlR4RecommendTag:DataDestroy()
  self.tagConfig = nil
end

function UIAlR4RecommendTag:OnBtnTagClick()
  local desc_id = self.tagConfig.desc
  if desc_id then
    local desc_text = Localization:GetString(desc_id)
    UIUtil.ShowBubbleTipsAuto(desc_text, self.transform.position, 0, -20, 0, nil, nil)
  end
end

function UIAlR4RecommendTag:SetTagInfo(tagId)
  self.tagConfig = DataCenter.AllianceMemberDataManager:GetR4RecommendTagConfig(tagId)
  if self.tagConfig then
    if self.tagConfig.is_show and self.tagConfig.is_show == 0 then
      return
    end
    self.textTag:SetLocalText(self.tagConfig.name)
    self.imgTag:LoadSpriteAuto(BG_COLOR_PATH[tonumber(self.tagConfig.color) or 1])
  end
end

return UIAlR4RecommendTag
