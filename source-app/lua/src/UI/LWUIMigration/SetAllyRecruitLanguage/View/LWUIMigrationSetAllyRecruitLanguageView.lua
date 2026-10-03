local LWUIMigrationSetAllyRecruitLanguageView = BaseClass("LWUIMigrationSetAllyRecruitLanguageView", UIBaseView)
local base = UIBaseView
local UISettingLanguageCell = require("UI.UISetting.UISettingLanguage.Component.UISettingLanguageCell")
local txt_title_path = "Root/Content/UICommonPopBg/bg_3/TitleTxt"
local close_btn_path = "Panel"
local return_btn_path = "Root/Content/UICommonPopBg/bg_3/CloseBtn"
local scroll_view_path = "Root/Content/ImgBg/ScrollView"
local conform_btn_path = "Root/Content/ConfirmButton"
local conform_name_path = "Root/Content/ConfirmButton/ConfirmTitleTxt"

function LWUIMigrationSetAllyRecruitLanguageView:OnCreate()
  base.OnCreate(self)
  self.title = self:AddComponent(UIText, txt_title_path)
  self.title:SetLocalText(100101)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.closeBg = self:AddComponent(UIButton, return_btn_path)
  self.closeBg:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
  self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnCellMoveIn(itemObj, index)
  end)
  self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnCellMoveOut(itemObj, index)
  end)
  self.conform_btn = self:AddComponent(UIButton, conform_btn_path)
  self.conform_btn:SetOnClick(BindCallback(self, self.OnConfirmBtnClick))
  self.conform_name = self:AddComponent(UIText, conform_name_path)
  self.conform_name:SetLocalText(GameDialogDefine.CONFIRM)
  self:DataDefine()
  self:ShowCells()
end

function LWUIMigrationSetAllyRecruitLanguageView:OnDestroy()
  self:ClearScroll()
  self.list = nil
  self.cells = nil
  self.selectIndex = nil
  self.initLanguage = nil
  self.cb = nil
  base.OnDestroy(self)
end

function LWUIMigrationSetAllyRecruitLanguageView:DataDefine()
  self.list = {}
  self.cells = {}
  self.selectIndex = nil
  local initLanguage, cb = self:GetUserData()
  self.cb = cb
  self.initLanguage = initLanguage
end

function LWUIMigrationSetAllyRecruitLanguageView:OnConfirmBtnClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  local lang = self.list[self.selectIndex] or ""
  if self.cb then
    self.cb(lang)
  end
  self.ctrl:CloseSelf()
end

function LWUIMigrationSetAllyRecruitLanguageView:GetShowList()
  local list = {}
  local supportedLanguages = SuportedLanguages
  for k, v in ipairs(supportedLanguages) do
    if v ~= Language.ChineseSimplified then
      table.insert(list, v)
    end
  end
  table.walk(list, function(k, v)
    if v == self.initLanguage then
      self.selectIndex = k
    end
  end)
  return list
end

function LWUIMigrationSetAllyRecruitLanguageView:ShowCells()
  self:ClearScroll()
  self.list = self:GetShowList()
  local tempCount = table.count(self.list)
  if 0 < tempCount then
    self.scroll_view:SetTotalCount(tempCount)
    self.scroll_view:RefillCells()
  end
end

function LWUIMigrationSetAllyRecruitLanguageView:OnCellMoveIn(itemObj, index)
  local tempType = self.list[index]
  itemObj.name = tempType
  local cellItem = self.scroll_view:AddComponent(UISettingLanguageCell, itemObj)
  local param = UISettingLanguageCell.Param.New()
  param.index = index
  param.name = SuportedLanguagesName[tempType]
  param.isSelect = self.selectIndex == index
  
  function param.callBack(tempIndex)
    self:CellCallBack(tempIndex)
  end
  
  param.languageIndex = tempType
  param.settingType = SettingType.Language
  cellItem:ReInit(param)
  self.cells[index] = cellItem
end

function LWUIMigrationSetAllyRecruitLanguageView:OnCellMoveOut(itemObj, index)
  self.cells[index] = nil
  self.scroll_view:RemoveComponent(itemObj.name, UISettingLanguageCell)
end

function LWUIMigrationSetAllyRecruitLanguageView:ClearScroll()
  self.cells = {}
  self.scroll_view:ClearCells()
  self.scroll_view:RemoveComponents(UISettingLanguageCell)
end

function LWUIMigrationSetAllyRecruitLanguageView:CellCallBack(index)
  if self.selectIndex == index then
    return
  end
  self:SetCellsSelect(self.selectIndex, false)
  self.selectIndex = index
  self:SetCellsSelect(index, true)
end

function LWUIMigrationSetAllyRecruitLanguageView:SetCellsSelect(index, value)
  local temp = self.cells[index]
  if temp ~= nil then
    temp:SetSelect(value)
  end
end

return LWUIMigrationSetAllyRecruitLanguageView
