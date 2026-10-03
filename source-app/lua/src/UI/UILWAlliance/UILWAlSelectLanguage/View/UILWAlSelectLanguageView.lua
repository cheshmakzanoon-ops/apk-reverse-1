local UILWAlSelectLanguageView = BaseClass("UILWAlSelectLanguageView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UILWAlSelectLanguageCell = require("UI.UILWAlliance.UILWAlSelectLanguage.Component.UILWAlSelectLanguageCell")
local txt_title_path = "Root/Content/UICommonPopBg/bg_3/TitleTxt"
local close_btn_path = "Panel"
local return_btn_path = "Root/Content/UICommonPopBg/bg_3/CloseBtn"
local scroll_view_path = "Root/Content/ImgBg/ScrollView"
local conform_btn_path = "Root/Content/ConfirmButton"
local conform_name_path = "Root/Content/ConfirmButton/ConfirmTitleTxt"
local TITLE_TXT = 100101

function UILWAlSelectLanguageView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWAlSelectLanguageView:OnDestroy()
  self:ClearScroll()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWAlSelectLanguageView:ComponentDefine()
  self.txt_title = self:AddComponent(UIText, txt_title_path)
  self.txt_title:SetLocalText(TITLE_TXT)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.return_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
  self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnCellMoveIn(itemObj, index)
  end)
  self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnCellMoveOut(itemObj, index)
  end)
  self.conform_name = self:AddComponent(UIText, conform_name_path)
  self.conform_name:SetLocalText(GameDialogDefine.CONFIRM)
  self.conform_btn = self:AddComponent(UIButton, conform_btn_path)
  self.conform_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnConfirmBtnClick()
  end)
end

function UILWAlSelectLanguageView:ComponentDestroy()
  self.txt_title = nil
  self.close_btn = nil
  self.return_btn = nil
  self.scroll_view = nil
  self.conform_btn = nil
  self.conform_name = nil
end

function UILWAlSelectLanguageView:DataDefine()
  self.list = {}
  self.cells = {}
  self.selectIndex = nil
  self.curLanguage = nil
  self.confirmCallBack = nil
end

function UILWAlSelectLanguageView:DataDestroy()
  self.list = nil
  self.cells = nil
  self.selectIndex = nil
  self.curLanguage = nil
  self.confirmCallBack = nil
end

function UILWAlSelectLanguageView:OnEnable()
  base.OnEnable(self)
  self:ReInit()
end

function UILWAlSelectLanguageView:OnDisable()
  base.OnDisable(self)
end

function UILWAlSelectLanguageView:OnAddListener()
  base.OnAddListener(self)
end

function UILWAlSelectLanguageView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWAlSelectLanguageView:ReInit()
  local param = self:GetUserData()
  self.curLanguage = param.curLanguage
  self.confirmCallBack = param.callback
  self:ShowCells()
end

function UILWAlSelectLanguageView:ShowCells()
  self:ClearScroll()
  self.list = self:GetShowList()
  local tempCount = table.count(self.list)
  if 0 < tempCount then
    self.scroll_view:SetTotalCount(tempCount)
    self.scroll_view:RefillCells()
  end
end

function UILWAlSelectLanguageView:ClearScroll()
  self.cells = {}
  self.scroll_view:ClearCells()
  self.scroll_view:RemoveComponents(UILWAlSelectLanguageCell)
end

function UILWAlSelectLanguageView:GetShowList()
  local list = {}
  for k, v in ipairs(SuportedLanguages) do
    if v ~= Language.ChineseSimplified then
      local language = SuportedLanguagesLocalName[v]
      if language then
        table.insert(list, language)
        if language == self.curLanguage then
          self.selectIndex = k
        end
      end
    end
  end
  return list
end

function UILWAlSelectLanguageView:OnCellMoveIn(itemObj, index)
  local name = self.list[index]
  itemObj.name = name
  local cellItem = self.scroll_view:AddComponent(UILWAlSelectLanguageCell, itemObj)
  local param = {
    index = index,
    name = name,
    isSelect = self.selectIndex == index,
    callBack = function(tempIndex)
      self:CellCallBack(tempIndex)
    end
  }
  cellItem:ReInit(param)
  self.cells[index] = cellItem
end

function UILWAlSelectLanguageView:CellCallBack(index)
  if self.selectIndex ~= index then
    self:SetCellsSelect(self.selectIndex, false)
    self:SetCellsSelect(index, true)
    self.selectIndex = index
  end
end

function UILWAlSelectLanguageView:SetCellsSelect(index, value)
  local cell = self.cells[index]
  if cell ~= nil then
    cell:SetSelect(value)
  end
end

function UILWAlSelectLanguageView:OnCellMoveOut(itemObj, index)
  self.cells[index] = nil
  self.scroll_view:RemoveComponent(itemObj.name, UILWAlSelectLanguageCell)
end

function UILWAlSelectLanguageView:OnConfirmBtnClick()
  self.curLanguage = self.list[self.selectIndex]
  if self.confirmCallBack then
    self.confirmCallBack(self.curLanguage)
  end
  self.ctrl:CloseSelf()
end

return UILWAlSelectLanguageView
