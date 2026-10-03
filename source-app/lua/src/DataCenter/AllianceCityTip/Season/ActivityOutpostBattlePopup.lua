local PopupItem = BaseClass("ActivityOutpostBattlePopupItem", UIBaseContainer)
local ActivityOutpostBattlePopup = BaseClass("ActivityOutpostBattlePopup", UIAsyncContainer)
local base = UIAsyncContainer

function ActivityOutpostBattlePopup:OnCreate()
  base.OnCreate(self)
  self.txt_title = self:AddComponent(UITextMeshProUGUIEx, "txtTitle")
  self.data_list = self:AddComponent(UIButton, "DataList")
  self.row1 = self:AddComponent(PopupItem, "DataList/Row1")
  self.row2 = self:AddComponent(PopupItem, "DataList/Row2")
  self.row3 = self:AddComponent(PopupItem, "DataList/Row3")
  self.row4 = self:AddComponent(PopupItem, "DataList/Row4")
  self.row5 = self:AddComponent(PopupItem, "DataList/Row5")
  self.close_btn = self:AddComponent(UIButton, "closeBtn")
  self.close_btn:SetOnClick(function()
    self:SetActive(false)
  end)
  self.close_btn:SetActive(false)
  self.txt_title:SetLocalText("390261")
  self:AddUIListener(EventId.OnClickWorld, self.HideMyself)
  self:AddUIListener(EventId.HideMarchTip, self.HideMyself)
end

function ActivityOutpostBattlePopup:OnDestroy()
  self:RemoveUIListener(EventId.OnClickWorld, self.HideMyself)
  self:RemoveUIListener(EventId.HideMarchTip, self.HideMyself)
  self.txt_title = nil
  self.detail = nil
  self.close_btn = nil
  self.data_list = nil
  self.row1 = nil
  self.row2 = nil
  self.row3 = nil
  self.row4 = nil
  self.row5 = nil
  base.OnDestroy(self)
end

function ActivityOutpostBattlePopup:SetData(x, y, z, detail, max_score)
  self.posShow = Vector3.New(x - 45, y, z)
  self.detail = detail
  self.max_score = max_score
  self:UpdateData()
end

function ActivityOutpostBattlePopup:HideMyself()
  self:SetActive(false)
end

function ActivityOutpostBattlePopup:UpdateData()
  if IsNull(self.gameObject) then
    return
  end
  if self.posShow and self.detail and self.max_score then
    self:SetAnchorMaxXY(0, 1)
    self:SetAnchorMinXY(0, 1)
    self:SetPivotXY(0.5, 1)
    self:SetLocalPosition(self.posShow)
    self:ParseData()
  end
  self:SetAsLastSibling()
end

function ActivityOutpostBattlePopup:ParseData()
  if self.detail.allianceArr == nil then
    self.data_list:SetActive(false)
    return
  end
  local max_score = 0
  local allianceArr = self.detail.allianceArr
  local count = #allianceArr
  local left_score_percent = 100
  self.data_list:SetActive(true)
  for k, v in pairs(allianceArr) do
    if v and v.score then
      max_score = max_score + v.score
    end
  end
  table.sort(allianceArr, function(a, b)
    return a.score > b.score
  end)
  for index = 1, 5 do
    local node = self["row" .. index]
    if node ~= nil then
      local data = allianceArr[index]
      if data then
        if index == count and count < 5 then
          local txt = left_score_percent .. "%"
          node:ReInit(index, data, txt, max_score)
        else
          local percentage_string = string.percentage(data.score, max_score)
          local number_string = string.gsub(percentage_string, "%%", "")
          left_score_percent = left_score_percent - toInt(number_string)
          node:ReInit(index, data, percentage_string, max_score)
        end
      else
        node:SetActive(false)
      end
    end
  end
end

function PopupItem:OnCreate()
  base.OnCreate(self)
  self.bg = self:AddComponent(UIImage, "")
  self.name = self:AddComponent(UITextMeshProUGUIEx, "name")
  self.icon = self:AddComponent(UIImage, "icon")
  self.num = self:AddComponent(UITextMeshProUGUIEx, "num")
end

function PopupItem:OnDestroy()
  self.bg = nil
  self.name = nil
  self.icon = nil
  self.num = nil
  base.OnDestroy(self)
end

function PopupItem:ReInit(index, data, txt, max_score)
  if data == nil then
    self:SetActive(false)
  else
    local myAllianceId = LuaEntry.Player.allianceId
    self:SetActive(true)
    self.bg:SetEnable(index % 2 == 1)
    if myAllianceId == data.allianceId then
      self.name:SetText("<color=#0e9500>" .. UIUtil.FormatAllianceAndName(data.abbr, data.allianceName) .. "</color>")
    else
      self.name:SetText(UIUtil.FormatAllianceAndName(data.abbr, data.allianceName))
    end
    self.num:SetText(txt)
    self.icon:LoadSprite(string.format(AL_FLAG_SPRITE_PATH, tostring(data.icon)))
  end
end

return ActivityOutpostBattlePopup
