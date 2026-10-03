local p_img_progress_empty_path = "p_img_progress_empty"
local p_img_progress_finish_path = "p_img_progress_finish"
local base = UIBaseContainer
local UILWSeasonMilitaryStarCell = BaseClass("UILWSeasonMilitaryStarCell", UIBaseContainer)

function UILWSeasonMilitaryStarCell:ComponentDefine()
  self.p_img_progress_empty = self:AddComponent(UIImage, p_img_progress_empty_path)
  self.p_img_progress_finish = self:AddComponent(UIImage, p_img_progress_finish_path)
end

function UILWSeasonMilitaryStarCell:ComponentDestroy()
  self.p_img_progress_empty = nil
  self.p_img_progress_finish = nil
end

function UILWSeasonMilitaryStarCell:DataDefine()
end

function UILWSeasonMilitaryStarCell:DataDestroy()
end

function UILWSeasonMilitaryStarCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWSeasonMilitaryStarCell:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonMilitaryStarCell:SetState(act, show, anim)
  if not show then
    self.p_img_progress_empty:SetActive(false)
    self.p_img_progress_finish:SetActive(false)
  else
    self.p_img_progress_empty:SetActive(true)
    if not act then
      self.p_img_progress_finish:SetActive(false)
    elseif anim then
      self.p_img_progress_finish:SetActive(true)
    else
      self.p_img_progress_finish:SetActive(true)
    end
  end
end

return UILWSeasonMilitaryStarCell
