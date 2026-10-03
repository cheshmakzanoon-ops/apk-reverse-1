local base = UIBaseContainer
local UILWMailDetailLandlordWeekResult = BaseClass("UILWMailDetailLandlordWeekResult", UIBaseContainer)
local UILWMailDetailLandlordBuffItem = require("UI.UILWMail.UILWMailMain.Component.MailLandlord.UILWMailDetailLandlordBuffItem")
local UILWMailDetailLandlordCityItem = require("UI.UILWMail.UILWMailMain.Component.MailLandlord.UILWMailDetailLandlordCityItem")
local MailRewardCommonItem = require("UI.UILWMail.UILWMailMain.Component.MailRewardCommonItem")
local rapidjson = require("rapidjson")
local LLMailResultData = require("DataCenter.Landlord.Data.LLMailResultData")
local Localization = CS.GameEntry.Localization
local BUFF_ITEM_PREFAB_PATH = "Assets/Main/Prefabs/UI/LWMail/Landlord/MailBuffItem.prefab"
local CITY_ITEM_PREFAB_PATH = "Assets/Main/Prefabs/UI/LWMail/Landlord/MailCityItem.prefab"

function UILWMailDetailLandlordWeekResult:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWMailDetailLandlordWeekResult:OnDestroy()
  self:ClearBuffList()
  self:ClearBuildingList()
  self:ClearRewardsList()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWMailDetailLandlordWeekResult:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textDetailTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.textWeekTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.compBuffScroll = self.viewSkin:AddComponent(self, UIBaseContainer, 3)
  self.compBuffContent = self.viewSkin:AddComponent(self, UIBaseContainer, 4)
  self.compProgressContent = self.viewSkin:AddComponent(self, UIBaseContainer, 5)
  self.slider = self.viewSkin:AddComponent(self, UISlider, 6)
  self.textProgressTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.compCityContent = self.viewSkin:AddComponent(self, UIBaseContainer, 8)
  self.textRewardTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.compRewardContent = self.viewSkin:AddComponent(self, UIBaseContainer, 10)
  self.textDetailTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 11)
  self.textCityEmpty = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 12)
  self.textCityTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 13)
  self.imgIcon = self.viewSkin:AddComponent(self, UIImage, 14)
  self.imgFill = self.viewSkin:AddComponent(self, UIImage, 15)
end

function UILWMailDetailLandlordWeekResult:ComponentDestroy()
  self.viewSkin = nil
  self.textDetailTitle = nil
  self.textWeekTitle = nil
  self.compBuffScroll = nil
  self.compBuffContent = nil
  self.compProgressContent = nil
  self.slider = nil
  self.textProgressTxt = nil
  self.compCityContent = nil
  self.textRewardTitle = nil
  self.compRewardContent = nil
  self.textDetailTime = nil
  self.textCityEmpty = nil
  self.textCityTitle = nil
  self.imgIcon = nil
  self.imgFill = nil
end

function UILWMailDetailLandlordWeekResult:DataDefine()
  self.buffReqList = {}
  self.cityReqList = {}
  self.rewardReqList = {}
  self.buffCompList = {}
  self.buildingCompList = {}
  self.rewardCompList = {}
end

function UILWMailDetailLandlordWeekResult:DataDestroy()
  self.buffReqList = nil
  self.cityReqList = nil
  self.rewardReqList = nil
  self.buffCompList = nil
  self.buildingCompList = nil
  self.rewardCompList = nil
end

function UILWMailDetailLandlordWeekResult:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ReadOneMailRespond, self.RewardSuccess)
end

function UILWMailDetailLandlordWeekResult:OnRemoveListener()
  self:RemoveUIListener(EventId.ReadOneMailRespond, self.RewardSuccess)
  base.OnRemoveListener(self)
end

function UILWMailDetailLandlordWeekResult:OnBtnBuffDetailClick()
end

