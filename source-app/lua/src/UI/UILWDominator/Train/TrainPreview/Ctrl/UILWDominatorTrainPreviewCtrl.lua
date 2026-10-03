local UILWDominatorTrainPreviewCtrl = BaseClass("UILWDominatorTrainPreviewCtrl", UIBaseCtrl)
UILWDominatorTrainPreviewCtrl.SHOW_MAX_BIG_LEVEL_DELTA = 5

function UILWDominatorTrainPreviewCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWDominatorTrainPreview)
end

function UILWDominatorTrainPreviewCtrl:GetShowDataList()
  local res = {}
  local curMainTrainInfo = DataCenter.DominatorManager:GetMainTrainGroupInfo()
  if curMainTrainInfo then
    local curLevelTemplate = curMainTrainInfo:GetCurLevelTemplate()
    if curLevelTemplate then
      local showMaxBigLevel = curLevelTemplate:GetBigLevel() + self.SHOW_MAX_BIG_LEVEL_DELTA
      local allMaxLevelTemplates = DataCenter.DominatorTemplateManager:GetAllMainTrainGroupBigLevelTemplates()
      for i, v in ipairs(allMaxLevelTemplates) do
        if not v.minTemplate:IsInitLevel() then
          if showMaxBigLevel < v.grade_order then
            break
          end
          table.insert(res, v.minTemplate)
        end
      end
    end
  end
  table.sort(res, function(a, b)
    return a.level_order < b.level_order
  end)
  return res
end

return UILWDominatorTrainPreviewCtrl
