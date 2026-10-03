local UITacticalChipTierDisplayCtrl = BaseClass("UITacticalChipTierDisplayCtrl", UIBaseCtrl)
local tierTemplateList = {}

function UITacticalChipTierDisplayCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UITacticalChipTierDisplay)
end

function UITacticalChipTierDisplayCtrl:GetTierQualityList()
  LocalController:instance():visitTable(TableName.LW_MASTERY_SHOW, function(_, line)
    local id = tonumber(line:getValue("id"))
    local temp = LWMasteryShowTemplate.New()
    temp:InitData(line)
    self.lwMasteryShowDict[id] = temp
  end)
end

return UITacticalChipTierDisplayCtrl
