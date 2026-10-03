local LWUIMigrationSetLanguageView = BaseClass("LWUIMigrationSetLanguageView", UIBaseView)
local base = UIBaseView
local UISettingLanguageCell = require("UI.UISetting.UISettingLanguage.Component.UISettingLanguageCell")
local txt_title_path = "Root/Content/UICommonPopBg/bg_3/TitleTxt"
local close_btn_path = "Panel"
local return_btn_path = "Root/Content/UICommonPopBg/bg_3/CloseBtn"
local scroll_view_path = "Root/Content/ImgBg/ScrollView"
local conform_btn_path = "Root/Content/ConfirmButton"
local conform_name_path = "Root/Content/ConfirmButton/ConfirmTitleTxt"

function LWUIMigrationSetLanguageView:OnCreate()
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

function LWUIMigrationSetLanguageView:OnDestroy()
  self:ClearScroll()
  self.list = nil
  self.cells = nil
  self.selectIndex1 = nil
  self.selectIndex2 = nil
  self.initLanguage1 = nil
  self.initLanguage2 = nil
  self.sInfo = nil
  self.cb = nil
  base.OnDestroy(self)
end

function LWUIMigrationSetLanguageView:DataDefine()
  self.list = {}
  self.cells = {}
  self.selectIndex1 = nil
  self.selectIndex2 = nil
  local sInfo, cb = self:GetUserData()
  self.sInfo = sInfo
  self.cb = cb
  self.initLanguage1 = sInfo.languageList[1]
  self.initLanguage2 = sInfo.languageList[2]
end

function LWUIMigrationSetLanguageView:OnConfirmBtnClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  local lang1 = self.list[self.selectIndex1] or ""
  local lang2 = self.list[self.selectIndex2] or ""
  if self.cb then
    local localNames = SuportedLanguagesLocalName
    self.cb(localNames[lang1] or "", localNames[lang2] or "")
  end
  self.ctrl:CloseSelf()
end

function LWUIMigrationSetLanguageView:GetShowList()
  local list = {}
  local supportedLanguages = SuportedLanguages
  local localNames = SuportedLanguagesLocalName
  for _, v in ipairs(supportedLanguages) do
    if not (not (v == Language.ChineseSimplified and LuaEntry.Player:GetGMFlag() <= 0) or CommonUtil.IsDebug()) then
      break
    end
    local key = localNames[v]
    if key == self.initLanguage1 then
      table.insert(list, 1, v)
      self.selectIndex1 = 1
    elseif key == self.initLanguage2 then
      if 1 < #list then
        table.insert(list, 2, v)
      else
        table.insert(list, 1, v)
      end
      self.selectIndex2 = 2
    else
      table.insert(list, v)
    end
  end
  return list
end

function LWUIMigrationSetLanguageView:ShowCells()
  self:ClearScroll()
  self.list = self:GetShowList()
  local tempCount = table.count(self.list)
  if 0 < tempCount then
    self.scroll_view:SetTotalCount(tempCount)
    self.scroll_view:RefillCells()
  end
end

function LWUIMigrationSetLanguageView:OnCellMoveIn(itemObj, index)
  local tempType = self.list[index]
  itemObj.name = tempType
  local cellItem = self.scroll_view:AddComponent(UISettingLanguageCell, itemObj)
  local param = UISettingLanguageCell.Param.New()
  param.index = index
  param.name = SuportedLanguagesName[tempType]
  param.isSelect = self.selectIndex1 == index or self.selectIndex2 == index
  
  function param.callBack(tempIndex)
    self:CellCallBack(tempIndex)
  end
  
  param.languageIndex = tempType
  param.settingType = SettingType.Language
  cellItem:ReInit(param)
  self.cells[index] = cellItem
end

function LWUIMigrationSetLanguageView:OnCellMoveOut(itemObj, index)
  self.cells[index] = nil
  self.scroll_view:RemoveComponent(itemObj.name, UISettingLanguageCell)
end

function LWUIMigrationSetLanguageView:ClearScroll()
  self.cells = {}
  self.scroll_view:ClearCells()
  self.scroll_view:RemoveComponents(UISettingLanguageCell)
end

function LWUIMigrationSetLanguageView:CellCallBack(index)
  if self.selectIndex1 == index then
    self:SetCellsSelect(self.selectIndex1, false)
    self.selectIndex1 = nil
    return
  end
  if self.selectIndex2 == index then
    self:SetCellsSelect(self.selectIndex2, false)
    self.selectIndex2 = nil
    return
  end
  if self.selectIndex1 ~= nil and self.selectIndex2 ~= nil then
    UIUtil.ShowTipsId("migration_activity_tips_20031")
    return
  end
  self:SetCellsSelect(index, true)
  if self.selectIndex1 == nil then
    self.selectIndex1 = index
  elseif self.selectIndex2 == nil then
    self.selectIndex2 = index
  end
end

function LWUIMigrationSetLanguageView:SetCellsSelect(index, value)
  local temp = self.cells[index]
  if temp ~= nil then
    temp:SetSelect(value)
  end
end

return LWUIMigrationSetLanguageView
