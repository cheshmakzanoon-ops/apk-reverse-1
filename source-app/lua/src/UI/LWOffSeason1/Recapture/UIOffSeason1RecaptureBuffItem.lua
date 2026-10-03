local base = UIBaseContainer
local OffSeason1RecaptureBuffItem = BaseClass("OffSeason1RecaptureBuffItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function OffSeason1RecaptureBuffItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function OffSeason1RecaptureBuffItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function OffSeason1RecaptureBuffItem:ComponentDefine()
  self.btn = self:AddComponent(UIButton, "")
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.imgIcon = self:AddComponent(UIImage, "IconImg")
  self.compSelectImg = self:AddComponent(UIBaseComponent, "SelectImg")
  self.compBgImg = self:AddComponent(UIBaseComponent, "BgImg")
  self.compSelectImg:SetActive(false)
  self.compGrayImg = self:AddComponent(UIBaseComponent, "GrayImg")
  self.compGrayImg:SetActive(false)
  self.compUnlockEffect = self:AddComponent(UIBaseComponent, "UnlockEffect")
  self.compUnlockEffect:SetActive(false)
end

function OffSeason1RecaptureBuffItem:ComponentDestroy()
  self.btn = nil
  self.imgIcon = nil
  self.compSelectImg = nil
  self.compBgImg = nil
  self.compGrayImg = nil
  self.compUnlockEffect = nil
end

function OffSeason1RecaptureBuffItem:DataDefine()
  self.index = nil
end

function OffSeason1RecaptureBuffItem:DataDestroy()
  self.index = nil
end

function OffSeason1RecaptureBuffItem:OnAddListener()
  base.OnAddListener(self)
end

function OffSeason1RecaptureBuffItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function OffSeason1RecaptureBuffItem:OnBtnClick()
  if self.index and self.effectInfo and self.effectInfo.cfg then
    self.compSelectImg:SetActive(true)
    local param = DataCenter.ArrowTipParamManager:Get(ArrowTipEnumtype.Type.OffSeason1RecaptureBuffTip)
    param.effectInfo = self.effectInfo
    
    function param.closeCallback()
      if self.compSelectImg then
        self.compSelectImg:SetActive(false)
      end
    end
    
    param.alignObject = self
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIOffSeason1RecaptureBuffTip, {anim = true}, param)
  end
end

function OffSeason1RecaptureBuffItem:Refresh(index, effectInfo)
  self.index = index
  self.effectInfo = effectInfo
  if self.effectInfo and self.effectInfo.cfg then
    self.imgIcon:LoadSprite(self.effectInfo.cfg.icon)
    self.compGrayImg:SetActive(not self.effectInfo.unlock)
    self.compUnlockEffect:SetActive(self.effectInfo.unlock)
  end
end

return OffSeason1RecaptureBuffItem
