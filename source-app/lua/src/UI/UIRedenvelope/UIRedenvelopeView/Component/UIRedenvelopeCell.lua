local UIRedenvelopeCell = BaseClass("UIRedenvelopeCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local imgBg_path = "ImgBg"
local txt_playerName_path = "ImgBg/Txt_PlayerName"
local txt_title_path = "ImgBg/Txt_Title"
local txt_time_path = "ImgBg/Txt_Time"
local playerHead = "ImgBg/Rect_Head/UIPlayerHead/HeadIcon"
local playerHeadFg = "ImgBg/Rect_Head/UIPlayerHead/Foreground"
local btn_red_path = "ImgBg/Btn_OpenRed"
local gray_img_path = "ImgBg/gray"

local function OnCreate(self)
  base.OnCreate(self)
  self.imgBg = self:AddComponent(UIImage, imgBg_path)
  self.playerHead = self:AddComponent(UIPlayerHead, playerHead)
  self.playerHeadFg = self:AddComponent(UIImage, playerHeadFg)
  self._playerName_txt = self:AddComponent(UIText, txt_playerName_path)
  self._title_txt = self:AddComponent(UIText, txt_title_path)
  self._time_txt = self:AddComponent(UIText, txt_time_path)
  self._red_btn = self:AddComponent(UIButton, btn_red_path)
  self._red_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OpenRed()
  end)
  self.gray_image = self:AddComponent(UIImage, gray_img_path)
  self.gray = self.gray_image:GetMaterial()
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnDestroy(self)
  self.playerHead = nil
  self.playerHeadFg = nil
  self._playerName_txt = nil
  self._title_txt = nil
  self._time_txt = nil
  self._red_btn = nil
  self.gray_image = nil
  self.gray = nil
  self:DeleteTimer()
  self.timer_action = nil
  self.endTime = nil
  base.OnDestroy(self)
end

local function ReInit(self, index, data)
  self.data = data
  
  function self.timer_action(temp)
    self:RefreshTime()
  end
  
  if self.data.status == RedPacketState.ALREADY_GET or self.data.status == RedPacketState.COST_ALL then
    self.imgBg:SetMaterial(self.gray)
    self.imgBg:SetAlpha(0.8)
  else
    self.imgBg:SetMaterial(nil)
    self.imgBg:SetAlpha(1)
  end
  self.playerHead:SetData(self.data.uid, self.data.pic, self.data.picV)
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  self.playerHeadFg:SetActive(curTime < self.data.mCardET)
  local buildId = GetTableData(TableName.SysRedPacket, self.data.reasonId, "building")
  local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
  local lvConfig = GetTableData(TableName.SysRedPacket, self.data.reasonId, "level")
  self._title_txt:SetText(Localization:GetString("390900", Localization:GetString(buildTemplate.name), lvConfig))
  self._playerName_txt:SetText(self.data.name)
  local k1 = LuaEntry.DataConfig:TryGetNum("red_packet_time", "k1")
  self.endTime = self.data.time * 1000 + k1 * 3600 * 1000
  self._time_txt:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(self.endTime - curTime * 1000))
  self:AddTime()
end

local function AddTime(self)
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false, false, false)
  end
  self.timer:Start()
end

local function RefreshTime(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime >= self.endTime then
    self:DeleteTimer()
    DataCenter.AllianceRedPacketManager:UpdateStatusByUUid(self.data.uuid, RedPacketState.TIMEOUT)
  else
    self._time_txt:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(self.endTime - curTime))
  end
end

local function DeleteTimer(self)
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

local function OpenRed(self)
  self.view.ctrl:OpenRed(self.data)
end

UIRedenvelopeCell.OnCreate = OnCreate
UIRedenvelopeCell.OnDestroy = OnDestroy
UIRedenvelopeCell.OnEnable = OnEnable
UIRedenvelopeCell.OnDisable = OnDisable
UIRedenvelopeCell.ReInit = ReInit
UIRedenvelopeCell.AddTime = AddTime
UIRedenvelopeCell.RefreshTime = RefreshTime
UIRedenvelopeCell.DeleteTimer = DeleteTimer
UIRedenvelopeCell.OpenRed = OpenRed
return UIRedenvelopeCell
