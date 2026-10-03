local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local UICitySkinGet = BaseClass("UICitySkinGet", base)
local Localization = CS.GameEntry.Localization
local EffectDesc = require("UI.UIDecoration.UIDecorationMain.Component.EffectDesc")
local UIGiftPackagePoint = require("UI.UIGiftPackage.Component.UIGiftPackagePoint")
local titleTextPath = "RightView/Top/title"
local remainTimeTextPath = "RightView/Top/RemainTimeContent/RemainTimeText"
local infoBtnPath = "RightView/Top/InfoBtn"
local surelyGetRewardsPath = "RightView/Rect_Bottom/SurelyGet/SurelyGetRewards/SurelyGetRewardsViewport/SurelyGetRewardsContent"
local randomlyGetRewardsPath = "RightView/Rect_Bottom/RandomlyGet/RandomlyGetRewards/RandomlyGetRewardsViewport/RandomlyGetRewardsContent"
local packsBtnPath = "RightView/Rect_Bottom/Packs/BuyBtn%d"
local packsBtnPriceTextPath = "RightView/Rect_Bottom/Packs/BuyBtn%d/Txt_Cost%d"
local packsBtnGiftPackagePointPath = "RightView/Rect_Bottom/Packs/BuyBtn%d/UIGiftPackagePoint%d"
local packsBtnRewardTimesTextPath = "RightView/Rect_Bottom/Packs/BuyBtn%d/Txt_RewardTimes%d"
local previewBtnPath = "RightView/Top/PreviewBtn"
local skillEffectPath = "RightView/Top/SkinEffect"
local useEffectTextPath = "RightView/Top/SkinEffect/UsingEffect/UseEffectText"
local ownEffectTextPath = "RightView/Top/SkinEffect/OwnEffect/OwnEffectText"
local surelyGetItemTemplatePath = "RightView/Rect_Bottom/UICommonResItem"

function UICitySkinGet:OnCreate()
  base.OnCreate(self)
  
  function self.timer_action()
    self:RefreshTime()
  end
  
  self:ComponentDefine()
end

function UICitySkinGet:OnPacksBtnClick(index)
  if not self.packages then
    return
  end
  local pack = self.packages[index]
  if pack then
    DataCenter.PayManager:BuyGift(pack)
  end
end

function UICitySkinGet:ComponentDefine()
  self.titleText = self:AddComponent(UIText, titleTextPath)
  self.remainText = self:AddComponent(UIText, remainTimeTextPath)
  self.infoBtn = self:AddComponent(UIButton, infoBtnPath)
  self.infoBtn:SetOnClick(function()
    if not self.activityId then
      return
    end
    local activityData = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
    if activityData == nil then
      return
    end
    local param = {}
    param.activityRulesStr = Localization:GetString(activityData.story)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetail, {anim = true}, param)
  end)
  self.surelyGetRewards = self:AddComponent(UIBaseContainer, surelyGetRewardsPath)
  self.randomGetRewards = self:AddComponent(UIBaseContainer, randomlyGetRewardsPath)
  self.packsBtn = {}
  self.packsBtnPriceText = {}
  self.packsBtnGiftPackagePoint = {}
  self.packsBtnRewardTimesText = {}
  for i = 1, 3 do
    self.packsBtn[i] = self:AddComponent(UIButton, string.format(packsBtnPath, i))
    self.packsBtn[i]:SetOnClick(function()
      self:OnPacksBtnClick(i)
    end)
    self.packsBtnPriceText[i] = self:AddComponent(UIText, string.format(packsBtnPriceTextPath, i, i))
    self.packsBtnGiftPackagePoint[i] = self:AddComponent(UIGiftPackagePoint, string.format(packsBtnGiftPackagePointPath, i, i))
    self.packsBtnRewardTimesText[i] = self:AddComponent(UIText, string.format(packsBtnRewardTimesTextPath, i, i))
  end
  self.previewBtn = self:AddComponent(UIButton, previewBtnPath)
  self.previewBtn:SetOnClick(function()
    if self.actBaseData then
      local jumpTo = tonumber(self.actBaseData.para_5)
      EventManager:GetInstance():Broadcast(EventId.UIDecorationMainViewOpen)
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIDecorationMain, {anim = true}, DecorationType_Main_City, tonumber(jumpTo))
    end
  end)
  self.skillEffect = self:AddComponent(UIBaseContainer, skillEffectPath)
  self.useEffectText = self:AddComponent(UIText, useEffectTextPath)
  self.ownEffectText = self:AddComponent(UIText, ownEffectTextPath)
  self.surelyGetItemTemplate = self:AddComponent(UIBaseContainer, surelyGetItemTemplatePath)
  self.surelyGetItemTemplate.gameObject:SetActive(false)
  self.surelyGetItemTemplate.gameObject:GameObjectCreatePool()
