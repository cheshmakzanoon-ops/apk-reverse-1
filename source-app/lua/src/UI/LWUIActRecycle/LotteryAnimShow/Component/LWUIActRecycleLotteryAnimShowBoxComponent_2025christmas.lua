local base = UIBaseContainer
local LWUIActRecycleLotteryAnimShowBoxComponent_2025christmas = BaseClass("LWUIActRecycleLotteryAnimShowBoxComponent_2025christmas", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function LWUIActRecycleLotteryAnimShowBoxComponent_2025christmas:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWUIActRecycleLotteryAnimShowBoxComponent_2025christmas:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIActRecycleLotteryAnimShowBoxComponent_2025christmas:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compRootGift3 = self.viewSkin:AddComponent(self, UIBaseComponent, 1)
  self.rawImgBox = self.viewSkin:AddComponent(self, UIRawImage, 2)
  self.rawImgBoxopen = self.viewSkin:AddComponent(self, UIRawImage, 3)
end

function LWUIActRecycleLotteryAnimShowBoxComponent_2025christmas:ComponentDestroy()
  self.viewSkin = nil
  self.compRootGift3 = nil
  self.rawImgBox = nil
  self.rawImgBoxopen = nil
end

function LWUIActRecycleLotteryAnimShowBoxComponent_2025christmas:DataDefine()
end

function LWUIActRecycleLotteryAnimShowBoxComponent_2025christmas:DataDestroy()
end

function LWUIActRecycleLotteryAnimShowBoxComponent_2025christmas:OnAddListener()
  base.OnAddListener(self)
end

function LWUIActRecycleLotteryAnimShowBoxComponent_2025christmas:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LWUIActRecycleLotteryAnimShowBoxComponent_2025christmas:ReInit(quality)
  self.compRootGift3:SetActive(quality ~= nil)
  if quality ~= nil then
    local boxIconPath = DataCenter.ActRecycleManager:Get2025ChristmasLotteryAnimBoxIcon(quality, false)
    local boxIconPathOpen = DataCenter.ActRecycleManager:Get2025ChristmasLotteryAnimBoxIcon(quality, true)
    self.rawImgBox:LoadSpriteAsync(boxIconPath)
    self.rawImgBoxopen:LoadSpriteAsync(boxIconPathOpen)
    if string.IsNullOrEmpty(boxIconPath) then
      Logger.LogError("LWUIActRecycleLotteryAnimShowBoxComponent_2025christmas boxIconPath is empty, quality: " .. quality)
    end
    if string.IsNullOrEmpty(boxIconPathOpen) then
      Logger.LogError("LWUIActRecycleLotteryAnimShowBoxComponent_2025christmas boxIconPathOpen is empty, quality: " .. quality)
    end
  end
end

return LWUIActRecycleLotteryAnimShowBoxComponent_2025christmas
