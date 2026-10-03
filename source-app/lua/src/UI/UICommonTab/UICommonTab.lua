local UICommonTab = BaseClass("UICommonTab", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local un_select_flag_path = "unSelectFlag"
local select_flag_path = "selectFlag"
local btn_path = "btn"
local un_select_title_path = "unSelectFlag/unSelectTitle"
local select_title_path = "selectFlag/selectTitle"
local red_dot_path = "RedDot"

function UICommonTab:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UICommonTab:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UICommonTab:ComponentDefine()
  self.un_select_flag = self:AddComponent(UIImage, un_select_flag_path)
  self.select_flag = self:AddComponent(UIImage, select_flag_path)
  self.selectTitle = self:AddComponent(UITextMeshProUGUIEx, select_title_path)
  self.unSelectTitle = self:AddComponent(UITextMeshProUGUIEx, un_select_title_path)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(function()
    if self.clickHandler then
      if self.customHolder then
        self.clickHandler(self.customHolder, self)
      else
        self.clickHandler(self.holder, self)
      end
    end
  end)
  self.red_dot = self:TryAddComponent(UIBaseContainer, red_dot_path)
  self:SetRedDotVisible(false)
end

function UICommonTab:ComponentDestroy()
  self.un_select_flag = nil
  self.select_flag = nil
  self.selectTitle = nil
  self.unSelectTitle = nil
  self.btn = nil
  self.clickHandler = nil
  self.containPanel = nil
  self.tabId = nil
end

function UICommonTab:ReInit(param)
  if param == nil then
    Logger.LogError("need param with 'clickHandler' and 'titleId' and 'c")
    return
  end
  self.tabId = param.tabId
  self.title = param.title
  self.clickHandler = param.clickHandler
  self.containPanel = param.containPanel
  self.customHolder = param.customHolder
  self.selectTitle:SetText(param.title)
  self.unSelectTitle:SetText(param.title)
end

function UICommonTab:SetSelect(visible)
  self.select_flag:SetActive(visible)
  self.un_select_flag:SetActive(not visible)
  if self.containPanel then
    self.containPanel:SetActive(visible)
  end
end

function UICommonTab:SetRedDotVisible(visible)
  if self.red_dot then
    self.red_dot.gameObject:SetActive(visible)
  end
end

function UICommonTab:SetPacking(selectImg, unSelectImg, selectTitleColor, unSelectTitleColor)
  if not string.IsNullOrEmpty(selectImg) then
    self.select_flag:LoadSprite(selectImg)
  end
  if not string.IsNullOrEmpty(unSelectImg) then
    self.un_select_flag:LoadSprite(unSelectImg)
  end
  if selectTitleColor then
    self.selectTitle:SetColor(selectTitleColor)
  end
  if unSelectTitleColor then
    self.unSelectTitle:SetColor(unSelectTitleColor)
  end
end

return UICommonTab
