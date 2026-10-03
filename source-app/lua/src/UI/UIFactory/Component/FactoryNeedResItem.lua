local FactoryNeedResItem = BaseClass("FactoryNeedResItem", UIBaseContainer)
local base = UIBaseContainer
local res_img_path = "itemIcon"
local price_txt_path = "itemNum"
local red_txt_path = "Text_red"
local this_path = ""
local goto_img_path = "goto_img"

local function OnCreate(self)
  base.OnCreate(self)
  self.res_img = self:AddComponent(UIImage, res_img_path)
  self.price_txt = self:AddComponent(UIText, price_txt_path)
  self.red_txt = self:AddComponent(UIText, red_txt_path)
  self.btn = self:AddComponent(UIButton, this_path)
  self.goto_img = self:AddComponent(UIImage, goto_img_path)
  self.btn:SetOnClick(function()
    if self.goto_img:GetActive() then
      DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
      GoToUtil.GotoColdStorage(self.data.needGoodsId)
    end
  end)
end

local function OnDestroy(self)
  self.res_img = nil
  self.price_txt = nil
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function RefreshData(self, data)
  self.data = data
  
  local function formatStr(num)
    if 10000 <= num then
      return string.GetFormattedStr(num)
    end
    return string.GetFormattedSeperatorNum(num)
  end
  
  self.goto_img:SetActive(false)
  if self.data.needGoodsId ~= nil then
    if self.data.needType == "good" then
      local resourceItem = DataCenter.ResourceItemDataManager:GetItemDataByItemId(self.data.needGoodsId)
      local num = 0
      if resourceItem ~= nil then
        num = resourceItem.number
      end
      num = formatStr(num)
      self.price_txt:SetText(num .. "/" .. formatStr(self.data.needGoodsNum))
      local resourceState = CommonUtil.CheckIsResourceGoodsEnough(self.data.needGoodsId, self.data.needGoodsNum)
      if resourceState then
        self.price_txt:SetColor(BlueColor)
        self.price_txt.gameObject:SetActive(true)
        self.red_txt.gameObject:SetActive(false)
      else
        self.price_txt.gameObject:SetActive(false)
        self.red_txt.gameObject:SetActive(true)
        local curNum = string.format("<color=#ff0000> %s</color>", num)
        self.red_txt:SetText(curNum .. "/" .. self.data.needGoodsNum)
        local resourceItemTemplate = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(self.data.needGoodsId)
        local showSearchFlag = false
        if resourceItemTemplate ~= nil then
          if resourceItemTemplate.monster ~= nil and resourceItemTemplate.monster ~= "" then
            showSearchFlag = true
          end
          local buildType = toInt(resourceItemTemplate.building)
          if buildType == BuildingTypes.APS_BUILD_FARM_FIELD then
            showSearchFlag = true
          elseif buildType == BuildingTypes.APS_BUILD_PASTURE_OSTRICH or buildType == BuildingTypes.APS_BUILD_PASTURE_CATTLE or buildType == BuildingTypes.APS_BUILD_PASTURE_SANDWORM then
            showSearchFlag = true
          elseif DataCenter.BuildManager:IsFactoryBuild(buildType) then
            showSearchFlag = true
          end
        end
        self.goto_img:SetActive(showSearchFlag)
      end
    elseif self.data.needType == "resource" then
      local num = LuaEntry.Resource:GetCntByResType(self.data.needGoodsId)
      num = formatStr(num)
      self.price_txt:SetText(num .. "/" .. formatStr(self.data.needGoodsNum))
      local resourceState = CommonUtil.CheckIsResourceEnough(self.data.needGoodsId, self.data.needGoodsNum)
      if resourceState then
        self.price_txt:SetColor(BlueColor)
        self.price_txt.gameObject:SetActive(true)
        self.red_txt.gameObject:SetActive(false)
      else
        self.price_txt.gameObject:SetActive(false)
        self.red_txt.gameObject:SetActive(true)
        local curNum = string.format("<color=#ff0000> %s</color>", num)
        self.red_txt:SetText(curNum .. "/" .. self.data.needGoodsNum)
        self.goto_img:SetActive(true)
      end
    end
    self.res_img:LoadSprite(self.data.needGoodsIcon)
  end
end

FactoryNeedResItem.OnDestroy = OnDestroy
FactoryNeedResItem.OnCreate = OnCreate
FactoryNeedResItem.OnEnable = OnEnable
FactoryNeedResItem.OnDisable = OnDisable
FactoryNeedResItem.RefreshData = RefreshData
return FactoryNeedResItem
