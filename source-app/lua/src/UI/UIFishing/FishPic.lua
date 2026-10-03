local base = UIAsyncContainer
local FishPic = BaseClass("FishPic", UIAsyncContainer)

function FishPic:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function FishPic:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function FishPic:ComponentDefine()
  self.icon = self:AddComponent(UIRawImage, "Icon")
  self.btn = self:AddComponent(UIButton, "")
  self.btn:SetOnClick(function()
    if self.cfgId then
      local fishMeta = DataCenter.FishMetaManager:GetMeta(self.cfgId)
      if fishMeta then
        UIUtil.ShowButtonTips(self.btn, fishMeta.name, fishMeta.desc)
      end
    end
  end)
end

function FishPic:ComponentDestroy()
  self.icon = nil
end

function FishPic:SetData(cfgId)
  self.cfgId = cfgId
end

function FishPic:UpdateData()
  local fishMeta = DataCenter.FishMetaManager:GetMeta(self.cfgId)
  if fishMeta then
    if not string.IsNullOrEmpty(fishMeta.pic) then
      self.icon:LoadSpriteAsyncWithCallback(fishMeta.pic, function()
        if self.icon then
          self.icon:SetNativeSize()
        end
      end)
    end
    local scale = fishMeta.collect_proportion or 1
    self.icon:SetLocalScaleXYZ(scale * 0.4, scale * 0.4, scale * 0.4)
  end
end

return FishPic
