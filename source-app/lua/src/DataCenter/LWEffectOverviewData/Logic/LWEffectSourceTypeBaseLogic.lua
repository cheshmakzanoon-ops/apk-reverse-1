local LWEffectSourceTypeBaseLogic = BaseClass("LWEffectSourceTypeBaseLogic")

function LWEffectSourceTypeBaseLogic:__init()
  self.dirty = true
end

function LWEffectSourceTypeBaseLogic:__delete()
  self.dirty = nil
end

function LWEffectSourceTypeBaseLogic:SetDirty()
  self.dirty = true
end

function LWEffectSourceTypeBaseLogic:RefreshData()
  if self.dirty then
    self.dirty = false
    self:RecalculateData()
  end
end

function LWEffectSourceTypeBaseLogic:RecalculateData()
end

return LWEffectSourceTypeBaseLogic
