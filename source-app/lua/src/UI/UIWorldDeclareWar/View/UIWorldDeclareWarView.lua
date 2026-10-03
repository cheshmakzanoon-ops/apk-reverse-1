local UIWorldDeclareWarView = BaseClass("UIWorldDeclareWarView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIDeclareWarAlliItem = require("UI.UIWorldDeclareWar.Component.UIDeclareWarAlliItem")
local title_path = "UICommonMiniPopUpTitle/titleText"
local close_path = "UICommonMiniPopUpTitle/CloseBtn"
local return_path = "UICommonMiniPopUpTitle/panel"
local declare_num_path = "Root/top/declareNum"
local city_icon_path = "Root/top/cityIcon"
local city_name_path = "Root/top/cityName"
local btn_tips1_path = "Root/top/Btn_Tips1"
local pre_declare_path = "Root/mid/preDeclare"
local local_time_path = "Root/mid/localTime"
local time_zone_btn_path = "Root/mid/localTime/Btn_toggleTime"
local btn_tips2_path = "Root/mid/preDeclare/Btn_Tips2"
local min_txt_path = "Root/mid/preDeclare/Min/minTxt"
local hour_txt_path = "Root/mid/preDeclare/Hour/hourTxt"
local date_txt_path = "Root/mid/preDeclare/Date/dateTxt"
local instant_path = "Root/mid/instant"
local btn_tips3_path = "Root/bot/Btn_Tips3"
local input_field_path = "Root/bot/InputField"
local txt_declare_path = "Root/Txt_Declare"
local btn_create_declare_path = "Root/Btn_CreateDeclare"
local bubble_path = "Root/bubble"
local scroll_view_path = "Root/bubble/bubbleBg/ScrollView"
local alliance_item_path = "Root/bubble/bubbleBg/ScrollView/Viewport/Content/AllianceItem"
local nobody_path = "Root/bubble/bubbleBg/nobody"
local content_path = "Root/bubble/bubbleBg/ScrollView/Viewport/Content"
local player_head_path = "Root/bot/PlayerHead/UIPlayerHead"
local member_txt_path = "Root/bot/Image/memberTxt"
local occupy_txt_path = "Root/top/occupyTxt"
local occupy_img_path = "Root/top/Image (1)"

function UIWorldDeclareWarView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function UIWorldDeclareWarView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIWorldDeclareWarView:ComponentDefine()
  self._title_txt = self:AddComponent(UITextMeshProUGUIEx, title_path)
  self._close_btn = self:AddComponent(UIButton, close_path)
  self._return_btn = self:AddComponent(UIButton, return_path)
  self._close_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self.ctrl:CloseSelf()
  end)
  self._return_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self.ctrl:CloseSelf()
  end)
  self.declare_num = self:AddComponent(UITextMeshProUGUIEx, declare_num_path)
  self.city_icon = self:AddComponent(UIImage, city_icon_path)
  self.city_name = self:AddComponent(UITextMeshProUGUIEx, city_name_path)
  self.btn_tips1 = self:AddComponent(UIButton, btn_tips1_path)
  self.btn_tips1:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnClickTips1()
  end)
  self.pre_declare = self:AddComponent(UIBaseContainer, pre_declare_path)
  self.local_time = self:AddComponent(UITextMeshProUGUIEx, local_time_path)
  self.time_zone_btn = self:AddComponent(UIButton, time_zone_btn_path)
  self.time_zone_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:ChangeShowTimeBtnClick()
  end)
  self.btn_tips2 = self:AddComponent(UIButton, btn_tips2_path)
  self.btn_tips2:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnClickTips2()
  end)
  self.min_txt = self:AddComponent(UITextMeshProUGUIEx, min_txt_path)
  self.hour_txt = self:AddComponent(UITextMeshProUGUIEx, hour_txt_path)
  self.date_txt = self:AddComponent(UITextMeshProUGUIEx, date_txt_path)
  self.instant = self:AddComponent(UITextMeshProUGUIEx, instant_path)
  self.btn_tips3 = self:AddComponent(UIButton, btn_tips3_path)
  self.btn_tips3:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnClickTips3()
  end)
  self.input_field = self:AddComponent(UIInput, input_field_path)
  self.input_field:SetOnValueChange(function(value)
    self:IptOnValueChange(value)
  end)
  self.txt_declare = self:AddComponent(UITextMeshProUGUIEx, txt_declare_path)
  self.btn_create_declare = self:AddComponent(UIButton, btn_create_declare_path)
  self.btn_create_declare:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnClickWar()
  end)
  self.bubble = self:AddComponent(UIButton, bubble_path)
  self.bubble:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnClickBubble()
  end)
  self.scroll_view = self:AddComponent(UIBaseComponent, scroll_view_path)
  self.nobody = self:AddComponent(UITextMeshProUGUIEx, nobody_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.alliance_item = self.transform:Find(alliance_item_path).gameObject
  self.alliance_item:GameObjectCreatePool()
  self.alliance_item:SetActive(false)
  self.player_head = self:AddComponent(UICommonHead, player_head_path)
  self.member_txt = self:AddComponent(UITextMeshProUGUIEx, member_txt_path)
  self.occupy_txt = self:AddComponent(UITextMeshProUGUIEx, occupy_txt_path)
  self.occupy_image = self:AddComponent(UIImage, occupy_img_path)
end

function UIWorldDeclareWarView:ComponentDestroy()
  self.alliance_item = nil
  elf.occupy_image = nil
end

function UIWorldDeclareWarView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.BattleFieldChangeShowLocalTime, self.OnDesertBattleChangeShowLocalTime)
end

