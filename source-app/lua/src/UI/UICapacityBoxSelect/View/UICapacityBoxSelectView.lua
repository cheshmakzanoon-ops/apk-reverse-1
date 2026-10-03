local UICapacityBoxHeroItem = require("UI.UICapacityBoxSelect.Component.UICapacityBoxHeroItem")
local UICapacityBoxItem = require("UI.UICapacityBoxSelect.Component.UICapacityBoxItem")
local UICapacityBoxSelectView = BaseClass("UICapacityBoxSelectView", UIBaseView)
local base = UIBaseView
local string_GetFormattedStr2 = string.GetFormattedStr2
local tonumber = _ENV.tonumber
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local GOODS_TYPE = _ENV.GOODS_TYPE
local DataCenter = _ENV.DataCenter
local selected_use_area_path = "ContentArea/BtnArea/SelectedUseArea"
local info_input_path = "ContentArea/BtnArea/SelectedUseArea/InfoInput"
local dec_btn_path = "ContentArea/BtnArea/SelectedUseArea/InfoInput/DecBtn"
local slider_path = "ContentArea/BtnArea/SelectedUseArea/InfoInput/Slider"
local add_btn_path = "ContentArea/BtnArea/SelectedUseArea/InfoInput/AddBtn"
local count_text_path = "ContentArea/BtnArea/SelectedUseArea/InfoInput/TextBg/CountText"
local res_total_num_group_path = "ContentArea/BtnArea/SelectedUseArea/InfoInput/TextBg/ResTotalNumGroup"
local got_total_num_path = "ContentArea/BtnArea/SelectedUseArea/InfoInput/TextBg/ResTotalNumGroup/GotTotalNum"

function UICapacityBoxSelectView:OnCreate()
  base.OnCreate(self)
  local itemUuid, count, template, isNoCapacity, viewMode, param = self:GetUserData()
  self.itemUuid = itemUuid
  self.count = count
  self.template = template
  self.selectHeroId = 0
  self.selectIndex = 0
  self.isNoCapacity = isNoCapacity
  self.viewMode = viewMode
  self.param = param
  self:ComponentDefine()
  self:ReInit()
  if viewMode then
    self.btn_area:SetActive(false)
  else
    self.btn_area:SetActive(true)
  end
  local selectCount = self.count or 1
  local haveCount = DataCenter.ItemData:GetItemCount(self.template.id)
  if selectCount > haveCount then
    selectCount = haveCount
  end
  if selectCount <= 0 then
    selectCount = 1
  end
  if not self.viewMode then
    self:SetSelectCount(selectCount)
  else
    self.selectCount = 1
  end
  self.unitNum = nil
end

function UICapacityBoxSelectView:OnDestroy()
  self.unitNum = nil
  self:ClearScroll()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UICapacityBoxSelectView:ComponentDefine()
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
  if self.isNoCapacity then
    self.txt_title:SetLocalText(372229)
  else
    self.txt_title:SetLocalText(self.template.name)
  end
  self.scrollView = self:AddComponent(UILayoutElement, "ContentArea/Rect_ScrollView")
  self._content_rect = self:AddComponent(UIBaseContainer, "ContentArea/Rect_ScrollView/Viewport/Content")
  self._use_btn = self:AddComponent(UIButton, "ContentArea/BtnArea/Btn_Use")
  self._use_txt = self:AddComponent(UIText, "ContentArea/BtnArea/Btn_Use/Txt_Use")
  self._use_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:UseItem()
  end)
  self.btn_area = self:AddComponent(UIBaseContainer, "ContentArea/BtnArea")
  self.cell_select = self:AddComponent(UIBaseContainer, "SelectGo")
  self.cell_select:SetActive(false)
  self.itemBg = self:AddComponent(UILayoutElement, "ContentArea/Bg")
  self.itemBg:SetActive(false)
  self.itemNameText = self:AddComponent(UIText, "ContentArea/Bg/NameText")
  self.itemDescText = self:AddComponent(UIText, "ContentArea/Bg/ContentScroll/Viewport/ContentTxt/DescText")
  self.itemDescTextContent = self:AddComponent(UIBaseContainer, "ContentArea/Bg/ContentScroll/Viewport/ContentTxt")
  self.selected_use_area = self:AddComponent(UIBaseContainer, selected_use_area_path)
  self.info_input = self:AddComponent(UIBaseContainer, info_input_path)
  self.dec_btn = self:AddComponent(UIButton, dec_btn_path)
  self.dec_btn:SetOnClick(function()
    if self.notChangeData then
      return
    end
    self:SetSelectCount(self.selectCount - 1)
  end)
  self.slider = self:AddComponent(UISlider, slider_path)
  self.slider:SetOnValueChanged(function(value)
    if self.notChangeData then
      return
    end
    local haveCount = DataCenter.ItemData:GetItemCount(self.template.id)
    self:SetSelectCount(math.floor(value * haveCount), true)
  end)
  self.add_btn = self:AddComponent(UIButton, add_btn_path)
  self.add_btn:SetOnClick(function()
    if self.notChangeData then
      return
    end
    self:SetSelectCount(self.selectCount + 1)
  end)
  self.count_text = self:AddComponent(UIText, count_text_path)
  self.selected_use_area:SetActive(false)
  self.got_total_num = self:AddComponent(UITextMeshProUGUIEx, got_total_num_path)
  self.res_total_num_group = self:AddComponent(UIBaseContainer, res_total_num_group_path)
  self.scrollView:SetMinHeight(262)
  self.scrollView:SetPreferredHeight(294)
  self.itemBg:SetMinHeight(200)
  self.itemBg:SetPreferredHeight(200)
