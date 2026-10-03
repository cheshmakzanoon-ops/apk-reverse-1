local base = UIBaseContainer
local UILWSeasonDonateFishItem = BaseClass("UILWSeasonDonateFishItem", base)
local rImg_imgIcon_path = "img_Icon"
local txt_count_path = "txt_count"
local go_select_path = "go_select"
local go_InfoInput_path = "InfoInput"
local txt_CountText_path = "InfoInput/TextBg/CountText"
local btn_fish_path = ""

function UILWSeasonDonateFishItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UILWSeasonDonateFishItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonDonateFishItem:ComponentDefine()
  self.rImg_imgIcon = self:AddComponent(UIRawImage, rImg_imgIcon_path)
  self.txt_count = self:AddComponent(UIText, txt_count_path)
  self.go_select = self:AddComponent(UIBaseContainer, go_select_path)
  self.go_InfoInput = self:AddComponent(UIBaseContainer, go_InfoInput_path)
  self.txt_CountText = self:AddComponent(UIText, txt_CountText_path)
  self.btn_fish = self:AddComponent(UILongPressTrigger, btn_fish_path)
  self.btn_AddBtn = self:AddComponent(UILongPressTrigger, "InfoInput/AddBtn")
  self.btn_DecBtn = self:AddComponent(UILongPressTrigger, "InfoInput/DecBtn")
  self.btn_AddBtn:SetCallback(function()
    return self:ClickAdd()
  end)
  self.btn_DecBtn:SetCallback(function()
    return self:ClickDec()
  end)
  self.btn_fish:SetCallback(function()
    return self:OnPointerClick()
  end)
  self.btn_fish:OnDrag(function()
    self.btn_fish.isClick = false
    self.btn_fish:BreakLongPress()
  end)
end

function UILWSeasonDonateFishItem:ComponentDestroy()
  self.rImg_imgIcon = nil
  self.txt_count = nil
  self.go_select = nil
  self.go_InfoInput = nil
  self.txt_CountText = nil
  self.btn_fish = nil
  self.btn_AddBtn = nil
  self.btn_DecBtn = nil
end

function UILWSeasonDonateFishItem:ReInit(data, logicDonate)
  self.data = data
  self.logicDonate = logicDonate
  local meta = DataCenter.FishMetaManager:GetMeta(self.data.id)
  if meta then
    self.rImg_imgIcon:LoadSpriteAsyncWithCallback(meta.pic, function()
      if self.rImg_imgIcon then
        self.rImg_imgIcon:SetNativeSize()
      end
    end)
  end
  local scale = meta.collect_proportion or 1
  self.rImg_imgIcon:SetLocalScaleXYZ(scale * 0.5, scale * 0.5, scale * 0.5)
  self.txt_count:SetText(self.data.num)
  self.go_select:SetActive(false)
  self:RefreshSelectCount()
end

function UILWSeasonDonateFishItem:OnPointerClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  local canAdd = self.holder.view.ctrl:GetCanAddToDonate()
  if not canAdd then
    if self.holder.view.canTip then
      UIUtil.ShowTipsId("season_s6_government_skill_desc55")
      self.holder.view.canTip = false
    end
    self.btn_fish:BreakLongPress()
    return true
  end
  local isSuccess = {result = true}
  self:ClickAdd(isSuccess)
  if not isSuccess.result then
    self.btn_fish:BreakLongPress()
  end
  return true
end

function UILWSeasonDonateFishItem:ClickAdd(isSuccess)
  if self.btn_AddBtn.isClick then
    DataCenter.LWSoundManager:PlaySound(6100021, false)
  end
  local progressInfo = self.logicDonate:GetProgressInfo()
  local curExp = progressInfo.curValue
  local maxExp = progressInfo.maxValue
  if curExp >= maxExp then
    UIUtil.ShowTipsId("season_camp_science_tips_23")
    if isSuccess then
      isSuccess.result = false
    end
    self.btn_AddBtn:BreakLongPress()
    return true
  end
  local selectList = self.holder.view.ctrl:GetSelectList()
  local curAddValue = 0
  for id, count in pairs(selectList) do
    local meta = DataCenter.FishMetaManager:GetMeta(id)
    curAddValue = curAddValue + meta.donation * count
  end
  local curSelectCount = self.holder.view.ctrl:GetSelectCount(self.data.id)
  if curSelectCount >= self.data.num then
    UIUtil.ShowTipsId("season_s6_government_skill_error_tips_08")
    self.btn_AddBtn:BreakLongPress()
    if isSuccess then
      isSuccess.result = false
    end
    return true
  end
  if maxExp < curExp + curAddValue then
    UIUtil.ShowTipsId("season_camp_science_tips_23")
    self.btn_AddBtn:BreakLongPress()
    if isSuccess then
      isSuccess.result = false
    end
    return true
  end
  self.holder.view:AddSelectCount(self.data.id, 1)
  self:RefreshSelectCount()
  self.holder.view.canTip = true
  return true
end

function UILWSeasonDonateFishItem:ClickDec()
  if self.btn_DecBtn.isClick then
    DataCenter.LWSoundManager:PlaySound(6100021, false)
  end
  self.holder.view:AddSelectCount(self.data.id, -1)
  self:RefreshSelectCount()
  local curSelectCount = self.holder.view.ctrl:GetSelectCount(self.data.id)
  if curSelectCount <= 0 then
    self.btn_DecBtn:BreakLongPress()
  end
  return true
end

function UILWSeasonDonateFishItem:RefreshSelectCount()
  local curSelectCount = self.holder.view.ctrl:GetSelectCount(self.data.id)
  self.txt_CountText:SetText(curSelectCount)
  if 0 < curSelectCount then
    self.txt_count:SetText(curSelectCount .. "/" .. self.data.num)
  else
    self.txt_count:SetText(self.data.num)
  end
  self.go_select:SetActive(0 < curSelectCount)
  self.go_InfoInput:SetActive(0 < curSelectCount)
end

return UILWSeasonDonateFishItem
