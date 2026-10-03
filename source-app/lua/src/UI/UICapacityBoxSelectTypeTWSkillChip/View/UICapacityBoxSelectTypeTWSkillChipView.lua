local UICapacityBoxSelectTypeTWSkillChipItem = require("UI.UICapacityBoxSelectTypeTWSkillChip.Component.UICapacityBoxSelectTypeTWSkillChipItem")
local UICapacityBoxSelectTypeTWSkillChipView = BaseClass("UICapacityBoxSelectTypeTWSkillChipView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local selected_use_area_path = "ContentArea/itemContent/BtnArea/SelectedUseArea"
local info_input_path = "ContentArea/itemContent/BtnArea/SelectedUseArea/InfoInput"
local dec_btn_path = "ContentArea/itemContent/BtnArea/SelectedUseArea/InfoInput/DecBtn"
local slider_path = "ContentArea/itemContent/BtnArea/SelectedUseArea/InfoInput/Slider"
local add_btn_path = "ContentArea/itemContent/BtnArea/SelectedUseArea/InfoInput/AddBtn"
local count_text_path = "ContentArea/itemContent/BtnArea/SelectedUseArea/InfoInput/TextBg/CountText"
local curNumIpt_path = "ContentArea/itemContent/BtnArea/SelectedUseArea/InfoInput/TextBg/curCountIpt"
local cell_content_path = "ContentArea/itemContent/cellContent"
local select_box_item_path = "ContentArea/itemContent/cellContent/selectBoxItem"

function UICapacityBoxSelectTypeTWSkillChipView:OnCreate()
  base.OnCreate(self)
  local itemUuid, count, template = self:GetUserData()
  self.itemUuid = itemUuid
  self.count = count
  self.template = template
  self.tagTypeList = {
    HeroType.Tank,
    HeroType.Missile,
    HeroType.Aircraft
  }
  self.showData = {}
  self.selectTagTypeIndex = 1
  self.selectItemIndex = 0
  self.selectCount = count or 1
  self:ComponentDefine()
  self:ReInit()
  self:RefreshView()
end

function UICapacityBoxSelectTypeTWSkillChipView:OnDestroy()
  self:ClearScroll()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UICapacityBoxSelectTypeTWSkillChipView:ComponentDefine()
  self._return_panel = self:AddComponent(UIButton, "UICommonPopUpTitle/panel")
  self._return_panel:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self.ctrl:CloseSelf()
  end)
  self.close_btn = self:AddComponent(UIButton, "UICommonPopUpTitle/CloseBtn")
  self.close_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self.ctrl:CloseSelf()
  end)
  self.txt_title = self:AddComponent(UIText, "UICommonPopUpTitle/Common_img_title/titleText")
  self.txt_title:SetLocalText(self.template.name)
  self._content_rect = self:AddComponent(UIBaseContainer, "ContentArea/itemContent/Rect_ScrollView/Viewport/Content")
  self._use_btn = self:AddComponent(UIButton, "ContentArea/itemContent/Btn_Use")
  self._use_txt = self:AddComponent(UIText, "ContentArea/itemContent/Btn_Use/Txt_Use")
  self._use_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:UseItem()
  end)
  self.btn_area = self:AddComponent(UIBaseContainer, "ContentArea/itemContent/BtnArea")
  self.selected_use_area = self:AddComponent(UIBaseContainer, selected_use_area_path)
  self.info_input = self:AddComponent(UIBaseContainer, info_input_path)
  self.dec_btn = self:AddComponent(UIButton, dec_btn_path)
  self.dec_btn:SetOnClick(function()
    if self.notChangeData then
      return
    end
    self:SetSelectCount(self.selectCount - 1)
  end)
  self.add_btn = self:AddComponent(UIButton, add_btn_path)
  self.add_btn:SetOnClick(function()
    if self.notChangeData then
      return
    end
    self:SetSelectCount(self.selectCount + 1)
  end)
  self.slider = self:AddComponent(UISlider, slider_path)
  self.slider:SetOnValueChanged(function(value)
    if self.notChangeData then
      return
    end
    local haveCount = DataCenter.ItemData:GetItemCount(self.template.id)
    self:SetSelectCount(math.floor(value * haveCount))
  end)
  self.count_text = self:AddComponent(UIText, count_text_path)
  self.curNumIptN = self:AddComponent(UIInput, curNumIpt_path)
  self.curNumIptN:SetOnEndEdit(function(value)
    if self.notChangeData then
      return
    end
    local num = toInt(value) or 1
    self:SetSelectCount(num)
  end)
  self.compTabLayout = self:AddComponent(UIBaseContainer, "ContentArea/TabLayout")
  self.compTabList = {}
  for i, v in ipairs(self.tagTypeList) do
    local tab = {}
    tab.tabType = v
    local tabPath = "ContentArea/TabLayout/Tab" .. tostring(v)
    tab.objRoot = self:AddComponent(UIBaseContainer, tabPath)
    tab.objSelect = tab.objRoot:AddComponent(UIBaseContainer, "Select")
    tab.objUnSelect = tab.objRoot:AddComponent(UIBaseContainer, "UnSelect")
    tab.btn = tab.objRoot:AddComponent(UIButton, "Btn")
    local index = i
    local heroType = v
    tab.btn:SetOnClick(function()
      self:OnSelectTab(index)
    end)
    self.compTabList[index] = tab
  end
  self.cell_content = self:AddComponent(UIBaseContainer, cell_content_path)
  self.select_box_item = self:AddComponent(UIButton, select_box_item_path)
  self.cell_content:SetActive(false)
  self.select_box_item:SetActive(false)
  self.itemList = {}
  self.select_box_item.gameObject:GameObjectCreatePool()
