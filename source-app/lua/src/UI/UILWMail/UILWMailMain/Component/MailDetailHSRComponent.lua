local base = UIBaseContainer
local MailDetailHSRComponent = BaseClass("MailDetailHSRComponent", UIBaseContainer)
local MailSaleItemComponent = require("UI/UILWMail/UILWMailMain/Component/MailSaleItemComponent")
local MailRewardCommonItem = require("UI.UILWMail.UILWMailMain.Component.MailRewardCommonItem")
local Localization = CS.GameEntry.Localization
local rapidjson = require("rapidjson")
local head_path = "Root/ScrollView/Viewport/Content/Head"
local mail_sale_item_path = "Root/MailSaleItem"
local base64 = require("Framework.Common.base64")

function MailDetailHSRComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function MailDetailHSRComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function MailDetailHSRComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 2)
  self.textDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textStation = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.textHead1 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.textHead2 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.textHead3 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.compUIPlayerHead = self.viewSkin:AddComponent(self, UICommonHead, 8)
  self.textName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.textPrice = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
  self.textCount = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 11)
  self.textDetailTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 12)
  self.jump_text = self:AddComponent(UITextMeshProUGUIEx, "Root/ScrollView/Viewport/Content/JumpText")
  self.jump_text:OnPointerClick(function(eventData)
    local pos = eventData.position
    if self.jump_text == nil then
      return
    end
    local linkId = self.jump_text:TryGetPointerClickLinkID(pos)
    if string.IsNullOrEmpty(linkId) then
      return
    end
    local link = rapidjson.decode(base64.decode(linkId))
    local hsrUuid = link.hsrUuid
    if DataCenter.ActivityListDataManager:GetOneOpenActivityByType(EnumActivity.HighSpeedRailway.Type) then
      RailwayUtil.TryOpenHSRMain()
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIHSRPersonalHistoryDetail, {anim = true}, hsrUuid)
    else
      UIUtil.ShowTipsId(370100)
    end
  end)
  self.jinjiejing = self:AddComponent(UIImage, "Root/MailSaleItem/Jinjiejing")
  self.jinjiejing:LoadSpriteAsync("Assets/Main/Sprites/ItemIcons/LXY_s5_jinjiejing_icon2.png")
  self.head = self:AddComponent(UIImage, head_path)
  self.mail_sale_item = self:AddComponent(UIImage, mail_sale_item_path)
  self.textTitle:SetLocalText("activity_1200044_mail_title")
  self.textHead1:SetLocalText("100184")
  self.textHead2:SetLocalText("activity_1200044_tips79")
  self.textHead3:SetLocalText("activity_1200044_tips80")
  self.compUIPlayerHead:SetAsMyself()
  self.compUIPlayerHead:SetEnableClickShowInfo(true, true)
  self.textName:SetText(LuaEntry.Player:GetFullNameWithSourceServer())
  self.rewardContent = self:AddComponent(UIBaseContainer, "Root/ScrollView/Viewport/Content/DReward")
  self.scroll_view = self:AddComponent(UIScrollRect, "Root/ScrollView")
end

function MailDetailHSRComponent:ComponentDestroy()
  self:ClearAllTradeItems()
  self.viewSkin = nil
  self.textTitle = nil
  self.compContent = nil
  self.textDesc = nil
  self.textStation = nil
  self.textHead1 = nil
  self.textHead2 = nil
  self.textHead3 = nil
  self.compUIPlayerHead = nil
  self.textName = nil
  self.textPrice = nil
  self.textCount = nil
  self.textDetailTime = nil
end

function MailDetailHSRComponent:DataDefine()
end

function MailDetailHSRComponent:DataDestroy()
end

function MailDetailHSRComponent:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ReadOneMailRespond, self.RewardSuccess)
end

function MailDetailHSRComponent:OnRemoveListener()
  self:RemoveUIListener(EventId.ReadOneMailRespond, self.RewardSuccess)
  base.OnRemoveListener(self)
end

function MailDetailHSRComponent:RefreshContent()
  self.mailUid = self.view.ctrl:GetCurrentMail()
  self.mailData = self.view.ctrl:GetCurrentMailData()
  self.data = rapidjson.decode(self.mailData.contents)
  self:RefreshView()
end