end

function UICapacityBoxSelectView:ComponentDestroy()
  self._return_panel = nil
  self.close_btn = nil
  self.txt_title = nil
  self._content_rect = nil
  self._use_btn = nil
  self._use_txt = nil
  self.cell_select.transform:SetParent(self.transform)
  self.cell_select:SetActive(false)
  self.cell_select = nil
  self.itemBg = nil
  self.itemNameText = nil
  self.itemDescText = nil
  self.itemDescTextContent = nil
  self.got_total_num = nil
  self.res_total_num_group = nil
end

function UICapacityBoxSelectView:OnEnable()
  base.OnEnable(self)
  self.notChangeData = false
end

function UICapacityBoxSelectView:OnDisable()
  base.OnDisable(self)
end

function UICapacityBoxSelectView:OnAddListener()
  base.OnAddListener(self)
end

function UICapacityBoxSelectView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UICapacityBoxSelectView:ReInit()
  UIGray.SetGray(self._use_btn.transform, true)
  if self.isNoCapacity then
    self._use_txt:SetLocalText(110108)
  else
    self._use_txt:SetLocalText(110046)
  end
  self:ClearScroll()
  self.modelHero = {}
  self.modelCells = {}
  local List = {}
  if self.isNoCapacity then
    for i = 1, #self.template do
      self.modelHero[i] = self:GameObjectInstantiateAsync(UIAssets.UICapacityBoxItem, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.gameObject:SetActive(true)
        go.transform:SetParent(self._content_rect.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        go.name = self.template[i].itemId
        local cell = self._content_rect:AddComponent(UICapacityBoxItem, go.name)
        local param = {}
        
        function param.callback(trans, index)
          self:ItemCallBack(trans, index)
        end
        
        param.index = i
        param.itemId = self.template[i].itemId
        param.itemcount = self.template[i].count
        param.perCount = 1
        param.rewardType = RewardType.GOODS
        cell:RefreshData(param)
        self.modelCells[i] = cell
      end)
    end
  else
    if self.template:IsSelectBox() then
      List = string.split(self.template.para1, "|")
    elseif self.param and self.param.mode == "ItemMultiUse" then
      List = {
        self.template.id
      }
      self.scrollView:SetMinHeight(144)
      self.scrollView:SetPreferredHeight(144)
      self.itemBg:SetMinHeight(350)
      self.itemBg:SetPreferredHeight(350)
    end
    for i = 1, #List do
      if self.template.type == GOODS_TYPE.GOODS_TYPE_102 then
        self.modelHero[List[i]] = self:GameObjectInstantiateAsync(UIAssets.UICapacityBoxHeroItem, function(request)
          if request.isError then
            return
          end
          local go = request.gameObject
          go.gameObject:SetActive(true)
          go.transform:SetParent(self._content_rect.transform)
          go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
          go.name = List[i]
          local cell = self._content_rect:AddComponent(UICapacityBoxHeroItem, go.name)
          local param = {}
          param.quality = GetTableData(HeroUtils.GetHeroXmlName(), List[i], "init_quality_level")
          param.heroId = List[i]
          local heroName = GetTableData(HeroUtils.GetHeroXmlName(), List[i], "name")
          param.name = string.format("<color='%s'>%s</color>", HeroUtils.GetQualityColorStr(param.quality), Localization:GetString(heroName))
          
          function param.callback(trans, heroId)
            self:HeroCallBack(trans, heroId)
          end
          
          param.count = self.selectCount
          param.perCount = 1
          cell:RefreshData(param)
          self.modelCells[i] = cell
        end)
      elseif self.template.type == GOODS_TYPE.GOODS_TYPE_59 or self.template.type == GOODS_TYPE.GOODS_TYPE_107 then
        local itemList = string.split(List[i], ",")
        self.modelHero[itemList[1]] = self:GameObjectInstantiateAsync(UIAssets.UICapacityBoxItem, function(request)
          if request.isError then
            return
          end
          local go = request.gameObject
          go.gameObject:SetActive(true)
          go.transform:SetParent(self._content_rect.transform)
          go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
          go.name = itemList[1]
          local cell = self._content_rect:AddComponent(UICapacityBoxItem, go.name)
          local param = {}
          
          function param.callback(trans, index, itemId)
            self:ItemCallBack(trans, index, itemId)
          end
          
          param.count = self.selectCount * tonumber(itemList[2])
          param.perCount = tonumber(itemList[2])
          param.index = i
          param.itemId = tonumber(itemList[1])
          param.rewardType = self.template.type == GOODS_TYPE.GOODS_TYPE_59 and RewardType.GOODS or RewardType.RESOURCE_ITEM
          cell:RefreshData(param)
          self.modelCells[i] = cell
        end)
      elseif self.param and self.param.mode == "ItemMultiUse" then
        local itemId = List[i]
        self.modelHero[itemId] = self:GameObjectInstantiateAsync(UIAssets.UICapacityBoxItem, function(request)
          if request.isError then
            return
          end
          local go = request.gameObject
          go.gameObject:SetActive(true)
          go.transform:SetParent(self._content_rect.transform)
          go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
          go.name = itemId
          local cell = self._content_rect:AddComponent(UICapacityBoxItem, go.name)
          local param = {}
          
          function param.callback(trans, index, itemId)
            self:ItemCallBack(trans, index, itemId)
          end
          
          param.count = self.selectCount
          param.index = i
          param.itemId = tonumber(itemId)
          param.rewardType = RewardType.GOODS
          cell:RefreshData(param)
          self.modelCells[i] = cell
          if i == 1 then
            self:ItemCallBack(go.transform, 1, itemId)
          end
        end)
      end
    end
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.rectTransform)
end

