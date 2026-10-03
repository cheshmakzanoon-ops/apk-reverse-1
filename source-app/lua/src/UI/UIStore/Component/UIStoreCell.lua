local UIStoreCell = BaseClass("UIStoreCell", UIBaseContainer)
local base = UIBaseContainer
local Param = DataClass("Param", ParamData)
local ParamData = {
  itemId,
  callBack,
  index
}
local item_quality_path = "ImgQuality"
local item_icon_path = "ItemIcon"
local flag_text_path = "FlagText"
local this_path = ""

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.item_quality = self:AddComponent(UIImage, item_quality_path)
  self.item_icon = self:AddComponent(UIImage, item_icon_path)
  self.flag_text = self:AddComponent(UIText, flag_text_path)
  self.btn = self:AddComponent(UIButton, this_path)
  self.btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnBtnClick()
  end)
end

local function ComponentDestroy(self)
  self.item_quality = nil
  self.item_icon = nil
  self.flag_text = nil
  self.btn = nil
end

local function DataDefine(self)
  self.param = {}
  self.flagText = nil
  self.flagActive = nil
  self.clickEnable = nil
end

local function DataDestroy(self)
  self.param = nil
  self.flagText = nil
  self.flagActive = nil
  self.clickEnable = nil
end

local function ReInit(self, param)
  self.param = param
  self:SetClickEnable(self.param.callBack ~= nil)
  if self.param.itemId ~= nil then
    local goods = DataCenter.ItemTemplateManager:GetItemTemplate(self.param.itemId)
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
        elseif itemType == 3 then
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
        if itemType == 9 then
          self:SetItemIconImage(goods.icon)
        else
          self:SetItemIconImage(goods.icon)
        end
      end
    end
  end
end

local function OnBtnClick(self)
  if self.param.callBack ~= nil then
    self.param.callBack(self.transform, self.param.index)
  end
end

local function SetItemIconImage(self, imageName)
  self.item_icon:LoadSprite(imageName)
end

local function SetItemQualityImage(self, imageName)
  self.item_quality:LoadSprite(imageName)
end

local function SetFlagActive(self, value)
  if self.flagActive ~= value then
    self.flagActive = value
    self.flag_text.gameObject:SetActive(value)
  end
end

local function SetFlagText(self, value)
  if self.flagText ~= value then
    self.flagText = value
    self.flag_text:SetText(value)
  end
end

local function SetClickEnable(self, value)
  if self.clickEnable ~= value then
    self.clickEnable = value
    self.btn:SetInteractable(value)
  end
end

UIStoreCell.OnCreate = OnCreate
UIStoreCell.OnDestroy = OnDestroy
UIStoreCell.Param = Param
UIStoreCell.OnBtnClick = OnBtnClick
UIStoreCell.OnEnable = OnEnable
UIStoreCell.OnDisable = OnDisable
UIStoreCell.ComponentDefine = ComponentDefine
UIStoreCell.ComponentDestroy = ComponentDestroy
UIStoreCell.DataDefine = DataDefine
UIStoreCell.DataDestroy = DataDestroy
UIStoreCell.ReInit = ReInit
UIStoreCell.SetItemIconImage = SetItemIconImage
UIStoreCell.SetItemQualityImage = SetItemQualityImage
UIStoreCell.SetFlagActive = SetFlagActive
UIStoreCell.SetFlagText = SetFlagText
UIStoreCell.SetClickEnable = SetClickEnable
return UIStoreCell
