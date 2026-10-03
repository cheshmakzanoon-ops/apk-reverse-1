local base = UIBaseContainer
local UIMailDetailRevivalActivityItemComponent = BaseClass("UIMailDetailRevivalActivityItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local images = {
  "Assets/Main/Sprites/UI/UILWRevivalPlan/FX_fuxingjihua_number_01.png",
  "Assets/Main/Sprites/UI/UILWRevivalPlan/FX_fuxingjihua_number_02.png",
  "Assets/Main/Sprites/UI/UILWRevivalPlan/FX_fuxingjihua_number_03.png",
  "Assets/Main/Sprites/UI/UILWRevivalPlan/FX_fuxingjihua_number_04.png",
  "Assets/Main/Sprites/UI/UILWRevivalPlan/FX_fuxingjihua_number_05.png",
  "Assets/Main/Sprites/UI/UILWRevivalPlan/FX_fuxingjihua_number_06.png",
  "Assets/Main/Sprites/UI/UILWRevivalPlan/FX_fuxingjihua_number_07.png"
}

function UIMailDetailRevivalActivityItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIMailDetailRevivalActivityItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIMailDetailRevivalActivityItemComponent:ComponentDefine()
  self.bg = self:AddComponent(UIImage, "")
  self.imgIcon = self:AddComponent(UIImage, "icon")
  self.textDesc = self:AddComponent(UIText, "desc")
  self.textScore = self:AddComponent(UIText, "score")
end

function UIMailDetailRevivalActivityItemComponent:ComponentDestroy()
  self.imgIcon = nil
  self.textDesc = nil
  self.textScore = nil
end

function UIMailDetailRevivalActivityItemComponent:DataDefine()
end

function UIMailDetailRevivalActivityItemComponent:DataDestroy()
end

function UIMailDetailRevivalActivityItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function UIMailDetailRevivalActivityItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIMailDetailRevivalActivityItemComponent:SetData(index, data)
  local img = images[index]
  if not string.IsNullOrEmpty(img) then
    self.imgIcon:LoadSprite(img)
  end
  local info = data
  if data == nil then
    return
  end
  local rank = info.rank or 0
  local score = info.score or 0
  if 0 < rank then
    self.textDesc:SetText(rank)
    self.textScore:SetText(string.GetFormattedSeperatorNum(score))
  else
    self.textDesc:SetText("-")
    self.textScore:SetText("-")
  end
end

return UIMailDetailRevivalActivityItemComponent