local cellSizeX = 107
local cellSizeY = 109
local cellSpacingX = 31.3
local cellSpacingY = 19.7
local rowCount = 5
local cellAreaMinSizeY = 266

function UICapacityBoxSelectView:OnSelectItem(id, index)
  local name = DataCenter.RewardManager:GetNameByType(RewardType.GOODS, id)
  local desc = DataCenter.RewardManager:GetDescByType(RewardType.GOODS, id)
  local oladActive = self.itemBg.activeSelf
  local changed = false
  if string.IsNullOrEmpty(name) then
    self.itemBg:SetActive(false)
    if not self.viewMode then
      self.selected_use_area:SetActive(false)
    end
  else
    self.itemBg:SetActive(true)
    if not self.viewMode then
      self.selected_use_area:SetActive(true)
    end
    self.itemNameText:SetText(name)
    self.itemDescText:SetText(desc)
    self.itemDescTextContent:SetAnchoredPositionXY(0, 0)
    changed = oladActive ~= true
  end
  local minSizeShowRow = math.ceil(cellAreaMinSizeY / (cellSizeY + cellSpacingY))
  if changed then
    local rowId = math.floor(index / rowCount)
    if minSizeShowRow > rowId then
      rowId = 0
    end
    self._content_rect:SetLocalPositionXYZ(0, rowId * (cellSizeY + cellSpacingY), 0)
  end
end

function UICapacityBoxSelectView:HeroCallBack(trans, heroId)
  if self.modelHero and table.count(self.modelHero) > 1 then
    self.cell_select.transform:SetParent(trans)
    self.cell_select.transform:Set_localPosition(0, 0, 0)
    self.cell_select.transform:Set_localScale(1, 1, 1)
    self.cell_select:SetActive(true)
  else
    self.cell_select:SetActive(false)
  end
  self.selectHeroId = heroId
  UIGray.SetGray(self._use_btn.transform, false, true)
end

