local AllianceGiftItem = BaseClass("AllianceGiftItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local RewardUtil = require("Util.RewardUtil")
local name_txt_path = "animatorObj/giftName"
local time_txt_path = "animatorObj/time"
local giftFrom_path = "animatorObj/from"
local rewardQuality_path = "animatorObj/UICommonResItem/clickBtn"
local rewardImg_path = "animatorObj/UICommonResItem/clickBtn/ImgQuality"
local rewardIcon_path = "animatorObj/UICommonResItem/clickBtn/ItemIcon"
local boxIcon_path = "animatorObj/boxIcon"
local get_btn_path = "animatorObj/getBtn"
local getBtnTxt_path = "animatorObj/getBtn/getTxt"
local del_btn_path = "animatorObj/delBtn"
local claimedTxt_path = "animatorObj/claimed"
local scoreNode_path = "animatorObj/score"
local scoreNum_path = "animatorObj/score/scoreNum"
local flagGo_path = "animatorObj/UICommonResItem/clickBtn/FlagGo"
local flagTxt_path = "animatorObj/UICommonResItem/clickBtn/FlagGo/FlagText"
local animObj_path = "animatorObj"
local itemCount_path = "animatorObj/UICommonResItem/clickBtn/NumText"
local scoreIcon_path = ""

local function OnCreate(self)
  base.OnCreate(self)
  self.giftName = self:AddComponent(UIText, name_txt_path)
  self.giftTime = self:AddComponent(UIText, time_txt_path)
  self.giftFrom = self:AddComponent(UIText, giftFrom_path)
  self.giftQuality = self:AddComponent(UIImage, rewardImg_path)
  self.giftBtn = self:AddComponent(UIButton, rewardQuality_path)
  self.giftBtn:SetOnClick(function()
    self:OnClickShowTip()
  end)
  self.giftIcon = self:AddComponent(UIImage, rewardIcon_path)
  self.boxIcon = self:AddComponent(UIImage, boxIcon_path)
  self.getBtn = self:AddComponent(UIButton, get_btn_path)
  self.getBtn:SetOnClick(function()
    self:OnGetClick()
  end)
  self.getBtnTxt = self:AddComponent(UIText, getBtnTxt_path)
  self.getBtnTxt:SetLocalText(170004)
  self.claimedTxt = self:AddComponent(UIText, claimedTxt_path)
  self.claimedTxt:SetLocalText(170003)
  self.scoreNode = self:AddComponent(UIBaseContainer, scoreNode_path)
  self.scoreNum = self:AddComponent(UIText, scoreNum_path)
  self.flagGo = self:AddComponent(UIBaseContainer, flagGo_path)
  self.flagTxt = self:AddComponent(UIText, flagTxt_path)
  self.animatorObj = self:AddComponent(UIBaseContainer, animObj_path)
  self.itemCount = self:AddComponent(UIText, itemCount_path)
  self.del_btn = self:AddComponent(UIButton, del_btn_path)
  self.del_btn:SetOnClick(function()
    self:OnDelClick()
  end)
  self.del_btn:SetActive(false)
  self.isUpdate = false
end

local function OnDestroy(self)
  self.giftName = nil
  self.giftTime = nil
  self.giftFrom = nil
  self.giftQuality = nil
  self.giftIcon = nil
  self.boxIcon = nil
  self.getBtn = nil
  self.getBtnTxt = nil
  self.claimedTxt = nil
  self.del_btn = nil
  self.scoreNode = nil
  self.scoreNum = nil
  base.OnDestroy(self)
end

local function RefreshData(self, data)
  self.lastChangeTextDeltaTime = 0
  self.isUpdate = false
  self.data = data
  self.boxIcon:LoadSprite(string.format(LoadPath.UIAllianceGift, self.data.icon))
  self.giftName:SetText(self.data.name)
  local tempId
  if self.data.reward and 0 < #self.data.reward then
    tempId = self.data.reward[1].value.id
  end
  if tempId then
    self.giftIcon:LoadSprite(DataCenter.ItemTemplateManager:GetIconPath(tempId))
    local goods = DataCenter.ItemTemplateManager:GetItemTemplate(tempId)
    local quality_name = DataCenter.ItemTemplateManager:GetToolBgByColor(goods.color)
    self.giftQuality:LoadSprite(quality_name)
    local flagtxt = ""
    if goods.type == 2 then
      if goods.para1 ~= nil and goods.para1 ~= "" then
        local para1 = goods.para1
        local temp = string.split(para1, ";")
        if temp ~= nil and 1 < #temp then
          flagtxt = temp[1] .. temp[2]
        end
      end
    elseif goods.type == 3 then
      local type2 = goods.type2
      if type2 ~= 999 and goods.para ~= nil and goods.para ~= "" then
        local res_num = tonumber(goods.para)
        flagtxt = string.GetFormattedStr(res_num)
      end
    end
    if not flagtxt or flagtxt == "" then
      self.flagGo:SetActive(false)
    else
      self.flagGo:SetActive(true)
      self.flagTxt:SetText(flagtxt)
    end
  end
  local fromPackage = self.data.fromPackage
  if fromPackage then
    Logger.Log("from pkg")
    self.giftFrom:SetText(Localization:GetString("390842", self.data.userName, Localization:GetString(fromPackage)))
  else
    self.giftFrom:SetText(Localization:GetString("391074", self.data.userName))
  end
  self:UpdateTime(self)
end

local function UpdateTime(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local deltaTime = 0
  if curTime < self.data.endTime and self.data.receiveState ~= 1 then
    self.isUpdate = true
    deltaTime = self.data.endTime - curTime
  else
    self.isUpdate = false
  end
  if self.isUpdate then
    self.boxIcon:SetActive(true)
    UIGray.SetGray(self.boxIcon.transform, false, false)
    self.giftBtn:SetActive(false)
    self.scoreNode:SetActive(false)
    self.giftTime:SetActive(true)
    self.getBtn:SetActive(true)
    self.claimedTxt:SetActive(false)
    if TimeBarUtil.CheckIsNeedChangeText(deltaTime, self.lastChangeTextDeltaTime) then
      self.lastChangeTextDeltaTime = deltaTime
      self.giftTime:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime))
    end
  else
    self.lastChangeTextDeltaTime = 0
    if self.data.receiveState == 1 then
      self.boxIcon:SetActive(false)
      self.giftBtn:SetActive(true)
      self.scoreNode:SetActive(true)
      self.giftTime:SetActive(false)
      self.claimedTxt:SetActive(true)
      self.getBtn:SetActive(false)
      local eachExpNum = self.data.eachExp and self.data.eachExp or 0
      local keyExpNum = self.data.keyExp and self.data.keyExp or 0
      self.scoreNum:SetText(eachExpNum + keyExpNum)
      if self.data.reward and 0 < #self.data.reward and self.data.reward[1].value then
        self.itemCount:SetText(self.data.reward[1].value.num)
      else
        self.itemCount:SetText("")
      end
    else
      self.scoreNode:SetActive(false)
      self.boxIcon:SetActive(true)
      UIGray.SetGray(self.boxIcon.transform, true, false)
      self.giftBtn:SetActive(false)
      self.scoreNode:SetActive(false)
      self.giftTime:SetActive(true)
      self.giftTime:SetLocalText(390843)
      self.getBtn:SetActive(false)
      self.claimedTxt:SetActive(false)
    end
  end
