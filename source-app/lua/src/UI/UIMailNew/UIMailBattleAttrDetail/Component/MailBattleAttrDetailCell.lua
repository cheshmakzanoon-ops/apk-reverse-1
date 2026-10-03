local UIHeroTipView = require("UI.UIHero2.UIHeroTip.View.UIHeroTipView")
local MailBattleAttrDetailCell = BaseClass("MailBattleAttrDetailCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local txt_left_path = "txt_left"
local txt_center_path = "txt_center"
local txt_right_path = "txt_right"
local left_btn_path = "txt_left/leftBtnInfo"
local right_btn_path = "txt_right/rightBtnInfo"

function MailBattleAttrDetailCell:OnCreate()
  base.OnCreate(self)
  self.txt_left = self:AddComponent(UIText, txt_left_path)
  self.txt_center = self:AddComponent(UIText, txt_center_path)
  self.txt_right = self:AddComponent(UIText, txt_right_path)
  self._leftBtnInfo = self:AddComponent(UIButton, left_btn_path)
  self._leftBtnInfo:SetOnClick(BindCallback(self, self.OnLeftInfoClick))
  self._rightBtnInfo = self:AddComponent(UIButton, right_btn_path)
  self._rightBtnInfo:SetOnClick(BindCallback(self, self.OnRightInfoClick))
end

function MailBattleAttrDetailCell:ReInit(param, reasonType, usePercent)
  self.usePercent = usePercent
  if reasonType == GameEffectReason.Building then
    self.txt_center:SetText(Localization:GetString("310148"))
  elseif reasonType == GameEffectReason.Science then
    self.txt_center:SetText(Localization:GetString("100025"))
  elseif reasonType == GameEffectReason.Alliance_Science then
    self.txt_center:SetText(Localization:GetString("390148"))
  elseif reasonType == GameEffectReason.Hero then
    self.txt_center:SetText(Localization:GetString("100275"))
  elseif reasonType == GameEffectReason.VIP then
    self.txt_center:SetText(Localization:GetString("320222"))
  elseif reasonType == GameEffectReason.Status then
    self.txt_center:SetText(Localization:GetString("320243"))
  elseif reasonType == GameEffectReason.World_Alliance_City then
    self.txt_center:SetText(Localization:GetString("300724"))
  elseif reasonType == GameEffectReason.Tank then
    self.txt_center:SetText(Localization:GetString("100398"))
  elseif reasonType == GameEffectReason.Career then
    self.txt_center:SetText(Localization:GetString("395000"))
  elseif reasonType == GameEffectReason.Alliance_Career then
    self.txt_center:SetText(Localization:GetString("395003"))
  elseif reasonType == GameEffectReason.FormationBuff then
    self.txt_center:SetText(Localization:GetString("150221"))
  elseif reasonType == GameEffectReason.FormationRestraintValue then
    self.txt_center:SetText(Localization:GetString("163134"))
  elseif reasonType == GameEffectReason.BASE_TALENT then
    self.txt_center:SetText(Localization:GetString("131000"))
  elseif reasonType == GameEffectReason.HERO_OFFICIAL then
    self.txt_center:SetText(Localization:GetString("133000"))
  elseif reasonType == GameEffectReason.ARTIFACT then
    self.txt_center:SetText(Localization:GetString("135000"))
  else
    self.txt_center:SetText("")
  end
  self.leftData = param.leftData
  self.rightData = param.rightData
  if self.leftData.totalNum > self.rightData.totalNum then
    self.txt_left:SetColor(GreenColor)
  elseif self.leftData.totalNum < self.rightData.totalNum then
    self.txt_left:SetColor(WorldRedColor)
  else
    self.txt_left:SetColorRGBA(0.7176471, 0.4, 0.1882353, 1)
  end
  if usePercent == true then
    self.txt_left:SetText(string.GetFormattedPercentStr(self.leftData.totalNum / 100))
    self.txt_right:SetText(string.GetFormattedPercentStr(self.rightData.totalNum / 100))
  else
    self.txt_left:SetText(string.GetFormattedSeperatorNum(math.floor(self.leftData.totalNum)))
    self.txt_right:SetText(string.GetFormattedSeperatorNum(math.floor(self.rightData.totalNum)))
  end
  self._leftBtnInfo:SetActive(table.count(self.leftData.totalReason) > 0)
  self._rightBtnInfo:SetActive(table.count(self.rightData.totalReason) > 0)
end

function MailBattleAttrDetailCell:OnLeftInfoClick()
  local strList = {}
  local desDialog = ""
  local mixNum = 0
  local mixDialog = ""
  for k, v in pairs(self.leftData.totalReason) do
    if v.addNum ~= nil and 0 < v.addNum then
      if v.effectId == 35001 or v.effectId == 35002 or v.effectId == 35003 then
        mixNum = mixNum + v.addNum
        if mixDialog == "" then
          mixDialog = Localization:GetString("163149")
        end
        if desDialog == "" then
          desDialog = Localization:GetString("163155")
        end
      elseif v.effectId == 35005 or v.effectId == 35006 or v.effectId == 35007 then
        mixNum = mixNum + v.addNum
        if mixDialog == "" then
          mixDialog = Localization:GetString("163150")
        end
        if desDialog == "" then
          desDialog = Localization:GetString("163156")
        end
      elseif v.effectId == 35013 or v.effectId == 35014 or v.effectId == 35015 then
        mixNum = mixNum + v.addNum
        if mixDialog == "" then
          mixDialog = Localization:GetString("163151")
        end
        if desDialog == "" then
          desDialog = Localization:GetString("163157")
        end
      else
        local msg = ""
        if self.usePercent == true then
          msg = Localization:GetString(v.dialog) .. ": " .. string.GetFormattedPercentStr(v.addNum / 100)
          table.insert(strList, msg)
        else
          msg = Localization:GetString(v.dialog) .. ": " .. string.GetFormattedSeperatorNum(math.floor(v.addNum))
          table.insert(strList, msg)
        end
      end
    end
  end
  if 0 < mixNum and desDialog ~= "" and mixDialog ~= "" then
    local msg = ""
    if self.usePercent == true then
      msg = mixDialog .. ": " .. string.GetFormattedPercentStr(mixNum / 100)
      table.insert(strList, msg)
    else
      msg = mixDialog .. ": " .. string.GetFormattedSeperatorNum(math.floor(mixNum))
      table.insert(strList, msg)
    end
    msg = "\226\128\148\226\128\148\226\128\148\226\128\148\226\128\148\226\128\148\226\128\148\226\128\148\226\128\148\226\128\148" .. "\n" .. desDialog
    table.insert(strList, msg)
  end
  if 0 < #strList then
    local msg = ""
    for i = 1, #strList do
      msg = msg .. strList[i]
      if i < #strList then
        msg = msg .. "\n"
      end
    end
    local scaleFactor = UIManager:GetInstance():GetScaleFactor()
    local position = self._leftBtnInfo.transform.position + Vector3.New(0, 15, 0) * scaleFactor
    local param = UIHeroTipView.Param.New()
    param.content = msg
    param.dir = UIHeroTipView.Direction.ABOVE
    param.defWidth = 300
    param.pivot = 0.25
    param.position = position
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, {anim = false}, param)
  end
