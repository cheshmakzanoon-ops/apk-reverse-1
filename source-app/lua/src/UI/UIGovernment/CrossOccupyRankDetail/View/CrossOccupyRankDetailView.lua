local CrossOccupyRankDetailView = BaseClass("CrossOccupyRankDetailView", UIBaseView)
local base = UIBaseView
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local CrossOccupyRankDetailItem = require("UI.UIGovernment.CrossOccupyRankDetail.Component.CrossOccupyRankDetailItem")
local panel_path = "panel"
local dialog_title_text_path = "PopUpTitle/Common_img_title/titleText"
local close_btn_path = "PopUpTitle/CloseBtn"
local info_btn_path = "PopUpTitle/top/InfoBtn"
local title_path = "PopUpTitle/top/title"
local item_path = "PopUpTitle/Item"
local scroll_view_path = "PopUpTitle/ScrollView"
local content_path = "PopUpTitle/ScrollView/Viewport/Content"
local home_path = "PopUpTitle/ServerInfo/House"
local home_icon_path = "PopUpTitle/ServerInfo/House/homeIcon"
local server_bg_path = "PopUpTitle/ServerInfo/House/ServerBg"
local server_txt_path = "PopUpTitle/ServerInfo/House/ServerBg/ServerTxt"
local alliance_icon_path = "PopUpTitle/ServerInfo/AllianceFlag"
local name_txt_path = "PopUpTitle/ServerInfo/nameTxt"
local slider_path = "PopUpTitle/ServerInfo/Slider"
local slider_txt_path = "PopUpTitle/ServerInfo/Slider/SliderTxt"
local fill_path = "PopUpTitle/ServerInfo/Slider/FillArea/Fill"

function CrossOccupyRankDetailView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.serverId = self:GetUserData()
  SFSNetwork.SendMessage(MsgDefines.GetCrossKingOccupyProgress, self.serverId)
end

function CrossOccupyRankDetailView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function CrossOccupyRankDetailView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.CrossKingOccupyProgressRefresh, self.RefreshRankList)
end

function CrossOccupyRankDetailView:OnRemoveListener()
  self:RemoveUIListener(EventId.CrossKingOccupyProgressRefresh, self.RefreshRankList)
  base.OnRemoveListener(self)
end

function CrossOccupyRankDetailView:ComponentDefine()
  self.dialog_title_text = self:AddComponent(UIText, dialog_title_text_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.dialog_title_text:SetLocalText("457044")
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.close_btn1 = self:AddComponent(UIButton, panel_path)
  self.close_btn1:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.title = self:AddComponent(UIText, title_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.home = self:AddComponent(UIImage, home_path)
  self.home_icon = self:AddComponent(UIImage, home_icon_path)
  self.server_bg = self:AddComponent(UIImage, server_bg_path)
  self.server_txt = self:AddComponent(UIText, server_txt_path)
  self.alliance_icon = self:AddComponent(UIImage, alliance_icon_path)
  self.name_txt = self:AddComponent(UIText, name_txt_path)
  self.slider = self:AddComponent(UISlider, slider_path)
  self.slider_txt = self:AddComponent(UIText, slider_txt_path)
  self.fill = self:AddComponent(UIImage, fill_path)
  self.info_btn = self:AddComponent(UIButton, info_btn_path)
  self.info_btn:SetOnClick(function()
    local param = {}
    param.title = "801604"
    if SeasonUtil.IsNineKingActive() then
      param.activityRulesStr = Localization:GetString("season_s5_activity_1200067_get_rule")
    else
      param.activityRulesStr = Localization:GetString("801605")
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
  end)
  self.ScrollView = self:AddComponent(UIScrollView, scroll_view_path)
  self.ScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnRankItemMoveIn(itemObj, index)
  end)
  self.ScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnRankItemMoveOut(itemObj, index)
  end)
end

function CrossOccupyRankDetailView:ComponentDestroy()
  self:ClearScroll()
  self.btn_back = nil
end

