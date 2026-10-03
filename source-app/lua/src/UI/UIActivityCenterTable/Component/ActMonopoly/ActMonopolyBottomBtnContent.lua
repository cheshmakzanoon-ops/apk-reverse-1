local ActMonopolyBottomBtnContent = BaseClass("ActMonopolyBottomBtnContent", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local btn_recruit1_path = "bottomContent/BtnRecruit1"
local cost_item1_path = "bottomContent/BtnRecruit1/CostItem1Content/CostItem1_"
local free_recruit_text1_path = "bottomContent/BtnRecruit1/FreeRecruitText1"
local btn_recruit2_path = "bottomContent/BtnRecruit2"
local cost_item2_path = "bottomContent/BtnRecruit2/CostItem2Content/CostItem2_"
local free_recruit_text2_path = "bottomContent/BtnRecruit2/FreeRecruitText2"
local cost_item1_content_path = "bottomContent/BtnRecruit1/CostItem1Content"
local cost_item2_content_path = "bottomContent/BtnRecruit2/CostItem2Content"
local bottom_content_path = "bottomContent"
local eff_ui_s_dafuwen_anniuliuguang_01_path = "bottomContent/BtnRecruit1/Eff_ui_s_dafuwen_anniuliuguang_01"
local eff_ui_s_dafuwen_anniuliuguang_02_path = "bottomContent/BtnRecruit2/Eff_ui_s_dafuwen_anniuliuguang_02"
local costNum = 2
local freeImg = "tongyong_cfm_anniu_1"
local costImg = "tongyong_cfm_anniu_3"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.btn_recruit1 = self:AddComponent(UIButton, btn_recruit1_path)
  self.btn_recruit1_img = self:AddComponent(UIImage, btn_recruit1_path)
  self.free_recruit_text1 = self:AddComponent(UIText, free_recruit_text1_path)
  self.btn_recruit2 = self:AddComponent(UIButton, btn_recruit2_path)
  self.btn_recruit2_img = self:AddComponent(UIImage, btn_recruit2_path)
  self.free_recruit_text2 = self:AddComponent(UIText, free_recruit_text2_path)
  self.cost_item1_content = self:AddComponent(UIBaseContainer, cost_item1_content_path)
  self.cost_item2_content = self:AddComponent(UIBaseContainer, cost_item2_content_path)
  self.recruitBtn1CostItems = {}
  for i = 1, costNum do
    local costRoot = self:AddComponent(UIBaseContainer, cost_item1_path .. i)
    self.recruitBtn1CostItems[i] = {
      costRoot = costRoot,
      costImg = costRoot:AddComponent(UIImage, "CostImg"),
      costNum = costRoot:AddComponent(UITextMeshProUGUIEx, "CostNum")
    }
  end
  self.recruitBtn2CostItems = {}
  for i = 1, costNum do
    local costRoot = self:AddComponent(UIBaseContainer, cost_item2_path .. i)
    self.recruitBtn2CostItems[i] = {
      costRoot = costRoot,
      costImg = costRoot:AddComponent(UIImage, "CostImg"),
      costNum = costRoot:AddComponent(UITextMeshProUGUIEx, "CostNum")
    }
  end
  self.btn_recruit1:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:ClickBtnRecruit1()
  end)
  self.btn_recruit2:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:ClickBtnRecruit2()
  end)
  self.bottom_content = self:AddComponent(UIAnimator, bottom_content_path)
  self.eff_ui_s_dafuwen_anniuliuguang_01 = self:AddComponent(UIBaseContainer, eff_ui_s_dafuwen_anniuliuguang_01_path)
  self.eff_ui_s_dafuwen_anniuliuguang_02 = self:AddComponent(UIBaseContainer, eff_ui_s_dafuwen_anniuliuguang_02_path)
  self.bottom_content:Enable(false)
  self.eff_ui_s_dafuwen_anniuliuguang_01:SetActive(false)
  self.eff_ui_s_dafuwen_anniuliuguang_02:SetActive(false)
end

local function ComponentDestroy(self)
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function SetData(self, mainView, activityId, activityInfo, activityDetailData, costData, isBoss)
  self.mainView = mainView
  self.activityId = activityId
  self.activityInfo = activityInfo
  self.activityDetailData = activityDetailData
  self.costData = costData
  self.isBoss = isBoss
  self:RefreshView()
end

