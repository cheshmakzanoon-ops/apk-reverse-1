local MailResItem = BaseClass("MailResItem", UIBaseContainer)
local base = UIBaseContainer

local function OnCreate(self)
  base.OnCreate(self)
  self.item_icon = self:AddComponent(UIImage, "Icon")
  self.num_text = self:AddComponent(UIText, "Num")
  self.btn = self:AddComponent(UIButton, "")
  self.btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnBtnClick()
  end)
end

local function OnDestroy(self)
  self.item_icon = nil
  self.num_text = nil
  self.btn = nil
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function RefreshData(self, data, hideName)
  self.param = data
  local itemId = data.itemId
  local count = tonumber(data.count)
  count = count < 0 and "" or count
  if not itemId then
    self.item_icon:LoadSprite(data.sprite)
    self.num_text:SetText(string.GetFormattedStr(math.floor(count)))
    return
  end
  local rewardType = data.rewardType
  local resourceType = data.resourceType
  if rewardType == nil and resourceType == nil then
    return
  end
  self.item_icon:SetActive(true)
  if resourceType ~= nil then
    self.item_icon:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(self.param.resourceType))
    self.num_text:SetText(string.GetFormattedStr(math.floor(count)))
    return
  end
  self.item_icon:LoadSprite(DataCenter.RewardManager:GetPicByType(rewardType, itemId))
  if rewardType == RewardType.GOODS then
    local goods = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
    if goods == nil then
      return
    end
    self.num_text:SetText(string.GetFormattedStr(math.floor(count)))
    local itemFlag = ""
    local itemType = goods.type
    if itemType == 2 then
      if goods.para1 ~= nil and goods.para1 ~= "" then
        local para1 = goods.para1
        local temp = string.split(para1, ";")
        if temp ~= nil and 1 < #temp then
          itemFlag = temp[1] .. temp[2]
        end
      end
    elseif itemType == GOODS_TYPE.GOODS_TYPE_110 then
      if goods.para2 ~= nil and goods.para2 ~= "" then
        local res_num = tonumber(goods.para2)
        itemFlag = string.GetFormattedStr(res_num)
      end
    elseif itemType == 3 or itemType == GOODS_TYPE.GOODS_TYPE_91 then
      local type2 = goods.type2
      if type2 ~= 999 and not string.IsNullOrEmpty(goods.para) then
        local res_num = tonumber(goods.para)
        itemFlag = string.GetFormattedStr(res_num)
      end
    elseif itemType == 5 and goods.para3 ~= nil and goods.para3 ~= "" then
      local res_num = tonumber(goods.para3)
      itemFlag = string.GetFormattedStr(res_num)
    end
  elseif rewardType == RewardType.OIL or rewardType == RewardType.METAL or rewardType == RewardType.WATER or rewardType == RewardType.FOOD or rewardType == RewardType.ELECTRICITY or rewardType == RewardType.PVE_POINT or rewardType == RewardType.DETECT_EVENT or rewardType == RewardType.FORMATION_STAMINA or rewardType == RewardType.EXP or rewardType == RewardType.WOOD or rewardType == RewardType.OBSIDIAN or rewardType == RewardType.FLINT then
    self.num_text:SetText(string.GetFormattedStr(math.floor(count)))
  elseif rewardType == RewardType.GOLD then
    self.num_text:SetText(count)
  elseif rewardType == RewardType.VISITOR then
    self.num_text:SetText(count)
  elseif rewardType == RewardType.WORKER then
    self.num_text:SetText(count)
  elseif rewardType == RewardType.MuseumArtifact then
    self.num_text:SetText(1)
  elseif rewardType == RewardType.RESOURCE_ITEM then
    local template = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(itemId)
    if template then
      self.num_text:SetText(string.GetFormattedStr(math.floor(count)))
    end
  elseif rewardType == RewardType.MATERIAL then
    local goods = DataCenter.ItemTemplateManager:GetItemTemplate(self.param.itemId)
    if goods ~= nil then
      self.num_text:SetText(string.GetFormattedStr(math.floor(count)))
    end
  elseif rewardType == RewardType.ARM then
    local army = DataCenter.ArmyTemplateManager:GetArmyTemplate(itemId)
    if army ~= nil then
      self.num_text:SetText(string.GetFormattedStr(math.floor(count)))
    end
  end
end

local function ShowCount(self, hideCount)
  self.num_text:SetActive(not hideCount)
end

local function OnBtnClick(self)
  if self.param.tip then
    UIUtil.ShowBubbleTips(self.param.tip, self.transform.position, 0, 0, -20)
    return
  end
  local itemType = self.param.rewardType
  if itemType ~= RewardType.GOODS and itemType ~= RewardType.RESOURCE_ITEM then
    return
  end
  if self.param.itemId == ResourceType.MeteoriteNucleusOfStar or self.param.itemId == ResourceType.MeteoriteCrystallization then
    return
  end
  if self.param.itemId ~= nil then
    local param = {}
    param.rewardType = self.param.rewardType
    param.itemId = self.param.itemId
    param.alignObject = self.item_icon
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
  end
end

MailResItem.OnCreate = OnCreate
MailResItem.OnDestroy = OnDestroy
MailResItem.OnBtnClick = OnBtnClick
MailResItem.OnEnable = OnEnable
MailResItem.OnDisable = OnDisable
MailResItem.RefreshData = RefreshData
MailResItem.ShowCount = ShowCount
return MailResItem
