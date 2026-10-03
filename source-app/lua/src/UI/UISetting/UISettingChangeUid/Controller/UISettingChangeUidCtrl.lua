local rapidjson = require("rapidjson")
local UISettingChangeUidCtrl = BaseClass("UISettingChangeUidCtrl", UIBaseCtrl)
local Setting = CS.GameEntry.Setting

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UISettingChangeUid)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

local function OnClick(self, temp)
  local gameUid = temp
  local url = "http://gsl-aps.metapoint.club/gameservice/getuidinfo.php?gameuid=" .. gameUid
  CS.GameKit.Base.WebRequestManager.Instance:Get(url, function(request, err, userdata)
    if err == true then
      UIUtil.ShowMessage("no id", 1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      end, function()
      end)
      return
    end
    local text = request.downloadHandler.text
    if text == nil or text == "" then
      return
    end
    local jsonData = rapidjson.decode(text)
    local ip = tostring(jsonData.ip)
    local port = tonumber(jsonData.port)
    local server = tostring(jsonData.server)
    local zone = "APS" .. server
    Logger.LogInfo("[AT]SetGUID_UISetChangeUidCtrl:" .. tostring(gameUid))
    DataCenter.LWSoundManager:StopAllSounds()
    CS.ApplicationLaunch.Instance:ReloadGame()
  end)
end

UISettingChangeUidCtrl.CloseSelf = CloseSelf
UISettingChangeUidCtrl.Close = Close
UISettingChangeUidCtrl.OnClick = OnClick
return UISettingChangeUidCtrl
