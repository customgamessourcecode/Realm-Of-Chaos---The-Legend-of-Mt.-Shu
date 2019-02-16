
if ModalDialog == nil then
	ModalDialog = RegisterController('modal_dialog')
	ModalDialog.__player_dialog_options = {}
	setmetatable(ModalDialog,ModalDialog)
end

local public = ModalDialog

--[[
通用对话框
ModalDialog(hero, {
	type = "CommonForLua",
	title = "dialog_title_warning",
	text = "shushan_do_you_want_to_go_to_jifengya",
	style = "warning",
	options = {
		{
			key = "YES",
			func = function ()
				print("YES")
			end,
		},
		{
			key = "NO",
			func = function ()
				print("NO")
			end,
		},
	},
})
]]

function public:__call(hero, data)
	local steamid = hero:GetSteamID()
	if steamid == "0" then return end
	if type(data.type) ~= "string" then return end

	if data.options then
		local options = data.options
		data.options = {}
		for k,v in ipairs(options) do
			table.insert(data.options,v.key)
		end

		self:SetPlayerDialogOptions(steamid, options)
	end

	CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "show_modal_dialog", data)
end

function public:SetPlayerDialogOptions(steamid, options)
	self.__player_dialog_options[steamid] = options
end

function public:GetPlayerDialogOptions(steamid)
	return self.__player_dialog_options[steamid]
end