local base = UIBaseView
local UIDetectRewardView = BaseClass("UIDetectRewardView", base)
local DetectRewardHeroPage = require("UI.UIDetectRewardView.Component.DetectRewardHeroPage")
local UICommonResItem = require("UI.UICommonResItem.UICommonResItemV2.UICommonResItem")
local MailScoutDetailHelper = require("DataCenter.MailData.MailScoutDetailHelper")
local Localization = CS.GameEntry.Localization
local rapidjson = require("rapidjson")
local panel_path = "UICommonPopUpTitle/panel"
local titleTxt_path = "UICommonPopUpTitle/Common_img_title/titleText"
local closeBtn_path = "UICommonPopUpTitle/CloseBtn"
local nameTxt_path = "TopParent/Name"
local coordinateTxt_path = "TopParent/Coordinate"
local rightBtn_path = "TopParent/RightBtn"
local leftBtn_path = "TopParent/LeftBtn"
local troopCountTxt_path = "DescContent/TroopCountTxt"
local powerTxt_path = "DescContent/PowerTxt"
local itemContent_path = "ResourceContent/ItemScroll/Viewport/Content"
local shareBtn_path = "Btn_share"
local mailBtn_path = "Btn_mail"
local pointText_path = "PointContent/PointText"
local resourceContent_path = "ResourceContent"
local bg_path = "BG (1)"
local scrollView_path = "Scroll View"
local uiPlayerHead_path = "TopParent/HeadParent/UIPlayerHead"
local scoutHeroPage_path = "Scroll View/Viewport/Content/MailScoutHeroPage"
local MailBattleParseHelper = require("DataCenter.MailData.MailBattleParseHelper")

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
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
  self.panel = self:AddComponent(UIButton, panel_path)
  self.titleTxt = self:AddComponent(UIText, titleTxt_path)
  self.closeBtn = self:AddComponent(UIButton, closeBtn_path)
  self.nameTxt = self:AddComponent(UIText, nameTxt_path)
  self.coordinateTxt = self:AddComponent(UIText, coordinateTxt_path)
  self.rightBtn = self:AddComponent(UIButton, rightBtn_path)
  self.leftBtn = self:AddComponent(UIButton, leftBtn_path)
  self.troopCountTxt = self:AddComponent(UIText, troopCountTxt_path)
  self.powerTxt = self:AddComponent(UIText, powerTxt_path)
  self.itemContent = self:AddComponent(UIBaseContainer, itemContent_path)
  self.shareBtn = self:AddComponent(UIButton, shareBtn_path)
  self.mailBtn = self:AddComponent(UIButton, mailBtn_path)
  self.pointText = self:AddComponent(UIText, pointText_path)
  self.resourceContent = self:AddComponent(UIBaseContainer, resourceContent_path)
  self.bg = self:AddComponent(UIBaseContainer, bg_path)
  self.scrollView = self:AddComponent(UIBaseContainer, scrollView_path)
  self.panel:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.closeBtn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.uiPlayerHead = self:AddComponent(UICommonHead, uiPlayerHead_path)
  self.scoutHeroPage = self:AddComponent(DetectRewardHeroPage, scoutHeroPage_path)
  self.leftBtn:SetOnClick(BindCallback(self, self.JumpPreviousReport))
  self.rightBtn:SetOnClick(BindCallback(self, self.JumpNextReport))
  self.coordinateTxt = self:AddComponent(UITextMeshProUGUIEx, coordinateTxt_path)
  self.coordinateTxt:OnPointerClick(function(eventData)
    UIUtil.UseJumpLink(self.coordinateTxt, eventData)
  end)
  self.shareBtn:SetOnClick(BindCallback(self, self.OnClickShareBtn))
  self.mailBtn:SetOnClick(BindCallback(self, self.OnClickMailBtn))
end

local function ComponentDestroy(self)
  self:ClearResourceItem()
  self.panel = nil
  self.titleTxt = nil
  self.closeBtn = nil
  self.nameTxt = nil
  self.coordinateTxt = nil
  self.rightBtn = nil
  self.leftBtn = nil
  self.troopCountTxt = nil
  self.powerTxt = nil
  self.itemContent = nil
  self.shareBtn = nil
  self.mailBtn = nil
  self.pointText = nil
  self.resourceContent = nil
  self.bg = nil
  self.scrollView = nil
  self.uiPlayerHead = nil
  self.scoutHeroPage = nil