function MailDetailHSRComponent:RefreshView()
  self:ClearAllTradeItems()
  local data = self.data
  local dialog = data.b.content.dialog
  self.textDesc:SetLocalText(dialog.id, dialog.params[1].text, dialog.params[2].text, dialog.params[3].text)
  local strTime = MailShowHelper.GetAbstractCreateTime(self.mailData)
  self.textDetailTime:SetText(strTime)
  local hsrUuid = dialog.params[5] and dialog.params[5].text
  if string.IsNullOrEmpty(hsrUuid) then
    self.jump_text:SetActive(false)
  else
    local link = {
      hsrUuid = tonumber(hsrUuid)
    }
    local js = rapidjson.encode(link)
    local strLink = Localization:GetString("activity_1200044_tips15")
    strLink = string.format("<link=\"%s\">%s</link>", base64.encode(js), strLink)
    self.jump_text:SetText(strLink)
    self.jump_text:SetActive(true)
  end
  local reward = self.mailData:GetMailReward()
  local rewardList = {}
  if reward ~= nil and table.count(reward.rewardInfo) > 0 then
    local tabReward = reward.rewardInfo
    for _, iteminfo in pairs(tabReward) do
      if iteminfo.type == RewardType.GOODS then
        local itemId = iteminfo.id
        local itemCnt = iteminfo.num
        if itemCnt and 0 < itemCnt then
          local param = {
            rewardType = RewardType.GOODS,
            itemId = itemId,
            count = itemCnt
          }
          table.insert(rewardList, param)
        end
      else
        local itemId = iteminfo.id
        local itemCnt = iteminfo.num
        if itemCnt and 0 < itemCnt then
          local param = {
            rewardType = iteminfo.type,
            itemId = itemId,
            count = itemCnt
          }
          table.insert(rewardList, param)
        end
      end
    end
  end
  for k, v in ipairs(rewardList) do
    local req = self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/Mail/ObjMail/MailRewardCommonItem.prefab")
    req:completed("+", function()
      if not IsNull(req.gameObject) then
        local go = req.gameObject
        local transform = go.transform
        transform:SetParent(self.rewardContent.transform)
        transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        go.name = "reward" .. k
        local item = self.rewardContent:AddComponent(MailRewardCommonItem, go.name)
        item:SetActive(true)
        item:ReInit(v, self.mailData.rewardStatus == 1)
      end
    end)
    table.insert(self.rewardItems, req)
  end
  if tonumber(dialog.params[4].text) == HSRSellType.Consign then
    self.head:SetActive(false)
    self.mail_sale_item:SetActive(false)
    self.textStation:SetActive(false)
    return
  end
  self.head:SetActive(true)
  self.mail_sale_item:SetActive(data.obj.owner)
  self.textStation:SetActive(true)
  if data.obj.owner and data.obj.owner.sellPrice and data.obj.owner.sellNum then
    self.mail_sale_item:SetActive(true)
    self.textPrice:SetText(data.obj.owner.sellPrice)
    self.textCount:SetText(data.obj.owner.sellNum)
    self.scroll_view:SetSizeDeltaY(-398)
    self.scroll_view:SetAnchoredPositionXY(0, -9)
  else
    self.mail_sale_item:SetActive(false)
    self.scroll_view:SetSizeDeltaY(-276)
    self.scroll_view:SetAnchoredPositionXY(0, -70)
  end
  local dumpBodyJson = data.obj.dumpBodyJson
  self.textStation:SetText(UIUtil.FormatServerName(dumpBodyJson.stationServer))
  local sellUserArray = dumpBodyJson.sellUserArray or {}
  local consign = {
    sellType = HSRSellType.Consign,
    sellPrice = DataCenter.HSRDataManager:GetConsignPrice(),
    sellNum = dumpBodyJson.consignmentNum or 0
  }
  table.insert(sellUserArray, consign)
  table.sort(sellUserArray, function(a, b)
    return a.sellPrice > b.sellPrice
  end)
  for _, v in ipairs(sellUserArray) do
    local item = self.compContent:LoadComponentAsync(MailSaleItemComponent, "Assets/Main/SeasonRes/Shared/Prefabs/UI/Mail/MailSaleItem.prefab")
    item:SetData(v)
    table.insert(self.tradeItems, item)
  end
end

function MailDetailHSRComponent:ClearAllTradeItems()
  if self.tradeItems then
    for _, v in pairs(self.tradeItems) do
      self.compContent:RemoveAsyncComponent(v)
    end
  end
  self.tradeItems = {}
  self.rewardContent:RemoveComponents(MailRewardCommonItem)
  if self.rewardItems then
    for k, v in pairs(self.rewardItems) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.rewardItems = {}
end

function MailDetailHSRComponent:RewardSuccess()
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Common_GetReward, false)
  local reward = self.mailData:GetMailReward()
  local tempType = {}
  local realRewardCount = 0
  if reward and reward.rewardInfo then
    for i = 1, #reward.rewardInfo do
      local itemCnt = reward.rewardInfo[i].num
      if itemCnt and 0 < itemCnt then
        realRewardCount = realRewardCount + 1
        if reward.rewardInfo[i].type ~= RewardType.FOOD and reward.rewardInfo[i].type ~= RewardType.GOLD then
          local resType = RewardToResType[reward.rewardInfo[i].type]
          if resType then
            table.insert(tempType, resType)
          end
        end
      end
    end
  end
  if next(tempType) then
    EventManager:GetInstance():Broadcast(EventId.RefreshTopResByPickUp, tempType)
  end
  if reward and 0 < table.count(reward.rewardInfo) and realRewardCount <= self.rewardContent.transform.childCount then
    local childIndex = -1
    for i = 1, #reward.rewardInfo do
      local itemCnt = reward.rewardInfo[i].num
      if itemCnt and 0 < itemCnt then
        childIndex = childIndex + 1
        local child = self.rewardContent.transform:GetChild(childIndex)
        local img = child.gameObject.transform:Find("MailRewardItem/clickBtn/ItemIcon")
        local pic = DataCenter.RewardManager:GetPicByType(reward.rewardInfo[i].type, reward.rewardInfo[i].id)
        local flyPos = Vector3.New(0, 0, 0)
        UIUtil.DoFly(reward.rewardInfo[i].type, 2, pic, img.gameObject.transform.position, flyPos, 100, 100)
      end
    end
  end
  self:RefreshContent()
end

return MailDetailHSRComponent
