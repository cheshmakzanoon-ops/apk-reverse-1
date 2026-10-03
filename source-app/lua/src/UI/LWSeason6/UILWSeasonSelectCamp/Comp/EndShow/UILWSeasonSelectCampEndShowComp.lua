local p_text_show_result_path = "content_leader/img/p_text_show_result"
local p_btn_ppt_path = "btns/p_btn_ppt"
local p_btn_record_path = "btns/p_btn_record"
local p_comp_member_path = "content_leader/img/p_comp_member_%s"
local p_img_result_path = "content_leader/img/p_img_result_%s"
local p_area_path = "content_map/p_area_%s"
local UILWSeasonSelectCampMemberComp = require("UI.LWSeason6.UILWSeasonSelectCamp.Comp.Select.UILWSeasonSelectCampMemberComp")
local UILWSeasonSelectCampAreaComp = require("UI.LWSeason6.UILWSeasonSelectCamp.Comp.EndShow.UILWSeasonSelectCampAreaComp")
local base = UIBaseContainer
local UILWSeasonSelectCampEndShowComp = BaseClass("UILWSeasonSelectCampEndShowComp", UIBaseContainer)

function UILWSeasonSelectCampEndShowComp:ComponentDefine()
  self.p_text_show_result = self:AddComponent(UITextMeshProUGUIEx, p_text_show_result_path)
  self.p_btn_ppt = self:AddComponent(UIButton, p_btn_ppt_path)
  self.p_btn_ppt:SetOnClick(BindCallback(self, self.OnPptClicked))
  self.p_btn_record = self:AddComponent(UIButton, p_btn_record_path)
  self.p_btn_record:SetOnClick(BindCallback(self, self.OnRecordClicked))
  self.p_comp_member = {}
  self.p_img_result = {}
  self.p_comp_area = {}
  for i = 1, 2 do
    self.p_comp_member[i] = self:AddComponent(UILWSeasonSelectCampMemberComp, string.format(p_comp_member_path, i))
    self.p_img_result[i] = self:AddComponent(UIImage, string.format(p_img_result_path, i))
  end
  for i = 1, 9 do
    if i ~= 5 then
      self.p_comp_area[i] = self:AddComponent(UILWSeasonSelectCampAreaComp, string.format(p_area_path, i))
    end
  end
end

function UILWSeasonSelectCampEndShowComp:ComponentDestroy()
  self.p_text_server_no = nil
  self.p_comp_member = nil
  self.p_img_result = nil
  self.p_text_show_result = nil
  self.p_btn_ppt = nil
  self.p_btn_record = nil
end

function UILWSeasonSelectCampEndShowComp:DataDefine()
end

function UILWSeasonSelectCampEndShowComp:DataDestroy()
end

function UILWSeasonSelectCampEndShowComp:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWSeasonSelectCampEndShowComp:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonSelectCampEndShowComp:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonSelectCampInfoUpdate, self.OnGetInfoEvt)
end

function UILWSeasonSelectCampEndShowComp:OnRemoveListener()
  self:RemoveUIListener(EventId.SeasonSelectCampInfoUpdate, self.OnGetInfoEvt)
  base.OnRemoveListener(self)
end

function UILWSeasonSelectCampEndShowComp:ReInit(data)
  if self:InitData(data) then
    self:InitUi()
    if self:UpdateData() then
      self:UpdateUi()
    end
  end
end

function UILWSeasonSelectCampEndShowComp:InitData(data)
  return true
end

function UILWSeasonSelectCampEndShowComp:InitUi()
end

function UILWSeasonSelectCampEndShowComp:UpdateData()
  self.Info = DataCenter.SeasonSelectCampManager.InfoData
  if self.Info ~= nil then
    self.LeftCamp = self.Info.LeftCamp
    self.RightCamp = self.Info.RightCamp
    return self.LeftCamp ~= nil and self.RightCamp ~= nil
  end
end

