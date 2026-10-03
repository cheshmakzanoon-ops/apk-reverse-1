local base = UIBaseContainer
local UIMailDetailS0AllianceBossAlliance = BaseClass("UIMailDetailS0AllianceBossAlliance", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local rapidjson = require("rapidjson")
local UIS0AllianceBossSliderAlliance = require("UI.UIS0AllianceBoss.Component.UIS0AllianceBossSliderAlliance")
local UIDecorationMainCity = require("UI.UIDecoration.UIDecorationMain.Component.UIDecorationMainCity")
local UIS0AllianceBossRankItem = require("UI.UIS0AllianceBoss.Component.UIS0AllianceBossRankItem")
local MailRewardCommonItem = require("UI.UILWMail.UILWMailMain.Component.MailRewardCommonItem")
local S0AllianceBossRankData = require("DataCenter.ActS0AllianceBoss.S0AllianceBossRankData")
local mail_reward_item_path = "Root/MailRewardCommonItem"

function UIMailDetailS0AllianceBossAlliance:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIMailDetailS0AllianceBossAlliance:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIMailDetailS0AllianceBossAlliance:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTitleDetail = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.textMessage = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textTitle01 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textBonus = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.compS0AllianceBossSliderAlliance = self.viewSkin:AddComponent(self, UIS0AllianceBossSliderAlliance, 5)
  self.textTitle02 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.textParticipantCount = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.compGridReward = self.viewSkin:AddComponent(self, UIBaseContainer, 8)
  self.textMvpBouns = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.compCityIcon = self.viewSkin:AddComponent(self, UIDecorationMainCity, 10)
  self.compHead = self.viewSkin:AddComponent(self, UICommonHead, 11)
  self.imgIconOffcial = self.viewSkin:AddComponent(self, UIImage, 12)
  self.textMvpName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 13)
  self.textMvpPower = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 14)
  self.textMvpAttack = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 15)
  self.textMvpDamage = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 16)
  self.scrollView = self.viewSkin:AddComponent(self, UIScrollView, 17)
  self.textRankTip = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 18)
  self.textDetailtime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 19)
  self.compImgTag = self.viewSkin:AddComponent(self, UIBaseContainer, 20)
  self.compMVP = self.viewSkin:AddComponent(self, UIBaseContainer, 21)
  self.textMessageRich = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 22)
  self.compProgressReward = self.viewSkin:AddComponent(self, UIBaseContainer, 23)
  self.rewardItem = self.transform:Find(mail_reward_item_path).gameObject
  self.rewardItem:GameObjectCreatePool()
  self.scrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.scrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
  self.textMessageRich:OnPointerClick(function(eventData)
    self:OnPointerClick(eventData.position)
  end)
end

function UIMailDetailS0AllianceBossAlliance:ComponentDestroy()
  self:ClearScroll()
  self:RemoveRewards()
  self.rewardItem = nil
  self.viewSkin = nil
  self.textTitleDetail = nil
  self.textMessage = nil
  self.textTitle01 = nil
  self.textBonus = nil
  self.compS0AllianceBossSliderAlliance = nil
  self.textTitle02 = nil
  self.textParticipantCount = nil
  self.compGridReward = nil
  self.textMvpBouns = nil
  self.compCityIcon = nil
  self.compHead = nil
  self.imgIconOffcial = nil
  self.textMvpName = nil
  self.textMvpPower = nil
  self.textMvpAttack = nil
  self.textMvpDamage = nil
  self.scrollView = nil
  self.textRankTip = nil
  self.textDetailtime = nil
  self.compImgTag = nil
  self.compMVP = nil
  self.textMessageRich = nil
  self.compProgressReward = nil
end

function UIMailDetailS0AllianceBossAlliance:DataDefine()
  self.rankList = nil
end

function UIMailDetailS0AllianceBossAlliance:DataDestroy()
  self.rankList = nil
end

function UIMailDetailS0AllianceBossAlliance:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ReadOneMailRespond, self.RewardSuccess)
end

function UIMailDetailS0AllianceBossAlliance:OnRemoveListener()
  self:RemoveUIListener(EventId.ReadOneMailRespond, self.RewardSuccess)
  base.OnRemoveListener(self)
end

