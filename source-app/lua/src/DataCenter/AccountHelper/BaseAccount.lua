local BaseAccount = BaseClass("BaseAccount")

function BaseAccount:__init()
  self.userId = ""
  self.userName = ""
end

function BaseAccount:__delete()
  self.userId = ""
  self.userName = ""
end

function BaseAccount:Login(data)
end

function BaseAccount:Bind()
end

function BaseAccount:Unbind()
end

function BaseAccount:Verify()
end

function BaseAccount:IsBound()
  return false
end

function BaseAccount:OnClick()
end

function BaseAccount:OnBtnHasBound()
end

function BaseAccount:ClearBindData()
  self.userId = ""
  self.userName = ""
end

return BaseAccount
