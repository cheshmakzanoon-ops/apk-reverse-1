local UILWTeamLeaderSelectCoinView = BaseClass("UILWTeamLeaderSelectCoinView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local panel_path = "panel"
local close_btn_path = "PopUpTitle/CloseBtn"
local desc1_path = "PopUpTitle/Content/desc1"
local coin1_path = "PopUpTitle/Content/CoinList/Coin1"
local coin2_path = "PopUpTitle/Content/CoinList/Coin2"
local desc2_path = "PopUpTitle/Content/desc2"
local btn_select_path = "PopUpTitle/BtnSelect"

function UILWTeamLeaderSelectCoinView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:UpdateData()
  self.coin1:SetOnValueChanged(function(tf)
    if tf then
      self:OnSelectChanged(1)
    end
  end)
  self.coin2:SetOnValueChanged(function(tf)
    if tf then
      self:OnSelectChanged(2)
    end
  end)
  self.btn_select:SetOnClick(function()
    if self.coin1:GetIsOn() then
      SFSNetwork.SendMessage(MsgDefines.SetCampMasterServerValue, 1)
    else
      SFSNetwork.SendMessage(MsgDefines.SetCampMasterServerValue, 2)
    end
  end)
end

function UILWTeamLeaderSelectCoinView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWTeamLeaderSelectCoinView:ComponentDefine()
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(BindCallback(self, self.NoSelectAndClose))
  self.close_btn1 = self:AddComponent(UIButton, panel_path)
  self.close_btn1:SetOnClick(BindCallback(self, self.NoSelectAndClose))
  self.desc1 = self:AddComponent(UITextMeshProUGUIEx, desc1_path)
  self.coin1 = self:AddComponent(UIToggle, coin1_path)
  self.coin2 = self:AddComponent(UIToggle, coin2_path)
  self.desc2 = self:AddComponent(UITextMeshProUGUIEx, desc2_path)
  self.btn_select = self:AddComponent(UIButton, btn_select_path)
end

function UILWTeamLeaderSelectCoinView:ComponentDestroy()
  self.desc1 = nil
  self.coin1 = nil
  self.coin2 = nil
  self.desc2 = nil
  self.btn_select = nil
end

function UILWTeamLeaderSelectCoinView:NoSelectAndClose()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWTeamLeaderSelectCoin)
end

function UILWTeamLeaderSelectCoinView:OnSelectChanged(coin_index)
end

function UILWTeamLeaderSelectCoinView:UpdateData()
  local myServerId = LuaEntry.Player:GetSourceServerId()
  local seasonConfig = DataCenter.SeasonDataManager:GetServerCurrentSeasonConfig()
  local groupingActInfo = DataCenter.SeasonFactionWarDataManager:GetGroupingActInfo()
  if seasonConfig and seasonConfig.camp_sever then
    local king1, king2 = string.split_ii(seasonConfig.camp_sever, "|")
    self.kingServer1 = king1
    self.kingServer2 = king2
  end
  if groupingActInfo and groupingActInfo.serverList then
    for k, v in pairs(groupingActInfo.serverList) do
      if v and v.serverId == myServerId then
        self.data = v
      end
    end
    self.coin1:SetIsOn(self.data ~= nil and self.data.value == 1)
    self.coin2:SetIsOn(self.data ~= nil and self.data.value == 2)
  end
  self.desc1:SetLocalText("season_s3_activity_1000063_desc021")
  self.desc2:SetLocalText("season_s3_activity_1000063_desc08", self.kingServer1 or "???", self.kingServer2 or "???")
end

return UILWTeamLeaderSelectCoinView
