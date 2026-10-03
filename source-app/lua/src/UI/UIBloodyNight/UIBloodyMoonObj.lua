local UIBloodyMoonObj = BaseClass("UIBloodyMoonObj", UIBaseContainer)
local base = UIBaseContainer
local SilentImgPath = "Assets/Main/SeasonRes/S4/Sprites/UI/BloodyNight/mjc_S4_xueye_mainUI_bg01.png"
local BloodyImgPath = "Assets/Main/SeasonRes/S4/Sprites/UI/BloodyNight/mjc_S4_xueye_mainUI_bg02.png"
local mask_path = "rotation/mask"
local u_i_player_head_path = "UIPlayerHead"
local moon_btn_path = "MoonBtn"
local time_path = "Time"
local text_path = "Text"
local mask1 = "Assets/Main/SeasonRes/S4/Sprites/UI/BloodyNight/mjc_S3_xueye_zhujiemian_yueliang_mask 1.png"
local mask2 = "Assets/Main/SeasonRes/S4/Sprites/UI/BloodyNight/mjc_S3_xueye_zhujiemian_yueliang_mask 2.png"

function UIBloodyMoonObj:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:Init()
end

function UIBloodyMoonObj:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIBloodyMoonObj:ComponentDefine()
  self.img_bg = self:AddComponent(UIImage, "")
  self.mask = self:AddComponent(UIImage, mask_path)
  self.u_i_player_head = self:AddComponent(UICommonHead, u_i_player_head_path)
  self.u_i_player_head:SetEnableClickShowInfo(true, true)
  self.moon_btn = self:AddComponent(UIButton, moon_btn_path)
  self.moon_btn:SetOnClick(function()
    UIUtil.CheckEventTrigger(OpMode.ClickBtnBloodyNight, nil, nil, nil, function()
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIBloodyNightPopup, {anim = true})
    end)
  end)
  self.time = self:AddComponent(UITextMeshProUGUIEx, time_path)
  self.text = self:AddComponent(UITextMeshProUGUIEx, text_path)
end

function UIBloodyMoonObj:ComponentDestroy()
  self.mask = nil
  self.u_i_player_head = nil
  self.moon_btn = nil
  self.time = nil
  self.text = nil
  self.img_bg = nil
end

function UIBloodyMoonObj:OnEnable()
  base.OnEnable(self)
end

function UIBloodyMoonObj:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.BloodyNightActivityRefresh, self.OnBloodyNightActivityRefresh)
end

function UIBloodyMoonObj:OnRemoveListener()
  self:RemoveUIListener(EventId.BloodyNightActivityRefresh, self.OnBloodyNightActivityRefresh)
  base.OnRemoveListener(self)
end

function UIBloodyMoonObj:OnBloodyNightActivityRefresh(serverId)
  if serverId == LuaEntry.Player:GetSelfServerId() then
    self:Refresh()
  end
end

function UIBloodyMoonObj:Refresh()
  local state, BNTemplate, startTime, endTime, nightStalker = DataCenter.BloodyNightDataManager:GetBloodyNightState()
  if state == BloodyNightState.None then
    self:SetActive(false)
    return
  end
  local imgPath = SilentImgPath
  if state == BloodyNightState.Bloody then
    imgPath = BloodyImgPath
  end
  self.img_bg:LoadSprite(imgPath)
  self:SetActive(true)
  self.u_i_player_head:SetActive(false)
  if state == BloodyNightState.Bloody then
    if nightStalker then
      self.u_i_player_head:SetActive(true)
      self.u_i_player_head:SetHeadAndFrame(nightStalker.uid, nightStalker.pic, nightStalker.picVer, nil, nightStalker.headSkinId, nightStalker.headSkinET)
      self.text:SetText(UIUtil.FormatServerAllianceName(nightStalker.serverId, nightStalker.abbr, nightStalker.name, nightStalker.uid))
    else
      self.text:SetLocalText("season_s4_activity_1200009_name")
    end
  elseif state == BloodyNightState.Silent then
    self.text:SetLocalText("season_s4_activity_1200009_desc2")
  end
  self.state = state
  self.endTime = endTime
  self.startTime = startTime
  self:Update1000MS()
end

function UIBloodyMoonObj:Init()
  if CommonUtil.ArabicAutoMirrorFactor() < 0 then
    self.mask:LoadSprite(mask2)
  else
    self.mask:LoadSprite(mask1)
  end
end

function UIBloodyMoonObj:Update1000MS()
  if not self.endTime or not self.time then
    return
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  local remain = UITimeManager:GetInstance():MilliSecondToFmtString(self.endTime - now)
  self.time:SetText(remain)
  local progress = 1
  if self.state == BloodyNightState.Silent then
    progress = (now - self.startTime) / (self.endTime - self.startTime)
  end
  progress = Mathf.Clamp(progress, 0, 1)
  local size = progress * 400 + 120
  self.mask:SetSizeDeltaXY(size, size)
end

return UIBloodyMoonObj
