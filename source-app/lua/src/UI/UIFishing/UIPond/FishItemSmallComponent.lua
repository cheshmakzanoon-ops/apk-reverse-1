local base = UIAsyncContainer
local FishItemSmallComponent = BaseClass("FishItemSmallComponent", UIAsyncContainer)
local Localization = CS.GameEntry.Localization

function FishItemSmallComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function FishItemSmallComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function FishItemSmallComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compHave = self.viewSkin:AddComponent(self, UIBaseComponent, 1)
  self.rawImgIcon = self.viewSkin:AddComponent(self, UIRawImage, 2)
  self.textName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
end

function FishItemSmallComponent:ComponentDestroy()
  self.viewSkin = nil
  self.compHave = nil
  self.rawImgIcon = nil
  self.textName = nil
end

function FishItemSmallComponent:DataDefine()
end

function FishItemSmallComponent:DataDestroy()
end

function FishItemSmallComponent:OnAddListener()
  base.OnAddListener(self)
end

function FishItemSmallComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function FishItemSmallComponent:SetData(cfgId)
  self.cfgId = cfgId
end

function FishItemSmallComponent:UpdateData()
  local fishMeta = DataCenter.FishMetaManager:GetMeta(self.cfgId)
  if fishMeta then
    if not string.IsNullOrEmpty(fishMeta.pic) then
      self.rawImgIcon:LoadSpriteAsyncWithCallback(fishMeta.pic, function()
        if self.rawImgIcon then
          self.rawImgIcon:SetNativeSize()
        end
      end)
    end
    self.textName:SetLocalText(fishMeta.name)
    local scale = fishMeta.collect_proportion or 1
    self.rawImgIcon:SetLocalScaleXYZ(scale * 0.35, scale * 0.35, scale * 0.35)
  end
  self.compHave:SetActive(DataCenter.FishingDataManager:GetMyFish(self.cfgId))
end

return FishItemSmallComponent
