local base = UIBaseContainer
local UIRevivalPlanRecordItemComponent = BaseClass("UIRevivalPlanRecordItemComponent", UIBaseContainer)
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

function UIRevivalPlanRecordItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIRevivalPlanRecordItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIRevivalPlanRecordItemComponent:ComponentDefine()
  self.bg = self:AddComponent(UIImage, "")
  self.imgIcon = self:AddComponent(UIImage, "icon")
  self.textDesc = self:AddComponent(UIText, "desc")
  self.textScore = self:AddComponent(UIText, "score")
end

function UIRevivalPlanRecordItemComponent:ComponentDestroy()
  self.imgIcon = nil
  self.textDesc = nil
  self.textScore = nil
end

function UIRevivalPlanRecordItemComponent:DataDefine()
end

function UIRevivalPlanRecordItemComponent:DataDestroy()
end

function UIRevivalPlanRecordItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function UIRevivalPlanRecordItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIRevivalPlanRecordItemComponent:SetData(activityId, index, cur)
  local img = images[index]
  if not string.IsNullOrEmpty(img) then
    self.imgIcon:LoadSprite(img)
  end
  local info = DataCenter.RevivalPlanManager:GetStageInfo(activityId, index)
  local rank = info.rank or 0
  local score = info.score or 0
  if 0 < rank then
    self.textDesc:SetText(rank)
    self.textScore:SetText(string.GetFormattedSeperatorNum(score))
  else
    self.textDesc:SetText("-")
    self.textScore:SetText("-")
  end
  if cur then
    self.bg:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/FX_common_diban_lv.png")
  else
    self.bg:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/FX_common_diban_bai.png")
  end
end

return UIRevivalPlanRecordItemComponent