function UIMailDetailS0AllianceBossAlliance:RefreshContent()
  self.mailUid = self.view.ctrl:GetCurrentMail()
  self.mailData = self.view.ctrl:GetCurrentMailData()
  local data = rapidjson.decode(self.mailData.contents)
  local rankList = data.obj.rankList
  local result = {}
  local selfUid = LuaEntry.Player:GetUid()
  for i, v in ipairs(rankList) do
    local oneData = S0AllianceBossRankData.New()
    oneData:ParseData(v)
    result[i] = oneData
    oneData.isSelf = oneData.uid == selfUid
  end
  self.rankList = result
  local _strTitle = MailShowHelper.GetMainTitle(self.mailData)
  self.textTitleDetail:SetText(_strTitle)
  local dialog = data.b.content.dialog
  local id = dialog.id
  local params = dialog.params
  local newParams = {}
  for i, v in ipairs(params) do
    if i == 2 then
      local dmgStr = string.GetFormattedStr2(tonumber(v.text))
      newParams[i] = dmgStr
    else
      newParams[i] = v.text
    end
  end
  local _strContents = Localization:GetString(id, SafeUnpack(newParams))
  self:SetMailText(_strContents)
  local _strTime = MailShowHelper.GetAbstractCreateTime(self.mailData)
  self.textDetailtime:SetText(_strTime)
  if data.obj.cfgId then
    self.compProgressReward:SetActive(true)
    self.textTitle01:SetLocalText("s0_alliance_boss_alliance_progress")
    if data.obj.mvpBonus then
      self.compImgTag:SetActive(true)
      self.textBonus:SetText("x" .. data.obj.mvpBonus)
    else
      self.textBonus:SetText("")
      self.compImgTag:SetActive(false)
    end
    local cfgId = data.obj.cfgId
    local bossTemp = DataCenter.AllianceBossS0TemplateManager:GetTemplate(cfgId)
    if bossTemp then
      local allianceDmgMax = bossTemp.allianceMaxDmg
      local damage = data.obj.totalDamage
      self.compS0AllianceBossSliderAlliance:RefreshView(damage, allianceDmgMax, bossTemp.allianceDmg, bossTemp.difficulty)
    end
  else
    self.compProgressReward:SetActive(false)
  end
  self.textTitle02:SetLocalText("s0_alliance_boss_reward_detail")
  self:RemoveRewards()
  self:ShowReward(self.mailData)
  if data.obj.fightNum and data.obj.memberNum then
    self.textParticipantCount:SetLocalText("s0_alliance_boss_member_count", data.obj.fightNum, data.obj.memberNum)
  else
    self.textParticipantCount:SetText("")
  end
  local mvpData = rankList and rankList[1]
  if mvpData then
    self.compMVP:SetActive(true)
    self.compHead:SetEnableClickShowInfo(true, true)
    self.compHead:SetHeadAndFrame(mvpData.uid, mvpData.pic, mvpData.picVer, false, mvpData.headSkinId, mvpData.headSkinET)
    self.compCityIcon:ReInit({
      decorationId = mvpData.baseSkinId or DEFAULT_CITY_SKIN,
      mainLevel = mvpData.level
    })
    self.textMvpName:SetText(UIUtil.FormatAllianceAndName(mvpData.abbr, mvpData.name))
    self.textMvpPower:SetText(string.GetFormattedSeparatorNum(mvpData.power))
    self.textMvpAttack:SetLocalText(2010338, mvpData.atkCount)
    self.textMvpDamage:SetLocalText(2010337, string.GetFormattedStr2(mvpData.damage))
    if mvpData.positionId and mvpData.positionId > 0 then
      self.imgIconOffcial:SetActive(true)
      self.imgIconOffcial:LoadSpriteAuto(LWAlMemberOffcialParam[mvpData.positionId].SmallIcon)
    elseif mvpData.alRank and mvpData.alRank >= 4 then
      self.imgIconOffcial:SetActive(true)
      self.imgIconOffcial:LoadSpriteAuto(LWAlMemberRankParam[mvpData.alRank].Icon)
    else
      self.imgIconOffcial:SetActive(false)
    end
  else
    self.compMVP:SetActive(false)
  end
  self.textRankTip:SetLocalText("s0_alliance_boss_damage_ranking")
  self:ClearScroll()
  local count = #self.rankList - 1
  if 0 < count then
    self.scrollView:SetTotalCount(count)
    self.scrollView:RefillCells()
  end
end

function UIMailDetailS0AllianceBossAlliance:RemoveRewards()
  self.compGridReward:RemoveComponents(MailRewardCommonItem)
  self.rewardItem.gameObject:GameObjectRecycleAll()
end

function UIMailDetailS0AllianceBossAlliance:ShowRewardItem(rewardData)
  NameCount = NameCount + 1
  if rewardData.rewardType == RewardType.HERO then
    local objName = rewardData.rewardType .. NameCount
    local item = self.rewardItem:GameObjectSpawn(self.compGridReward.transform)
    item.name = objName
    local obj = self.compGridReward:AddComponent(MailRewardCommonItem, item.name)
    local param = {}
    param.heroId = rewardData.itemId
    param.count = rewardData.count
    local heroName = GetTableData(TableName.LW_Hero, rewardData.itemId, "first_name")
    local heroQuality = GetTableData(TableName.LW_Hero, rewardData.itemId, "quality")
    param.name = string.format("<color='%s'>%s</color>", HeroUtils.GetQualityColorStr(heroQuality), Localization:GetString(heroName))
    obj:RefreshData(param, self.mailData.rewardStatus == 1)
  else
    local objName = rewardData.rewardType .. NameCount
    local item = self.rewardItem:GameObjectSpawn(self.compGridReward.transform)
    item.name = objName
    local obj = self.compGridReward:AddComponent(MailRewardCommonItem, item.name)
    obj:ReInit(rewardData, self.mailData.rewardStatus == 1)
  end