end

local function Update(self)
  if self.isUpdate then
    self:UpdateTime(self)
  end
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnBgClick(self)
  self.view.ctrl:OnOpenClick(self.data.uuid)
end

local function OnGetClick(self)
  if self.view:OnGetClick(self.data.uuid) then
    if self.data.reward and #self.data.reward > 0 then
      local tempType = self.data.reward[1].type
      local tempId = self.data.reward[1].value.id
      local pic = RewardUtil.GetPic(tempType, tempId)
      UIUtil.DoFly(tonumber(tempType), 5, pic, self.boxIcon.transform.position, Vector3.New(0, 0, 0))
      local targetPos = self.view.scoreFlyTarget.transform.position
      local scorePic = "Assets/Main/Sprites/UI/UIAllianceGift/UIAllianceGift_iconBox_exp.png"
      UIUtil.DoFly(tonumber(tempType), 5, scorePic, self.scoreNode.transform.position, targetPos, 40, 40)
      self.data.receiveState = 1
    end
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Common_GetReward, false)
  end
end

local function PlayShowAnimation(self, state)
  if state == 1 then
    DOTween.Play(self.animatorObj.gameObject, "Dissolve")
  elseif state == 2 then
    DOTween.Play(self.animatorObj.gameObject, "Move")
  elseif state == 3 then
    DOTween.Play(self.animatorObj.gameObject, "Hide")
  elseif state == 4 then
    DOTween.Play(self.animatorObj.gameObject, "show")
  elseif state == 5 then
    DOTween.Rewind(self.animatorObj.gameObject)
  end
end

local function OnDelClick(self)
  self.view.ctrl:OnRemoveClick(self.data.uuid)
end

local function OnClickShowTip(self)
  local param = {}
  if self.data.reward and #self.data.reward > 0 then
    local tempId = self.data.reward[1].value.id
    local param = {}
    param.itemId = tempId
    param.alignObject = self.giftQuality
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
  end
end

AllianceGiftItem.OnCreate = OnCreate
AllianceGiftItem.OnDestroy = OnDestroy
AllianceGiftItem.OnEnable = OnEnable
AllianceGiftItem.OnDisable = OnDisable
AllianceGiftItem.RefreshData = RefreshData
AllianceGiftItem.UpdateTime = UpdateTime
AllianceGiftItem.Update = Update
AllianceGiftItem.OnBgClick = OnBgClick
AllianceGiftItem.OnGetClick = OnGetClick
AllianceGiftItem.OnDelClick = OnDelClick
AllianceGiftItem.OnClickShowTip = OnClickShowTip
AllianceGiftItem.PlayShowAnimation = PlayShowAnimation
return AllianceGiftItem
