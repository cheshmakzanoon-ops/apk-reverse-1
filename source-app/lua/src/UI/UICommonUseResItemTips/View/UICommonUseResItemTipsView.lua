local UICommonUseResItemTipsView = BaseClass("UICommonUseResItemTipsView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local title_path = "UICommonMiniPopUpTitle/titleText"
local return_btn_path = "UICommonMiniPopUpTitle/panel"
local close_btn_path = "UICommonMiniPopUpTitle/CloseBtn"
local btn_2_path = "BtnGo/RightBtn"
local btn_2_txt_path = "BtnGo/RightBtn/RightBtnName"
local icon_path = "UICommonResItem"
local item_quality_path = "UICommonResItem/clickBtn/ImgQuality"
local item_icon_path = "UICommonResItem/clickBtn/ItemIcon"
local flag_text_path = "UICommonResItem/clickBtn/FlagGo/FlagText"
local flag_go_path = "UICommonResItem/clickBtn/FlagGo"
local count_text_path = "UICommonResItem/clickBtn/NumText"
local name_text_path = "UICommonResItem/clickBtn/NameText"
local btn_path = "UICommonResItem/clickBtn"
local imgExtra = "UICommonResItem/clickBtn/ImgExtra"
local hero_debris_path = "UICommonResItem/clickBtn/HeroDebris"
local slider_path = "Slider"
local add_btn_path = "AddButton"
local sub_btn_path = "ReduceButton"
local curNum_txt_path = "Txt_CurNum"

local function OnCreate(self)
  base.OnCreate(self)
  self.title = self:AddComponent(UIText, title_path)
  self.btn_2 = self:AddComponent(UIButton, btn_2_path)
  self.btn_2_txt = self:AddComponent(UIText, btn_2_txt_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.icon = self:AddComponent(UIBaseContainer, icon_path)
  self.item_quality = self:AddComponent(UIImage, item_quality_path)
  self.item_icon = self:AddComponent(UIImage, item_icon_path)
  self.flag_text = self:AddComponent(UIText, flag_text_path)
  self.flag_go = self:AddComponent(UIBaseContainer, flag_go_path)
  self.count_text = self:AddComponent(UIText, count_text_path)
  self.name_text = self:AddComponent(UIText, name_text_path)
  self.imgExtra = self:AddComponent(UIImage, imgExtra)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnBtnClick()
  end)
  self.nodeHeroDebris = self:AddComponent(UIBaseContainer, hero_debris_path)
  self.nodeHeroDebris:SetActive(false)
  self.slider = self:AddComponent(UISlider, slider_path)
  self.slider:SetOnValueChanged(function(value)
    self:OnValueChange(value)
  end)
  self.add_btn = self:AddComponent(UIButton, add_btn_path)
  self.add_btn:SetOnClick(function()
    self:OnAdd()
  end)
  self.sub_btn = self:AddComponent(UIButton, sub_btn_path)
  self.sub_btn:SetOnClick(function()
    self:OnSub()
  end)
  self._curNum_txt = self:AddComponent(UIText, curNum_txt_path)
end

local function OnDestroy(self)
  self.titleText = nil
  self.tipText = nil
  self.text1 = nil
  self.text2 = nil
  self.action1 = nil
  self.closeAction = nil
  self.action2 = nil
  self.title = nil
  self.btn_2 = nil
  self.btn_2_txt = nil
  self.close_btn = nil
  self.return_btn = nil
  self._curNum_txt = nil
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self:RefreshData()
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function SetData(self, tipText, text2, action2, closeAction, titleText, item, noPlayCloseEffect, enableBtn1, enableBtn2)
  self.titleText = titleText
  self.tipText = tipText
  self.text2 = text2
  self.closeAction = closeAction
  self.action2 = action2
  self.btnPriceTxt = btnPriceTxt
  self.OnCloseClick = false
  self.noPlayCloseEffect = noPlayCloseEffect
  self.item = item
  if enableBtn1 ~= nil then
    self.enableBtn1 = enableBtn1
  else
    self.enableBtn1 = true
  end
  if enableBtn2 ~= nil then
    self.enableBtn2 = enableBtn2
  else
    self.enableBtn2 = true
  end
end

local function RefreshData(self)
  if self.titleText ~= nil and self.titleText ~= "" then
    self.title:SetLocalText(self.titleText)
  else
    self.title:SetLocalText(100378)
  end
  if self.btn_2:GetActive() then
    if self.action2 then
      self.btn_2:SetOnClick(function()
        self:OnCloseInTimer()
        self.action2()
      end)
    else
      self.btn_2:SetOnClick(function()
        self:OnClickFunc()
      end)
    end
    if self.text2 ~= nil and self.text2 ~= "" then
      self.btn_2_txt:SetLocalText(self.text2)
    else
      self.btn_2_txt:SetLocalText(GameDialogDefine.CANCEL)
    end
  end
  if self.closeAction then
    self.close_btn:SetOnClick(function()
      self:OnCloseInTimer()
      self.closeAction()
    end)
    self.return_btn:SetOnClick(function()
      self:OnCloseInTimer()
      self.closeAction()
    end)
  else
    self.close_btn:SetOnClick(function()
      self.ctrl:CloseSelf()
    end)
    self.return_btn:SetOnClick(function()
      self.ctrl:CloseSelf()
    end)
  end
  if self.item then
    self.icon:SetActive(true)
    self:RefreshItem()
  else
    self.icon:SetActive(false)
  end
  self.minValue = 1
  local item = DataCenter.ItemData:GetItemById(self.item.itemId)
  if item then
    self.maxNum = item.count
  end
  self:RefreshSlider(self.item.count)
end

local function OnValueChange(self, val)
  local cnt = math.floor(val * (self.maxNum - self.minValue) + self.minValue + 0.5)
  self._curNum_txt:SetText(cnt)
  self:SetCountText(cnt)
  self:SetItemName(cnt)
end

local function OnAdd(self)
  local value = self.slider:GetValue()
  local cnt = math.floor(value * (self.maxNum - self.minValue) + self.minValue + 0.5)
  if self:CheckChange(cnt + 1) then
    self:RefreshSlider(cnt + 1)
  end
end

local function OnSub(self)
  local value = self.slider:GetValue()
  local cnt = math.floor(value * (self.maxNum - self.minValue) + self.minValue + 0.5)
  if self:CheckChange(cnt - 1) then
    self:RefreshSlider(cnt - 1)
  end
end

local function CheckChange(self, willNun)
  if willNun >= self.minValue and willNun <= self.maxNum then
    return true
  end
  return false
end

local function RefreshSlider(self, num)
  local percent = (num - self.minValue) / math.max(self.maxNum - self.minValue, 1)
  self.slider:SetValue(percent)
end

local function RefreshItem(self)
  self.imgExtra:SetActive(false)
  self.nodeHeroDebris:SetActive(false)
  if self.item.isSimple then
    self:SetFlagActive(false)
    self:SetItemIconImage(self.item.iconName)
    self:SetItemQualityImage(DataCenter.ItemTemplateManager:GetToolBgByColor(ItemColor.GREEN))
    self.count_text:SetText("")
  elseif self.item.itemId == nil then
    if self.item.iconName ~= nil and self.item.itemColor ~= nil then
      self:SetFlagActive(false)
      self:SetItemIconImage(self.item.iconName)
      self:SetItemQualityImage(DataCenter.ItemTemplateManager:GetToolBgByColor(tonumber(self.item.itemColor)))
      self.count_text:SetText("")
    elseif self.item.heroConfigId ~= nil then
      self:SetFlagActive(false)
      local _heroConfigId = self.item.heroConfigId
      self:SetItemIconImage(HeroUtils.GetHeroIconPath(_heroConfigId, false))
      local rarity = GetTableData(HeroUtils.GetHeroXmlName(), _heroConfigId, "rarity")
      local qualityimg = HeroUtils.GetRarityIconPath(rarity, false)
      self:SetItemQualityImage(qualityimg)
    end
  else
    local goods = DataCenter.ItemTemplateManager:GetItemTemplate(self.item.itemId)
    if goods ~= nil then
      local join_method = -1
      local icon_join
      if goods.join_method ~= nil and goods.join_method > 0 and goods.icon_join ~= nil and goods.icon_join ~= "" then
        join_method = goods.join_method
        icon_join = goods.icon_join
      end
      if 0 < join_method and icon_join ~= nil and icon_join ~= "" then
        self:SetFlagActive(false)
        local tempJoin = string.split(icon_join, ";")
        if 1 < #tempJoin then
          self:SetItemQualityImage(tempJoin[2])
        end
        if 2 < #tempJoin then
          self:SetItemIconImage(tempJoin[3])
        end
      else
        self:SetItemQualityImage(DataCenter.ItemTemplateManager:GetToolBgByColor(goods.color))
        if self.item.count ~= nil then
          self:SetCountText(self.item.count)
        else
          self:SetCountText("")
        end
        local itemType = goods.type
        if itemType == 2 then
          if goods.para1 ~= nil and goods.para1 ~= "" then
            local para1 = goods.para1
            local temp = string.split(para1, ";")
            if temp ~= nil and 1 < #temp then
              self:SetFlagActive(true)
              self:SetFlagText(temp[1] .. temp[2])
            else
              self:SetFlagActive(false)
            end
          end
        elseif itemType == 3 or itemType == GOODS_TYPE.GOODS_TYPE_91 then
          local type2 = goods.type2
          if type2 ~= 999 and goods.para ~= nil and goods.para ~= "" then
            local res_num = tonumber(goods.para)
            self:SetFlagText(string.GetFormattedStr(res_num))
            self:SetFlagActive(true)
          else
            self:SetFlagActive(false)
          end
        else
          self:SetFlagActive(false)
        end
        local iconImg = string.format(LoadPath.ItemPath, goods.icon)
        self:SetItemIconImage(iconImg)
        self:SetItemName(self.item.count)
      end
    else
      local resourceType = tonumber(self.item.itemId)
      if resourceType < 100 then
        self:SetFlagActive(false)
        self:SetItemIconImage(CS.ResourceUtils.GetResourceImagePath(resourceType))
        self:SetItemQualityImage(DataCenter.ItemTemplateManager:GetToolBgByColor(ItemColor.PURPLE))
        if self.item.count ~= nil then
          self:SetCountText(self.item.count)
        else
          self:SetCountText("")
        end
      end
    end
  end
end

local function OnBtnClick(self)
  if self.item.itemId ~= nil then
    local param = {}
    param.itemId = self.item.itemId
    param.alignObject = self.item_icon
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
  elseif self.iconName ~= nil then
    local param = {}
    param.itemName = self.item.itemName
    param.itemDesc = self.item.itemDes
    param.alignObject = self.item_icon
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
  end
end

local function SetItemIconImage(self, imageName)
  self.item_icon:LoadSpriteAuto(imageName)
end

local function SetItemQualityImage(self, imageName)
  self.item_quality:LoadSpriteAuto(imageName)
end

local function SetFlagActive(self, value)
  if self.flagActive ~= value then
    self.flagActive = value
    self.flag_text.gameObject:SetActive(value)
    if self.flag_go ~= nil then
      self.flag_go:SetActive(value)
    end
  end
end

local function SetFlagText(self, value)
  if self.flagText ~= value then
    self.flagText = value
    self.flag_text:SetText(value)
  end
end

local function SetItemName(self, value)
  local goods = DataCenter.ItemTemplateManager:GetItemTemplate(self.item.itemId)
  for i, v in pairs(goods.name_value) do
    self.name_text:SetLocalText(i, string.GetFormattedSeperatorNum(value * tonumber(goods.para)))
  end
  self.curNum = value
end

local function SetCountText(self, value)
  self.count_text:SetText(value)
end

local function OnClickFunc(self)
  local item = DataCenter.ItemData:GetItemById(self.item.itemId)
  if item then
    local str = self.count_text:GetText()
    if self.item.isRefresh then
      local goods = DataCenter.ItemTemplateManager:GetItemTemplate(self.item.itemId)
      local param = {}
      param.tips = self.item.tips
      param.count = self.item.lacktab.disNum - tonumber(str) * tonumber(goods.para)
      param.useCount = self.maxNum - self.curNum
      param.type = self.item.lacktab.resType
      DataCenter.ResLackManager:SetRefreshParam(param)
    end
    SFSNetwork.SendMessage(MsgDefines.ItemUse, {
      uuid = item.uuid,
      num = tonumber(str)
    })
  end
  self.ctrl:CloseSelf()
end

local function OnCloseInTimer(self)
  self.OnCloseClick = true
  local closeTimer = TimerManager:GetInstance():GetTimer(0.1, function()
    if self.OnCloseClick and self.ctrl then
      self.ctrl:CloseSelf(self.noPlayCloseEffect)
    end
  end, nil, true, false, false)
  closeTimer:Start()
end

UICommonUseResItemTipsView.OnCreate = OnCreate
UICommonUseResItemTipsView.OnDestroy = OnDestroy
UICommonUseResItemTipsView.OnEnable = OnEnable
UICommonUseResItemTipsView.OnDisable = OnDisable
UICommonUseResItemTipsView.SetData = SetData
UICommonUseResItemTipsView.RefreshData = RefreshData
UICommonUseResItemTipsView.RefreshItem = RefreshItem
UICommonUseResItemTipsView.OnCloseInTimer = OnCloseInTimer
UICommonUseResItemTipsView.SetItemIconImage = SetItemIconImage
UICommonUseResItemTipsView.SetItemQualityImage = SetItemQualityImage
UICommonUseResItemTipsView.SetFlagActive = SetFlagActive
UICommonUseResItemTipsView.SetFlagText = SetFlagText
UICommonUseResItemTipsView.SetItemName = SetItemName
UICommonUseResItemTipsView.SetCountText = SetCountText
UICommonUseResItemTipsView.OnBtnClick = OnBtnClick
UICommonUseResItemTipsView.OnValueChange = OnValueChange
UICommonUseResItemTipsView.OnAdd = OnAdd
UICommonUseResItemTipsView.OnSub = OnSub
UICommonUseResItemTipsView.CheckChange = CheckChange
UICommonUseResItemTipsView.RefreshSlider = RefreshSlider
UICommonUseResItemTipsView.OnClickFunc = OnClickFunc
return UICommonUseResItemTipsView
