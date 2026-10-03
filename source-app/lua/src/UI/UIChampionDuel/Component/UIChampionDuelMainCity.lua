local UIChampionDuelMainCity = BaseClass("UIChampionDuelMainCity", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIDecorationMainCity = require("UI.UIDecoration.UIDecorationMain.Component.UIDecorationMainCity")
local UIDecorationHeadFrame = require("UI.UIDecoration.UIDecorationMain.Component.UIDecorationHeadFrame")
local mainCity_path = "MainCity"
local btn_mainCity_path = "BtnMain"
local headFrame_path = "HeadFrame/Head"
local power_icon_path = "HeadFrame/Icon"
local text_power_path = "HeadFrame/PowerText"
local text_tip_path = "TextTip"

function UIChampionDuelMainCity:OnCreate()
  base.OnCreate(self)
  self.side = 0
  self:ComponentDefine()
end

function UIChampionDuelMainCity:OnDestroy()
  self.side = 0
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIChampionDuelMainCity:ComponentDefine()
  self.mainCity = self:AddComponent(UIDecorationMainCity, mainCity_path)
  self.mainCity:SetActive(false)
  self.mainCity:SetRawDefRGBA(0, 0, 0, 0)
  self.btn_mainCity = self:AddComponent(UIButton, btn_mainCity_path)
  self.btn_mainCity:SetOnClick(BindCallback(self, self.OnClickInfoBtn))
  self.headFrame = self:AddComponent(UIDecorationHeadFrame, headFrame_path)
  self.power_icon = self:AddComponent(UIBaseContainer, power_icon_path)
  self.text_power = self:AddComponent(UIText, text_power_path)
  self.text_tip = self:AddComponent(UIText, text_tip_path)
end

function UIChampionDuelMainCity:ComponentDestroy()
  self.mainCity = nil
  self.btn_mainCity = nil
  self.headFrame = nil
  self.power_icon = nil
  self.text_power = nil
  self.text_tip = nil
  self.info = nil
end

function UIChampionDuelMainCity:OnClickInfoBtn()
  if self.info == nil then
    return
  end
  self.info:OnHeadClick()
end

function UIChampionDuelMainCity:SetPower(power)
  if power == nil or power == 0 then
    self.text_power:SetActive(false)
    self.power_icon:SetActive(false)
  else
    self.text_power:SetText(string.GetFormattedStr(math.floor(power)))
    self.text_power:SetActive(true)
    self.power_icon:SetActive(true)
  end
end

function UIChampionDuelMainCity:SetTip(tip)
  if string.IsNullOrEmpty(tip) then
    self.text_tip:SetActive(false)
  else
    self.text_tip:SetActive(true)
    self.text_tip:SetLocalText(tip)
  end
end

function UIChampionDuelMainCity:SetSide(side)
  self.side = side
end

function UIChampionDuelMainCity:ReInit(tip, hidePower)
  local currentSkinId = DataCenter.DecorationDataManager:GetCurrentSkinByType(DecorationType.DecorationType_TittleName)
  self.mainCity:SetActive(true)
  self.mainCity:ReInit({
    decorationId = currentSkinId,
    onLoad = function()
      local effectId = DataCenter.DecorationDataManager:GetCurrentSkinByType(DecorationType.DecorationType_Main_Effect)
      self.mainCity:ShowMainEffect(effectId)
    end
  })
  local frameId = DataCenter.DecorationDataManager:GetCurrentSkinByType(DecorationType.DecorationType_Head_Frame)
  self.headFrame:ReInit({
    decorationId = frameId,
    frame = DataCenter.DecorationDataManager:GetHeadFrame(frameId, LongMaxValue)
  })
  self:SetPower(hidePower and 0 or LuaEntry.Player.power)
  self:SetTip(tip)
end

function UIChampionDuelMainCity:ReInitWithInfo(teamInfo, tip, hidePower, hideTitle)
  self.info = teamInfo
  local titleId, mainId, frameId, effectId
  for _, v in pairs(teamInfo.skin) do
    if v.type == DecorationType.DecorationType_Main_City then
      mainId = v.skinId
    elseif v.type == DecorationType.DecorationType_Head_Frame then
      frameId = v.skinId
    elseif v.type == DecorationType.DecorationType_TittleName then
      titleId = v.skinId
    elseif v.type == DecorationType.DecorationType_Main_Effect then
      effectId = v.skinId
    end
  end
  if mainId == nil then
    mainId = DataCenter.DecorationDataManager:GetDefaultSkinIdByType(DecorationType.DecorationType_Main_City)
  end
  local name = teamInfo.name
  if teamInfo.robot then
    name = Localization:GetString(name)
  else
    name = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(teamInfo.uid, name)
  end
  self.mainCity:SetActive(true)
  self.mainCity:ReInit({
    decorationId = mainId,
    lv = teamInfo.lv,
    name = name,
    abbr = teamInfo.abbr,
    robot = teamInfo.robot,
    countryFlag = "",
    uid = teamInfo.uid,
    side = self.side,
    onLoad = function()
      if not hideTitle then
        if titleId == nil then
          titleId = DataCenter.DecorationDataManager:GetDefaultSkinIdByType(DecorationType.DecorationType_TittleName)
        end
        self.mainCity:LoadTitle(titleId)
      end
      if effectId == nil then
        effectId = DataCenter.DecorationDataManager:GetDefaultSkinIdByType(DecorationType.DecorationType_Main_Effect)
      end
      self.mainCity:ShowMainEffect(effectId)
    end
  })
  if frameId == nil then
    frameId = DataCenter.DecorationDataManager:GetDefaultSkinIdByType(DecorationType.DecorationType_Head_Frame)
  end
  self.headFrame:SetFrame(DataCenter.DecorationDataManager:GetHeadFrame(frameId, LongMaxValue))
  self.headFrame:SetHead(teamInfo.uid, teamInfo.head, teamInfo.frame)
  self:SetPower(hidePower and 0 or teamInfo:GetPower())
  self:SetTip(tip)
end

function UIChampionDuelMainCity:EnableClickInfo(bEnable)
  self.btn_mainCity:SetActive(bEnable)
end

function UIChampionDuelMainCity:HidePower()
  self:SetPower(teamInfo:GetPower())
end

return UIChampionDuelMainCity