function CrossOccupyRankDetailView:RefreshRankList()
  self:ClearScroll()
  self:RefreshSelfContent()
  local data = DataCenter.GovernmentManager.CrossKingOccupyList
  if data and self.ownerServerInfo then
    local ownerServerId = self.ownerServerId or 0
    local ownerAllianceId = self.ownerAllianceId or ""
    self.maxOccupy = 0
    self.maxOther = 0
    self.rankList = data.allianceBuildPoint
    local rankList = {}
    for i, v in ipairs(self.rankList) do
      if v and v.serverId and v.allianceId and v.allianceName and v.allianceIcon and v.contributePoint and v.allianceAbbr then
        table.insert(rankList, v)
      end
    end
    self.rankList = rankList
    table.sort(self.rankList, function(a, b)
      if a.contributePoint == nil then
        a.contributePoint = 0
      end
      if b.contributePoint == nil then
        b.contributePoint = 0
      end
      local isAllyA = SeasonUtil.IsAlly(ownerServerId, a.serverId, ownerAllianceId, a.allianceId)
      local isAllyB = SeasonUtil.IsAlly(ownerServerId, b.serverId, ownerAllianceId, b.allianceId)
      if isAllyA and not isAllyB then
        return true
      elseif not isAllyA and isAllyB then
        return false
      end
      return a.contributePoint > b.contributePoint
    end)
    for i, v in ipairs(self.rankList) do
      if SeasonUtil.IsAlly(ownerServerId, v.serverId, ownerAllianceId, v.allianceId) then
        self.maxOccupy = math.max(self.maxOccupy, v.contributePoint)
      else
        self.maxOther = math.max(self.maxOther, v.contributePoint)
      end
    end
    if #self.rankList > 0 then
      self.ScrollView:SetTotalCount(#self.rankList)
      self.ScrollView:RefillCells()
    end
  end
end

function CrossOccupyRankDetailView:OnRankItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.ScrollView:AddComponent(CrossOccupyRankDetailItem, itemObj)
  if cellItem ~= nil then
    cellItem:ReInit(index, self.rankList[index], self.ownerServerId, self.maxOccupy, self.maxOther, self.ownerAllianceId)
  end
end

function CrossOccupyRankDetailView:OnRankItemMoveOut(itemObj, index)
  self.ScrollView:RemoveComponent(itemObj.name, CrossOccupyRankDetailItem)
end

function CrossOccupyRankDetailView:ClearScroll()
  self.ScrollView:ClearCells()
  self.ScrollView:RemoveComponents(CrossOccupyRankDetailItem)
end

function CrossOccupyRankDetailView:RefreshSelfContent()
  local data = DataCenter.GovernmentManager.CrossKingOccupyList
  if data then
    local serverBuildPoint = data.serverBuildPoint
    if serverBuildPoint then
      local player = LuaEntry.Player
      local myServerId = player:GetSourceServerId()
      local ownerServerId = 0
      local ownerAllianceId = ""
      local ownerAbbr = ""
      self.ownerServerInfo = nil
      for _, v in ipairs(serverBuildPoint) do
        if v and v.buildSpeed and 0 < v.buildSpeed then
          ownerServerId = v.serverId
          ownerAllianceId = v.allianceId
          ownerAbbr = v.allianceAbbr
          self.ownerServerInfo = v
          self.buildPoint = v.buildPoint
          self.buildSpeed = v.buildSpeed
          break
        end
      end
      local curServerId = LuaEntry.Player:GetCurServerId()
      local kingCityId, kingCityPosIndex = SeasonUtil.GetKingCityId(curServerId)
      local pointInfo = CS.SceneManager.World:GetPointInfo(kingCityPosIndex)
      if pointInfo ~= nil then
        local allianceCityPointInfo = SeasonUtil.TryParseAllianceCityPointInfo(pointInfo.PointType, pointInfo.extraInfo, pointInfo)
        if allianceCityPointInfo ~= nil then
          if ownerServerId == 0 and allianceCityPointInfo.serverId ~= nil then
            ownerServerId = allianceCityPointInfo.serverId
            ownerAllianceId = allianceCityPointInfo.allianceId
            ownerAbbr = allianceCityPointInfo.alAbbr
          end
          local buildPointInfo = allianceCityPointInfo.buildPointInfo
          self.buildStartTime = allianceCityPointInfo.buildStartTime
          self.buildPointInfo = buildPointInfo
          for _, v in ipairs(buildPointInfo) do
            if SeasonUtil.IsAlly(ownerServerId, v.serverId, ownerAllianceId, v.allianceId) then
              self.ownerServerInfo = v
              self.buildPoint = v.buildPoint
              self.buildSpeed = v.buildSpeed
              break
            end
          end
        end
      end
      if ownerServerId == 0 and 0 < #serverBuildPoint then
        self.ownerServerInfo = serverBuildPoint[1]
        if self.ownerServerInfo then
          ownerServerId = self.ownerServerInfo.serverId
          ownerAllianceId = self.ownerServerInfo.allianceId
          ownerAbbr = self.ownerServerInfo.allianceAbbr
          self.buildPoint = self.ownerServerInfo.buildPoint
          self.buildSpeed = self.ownerServerInfo.buildSpeed
        end
      end
      self.ownerServerId = ownerServerId
      self.ownerAllianceId = ownerAllianceId
      self.ownerInfo = {
        serverId = ownerServerId,
        allianceId = ownerAllianceId,
        allianceAbbr = ownerAbbr
      }
      self:Update1000MS()
      if SeasonUtil.IsAlly(ownerServerId, myServerId, ownerAllianceId) then
        self.fill:SetColorRGBA(0.15294117647058825, 0.7490196078431373, 0.9921568627450981, 1)
        self.server_bg:LoadSprite("Assets/Main/Sprites/UI/UIGovernment/Sprites/ServerBattle/lrb_zhanqvduijue_fuwuqibg02.png")
      else
        self.fill:SetColorRGBA(0.8117647058823529, 0.16470588235294117, 0.16470588235294117, 1)
        self.server_bg:LoadSprite("Assets/Main/Sprites/UI/UIGovernment/Sprites/ServerBattle/lrb_zhanqvduijue_fuwuqibg01.png")
      end
      for _, v in ipairs(serverBuildPoint) do
        if SeasonUtil.IsAlly(ownerServerId, v.serverId, ownerAllianceId, v.allianceId) then
          self.buildPoint = v.buildPoint
          if SeasonUtil.IsAlly(ownerServerId, myServerId, ownerAllianceId) then
            self.name_txt:SetLocalText(801485, SeasonUtil.GetWorldBattleName(self.ownerInfo, true, false))
          else
            self.name_txt:SetLocalText(801485, SeasonUtil.GetWorldBattleName(self.ownerInfo, true, true))
          end
          self:RefreshIcon(ownerServerId, ownerAllianceId)
          self:Update1000MS()
          break
        end
      end
    end
  end
end

function CrossOccupyRankDetailView:Update1000MS()
  if self.buildStartTime and self.buildPointInfo and self.ownerServerInfo then
    local totalPoint = SeasonUtil.GetWorldBattleTotalPoint()
    local addPoint = self.buildSpeed
    local Seconds = UITimeManager:GetInstance():GetServerSeconds() - self.buildStartTime
    local pointNow = self.buildPoint + addPoint * Seconds
    local rate = math.min(pointNow / totalPoint, 1.0)
    self.slider:SetValue(rate * 100)
    self.slider_txt:SetText(math.floor(rate * 10000) * 0.01 .. "%")
    local remainTime = DataCenter.ZoneWarManager:CalcOccupyTime(pointNow, addPoint)
    if 0 < remainTime then
      self.title:SetLocalText("801484", UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
    elseif self.ownerServerId then
      self.title:SetText(Localization:GetString("110236") .. SeasonUtil.GetWorldBattleName(self.ownerInfo))
    end
  end
end

function CrossOccupyRankDetailView:OnPlayerDetailClick(serverId, playerUid)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {anim = true}, {serverId = serverId, uid = playerUid})
end

function CrossOccupyRankDetailView:OnAllianceDetailClick(allianceId, allianceName)
  UIUtil.TryShowAllianceInfo(nil, allianceId, allianceName)
end

function CrossOccupyRankDetailView:RefreshIcon(ownerServerId, ownerAllianceId, allianceIcon)
  if SeasonUtil.IsNineKingActive() then
    if not allianceIcon then
      local data = DataCenter.GovernmentManager.CrossKingOccupyList
      if data and data.allianceBuildPoint then
        for _, v in ipairs(data.allianceBuildPoint) do
          if v.allianceId == ownerAllianceId and v.serverId == ownerServerId then
            allianceIcon = v.allianceIcon
            break
          end
        end
      end
    end
    self.alliance_icon:LoadSprite(string.format(AL_FLAG_SPRITE_PATH, tostring(allianceIcon or 1)))
    self.alliance_icon:SetActive(true)
    self.home:SetActive(false)
    return
  end
  self.server_txt:SetText(SeasonUtil.GetWorldBattleName(self.ownerInfo))
  self.serverKingInfo = DataCenter.ZoneWarManager:GetServerInfo(ownerServerId)
  if self.serverKingInfo and self.serverKingInfo.cfgId then
    local itemCfg = DataCenter.ItemTemplateManager:GetItemTemplate(self.serverKingInfo.cfgId)
    if itemCfg ~= nil then
      self.home_icon:LoadSprite(string.format(LoadPath.ItemPath, itemCfg.icon))
    end
  end
  self.alliance_icon:SetActive(false)
  self.home:SetActive(true)
end

return CrossOccupyRankDetailView
