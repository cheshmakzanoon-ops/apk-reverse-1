local UIWorkerVipBoxShowTipsView = BaseClass("UIWorkerVipBoxShowTipsView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIHeroRecruitTipRateDetailInfoItem2 = require("UI.UIHero2.UIHeroRecruitTipNew.Component.UIHeroRecruitTipRateDetailInfoItem2")
local content_path = "content"
local u_i_common_res_item_path = "content/infoContent/UICommonResItem"
local name_path = "content/infoContent/name"
local desc_content_path = "content/infoContent/descScroll/descViewPort/descContent"
local tip_content_path = "content/tipContent"
local u_i_hero_recruit_tip_detail_item_path = "content/rateRewardContent/UIHeroRecruitTipDetailItem"
local rate_item_content_path = "content/rateRewardContent/rateItemScroll/rateItemViewPort/rateItemContent"
local img_arrow_path = "ImgArrow"

local function OnCreate(self)
  base.OnCreate(self)
  self.pos, self.goodsId = self:GetUserData()
  self:ComponentDefine()
  self:RefreshView()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  local btnPanel = self:AddComponent(UIButton, "Panel")
  btnPanel:SetOnClick(function()
    self.ctrl.CloseSelf(self.ctrl)
  end)
  self.content = self:AddComponent(UIImage, content_path)
  self.u_i_common_res_item = self:AddComponent(UICommonResItem, u_i_common_res_item_path)
  self.name = self:AddComponent(UITextMeshProUGUIEx, name_path)
  self.desc_content = self:AddComponent(UITextMeshProUGUIEx, desc_content_path)
  self.tip_content = self:AddComponent(UITextMeshProUGUIEx, tip_content_path)
  self.u_i_hero_recruit_tip_detail_item = self:AddComponent(UIImage, u_i_hero_recruit_tip_detail_item_path)
  self.rate_item_content = self:AddComponent(UIBaseContainer, rate_item_content_path)
  self.img_arrow = self:AddComponent(UIImage, img_arrow_path)
  self.u_i_hero_recruit_tip_detail_item:SetActive(false)
  self.rateItemList = {}
  self.u_i_hero_recruit_tip_detail_item.gameObject:GameObjectCreatePool()
end

local function ComponentDestroy(self)
  self.rate_item_content:RemoveComponents(UIHeroRecruitTipRateDetailInfoItem2)
  self.u_i_hero_recruit_tip_detail_item.gameObject:GameObjectRecycleAll()
  self.rateItemList = {}
  self.content = nil
  self.u_i_common_res_item = nil
  self.name = nil
  self.desc_content = nil
  self.tip_content = nil
  self.u_i_hero_recruit_tip_detail_item = nil
  self.rate_item_content = nil
  self.img_arrow = nil
end

local function RefreshView(self)
  self:SetPosView()
  self:SetGoodsInfoView()
end

local function SetPosView(self)
  local arrowDeltaX = -10
  local arrowDeltaY = 30
  local contentMaxPosX = 80
  if CommonUtil.IsArabic() then
    arrowDeltaX = 10
  end
  self.img_arrow:SetPositionXYZ(self.pos.x + arrowDeltaX, self.pos.y + arrowDeltaY, 0)
  local anchoredPosition = self.img_arrow:GetAnchoredPosition()
  local contentPosX = anchoredPosition.x
  if 0 < contentPosX then
    contentPosX = math.min(contentPosX, contentMaxPosX)
  else
    contentPosX = math.max(contentPosX, -contentMaxPosX)
  end
  self.content:SetAnchoredPositionXY(contentPosX, anchoredPosition.y - 6)
end

local function GetQualityByTypeAndId(type, id)
  if type == HeroRecruitRateDetailInfoType.Hero then
    local heroTemplate = DataCenter.HeroTemplateManager:GetTemplate(id)
    return heroTemplate.quality
  elseif type == HeroRecruitRateDetailInfoType.Goods then
    local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(id)
    return itemTemplate.quality
  elseif type == HeroRecruitRateDetailInfoType.ResItem then
    local resItemTemplate = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(id)
    return resItemTemplate.quality
  elseif type == HeroRecruitRateDetailInfoType.Worker then
    local workerTemplate = DataCenter.WorkerTemplateManager:GetShowTemplateById(id)
    return workerTemplate.quality
  elseif type == HeroRecruitRateDetailInfoType.SquadEquip then
    local squadEquipTemplate = DataCenter.CommonEquipTemplateManager:GetTemplate(id)
    return squadEquipTemplate.quality
  elseif type == HeroRecruitRateDetailInfoType.Equip then
    local equipTemplate = DataCenter.EquipTemplateManager:GetTemplate(id)
    return equipTemplate.quality
  elseif type == HeroRecruitRateDetailInfoType.SkillChip then
    local chipTemplate = DataCenter.TWSkillChipTemplateManager:GetTemplate(id)
    return chipTemplate.quality
  end
end

local function GetRewardTypeByData(data)
  local rewardType
  if data.type == HeroRecruitRateDetailInfoType.Hero then
    rewardType = RewardType.HERO
  elseif data.type == HeroRecruitRateDetailInfoType.Goods then
    rewardType = RewardType.GOODS
  elseif data.type == HeroRecruitRateDetailInfoType.ResItem then
    rewardType = RewardType.RESOURCE_ITEM
  elseif data.type == HeroRecruitRateDetailInfoType.Worker then
    rewardType = RewardType.WORKER
  elseif data.type == HeroRecruitRateDetailInfoType.SquadEquip then
    rewardType = RewardType.CommonEquip
  elseif data.type == HeroRecruitRateDetailInfoType.Equip then
    rewardType = RewardType.EQUIP
  elseif data.type == HeroRecruitRateDetailInfoType.SkillChip then
    rewardType = RewardType.TWSkillChip
  end
  return rewardType
end

local function SetGoodsInfoView(self)
  local itemTemp = DataCenter.ItemTemplateManager:GetItemTemplate(self.goodsId)
  if itemTemp == nil then
    return
  end
  local rewardData = {
    rewardType = RewardType.GOODS,
    itemId = self.goodsId
  }
  self.u_i_common_res_item:ReInit(rewardData)
  self.name:SetLocalText(itemTemp.name)
  self.desc_content:SetAnchoredPositionXY(0, 0)
  local descTxt = DataCenter.ItemTemplateManager:GetDes(self.goodsId)
  self.desc_content:SetText(descTxt)
  self.tip_content:SetLocalText("2000838")
  self.rate_item_content:SetAnchoredPositionXY(0, 0)
  local dropInfoId = itemTemp.drop_info_para
  local dropInfoDetail = GetTableData(TableName.DropInfoDetail, dropInfoId, "dropInfoDetail")
  self.showData = {}
  local dropList = string.split(dropInfoDetail, "|")
  for index, v in ipairs(dropList) do
    local dropItem = string.split(v, ";")
    if #dropItem == 4 then
      local type = tonumber(dropItem[1])
      local id = tonumber(dropItem[2])
      local num = tonumber(dropItem[3])
      local rate = tonumber(dropItem[4])
      rate = rate * 100
      local quality = GetQualityByTypeAndId(type, id)
      local rewardType = GetRewardTypeByData({type = type})
      table.insert(self.showData, {
        type = type,
        id = id,
        num = num,
        rate = rate,
        quality = quality,
        param = {
          rewardType = rewardType,
          itemId = id,
          count = num
        },
        sortIndex = index
      })
    end
  end
  table.sort(self.showData, function(a, b)
    if b.quality ~= a.quality then
      return b.quality < a.quality
    end
    return a.sortIndex < b.sortIndex
  end)
  self.rate_item_content:RemoveComponents(UIHeroRecruitTipRateDetailInfoItem2)
  self.u_i_hero_recruit_tip_detail_item.gameObject:GameObjectRecycleAll()
  self.rateItemList = {}
  for i = 1, #self.showData do
    local index = i
    local item = self.u_i_hero_recruit_tip_detail_item.gameObject:GameObjectSpawn(self.rate_item_content.transform)
    item.name = index
    local obj = self.rate_item_content:AddComponent(UIHeroRecruitTipRateDetailInfoItem2, item.name)
    obj:SetActive(true)
    obj:SetData(self.showData[i].param, self.showData[i].rate, "")
    self.rateItemList[index] = obj
  end
end

UIWorkerVipBoxShowTipsView.OnCreate = OnCreate
UIWorkerVipBoxShowTipsView.OnDestroy = OnDestroy
UIWorkerVipBoxShowTipsView.ComponentDefine = ComponentDefine
UIWorkerVipBoxShowTipsView.ComponentDestroy = ComponentDestroy
UIWorkerVipBoxShowTipsView.RefreshView = RefreshView
UIWorkerVipBoxShowTipsView.SetPosView = SetPosView
UIWorkerVipBoxShowTipsView.SetGoodsInfoView = SetGoodsInfoView
return UIWorkerVipBoxShowTipsView
