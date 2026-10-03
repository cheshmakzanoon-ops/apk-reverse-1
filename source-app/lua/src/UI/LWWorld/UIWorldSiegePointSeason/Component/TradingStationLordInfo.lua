local base = UIAsyncContainer
local TradingStationLordInfo = BaseClass("TradingStationLordInfo", base)
local ResourceManager = CS.GameEntry.Resource
local Localization = CS.GameEntry.Localization
local lord_des_path = "lordDes"
local player_head_path = "headParent/UIPlayerHead"
local empty_path = "empty"
local record_btn_path = "recordBtn"
local lord_title_path = "headParent/lordTitle"

function TradingStationLordInfo:OnCreate()
  base.OnCreate(self)
  self.lordHead = self:AddComponent(UICommonHead, player_head_path)
  self.lord_des = self:AddComponent(UITextMeshProUGUIEx, lord_des_path)
  self.empty = self:AddComponent(UIBaseContainer, empty_path)
  self.lord_title = self:AddComponent(UIImage, lord_title_path)
  self.empty:SetActive(true)
  self.lordHead:SetActive(false)
  self.empty:SetLocalScaleXYZ(0.6, 0.6, 0.6)
  self.record_btn = self:AddComponent(UIButton, record_btn_path)
  self.record_btn:SetOnClick(function()
    local serverId = LuaEntry.Player:GetCurServerId()
    local tradeId = self.data.tradeData.tradeId
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWTradeStationRecord, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    }, {tradeId = tradeId, serverId = serverId})
  end)
end

function TradingStationLordInfo:OnDestroy()
  self.lord_des = nil
  self.lordHead = nil
  self.empty = nil
  self.record_btn = nil
  self.lord_title = nil
  base.OnDestroy(self)
end

function TradingStationLordInfo:ReInit()
  self:UpdateData()
end

function TradingStationLordInfo:SetData(data)
  self.data = data
  self:UpdateData()
end

function TradingStationLordInfo:UpdateData()
  if IsNull(self.gameObject) or self.data == nil or self.data.tradeData == nil then
    return
  end
  if self.data.tradeData:HasLord() then
    self.empty:SetActive(false)
    self.lordHead:SetActive(true)
    self.lordHead:SetEnableClickShowInfo(true)
    self.lordHead:SetHeadAndFrame(self.data.tradeData.uid, self.data.tradeData.pic, self.data.tradeData.picVer, false, nil, nil)
    self.lord_des:SetText(UIUtil.FormatServerAllianceName(self.data.tradeData.serverId, self.data.tradeData.alAbbr, self.data.tradeData.lordName))
    self.lord_title:SetActive(true)
    local tradeId = self.data.tradeData.tradeId
    local cityMeta = DataCenter.AllianceCityTemplateManager:GetTemplate(tradeId, LuaEntry.Player:GetCurServerId())
    if cityMeta and not string.IsNullOrEmpty(cityMeta.lord_cap) then
      self.lord_title:LoadSpriteAsyncEx(cityMeta.lord_cap)
    else
      self.lord_title:SetActive(false)
    end
  else
    self.lord_title:SetActive(false)
    self.empty:SetActive(true)
    self.lordHead:SetActive(false)
    self.lord_des:SetLocalText("season_s3_trade_city005")
  end
end

return TradingStationLordInfo
