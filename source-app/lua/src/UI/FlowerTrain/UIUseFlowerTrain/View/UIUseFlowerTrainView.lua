local base = UIBaseView
local UIUseFlowerTrainView = BaseClass("UIUseFlowerTrainView", base)
local Localization = CS.GameEntry.Localization
local UICommonResItem = require("UI.UICommonResItem.UICommonResItemV2.UICommonResItem")
local useBtn_path = "Content/UseBtn"
local getBtn_path = "Content/GetBtn"
local employBtn_path = "Content/EmployBtn"
local previewBtn_path = "Content/PreviewBtn"
local rewardContent_path = "Content/RewardBg/Rect_Reward/Viewport/Content"
local closeBtn_path = "Content/CloseBtn"
local titleTxt_path = "Content/Title"
local descTxt_path = "Content/Scroll View/Viewport/Desc"
local infoBtn_path = "Content/InfoBtn"
local bg_path = "Content/Bg"
local spineParent_path = "Content/Bg/SpineParent"
local closePanelBtn_path = "panel"
local frontEffPoint_path = "Content/Bg/FrontEffPoint"
local USE_FLOWER_TRAIN_CONFIRM = "USE_FLOWER_TRAIN_CONFIRM"
local ENTER_ANIM = "in"
local IDLE_ANIM = "idle"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshView()
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

local function ComponentDefine(self)
  self.useBtn = self:AddComponent(UIButton, useBtn_path)
  self.getBtn = self:AddComponent(UIButton, getBtn_path)
  self.employBtn = self:AddComponent(UIButton, employBtn_path)
  self.previewBtn = self:AddComponent(UIButton, previewBtn_path)
  self.rewardContent = self:AddComponent(UIBaseContainer, rewardContent_path)
  self.closeBtn = self:AddComponent(UIButton, closeBtn_path)
  self.titleTxt = self:AddComponent(UIText, titleTxt_path)
  self.descTxt = self:AddComponent(UIText, descTxt_path)
  self.infoBtn = self:AddComponent(UIButton, infoBtn_path)
  self.bg = self:AddComponent(UIRawImage, bg_path)
  self.spineParent = self:AddComponent(UIBaseContainer, spineParent_path)
  self.closePanelBtn = self:AddComponent(UIButton, closePanelBtn_path)
  self.frontEffPoint = self:AddComponent(UIBaseContainer, frontEffPoint_path)
  self.useBtn:SetOnClick(function()
    self:UseFlowerTrain()
  end)
  self.getBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.employBtn:SetOnClick(function()
    self:UseFlowerTrain()
  end)
  self.previewBtn:SetOnClick(function()
    self:OnPreviewBtnClick()
  end)
  self.infoBtn:SetOnClick(function()
    self:OnInfoBtnClick()
  end)
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.closePanelBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
end

local function ComponentDestroy(self)
  self:ClearRewards()
  self.useBtn = nil
  self.getBtn = nil
  self.employBtn = nil
  self.previewBtn = nil
  self.rewardContent = nil
  self.closeBtn = nil
  self.titleTxt = nil
  self.descTxt = nil
  self.infoBtn = nil
  self.bg = nil
  self.spineParent = nil
  self.closePanelBtn = nil
  self.frontEffPoint = nil
  if self.frontEffReq then
    self.frontEffReq:Destroy()
    self.frontEffReq = nil
  end
end

local function DataDefine(self)
  self.rewardItemRequests = {}
  local data = self:GetUserData()
  self.itemId = data.itemId
  self.itemMeta = DataCenter.ItemTemplateManager:GetItemTemplate(self.itemId)
  self.showData = FlowerTrainUtils.GetFlowerTrainDisplayMetaByGoodsId(self.itemId)
  self.infoData = FlowerTrainUtils.GetFlowerTrainLvDataByGoodsId(self.itemId)
  self.paraInfo = FlowerTrainUtils.GetFlowerTrainParaMetaByGoodsId(self.itemId)
  self.isBagUse = data.isBagUse == true
  local rewardList = FlowerTrainUtils.ParseRewardStr(self.infoData.reward_show)
  self.rewardList = rewardList or {}
  PostEventLog.Track(PostEventLog.Defines.FlowerTrain_Show_Use_Panel, {
    share_type = data.isBagUse and 2 or 1
  })
