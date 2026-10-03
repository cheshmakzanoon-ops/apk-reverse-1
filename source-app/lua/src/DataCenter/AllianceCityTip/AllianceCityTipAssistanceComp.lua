local base = require("DataCenter.AllianceCityTip.AllianceCityTipBaseClass")
local AllianceCityTipAssistanceComp = BaseClass("AllianceCityTipAssistanceComp", base)
local assistance_root_path = "AssistanceRoot"
local assitance_icon_path = "AssistanceRoot/AssitanceIcon"
local assistance_count_path = "AssistanceRoot/AssistanceCount"
local assistance_bg_path = "AssistanceRoot/AssistanceBg"

function AllianceCityTipAssistanceComp:__init(gameObject)
  base.__init(self, gameObject)
  self.assistanceRoot = self.transform:Find(assistance_root_path).gameObject
  self.assistanceCount = self.transform:Find(assistance_count_path):GetComponent(typeof(CS.TextMeshProEx))
  self.assistanceIcon = self.transform:Find(assitance_icon_path):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  self.assistanceIconTran = self.assistanceIcon.transform
  self.spAssistanceBg = self.transform:Find(assistance_bg_path):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  self.isVisible = nil
  self.iconPath = nil
end

function AllianceCityTipAssistanceComp:__delete()
  base.__delete(self)
end

local normalColor = Color.New(1, 1, 1, 1)
local redColor = Color.New(0.9490196078431372, 0.1607843137254902, 0.1843137254901961, 1)
local myAssistanceIcon = "Assets/Main/Sprites/LodIcon/wxy_dashijie_zhufang_zhushouwo.png"
local otherAssistanceIcon = "Assets/Main/Sprites/LodIcon/wxy_dashijie_zhufang_zhushou.png"

function AllianceCityTipAssistanceComp:UpdateAssistanceInfo(force)
  if not self.data then
    self.assistanceRoot:SetActive(false)
    return
  end
  if not self.isVisible and not force then
    return
  end
  local pointId = self.data:GetPointId()
  local pointInfo = self.data:GetPointInfo()
  local myAssistance = CS.SceneManager.World:GetMyAssistanceCount(pointId)
  local _count = pointInfo and pointInfo.assistanceCount or 0
  if 0 < _count then
    local _maxCount = pointInfo.maxAssistanceCount or 0
    self.assistanceRoot:SetActive(true)
    self.assistanceCount.text = string.format("%s/%s", _count, _maxCount)
    local color = _count >= _maxCount and redColor or normalColor
    self.assistanceCount.color = color
    local labelWidth = self.assistanceCount.preferredWidth
    local iconWidth = 0.4
    local gap = 0
    local totalWidth = labelWidth + iconWidth + gap
    local labelX = iconWidth + gap + labelWidth * 0.5 - totalWidth * 0.5
    local iconX = iconWidth * 0.5 - totalWidth * 0.5
    self.assistanceCount.transform.localPosition = Vector3.New(labelX, 0, 0)
    self.assistanceIconTran.localPosition = Vector3.New(iconX, 0, 0)
    self.spAssistanceBg.size = Vector2.New(totalWidth + 0.1, 0.35)
    local _iconPath = 0 < myAssistance and myAssistanceIcon or otherAssistanceIcon
    if self.iconPath ~= _iconPath then
      self.assistanceIcon:LoadSprite(_iconPath)
      self.iconPath = _iconPath
    end
  else
    self.assistanceRoot:SetActive(false)
  end
end

function AllianceCityTipAssistanceComp:SetLod(lod)
  base.SetLod(self, lod)
  self:UpdateAssistanceInfo(true)
  self.isVisible = lod <= 5
  if not self.isVisible then
    self.assistanceRoot:SetActive(false)
    return
  end
end

function AllianceCityTipAssistanceComp:CheckLod(lod)
  base.CheckLod(self, lod)
  local lastVisible = self.isVisible
  self.isVisible = lod <= 5
  if not self.isVisible then
    self.assistanceRoot:SetActive(false)
    return
  end
  if self.isVisible and not lastVisible then
    self:UpdateAssistanceInfo()
  end
end

function AllianceCityTipAssistanceComp:DoRefresh()
end

return AllianceCityTipAssistanceComp