end

function UICitySkinGet:OnDestroy()
  self:DeleteTimer()
  self:ClearRewards()
  self:ComponentDestroy()
  self.timer_action = nil
  base.OnDestroy(self)
end

function UICitySkinGet:ComponentDestroy()
  self.titleText = nil
  self.remainText = nil
  self.infoBtn = nil
  self.skillEffect = nil
  self.surelyGetRewards = nil
  self.randomGetRewards = nil
  self.packsBtn = nil
  self.packsBtnPriceText = nil
  self.packsBtnGiftPackagePoint = nil
  self.packsBtnRewardTimesText = nil
  self.previewBtn = nil
  self.skillEffect = nil
  self.useEffectText = nil
  self.ownEffectText = nil
end

function UICitySkinGet:OnEnable()
  base.OnEnable(self)
end

function UICitySkinGet:OnDisable()
  base.OnDisable(self)
end

function UICitySkinGet:OnGetData(rechargeId)
  if not rechargeId then
    return
  end
end

function UICitySkinGet:OnUpdateGiftPackage()
  self:RefreshGiftPackages()
end

function UICitySkinGet:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.UpdateGiftPackData, self.OnUpdateGiftPackage)
end

function UICitySkinGet:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.UpdateGiftPackData, self.OnUpdateGiftPackage)
end

function UICitySkinGet:RefreshRewardList()
  if not self.actInfo then
    return
  end
end

function UICitySkinGet:Refresh()
  self:RefreshRewardList(true)
  self:RefreshScore()
end

function UICitySkinGet:DeleteTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function UICitySkinGet:AddTimer()
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, nil, false, false, false)
    self.timer:Start()
  end
end

function UICitySkinGet:RefreshTime()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.actBaseData then
    if curTime > self.actBaseData.endTime then
      self:DeleteTimer()
      self.remainText:SetLocalText(2000409)
    else
      self.remainText:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(self.actBaseData.endTime - curTime))
    end
  else
    self:DeleteTimer()
    self.remainText:SetText("")
  end
end

function UICitySkinGet:RefreshSkinEffect()
  if not self.actBaseData then
    return
  end
  local jumpTo = tonumber(self.actBaseData.para_5)
  if jumpTo and 0 < jumpTo then
    self.skillEffect:SetActive(true)
    local effects = DecorationUtil.GetEffectDesc(jumpTo)
    local ownEffectStr = effects.ownEffect
    ownEffectStr = string.gsub(ownEffectStr, "94e138", "2EE769")
    self.ownEffectText:SetText(ownEffectStr)
    local useEffectStr = effects.useEffect
    useEffectStr = string.gsub(useEffectStr, "94e138", "2EE769")
    self.useEffectText:SetText(useEffectStr)
  else
    self.skillEffect:SetActive(false)
  end
end

