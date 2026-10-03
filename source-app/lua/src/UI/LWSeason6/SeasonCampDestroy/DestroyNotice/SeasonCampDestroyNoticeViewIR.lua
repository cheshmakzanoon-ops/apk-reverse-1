local base = UIBaseContainer
local SeasonCampDestroyNoticeViewIR = BaseClass("SeasonCampDestroyNoticeViewIR", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function SeasonCampDestroyNoticeViewIR:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function SeasonCampDestroyNoticeViewIR:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SeasonCampDestroyNoticeViewIR:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgBg = self.viewSkin:AddComponent(self, UIImage, 1)
  self.imgIcon = self.viewSkin:AddComponent(self, UIImage, 2)
  self.textTmpDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
end

function SeasonCampDestroyNoticeViewIR:ComponentDestroy()
  self.viewSkin = nil
  self.imgBg = nil
  self.imgIcon = nil
  self.textTmpDesc = nil
end

function SeasonCampDestroyNoticeViewIR:DataDefine()
end

function SeasonCampDestroyNoticeViewIR:DataDestroy()
end

function SeasonCampDestroyNoticeViewIR:OnAddListener()
  base.OnAddListener(self)
end

function SeasonCampDestroyNoticeViewIR:Refresh(data)
  if not data then
    return
  end
  self.imgIcon:LoadSpriteAuto(data.icon)
  self.textTmpDesc:SetLocalText(data.desc)
end

function SeasonCampDestroyNoticeViewIR:OnRemoveListener()
  base.OnRemoveListener(self)
end

return SeasonCampDestroyNoticeViewIR