end

function UICapacityBoxSelectTypeTWSkillChipView:ComponentDestroy()
  self._return_panel = nil
  self.close_btn = nil
  self.txt_title = nil
  self._content_rect = nil
  self._use_btn = nil
  self._use_txt = nil
  self.itemNameText = nil
  self.itemDescText = nil
  self.itemDescTextContent = nil
  self.cell_content = nil
  self.select_box_item = nil
end

function UICapacityBoxSelectTypeTWSkillChipView:OnEnable()
  base.OnEnable(self)
  self.notChangeData = false
end

function UICapacityBoxSelectTypeTWSkillChipView:OnDisable()
  base.OnDisable(self)
end

function UICapacityBoxSelectTypeTWSkillChipView:OnAddListener()
  base.OnAddListener(self)
end

function UICapacityBoxSelectTypeTWSkillChipView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UICapacityBoxSelectTypeTWSkillChipView:ReInit()
  self._use_txt:SetLocalText(110046)
  self:ClearScroll()
  self.modelCells = {}
  self:SetShowData()
end

function UICapacityBoxSelectTypeTWSkillChipView:SetShowData()
  self.showData = {}
  local List = {}
  if self.template.type == GOODS_TYPE.GOODS_TYPE_59 then
    List = string.split(self.template.para1, "|")
  end
  local chipDataList = {}
  for order, itemIdDara in ipairs(List) do
    local strList = string.split(itemIdDara, ",")
    local itemId = tonumber(strList[1])
    local itemtemp = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
    if itemtemp and itemtemp.linked_item_type == ItemLinkType.DroneSkillChip then
      local chipId = itemtemp.linked_item_id
      local chipTemplate = DataCenter.TWSkillChipTemplateManager:GetTemplate(chipId)
      if chipTemplate then
        local heroType = chipTemplate.heroType
        local data = {
          itemId = itemId,
          order = order,
          itemtemp = itemtemp,
          chipId = chipId,
          chipTemplate = chipTemplate,
          heroType = heroType
        }
        if not chipDataList[heroType] then
          chipDataList[heroType] = {}
        end
        chipDataList[heroType][data.chipTemplate.skill_type] = data
      end
    end
  end
  local commonDataList = chipDataList[HeroType.All]
  for _, heroType in ipairs(self.tagTypeList) do
    if chipDataList[heroType] then
      self.showData[heroType] = chipDataList[heroType]
      if commonDataList and 0 < #commonDataList then
        for _, data in ipairs(commonDataList) do
          table.insert(self.showData[heroType], data)
        end
      end
    end
  end
  for heroType, dataList in pairs(self.showData) do
    table.sort(dataList, function(a, b)
      return a.order < b.order
    end)
  end
  for index, heroType in ipairs(self.tagTypeList) do
    if self.showData[heroType] and #self.showData[heroType] > 0 then
      self.selectTagTypeIndex = index
      self.selectItemIndex = 0
      break
    end
  end
end

function UICapacityBoxSelectTypeTWSkillChipView:OnSelectItem(id, index)
  if self.selectItemIndex == index then
    return
  end
  self.selectItemIndex = index
  self:RefreshView()