function UILWMailDetailLandlordWeekResult:RewardSuccess()
  DataCenter.LWSoundManager:PlayEffect(SoundAssets.Music_Effect_Common_GetReward)
  local pay = self.mailData:GetMailPay()
  if pay ~= nil then
    local goldCnt = pay.gold or 0
    if 0 < goldCnt then
      UIUtil.DoFly(RewardType.GOLD, 2, DataCenter.RewardManager:GetPicByType(RewardType.GOLD), self.compRewardContent.transform.position, Vector3.New(0, 0, 0), 100, 100)
    end
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
      local pic = DataCenter.RewardManager:GetPicByType(reward.rewardInfo[i].type, reward.rewardInfo[i].id)
      local flyPos = Vector3.New(0, 0, 0)
      UIUtil.DoFly(reward.rewardInfo[i].type, 2, pic, self.compRewardContent.transform.position, flyPos, 100, 100)
    end
  end
  self:RefreshContent()
end

function UILWMailDetailLandlordWeekResult:RefreshContent()
  self.mailUid = self.view.ctrl:GetCurrentMail()
  self.mailData = self.view.ctrl:GetCurrentMailData()
  local _strTitle = MailShowHelper.GetMainTitle(self.mailData)
  self.textDetailTitle:SetText(_strTitle)
  local _strCreateTime = MailShowHelper.GetAbstractCreateTime(self.mailData)
  self.textDetailTime:SetText(_strCreateTime)
  local msg = rapidjson.decode(self.mailData.contents)
  self.data = LLMailResultData.New()
  self.data:ParseData(msg.obj)
  self:ParseReward()
  self:RefreshView()
end

