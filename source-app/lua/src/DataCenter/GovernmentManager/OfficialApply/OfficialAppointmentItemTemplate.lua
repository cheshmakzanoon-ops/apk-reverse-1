local OfficialAppointmentItemTemplate = BaseClass("OfficialAppointmentItemTemplate")

local function __init(self)
  self.uid = ""
  self.name = ""
  self.pic = ""
  self.picver = 0
  self.headSkinId = 0
  self.headSkinET = 0
  self.abbr = ""
  self.appointTime = 0
  self.allianceId = ""
  self.state = 0
  self:AddListener()
end

local function __delete(self)
  self.uid = nil
  self.name = nil
  self.pic = nil
  self.picver = nil
  self.headSkinId = nil
  self.headSkinET = nil
  self.abbr = nil
  self.appointTime = nil
  self.allianceId = nil
  self.state = nil
  self:RemoveListener()
end

local function AddListener(self)
end

local function RemoveListener(self)
end

local function ParseData(self, msg)
  if msg == nil then
    return
  end
  self.uid = msg.uid
  self.name = msg.name
  self.pic = msg.pic
  self.picver = msg.picver
  self.headSkinId = msg.headSkinId
  self.headSkinET = msg.headSkinET
  self.abbr = msg.abbr
  self.appointTime = msg.appointTime
  self.allianceId = msg.allianceId
  self.state = msg.state
end

local function GetFullName(self, uid)
  local showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(uid, self.name)
  if string.IsNullOrEmpty(self.abbr) then
    return showName
  else
    return "[" .. self.abbr .. "] " .. showName
  end
end

OfficialAppointmentItemTemplate.__init = __init
OfficialAppointmentItemTemplate.__delete = __delete
OfficialAppointmentItemTemplate.AddListener = AddListener
OfficialAppointmentItemTemplate.RemoveListener = RemoveListener
OfficialAppointmentItemTemplate.ParseData = ParseData
OfficialAppointmentItemTemplate.GetFullName = GetFullName
return OfficialAppointmentItemTemplate