function UIWorldDeclareWarView:OnRemoveListener()
  self:RemoveUIListener(EventId.BattleFieldChangeShowLocalTime, self.OnDesertBattleChangeShowLocalTime)
  base.OnRemoveListener(self)
end

function UIWorldDeclareWarView:RemoveAlliItems()
  self.content:RemoveComponents(UIDeclareWarAlliItem)
  self.alliance_item:GameObjectRecycleAll()
end

function UIWorldDeclareWarView:DataDefine()
  self.cityId, self.pointId, self.uuid, self.serverId = self:GetUserData()
  self.k2 = DataCenter.AllianceDeclareWarManager:GetConfigData("k2")
  self.k3 = DataCenter.AllianceDeclareWarManager:GetConfigData("k3")
  self.k5 = DataCenter.AllianceDeclareWarManager:GetConfigData("k5")
  self.k6 = DataCenter.AllianceDeclareWarManager:GetConfigData("k6")
end

function UIWorldDeclareWarView:DataDestroy()
end

function UIWorldDeclareWarView:OnEnable()
  base.OnEnable(self)
end

function UIWorldDeclareWarView:OnDisable()
  base.OnDisable(self)
end

function UIWorldDeclareWarView:ReInit()
  local protectTime = self:GetPreDeclareWarTime()
  local now = UITimeManager:GetInstance():GetServerTime()
  local isPre = protectTime > now
  self.pre_declare:SetActive(isPre)
  self.instant:SetActive(not isPre)
  self.time_zone_btn:SetInteractable(isPre)
  self.time_zone_btn:SetActive(isPre)
  if isPre then
    self:OnDesertBattleChangeShowLocalTime()
  else
    self.local_time:SetLocalText("new_city_activity_battle_tips1063")
  end
  local warDataList = DataCenter.AllianceDeclareWarManager:GetWarDataByCityId(self.cityId)
  self.declare_num:SetLocalText("new_city_activity_battle_tips1007", #warDataList)
  self.btn_tips1:SetActive(0 < #warDataList)
  local timeDeclare = DataCenter.AllianceDeclareWarManager:GetDeclareTime()
  self.curNum = self.k6 - timeDeclare
  if self.curNum == nil or 0 > self.curNum then
    self.curNum = 0
  end
  if isPre then
    self.txt_declare:SetLocalText("new_city_activity_battle_tips1073")
  else
    self.txt_declare:SetLocalText("new_city_activity_battle_tips1011", timeDeclare .. "/" .. self.k6)
  end
  local cityTemplate = DataCenter.AllianceCityTemplateManager:GetTemplate(self.cityId)
  if cityTemplate == nil then
    return
  end
  self.city_icon:LoadSprite(cityTemplate:GetIconPath(false))
  local str = ""
  local level = cityTemplate.level
  local name = Localization:GetString(cityTemplate.name)
  local pos = self.pointId * 10 + 7
  local point = (pos - pos % 10) / 10
  str = Localization:GetString("140205", level, name)
  self.city_name:SetText(str)
  self._title_txt:SetLocalText("new_city_activity_battle_tips1006", Localization:GetString("300665", level), name)
  local randomTxt = {
    "new_city_activity_battle_tips1058",
    "new_city_activity_battle_tips1059",
    "new_city_activity_battle_tips1060"
  }
  local randomIndex = math.random(#randomTxt)
  local data = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
  local localeTxt = CS.GameEntry.Localization:GetString(randomTxt[randomIndex])
  local member = DataCenter.AllianceMemberDataManager:GetRandomMember()
  if member then
    self.player_head:SetHeadAndFrame(member.uid, member.pic, member.picVer, false, member.headSkinId, member.headSkinET)
    self.member_txt:SetText(string.format([[
[%s] %s
%s]], data.abbr, member.name, localeTxt))
  else
    self.player_head:SetAsMyself()
    self.member_txt:SetText(string.format([[
[%s] %s
%s]], data.abbr, LuaEntry.Player.name, localeTxt))
  end
  local allianceId = LuaEntry.Player:GetAllianceUid()
  local occupied, _ = DataCenter.AllianceCityTemplateManager:GetOccupiedCityList(allianceId, false)
  local cityMax = SeasonUtil.GetOccupyCityMaxCount()
  self.occupy_txt:SetText(#occupied .. "/" .. tostring(cityMax))
  local destroyMode = DataCenter.SeasonCampDestroyManager:IsEnemyServer(self.serverId)
  self.occupy_txt:SetActive(not destroyMode)
  self.occupy_image:SetActive(not destroyMode)
end

function UIWorldDeclareWarView:IptOnValueChange(value)
end

function UIWorldDeclareWarView:OnClickWar()
  if self:CheckValid(true) then
    local str = self.input_field:GetText()
    if str == "" then
      UIUtil.ShowTipsId(302330)
    else
      self:HandleBeforeDeclare(function()
        SFSNetwork.SendMessage(MsgDefines.AllianceDeclareWarCreate, 0, 0, tostring(self.cityId), str)
        self.ctrl:CloseSelf()
      end)
    end
  end
end

function UIWorldDeclareWarView:CheckValid(toast)
  local data = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
  if data.curMember < self.k5 then
    if toast then
      UIUtil.ShowTipsId(302323)
    end
    return false
  end
  if self.curNum <= 0 then
    if toast then
      UIUtil.ShowTipsId(302322)
    end
    return false
  end
  return true
end

function UIWorldDeclareWarView:HandleBeforeDeclare(declareAction)
  if DataCenter.UILWSeasonAllianceWarTimeManager:IsFuncOpen(false) then
    local pointInfo = CS.SceneManager.World:GetPointInfo(self.pointId)
    if pointInfo ~= nil then
      local extraInfo = SeasonUtil.TryParseAllianceCityPointInfo(pointInfo.PointType, pointInfo.extraInfo)
      if extraInfo ~= nil and not string.IsNullOrEmpty(extraInfo.allianceId) then
        local isWarTime, startTime, endTime = DataCenter.UILWSeasonAllianceWarTimeManager:IsAllianceWarTime(extraInfo.warTimeIndex)
        if isWarTime then
          local zeroTime = UITimeManager:GetInstance():GetTodayZero()
          endTime = zeroTime + endTime * 1000
          local leftTime = endTime - UITimeManager:GetInstance():GetServerTime()
          local minMax = math.ceil(leftTime / 60 / 1000)
          if minMax <= 15 then
            local tips = CS.GameEntry.Localization:GetString("s5_alliance_battle_time_tips06", minMax)
            
            local function leftCallback()
              if declareAction ~= nil then
                pcall(declareAction)
              end
            end
            
            local function rightCallback()
            end
            
            UIUtil.ShowMessage(tips, 2, GameDialogDefine.CANCEL, GameDialogDefine.CONFIRM, rightCallback, leftCallback)
          elseif declareAction ~= nil then
            pcall(declareAction)
          end
          return
        end
      end
    end
  end
  if declareAction ~= nil then
    pcall(declareAction)
  end
end

function UIWorldDeclareWarView:OnClickTips()
  local k5 = DataCenter.AllianceDeclareWarManager:GetConfigData("k5")
  local k6 = DataCenter.AllianceDeclareWarManager:GetConfigData("k6")
  if SeasonUtil.IsInSeason() then
    local msg = Localization:GetString("season_city_battle_tips002", k5, k6)
    UIUtil.ShowDetail(msg, nil, nil, true, true)
  else
    local msg = Localization:GetString("302324", k5, k6)
    UIUtil.ShowDetail(msg, nil, nil, true, true)
  end
end

function UIWorldDeclareWarView:OnClickTips1()
  self.bubble:SetActive(true)
  self:RemoveAlliItems()
  local warInfos = DataCenter.AllianceDeclareWarManager:GetWarDataByCityId(self.cityId)
  table.sort(warInfos, function(a, b)
    return a.power > b.power
  end)
  for i = 1, #warInfos do
    local item = self.alliance_item:GameObjectSpawn(self.content.transform)
    item.name = "UIDeclareWarAlliItem" .. i
    item.transform:SetParent(self.content.transform)
    local obj = self.content:AddComponent(UIDeclareWarAlliItem, item.name)
    obj:Refresh(warInfos[i])
  end
end

function UIWorldDeclareWarView:OnClickTips2()
end

function UIWorldDeclareWarView:OnClickTips3()
  UIUtil.ShowTipsId("new_city_activity_battle_tips1019")
end

function UIWorldDeclareWarView:OnClickBubble()
  self.bubble:SetActive(false)
end

function UIWorldDeclareWarView:ChangeShowTimeBtnClick()
  self.isShowLocalTime = not self.isShowLocalTime
  BattleFieldUtil.SetShowLocalTime(self.isShowLocalTime)
end

function UIWorldDeclareWarView:OnDesertBattleChangeShowLocalTime()
  self.isShowLocalTime = BattleFieldUtil.GetShowLocalTime()
  self:RefreshBattleTimeShow()
end

function UIWorldDeclareWarView:RefreshBattleTimeShow()
  local protectTime = self:GetPreDeclareWarTime()
  if self.isShowLocalTime then
    self.local_time:SetLocalText("new_city_activity_battle_tips1061")
    local year, month, date, hour, min = UITimeManager:GetInstance():TimeStampToServerTime(protectTime)
    self.date_txt:SetText(string.format("%s/%s", month, date))
    self.hour_txt:SetText(hour)
    self.min_txt:SetText(min)
  else
    self.local_time:SetLocalText("new_city_activity_battle_tips1062")
    local year, month, date, hour, min = UITimeManager:GetInstance():TimeStampToLocalTime(protectTime)
    self.date_txt:SetText(string.format("%s/%s", month, date))
    self.hour_txt:SetText(hour)
    self.min_txt:SetText(min)
  end
end

function UIWorldDeclareWarView:GetPreDeclareWarTime()
  local protectTime = DataCenter.WorldAllianceCityDataManager:GetCityProtectTime(self.cityId)
  protectTime = math.max(UITimeManager:GetInstance():GetServerTime(), protectTime)
  local seasonType = SeasonUtil.GetSeasonType()
  if seasonType == SeasonMapType.NineNation then
    local pointInfo = CS.SceneManager.World:GetPointInfo(self.pointId)
    if pointInfo ~= nil then
      local extraInfo = SeasonUtil.TryParseAllianceCityPointInfo(pointInfo.PointType, pointInfo.extraInfo)
      if extraInfo ~= nil then
        local hasOwner = checkstring(extraInfo.allianceId) ~= ""
        local warTimeIndex = checknumber(extraInfo.warTimeIndex)
        local startTime, _ = DataCenter.UILWSeasonAllianceWarTimeManager:GetNextWarTime(protectTime, warTimeIndex, true, hasOwner)
        return startTime
      end
    end
  end
  return protectTime
end

return UIWorldDeclareWarView
