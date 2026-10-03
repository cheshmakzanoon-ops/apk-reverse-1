local base = UIBaseContainer
local UILWSeasonTetrisBlockItemComp = BaseClass("UILWSeasonTetrisBlockItemComp", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UILWSeasonTetrisBlockItemComp:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWSeasonTetrisBlockItemComp:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonTetrisBlockItemComp:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgItem = self.viewSkin:AddComponent(self, UIImage, 1)
  self.compVfx = self.viewSkin:AddComponent(self, UIBaseContainer, 2)
  self.imgItemTop = self.viewSkin:AddComponent(self, UIImage, 3)
end

function UILWSeasonTetrisBlockItemComp:ComponentDestroy()
  self.viewSkin = nil
  self.imgItem = nil
  self.compVfx = nil
  self.imgItemTop = nil
end

function UILWSeasonTetrisBlockItemComp:DataDefine()
  self.BlockImagePathPrefix = "Assets/Main/Sprites/ItemIcons/%s.png"
end

function UILWSeasonTetrisBlockItemComp:DataDestroy()
  if self.Tween ~= nil then
    self.Tween:Kill()
    self.Tween = nil
  end
  if self.Timer ~= nil then
    self.Timer:Stop()
    self.Timer = nil
  end
  if self.ImgTween ~= nil then
    self.ImgTween:Kill()
    self.ImgTween = nil
  end
end

function UILWSeasonTetrisBlockItemComp:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonTetrisTargetFinish, self.OnTargetFinished)
end

function UILWSeasonTetrisBlockItemComp:OnRemoveListener()
  self:RemoveUIListener(EventId.SeasonTetrisTargetFinish, self.OnTargetFinished)
  base.OnRemoveListener(self)
end

function UILWSeasonTetrisBlockItemComp:ReInit(data)
  self.Data = data
  if self.Data.BlockState ~= -1 and self.Data.BlockState ~= 0 then
    self.GoodsCell = LocalController:instance():getLine(TableName.GoodsTab, self.Data.BlockState)
  end
  local dataSource = DataCenter.SeasonTetrisManager.DataSource
  self.DefaultBlockImage = dataSource:GetDefaultBlockImage()
  self.compVfx:SetActive(false)
  self.ShowItem = self:SetImage()
end

function UILWSeasonTetrisBlockItemComp:GetImage()
  if self.GoodsCell ~= nil then
    if not table.IsNullOrEmpty(self.GoodsCell.icon_join) then
      return string.format(self.BlockImagePathPrefix, self.GoodsCell.icon_join[1])
    end
    return ""
  else
    return self.DefaultBlockImage
  end
end

function UILWSeasonTetrisBlockItemComp:PlayAnim(delay, callback)
  if self.Tween ~= nil then
    self.Tween:Kill()
    self.Tween = nil
  end
  if self.ShowItem then
    self.imgItem:SetActive(true)
    self.imgItem:LoadSprite(self.DefaultBlockImage)
    self.imgItemTop:SetActive(false)
  end
  self.Timer = TimerManager:GetInstance():DelayInvoke(function()
    self.compVfx:SetActive(true)
  end, delay)
  self.Tween = DOTween.Sequence()
  self.Tween:Append(self.imgItem:DOFade(0, 0))
  self.Tween:AppendInterval(delay)
  self.Tween:Append(self.imgItem:DOFade(1, 0))
  self.Tween:AppendInterval(0.2)
  self.Tween:Append(self.imgItem:DOFade(0, 0.1))
  self.Tween:Join(self.imgItem.transform:DOScale(ResetScale * 0.3, 0.1))
  self.Tween:AppendInterval(1)
  self.Tween:OnComplete(function()
    self.compVfx:SetActive(false)
    if callback ~= nil then
      callback()
    end
  end)
end

function UILWSeasonTetrisBlockItemComp:SetImage()
  self.imgItem:LoadSprite(self.DefaultBlockImage)
  self.imgItem:SetLocalScale(ResetScale)
  self.imgItemTop:SetActive(false)
  if self.Data ~= nil then
    self.imgItem:SetActive(self.Data.BlockState ~= nil and self.Data.BlockState ~= 0)
    self.imgItem:SetAlpha(self.Data.IsShadow and DataCenter.SeasonTetrisManager.ShadowAlpha or 1)
    if not self.Data.IsShadow then
      self.imgItemTop:LoadSprite(self:GetImage())
    end
    local targetData = DataCenter.SeasonTetrisManager.GameData:GetTargetData(self.Data.BlockState)
    if targetData ~= nil then
      local hasFinish = targetData.Gained >= targetData.Target
      self.imgItemTop:SetActive(not hasFinish)
      self.imgItemTop:SetAlpha(1)
      return not hasFinish
    end
  end
  return false
end

function UILWSeasonTetrisBlockItemComp:UpdateImg()
  self.ShowItem = false
  self.imgItemTop:SetActive(true)
  self.imgItemTop:SetAlpha(1)
  self.ImgTween = self.imgItemTop:DOFade(0, 0.2)
end

function UILWSeasonTetrisBlockItemComp:OnTargetFinished(evt)
  if evt ~= nil and self.Data and evt.ItemId == self.Data.BlockState and self.ShowItem then
    self:UpdateImg()
  end
end

return UILWSeasonTetrisBlockItemComp
