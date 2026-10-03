local LWSeasonBuildCtrl = BaseClass("LWSeasonBuildCtrl", UIBaseCtrl)

function LWSeasonBuildCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonBuild)
end

function LWSeasonBuildCtrl:GetCntByResType(resourceType)
  if DataCenter.ItemTemplateManager:GetItemTemplate(resourceType) ~= nil then
    local item = DataCenter.ItemData:GetItemById(resourceType)
    if item ~= nil then
      return item.count
    end
    return 0
  end
  return LuaEntry.Resource:GetCntByResType(resourceType)
end

function LWSeasonBuildCtrl:OnClickResourceBtn(resourceType)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWResourceInfo, {anim = true}, resourceType)
end

return LWSeasonBuildCtrl