end

local function DataDestroy(self)
  self.rewardItemRequests = {}
end

function UIUseFlowerTrainView:RefreshView()
  self.bg:LoadSprite(self.paraInfo.use_di_pic)
  self.useBtn:SetActive(not self.isBagUse)
  self.getBtn:SetActive(not self.isBagUse)
  self.employBtn:SetActive(self.isBagUse)
  local title, desc = "", ""
  if self.itemMeta then
    title = self.itemMeta.name
  end
  if self.paraInfo then
    desc = self.paraInfo.spec_desc
  end
  self.titleTxt:SetLocalText(title)
  self.descTxt:SetLocalText(desc)
  self:RefreshRewardContent()
  self:ReloadSpine(self.paraInfo.use_effect)
  self:GenerateDecoEff()
end

function UIUseFlowerTrainView:GenerateDecoEff()
  if not self.paraInfo or not self.paraInfo.use_panel_deco_cfg then
    return
  end
  FlowerTrainUtils.GeneratePanelDeco(self, self.paraInfo.use_panel_deco_cfg)
end

function UIUseFlowerTrainView:RefreshRewardContent()
  self:ClearRewards()
  local index = 1
  for i = 1, table.count(self.rewardList) do
    local request = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go.gameObject:SetActive(true)
      go.transform:SetParent(self.rewardContent.transform)
      go.transform:Set_localScale(1, 1, ResetScale.z)
      go.transform:Set_pivot(0.5, 0.5)
      go.name = "item" .. tostring(index)
      local cell = self.rewardContent:AddComponent(UICommonResItem, go.name)
      cell:ReInit(self.rewardList[i])
      index = index + 1
    end)
    table.insert(self.rewardItemRequests, request)
  end
end

function UIUseFlowerTrainView:ClearRewards()
  if self.rewardItemRequests then
    self.rewardContent:RemoveComponents(UICommonResItem)
    for i, v in pairs(self.rewardItemRequests) do
      v:Destroy()
    end
    self.rewardItemRequests = {}
  end
end

function UIUseFlowerTrainView:UseFlowerTrain()
  local isCanPlaceFlower, reasonType = FlowerTrainUtils.IsCanPlaceFlowerTrain(false)
  if not isCanPlaceFlower then
    if reasonType == FlowerTrainOperateFailReason.NotInSourceServer then
      local pointId = LuaEntry.Player:GetMainWorldPos()
      UIUtil.ShowMessage(Localization:GetString("treasure_use_common_alert1_desc"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
        GoToUtil.CloseAllWindows()
        CrossServerUtil.BackToSrcServerAndDoSomething(pointId, function()
          self:ConfirmUseFlowerTrain()
        end)
      end, function()
      end)
    end
    return
  end
  if self:TodayDontShowJumpTipAgain() then
    self:ConfirmUseFlowerTrain()
    return
  end
  local key = self.paraInfo.use_alert_text or "halloween_treasure_use_alert3"
  UIUtil.ShowSecondMessageByParam({
    tipText = Localization:GetString(key),
    btnNum = 2,
    showToggle = true,
    toggleText = Localization:GetString("110103"),
    toggleAction = function(isOn)
      if isOn then
        CommonUtil.PlayerPrefsSetString(USE_FLOWER_TRAIN_CONFIRM, "")
      else
        CommonUtil.PlayerPrefsSetString(USE_FLOWER_TRAIN_CONFIRM, tostring(UITimeManager:GetInstance():GetServerSeconds()))
      end
    end,
    sureAction = function()
      self:ConfirmUseFlowerTrain()
    end
  })
end

function UIUseFlowerTrainView:ConfirmUseFlowerTrain()
  if SceneUtils.CheckCanGotoWorld() then
    SceneUtils.ChangeToWorld(function()
      local goodsId = self.itemId
      local flowerTrainPrefabPath = FlowerTrainUtils.GetFlowerTrainPrefabPathByGoodsId(goodsId)
      local pointId = LuaEntry.Player:GetMainWorldPos()
      if not CS.SceneManager.IsInCity() then
        local center = Vector3.New(Screen.width / 2, Screen.height / 2, 0)
        local worldPos = CS.SceneManager.World:ScreenPointToWorld(center)
        pointId = SceneUtils.WorldToTileIndex(worldPos, ForceChangeScene.World)
      end
      CS.SceneManager.World:UICreateWorldFlowerTrain(flowerTrainPrefabPath, pointId, goodsId)
    end)
  end
  if self.ctrl then
    self.ctrl:CloseSelf()
  end
  if self.isBagUse then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWBagMain)
  else
    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIActivityCommonGroupShow) then
      UIManager:GetInstance():DestroyWindow(UIWindowNames.UIActivityCommonGroupShow)
    end
    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIFestivalActivityCommonGroupShow) then
      UIManager:GetInstance():DestroyWindow(UIWindowNames.UIFestivalActivityCommonGroupShow)
    end
    GoToUtil.CloseAllWindows()
  end
