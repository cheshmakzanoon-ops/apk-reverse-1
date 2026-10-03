local UIMainChampionDuelSignTipBtn = BaseClass("UIMainChampionDuelSignTipBtn", UIButton)
local base = UIButton
local Localization = CS.GameEntry.Localization

function UIMainChampionDuelSignTipBtn:OnCreate()
  base.OnCreate(self)
  self:SetOnClick(function()
    local data = DataCenter.ActivityListDataManager:GetOneOpenActivityByType(EnumActivity.ChampionDuelMain.Type)
    if data == nil then
      return
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIChampionDuelMain, {
      anim = false,
      UIMainAnim = UIMainAnimType.AllHide
    }, data)
  end)
  self.time_text = self:AddComponent(UITextMeshProUGUIEx, "TimeText")
  self.time_text:SetActive(false)
end

function UIMainChampionDuelSignTipBtn:OnDestroy()
  self.endSec = nil
  base.OnDestroy(self)
end

function UIMainChampionDuelSignTipBtn:Refresh()
  local flag = DataCenter.ChampionDuelManager:GetSignRed()
  if flag == 0 then
    self.endSec = nil
    self:SetActive(false)
  else
    local _, endTime = DataCenter.ChampionDuelManager:GetStageTime(ChampionDuelState.SignIn)
    self.endSec = endTime
    self:SetActive(true)
    self:Update1000MS()
  end
end

function UIMainChampionDuelSignTipBtn:Update1000MS()
  if self.endSec == nil then
    return
  end
  local curSec = UITimeManager:GetInstance():GetServerSeconds()
  local remindTime = self.endSec - curSec
  if remindTime <= 0 then
    self.endSec = nil
    self:SetActive(false)
  end
end

return UIMainChampionDuelSignTipBtn
