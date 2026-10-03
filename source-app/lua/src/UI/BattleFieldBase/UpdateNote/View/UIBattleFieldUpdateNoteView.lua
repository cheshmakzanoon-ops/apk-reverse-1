local UIBattleFieldUpdateNoteView = BaseClass("UIBattleFieldUpdateNoteView", UIBaseView)
local base = UIBaseView
local ItemCell = require("UI.BattleFieldBase.UpdateNote.Component.UIBattleFieldUpdateNoteItem")
local panel_path = "panel"
local title_text_path = "Bg/TitleText"
local season_bg_path = "Bg/SeasonBg"
local season_path = "Bg/SeasonBg/Season"
local scroll_view_path = "Bg/ScrollView"
local content_path = "Bg/ScrollView/Viewport/Content"
local page_cell_path = "Bg/PageCell"
local page_identify_root_path = "Bg/PageIdentify"
local page_identify_path = "Bg/PageItem"
local left_arrow_path = "Bg/LeftArrow"
local right_arrow_path = "Bg/RightArrow"
local btn_path = "Bg/Btn"
local RESOURCE_PATH = "Assets/Main/Sprites/UI/LWUIResource/cfm_tianxiadashi_S"

function UIBattleFieldUpdateNoteView:OnCreate()
  base.OnCreate(self)
  local goCb = BindCallback(self, self.OnBtnGo)
  self.panel = self:AddComponent(UIButton, panel_path)
  self.panel:SetOnClick(goCb)
  self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_text_path)
  self.season_bg = self:AddComponent(UIBaseComponent, season_bg_path)
  self.season = self:AddComponent(UIImage, season_path)
  self.scroll_view = self:AddComponent(UIScrollPage, scroll_view_path)
  self.scroll_view:SetPageChangedCallback(BindCallback(self, self.OnUpdateScroll))
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.page_identify = self:AddComponent(UIBaseContainer, page_identify_root_path)
  self.left_arrow = self:AddComponent(UIButton, left_arrow_path)
  self.left_arrow:SetOnClick(function()
    self.scroll_view:ToPrevPage()
    self:OnUpdateScroll(self.scroll_view.currentPageIndex)
  end)
  self.right_arrow = self:AddComponent(UIButton, right_arrow_path)
  self.right_arrow:SetOnClick(function()
    self.scroll_view:ToNextPage()
    self:OnUpdateScroll(self.scroll_view.currentPageIndex)
  end)
  self.thePageItem = self.transform:Find(page_cell_path).gameObject
  self.thePageItem:GameObjectCreatePool()
  self.thePageIdentifyItem = self.transform:Find(page_identify_path).gameObject
  self.thePageIdentifyItem:GameObjectCreatePool()
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(goCb)
  self.bfType, self.season = self:GetUserData()
  self.season = self.season or 0
  self.season_bg:SetActive(self.season > 0)
  if self.season > 0 then
    self.season:LoadSpriteAuto(string.format(RESOURCE_PATH, self.season))
  end
  local curGroup = BattleFieldUtil.GetBattleFieldCfgValue(self.bfType, BattleFieldTableKey.UPDATE)
  local updateList = {}
  LocalController:instance():visitTable(TableName.LW_BattleField_Update_Note, function(_, lineData)
    local group = lineData:getValue("group")
    if group ~= curGroup then
      return
    end
    table.insert(updateList, {
      id = lineData:getIntValue("id"),
      desc = lineData:getIntValue("desc"),
      pic = lineData:getIntValue("pic")
    })
  end)
  table.sort(updateList, function(a, b)
    return a.id < b.id
  end)
  local toggleList = {}
  local listCnt = #updateList
  if 0 < listCnt then
    for index, v in ipairs(updateList) do
      local theName = "page_" .. index
      local goItem = self.thePageItem:GameObjectSpawn(self.content.transform)
      goItem.name = theName
      goItem:SetActive(true)
      local itemNode = self.content:AddComponent(ItemCell, theName)
      itemNode:ReInit(v, index, listCnt)
      goItem = self.thePageIdentifyItem:GameObjectSpawn(self.page_identify.transform)
      goItem.name = theName
      goItem:SetActive(true)
      local itemToggle = self.page_identify:AddComponent(UIToggle, theName)
      local theIndex = index
      itemToggle:SetIsOn(false)
      toggleList[index] = itemToggle
      itemToggle:SetOnValueChanged(function(tf)
        if tf then
          self.scroll_view:PageTo(theIndex)
        end
      end)
    end
  end
  self.toggleList = toggleList
  self.scroll_view:SetPageCount(listCnt)
  self.scroll_view:PageTo(1)
  toggleList[1]:SetIsOn(true)
end

function UIBattleFieldUpdateNoteView:OnDestroy()
  self.content:RemoveComponents(ItemCell)
  self.thePageItem:GameObjectRecycleAll()
  self.page_identify:RemoveComponents(UIToggle)
  self.thePageIdentifyItem:GameObjectRecycleAll()
  self.panel = nil
  self.title_text = nil
  self.season_bg = nil
  self.season = nil
  self.left_arrow = nil
  self.right_arrow = nil
  self.scroll_view = nil
  self.content = nil
  self.page_identify = nil
  self.thePageItem = nil
  self.thePageIdentifyItem = nil
  self.btn = nil
  base.OnDestroy(self)
end

function UIBattleFieldUpdateNoteView:OnUpdateScroll(index)
  local itemToggle = self.toggleList[index]
  if itemToggle ~= nil then
    itemToggle:SetIsOn(true)
  end
  self.left_arrow:SetActive(1 < index)
  self.right_arrow:SetActive(index < #self.toggleList)
end

function UIBattleFieldUpdateNoteView:OnBtnGo()
  BattleFieldUtil.SignUpdateNoteFlag(self.bfType, self.season)
  self.ctrl:CloseSelf()
end

return UIBattleFieldUpdateNoteView
