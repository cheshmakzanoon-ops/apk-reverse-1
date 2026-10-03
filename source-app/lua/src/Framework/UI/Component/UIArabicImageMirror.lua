local UIArabicImageMirror = BaseClass("UIArabicImageMirror", UIBaseComponent)
local base = UIBaseComponent
local UnityArabicImageMirror = typeof(CS.UnityEngine.UI.ArabicImageMirror)

function UIArabicImageMirror:OnCreate()
  base.OnCreate(self)
  self.unity_mirror = self.gameObject:GetComponent(UnityArabicImageMirror)
end

function UIArabicImageMirror:OnDestroy()
  self.unity_mirror = nil
  base.OnDestroy(self)
end

function UIArabicImageMirror:SetEnable(enable)
  if self.unity_mirror then
    self.unity_mirror.enabled = enable
  end
end

return UIArabicImageMirror