end

local function DataDefine(self)
  self.curIndex = 1
end

local function DataDestroy(self)
  self.curIndex = nil
end

function UIDetectRewardView:ReInit()
  self.dataList = DataCenter.DetectResultDataManager:GetAllNewScoutDataList()
  if not table.IsNullOrEmpty(self.dataList) then
    self.curData = self.dataList[self.curIndex]
    self.curDataExt = self.dataList[self.curIndex]:GetMailExt()
    self:OnShow()
  end
end

function UIDetectRewardView:OnShow()
  self.scoutHeroPage:Refresh(self.curDataExt)
  self:SetPlayerData()
  self:SetResourceItems()
  self:RefreshJumpBtn()
  self:RefreshBottomPointImg()
end

function UIDetectRewardView:SetPlayerData()
  if self.curDataExt then
    local extData = self.curDataExt:GetExtData()
    local targetInfo = MailScoutDetailHelper:HandleTargetInfo(extData, extData.targetType)
    self.location2 = targetInfo.location
    self.serverId2 = targetInfo.serverId
    if targetInfo.isWerewolf then
      self.uiPlayerHead:ShowWerewolf()
    elseif targetInfo.headIcon then
      self.uiPlayerHead:SetHead(nil, targetInfo.headIcon)
    else
      self.uiPlayerHead:SetHead(targetInfo.uid, targetInfo.pic, targetInfo.picVer, nil, targetInfo.headFramePath)
    end
    self.uiPlayerHead:SetEnableClickShowInfo(targetInfo.enableClickInfo, true)
    self.uiPlayerHead.frameBg:SetActive(not targetInfo.hideBg)
    self.nameTxt:SetText(targetInfo.nameNeedLocal and Localization:GetString(targetInfo.name) or DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(targetInfo.uid, targetInfo.name))
    local coordTxt = string.format("X: %s, Y: %s", self.location2.x, self.location2.y)
    local pointId = SceneUtils.TilePosToIndex({
      x = self.location2.x,
      y = self.location2.y
    })
    local worldId = MailScoutDetailHelper:GetWorldId(extData)
    self.coordinateTxt:SetText(UIUtil.MakeJumpLink(pointId, self.serverId2, worldId, coordTxt))
    self.totalTroopCount = 0
    for k, v in ipairs(extData.army.target.formation) do
      if 0 < table.count(v.hero) then
        self.totalTroopCount = self.totalTroopCount + 1
      end
    end
    for k, v in ipairs(extData.army.help.formation) do
      if 0 < table.count(v.formation.hero) then
        self.totalTroopCount = self.totalTroopCount + 1
      end
    end
    self.troopCountTxt:SetText(Localization:GetString(110149) .. " " .. self.totalTroopCount)
    self.totalPower = 0
    for k, v in ipairs(extData.army.target.formation) do
      self.totalPower = self.totalPower + v.power
    end
    local helperPower = 0
    for k, v in ipairs(extData.army.help.formation) do
      helperPower = helperPower + v.formation.power
    end
    self.totalPower = self.totalPower + helperPower
    self.powerTxt:SetActive(0 < self.totalPower and (0 < helperPower or table.count(extData.army.help.formation) == 0))
    self.powerTxt:SetText(Localization:GetString(100644) .. " " .. string.GetFormattedStr2(self.totalPower))
  end
end

function UIDetectRewardView:ClearResourceItem()
  self.itemContent:RemoveComponents(UICommonResItem)
  if self.rewardReqs then
    for k, v in pairs(self.rewardReqs) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
    self.rewardReqs = nil
  end
end

