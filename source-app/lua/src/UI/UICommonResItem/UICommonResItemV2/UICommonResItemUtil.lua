local UICommonResItemUtil = {}
local CommonResItemTypeEnum = {
  NotReward = "NotReward",
  GoodsNormal = "GoodsNormal",
  GoodsDecorator = "GoodsDecorator",
  GoodsGoldBrick = "GoodsGoldBrick",
  GoodsDecoratorChoose = "GoodsDecoratorChoose",
  GoodsDecoratorPreview = "GoodsDecoratorPreview",
  GoodsBox = "GoodsBox",
  GoodsSaveGirl = "GoodsSaveGirl",
  ResourceItem = "ResourceItem",
  TWSkillChip = "TWSkillChip",
  Army = "Army",
  DragonWorldPoint = "DragonWorldPoint",
  Equip = "Equip",
  Hero = "Hero",
  HonorAndAlliancePoint = "HonorAndAlliancePoint",
  Golloes = "Golloes",
  EXP = "EXP",
  UnlockModule = "UnlockModule",
  HERO_EXP = "HERO_EXP",
  Visitor = "Visitor",
  Fish = "Fish",
  Worker = "Worker",
  Resource = "Resource",
  Gold = "Gold",
  BattlePass = "BattlePass",
  MonthCard = "MonthCard",
  CommonEquip = "CommonEquip",
  DecorateBuild = "DecorateBuild",
  ActGiftBox = "ActGiftBox",
  AllianceGift = "AllianceGift",
  WhiteBgReward = "WhiteBgReward",
  PartyMonster = "PartyMonster",
  TacticalCard = "TacticalCard",
  DecorateGacha = "DecorateGacha",
  OtherRewards = "OtherRewards"
}
local CommonResItemTypeToItemDic = {
  [CommonResItemTypeEnum.GoodsDecorator] = "UICommonResItemGoodsDecorator",
  [CommonResItemTypeEnum.GoodsGoldBrick] = "UICommonResItemGoodsGoldBrick",
  [CommonResItemTypeEnum.GoodsDecoratorChoose] = "UICommonResItemGoodsDecoratorChoose",
  [CommonResItemTypeEnum.GoodsDecoratorPreview] = "UICommonResItemGoodsDecoratorPreview",
  [CommonResItemTypeEnum.GoodsBox] = "UICommonResItemGoodsBox",
  [CommonResItemTypeEnum.GoodsSaveGirl] = "UICommonResItemGoodsSaveGirl",
  [CommonResItemTypeEnum.GoodsNormal] = "UICommonResItemGoodsBase",
  [CommonResItemTypeEnum.ResourceItem] = "UICommonResItemResourceItem",
  [CommonResItemTypeEnum.NotReward] = "UICommonResItemNotReward",
  [CommonResItemTypeEnum.TWSkillChip] = "UICommonResItemTWSkillChip",
  [CommonResItemTypeEnum.Army] = "UICommonResItemArmy",
  [CommonResItemTypeEnum.OtherRewards] = "UICommonResItemOtherRewards",
  [CommonResItemTypeEnum.DragonWorldPoint] = "UICommonResItemDragonWorldPoint",
  [CommonResItemTypeEnum.Equip] = "UICommonResItemEquip",
  [CommonResItemTypeEnum.Hero] = "UICommonResItemHero",
  [CommonResItemTypeEnum.HonorAndAlliancePoint] = "UICommonResItemHonorAndAlliancePoint",
  [CommonResItemTypeEnum.Golloes] = "UICommonResItemGolloes",
  [CommonResItemTypeEnum.EXP] = "UICommonResItemEXP",
  [CommonResItemTypeEnum.UnlockModule] = "UICommonResItemUnlockModule",
  [CommonResItemTypeEnum.HERO_EXP] = "UICommonResItemHeroExp",
  [CommonResItemTypeEnum.Visitor] = "UICommonResItemVisitor",
  [CommonResItemTypeEnum.Fish] = "UICommonResItemFish",
  [CommonResItemTypeEnum.Worker] = "UICommonResItemWorker",
  [CommonResItemTypeEnum.Resource] = "UICommonResItemResource",
  [CommonResItemTypeEnum.Gold] = "UICommonResItemGold",
  [CommonResItemTypeEnum.BattlePass] = "UICommonResItemBattlePass",
  [CommonResItemTypeEnum.MonthCard] = "UICommonResItemMonthCard",
  [CommonResItemTypeEnum.CommonEquip] = "UICommonResItemCommonEquip",
  [CommonResItemTypeEnum.DecorateBuild] = "UICommonResItemDecorateBuild",
  [CommonResItemTypeEnum.ActGiftBox] = "UICommonResItemActGiftBox",
  [CommonResItemTypeEnum.AllianceGift] = "UICommonResItemAllianceGift",
  [CommonResItemTypeEnum.WhiteBgReward] = "UICommonResItemWhiteBgReward",
  [CommonResItemTypeEnum.PartyMonster] = "UICommonResItemPartyMonster",
  [CommonResItemTypeEnum.TacticalCard] = "UICommonResItemTacticalCard",
  [CommonResItemTypeEnum.DecorateGacha] = "UICommonResItemDecorateGacha"
}

