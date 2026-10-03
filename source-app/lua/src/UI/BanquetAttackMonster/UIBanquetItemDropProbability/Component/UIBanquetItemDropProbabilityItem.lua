local base = UIBaseContainer
local UIBanquetItemDropProbabilityItem = BaseClass("UIBanquetItemDropProbabilityItem", base)
local M = UIBanquetItemDropProbabilityItem
local BanquetAttackMonsterRateRewardItem = require("UI.BanquetAttackMonster.BanquetAttackMonsterRateReward.Component.BanquetAttackMonsterRateRewardItem")
local arrow_open_img_path = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_lianmeng_anniu_xiala_1.png"
local arrow_close_img_path = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_lianmeng_anniu_xiala_2.png"
local monsterPartMinHeight = 150
local monsterDescMinHeight = 85
local descPartBlankHeight = 60

function M:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.isExpandArrow = true
  self.index = 0
  self.compRewardRateItem:SetActive(false)
  self.compRewardRateItem.gameObject:GameObjectCreatePool()
  self.compRewardItem:SetActive(false)
  self.compRewardItem.gameObject:GameObjectCreatePool()
end

function M:OnDestroy()
  self.isExpandArrow = true
  self.index = 0
  self.show1Data = nil
  self.show2Data = nil
  self.show3Data = nil
  self:ClearAllItem()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function M:ComponentDefine()
  self.imgArrow = self:AddComponent(UIImage, "TopBar/arrowImg")
  self.btnArrowImg = self:AddComponent(UIButton, "TopBar/arrowImg")
  self.btnArrowImg:SetOnClick(function()
    self:ExpandArrowShow(not self.isExpandArrow, false)
  end)
  self.textPageName = self:AddComponent(UITextMeshProUGUIEx, "TopBar/PageName")
  self.compMonsterPart = self:AddComponent(UIBaseContainer, "MonsterPart")
  self.compDescPart = self:AddComponent(UIBaseContainer, "DescPart")
  self.imgMonsterIcon = self:AddComponent(UIImage, "MonsterPart/monsterIcon")
  self.textMonsterName = self:AddComponent(UITextMeshProUGUIEx, "MonsterPart/monsterName")
  self.textMonsterDesc = self:AddComponent(UITextMeshProUGUIEx, "MonsterPart/monsterDesc")
  self.textDescPart = self:AddComponent(UITextMeshProUGUIEx, "DescPart")
  self.compRewardRateShowItem1 = self:AddComponent(UIBaseContainer, "rewardRateShowItem1")
  self.compRewardRateShowItem2 = self:AddComponent(UIBaseContainer, "rewardRateShowItem2")
  self.compRewardRateShowItem3 = self:AddComponent(UIBaseContainer, "rewardRateShowItem3")
  self.compScrollContent1 = self:AddComponent(UIBaseContainer, "rewardRateShowItem1/Scroll1/Viewport/Content1")
  self.compScrollContent2 = self:AddComponent(UIBaseContainer, "rewardRateShowItem2/Scroll2/Viewport/Content2")
  self.compScrollContent3 = self:AddComponent(UIBaseContainer, "rewardRateShowItem3/Scroll3/Viewport/Content3")
  self.compScroll1 = self:AddComponent(UIScrollRect, "rewardRateShowItem1/Scroll1")
  self.compScroll2 = self:AddComponent(UIScrollRect, "rewardRateShowItem2/Scroll2")
  self.compScroll3 = self:AddComponent(UIScrollRect, "rewardRateShowItem3/Scroll3")
  self.compRewardRateItem = self:AddComponent(UIBaseContainer, "rewardRateItem")
  self.compRewardItem = self:AddComponent(UIBaseContainer, "rewardItem")
  self.itemTitle1 = self:AddComponent(UITextMeshProUGUIEx, "rewardRateShowItem1/itemTitle1")
  self.itemTitle2 = self:AddComponent(UITextMeshProUGUIEx, "rewardRateShowItem2/itemTitle2")
  self.itemTitle3 = self:AddComponent(UITextMeshProUGUIEx, "rewardRateShowItem3/itemTitle3")
end