function UICitySkinGet:RefreshGiftPackages()
  if not self.actBaseData then
    return
  end
  local idsStr = ""
  if self.actBaseData.para then
    idsStr = self.actBaseData.para
  end
  local giftPackIds = string.split(idsStr, "|")
  local packs = {}
  local packsRewardTimes = {}
  for _, id in pairs(giftPackIds) do
    local ids = string.split(id, ";")
    if 1 <= #ids then
      local giftPackId = tonumber(ids[1])
      local gift = GiftPackageData.get(tostring(giftPackId))
      if gift then
        table.insert(packs, gift)
        if 4 <= #ids then
          table.insert(packsRewardTimes, tonumber(ids[4]))
        else
          table.insert(packsRewardTimes, 0)
        end
      end
    end
  end
  for i = 1, 3 do
    if packs[i] then
      self.packsBtn[i]:SetActive(true)
      self.packsBtnPriceText[i]:SetText(packs[i]:getPriceText())
      self.packsBtnGiftPackagePoint[i]:RefreshPoint(packs[i])
      self.packsBtnRewardTimesText[i]:SetLocalText(2000839, packsRewardTimes[i] or 0)
    else
      self.packsBtn[i]:SetActive(false)
    end
  end
  self.packages = packs
end

function UICitySkinGet:ClearRewards()
  if self.surelyGetRewards then
    self.surelyGetRewards:RemoveComponents(UICommonResItem)
  end
  if self.surelyGetItemTemplate and not IsNull(self.surelyGetItemTemplate.gameObject) then
    self.surelyGetItemTemplate.gameObject:GameObjectRecycleAll()
  end
  self.surelyGetItemObjs = {}
  if self.randomGetRewards then
    self.randomGetRewards:RemoveComponents(UICommonResItem)
  end
  if not table.IsNullOrEmpty(self.randomReqList) then
    for i = 1, #self.randomReqList do
      self.randomReqList[i]:Destroy()
    end
  end
  self.randomReqList = {}
end

function UICitySkinGet:RefreshRewards()
  if not self.actDetailInfo then
    return
  end
  self:ClearRewards()
  local surelyReward = self.actDetailInfo.surelyReward
  for i = 1, 1 do
    local obj = self.surelyGetItemTemplate.gameObject:GameObjectSpawn(self.surelyGetRewards.transform)
    local go = obj
    go.transform:SetParent(self.surelyGetRewards.transform)
    go.transform:Set_localScale(1.02, 1.08, 1)
    go.transform:Set_sizeDelta(118, 127)
    go.transform:Set_pivot(0.5, 0.5)
    go.name = "item" .. i
    local cell = self.surelyGetRewards:AddComponent(UICommonResItem, go.name)
    local showData = {}
    showData.rewardType = RewardType.GOODS
    showData.itemId = tonumber(surelyReward.itemId)
    showData.count = 1
    cell:ReInit(showData)
    if cell.num_text then
      cell.num_text:SetText(string.format("%s-%s", surelyReward.minNum, surelyReward.maxNum))
    end
    self.surelyGetItemObjs[i] = cell
  end
  local randomReward = self.actDetailInfo.randomReward
  for i = 1, #randomReward do
    self.randomReqList[i] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go.transform:SetParent(self.randomGetRewards.transform)
      go.transform:Set_localScale(1.02, 1.08, 1)
      go.transform:Set_sizeDelta(118, 127)
      go.transform:Set_pivot(0.5, 0.5)
      go.name = "item" .. i
      local cell = self.randomGetRewards:AddComponent(UICommonResItem, go.name)
      cell:ReInit(randomReward[i])
    end)
  end
end

function UICitySkinGet:SetData(activityId)
  base.SetData(self, activityId)
  self.activityId = activityId
  if not self.activityId then
    return
  end
  self.actBaseData = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if self.actBaseData then
    self.titleText:SetLocalText(self.actBaseData.name)
  end
  self.actDetailInfo = DataCenter.ActCitySkinDataManager:GetActCitySkinGetInfo(self.activityId)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.actBaseData then
    if curTime > self.actBaseData.endTime then
      self.remainText:SetLocalText(2000409)
    else
      self:AddTimer()
    end
  else
    self.remainText:SetText("")
  end
  self:RefreshSkinEffect()
  self:RefreshGiftPackages()
  self:RefreshRewards()
end

return UICitySkinGet
