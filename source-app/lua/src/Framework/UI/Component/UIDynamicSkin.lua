local UIDynamicSkin = BaseClass("UIDynamicSkin", UIBaseComponent)
local base = UIBaseComponent
local UnityDynamicSkinManager = typeof(CS.DynamicSkinManager)

function UIDynamicSkin:OnCreate()
  base.OnCreate(self)
  self.unity_skin_mgr = self.gameObject:GetComponent(UnityDynamicSkinManager)
end

function UIDynamicSkin:OnDestroy()
  self.unity_skin_mgr = nil
  base.OnDestroy(self)
end

function UIDynamicSkin:SetAsync(async)
  if not IsNull(self.unity_skin_mgr) then
    self.unity_skin_mgr:SetAsync(async)
  end
end

function UIDynamicSkin:ActiveSkin(theSeasonMapType)
  if not IsNull(self.unity_skin_mgr) then
    self.unity_skin_mgr:ActiveSkin(toInt(theSeasonMapType))
  end
end

return UIDynamicSkin
