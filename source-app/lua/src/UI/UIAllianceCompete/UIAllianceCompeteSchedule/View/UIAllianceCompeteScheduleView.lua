local UIAllianceCompeteScheduleView = BaseClass("UIAllianceCompeteScheduleView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local AllianceCompeteScheduleItem = require("UI.UIAllianceCompete.UIAllianceCompeteSchedule.Component.AllianceCompeteScheduleItem")
local UIHeroTipView = require("UI.UIHero2.UIHeroTip.View.UIHeroTipView")
local titleTxt_path = "UICommonPopUpTitle/Common_img_title/titleText"
local closeBtn_path = "UICommonPopUpTitle/CloseBtn"
local redIcon_path = "ImgBg/topGo/Image/redIcon"
local blueIcon_path = "ImgBg/topGo/Image/blueIcon"
local redNameTxt_path = "ImgBg/topGo/Image/redIcon/redNameTxt"
local redScoreTxt_path = "ImgBg/topGo/Image/redIcon/redScoreTxt"
local redRatTxt_path = "ImgBg/topGo/Image/redIcon/redRatTxt"
local blueNameTxt_path = "ImgBg/topGo/Image/blueIcon/blueNameTxt"
local blueScoreTxt_path = "ImgBg/topGo/Image/blueIcon/blueScoreTxt"
local blueRatTxt_path = "ImgBg/topGo/Image/blueIcon/blueRatTxt"
local progressGo_path = "ImgBg/sv/Viewport/Content/progressGo"
local itemContainer_path = "ImgBg/sv/Viewport/Content/itemContainer"
local rate_path = "ImgBg/sv/Viewport/Content/progressGo/Image jindutiao/rate"
local blueScoreBtn_path = "ImgBg/topGo/Image/blueIcon/blueScoreBtn"
local redScoreBtn_path = "ImgBg/topGo/Image/redIcon/redScoreBtn"
local maskBtn_path = "UICommonPopUpTitle/panel"
local dateTxt_path = "ImgBg/topGo/Image/TextDate"
local typeTxt_path = "ImgBg/topGo/Image/TextMatch"
local scoreTxt_path = "ImgBg/topGo/Image/TextPoints"
local resultTxt_path = "ImgBg/topGo/Image/TextWinner"

local function OnCreate(self)
  base.OnCreate(self)
  self.titleTxt = self:AddComponent(UIText, titleTxt_path)
  self.titleTxt:SetLocalText(361011)
  self.dateTxt = self:AddComponent(UIText, dateTxt_path)
  self.dateTxt:SetLocalText(361016)
  self.typeTxt = self:AddComponent(UIText, typeTxt_path)
  self.typeTxt:SetLocalText(361017)
  self.scoreTxt = self:AddComponent(UIText, scoreTxt_path)
  self.scoreTxt:SetLocalText(361018)
  self.resultTxt = self:AddComponent(UIText, resultTxt_path)
  self.resultTxt:SetLocalText(361019)
  self.closeBtn = self:AddComponent(UIButton, closeBtn_path)
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.redIcon = self:AddComponent(UIImage, redIcon_path)
  self.blueIcon = self:AddComponent(UIImage, blueIcon_path)
  self.redNameTxt = self:AddComponent(UIText, redNameTxt_path)
  self.redScoreTxt = self:AddComponent(UIText, redScoreTxt_path)
  self.redRatTxt = self:AddComponent(UIText, redRatTxt_path)
  self.blueNameTxt = self:AddComponent(UIText, blueNameTxt_path)
  self.blueScoreTxt = self:AddComponent(UIText, blueScoreTxt_path)
  self.blueRatTxt = self:AddComponent(UIText, blueRatTxt_path)
  self.progressGo = self:AddComponent(UIBaseContainer, progressGo_path)
  self.itemContainer = self:AddComponent(UIBaseContainer, itemContainer_path)
  self.rates = {}
  for i = 1, 7 do
    self.rates[i] = self:AddComponent(UIBaseContainer, rate_path .. i)
  end
  self.blueScoreBtn = self:AddComponent(UIButton, blueScoreBtn_path)
  self.blueScoreBtn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnClickBlueScoreBtn()
  end)
  self.redScoreBtn = self:AddComponent(UIButton, redScoreBtn_path)
  self.redScoreBtn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnClickRedScoreBtn()
  end)
  self.maskBtn = self:AddComponent(UIButton, maskBtn_path)
  self.maskBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self:UpdateData()
end

local function OnDestroy(self)
  self.titleTxt = nil
  self.closeBtn = nil
  self.redIcon = nil
  self.blueIcon = nil
  self.redNameTxt = nil
  self.redScoreTxt = nil
  self.redRatTxt = nil
  self.blueNameTxt = nil
  self.blueScoreTxt = nil
  self.blueRatTxt = nil
  self.progressGo = nil
  self.itemContainer = nil
  self.rates = nil
  self.blueScoreBtn = nil
  self.redScoreBtn = nil
  self.maskBtn = nil
  base.OnDestroy(self)
end

local function OnAddListener(self)
  self:AddUIListener(EventId.AllianceCompeteWeeklySummaryUpdated, self.RefreshUI)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.AllianceCompeteWeeklySummaryUpdated, self.RefreshUI)
