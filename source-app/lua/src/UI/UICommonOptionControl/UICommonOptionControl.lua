local UICommonOptionControl = BaseClass("UICommonOptionControl", UIBaseContainer)
local UICommonTab = require("UI.UICommonTab.UICommonTab")
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local arrow_path = "optionBtn/arrow"
local open_btn_path = "optionBtn/openBtn"
local text_path = "optionBtn/curOptionTitle"
local options_path = "optionList/options"
local close_btn_path = "optionList/closeBtn"
local option_list_path = "optionList"

function UICommonOptionControl:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UICommonOptionControl:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UICommonOptionControl:ComponentDefine()
  self.curOptionTitle = self:AddComponent(UITextMeshProUGUIEx, text_path)
  self.open_btn = self:AddComponent(UIButton, open_btn_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.options = self:AddComponent(UIBaseContainer, options_path)
  self.arrow = self:AddComponent(UIImage, arrow_path)
  self.option_list = self:AddComponent(UIBaseContainer, option_list_path)
  self.open_btn:SetOnClick(function()
    self:OnOpenBtnClick()
  end)
  self.close_btn:SetOnClick(function()
    self:OnCloseBtnClick()
  end)
  self.optionCellReqList = {}
  self.optionCellList = {}
  self.loadCount = 0
end

function UICommonOptionControl:ComponentDestroy()
  self:ClearOptionCells()
  self.optionCellList = nil
  self.curOptionTitle = nil
  self.open_btn = nil
  self.close_btn = nil
  self.options = nil
  self.arrow = nil
  self.option_list = nil
  self.open_btn = nil
  self.close_btn = nil
  self.loadCount = nil
end

function UICommonOptionControl:ReInit(param)
  if param == nil then
    Logger.LogError("param is nil")
    return
  end
  self.defaultOptionId = param.defaultOptionId
  self.optionParamList = param.optionParamList
  self.optionClickHandler = param.optionClickHandler
  self.customHolder = param.customHolder
  self.openBtnClickHandler = param.openBtnClickHandler
  self.closeBtnClickHandler = param.closeBtnClickHandler
  self.optionPrefabPath = param.optionPrefabPath or UIAssets.UICommonTab
  self.initCompleteHandler = param.initCompleteHandler
  self.option_list:SetActive(false)
  self:InitOptionCells()
end

function UICommonOptionControl:PreSetArrowDefaultDir(dir)
  self.arrowDefaultDir = dir
end

function UICommonOptionControl:InitOptionCells()
  for i = 1, table.count(self.optionParamList) do
    self.optionCellReqList[i] = self:CreateOptionCell(i, self.optionParamList[i])
  end
end

function UICommonOptionControl:CreateOptionCell(index, param)
  local req = self:GameObjectInstantiateAsync(self.optionPrefabPath, function(request)
    if request.isError then
      return
    end
    local go = request.gameObject
    go:SetActive(true)
    go.transform:SetParent(self.options.transform)
    go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    local nameStr = "option_" .. index
    go.name = nameStr
    local cell = self.options:AddComponent(UICommonTab, nameStr)
    param.clickHandler = self.OnOptionClick
    param.customHolder = self
    cell:ReInit(param)
    cell:SetSelect(false)
    self.optionCellList[index] = cell
    self.loadCount = self.loadCount + 1
    if self.loadCount == table.count(self.optionParamList) then
      self:OnLoadAllOptionComplete()
    end
  end)
  return req
end

function UICommonOptionControl:OnLoadAllOptionComplete()
  for i = 1, table.count(self.optionCellList) do
    local cell = self.optionCellList[i]
    if cell.tabId == self.defaultOptionId then
      self:OnOptionClick(cell)
      break
    end
  end
  if self.initCompleteHandler then
    if self.customHolder then
      self.initCompleteHandler(self.customHolder, tabItem)
    else
      self.initCompleteHandler(self.holder, tabItem)
    end
  end
end

function UICommonOptionControl:OnOptionClick(tabItem)
  if self.curTab ~= nil then
    if self.curTab.tabId == tabItem.tabId then
      return
    else
      self.curTab:SetSelect(false)
    end
  end
  self.curTab = tabItem
  self.curTab:SetSelect(true)
  if self.optionClickHandler then
    if self.customHolder then
      self.optionClickHandler(self.customHolder, tabItem)
    else
      self.optionClickHandler(self.holder, tabItem)
    end
  end
  self.curOptionTitle:SetText(self.curTab.title)
end

function UICommonOptionControl:OnOpenBtnClick()
  if self.openBtnClickHandler then
    if self.customHolder then
      self.closeBtnClickHandler(self.customHolder)
    else
      self.closeBtnClickHandler(self.holder)
    end
  end
  self.option_list:SetActive(true)
end

function UICommonOptionControl:OnCloseBtnClick()
  if self.openBtnClickHandler then
    if self.customHolder then
      self.closeBtnClickHandler(self.customHolder)
    else
      self.closeBtnClickHandler(self.holder)
    end
  end
  self.option_list:SetActive(false)
end

function UICommonOptionControl:ReversalArrow(dir)
end

function UICommonOptionControl:GetCurOptionId()
  if self.curTab then
    return self.curTab.tabId
  end
  return self.defaultOptionId
end

function UICommonOptionControl:CloseOptionList()
  if self.option_list then
    self.option_list:SetActive(false)
  end
end

function UICommonOptionControl:ClearOptionCells()
  if self.optionCellReqList then
    self.options:RemoveComponents(UICommonTab)
    for k, v in ipairs(self.optionCellReqList) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
end

return UICommonOptionControl