function M:ComponentDestroy()
  self.imgArrow = nil
  self.btnArrowImg = nil
  self.textPageName = nil
  self.compMonsterPart = nil
  self.compDescPart = nil
  self.imgMonsterIcon = nil
  self.textMonsterName = nil
  self.textMonsterDesc = nil
  self.textDescPart = nil
  self.compRewardRateShowItem1 = nil
  self.compRewardRateShowItem2 = nil
  self.compRewardRateShowItem3 = nil
  self.compScrollContent1 = nil
  self.compScrollContent2 = nil
  self.compScrollContent3 = nil
  self.compRewardRateItem = nil
  self.compRewardItem = nil
end

function M:SetItemShow(scrollItemCfg, isExpand, index)
  self.scrollItemCfg = scrollItemCfg
  self.isExpandArrow = isExpand
  self.index = index
  local barRowCfg = self.scrollItemCfg[1]
  self.textPageName:SetLocalText(barRowCfg.type_name)
  if barRowCfg.page == 1 then
    self:SetMonstePartHeight()
  elseif barRowCfg.page == 2 then
    self:SetDescPartTextHeight()
  end
  self:SetRewardRateShow()
  self:ExpandArrowShow(self.isExpandArrow, true)
end

function M:SetMonstePartHeight()
  local barRowCfg = self.scrollItemCfg[1]
  local curMonsterTemp = DataCenter.ActivityPartyMonsterTemplateManager:GetTemplate(barRowCfg.monster_id)
  local picPath = ""
  local pic = curMonsterTemp.pic_name
  if pic and pic ~= "" and type(pic) == "string" and string.startswith(pic, "Assets/Main/") then
    picPath = pic
  else
    picPath = string.format(UIAssets.UIActChristmasTreeSpritePath, pic)
  end
  self.imgMonsterIcon:LoadSprite(picPath)
  self.imgMonsterIcon:SetNativeSize()
  self.textMonsterName:SetLocalText(curMonsterTemp.name)
  self.textMonsterDesc:SetLocalText(curMonsterTemp.desc)
  local descPreferHeight = self.textMonsterDesc.unity_tmpro:GetPreferredValues().y
  local descFinalHeight = math.max(monsterDescMinHeight, descPreferHeight)
  self.textMonsterDesc:SetSizeDeltaY(descFinalHeight)
  local monsterPartHeight = descFinalHeight - monsterDescMinHeight + monsterPartMinHeight
  self.compMonsterPart:SetSizeDeltaY(monsterPartHeight)
  self.compDescPart:SetActive(barRowCfg.page == 2)
end

function M:SetDescPartTextHeight()
  local barRowCfg = self.scrollItemCfg[1]
  self.textDescPart:SetLocalText(barRowCfg.content_text)
  local descPreferHeight = self.textDescPart.unity_tmpro:GetPreferredValues().y
  self.textDescPart:SetSizeDeltaY(descPreferHeight + descPartBlankHeight)
end