function UIDetectRewardView:SetResourceItems()
  local extData = self.curDataExt:GetExtData()
  local worldId = MailScoutDetailHelper:GetWorldId(extData)
  self.resourceDatas = {}
  if worldId == 0 then
    for k, v in pairs(extData.resource.data) do
      local reward = {}
      reward.type = RewardType.RESOURCE
      reward.value = {}
      reward.value.id = v.id.value
      if v.newValue and v.newValue.value then
        reward.value.num = v.newValue.value
      else
        reward.value.num = v.value.value
      end
      if 0 < reward.value.num then
        table.insert(self.resourceDatas, reward)
      end
    end
  end
  self.resourceContent:SetActive(not table.IsNullOrEmpty(self.resourceDatas))
  self.bg:SetSizeDeltaXY(705, table.IsNullOrEmpty(self.resourceDatas) and 640 or 480)
  self.scrollView:SetSizeDeltaXY(693, table.IsNullOrEmpty(self.resourceDatas) and 618 or 468)
  self:ClearResourceItem()
  if worldId == 0 then
    self.rewardReqs = {}
    if not table.IsNullOrEmpty(self.resourceDatas) then
      local rewardsParam = DataCenter.RewardManager:ReturnRewardParamForMessage(self.resourceDatas) or {}
      for k, v in ipairs(rewardsParam) do
        self.rewardReqs[k] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(request)
          if request.isError then
            return
          end
          local go = request.gameObject
          local trans = go.transform
          trans:SetParent(self.itemContent.transform)
          trans:Set_localScale(0.6, 0.6, 1)
          trans:Set_pivot(0.5, 0.5)
          local nameStr = tostring(NameCount)
          go.name = nameStr
          NameCount = NameCount + 1
          local cell = self.itemContent:AddComponent(UICommonResItem, nameStr)
          cell:ReInit(rewardsParam[k])
        end)
      end
    end
  end
end

function UIDetectRewardView:RefreshJumpBtn()
  self.rightBtn:SetActive(self.curIndex < #self.dataList)
  self.leftBtn:SetActive(self.curIndex > 1)
end

function UIDetectRewardView:JumpNextReport()
  if self.curIndex < #self.dataList then
    self.curIndex = self.curIndex + 1
    self.curData = self.dataList[self.curIndex]
    self.curDataExt = self.dataList[self.curIndex]:GetMailExt()
    self:OnShow()
  end
end

function UIDetectRewardView:JumpPreviousReport()
  if self.curIndex > 1 then
    self.curIndex = self.curIndex - 1
    self.curData = self.dataList[self.curIndex]
    self.curDataExt = self.dataList[self.curIndex]:GetMailExt()
    self:OnShow()
  end
end

function UIDetectRewardView:OnClickShareBtn()
  if CoppaUtil.IsCoppaLimitWithTips() then
    return
  end
  local shareParam = {}
  shareParam.post = PostType.Text_FightReport
  shareParam.param = {}
  shareParam.param.reportUid = self.curData.uid
  shareParam.param.reportLang = ChatManager2:GetInstance().Translate:GetLangString(ChatInterface.getLanguageName())
  shareParam.param.mailType = self.curData.type
  shareParam.param.toUser = self.curData.toUser
  shareParam.post = PostType.Text_ScoutReport
  shareParam.troopCount = self.totalTroopCount or 0
  shareParam.power = self.totalPower or 0
  local ext = self.curData:GetMailExt():GetExtData()
  if ext and MailBattleParseHelper.IsWerewolf(ext.targetUser) then
    shareParam.param.wolfEndTime = ext.targetUser.wolfEndTime
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPositionShare, {anim = true}, shareParam)
end

function UIDetectRewardView:OnClickMailBtn()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWMailMain, {anim = false}, UIMailOpenType.Detail, self.curData.uid, "DetectReward")
end

function UIDetectRewardView:RefreshBottomPointImg()
  local dataCount = #self.dataList
  self.pointText:SetText(string.format("%d/%d", self.curIndex, dataCount))
end

UIDetectRewardView.OnCreate = OnCreate
UIDetectRewardView.OnDestroy = OnDestroy
UIDetectRewardView.OnEnable = OnEnable
UIDetectRewardView.OnDisable = OnDisable
UIDetectRewardView.ComponentDefine = ComponentDefine
UIDetectRewardView.ComponentDestroy = ComponentDestroy
UIDetectRewardView.DataDefine = DataDefine
UIDetectRewardView.DataDestroy = DataDestroy
return UIDetectRewardView