end

function UIUseFlowerTrainView:TodayDontShowJumpTipAgain()
  local time = CommonUtil.PlayerPrefsGetString(USE_FLOWER_TRAIN_CONFIRM, "")
  if time ~= nil and time ~= "" then
    local now = UITimeManager:GetInstance():GetServerSeconds()
    return UITimeManager:GetInstance():IsSameDayForServer(tonumber(time) or 0, now)
  end
  return false
end

function UIUseFlowerTrainView:OnPreviewBtnClick()
  if not self.itemId then
    Logger.LogError("UIUseFlowerTrainView:OnPreviewBtnClick item is nil")
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIFlowerTrainProbability, {anim = true}, {
    itemId = self.itemId
  })
end

function UIUseFlowerTrainView:OnInfoBtnClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIFlowerTrainRules, {anim = true}, {
    itemId = self.itemId
  })
end

function UIUseFlowerTrainView:ReloadSpine(spinePath)
  if string.IsNullOrEmpty(spinePath) then
    return
  end
  if spinePath ~= self.lastSpinePath then
    if self.spine then
      self.spineParent:RemoveComponent(UISpine)
    end
    if self.spineLoadRequest ~= nil then
      self:GameObjectDestroy(self.spineLoadRequest)
      self.spineLoadRequest = nil
    end
    local request = self:GameObjectInstantiateAsync(spinePath)
    self.spineLoadRequest = request
    request:completed("+", function()
      if request.isError or request.gameObject == nil then
        self.spineLoadRequest = nil
        return
      end
      self:ResetSpineTransform(request.gameObject)
    end)
    self.lastSpinePath = spinePath
  elseif self.spine then
    self.spine:SetActive(false)
    self.spine:SetAnimation(0, ENTER_ANIM, false)
    self.spine:SetActive(true)
  end
end

function UIUseFlowerTrainView:ResetSpineTransform(obj)
  if not obj then
    return
  end
  local rectTransform = obj:GetComponent(typeof(CS.UnityEngine.RectTransform))
  if rectTransform ~= nil then
    rectTransform:SetParent(self.spineParent.transform)
    rectTransform:Set_localScale(1, 1, 1)
    rectTransform:Set_anchoredPosition(0, 0, 0)
    self.spine = self:AddComponent(UISpine, obj.transform:Find("Spine").gameObject)
    self.spine:SetCompleteEvent(BindCallback(self.OnComplete, self))
    self.spine:SetAnimation(0, ENTER_ANIM, false)
    self.spine:SetActive(true)
  end
end

function UIUseFlowerTrainView:OnComplete()
  if self.spine then
    self.spine:SetAnimation(0, IDLE_ANIM, true)
  end
end

UIUseFlowerTrainView.OnCreate = OnCreate
UIUseFlowerTrainView.OnDestroy = OnDestroy
UIUseFlowerTrainView.OnEnable = OnEnable
UIUseFlowerTrainView.OnDisable = OnDisable
UIUseFlowerTrainView.ComponentDefine = ComponentDefine
UIUseFlowerTrainView.ComponentDestroy = ComponentDestroy
UIUseFlowerTrainView.DataDefine = DataDefine
UIUseFlowerTrainView.DataDestroy = DataDestroy
return UIUseFlowerTrainView