function M:SetRewardRateShow()
  self.show1Data = {}
  self.show2Data = {}
  self.show3Data = {}
  self:PrepareRewardData(1, self.show1Data, self.itemTitle1)
  self:PrepareRewardData(2, self.show2Data, self.itemTitle2)
  self:PrepareRewardData(3, self.show3Data, self.itemTitle3)
  self:ClearAllItem()
  for i = 1, #self.show1Data do
    local item
    if self.show1Data[i].rateNum == nil or self.show1Data[i].rateNum == 0 then
      item = self.compRewardItem.gameObject:GameObjectSpawn(self.compScrollContent1.transform)
    else
      item = self.compRewardRateItem.gameObject:GameObjectSpawn(self.compScrollContent1.transform)
    end
    item.name = "BanquetAttackMonsterRateRewardItem" .. i
    local obj = self.compScrollContent1:AddComponent(BanquetAttackMonsterRateRewardItem, item.name)
    obj:SetActive(true)
    obj:SetData(self.show1Data[i])
    obj:SetLocalScaleXYZ(1, 1, 1)
  end
  for i = 1, #self.show2Data do
    local item
    if self.show2Data[i].rateNum == nil or self.show2Data[i].rateNum == 0 then
      item = self.compRewardItem.gameObject:GameObjectSpawn(self.compScrollContent2.transform)
    else
      item = self.compRewardRateItem.gameObject:GameObjectSpawn(self.compScrollContent2.transform)
    end
    item.name = "BanquetAttackMonsterRateRewardItem" .. i
    local obj = self.compScrollContent2:AddComponent(BanquetAttackMonsterRateRewardItem, item.name)
    obj:SetActive(true)
    obj:SetData(self.show2Data[i])
    obj:SetLocalScaleXYZ(1, 1, 1)
  end
  for i = 1, #self.show3Data do
    local item
    if self.show3Data[i].rateNum == nil or self.show3Data[i].rateNum == 0 then
      item = self.compRewardItem.gameObject:GameObjectSpawn(self.compScrollContent3.transform)
    else
      item = self.compRewardRateItem.gameObject:GameObjectSpawn(self.compScrollContent3.transform)
    end
    item.name = "BanquetAttackMonsterRateRewardItem" .. i
    local obj = self.compScrollContent3:AddComponent(BanquetAttackMonsterRateRewardItem, item.name)
    obj:SetActive(true)
    obj:SetData(self.show3Data[i])
    obj:SetLocalScaleXYZ(1, 1, 1)
  end
  self.compScroll1:SetEnable(#self.show1Data > 5)
  self.compScroll2:SetEnable(#self.show2Data > 5)
  self.compScroll3:SetEnable(#self.show3Data > 5)
end

function M:PrepareRewardData(index, showRewardData, titleCpt)
  if self.scrollItemCfg[index] ~= nil then
    if self.scrollItemCfg[index].sub_item then
      local rewardCfgList = string.string2array_i(self.scrollItemCfg[index].sub_item, ";", "|")
      for i = 1, #rewardCfgList do
        local tmpShowData = {}
        if rewardCfgList[i][1] == 1 then
          tmpShowData = {
            rewardType = ResTypeToReward[rewardCfgList[i][2]],
            count = rewardCfgList[i][3]
          }
        else
          tmpShowData = {
            rewardType = rewardCfgList[i][1],
            itemId = rewardCfgList[i][2],
            count = rewardCfgList[i][3]
          }
        end
        table.insert(showRewardData, tmpShowData)
      end
    end
    if self.scrollItemCfg[index].drop_show then
      local rewardRateList = string.split(self.scrollItemCfg[index].drop_show, "|")
      for i = 1, #rewardRateList do
        showRewardData[i].rateNum = tonumber(rewardRateList[i]) / 100
      end
    end
    if self.scrollItemCfg[index].special then
      local rewardSpecialList = string.split(self.scrollItemCfg[index].special, "|")
      for i = 1, #rewardSpecialList do
        showRewardData[i].isTip = tonumber(rewardSpecialList[i]) or 0
      end
    end
    titleCpt:SetLocalText(self.scrollItemCfg[index].sub_type_name)
  end
end

function M:ExpandArrowShow(state, isSkipChangeItemSize)
  self.isExpandArrow = state
  self.view:SetExpandStateByType(self.scrollItemCfg[1].type, self.isExpandArrow)
  if self.isExpandArrow then
    self.imgArrow:LoadSprite(arrow_open_img_path)
  else
    self.imgArrow:LoadSprite(arrow_close_img_path)
  end
  self.compMonsterPart:SetActive(self.isExpandArrow and self.scrollItemCfg[1].page == 1)
  self.compDescPart:SetActive(self.isExpandArrow and self.scrollItemCfg[1].page == 2)
  self.compRewardRateShowItem1:SetActive(self.isExpandArrow and self.scrollItemCfg[1] ~= nil)
  self.compRewardRateShowItem2:SetActive(self.isExpandArrow and self.scrollItemCfg[2] ~= nil)
  self.compRewardRateShowItem3:SetActive(self.isExpandArrow and self.scrollItemCfg[3] ~= nil)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.transform)
  if not isSkipChangeItemSize then
    self.view.ScrollLoopListView:OnItemSizeChanged(math.max(0, self.index - 1))
  end
end

function M:ClearAllItem()
  self.compScrollContent1:RemoveComponents(BanquetAttackMonsterRateRewardItem)
  self.compScrollContent2:RemoveComponents(BanquetAttackMonsterRateRewardItem)
  self.compScrollContent3:RemoveComponents(BanquetAttackMonsterRateRewardItem)
  self.compRewardRateItem.gameObject:GameObjectRecycleAll()
  self.compRewardItem.gameObject:GameObjectRecycleAll()
end

return UIBanquetItemDropProbabilityItem
