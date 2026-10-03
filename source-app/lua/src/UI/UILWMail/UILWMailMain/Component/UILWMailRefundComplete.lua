local base = UIBaseContainer
local UILWMailRefundComplete = BaseClass("UILWMailRefundComplete", base)
local Localization = CS.GameEntry.Localization
local rapidjson = require("rapidjson")
local M = UILWMailRefundComplete
local HeroRewardItem = require("UI.UICapacityBoxSelect.Component.UICapacityBoxHeroItem")
local RefundType = {
  RefundItem = 17701,
  RefundGoldBricks = 17702,
  RefundLimit = 17703,
  RefundBan = 17704,
  RefundItemAndObtain = 17709,
  RefundNoItem = 17710,
  RefundItem_GoldBlock = 17711,
  RefundItemAndObtain_GoldBlock = 17712,
  RefundNoItem_GoldBlock = 17713,
  RefundCancel = 17802
}

function M:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function M:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function M:ComponentDefine()
  self.textTopic = self:AddComponent(UITextMeshProUGUIEx, "Scroll/Viewport/Content/TopicText")
  self.textDetailTitle = self:AddComponent(UITextMeshProUGUIEx, "DetailTitle")
  self.textDetail = self:AddComponent(UITextMeshProUGUIEx, "Scroll/Viewport/Content/DetailText")
  self.textOrderTopic = self:AddComponent(UITextMeshProUGUIEx, "Scroll/Viewport/Content/OrderTopic")
  self.textOrder = self:AddComponent(UITextMeshProUGUIEx, "Scroll/Viewport/Content/OrderText")
  self.textPackageNameTopic = self:AddComponent(UITextMeshProUGUIEx, "Scroll/Viewport/Content/PackageNameTopic")
  self.textPackageName = self:AddComponent(UITextMeshProUGUIEx, "Scroll/Viewport/Content/PackageNameText")
  self.textPackageDateTopic = self:AddComponent(UITextMeshProUGUIEx, "Scroll/Viewport/Content/PackageDateTopic")
  self.textPackageDate = self:AddComponent(UITextMeshProUGUIEx, "Scroll/Viewport/Content/PackageDateText")
  self.textRefundProcessTimeTopic = self:AddComponent(UITextMeshProUGUIEx, "Scroll/Viewport/Content/RefundProcessTimeTopic")
  self.textRefundProcessTime = self:AddComponent(UITextMeshProUGUIEx, "Scroll/Viewport/Content/RefundProcessTimeText")
  self.textContent = self:AddComponent(UITextMeshProUGUIEx, "Scroll/Viewport/Content/ContentText")
  self.holder1 = self:AddComponent(UIBaseComponent, "Scroll/Viewport/Content/GameObject")
  self.detailTime = self:AddComponent(UITextMeshProUGUIEx, "DetailTimeBg/DetailTime")
  self.contentNode = self:AddComponent(UIBaseContainer, "Scroll/Viewport/Content")
  self.scroll = self:AddComponent(UIScrollRect, "Scroll")
  self.rewardContent = self:AddComponent(UIBaseContainer, "Scroll/Viewport/Content/RewardItem/DScroll/DViewport/DContent/DReward")
  local mail_reward_item_path = "Scroll/Viewport/Content/RewardItem/DScroll/DViewport/DContent/MailRewardItem"
  local hero_reward_item_path = "Scroll/Viewport/Content/RewardItem/DScroll/DViewport/DContent/HeroRewardItem"
  self.rewarditem = self.transform:Find(mail_reward_item_path).gameObject
  self.rewarditem:GameObjectCreatePool()
  self.rewardheroitem = self.transform:Find(hero_reward_item_path).gameObject
  self.rewardheroitem:GameObjectCreatePool()
  self.rewardNode = self:AddComponent(UIBaseContainer, "Scroll/Viewport/Content/RewardItem")
  self.rewardLayoutElement = self:AddComponent(UILayoutElement, "Scroll/Viewport/Content/RewardItem")
  self.dScrollNode = self:AddComponent(UIBaseContainer, "Scroll/Viewport/Content/RewardItem/DScroll")
  self.rewardContent2 = self:AddComponent(UIBaseContainer, "Scroll/Viewport/Content/RewardItem2/DScroll2/DViewport/DContent/DReward2")
  local mail_reward_item_path2 = "Scroll/Viewport/Content/RewardItem2/DScroll2/DViewport/DContent/MailRewardItem"
  local hero_reward_item_path2 = "Scroll/Viewport/Content/RewardItem2/DScroll2/DViewport/DContent/HeroRewardItem"
  self.rewarditem2 = self.transform:Find(mail_reward_item_path2).gameObject
  self.rewarditem2:GameObjectCreatePool()
  self.rewardheroitem2 = self.transform:Find(hero_reward_item_path2).gameObject
  self.rewardheroitem2:GameObjectCreatePool()
  self.rewardNode2 = self:AddComponent(UIBaseContainer, "Scroll/Viewport/Content/RewardItem2")
  self.rewardLayoutElement2 = self:AddComponent(UILayoutElement, "Scroll/Viewport/Content/RewardItem2")
  self.dScrollNode2 = self:AddComponent(UIBaseContainer, "Scroll/Viewport/Content/RewardItem2/DScroll2")
  local isGoogle = CS.SDKManager.IS_UNITY_ANDROID()
  self.textOrderTopic:SetActive(isGoogle)
  self.textOrder:SetActive(isGoogle)
  self.textPackageDate:SetAlignment(CommonUtil.IsArabic() and CS.TMPro.TextAlignmentOptions.MidlineRight or CS.TMPro.TextAlignmentOptions.MidlineLeft)
  self.textRefundProcessTime:SetAlignment(CommonUtil.IsArabic() and CS.TMPro.TextAlignmentOptions.MidlineRight or CS.TMPro.TextAlignmentOptions.MidlineLeft)
