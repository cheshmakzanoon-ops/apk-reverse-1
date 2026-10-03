local base = UIBaseContainer
local UICampScienceDestroyRecordItem = BaseClass("UICampScienceDestroyRecordItem", base)
local txt_des_path = "Txt_Des"
local txt_time_path = "Txt_Time"
local btn_bg_path = "bg"
local img_bgColor_path = "bgColor"
local img_bgIcon_path = "bgIcon"

function UICampScienceDestroyRecordItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UICampScienceDestroyRecordItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UICampScienceDestroyRecordItem:ComponentDefine()
  self.txt_des = self:AddComponent(UITextMeshProUGUIEx, txt_des_path)
  self.txt_time = self:AddComponent(UIText, txt_time_path)
  self.btn_bg = self:AddComponent(UIButton, btn_bg_path)
  self.img_bgColor = self:AddComponent(UIImage, img_bgColor_path)
  self.img_bgIcon = self:AddComponent(UIImage, img_bgIcon_path)
end

function UICampScienceDestroyRecordItem:ComponentDestroy()
  self.txt_des = nil
  self.txt_time = nil
  self.btn_bg = nil
  self.img_bgColor = nil
  self.img_bgIcon = nil
end

function UICampScienceDestroyRecordItem:ReInit(data)
  local attackStr = "#" .. data.atkAlliance.serverId .. "[" .. data.atkAlliance.abbr .. "]"
  local defenceStr
  if data.defAlliance ~= nil then
    defenceStr = "#" .. data.defAlliance.serverId .. "[" .. data.defAlliance.abbr .. "]"
  else
    defenceStr = "#" .. data.cityServerId
  end
  local cityMgr = DataCenter.AllianceCityTemplateManager
  local sourceServerId = LuaEntry.Player:GetSourceServerId()
  local cityMeta = cityMgr:GetTemplate(toInt(data.cityId), sourceServerId)
  local pos = string.format("(#%d X:%d,Y:%d)", data.cityServerId, cityMeta.pos.x, cityMeta.pos.y)
  local resData = cityMeta:GetCampDestroyResOutput()
  if resData then
    self.txt_des:SetLocalText("season_camp_science_ui_24", attackStr, defenceStr, cityMeta.level, pos, resData.count or 0)
  end
  self.txt_time:SetText(UITimeManager:GetInstance():TimeStampToTimeForServer(data.destroyTime))
end

return UICampScienceDestroyRecordItem