end

function MailBattleAttrDetailCell:OnRightInfoClick()
  local strList = {}
  local desDialog = ""
  local mixNum = 0
  local mixDialog = ""
  for k, v in pairs(self.rightData.totalReason) do
    if v.addNum ~= nil and 0 < v.addNum then
      if v.effectId == 35001 or v.effectId == 35002 or v.effectId == 35003 then
        mixNum = mixNum + v.addNum
        if mixDialog == "" then
          mixDialog = Localization:GetString("163149")
        end
        if desDialog == "" then
          desDialog = Localization:GetString("163155")
        end
      elseif v.effectId == 35005 or v.effectId == 35006 or v.effectId == 35007 then
        mixNum = mixNum + v.addNum
        if mixDialog == "" then
          mixDialog = Localization:GetString("163150")
        end
        if desDialog == "" then
          desDialog = Localization:GetString("163156")
        end
      elseif v.effectId == 35013 or v.effectId == 35014 or v.effectId == 35015 then
        mixNum = mixNum + v.addNum
        if mixDialog == "" then
          mixDialog = Localization:GetString("163151")
        end
        if desDialog == "" then
          desDialog = Localization:GetString("163157")
        end
      else
        local msg = ""
        if self.usePercent == true then
          msg = Localization:GetString(v.dialog) .. ": " .. string.GetFormattedPercentStr(v.addNum / 100)
          table.insert(strList, msg)
        else
          msg = Localization:GetString(v.dialog) .. ": " .. string.GetFormattedSeperatorNum(math.floor(v.addNum))
          table.insert(strList, msg)
        end
      end
    end
  end
  if 0 < mixNum and desDialog ~= "" and mixDialog ~= "" then
    local msg = ""
    if self.usePercent == true then
      msg = mixDialog .. ": " .. string.GetFormattedPercentStr(mixNum / 100)
      table.insert(strList, msg)
    else
      msg = mixDialog .. ": " .. string.GetFormattedSeperatorNum(math.floor(mixNum))
      table.insert(strList, msg)
    end
    msg = "\226\128\148\226\128\148\226\128\148\226\128\148\226\128\148\226\128\148\226\128\148\226\128\148\226\128\148\226\128\148" .. "\n" .. desDialog
    table.insert(strList, msg)
  end
  if 0 < #strList then
    local msg = ""
    for i = 1, #strList do
      msg = msg .. strList[i]
      if i < #strList then
        msg = msg .. "\n"
      end
    end
    local scaleFactor = UIManager:GetInstance():GetScaleFactor()
    local position = self._rightBtnInfo.transform.position + Vector3.New(0, 15, 0) * scaleFactor
    local param = UIHeroTipView.Param.New()
    param.content = msg
    param.dir = UIHeroTipView.Direction.ABOVE
    param.defWidth = 300
    param.pivot = 0.75
    param.position = position
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, {anim = false}, param)
  end
end

return MailBattleAttrDetailCell