local function RefreshView(self)
  local detailData = self.activityDetailData
  if detailData == nil then
    return
  end
  local freeNormalDice = detailData.freeNormalDice
  local freeHighDice = detailData.freeHighDice
  self.btn_recruit1_img:LoadSprite(string.format(LoadPath.LWCommonPath, 0 < freeNormalDice and freeImg or costImg))
  if 0 < freeNormalDice then
    self.free_recruit_text1:SetActive(true)
    self.cost_item1_content:SetActive(false)
  else
    self.free_recruit_text1:SetActive(false)
    self.cost_item1_content:SetActive(true)
    if self.costData[1] then
      for i = 1, costNum do
        local costData = self.costData[1][i]
        if costData then
          self.recruitBtn1CostItems[i].costRoot:SetActive(true)
          local costId = costData.itemId
          local iconPath = DataCenter.RewardManager:GetPicByType(costData.type, costData.itemId)
          self.recruitBtn1CostItems[i].costImg:LoadSprite(iconPath)
          local curNum = self:GetCurCostNumByData(costData.type, costData.itemId)
          local needNum = costData.count
          local numStr = curNum >= needNum and needNum or string.format("<color=#dd2828> %s</color>", needNum)
          self.recruitBtn1CostItems[i].costNum:SetText(numStr)
        else
          self.recruitBtn1CostItems[i].costRoot:SetActive(false)
        end
      end
    end
  end
  self.btn_recruit2_img:LoadSprite(string.format(LoadPath.LWCommonPath, 0 < freeHighDice and freeImg or costImg))
  if 0 < freeHighDice then
    self.free_recruit_text2:SetActive(true)
    self.cost_item2_content:SetActive(false)
  else
    self.free_recruit_text2:SetActive(false)
    self.cost_item2_content:SetActive(true)
    if self.costData[2] then
      for i = 1, costNum do
        local costData = self.costData[2][i]
        if costData then
          self.recruitBtn2CostItems[i].costRoot:SetActive(true)
          local costId = costData.itemId
          local iconPath = DataCenter.RewardManager:GetPicByType(costData.type, costData.itemId)
          self.recruitBtn2CostItems[i].costImg:LoadSprite(iconPath)
          local curNum = self:GetCurCostNumByData(costData.type, costData.itemId)
          local needNum = costData.count
          local numStr = curNum >= needNum and needNum or string.format("<color=#dd2828> %s</color>", needNum)
          self.recruitBtn2CostItems[i].costNum:SetText(numStr)
        else
          self.recruitBtn2CostItems[i].costRoot:SetActive(false)
        end
      end
    end
  end
  self.bottom_content:Enable(false)
  self.eff_ui_s_dafuwen_anniuliuguang_01:SetActive(false)
  self.eff_ui_s_dafuwen_anniuliuguang_02:SetActive(false)
end

local function GetCurCostNumByData(self, costType, costId)
  local curNum = 0
  if costType == RewardType.GOODS then
    curNum = DataCenter.ItemData:GetItemCount(costId)
  elseif costType == RewardType.GOLD then
    curNum = LuaEntry.Resource:GetCntByResType(costId)
  end
  return curNum
end

local function GotoLackByLackData(self, lackData)
  if lackData == nil then
    return
  end
  if lackData.type == RewardType.GOODS then
    local costId = lackData.itemId
    local canGotoPackShop = DataCenter.ActMonopolyDataManager:CanGotoPackShop(tonumber(self.activityId))
    if canGotoPackShop then
      DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILuckyRollShop, {anim = true}, self.activityId, DataCenter.ActMonopolyDataManager:GetKeyGiftPackId(tonumber(self.activityId)), costId)
    else
      UIUtil.ShowTipsId(2000655)
    end
  elseif lackData.type == RewardType.GOLD then
    local costData = lackData
    local costId = costData.itemId
    local costNeed = costData.count
    local curNum = LuaEntry.Resource:GetCntByResType(costId)
    GoToUtil.GotoPayTips(costNeed)
  end
end

local function CanClickBtnRecruit1(self)
  local canSendMsg = false
  local detailData = self.activityDetailData
  local lackData
  if detailData == nil then
    return canSendMsg
  end
  local freeNum = detailData.freeNormalDice
  if 0 < freeNum then
    canSendMsg = true
  elseif self.costData[1] then
    local isEnough = true
    for i = 1, costNum do
      local costData = self.costData[1][i]
      if costData then
        local type = costData.type
        local costId = costData.itemId
        local costNeed = costData.count
        local curNum = self:GetCurCostNumByData(costData.type, costData.itemId)
        if costNeed > curNum then
          isEnough = false
          lackData = costData
          break
        end
      end
    end
    canSendMsg = isEnough
  end
  return canSendMsg, lackData
end

local function CanClickBtnRecruit2(self)
  local canSendMsg = false
  local detailData = self.activityDetailData
  local lackData
  if detailData == nil then
    return canSendMsg
  end
  local freeNum = detailData.freeHighDice
  if 0 < freeNum then
    canSendMsg = true
  elseif self.costData[2] then
    local isEnough = true
    for i = 1, costNum do
      local costData = self.costData[2][i]
      if costData then
        local costId = costData.itemId
        local costNeed = costData.count
        local curNum = self:GetCurCostNumByData(costData.type, costData.itemId)
        if costNeed > curNum then
          isEnough = false
          lackData = costData
          break
        end
      end
    end
    canSendMsg = isEnough
  end
  return canSendMsg, lackData
end

