local UIWorldLLCityBuffPoint = BaseClass("UIWorldLLCityBuffPoint", UIAsyncContainer)
local base = UIAsyncContainer
local Localization = CS.GameEntry.Localization
local lua_path_assistance = "UI.UIWorldPoint.Component.UIWorldPointNewOtherPlayerInfoAssistanceComp"
local info_speed_path = "infoSpeed"
local speed_tip_path = "infoSpeed/SpeedTip"
local speed_num_path = "infoSpeed/SpeedNum"
local speed_btn_path = "infoSpeed/SpeedBtn"
local info_buff_path = "infoBuff"
local buff_icon_path = "infoBuff/BuffIcon"
local buff_name_path = "infoBuff/BuffName"
local buff_desc_path = "infoBuff/BuffDesc"
local info_time_path = "infoTime"
local time_desc_path = "infoTime/TimeDesc"
local time_btn_path = "infoTime/TimeBtn"
local info_empty_path = "infoEmpty"
local empty_desc_path = "infoEmpty/EmptyDesc"
local info_occupy_path = "infoOccupy"
local no_occupy_desc_path = "infoOccupy/NoOccupyDesc"
local occupy_desc_path = "infoOccupy/OccupyDesc"
local occupy_detail_path = "infoOccupy/OccupyDesc/OccupyDetail"
local assistance_root_path = "assistanceRoot"
local COLOR_GREEN = Color.New(0.03529411764705882, 0.6078431372549019, 0.2901960784313726, 1)
local COLOR_BLACK = Color.New(0.16470588235294117, 0.1568627450980392, 0.18823529411764706, 1)

function UIWorldLLCityBuffPoint:OnCreate()
  base.OnCreate(self)
  self.info_speed = self:AddComponent(UIImage, info_speed_path)
  self.speed_tip = self:AddComponent(UITextMeshProUGUIEx, speed_tip_path)
  self.speed_num = self:AddComponent(UITextMeshProUGUIEx, speed_num_path)
  self.speed_btn = self:AddComponent(UIButton, speed_btn_path)
  self.speed_btn:SetOnClick(function()
  end)
  self.info_buff = self:AddComponent(UIBaseContainer, info_buff_path)
  self.buff_icon = self:AddComponent(UIImage, buff_icon_path)
  self.buff_name = self:AddComponent(UITextMeshProUGUIEx, buff_name_path)
  self.buff_desc = self:AddComponent(UITextMeshProUGUIEx, buff_desc_path)
  self.info_time = self:AddComponent(UIImage, info_time_path)
  self.time_desc = self:AddComponent(UITextMeshProUGUIEx, time_desc_path)
  self.time_btn = self:AddComponent(UIButton, time_btn_path)
  self.time_btn:SetOnClick(function()
    local param = {}
    param.type = "desc"
    param.title = ""
    param.desc = "zonewar_landlord_desc_1040"
    param.alignObject = self.time_btn
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
  end)
  if WorldBattleUtil.EnableShowWorldAssistanceInfo() then
    self.dCompAssistance = UIAsyncLoaderBridge.New(self, "dCompAssistance", self.transform:Find(assistance_root_path), UIAssets.UIWorldPointComp_PlayerAssistanceCompFat, lua_path_assistance)
  end
  self.info_empty = self:AddComponent(UIImage, info_empty_path)
  self.empty_desc = self:AddComponent(UITextMeshProUGUIEx, empty_desc_path)
  self.empty_desc:SetLocalText("zonewar_landlord_limit_1045")
  self.info_occupy = self:AddComponent(UIImage, info_occupy_path)
  self.no_occupy_desc = self:AddComponent(UITextMeshProUGUIEx, no_occupy_desc_path)
  self.occupy_desc = self:AddComponent(UITextMeshProUGUIEx, occupy_desc_path)
  self.occupy_detail = self:AddComponent(UITextMeshProUGUIEx, occupy_detail_path)
  self.no_occupy_desc:SetLocalText("801471")
  self.occupy_desc:SetLocalText("801472")
end

function UIWorldLLCityBuffPoint:OnDestroy()
  self.info_speed = nil
  self.speed_tip = nil
  self.speed_num = nil
  self.speed_btn = nil
  self.info_buff = nil
  self.buff_icon = nil
  self.buff_name = nil
  self.buff_desc = nil
  self.info_time = nil
  self.time_desc = nil
  self.time_btn = nil
  self.info_occupy = nil
  self.no_occupy_desc = nil
  self.occupy_desc = nil
  self.occupy_detail = nil
  if self.dCompAssistance then
    self.dCompAssistance:Delete()
    self.dCompAssistance = nil
  end
  base.OnDestroy(self)
end

function UIWorldLLCityBuffPoint:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.LandlordCityPointInfoUpdate, self.OnLandlordCityPointInfoUpdate)
end