end

function UICapacityBoxSelectTypeTWSkillChipView:ClearScroll()
  self._content_rect:RemoveComponents(UICapacityBoxSelectTypeTWSkillChipItem)
  for _, v in ipairs(self._content_rect.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  self.select_box_item.gameObject:GameObjectRecycleAll()
  self.itemList = {}
end

function UICapacityBoxSelectTypeTWSkillChipView:UseItem()
  if self.selectItemIndex == 0 then
    UIUtil.ShowTips("itembox_use_alert1")
    return
  end
  local tagType = self.tagTypeList[self.selectTagTypeIndex]
  local dataList = self.showData[tagType]
  local data = dataList[self.selectItemIndex]
  self.selectIndex = data.order
  self.ctrl:UseItem(self.template.type, self.itemUuid, self.selectCount, self.selectIndex)
end

function UICapacityBoxSelectTypeTWSkillChipView:SetSelectCount(selectCount)
  local haveCount = DataCenter.ItemData:GetItemCount(self.template.id)
  if selectCount > haveCount then
    selectCount = haveCount
  end
  if selectCount <= 1 then
    selectCount = 1
  end
  self.selectCount = selectCount
  self:RefreshAreaView()
end

function UICapacityBoxSelectTypeTWSkillChipView:OnSelectTab(selectTagTypeIndex)
  if selectTagTypeIndex == self.selectTagTypeIndex then
    return
  end
  self.selectTagTypeIndex = selectTagTypeIndex
  self.selectItemIndex = 0
  self:RefreshView()
  self._content_rect:SetAnchoredPositionXY(0, 0)
end

function UICapacityBoxSelectTypeTWSkillChipView:RefreshView()
  self:RefreshTagView()
  self:RefreshItemListView()
  self:RefreshAreaView()
end

function UICapacityBoxSelectTypeTWSkillChipView:RefreshTagView()
  if self.compTabList == nil then
    return
  end
  local tagNum = table.count(self.showData)
  if tagNum <= 1 then
    self.compTabLayout:SetActive(false)
  else
    self.compTabLayout:SetActive(true)
  end
  for i, v in ipairs(self.compTabList) do
    local type = self.tagTypeList[i]
    v.objRoot:SetActive(self.showData[type])
    local isSelect = i == self.selectTagTypeIndex
    v.objSelect:SetActive(isSelect)
    v.objUnSelect:SetActive(not isSelect)
  end
end

function UICapacityBoxSelectTypeTWSkillChipView:RefreshItemListView()
  local tagType = self.tagTypeList[self.selectTagTypeIndex]
  local dataList = self.showData[tagType]
  for i, data in ipairs(dataList) do
    if not self.itemList[i] then
      local item = self.select_box_item.gameObject:GameObjectSpawn(self._content_rect.transform)
      item.name = "SkillChipItem" .. tostring(i)
      local obj = self._content_rect:AddComponent(UICapacityBoxSelectTypeTWSkillChipItem, item.name)
      obj:SetActive(true)
      self.itemList[i] = obj
    end
    self.itemList[i]:RefreshData(data, i, function(data, index)
      self:OnSelectItem(data.itemId, index)
    end, i == self.selectItemIndex)
  end
  for i = #dataList + 1, #self.itemList do
    self.itemList[i]:SetActive(false)
  end
end

function UICapacityBoxSelectTypeTWSkillChipView:RefreshAreaView()
  self.btn_area:SetActive(self.selectItemIndex > 0)
  UIGray.SetGray(self._use_btn.transform, self.selectItemIndex <= 0, true)
  if self.selectItemIndex > 0 then
    local selectCount = self.selectCount
    local haveCount = DataCenter.ItemData:GetItemCount(self.template.id)
    if selectCount > haveCount then
      selectCount = haveCount
    end
    if selectCount <= 0 then
      selectCount = 1
    end
    self.selectCount = selectCount
    self.count_text:SetText(self.selectCount)
    self.notChangeData = true
    self.slider:SetValue(self.selectCount / haveCount)
    self.curNumIptN:SetText(self.selectCount)
    self.notChangeData = false
    UIGray.SetGray(self.dec_btn.transform, selectCount <= 1, true)
    UIGray.SetGray(self.add_btn.transform, haveCount <= selectCount, true)
  end
end

return UICapacityBoxSelectTypeTWSkillChipView
