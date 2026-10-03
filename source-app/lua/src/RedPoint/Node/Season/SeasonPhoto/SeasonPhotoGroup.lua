local RedPoint = BaseClass("SeasonPhotoGroup", RedPointGroup)

function RedPoint:__init(nodeName)
  self.isSimpleCount = true
end

function RedPoint:SetData(activityId)
  self:GetOrAddOnlyChild(RedDef.SeasonPhotoTask, activityId)
  self:GetOrAddOnlyChild(RedDef.SeasonPhotoView, activityId)
end

return RedPoint
