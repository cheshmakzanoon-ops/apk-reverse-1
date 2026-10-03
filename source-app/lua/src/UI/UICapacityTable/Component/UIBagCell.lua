local UIBagCell = BaseClass("UIBagCell", UIBaseContainer)
local base = UIBaseContainer
local Param = DataClass("Param", ParamData)
local ParamData = {
  itemId,
  count,
  callBack,
  index
}
local item_quality_path = "clickBtn/ImgQuality"
local item_icon_path = "clickBtn/ItemIcon"
local num_text_path = "clickBtn/NumText"
local num_go_path = "clickBtn/NumText"
local flag_text_path = "clickBtn/FlagGo/FlagText"
local flag_go_path = "clickBtn/FlagGo"
local imgExtra_path = "clickBtn/ImgExtra"
local this_path = "clickBtn"

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
  self.num_text = self:AddComponent(UIText, num_text_path)
  self.flag_text = self:AddComponent(UIText, flag_text_path)
  self.btn = self:AddComponent(UIButton, this_path)
  self.num_go = self:AddComponent(UIBaseContainer, num_go_path)
  self.flag_go = self:AddComponent(UIBaseContainer, flag_go_path)
  self.imgExtra = self:AddComponent(UIImage, imgExtra_path)
  self.nodeHeroDebris = self:AddComponent(UIBaseContainer, "clickBtn/HeroDebris")
  self.nodeHeroDebris:SetActive(false)
  self.btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnBtnClick()
  end)
end

local function ComponentDestroy(self)
  self.item_quality = nil
  self.item_icon = nil
  self.num_text = nil
  self.flag_text = nil
  self.btn = nil
  self.num_go = nil
  self.flag_go = nil
  self.imgExtra = nil
end

local function DataDefine(self)
  self.param = {}
end

local function DataDestroy(self)
  self.param = nil
end

local function ClearInfo(self)
  self.param = nil
  self.item_icon:SetActive(false)
  self.num_text:SetText("")
  self.flag_go:SetActive(false)
end

local function ReInit(self, param)
  self.param = param
  self.imgExtra:SetActive(false)
  if self.param.count == nil then
    self.num_go:SetActive(false)
  else
    self.num_go:SetActive(true)
    self.num_text:SetText(self.param.count)
  end
  self.btn:SetInteractable(self.param.callBack ~= nil)
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
        self.flag_go:SetActive(false)
        local tempJoin = string.split(icon_join, ";")
        if 1 < #tempJoin then
          self.item_quality:LoadSprite(tempJoin[2])
        end
        if 2 < #tempJoin then
          self.item_quality:LoadSprite(tempJoin[3])
        end
      else
        self.item_quality:LoadSprite(DataCenter.ItemTemplateManager:GetToolBgByColor(goods.color))
        local itemType = goods.type
        if itemType == 2 then
          if goods.para1 ~= nil and goods.para1 ~= "" then
            local para1 = goods.para1
            local temp = string.split(para1, ";")
            if temp ~= nil and 1 < #temp then
              self.flag_go:SetActive(true)
              self.flag_text:SetText(temp[1] .. temp[2])
            else
              self.flag_go:SetActive(false)
            end
          end
        elseif itemType == 3 then
          local type2 = goods.type2
          if type2 ~= 999 and goods.para ~= nil and goods.para ~= "" then
            local res_num = tonumber(goods.para)
            self.flag_text:SetText(string.GetFormattedStr(res_num))
            self.flag_go:SetActive(true)
          else
            self.flag_go:SetActive(false)
          end
        else
          self.flag_go:SetActive(false)
        end
        self.item_icon:SetActive(true)
        self.item_icon:LoadSprite(string.format(LoadPath.ItemPath, goods.icon))
      end
    end
  end
end

local function OnBtnClick(self)
  if self.param.callBack ~= nil then
    self.param.callBack(self.transform, self.param.index)
  end
end

UIBagCell.OnCreate = OnCreate
UIBagCell.OnDestroy = OnDestroy
UIBagCell.Param = Param
UIBagCell.OnBtnClick = OnBtnClick
UIBagCell.OnEnable = OnEnable
UIBagCell.OnDisable = OnDisable
UIBagCell.ComponentDefine = ComponentDefine
UIBagCell.ComponentDestroy = ComponentDestroy
UIBagCell.DataDefine = DataDefine
UIBagCell.DataDestroy = DataDestroy
UIBagCell.ReInit = ReInit
UIBagCell.ClearInfo = ClearInfo
return UIBagCell
