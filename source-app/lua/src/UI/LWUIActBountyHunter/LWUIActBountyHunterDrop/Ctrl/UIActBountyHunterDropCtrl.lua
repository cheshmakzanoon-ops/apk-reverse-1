local UIActBountyHunterDropCtrl = BaseClass("UIActBountyHunterDropCtrl", UIBaseCtrl)

function UIActBountyHunterDropCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIActBountyHunterDrop)
end

function UIActBountyHunterDropCtrl:GetTemplateByTypes(templates, types)
  local res = {}
  if templates ~= nil then
    for _, v in ipairs(templates) do
      for _, type in ipairs(types) do
        if v.type == type then
          table.insert(res, v)
          break
        end
      end
    end
  end
  table.sort(res, function(a, b)
    return a.type_order > b.type_order
  end)
  return res
end

return UIActBountyHunterDropCtrl