end

function UIMailDetailS0AllianceBossAlliance:ShowReward(maildata)
  local pay = maildata:GetMailPay()
  local reward = maildata:GetMailReward()
  local totalCnt = 0
  if pay ~= nil then
    local goldCnt = pay.gold or 0
    if 0 < goldCnt then
      totalCnt = totalCnt + 1
      self:ShowRewardItem({
        rewardType = RewardType.GOLD,
        itemId = "gold",
        count = goldCnt
      })
    end
  end
  if reward ~= nil and 0 < table.count(reward.rewardInfo) then
    local tabReward = reward.rewardInfo
    for _, iteminfo in pairs(tabReward) do
      if iteminfo.type == RewardType.GOODS then
        local itemId = iteminfo.id
        local itemCnt = iteminfo.num
        local param = {
          rewardType = RewardType.GOODS,
          itemId = itemId,
          count = itemCnt
        }
        totalCnt = totalCnt + 1
        self:ShowRewardItem(param)
      else
        local itemId = iteminfo.id
        local itemCnt = iteminfo.num
        local param = {
          rewardType = iteminfo.type,
          itemId = itemId,
          count = itemCnt
        }
        totalCnt = totalCnt + 1
        self:ShowRewardItem(param)
      end
    end
  end
  return totalCnt
end

function UIMailDetailS0AllianceBossAlliance:RewardSuccess()
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Common_GetReward, false)
  local pay = self.mailData:GetMailPay()
  if pay ~= nil and pay.gold > 0 then
    UIUtil.DoFly(RewardType.GOLD, 2, DataCenter.RewardManager:GetPicByType(RewardType.GOLD), self.compGridReward.transform:GetChild(0).gameObject.transform.position, Vector3.New(0, 0, 0), 100, 100)
  end
  local reward = self.mailData:GetMailReward()
  local tempType = {}
  if reward and reward.rewardInfo then
    for i = 1, #reward.rewardInfo do
      if reward.rewardInfo[i].type ~= RewardType.FOOD and reward.rewardInfo[i].type ~= RewardType.GOLD then
        table.insert(tempType, RewardToResType[reward.rewardInfo[i].type])
      end
    end
  end
  if next(tempType) then
    EventManager:GetInstance():Broadcast(EventId.RefreshTopResByPickUp, tempType)
  end
  if reward ~= nil and 0 < table.count(reward.rewardInfo) then
    for i = 1, #reward.rewardInfo do
      local child = self.compGridReward.transform:GetChild(i - 1)
      local img = child.gameObject.transform:Find("MailRewardItem/clickBtn/ItemIcon")
      if img then
        local pic = DataCenter.RewardManager:GetPicByType(reward.rewardInfo[i].type, reward.rewardInfo[i].id)
        local flyPos = Vector3.New(0, 0, 0)
        UIUtil.DoFly(reward.rewardInfo[i].type, 2, pic, img.gameObject.transform.position, flyPos, 100, 100)
      end
    end
  end
  self:RefreshContent()
end

function UIMailDetailS0AllianceBossAlliance:SetMailText(txt)
  local hasLinkData = txt:find("<link") ~= nil and txt:find("</link>") ~= nil
  if not hasLinkData and txt:find("X:") ~= nil and txt:find("Y:") ~= nil then
    txt = FindAndAppendLinkInfo(txt)
  end
  if hasLinkData or txt:find("<u>") ~= nil and txt:find("</u>") ~= nil then
    self.textMessageRich:SetText(txt)
    self.textMessage:SetActive(false)
    self.textMessageRich:SetActive(true)
  else
    self.textMessage:SetText(txt)
    self.textMessage:SetActive(true)
    self.textMessageRich:SetActive(false)
  end
end

function UIMailDetailS0AllianceBossAlliance:OnPointerClick(clickPos)
  if self.textMessageRich == nil then
    return
  end
  local linkId = self.textMessageRich:TryGetPointerClickLinkID(clickPos)
  if string.IsNullOrEmpty(linkId) then
    return
  end
  if string.find(linkId, "http:") or string.find(linkId, "https:") then
    CS.SDKManager.OpenURL(linkId)
  else
    local linkMsg = base64.decode(linkId)
    linkMsg = rapidjson.decode(linkMsg)
    GoToUtil.TryJumpToWorld(linkMsg)
  end
end

function UIMailDetailS0AllianceBossAlliance:OnItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scrollView:AddComponent(UIS0AllianceBossRankItem, itemObj)
  if cellItem ~= nil then
    index = index + 1
    local info = self.rankList[index]
    if info then
      cellItem:RefreshItem(info)
    end
  end
end

function UIMailDetailS0AllianceBossAlliance:OnItemMoveOut(itemObj, index)
  self.scrollView:RemoveComponent(itemObj.name, UIS0AllianceBossRankItem)
end

function UIMailDetailS0AllianceBossAlliance:ClearScroll()
  self.scrollView:ClearCells()
  self.scrollView:RemoveComponents(UIS0AllianceBossRankItem)
end

return UIMailDetailS0AllianceBossAlliance