local function ClickBtnRecruit1(self)
  local canClick = self:CanClickBtn()
  if not canClick then
    return
  end
  local detailData = self.activityDetailData
  if detailData == nil then
    return
  end
  local freeNum = detailData.freeNormalDice
  if 0 < freeNum then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if curTime > self.mainView.waitBackMsgTime then
      self.mainView:SendDicMsg(ActMonopolyDiceType.Normal)
      self.mainView.waitBackMsgTime = curTime + 5000
    end
    return
  end
  if self.costData[1] then
    local isEnough = true
    local lackData
    for i = 1, costNum do
      local costData = self.costData[1][i]
      if costData then
        local type = costData.type
        local costId = costData.itemId
        local costNeed = costData.count
        local curNum = self:GetCurCostNumByData(costData.type, costData.itemId)
        if costNeed > curNum then
          isEnough = false
          lackData = costData
          break
        end
      end
    end
    if isEnough then
      local curTime = UITimeManager:GetInstance():GetServerTime()
      if curTime > self.mainView.waitBackMsgTime then
        self.mainView:SendDicMsg(ActMonopolyDiceType.Normal)
        self.mainView.waitBackMsgTime = curTime + 5000
      end
    else
      self:GotoLackByLackData(lackData)
    end
  end
end

local function ClickBtnRecruit2(self)
  local canClick = self:CanClickBtn()
  if not canClick then
    return
  end
  local detailData = self.activityDetailData
  if detailData == nil then
    return
  end
  local freeNum = detailData.freeHighDice
  if 0 < freeNum then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if curTime > self.mainView.waitBackMsgTime then
      self.mainView:SendDicMsg(ActMonopolyDiceType.Special)
      self.mainView.waitBackMsgTime = curTime + 5000
    end
    return
  end
  if self.costData[2] then
    local isEnough = true
    local lackData
    for i = 1, costNum do
      local costData = self.costData[2][i]
      if costData then
        local costId = costData.itemId
        local costNeed = costData.count
        local curNum = self:GetCurCostNumByData(costData.type, costData.itemId)
        if costNeed > curNum then
          isEnough = false
          lackData = costData
          break
        end
      end
    end
    if isEnough then
      local curTime = UITimeManager:GetInstance():GetServerTime()
      if curTime > self.mainView.waitBackMsgTime then
        self.mainView:SendDicMsg(ActMonopolyDiceType.Special)
        self.mainView.waitBackMsgTime = curTime + 5000
      end
    else
      self:GotoLackByLackData(lackData)
    end
  end
end

local function CanClickBtn(self)
  local canClick = self.mainView:CanClickBtn()
  return canClick
end

local function SetBtnEffectByDiceType(self, diceType)
  if diceType == ActMonopolyDiceType.Normal then
    self.eff_ui_s_dafuwen_anniuliuguang_01:SetActive(true)
    self.eff_ui_s_dafuwen_anniuliuguang_02:SetActive(false)
  elseif diceType == ActMonopolyDiceType.Special then
    self.eff_ui_s_dafuwen_anniuliuguang_01:SetActive(false)
    self.eff_ui_s_dafuwen_anniuliuguang_02:SetActive(true)
  else
    self.eff_ui_s_dafuwen_anniuliuguang_01:SetActive(false)
    self.eff_ui_s_dafuwen_anniuliuguang_02:SetActive(false)
  end
end

local function DoBtnClickAni(self, diceType)
  self.bottom_content:Enable(true)
  if diceType == ActMonopolyDiceType.Normal then
    self.bottom_content:Play("zuo")
  elseif diceType == ActMonopolyDiceType.Special then
    self.bottom_content:Play("you")
  end
end

ActMonopolyBottomBtnContent.OnCreate = OnCreate
ActMonopolyBottomBtnContent.OnDestroy = OnDestroy
ActMonopolyBottomBtnContent.ComponentDefine = ComponentDefine
ActMonopolyBottomBtnContent.ComponentDestroy = ComponentDestroy
ActMonopolyBottomBtnContent.DataDefine = DataDefine
ActMonopolyBottomBtnContent.DataDestroy = DataDestroy
ActMonopolyBottomBtnContent.SetData = SetData
ActMonopolyBottomBtnContent.RefreshView = RefreshView
ActMonopolyBottomBtnContent.CanClickBtnRecruit1 = CanClickBtnRecruit1
ActMonopolyBottomBtnContent.CanClickBtnRecruit2 = CanClickBtnRecruit2
ActMonopolyBottomBtnContent.ClickBtnRecruit1 = ClickBtnRecruit1
ActMonopolyBottomBtnContent.ClickBtnRecruit2 = ClickBtnRecruit2
ActMonopolyBottomBtnContent.CanClickBtn = CanClickBtn
ActMonopolyBottomBtnContent.GetCurCostNumByData = GetCurCostNumByData
ActMonopolyBottomBtnContent.GotoLackByLackData = GotoLackByLackData
ActMonopolyBottomBtnContent.SetBtnEffectByDiceType = SetBtnEffectByDiceType
ActMonopolyBottomBtnContent.DoBtnClickAni = DoBtnClickAni
return ActMonopolyBottomBtnContent
