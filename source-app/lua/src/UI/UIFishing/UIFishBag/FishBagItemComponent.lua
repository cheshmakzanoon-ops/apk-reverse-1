local base = UIBaseContainer
local FishBagItemComponent = BaseClass("FishBagItemComponent", UIBaseContainer)

function FishBagItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function FishBagItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function FishBagItemComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnFishBagItem = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnFishBagItem:SetOnClick(function()
    self:OnBtnFishBagItemClick()
  end)
  self.rawImgIcon = self.viewSkin:AddComponent(self, UIRawImage, 2)
  self.textNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
end

function FishBagItemComponent:ComponentDestroy()
  self.viewSkin = nil
  self.btnFishBagItem = nil
  self.rawImgIcon = nil
  self.textNum = nil
end

function FishBagItemComponent:DataDefine()
end

function FishBagItemComponent:DataDestroy()
  self.index = nil
end

function FishBagItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function FishBagItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function FishBagItemComponent:OnBtnFishBagItemClick()
  DataCenter.LWSoundManager:PlaySound(6100021, false)
  if self.index then
    self.view:OnSelectCell(self.transform, self.index)
  end
end

function FishBagItemComponent:SetData(index, data)
  self.index = index
  local meta = DataCenter.FishMetaManager:GetMeta(data.id)
  if meta then
    if not string.IsNullOrEmpty(meta.pic) then
      self.rawImgIcon:LoadSpriteAsyncWithCallback(meta.pic, function()
        if self.rawImgIcon then
          self.rawImgIcon:SetNativeSize()
        end
      end)
    end
    local scale = meta.collect_proportion or 1
    self.rawImgIcon:SetLocalScaleXYZ(scale * 0.5, scale * 0.5, scale * 0.5)
  end
  self.textNum:SetText(string.GetFormattedStr2(data.num))
end

return FishBagItemComponent
