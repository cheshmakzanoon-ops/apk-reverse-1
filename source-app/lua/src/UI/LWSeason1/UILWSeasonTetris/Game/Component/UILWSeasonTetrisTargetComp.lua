local base = UIBaseContainer
local UILWSeasonTetrisTargetComp = BaseClass("UILWSeasonTetrisTargetComp", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local img_bg_path = "ImgTargetBg"
local img_complete_mask_path = "Completed"

function UILWSeasonTetrisTargetComp:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgTarget = self.viewSkin:AddComponent(self, UIImage, 1)
  self.textTargetNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.goCompleted = self.viewSkin:AddComponent(self, UIBaseContainer, 3)
  self.compTargetVfx = self.viewSkin:AddComponent(self, UIBaseContainer, 4)
  self.img_target_bg = self:AddComponent(UIImage, img_bg_path)
  self.img_complete_mask = self:AddComponent(UIImage, img_complete_mask_path)
  self.compCanvasGroup = self:AddComponent(UICanvasGroup, img_complete_mask_path)
end

function UILWSeasonTetrisTargetComp:ComponentDestroy()
  self.viewSkin = nil
  self.imgTarget = nil
  self.textTargetNum = nil
  self.goCompleted = nil
  self.compTargetVfx = nil
  self.compCanvasGroup = nil
end

function UILWSeasonTetrisTargetComp:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWSeasonTetrisTargetComp:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonTetrisTargetComp:DataDefine()
  local dataSource = DataCenter.SeasonTetrisManager.DataSource
  self.ImagePathPrefix = dataSource:GetTargetIconPathPrefix()
end

function UILWSeasonTetrisTargetComp:DataDestroy()
end

function UILWSeasonTetrisTargetComp:OnAddListener()
  base.OnAddListener(self)
end

function UILWSeasonTetrisTargetComp:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWSeasonTetrisTargetComp:ReInit(targetData)
  if self:InitData(targetData) then
    self:InitUi()
  end
end

function UILWSeasonTetrisTargetComp:InitData(data)
  self.Data = data
  if self.Data ~= nil then
    self.Gained = self.Data.Gained
    self.GainedLogic = self.Data.Gained
    self.GoodsCell = LocalController:instance():getLine(TableName.GoodsTab, self.Data.ItemId)
    return self.GoodsCell ~= nil
  end
  return false
end

function UILWSeasonTetrisTargetComp:InitUi()
  self.imgTarget:LoadSprite(self:GetImagePath())
  local dataSource = DataCenter.SeasonTetrisManager.DataSource
  if dataSource ~= nil then
    self.img_target_bg:LoadSpriteAsync(dataSource:GetTargetBg())
    self.img_complete_mask:LoadSpriteAsync(dataSource:GetTargetMask())
    local color = dataSource:GetTargetMaskColor()
    self.img_complete_mask:SetColor(color)
    self.compCanvasGroup:SetAlpha(color.a)
  end
  self:UpdateState()
end

function UILWSeasonTetrisTargetComp:GetImagePath()
  if self.GoodsCell ~= nil and not string.IsNullOrEmpty(self.GoodsCell.icon) then
    return string.format(self.ImagePathPrefix, self.GoodsCell.icon)
  end
  return ""
end

function UILWSeasonTetrisTargetComp:Inc()
  self.Gained = self.Gained + 1
  self:UpdateState()
  self:ShowVfx()
end

function UILWSeasonTetrisTargetComp:UpdateState()
  local hasFinish = self:HasFinish()
  if IsNotNull(self.goCompleted) then
    self.goCompleted:SetActive(hasFinish)
  end
  if IsNotNull(self.textTargetNum) then
    self.textTargetNum:SetActive(not hasFinish)
    if not hasFinish then
      self.textTargetNum:SetText(string.format("%s/%s", self.Gained, self.Data.Target))
    end
  end
  if hasFinish then
    EventManager:GetInstance():Broadcast(EventId.SeasonTetrisTargetFinish, self.Data)
  end
end

function UILWSeasonTetrisTargetComp:ShowVfx()
  if IsNotNull(self.compTargetVfx) then
    self.compTargetVfx:SetActive(false)
    self.compTargetVfx:SetActive(true)
  end
end

function UILWSeasonTetrisTargetComp:HasFinish()
  if self.Data ~= nil then
    return checknumber(self.Gained) >= checknumber(self.Data.Target)
  end
  return true
end

function UILWSeasonTetrisTargetComp:IncLogic()
  self.GainedLogic = checknumber(self.GainedLogic) + 1
end

function UILWSeasonTetrisTargetComp:HasFinishLogic()
  if self.Data ~= nil then
    return checknumber(self.GainedLogic) >= checknumber(self.Data.Target)
  end
  return true
end

return UILWSeasonTetrisTargetComp