function UILWMailDetailLandlordWeekResult:ParseReward()
  local pay = self.mailData:GetMailPay()
  local reward = self.mailData:GetMailReward()
  self.rewardList = {}
  if pay ~= nil then
    local goldCnt = pay.gold or 0
    if 0 < goldCnt then
      table.insert(self.rewardList, {
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
        table.insert(self.rewardList, param)
      else
        local itemId = iteminfo.id
        local itemCnt = iteminfo.num
        local param = {
          rewardType = iteminfo.type,
          itemId = itemId,
          count = itemCnt
        }
        table.insert(self.rewardList, param)
      end
    end
  end
end

function UILWMailDetailLandlordWeekResult:RefreshView()
  local isFarmer = self.data.camp == LLConst.LandLordGroup.FARMER
  local isLord = self.data.camp == LLConst.LandLordGroup.LORD
  self.compBuffScroll:SetActive(false)
  self.textCityEmpty:SetLocalText(isLord and "zonewar_landlord_desc_1033" or "zonewar_landlord_desc_1032")
  local rate = self.data.maxDestroyScore == 0 and 0 or self.data.destroyScore / self.data.maxDestroyScore
  self.slider:SetValue(rate)
  local str
  if not self.data.beforeDestroyScore or self.data.beforeDestroyScore == 0 then
    str = tostring(self.data.destroyScore or 0)
  else
    str = string.format("%s+%s", self.data.beforeDestroyScore, (self.data.destroyScore or 0) - self.data.beforeDestroyScore)
  end
  self.textProgressTxt:SetLocalText("zonewar_landlord_limit_1081", str)
  self.imgIcon:LoadSpriteAsync(isLord and string.format(LoadPath.LandlordPath, "lrb_jinmai_beizhan_pocheng_hong.png") or string.format(LoadPath.LandlordPath, "lrb_jinmai_beizhan_pocheng_lan.png"))
  self.imgFill:LoadSpriteAsync(isLord and "Assets/Main/Sprites/UI/LWCommon/Sprite/lyp_youujian_jindutiao_3.png" or "Assets/Main/Sprites/UI/LWCommon/Sprite/lyp_tongyong_jindutiao_lan.png")
  self.textWeekTitle:SetLocalText("zonewar_landlord_limit_1073", self.data.weekNum + 1)
  self.textRewardTitle:SetLocalText("zonewar_landlord_limit_1074")
  self.textCityTitle:SetLocalText(isLord and "zonewar_landlord_limit_1083" or "zonewar_landlord_limit_1082")
  self:RefreshBuildingList()
  self:RefreshRewardsList()
end

function UILWMailDetailLandlordWeekResult:ClearBuffList()
  self.compBuffContent:RemoveComponents(UILWMailDetailLandlordBuffItem)
  self.buffCompList = {}
  if self.buffReqList ~= nil then
    for k, v in pairs(self.buffReqList) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.buffReqList = {}
end

function UILWMailDetailLandlordWeekResult:RefreshBuffList()
  for i = 1, #self.data.buffList do
    if self.buffCompList[i] then
      self.buffCompList[i]:SetActive(true)
      self.buffCompList[i]:ReInit(self.data.buffList[i])
    elseif self.buffReqList[i] == nil then
      local idx = i
      local data = self.data.buffList[i]
      self.buffReqList[i] = self:GameObjectInstantiateAsync(BUFF_ITEM_PREFAB_PATH, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.transform:SetParent(self.compBuffContent.transform)
        go.transform:Set_localScale(1, 1, 1)
        go.transform:Set_localPosition(0, 0, 0)
        go.transform:Set_pivot(0.5, 0.5)
        go.name = "buffItem" .. idx
        local cell = self.compBuffContent:AddComponent(UILWMailDetailLandlordBuffItem, go.name)
        go.gameObject:SetActive(true)
        cell:ReInit(data)
        self.buffCompList[idx] = cell
      end)
    end
  end
  for i = #self.data.buffList + 1, #self.buffCompList do
    self.buffCompList[i]:SetActive(false)
  end
end

function UILWMailDetailLandlordWeekResult:ClearBuildingList()
  self.compCityContent:RemoveComponents(UILWMailDetailLandlordCityItem)
  self.buildingCompList = {}
  if self.cityReqList ~= nil then
    for k, v in pairs(self.cityReqList) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.cityReqList = {}
end

function UILWMailDetailLandlordWeekResult:RefreshBuildingList()
  local buildingArr = self.data.buildingsList
  for i = 1, #buildingArr do
    local data = buildingArr[i]
    if self.buildingCompList[i] then
      self.buildingCompList[i]:SetActive(true)
      self.buildingCompList[i]:ReInit(data)
    elseif self.cityReqList[i] == nil then
      do
        local idx = i
        self.cityReqList[i] = self:GameObjectInstantiateAsync(CITY_ITEM_PREFAB_PATH, function(request)
          if request.isError then
            return
          end
          local go = request.gameObject
          go.transform:SetParent(self.compCityContent.transform)
          go.transform:Set_localScale(1, 1, 1)
          go.transform:Set_localPosition(0, 0, 0)
          go.transform:Set_pivot(0.5, 0.5)
          go.name = "buildingItem" .. idx
          local cell = self.compCityContent:AddComponent(UILWMailDetailLandlordCityItem, go.name)
          go.gameObject:SetActive(true)
          cell:ReInit(data)
          self.buildingCompList[idx] = cell
        end)
      end
    end
  end
  for i = #buildingArr + 1, #self.buildingCompList do
    self.buildingCompList[i]:SetActive(false)
  end
  self.compCityContent:SetActive(0 < #buildingArr)
  self.textCityEmpty:SetActive(#buildingArr == 0)
end

function UILWMailDetailLandlordWeekResult:ClearRewardsList()
  self.compRewardContent:RemoveComponents(MailRewardCommonItem)
  self.rewardCompList = {}
  if self.rewardReqList ~= nil then
    for k, v in pairs(self.rewardReqList) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.rewardReqList = {}
end

function UILWMailDetailLandlordWeekResult:RefreshRewardsList()
  local hasReward = self.mailData and self.mailData.rewardStatus == 1 or false
  for i = 1, #self.rewardList do
    local data = self.rewardList[i]
    if self.rewardCompList[i] then
      self.rewardCompList[i]:SetActive(true)
      self.rewardCompList[i]:ReInit(data, hasReward)
    elseif self.rewardReqList[i] == nil then
      do
        local idx = i
        self.rewardReqList[i] = self:GameObjectInstantiateAsync(UIAssets.MailRewardCommonItem, function(request)
          if request.isError then
            return
          end
          local go = request.gameObject
          go.transform:SetParent(self.compRewardContent.transform)
          go.transform:Set_localScale(1, 1, 1)
          go.transform:Set_localPosition(0, 0, 0)
          go.transform:Set_pivot(0.5, 0.5)
          go.name = "rewardItem" .. idx
          local cell = self.compRewardContent:AddComponent(MailRewardCommonItem, go.name)
          go.gameObject:SetActive(true)
          cell:ReInit(data, hasReward)
          self.rewardCompList[idx] = cell
        end)
      end
    end
  end
  for i = #self.rewardList + 1, #self.rewardCompList do
    self.rewardCompList[i]:SetActive(false)
  end
end

return UILWMailDetailLandlordWeekResult
