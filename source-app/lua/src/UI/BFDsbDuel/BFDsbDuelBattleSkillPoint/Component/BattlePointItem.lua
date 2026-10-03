local base = UIBaseContainer
local BattlePointItem = BaseClass("BattlePointItem", base)
local icon_path = "Icon"
local name_text_path = "NameText"
local speed_text_path = "SpeedText"
local icon_score_path = "SpeedText/Icon"
local info_btn_path = "InfoBtn"

function BattlePointItem:OnCreate()
  base.OnCreate(self)
  self.icon = self:AddComponent(UIRawImage, icon_path)
  self.name_text = self:AddComponent(UITextMeshProUGUIEx, name_text_path)
  self.speed_text = self:AddComponent(UITextMeshProUGUIEx, speed_text_path)
  self.icon_score = self:AddComponent(UIImage, icon_score_path)
  self.info_btn = self:AddComponent(UIButton, info_btn_path)
  self.info_btn:SetOnClick(function()
    self:OnClickBtn()
  end)
end

function BattlePointItem:OnDestroy()
  self.icon = nil
  self.name_text = nil
  self.speed_text = nil
  self.icon_score = nil
  self.info_btn = nil
  self.cfgs = nil
  base.OnDestroy(self)
end

function BattlePointItem:OnClickBtn()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  if table.IsNullOrEmpty(self.cfgs) then
    return
  end
  if self.tipCb then
    self.tipCb(self.info_btn, self.cfgs)
  end
end

function BattlePointItem:ReInit(showId, scoreIcon, tipCb)
  if not string.IsNullOrEmpty(scoreIcon) then
    self.icon_score:LoadSpriteAuto(string.format(LoadPath.LWBattleFieldEpidemicPath, scoreIcon))
  end
  local tbName = DataCenter.BattlefieldDsbDuelManager:GetCfgValue(BattleFieldTableKey.P_POINT_ID)
  local line = LocalController:instance():getLine(tbName, showId)
  if line == nil then
    self.ids = nil
    self.tipCb = nil
    self.icon:SetActive(false)
    self.name_text:SetText("")
    self.speed_text:SetText("")
    return
  end
  self.tipCb = tipCb
  local iconPath = line:getValue("icon")
  if string.IsNullOrEmpty(iconPath) then
    self.icon:SetActive(false)
  else
    self.icon:SetActive(true)
    self.icon:LoadSpriteAuto(string.format(LoadPath.LWBattleFieldDsbDuelTexturePath, iconPath))
  end
  self.name_text:SetLocalText(line:getValue("name") or "")
  local ids = string.string2array_i_oneSep(line:getValue("score_detail"), ",")
  local min, max
  local list = {}
  for _, scoreId in ipairs(ids) do
    local cfg = LocalController:instance():getLine(TableName.Score, scoreId)
    if cfg then
      local points = cfg:getIntValue("points")
      table.insert(list, {
        name = cfg:getValue("name"),
        points = points
      })
      if min == nil or min > points then
        min = points
      end
      if max == nil or max < points then
        max = points
      end
    end
  end
  self.info_btn:SetActive(1 < #ids)
  if min == max then
    self.speed_text:SetText("+" .. min)
  else
    self.speed_text:SetText(min .. "-" .. max)
  end
  self.cfgs = list
end

return BattlePointItem