end

function M:ComponentDestroy()
  self.rewardContent:RemoveComponents(UICommonResItem)
  self.rewardContent:RemoveComponents(HeroRewardItem)
  self.rewardContent2:RemoveComponents(UICommonResItem)
  self.rewardContent2:RemoveComponents(HeroRewardItem)
  for _, v in ipairs(self.rewardContent.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  for _, v in ipairs(self.rewardContent2.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  self.rewarditem.gameObject:GameObjectRecycleAll()
  self.rewardheroitem.gameObject:GameObjectRecycleAll()
  self.rewarditem2.gameObject:GameObjectRecycleAll()
  self.rewardheroitem2.gameObject:GameObjectRecycleAll()
  self.textTopic = nil
  self.textDetailTitle = nil
  self.textDetail = nil
  self.textOrderTopic = nil
  self.textOrder = nil
  self.textPackageNameTopic = nil
  self.textPackageName = nil
  self.textPackageDateTopic = nil
  self.textPackageDate = nil
  self.textRefundProcessTimeTopic = nil
  self.textRefundProcessTime = nil
  self.textContent = nil
  self.rewardContent = nil
  self.rewardContent2 = nil
  self.rewarditem = nil
  self.rewardheroitem = nil
  self.rewardNode = nil
  self.detailTime = nil
  self.contentNode = nil
  self.scroll = nil
  self.rewarditem2 = nil
  self.rewardheroitem2 = nil
  self.rewardNode2 = nil
end

function M:DataDefine()
  self.mailData = {}
  self.mailUid = nil
  self.content = {}
end

function M:DataDestroy()
  self.mailData = nil
  self.mailUid = nil
  self.content = nil
end

function M:OnAddListener()
  base.OnAddListener(self)
end

function M:OnRemoveListener()
  base.OnRemoveListener(self)
end

function M:GatherReward(itemsList)
  local resultMap = {}
  for _, item in pairs(itemsList) do
    if item.type then
      local type = item.type
      local id = item.id or 0
      local key = id .. "_" .. type
      if resultMap[key] then
        resultMap[key].num = resultMap[key].num + item.num
      else
        resultMap[key] = {
          id = id,
          type = type,
          num = item.num
        }
      end
    end
  end
  local resultList = {}
  for _, item in pairs(resultMap) do
    table.insert(resultList, item)
  end
  return resultList
end

function M:RefreshContent()
  self.mailUid = self.view.ctrl:GetCurrentMail()
  self.mailData = self.view.ctrl:GetCurrentMailData()
  self.content = rapidjson.decode(self.mailData.contents)
  self.rewardList = self:GatherReward(self.content.obj.costReward or {})
  self.rewardList2 = self:GatherReward(self.content.obj.refundReward or {})
  self.rewardNode:SetActive(false)
  self.rewardNode2:SetActive(false)
  self:SetMailDetail()
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.contentNode.rectTransform)
  self.scroll:SetVerticalNormalizedPosition(1)
end

function M:SetMailDetail()
  if not self.content or not self.content.obj then
    Logger.LogError("SetMailDetail content is nil")
    return
  end
  local mailId = self.content.b.mailId
  if mailId == RefundType.RefundCancel then
    self.textTopic:SetActive(false)
    self.textDetail:SetActive(false)
    self.textOrderTopic:SetActive(false)
    self.textPackageNameTopic:SetActive(false)
    self.textPackageDateTopic:SetActive(false)
    self.textRefundProcessTimeTopic:SetActive(false)
    self.textOrder:SetActive(false)
    self.textPackageName:SetActive(false)
    self.textPackageDate:SetActive(false)
    self.textRefundProcessTime:SetActive(false)
    self.holder1:SetActive(false)
    self.textDetailTitle:SetLocalText("refund_mail_item_subject")
    local _strTime = MailShowHelper.GetAbstractCreateTime(self.mailData)
    self.detailTime:SetText(_strTime)
    local itemStr = ""
    local index = 0
    if self.rewardList then
      for k, v in pairs(self.rewardList) do
        local name = DataCenter.RewardManager:GetNameByType(tonumber(v.type), tonumber(v.id))
        local count = v.num
        local str = Localization:GetString("refund_mail_item", name, count)
        index = index + 1
        if k == #self.rewardList then
          itemStr = itemStr .. str
        else
          itemStr = itemStr .. str .. "\n"
        end
      end
    end
    local contentText = Localization:GetString("goldbrickshop_mail_1", itemStr)
    self.textContent:SetText(contentText)
    self:SetReward()
  else
    local isGoogle = CS.SDKManager.IS_UNITY_ANDROID()
    self.textTopic:SetActive(true)
    self.textDetail:SetActive(true)
    self.textOrderTopic:SetActive(isGoogle)
    self.textPackageNameTopic:SetActive(true)
    self.textPackageDateTopic:SetActive(true)
    self.textRefundProcessTimeTopic:SetActive(true)
    self.holder1:SetActive(true)
    self.textTopic:SetLocalText("refund_mail_opening")
    self.textDetail:SetLocalText("refund_mail_detail")
    self.textOrderTopic:SetLocalText("refund_mail_number")
    self.textPackageNameTopic:SetLocalText("refund_mail_packname")
    self.textPackageDateTopic:SetLocalText("refund_mail_date")
    self.textRefundProcessTimeTopic:SetLocalText("refund_mail_handletime")
    local obj = self.content.obj
    self.textOrder:SetActive(isGoogle)
    self.textPackageName:SetActive(true)
    self.textPackageDate:SetActive(true)
    self.textRefundProcessTime:SetActive(true)
    self.textOrder:SetText(obj.orderid or "")
    self.textPackageName:SetLocalText(obj.exchangeName)
    self.textPackageDate:SetText(UITimeManager:GetInstance():TimeStampToDayForLocal(obj.time))
    self.textRefundProcessTime:SetText(UITimeManager:GetInstance():TimeStampToDayForLocal(obj.refundTime))
    local _strTime = MailShowHelper.GetAbstractCreateTime(self.mailData)
    self.detailTime:SetText(_strTime)
    if mailId == RefundType.RefundItem or mailId == RefundType.RefundItem_GoldBlock then
      if mailId == RefundType.RefundItem_GoldBlock then
        self.textDetailTitle:SetLocalText("mail_refund_goldbrick_subject")
      else
        self.textDetailTitle:SetLocalText("refund_mail_item_subject")
      end
      local itemStr = ""
      local index = 0
      if self.rewardList then
        for k, v in pairs(self.rewardList) do
          local name = DataCenter.RewardManager:GetNameByType(tonumber(v.type), tonumber(v.id))
          local count = v.num
          local str = Localization:GetString("refund_mail_item", name, count)
          index = index + 1
          if k == #self.rewardList then
            itemStr = itemStr .. str
          else
            itemStr = itemStr .. str .. "\n"
          end
        end
      end
      local contentText = ""
      if mailId == RefundType.RefundItem_GoldBlock then
        contentText = Localization:GetString("mail_refund_goldbrick_content", itemStr, self:GetGoldBlockCount())
      else
        contentText = Localization:GetString("refund_mail_item_content", itemStr)
      end
      contentText = contentText .. [[


]]
      self.textContent:SetText(contentText)
      self:SetReward()
    elseif mailId == RefundType.RefundItemAndObtain or mailId == RefundType.RefundItemAndObtain_GoldBlock then
      if mailId == RefundType.RefundItemAndObtain_GoldBlock then
        self.textDetailTitle:SetLocalText("mail_refund_goldbrick_subject")
      else
        self.textDetailTitle:SetLocalText("refund_mail_item_subject")
      end
      local itemStr = ""
      if self.rewardList then
        for k, v in pairs(self.rewardList) do
          local name = DataCenter.RewardManager:GetNameByType(tonumber(v.type), tonumber(v.id))
          local count = v.num
          local str = Localization:GetString("refund_mail_item", name, count)
          if k == #self.rewardList then
            itemStr = itemStr .. str
          else
            itemStr = itemStr .. str .. "\n"
          end
        end
      end
      self:SetReward()
      local itemStr2 = ""
      if self.rewardList2 then
        for k, v in pairs(self.rewardList2) do
          local name = DataCenter.RewardManager:GetNameByType(tonumber(v.type), tonumber(v.id))
          local count = v.num
          local str = Localization:GetString("refund_mail_item", name, count)
          if k == #self.rewardList2 then
            itemStr2 = itemStr2 .. str
          else
            itemStr2 = itemStr2 .. str .. "\n"
          end
        end
      end
      local contentText = ""
      if mailId == RefundType.RefundItemAndObtain_GoldBlock then
        contentText = Localization:GetString("mail_refund_goldbrick_content01", itemStr, itemStr2, self:GetGoldBlockCount())
      else
        contentText = Localization:GetString("refund_mail_item_content01", itemStr, itemStr2)
      end
      contentText = contentText .. [[


]]
      self.textContent:SetText(contentText)
      self:SetReward2()
    elseif mailId == RefundType.RefundNoItem or mailId == RefundType.RefundNoItem_GoldBlock then
      if mailId == RefundType.RefundNoItem_GoldBlock then
        self.textDetailTitle:SetLocalText("mail_refund_goldbrick_subject")
      else
        self.textDetailTitle:SetLocalText("refund_mail_item_subject")
      end
      local contentText = ""
      if mailId == RefundType.RefundNoItem_GoldBlock then
        contentText = Localization:GetString("mail_refund_goldbrick_content02", self:GetGoldBlockCount())
      else
        contentText = Localization:GetString("refund_mail_item_content02")
      end
      contentText = contentText .. [[


]]
      self.textContent:SetText(contentText)
    elseif mailId == RefundType.RefundGoldBricks then
      self.textDetailTitle:SetLocalText("refund_mail_goldbrick_subject")
      local costGoldBrick = obj.costGoldBrick or 0
      local goldBrickStr = "" .. costGoldBrick
      local content = Localization:GetString("refund_mail_goldbrick_content", goldBrickStr)
      self.textContent:SetText(content)
    elseif mailId == RefundType.RefundLimit then
      self.textDetailTitle:SetLocalText("refund_mail_limit_subject")
      local banType = DataCenter.LWRefundPunishManager:GetBanTypeByBrickNum(obj.restGoldBrick or 0)
      local curPunishList = DataCenter.LWRefundPunishManager:GetPunishListByBanType(banType)
      local curPunishStr = ""
      for k, v in pairs(curPunishList) do
        local str = DataCenter.LWRefundPunishManager:GetPunishLocalizationString(v)
        if k == #curPunishList then
          curPunishStr = curPunishStr .. str
        else
          curPunishStr = curPunishStr .. str .. "\n"
        end
      end
      local nextPunish = DataCenter.LWRefundPunishManager:GetNextPunishByBanType(banType)
      local nextPunishStr = DataCenter.LWRefundPunishManager:GetPunishLocalizationString(nextPunish)
      local costGoldBrick = obj.costGoldBrick or 0
      local restGoldBrick = obj.restGoldBrick or 0
      local goldBrickStr = "" .. Localization:GetString("refund_mail_goldbrick", costGoldBrick)
      local content = Localization:GetString("refund_mail_limit_content", goldBrickStr, restGoldBrick, curPunishStr, nextPunishStr)
      self.textContent:SetText(content)
    elseif mailId == RefundType.RefundBan then
      self.textDetailTitle:SetLocalText("refund_mail_ban_subject")
      local costGoldBrick = obj.costGoldBrick or 0
      local goldBrickStr = "" .. costGoldBrick
      local content = Localization:GetString("refund_mail_ban_content", goldBrickStr)
      self.textContent:SetText(content)
    end
  end
end

function M:GetGoldBlockCount()
  local tmpGoldBrickCount = "0"
  if self.content ~= nil and self.content.b ~= nil and self.content.b.content ~= nil and self.content.b.content.dialog ~= nil and self.content.b.content.dialog.params ~= nil and self.content.b.content.dialog.params[1] ~= nil and not string.IsNullOrEmpty(self.content.b.content.dialog.params[1].text) then
    tmpGoldBrickCount = self.content.b.content.dialog.params[1].text
  end
  return tmpGoldBrickCount
end

function M:SetReward()
  self.rewardContent:SetActive(true)
  self.rewardContent:RemoveComponents(UICommonResItem)
  self.rewardContent:RemoveComponents(HeroRewardItem)
  for _, v in ipairs(self.rewardContent.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  self.rewarditem.gameObject:GameObjectRecycleAll()
  self.rewardheroitem.gameObject:GameObjectRecycleAll()
  local rewardNum = table.count(self.rewardList)
  if rewardNum <= 0 then
    self.rewardNode:SetActive(false)
  else
    self.rewardNode:SetActive(true)
    self:ShowReward(self.rewardList)
  end
end

function M:ShowReward(rewards)
  if rewards ~= nil and table.count(rewards) > 0 then
    for _, iteminfo in pairs(rewards) do
      local itemId = iteminfo.id
      local itemCnt = iteminfo.num
      local type = iteminfo.type
      local param = {
        rewardType = type,
        itemId = itemId,
        count = itemCnt
      }
      self:ShowRewardItem(param)
    end
    if table.count(rewards) > 4 then
      self.rewardNode:SetSizeDeltaXY(652, 350)
      self.rewardLayoutElement:SetMinHeight(350)
      local x, y = self.dScrollNode:GetSizeDeltaXY()
      self.dScrollNode:SetSizeDeltaXY(x, 350)
    else
      self.rewardNode:SetSizeDeltaXY(652, 200)
      self.rewardLayoutElement:SetMinHeight(200)
      local x, y = self.dScrollNode:GetSizeDeltaXY()
      self.dScrollNode:SetSizeDeltaXY(x, 200)
    end
  end
end

function M:ShowRewardItem(rewardData)
  NameCount = NameCount + 1
  if rewardData.rewardType == RewardType.HERO then
    local objName = rewardData.rewardType .. NameCount
    local item = self.rewardheroitem:GameObjectSpawn(self.rewardContent.transform)
    item.name = objName
    local obj = self.rewardContent:AddComponent(HeroRewardItem, item.name)
    local param = {}
    param.heroId = rewardData.itemId
    param.count = rewardData.count
    local heroName = GetTableData(TableName.LW_Hero, rewardData.itemId, "first_name")
    local heroQuality = GetTableData(TableName.LW_Hero, rewardData.itemId, "quality")
    param.name = string.format("<color='%s'>%s</color>", HeroUtils.GetQualityColorStr(heroQuality), Localization:GetString(heroName))
    obj:RefreshData(param)
  else
    local objName = rewardData.rewardType .. NameCount
    local item = self.rewarditem:GameObjectSpawn(self.rewardContent.transform)
    item.name = objName
    local obj = self.rewardContent:AddComponent(UICommonResItem, item.name)
    obj:ReInit(rewardData)
  end
end

function M:SetReward2()
  self.rewardContent2:SetActive(true)
  self.rewardContent2:RemoveComponents(UICommonResItem)
  self.rewardContent2:RemoveComponents(HeroRewardItem)
  for _, v in ipairs(self.rewardContent2.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  self.rewarditem2.gameObject:GameObjectRecycleAll()
  self.rewardheroitem2.gameObject:GameObjectRecycleAll()
  local rewardNum2 = table.count(self.rewardList2)
  if rewardNum2 <= 0 then
    self.rewardNode2:SetActive(false)
  else
    self.rewardNode2:SetActive(true)
    self:ShowReward2(self.rewardList2)
  end
end

function M:ShowReward2(rewards)
  if rewards ~= nil and table.count(rewards) > 0 then
    for _, iteminfo in pairs(rewards) do
      local itemId = iteminfo.id
      local itemCnt = iteminfo.num
      local type = iteminfo.type
      local param = {
        rewardType = type,
        itemId = itemId,
        count = itemCnt
      }
      self:ShowRewardItem2(param)
    end
    if table.count(rewards) > 4 then
      self.rewardNode2:SetSizeDeltaXY(652, 350)
      self.rewardLayoutElement2:SetMinHeight(350)
      local x, y = self.dScrollNode2:GetSizeDeltaXY()
      self.dScrollNode2:SetSizeDeltaXY(x, 350)
    else
      self.rewardNode2:SetSizeDeltaXY(652, 200)
      self.rewardLayoutElement2:SetMinHeight(200)
      local x, y = self.dScrollNode2:GetSizeDeltaXY()
      self.dScrollNode2:SetSizeDeltaXY(x, 200)
    end
  end
end

function M:ShowRewardItem2(rewardData)
  NameCount = NameCount + 1
  if rewardData.rewardType == RewardType.HERO then
    local objName = rewardData.rewardType .. NameCount
    local item = self.rewardheroitem2:GameObjectSpawn(self.rewardContent2.transform)
    item.name = objName
    local obj = self.rewardContent2:AddComponent(HeroRewardItem, item.name)
    local param = {}
    param.heroId = rewardData.itemId
    param.count = rewardData.count
    local heroName = GetTableData(TableName.LW_Hero, rewardData.itemId, "first_name")
    local heroQuality = GetTableData(TableName.LW_Hero, rewardData.itemId, "quality")
    param.name = string.format("<color='%s'>%s</color>", HeroUtils.GetQualityColorStr(heroQuality), Localization:GetString(heroName))
    obj:RefreshData(param)
  else
    local objName = rewardData.rewardType .. NameCount
    local item = self.rewarditem2:GameObjectSpawn(self.rewardContent2.transform)
    item.name = objName
    local obj = self.rewardContent2:AddComponent(UICommonResItem, item.name)
    obj:ReInit(rewardData)
  end
end

return UILWMailRefundComplete
