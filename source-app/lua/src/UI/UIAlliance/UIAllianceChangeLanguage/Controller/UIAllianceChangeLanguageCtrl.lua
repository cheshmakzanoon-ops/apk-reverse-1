local UIAllianceChangeLanguageCtrl = BaseClass("UIAllianceChangeLanguageCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAllianceChangeLanguage)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

local function GetLanguageList(self)
  local list = {}
  LocalController:instance():visitTable("language", function(k, v)
    local mark = v.mark
    if mark ~= 0 then
      local languageId = v.lang_id
      table.insert(list, languageId)
    end
  end)
  return list
end

local function OnSetBtnClick(self, value)
  self:CloseSelf()
end

UIAllianceChangeLanguageCtrl.CloseSelf = CloseSelf
UIAllianceChangeLanguageCtrl.Close = Close
UIAllianceChangeLanguageCtrl.GetLanguageList = GetLanguageList
UIAllianceChangeLanguageCtrl.OnSetBtnClick = OnSetBtnClick
return UIAllianceChangeLanguageCtrl
