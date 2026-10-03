local base = UIBaseView
local UILWMailSeasonRewardView = BaseClass("UILWMailSeasonRewardView", base)
local HeroRewardItem = require("UI.UICapacityBoxSelect.Component.UICapacityBoxHeroItem")
local MailRewardItem = require("UI.UIMailNew.UIMailMainPanel.Component.MailRewardItem")
local envelope_path = "envelope"
local letter_path = "letter"
local rewardTier_path = "envelope/rewardTier"
local allianceName_path = "envelope/allianceName"
local openBtn_path = "envelope/openBtn"
local title_path = "letter/content/Image_ditu/title"
local conclusion_path = "letter/content/Image_ditu/Conclusion"
local receiveBtn_path = "letter/content/Image_ditu/receiveBtn"
local mainInfo_path = "letter/content/Image_ditu/DScroll/DViewport/DContent/DMessage"
local rewardContent_path = "letter/content/Image_ditu/DScroll/DViewport/DContent/DReward"
local rewarditem_path = "letter/content/Image_ditu/DScroll/DViewport/DContent/MailRewardItem"
local rewardheroitem_path = "letter/content/Image_ditu/DScroll/DViewport/DContent/HeroRewardItem"
local senderName_path = "letter/content/Image_ditu/senderName"
local closeBtn_path = "CloseBtn"
local animatorCom_path = ""
local btnDes_path = "letter/content/Image_ditu/receiveBtn/ButtonDes"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  local mailUid = self:GetUserData()
  self.mailData = DataCenter.MailDataManager:GetMailInfoById(mailUid)
  if self.mailData then
    self:Refresh()
  else
    self.ctrl:CloseSelf()
  end
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

function UILWMailSeasonRewardView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.MailPush, self.RefreshReceiveBtn)
  self:AddUIListener(EventId.ReadOneMailRespond, self.RewardSuccess)
end

function UILWMailSeasonRewardView:OnRemoveListener()
  self:RemoveUIListener(EventId.MailPush, self.RefreshReceiveBtn)
  self:RemoveUIListener(EventId.ReadOneMailRespond, self.RewardSuccess)
  base.OnRemoveListener(self)
end

local function ComponentDefine(self)
  self.envelope = self:AddComponent(UIBaseContainer, envelope_path)
  self.letter = self:AddComponent(UIBaseContainer, letter_path)
  self.rewardTier = self:AddComponent(UIImage, rewardTier_path)
  self.allianceName = self:AddComponent(UIText, allianceName_path)
  self.openBtn = self:AddComponent(UIButton, openBtn_path)
  self.title = self:AddComponent(UIText, title_path)
  self.conclusion = self:AddComponent(UIText, conclusion_path)
  self.receiveBtn = self:AddComponent(UIButton, receiveBtn_path)
  self.mainInfo = self:AddComponent(UIText, mainInfo_path)
  self.rewardContent = self:AddComponent(UIBaseContainer, rewardContent_path)
  self.rewarditem = self:AddComponent(UIBaseContainer, rewarditem_path)
  self.rewardheroitem = self:AddComponent(UIBaseContainer, rewardheroitem_path)
  self.senderName = self:AddComponent(UIText, senderName_path)
  self.closeBtn = self:AddComponent(UIButton, closeBtn_path)
  self.animatorCom = self:AddComponent(UIAnimator, animatorCom_path)
  self.btnDes = self:AddComponent(UIText, btnDes_path)
  self.rewarditem = self.transform:Find(rewarditem_path).gameObject
  self.rewarditem:GameObjectCreatePool()
  self.rewardheroitem = self.transform:Find(rewardheroitem_path).gameObject
  self.rewardheroitem:GameObjectCreatePool()
  self.openBtn:SetOnClick(function()
    self:OpenLetter()
  end)
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.receiveBtn:SetOnClick(function()
    self:ReceiveReward()
  end)
end