function UILWSeasonSelectCampEndShowComp:UpdateUi()
  local leftResult = self.LeftCamp.ResultId
  local rightResult = self.RightCamp.ResultId
  if leftResult == 1 then
    local leftData = {}
    leftData.ServerData = self.LeftCamp.LeaderServer
    leftData.AreaIndex = 1
    self.p_comp_member[1]:ReInit(leftData)
    local rightData = {}
    rightData.ServerData = self.RightCamp.LeaderServer
    rightData.AreaIndex = 2
    self.p_comp_member[2]:ReInit(rightData)
    self.p_img_result[1]:LoadSpriteAsync(self.Info:GetLeftResultIcon())
    self.p_img_result[2]:LoadSpriteAsync(self.Info:GetRightResultIcon())
    local resultStr = CS.GameEntry.Localization:GetString("season_s6_activity_1200080_desc04", table.unpack(self.LeftCamp:GetServerStrList()))
    self.p_text_show_result:SetText(resultStr)
  else
    local leftData = {}
    leftData.ServerData = self.RightCamp.LeaderServer
    leftData.AreaIndex = 1
    self.p_comp_member[1]:ReInit(leftData)
    local rightData = {}
    rightData.ServerData = self.LeftCamp.LeaderServer
    rightData.AreaIndex = 2
    self.p_comp_member[2]:ReInit(rightData)
    self.p_img_result[1]:LoadSpriteAsync(self.Info:GetRightResultIcon())
    self.p_img_result[2]:LoadSpriteAsync(self.Info:GetLeftResultIcon())
    local resultStr = CS.GameEntry.Localization:GetString("season_s6_activity_1200080_desc05", table.unpack(self.RightCamp:GetServerStrList()))
    self.p_text_show_result:SetText(resultStr)
  end
  self:SetServerPos()
end

function UILWSeasonSelectCampEndShowComp:SetPos(leftArr, rightArr)
  local orderStr = LuaEntry.DataConfig:TryGetStr("season_s6_camp_zone", "k1", "")
  local orderList = string.split(orderStr, "|")
  assert(table.count(orderList) == 8, "season_s6_camp_zone.k1 \233\133\141\231\189\174\230\149\176\233\135\143\228\184\141\228\184\186 8 \228\184\170, \232\129\148\231\179\187\228\189\179\232\177\170")
  local areaIndex = 0
  for i = 1, 4 do
    local leftAreaData = {}
    if i <= table.count(leftArr) then
      leftAreaData.AreaIndex = 1
      leftAreaData.ServerId = checknumber(leftArr[i])
      leftAreaData.Icon = ""
    end
    areaIndex = checknumber(orderList[i])
    self.p_comp_area[areaIndex]:ReInit(leftAreaData)
    local rightAreaData = {}
    if i <= table.count(rightArr) then
      rightAreaData.AreaIndex = 2
      rightAreaData.ServerId = checknumber(rightArr[i])
      rightAreaData.Icon = ""
    end
    areaIndex = checknumber(orderList[4 + i])
    self.p_comp_area[areaIndex]:ReInit(rightAreaData)
  end
end

function UILWSeasonSelectCampEndShowComp:SetServerPos()
  for _, comp in pairs(self.p_comp_area) do
    if comp then
      comp:SetActive(false)
    end
  end
  if self.Info ~= nil then
    local orderStr = LuaEntry.DataConfig:TryGetStr("season_s6_camp_zone", "k1", "")
    local orderList = string.split(orderStr, "|")
    local no = 1
    local noMap = {}
    for _, pos in pairs(orderList) do
      noMap[checknumber(pos)] = no
      no = no % 4 + 1
    end
    for serverId, zoneIndex in pairs(self.Info.ServerZone) do
      local areaData = {}
      areaData.AreaIndex = table.TryGetValue(self.Info.ServerCamp, serverId, 0)
      areaData.ServerId = checknumber(serverId)
      areaData.No = checknumber(noMap[zoneIndex])
      local areaComp = self.p_comp_area[zoneIndex]
      if areaComp then
        areaComp:SetActive(true)
        areaComp:ReInit(areaData)
      end
    end
  end
end

function UILWSeasonSelectCampEndShowComp:OnPptClicked()
  local actData = DataCenter.SeasonSelectCampManager:GetActData()
  if actData ~= nil and checknumber(actData.para) > 0 then
    local data = DataCenter.LWWorldTipManager:GetDataBySeason(checknumber(actData.para))
    if data ~= nil and 0 < table.count(data) then
      local param = {}
      param.dataTabGroup = data
      UIManager:GetInstance():OpenWindow(UIWindowNames.S6SelectCampIntroView, {anim = false}, param)
    end
  end
end

function UILWSeasonSelectCampEndShowComp:OnRecordClicked()
  if self.Info ~= nil and not table.IsNullOrEmpty(self.Info.Records) then
    UIManager:GetInstance():OpenWindow(UIWindowNames.S6SelectCampRecordsView, {anim = true})
  end
end

function UILWSeasonSelectCampEndShowComp:OnGetInfoEvt(evt)
  if self:UpdateData() then
    self:UpdateUi()
  end
end

return UILWSeasonSelectCampEndShowComp