function UIWorldLLCityBuffPoint:OnRemoveListener()
  self:RemoveUIListener(EventId.LandlordCityPointInfoUpdate, self.OnLandlordCityPointInfoUpdate)
  base.OnRemoveListener(self)
end

function UIWorldLLCityBuffPoint:OnLandlordCityPointInfoUpdate(uuid)
  if self.data and uuid == self.data.uuid then
    local data = self.view.ctrl:GetAllianceCityData()
    self:RefreshData(data)
  end
end

local BLUE_COLOR = Color.New(0.17254901960784313, 0.6549019607843137, 1, 1)

function UIWorldLLCityBuffPoint:RefreshData(pointData)
  self.data = pointData
  self.curState = self.data.clientState or LLConst.LLBuildingState.NotOpen
  self.template = self.data.landlordCityTemplate
  local buff = self.template.buff
  self.effects = {}
  if not string.IsNullOrEmpty(buff) then
    for _, pair in ipairs(string.split(buff, "|")) do
      local idStr, valStr = string.match(pair, "(.*)[;,](.*)")
      if idStr and valStr then
        table.insert(self.effects, {
          id = tonumber(idStr),
          value = tonumber(valStr)
        })
      end
    end
  end
  self:UpdateCurNum()
  local showTime = self.curState ~= LLConst.LLBuildingState.NotOpen and self.curState ~= LLConst.LLBuildingState.OpenButShield
  self.info_empty:SetActive(not showTime)
  self.info_time:SetActive(showTime)
  self.no_occupy_desc:SetActive(self.data.ownerCampId == LLConst.LandLordGroup.NONE)
  self.occupy_desc:SetActive(self.data.ownerCampId ~= LLConst.LandLordGroup.NONE)
  if self.data.ownerCampId ~= LLConst.LandLordGroup.NONE then
    self.occupy_detail:SetText(string.format("#%s %s", self.data.alServerId, self.data.alAbbr))
    local isAlly = DataCenter.LandlordMgr:IsSameGroupServer(self.data.alServerId)
    self.occupy_desc:SetColor(isAlly and BLUE_COLOR or RedColor)
    self.occupy_detail:SetColor(isAlly and BLUE_COLOR or RedColor)
  end
  local skillId = self.data.buffId
  if skillId == 0 then
    local tableName = DataCenter.LandlordMgr:GetCityTemplateTableName()
    skillId = GetTableData(tableName, self.data.cityId, "special_status")
  end
  local stateTemplate = DataCenter.StatusManager:GetTemplate(skillId)
  if stateTemplate then
    self.buff_icon:LoadSpriteAsync(stateTemplate.icon)
    self.buff_name:SetLocalText(stateTemplate.name)
    self.buff_desc:SetLocalText(stateTemplate.description, stateTemplate.effect_num, stateTemplate.time)
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.info_buff.rectTransform)
  self.endTime = self.data.refreshTime or 0
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.rectTransform)
  self:Update1000MS()
end

function UIWorldLLCityBuffPoint:UpdateCurNum()
  local myCampId = DataCenter.LandlordMgr:GetMyGroup()
  local effectId = myCampId == LLConst.LandLordGroup.LORD and LLConst.OccupySpeedEffectId[LLConst.LandLordGroup.LORD] or LLConst.OccupySpeedEffectId[LLConst.LandLordGroup.FARMER]
  local effectNum = 0
  table.walk(self.effects, function(k, v)
    if v.id == effectId then
      effectNum = v.value
    end
  end)
  local nameStr, effectNumStr = WorkerUtil.GetEffectText(effectId, effectNum, true)
  self.speed_tip:SetText(nameStr)
  self.speed_num:SetText(effectNumStr)
  self.speed_num:SetColor(COLOR_GREEN)
end

function UIWorldLLCityBuffPoint:Update1000MS()
  if self.data == nil then
    return
  end
  if self.endTime ~= nil then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local remainTime = math.max(self.endTime - curTime, 0)
    local key = "zonewar_landlord_limit_1086"
    self.time_desc:SetText(string.format([[
<size=24>%s</size>
%s]], Localization:GetString(key), UITimeManager:GetInstance():MilliSecondToFmtString(remainTime)))
  end
end

function UIWorldLLCityBuffPoint:RefreshAssistance(info)
  if not self.dCompAssistance then
    return
  end
  if not (info and info.assistanceList) or #info.assistanceList <= 0 then
    self.dCompAssistance:SetActive(false)
  else
    self.dCompAssistance:SetActive(true)
    self.dCompAssistance:Setup({
      isCity = true,
      pointId = self.data.pointId,
      cityId = info.cityId,
      assistanceList = info.assistanceList,
      maxMember = info.maxAssistance,
      memberCount = info.currAssistance,
      totalPower = info.assistanceTotalPower,
      limit = 10
    })
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.rectTransform)
end

return UIWorldLLCityBuffPoint