end

local function UpdateData(self)
  SFSNetwork.SendMessage(MsgDefines.AllianceCompeteWeeklySummary)
end

local function RefreshUI(self)
  self.allianceInfo = DataCenter.ActivityListDataManager:GetActivityDataById(EnumActivity.AllianceCompete.ActId)
  if self.allianceInfo == nil then
    return
  end
  self.eventInfo = self.allianceInfo:GetEventInfo()
  if not self.eventInfo then
    return
  end
  self:RefreshTop()
  self:RefreshList()
end

local function RefreshTop(self)
  local hasAlliance = LuaEntry.Player:IsInAlliance()
  if not hasAlliance then
    return
  end
  local myAllianceId = LuaEntry.Player:GetAllianceUid()
  table.walk(self.eventInfo.vsAllianceList, function(k, v)
    local name = string.format("#%s [%s] %s", v.serverId, v.abbr, v.alName)
    local scoreStr = string.GetFormattedSeperatorNum(v.winScore)
    if k == myAllianceId then
      self.redNameTxt:SetText(name)
      self.redScoreTxt:SetText("")
      self.redRatTxt:SetText(scoreStr)
    else
      self.blueNameTxt:SetText(name)
      self.blueScoreTxt:SetText("")
      self.blueRatTxt:SetText(scoreStr)
    end
  end)
end

local function RefreshList(self)
  for i = 1, 7 do
    self.rates[i]:SetActive(false)
  end
  self.itemList = {}
  local dataList = DataCenter.AllianceCompeteDataManager:GetWeeklySummaryList()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local startT = DataCenter.AllianceCompeteDataManager:GetWeeklySummaryStartTime()
  local day = math.ceil((curTime - startT) / 86400000)
  local list = dataList
  self:SetAllScheduleItemsDestroy()
  self.scheduleItemCount = 0
  self.scheduleItemModel = {}
  self.scheduleItemsList = {}
  if list ~= nil and 0 < #list then
    for i = 1, table.length(list) do
      self.scheduleItemCount = self.scheduleItemCount + 1
      self.scheduleItemModel[self.scheduleItemCount] = self:GameObjectInstantiateAsync(UIAssets.AllianceCompeteScheduleItem, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.gameObject:SetActive(true)
        go.transform:SetParent(self.itemContainer.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        local nameStr = tostring(NameCount)
        go.name = nameStr
        NameCount = NameCount + 1
        local cell = self.itemContainer:AddComponent(AllianceCompeteScheduleItem, nameStr)
        cell:RefreshData(list[i], i, day)
        if i <= day then
          self.rates[i]:SetActive(true)
        end
        table.insert(self.scheduleItemsList, cell)
      end)
    end
  end
end

local function SetAllScheduleItemsDestroy(self)
  self.itemContainer:RemoveComponents(AllianceCompeteScheduleItem)
  if self.scheduleItemModel ~= nil then
    for k, v in pairs(self.scheduleItemModel) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.scheduleItemModel = {}
  self.scheduleItemsList = {}
end

local function OnClickBlueScoreBtn(self)
  local scaleFactor = UIManager:GetInstance():GetScaleFactor()
  local position = self.blueScoreBtn.transform.position + Vector3.New(-50, 0, 0) * scaleFactor
  local param = UIHeroTipView.Param.New()
  param.title = Localization:GetString("361018")
  param.content = Localization:GetString("361067")
  param.dir = UIHeroTipView.Direction.LEFT
  param.defWidth = 180
  param.pivot = 0.5
  param.position = position
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, {anim = false}, param)
end

local function OnClickRedScoreBtn(self)
  local scaleFactor = UIManager:GetInstance():GetScaleFactor()
  local position = self.redScoreBtn.transform.position + Vector3.New(50, 0, 0) * scaleFactor
  local param = UIHeroTipView.Param.New()
  param.title = Localization:GetString("361018")
  param.content = Localization:GetString("361067")
  param.dir = UIHeroTipView.Direction.RIGHT
  param.defWidth = 180
  param.pivot = 0.5
  param.position = position
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, {anim = false}, param)
end

UIAllianceCompeteScheduleView.OnCreate = OnCreate
UIAllianceCompeteScheduleView.OnDestroy = OnDestroy
UIAllianceCompeteScheduleView.OnAddListener = OnAddListener
UIAllianceCompeteScheduleView.OnRemoveListener = OnRemoveListener
UIAllianceCompeteScheduleView.UpdateData = UpdateData
UIAllianceCompeteScheduleView.RefreshUI = RefreshUI
UIAllianceCompeteScheduleView.RefreshTop = RefreshTop
UIAllianceCompeteScheduleView.RefreshList = RefreshList
UIAllianceCompeteScheduleView.SetAllScheduleItemsDestroy = SetAllScheduleItemsDestroy
UIAllianceCompeteScheduleView.OnClickBlueScoreBtn = OnClickBlueScoreBtn
UIAllianceCompeteScheduleView.OnClickRedScoreBtn = OnClickRedScoreBtn
return UIAllianceCompeteScheduleView