function UICapacityBoxSelectView:ItemCallBack(trans, index, itemId)
  if self.isNoCapacity and self.template[index].needhero and self.template[index].needhero ~= 0 then
    local uuid = DataCenter.HeroDataManager:GetHeroUuidByHeroId(self.template[index].needhero)
    if uuid == "" then
      return UIUtil.ShowTipsId(320477)
    end
  end
  if self.modelHero and table.count(self.modelHero) > 1 then
    self.cell_select.transform:SetParent(trans)
    self.cell_select.transform:Set_localPosition(0, 0, 0)
    self.cell_select.transform:Set_localScale(1, 1, 1)
    self.cell_select:SetActive(true)
  else
    self.cell_select:SetActive(false)
  end
  self.selectIndex = index
  if self.isNoCapacity then
    self:OnSelectItem(itemId, index)
  else
    self:OnSelectItem(itemId, index)
  end
  UIGray.SetGray(self._use_btn.transform, false, true)
  if self.param and self.param.mode == "ItemMultiUse" then
    local haveCount = DataCenter.ItemData:GetItemCount(self.template.id)
    self.res_total_num_group:SetActive(true)
    self.got_total_num:SetText(string_GetFormattedStr2(haveCount))
  else
    self.unitNum = DataCenter.ItemTemplateManager:GetResGoodsUnitNum(itemId, index, true)
    if self.unitNum and 0 < self.unitNum then
      self.res_total_num_group:SetActive(true)
      self.got_total_num:SetText(string_GetFormattedStr2(self.unitNum * self.selectCount))
    else
      self.res_total_num_group:SetActive(false)
    end
  end
end

function UICapacityBoxSelectView:ClearScroll()
  if self.template.type == GOODS_TYPE.GOODS_TYPE_102 then
    self._content_rect:RemoveComponents(UICapacityBoxHeroItem)
  elseif self.template.type == GOODS_TYPE.GOODS_TYPE_59 then
    self._content_rect:RemoveComponents(UICapacityBoxItem)
  end
  if self.modelHero ~= nil then
    for k, v in pairs(self.modelHero) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.modelCells = {}
end

function UICapacityBoxSelectView:UseItem()
  if self.isNoCapacity then
    EventManager:GetInstance():Broadcast(EventId.ActLuckyRollChoiceItem, self.selectIndex)
    self.ctrl:CloseSelf()
  elseif self.template.type == GOODS_TYPE.GOODS_TYPE_102 then
    if self.selectHeroId == 0 then
      return
    end
    self.ctrl:UseItem(self.template.type, self.itemUuid, self.selectCount, self.selectHeroId)
  elseif self.template.type == GOODS_TYPE.GOODS_TYPE_59 or self.template.type == GOODS_TYPE.GOODS_TYPE_107 then
    if self.selectIndex == 0 then
      return
    end
    self.ctrl:UseItem(self.template.type, self.itemUuid, self.selectCount, self.selectIndex)
  else
    if self.selectIndex == 0 then
      return
    end
    self.ctrl:UseItem(self.template.type, self.itemUuid, self.selectCount, self.selectIndex)
  end
end

function UICapacityBoxSelectView:RefershCells()
  if self.modelCells and self.selectCount then
    for k, v in pairs(self.modelCells) do
      if v ~= nil then
        v:RefreshCount(self.selectCount)
      end
    end
  end
end

function UICapacityBoxSelectView:SetSelectCount(selectCount, exceptSlider)
  local haveCount = DataCenter.ItemData:GetItemCount(self.template.id)
  if selectCount > haveCount then
    selectCount = haveCount
  end
  if selectCount <= 0 then
    selectCount = 1
  end
  if selectCount == self.selectCount then
    return
  end
  self.selectCount = selectCount
  self.notChangeData = true
  self.count_text:SetText(self.selectCount)
  if self.param and self.param.mode == "ItemMultiUse" then
    self.res_total_num_group:SetActive(true)
    self.got_total_num:SetText(string_GetFormattedStr2(haveCount))
  elseif self.unitNum then
    self.got_total_num:SetText(string_GetFormattedStr2(self.unitNum * self.selectCount))
  else
    self.got_total_num:SetText("")
  end
  if not exceptSlider then
    self.slider:SetValue(self.selectCount / haveCount)
  end
  self.notChangeData = false
  UIGray.SetGray(self.dec_btn.transform, selectCount <= 1, true)
  UIGray.SetGray(self.add_btn.transform, haveCount <= selectCount, true)
  self:RefershCells()
end

return UICapacityBoxSelectView