local function GetItemRenderByParam(param)
  local resItemType
  local rewardType = param.rewardType
  if rewardType == nil then
    resItemType = CommonResItemTypeEnum.NotReward
  elseif rewardType == RewardType.GOODS then
    if param.itemId then
      local goods = DataCenter.ItemTemplateManager:GetItemTemplate(param.itemId)
      if goods == nil then
        return CommonResItemTypeToItemDic[resItemType]
      end
      local type = goods.type
      local type2 = goods.type2
      local tipsType = goods.tipsType
      if type2 == GOODS_TYPE2.DecoratorItem then
        resItemType = CommonResItemTypeEnum.GoodsDecorator
      elseif type == GOODS_TYPE.GOODS_TYPE_146 then
        resItemType = CommonResItemTypeEnum.GoodsGoldBrick
      elseif type == GOODS_TYPE.GOODS_TYPE_138 then
        resItemType = CommonResItemTypeEnum.GoodsDecoratorChoose
      elseif type == GOODS_TYPE.GOODS_TYPE_113 then
        resItemType = CommonResItemTypeEnum.GoodsDecoratorPreview
      elseif tipsType == GOODS_TIPS_TYPE.Box or tipsType == GOODS_TIPS_TYPE.BoxWithoutProbability or tipsType == GOODS_TIPS_TYPE.BoxTag or tipsType == GOODS_TIPS_TYPE.BoxTacticalCard then
        resItemType = CommonResItemTypeEnum.GoodsBox
      elseif param.itemId == tostring(DataCenter.LWSaveGirlManager:GetCostItemId()) then
        resItemType = CommonResItemTypeEnum.GoodsSaveGirl
      else
        resItemType = CommonResItemTypeEnum.GoodsNormal
      end
    else
      resItemType = CommonResItemTypeEnum.GoodsNormal
    end
  elseif rewardType == RewardType.RESOURCE_ITEM then
    resItemType = CommonResItemTypeEnum.ResourceItem
  elseif rewardType == RewardType.TWSkillChip then
    resItemType = CommonResItemTypeEnum.TWSkillChip
  elseif rewardType == RewardType.ARM then
    resItemType = CommonResItemTypeEnum.Army
  elseif rewardType == RewardType.DragonWorldPoint then
    resItemType = CommonResItemTypeEnum.DragonWorldPoint
  elseif rewardType == RewardType.EQUIP then
    resItemType = CommonResItemTypeEnum.Equip
  elseif rewardType == RewardType.HERO then
    resItemType = CommonResItemTypeEnum.Hero
  elseif rewardType == RewardType.HONOR or rewardType == RewardType.ALLIANCE_POINT then
    resItemType = CommonResItemTypeEnum.HonorAndAlliancePoint
  elseif rewardType == RewardType.Golloes then
    resItemType = CommonResItemTypeEnum.Golloes
  elseif rewardType == RewardType.EXP then
    resItemType = CommonResItemTypeEnum.EXP
  elseif rewardType == RewardType.UnlockModule then
    resItemType = CommonResItemTypeEnum.UnlockModule
  elseif rewardType == RewardType.HERO_EXP then
    resItemType = CommonResItemTypeEnum.HERO_EXP
  elseif rewardType == RewardType.VISITOR then
    resItemType = CommonResItemTypeEnum.Visitor
  elseif rewardType == RewardType.FISH then
    resItemType = CommonResItemTypeEnum.Fish
  elseif rewardType == RewardType.WORKER then
    resItemType = CommonResItemTypeEnum.Worker
  elseif rewardType == RewardType.RESOURCE then
    resItemType = CommonResItemTypeEnum.Resource
  elseif rewardType == RewardType.GOLD then
    resItemType = CommonResItemTypeEnum.Gold
  elseif rewardType == RewardType.BATTLE_PASS then
    resItemType = CommonResItemTypeEnum.BattlePass
  elseif rewardType == RewardType.CommonEquip then
    resItemType = CommonResItemTypeEnum.CommonEquip
  elseif rewardType == RewardType.DecorateBuild then
    if param.isDecorateGacha == true then
      resItemType = CommonResItemTypeEnum.DecorateGacha
    else
      resItemType = CommonResItemTypeEnum.DecorateBuild
    end
  elseif rewardType == RewardType.ActGiftBox then
    resItemType = CommonResItemTypeEnum.ActGiftBox
  elseif rewardType == RewardType.ALLIANCE_GIFT then
    resItemType = CommonResItemTypeEnum.AllianceGift
  elseif rewardType == RewardType.OIL or rewardType == RewardType.METAL or rewardType == RewardType.Wood or rewardType == RewardType.WOOD or rewardType == RewardType.WATER or rewardType == RewardType.FOOD or rewardType == RewardType.ELECTRICITY or rewardType == RewardType.PVE_POINT or rewardType == RewardType.DETECT_EVENT or rewardType == RewardType.FLINT or rewardType == RewardType.OBSIDIAN or rewardType == RewardType.AllianceCoal or rewardType == RewardType.AllianceStone or rewardType == RewardType.AllianceFarmerExp or rewardType == RewardType.FORMATION_STAMINA or rewardType == RewardType.PVE_ACT_SCORE then
    resItemType = CommonResItemTypeEnum.WhiteBgReward
  elseif rewardType == RewardType.PartyMonster then
    resItemType = CommonResItemTypeEnum.PartyMonster
  elseif rewardType == RewardType.MonthCard then
    resItemType = CommonResItemTypeEnum.MonthCard
  elseif rewardType == RewardType.TACTICAL_CARD then
    resItemType = CommonResItemTypeEnum.TacticalCard
  else
    resItemType = CommonResItemTypeEnum.OtherRewards
  end
  return CommonResItemTypeToItemDic[resItemType]
end

UICommonResItemUtil.CommonResItemTypeEnum = CommonResItemTypeEnum
UICommonResItemUtil.CommonResItemTypeToItemDic = CommonResItemTypeToItemDic
UICommonResItemUtil.GetItemRenderByParam = GetItemRenderByParam
return ConstClass("UICommonResItemUtil", UICommonResItemUtil)