local function ComponentDestroy(self)
  self.envelope = nil
  self.letter = nil
  self.rewardTier = nil
  self.allianceName = nil
  self.openBtn = nil
  self.title = nil
  self.conclusion = nil
  self.receiveBtn = nil
  self.mainInfo = nil
  self.rewardContent = nil
  self.rewarditem = nil
  self.rewardheroitem = nil
  self.senderName = nil
  self.closeBtn = nil
  self.animatorCom = nil
  self.btnDes = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function UILWMailSeasonRewardView:Refresh()
  local title = self.mailData:GetMailTitle()
  local objData = self.mailData:GetMailSFSObj()
  local msg = self.mailData:GetMailMessage()
  local has_reward = self.mailData.rewardStatus == 0
  if has_reward then
    self.btnDes:SetLocalText("season_get_reward_desc01")
  else
    self.btnDes:SetLocalText("371068")
  end
  CS.UIGray.SetGray(self.receiveBtn.transform, not has_reward, has_reward)
  self.mainInfo:SetText(msg)
  local allianceName = UIUtil.FormatAllianceAndName(objData.allianceAbbr, objData.allianceName)
  self.allianceName:SetText(allianceName)
  self.senderName:SetText(objData.senderName)
  self.title:SetText(title)
  self.rewardTier:LoadSprite(DataCenter.SeasonRewardDataManager:GetAlliancerewardMailIconPathByConfigId(objData.seasonRewardConfigId))
  local count = self:ShowReward()
  self.rewardContent:SetActive(0 < count)
  if self.mailData.status ~= 1 then
    self.letter:SetActive(false)
    self.envelope:SetActive(true)
    self.animatorCom:Play("UILWMailSeasonRewardViewEnvelopeIn")
  else
    self.letter:SetActive(true)
    self.envelope:SetActive(false)
    self.animatorCom:Play("UILWMailSeasonRewardViewLetterIn")
  end
end

function UILWMailSeasonRewardView:RemoveReward()
  self.rewardContent:RemoveComponents(HeroRewardItem)
  self.rewardContent:RemoveComponents(UICommonResItem)
  self.rewarditem.gameObject:GameObjectRecycleAll()
  self.rewardheroitem.gameObject:GameObjectRecycleAll()
end

function UILWMailSeasonRewardView:ShowReward()
  local maildata = self.mailData
  self:RemoveReward()
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
  if maildata.type == MailType.COLLECT_OVER_FLOW_MAIL then
    local data = maildata:GetMailSFSObj()
    if data and data.resourceItem then
      for i = 1, table.count(data.resourceItem) do
        local param = {
          rewardType = RewardType.RESOURCE_ITEM,
          itemId = data.resourceItem[i].t,
          count = data.resourceItem[i].v
        }
        totalCnt = totalCnt + 1
        self:ShowRewardItem(param)
      end
    end
  end
  return totalCnt
end

local NameCount = 0

function UILWMailSeasonRewardView:ShowRewardItem(rewardData)
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

function UILWMailSeasonRewardView:OpenLetter()
  DataCenter.MailDataManager:ReadMail(self.mailData.uid)
  self.letter:SetActive(true)
  self.envelope:SetActive(false)
  self.animatorCom:Play("UILWMailSeasonRewardViewLetterIn")
end

function UILWMailSeasonRewardView:ReceiveReward()
  DataCenter.MailDataManager:SetAllAndOne(false)
  DataCenter.MailDataManager:RewardMail(self.mailData.uid)
  EventManager:GetInstance():Broadcast(EventId.OnClickReceiveOneMailReward)
end

function UILWMailSeasonRewardView:RefreshReceiveBtn()
  self.mailData = DataCenter.MailDataManager:GetMailInfoById(self.mailData.uid)
  local has_reward = self.mailData.rewardStatus == 0
  if has_reward then
    self.btnDes:SetLocalText("season_get_reward_desc01")
  else
    self.btnDes:SetLocalText("371068")
  end
  CS.UIGray.SetGray(self.receiveBtn.transform, not has_reward, has_reward)
end

function UILWMailSeasonRewardView:RewardSuccess()
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Common_GetReward, false)
  local pay = self.mailData:GetMailPay()
  if pay ~= nil and pay.gold > 0 then
    UIUtil.DoFly(RewardType.GOLD, 2, DataCenter.RewardManager:GetPicByType(RewardType.GOLD), self.rewardContent.transform:GetChild(0).gameObject.transform.position, Vector3.New(0, 0, 0), 100, 100)
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
      local child = self.rewardContent.transform:GetChild(i - 1)
      local img = child.gameObject.transform:Find("clickBtn/ItemIcon")
      local pic = DataCenter.RewardManager:GetPicByType(reward.rewardInfo[i].type, reward.rewardInfo[i].id)
      local flyPos = Vector3.New(0, 0, 0)
      UIUtil.DoFly(reward.rewardInfo[i].type, 2, pic, img.gameObject.transform.position, flyPos, 100, 100)
    end
  end
end

UILWMailSeasonRewardView.OnCreate = OnCreate
UILWMailSeasonRewardView.OnDestroy = OnDestroy
UILWMailSeasonRewardView.OnEnable = OnEnable
UILWMailSeasonRewardView.OnDisable = OnDisable
UILWMailSeasonRewardView.ComponentDefine = ComponentDefine
UILWMailSeasonRewardView.ComponentDestroy = ComponentDestroy
UILWMailSeasonRewardView.DataDefine = DataDefine
UILWMailSeasonRewardView.DataDestroy = DataDestroy
return UILWMailSeasonRewardView
